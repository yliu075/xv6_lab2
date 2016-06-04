
_frisbee:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
void pass_next(void *arg);
int lookup();



int main(int argc, char *argv[]){
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	56                   	push   %esi
    100e:	53                   	push   %ebx
    100f:	51                   	push   %ecx
    1010:	83 ec 3c             	sub    $0x3c,%esp
    1013:	89 cb                	mov    %ecx,%ebx

    int i;
    struct thread *t;
//    void * sp;

    if(argc != 3){
    1015:	83 3b 03             	cmpl   $0x3,(%ebx)
    1018:	74 19                	je     1033 <main+0x33>
        printf(1,"argc is not match !\n");
    101a:	c7 44 24 04 60 1f 00 	movl   $0x1f60,0x4(%esp)
    1021:	00 
    1022:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1029:	e8 ec 07 00 00       	call   181a <printf>
        exit();
    102e:	e8 37 06 00 00       	call   166a <exit>
    }
    numthreads = atoi(argv[1]);
    1033:	8b 43 04             	mov    0x4(%ebx),%eax
    1036:	83 c0 04             	add    $0x4,%eax
    1039:	8b 00                	mov    (%eax),%eax
    103b:	89 04 24             	mov    %eax,(%esp)
    103e:	e8 95 05 00 00       	call   15d8 <atoi>
    1043:	a3 c0 24 00 00       	mov    %eax,0x24c0
    numpass = atoi(argv[2]);
    1048:	8b 43 04             	mov    0x4(%ebx),%eax
    104b:	83 c0 08             	add    $0x8,%eax
    104e:	8b 00                	mov    (%eax),%eax
    1050:	89 04 24             	mov    %eax,(%esp)
    1053:	e8 80 05 00 00       	call   15d8 <atoi>
    1058:	a3 c4 24 00 00       	mov    %eax,0x24c4

    void * slist[numthreads];
    105d:	a1 c0 24 00 00       	mov    0x24c0,%eax
    1062:	8d 50 ff             	lea    -0x1(%eax),%edx
    1065:	89 55 dc             	mov    %edx,-0x24(%ebp)
    1068:	c1 e0 02             	shl    $0x2,%eax
    106b:	8d 50 03             	lea    0x3(%eax),%edx
    106e:	b8 10 00 00 00       	mov    $0x10,%eax
    1073:	83 e8 01             	sub    $0x1,%eax
    1076:	01 d0                	add    %edx,%eax
    1078:	be 10 00 00 00       	mov    $0x10,%esi
    107d:	ba 00 00 00 00       	mov    $0x0,%edx
    1082:	f7 f6                	div    %esi
    1084:	6b c0 10             	imul   $0x10,%eax,%eax
    1087:	29 c4                	sub    %eax,%esp
    1089:	8d 44 24 0c          	lea    0xc(%esp),%eax
    108d:	83 c0 03             	add    $0x3,%eax
    1090:	c1 e8 02             	shr    $0x2,%eax
    1093:	c1 e0 02             	shl    $0x2,%eax
    1096:	89 45 d8             	mov    %eax,-0x28(%ebp)

    //init ttable;
    lock_init(&ttable.lock);
    1099:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    10a0:	e8 5b 0b 00 00       	call   1c00 <lock_init>
    ttable.total = 0;
    10a5:	c7 05 e4 26 00 00 00 	movl   $0x0,0x26e4
    10ac:	00 00 00 
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    10af:	c7 45 e0 e4 24 00 00 	movl   $0x24e4,-0x20(%ebp)
    10b6:	eb 0d                	jmp    10c5 <main+0xc5>
        t->tid = 0;
    10b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    10bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    void * slist[numthreads];

    //init ttable;
    lock_init(&ttable.lock);
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    10c1:	83 45 e0 08          	addl   $0x8,-0x20(%ebp)
    10c5:	81 7d e0 e4 26 00 00 	cmpl   $0x26e4,-0x20(%ebp)
    10cc:	72 ea                	jb     10b8 <main+0xb8>
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
    10ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    10d5:	eb 11                	jmp    10e8 <main+0xe8>
        slist[i]=0;
    10d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
    10da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    10dd:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
    10e4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    10e8:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
    10ec:	7e e9                	jle    10d7 <main+0xd7>
        slist[i]=0;
    }
    //init frisbee
    lock_init(&frisbee.lock);
    10ee:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    10f5:	e8 06 0b 00 00       	call   1c00 <lock_init>
    frisbee.pass = 0;
    10fa:	c7 05 ec 26 00 00 00 	movl   $0x0,0x26ec
    1101:	00 00 00 
    frisbee.holding_thread = 0;
    1104:	c7 05 f0 26 00 00 00 	movl   $0x0,0x26f0
    110b:	00 00 00 

    printf(1,"\nnum of threads %d \n",numthreads);
    110e:	a1 c0 24 00 00       	mov    0x24c0,%eax
    1113:	89 44 24 08          	mov    %eax,0x8(%esp)
    1117:	c7 44 24 04 75 1f 00 	movl   $0x1f75,0x4(%esp)
    111e:	00 
    111f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1126:	e8 ef 06 00 00       	call   181a <printf>
    printf(1,"num of passes %d \n\n",numpass);
    112b:	a1 c4 24 00 00       	mov    0x24c4,%eax
    1130:	89 44 24 08          	mov    %eax,0x8(%esp)
    1134:	c7 44 24 04 8a 1f 00 	movl   $0x1f8a,0x4(%esp)
    113b:	00 
    113c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1143:	e8 d2 06 00 00       	call   181a <printf>


    for(i=0; i<numthreads;i++){
    1148:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    114f:	eb 43                	jmp    1194 <main+0x194>
        void *stack = thread_create(pass_next,(void *)0);      
    1151:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1158:	00 
    1159:	c7 04 24 3d 12 00 00 	movl   $0x123d,(%esp)
    1160:	e8 e4 0a 00 00       	call   1c49 <thread_create>
    1165:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(stack == 0)
    1168:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    116c:	75 16                	jne    1184 <main+0x184>
            printf(1,"thread_create fail\n");
    116e:	c7 44 24 04 9e 1f 00 	movl   $0x1f9e,0x4(%esp)
    1175:	00 
    1176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    117d:	e8 98 06 00 00       	call   181a <printf>
    1182:	eb 0c                	jmp    1190 <main+0x190>
        else{
            slist[i] = stack;
    1184:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1187:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    118a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    118d:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    printf(1,"\nnum of threads %d \n",numthreads);
    printf(1,"num of passes %d \n\n",numpass);


    for(i=0; i<numthreads;i++){
    1190:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    1194:	a1 c0 24 00 00       	mov    0x24c0,%eax
    1199:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    119c:	7c b3                	jl     1151 <main+0x151>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
    119e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    11a5:	eb 10                	jmp    11b7 <main+0x1b7>
        if(wait() == -1)
    11a7:	e8 c6 04 00 00       	call   1672 <wait>
    11ac:	83 f8 ff             	cmp    $0xffffffff,%eax
    11af:	75 02                	jne    11b3 <main+0x1b3>
            break;
    11b1:	eb 0e                	jmp    11c1 <main+0x1c1>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
    11b3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    11b7:	a1 c0 24 00 00       	mov    0x24c0,%eax
    11bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    11bf:	7c e6                	jl     11a7 <main+0x1a7>
        if(wait() == -1)
            break;
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    11c1:	c7 45 e0 e4 24 00 00 	movl   $0x24e4,-0x20(%ebp)
    11c8:	eb 2a                	jmp    11f4 <main+0x1f4>
        if(t->tid != 0)
    11ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11cd:	8b 00                	mov    (%eax),%eax
    11cf:	85 c0                	test   %eax,%eax
    11d1:	74 1d                	je     11f0 <main+0x1f0>
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    11d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11d6:	8b 00                	mov    (%eax),%eax
    11d8:	89 44 24 08          	mov    %eax,0x8(%esp)
    11dc:	c7 44 24 04 b4 1f 00 	movl   $0x1fb4,0x4(%esp)
    11e3:	00 
    11e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11eb:	e8 2a 06 00 00       	call   181a <printf>
    for(i=0;i<numthreads;i++){
        if(wait() == -1)
            break;
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    11f0:	83 45 e0 08          	addl   $0x8,-0x20(%ebp)
    11f4:	81 7d e0 e4 26 00 00 	cmpl   $0x26e4,-0x20(%ebp)
    11fb:	72 cd                	jb     11ca <main+0x1ca>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
    11fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1204:	eb 28                	jmp    122e <main+0x22e>
        if(slist[i] != 0){
    1206:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1209:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    120c:	8b 04 90             	mov    (%eax,%edx,4),%eax
    120f:	85 c0                	test   %eax,%eax
    1211:	74 17                	je     122a <main+0x22a>
            void * f = slist[i];
    1213:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1219:	8b 04 90             	mov    (%eax,%edx,4),%eax
    121c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            free(f);
    121f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 a3 07 00 00       	call   19cd <free>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
    122a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    122e:	a1 c0 24 00 00       	mov    0x24c0,%eax
    1233:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    1236:	7c ce                	jl     1206 <main+0x206>
        if(slist[i] != 0){
            void * f = slist[i];
            free(f);
        }
    }
    exit();
    1238:	e8 2d 04 00 00       	call   166a <exit>

0000123d <pass_next>:
}

void pass_next(void *arg){
    123d:	55                   	push   %ebp
    123e:	89 e5                	mov    %esp,%ebp
    1240:	83 ec 28             	sub    $0x28,%esp
    struct thread *t;
    int tid;

    tid = getpid();
    1243:	e8 a2 04 00 00       	call   16ea <getpid>
    1248:	89 45 f0             	mov    %eax,-0x10(%ebp)

    lock_acquire(&ttable.lock);
    124b:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    1252:	e8 b7 09 00 00       	call   1c0e <lock_acquire>
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    1257:	c7 45 f4 e4 24 00 00 	movl   $0x24e4,-0xc(%ebp)
    125e:	eb 17                	jmp    1277 <pass_next+0x3a>
        if(t->tid == 0){
    1260:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1263:	8b 00                	mov    (%eax),%eax
    1265:	85 c0                	test   %eax,%eax
    1267:	75 0a                	jne    1273 <pass_next+0x36>
            t->tid = tid;
    1269:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    126f:	89 10                	mov    %edx,(%eax)
            break;
    1271:	eb 0d                	jmp    1280 <pass_next+0x43>
    int tid;

    tid = getpid();

    lock_acquire(&ttable.lock);
    for(t=ttable.thread;t < &ttable.thread[64];t++){
    1273:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
    1277:	81 7d f4 e4 26 00 00 	cmpl   $0x26e4,-0xc(%ebp)
    127e:	72 e0                	jb     1260 <pass_next+0x23>
        if(t->tid == 0){
            t->tid = tid;
            break;
        } 
    }
    ttable.total++;
    1280:	a1 e4 26 00 00       	mov    0x26e4,%eax
    1285:	83 c0 01             	add    $0x1,%eax
    1288:	a3 e4 26 00 00       	mov    %eax,0x26e4
    lock_release(&ttable.lock);
    128d:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    1294:	e8 95 09 00 00       	call   1c2e <lock_release>

   for(;;){
        lock_acquire(&ttable.lock);
    1299:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    12a0:	e8 69 09 00 00       	call   1c0e <lock_acquire>
        if(ttable.total == numthreads){
    12a5:	8b 15 e4 26 00 00    	mov    0x26e4,%edx
    12ab:	a1 c0 24 00 00       	mov    0x24c0,%eax
    12b0:	39 c2                	cmp    %eax,%edx
    12b2:	75 39                	jne    12ed <pass_next+0xb0>
            printf(1," tid %d ready to go\n",t->tid);
    12b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b7:	8b 00                	mov    (%eax),%eax
    12b9:	89 44 24 08          	mov    %eax,0x8(%esp)
    12bd:	c7 44 24 04 dc 1f 00 	movl   $0x1fdc,0x4(%esp)
    12c4:	00 
    12c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12cc:	e8 49 05 00 00       	call   181a <printf>
            barrier++;
    12d1:	a1 c8 24 00 00       	mov    0x24c8,%eax
    12d6:	83 c0 01             	add    $0x1,%eax
    12d9:	a3 c8 24 00 00       	mov    %eax,0x24c8
            goto start;
    12de:	90                   	nop
        lock_release(&ttable.lock);
    }
    
//barriar above
start:
     lock_release(&ttable.lock);
    12df:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    12e6:	e8 43 09 00 00       	call   1c2e <lock_release>
     while(barrier != numthreads);
    12eb:	eb 0e                	jmp    12fb <pass_next+0xbe>
        if(ttable.total == numthreads){
            printf(1," tid %d ready to go\n",t->tid);
            barrier++;
            goto start;
        }
        lock_release(&ttable.lock);
    12ed:	c7 04 24 e0 24 00 00 	movl   $0x24e0,(%esp)
    12f4:	e8 35 09 00 00       	call   1c2e <lock_release>
    }
    12f9:	eb 9e                	jmp    1299 <pass_next+0x5c>
    
//barriar above
start:
     lock_release(&ttable.lock);
     while(barrier != numthreads);
    12fb:	8b 15 c8 24 00 00    	mov    0x24c8,%edx
    1301:	a1 c0 24 00 00       	mov    0x24c0,%eax
    1306:	39 c2                	cmp    %eax,%edx
    1308:	75 f1                	jne    12fb <pass_next+0xbe>
    //throw frisbee
    do{
        lock_acquire(&frisbee.lock);
    130a:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    1311:	e8 f8 08 00 00       	call   1c0e <lock_acquire>
        if(frisbee.pass > numpass){
    1316:	8b 15 ec 26 00 00    	mov    0x26ec,%edx
    131c:	a1 c4 24 00 00       	mov    0x24c4,%eax
    1321:	39 c2                	cmp    %eax,%edx
    1323:	7e 39                	jle    135e <pass_next+0x121>
            lock_release(&frisbee.lock);
    1325:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    132c:	e8 fd 08 00 00       	call   1c2e <lock_release>
            goto leaving;
    1331:	90                   	nop
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);

leaving: 
    lock_release(&frisbee.lock);
    1332:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    1339:	e8 f0 08 00 00       	call   1c2e <lock_release>
    printf(1,"thread %d out of game\n",tid);
    133e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1341:	89 44 24 08          	mov    %eax,0x8(%esp)
    1345:	c7 44 24 04 28 20 00 	movl   $0x2028,0x4(%esp)
    134c:	00 
    134d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1354:	e8 c1 04 00 00       	call   181a <printf>
    texit();
    1359:	e8 b4 03 00 00       	call   1712 <texit>
        lock_acquire(&frisbee.lock);
        if(frisbee.pass > numpass){
            lock_release(&frisbee.lock);
            goto leaving;
        }
        if(frisbee.holding_thread == tid){
    135e:	a1 f0 26 00 00       	mov    0x26f0,%eax
    1363:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1366:	75 1b                	jne    1383 <pass_next+0x146>
            lock_release(&frisbee.lock);
    1368:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    136f:	e8 ba 08 00 00       	call   1c2e <lock_release>
            sleep(5);
    1374:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    137b:	e8 7a 03 00 00       	call   16fa <sleep>
            continue;
    1380:	90                   	nop
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
                frisbee.pass, tid);
        frisbee.pass++;
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);
    1381:	eb 87                	jmp    130a <pass_next+0xcd>
        if(frisbee.holding_thread == tid){
            lock_release(&frisbee.lock);
            sleep(5);
            continue;
        }
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
    1383:	a1 ec 26 00 00       	mov    0x26ec,%eax
    1388:	8b 55 f0             	mov    -0x10(%ebp),%edx
    138b:	89 54 24 0c          	mov    %edx,0xc(%esp)
    138f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1393:	c7 44 24 04 f4 1f 00 	movl   $0x1ff4,0x4(%esp)
    139a:	00 
    139b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a2:	e8 73 04 00 00       	call   181a <printf>
                frisbee.pass, tid);
        frisbee.pass++;
    13a7:	a1 ec 26 00 00       	mov    0x26ec,%eax
    13ac:	83 c0 01             	add    $0x1,%eax
    13af:	a3 ec 26 00 00       	mov    %eax,0x26ec
        frisbee.holding_thread = tid;
    13b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b7:	a3 f0 26 00 00       	mov    %eax,0x26f0
        lock_release(&frisbee.lock);
    13bc:	c7 04 24 e8 26 00 00 	movl   $0x26e8,(%esp)
    13c3:	e8 66 08 00 00       	call   1c2e <lock_release>
    }while(1);
    13c8:	e9 3d ff ff ff       	jmp    130a <pass_next+0xcd>

000013cd <lookup>:
    lock_release(&frisbee.lock);
    printf(1,"thread %d out of game\n",tid);
    texit();
}

int lookup(int num_threads){
    13cd:	55                   	push   %ebp
    13ce:	89 e5                	mov    %esp,%ebp
    13d0:	83 ec 10             	sub    $0x10,%esp
    int i;
    struct thread *t;
    i = 0;
    13d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(t=ttable.thread;t<&ttable.thread[64];t++){
    13da:	c7 45 f8 e4 24 00 00 	movl   $0x24e4,-0x8(%ebp)
    13e1:	eb 11                	jmp    13f4 <lookup+0x27>
        if(t->tid != 0){
    13e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13e6:	8b 00                	mov    (%eax),%eax
    13e8:	85 c0                	test   %eax,%eax
    13ea:	74 04                	je     13f0 <lookup+0x23>
            i++;
    13ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

int lookup(int num_threads){
    int i;
    struct thread *t;
    i = 0;
    for(t=ttable.thread;t<&ttable.thread[64];t++){
    13f0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
    13f4:	81 7d f8 e4 26 00 00 	cmpl   $0x26e4,-0x8(%ebp)
    13fb:	72 e6                	jb     13e3 <lookup+0x16>
        if(t->tid != 0){
            i++;
        }
    }
    return i;
    13fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1400:	c9                   	leave  
    1401:	c3                   	ret    

00001402 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1402:	55                   	push   %ebp
    1403:	89 e5                	mov    %esp,%ebp
    1405:	57                   	push   %edi
    1406:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1407:	8b 4d 08             	mov    0x8(%ebp),%ecx
    140a:	8b 55 10             	mov    0x10(%ebp),%edx
    140d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1410:	89 cb                	mov    %ecx,%ebx
    1412:	89 df                	mov    %ebx,%edi
    1414:	89 d1                	mov    %edx,%ecx
    1416:	fc                   	cld    
    1417:	f3 aa                	rep stos %al,%es:(%edi)
    1419:	89 ca                	mov    %ecx,%edx
    141b:	89 fb                	mov    %edi,%ebx
    141d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1420:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1423:	5b                   	pop    %ebx
    1424:	5f                   	pop    %edi
    1425:	5d                   	pop    %ebp
    1426:	c3                   	ret    

00001427 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1427:	55                   	push   %ebp
    1428:	89 e5                	mov    %esp,%ebp
    142a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    142d:	8b 45 08             	mov    0x8(%ebp),%eax
    1430:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1433:	90                   	nop
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
    1437:	8d 50 01             	lea    0x1(%eax),%edx
    143a:	89 55 08             	mov    %edx,0x8(%ebp)
    143d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1440:	8d 4a 01             	lea    0x1(%edx),%ecx
    1443:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1446:	0f b6 12             	movzbl (%edx),%edx
    1449:	88 10                	mov    %dl,(%eax)
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	84 c0                	test   %al,%al
    1450:	75 e2                	jne    1434 <strcpy+0xd>
    ;
  return os;
    1452:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1455:	c9                   	leave  
    1456:	c3                   	ret    

00001457 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1457:	55                   	push   %ebp
    1458:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    145a:	eb 08                	jmp    1464 <strcmp+0xd>
    p++, q++;
    145c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1460:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1464:	8b 45 08             	mov    0x8(%ebp),%eax
    1467:	0f b6 00             	movzbl (%eax),%eax
    146a:	84 c0                	test   %al,%al
    146c:	74 10                	je     147e <strcmp+0x27>
    146e:	8b 45 08             	mov    0x8(%ebp),%eax
    1471:	0f b6 10             	movzbl (%eax),%edx
    1474:	8b 45 0c             	mov    0xc(%ebp),%eax
    1477:	0f b6 00             	movzbl (%eax),%eax
    147a:	38 c2                	cmp    %al,%dl
    147c:	74 de                	je     145c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    147e:	8b 45 08             	mov    0x8(%ebp),%eax
    1481:	0f b6 00             	movzbl (%eax),%eax
    1484:	0f b6 d0             	movzbl %al,%edx
    1487:	8b 45 0c             	mov    0xc(%ebp),%eax
    148a:	0f b6 00             	movzbl (%eax),%eax
    148d:	0f b6 c0             	movzbl %al,%eax
    1490:	29 c2                	sub    %eax,%edx
    1492:	89 d0                	mov    %edx,%eax
}
    1494:	5d                   	pop    %ebp
    1495:	c3                   	ret    

00001496 <strlen>:

uint
strlen(char *s)
{
    1496:	55                   	push   %ebp
    1497:	89 e5                	mov    %esp,%ebp
    1499:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    14a3:	eb 04                	jmp    14a9 <strlen+0x13>
    14a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    14a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14ac:	8b 45 08             	mov    0x8(%ebp),%eax
    14af:	01 d0                	add    %edx,%eax
    14b1:	0f b6 00             	movzbl (%eax),%eax
    14b4:	84 c0                	test   %al,%al
    14b6:	75 ed                	jne    14a5 <strlen+0xf>
    ;
  return n;
    14b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14bb:	c9                   	leave  
    14bc:	c3                   	ret    

000014bd <memset>:

void*
memset(void *dst, int c, uint n)
{
    14bd:	55                   	push   %ebp
    14be:	89 e5                	mov    %esp,%ebp
    14c0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    14c3:	8b 45 10             	mov    0x10(%ebp),%eax
    14c6:	89 44 24 08          	mov    %eax,0x8(%esp)
    14ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    14cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14d1:	8b 45 08             	mov    0x8(%ebp),%eax
    14d4:	89 04 24             	mov    %eax,(%esp)
    14d7:	e8 26 ff ff ff       	call   1402 <stosb>
  return dst;
    14dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14df:	c9                   	leave  
    14e0:	c3                   	ret    

000014e1 <strchr>:

char*
strchr(const char *s, char c)
{
    14e1:	55                   	push   %ebp
    14e2:	89 e5                	mov    %esp,%ebp
    14e4:	83 ec 04             	sub    $0x4,%esp
    14e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    14ea:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    14ed:	eb 14                	jmp    1503 <strchr+0x22>
    if(*s == c)
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
    14f2:	0f b6 00             	movzbl (%eax),%eax
    14f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
    14f8:	75 05                	jne    14ff <strchr+0x1e>
      return (char*)s;
    14fa:	8b 45 08             	mov    0x8(%ebp),%eax
    14fd:	eb 13                	jmp    1512 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    14ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1503:	8b 45 08             	mov    0x8(%ebp),%eax
    1506:	0f b6 00             	movzbl (%eax),%eax
    1509:	84 c0                	test   %al,%al
    150b:	75 e2                	jne    14ef <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    150d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1512:	c9                   	leave  
    1513:	c3                   	ret    

00001514 <gets>:

char*
gets(char *buf, int max)
{
    1514:	55                   	push   %ebp
    1515:	89 e5                	mov    %esp,%ebp
    1517:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    151a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1521:	eb 4c                	jmp    156f <gets+0x5b>
    cc = read(0, &c, 1);
    1523:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    152a:	00 
    152b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    152e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1539:	e8 44 01 00 00       	call   1682 <read>
    153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1545:	7f 02                	jg     1549 <gets+0x35>
      break;
    1547:	eb 31                	jmp    157a <gets+0x66>
    buf[i++] = c;
    1549:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154c:	8d 50 01             	lea    0x1(%eax),%edx
    154f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1552:	89 c2                	mov    %eax,%edx
    1554:	8b 45 08             	mov    0x8(%ebp),%eax
    1557:	01 c2                	add    %eax,%edx
    1559:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    155d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    155f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1563:	3c 0a                	cmp    $0xa,%al
    1565:	74 13                	je     157a <gets+0x66>
    1567:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    156b:	3c 0d                	cmp    $0xd,%al
    156d:	74 0b                	je     157a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1572:	83 c0 01             	add    $0x1,%eax
    1575:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1578:	7c a9                	jl     1523 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    157d:	8b 45 08             	mov    0x8(%ebp),%eax
    1580:	01 d0                	add    %edx,%eax
    1582:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1585:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1588:	c9                   	leave  
    1589:	c3                   	ret    

0000158a <stat>:

int
stat(char *n, struct stat *st)
{
    158a:	55                   	push   %ebp
    158b:	89 e5                	mov    %esp,%ebp
    158d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1590:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1597:	00 
    1598:	8b 45 08             	mov    0x8(%ebp),%eax
    159b:	89 04 24             	mov    %eax,(%esp)
    159e:	e8 07 01 00 00       	call   16aa <open>
    15a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    15a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15aa:	79 07                	jns    15b3 <stat+0x29>
    return -1;
    15ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    15b1:	eb 23                	jmp    15d6 <stat+0x4c>
  r = fstat(fd, st);
    15b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    15b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15bd:	89 04 24             	mov    %eax,(%esp)
    15c0:	e8 fd 00 00 00       	call   16c2 <fstat>
    15c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    15c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15cb:	89 04 24             	mov    %eax,(%esp)
    15ce:	e8 bf 00 00 00       	call   1692 <close>
  return r;
    15d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    15d6:	c9                   	leave  
    15d7:	c3                   	ret    

000015d8 <atoi>:

int
atoi(const char *s)
{
    15d8:	55                   	push   %ebp
    15d9:	89 e5                	mov    %esp,%ebp
    15db:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    15de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    15e5:	eb 25                	jmp    160c <atoi+0x34>
    n = n*10 + *s++ - '0';
    15e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    15ea:	89 d0                	mov    %edx,%eax
    15ec:	c1 e0 02             	shl    $0x2,%eax
    15ef:	01 d0                	add    %edx,%eax
    15f1:	01 c0                	add    %eax,%eax
    15f3:	89 c1                	mov    %eax,%ecx
    15f5:	8b 45 08             	mov    0x8(%ebp),%eax
    15f8:	8d 50 01             	lea    0x1(%eax),%edx
    15fb:	89 55 08             	mov    %edx,0x8(%ebp)
    15fe:	0f b6 00             	movzbl (%eax),%eax
    1601:	0f be c0             	movsbl %al,%eax
    1604:	01 c8                	add    %ecx,%eax
    1606:	83 e8 30             	sub    $0x30,%eax
    1609:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    160c:	8b 45 08             	mov    0x8(%ebp),%eax
    160f:	0f b6 00             	movzbl (%eax),%eax
    1612:	3c 2f                	cmp    $0x2f,%al
    1614:	7e 0a                	jle    1620 <atoi+0x48>
    1616:	8b 45 08             	mov    0x8(%ebp),%eax
    1619:	0f b6 00             	movzbl (%eax),%eax
    161c:	3c 39                	cmp    $0x39,%al
    161e:	7e c7                	jle    15e7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1620:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1623:	c9                   	leave  
    1624:	c3                   	ret    

00001625 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1625:	55                   	push   %ebp
    1626:	89 e5                	mov    %esp,%ebp
    1628:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    162b:	8b 45 08             	mov    0x8(%ebp),%eax
    162e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1631:	8b 45 0c             	mov    0xc(%ebp),%eax
    1634:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1637:	eb 17                	jmp    1650 <memmove+0x2b>
    *dst++ = *src++;
    1639:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163c:	8d 50 01             	lea    0x1(%eax),%edx
    163f:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1642:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1645:	8d 4a 01             	lea    0x1(%edx),%ecx
    1648:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    164b:	0f b6 12             	movzbl (%edx),%edx
    164e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1650:	8b 45 10             	mov    0x10(%ebp),%eax
    1653:	8d 50 ff             	lea    -0x1(%eax),%edx
    1656:	89 55 10             	mov    %edx,0x10(%ebp)
    1659:	85 c0                	test   %eax,%eax
    165b:	7f dc                	jg     1639 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    165d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1660:	c9                   	leave  
    1661:	c3                   	ret    

00001662 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1662:	b8 01 00 00 00       	mov    $0x1,%eax
    1667:	cd 40                	int    $0x40
    1669:	c3                   	ret    

0000166a <exit>:
SYSCALL(exit)
    166a:	b8 02 00 00 00       	mov    $0x2,%eax
    166f:	cd 40                	int    $0x40
    1671:	c3                   	ret    

00001672 <wait>:
SYSCALL(wait)
    1672:	b8 03 00 00 00       	mov    $0x3,%eax
    1677:	cd 40                	int    $0x40
    1679:	c3                   	ret    

0000167a <pipe>:
SYSCALL(pipe)
    167a:	b8 04 00 00 00       	mov    $0x4,%eax
    167f:	cd 40                	int    $0x40
    1681:	c3                   	ret    

00001682 <read>:
SYSCALL(read)
    1682:	b8 05 00 00 00       	mov    $0x5,%eax
    1687:	cd 40                	int    $0x40
    1689:	c3                   	ret    

0000168a <write>:
SYSCALL(write)
    168a:	b8 10 00 00 00       	mov    $0x10,%eax
    168f:	cd 40                	int    $0x40
    1691:	c3                   	ret    

00001692 <close>:
SYSCALL(close)
    1692:	b8 15 00 00 00       	mov    $0x15,%eax
    1697:	cd 40                	int    $0x40
    1699:	c3                   	ret    

0000169a <kill>:
SYSCALL(kill)
    169a:	b8 06 00 00 00       	mov    $0x6,%eax
    169f:	cd 40                	int    $0x40
    16a1:	c3                   	ret    

000016a2 <exec>:
SYSCALL(exec)
    16a2:	b8 07 00 00 00       	mov    $0x7,%eax
    16a7:	cd 40                	int    $0x40
    16a9:	c3                   	ret    

000016aa <open>:
SYSCALL(open)
    16aa:	b8 0f 00 00 00       	mov    $0xf,%eax
    16af:	cd 40                	int    $0x40
    16b1:	c3                   	ret    

000016b2 <mknod>:
SYSCALL(mknod)
    16b2:	b8 11 00 00 00       	mov    $0x11,%eax
    16b7:	cd 40                	int    $0x40
    16b9:	c3                   	ret    

000016ba <unlink>:
SYSCALL(unlink)
    16ba:	b8 12 00 00 00       	mov    $0x12,%eax
    16bf:	cd 40                	int    $0x40
    16c1:	c3                   	ret    

000016c2 <fstat>:
SYSCALL(fstat)
    16c2:	b8 08 00 00 00       	mov    $0x8,%eax
    16c7:	cd 40                	int    $0x40
    16c9:	c3                   	ret    

000016ca <link>:
SYSCALL(link)
    16ca:	b8 13 00 00 00       	mov    $0x13,%eax
    16cf:	cd 40                	int    $0x40
    16d1:	c3                   	ret    

000016d2 <mkdir>:
SYSCALL(mkdir)
    16d2:	b8 14 00 00 00       	mov    $0x14,%eax
    16d7:	cd 40                	int    $0x40
    16d9:	c3                   	ret    

000016da <chdir>:
SYSCALL(chdir)
    16da:	b8 09 00 00 00       	mov    $0x9,%eax
    16df:	cd 40                	int    $0x40
    16e1:	c3                   	ret    

000016e2 <dup>:
SYSCALL(dup)
    16e2:	b8 0a 00 00 00       	mov    $0xa,%eax
    16e7:	cd 40                	int    $0x40
    16e9:	c3                   	ret    

000016ea <getpid>:
SYSCALL(getpid)
    16ea:	b8 0b 00 00 00       	mov    $0xb,%eax
    16ef:	cd 40                	int    $0x40
    16f1:	c3                   	ret    

000016f2 <sbrk>:
SYSCALL(sbrk)
    16f2:	b8 0c 00 00 00       	mov    $0xc,%eax
    16f7:	cd 40                	int    $0x40
    16f9:	c3                   	ret    

000016fa <sleep>:
SYSCALL(sleep)
    16fa:	b8 0d 00 00 00       	mov    $0xd,%eax
    16ff:	cd 40                	int    $0x40
    1701:	c3                   	ret    

00001702 <uptime>:
SYSCALL(uptime)
    1702:	b8 0e 00 00 00       	mov    $0xe,%eax
    1707:	cd 40                	int    $0x40
    1709:	c3                   	ret    

0000170a <clone>:
SYSCALL(clone)
    170a:	b8 16 00 00 00       	mov    $0x16,%eax
    170f:	cd 40                	int    $0x40
    1711:	c3                   	ret    

00001712 <texit>:
SYSCALL(texit)
    1712:	b8 17 00 00 00       	mov    $0x17,%eax
    1717:	cd 40                	int    $0x40
    1719:	c3                   	ret    

0000171a <tsleep>:
SYSCALL(tsleep)
    171a:	b8 18 00 00 00       	mov    $0x18,%eax
    171f:	cd 40                	int    $0x40
    1721:	c3                   	ret    

00001722 <twakeup>:
SYSCALL(twakeup)
    1722:	b8 19 00 00 00       	mov    $0x19,%eax
    1727:	cd 40                	int    $0x40
    1729:	c3                   	ret    

0000172a <thread_yield>:
SYSCALL(thread_yield)
    172a:	b8 1a 00 00 00       	mov    $0x1a,%eax
    172f:	cd 40                	int    $0x40
    1731:	c3                   	ret    

00001732 <thread_yield3>:
    1732:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1737:	cd 40                	int    $0x40
    1739:	c3                   	ret    

0000173a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    173a:	55                   	push   %ebp
    173b:	89 e5                	mov    %esp,%ebp
    173d:	83 ec 18             	sub    $0x18,%esp
    1740:	8b 45 0c             	mov    0xc(%ebp),%eax
    1743:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1746:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    174d:	00 
    174e:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1751:	89 44 24 04          	mov    %eax,0x4(%esp)
    1755:	8b 45 08             	mov    0x8(%ebp),%eax
    1758:	89 04 24             	mov    %eax,(%esp)
    175b:	e8 2a ff ff ff       	call   168a <write>
}
    1760:	c9                   	leave  
    1761:	c3                   	ret    

00001762 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1762:	55                   	push   %ebp
    1763:	89 e5                	mov    %esp,%ebp
    1765:	56                   	push   %esi
    1766:	53                   	push   %ebx
    1767:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    176a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1771:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1775:	74 17                	je     178e <printint+0x2c>
    1777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    177b:	79 11                	jns    178e <printint+0x2c>
    neg = 1;
    177d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1784:	8b 45 0c             	mov    0xc(%ebp),%eax
    1787:	f7 d8                	neg    %eax
    1789:	89 45 ec             	mov    %eax,-0x14(%ebp)
    178c:	eb 06                	jmp    1794 <printint+0x32>
  } else {
    x = xx;
    178e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    179b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    179e:	8d 41 01             	lea    0x1(%ecx),%eax
    17a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
    17a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17aa:	ba 00 00 00 00       	mov    $0x0,%edx
    17af:	f7 f3                	div    %ebx
    17b1:	89 d0                	mov    %edx,%eax
    17b3:	0f b6 80 9c 24 00 00 	movzbl 0x249c(%eax),%eax
    17ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    17be:	8b 75 10             	mov    0x10(%ebp),%esi
    17c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17c4:	ba 00 00 00 00       	mov    $0x0,%edx
    17c9:	f7 f6                	div    %esi
    17cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    17ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17d2:	75 c7                	jne    179b <printint+0x39>
  if(neg)
    17d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17d8:	74 10                	je     17ea <printint+0x88>
    buf[i++] = '-';
    17da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17dd:	8d 50 01             	lea    0x1(%eax),%edx
    17e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    17e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    17e8:	eb 1f                	jmp    1809 <printint+0xa7>
    17ea:	eb 1d                	jmp    1809 <printint+0xa7>
    putc(fd, buf[i]);
    17ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
    17ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f2:	01 d0                	add    %edx,%eax
    17f4:	0f b6 00             	movzbl (%eax),%eax
    17f7:	0f be c0             	movsbl %al,%eax
    17fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    17fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1801:	89 04 24             	mov    %eax,(%esp)
    1804:	e8 31 ff ff ff       	call   173a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1809:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    180d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1811:	79 d9                	jns    17ec <printint+0x8a>
    putc(fd, buf[i]);
}
    1813:	83 c4 30             	add    $0x30,%esp
    1816:	5b                   	pop    %ebx
    1817:	5e                   	pop    %esi
    1818:	5d                   	pop    %ebp
    1819:	c3                   	ret    

0000181a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    181a:	55                   	push   %ebp
    181b:	89 e5                	mov    %esp,%ebp
    181d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1820:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1827:	8d 45 0c             	lea    0xc(%ebp),%eax
    182a:	83 c0 04             	add    $0x4,%eax
    182d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1830:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1837:	e9 7c 01 00 00       	jmp    19b8 <printf+0x19e>
    c = fmt[i] & 0xff;
    183c:	8b 55 0c             	mov    0xc(%ebp),%edx
    183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1842:	01 d0                	add    %edx,%eax
    1844:	0f b6 00             	movzbl (%eax),%eax
    1847:	0f be c0             	movsbl %al,%eax
    184a:	25 ff 00 00 00       	and    $0xff,%eax
    184f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1852:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1856:	75 2c                	jne    1884 <printf+0x6a>
      if(c == '%'){
    1858:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    185c:	75 0c                	jne    186a <printf+0x50>
        state = '%';
    185e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1865:	e9 4a 01 00 00       	jmp    19b4 <printf+0x19a>
      } else {
        putc(fd, c);
    186a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    186d:	0f be c0             	movsbl %al,%eax
    1870:	89 44 24 04          	mov    %eax,0x4(%esp)
    1874:	8b 45 08             	mov    0x8(%ebp),%eax
    1877:	89 04 24             	mov    %eax,(%esp)
    187a:	e8 bb fe ff ff       	call   173a <putc>
    187f:	e9 30 01 00 00       	jmp    19b4 <printf+0x19a>
      }
    } else if(state == '%'){
    1884:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1888:	0f 85 26 01 00 00    	jne    19b4 <printf+0x19a>
      if(c == 'd'){
    188e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1892:	75 2d                	jne    18c1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1894:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1897:	8b 00                	mov    (%eax),%eax
    1899:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    18a0:	00 
    18a1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    18a8:	00 
    18a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ad:	8b 45 08             	mov    0x8(%ebp),%eax
    18b0:	89 04 24             	mov    %eax,(%esp)
    18b3:	e8 aa fe ff ff       	call   1762 <printint>
        ap++;
    18b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18bc:	e9 ec 00 00 00       	jmp    19ad <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    18c1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    18c5:	74 06                	je     18cd <printf+0xb3>
    18c7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    18cb:	75 2d                	jne    18fa <printf+0xe0>
        printint(fd, *ap, 16, 0);
    18cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18d0:	8b 00                	mov    (%eax),%eax
    18d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18d9:	00 
    18da:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18e1:	00 
    18e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    18e6:	8b 45 08             	mov    0x8(%ebp),%eax
    18e9:	89 04 24             	mov    %eax,(%esp)
    18ec:	e8 71 fe ff ff       	call   1762 <printint>
        ap++;
    18f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18f5:	e9 b3 00 00 00       	jmp    19ad <printf+0x193>
      } else if(c == 's'){
    18fa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    18fe:	75 45                	jne    1945 <printf+0x12b>
        s = (char*)*ap;
    1900:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1903:	8b 00                	mov    (%eax),%eax
    1905:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1908:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    190c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1910:	75 09                	jne    191b <printf+0x101>
          s = "(null)";
    1912:	c7 45 f4 3f 20 00 00 	movl   $0x203f,-0xc(%ebp)
        while(*s != 0){
    1919:	eb 1e                	jmp    1939 <printf+0x11f>
    191b:	eb 1c                	jmp    1939 <printf+0x11f>
          putc(fd, *s);
    191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1920:	0f b6 00             	movzbl (%eax),%eax
    1923:	0f be c0             	movsbl %al,%eax
    1926:	89 44 24 04          	mov    %eax,0x4(%esp)
    192a:	8b 45 08             	mov    0x8(%ebp),%eax
    192d:	89 04 24             	mov    %eax,(%esp)
    1930:	e8 05 fe ff ff       	call   173a <putc>
          s++;
    1935:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1939:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193c:	0f b6 00             	movzbl (%eax),%eax
    193f:	84 c0                	test   %al,%al
    1941:	75 da                	jne    191d <printf+0x103>
    1943:	eb 68                	jmp    19ad <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1945:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1949:	75 1d                	jne    1968 <printf+0x14e>
        putc(fd, *ap);
    194b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    194e:	8b 00                	mov    (%eax),%eax
    1950:	0f be c0             	movsbl %al,%eax
    1953:	89 44 24 04          	mov    %eax,0x4(%esp)
    1957:	8b 45 08             	mov    0x8(%ebp),%eax
    195a:	89 04 24             	mov    %eax,(%esp)
    195d:	e8 d8 fd ff ff       	call   173a <putc>
        ap++;
    1962:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1966:	eb 45                	jmp    19ad <printf+0x193>
      } else if(c == '%'){
    1968:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    196c:	75 17                	jne    1985 <printf+0x16b>
        putc(fd, c);
    196e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1971:	0f be c0             	movsbl %al,%eax
    1974:	89 44 24 04          	mov    %eax,0x4(%esp)
    1978:	8b 45 08             	mov    0x8(%ebp),%eax
    197b:	89 04 24             	mov    %eax,(%esp)
    197e:	e8 b7 fd ff ff       	call   173a <putc>
    1983:	eb 28                	jmp    19ad <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1985:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    198c:	00 
    198d:	8b 45 08             	mov    0x8(%ebp),%eax
    1990:	89 04 24             	mov    %eax,(%esp)
    1993:	e8 a2 fd ff ff       	call   173a <putc>
        putc(fd, c);
    1998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    199b:	0f be c0             	movsbl %al,%eax
    199e:	89 44 24 04          	mov    %eax,0x4(%esp)
    19a2:	8b 45 08             	mov    0x8(%ebp),%eax
    19a5:	89 04 24             	mov    %eax,(%esp)
    19a8:	e8 8d fd ff ff       	call   173a <putc>
      }
      state = 0;
    19ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    19b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    19b8:	8b 55 0c             	mov    0xc(%ebp),%edx
    19bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19be:	01 d0                	add    %edx,%eax
    19c0:	0f b6 00             	movzbl (%eax),%eax
    19c3:	84 c0                	test   %al,%al
    19c5:	0f 85 71 fe ff ff    	jne    183c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    19cb:	c9                   	leave  
    19cc:	c3                   	ret    

000019cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    19cd:	55                   	push   %ebp
    19ce:	89 e5                	mov    %esp,%ebp
    19d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    19d3:	8b 45 08             	mov    0x8(%ebp),%eax
    19d6:	83 e8 08             	sub    $0x8,%eax
    19d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19dc:	a1 d4 24 00 00       	mov    0x24d4,%eax
    19e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19e4:	eb 24                	jmp    1a0a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e9:	8b 00                	mov    (%eax),%eax
    19eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19ee:	77 12                	ja     1a02 <free+0x35>
    19f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19f6:	77 24                	ja     1a1c <free+0x4f>
    19f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19fb:	8b 00                	mov    (%eax),%eax
    19fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a00:	77 1a                	ja     1a1c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a05:	8b 00                	mov    (%eax),%eax
    1a07:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a0d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1a10:	76 d4                	jbe    19e6 <free+0x19>
    1a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a15:	8b 00                	mov    (%eax),%eax
    1a17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a1a:	76 ca                	jbe    19e6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a1f:	8b 40 04             	mov    0x4(%eax),%eax
    1a22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a2c:	01 c2                	add    %eax,%edx
    1a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a31:	8b 00                	mov    (%eax),%eax
    1a33:	39 c2                	cmp    %eax,%edx
    1a35:	75 24                	jne    1a5b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a3a:	8b 50 04             	mov    0x4(%eax),%edx
    1a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a40:	8b 00                	mov    (%eax),%eax
    1a42:	8b 40 04             	mov    0x4(%eax),%eax
    1a45:	01 c2                	add    %eax,%edx
    1a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a4a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a50:	8b 00                	mov    (%eax),%eax
    1a52:	8b 10                	mov    (%eax),%edx
    1a54:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a57:	89 10                	mov    %edx,(%eax)
    1a59:	eb 0a                	jmp    1a65 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a5e:	8b 10                	mov    (%eax),%edx
    1a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a63:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a68:	8b 40 04             	mov    0x4(%eax),%eax
    1a6b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a75:	01 d0                	add    %edx,%eax
    1a77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a7a:	75 20                	jne    1a9c <free+0xcf>
    p->s.size += bp->s.size;
    1a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a7f:	8b 50 04             	mov    0x4(%eax),%edx
    1a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a85:	8b 40 04             	mov    0x4(%eax),%eax
    1a88:	01 c2                	add    %eax,%edx
    1a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a8d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a93:	8b 10                	mov    (%eax),%edx
    1a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a98:	89 10                	mov    %edx,(%eax)
    1a9a:	eb 08                	jmp    1aa4 <free+0xd7>
  } else
    p->s.ptr = bp;
    1a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a9f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1aa2:	89 10                	mov    %edx,(%eax)
  freep = p;
    1aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aa7:	a3 d4 24 00 00       	mov    %eax,0x24d4
}
    1aac:	c9                   	leave  
    1aad:	c3                   	ret    

00001aae <morecore>:

static Header*
morecore(uint nu)
{
    1aae:	55                   	push   %ebp
    1aaf:	89 e5                	mov    %esp,%ebp
    1ab1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1ab4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1abb:	77 07                	ja     1ac4 <morecore+0x16>
    nu = 4096;
    1abd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1ac4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac7:	c1 e0 03             	shl    $0x3,%eax
    1aca:	89 04 24             	mov    %eax,(%esp)
    1acd:	e8 20 fc ff ff       	call   16f2 <sbrk>
    1ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1ad5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1ad9:	75 07                	jne    1ae2 <morecore+0x34>
    return 0;
    1adb:	b8 00 00 00 00       	mov    $0x0,%eax
    1ae0:	eb 22                	jmp    1b04 <morecore+0x56>
  hp = (Header*)p;
    1ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aeb:	8b 55 08             	mov    0x8(%ebp),%edx
    1aee:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1af4:	83 c0 08             	add    $0x8,%eax
    1af7:	89 04 24             	mov    %eax,(%esp)
    1afa:	e8 ce fe ff ff       	call   19cd <free>
  return freep;
    1aff:	a1 d4 24 00 00       	mov    0x24d4,%eax
}
    1b04:	c9                   	leave  
    1b05:	c3                   	ret    

00001b06 <malloc>:

void*
malloc(uint nbytes)
{
    1b06:	55                   	push   %ebp
    1b07:	89 e5                	mov    %esp,%ebp
    1b09:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1b0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0f:	83 c0 07             	add    $0x7,%eax
    1b12:	c1 e8 03             	shr    $0x3,%eax
    1b15:	83 c0 01             	add    $0x1,%eax
    1b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1b1b:	a1 d4 24 00 00       	mov    0x24d4,%eax
    1b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b27:	75 23                	jne    1b4c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1b29:	c7 45 f0 cc 24 00 00 	movl   $0x24cc,-0x10(%ebp)
    1b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b33:	a3 d4 24 00 00       	mov    %eax,0x24d4
    1b38:	a1 d4 24 00 00       	mov    0x24d4,%eax
    1b3d:	a3 cc 24 00 00       	mov    %eax,0x24cc
    base.s.size = 0;
    1b42:	c7 05 d0 24 00 00 00 	movl   $0x0,0x24d0
    1b49:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b4f:	8b 00                	mov    (%eax),%eax
    1b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b57:	8b 40 04             	mov    0x4(%eax),%eax
    1b5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b5d:	72 4d                	jb     1bac <malloc+0xa6>
      if(p->s.size == nunits)
    1b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b62:	8b 40 04             	mov    0x4(%eax),%eax
    1b65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b68:	75 0c                	jne    1b76 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6d:	8b 10                	mov    (%eax),%edx
    1b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b72:	89 10                	mov    %edx,(%eax)
    1b74:	eb 26                	jmp    1b9c <malloc+0x96>
      else {
        p->s.size -= nunits;
    1b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b79:	8b 40 04             	mov    0x4(%eax),%eax
    1b7c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1b7f:	89 c2                	mov    %eax,%edx
    1b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b84:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8a:	8b 40 04             	mov    0x4(%eax),%eax
    1b8d:	c1 e0 03             	shl    $0x3,%eax
    1b90:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b96:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b99:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b9f:	a3 d4 24 00 00       	mov    %eax,0x24d4
      return (void*)(p + 1);
    1ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ba7:	83 c0 08             	add    $0x8,%eax
    1baa:	eb 38                	jmp    1be4 <malloc+0xde>
    }
    if(p == freep)
    1bac:	a1 d4 24 00 00       	mov    0x24d4,%eax
    1bb1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1bb4:	75 1b                	jne    1bd1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1bb9:	89 04 24             	mov    %eax,(%esp)
    1bbc:	e8 ed fe ff ff       	call   1aae <morecore>
    1bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bc8:	75 07                	jne    1bd1 <malloc+0xcb>
        return 0;
    1bca:	b8 00 00 00 00       	mov    $0x0,%eax
    1bcf:	eb 13                	jmp    1be4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bda:	8b 00                	mov    (%eax),%eax
    1bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1bdf:	e9 70 ff ff ff       	jmp    1b54 <malloc+0x4e>
}
    1be4:	c9                   	leave  
    1be5:	c3                   	ret    

00001be6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1be6:	55                   	push   %ebp
    1be7:	89 e5                	mov    %esp,%ebp
    1be9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1bec:	8b 55 08             	mov    0x8(%ebp),%edx
    1bef:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1bf5:	f0 87 02             	lock xchg %eax,(%edx)
    1bf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1bfe:	c9                   	leave  
    1bff:	c3                   	ret    

00001c00 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1c00:	55                   	push   %ebp
    1c01:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1c03:	8b 45 08             	mov    0x8(%ebp),%eax
    1c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1c0c:	5d                   	pop    %ebp
    1c0d:	c3                   	ret    

00001c0e <lock_acquire>:
void lock_acquire(lock_t *lock){
    1c0e:	55                   	push   %ebp
    1c0f:	89 e5                	mov    %esp,%ebp
    1c11:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1c14:	90                   	nop
    1c15:	8b 45 08             	mov    0x8(%ebp),%eax
    1c18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1c1f:	00 
    1c20:	89 04 24             	mov    %eax,(%esp)
    1c23:	e8 be ff ff ff       	call   1be6 <xchg>
    1c28:	85 c0                	test   %eax,%eax
    1c2a:	75 e9                	jne    1c15 <lock_acquire+0x7>
}
    1c2c:	c9                   	leave  
    1c2d:	c3                   	ret    

00001c2e <lock_release>:
void lock_release(lock_t *lock){
    1c2e:	55                   	push   %ebp
    1c2f:	89 e5                	mov    %esp,%ebp
    1c31:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1c34:	8b 45 08             	mov    0x8(%ebp),%eax
    1c37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c3e:	00 
    1c3f:	89 04 24             	mov    %eax,(%esp)
    1c42:	e8 9f ff ff ff       	call   1be6 <xchg>
}
    1c47:	c9                   	leave  
    1c48:	c3                   	ret    

00001c49 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1c49:	55                   	push   %ebp
    1c4a:	89 e5                	mov    %esp,%ebp
    1c4c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1c4f:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1c56:	e8 ab fe ff ff       	call   1b06 <malloc>
    1c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1c64:	0f b6 05 d8 24 00 00 	movzbl 0x24d8,%eax
    1c6b:	84 c0                	test   %al,%al
    1c6d:	75 1c                	jne    1c8b <thread_create+0x42>
        init_q(thQ2);
    1c6f:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1c74:	89 04 24             	mov    %eax,(%esp)
    1c77:	e8 cd 01 00 00       	call   1e49 <init_q>
        inQ++;
    1c7c:	0f b6 05 d8 24 00 00 	movzbl 0x24d8,%eax
    1c83:	83 c0 01             	add    $0x1,%eax
    1c86:	a2 d8 24 00 00       	mov    %al,0x24d8
    }

    if((uint)stack % 4096){
    1c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c8e:	25 ff 0f 00 00       	and    $0xfff,%eax
    1c93:	85 c0                	test   %eax,%eax
    1c95:	74 14                	je     1cab <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c9a:	25 ff 0f 00 00       	and    $0xfff,%eax
    1c9f:	89 c2                	mov    %eax,%edx
    1ca1:	b8 00 10 00 00       	mov    $0x1000,%eax
    1ca6:	29 d0                	sub    %edx,%eax
    1ca8:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1caf:	75 1e                	jne    1ccf <thread_create+0x86>

        printf(1,"malloc fail \n");
    1cb1:	c7 44 24 04 46 20 00 	movl   $0x2046,0x4(%esp)
    1cb8:	00 
    1cb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cc0:	e8 55 fb ff ff       	call   181a <printf>
        return 0;
    1cc5:	b8 00 00 00 00       	mov    $0x0,%eax
    1cca:	e9 9e 00 00 00       	jmp    1d6d <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1cd2:	8b 55 08             	mov    0x8(%ebp),%edx
    1cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cd8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1cdc:	89 54 24 08          	mov    %edx,0x8(%esp)
    1ce0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1ce7:	00 
    1ce8:	89 04 24             	mov    %eax,(%esp)
    1ceb:	e8 1a fa ff ff       	call   170a <clone>
    1cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1cfa:	c7 44 24 04 54 20 00 	movl   $0x2054,0x4(%esp)
    1d01:	00 
    1d02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d09:	e8 0c fb ff ff       	call   181a <printf>
    if(tid < 0){
    1d0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d12:	79 1b                	jns    1d2f <thread_create+0xe6>
        printf(1,"clone fails\n");
    1d14:	c7 44 24 04 6d 20 00 	movl   $0x206d,0x4(%esp)
    1d1b:	00 
    1d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d23:	e8 f2 fa ff ff       	call   181a <printf>
        return 0;
    1d28:	b8 00 00 00 00       	mov    $0x0,%eax
    1d2d:	eb 3e                	jmp    1d6d <thread_create+0x124>
    }
    if(tid > 0){
    1d2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d33:	7e 19                	jle    1d4e <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1d35:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1d3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1d3d:	89 54 24 04          	mov    %edx,0x4(%esp)
    1d41:	89 04 24             	mov    %eax,(%esp)
    1d44:	e8 22 01 00 00       	call   1e6b <add_q>
        return garbage_stack;
    1d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d4c:	eb 1f                	jmp    1d6d <thread_create+0x124>
    }
    if(tid == 0){
    1d4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d52:	75 14                	jne    1d68 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1d54:	c7 44 24 04 7a 20 00 	movl   $0x207a,0x4(%esp)
    1d5b:	00 
    1d5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d63:	e8 b2 fa ff ff       	call   181a <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1d6d:	c9                   	leave  
    1d6e:	c3                   	ret    

00001d6f <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1d6f:	55                   	push   %ebp
    1d70:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1d72:	a1 b0 24 00 00       	mov    0x24b0,%eax
    1d77:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1d7d:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1d82:	a3 b0 24 00 00       	mov    %eax,0x24b0
    return (int)(rands % max);
    1d87:	a1 b0 24 00 00       	mov    0x24b0,%eax
    1d8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1d8f:	ba 00 00 00 00       	mov    $0x0,%edx
    1d94:	f7 f1                	div    %ecx
    1d96:	89 d0                	mov    %edx,%eax
}
    1d98:	5d                   	pop    %ebp
    1d99:	c3                   	ret    

00001d9a <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1d9a:	55                   	push   %ebp
    1d9b:	89 e5                	mov    %esp,%ebp
    1d9d:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1da0:	e8 45 f9 ff ff       	call   16ea <getpid>
    1da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1da8:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1dad:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1db0:	89 54 24 04          	mov    %edx,0x4(%esp)
    1db4:	89 04 24             	mov    %eax,(%esp)
    1db7:	e8 af 00 00 00       	call   1e6b <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1dbc:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1dc1:	89 04 24             	mov    %eax,(%esp)
    1dc4:	e8 1c 01 00 00       	call   1ee5 <pop_q>
    1dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1dcc:	a1 dc 24 00 00       	mov    0x24dc,%eax
    1dd1:	85 c0                	test   %eax,%eax
    1dd3:	75 1f                	jne    1df4 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1dd5:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1dda:	89 04 24             	mov    %eax,(%esp)
    1ddd:	e8 03 01 00 00       	call   1ee5 <pop_q>
    1de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1de5:	a1 dc 24 00 00       	mov    0x24dc,%eax
    1dea:	83 c0 01             	add    $0x1,%eax
    1ded:	a3 dc 24 00 00       	mov    %eax,0x24dc
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1df2:	eb 12                	jmp    1e06 <thread_yield2+0x6c>
    1df4:	eb 10                	jmp    1e06 <thread_yield2+0x6c>
    1df6:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1dfb:	89 04 24             	mov    %eax,(%esp)
    1dfe:	e8 e2 00 00 00       	call   1ee5 <pop_q>
    1e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1e0c:	74 e8                	je     1df6 <thread_yield2+0x5c>
    1e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e12:	74 e2                	je     1df6 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e17:	89 04 24             	mov    %eax,(%esp)
    1e1a:	e8 03 f9 ff ff       	call   1722 <twakeup>
    tsleep();
    1e1f:	e8 f6 f8 ff ff       	call   171a <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1e24:	c9                   	leave  
    1e25:	c3                   	ret    

00001e26 <thread_yield_last>:

void thread_yield_last(){
    1e26:	55                   	push   %ebp
    1e27:	89 e5                	mov    %esp,%ebp
    1e29:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1e2c:	a1 f4 26 00 00       	mov    0x26f4,%eax
    1e31:	89 04 24             	mov    %eax,(%esp)
    1e34:	e8 ac 00 00 00       	call   1ee5 <pop_q>
    1e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e3f:	89 04 24             	mov    %eax,(%esp)
    1e42:	e8 db f8 ff ff       	call   1722 <twakeup>
    1e47:	c9                   	leave  
    1e48:	c3                   	ret    

00001e49 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1e49:	55                   	push   %ebp
    1e4a:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1e4c:	8b 45 08             	mov    0x8(%ebp),%eax
    1e4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1e55:	8b 45 08             	mov    0x8(%ebp),%eax
    1e58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1e5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1e69:	5d                   	pop    %ebp
    1e6a:	c3                   	ret    

00001e6b <add_q>:

void add_q(struct queue *q, int v){
    1e6b:	55                   	push   %ebp
    1e6c:	89 e5                	mov    %esp,%ebp
    1e6e:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1e71:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1e78:	e8 89 fc ff ff       	call   1b06 <malloc>
    1e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1e90:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1e92:	8b 45 08             	mov    0x8(%ebp),%eax
    1e95:	8b 40 04             	mov    0x4(%eax),%eax
    1e98:	85 c0                	test   %eax,%eax
    1e9a:	75 0b                	jne    1ea7 <add_q+0x3c>
        q->head = n;
    1e9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ea2:	89 50 04             	mov    %edx,0x4(%eax)
    1ea5:	eb 0c                	jmp    1eb3 <add_q+0x48>
    }else{
        q->tail->next = n;
    1ea7:	8b 45 08             	mov    0x8(%ebp),%eax
    1eaa:	8b 40 08             	mov    0x8(%eax),%eax
    1ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1eb0:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1eb3:	8b 45 08             	mov    0x8(%ebp),%eax
    1eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1eb9:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1ebc:	8b 45 08             	mov    0x8(%ebp),%eax
    1ebf:	8b 00                	mov    (%eax),%eax
    1ec1:	8d 50 01             	lea    0x1(%eax),%edx
    1ec4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ec7:	89 10                	mov    %edx,(%eax)
}
    1ec9:	c9                   	leave  
    1eca:	c3                   	ret    

00001ecb <empty_q>:

int empty_q(struct queue *q){
    1ecb:	55                   	push   %ebp
    1ecc:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1ece:	8b 45 08             	mov    0x8(%ebp),%eax
    1ed1:	8b 00                	mov    (%eax),%eax
    1ed3:	85 c0                	test   %eax,%eax
    1ed5:	75 07                	jne    1ede <empty_q+0x13>
        return 1;
    1ed7:	b8 01 00 00 00       	mov    $0x1,%eax
    1edc:	eb 05                	jmp    1ee3 <empty_q+0x18>
    else
        return 0;
    1ede:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1ee3:	5d                   	pop    %ebp
    1ee4:	c3                   	ret    

00001ee5 <pop_q>:
int pop_q(struct queue *q){
    1ee5:	55                   	push   %ebp
    1ee6:	89 e5                	mov    %esp,%ebp
    1ee8:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1eeb:	8b 45 08             	mov    0x8(%ebp),%eax
    1eee:	89 04 24             	mov    %eax,(%esp)
    1ef1:	e8 d5 ff ff ff       	call   1ecb <empty_q>
    1ef6:	85 c0                	test   %eax,%eax
    1ef8:	75 5d                	jne    1f57 <pop_q+0x72>
       val = q->head->value; 
    1efa:	8b 45 08             	mov    0x8(%ebp),%eax
    1efd:	8b 40 04             	mov    0x4(%eax),%eax
    1f00:	8b 00                	mov    (%eax),%eax
    1f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1f05:	8b 45 08             	mov    0x8(%ebp),%eax
    1f08:	8b 40 04             	mov    0x4(%eax),%eax
    1f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1f0e:	8b 45 08             	mov    0x8(%ebp),%eax
    1f11:	8b 40 04             	mov    0x4(%eax),%eax
    1f14:	8b 50 04             	mov    0x4(%eax),%edx
    1f17:	8b 45 08             	mov    0x8(%ebp),%eax
    1f1a:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1f20:	89 04 24             	mov    %eax,(%esp)
    1f23:	e8 a5 fa ff ff       	call   19cd <free>
       q->size--;
    1f28:	8b 45 08             	mov    0x8(%ebp),%eax
    1f2b:	8b 00                	mov    (%eax),%eax
    1f2d:	8d 50 ff             	lea    -0x1(%eax),%edx
    1f30:	8b 45 08             	mov    0x8(%ebp),%eax
    1f33:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1f35:	8b 45 08             	mov    0x8(%ebp),%eax
    1f38:	8b 00                	mov    (%eax),%eax
    1f3a:	85 c0                	test   %eax,%eax
    1f3c:	75 14                	jne    1f52 <pop_q+0x6d>
            q->head = 0;
    1f3e:	8b 45 08             	mov    0x8(%ebp),%eax
    1f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1f48:	8b 45 08             	mov    0x8(%ebp),%eax
    1f4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f55:	eb 05                	jmp    1f5c <pop_q+0x77>
    }
    return -1;
    1f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1f5c:	c9                   	leave  
    1f5d:	c3                   	ret    
