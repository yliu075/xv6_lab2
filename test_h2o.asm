
_test_h2o:     file format elf32-i386


Disassembly of section .text:

00001000 <sema_init>:

//#include "user.h"
#include "semaphore.h"

//void sem_init(struct semaphore *s, uint newVal) {
void sema_init(struct semaphore *s) {
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  /*s->val = newVal;
  s->locked = 0;*/
  lock_init(&s->lock);
    1006:	8b 45 08             	mov    0x8(%ebp),%eax
    1009:	89 04 24             	mov    %eax,(%esp)
    100c:	e8 8f 0a 00 00       	call   1aa0 <lock_init>
  s->count = 0;
    1011:	8b 45 08             	mov    0x8(%ebp),%eax
    1014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  init_q(&s->q);
    101b:	8b 45 08             	mov    0x8(%ebp),%eax
    101e:	83 c0 08             	add    $0x8,%eax
    1021:	89 04 24             	mov    %eax,(%esp)
    1024:	e8 a5 0c 00 00       	call   1cce <init_q>
}
    1029:	c9                   	leave  
    102a:	c3                   	ret    

0000102b <sema_acquire>:
void sema_acquire(struct semaphore *s) {
    102b:	55                   	push   %ebp
    102c:	89 e5                	mov    %esp,%ebp
    102e:	83 ec 18             	sub    $0x18,%esp
          s->val--;
        break;
    }
    xchg(&s->locked, 0);
  }*/
  lock_acquire(&(s->lock));
    1031:	8b 45 08             	mov    0x8(%ebp),%eax
    1034:	89 04 24             	mov    %eax,(%esp)
    1037:	e8 72 0a 00 00       	call   1aae <lock_acquire>
  if(s->count <= 0){
    103c:	8b 45 08             	mov    0x8(%ebp),%eax
    103f:	8b 40 04             	mov    0x4(%eax),%eax
    1042:	85 c0                	test   %eax,%eax
    1044:	7f 29                	jg     106f <sema_acquire+0x44>
      add_q(&(s->q),getpid());
    1046:	e8 3f 05 00 00       	call   158a <getpid>
    104b:	8b 55 08             	mov    0x8(%ebp),%edx
    104e:	83 c2 08             	add    $0x8,%edx
    1051:	89 44 24 04          	mov    %eax,0x4(%esp)
    1055:	89 14 24             	mov    %edx,(%esp)
    1058:	e8 93 0c 00 00       	call   1cf0 <add_q>
      lock_release(&s->lock);
    105d:	8b 45 08             	mov    0x8(%ebp),%eax
    1060:	89 04 24             	mov    %eax,(%esp)
    1063:	e8 66 0a 00 00       	call   1ace <lock_release>
      tsleep();
    1068:	e8 4d 05 00 00       	call   15ba <tsleep>
    106d:	eb 1a                	jmp    1089 <sema_acquire+0x5e>
  }else{
      s->count--;
    106f:	8b 45 08             	mov    0x8(%ebp),%eax
    1072:	8b 40 04             	mov    0x4(%eax),%eax
    1075:	8d 50 ff             	lea    -0x1(%eax),%edx
    1078:	8b 45 08             	mov    0x8(%ebp),%eax
    107b:	89 50 04             	mov    %edx,0x4(%eax)
      lock_release(&s->lock);
    107e:	8b 45 08             	mov    0x8(%ebp),%eax
    1081:	89 04 24             	mov    %eax,(%esp)
    1084:	e8 45 0a 00 00       	call   1ace <lock_release>
  }
}
    1089:	c9                   	leave  
    108a:	c3                   	ret    

0000108b <sema_signal>:
void sema_signal(struct semaphore *s) {
    108b:	55                   	push   %ebp
    108c:	89 e5                	mov    %esp,%ebp
    108e:	83 ec 28             	sub    $0x28,%esp
  /*while(xchg(&s->locked, 1) ! = 0);
  s->val++;

  xchg(&s->locked, 0);*/
  lock_acquire(&s->lock);
    1091:	8b 45 08             	mov    0x8(%ebp),%eax
    1094:	89 04 24             	mov    %eax,(%esp)
    1097:	e8 12 0a 00 00       	call   1aae <lock_acquire>
  if(empty_q(&s->q)){
    109c:	8b 45 08             	mov    0x8(%ebp),%eax
    109f:	83 c0 08             	add    $0x8,%eax
    10a2:	89 04 24             	mov    %eax,(%esp)
    10a5:	e8 a6 0c 00 00       	call   1d50 <empty_q>
    10aa:	85 c0                	test   %eax,%eax
    10ac:	74 11                	je     10bf <sema_signal+0x34>
      s->count++;
    10ae:	8b 45 08             	mov    0x8(%ebp),%eax
    10b1:	8b 40 04             	mov    0x4(%eax),%eax
    10b4:	8d 50 01             	lea    0x1(%eax),%edx
    10b7:	8b 45 08             	mov    0x8(%ebp),%eax
    10ba:	89 50 04             	mov    %edx,0x4(%eax)
    10bd:	eb 1c                	jmp    10db <sema_signal+0x50>
  }else{
      int tid = pop_q(&s->q);
    10bf:	8b 45 08             	mov    0x8(%ebp),%eax
    10c2:	83 c0 08             	add    $0x8,%eax
    10c5:	89 04 24             	mov    %eax,(%esp)
    10c8:	e8 9d 0c 00 00       	call   1d6a <pop_q>
    10cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      twakeup(tid);
    10d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d3:	89 04 24             	mov    %eax,(%esp)
    10d6:	e8 e7 04 00 00       	call   15c2 <twakeup>
  }
  lock_release(&s->lock);
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	89 04 24             	mov    %eax,(%esp)
    10e1:	e8 e8 09 00 00       	call   1ace <lock_release>
}
    10e6:	c9                   	leave  
    10e7:	c3                   	ret    

000010e8 <main>:

void test_func(void *arg_ptr);
void ping(void *arg_ptr);
void pong(void *arg_ptr);

