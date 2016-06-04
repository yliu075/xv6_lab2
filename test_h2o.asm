
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
  //lock_init(&s->lock);
  s->count = 0;
    1006:	8b 45 08             	mov    0x8(%ebp),%eax
    1009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  init_q(&s->q);
    100f:	8b 45 08             	mov    0x8(%ebp),%eax
    1012:	83 c0 04             	add    $0x4,%eax
    1015:	89 04 24             	mov    %eax,(%esp)
    1018:	e8 38 0d 00 00       	call   1d55 <init_q>
}
    101d:	c9                   	leave  
    101e:	c3                   	ret    

0000101f <sema_acquire>:
void sema_acquire(struct semaphore *s) {
    101f:	55                   	push   %ebp
    1020:	89 e5                	mov    %esp,%ebp
    1022:	83 ec 18             	sub    $0x18,%esp
        break;
    }
    xchg(&s->locked, 0);
  }*/
  //lock_acquire(&(s->lock));
  if(s->count <= 0){
    1025:	8b 45 08             	mov    0x8(%ebp),%eax
    1028:	8b 00                	mov    (%eax),%eax
    102a:	85 c0                	test   %eax,%eax
    102c:	7f 37                	jg     1065 <sema_acquire+0x46>
      add_q(&(s->q),getpid());
    102e:	e8 de 05 00 00       	call   1611 <getpid>
    1033:	8b 55 08             	mov    0x8(%ebp),%edx
    1036:	83 c2 04             	add    $0x4,%edx
    1039:	89 44 24 04          	mov    %eax,0x4(%esp)
    103d:	89 14 24             	mov    %edx,(%esp)
    1040:	e8 32 0d 00 00       	call   1d77 <add_q>
      while((s->count == 0) ) wait();
    1045:	eb 05                	jmp    104c <sema_acquire+0x2d>
    1047:	e8 4d 05 00 00       	call   1599 <wait>
    104c:	8b 45 08             	mov    0x8(%ebp),%eax
    104f:	8b 00                	mov    (%eax),%eax
    1051:	85 c0                	test   %eax,%eax
    1053:	74 f2                	je     1047 <sema_acquire+0x28>
      pop_q(&(s->q));
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	83 c0 04             	add    $0x4,%eax
    105b:	89 04 24             	mov    %eax,(%esp)
    105e:	e8 8e 0d 00 00       	call   1df1 <pop_q>
    1063:	eb 0d                	jmp    1072 <sema_acquire+0x53>
      //lock_release(&s->lock);
      //tsleep();
  }else{
      s->count--;
    1065:	8b 45 08             	mov    0x8(%ebp),%eax
    1068:	8b 00                	mov    (%eax),%eax
    106a:	8d 50 ff             	lea    -0x1(%eax),%edx
    106d:	8b 45 08             	mov    0x8(%ebp),%eax
    1070:	89 10                	mov    %edx,(%eax)
      //lock_release(&s->lock);
  }
}
    1072:	c9                   	leave  
    1073:	c3                   	ret    

00001074 <sema_signal>:
void sema_signal(struct semaphore *s) {
    1074:	55                   	push   %ebp
    1075:	89 e5                	mov    %esp,%ebp
  /*while(xchg(&s->locked, 1) ! = 0);
  s->val++;
  
  xchg(&s->locked, 0);*/
  //printf(1,"sema sig called Count: %d\n", s->count);
  s->count++;
    1077:	8b 45 08             	mov    0x8(%ebp),%eax
    107a:	8b 00                	mov    (%eax),%eax
    107c:	8d 50 01             	lea    0x1(%eax),%edx
    107f:	8b 45 08             	mov    0x8(%ebp),%eax
    1082:	89 10                	mov    %edx,(%eax)
      //int tid = pop_q(&s->q);
      //twakeup(tid);
  }
  //lock_release(&s->lock);
  */
}
    1084:	5d                   	pop    %ebp
    1085:	c3                   	ret    

00001086 <main>:
int water_molecules = 0;

void hReady(void *water);
void oReady(void *water);

int main(int argc, char *argv[]){
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
    1089:	83 e4 f0             	and    $0xfffffff0,%esp
    108c:	83 ec 10             	sub    $0x10,%esp

    printf(1,"Water Count: %d\n", water_molecules);
    108f:	a1 c0 23 00 00       	mov    0x23c0,%eax
    1094:	89 44 24 08          	mov    %eax,0x8(%esp)
    1098:	c7 44 24 04 6a 1e 00 	movl   $0x1e6a,0x4(%esp)
    109f:	00 
    10a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a7:	e8 95 06 00 00       	call   1741 <printf>
    sema_init(h);
    10ac:	a1 e0 23 00 00       	mov    0x23e0,%eax
    10b1:	89 04 24             	mov    %eax,(%esp)
    10b4:	e8 47 ff ff ff       	call   1000 <sema_init>
    //sema_init(h2);
    sema_init(o);
    10b9:	a1 d8 23 00 00       	mov    0x23d8,%eax
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 3a ff ff ff       	call   1000 <sema_init>
    printf(1,"H Count: %d\n", h->count);
    10c6:	a1 e0 23 00 00       	mov    0x23e0,%eax
    10cb:	8b 00                	mov    (%eax),%eax
    10cd:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d1:	c7 44 24 04 7b 1e 00 	movl   $0x1e7b,0x4(%esp)
    10d8:	00 
    10d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e0:	e8 5c 06 00 00       	call   1741 <printf>
    printf(1,"O Count: %d\n", o->count);
    10e5:	a1 d8 23 00 00       	mov    0x23d8,%eax
    10ea:	8b 00                	mov    (%eax),%eax
    10ec:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f0:	c7 44 24 04 88 1e 00 	movl   $0x1e88,0x4(%esp)
    10f7:	00 
    10f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ff:	e8 3d 06 00 00       	call   1741 <printf>
    thread_create(hReady, (void *)&water_molecules);
    1104:	c7 44 24 04 c0 23 00 	movl   $0x23c0,0x4(%esp)
    110b:	00 
    110c:	c7 04 24 4e 12 00 00 	movl   $0x124e,(%esp)
    1113:	e8 58 0a 00 00       	call   1b70 <thread_create>
    thread_create(hReady, (void *)&water_molecules);
    1118:	c7 44 24 04 c0 23 00 	movl   $0x23c0,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 4e 12 00 00 	movl   $0x124e,(%esp)
    1127:	e8 44 0a 00 00       	call   1b70 <thread_create>
    thread_create(oReady, (void *)&water_molecules);
    112c:	c7 44 24 04 c0 23 00 	movl   $0x23c0,0x4(%esp)
    1133:	00 
    1134:	c7 04 24 9b 12 00 00 	movl   $0x129b,(%esp)
    113b:	e8 30 0a 00 00       	call   1b70 <thread_create>
    printf(1,"H Count: %d\n", h->count);
    1140:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1145:	8b 00                	mov    (%eax),%eax
    1147:	89 44 24 08          	mov    %eax,0x8(%esp)
    114b:	c7 44 24 04 7b 1e 00 	movl   $0x1e7b,0x4(%esp)
    1152:	00 
    1153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115a:	e8 e2 05 00 00       	call   1741 <printf>
    printf(1,"O Count: %d\n", o->count);
    115f:	a1 d8 23 00 00       	mov    0x23d8,%eax
    1164:	8b 00                	mov    (%eax),%eax
    1166:	89 44 24 08          	mov    %eax,0x8(%esp)
    116a:	c7 44 24 04 88 1e 00 	movl   $0x1e88,0x4(%esp)
    1171:	00 
    1172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1179:	e8 c3 05 00 00       	call   1741 <printf>
    while(wait() >= 0){}
    117e:	90                   	nop
    117f:	e8 15 04 00 00       	call   1599 <wait>
    1184:	85 c0                	test   %eax,%eax
    1186:	79 f7                	jns    117f <main+0xf9>
    //wait();
    printf(1,"Waited 1\n");
    1188:	c7 44 24 04 95 1e 00 	movl   $0x1e95,0x4(%esp)
    118f:	00 
    1190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1197:	e8 a5 05 00 00       	call   1741 <printf>
    //thread_yield_last();
    //wait();
    printf(1,"Waited 2\n");
    119c:	c7 44 24 04 9f 1e 00 	movl   $0x1e9f,0x4(%esp)
    11a3:	00 
    11a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ab:	e8 91 05 00 00       	call   1741 <printf>
    //thread_yield_last();
    //wait();
    //printf(1,"Waited 3\n");
    printf(1,"Water Count: %d\n", water_molecules);
    11b0:	a1 c0 23 00 00       	mov    0x23c0,%eax
    11b5:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b9:	c7 44 24 04 6a 1e 00 	movl   $0x1e6a,0x4(%esp)
    11c0:	00 
    11c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c8:	e8 74 05 00 00       	call   1741 <printf>
    exit();
    11cd:	e8 bf 03 00 00       	call   1591 <exit>

000011d2 <ping>:
}


