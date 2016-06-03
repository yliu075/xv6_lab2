
_frisbee:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void pass_next(void *arg);
int lookup();



int main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 3c             	sub    $0x3c,%esp
  13:	89 cb                	mov    %ecx,%ebx

    int i;
    struct thread *t;
//    void * sp;

    if(argc != 3){
  15:	83 3b 03             	cmpl   $0x3,(%ebx)
  18:	74 19                	je     33 <main+0x33>
        printf(1,"argc is not match !\n");
  1a:	c7 44 24 04 c0 0e 00 	movl   $0xec0,0x4(%esp)
  21:	00 
  22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  29:	e8 ec 07 00 00       	call   81a <printf>
        exit();
  2e:	e8 37 06 00 00       	call   66a <exit>
    }
    numthreads = atoi(argv[1]);
  33:	8b 43 04             	mov    0x4(%ebx),%eax
  36:	83 c0 04             	add    $0x4,%eax
  39:	8b 00                	mov    (%eax),%eax
  3b:	89 04 24             	mov    %eax,(%esp)
  3e:	e8 95 05 00 00       	call   5d8 <atoi>
  43:	a3 00 14 00 00       	mov    %eax,0x1400
    numpass = atoi(argv[2]);
  48:	8b 43 04             	mov    0x4(%ebx),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 00                	mov    (%eax),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 80 05 00 00       	call   5d8 <atoi>
  58:	a3 04 14 00 00       	mov    %eax,0x1404

    void * slist[numthreads];
  5d:	a1 00 14 00 00       	mov    0x1400,%eax
  62:	8d 50 ff             	lea    -0x1(%eax),%edx
  65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  68:	c1 e0 02             	shl    $0x2,%eax
  6b:	8d 50 03             	lea    0x3(%eax),%edx
  6e:	b8 10 00 00 00       	mov    $0x10,%eax
  73:	83 e8 01             	sub    $0x1,%eax
  76:	01 d0                	add    %edx,%eax
  78:	be 10 00 00 00       	mov    $0x10,%esi
  7d:	ba 00 00 00 00       	mov    $0x0,%edx
  82:	f7 f6                	div    %esi
  84:	6b c0 10             	imul   $0x10,%eax,%eax
  87:	29 c4                	sub    %eax,%esp
  89:	8d 44 24 0c          	lea    0xc(%esp),%eax
  8d:	83 c0 03             	add    $0x3,%eax
  90:	c1 e8 02             	shr    $0x2,%eax
  93:	c1 e0 02             	shl    $0x2,%eax
  96:	89 45 d8             	mov    %eax,-0x28(%ebp)

    //init ttable;
    lock_init(&ttable.lock);
  99:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
  a0:	e8 5b 0b 00 00       	call   c00 <lock_init>
    ttable.total = 0;
  a5:	c7 05 24 16 00 00 00 	movl   $0x0,0x1624
  ac:	00 00 00 
    for(t=ttable.thread;t < &ttable.thread[64];t++){
  af:	c7 45 e0 24 14 00 00 	movl   $0x1424,-0x20(%ebp)
  b6:	eb 0d                	jmp    c5 <main+0xc5>
        t->tid = 0;
  b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    void * slist[numthreads];

    //init ttable;
    lock_init(&ttable.lock);
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
  c1:	83 45 e0 08          	addl   $0x8,-0x20(%ebp)
  c5:	81 7d e0 24 16 00 00 	cmpl   $0x1624,-0x20(%ebp)
  cc:	72 ea                	jb     b8 <main+0xb8>
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
  ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  d5:	eb 11                	jmp    e8 <main+0xe8>
        slist[i]=0;
  d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  dd:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
  e4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  e8:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
  ec:	7e e9                	jle    d7 <main+0xd7>
        slist[i]=0;
    }
    //init frisbee
    lock_init(&frisbee.lock);
  ee:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
  f5:	e8 06 0b 00 00       	call   c00 <lock_init>
    frisbee.pass = 0;
  fa:	c7 05 2c 16 00 00 00 	movl   $0x0,0x162c
 101:	00 00 00 
    frisbee.holding_thread = 0;
 104:	c7 05 30 16 00 00 00 	movl   $0x0,0x1630
 10b:	00 00 00 

    printf(1,"\nnum of threads %d \n",numthreads);
 10e:	a1 00 14 00 00       	mov    0x1400,%eax
 113:	89 44 24 08          	mov    %eax,0x8(%esp)
 117:	c7 44 24 04 d5 0e 00 	movl   $0xed5,0x4(%esp)
 11e:	00 
 11f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 126:	e8 ef 06 00 00       	call   81a <printf>
    printf(1,"num of passes %d \n\n",numpass);
 12b:	a1 04 14 00 00       	mov    0x1404,%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	c7 44 24 04 ea 0e 00 	movl   $0xeea,0x4(%esp)
 13b:	00 
 13c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 143:	e8 d2 06 00 00       	call   81a <printf>


    for(i=0; i<numthreads;i++){
 148:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 14f:	eb 43                	jmp    194 <main+0x194>
        void *stack = thread_create(pass_next,(void *)0);      
 151:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 158:	00 
 159:	c7 04 24 3d 02 00 00 	movl   $0x23d,(%esp)
 160:	e8 e4 0a 00 00       	call   c49 <thread_create>
 165:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(stack == 0)
 168:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 16c:	75 16                	jne    184 <main+0x184>
            printf(1,"thread_create fail\n");
 16e:	c7 44 24 04 fe 0e 00 	movl   $0xefe,0x4(%esp)
 175:	00 
 176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17d:	e8 98 06 00 00       	call   81a <printf>
 182:	eb 0c                	jmp    190 <main+0x190>
        else{
            slist[i] = stack;
 184:	8b 45 d8             	mov    -0x28(%ebp),%eax
 187:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 18a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 18d:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    printf(1,"\nnum of threads %d \n",numthreads);
    printf(1,"num of passes %d \n\n",numpass);


    for(i=0; i<numthreads;i++){
 190:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 194:	a1 00 14 00 00       	mov    0x1400,%eax
 199:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 19c:	7c b3                	jl     151 <main+0x151>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
 19e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1a5:	eb 10                	jmp    1b7 <main+0x1b7>
        if(wait() == -1)
 1a7:	e8 c6 04 00 00       	call   672 <wait>
 1ac:	83 f8 ff             	cmp    $0xffffffff,%eax
 1af:	75 02                	jne    1b3 <main+0x1b3>
            break;
 1b1:	eb 0e                	jmp    1c1 <main+0x1c1>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
 1b3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1b7:	a1 00 14 00 00       	mov    0x1400,%eax
 1bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 1bf:	7c e6                	jl     1a7 <main+0x1a7>
        if(wait() == -1)
            break;
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 1c1:	c7 45 e0 24 14 00 00 	movl   $0x1424,-0x20(%ebp)
 1c8:	eb 2a                	jmp    1f4 <main+0x1f4>
        if(t->tid != 0)
 1ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1cd:	8b 00                	mov    (%eax),%eax
 1cf:	85 c0                	test   %eax,%eax
 1d1:	74 1d                	je     1f0 <main+0x1f0>
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
 1d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1d6:	8b 00                	mov    (%eax),%eax
 1d8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dc:	c7 44 24 04 14 0f 00 	movl   $0xf14,0x4(%esp)
 1e3:	00 
 1e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1eb:	e8 2a 06 00 00       	call   81a <printf>
    for(i=0;i<numthreads;i++){
        if(wait() == -1)
            break;
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 1f0:	83 45 e0 08          	addl   $0x8,-0x20(%ebp)
 1f4:	81 7d e0 24 16 00 00 	cmpl   $0x1624,-0x20(%ebp)
 1fb:	72 cd                	jb     1ca <main+0x1ca>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
 1fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 204:	eb 28                	jmp    22e <main+0x22e>
        if(slist[i] != 0){
 206:	8b 45 d8             	mov    -0x28(%ebp),%eax
 209:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 20c:	8b 04 90             	mov    (%eax,%edx,4),%eax
 20f:	85 c0                	test   %eax,%eax
 211:	74 17                	je     22a <main+0x22a>
            void * f = slist[i];
 213:	8b 45 d8             	mov    -0x28(%ebp),%eax
 216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 219:	8b 04 90             	mov    (%eax,%edx,4),%eax
 21c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            free(f);
 21f:	8b 45 d0             	mov    -0x30(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 a3 07 00 00       	call   9cd <free>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
 22a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 22e:	a1 00 14 00 00       	mov    0x1400,%eax
 233:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 236:	7c ce                	jl     206 <main+0x206>
        if(slist[i] != 0){
            void * f = slist[i];
            free(f);
        }
    }
    exit();
 238:	e8 2d 04 00 00       	call   66a <exit>

0000023d <pass_next>:
}

void pass_next(void *arg){
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 28             	sub    $0x28,%esp
    struct thread *t;
    int tid;

    tid = getpid();
 243:	e8 a2 04 00 00       	call   6ea <getpid>
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)

    lock_acquire(&ttable.lock);
 24b:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
 252:	e8 b7 09 00 00       	call   c0e <lock_acquire>
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 257:	c7 45 f4 24 14 00 00 	movl   $0x1424,-0xc(%ebp)
 25e:	eb 17                	jmp    277 <pass_next+0x3a>
        if(t->tid == 0){
 260:	8b 45 f4             	mov    -0xc(%ebp),%eax
 263:	8b 00                	mov    (%eax),%eax
 265:	85 c0                	test   %eax,%eax
 267:	75 0a                	jne    273 <pass_next+0x36>
            t->tid = tid;
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 26f:	89 10                	mov    %edx,(%eax)
            break;
 271:	eb 0d                	jmp    280 <pass_next+0x43>
    int tid;

    tid = getpid();

    lock_acquire(&ttable.lock);
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 273:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
 277:	81 7d f4 24 16 00 00 	cmpl   $0x1624,-0xc(%ebp)
 27e:	72 e0                	jb     260 <pass_next+0x23>
        if(t->tid == 0){
            t->tid = tid;
            break;
        } 
    }
    ttable.total++;
 280:	a1 24 16 00 00       	mov    0x1624,%eax
 285:	83 c0 01             	add    $0x1,%eax
 288:	a3 24 16 00 00       	mov    %eax,0x1624
    lock_release(&ttable.lock);
 28d:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
 294:	e8 95 09 00 00       	call   c2e <lock_release>

   for(;;){
        lock_acquire(&ttable.lock);
 299:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
 2a0:	e8 69 09 00 00       	call   c0e <lock_acquire>
        if(ttable.total == numthreads){
 2a5:	8b 15 24 16 00 00    	mov    0x1624,%edx
 2ab:	a1 00 14 00 00       	mov    0x1400,%eax
 2b0:	39 c2                	cmp    %eax,%edx
 2b2:	75 39                	jne    2ed <pass_next+0xb0>
            printf(1," tid %d ready to go\n",t->tid);
 2b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b7:	8b 00                	mov    (%eax),%eax
 2b9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bd:	c7 44 24 04 3c 0f 00 	movl   $0xf3c,0x4(%esp)
 2c4:	00 
 2c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2cc:	e8 49 05 00 00       	call   81a <printf>
            barrier++;
 2d1:	a1 08 14 00 00       	mov    0x1408,%eax
 2d6:	83 c0 01             	add    $0x1,%eax
 2d9:	a3 08 14 00 00       	mov    %eax,0x1408
            goto start;
 2de:	90                   	nop
        lock_release(&ttable.lock);
    }
    
//barriar above
start:
     lock_release(&ttable.lock);
 2df:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
 2e6:	e8 43 09 00 00       	call   c2e <lock_release>
     while(barrier != numthreads);
 2eb:	eb 0e                	jmp    2fb <pass_next+0xbe>
        if(ttable.total == numthreads){
            printf(1," tid %d ready to go\n",t->tid);
            barrier++;
            goto start;
        }
        lock_release(&ttable.lock);
 2ed:	c7 04 24 20 14 00 00 	movl   $0x1420,(%esp)
 2f4:	e8 35 09 00 00       	call   c2e <lock_release>
    }
 2f9:	eb 9e                	jmp    299 <pass_next+0x5c>
    
//barriar above
start:
     lock_release(&ttable.lock);
     while(barrier != numthreads);
 2fb:	8b 15 08 14 00 00    	mov    0x1408,%edx
 301:	a1 00 14 00 00       	mov    0x1400,%eax
 306:	39 c2                	cmp    %eax,%edx
 308:	75 f1                	jne    2fb <pass_next+0xbe>
    //throw frisbee
    do{
        lock_acquire(&frisbee.lock);
 30a:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
 311:	e8 f8 08 00 00       	call   c0e <lock_acquire>
        if(frisbee.pass > numpass){
 316:	8b 15 2c 16 00 00    	mov    0x162c,%edx
 31c:	a1 04 14 00 00       	mov    0x1404,%eax
 321:	39 c2                	cmp    %eax,%edx
 323:	7e 39                	jle    35e <pass_next+0x121>
            lock_release(&frisbee.lock);
 325:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
 32c:	e8 fd 08 00 00       	call   c2e <lock_release>
            goto leaving;
 331:	90                   	nop
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);

leaving: 
    lock_release(&frisbee.lock);
 332:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
 339:	e8 f0 08 00 00       	call   c2e <lock_release>
    printf(1,"thread %d out of game\n",tid);
 33e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 341:	89 44 24 08          	mov    %eax,0x8(%esp)
 345:	c7 44 24 04 88 0f 00 	movl   $0xf88,0x4(%esp)
 34c:	00 
 34d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 354:	e8 c1 04 00 00       	call   81a <printf>
    texit();
 359:	e8 b4 03 00 00       	call   712 <texit>
        lock_acquire(&frisbee.lock);
        if(frisbee.pass > numpass){
            lock_release(&frisbee.lock);
            goto leaving;
        }
        if(frisbee.holding_thread == tid){
 35e:	a1 30 16 00 00       	mov    0x1630,%eax
 363:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 366:	75 1b                	jne    383 <pass_next+0x146>
            lock_release(&frisbee.lock);
 368:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
 36f:	e8 ba 08 00 00       	call   c2e <lock_release>
            sleep(5);
 374:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 37b:	e8 7a 03 00 00       	call   6fa <sleep>
            continue;
 380:	90                   	nop
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
                frisbee.pass, tid);
        frisbee.pass++;
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);
 381:	eb 87                	jmp    30a <pass_next+0xcd>
        if(frisbee.holding_thread == tid){
            lock_release(&frisbee.lock);
            sleep(5);
            continue;
        }
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
 383:	a1 2c 16 00 00       	mov    0x162c,%eax
 388:	8b 55 f0             	mov    -0x10(%ebp),%edx
 38b:	89 54 24 0c          	mov    %edx,0xc(%esp)
 38f:	89 44 24 08          	mov    %eax,0x8(%esp)
 393:	c7 44 24 04 54 0f 00 	movl   $0xf54,0x4(%esp)
 39a:	00 
 39b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3a2:	e8 73 04 00 00       	call   81a <printf>
                frisbee.pass, tid);
        frisbee.pass++;
 3a7:	a1 2c 16 00 00       	mov    0x162c,%eax
 3ac:	83 c0 01             	add    $0x1,%eax
 3af:	a3 2c 16 00 00       	mov    %eax,0x162c
        frisbee.holding_thread = tid;
 3b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3b7:	a3 30 16 00 00       	mov    %eax,0x1630
        lock_release(&frisbee.lock);
 3bc:	c7 04 24 28 16 00 00 	movl   $0x1628,(%esp)
 3c3:	e8 66 08 00 00       	call   c2e <lock_release>
    }while(1);
 3c8:	e9 3d ff ff ff       	jmp    30a <pass_next+0xcd>

000003cd <lookup>:
    lock_release(&frisbee.lock);
    printf(1,"thread %d out of game\n",tid);
    texit();
}

int lookup(int num_threads){
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	83 ec 10             	sub    $0x10,%esp
    int i;
    struct thread *t;
    i = 0;
 3d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(t=ttable.thread;t<&ttable.thread[64];t++){
 3da:	c7 45 f8 24 14 00 00 	movl   $0x1424,-0x8(%ebp)
 3e1:	eb 11                	jmp    3f4 <lookup+0x27>
        if(t->tid != 0){
 3e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e6:	8b 00                	mov    (%eax),%eax
 3e8:	85 c0                	test   %eax,%eax
 3ea:	74 04                	je     3f0 <lookup+0x23>
            i++;
 3ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

int lookup(int num_threads){
    int i;
    struct thread *t;
    i = 0;
    for(t=ttable.thread;t<&ttable.thread[64];t++){
 3f0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
 3f4:	81 7d f8 24 16 00 00 	cmpl   $0x1624,-0x8(%ebp)
 3fb:	72 e6                	jb     3e3 <lookup+0x16>
        if(t->tid != 0){
            i++;
        }
    }
    return i;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	57                   	push   %edi
 406:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 407:	8b 4d 08             	mov    0x8(%ebp),%ecx
 40a:	8b 55 10             	mov    0x10(%ebp),%edx
 40d:	8b 45 0c             	mov    0xc(%ebp),%eax
 410:	89 cb                	mov    %ecx,%ebx
 412:	89 df                	mov    %ebx,%edi
 414:	89 d1                	mov    %edx,%ecx
 416:	fc                   	cld    
 417:	f3 aa                	rep stos %al,%es:(%edi)
 419:	89 ca                	mov    %ecx,%edx
 41b:	89 fb                	mov    %edi,%ebx
 41d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 420:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 423:	5b                   	pop    %ebx
 424:	5f                   	pop    %edi
 425:	5d                   	pop    %ebp
 426:	c3                   	ret    

00000427 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp
 42a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 433:	90                   	nop
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	8d 50 01             	lea    0x1(%eax),%edx
 43a:	89 55 08             	mov    %edx,0x8(%ebp)
 43d:	8b 55 0c             	mov    0xc(%ebp),%edx
 440:	8d 4a 01             	lea    0x1(%edx),%ecx
 443:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 446:	0f b6 12             	movzbl (%edx),%edx
 449:	88 10                	mov    %dl,(%eax)
 44b:	0f b6 00             	movzbl (%eax),%eax
 44e:	84 c0                	test   %al,%al
 450:	75 e2                	jne    434 <strcpy+0xd>
    ;
  return os;
 452:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 45a:	eb 08                	jmp    464 <strcmp+0xd>
    p++, q++;
 45c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 460:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	84 c0                	test   %al,%al
 46c:	74 10                	je     47e <strcmp+0x27>
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	0f b6 10             	movzbl (%eax),%edx
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	38 c2                	cmp    %al,%dl
 47c:	74 de                	je     45c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f b6 d0             	movzbl %al,%edx
 487:	8b 45 0c             	mov    0xc(%ebp),%eax
 48a:	0f b6 00             	movzbl (%eax),%eax
 48d:	0f b6 c0             	movzbl %al,%eax
 490:	29 c2                	sub    %eax,%edx
 492:	89 d0                	mov    %edx,%eax
}
 494:	5d                   	pop    %ebp
 495:	c3                   	ret    

00000496 <strlen>:

uint
strlen(char *s)
{
 496:	55                   	push   %ebp
 497:	89 e5                	mov    %esp,%ebp
 499:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 49c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4a3:	eb 04                	jmp    4a9 <strlen+0x13>
 4a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	0f b6 00             	movzbl (%eax),%eax
 4b4:	84 c0                	test   %al,%al
 4b6:	75 ed                	jne    4a5 <strlen+0xf>
    ;
  return n;
 4b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4bb:	c9                   	leave  
 4bc:	c3                   	ret    

000004bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 4bd:	55                   	push   %ebp
 4be:	89 e5                	mov    %esp,%ebp
 4c0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 4c3:	8b 45 10             	mov    0x10(%ebp),%eax
 4c6:	89 44 24 08          	mov    %eax,0x8(%esp)
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	89 04 24             	mov    %eax,(%esp)
 4d7:	e8 26 ff ff ff       	call   402 <stosb>
  return dst;
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4df:	c9                   	leave  
 4e0:	c3                   	ret    

000004e1 <strchr>:

char*
strchr(const char *s, char c)
{
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	83 ec 04             	sub    $0x4,%esp
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4ed:	eb 14                	jmp    503 <strchr+0x22>
    if(*s == c)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4f8:	75 05                	jne    4ff <strchr+0x1e>
      return (char*)s;
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	eb 13                	jmp    512 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	84 c0                	test   %al,%al
 50b:	75 e2                	jne    4ef <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 50d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 512:	c9                   	leave  
 513:	c3                   	ret    

00000514 <gets>:

char*
gets(char *buf, int max)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 51a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 521:	eb 4c                	jmp    56f <gets+0x5b>
    cc = read(0, &c, 1);
 523:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52a:	00 
 52b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 52e:	89 44 24 04          	mov    %eax,0x4(%esp)
 532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 539:	e8 44 01 00 00       	call   682 <read>
 53e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 545:	7f 02                	jg     549 <gets+0x35>
      break;
 547:	eb 31                	jmp    57a <gets+0x66>
    buf[i++] = c;
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	8d 50 01             	lea    0x1(%eax),%edx
 54f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 552:	89 c2                	mov    %eax,%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	01 c2                	add    %eax,%edx
 559:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 55d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 55f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 563:	3c 0a                	cmp    $0xa,%al
 565:	74 13                	je     57a <gets+0x66>
 567:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 56b:	3c 0d                	cmp    $0xd,%al
 56d:	74 0b                	je     57a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	83 c0 01             	add    $0x1,%eax
 575:	3b 45 0c             	cmp    0xc(%ebp),%eax
 578:	7c a9                	jl     523 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 57a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	01 d0                	add    %edx,%eax
 582:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 585:	8b 45 08             	mov    0x8(%ebp),%eax
}
 588:	c9                   	leave  
 589:	c3                   	ret    

0000058a <stat>:

int
stat(char *n, struct stat *st)
{
 58a:	55                   	push   %ebp
 58b:	89 e5                	mov    %esp,%ebp
 58d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 590:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 597:	00 
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 07 01 00 00       	call   6aa <open>
 5a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5aa:	79 07                	jns    5b3 <stat+0x29>
    return -1;
 5ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5b1:	eb 23                	jmp    5d6 <stat+0x4c>
  r = fstat(fd, st);
 5b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 fd 00 00 00       	call   6c2 <fstat>
 5c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 bf 00 00 00       	call   692 <close>
  return r;
 5d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 5d6:	c9                   	leave  
 5d7:	c3                   	ret    

000005d8 <atoi>:

int
atoi(const char *s)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 5de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5e5:	eb 25                	jmp    60c <atoi+0x34>
    n = n*10 + *s++ - '0';
 5e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5ea:	89 d0                	mov    %edx,%eax
 5ec:	c1 e0 02             	shl    $0x2,%eax
 5ef:	01 d0                	add    %edx,%eax
 5f1:	01 c0                	add    %eax,%eax
 5f3:	89 c1                	mov    %eax,%ecx
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	8d 50 01             	lea    0x1(%eax),%edx
 5fb:	89 55 08             	mov    %edx,0x8(%ebp)
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	01 c8                	add    %ecx,%eax
 606:	83 e8 30             	sub    $0x30,%eax
 609:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	0f b6 00             	movzbl (%eax),%eax
 612:	3c 2f                	cmp    $0x2f,%al
 614:	7e 0a                	jle    620 <atoi+0x48>
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	3c 39                	cmp    $0x39,%al
 61e:	7e c7                	jle    5e7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 623:	c9                   	leave  
 624:	c3                   	ret    

00000625 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 631:	8b 45 0c             	mov    0xc(%ebp),%eax
 634:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 637:	eb 17                	jmp    650 <memmove+0x2b>
    *dst++ = *src++;
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8d 50 01             	lea    0x1(%eax),%edx
 63f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 642:	8b 55 f8             	mov    -0x8(%ebp),%edx
 645:	8d 4a 01             	lea    0x1(%edx),%ecx
 648:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 64b:	0f b6 12             	movzbl (%edx),%edx
 64e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 650:	8b 45 10             	mov    0x10(%ebp),%eax
 653:	8d 50 ff             	lea    -0x1(%eax),%edx
 656:	89 55 10             	mov    %edx,0x10(%ebp)
 659:	85 c0                	test   %eax,%eax
 65b:	7f dc                	jg     639 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 660:	c9                   	leave  
 661:	c3                   	ret    

00000662 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 662:	b8 01 00 00 00       	mov    $0x1,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <exit>:
SYSCALL(exit)
 66a:	b8 02 00 00 00       	mov    $0x2,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <wait>:
SYSCALL(wait)
 672:	b8 03 00 00 00       	mov    $0x3,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <pipe>:
SYSCALL(pipe)
 67a:	b8 04 00 00 00       	mov    $0x4,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <read>:
SYSCALL(read)
 682:	b8 05 00 00 00       	mov    $0x5,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <write>:
SYSCALL(write)
 68a:	b8 10 00 00 00       	mov    $0x10,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <close>:
SYSCALL(close)
 692:	b8 15 00 00 00       	mov    $0x15,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <kill>:
SYSCALL(kill)
 69a:	b8 06 00 00 00       	mov    $0x6,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <exec>:
SYSCALL(exec)
 6a2:	b8 07 00 00 00       	mov    $0x7,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <open>:
SYSCALL(open)
 6aa:	b8 0f 00 00 00       	mov    $0xf,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <mknod>:
SYSCALL(mknod)
 6b2:	b8 11 00 00 00       	mov    $0x11,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <unlink>:
SYSCALL(unlink)
 6ba:	b8 12 00 00 00       	mov    $0x12,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <fstat>:
SYSCALL(fstat)
 6c2:	b8 08 00 00 00       	mov    $0x8,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <link>:
SYSCALL(link)
 6ca:	b8 13 00 00 00       	mov    $0x13,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <mkdir>:
SYSCALL(mkdir)
 6d2:	b8 14 00 00 00       	mov    $0x14,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <chdir>:
SYSCALL(chdir)
 6da:	b8 09 00 00 00       	mov    $0x9,%eax
 6df:	cd 40                	int    $0x40
 6e1:	c3                   	ret    

000006e2 <dup>:
SYSCALL(dup)
 6e2:	b8 0a 00 00 00       	mov    $0xa,%eax
 6e7:	cd 40                	int    $0x40
 6e9:	c3                   	ret    

000006ea <getpid>:
SYSCALL(getpid)
 6ea:	b8 0b 00 00 00       	mov    $0xb,%eax
 6ef:	cd 40                	int    $0x40
 6f1:	c3                   	ret    

000006f2 <sbrk>:
SYSCALL(sbrk)
 6f2:	b8 0c 00 00 00       	mov    $0xc,%eax
 6f7:	cd 40                	int    $0x40
 6f9:	c3                   	ret    

000006fa <sleep>:
SYSCALL(sleep)
 6fa:	b8 0d 00 00 00       	mov    $0xd,%eax
 6ff:	cd 40                	int    $0x40
 701:	c3                   	ret    

00000702 <uptime>:
SYSCALL(uptime)
 702:	b8 0e 00 00 00       	mov    $0xe,%eax
 707:	cd 40                	int    $0x40
 709:	c3                   	ret    

0000070a <clone>:
SYSCALL(clone)
 70a:	b8 16 00 00 00       	mov    $0x16,%eax
 70f:	cd 40                	int    $0x40
 711:	c3                   	ret    

00000712 <texit>:
SYSCALL(texit)
 712:	b8 17 00 00 00       	mov    $0x17,%eax
 717:	cd 40                	int    $0x40
 719:	c3                   	ret    

0000071a <tsleep>:
SYSCALL(tsleep)
 71a:	b8 18 00 00 00       	mov    $0x18,%eax
 71f:	cd 40                	int    $0x40
 721:	c3                   	ret    

00000722 <twakeup>:
SYSCALL(twakeup)
 722:	b8 19 00 00 00       	mov    $0x19,%eax
 727:	cd 40                	int    $0x40
 729:	c3                   	ret    

0000072a <thread_yield>:
SYSCALL(thread_yield)
 72a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 72f:	cd 40                	int    $0x40
 731:	c3                   	ret    

00000732 <thread_yield3>:
 732:	b8 1a 00 00 00       	mov    $0x1a,%eax
 737:	cd 40                	int    $0x40
 739:	c3                   	ret    

0000073a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 18             	sub    $0x18,%esp
 740:	8b 45 0c             	mov    0xc(%ebp),%eax
 743:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 746:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 74d:	00 
 74e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 751:	89 44 24 04          	mov    %eax,0x4(%esp)
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	89 04 24             	mov    %eax,(%esp)
 75b:	e8 2a ff ff ff       	call   68a <write>
}
 760:	c9                   	leave  
 761:	c3                   	ret    

00000762 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 762:	55                   	push   %ebp
 763:	89 e5                	mov    %esp,%ebp
 765:	56                   	push   %esi
 766:	53                   	push   %ebx
 767:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 76a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 771:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 775:	74 17                	je     78e <printint+0x2c>
 777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 77b:	79 11                	jns    78e <printint+0x2c>
    neg = 1;
 77d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 784:	8b 45 0c             	mov    0xc(%ebp),%eax
 787:	f7 d8                	neg    %eax
 789:	89 45 ec             	mov    %eax,-0x14(%ebp)
 78c:	eb 06                	jmp    794 <printint+0x32>
  } else {
    x = xx;
 78e:	8b 45 0c             	mov    0xc(%ebp),%eax
 791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 79b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 79e:	8d 41 01             	lea    0x1(%ecx),%eax
 7a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7aa:	ba 00 00 00 00       	mov    $0x0,%edx
 7af:	f7 f3                	div    %ebx
 7b1:	89 d0                	mov    %edx,%eax
 7b3:	0f b6 80 d0 13 00 00 	movzbl 0x13d0(%eax),%eax
 7ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7be:	8b 75 10             	mov    0x10(%ebp),%esi
 7c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c4:	ba 00 00 00 00       	mov    $0x0,%edx
 7c9:	f7 f6                	div    %esi
 7cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d2:	75 c7                	jne    79b <printint+0x39>
  if(neg)
 7d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d8:	74 10                	je     7ea <printint+0x88>
    buf[i++] = '-';
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8d 50 01             	lea    0x1(%eax),%edx
 7e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7e8:	eb 1f                	jmp    809 <printint+0xa7>
 7ea:	eb 1d                	jmp    809 <printint+0xa7>
    putc(fd, buf[i]);
 7ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	01 d0                	add    %edx,%eax
 7f4:	0f b6 00             	movzbl (%eax),%eax
 7f7:	0f be c0             	movsbl %al,%eax
 7fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 31 ff ff ff       	call   73a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 809:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 80d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 811:	79 d9                	jns    7ec <printint+0x8a>
    putc(fd, buf[i]);
}
 813:	83 c4 30             	add    $0x30,%esp
 816:	5b                   	pop    %ebx
 817:	5e                   	pop    %esi
 818:	5d                   	pop    %ebp
 819:	c3                   	ret    

0000081a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 81a:	55                   	push   %ebp
 81b:	89 e5                	mov    %esp,%ebp
 81d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 820:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 827:	8d 45 0c             	lea    0xc(%ebp),%eax
 82a:	83 c0 04             	add    $0x4,%eax
 82d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 830:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 837:	e9 7c 01 00 00       	jmp    9b8 <printf+0x19e>
    c = fmt[i] & 0xff;
 83c:	8b 55 0c             	mov    0xc(%ebp),%edx
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	01 d0                	add    %edx,%eax
 844:	0f b6 00             	movzbl (%eax),%eax
 847:	0f be c0             	movsbl %al,%eax
 84a:	25 ff 00 00 00       	and    $0xff,%eax
 84f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 852:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 856:	75 2c                	jne    884 <printf+0x6a>
      if(c == '%'){
 858:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 85c:	75 0c                	jne    86a <printf+0x50>
        state = '%';
 85e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 865:	e9 4a 01 00 00       	jmp    9b4 <printf+0x19a>
      } else {
        putc(fd, c);
 86a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86d:	0f be c0             	movsbl %al,%eax
 870:	89 44 24 04          	mov    %eax,0x4(%esp)
 874:	8b 45 08             	mov    0x8(%ebp),%eax
 877:	89 04 24             	mov    %eax,(%esp)
 87a:	e8 bb fe ff ff       	call   73a <putc>
 87f:	e9 30 01 00 00       	jmp    9b4 <printf+0x19a>
      }
    } else if(state == '%'){
 884:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 888:	0f 85 26 01 00 00    	jne    9b4 <printf+0x19a>
      if(c == 'd'){
 88e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 892:	75 2d                	jne    8c1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 894:	8b 45 e8             	mov    -0x18(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8a0:	00 
 8a1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8a8:	00 
 8a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	89 04 24             	mov    %eax,(%esp)
 8b3:	e8 aa fe ff ff       	call   762 <printint>
        ap++;
 8b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8bc:	e9 ec 00 00 00       	jmp    9ad <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 8c1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8c5:	74 06                	je     8cd <printf+0xb3>
 8c7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8cb:	75 2d                	jne    8fa <printf+0xe0>
        printint(fd, *ap, 16, 0);
 8cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8d9:	00 
 8da:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8e1:	00 
 8e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e6:	8b 45 08             	mov    0x8(%ebp),%eax
 8e9:	89 04 24             	mov    %eax,(%esp)
 8ec:	e8 71 fe ff ff       	call   762 <printint>
        ap++;
 8f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f5:	e9 b3 00 00 00       	jmp    9ad <printf+0x193>
      } else if(c == 's'){
 8fa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8fe:	75 45                	jne    945 <printf+0x12b>
        s = (char*)*ap;
 900:	8b 45 e8             	mov    -0x18(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 908:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 90c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 910:	75 09                	jne    91b <printf+0x101>
          s = "(null)";
 912:	c7 45 f4 9f 0f 00 00 	movl   $0xf9f,-0xc(%ebp)
        while(*s != 0){
 919:	eb 1e                	jmp    939 <printf+0x11f>
 91b:	eb 1c                	jmp    939 <printf+0x11f>
          putc(fd, *s);
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	0f b6 00             	movzbl (%eax),%eax
 923:	0f be c0             	movsbl %al,%eax
 926:	89 44 24 04          	mov    %eax,0x4(%esp)
 92a:	8b 45 08             	mov    0x8(%ebp),%eax
 92d:	89 04 24             	mov    %eax,(%esp)
 930:	e8 05 fe ff ff       	call   73a <putc>
          s++;
 935:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	0f b6 00             	movzbl (%eax),%eax
 93f:	84 c0                	test   %al,%al
 941:	75 da                	jne    91d <printf+0x103>
 943:	eb 68                	jmp    9ad <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 945:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 949:	75 1d                	jne    968 <printf+0x14e>
        putc(fd, *ap);
 94b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	0f be c0             	movsbl %al,%eax
 953:	89 44 24 04          	mov    %eax,0x4(%esp)
 957:	8b 45 08             	mov    0x8(%ebp),%eax
 95a:	89 04 24             	mov    %eax,(%esp)
 95d:	e8 d8 fd ff ff       	call   73a <putc>
        ap++;
 962:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 966:	eb 45                	jmp    9ad <printf+0x193>
      } else if(c == '%'){
 968:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 96c:	75 17                	jne    985 <printf+0x16b>
        putc(fd, c);
 96e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 971:	0f be c0             	movsbl %al,%eax
 974:	89 44 24 04          	mov    %eax,0x4(%esp)
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	89 04 24             	mov    %eax,(%esp)
 97e:	e8 b7 fd ff ff       	call   73a <putc>
 983:	eb 28                	jmp    9ad <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 985:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 98c:	00 
 98d:	8b 45 08             	mov    0x8(%ebp),%eax
 990:	89 04 24             	mov    %eax,(%esp)
 993:	e8 a2 fd ff ff       	call   73a <putc>
        putc(fd, c);
 998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 99b:	0f be c0             	movsbl %al,%eax
 99e:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a2:	8b 45 08             	mov    0x8(%ebp),%eax
 9a5:	89 04 24             	mov    %eax,(%esp)
 9a8:	e8 8d fd ff ff       	call   73a <putc>
      }
      state = 0;
 9ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9b8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9be:	01 d0                	add    %edx,%eax
 9c0:	0f b6 00             	movzbl (%eax),%eax
 9c3:	84 c0                	test   %al,%al
 9c5:	0f 85 71 fe ff ff    	jne    83c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9cb:	c9                   	leave  
 9cc:	c3                   	ret    

000009cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9cd:	55                   	push   %ebp
 9ce:	89 e5                	mov    %esp,%ebp
 9d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d3:	8b 45 08             	mov    0x8(%ebp),%eax
 9d6:	83 e8 08             	sub    $0x8,%eax
 9d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9dc:	a1 14 14 00 00       	mov    0x1414,%eax
 9e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9e4:	eb 24                	jmp    a0a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e9:	8b 00                	mov    (%eax),%eax
 9eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ee:	77 12                	ja     a02 <free+0x35>
 9f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9f6:	77 24                	ja     a1c <free+0x4f>
 9f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fb:	8b 00                	mov    (%eax),%eax
 9fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a00:	77 1a                	ja     a1c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a05:	8b 00                	mov    (%eax),%eax
 a07:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a10:	76 d4                	jbe    9e6 <free+0x19>
 a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a15:	8b 00                	mov    (%eax),%eax
 a17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a1a:	76 ca                	jbe    9e6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1f:	8b 40 04             	mov    0x4(%eax),%eax
 a22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2c:	01 c2                	add    %eax,%edx
 a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a31:	8b 00                	mov    (%eax),%eax
 a33:	39 c2                	cmp    %eax,%edx
 a35:	75 24                	jne    a5b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3a:	8b 50 04             	mov    0x4(%eax),%edx
 a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a40:	8b 00                	mov    (%eax),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	01 c2                	add    %eax,%edx
 a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	8b 00                	mov    (%eax),%eax
 a52:	8b 10                	mov    (%eax),%edx
 a54:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a57:	89 10                	mov    %edx,(%eax)
 a59:	eb 0a                	jmp    a65 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5e:	8b 10                	mov    (%eax),%edx
 a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a63:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	8b 40 04             	mov    0x4(%eax),%eax
 a6b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a75:	01 d0                	add    %edx,%eax
 a77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a7a:	75 20                	jne    a9c <free+0xcf>
    p->s.size += bp->s.size;
 a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7f:	8b 50 04             	mov    0x4(%eax),%edx
 a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	01 c2                	add    %eax,%edx
 a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a93:	8b 10                	mov    (%eax),%edx
 a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a98:	89 10                	mov    %edx,(%eax)
 a9a:	eb 08                	jmp    aa4 <free+0xd7>
  } else
    p->s.ptr = bp;
 a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 aa2:	89 10                	mov    %edx,(%eax)
  freep = p;
 aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa7:	a3 14 14 00 00       	mov    %eax,0x1414
}
 aac:	c9                   	leave  
 aad:	c3                   	ret    

00000aae <morecore>:

static Header*
morecore(uint nu)
{
 aae:	55                   	push   %ebp
 aaf:	89 e5                	mov    %esp,%ebp
 ab1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ab4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 abb:	77 07                	ja     ac4 <morecore+0x16>
    nu = 4096;
 abd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ac4:	8b 45 08             	mov    0x8(%ebp),%eax
 ac7:	c1 e0 03             	shl    $0x3,%eax
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 20 fc ff ff       	call   6f2 <sbrk>
 ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ad5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ad9:	75 07                	jne    ae2 <morecore+0x34>
    return 0;
 adb:	b8 00 00 00 00       	mov    $0x0,%eax
 ae0:	eb 22                	jmp    b04 <morecore+0x56>
  hp = (Header*)p;
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aeb:	8b 55 08             	mov    0x8(%ebp),%edx
 aee:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af4:	83 c0 08             	add    $0x8,%eax
 af7:	89 04 24             	mov    %eax,(%esp)
 afa:	e8 ce fe ff ff       	call   9cd <free>
  return freep;
 aff:	a1 14 14 00 00       	mov    0x1414,%eax
}
 b04:	c9                   	leave  
 b05:	c3                   	ret    

00000b06 <malloc>:

void*
malloc(uint nbytes)
{
 b06:	55                   	push   %ebp
 b07:	89 e5                	mov    %esp,%ebp
 b09:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b0c:	8b 45 08             	mov    0x8(%ebp),%eax
 b0f:	83 c0 07             	add    $0x7,%eax
 b12:	c1 e8 03             	shr    $0x3,%eax
 b15:	83 c0 01             	add    $0x1,%eax
 b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b1b:	a1 14 14 00 00       	mov    0x1414,%eax
 b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b27:	75 23                	jne    b4c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b29:	c7 45 f0 0c 14 00 00 	movl   $0x140c,-0x10(%ebp)
 b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b33:	a3 14 14 00 00       	mov    %eax,0x1414
 b38:	a1 14 14 00 00       	mov    0x1414,%eax
 b3d:	a3 0c 14 00 00       	mov    %eax,0x140c
    base.s.size = 0;
 b42:	c7 05 10 14 00 00 00 	movl   $0x0,0x1410
 b49:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4f:	8b 00                	mov    (%eax),%eax
 b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b57:	8b 40 04             	mov    0x4(%eax),%eax
 b5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b5d:	72 4d                	jb     bac <malloc+0xa6>
      if(p->s.size == nunits)
 b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b62:	8b 40 04             	mov    0x4(%eax),%eax
 b65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b68:	75 0c                	jne    b76 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6d:	8b 10                	mov    (%eax),%edx
 b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b72:	89 10                	mov    %edx,(%eax)
 b74:	eb 26                	jmp    b9c <malloc+0x96>
      else {
        p->s.size -= nunits;
 b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b79:	8b 40 04             	mov    0x4(%eax),%eax
 b7c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b7f:	89 c2                	mov    %eax,%edx
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8a:	8b 40 04             	mov    0x4(%eax),%eax
 b8d:	c1 e0 03             	shl    $0x3,%eax
 b90:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b96:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b99:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9f:	a3 14 14 00 00       	mov    %eax,0x1414
      return (void*)(p + 1);
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	83 c0 08             	add    $0x8,%eax
 baa:	eb 38                	jmp    be4 <malloc+0xde>
    }
    if(p == freep)
 bac:	a1 14 14 00 00       	mov    0x1414,%eax
 bb1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bb4:	75 1b                	jne    bd1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bb9:	89 04 24             	mov    %eax,(%esp)
 bbc:	e8 ed fe ff ff       	call   aae <morecore>
 bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bc8:	75 07                	jne    bd1 <malloc+0xcb>
        return 0;
 bca:	b8 00 00 00 00       	mov    $0x0,%eax
 bcf:	eb 13                	jmp    be4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bda:	8b 00                	mov    (%eax),%eax
 bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bdf:	e9 70 ff ff ff       	jmp    b54 <malloc+0x4e>
}
 be4:	c9                   	leave  
 be5:	c3                   	ret    

00000be6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 be6:	55                   	push   %ebp
 be7:	89 e5                	mov    %esp,%ebp
 be9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 bec:	8b 55 08             	mov    0x8(%ebp),%edx
 bef:	8b 45 0c             	mov    0xc(%ebp),%eax
 bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 bf5:	f0 87 02             	lock xchg %eax,(%edx)
 bf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 bfe:	c9                   	leave  
 bff:	c3                   	ret    

00000c00 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 c00:	55                   	push   %ebp
 c01:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 c03:	8b 45 08             	mov    0x8(%ebp),%eax
 c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 c0c:	5d                   	pop    %ebp
 c0d:	c3                   	ret    

00000c0e <lock_acquire>:
void lock_acquire(lock_t *lock){
 c0e:	55                   	push   %ebp
 c0f:	89 e5                	mov    %esp,%ebp
 c11:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 c14:	90                   	nop
 c15:	8b 45 08             	mov    0x8(%ebp),%eax
 c18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 c1f:	00 
 c20:	89 04 24             	mov    %eax,(%esp)
 c23:	e8 be ff ff ff       	call   be6 <xchg>
 c28:	85 c0                	test   %eax,%eax
 c2a:	75 e9                	jne    c15 <lock_acquire+0x7>
}
 c2c:	c9                   	leave  
 c2d:	c3                   	ret    

00000c2e <lock_release>:
void lock_release(lock_t *lock){
 c2e:	55                   	push   %ebp
 c2f:	89 e5                	mov    %esp,%ebp
 c31:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 c34:	8b 45 08             	mov    0x8(%ebp),%eax
 c37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 c3e:	00 
 c3f:	89 04 24             	mov    %eax,(%esp)
 c42:	e8 9f ff ff ff       	call   be6 <xchg>
}
 c47:	c9                   	leave  
 c48:	c3                   	ret    

00000c49 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 c49:	55                   	push   %ebp
 c4a:	89 e5                	mov    %esp,%ebp
 c4c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 c4f:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 c56:	e8 ab fe ff ff       	call   b06 <malloc>
 c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 c64:	0f b6 05 18 14 00 00 	movzbl 0x1418,%eax
 c6b:	84 c0                	test   %al,%al
 c6d:	75 1c                	jne    c8b <thread_create+0x42>
        init_q(thQ2);
 c6f:	a1 34 16 00 00       	mov    0x1634,%eax
 c74:	89 04 24             	mov    %eax,(%esp)
 c77:	e8 2c 01 00 00       	call   da8 <init_q>
        inQ++;
 c7c:	0f b6 05 18 14 00 00 	movzbl 0x1418,%eax
 c83:	83 c0 01             	add    $0x1,%eax
 c86:	a2 18 14 00 00       	mov    %al,0x1418
    }

    if((uint)stack % 4096){
 c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8e:	25 ff 0f 00 00       	and    $0xfff,%eax
 c93:	85 c0                	test   %eax,%eax
 c95:	74 14                	je     cab <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9a:	25 ff 0f 00 00       	and    $0xfff,%eax
 c9f:	89 c2                	mov    %eax,%edx
 ca1:	b8 00 10 00 00       	mov    $0x1000,%eax
 ca6:	29 d0                	sub    %edx,%eax
 ca8:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 caf:	75 1e                	jne    ccf <thread_create+0x86>

        printf(1,"malloc fail \n");
 cb1:	c7 44 24 04 a6 0f 00 	movl   $0xfa6,0x4(%esp)
 cb8:	00 
 cb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cc0:	e8 55 fb ff ff       	call   81a <printf>
        return 0;
 cc5:	b8 00 00 00 00       	mov    $0x0,%eax
 cca:	e9 83 00 00 00       	jmp    d52 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 cd2:	8b 55 08             	mov    0x8(%ebp),%edx
 cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 cdc:	89 54 24 08          	mov    %edx,0x8(%esp)
 ce0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 ce7:	00 
 ce8:	89 04 24             	mov    %eax,(%esp)
 ceb:	e8 1a fa ff ff       	call   70a <clone>
 cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 cf7:	79 1b                	jns    d14 <thread_create+0xcb>
        printf(1,"clone fails\n");
 cf9:	c7 44 24 04 b4 0f 00 	movl   $0xfb4,0x4(%esp)
 d00:	00 
 d01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d08:	e8 0d fb ff ff       	call   81a <printf>
        return 0;
 d0d:	b8 00 00 00 00       	mov    $0x0,%eax
 d12:	eb 3e                	jmp    d52 <thread_create+0x109>
    }
    if(tid > 0){
 d14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d18:	7e 19                	jle    d33 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 d1a:	a1 34 16 00 00       	mov    0x1634,%eax
 d1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d22:	89 54 24 04          	mov    %edx,0x4(%esp)
 d26:	89 04 24             	mov    %eax,(%esp)
 d29:	e8 9c 00 00 00       	call   dca <add_q>
        return garbage_stack;
 d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d31:	eb 1f                	jmp    d52 <thread_create+0x109>
    }
    if(tid == 0){
 d33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d37:	75 14                	jne    d4d <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 d39:	c7 44 24 04 c1 0f 00 	movl   $0xfc1,0x4(%esp)
 d40:	00 
 d41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d48:	e8 cd fa ff ff       	call   81a <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d52:	c9                   	leave  
 d53:	c3                   	ret    

00000d54 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 d54:	55                   	push   %ebp
 d55:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 d57:	a1 e4 13 00 00       	mov    0x13e4,%eax
 d5c:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 d62:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 d67:	a3 e4 13 00 00       	mov    %eax,0x13e4
    return (int)(rands % max);
 d6c:	a1 e4 13 00 00       	mov    0x13e4,%eax
 d71:	8b 4d 08             	mov    0x8(%ebp),%ecx
 d74:	ba 00 00 00 00       	mov    $0x0,%edx
 d79:	f7 f1                	div    %ecx
 d7b:	89 d0                	mov    %edx,%eax
}
 d7d:	5d                   	pop    %ebp
 d7e:	c3                   	ret    

00000d7f <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 d7f:	55                   	push   %ebp
 d80:	89 e5                	mov    %esp,%ebp
 d82:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
 d85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 d8b:	8b 40 10             	mov    0x10(%eax),%eax
 d8e:	89 44 24 08          	mov    %eax,0x8(%esp)
 d92:	c7 44 24 04 d2 0f 00 	movl   $0xfd2,0x4(%esp)
 d99:	00 
 d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 da1:	e8 74 fa ff ff       	call   81a <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
 da6:	c9                   	leave  
 da7:	c3                   	ret    

00000da8 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 da8:	55                   	push   %ebp
 da9:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 dab:	8b 45 08             	mov    0x8(%ebp),%eax
 dae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 db4:	8b 45 08             	mov    0x8(%ebp),%eax
 db7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 dbe:	8b 45 08             	mov    0x8(%ebp),%eax
 dc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 dc8:	5d                   	pop    %ebp
 dc9:	c3                   	ret    

00000dca <add_q>:

void add_q(struct queue *q, int v){
 dca:	55                   	push   %ebp
 dcb:	89 e5                	mov    %esp,%ebp
 dcd:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 dd0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 dd7:	e8 2a fd ff ff       	call   b06 <malloc>
 ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dec:	8b 55 0c             	mov    0xc(%ebp),%edx
 def:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 df1:	8b 45 08             	mov    0x8(%ebp),%eax
 df4:	8b 40 04             	mov    0x4(%eax),%eax
 df7:	85 c0                	test   %eax,%eax
 df9:	75 0b                	jne    e06 <add_q+0x3c>
        q->head = n;
 dfb:	8b 45 08             	mov    0x8(%ebp),%eax
 dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e01:	89 50 04             	mov    %edx,0x4(%eax)
 e04:	eb 0c                	jmp    e12 <add_q+0x48>
    }else{
        q->tail->next = n;
 e06:	8b 45 08             	mov    0x8(%ebp),%eax
 e09:	8b 40 08             	mov    0x8(%eax),%eax
 e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e0f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 e12:	8b 45 08             	mov    0x8(%ebp),%eax
 e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e18:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 e1b:	8b 45 08             	mov    0x8(%ebp),%eax
 e1e:	8b 00                	mov    (%eax),%eax
 e20:	8d 50 01             	lea    0x1(%eax),%edx
 e23:	8b 45 08             	mov    0x8(%ebp),%eax
 e26:	89 10                	mov    %edx,(%eax)
}
 e28:	c9                   	leave  
 e29:	c3                   	ret    

00000e2a <empty_q>:

int empty_q(struct queue *q){
 e2a:	55                   	push   %ebp
 e2b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 e2d:	8b 45 08             	mov    0x8(%ebp),%eax
 e30:	8b 00                	mov    (%eax),%eax
 e32:	85 c0                	test   %eax,%eax
 e34:	75 07                	jne    e3d <empty_q+0x13>
        return 1;
 e36:	b8 01 00 00 00       	mov    $0x1,%eax
 e3b:	eb 05                	jmp    e42 <empty_q+0x18>
    else
        return 0;
 e3d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 e42:	5d                   	pop    %ebp
 e43:	c3                   	ret    

00000e44 <pop_q>:
int pop_q(struct queue *q){
 e44:	55                   	push   %ebp
 e45:	89 e5                	mov    %esp,%ebp
 e47:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 e4a:	8b 45 08             	mov    0x8(%ebp),%eax
 e4d:	89 04 24             	mov    %eax,(%esp)
 e50:	e8 d5 ff ff ff       	call   e2a <empty_q>
 e55:	85 c0                	test   %eax,%eax
 e57:	75 5d                	jne    eb6 <pop_q+0x72>
       val = q->head->value; 
 e59:	8b 45 08             	mov    0x8(%ebp),%eax
 e5c:	8b 40 04             	mov    0x4(%eax),%eax
 e5f:	8b 00                	mov    (%eax),%eax
 e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 e64:	8b 45 08             	mov    0x8(%ebp),%eax
 e67:	8b 40 04             	mov    0x4(%eax),%eax
 e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 e6d:	8b 45 08             	mov    0x8(%ebp),%eax
 e70:	8b 40 04             	mov    0x4(%eax),%eax
 e73:	8b 50 04             	mov    0x4(%eax),%edx
 e76:	8b 45 08             	mov    0x8(%ebp),%eax
 e79:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e7f:	89 04 24             	mov    %eax,(%esp)
 e82:	e8 46 fb ff ff       	call   9cd <free>
       q->size--;
 e87:	8b 45 08             	mov    0x8(%ebp),%eax
 e8a:	8b 00                	mov    (%eax),%eax
 e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
 e8f:	8b 45 08             	mov    0x8(%ebp),%eax
 e92:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 e94:	8b 45 08             	mov    0x8(%ebp),%eax
 e97:	8b 00                	mov    (%eax),%eax
 e99:	85 c0                	test   %eax,%eax
 e9b:	75 14                	jne    eb1 <pop_q+0x6d>
            q->head = 0;
 e9d:	8b 45 08             	mov    0x8(%ebp),%eax
 ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 ea7:	8b 45 08             	mov    0x8(%ebp),%eax
 eaa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb4:	eb 05                	jmp    ebb <pop_q+0x77>
    }
    return -1;
 eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 ebb:	c9                   	leave  
 ebc:	c3                   	ret    