int main(int argc, char *argv[]){
    10e8:	55                   	push   %ebp
    10e9:	89 e5                	mov    %esp,%ebp
    10eb:	83 e4 f0             	and    $0xfffffff0,%esp
    10ee:	83 ec 20             	sub    $0x20,%esp

    int arg = 10;
    10f1:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
    10f8:	00 
    sema_init(h);
    10f9:	a1 48 24 00 00       	mov    0x2448,%eax
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 fa fe ff ff       	call   1000 <sema_init>
    //thread_create(ping, (void *)&arg);
    //thread_create(pong, (void *)&arg);
    
    void *tid = thread_create(ping, (void *)&arg);
    1106:	8d 44 24 18          	lea    0x18(%esp),%eax
    110a:	89 44 24 04          	mov    %eax,0x4(%esp)
    110e:	c7 04 24 06 12 00 00 	movl   $0x1206,(%esp)
    1115:	e8 cf 09 00 00       	call   1ae9 <thread_create>
    111a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    printf(1,"Thread Created 1\n");
    111e:	c7 44 24 04 e3 1d 00 	movl   $0x1de3,0x4(%esp)
    1125:	00 
    1126:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112d:	e8 88 05 00 00       	call   16ba <printf>
    if(tid <= 0){
    1132:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1137:	75 19                	jne    1152 <main+0x6a>
        printf(1,"wrong happen\n");
    1139:	c7 44 24 04 f5 1d 00 	movl   $0x1df5,0x4(%esp)
    1140:	00 
    1141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1148:	e8 6d 05 00 00       	call   16ba <printf>
        exit();
    114d:	e8 b8 03 00 00       	call   150a <exit>
    } 
    tid = thread_create(pong, (void *)&arg);
    1152:	8d 44 24 18          	lea    0x18(%esp),%eax
    1156:	89 44 24 04          	mov    %eax,0x4(%esp)
    115a:	c7 04 24 54 12 00 00 	movl   $0x1254,(%esp)
    1161:	e8 83 09 00 00       	call   1ae9 <thread_create>
    1166:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    printf(1,"Thread Created 2\n");
    116a:	c7 44 24 04 03 1e 00 	movl   $0x1e03,0x4(%esp)
    1171:	00 
    1172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1179:	e8 3c 05 00 00       	call   16ba <printf>
    if(tid <= 0){
    117e:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1183:	75 19                	jne    119e <main+0xb6>
        printf(1,"wrong happen\n");
    1185:	c7 44 24 04 f5 1d 00 	movl   $0x1df5,0x4(%esp)
    118c:	00 
    118d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1194:	e8 21 05 00 00       	call   16ba <printf>
        exit();
    1199:	e8 6c 03 00 00       	call   150a <exit>
    } 
    
    
    printf(1,"Going to Wait\n");
    119e:	c7 44 24 04 15 1e 00 	movl   $0x1e15,0x4(%esp)
    11a5:	00 
    11a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ad:	e8 08 05 00 00       	call   16ba <printf>
    wait();
    11b2:	e8 5b 03 00 00       	call   1512 <wait>
    printf(1,"Waited 1\n");
    11b7:	c7 44 24 04 24 1e 00 	movl   $0x1e24,0x4(%esp)
    11be:	00 
    11bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c6:	e8 ef 04 00 00       	call   16ba <printf>
    thread_yield_last();
    11cb:	e8 db 0a 00 00       	call   1cab <thread_yield_last>
    wait();
    11d0:	e8 3d 03 00 00       	call   1512 <wait>
    printf(1,"Waited 2\n");
    11d5:	c7 44 24 04 2e 1e 00 	movl   $0x1e2e,0x4(%esp)
    11dc:	00 
    11dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11e4:	e8 d1 04 00 00       	call   16ba <printf>
    
    exit();
    11e9:	e8 1c 03 00 00       	call   150a <exit>

000011ee <test_func>:
}

void test_func(void *arg_ptr){
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
    11f4:	a1 f8 22 00 00       	mov    0x22f8,%eax
    11f9:	83 c0 01             	add    $0x1,%eax
    11fc:	a3 f8 22 00 00       	mov    %eax,0x22f8
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
    1201:	e8 ac 03 00 00       	call   15b2 <texit>

00001206 <ping>:
}

void ping(void *arg_ptr){
    1206:	55                   	push   %ebp
    1207:	89 e5                	mov    %esp,%ebp
    1209:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    1212:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1215:	8b 00                	mov    (%eax),%eax
    1217:	a3 f8 22 00 00       	mov    %eax,0x22f8
    int i = 0;
    121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    1223:	eb 24                	jmp    1249 <ping+0x43>
    // while(1) {
        printf(1,"Ping %d \n",i);
    1225:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1228:	89 44 24 08          	mov    %eax,0x8(%esp)
    122c:	c7 44 24 04 38 1e 00 	movl   $0x1e38,0x4(%esp)
    1233:	00 
    1234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    123b:	e8 7a 04 00 00       	call   16ba <printf>
        thread_yield2();
    1240:	e8 da 09 00 00       	call   1c1f <thread_yield2>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    1245:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1249:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    124d:	7e d6                	jle    1225 <ping+0x1f>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    124f:	e8 5e 03 00 00       	call   15b2 <texit>

00001254 <pong>:
}
void pong(void *arg_ptr){
    1254:	55                   	push   %ebp
    1255:	89 e5                	mov    %esp,%ebp
    1257:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    1260:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1263:	8b 00                	mov    (%eax),%eax
    1265:	a3 f8 22 00 00       	mov    %eax,0x22f8
    int i = 0;
    126a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    1271:	eb 24                	jmp    1297 <pong+0x43>
    // while(1) {
        printf(1,"Pong %d \n",i);
    1273:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1276:	89 44 24 08          	mov    %eax,0x8(%esp)
    127a:	c7 44 24 04 42 1e 00 	movl   $0x1e42,0x4(%esp)
    1281:	00 
    1282:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1289:	e8 2c 04 00 00       	call   16ba <printf>
        thread_yield2();
    128e:	e8 8c 09 00 00       	call   1c1f <thread_yield2>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    1293:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1297:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    129b:	7e d6                	jle    1273 <pong+0x1f>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    129d:	e8 10 03 00 00       	call   15b2 <texit>

000012a2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    12a2:	55                   	push   %ebp
    12a3:	89 e5                	mov    %esp,%ebp
    12a5:	57                   	push   %edi
    12a6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    12a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
    12aa:	8b 55 10             	mov    0x10(%ebp),%edx
    12ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b0:	89 cb                	mov    %ecx,%ebx
    12b2:	89 df                	mov    %ebx,%edi
    12b4:	89 d1                	mov    %edx,%ecx
    12b6:	fc                   	cld    
    12b7:	f3 aa                	rep stos %al,%es:(%edi)
    12b9:	89 ca                	mov    %ecx,%edx
    12bb:	89 fb                	mov    %edi,%ebx
    12bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
    12c0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12c3:	5b                   	pop    %ebx
    12c4:	5f                   	pop    %edi
    12c5:	5d                   	pop    %ebp
    12c6:	c3                   	ret    

000012c7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12c7:	55                   	push   %ebp
    12c8:	89 e5                	mov    %esp,%ebp
    12ca:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    12cd:	8b 45 08             	mov    0x8(%ebp),%eax
    12d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    12d3:	90                   	nop
    12d4:	8b 45 08             	mov    0x8(%ebp),%eax
    12d7:	8d 50 01             	lea    0x1(%eax),%edx
    12da:	89 55 08             	mov    %edx,0x8(%ebp)
    12dd:	8b 55 0c             	mov    0xc(%ebp),%edx
    12e0:	8d 4a 01             	lea    0x1(%edx),%ecx
    12e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    12e6:	0f b6 12             	movzbl (%edx),%edx
    12e9:	88 10                	mov    %dl,(%eax)
    12eb:	0f b6 00             	movzbl (%eax),%eax
    12ee:	84 c0                	test   %al,%al
    12f0:	75 e2                	jne    12d4 <strcpy+0xd>
    ;
  return os;
    12f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12f5:	c9                   	leave  
    12f6:	c3                   	ret    

000012f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12f7:	55                   	push   %ebp
    12f8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    12fa:	eb 08                	jmp    1304 <strcmp+0xd>
    p++, q++;
    12fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1300:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1304:	8b 45 08             	mov    0x8(%ebp),%eax
    1307:	0f b6 00             	movzbl (%eax),%eax
    130a:	84 c0                	test   %al,%al
    130c:	74 10                	je     131e <strcmp+0x27>
    130e:	8b 45 08             	mov    0x8(%ebp),%eax
    1311:	0f b6 10             	movzbl (%eax),%edx
    1314:	8b 45 0c             	mov    0xc(%ebp),%eax
    1317:	0f b6 00             	movzbl (%eax),%eax
    131a:	38 c2                	cmp    %al,%dl
    131c:	74 de                	je     12fc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    131e:	8b 45 08             	mov    0x8(%ebp),%eax
    1321:	0f b6 00             	movzbl (%eax),%eax
    1324:	0f b6 d0             	movzbl %al,%edx
    1327:	8b 45 0c             	mov    0xc(%ebp),%eax
    132a:	0f b6 00             	movzbl (%eax),%eax
    132d:	0f b6 c0             	movzbl %al,%eax
    1330:	29 c2                	sub    %eax,%edx
    1332:	89 d0                	mov    %edx,%eax
}
    1334:	5d                   	pop    %ebp
    1335:	c3                   	ret    