void ping(void *arg_ptr){
    11d2:	55                   	push   %ebp
    11d3:	89 e5                	mov    %esp,%ebp
    11d5:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    11d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    11df:	eb 24                	jmp    1205 <ping+0x33>
    // while(1) {
        printf(1,"Ping %d \n",i);
    11e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e4:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e8:	c7 44 24 04 a9 1e 00 	movl   $0x1ea9,0x4(%esp)
    11ef:	00 
    11f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11f7:	e8 45 05 00 00       	call   1741 <printf>
        thread_yield2();
    11fc:	e8 a5 0a 00 00       	call   1ca6 <thread_yield2>
}


void ping(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    1201:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1205:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    1209:	7e d6                	jle    11e1 <ping+0xf>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    120b:	e8 29 04 00 00       	call   1639 <texit>

00001210 <pong>:
}
void pong(void *arg_ptr){
    1210:	55                   	push   %ebp
    1211:	89 e5                	mov    %esp,%ebp
    1213:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    1216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    121d:	eb 24                	jmp    1243 <pong+0x33>
    // while(1) {
        printf(1,"Pong %d \n",i);
    121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1222:	89 44 24 08          	mov    %eax,0x8(%esp)
    1226:	c7 44 24 04 b3 1e 00 	movl   $0x1eb3,0x4(%esp)
    122d:	00 
    122e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1235:	e8 07 05 00 00       	call   1741 <printf>
        thread_yield2();
    123a:	e8 67 0a 00 00       	call   1ca6 <thread_yield2>
    //printf(1,"Pinged ALL\n");
    texit();
}
void pong(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    123f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1243:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    1247:	7e d6                	jle    121f <pong+0xf>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    1249:	e8 eb 03 00 00       	call   1639 <texit>

0000124e <hReady>:
}

void hReady(void *water) {
    124e:	55                   	push   %ebp
    124f:	89 e5                	mov    %esp,%ebp
    1251:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Added H\n");
    1254:	c7 44 24 04 bd 1e 00 	movl   $0x1ebd,0x4(%esp)
    125b:	00 
    125c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1263:	e8 d9 04 00 00       	call   1741 <printf>
    sema_signal(h);
    1268:	a1 e0 23 00 00       	mov    0x23e0,%eax
    126d:	89 04 24             	mov    %eax,(%esp)
    1270:	e8 ff fd ff ff       	call   1074 <sema_signal>
    sema_acquire(o);
    1275:	a1 d8 23 00 00       	mov    0x23d8,%eax
    127a:	89 04 24             	mov    %eax,(%esp)
    127d:	e8 9d fd ff ff       	call   101f <sema_acquire>
    printf(1, "Exit H\n");
    1282:	c7 44 24 04 c6 1e 00 	movl   $0x1ec6,0x4(%esp)
    1289:	00 
    128a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1291:	e8 ab 04 00 00       	call   1741 <printf>
    texit();
    1296:	e8 9e 03 00 00       	call   1639 <texit>

0000129b <oReady>:
}

void oReady(void *water) {
    129b:	55                   	push   %ebp
    129c:	89 e5                	mov    %esp,%ebp
    129e:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Added O\n");
    12a1:	c7 44 24 04 ce 1e 00 	movl   $0x1ece,0x4(%esp)
    12a8:	00 
    12a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b0:	e8 8c 04 00 00       	call   1741 <printf>
    sema_acquire(h);
    12b5:	a1 e0 23 00 00       	mov    0x23e0,%eax
    12ba:	89 04 24             	mov    %eax,(%esp)
    12bd:	e8 5d fd ff ff       	call   101f <sema_acquire>
    sema_acquire(h);
    12c2:	a1 e0 23 00 00       	mov    0x23e0,%eax
    12c7:	89 04 24             	mov    %eax,(%esp)
    12ca:	e8 50 fd ff ff       	call   101f <sema_acquire>
    sema_signal(o);
    12cf:	a1 d8 23 00 00       	mov    0x23d8,%eax
    12d4:	89 04 24             	mov    %eax,(%esp)
    12d7:	e8 98 fd ff ff       	call   1074 <sema_signal>
    sema_signal(o);
    12dc:	a1 d8 23 00 00       	mov    0x23d8,%eax
    12e1:	89 04 24             	mov    %eax,(%esp)
    12e4:	e8 8b fd ff ff       	call   1074 <sema_signal>
    sema_acquire(w);
    12e9:	a1 dc 23 00 00       	mov    0x23dc,%eax
    12ee:	89 04 24             	mov    %eax,(%esp)
    12f1:	e8 29 fd ff ff       	call   101f <sema_acquire>
    water_molecules++;
    12f6:	a1 c0 23 00 00       	mov    0x23c0,%eax
    12fb:	83 c0 01             	add    $0x1,%eax
    12fe:	a3 c0 23 00 00       	mov    %eax,0x23c0
    printf(1, "Exit O\n");
    1303:	c7 44 24 04 d7 1e 00 	movl   $0x1ed7,0x4(%esp)
    130a:	00 
    130b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1312:	e8 2a 04 00 00       	call   1741 <printf>
    sema_signal(w);
    1317:	a1 dc 23 00 00       	mov    0x23dc,%eax
    131c:	89 04 24             	mov    %eax,(%esp)
    131f:	e8 50 fd ff ff       	call   1074 <sema_signal>
    texit();
    1324:	e8 10 03 00 00       	call   1639 <texit>

00001329 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1329:	55                   	push   %ebp
    132a:	89 e5                	mov    %esp,%ebp
    132c:	57                   	push   %edi
    132d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    132e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1331:	8b 55 10             	mov    0x10(%ebp),%edx
    1334:	8b 45 0c             	mov    0xc(%ebp),%eax
    1337:	89 cb                	mov    %ecx,%ebx
    1339:	89 df                	mov    %ebx,%edi
    133b:	89 d1                	mov    %edx,%ecx
    133d:	fc                   	cld    
    133e:	f3 aa                	rep stos %al,%es:(%edi)
    1340:	89 ca                	mov    %ecx,%edx
    1342:	89 fb                	mov    %edi,%ebx
    1344:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1347:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    134a:	5b                   	pop    %ebx
    134b:	5f                   	pop    %edi
    134c:	5d                   	pop    %ebp
    134d:	c3                   	ret    

0000134e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    134e:	55                   	push   %ebp
    134f:	89 e5                	mov    %esp,%ebp
    1351:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1354:	8b 45 08             	mov    0x8(%ebp),%eax
    1357:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    135a:	90                   	nop
    135b:	8b 45 08             	mov    0x8(%ebp),%eax
    135e:	8d 50 01             	lea    0x1(%eax),%edx
    1361:	89 55 08             	mov    %edx,0x8(%ebp)
    1364:	8b 55 0c             	mov    0xc(%ebp),%edx
    1367:	8d 4a 01             	lea    0x1(%edx),%ecx
    136a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    136d:	0f b6 12             	movzbl (%edx),%edx
    1370:	88 10                	mov    %dl,(%eax)
    1372:	0f b6 00             	movzbl (%eax),%eax
    1375:	84 c0                	test   %al,%al
    1377:	75 e2                	jne    135b <strcpy+0xd>
    ;
  return os;
    1379:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    137c:	c9                   	leave  
    137d:	c3                   	ret    

0000137e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    137e:	55                   	push   %ebp
    137f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1381:	eb 08                	jmp    138b <strcmp+0xd>
    p++, q++;
    1383:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1387:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    138b:	8b 45 08             	mov    0x8(%ebp),%eax
    138e:	0f b6 00             	movzbl (%eax),%eax
    1391:	84 c0                	test   %al,%al
    1393:	74 10                	je     13a5 <strcmp+0x27>
    1395:	8b 45 08             	mov    0x8(%ebp),%eax
    1398:	0f b6 10             	movzbl (%eax),%edx
    139b:	8b 45 0c             	mov    0xc(%ebp),%eax
    139e:	0f b6 00             	movzbl (%eax),%eax
    13a1:	38 c2                	cmp    %al,%dl
    13a3:	74 de                	je     1383 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13a5:	8b 45 08             	mov    0x8(%ebp),%eax
    13a8:	0f b6 00             	movzbl (%eax),%eax
    13ab:	0f b6 d0             	movzbl %al,%edx
    13ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b1:	0f b6 00             	movzbl (%eax),%eax
    13b4:	0f b6 c0             	movzbl %al,%eax
    13b7:	29 c2                	sub    %eax,%edx
    13b9:	89 d0                	mov    %edx,%eax
}
    13bb:	5d                   	pop    %ebp
    13bc:	c3                   	ret    

