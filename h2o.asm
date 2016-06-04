
_h2o:     file format elf32-i386


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
    1018:	e8 11 0d 00 00       	call   1d2e <init_q>
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
    102e:	e8 b7 05 00 00       	call   15ea <getpid>
    1033:	8b 55 08             	mov    0x8(%ebp),%edx
    1036:	83 c2 04             	add    $0x4,%edx
    1039:	89 44 24 04          	mov    %eax,0x4(%esp)
    103d:	89 14 24             	mov    %edx,(%esp)
    1040:	e8 0b 0d 00 00       	call   1d50 <add_q>
      while((s->count == 0) ) wait();
    1045:	eb 05                	jmp    104c <sema_acquire+0x2d>
    1047:	e8 26 05 00 00       	call   1572 <wait>
    104c:	8b 45 08             	mov    0x8(%ebp),%eax
    104f:	8b 00                	mov    (%eax),%eax
    1051:	85 c0                	test   %eax,%eax
    1053:	74 f2                	je     1047 <sema_acquire+0x28>
      pop_q(&(s->q));
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	83 c0 04             	add    $0x4,%eax
    105b:	89 04 24             	mov    %eax,(%esp)
    105e:	e8 67 0d 00 00       	call   1dca <pop_q>
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
    108f:	a1 98 23 00 00       	mov    0x2398,%eax
    1094:	89 44 24 08          	mov    %eax,0x8(%esp)
    1098:	c7 44 24 04 43 1e 00 	movl   $0x1e43,0x4(%esp)
    109f:	00 
    10a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a7:	e8 6e 06 00 00       	call   171a <printf>
    sema_init(h);
    10ac:	a1 b4 23 00 00       	mov    0x23b4,%eax
    10b1:	89 04 24             	mov    %eax,(%esp)
    10b4:	e8 47 ff ff ff       	call   1000 <sema_init>
    //sema_init(h2);
    sema_init(o);
    10b9:	a1 b0 23 00 00       	mov    0x23b0,%eax
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 3a ff ff ff       	call   1000 <sema_init>
    printf(1,"H Count: %d\n", h->count);
    10c6:	a1 b4 23 00 00       	mov    0x23b4,%eax
    10cb:	8b 00                	mov    (%eax),%eax
    10cd:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d1:	c7 44 24 04 54 1e 00 	movl   $0x1e54,0x4(%esp)
    10d8:	00 
    10d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e0:	e8 35 06 00 00       	call   171a <printf>
    printf(1,"O Count: %d\n", o->count);
    10e5:	a1 b0 23 00 00       	mov    0x23b0,%eax
    10ea:	8b 00                	mov    (%eax),%eax
    10ec:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f0:	c7 44 24 04 61 1e 00 	movl   $0x1e61,0x4(%esp)
    10f7:	00 
    10f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ff:	e8 16 06 00 00       	call   171a <printf>
    thread_create(hReady, (void *)&water_molecules);
    1104:	c7 44 24 04 98 23 00 	movl   $0x2398,0x4(%esp)
    110b:	00 
    110c:	c7 04 24 4e 12 00 00 	movl   $0x124e,(%esp)
    1113:	e8 31 0a 00 00       	call   1b49 <thread_create>
    thread_create(hReady, (void *)&water_molecules);
    1118:	c7 44 24 04 98 23 00 	movl   $0x2398,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 4e 12 00 00 	movl   $0x124e,(%esp)
    1127:	e8 1d 0a 00 00       	call   1b49 <thread_create>
    thread_create(oReady, (void *)&water_molecules);
    112c:	c7 44 24 04 98 23 00 	movl   $0x2398,0x4(%esp)
    1133:	00 
    1134:	c7 04 24 9b 12 00 00 	movl   $0x129b,(%esp)
    113b:	e8 09 0a 00 00       	call   1b49 <thread_create>
    printf(1,"H Count: %d\n", h->count);
    1140:	a1 b4 23 00 00       	mov    0x23b4,%eax
    1145:	8b 00                	mov    (%eax),%eax
    1147:	89 44 24 08          	mov    %eax,0x8(%esp)
    114b:	c7 44 24 04 54 1e 00 	movl   $0x1e54,0x4(%esp)
    1152:	00 
    1153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115a:	e8 bb 05 00 00       	call   171a <printf>
    printf(1,"O Count: %d\n", o->count);
    115f:	a1 b0 23 00 00       	mov    0x23b0,%eax
    1164:	8b 00                	mov    (%eax),%eax
    1166:	89 44 24 08          	mov    %eax,0x8(%esp)
    116a:	c7 44 24 04 61 1e 00 	movl   $0x1e61,0x4(%esp)
    1171:	00 
    1172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1179:	e8 9c 05 00 00       	call   171a <printf>
    while(wait() >= 0){}
    117e:	90                   	nop
    117f:	e8 ee 03 00 00       	call   1572 <wait>
    1184:	85 c0                	test   %eax,%eax
    1186:	79 f7                	jns    117f <main+0xf9>
    //wait();
    printf(1,"Waited 1\n");
    1188:	c7 44 24 04 6e 1e 00 	movl   $0x1e6e,0x4(%esp)
    118f:	00 
    1190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1197:	e8 7e 05 00 00       	call   171a <printf>
    //thread_yield_last();
    //wait();
    printf(1,"Waited 2\n");
    119c:	c7 44 24 04 78 1e 00 	movl   $0x1e78,0x4(%esp)
    11a3:	00 
    11a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ab:	e8 6a 05 00 00       	call   171a <printf>
    //thread_yield_last();
    //wait();
    //printf(1,"Waited 3\n");
    printf(1,"Water Count: %d\n", water_molecules);
    11b0:	a1 98 23 00 00       	mov    0x2398,%eax
    11b5:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b9:	c7 44 24 04 43 1e 00 	movl   $0x1e43,0x4(%esp)
    11c0:	00 
    11c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c8:	e8 4d 05 00 00       	call   171a <printf>
    exit();
    11cd:	e8 98 03 00 00       	call   156a <exit>

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
    11e8:	c7 44 24 04 82 1e 00 	movl   $0x1e82,0x4(%esp)
    11ef:	00 
    11f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11f7:	e8 1e 05 00 00       	call   171a <printf>
        thread_yield2();
    11fc:	e8 7e 0a 00 00       	call   1c7f <thread_yield2>
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
    120b:	e8 02 04 00 00       	call   1612 <texit>

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
    1226:	c7 44 24 04 8c 1e 00 	movl   $0x1e8c,0x4(%esp)
    122d:	00 
    122e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1235:	e8 e0 04 00 00       	call   171a <printf>
        thread_yield2();
    123a:	e8 40 0a 00 00       	call   1c7f <thread_yield2>
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
    1249:	e8 c4 03 00 00       	call   1612 <texit>

0000124e <hReady>:
}

