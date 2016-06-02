#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "queue.h"
//#include "user.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
            *d++ = *s++;

    return dst;
}


    void
pinit(void)
{
    initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
    initproc = p;
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
    uint sz;

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if(n < 0){
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    proc->sz = sz;
    switchuvm(proc);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
        return -1;

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    pid = np->pid;
    np->state = RUNNABLE;
    safestrcpy(np->name, proc->name, sizeof(proc->name));
    return pid;

}


//////////////////////////////////////////////////////////////////////
uint initedQ = 0;
void init_q2(struct queue2 *q){
    q->size = 0;
    q->head = 0;
    q->tail = 0;
}
void add_q2(struct queue2 *q, struct proc *v){
    //struct node2 * n = kalloc2();
    struct node2 * n = kalloc2();
    n->next = 0;
    n->value = v;
    if(q->head == 0){
        q->head = n;
    }else{
        q->tail->next = n;
    }
    q->tail = n;
    q->size++;
}
int empty_q2(struct queue2 *q){
    if(q->size == 0)
        return 1;
    else
        return 0;
} 
struct proc* pop_q2(struct queue2 *q){
    struct proc *val;
    struct node2 *destroy;
    if(!empty_q2(q)){
       val = q->head->value; 
       destroy = q->head;
       q->head = q->head->next;
       kfree2(destroy);
       q->size--;
       if(q->size == 0){
            q->head = 0;
            q->tail = 0;
       }
       return val;
    }
    return 0;
}
/////////////////////////////////////////////////////////////////////////


//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
        return -1;
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
        return -1;

    np->pgdir = proc->pgdir;
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;


//modify here >>>
//    uint argc;
//    char **argv;
//    argv = (char **)arg;
//    np->tf->ebp = sp;
//    cprintf("in clone argv addr = %d\n",argv);
//    for(argc = 0; argv[argc];argc++){
//        if(argc >= MAXARG){
//            cprintf("execeed max args\n");
//            return -1;
//        }
//        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
//        if(copyout(np->pgdir,sp,argv[argc],strlen(argv[argc]) + 1) < 0){
//            cprintf("copyout wrong \n");
//            return -1;
//        }
//        ustack[3+argc] = sp;
//    }
//    ustack[3+argc] = 0;
//    ustack[0] = 0xffffffff;
//    ustack[1] = argc;
//    ustack[2] = sp - (argc + 1)*4;
//    sp -= (3+argc+1)*4;
//
//    if(copyout(np->pgdir,sp,ustack,(3+argc+1)*4) < 0){
//        cprintf("copyout ustack wrong\n");
//        return -1;
//    }
//    uint cnt; 
//    cprintf("sp is %d\n",sp);
//
//    for (cnt=0;ustack[cnt];cnt++){
//        cprintf("ustack[%d] is %d\n",cnt,ustack[cnt]);
//    }
//
    /*
    if (!initedQ) {
        init_q2(thQ);
        initedQ++;
    }
    add_q2(thQ, np);
    */
//modify here <<<<<

    np->tf->ebp = sp;
    ustack[0] = 0xffffffff;
    ustack[1] = arg;
    sp -= 8;
    if(copyout(np->pgdir,sp,ustack,8)<0){
        cprintf("push arg fails\n");
        return -1;
    }

    np->tf->eip = routine;
    np->tf->esp = sp;
    np->cwd = idup(proc->cwd);

    switchuvm(np);

     acquire(&ptable.lock);
    np->state = RUNNABLE;
    // if (!initedQ) {
    //     init_q2(thQ);
    //     initedQ ++;
    // }
    // add_q2(thQ, np);
     release(&ptable.lock);
    safestrcpy(np->name, proc->name, sizeof(proc->name));


    return pid;

}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
    struct proc *p;
    int fd;

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
            if(p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
    sched();
    panic("zombie exit");
}
    void
texit(void)
{
    //  struct proc *p;
    int fd;

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
    proc->cwd = 0;

    acquire(&ptable.lock);
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    // Pass abandoned children to init.
    //  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //    if(p->parent == proc){
    //      p->parent = initproc;
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
    sched();
    panic("zombie exit");
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                if(p->isthread != 1){
                    freevm(p->pgdir);
                }
                p->state = UNUSED;
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
            switchuvm(p);
            p->state = RUNNING;
            swtch(&cpu->scheduler, proc->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);

    }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1){
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
        panic("sched locks");
    }
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
    cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
    void