000013bd <strlen>:

uint
strlen(char *s)
{
    13bd:	55                   	push   %ebp
    13be:	89 e5                	mov    %esp,%ebp
    13c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13ca:	eb 04                	jmp    13d0 <strlen+0x13>
    13cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13d3:	8b 45 08             	mov    0x8(%ebp),%eax
    13d6:	01 d0                	add    %edx,%eax
    13d8:	0f b6 00             	movzbl (%eax),%eax
    13db:	84 c0                	test   %al,%al
    13dd:	75 ed                	jne    13cc <strlen+0xf>
    ;
  return n;
    13df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13e2:	c9                   	leave  
    13e3:	c3                   	ret    

000013e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    13e4:	55                   	push   %ebp
    13e5:	89 e5                	mov    %esp,%ebp
    13e7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    13ea:	8b 45 10             	mov    0x10(%ebp),%eax
    13ed:	89 44 24 08          	mov    %eax,0x8(%esp)
    13f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f4:	89 44 24 04          	mov    %eax,0x4(%esp)
    13f8:	8b 45 08             	mov    0x8(%ebp),%eax
    13fb:	89 04 24             	mov    %eax,(%esp)
    13fe:	e8 26 ff ff ff       	call   1329 <stosb>
  return dst;
    1403:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1406:	c9                   	leave  
    1407:	c3                   	ret    

00001408 <strchr>:

char*
strchr(const char *s, char c)
{
    1408:	55                   	push   %ebp
    1409:	89 e5                	mov    %esp,%ebp
    140b:	83 ec 04             	sub    $0x4,%esp
    140e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1411:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1414:	eb 14                	jmp    142a <strchr+0x22>
    if(*s == c)
    1416:	8b 45 08             	mov    0x8(%ebp),%eax
    1419:	0f b6 00             	movzbl (%eax),%eax
    141c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    141f:	75 05                	jne    1426 <strchr+0x1e>
      return (char*)s;
    1421:	8b 45 08             	mov    0x8(%ebp),%eax
    1424:	eb 13                	jmp    1439 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1426:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
    142d:	0f b6 00             	movzbl (%eax),%eax
    1430:	84 c0                	test   %al,%al
    1432:	75 e2                	jne    1416 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1434:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1439:	c9                   	leave  
    143a:	c3                   	ret    

0000143b <gets>:

char*
gets(char *buf, int max)
{
    143b:	55                   	push   %ebp
    143c:	89 e5                	mov    %esp,%ebp
    143e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1448:	eb 4c                	jmp    1496 <gets+0x5b>
    cc = read(0, &c, 1);
    144a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1451:	00 
    1452:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1455:	89 44 24 04          	mov    %eax,0x4(%esp)
    1459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1460:	e8 44 01 00 00       	call   15a9 <read>
    1465:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1468:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    146c:	7f 02                	jg     1470 <gets+0x35>
      break;
    146e:	eb 31                	jmp    14a1 <gets+0x66>
    buf[i++] = c;
    1470:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1473:	8d 50 01             	lea    0x1(%eax),%edx
    1476:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1479:	89 c2                	mov    %eax,%edx
    147b:	8b 45 08             	mov    0x8(%ebp),%eax
    147e:	01 c2                	add    %eax,%edx
    1480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1484:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1486:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    148a:	3c 0a                	cmp    $0xa,%al
    148c:	74 13                	je     14a1 <gets+0x66>
    148e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1492:	3c 0d                	cmp    $0xd,%al
    1494:	74 0b                	je     14a1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1496:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1499:	83 c0 01             	add    $0x1,%eax
    149c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    149f:	7c a9                	jl     144a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14a4:	8b 45 08             	mov    0x8(%ebp),%eax
    14a7:	01 d0                	add    %edx,%eax
    14a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14af:	c9                   	leave  
    14b0:	c3                   	ret    

000014b1 <stat>:

int
stat(char *n, struct stat *st)
{
    14b1:	55                   	push   %ebp
    14b2:	89 e5                	mov    %esp,%ebp
    14b4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14be:	00 
    14bf:	8b 45 08             	mov    0x8(%ebp),%eax
    14c2:	89 04 24             	mov    %eax,(%esp)
    14c5:	e8 07 01 00 00       	call   15d1 <open>
    14ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14d1:	79 07                	jns    14da <stat+0x29>
    return -1;
    14d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14d8:	eb 23                	jmp    14fd <stat+0x4c>
  r = fstat(fd, st);
    14da:	8b 45 0c             	mov    0xc(%ebp),%eax
    14dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e4:	89 04 24             	mov    %eax,(%esp)
    14e7:	e8 fd 00 00 00       	call   15e9 <fstat>
    14ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f2:	89 04 24             	mov    %eax,(%esp)
    14f5:	e8 bf 00 00 00       	call   15b9 <close>
  return r;
    14fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    14fd:	c9                   	leave  
    14fe:	c3                   	ret    

000014ff <atoi>:

int
atoi(const char *s)
{
    14ff:	55                   	push   %ebp
    1500:	89 e5                	mov    %esp,%ebp
    1502:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1505:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    150c:	eb 25                	jmp    1533 <atoi+0x34>
    n = n*10 + *s++ - '0';
    150e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1511:	89 d0                	mov    %edx,%eax
    1513:	c1 e0 02             	shl    $0x2,%eax
    1516:	01 d0                	add    %edx,%eax
    1518:	01 c0                	add    %eax,%eax
    151a:	89 c1                	mov    %eax,%ecx
    151c:	8b 45 08             	mov    0x8(%ebp),%eax
    151f:	8d 50 01             	lea    0x1(%eax),%edx
    1522:	89 55 08             	mov    %edx,0x8(%ebp)
    1525:	0f b6 00             	movzbl (%eax),%eax
    1528:	0f be c0             	movsbl %al,%eax
    152b:	01 c8                	add    %ecx,%eax
    152d:	83 e8 30             	sub    $0x30,%eax
    1530:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1533:	8b 45 08             	mov    0x8(%ebp),%eax
    1536:	0f b6 00             	movzbl (%eax),%eax
    1539:	3c 2f                	cmp    $0x2f,%al
    153b:	7e 0a                	jle    1547 <atoi+0x48>
    153d:	8b 45 08             	mov    0x8(%ebp),%eax
    1540:	0f b6 00             	movzbl (%eax),%eax
    1543:	3c 39                	cmp    $0x39,%al
    1545:	7e c7                	jle    150e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1547:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    154a:	c9                   	leave  
    154b:	c3                   	ret    

0000154c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    154c:	55                   	push   %ebp
    154d:	89 e5                	mov    %esp,%ebp
    154f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1552:	8b 45 08             	mov    0x8(%ebp),%eax
    1555:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1558:	8b 45 0c             	mov    0xc(%ebp),%eax
    155b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    155e:	eb 17                	jmp    1577 <memmove+0x2b>
    *dst++ = *src++;
    1560:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1563:	8d 50 01             	lea    0x1(%eax),%edx
    1566:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1569:	8b 55 f8             	mov    -0x8(%ebp),%edx
    156c:	8d 4a 01             	lea    0x1(%edx),%ecx
    156f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1572:	0f b6 12             	movzbl (%edx),%edx
    1575:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1577:	8b 45 10             	mov    0x10(%ebp),%eax
    157a:	8d 50 ff             	lea    -0x1(%eax),%edx
    157d:	89 55 10             	mov    %edx,0x10(%ebp)
    1580:	85 c0                	test   %eax,%eax
    1582:	7f dc                	jg     1560 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1587:	c9                   	leave  
    1588:	c3                   	ret    

00001589 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1589:	b8 01 00 00 00       	mov    $0x1,%eax
    158e:	cd 40                	int    $0x40
    1590:	c3                   	ret    

00001591 <exit>:
SYSCALL(exit)
    1591:	b8 02 00 00 00       	mov    $0x2,%eax
    1596:	cd 40                	int    $0x40
    1598:	c3                   	ret    

00001599 <wait>:
SYSCALL(wait)
    1599:	b8 03 00 00 00       	mov    $0x3,%eax
    159e:	cd 40                	int    $0x40
    15a0:	c3                   	ret    

000015a1 <pipe>:
SYSCALL(pipe)
    15a1:	b8 04 00 00 00       	mov    $0x4,%eax
    15a6:	cd 40                	int    $0x40
    15a8:	c3                   	ret    

000015a9 <read>:
SYSCALL(read)
    15a9:	b8 05 00 00 00       	mov    $0x5,%eax
    15ae:	cd 40                	int    $0x40
    15b0:	c3                   	ret    

000015b1 <write>:
SYSCALL(write)
    15b1:	b8 10 00 00 00       	mov    $0x10,%eax
    15b6:	cd 40                	int    $0x40
    15b8:	c3                   	ret    

000015b9 <close>:
SYSCALL(close)
    15b9:	b8 15 00 00 00       	mov    $0x15,%eax
    15be:	cd 40                	int    $0x40
    15c0:	c3                   	ret    

000015c1 <kill>:
SYSCALL(kill)
    15c1:	b8 06 00 00 00       	mov    $0x6,%eax
    15c6:	cd 40                	int    $0x40
    15c8:	c3                   	ret    

000015c9 <exec>:
SYSCALL(exec)
    15c9:	b8 07 00 00 00       	mov    $0x7,%eax
    15ce:	cd 40                	int    $0x40
    15d0:	c3                   	ret    

000015d1 <open>:
SYSCALL(open)
    15d1:	b8 0f 00 00 00       	mov    $0xf,%eax
    15d6:	cd 40                	int    $0x40
    15d8:	c3                   	ret    

000015d9 <mknod>:
SYSCALL(mknod)
    15d9:	b8 11 00 00 00       	mov    $0x11,%eax
    15de:	cd 40                	int    $0x40
    15e0:	c3                   	ret    

000015e1 <unlink>:
SYSCALL(unlink)
    15e1:	b8 12 00 00 00       	mov    $0x12,%eax
    15e6:	cd 40                	int    $0x40
    15e8:	c3                   	ret    

000015e9 <fstat>:
SYSCALL(fstat)
    15e9:	b8 08 00 00 00       	mov    $0x8,%eax
    15ee:	cd 40                	int    $0x40
    15f0:	c3                   	ret    

000015f1 <link>:
SYSCALL(link)
    15f1:	b8 13 00 00 00       	mov    $0x13,%eax
    15f6:	cd 40                	int    $0x40
    15f8:	c3                   	ret    

000015f9 <mkdir>:
SYSCALL(mkdir)
    15f9:	b8 14 00 00 00       	mov    $0x14,%eax
    15fe:	cd 40                	int    $0x40
    1600:	c3                   	ret    

00001601 <chdir>:
SYSCALL(chdir)
    1601:	b8 09 00 00 00       	mov    $0x9,%eax
    1606:	cd 40                	int    $0x40
    1608:	c3                   	ret    

00001609 <dup>:
SYSCALL(dup)
    1609:	b8 0a 00 00 00       	mov    $0xa,%eax
    160e:	cd 40                	int    $0x40
    1610:	c3                   	ret    

00001611 <getpid>:
SYSCALL(getpid)
    1611:	b8 0b 00 00 00       	mov    $0xb,%eax
    1616:	cd 40                	int    $0x40
    1618:	c3                   	ret    

00001619 <sbrk>:
SYSCALL(sbrk)
    1619:	b8 0c 00 00 00       	mov    $0xc,%eax
    161e:	cd 40                	int    $0x40
    1620:	c3                   	ret    

00001621 <sleep>:
SYSCALL(sleep)
    1621:	b8 0d 00 00 00       	mov    $0xd,%eax
    1626:	cd 40                	int    $0x40
    1628:	c3                   	ret    

00001629 <uptime>:
SYSCALL(uptime)
    1629:	b8 0e 00 00 00       	mov    $0xe,%eax
    162e:	cd 40                	int    $0x40
    1630:	c3                   	ret    

00001631 <clone>:
SYSCALL(clone)
    1631:	b8 16 00 00 00       	mov    $0x16,%eax
    1636:	cd 40                	int    $0x40
    1638:	c3                   	ret    

00001639 <texit>:
SYSCALL(texit)
    1639:	b8 17 00 00 00       	mov    $0x17,%eax
    163e:	cd 40                	int    $0x40
    1640:	c3                   	ret    

00001641 <tsleep>:
SYSCALL(tsleep)
    1641:	b8 18 00 00 00       	mov    $0x18,%eax
    1646:	cd 40                	int    $0x40
    1648:	c3                   	ret    

00001649 <twakeup>:
SYSCALL(twakeup)
    1649:	b8 19 00 00 00       	mov    $0x19,%eax
    164e:	cd 40                	int    $0x40
    1650:	c3                   	ret    

00001651 <thread_yield>:
SYSCALL(thread_yield)
    1651:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1656:	cd 40                	int    $0x40
    1658:	c3                   	ret    

00001659 <thread_yield3>:
    1659:	b8 1a 00 00 00       	mov    $0x1a,%eax
    165e:	cd 40                	int    $0x40
    1660:	c3                   	ret    

00001661 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1661:	55                   	push   %ebp
    1662:	89 e5                	mov    %esp,%ebp
    1664:	83 ec 18             	sub    $0x18,%esp
    1667:	8b 45 0c             	mov    0xc(%ebp),%eax
    166a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    166d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1674:	00 
    1675:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1678:	89 44 24 04          	mov    %eax,0x4(%esp)
    167c:	8b 45 08             	mov    0x8(%ebp),%eax
    167f:	89 04 24             	mov    %eax,(%esp)
    1682:	e8 2a ff ff ff       	call   15b1 <write>
}
    1687:	c9                   	leave  
    1688:	c3                   	ret    

00001689 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1689:	55                   	push   %ebp
    168a:	89 e5                	mov    %esp,%ebp
    168c:	56                   	push   %esi
    168d:	53                   	push   %ebx
    168e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1691:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1698:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    169c:	74 17                	je     16b5 <printint+0x2c>
    169e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16a2:	79 11                	jns    16b5 <printint+0x2c>
    neg = 1;
    16a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16ab:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ae:	f7 d8                	neg    %eax
    16b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16b3:	eb 06                	jmp    16bb <printint+0x32>
  } else {
    x = xx;
    16b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    16b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16c5:	8d 41 01             	lea    0x1(%ecx),%eax
    16c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16d1:	ba 00 00 00 00       	mov    $0x0,%edx
    16d6:	f7 f3                	div    %ebx
    16d8:	89 d0                	mov    %edx,%eax
    16da:	0f b6 80 a8 23 00 00 	movzbl 0x23a8(%eax),%eax
    16e1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16e5:	8b 75 10             	mov    0x10(%ebp),%esi
    16e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16eb:	ba 00 00 00 00       	mov    $0x0,%edx
    16f0:	f7 f6                	div    %esi
    16f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16f9:	75 c7                	jne    16c2 <printint+0x39>
  if(neg)
    16fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16ff:	74 10                	je     1711 <printint+0x88>
    buf[i++] = '-';
    1701:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1704:	8d 50 01             	lea    0x1(%eax),%edx
    1707:	89 55 f4             	mov    %edx,-0xc(%ebp)
    170a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    170f:	eb 1f                	jmp    1730 <printint+0xa7>
    1711:	eb 1d                	jmp    1730 <printint+0xa7>
    putc(fd, buf[i]);
    1713:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1716:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1719:	01 d0                	add    %edx,%eax
    171b:	0f b6 00             	movzbl (%eax),%eax
    171e:	0f be c0             	movsbl %al,%eax
    1721:	89 44 24 04          	mov    %eax,0x4(%esp)
    1725:	8b 45 08             	mov    0x8(%ebp),%eax
    1728:	89 04 24             	mov    %eax,(%esp)
    172b:	e8 31 ff ff ff       	call   1661 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1730:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1738:	79 d9                	jns    1713 <printint+0x8a>
    putc(fd, buf[i]);
}
    173a:	83 c4 30             	add    $0x30,%esp
    173d:	5b                   	pop    %ebx
    173e:	5e                   	pop    %esi
    173f:	5d                   	pop    %ebp
    1740:	c3                   	ret    

00001741 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1741:	55                   	push   %ebp
    1742:	89 e5                	mov    %esp,%ebp
    1744:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1747:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    174e:	8d 45 0c             	lea    0xc(%ebp),%eax
    1751:	83 c0 04             	add    $0x4,%eax
    1754:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1757:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    175e:	e9 7c 01 00 00       	jmp    18df <printf+0x19e>
    c = fmt[i] & 0xff;
    1763:	8b 55 0c             	mov    0xc(%ebp),%edx
    1766:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1769:	01 d0                	add    %edx,%eax
    176b:	0f b6 00             	movzbl (%eax),%eax
    176e:	0f be c0             	movsbl %al,%eax
    1771:	25 ff 00 00 00       	and    $0xff,%eax
    1776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1779:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    177d:	75 2c                	jne    17ab <printf+0x6a>
      if(c == '%'){
    177f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1783:	75 0c                	jne    1791 <printf+0x50>
        state = '%';
    1785:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    178c:	e9 4a 01 00 00       	jmp    18db <printf+0x19a>
      } else {
        putc(fd, c);
    1791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1794:	0f be c0             	movsbl %al,%eax
    1797:	89 44 24 04          	mov    %eax,0x4(%esp)
    179b:	8b 45 08             	mov    0x8(%ebp),%eax
    179e:	89 04 24             	mov    %eax,(%esp)
    17a1:	e8 bb fe ff ff       	call   1661 <putc>
    17a6:	e9 30 01 00 00       	jmp    18db <printf+0x19a>
      }
    } else if(state == '%'){
    17ab:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17af:	0f 85 26 01 00 00    	jne    18db <printf+0x19a>
      if(c == 'd'){
    17b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17b9:	75 2d                	jne    17e8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17be:	8b 00                	mov    (%eax),%eax
    17c0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17c7:	00 
    17c8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17cf:	00 
    17d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    17d4:	8b 45 08             	mov    0x8(%ebp),%eax
    17d7:	89 04 24             	mov    %eax,(%esp)
    17da:	e8 aa fe ff ff       	call   1689 <printint>
        ap++;
    17df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17e3:	e9 ec 00 00 00       	jmp    18d4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17e8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17ec:	74 06                	je     17f4 <printf+0xb3>
    17ee:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17f2:	75 2d                	jne    1821 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    17f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17f7:	8b 00                	mov    (%eax),%eax
    17f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1800:	00 
    1801:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1808:	00 
    1809:	89 44 24 04          	mov    %eax,0x4(%esp)
    180d:	8b 45 08             	mov    0x8(%ebp),%eax
    1810:	89 04 24             	mov    %eax,(%esp)
    1813:	e8 71 fe ff ff       	call   1689 <printint>
        ap++;
    1818:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    181c:	e9 b3 00 00 00       	jmp    18d4 <printf+0x193>
      } else if(c == 's'){
    1821:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1825:	75 45                	jne    186c <printf+0x12b>
        s = (char*)*ap;
    1827:	8b 45 e8             	mov    -0x18(%ebp),%eax
    182a:	8b 00                	mov    (%eax),%eax
    182c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    182f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1837:	75 09                	jne    1842 <printf+0x101>
          s = "(null)";
    1839:	c7 45 f4 df 1e 00 00 	movl   $0x1edf,-0xc(%ebp)
        while(*s != 0){
    1840:	eb 1e                	jmp    1860 <printf+0x11f>
    1842:	eb 1c                	jmp    1860 <printf+0x11f>
          putc(fd, *s);
    1844:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1847:	0f b6 00             	movzbl (%eax),%eax
    184a:	0f be c0             	movsbl %al,%eax
    184d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1851:	8b 45 08             	mov    0x8(%ebp),%eax
    1854:	89 04 24             	mov    %eax,(%esp)
    1857:	e8 05 fe ff ff       	call   1661 <putc>
          s++;
    185c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1860:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1863:	0f b6 00             	movzbl (%eax),%eax
    1866:	84 c0                	test   %al,%al
    1868:	75 da                	jne    1844 <printf+0x103>
    186a:	eb 68                	jmp    18d4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    186c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1870:	75 1d                	jne    188f <printf+0x14e>
        putc(fd, *ap);
    1872:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1875:	8b 00                	mov    (%eax),%eax
    1877:	0f be c0             	movsbl %al,%eax
    187a:	89 44 24 04          	mov    %eax,0x4(%esp)
    187e:	8b 45 08             	mov    0x8(%ebp),%eax
    1881:	89 04 24             	mov    %eax,(%esp)
    1884:	e8 d8 fd ff ff       	call   1661 <putc>
        ap++;
    1889:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    188d:	eb 45                	jmp    18d4 <printf+0x193>
      } else if(c == '%'){
    188f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1893:	75 17                	jne    18ac <printf+0x16b>
        putc(fd, c);
    1895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1898:	0f be c0             	movsbl %al,%eax
    189b:	89 44 24 04          	mov    %eax,0x4(%esp)
    189f:	8b 45 08             	mov    0x8(%ebp),%eax
    18a2:	89 04 24             	mov    %eax,(%esp)
    18a5:	e8 b7 fd ff ff       	call   1661 <putc>
    18aa:	eb 28                	jmp    18d4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18ac:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18b3:	00 
    18b4:	8b 45 08             	mov    0x8(%ebp),%eax
    18b7:	89 04 24             	mov    %eax,(%esp)
    18ba:	e8 a2 fd ff ff       	call   1661 <putc>
        putc(fd, c);
    18bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18c2:	0f be c0             	movsbl %al,%eax
    18c5:	89 44 24 04          	mov    %eax,0x4(%esp)
    18c9:	8b 45 08             	mov    0x8(%ebp),%eax
    18cc:	89 04 24             	mov    %eax,(%esp)
    18cf:	e8 8d fd ff ff       	call   1661 <putc>
      }
      state = 0;
    18d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18df:	8b 55 0c             	mov    0xc(%ebp),%edx
    18e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e5:	01 d0                	add    %edx,%eax
    18e7:	0f b6 00             	movzbl (%eax),%eax
    18ea:	84 c0                	test   %al,%al
    18ec:	0f 85 71 fe ff ff    	jne    1763 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18f2:	c9                   	leave  
    18f3:	c3                   	ret    

000018f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18f4:	55                   	push   %ebp
    18f5:	89 e5                	mov    %esp,%ebp
    18f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18fa:	8b 45 08             	mov    0x8(%ebp),%eax
    18fd:	83 e8 08             	sub    $0x8,%eax
    1900:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1903:	a1 cc 23 00 00       	mov    0x23cc,%eax
    1908:	89 45 fc             	mov    %eax,-0x4(%ebp)
    190b:	eb 24                	jmp    1931 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1910:	8b 00                	mov    (%eax),%eax
    1912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1915:	77 12                	ja     1929 <free+0x35>
    1917:	8b 45 f8             	mov    -0x8(%ebp),%eax
    191a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    191d:	77 24                	ja     1943 <free+0x4f>
    191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1922:	8b 00                	mov    (%eax),%eax
    1924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1927:	77 1a                	ja     1943 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1929:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192c:	8b 00                	mov    (%eax),%eax
    192e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1931:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1937:	76 d4                	jbe    190d <free+0x19>
    1939:	8b 45 fc             	mov    -0x4(%ebp),%eax
    193c:	8b 00                	mov    (%eax),%eax
    193e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1941:	76 ca                	jbe    190d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1943:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1946:	8b 40 04             	mov    0x4(%eax),%eax
    1949:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1950:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1953:	01 c2                	add    %eax,%edx
    1955:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1958:	8b 00                	mov    (%eax),%eax
    195a:	39 c2                	cmp    %eax,%edx
    195c:	75 24                	jne    1982 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1961:	8b 50 04             	mov    0x4(%eax),%edx
    1964:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1967:	8b 00                	mov    (%eax),%eax
    1969:	8b 40 04             	mov    0x4(%eax),%eax
    196c:	01 c2                	add    %eax,%edx
    196e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1971:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1974:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1977:	8b 00                	mov    (%eax),%eax
    1979:	8b 10                	mov    (%eax),%edx
    197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197e:	89 10                	mov    %edx,(%eax)
    1980:	eb 0a                	jmp    198c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1982:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1985:	8b 10                	mov    (%eax),%edx
    1987:	8b 45 f8             	mov    -0x8(%ebp),%eax
    198a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198f:	8b 40 04             	mov    0x4(%eax),%eax
    1992:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1999:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199c:	01 d0                	add    %edx,%eax
    199e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19a1:	75 20                	jne    19c3 <free+0xcf>
    p->s.size += bp->s.size;
    19a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a6:	8b 50 04             	mov    0x4(%eax),%edx
    19a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ac:	8b 40 04             	mov    0x4(%eax),%eax
    19af:	01 c2                	add    %eax,%edx
    19b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ba:	8b 10                	mov    (%eax),%edx
    19bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19bf:	89 10                	mov    %edx,(%eax)
    19c1:	eb 08                	jmp    19cb <free+0xd7>
  } else
    p->s.ptr = bp;
    19c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19c9:	89 10                	mov    %edx,(%eax)
  freep = p;
    19cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ce:	a3 cc 23 00 00       	mov    %eax,0x23cc
}
    19d3:	c9                   	leave  
    19d4:	c3                   	ret    

000019d5 <morecore>:

static Header*
morecore(uint nu)
{
    19d5:	55                   	push   %ebp
    19d6:	89 e5                	mov    %esp,%ebp
    19d8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19db:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19e2:	77 07                	ja     19eb <morecore+0x16>
    nu = 4096;
    19e4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19eb:	8b 45 08             	mov    0x8(%ebp),%eax
    19ee:	c1 e0 03             	shl    $0x3,%eax
    19f1:	89 04 24             	mov    %eax,(%esp)
    19f4:	e8 20 fc ff ff       	call   1619 <sbrk>
    19f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    19fc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a00:	75 07                	jne    1a09 <morecore+0x34>
    return 0;
    1a02:	b8 00 00 00 00       	mov    $0x0,%eax
    1a07:	eb 22                	jmp    1a2b <morecore+0x56>
  hp = (Header*)p;
    1a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a12:	8b 55 08             	mov    0x8(%ebp),%edx
    1a15:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a1b:	83 c0 08             	add    $0x8,%eax
    1a1e:	89 04 24             	mov    %eax,(%esp)
    1a21:	e8 ce fe ff ff       	call   18f4 <free>
  return freep;
    1a26:	a1 cc 23 00 00       	mov    0x23cc,%eax
}
    1a2b:	c9                   	leave  
    1a2c:	c3                   	ret    

00001a2d <malloc>:

void*
malloc(uint nbytes)
{
    1a2d:	55                   	push   %ebp
    1a2e:	89 e5                	mov    %esp,%ebp
    1a30:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a33:	8b 45 08             	mov    0x8(%ebp),%eax
    1a36:	83 c0 07             	add    $0x7,%eax
    1a39:	c1 e8 03             	shr    $0x3,%eax
    1a3c:	83 c0 01             	add    $0x1,%eax
    1a3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a42:	a1 cc 23 00 00       	mov    0x23cc,%eax
    1a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a4e:	75 23                	jne    1a73 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a50:	c7 45 f0 c4 23 00 00 	movl   $0x23c4,-0x10(%ebp)
    1a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a5a:	a3 cc 23 00 00       	mov    %eax,0x23cc
    1a5f:	a1 cc 23 00 00       	mov    0x23cc,%eax
    1a64:	a3 c4 23 00 00       	mov    %eax,0x23c4
    base.s.size = 0;
    1a69:	c7 05 c8 23 00 00 00 	movl   $0x0,0x23c8
    1a70:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a76:	8b 00                	mov    (%eax),%eax
    1a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7e:	8b 40 04             	mov    0x4(%eax),%eax
    1a81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a84:	72 4d                	jb     1ad3 <malloc+0xa6>
      if(p->s.size == nunits)
    1a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a89:	8b 40 04             	mov    0x4(%eax),%eax
    1a8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a8f:	75 0c                	jne    1a9d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a94:	8b 10                	mov    (%eax),%edx
    1a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a99:	89 10                	mov    %edx,(%eax)
    1a9b:	eb 26                	jmp    1ac3 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa0:	8b 40 04             	mov    0x4(%eax),%eax
    1aa3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1aa6:	89 c2                	mov    %eax,%edx
    1aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab1:	8b 40 04             	mov    0x4(%eax),%eax
    1ab4:	c1 e0 03             	shl    $0x3,%eax
    1ab7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ac0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ac6:	a3 cc 23 00 00       	mov    %eax,0x23cc
      return (void*)(p + 1);
    1acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ace:	83 c0 08             	add    $0x8,%eax
    1ad1:	eb 38                	jmp    1b0b <malloc+0xde>
    }
    if(p == freep)
    1ad3:	a1 cc 23 00 00       	mov    0x23cc,%eax
    1ad8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1adb:	75 1b                	jne    1af8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1add:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ae0:	89 04 24             	mov    %eax,(%esp)
    1ae3:	e8 ed fe ff ff       	call   19d5 <morecore>
    1ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1aef:	75 07                	jne    1af8 <malloc+0xcb>
        return 0;
    1af1:	b8 00 00 00 00       	mov    $0x0,%eax
    1af6:	eb 13                	jmp    1b0b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b01:	8b 00                	mov    (%eax),%eax
    1b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b06:	e9 70 ff ff ff       	jmp    1a7b <malloc+0x4e>
}
    1b0b:	c9                   	leave  
    1b0c:	c3                   	ret    

00001b0d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1b0d:	55                   	push   %ebp
    1b0e:	89 e5                	mov    %esp,%ebp
    1b10:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1b13:	8b 55 08             	mov    0x8(%ebp),%edx
    1b16:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b1c:	f0 87 02             	lock xchg %eax,(%edx)
    1b1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1b25:	c9                   	leave  
    1b26:	c3                   	ret    

00001b27 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1b27:	55                   	push   %ebp
    1b28:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1b2a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b33:	5d                   	pop    %ebp
    1b34:	c3                   	ret    

00001b35 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1b35:	55                   	push   %ebp
    1b36:	89 e5                	mov    %esp,%ebp
    1b38:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1b3b:	90                   	nop
    1b3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b46:	00 
    1b47:	89 04 24             	mov    %eax,(%esp)
    1b4a:	e8 be ff ff ff       	call   1b0d <xchg>
    1b4f:	85 c0                	test   %eax,%eax
    1b51:	75 e9                	jne    1b3c <lock_acquire+0x7>
}
    1b53:	c9                   	leave  
    1b54:	c3                   	ret    