00001336 <strlen>:

uint
strlen(char *s)
{
    1336:	55                   	push   %ebp
    1337:	89 e5                	mov    %esp,%ebp
    1339:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    133c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1343:	eb 04                	jmp    1349 <strlen+0x13>
    1345:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1349:	8b 55 fc             	mov    -0x4(%ebp),%edx
    134c:	8b 45 08             	mov    0x8(%ebp),%eax
    134f:	01 d0                	add    %edx,%eax
    1351:	0f b6 00             	movzbl (%eax),%eax
    1354:	84 c0                	test   %al,%al
    1356:	75 ed                	jne    1345 <strlen+0xf>
    ;
  return n;
    1358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    135b:	c9                   	leave  
    135c:	c3                   	ret    

0000135d <memset>:

void*
memset(void *dst, int c, uint n)
{
    135d:	55                   	push   %ebp
    135e:	89 e5                	mov    %esp,%ebp
    1360:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1363:	8b 45 10             	mov    0x10(%ebp),%eax
    1366:	89 44 24 08          	mov    %eax,0x8(%esp)
    136a:	8b 45 0c             	mov    0xc(%ebp),%eax
    136d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1371:	8b 45 08             	mov    0x8(%ebp),%eax
    1374:	89 04 24             	mov    %eax,(%esp)
    1377:	e8 26 ff ff ff       	call   12a2 <stosb>
  return dst;
    137c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    137f:	c9                   	leave  
    1380:	c3                   	ret    

00001381 <strchr>:

char*
strchr(const char *s, char c)
{
    1381:	55                   	push   %ebp
    1382:	89 e5                	mov    %esp,%ebp
    1384:	83 ec 04             	sub    $0x4,%esp
    1387:	8b 45 0c             	mov    0xc(%ebp),%eax
    138a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    138d:	eb 14                	jmp    13a3 <strchr+0x22>
    if(*s == c)
    138f:	8b 45 08             	mov    0x8(%ebp),%eax
    1392:	0f b6 00             	movzbl (%eax),%eax
    1395:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1398:	75 05                	jne    139f <strchr+0x1e>
      return (char*)s;
    139a:	8b 45 08             	mov    0x8(%ebp),%eax
    139d:	eb 13                	jmp    13b2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    139f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13a3:	8b 45 08             	mov    0x8(%ebp),%eax
    13a6:	0f b6 00             	movzbl (%eax),%eax
    13a9:	84 c0                	test   %al,%al
    13ab:	75 e2                	jne    138f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    13ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13b2:	c9                   	leave  
    13b3:	c3                   	ret    

000013b4 <gets>:

char*
gets(char *buf, int max)
{
    13b4:	55                   	push   %ebp
    13b5:	89 e5                	mov    %esp,%ebp
    13b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13c1:	eb 4c                	jmp    140f <gets+0x5b>
    cc = read(0, &c, 1);
    13c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13ca:	00 
    13cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
    13ce:	89 44 24 04          	mov    %eax,0x4(%esp)
    13d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    13d9:	e8 44 01 00 00       	call   1522 <read>
    13de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    13e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13e5:	7f 02                	jg     13e9 <gets+0x35>
      break;
    13e7:	eb 31                	jmp    141a <gets+0x66>
    buf[i++] = c;
    13e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ec:	8d 50 01             	lea    0x1(%eax),%edx
    13ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13f2:	89 c2                	mov    %eax,%edx
    13f4:	8b 45 08             	mov    0x8(%ebp),%eax
    13f7:	01 c2                	add    %eax,%edx
    13f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13fd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    13ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1403:	3c 0a                	cmp    $0xa,%al
    1405:	74 13                	je     141a <gets+0x66>
    1407:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    140b:	3c 0d                	cmp    $0xd,%al
    140d:	74 0b                	je     141a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    140f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1412:	83 c0 01             	add    $0x1,%eax
    1415:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1418:	7c a9                	jl     13c3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    141d:	8b 45 08             	mov    0x8(%ebp),%eax
    1420:	01 d0                	add    %edx,%eax
    1422:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1425:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1428:	c9                   	leave  
    1429:	c3                   	ret    

0000142a <stat>:

int
stat(char *n, struct stat *st)
{
    142a:	55                   	push   %ebp
    142b:	89 e5                	mov    %esp,%ebp
    142d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1430:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1437:	00 
    1438:	8b 45 08             	mov    0x8(%ebp),%eax
    143b:	89 04 24             	mov    %eax,(%esp)
    143e:	e8 07 01 00 00       	call   154a <open>
    1443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    144a:	79 07                	jns    1453 <stat+0x29>
    return -1;
    144c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1451:	eb 23                	jmp    1476 <stat+0x4c>
  r = fstat(fd, st);
    1453:	8b 45 0c             	mov    0xc(%ebp),%eax
    1456:	89 44 24 04          	mov    %eax,0x4(%esp)
    145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145d:	89 04 24             	mov    %eax,(%esp)
    1460:	e8 fd 00 00 00       	call   1562 <fstat>
    1465:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1468:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146b:	89 04 24             	mov    %eax,(%esp)
    146e:	e8 bf 00 00 00       	call   1532 <close>
  return r;
    1473:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1476:	c9                   	leave  
    1477:	c3                   	ret    

00001478 <atoi>:

int
atoi(const char *s)
{
    1478:	55                   	push   %ebp
    1479:	89 e5                	mov    %esp,%ebp
    147b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    147e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1485:	eb 25                	jmp    14ac <atoi+0x34>
    n = n*10 + *s++ - '0';
    1487:	8b 55 fc             	mov    -0x4(%ebp),%edx
    148a:	89 d0                	mov    %edx,%eax
    148c:	c1 e0 02             	shl    $0x2,%eax
    148f:	01 d0                	add    %edx,%eax
    1491:	01 c0                	add    %eax,%eax
    1493:	89 c1                	mov    %eax,%ecx
    1495:	8b 45 08             	mov    0x8(%ebp),%eax
    1498:	8d 50 01             	lea    0x1(%eax),%edx
    149b:	89 55 08             	mov    %edx,0x8(%ebp)
    149e:	0f b6 00             	movzbl (%eax),%eax
    14a1:	0f be c0             	movsbl %al,%eax
    14a4:	01 c8                	add    %ecx,%eax
    14a6:	83 e8 30             	sub    $0x30,%eax
    14a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    14ac:	8b 45 08             	mov    0x8(%ebp),%eax
    14af:	0f b6 00             	movzbl (%eax),%eax
    14b2:	3c 2f                	cmp    $0x2f,%al
    14b4:	7e 0a                	jle    14c0 <atoi+0x48>
    14b6:	8b 45 08             	mov    0x8(%ebp),%eax
    14b9:	0f b6 00             	movzbl (%eax),%eax
    14bc:	3c 39                	cmp    $0x39,%al
    14be:	7e c7                	jle    1487 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    14c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14c3:	c9                   	leave  
    14c4:	c3                   	ret    

000014c5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14c5:	55                   	push   %ebp
    14c6:	89 e5                	mov    %esp,%ebp
    14c8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    14cb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    14d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    14d7:	eb 17                	jmp    14f0 <memmove+0x2b>
    *dst++ = *src++;
    14d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14dc:	8d 50 01             	lea    0x1(%eax),%edx
    14df:	89 55 fc             	mov    %edx,-0x4(%ebp)
    14e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    14e5:	8d 4a 01             	lea    0x1(%edx),%ecx
    14e8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    14eb:	0f b6 12             	movzbl (%edx),%edx
    14ee:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    14f0:	8b 45 10             	mov    0x10(%ebp),%eax
    14f3:	8d 50 ff             	lea    -0x1(%eax),%edx
    14f6:	89 55 10             	mov    %edx,0x10(%ebp)
    14f9:	85 c0                	test   %eax,%eax
    14fb:	7f dc                	jg     14d9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    14fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1500:	c9                   	leave  
    1501:	c3                   	ret    

00001502 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1502:	b8 01 00 00 00       	mov    $0x1,%eax
    1507:	cd 40                	int    $0x40
    1509:	c3                   	ret    

0000150a <exit>:
SYSCALL(exit)
    150a:	b8 02 00 00 00       	mov    $0x2,%eax
    150f:	cd 40                	int    $0x40
    1511:	c3                   	ret    

00001512 <wait>:
SYSCALL(wait)
    1512:	b8 03 00 00 00       	mov    $0x3,%eax
    1517:	cd 40                	int    $0x40
    1519:	c3                   	ret    

0000151a <pipe>:
SYSCALL(pipe)
    151a:	b8 04 00 00 00       	mov    $0x4,%eax
    151f:	cd 40                	int    $0x40
    1521:	c3                   	ret    

00001522 <read>:
SYSCALL(read)
    1522:	b8 05 00 00 00       	mov    $0x5,%eax
    1527:	cd 40                	int    $0x40
    1529:	c3                   	ret    

0000152a <write>:
SYSCALL(write)
    152a:	b8 10 00 00 00       	mov    $0x10,%eax
    152f:	cd 40                	int    $0x40
    1531:	c3                   	ret    

00001532 <close>:
SYSCALL(close)
    1532:	b8 15 00 00 00       	mov    $0x15,%eax
    1537:	cd 40                	int    $0x40
    1539:	c3                   	ret    

0000153a <kill>:
SYSCALL(kill)
    153a:	b8 06 00 00 00       	mov    $0x6,%eax
    153f:	cd 40                	int    $0x40
    1541:	c3                   	ret    

00001542 <exec>:
SYSCALL(exec)
    1542:	b8 07 00 00 00       	mov    $0x7,%eax
    1547:	cd 40                	int    $0x40
    1549:	c3                   	ret    

0000154a <open>:
SYSCALL(open)
    154a:	b8 0f 00 00 00       	mov    $0xf,%eax
    154f:	cd 40                	int    $0x40
    1551:	c3                   	ret    

00001552 <mknod>:
SYSCALL(mknod)
    1552:	b8 11 00 00 00       	mov    $0x11,%eax
    1557:	cd 40                	int    $0x40
    1559:	c3                   	ret    

0000155a <unlink>:
SYSCALL(unlink)
    155a:	b8 12 00 00 00       	mov    $0x12,%eax
    155f:	cd 40                	int    $0x40
    1561:	c3                   	ret    

00001562 <fstat>:
SYSCALL(fstat)
    1562:	b8 08 00 00 00       	mov    $0x8,%eax
    1567:	cd 40                	int    $0x40
    1569:	c3                   	ret    

0000156a <link>:
SYSCALL(link)
    156a:	b8 13 00 00 00       	mov    $0x13,%eax
    156f:	cd 40                	int    $0x40
    1571:	c3                   	ret    

00001572 <mkdir>:
SYSCALL(mkdir)
    1572:	b8 14 00 00 00       	mov    $0x14,%eax
    1577:	cd 40                	int    $0x40
    1579:	c3                   	ret    

0000157a <chdir>:
SYSCALL(chdir)
    157a:	b8 09 00 00 00       	mov    $0x9,%eax
    157f:	cd 40                	int    $0x40
    1581:	c3                   	ret    

00001582 <dup>:
SYSCALL(dup)
    1582:	b8 0a 00 00 00       	mov    $0xa,%eax
    1587:	cd 40                	int    $0x40
    1589:	c3                   	ret    

0000158a <getpid>:
SYSCALL(getpid)
    158a:	b8 0b 00 00 00       	mov    $0xb,%eax
    158f:	cd 40                	int    $0x40
    1591:	c3                   	ret    

00001592 <sbrk>:
SYSCALL(sbrk)
    1592:	b8 0c 00 00 00       	mov    $0xc,%eax
    1597:	cd 40                	int    $0x40
    1599:	c3                   	ret    

0000159a <sleep>:
SYSCALL(sleep)
    159a:	b8 0d 00 00 00       	mov    $0xd,%eax
    159f:	cd 40                	int    $0x40
    15a1:	c3                   	ret    

000015a2 <uptime>:
SYSCALL(uptime)
    15a2:	b8 0e 00 00 00       	mov    $0xe,%eax
    15a7:	cd 40                	int    $0x40
    15a9:	c3                   	ret    

000015aa <clone>:
SYSCALL(clone)
    15aa:	b8 16 00 00 00       	mov    $0x16,%eax
    15af:	cd 40                	int    $0x40
    15b1:	c3                   	ret    

000015b2 <texit>:
SYSCALL(texit)
    15b2:	b8 17 00 00 00       	mov    $0x17,%eax
    15b7:	cd 40                	int    $0x40
    15b9:	c3                   	ret    

000015ba <tsleep>:
SYSCALL(tsleep)
    15ba:	b8 18 00 00 00       	mov    $0x18,%eax
    15bf:	cd 40                	int    $0x40
    15c1:	c3                   	ret    

000015c2 <twakeup>:
SYSCALL(twakeup)
    15c2:	b8 19 00 00 00       	mov    $0x19,%eax
    15c7:	cd 40                	int    $0x40
    15c9:	c3                   	ret    

000015ca <thread_yield>:
SYSCALL(thread_yield)
    15ca:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15cf:	cd 40                	int    $0x40
    15d1:	c3                   	ret    

000015d2 <thread_yield3>:
    15d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15d7:	cd 40                	int    $0x40
    15d9:	c3                   	ret    

000015da <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    15da:	55                   	push   %ebp
    15db:	89 e5                	mov    %esp,%ebp
    15dd:	83 ec 18             	sub    $0x18,%esp
    15e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    15e3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    15e6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15ed:	00 
    15ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
    15f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f5:	8b 45 08             	mov    0x8(%ebp),%eax
    15f8:	89 04 24             	mov    %eax,(%esp)
    15fb:	e8 2a ff ff ff       	call   152a <write>
}
    1600:	c9                   	leave  
    1601:	c3                   	ret    

00001602 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1602:	55                   	push   %ebp
    1603:	89 e5                	mov    %esp,%ebp
    1605:	56                   	push   %esi
    1606:	53                   	push   %ebx
    1607:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    160a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1611:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1615:	74 17                	je     162e <printint+0x2c>
    1617:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    161b:	79 11                	jns    162e <printint+0x2c>
    neg = 1;
    161d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1624:	8b 45 0c             	mov    0xc(%ebp),%eax
    1627:	f7 d8                	neg    %eax
    1629:	89 45 ec             	mov    %eax,-0x14(%ebp)
    162c:	eb 06                	jmp    1634 <printint+0x32>
  } else {
    x = xx;
    162e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1631:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    163b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    163e:	8d 41 01             	lea    0x1(%ecx),%eax
    1641:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1644:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1647:	8b 45 ec             	mov    -0x14(%ebp),%eax
    164a:	ba 00 00 00 00       	mov    $0x0,%edx
    164f:	f7 f3                	div    %ebx
    1651:	89 d0                	mov    %edx,%eax
    1653:	0f b6 80 fc 22 00 00 	movzbl 0x22fc(%eax),%eax
    165a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    165e:	8b 75 10             	mov    0x10(%ebp),%esi
    1661:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1664:	ba 00 00 00 00       	mov    $0x0,%edx
    1669:	f7 f6                	div    %esi
    166b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    166e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1672:	75 c7                	jne    163b <printint+0x39>
  if(neg)
    1674:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1678:	74 10                	je     168a <printint+0x88>
    buf[i++] = '-';
    167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167d:	8d 50 01             	lea    0x1(%eax),%edx
    1680:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1683:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1688:	eb 1f                	jmp    16a9 <printint+0xa7>
    168a:	eb 1d                	jmp    16a9 <printint+0xa7>
    putc(fd, buf[i]);
    168c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1692:	01 d0                	add    %edx,%eax
    1694:	0f b6 00             	movzbl (%eax),%eax
    1697:	0f be c0             	movsbl %al,%eax
    169a:	89 44 24 04          	mov    %eax,0x4(%esp)
    169e:	8b 45 08             	mov    0x8(%ebp),%eax
    16a1:	89 04 24             	mov    %eax,(%esp)
    16a4:	e8 31 ff ff ff       	call   15da <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    16a9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    16ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16b1:	79 d9                	jns    168c <printint+0x8a>
    putc(fd, buf[i]);
}
    16b3:	83 c4 30             	add    $0x30,%esp
    16b6:	5b                   	pop    %ebx
    16b7:	5e                   	pop    %esi
    16b8:	5d                   	pop    %ebp
    16b9:	c3                   	ret    

000016ba <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    16ba:	55                   	push   %ebp
    16bb:	89 e5                	mov    %esp,%ebp
    16bd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    16c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    16c7:	8d 45 0c             	lea    0xc(%ebp),%eax
    16ca:	83 c0 04             	add    $0x4,%eax
    16cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    16d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    16d7:	e9 7c 01 00 00       	jmp    1858 <printf+0x19e>
    c = fmt[i] & 0xff;
    16dc:	8b 55 0c             	mov    0xc(%ebp),%edx
    16df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e2:	01 d0                	add    %edx,%eax
    16e4:	0f b6 00             	movzbl (%eax),%eax
    16e7:	0f be c0             	movsbl %al,%eax
    16ea:	25 ff 00 00 00       	and    $0xff,%eax
    16ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    16f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16f6:	75 2c                	jne    1724 <printf+0x6a>
      if(c == '%'){
    16f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16fc:	75 0c                	jne    170a <printf+0x50>
        state = '%';
    16fe:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1705:	e9 4a 01 00 00       	jmp    1854 <printf+0x19a>
      } else {
        putc(fd, c);
    170a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    170d:	0f be c0             	movsbl %al,%eax
    1710:	89 44 24 04          	mov    %eax,0x4(%esp)
    1714:	8b 45 08             	mov    0x8(%ebp),%eax
    1717:	89 04 24             	mov    %eax,(%esp)
    171a:	e8 bb fe ff ff       	call   15da <putc>
    171f:	e9 30 01 00 00       	jmp    1854 <printf+0x19a>
      }
    } else if(state == '%'){
    1724:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1728:	0f 85 26 01 00 00    	jne    1854 <printf+0x19a>
      if(c == 'd'){
    172e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1732:	75 2d                	jne    1761 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1734:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1737:	8b 00                	mov    (%eax),%eax
    1739:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1740:	00 
    1741:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1748:	00 
    1749:	89 44 24 04          	mov    %eax,0x4(%esp)
    174d:	8b 45 08             	mov    0x8(%ebp),%eax
    1750:	89 04 24             	mov    %eax,(%esp)
    1753:	e8 aa fe ff ff       	call   1602 <printint>
        ap++;
    1758:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    175c:	e9 ec 00 00 00       	jmp    184d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1761:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1765:	74 06                	je     176d <printf+0xb3>
    1767:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    176b:	75 2d                	jne    179a <printf+0xe0>
        printint(fd, *ap, 16, 0);
    176d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1770:	8b 00                	mov    (%eax),%eax
    1772:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1779:	00 
    177a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1781:	00 
    1782:	89 44 24 04          	mov    %eax,0x4(%esp)
    1786:	8b 45 08             	mov    0x8(%ebp),%eax
    1789:	89 04 24             	mov    %eax,(%esp)
    178c:	e8 71 fe ff ff       	call   1602 <printint>
        ap++;
    1791:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1795:	e9 b3 00 00 00       	jmp    184d <printf+0x193>
      } else if(c == 's'){
    179a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    179e:	75 45                	jne    17e5 <printf+0x12b>
        s = (char*)*ap;
    17a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17a3:	8b 00                	mov    (%eax),%eax
    17a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    17a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    17ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17b0:	75 09                	jne    17bb <printf+0x101>
          s = "(null)";
    17b2:	c7 45 f4 4c 1e 00 00 	movl   $0x1e4c,-0xc(%ebp)
        while(*s != 0){
    17b9:	eb 1e                	jmp    17d9 <printf+0x11f>
    17bb:	eb 1c                	jmp    17d9 <printf+0x11f>
          putc(fd, *s);
    17bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c0:	0f b6 00             	movzbl (%eax),%eax
    17c3:	0f be c0             	movsbl %al,%eax
    17c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    17ca:	8b 45 08             	mov    0x8(%ebp),%eax
    17cd:	89 04 24             	mov    %eax,(%esp)
    17d0:	e8 05 fe ff ff       	call   15da <putc>
          s++;
    17d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    17d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17dc:	0f b6 00             	movzbl (%eax),%eax
    17df:	84 c0                	test   %al,%al
    17e1:	75 da                	jne    17bd <printf+0x103>
    17e3:	eb 68                	jmp    184d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    17e5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    17e9:	75 1d                	jne    1808 <printf+0x14e>
        putc(fd, *ap);
    17eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17ee:	8b 00                	mov    (%eax),%eax
    17f0:	0f be c0             	movsbl %al,%eax
    17f3:	89 44 24 04          	mov    %eax,0x4(%esp)
    17f7:	8b 45 08             	mov    0x8(%ebp),%eax
    17fa:	89 04 24             	mov    %eax,(%esp)
    17fd:	e8 d8 fd ff ff       	call   15da <putc>
        ap++;
    1802:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1806:	eb 45                	jmp    184d <printf+0x193>
      } else if(c == '%'){
    1808:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    180c:	75 17                	jne    1825 <printf+0x16b>
        putc(fd, c);
    180e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1811:	0f be c0             	movsbl %al,%eax
    1814:	89 44 24 04          	mov    %eax,0x4(%esp)
    1818:	8b 45 08             	mov    0x8(%ebp),%eax
    181b:	89 04 24             	mov    %eax,(%esp)
    181e:	e8 b7 fd ff ff       	call   15da <putc>
    1823:	eb 28                	jmp    184d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1825:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    182c:	00 
    182d:	8b 45 08             	mov    0x8(%ebp),%eax
    1830:	89 04 24             	mov    %eax,(%esp)
    1833:	e8 a2 fd ff ff       	call   15da <putc>
        putc(fd, c);
    1838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    183b:	0f be c0             	movsbl %al,%eax
    183e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1842:	8b 45 08             	mov    0x8(%ebp),%eax
    1845:	89 04 24             	mov    %eax,(%esp)
    1848:	e8 8d fd ff ff       	call   15da <putc>
      }
      state = 0;
    184d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1854:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1858:	8b 55 0c             	mov    0xc(%ebp),%edx
    185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185e:	01 d0                	add    %edx,%eax
    1860:	0f b6 00             	movzbl (%eax),%eax
    1863:	84 c0                	test   %al,%al
    1865:	0f 85 71 fe ff ff    	jne    16dc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    186b:	c9                   	leave  
    186c:	c3                   	ret    

0000186d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    186d:	55                   	push   %ebp
    186e:	89 e5                	mov    %esp,%ebp
    1870:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1873:	8b 45 08             	mov    0x8(%ebp),%eax
    1876:	83 e8 08             	sub    $0x8,%eax
    1879:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    187c:	a1 28 23 00 00       	mov    0x2328,%eax
    1881:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1884:	eb 24                	jmp    18aa <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1886:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1889:	8b 00                	mov    (%eax),%eax
    188b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    188e:	77 12                	ja     18a2 <free+0x35>
    1890:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1893:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1896:	77 24                	ja     18bc <free+0x4f>
    1898:	8b 45 fc             	mov    -0x4(%ebp),%eax
    189b:	8b 00                	mov    (%eax),%eax
    189d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18a0:	77 1a                	ja     18bc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18a5:	8b 00                	mov    (%eax),%eax
    18a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18b0:	76 d4                	jbe    1886 <free+0x19>
    18b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18b5:	8b 00                	mov    (%eax),%eax
    18b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18ba:	76 ca                	jbe    1886 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    18bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18bf:	8b 40 04             	mov    0x4(%eax),%eax
    18c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    18c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18cc:	01 c2                	add    %eax,%edx
    18ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18d1:	8b 00                	mov    (%eax),%eax
    18d3:	39 c2                	cmp    %eax,%edx
    18d5:	75 24                	jne    18fb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    18d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18da:	8b 50 04             	mov    0x4(%eax),%edx
    18dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e0:	8b 00                	mov    (%eax),%eax
    18e2:	8b 40 04             	mov    0x4(%eax),%eax
    18e5:	01 c2                	add    %eax,%edx
    18e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ea:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    18ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f0:	8b 00                	mov    (%eax),%eax
    18f2:	8b 10                	mov    (%eax),%edx
    18f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18f7:	89 10                	mov    %edx,(%eax)
    18f9:	eb 0a                	jmp    1905 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    18fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18fe:	8b 10                	mov    (%eax),%edx
    1900:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1903:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1905:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1908:	8b 40 04             	mov    0x4(%eax),%eax
    190b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1912:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1915:	01 d0                	add    %edx,%eax
    1917:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    191a:	75 20                	jne    193c <free+0xcf>
    p->s.size += bp->s.size;
    191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    191f:	8b 50 04             	mov    0x4(%eax),%edx
    1922:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1925:	8b 40 04             	mov    0x4(%eax),%eax
    1928:	01 c2                	add    %eax,%edx
    192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1930:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1933:	8b 10                	mov    (%eax),%edx
    1935:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1938:	89 10                	mov    %edx,(%eax)
    193a:	eb 08                	jmp    1944 <free+0xd7>
  } else
    p->s.ptr = bp;
    193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    193f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1942:	89 10                	mov    %edx,(%eax)
  freep = p;
    1944:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1947:	a3 28 23 00 00       	mov    %eax,0x2328
}
    194c:	c9                   	leave  
    194d:	c3                   	ret    

0000194e <morecore>:

static Header*
morecore(uint nu)
{
    194e:	55                   	push   %ebp
    194f:	89 e5                	mov    %esp,%ebp
    1951:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1954:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    195b:	77 07                	ja     1964 <morecore+0x16>
    nu = 4096;
    195d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1964:	8b 45 08             	mov    0x8(%ebp),%eax
    1967:	c1 e0 03             	shl    $0x3,%eax
    196a:	89 04 24             	mov    %eax,(%esp)
    196d:	e8 20 fc ff ff       	call   1592 <sbrk>
    1972:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1975:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1979:	75 07                	jne    1982 <morecore+0x34>
    return 0;
    197b:	b8 00 00 00 00       	mov    $0x0,%eax
    1980:	eb 22                	jmp    19a4 <morecore+0x56>
  hp = (Header*)p;
    1982:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1988:	8b 45 f0             	mov    -0x10(%ebp),%eax
    198b:	8b 55 08             	mov    0x8(%ebp),%edx
    198e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1991:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1994:	83 c0 08             	add    $0x8,%eax
    1997:	89 04 24             	mov    %eax,(%esp)
    199a:	e8 ce fe ff ff       	call   186d <free>
  return freep;
    199f:	a1 28 23 00 00       	mov    0x2328,%eax
}
    19a4:	c9                   	leave  
    19a5:	c3                   	ret    

000019a6 <malloc>:

void*
malloc(uint nbytes)
{
    19a6:	55                   	push   %ebp
    19a7:	89 e5                	mov    %esp,%ebp
    19a9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19ac:	8b 45 08             	mov    0x8(%ebp),%eax
    19af:	83 c0 07             	add    $0x7,%eax
    19b2:	c1 e8 03             	shr    $0x3,%eax
    19b5:	83 c0 01             	add    $0x1,%eax
    19b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    19bb:	a1 28 23 00 00       	mov    0x2328,%eax
    19c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    19c7:	75 23                	jne    19ec <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    19c9:	c7 45 f0 20 23 00 00 	movl   $0x2320,-0x10(%ebp)
    19d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19d3:	a3 28 23 00 00       	mov    %eax,0x2328
    19d8:	a1 28 23 00 00       	mov    0x2328,%eax
    19dd:	a3 20 23 00 00       	mov    %eax,0x2320
    base.s.size = 0;
    19e2:	c7 05 24 23 00 00 00 	movl   $0x0,0x2324
    19e9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19ef:	8b 00                	mov    (%eax),%eax
    19f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    19f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19f7:	8b 40 04             	mov    0x4(%eax),%eax
    19fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19fd:	72 4d                	jb     1a4c <malloc+0xa6>
      if(p->s.size == nunits)
    19ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a02:	8b 40 04             	mov    0x4(%eax),%eax
    1a05:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a08:	75 0c                	jne    1a16 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a0d:	8b 10                	mov    (%eax),%edx
    1a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a12:	89 10                	mov    %edx,(%eax)
    1a14:	eb 26                	jmp    1a3c <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a19:	8b 40 04             	mov    0x4(%eax),%eax
    1a1c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1a1f:	89 c2                	mov    %eax,%edx
    1a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a24:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a2a:	8b 40 04             	mov    0x4(%eax),%eax
    1a2d:	c1 e0 03             	shl    $0x3,%eax
    1a30:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a39:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a3f:	a3 28 23 00 00       	mov    %eax,0x2328
      return (void*)(p + 1);
    1a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a47:	83 c0 08             	add    $0x8,%eax
    1a4a:	eb 38                	jmp    1a84 <malloc+0xde>
    }
    if(p == freep)
    1a4c:	a1 28 23 00 00       	mov    0x2328,%eax
    1a51:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1a54:	75 1b                	jne    1a71 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1a59:	89 04 24             	mov    %eax,(%esp)
    1a5c:	e8 ed fe ff ff       	call   194e <morecore>
    1a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a68:	75 07                	jne    1a71 <malloc+0xcb>
        return 0;
    1a6a:	b8 00 00 00 00       	mov    $0x0,%eax
    1a6f:	eb 13                	jmp    1a84 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7a:	8b 00                	mov    (%eax),%eax
    1a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1a7f:	e9 70 ff ff ff       	jmp    19f4 <malloc+0x4e>
}
    1a84:	c9                   	leave  
    1a85:	c3                   	ret    

00001a86 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1a86:	55                   	push   %ebp
    1a87:	89 e5                	mov    %esp,%ebp
    1a89:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1a8c:	8b 55 08             	mov    0x8(%ebp),%edx
    1a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a95:	f0 87 02             	lock xchg %eax,(%edx)
    1a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1a9e:	c9                   	leave  
    1a9f:	c3                   	ret    

00001aa0 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1aa0:	55                   	push   %ebp
    1aa1:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1aa3:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1aac:	5d                   	pop    %ebp
    1aad:	c3                   	ret    

00001aae <lock_acquire>:
void lock_acquire(lock_t *lock){
    1aae:	55                   	push   %ebp
    1aaf:	89 e5                	mov    %esp,%ebp
    1ab1:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1ab4:	90                   	nop
    1ab5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ab8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1abf:	00 
    1ac0:	89 04 24             	mov    %eax,(%esp)
    1ac3:	e8 be ff ff ff       	call   1a86 <xchg>
    1ac8:	85 c0                	test   %eax,%eax
    1aca:	75 e9                	jne    1ab5 <lock_acquire+0x7>
}
    1acc:	c9                   	leave  
    1acd:	c3                   	ret    

00001ace <lock_release>:
void lock_release(lock_t *lock){
    1ace:	55                   	push   %ebp
    1acf:	89 e5                	mov    %esp,%ebp
    1ad1:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1ad4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1ade:	00 
    1adf:	89 04 24             	mov    %eax,(%esp)
    1ae2:	e8 9f ff ff ff       	call   1a86 <xchg>
}
    1ae7:	c9                   	leave  
    1ae8:	c3                   	ret    

00001ae9 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1ae9:	55                   	push   %ebp
    1aea:	89 e5                	mov    %esp,%ebp
    1aec:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1aef:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1af6:	e8 ab fe ff ff       	call   19a6 <malloc>
    1afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1b04:	0f b6 05 2c 23 00 00 	movzbl 0x232c,%eax
    1b0b:	84 c0                	test   %al,%al
    1b0d:	75 1c                	jne    1b2b <thread_create+0x42>
        init_q(thQ2);
    1b0f:	a1 4c 24 00 00       	mov    0x244c,%eax
    1b14:	89 04 24             	mov    %eax,(%esp)
    1b17:	e8 b2 01 00 00       	call   1cce <init_q>
        inQ++;
    1b1c:	0f b6 05 2c 23 00 00 	movzbl 0x232c,%eax
    1b23:	83 c0 01             	add    $0x1,%eax
    1b26:	a2 2c 23 00 00       	mov    %al,0x232c
    }

    if((uint)stack % 4096){
    1b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2e:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b33:	85 c0                	test   %eax,%eax
    1b35:	74 14                	je     1b4b <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3a:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b3f:	89 c2                	mov    %eax,%edx
    1b41:	b8 00 10 00 00       	mov    $0x1000,%eax
    1b46:	29 d0                	sub    %edx,%eax
    1b48:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b4f:	75 1e                	jne    1b6f <thread_create+0x86>

        printf(1,"malloc fail \n");
    1b51:	c7 44 24 04 53 1e 00 	movl   $0x1e53,0x4(%esp)
    1b58:	00 
    1b59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b60:	e8 55 fb ff ff       	call   16ba <printf>
        return 0;
    1b65:	b8 00 00 00 00       	mov    $0x0,%eax
    1b6a:	e9 83 00 00 00       	jmp    1bf2 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1b72:	8b 55 08             	mov    0x8(%ebp),%edx
    1b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b78:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1b7c:	89 54 24 08          	mov    %edx,0x8(%esp)
    1b80:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1b87:	00 
    1b88:	89 04 24             	mov    %eax,(%esp)
    1b8b:	e8 1a fa ff ff       	call   15aa <clone>
    1b90:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1b93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b97:	79 1b                	jns    1bb4 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1b99:	c7 44 24 04 61 1e 00 	movl   $0x1e61,0x4(%esp)
    1ba0:	00 
    1ba1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba8:	e8 0d fb ff ff       	call   16ba <printf>
        return 0;
    1bad:	b8 00 00 00 00       	mov    $0x0,%eax
    1bb2:	eb 3e                	jmp    1bf2 <thread_create+0x109>
    }
    if(tid > 0){
    1bb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bb8:	7e 19                	jle    1bd3 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1bba:	a1 4c 24 00 00       	mov    0x244c,%eax
    1bbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1bc2:	89 54 24 04          	mov    %edx,0x4(%esp)
    1bc6:	89 04 24             	mov    %eax,(%esp)
    1bc9:	e8 22 01 00 00       	call   1cf0 <add_q>
        return garbage_stack;
    1bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bd1:	eb 1f                	jmp    1bf2 <thread_create+0x109>
    }
    if(tid == 0){
    1bd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bd7:	75 14                	jne    1bed <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1bd9:	c7 44 24 04 6e 1e 00 	movl   $0x1e6e,0x4(%esp)
    1be0:	00 
    1be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1be8:	e8 cd fa ff ff       	call   16ba <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1bf2:	c9                   	leave  
    1bf3:	c3                   	ret    

00001bf4 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1bf4:	55                   	push   %ebp
    1bf5:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1bf7:	a1 10 23 00 00       	mov    0x2310,%eax
    1bfc:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1c02:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1c07:	a3 10 23 00 00       	mov    %eax,0x2310
    return (int)(rands % max);
    1c0c:	a1 10 23 00 00       	mov    0x2310,%eax
    1c11:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1c14:	ba 00 00 00 00       	mov    $0x0,%edx
    1c19:	f7 f1                	div    %ecx
    1c1b:	89 d0                	mov    %edx,%eax
}
    1c1d:	5d                   	pop    %ebp
    1c1e:	c3                   	ret    

00001c1f <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1c1f:	55                   	push   %ebp
    1c20:	89 e5                	mov    %esp,%ebp
    1c22:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1c25:	e8 60 f9 ff ff       	call   158a <getpid>
    1c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1c2d:	a1 4c 24 00 00       	mov    0x244c,%eax
    1c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1c35:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c39:	89 04 24             	mov    %eax,(%esp)
    1c3c:	e8 af 00 00 00       	call   1cf0 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1c41:	a1 4c 24 00 00       	mov    0x244c,%eax
    1c46:	89 04 24             	mov    %eax,(%esp)
    1c49:	e8 1c 01 00 00       	call   1d6a <pop_q>
    1c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1c51:	a1 30 23 00 00       	mov    0x2330,%eax
    1c56:	85 c0                	test   %eax,%eax
    1c58:	75 1f                	jne    1c79 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1c5a:	a1 4c 24 00 00       	mov    0x244c,%eax
    1c5f:	89 04 24             	mov    %eax,(%esp)
    1c62:	e8 03 01 00 00       	call   1d6a <pop_q>
    1c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1c6a:	a1 30 23 00 00       	mov    0x2330,%eax
    1c6f:	83 c0 01             	add    $0x1,%eax
    1c72:	a3 30 23 00 00       	mov    %eax,0x2330
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1c77:	eb 12                	jmp    1c8b <thread_yield2+0x6c>
    1c79:	eb 10                	jmp    1c8b <thread_yield2+0x6c>
    1c7b:	a1 4c 24 00 00       	mov    0x244c,%eax
    1c80:	89 04 24             	mov    %eax,(%esp)
    1c83:	e8 e2 00 00 00       	call   1d6a <pop_q>
    1c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c8e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1c91:	74 e8                	je     1c7b <thread_yield2+0x5c>
    1c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c97:	74 e2                	je     1c7b <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c9c:	89 04 24             	mov    %eax,(%esp)
    1c9f:	e8 1e f9 ff ff       	call   15c2 <twakeup>
    tsleep();
    1ca4:	e8 11 f9 ff ff       	call   15ba <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1ca9:	c9                   	leave  
    1caa:	c3                   	ret    

00001cab <thread_yield_last>:

void thread_yield_last(){
    1cab:	55                   	push   %ebp
    1cac:	89 e5                	mov    %esp,%ebp
    1cae:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1cb1:	a1 4c 24 00 00       	mov    0x244c,%eax
    1cb6:	89 04 24             	mov    %eax,(%esp)
    1cb9:	e8 ac 00 00 00       	call   1d6a <pop_q>
    1cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cc4:	89 04 24             	mov    %eax,(%esp)
    1cc7:	e8 f6 f8 ff ff       	call   15c2 <twakeup>
    1ccc:	c9                   	leave  
    1ccd:	c3                   	ret    

00001cce <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1cce:	55                   	push   %ebp
    1ccf:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1cd1:	8b 45 08             	mov    0x8(%ebp),%eax
    1cd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1cda:	8b 45 08             	mov    0x8(%ebp),%eax
    1cdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1ce4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1cee:	5d                   	pop    %ebp
    1cef:	c3                   	ret    

00001cf0 <add_q>:

void add_q(struct queue *q, int v){
    1cf0:	55                   	push   %ebp
    1cf1:	89 e5                	mov    %esp,%ebp
    1cf3:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1cf6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1cfd:	e8 a4 fc ff ff       	call   19a6 <malloc>
    1d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d12:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d15:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1d17:	8b 45 08             	mov    0x8(%ebp),%eax
    1d1a:	8b 40 04             	mov    0x4(%eax),%eax
    1d1d:	85 c0                	test   %eax,%eax
    1d1f:	75 0b                	jne    1d2c <add_q+0x3c>
        q->head = n;
    1d21:	8b 45 08             	mov    0x8(%ebp),%eax
    1d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d27:	89 50 04             	mov    %edx,0x4(%eax)
    1d2a:	eb 0c                	jmp    1d38 <add_q+0x48>
    }else{
        q->tail->next = n;
    1d2c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d2f:	8b 40 08             	mov    0x8(%eax),%eax
    1d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d35:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1d38:	8b 45 08             	mov    0x8(%ebp),%eax
    1d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d3e:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1d41:	8b 45 08             	mov    0x8(%ebp),%eax
    1d44:	8b 00                	mov    (%eax),%eax
    1d46:	8d 50 01             	lea    0x1(%eax),%edx
    1d49:	8b 45 08             	mov    0x8(%ebp),%eax
    1d4c:	89 10                	mov    %edx,(%eax)
}
    1d4e:	c9                   	leave  
    1d4f:	c3                   	ret    

00001d50 <empty_q>:

int empty_q(struct queue *q){
    1d50:	55                   	push   %ebp
    1d51:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1d53:	8b 45 08             	mov    0x8(%ebp),%eax
    1d56:	8b 00                	mov    (%eax),%eax
    1d58:	85 c0                	test   %eax,%eax
    1d5a:	75 07                	jne    1d63 <empty_q+0x13>
        return 1;
    1d5c:	b8 01 00 00 00       	mov    $0x1,%eax
    1d61:	eb 05                	jmp    1d68 <empty_q+0x18>
    else
        return 0;
    1d63:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1d68:	5d                   	pop    %ebp
    1d69:	c3                   	ret    

00001d6a <pop_q>:
int pop_q(struct queue *q){
    1d6a:	55                   	push   %ebp
    1d6b:	89 e5                	mov    %esp,%ebp
    1d6d:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1d70:	8b 45 08             	mov    0x8(%ebp),%eax
    1d73:	89 04 24             	mov    %eax,(%esp)
    1d76:	e8 d5 ff ff ff       	call   1d50 <empty_q>
    1d7b:	85 c0                	test   %eax,%eax
    1d7d:	75 5d                	jne    1ddc <pop_q+0x72>
       val = q->head->value; 
    1d7f:	8b 45 08             	mov    0x8(%ebp),%eax
    1d82:	8b 40 04             	mov    0x4(%eax),%eax
    1d85:	8b 00                	mov    (%eax),%eax
    1d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1d8a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d8d:	8b 40 04             	mov    0x4(%eax),%eax
    1d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1d93:	8b 45 08             	mov    0x8(%ebp),%eax
    1d96:	8b 40 04             	mov    0x4(%eax),%eax
    1d99:	8b 50 04             	mov    0x4(%eax),%edx
    1d9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d9f:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1da5:	89 04 24             	mov    %eax,(%esp)
    1da8:	e8 c0 fa ff ff       	call   186d <free>
       q->size--;
    1dad:	8b 45 08             	mov    0x8(%ebp),%eax
    1db0:	8b 00                	mov    (%eax),%eax
    1db2:	8d 50 ff             	lea    -0x1(%eax),%edx
    1db5:	8b 45 08             	mov    0x8(%ebp),%eax
    1db8:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1dba:	8b 45 08             	mov    0x8(%ebp),%eax
    1dbd:	8b 00                	mov    (%eax),%eax
    1dbf:	85 c0                	test   %eax,%eax
    1dc1:	75 14                	jne    1dd7 <pop_q+0x6d>
            q->head = 0;
    1dc3:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1dcd:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dda:	eb 05                	jmp    1de1 <pop_q+0x77>
    }
    return -1;
    1ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1de1:	c9                   	leave  
    1de2:	c3                   	ret    