void hReady(void *water) {
    124e:	55                   	push   %ebp
    124f:	89 e5                	mov    %esp,%ebp
    1251:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Added H\n");
    1254:	c7 44 24 04 96 1e 00 	movl   $0x1e96,0x4(%esp)
    125b:	00 
    125c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1263:	e8 b2 04 00 00       	call   171a <printf>
    sema_signal(h);
    1268:	a1 b4 23 00 00       	mov    0x23b4,%eax
    126d:	89 04 24             	mov    %eax,(%esp)
    1270:	e8 ff fd ff ff       	call   1074 <sema_signal>
    sema_acquire(o);
    1275:	a1 b0 23 00 00       	mov    0x23b0,%eax
    127a:	89 04 24             	mov    %eax,(%esp)
    127d:	e8 9d fd ff ff       	call   101f <sema_acquire>
    printf(1, "Exit H\n");
    1282:	c7 44 24 04 9f 1e 00 	movl   $0x1e9f,0x4(%esp)
    1289:	00 
    128a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1291:	e8 84 04 00 00       	call   171a <printf>
    texit();
    1296:	e8 77 03 00 00       	call   1612 <texit>

0000129b <oReady>:
}

void oReady(void *water) {
    129b:	55                   	push   %ebp
    129c:	89 e5                	mov    %esp,%ebp
    129e:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Added O\n");
    12a1:	c7 44 24 04 a7 1e 00 	movl   $0x1ea7,0x4(%esp)
    12a8:	00 
    12a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b0:	e8 65 04 00 00       	call   171a <printf>
    sema_acquire(h);
    12b5:	a1 b4 23 00 00       	mov    0x23b4,%eax
    12ba:	89 04 24             	mov    %eax,(%esp)
    12bd:	e8 5d fd ff ff       	call   101f <sema_acquire>
    sema_acquire(h);
    12c2:	a1 b4 23 00 00       	mov    0x23b4,%eax
    12c7:	89 04 24             	mov    %eax,(%esp)
    12ca:	e8 50 fd ff ff       	call   101f <sema_acquire>
    sema_signal(o);
    12cf:	a1 b0 23 00 00       	mov    0x23b0,%eax
    12d4:	89 04 24             	mov    %eax,(%esp)
    12d7:	e8 98 fd ff ff       	call   1074 <sema_signal>
    water_molecules++;
    12dc:	a1 98 23 00 00       	mov    0x2398,%eax
    12e1:	83 c0 01             	add    $0x1,%eax
    12e4:	a3 98 23 00 00       	mov    %eax,0x2398
    printf(1, "Exit O\n");
    12e9:	c7 44 24 04 b0 1e 00 	movl   $0x1eb0,0x4(%esp)
    12f0:	00 
    12f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12f8:	e8 1d 04 00 00       	call   171a <printf>
    texit();
    12fd:	e8 10 03 00 00       	call   1612 <texit>

00001302 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1302:	55                   	push   %ebp
    1303:	89 e5                	mov    %esp,%ebp
    1305:	57                   	push   %edi
    1306:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1307:	8b 4d 08             	mov    0x8(%ebp),%ecx
    130a:	8b 55 10             	mov    0x10(%ebp),%edx
    130d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1310:	89 cb                	mov    %ecx,%ebx
    1312:	89 df                	mov    %ebx,%edi
    1314:	89 d1                	mov    %edx,%ecx
    1316:	fc                   	cld    
    1317:	f3 aa                	rep stos %al,%es:(%edi)
    1319:	89 ca                	mov    %ecx,%edx
    131b:	89 fb                	mov    %edi,%ebx
    131d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1320:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1323:	5b                   	pop    %ebx
    1324:	5f                   	pop    %edi
    1325:	5d                   	pop    %ebp
    1326:	c3                   	ret    

00001327 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1327:	55                   	push   %ebp
    1328:	89 e5                	mov    %esp,%ebp
    132a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    132d:	8b 45 08             	mov    0x8(%ebp),%eax
    1330:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1333:	90                   	nop
    1334:	8b 45 08             	mov    0x8(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 08             	mov    %edx,0x8(%ebp)
    133d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1340:	8d 4a 01             	lea    0x1(%edx),%ecx
    1343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1346:	0f b6 12             	movzbl (%edx),%edx
    1349:	88 10                	mov    %dl,(%eax)
    134b:	0f b6 00             	movzbl (%eax),%eax
    134e:	84 c0                	test   %al,%al
    1350:	75 e2                	jne    1334 <strcpy+0xd>
    ;
  return os;
    1352:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1355:	c9                   	leave  
    1356:	c3                   	ret    

00001357 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1357:	55                   	push   %ebp
    1358:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    135a:	eb 08                	jmp    1364 <strcmp+0xd>
    p++, q++;
    135c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1360:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1364:	8b 45 08             	mov    0x8(%ebp),%eax
    1367:	0f b6 00             	movzbl (%eax),%eax
    136a:	84 c0                	test   %al,%al
    136c:	74 10                	je     137e <strcmp+0x27>
    136e:	8b 45 08             	mov    0x8(%ebp),%eax
    1371:	0f b6 10             	movzbl (%eax),%edx
    1374:	8b 45 0c             	mov    0xc(%ebp),%eax
    1377:	0f b6 00             	movzbl (%eax),%eax
    137a:	38 c2                	cmp    %al,%dl
    137c:	74 de                	je     135c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    137e:	8b 45 08             	mov    0x8(%ebp),%eax
    1381:	0f b6 00             	movzbl (%eax),%eax
    1384:	0f b6 d0             	movzbl %al,%edx
    1387:	8b 45 0c             	mov    0xc(%ebp),%eax
    138a:	0f b6 00             	movzbl (%eax),%eax
    138d:	0f b6 c0             	movzbl %al,%eax
    1390:	29 c2                	sub    %eax,%edx
    1392:	89 d0                	mov    %edx,%eax
}
    1394:	5d                   	pop    %ebp
    1395:	c3                   	ret    

00001396 <strlen>:

uint
strlen(char *s)
{
    1396:	55                   	push   %ebp
    1397:	89 e5                	mov    %esp,%ebp
    1399:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    139c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13a3:	eb 04                	jmp    13a9 <strlen+0x13>
    13a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
    13af:	01 d0                	add    %edx,%eax
    13b1:	0f b6 00             	movzbl (%eax),%eax
    13b4:	84 c0                	test   %al,%al
    13b6:	75 ed                	jne    13a5 <strlen+0xf>
    ;
  return n;
    13b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13bb:	c9                   	leave  
    13bc:	c3                   	ret    

000013bd <memset>:

void*
memset(void *dst, int c, uint n)
{
    13bd:	55                   	push   %ebp
    13be:	89 e5                	mov    %esp,%ebp
    13c0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    13c3:	8b 45 10             	mov    0x10(%ebp),%eax
    13c6:	89 44 24 08          	mov    %eax,0x8(%esp)
    13ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	89 04 24             	mov    %eax,(%esp)
    13d7:	e8 26 ff ff ff       	call   1302 <stosb>
  return dst;
    13dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13df:	c9                   	leave  
    13e0:	c3                   	ret    

000013e1 <strchr>:

char*
strchr(const char *s, char c)
{
    13e1:	55                   	push   %ebp
    13e2:	89 e5                	mov    %esp,%ebp
    13e4:	83 ec 04             	sub    $0x4,%esp
    13e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ea:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    13ed:	eb 14                	jmp    1403 <strchr+0x22>
    if(*s == c)
    13ef:	8b 45 08             	mov    0x8(%ebp),%eax
    13f2:	0f b6 00             	movzbl (%eax),%eax
    13f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
    13f8:	75 05                	jne    13ff <strchr+0x1e>
      return (char*)s;
    13fa:	8b 45 08             	mov    0x8(%ebp),%eax
    13fd:	eb 13                	jmp    1412 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    13ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1403:	8b 45 08             	mov    0x8(%ebp),%eax
    1406:	0f b6 00             	movzbl (%eax),%eax
    1409:	84 c0                	test   %al,%al
    140b:	75 e2                	jne    13ef <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    140d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1412:	c9                   	leave  
    1413:	c3                   	ret    

00001414 <gets>:

char*
gets(char *buf, int max)
{
    1414:	55                   	push   %ebp
    1415:	89 e5                	mov    %esp,%ebp
    1417:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    141a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1421:	eb 4c                	jmp    146f <gets+0x5b>
    cc = read(0, &c, 1);
    1423:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    142a:	00 
    142b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    142e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1439:	e8 44 01 00 00       	call   1582 <read>
    143e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1445:	7f 02                	jg     1449 <gets+0x35>
      break;
    1447:	eb 31                	jmp    147a <gets+0x66>
    buf[i++] = c;
    1449:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144c:	8d 50 01             	lea    0x1(%eax),%edx
    144f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1452:	89 c2                	mov    %eax,%edx
    1454:	8b 45 08             	mov    0x8(%ebp),%eax
    1457:	01 c2                	add    %eax,%edx
    1459:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    145d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    145f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1463:	3c 0a                	cmp    $0xa,%al
    1465:	74 13                	je     147a <gets+0x66>
    1467:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    146b:	3c 0d                	cmp    $0xd,%al
    146d:	74 0b                	je     147a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1472:	83 c0 01             	add    $0x1,%eax
    1475:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1478:	7c a9                	jl     1423 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    147a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    147d:	8b 45 08             	mov    0x8(%ebp),%eax
    1480:	01 d0                	add    %edx,%eax
    1482:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1485:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1488:	c9                   	leave  
    1489:	c3                   	ret    

0000148a <stat>:

int
stat(char *n, struct stat *st)
{
    148a:	55                   	push   %ebp
    148b:	89 e5                	mov    %esp,%ebp
    148d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1490:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1497:	00 
    1498:	8b 45 08             	mov    0x8(%ebp),%eax
    149b:	89 04 24             	mov    %eax,(%esp)
    149e:	e8 07 01 00 00       	call   15aa <open>
    14a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14aa:	79 07                	jns    14b3 <stat+0x29>
    return -1;
    14ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14b1:	eb 23                	jmp    14d6 <stat+0x4c>
  r = fstat(fd, st);
    14b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bd:	89 04 24             	mov    %eax,(%esp)
    14c0:	e8 fd 00 00 00       	call   15c2 <fstat>
    14c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cb:	89 04 24             	mov    %eax,(%esp)
    14ce:	e8 bf 00 00 00       	call   1592 <close>
  return r;
    14d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    14d6:	c9                   	leave  
    14d7:	c3                   	ret    

000014d8 <atoi>:

int
atoi(const char *s)
{
    14d8:	55                   	push   %ebp
    14d9:	89 e5                	mov    %esp,%ebp
    14db:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    14de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    14e5:	eb 25                	jmp    150c <atoi+0x34>
    n = n*10 + *s++ - '0';
    14e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14ea:	89 d0                	mov    %edx,%eax
    14ec:	c1 e0 02             	shl    $0x2,%eax
    14ef:	01 d0                	add    %edx,%eax
    14f1:	01 c0                	add    %eax,%eax
    14f3:	89 c1                	mov    %eax,%ecx
    14f5:	8b 45 08             	mov    0x8(%ebp),%eax
    14f8:	8d 50 01             	lea    0x1(%eax),%edx
    14fb:	89 55 08             	mov    %edx,0x8(%ebp)
    14fe:	0f b6 00             	movzbl (%eax),%eax
    1501:	0f be c0             	movsbl %al,%eax
    1504:	01 c8                	add    %ecx,%eax
    1506:	83 e8 30             	sub    $0x30,%eax
    1509:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    150c:	8b 45 08             	mov    0x8(%ebp),%eax
    150f:	0f b6 00             	movzbl (%eax),%eax
    1512:	3c 2f                	cmp    $0x2f,%al
    1514:	7e 0a                	jle    1520 <atoi+0x48>
    1516:	8b 45 08             	mov    0x8(%ebp),%eax
    1519:	0f b6 00             	movzbl (%eax),%eax
    151c:	3c 39                	cmp    $0x39,%al
    151e:	7e c7                	jle    14e7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1520:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1523:	c9                   	leave  
    1524:	c3                   	ret    

00001525 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1525:	55                   	push   %ebp
    1526:	89 e5                	mov    %esp,%ebp
    1528:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    152b:	8b 45 08             	mov    0x8(%ebp),%eax
    152e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1531:	8b 45 0c             	mov    0xc(%ebp),%eax
    1534:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1537:	eb 17                	jmp    1550 <memmove+0x2b>
    *dst++ = *src++;
    1539:	8b 45 fc             	mov    -0x4(%ebp),%eax
    153c:	8d 50 01             	lea    0x1(%eax),%edx
    153f:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1542:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1545:	8d 4a 01             	lea    0x1(%edx),%ecx
    1548:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    154b:	0f b6 12             	movzbl (%edx),%edx
    154e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1550:	8b 45 10             	mov    0x10(%ebp),%eax
    1553:	8d 50 ff             	lea    -0x1(%eax),%edx
    1556:	89 55 10             	mov    %edx,0x10(%ebp)
    1559:	85 c0                	test   %eax,%eax
    155b:	7f dc                	jg     1539 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    155d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1560:	c9                   	leave  
    1561:	c3                   	ret    

00001562 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1562:	b8 01 00 00 00       	mov    $0x1,%eax
    1567:	cd 40                	int    $0x40
    1569:	c3                   	ret    

0000156a <exit>:
SYSCALL(exit)
    156a:	b8 02 00 00 00       	mov    $0x2,%eax
    156f:	cd 40                	int    $0x40
    1571:	c3                   	ret    

00001572 <wait>:
SYSCALL(wait)
    1572:	b8 03 00 00 00       	mov    $0x3,%eax
    1577:	cd 40                	int    $0x40
    1579:	c3                   	ret    

0000157a <pipe>:
SYSCALL(pipe)
    157a:	b8 04 00 00 00       	mov    $0x4,%eax
    157f:	cd 40                	int    $0x40
    1581:	c3                   	ret    

00001582 <read>:
SYSCALL(read)
    1582:	b8 05 00 00 00       	mov    $0x5,%eax
    1587:	cd 40                	int    $0x40
    1589:	c3                   	ret    

0000158a <write>:
SYSCALL(write)
    158a:	b8 10 00 00 00       	mov    $0x10,%eax
    158f:	cd 40                	int    $0x40
    1591:	c3                   	ret    

00001592 <close>:
SYSCALL(close)
    1592:	b8 15 00 00 00       	mov    $0x15,%eax
    1597:	cd 40                	int    $0x40
    1599:	c3                   	ret    

0000159a <kill>:
SYSCALL(kill)
    159a:	b8 06 00 00 00       	mov    $0x6,%eax
    159f:	cd 40                	int    $0x40
    15a1:	c3                   	ret    

000015a2 <exec>:
SYSCALL(exec)
    15a2:	b8 07 00 00 00       	mov    $0x7,%eax
    15a7:	cd 40                	int    $0x40
    15a9:	c3                   	ret    

000015aa <open>:
SYSCALL(open)
    15aa:	b8 0f 00 00 00       	mov    $0xf,%eax
    15af:	cd 40                	int    $0x40
    15b1:	c3                   	ret    

000015b2 <mknod>:
SYSCALL(mknod)
    15b2:	b8 11 00 00 00       	mov    $0x11,%eax
    15b7:	cd 40                	int    $0x40
    15b9:	c3                   	ret    

000015ba <unlink>:
SYSCALL(unlink)
    15ba:	b8 12 00 00 00       	mov    $0x12,%eax
    15bf:	cd 40                	int    $0x40
    15c1:	c3                   	ret    

000015c2 <fstat>:
SYSCALL(fstat)
    15c2:	b8 08 00 00 00       	mov    $0x8,%eax
    15c7:	cd 40                	int    $0x40
    15c9:	c3                   	ret    

000015ca <link>:
SYSCALL(link)
    15ca:	b8 13 00 00 00       	mov    $0x13,%eax
    15cf:	cd 40                	int    $0x40
    15d1:	c3                   	ret    

000015d2 <mkdir>:
SYSCALL(mkdir)
    15d2:	b8 14 00 00 00       	mov    $0x14,%eax
    15d7:	cd 40                	int    $0x40
    15d9:	c3                   	ret    

000015da <chdir>:
SYSCALL(chdir)
    15da:	b8 09 00 00 00       	mov    $0x9,%eax
    15df:	cd 40                	int    $0x40
    15e1:	c3                   	ret    

000015e2 <dup>:
SYSCALL(dup)
    15e2:	b8 0a 00 00 00       	mov    $0xa,%eax
    15e7:	cd 40                	int    $0x40
    15e9:	c3                   	ret    

000015ea <getpid>:
SYSCALL(getpid)
    15ea:	b8 0b 00 00 00       	mov    $0xb,%eax
    15ef:	cd 40                	int    $0x40
    15f1:	c3                   	ret    

000015f2 <sbrk>:
SYSCALL(sbrk)
    15f2:	b8 0c 00 00 00       	mov    $0xc,%eax
    15f7:	cd 40                	int    $0x40
    15f9:	c3                   	ret    

000015fa <sleep>:
SYSCALL(sleep)
    15fa:	b8 0d 00 00 00       	mov    $0xd,%eax
    15ff:	cd 40                	int    $0x40
    1601:	c3                   	ret    

00001602 <uptime>:
SYSCALL(uptime)
    1602:	b8 0e 00 00 00       	mov    $0xe,%eax
    1607:	cd 40                	int    $0x40
    1609:	c3                   	ret    

0000160a <clone>:
SYSCALL(clone)
    160a:	b8 16 00 00 00       	mov    $0x16,%eax
    160f:	cd 40                	int    $0x40
    1611:	c3                   	ret    

00001612 <texit>:
SYSCALL(texit)
    1612:	b8 17 00 00 00       	mov    $0x17,%eax
    1617:	cd 40                	int    $0x40
    1619:	c3                   	ret    

0000161a <tsleep>:
SYSCALL(tsleep)
    161a:	b8 18 00 00 00       	mov    $0x18,%eax
    161f:	cd 40                	int    $0x40
    1621:	c3                   	ret    

00001622 <twakeup>:
SYSCALL(twakeup)
    1622:	b8 19 00 00 00       	mov    $0x19,%eax
    1627:	cd 40                	int    $0x40
    1629:	c3                   	ret    

0000162a <thread_yield>:
SYSCALL(thread_yield)
    162a:	b8 1a 00 00 00       	mov    $0x1a,%eax
    162f:	cd 40                	int    $0x40
    1631:	c3                   	ret    

00001632 <thread_yield3>:
    1632:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1637:	cd 40                	int    $0x40
    1639:	c3                   	ret    

0000163a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    163a:	55                   	push   %ebp
    163b:	89 e5                	mov    %esp,%ebp
    163d:	83 ec 18             	sub    $0x18,%esp
    1640:	8b 45 0c             	mov    0xc(%ebp),%eax
    1643:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1646:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    164d:	00 
    164e:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1651:	89 44 24 04          	mov    %eax,0x4(%esp)
    1655:	8b 45 08             	mov    0x8(%ebp),%eax
    1658:	89 04 24             	mov    %eax,(%esp)
    165b:	e8 2a ff ff ff       	call   158a <write>
}
    1660:	c9                   	leave  
    1661:	c3                   	ret    

00001662 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1662:	55                   	push   %ebp
    1663:	89 e5                	mov    %esp,%ebp
    1665:	56                   	push   %esi
    1666:	53                   	push   %ebx
    1667:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    166a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1671:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1675:	74 17                	je     168e <printint+0x2c>
    1677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    167b:	79 11                	jns    168e <printint+0x2c>
    neg = 1;
    167d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1684:	8b 45 0c             	mov    0xc(%ebp),%eax
    1687:	f7 d8                	neg    %eax
    1689:	89 45 ec             	mov    %eax,-0x14(%ebp)
    168c:	eb 06                	jmp    1694 <printint+0x32>
  } else {
    x = xx;
    168e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    169b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    169e:	8d 41 01             	lea    0x1(%ecx),%eax
    16a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16aa:	ba 00 00 00 00       	mov    $0x0,%edx
    16af:	f7 f3                	div    %ebx
    16b1:	89 d0                	mov    %edx,%eax
    16b3:	0f b6 80 80 23 00 00 	movzbl 0x2380(%eax),%eax
    16ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16be:	8b 75 10             	mov    0x10(%ebp),%esi
    16c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16c4:	ba 00 00 00 00       	mov    $0x0,%edx
    16c9:	f7 f6                	div    %esi
    16cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16d2:	75 c7                	jne    169b <printint+0x39>
  if(neg)
    16d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16d8:	74 10                	je     16ea <printint+0x88>
    buf[i++] = '-';
    16da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16dd:	8d 50 01             	lea    0x1(%eax),%edx
    16e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    16e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    16e8:	eb 1f                	jmp    1709 <printint+0xa7>
    16ea:	eb 1d                	jmp    1709 <printint+0xa7>
    putc(fd, buf[i]);
    16ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f2:	01 d0                	add    %edx,%eax
    16f4:	0f b6 00             	movzbl (%eax),%eax
    16f7:	0f be c0             	movsbl %al,%eax
    16fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    16fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1701:	89 04 24             	mov    %eax,(%esp)
    1704:	e8 31 ff ff ff       	call   163a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1709:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    170d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1711:	79 d9                	jns    16ec <printint+0x8a>
    putc(fd, buf[i]);
}
    1713:	83 c4 30             	add    $0x30,%esp
    1716:	5b                   	pop    %ebx
    1717:	5e                   	pop    %esi
    1718:	5d                   	pop    %ebp
    1719:	c3                   	ret    

0000171a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    171a:	55                   	push   %ebp
    171b:	89 e5                	mov    %esp,%ebp
    171d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1720:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1727:	8d 45 0c             	lea    0xc(%ebp),%eax
    172a:	83 c0 04             	add    $0x4,%eax
    172d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1737:	e9 7c 01 00 00       	jmp    18b8 <printf+0x19e>
    c = fmt[i] & 0xff;
    173c:	8b 55 0c             	mov    0xc(%ebp),%edx
    173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1742:	01 d0                	add    %edx,%eax
    1744:	0f b6 00             	movzbl (%eax),%eax
    1747:	0f be c0             	movsbl %al,%eax
    174a:	25 ff 00 00 00       	and    $0xff,%eax
    174f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1752:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1756:	75 2c                	jne    1784 <printf+0x6a>
      if(c == '%'){
    1758:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    175c:	75 0c                	jne    176a <printf+0x50>
        state = '%';
    175e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1765:	e9 4a 01 00 00       	jmp    18b4 <printf+0x19a>
      } else {
        putc(fd, c);
    176a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    176d:	0f be c0             	movsbl %al,%eax
    1770:	89 44 24 04          	mov    %eax,0x4(%esp)
    1774:	8b 45 08             	mov    0x8(%ebp),%eax
    1777:	89 04 24             	mov    %eax,(%esp)
    177a:	e8 bb fe ff ff       	call   163a <putc>
    177f:	e9 30 01 00 00       	jmp    18b4 <printf+0x19a>
      }
    } else if(state == '%'){
    1784:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1788:	0f 85 26 01 00 00    	jne    18b4 <printf+0x19a>
      if(c == 'd'){
    178e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1792:	75 2d                	jne    17c1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1794:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1797:	8b 00                	mov    (%eax),%eax
    1799:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17a0:	00 
    17a1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17a8:	00 
    17a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    17ad:	8b 45 08             	mov    0x8(%ebp),%eax
    17b0:	89 04 24             	mov    %eax,(%esp)
    17b3:	e8 aa fe ff ff       	call   1662 <printint>
        ap++;
    17b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17bc:	e9 ec 00 00 00       	jmp    18ad <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17c1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17c5:	74 06                	je     17cd <printf+0xb3>
    17c7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17cb:	75 2d                	jne    17fa <printf+0xe0>
        printint(fd, *ap, 16, 0);
    17cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17d0:	8b 00                	mov    (%eax),%eax
    17d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    17d9:	00 
    17da:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    17e1:	00 
    17e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e6:	8b 45 08             	mov    0x8(%ebp),%eax
    17e9:	89 04 24             	mov    %eax,(%esp)
    17ec:	e8 71 fe ff ff       	call   1662 <printint>
        ap++;
    17f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17f5:	e9 b3 00 00 00       	jmp    18ad <printf+0x193>
      } else if(c == 's'){
    17fa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    17fe:	75 45                	jne    1845 <printf+0x12b>
        s = (char*)*ap;
    1800:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1803:	8b 00                	mov    (%eax),%eax
    1805:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1808:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    180c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1810:	75 09                	jne    181b <printf+0x101>
          s = "(null)";
    1812:	c7 45 f4 b8 1e 00 00 	movl   $0x1eb8,-0xc(%ebp)
        while(*s != 0){
    1819:	eb 1e                	jmp    1839 <printf+0x11f>
    181b:	eb 1c                	jmp    1839 <printf+0x11f>
          putc(fd, *s);
    181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1820:	0f b6 00             	movzbl (%eax),%eax
    1823:	0f be c0             	movsbl %al,%eax
    1826:	89 44 24 04          	mov    %eax,0x4(%esp)
    182a:	8b 45 08             	mov    0x8(%ebp),%eax
    182d:	89 04 24             	mov    %eax,(%esp)
    1830:	e8 05 fe ff ff       	call   163a <putc>
          s++;
    1835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1839:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183c:	0f b6 00             	movzbl (%eax),%eax
    183f:	84 c0                	test   %al,%al
    1841:	75 da                	jne    181d <printf+0x103>
    1843:	eb 68                	jmp    18ad <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1845:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1849:	75 1d                	jne    1868 <printf+0x14e>
        putc(fd, *ap);
    184b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    184e:	8b 00                	mov    (%eax),%eax
    1850:	0f be c0             	movsbl %al,%eax
    1853:	89 44 24 04          	mov    %eax,0x4(%esp)
    1857:	8b 45 08             	mov    0x8(%ebp),%eax
    185a:	89 04 24             	mov    %eax,(%esp)
    185d:	e8 d8 fd ff ff       	call   163a <putc>
        ap++;
    1862:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1866:	eb 45                	jmp    18ad <printf+0x193>
      } else if(c == '%'){
    1868:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    186c:	75 17                	jne    1885 <printf+0x16b>
        putc(fd, c);
    186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1871:	0f be c0             	movsbl %al,%eax
    1874:	89 44 24 04          	mov    %eax,0x4(%esp)
    1878:	8b 45 08             	mov    0x8(%ebp),%eax
    187b:	89 04 24             	mov    %eax,(%esp)
    187e:	e8 b7 fd ff ff       	call   163a <putc>
    1883:	eb 28                	jmp    18ad <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1885:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    188c:	00 
    188d:	8b 45 08             	mov    0x8(%ebp),%eax
    1890:	89 04 24             	mov    %eax,(%esp)
    1893:	e8 a2 fd ff ff       	call   163a <putc>
        putc(fd, c);
    1898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    189b:	0f be c0             	movsbl %al,%eax
    189e:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	89 04 24             	mov    %eax,(%esp)
    18a8:	e8 8d fd ff ff       	call   163a <putc>
      }
      state = 0;
    18ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18b8:	8b 55 0c             	mov    0xc(%ebp),%edx
    18bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18be:	01 d0                	add    %edx,%eax
    18c0:	0f b6 00             	movzbl (%eax),%eax
    18c3:	84 c0                	test   %al,%al
    18c5:	0f 85 71 fe ff ff    	jne    173c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18cb:	c9                   	leave  
    18cc:	c3                   	ret    

000018cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18cd:	55                   	push   %ebp
    18ce:	89 e5                	mov    %esp,%ebp
    18d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18d3:	8b 45 08             	mov    0x8(%ebp),%eax
    18d6:	83 e8 08             	sub    $0x8,%eax
    18d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18dc:	a1 a4 23 00 00       	mov    0x23a4,%eax
    18e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18e4:	eb 24                	jmp    190a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e9:	8b 00                	mov    (%eax),%eax
    18eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18ee:	77 12                	ja     1902 <free+0x35>
    18f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18f6:	77 24                	ja     191c <free+0x4f>
    18f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18fb:	8b 00                	mov    (%eax),%eax
    18fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1900:	77 1a                	ja     191c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1902:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1905:	8b 00                	mov    (%eax),%eax
    1907:	89 45 fc             	mov    %eax,-0x4(%ebp)
    190a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    190d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1910:	76 d4                	jbe    18e6 <free+0x19>
    1912:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1915:	8b 00                	mov    (%eax),%eax
    1917:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    191a:	76 ca                	jbe    18e6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    191c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    191f:	8b 40 04             	mov    0x4(%eax),%eax
    1922:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1929:	8b 45 f8             	mov    -0x8(%ebp),%eax
    192c:	01 c2                	add    %eax,%edx
    192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1931:	8b 00                	mov    (%eax),%eax
    1933:	39 c2                	cmp    %eax,%edx
    1935:	75 24                	jne    195b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1937:	8b 45 f8             	mov    -0x8(%ebp),%eax
    193a:	8b 50 04             	mov    0x4(%eax),%edx
    193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1940:	8b 00                	mov    (%eax),%eax
    1942:	8b 40 04             	mov    0x4(%eax),%eax
    1945:	01 c2                	add    %eax,%edx
    1947:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    194d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1950:	8b 00                	mov    (%eax),%eax
    1952:	8b 10                	mov    (%eax),%edx
    1954:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1957:	89 10                	mov    %edx,(%eax)
    1959:	eb 0a                	jmp    1965 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195e:	8b 10                	mov    (%eax),%edx
    1960:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1963:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1965:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1968:	8b 40 04             	mov    0x4(%eax),%eax
    196b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1972:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1975:	01 d0                	add    %edx,%eax
    1977:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    197a:	75 20                	jne    199c <free+0xcf>
    p->s.size += bp->s.size;
    197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197f:	8b 50 04             	mov    0x4(%eax),%edx
    1982:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1985:	8b 40 04             	mov    0x4(%eax),%eax
    1988:	01 c2                	add    %eax,%edx
    198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1990:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1993:	8b 10                	mov    (%eax),%edx
    1995:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1998:	89 10                	mov    %edx,(%eax)
    199a:	eb 08                	jmp    19a4 <free+0xd7>
  } else
    p->s.ptr = bp;
    199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19a2:	89 10                	mov    %edx,(%eax)
  freep = p;
    19a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a7:	a3 a4 23 00 00       	mov    %eax,0x23a4
}
    19ac:	c9                   	leave  
    19ad:	c3                   	ret    

000019ae <morecore>:

static Header*
morecore(uint nu)
{
    19ae:	55                   	push   %ebp
    19af:	89 e5                	mov    %esp,%ebp
    19b1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19bb:	77 07                	ja     19c4 <morecore+0x16>
    nu = 4096;
    19bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19c4:	8b 45 08             	mov    0x8(%ebp),%eax
    19c7:	c1 e0 03             	shl    $0x3,%eax
    19ca:	89 04 24             	mov    %eax,(%esp)
    19cd:	e8 20 fc ff ff       	call   15f2 <sbrk>
    19d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    19d5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    19d9:	75 07                	jne    19e2 <morecore+0x34>
    return 0;
    19db:	b8 00 00 00 00       	mov    $0x0,%eax
    19e0:	eb 22                	jmp    1a04 <morecore+0x56>
  hp = (Header*)p;
    19e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    19e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19eb:	8b 55 08             	mov    0x8(%ebp),%edx
    19ee:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    19f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19f4:	83 c0 08             	add    $0x8,%eax
    19f7:	89 04 24             	mov    %eax,(%esp)
    19fa:	e8 ce fe ff ff       	call   18cd <free>
  return freep;
    19ff:	a1 a4 23 00 00       	mov    0x23a4,%eax
}
    1a04:	c9                   	leave  
    1a05:	c3                   	ret    

00001a06 <malloc>:

void*
malloc(uint nbytes)
{
    1a06:	55                   	push   %ebp
    1a07:	89 e5                	mov    %esp,%ebp
    1a09:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1a0f:	83 c0 07             	add    $0x7,%eax
    1a12:	c1 e8 03             	shr    $0x3,%eax
    1a15:	83 c0 01             	add    $0x1,%eax
    1a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a1b:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a27:	75 23                	jne    1a4c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a29:	c7 45 f0 9c 23 00 00 	movl   $0x239c,-0x10(%ebp)
    1a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a33:	a3 a4 23 00 00       	mov    %eax,0x23a4
    1a38:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1a3d:	a3 9c 23 00 00       	mov    %eax,0x239c
    base.s.size = 0;
    1a42:	c7 05 a0 23 00 00 00 	movl   $0x0,0x23a0
    1a49:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a4f:	8b 00                	mov    (%eax),%eax
    1a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a57:	8b 40 04             	mov    0x4(%eax),%eax
    1a5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a5d:	72 4d                	jb     1aac <malloc+0xa6>
      if(p->s.size == nunits)
    1a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a62:	8b 40 04             	mov    0x4(%eax),%eax
    1a65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a68:	75 0c                	jne    1a76 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a6d:	8b 10                	mov    (%eax),%edx
    1a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a72:	89 10                	mov    %edx,(%eax)
    1a74:	eb 26                	jmp    1a9c <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a79:	8b 40 04             	mov    0x4(%eax),%eax
    1a7c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1a7f:	89 c2                	mov    %eax,%edx
    1a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a84:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8a:	8b 40 04             	mov    0x4(%eax),%eax
    1a8d:	c1 e0 03             	shl    $0x3,%eax
    1a90:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a96:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a99:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a9f:	a3 a4 23 00 00       	mov    %eax,0x23a4
      return (void*)(p + 1);
    1aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa7:	83 c0 08             	add    $0x8,%eax
    1aaa:	eb 38                	jmp    1ae4 <malloc+0xde>
    }
    if(p == freep)
    1aac:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1ab1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1ab4:	75 1b                	jne    1ad1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ab9:	89 04 24             	mov    %eax,(%esp)
    1abc:	e8 ed fe ff ff       	call   19ae <morecore>
    1ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ac8:	75 07                	jne    1ad1 <malloc+0xcb>
        return 0;
    1aca:	b8 00 00 00 00       	mov    $0x0,%eax
    1acf:	eb 13                	jmp    1ae4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ada:	8b 00                	mov    (%eax),%eax
    1adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1adf:	e9 70 ff ff ff       	jmp    1a54 <malloc+0x4e>
}
    1ae4:	c9                   	leave  
    1ae5:	c3                   	ret    

00001ae6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1ae6:	55                   	push   %ebp
    1ae7:	89 e5                	mov    %esp,%ebp
    1ae9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1aec:	8b 55 08             	mov    0x8(%ebp),%edx
    1aef:	8b 45 0c             	mov    0xc(%ebp),%eax
    1af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1af5:	f0 87 02             	lock xchg %eax,(%edx)
    1af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1afe:	c9                   	leave  
    1aff:	c3                   	ret    

00001b00 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1b00:	55                   	push   %ebp
    1b01:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1b03:	8b 45 08             	mov    0x8(%ebp),%eax
    1b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b0c:	5d                   	pop    %ebp
    1b0d:	c3                   	ret    

00001b0e <lock_acquire>:
void lock_acquire(lock_t *lock){
    1b0e:	55                   	push   %ebp
    1b0f:	89 e5                	mov    %esp,%ebp
    1b11:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1b14:	90                   	nop
    1b15:	8b 45 08             	mov    0x8(%ebp),%eax
    1b18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b1f:	00 
    1b20:	89 04 24             	mov    %eax,(%esp)
    1b23:	e8 be ff ff ff       	call   1ae6 <xchg>
    1b28:	85 c0                	test   %eax,%eax
    1b2a:	75 e9                	jne    1b15 <lock_acquire+0x7>
}
    1b2c:	c9                   	leave  
    1b2d:	c3                   	ret    

00001b2e <lock_release>:
void lock_release(lock_t *lock){
    1b2e:	55                   	push   %ebp
    1b2f:	89 e5                	mov    %esp,%ebp
    1b31:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1b34:	8b 45 08             	mov    0x8(%ebp),%eax
    1b37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b3e:	00 
    1b3f:	89 04 24             	mov    %eax,(%esp)
    1b42:	e8 9f ff ff ff       	call   1ae6 <xchg>
}
    1b47:	c9                   	leave  
    1b48:	c3                   	ret    

00001b49 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1b49:	55                   	push   %ebp
    1b4a:	89 e5                	mov    %esp,%ebp
    1b4c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1b4f:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1b56:	e8 ab fe ff ff       	call   1a06 <malloc>
    1b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1b64:	0f b6 05 a8 23 00 00 	movzbl 0x23a8,%eax
    1b6b:	84 c0                	test   %al,%al
    1b6d:	75 1c                	jne    1b8b <thread_create+0x42>
        init_q(thQ2);
    1b6f:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1b74:	89 04 24             	mov    %eax,(%esp)
    1b77:	e8 b2 01 00 00       	call   1d2e <init_q>
        inQ++;
    1b7c:	0f b6 05 a8 23 00 00 	movzbl 0x23a8,%eax
    1b83:	83 c0 01             	add    $0x1,%eax
    1b86:	a2 a8 23 00 00       	mov    %al,0x23a8
    }

    if((uint)stack % 4096){
    1b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8e:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b93:	85 c0                	test   %eax,%eax
    1b95:	74 14                	je     1bab <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b9a:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b9f:	89 c2                	mov    %eax,%edx
    1ba1:	b8 00 10 00 00       	mov    $0x1000,%eax
    1ba6:	29 d0                	sub    %edx,%eax
    1ba8:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1baf:	75 1e                	jne    1bcf <thread_create+0x86>

        printf(1,"malloc fail \n");
    1bb1:	c7 44 24 04 bf 1e 00 	movl   $0x1ebf,0x4(%esp)
    1bb8:	00 
    1bb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bc0:	e8 55 fb ff ff       	call   171a <printf>
        return 0;
    1bc5:	b8 00 00 00 00       	mov    $0x0,%eax
    1bca:	e9 83 00 00 00       	jmp    1c52 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1bd2:	8b 55 08             	mov    0x8(%ebp),%edx
    1bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1bdc:	89 54 24 08          	mov    %edx,0x8(%esp)
    1be0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1be7:	00 
    1be8:	89 04 24             	mov    %eax,(%esp)
    1beb:	e8 1a fa ff ff       	call   160a <clone>
    1bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1bf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bf7:	79 1b                	jns    1c14 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1bf9:	c7 44 24 04 cd 1e 00 	movl   $0x1ecd,0x4(%esp)
    1c00:	00 
    1c01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c08:	e8 0d fb ff ff       	call   171a <printf>
        return 0;
    1c0d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c12:	eb 3e                	jmp    1c52 <thread_create+0x109>
    }
    if(tid > 0){
    1c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c18:	7e 19                	jle    1c33 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1c1a:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1c22:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c26:	89 04 24             	mov    %eax,(%esp)
    1c29:	e8 22 01 00 00       	call   1d50 <add_q>
        return garbage_stack;
    1c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c31:	eb 1f                	jmp    1c52 <thread_create+0x109>
    }
    if(tid == 0){
    1c33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c37:	75 14                	jne    1c4d <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1c39:	c7 44 24 04 da 1e 00 	movl   $0x1eda,0x4(%esp)
    1c40:	00 
    1c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c48:	e8 cd fa ff ff       	call   171a <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1c52:	c9                   	leave  
    1c53:	c3                   	ret    

00001c54 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1c54:	55                   	push   %ebp
    1c55:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1c57:	a1 94 23 00 00       	mov    0x2394,%eax
    1c5c:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1c62:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1c67:	a3 94 23 00 00       	mov    %eax,0x2394
    return (int)(rands % max);
    1c6c:	a1 94 23 00 00       	mov    0x2394,%eax
    1c71:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1c74:	ba 00 00 00 00       	mov    $0x0,%edx
    1c79:	f7 f1                	div    %ecx
    1c7b:	89 d0                	mov    %edx,%eax
}
    1c7d:	5d                   	pop    %ebp
    1c7e:	c3                   	ret    

00001c7f <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1c7f:	55                   	push   %ebp
    1c80:	89 e5                	mov    %esp,%ebp
    1c82:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1c85:	e8 60 f9 ff ff       	call   15ea <getpid>
    1c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1c8d:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1c92:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1c95:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c99:	89 04 24             	mov    %eax,(%esp)
    1c9c:	e8 af 00 00 00       	call   1d50 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1ca1:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1ca6:	89 04 24             	mov    %eax,(%esp)
    1ca9:	e8 1c 01 00 00       	call   1dca <pop_q>
    1cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1cb1:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1cb6:	85 c0                	test   %eax,%eax
    1cb8:	75 1f                	jne    1cd9 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1cba:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1cbf:	89 04 24             	mov    %eax,(%esp)
    1cc2:	e8 03 01 00 00       	call   1dca <pop_q>
    1cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1cca:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1ccf:	83 c0 01             	add    $0x1,%eax
    1cd2:	a3 ac 23 00 00       	mov    %eax,0x23ac
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1cd7:	eb 12                	jmp    1ceb <thread_yield2+0x6c>
    1cd9:	eb 10                	jmp    1ceb <thread_yield2+0x6c>
    1cdb:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1ce0:	89 04 24             	mov    %eax,(%esp)
    1ce3:	e8 e2 00 00 00       	call   1dca <pop_q>
    1ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1cee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1cf1:	74 e8                	je     1cdb <thread_yield2+0x5c>
    1cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1cf7:	74 e2                	je     1cdb <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cfc:	89 04 24             	mov    %eax,(%esp)
    1cff:	e8 1e f9 ff ff       	call   1622 <twakeup>
    tsleep();
    1d04:	e8 11 f9 ff ff       	call   161a <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1d09:	c9                   	leave  
    1d0a:	c3                   	ret    

00001d0b <thread_yield_last>:

void thread_yield_last(){
    1d0b:	55                   	push   %ebp
    1d0c:	89 e5                	mov    %esp,%ebp
    1d0e:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1d11:	a1 b8 23 00 00       	mov    0x23b8,%eax
    1d16:	89 04 24             	mov    %eax,(%esp)
    1d19:	e8 ac 00 00 00       	call   1dca <pop_q>
    1d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d24:	89 04 24             	mov    %eax,(%esp)
    1d27:	e8 f6 f8 ff ff       	call   1622 <twakeup>
    1d2c:	c9                   	leave  
    1d2d:	c3                   	ret    

00001d2e <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1d2e:	55                   	push   %ebp
    1d2f:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1d31:	8b 45 08             	mov    0x8(%ebp),%eax
    1d34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1d3a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1d44:	8b 45 08             	mov    0x8(%ebp),%eax
    1d47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1d4e:	5d                   	pop    %ebp
    1d4f:	c3                   	ret    

00001d50 <add_q>:

void add_q(struct queue *q, int v){
    1d50:	55                   	push   %ebp
    1d51:	89 e5                	mov    %esp,%ebp
    1d53:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1d56:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1d5d:	e8 a4 fc ff ff       	call   1a06 <malloc>
    1d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d72:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d75:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1d77:	8b 45 08             	mov    0x8(%ebp),%eax
    1d7a:	8b 40 04             	mov    0x4(%eax),%eax
    1d7d:	85 c0                	test   %eax,%eax
    1d7f:	75 0b                	jne    1d8c <add_q+0x3c>
        q->head = n;
    1d81:	8b 45 08             	mov    0x8(%ebp),%eax
    1d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d87:	89 50 04             	mov    %edx,0x4(%eax)
    1d8a:	eb 0c                	jmp    1d98 <add_q+0x48>
    }else{
        q->tail->next = n;
    1d8c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d8f:	8b 40 08             	mov    0x8(%eax),%eax
    1d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d95:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1d98:	8b 45 08             	mov    0x8(%ebp),%eax
    1d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d9e:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1da1:	8b 45 08             	mov    0x8(%ebp),%eax
    1da4:	8b 00                	mov    (%eax),%eax
    1da6:	8d 50 01             	lea    0x1(%eax),%edx
    1da9:	8b 45 08             	mov    0x8(%ebp),%eax
    1dac:	89 10                	mov    %edx,(%eax)
}
    1dae:	c9                   	leave  
    1daf:	c3                   	ret    

00001db0 <empty_q>:

int empty_q(struct queue *q){
    1db0:	55                   	push   %ebp
    1db1:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1db3:	8b 45 08             	mov    0x8(%ebp),%eax
    1db6:	8b 00                	mov    (%eax),%eax
    1db8:	85 c0                	test   %eax,%eax
    1dba:	75 07                	jne    1dc3 <empty_q+0x13>
        return 1;
    1dbc:	b8 01 00 00 00       	mov    $0x1,%eax
    1dc1:	eb 05                	jmp    1dc8 <empty_q+0x18>
    else
        return 0;
    1dc3:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1dc8:	5d                   	pop    %ebp
    1dc9:	c3                   	ret    

00001dca <pop_q>:
int pop_q(struct queue *q){
    1dca:	55                   	push   %ebp
    1dcb:	89 e5                	mov    %esp,%ebp
    1dcd:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1dd0:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd3:	89 04 24             	mov    %eax,(%esp)
    1dd6:	e8 d5 ff ff ff       	call   1db0 <empty_q>
    1ddb:	85 c0                	test   %eax,%eax
    1ddd:	75 5d                	jne    1e3c <pop_q+0x72>
       val = q->head->value; 
    1ddf:	8b 45 08             	mov    0x8(%ebp),%eax
    1de2:	8b 40 04             	mov    0x4(%eax),%eax
    1de5:	8b 00                	mov    (%eax),%eax
    1de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1dea:	8b 45 08             	mov    0x8(%ebp),%eax
    1ded:	8b 40 04             	mov    0x4(%eax),%eax
    1df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1df3:	8b 45 08             	mov    0x8(%ebp),%eax
    1df6:	8b 40 04             	mov    0x4(%eax),%eax
    1df9:	8b 50 04             	mov    0x4(%eax),%edx
    1dfc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dff:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e05:	89 04 24             	mov    %eax,(%esp)
    1e08:	e8 c0 fa ff ff       	call   18cd <free>
       q->size--;
    1e0d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e10:	8b 00                	mov    (%eax),%eax
    1e12:	8d 50 ff             	lea    -0x1(%eax),%edx
    1e15:	8b 45 08             	mov    0x8(%ebp),%eax
    1e18:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1e1a:	8b 45 08             	mov    0x8(%ebp),%eax
    1e1d:	8b 00                	mov    (%eax),%eax
    1e1f:	85 c0                	test   %eax,%eax
    1e21:	75 14                	jne    1e37 <pop_q+0x6d>
            q->head = 0;
    1e23:	8b 45 08             	mov    0x8(%ebp),%eax
    1e26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1e2d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e3a:	eb 05                	jmp    1e41 <pop_q+0x77>
    }
    return -1;
    1e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1e41:	c9                   	leave  
    1e42:	c3                   	ret    