00001b55 <lock_release>:
void lock_release(lock_t *lock){
    1b55:	55                   	push   %ebp
    1b56:	89 e5                	mov    %esp,%ebp
    1b58:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1b5b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b65:	00 
    1b66:	89 04 24             	mov    %eax,(%esp)
    1b69:	e8 9f ff ff ff       	call   1b0d <xchg>
}
    1b6e:	c9                   	leave  
    1b6f:	c3                   	ret    

00001b70 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1b70:	55                   	push   %ebp
    1b71:	89 e5                	mov    %esp,%ebp
    1b73:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1b76:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1b7d:	e8 ab fe ff ff       	call   1a2d <malloc>
    1b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1b8b:	0f b6 05 d0 23 00 00 	movzbl 0x23d0,%eax
    1b92:	84 c0                	test   %al,%al
    1b94:	75 1c                	jne    1bb2 <thread_create+0x42>
        init_q(thQ2);
    1b96:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1b9b:	89 04 24             	mov    %eax,(%esp)
    1b9e:	e8 b2 01 00 00       	call   1d55 <init_q>
        inQ++;
    1ba3:	0f b6 05 d0 23 00 00 	movzbl 0x23d0,%eax
    1baa:	83 c0 01             	add    $0x1,%eax
    1bad:	a2 d0 23 00 00       	mov    %al,0x23d0
    }

    if((uint)stack % 4096){
    1bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bb5:	25 ff 0f 00 00       	and    $0xfff,%eax
    1bba:	85 c0                	test   %eax,%eax
    1bbc:	74 14                	je     1bd2 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc1:	25 ff 0f 00 00       	and    $0xfff,%eax
    1bc6:	89 c2                	mov    %eax,%edx
    1bc8:	b8 00 10 00 00       	mov    $0x1000,%eax
    1bcd:	29 d0                	sub    %edx,%eax
    1bcf:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bd6:	75 1e                	jne    1bf6 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1bd8:	c7 44 24 04 e6 1e 00 	movl   $0x1ee6,0x4(%esp)
    1bdf:	00 
    1be0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1be7:	e8 55 fb ff ff       	call   1741 <printf>
        return 0;
    1bec:	b8 00 00 00 00       	mov    $0x0,%eax
    1bf1:	e9 83 00 00 00       	jmp    1c79 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1bf9:	8b 55 08             	mov    0x8(%ebp),%edx
    1bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1c03:	89 54 24 08          	mov    %edx,0x8(%esp)
    1c07:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1c0e:	00 
    1c0f:	89 04 24             	mov    %eax,(%esp)
    1c12:	e8 1a fa ff ff       	call   1631 <clone>
    1c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c1e:	79 1b                	jns    1c3b <thread_create+0xcb>
        printf(1,"clone fails\n");
    1c20:	c7 44 24 04 f4 1e 00 	movl   $0x1ef4,0x4(%esp)
    1c27:	00 
    1c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c2f:	e8 0d fb ff ff       	call   1741 <printf>
        return 0;
    1c34:	b8 00 00 00 00       	mov    $0x0,%eax
    1c39:	eb 3e                	jmp    1c79 <thread_create+0x109>
    }
    if(tid > 0){
    1c3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c3f:	7e 19                	jle    1c5a <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1c41:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1c46:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1c49:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c4d:	89 04 24             	mov    %eax,(%esp)
    1c50:	e8 22 01 00 00       	call   1d77 <add_q>
        return garbage_stack;
    1c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c58:	eb 1f                	jmp    1c79 <thread_create+0x109>
    }
    if(tid == 0){
    1c5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c5e:	75 14                	jne    1c74 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1c60:	c7 44 24 04 01 1f 00 	movl   $0x1f01,0x4(%esp)
    1c67:	00 
    1c68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c6f:	e8 cd fa ff ff       	call   1741 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1c79:	c9                   	leave  
    1c7a:	c3                   	ret    

00001c7b <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1c7b:	55                   	push   %ebp
    1c7c:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1c7e:	a1 bc 23 00 00       	mov    0x23bc,%eax
    1c83:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1c89:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1c8e:	a3 bc 23 00 00       	mov    %eax,0x23bc
    return (int)(rands % max);
    1c93:	a1 bc 23 00 00       	mov    0x23bc,%eax
    1c98:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1c9b:	ba 00 00 00 00       	mov    $0x0,%edx
    1ca0:	f7 f1                	div    %ecx
    1ca2:	89 d0                	mov    %edx,%eax
}
    1ca4:	5d                   	pop    %ebp
    1ca5:	c3                   	ret    