yield(void)
{
    //cprintf("Yielded\n");
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
        initlog();
    }

    // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    if(proc == 0)
        panic("sleep");

    if(lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
    proc->state = SLEEPING;
    sched();

    // Tidy up.
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
}

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
    static char *states[] = {
        [UNUSED]    "unused",
        [EMBRYO]    "embryo",
        [SLEEPING]  "sleep ",
        [RUNNABLE]  "runble",
        [RUNNING]   "run   ",
        [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}

void tsleep(void){
    
    acquire(&ptable.lock); 
    sleep(proc, &ptable.lock);
    release(&ptable.lock);

}

///////////////////////////////////////////////////////////////////////////////
// struct node2{
//     struct proc *value;
//     struct node2 *next;
// };

// struct queue2{
//     int size;
//     struct node2 * head;
//     struct node2 * tail;
// };
// struct queue2 *thQ;


void lock_acquire2(struct spinlock *lock){
    while(xchg(&lock->locked,1) != 0);
}
void lock_release2(struct spinlock *lock){
    xchg(&lock->locked,0);
}
//////////////////////////////////

//////////////////////////////////
void thread_yield(void){
    cprintf("Curr %d%d%d\n", proc->isthread, proc->state, proc->pid);
    //acquire(&ptable.lock);
    struct proc *p;
    struct proc *old;
    //struct proc *curr;
    int pid = proc->pid;
    int intena;
    if (!initedQ) {
        init_q2(thQ);
        initedQ ++;
    }
    // static int acq = 0;
    // cprintf("ACQ: %d\n", acq);
    // if (acq == 0) {
    //     init_q2(thQ);
    //     //acquire(&ptable.lock); 
    //     //cprintf(" ACQUIRED\n");
    //     acq++;
    // }
    //else cprintf(" DID NOT ACQUIRE\n");
    
    if (!holding(&ptable.lock)) {
        //lock_acquire2(&ptable.lock);
        acquire(&ptable.lock); 
        cprintf(" ACQUIRED\n");
    }
    else cprintf(" DID NOT ACQUIRE\n");
    cprintf("QUEUE SIZE_1 %d\n", thQ->size);
    
    /*
    if(empty_q2(thQ)) {
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            cprintf(" %d%d%d", p->isthread, p->state, p->pid);
            if ((p->state == RUNNABLE) && (p->isthread == 1)) {
                add_q2(thQ, p);
                cprintf("\nPUSHED NEW\n");
                break;
            }
        }
    }
    */
    p = pop_q2(thQ);
    if ((p->pid) == (proc->pid)) {
        p = pop_q2(thQ);
    }
    cprintf("Before %d going to %d%d%d\n",pid, p->isthread, p->state, p->pid);
    cprintf("QUEUE SIZE_2 %d\n", thQ->size);
    proc->state = RUNNABLE;
    add_q2(thQ, proc);
    old = proc;
    proc = p;
    //switchuvm(p);
    p->state = RUNNING;
    intena = cpu->intena;
    swtch(&old->context, proc->context);
    cpu->intena = intena;
    //switchkvm();
    //proc = 0;
    //swtch(&old->context, p->context);
    //swtch(&old->context, cpu->scheduler);
    //swtch(&cpu->scheduler, proc->context);
    cprintf("After %d\n", pid);
    
    if (holding(&ptable.lock)) {
        //lock_release2(&ptable.lock);
        release(&ptable.lock); 
        cprintf("RELEASED\n");
    }
    else cprintf("DID NOT RELEASE\n");
    
    //release(&ptable.lock);
    
}

void thread_yield3(int tid) {
    /*
    acquire(&ptable.lock);
    struct proc *p;
    struct proc *old;
    cprintf("Finding TID: %d", tid);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        cprintf(" %d%d%d", p->isthread, p->state, p->pid);
        if ((p->state == RUNNABLE) && (p->isthread == 1) && (p->pid == tid)) {
            //add_q2(thQ, p);
            cprintf("\nFound\n");
            break;
        }
    }
    proc->state = RUNNABLE;
    old = proc;
    proc = p;
    //switchuvm(p);
    p->state = RUNNING;
    swtch(&old->context, proc->context);
    release(&ptable.lock);
    */
    yield();
}