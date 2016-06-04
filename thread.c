#include "types.h"
#include "user.h"
#define PSIZE (4096)
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    lock->locked = 0;
}
void lock_acquire(lock_t *lock){
    while(xchg(&lock->locked,1) != 0);
}
void lock_release(lock_t *lock){
    xchg(&lock->locked,0);
}

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    int tid;
    void * stack = malloc(2 * 4096);
    void *garbage_stack = stack; 
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
        init_q(thQ2);
        inQ++;
    }

    if((uint)stack % 4096){
        stack = stack + (4096 - (uint)stack % 4096);
    }
    if (stack == 0){

        printf(1,"malloc fail \n");
        return 0;
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
        printf(1,"clone fails\n");
        return 0;
    }
    if(tid > 0){
        //store threads on thread table
        add_q(thQ2, tid);
        return garbage_stack;
    }
    if(tid == 0){
        printf(1,"tid = 0 return \n");
    }
//    wait();
//    free(garbage_stack);

    return 0;
}

// generate 0 -> max random number exclude max.
int random(int max){
    rands = rands * 1664525 + 1013904233;
    return (int)(rands % max);
}

////////////////////////////////////////////////////////
void thread_yield2(){
    static int popp = 0;
    

    int tid2 = getpid();
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    if (popp == 0) {
        tidNext = pop_q(thQ2);
        popp++;
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    tsleep();
    //printf(1,"thQ2 Size4 %d PID: %d \n", thQ2->size, getpid());
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}

void thread_yield_last(){
    int tidNext = pop_q(thQ2);
    twakeup(tidNext);
}