00001ca6 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1ca6:	55                   	push   %ebp
    1ca7:	89 e5                	mov    %esp,%ebp
    1ca9:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1cac:	e8 60 f9 ff ff       	call   1611 <getpid>
    1cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1cb4:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1cb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1cbc:	89 54 24 04          	mov    %edx,0x4(%esp)
    1cc0:	89 04 24             	mov    %eax,(%esp)
    1cc3:	e8 af 00 00 00       	call   1d77 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1cc8:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1ccd:	89 04 24             	mov    %eax,(%esp)
    1cd0:	e8 1c 01 00 00       	call   1df1 <pop_q>
    1cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1cd8:	a1 d4 23 00 00       	mov    0x23d4,%eax
    1cdd:	85 c0                	test   %eax,%eax
    1cdf:	75 1f                	jne    1d00 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1ce1:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1ce6:	89 04 24             	mov    %eax,(%esp)
    1ce9:	e8 03 01 00 00       	call   1df1 <pop_q>
    1cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1cf1:	a1 d4 23 00 00       	mov    0x23d4,%eax
    1cf6:	83 c0 01             	add    $0x1,%eax
    1cf9:	a3 d4 23 00 00       	mov    %eax,0x23d4
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1cfe:	eb 12                	jmp    1d12 <thread_yield2+0x6c>
    1d00:	eb 10                	jmp    1d12 <thread_yield2+0x6c>
    1d02:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1d07:	89 04 24             	mov    %eax,(%esp)
    1d0a:	e8 e2 00 00 00       	call   1df1 <pop_q>
    1d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1d18:	74 e8                	je     1d02 <thread_yield2+0x5c>
    1d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d1e:	74 e2                	je     1d02 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d23:	89 04 24             	mov    %eax,(%esp)
    1d26:	e8 1e f9 ff ff       	call   1649 <twakeup>
    tsleep();
    1d2b:	e8 11 f9 ff ff       	call   1641 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1d30:	c9                   	leave  
    1d31:	c3                   	ret    

00001d32 <thread_yield_last>:

void thread_yield_last(){
    1d32:	55                   	push   %ebp
    1d33:	89 e5                	mov    %esp,%ebp
    1d35:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1d38:	a1 e4 23 00 00       	mov    0x23e4,%eax
    1d3d:	89 04 24             	mov    %eax,(%esp)
    1d40:	e8 ac 00 00 00       	call   1df1 <pop_q>
    1d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d4b:	89 04 24             	mov    %eax,(%esp)
    1d4e:	e8 f6 f8 ff ff       	call   1649 <twakeup>
    1d53:	c9                   	leave  
    1d54:	c3                   	ret    

00001d55 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1d55:	55                   	push   %ebp
    1d56:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1d58:	8b 45 08             	mov    0x8(%ebp),%eax
    1d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1d61:	8b 45 08             	mov    0x8(%ebp),%eax
    1d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1d6b:	8b 45 08             	mov    0x8(%ebp),%eax
    1d6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1d75:	5d                   	pop    %ebp
    1d76:	c3                   	ret    

00001d77 <add_q>:

void add_q(struct queue *q, int v){
    1d77:	55                   	push   %ebp
    1d78:	89 e5                	mov    %esp,%ebp
    1d7a:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1d7d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1d84:	e8 a4 fc ff ff       	call   1a2d <malloc>
    1d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d99:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d9c:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1d9e:	8b 45 08             	mov    0x8(%ebp),%eax
    1da1:	8b 40 04             	mov    0x4(%eax),%eax
    1da4:	85 c0                	test   %eax,%eax
    1da6:	75 0b                	jne    1db3 <add_q+0x3c>
        q->head = n;
    1da8:	8b 45 08             	mov    0x8(%ebp),%eax
    1dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1dae:	89 50 04             	mov    %edx,0x4(%eax)
    1db1:	eb 0c                	jmp    1dbf <add_q+0x48>
    }else{
        q->tail->next = n;
    1db3:	8b 45 08             	mov    0x8(%ebp),%eax
    1db6:	8b 40 08             	mov    0x8(%eax),%eax
    1db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1dbc:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1dbf:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1dc5:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1dc8:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcb:	8b 00                	mov    (%eax),%eax
    1dcd:	8d 50 01             	lea    0x1(%eax),%edx
    1dd0:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd3:	89 10                	mov    %edx,(%eax)
}
    1dd5:	c9                   	leave  
    1dd6:	c3                   	ret    

00001dd7 <empty_q>:

int empty_q(struct queue *q){
    1dd7:	55                   	push   %ebp
    1dd8:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1dda:	8b 45 08             	mov    0x8(%ebp),%eax
    1ddd:	8b 00                	mov    (%eax),%eax
    1ddf:	85 c0                	test   %eax,%eax
    1de1:	75 07                	jne    1dea <empty_q+0x13>
        return 1;
    1de3:	b8 01 00 00 00       	mov    $0x1,%eax
    1de8:	eb 05                	jmp    1def <empty_q+0x18>
    else
        return 0;
    1dea:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1def:	5d                   	pop    %ebp
    1df0:	c3                   	ret    

00001df1 <pop_q>:
int pop_q(struct queue *q){
    1df1:	55                   	push   %ebp
    1df2:	89 e5                	mov    %esp,%ebp
    1df4:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1df7:	8b 45 08             	mov    0x8(%ebp),%eax
    1dfa:	89 04 24             	mov    %eax,(%esp)
    1dfd:	e8 d5 ff ff ff       	call   1dd7 <empty_q>
    1e02:	85 c0                	test   %eax,%eax
    1e04:	75 5d                	jne    1e63 <pop_q+0x72>
       val = q->head->value; 
    1e06:	8b 45 08             	mov    0x8(%ebp),%eax
    1e09:	8b 40 04             	mov    0x4(%eax),%eax
    1e0c:	8b 00                	mov    (%eax),%eax
    1e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1e11:	8b 45 08             	mov    0x8(%ebp),%eax
    1e14:	8b 40 04             	mov    0x4(%eax),%eax
    1e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1e1a:	8b 45 08             	mov    0x8(%ebp),%eax
    1e1d:	8b 40 04             	mov    0x4(%eax),%eax
    1e20:	8b 50 04             	mov    0x4(%eax),%edx
    1e23:	8b 45 08             	mov    0x8(%ebp),%eax
    1e26:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e2c:	89 04 24             	mov    %eax,(%esp)
    1e2f:	e8 c0 fa ff ff       	call   18f4 <free>
       q->size--;
    1e34:	8b 45 08             	mov    0x8(%ebp),%eax
    1e37:	8b 00                	mov    (%eax),%eax
    1e39:	8d 50 ff             	lea    -0x1(%eax),%edx
    1e3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1e3f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1e41:	8b 45 08             	mov    0x8(%ebp),%eax
    1e44:	8b 00                	mov    (%eax),%eax
    1e46:	85 c0                	test   %eax,%eax
    1e48:	75 14                	jne    1e5e <pop_q+0x6d>
            q->head = 0;
    1e4a:	8b 45 08             	mov    0x8(%ebp),%eax
    1e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1e54:	8b 45 08             	mov    0x8(%ebp),%eax
    1e57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e61:	eb 05                	jmp    1e68 <pop_q+0x77>
    }
    return -1;
    1e63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1e68:	c9                   	leave  
    1e69:	c3                   	ret    
