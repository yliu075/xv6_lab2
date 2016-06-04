
_tm:     file format elf32-i386


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
    1018:	e8 c8 0c 00 00       	call   1ce5 <init_q>
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
    102e:	e8 6e 05 00 00       	call   15a1 <getpid>
    1033:	8b 55 08             	mov    0x8(%ebp),%edx
    1036:	83 c2 04             	add    $0x4,%edx
    1039:	89 44 24 04          	mov    %eax,0x4(%esp)
    103d:	89 14 24             	mov    %edx,(%esp)
    1040:	e8 c2 0c 00 00       	call   1d07 <add_q>
      while((s->count == 0) ) wait();
    1045:	eb 05                	jmp    104c <sema_acquire+0x2d>
    1047:	e8 dd 04 00 00       	call   1529 <wait>
    104c:	8b 45 08             	mov    0x8(%ebp),%eax
    104f:	8b 00                	mov    (%eax),%eax
    1051:	85 c0                	test   %eax,%eax
    1053:	74 f2                	je     1047 <sema_acquire+0x28>
      pop_q(&(s->q));
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	83 c0 04             	add    $0x4,%eax
    105b:	89 04 24             	mov    %eax,(%esp)
    105e:	e8 1e 0d 00 00       	call   1d81 <pop_q>
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

00001086 <part_a>:
int dominantMonkey = 0;

void Monkey(void* m);
void domMonkey(void* m);

void part_a() {
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
    1089:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    108c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(; i < 10; i++) {
    1093:	eb 17                	jmp    10ac <part_a+0x26>
        thread_create(Monkey,(void*)i);
    1095:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1098:	89 44 24 04          	mov    %eax,0x4(%esp)
    109c:	c7 04 24 95 11 00 00 	movl   $0x1195,(%esp)
    10a3:	e8 58 0a 00 00       	call   1b00 <thread_create>
void Monkey(void* m);
void domMonkey(void* m);

void part_a() {
    int i = 0;
    for(; i < 10; i++) {
    10a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10ac:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    10b0:	7e e3                	jle    1095 <part_a+0xf>
        thread_create(Monkey,(void*)i);
    }
    while(wait() >= 0);
    10b2:	90                   	nop
    10b3:	e8 71 04 00 00       	call   1529 <wait>
    10b8:	85 c0                	test   %eax,%eax
    10ba:	79 f7                	jns    10b3 <part_a+0x2d>
}
    10bc:	c9                   	leave  
    10bd:	c3                   	ret    

000010be <part_c>:

void part_c() {
    10be:	55                   	push   %ebp
    10bf:	89 e5                	mov    %esp,%ebp
    10c1:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    10c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(; i < 5; i++) {
    10cb:	eb 17                	jmp    10e4 <part_c+0x26>
        thread_create(Monkey,(void*)i);
    10cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    10d4:	c7 04 24 95 11 00 00 	movl   $0x1195,(%esp)
    10db:	e8 20 0a 00 00       	call   1b00 <thread_create>
    while(wait() >= 0);
}

void part_c() {
    int i = 0;
    for(; i < 5; i++) {
    10e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10e4:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
    10e8:	7e e3                	jle    10cd <part_c+0xf>
        thread_create(Monkey,(void*)i);
    }
    thread_create(domMonkey,(void*)1);
    10ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    10f1:	00 
    10f2:	c7 04 24 29 12 00 00 	movl   $0x1229,(%esp)
    10f9:	e8 02 0a 00 00       	call   1b00 <thread_create>
    for(; i < 10; i++) {
    10fe:	eb 17                	jmp    1117 <part_c+0x59>
        thread_create(Monkey,(void*)i);
    1100:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1103:	89 44 24 04          	mov    %eax,0x4(%esp)
    1107:	c7 04 24 95 11 00 00 	movl   $0x1195,(%esp)
    110e:	e8 ed 09 00 00       	call   1b00 <thread_create>
    int i = 0;
    for(; i < 5; i++) {
        thread_create(Monkey,(void*)i);
    }
    thread_create(domMonkey,(void*)1);
    for(; i < 10; i++) {
    1113:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1117:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    111b:	7e e3                	jle    1100 <part_c+0x42>
        thread_create(Monkey,(void*)i);
    }
    while(wait() >= 0);
    111d:	90                   	nop
    111e:	e8 06 04 00 00       	call   1529 <wait>
    1123:	85 c0                	test   %eax,%eax
    1125:	79 f7                	jns    111e <part_c+0x60>
}   
    1127:	c9                   	leave  
    1128:	c3                   	ret    

00001129 <main>:

int main(int argc, char *argv[]){
    1129:	55                   	push   %ebp
    112a:	89 e5                	mov    %esp,%ebp
    112c:	83 e4 f0             	and    $0xfffffff0,%esp
    112f:	83 ec 10             	sub    $0x10,%esp
    
    sema_init(tree);
    1132:	a1 70 23 00 00       	mov    0x2370,%eax
    1137:	89 04 24             	mov    %eax,(%esp)
    113a:	e8 c1 fe ff ff       	call   1000 <sema_init>
    tree->count = 3;
    113f:	a1 70 23 00 00       	mov    0x2370,%eax
    1144:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    printf(1,"\n*****Part a*****\n\n");
    114a:	c7 44 24 04 fa 1d 00 	movl   $0x1dfa,0x4(%esp)
    1151:	00 
    1152:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1159:	e8 73 05 00 00       	call   16d1 <printf>
    part_a();
    115e:	e8 23 ff ff ff       	call   1086 <part_a>
    printf(1,"\n*****Part c*****\n\n");
    1163:	c7 44 24 04 0e 1e 00 	movl   $0x1e0e,0x4(%esp)
    116a:	00 
    116b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1172:	e8 5a 05 00 00       	call   16d1 <printf>
    part_c();
    1177:	e8 42 ff ff ff       	call   10be <part_c>
    printf(1,"\n");
    117c:	c7 44 24 04 22 1e 00 	movl   $0x1e22,0x4(%esp)
    1183:	00 
    1184:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    118b:	e8 41 05 00 00       	call   16d1 <printf>
    exit();
    1190:	e8 8c 03 00 00       	call   1521 <exit>

00001195 <Monkey>:

}


void Monkey(void* m) {
    1195:	55                   	push   %ebp
    1196:	89 e5                	mov    %esp,%ebp
    1198:	83 ec 28             	sub    $0x28,%esp
    int num = (int)m;
    119b:	8b 45 08             	mov    0x8(%ebp),%eax
    119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(dominantMonkey != 0){}
    11a1:	90                   	nop
    11a2:	a1 58 23 00 00       	mov    0x2358,%eax
    11a7:	85 c0                	test   %eax,%eax
    11a9:	75 f7                	jne    11a2 <Monkey+0xd>
    sema_acquire(tree);
    11ab:	a1 70 23 00 00       	mov    0x2370,%eax
    11b0:	89 04 24             	mov    %eax,(%esp)
    11b3:	e8 67 fe ff ff       	call   101f <sema_acquire>
    //printf(1,"Monkey acq Count: %d\n", tree->count);
    printf(1,"Monkey #%d UP\n", num);
    11b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11bb:	89 44 24 08          	mov    %eax,0x8(%esp)
    11bf:	c7 44 24 04 24 1e 00 	movl   $0x1e24,0x4(%esp)
    11c6:	00 
    11c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ce:	e8 fe 04 00 00       	call   16d1 <printf>
    int i = 0;
    11d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int coconutTimer = random(99999) + 500000;
    11da:	c7 04 24 9f 86 01 00 	movl   $0x1869f,(%esp)
    11e1:	e8 25 0a 00 00       	call   1c0b <random>
    11e6:	05 20 a1 07 00       	add    $0x7a120,%eax
    11eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(;i < coconutTimer; i++){}
    11ee:	eb 04                	jmp    11f4 <Monkey+0x5f>
    11f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    11fa:	7c f4                	jl     11f0 <Monkey+0x5b>
    printf(1,"Monkey $%d DOWN\n",num);
    11fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ff:	89 44 24 08          	mov    %eax,0x8(%esp)
    1203:	c7 44 24 04 33 1e 00 	movl   $0x1e33,0x4(%esp)
    120a:	00 
    120b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1212:	e8 ba 04 00 00       	call   16d1 <printf>
    sema_signal(tree);
    1217:	a1 70 23 00 00       	mov    0x2370,%eax
    121c:	89 04 24             	mov    %eax,(%esp)
    121f:	e8 50 fe ff ff       	call   1074 <sema_signal>
    //printf(1,"Monkey sig Count: %d\n", tree->count);
    
    texit();
    1224:	e8 a0 03 00 00       	call   15c9 <texit>

00001229 <domMonkey>:
}

void domMonkey(void* m) {
    1229:	55                   	push   %ebp
    122a:	89 e5                	mov    %esp,%ebp
    122c:	83 ec 28             	sub    $0x28,%esp
    dominantMonkey++;
    122f:	a1 58 23 00 00       	mov    0x2358,%eax
    1234:	83 c0 01             	add    $0x1,%eax
    1237:	a3 58 23 00 00       	mov    %eax,0x2358
    sema_acquire(tree);
    123c:	a1 70 23 00 00       	mov    0x2370,%eax
    1241:	89 04 24             	mov    %eax,(%esp)
    1244:	e8 d6 fd ff ff       	call   101f <sema_acquire>
    //printf(1,"Monkey acq Count: %d\n", tree->count);
    printf(1,"Dominant Monkey UP\n");
    1249:	c7 44 24 04 44 1e 00 	movl   $0x1e44,0x4(%esp)
    1250:	00 
    1251:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1258:	e8 74 04 00 00       	call   16d1 <printf>
    int i = 0;
    125d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int coconutTimer = random(99999) + 500000;
    1264:	c7 04 24 9f 86 01 00 	movl   $0x1869f,(%esp)
    126b:	e8 9b 09 00 00       	call   1c0b <random>
    1270:	05 20 a1 07 00       	add    $0x7a120,%eax
    1275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(;i < coconutTimer; i++){}
    1278:	eb 04                	jmp    127e <domMonkey+0x55>
    127a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1281:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1284:	7c f4                	jl     127a <domMonkey+0x51>
    printf(1,"Dominant Monkey DOWN\n");
    1286:	c7 44 24 04 58 1e 00 	movl   $0x1e58,0x4(%esp)
    128d:	00 
    128e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1295:	e8 37 04 00 00       	call   16d1 <printf>
    sema_signal(tree);
    129a:	a1 70 23 00 00       	mov    0x2370,%eax
    129f:	89 04 24             	mov    %eax,(%esp)
    12a2:	e8 cd fd ff ff       	call   1074 <sema_signal>
    dominantMonkey--;
    12a7:	a1 58 23 00 00       	mov    0x2358,%eax
    12ac:	83 e8 01             	sub    $0x1,%eax
    12af:	a3 58 23 00 00       	mov    %eax,0x2358
    //printf(1,"Monkey sig Count: %d\n", tree->count);
    texit();
    12b4:	e8 10 03 00 00       	call   15c9 <texit>

000012b9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    12b9:	55                   	push   %ebp
    12ba:	89 e5                	mov    %esp,%ebp
    12bc:	57                   	push   %edi
    12bd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    12be:	8b 4d 08             	mov    0x8(%ebp),%ecx
    12c1:	8b 55 10             	mov    0x10(%ebp),%edx
    12c4:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c7:	89 cb                	mov    %ecx,%ebx
    12c9:	89 df                	mov    %ebx,%edi
    12cb:	89 d1                	mov    %edx,%ecx
    12cd:	fc                   	cld    
    12ce:	f3 aa                	rep stos %al,%es:(%edi)
    12d0:	89 ca                	mov    %ecx,%edx
    12d2:	89 fb                	mov    %edi,%ebx
    12d4:	89 5d 08             	mov    %ebx,0x8(%ebp)
    12d7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12da:	5b                   	pop    %ebx
    12db:	5f                   	pop    %edi
    12dc:	5d                   	pop    %ebp
    12dd:	c3                   	ret    

000012de <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12de:	55                   	push   %ebp
    12df:	89 e5                	mov    %esp,%ebp
    12e1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    12e4:	8b 45 08             	mov    0x8(%ebp),%eax
    12e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    12ea:	90                   	nop
    12eb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ee:	8d 50 01             	lea    0x1(%eax),%edx
    12f1:	89 55 08             	mov    %edx,0x8(%ebp)
    12f4:	8b 55 0c             	mov    0xc(%ebp),%edx
    12f7:	8d 4a 01             	lea    0x1(%edx),%ecx
    12fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    12fd:	0f b6 12             	movzbl (%edx),%edx
    1300:	88 10                	mov    %dl,(%eax)
    1302:	0f b6 00             	movzbl (%eax),%eax
    1305:	84 c0                	test   %al,%al
    1307:	75 e2                	jne    12eb <strcpy+0xd>
    ;
  return os;
    1309:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    130c:	c9                   	leave  
    130d:	c3                   	ret    

0000130e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    130e:	55                   	push   %ebp
    130f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1311:	eb 08                	jmp    131b <strcmp+0xd>
    p++, q++;
    1313:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1317:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    131b:	8b 45 08             	mov    0x8(%ebp),%eax
    131e:	0f b6 00             	movzbl (%eax),%eax
    1321:	84 c0                	test   %al,%al
    1323:	74 10                	je     1335 <strcmp+0x27>
    1325:	8b 45 08             	mov    0x8(%ebp),%eax
    1328:	0f b6 10             	movzbl (%eax),%edx
    132b:	8b 45 0c             	mov    0xc(%ebp),%eax
    132e:	0f b6 00             	movzbl (%eax),%eax
    1331:	38 c2                	cmp    %al,%dl
    1333:	74 de                	je     1313 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1335:	8b 45 08             	mov    0x8(%ebp),%eax
    1338:	0f b6 00             	movzbl (%eax),%eax
    133b:	0f b6 d0             	movzbl %al,%edx
    133e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1341:	0f b6 00             	movzbl (%eax),%eax
    1344:	0f b6 c0             	movzbl %al,%eax
    1347:	29 c2                	sub    %eax,%edx
    1349:	89 d0                	mov    %edx,%eax
}
    134b:	5d                   	pop    %ebp
    134c:	c3                   	ret    

0000134d <strlen>:

uint
strlen(char *s)
{
    134d:	55                   	push   %ebp
    134e:	89 e5                	mov    %esp,%ebp
    1350:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    135a:	eb 04                	jmp    1360 <strlen+0x13>
    135c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1360:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1363:	8b 45 08             	mov    0x8(%ebp),%eax
    1366:	01 d0                	add    %edx,%eax
    1368:	0f b6 00             	movzbl (%eax),%eax
    136b:	84 c0                	test   %al,%al
    136d:	75 ed                	jne    135c <strlen+0xf>
    ;
  return n;
    136f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1372:	c9                   	leave  
    1373:	c3                   	ret    

00001374 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1374:	55                   	push   %ebp
    1375:	89 e5                	mov    %esp,%ebp
    1377:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    137a:	8b 45 10             	mov    0x10(%ebp),%eax
    137d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1381:	8b 45 0c             	mov    0xc(%ebp),%eax
    1384:	89 44 24 04          	mov    %eax,0x4(%esp)
    1388:	8b 45 08             	mov    0x8(%ebp),%eax
    138b:	89 04 24             	mov    %eax,(%esp)
    138e:	e8 26 ff ff ff       	call   12b9 <stosb>
  return dst;
    1393:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1396:	c9                   	leave  
    1397:	c3                   	ret    

00001398 <strchr>:

char*
strchr(const char *s, char c)
{
    1398:	55                   	push   %ebp
    1399:	89 e5                	mov    %esp,%ebp
    139b:	83 ec 04             	sub    $0x4,%esp
    139e:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    13a4:	eb 14                	jmp    13ba <strchr+0x22>
    if(*s == c)
    13a6:	8b 45 08             	mov    0x8(%ebp),%eax
    13a9:	0f b6 00             	movzbl (%eax),%eax
    13ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
    13af:	75 05                	jne    13b6 <strchr+0x1e>
      return (char*)s;
    13b1:	8b 45 08             	mov    0x8(%ebp),%eax
    13b4:	eb 13                	jmp    13c9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    13b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13ba:	8b 45 08             	mov    0x8(%ebp),%eax
    13bd:	0f b6 00             	movzbl (%eax),%eax
    13c0:	84 c0                	test   %al,%al
    13c2:	75 e2                	jne    13a6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    13c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13c9:	c9                   	leave  
    13ca:	c3                   	ret    

000013cb <gets>:

char*
gets(char *buf, int max)
{
    13cb:	55                   	push   %ebp
    13cc:	89 e5                	mov    %esp,%ebp
    13ce:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13d8:	eb 4c                	jmp    1426 <gets+0x5b>
    cc = read(0, &c, 1);
    13da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13e1:	00 
    13e2:	8d 45 ef             	lea    -0x11(%ebp),%eax
    13e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    13e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    13f0:	e8 44 01 00 00       	call   1539 <read>
    13f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    13f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13fc:	7f 02                	jg     1400 <gets+0x35>
      break;
    13fe:	eb 31                	jmp    1431 <gets+0x66>
    buf[i++] = c;
    1400:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1403:	8d 50 01             	lea    0x1(%eax),%edx
    1406:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1409:	89 c2                	mov    %eax,%edx
    140b:	8b 45 08             	mov    0x8(%ebp),%eax
    140e:	01 c2                	add    %eax,%edx
    1410:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1414:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1416:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    141a:	3c 0a                	cmp    $0xa,%al
    141c:	74 13                	je     1431 <gets+0x66>
    141e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1422:	3c 0d                	cmp    $0xd,%al
    1424:	74 0b                	je     1431 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1426:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1429:	83 c0 01             	add    $0x1,%eax
    142c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    142f:	7c a9                	jl     13da <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1431:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
    1437:	01 d0                	add    %edx,%eax
    1439:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    143c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    143f:	c9                   	leave  
    1440:	c3                   	ret    

00001441 <stat>:

int
stat(char *n, struct stat *st)
{
    1441:	55                   	push   %ebp
    1442:	89 e5                	mov    %esp,%ebp
    1444:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1447:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    144e:	00 
    144f:	8b 45 08             	mov    0x8(%ebp),%eax
    1452:	89 04 24             	mov    %eax,(%esp)
    1455:	e8 07 01 00 00       	call   1561 <open>
    145a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    145d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1461:	79 07                	jns    146a <stat+0x29>
    return -1;
    1463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1468:	eb 23                	jmp    148d <stat+0x4c>
  r = fstat(fd, st);
    146a:	8b 45 0c             	mov    0xc(%ebp),%eax
    146d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1471:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1474:	89 04 24             	mov    %eax,(%esp)
    1477:	e8 fd 00 00 00       	call   1579 <fstat>
    147c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    147f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1482:	89 04 24             	mov    %eax,(%esp)
    1485:	e8 bf 00 00 00       	call   1549 <close>
  return r;
    148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    148d:	c9                   	leave  
    148e:	c3                   	ret    

0000148f <atoi>:

int
atoi(const char *s)
{
    148f:	55                   	push   %ebp
    1490:	89 e5                	mov    %esp,%ebp
    1492:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    149c:	eb 25                	jmp    14c3 <atoi+0x34>
    n = n*10 + *s++ - '0';
    149e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14a1:	89 d0                	mov    %edx,%eax
    14a3:	c1 e0 02             	shl    $0x2,%eax
    14a6:	01 d0                	add    %edx,%eax
    14a8:	01 c0                	add    %eax,%eax
    14aa:	89 c1                	mov    %eax,%ecx
    14ac:	8b 45 08             	mov    0x8(%ebp),%eax
    14af:	8d 50 01             	lea    0x1(%eax),%edx
    14b2:	89 55 08             	mov    %edx,0x8(%ebp)
    14b5:	0f b6 00             	movzbl (%eax),%eax
    14b8:	0f be c0             	movsbl %al,%eax
    14bb:	01 c8                	add    %ecx,%eax
    14bd:	83 e8 30             	sub    $0x30,%eax
    14c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    14c3:	8b 45 08             	mov    0x8(%ebp),%eax
    14c6:	0f b6 00             	movzbl (%eax),%eax
    14c9:	3c 2f                	cmp    $0x2f,%al
    14cb:	7e 0a                	jle    14d7 <atoi+0x48>
    14cd:	8b 45 08             	mov    0x8(%ebp),%eax
    14d0:	0f b6 00             	movzbl (%eax),%eax
    14d3:	3c 39                	cmp    $0x39,%al
    14d5:	7e c7                	jle    149e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    14d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14da:	c9                   	leave  
    14db:	c3                   	ret    

000014dc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14dc:	55                   	push   %ebp
    14dd:	89 e5                	mov    %esp,%ebp
    14df:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    14e2:	8b 45 08             	mov    0x8(%ebp),%eax
    14e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    14e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    14eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    14ee:	eb 17                	jmp    1507 <memmove+0x2b>
    *dst++ = *src++;
    14f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14f3:	8d 50 01             	lea    0x1(%eax),%edx
    14f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
    14f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    14fc:	8d 4a 01             	lea    0x1(%edx),%ecx
    14ff:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1502:	0f b6 12             	movzbl (%edx),%edx
    1505:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1507:	8b 45 10             	mov    0x10(%ebp),%eax
    150a:	8d 50 ff             	lea    -0x1(%eax),%edx
    150d:	89 55 10             	mov    %edx,0x10(%ebp)
    1510:	85 c0                	test   %eax,%eax
    1512:	7f dc                	jg     14f0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1514:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1517:	c9                   	leave  
    1518:	c3                   	ret    

00001519 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1519:	b8 01 00 00 00       	mov    $0x1,%eax
    151e:	cd 40                	int    $0x40
    1520:	c3                   	ret    

00001521 <exit>:
SYSCALL(exit)
    1521:	b8 02 00 00 00       	mov    $0x2,%eax
    1526:	cd 40                	int    $0x40
    1528:	c3                   	ret    

00001529 <wait>:
SYSCALL(wait)
    1529:	b8 03 00 00 00       	mov    $0x3,%eax
    152e:	cd 40                	int    $0x40
    1530:	c3                   	ret    

00001531 <pipe>:
SYSCALL(pipe)
    1531:	b8 04 00 00 00       	mov    $0x4,%eax
    1536:	cd 40                	int    $0x40
    1538:	c3                   	ret    

00001539 <read>:
SYSCALL(read)
    1539:	b8 05 00 00 00       	mov    $0x5,%eax
    153e:	cd 40                	int    $0x40
    1540:	c3                   	ret    

00001541 <write>:
SYSCALL(write)
    1541:	b8 10 00 00 00       	mov    $0x10,%eax
    1546:	cd 40                	int    $0x40
    1548:	c3                   	ret    

00001549 <close>:
SYSCALL(close)
    1549:	b8 15 00 00 00       	mov    $0x15,%eax
    154e:	cd 40                	int    $0x40
    1550:	c3                   	ret    

00001551 <kill>:
SYSCALL(kill)
    1551:	b8 06 00 00 00       	mov    $0x6,%eax
    1556:	cd 40                	int    $0x40
    1558:	c3                   	ret    

00001559 <exec>:
SYSCALL(exec)
    1559:	b8 07 00 00 00       	mov    $0x7,%eax
    155e:	cd 40                	int    $0x40
    1560:	c3                   	ret    

00001561 <open>:
SYSCALL(open)
    1561:	b8 0f 00 00 00       	mov    $0xf,%eax
    1566:	cd 40                	int    $0x40
    1568:	c3                   	ret    

00001569 <mknod>:
SYSCALL(mknod)
    1569:	b8 11 00 00 00       	mov    $0x11,%eax
    156e:	cd 40                	int    $0x40
    1570:	c3                   	ret    

00001571 <unlink>:
SYSCALL(unlink)
    1571:	b8 12 00 00 00       	mov    $0x12,%eax
    1576:	cd 40                	int    $0x40
    1578:	c3                   	ret    

00001579 <fstat>:
SYSCALL(fstat)
    1579:	b8 08 00 00 00       	mov    $0x8,%eax
    157e:	cd 40                	int    $0x40
    1580:	c3                   	ret    

00001581 <link>:
SYSCALL(link)
    1581:	b8 13 00 00 00       	mov    $0x13,%eax
    1586:	cd 40                	int    $0x40
    1588:	c3                   	ret    

00001589 <mkdir>:
SYSCALL(mkdir)
    1589:	b8 14 00 00 00       	mov    $0x14,%eax
    158e:	cd 40                	int    $0x40
    1590:	c3                   	ret    

00001591 <chdir>:
SYSCALL(chdir)
    1591:	b8 09 00 00 00       	mov    $0x9,%eax
    1596:	cd 40                	int    $0x40
    1598:	c3                   	ret    

00001599 <dup>:
SYSCALL(dup)
    1599:	b8 0a 00 00 00       	mov    $0xa,%eax
    159e:	cd 40                	int    $0x40
    15a0:	c3                   	ret    

000015a1 <getpid>:
SYSCALL(getpid)
    15a1:	b8 0b 00 00 00       	mov    $0xb,%eax
    15a6:	cd 40                	int    $0x40
    15a8:	c3                   	ret    

000015a9 <sbrk>:
SYSCALL(sbrk)
    15a9:	b8 0c 00 00 00       	mov    $0xc,%eax
    15ae:	cd 40                	int    $0x40
    15b0:	c3                   	ret    

000015b1 <sleep>:
SYSCALL(sleep)
    15b1:	b8 0d 00 00 00       	mov    $0xd,%eax
    15b6:	cd 40                	int    $0x40
    15b8:	c3                   	ret    

000015b9 <uptime>:
SYSCALL(uptime)
    15b9:	b8 0e 00 00 00       	mov    $0xe,%eax
    15be:	cd 40                	int    $0x40
    15c0:	c3                   	ret    

000015c1 <clone>:
SYSCALL(clone)
    15c1:	b8 16 00 00 00       	mov    $0x16,%eax
    15c6:	cd 40                	int    $0x40
    15c8:	c3                   	ret    

000015c9 <texit>:
SYSCALL(texit)
    15c9:	b8 17 00 00 00       	mov    $0x17,%eax
    15ce:	cd 40                	int    $0x40
    15d0:	c3                   	ret    

000015d1 <tsleep>:
SYSCALL(tsleep)
    15d1:	b8 18 00 00 00       	mov    $0x18,%eax
    15d6:	cd 40                	int    $0x40
    15d8:	c3                   	ret    

000015d9 <twakeup>:
SYSCALL(twakeup)
    15d9:	b8 19 00 00 00       	mov    $0x19,%eax
    15de:	cd 40                	int    $0x40
    15e0:	c3                   	ret    

000015e1 <thread_yield>:
SYSCALL(thread_yield)
    15e1:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15e6:	cd 40                	int    $0x40
    15e8:	c3                   	ret    

000015e9 <thread_yield3>:
    15e9:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15ee:	cd 40                	int    $0x40
    15f0:	c3                   	ret    

000015f1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    15f1:	55                   	push   %ebp
    15f2:	89 e5                	mov    %esp,%ebp
    15f4:	83 ec 18             	sub    $0x18,%esp
    15f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    15fa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    15fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1604:	00 
    1605:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1608:	89 44 24 04          	mov    %eax,0x4(%esp)
    160c:	8b 45 08             	mov    0x8(%ebp),%eax
    160f:	89 04 24             	mov    %eax,(%esp)
    1612:	e8 2a ff ff ff       	call   1541 <write>
}
    1617:	c9                   	leave  
    1618:	c3                   	ret    

00001619 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1619:	55                   	push   %ebp
    161a:	89 e5                	mov    %esp,%ebp
    161c:	56                   	push   %esi
    161d:	53                   	push   %ebx
    161e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1621:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1628:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    162c:	74 17                	je     1645 <printint+0x2c>
    162e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1632:	79 11                	jns    1645 <printint+0x2c>
    neg = 1;
    1634:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    163b:	8b 45 0c             	mov    0xc(%ebp),%eax
    163e:	f7 d8                	neg    %eax
    1640:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1643:	eb 06                	jmp    164b <printint+0x32>
  } else {
    x = xx;
    1645:	8b 45 0c             	mov    0xc(%ebp),%eax
    1648:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    164b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1652:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1655:	8d 41 01             	lea    0x1(%ecx),%eax
    1658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    165b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    165e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1661:	ba 00 00 00 00       	mov    $0x0,%edx
    1666:	f7 f3                	div    %ebx
    1668:	89 d0                	mov    %edx,%eax
    166a:	0f b6 80 40 23 00 00 	movzbl 0x2340(%eax),%eax
    1671:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1675:	8b 75 10             	mov    0x10(%ebp),%esi
    1678:	8b 45 ec             	mov    -0x14(%ebp),%eax
    167b:	ba 00 00 00 00       	mov    $0x0,%edx
    1680:	f7 f6                	div    %esi
    1682:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1685:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1689:	75 c7                	jne    1652 <printint+0x39>
  if(neg)
    168b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    168f:	74 10                	je     16a1 <printint+0x88>
    buf[i++] = '-';
    1691:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1694:	8d 50 01             	lea    0x1(%eax),%edx
    1697:	89 55 f4             	mov    %edx,-0xc(%ebp)
    169a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    169f:	eb 1f                	jmp    16c0 <printint+0xa7>
    16a1:	eb 1d                	jmp    16c0 <printint+0xa7>
    putc(fd, buf[i]);
    16a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a9:	01 d0                	add    %edx,%eax
    16ab:	0f b6 00             	movzbl (%eax),%eax
    16ae:	0f be c0             	movsbl %al,%eax
    16b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b5:	8b 45 08             	mov    0x8(%ebp),%eax
    16b8:	89 04 24             	mov    %eax,(%esp)
    16bb:	e8 31 ff ff ff       	call   15f1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    16c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    16c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16c8:	79 d9                	jns    16a3 <printint+0x8a>
    putc(fd, buf[i]);
}
    16ca:	83 c4 30             	add    $0x30,%esp
    16cd:	5b                   	pop    %ebx
    16ce:	5e                   	pop    %esi
    16cf:	5d                   	pop    %ebp
    16d0:	c3                   	ret    

000016d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    16d1:	55                   	push   %ebp
    16d2:	89 e5                	mov    %esp,%ebp
    16d4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    16d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    16de:	8d 45 0c             	lea    0xc(%ebp),%eax
    16e1:	83 c0 04             	add    $0x4,%eax
    16e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    16e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    16ee:	e9 7c 01 00 00       	jmp    186f <printf+0x19e>
    c = fmt[i] & 0xff;
    16f3:	8b 55 0c             	mov    0xc(%ebp),%edx
    16f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16f9:	01 d0                	add    %edx,%eax
    16fb:	0f b6 00             	movzbl (%eax),%eax
    16fe:	0f be c0             	movsbl %al,%eax
    1701:	25 ff 00 00 00       	and    $0xff,%eax
    1706:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1709:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    170d:	75 2c                	jne    173b <printf+0x6a>
      if(c == '%'){
    170f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1713:	75 0c                	jne    1721 <printf+0x50>
        state = '%';
    1715:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    171c:	e9 4a 01 00 00       	jmp    186b <printf+0x19a>
      } else {
        putc(fd, c);
    1721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1724:	0f be c0             	movsbl %al,%eax
    1727:	89 44 24 04          	mov    %eax,0x4(%esp)
    172b:	8b 45 08             	mov    0x8(%ebp),%eax
    172e:	89 04 24             	mov    %eax,(%esp)
    1731:	e8 bb fe ff ff       	call   15f1 <putc>
    1736:	e9 30 01 00 00       	jmp    186b <printf+0x19a>
      }
    } else if(state == '%'){
    173b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    173f:	0f 85 26 01 00 00    	jne    186b <printf+0x19a>
      if(c == 'd'){
    1745:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1749:	75 2d                	jne    1778 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    174b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    174e:	8b 00                	mov    (%eax),%eax
    1750:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1757:	00 
    1758:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    175f:	00 
    1760:	89 44 24 04          	mov    %eax,0x4(%esp)
    1764:	8b 45 08             	mov    0x8(%ebp),%eax
    1767:	89 04 24             	mov    %eax,(%esp)
    176a:	e8 aa fe ff ff       	call   1619 <printint>
        ap++;
    176f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1773:	e9 ec 00 00 00       	jmp    1864 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1778:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    177c:	74 06                	je     1784 <printf+0xb3>
    177e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1782:	75 2d                	jne    17b1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1784:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1787:	8b 00                	mov    (%eax),%eax
    1789:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1790:	00 
    1791:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1798:	00 
    1799:	89 44 24 04          	mov    %eax,0x4(%esp)
    179d:	8b 45 08             	mov    0x8(%ebp),%eax
    17a0:	89 04 24             	mov    %eax,(%esp)
    17a3:	e8 71 fe ff ff       	call   1619 <printint>
        ap++;
    17a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17ac:	e9 b3 00 00 00       	jmp    1864 <printf+0x193>
      } else if(c == 's'){
    17b1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    17b5:	75 45                	jne    17fc <printf+0x12b>
        s = (char*)*ap;
    17b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17ba:	8b 00                	mov    (%eax),%eax
    17bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    17bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    17c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17c7:	75 09                	jne    17d2 <printf+0x101>
          s = "(null)";
    17c9:	c7 45 f4 6e 1e 00 00 	movl   $0x1e6e,-0xc(%ebp)
        while(*s != 0){
    17d0:	eb 1e                	jmp    17f0 <printf+0x11f>
    17d2:	eb 1c                	jmp    17f0 <printf+0x11f>
          putc(fd, *s);
    17d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d7:	0f b6 00             	movzbl (%eax),%eax
    17da:	0f be c0             	movsbl %al,%eax
    17dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e1:	8b 45 08             	mov    0x8(%ebp),%eax
    17e4:	89 04 24             	mov    %eax,(%esp)
    17e7:	e8 05 fe ff ff       	call   15f1 <putc>
          s++;
    17ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    17f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f3:	0f b6 00             	movzbl (%eax),%eax
    17f6:	84 c0                	test   %al,%al
    17f8:	75 da                	jne    17d4 <printf+0x103>
    17fa:	eb 68                	jmp    1864 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    17fc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1800:	75 1d                	jne    181f <printf+0x14e>
        putc(fd, *ap);
    1802:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1805:	8b 00                	mov    (%eax),%eax
    1807:	0f be c0             	movsbl %al,%eax
    180a:	89 44 24 04          	mov    %eax,0x4(%esp)
    180e:	8b 45 08             	mov    0x8(%ebp),%eax
    1811:	89 04 24             	mov    %eax,(%esp)
    1814:	e8 d8 fd ff ff       	call   15f1 <putc>
        ap++;
    1819:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    181d:	eb 45                	jmp    1864 <printf+0x193>
      } else if(c == '%'){
    181f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1823:	75 17                	jne    183c <printf+0x16b>
        putc(fd, c);
    1825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1828:	0f be c0             	movsbl %al,%eax
    182b:	89 44 24 04          	mov    %eax,0x4(%esp)
    182f:	8b 45 08             	mov    0x8(%ebp),%eax
    1832:	89 04 24             	mov    %eax,(%esp)
    1835:	e8 b7 fd ff ff       	call   15f1 <putc>
    183a:	eb 28                	jmp    1864 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    183c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1843:	00 
    1844:	8b 45 08             	mov    0x8(%ebp),%eax
    1847:	89 04 24             	mov    %eax,(%esp)
    184a:	e8 a2 fd ff ff       	call   15f1 <putc>
        putc(fd, c);
    184f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1852:	0f be c0             	movsbl %al,%eax
    1855:	89 44 24 04          	mov    %eax,0x4(%esp)
    1859:	8b 45 08             	mov    0x8(%ebp),%eax
    185c:	89 04 24             	mov    %eax,(%esp)
    185f:	e8 8d fd ff ff       	call   15f1 <putc>
      }
      state = 0;
    1864:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    186b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    186f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1872:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1875:	01 d0                	add    %edx,%eax
    1877:	0f b6 00             	movzbl (%eax),%eax
    187a:	84 c0                	test   %al,%al
    187c:	0f 85 71 fe ff ff    	jne    16f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1882:	c9                   	leave  
    1883:	c3                   	ret    

00001884 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1884:	55                   	push   %ebp
    1885:	89 e5                	mov    %esp,%ebp
    1887:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    188a:	8b 45 08             	mov    0x8(%ebp),%eax
    188d:	83 e8 08             	sub    $0x8,%eax
    1890:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1893:	a1 64 23 00 00       	mov    0x2364,%eax
    1898:	89 45 fc             	mov    %eax,-0x4(%ebp)
    189b:	eb 24                	jmp    18c1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18a0:	8b 00                	mov    (%eax),%eax
    18a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18a5:	77 12                	ja     18b9 <free+0x35>
    18a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18ad:	77 24                	ja     18d3 <free+0x4f>
    18af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18b2:	8b 00                	mov    (%eax),%eax
    18b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18b7:	77 1a                	ja     18d3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18bc:	8b 00                	mov    (%eax),%eax
    18be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18c7:	76 d4                	jbe    189d <free+0x19>
    18c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18cc:	8b 00                	mov    (%eax),%eax
    18ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18d1:	76 ca                	jbe    189d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    18d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18d6:	8b 40 04             	mov    0x4(%eax),%eax
    18d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    18e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18e3:	01 c2                	add    %eax,%edx
    18e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e8:	8b 00                	mov    (%eax),%eax
    18ea:	39 c2                	cmp    %eax,%edx
    18ec:	75 24                	jne    1912 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    18ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18f1:	8b 50 04             	mov    0x4(%eax),%edx
    18f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f7:	8b 00                	mov    (%eax),%eax
    18f9:	8b 40 04             	mov    0x4(%eax),%eax
    18fc:	01 c2                	add    %eax,%edx
    18fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1901:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1904:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1907:	8b 00                	mov    (%eax),%eax
    1909:	8b 10                	mov    (%eax),%edx
    190b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    190e:	89 10                	mov    %edx,(%eax)
    1910:	eb 0a                	jmp    191c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1912:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1915:	8b 10                	mov    (%eax),%edx
    1917:	8b 45 f8             	mov    -0x8(%ebp),%eax
    191a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    191f:	8b 40 04             	mov    0x4(%eax),%eax
    1922:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1929:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192c:	01 d0                	add    %edx,%eax
    192e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1931:	75 20                	jne    1953 <free+0xcf>
    p->s.size += bp->s.size;
    1933:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1936:	8b 50 04             	mov    0x4(%eax),%edx
    1939:	8b 45 f8             	mov    -0x8(%ebp),%eax
    193c:	8b 40 04             	mov    0x4(%eax),%eax
    193f:	01 c2                	add    %eax,%edx
    1941:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1944:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1947:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194a:	8b 10                	mov    (%eax),%edx
    194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    194f:	89 10                	mov    %edx,(%eax)
    1951:	eb 08                	jmp    195b <free+0xd7>
  } else
    p->s.ptr = bp;
    1953:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1956:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1959:	89 10                	mov    %edx,(%eax)
  freep = p;
    195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195e:	a3 64 23 00 00       	mov    %eax,0x2364
}
    1963:	c9                   	leave  
    1964:	c3                   	ret    

00001965 <morecore>:

static Header*
morecore(uint nu)
{
    1965:	55                   	push   %ebp
    1966:	89 e5                	mov    %esp,%ebp
    1968:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    196b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1972:	77 07                	ja     197b <morecore+0x16>
    nu = 4096;
    1974:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    197b:	8b 45 08             	mov    0x8(%ebp),%eax
    197e:	c1 e0 03             	shl    $0x3,%eax
    1981:	89 04 24             	mov    %eax,(%esp)
    1984:	e8 20 fc ff ff       	call   15a9 <sbrk>
    1989:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    198c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1990:	75 07                	jne    1999 <morecore+0x34>
    return 0;
    1992:	b8 00 00 00 00       	mov    $0x0,%eax
    1997:	eb 22                	jmp    19bb <morecore+0x56>
  hp = (Header*)p;
    1999:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19a2:	8b 55 08             	mov    0x8(%ebp),%edx
    19a5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    19a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19ab:	83 c0 08             	add    $0x8,%eax
    19ae:	89 04 24             	mov    %eax,(%esp)
    19b1:	e8 ce fe ff ff       	call   1884 <free>
  return freep;
    19b6:	a1 64 23 00 00       	mov    0x2364,%eax
}
    19bb:	c9                   	leave  
    19bc:	c3                   	ret    

000019bd <malloc>:

void*
malloc(uint nbytes)
{
    19bd:	55                   	push   %ebp
    19be:	89 e5                	mov    %esp,%ebp
    19c0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19c3:	8b 45 08             	mov    0x8(%ebp),%eax
    19c6:	83 c0 07             	add    $0x7,%eax
    19c9:	c1 e8 03             	shr    $0x3,%eax
    19cc:	83 c0 01             	add    $0x1,%eax
    19cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    19d2:	a1 64 23 00 00       	mov    0x2364,%eax
    19d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    19de:	75 23                	jne    1a03 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    19e0:	c7 45 f0 5c 23 00 00 	movl   $0x235c,-0x10(%ebp)
    19e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19ea:	a3 64 23 00 00       	mov    %eax,0x2364
    19ef:	a1 64 23 00 00       	mov    0x2364,%eax
    19f4:	a3 5c 23 00 00       	mov    %eax,0x235c
    base.s.size = 0;
    19f9:	c7 05 60 23 00 00 00 	movl   $0x0,0x2360
    1a00:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a06:	8b 00                	mov    (%eax),%eax
    1a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a0e:	8b 40 04             	mov    0x4(%eax),%eax
    1a11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a14:	72 4d                	jb     1a63 <malloc+0xa6>
      if(p->s.size == nunits)
    1a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a19:	8b 40 04             	mov    0x4(%eax),%eax
    1a1c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a1f:	75 0c                	jne    1a2d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a24:	8b 10                	mov    (%eax),%edx
    1a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a29:	89 10                	mov    %edx,(%eax)
    1a2b:	eb 26                	jmp    1a53 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a30:	8b 40 04             	mov    0x4(%eax),%eax
    1a33:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1a36:	89 c2                	mov    %eax,%edx
    1a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a3b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a41:	8b 40 04             	mov    0x4(%eax),%eax
    1a44:	c1 e0 03             	shl    $0x3,%eax
    1a47:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a50:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a56:	a3 64 23 00 00       	mov    %eax,0x2364
      return (void*)(p + 1);
    1a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a5e:	83 c0 08             	add    $0x8,%eax
    1a61:	eb 38                	jmp    1a9b <malloc+0xde>
    }
    if(p == freep)
    1a63:	a1 64 23 00 00       	mov    0x2364,%eax
    1a68:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1a6b:	75 1b                	jne    1a88 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1a70:	89 04 24             	mov    %eax,(%esp)
    1a73:	e8 ed fe ff ff       	call   1965 <morecore>
    1a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a7f:	75 07                	jne    1a88 <malloc+0xcb>
        return 0;
    1a81:	b8 00 00 00 00       	mov    $0x0,%eax
    1a86:	eb 13                	jmp    1a9b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a91:	8b 00                	mov    (%eax),%eax
    1a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1a96:	e9 70 ff ff ff       	jmp    1a0b <malloc+0x4e>
}
    1a9b:	c9                   	leave  
    1a9c:	c3                   	ret    

00001a9d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1a9d:	55                   	push   %ebp
    1a9e:	89 e5                	mov    %esp,%ebp
    1aa0:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1aa3:	8b 55 08             	mov    0x8(%ebp),%edx
    1aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
    1aa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1aac:	f0 87 02             	lock xchg %eax,(%edx)
    1aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1ab2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1ab5:	c9                   	leave  
    1ab6:	c3                   	ret    

00001ab7 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1ab7:	55                   	push   %ebp
    1ab8:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1aba:	8b 45 08             	mov    0x8(%ebp),%eax
    1abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1ac3:	5d                   	pop    %ebp
    1ac4:	c3                   	ret    

00001ac5 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1ac5:	55                   	push   %ebp
    1ac6:	89 e5                	mov    %esp,%ebp
    1ac8:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1acb:	90                   	nop
    1acc:	8b 45 08             	mov    0x8(%ebp),%eax
    1acf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1ad6:	00 
    1ad7:	89 04 24             	mov    %eax,(%esp)
    1ada:	e8 be ff ff ff       	call   1a9d <xchg>
    1adf:	85 c0                	test   %eax,%eax
    1ae1:	75 e9                	jne    1acc <lock_acquire+0x7>
}
    1ae3:	c9                   	leave  
    1ae4:	c3                   	ret    

00001ae5 <lock_release>:
void lock_release(lock_t *lock){
    1ae5:	55                   	push   %ebp
    1ae6:	89 e5                	mov    %esp,%ebp
    1ae8:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1aeb:	8b 45 08             	mov    0x8(%ebp),%eax
    1aee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1af5:	00 
    1af6:	89 04 24             	mov    %eax,(%esp)
    1af9:	e8 9f ff ff ff       	call   1a9d <xchg>
}
    1afe:	c9                   	leave  
    1aff:	c3                   	ret    

00001b00 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1b00:	55                   	push   %ebp
    1b01:	89 e5                	mov    %esp,%ebp
    1b03:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1b06:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1b0d:	e8 ab fe ff ff       	call   19bd <malloc>
    1b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1b1b:	0f b6 05 68 23 00 00 	movzbl 0x2368,%eax
    1b22:	84 c0                	test   %al,%al
    1b24:	75 1c                	jne    1b42 <thread_create+0x42>
        init_q(thQ2);
    1b26:	a1 74 23 00 00       	mov    0x2374,%eax
    1b2b:	89 04 24             	mov    %eax,(%esp)
    1b2e:	e8 b2 01 00 00       	call   1ce5 <init_q>
        inQ++;
    1b33:	0f b6 05 68 23 00 00 	movzbl 0x2368,%eax
    1b3a:	83 c0 01             	add    $0x1,%eax
    1b3d:	a2 68 23 00 00       	mov    %al,0x2368
    }

    if((uint)stack % 4096){
    1b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b45:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b4a:	85 c0                	test   %eax,%eax
    1b4c:	74 14                	je     1b62 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b51:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b56:	89 c2                	mov    %eax,%edx
    1b58:	b8 00 10 00 00       	mov    $0x1000,%eax
    1b5d:	29 d0                	sub    %edx,%eax
    1b5f:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b66:	75 1e                	jne    1b86 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1b68:	c7 44 24 04 75 1e 00 	movl   $0x1e75,0x4(%esp)
    1b6f:	00 
    1b70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b77:	e8 55 fb ff ff       	call   16d1 <printf>
        return 0;
    1b7c:	b8 00 00 00 00       	mov    $0x0,%eax
    1b81:	e9 83 00 00 00       	jmp    1c09 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1b89:	8b 55 08             	mov    0x8(%ebp),%edx
    1b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1b93:	89 54 24 08          	mov    %edx,0x8(%esp)
    1b97:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1b9e:	00 
    1b9f:	89 04 24             	mov    %eax,(%esp)
    1ba2:	e8 1a fa ff ff       	call   15c1 <clone>
    1ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bae:	79 1b                	jns    1bcb <thread_create+0xcb>
        printf(1,"clone fails\n");
    1bb0:	c7 44 24 04 83 1e 00 	movl   $0x1e83,0x4(%esp)
    1bb7:	00 
    1bb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bbf:	e8 0d fb ff ff       	call   16d1 <printf>
        return 0;
    1bc4:	b8 00 00 00 00       	mov    $0x0,%eax
    1bc9:	eb 3e                	jmp    1c09 <thread_create+0x109>
    }
    if(tid > 0){
    1bcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bcf:	7e 19                	jle    1bea <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1bd1:	a1 74 23 00 00       	mov    0x2374,%eax
    1bd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1bd9:	89 54 24 04          	mov    %edx,0x4(%esp)
    1bdd:	89 04 24             	mov    %eax,(%esp)
    1be0:	e8 22 01 00 00       	call   1d07 <add_q>
        return garbage_stack;
    1be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be8:	eb 1f                	jmp    1c09 <thread_create+0x109>
    }
    if(tid == 0){
    1bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bee:	75 14                	jne    1c04 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1bf0:	c7 44 24 04 90 1e 00 	movl   $0x1e90,0x4(%esp)
    1bf7:	00 
    1bf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bff:	e8 cd fa ff ff       	call   16d1 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1c09:	c9                   	leave  
    1c0a:	c3                   	ret    

00001c0b <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1c0b:	55                   	push   %ebp
    1c0c:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1c0e:	a1 54 23 00 00       	mov    0x2354,%eax
    1c13:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1c19:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1c1e:	a3 54 23 00 00       	mov    %eax,0x2354
    return (int)(rands % max);
    1c23:	a1 54 23 00 00       	mov    0x2354,%eax
    1c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1c2b:	ba 00 00 00 00       	mov    $0x0,%edx
    1c30:	f7 f1                	div    %ecx
    1c32:	89 d0                	mov    %edx,%eax
}
    1c34:	5d                   	pop    %ebp
    1c35:	c3                   	ret    

00001c36 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1c36:	55                   	push   %ebp
    1c37:	89 e5                	mov    %esp,%ebp
    1c39:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1c3c:	e8 60 f9 ff ff       	call   15a1 <getpid>
    1c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1c44:	a1 74 23 00 00       	mov    0x2374,%eax
    1c49:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1c4c:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c50:	89 04 24             	mov    %eax,(%esp)
    1c53:	e8 af 00 00 00       	call   1d07 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1c58:	a1 74 23 00 00       	mov    0x2374,%eax
    1c5d:	89 04 24             	mov    %eax,(%esp)
    1c60:	e8 1c 01 00 00       	call   1d81 <pop_q>
    1c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1c68:	a1 6c 23 00 00       	mov    0x236c,%eax
    1c6d:	85 c0                	test   %eax,%eax
    1c6f:	75 1f                	jne    1c90 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1c71:	a1 74 23 00 00       	mov    0x2374,%eax
    1c76:	89 04 24             	mov    %eax,(%esp)
    1c79:	e8 03 01 00 00       	call   1d81 <pop_q>
    1c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1c81:	a1 6c 23 00 00       	mov    0x236c,%eax
    1c86:	83 c0 01             	add    $0x1,%eax
    1c89:	a3 6c 23 00 00       	mov    %eax,0x236c
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1c8e:	eb 12                	jmp    1ca2 <thread_yield2+0x6c>
    1c90:	eb 10                	jmp    1ca2 <thread_yield2+0x6c>
    1c92:	a1 74 23 00 00       	mov    0x2374,%eax
    1c97:	89 04 24             	mov    %eax,(%esp)
    1c9a:	e8 e2 00 00 00       	call   1d81 <pop_q>
    1c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ca5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1ca8:	74 e8                	je     1c92 <thread_yield2+0x5c>
    1caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1cae:	74 e2                	je     1c92 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cb3:	89 04 24             	mov    %eax,(%esp)
    1cb6:	e8 1e f9 ff ff       	call   15d9 <twakeup>
    tsleep();
    1cbb:	e8 11 f9 ff ff       	call   15d1 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1cc0:	c9                   	leave  
    1cc1:	c3                   	ret    

00001cc2 <thread_yield_last>:

void thread_yield_last(){
    1cc2:	55                   	push   %ebp
    1cc3:	89 e5                	mov    %esp,%ebp
    1cc5:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1cc8:	a1 74 23 00 00       	mov    0x2374,%eax
    1ccd:	89 04 24             	mov    %eax,(%esp)
    1cd0:	e8 ac 00 00 00       	call   1d81 <pop_q>
    1cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cdb:	89 04 24             	mov    %eax,(%esp)
    1cde:	e8 f6 f8 ff ff       	call   15d9 <twakeup>
    1ce3:	c9                   	leave  
    1ce4:	c3                   	ret    

00001ce5 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ce5:	55                   	push   %ebp
    1ce6:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ce8:	8b 45 08             	mov    0x8(%ebp),%eax
    1ceb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1cf1:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1cfb:	8b 45 08             	mov    0x8(%ebp),%eax
    1cfe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1d05:	5d                   	pop    %ebp
    1d06:	c3                   	ret    

00001d07 <add_q>:

void add_q(struct queue *q, int v){
    1d07:	55                   	push   %ebp
    1d08:	89 e5                	mov    %esp,%ebp
    1d0a:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1d0d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1d14:	e8 a4 fc ff ff       	call   19bd <malloc>
    1d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d29:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d2c:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1d2e:	8b 45 08             	mov    0x8(%ebp),%eax
    1d31:	8b 40 04             	mov    0x4(%eax),%eax
    1d34:	85 c0                	test   %eax,%eax
    1d36:	75 0b                	jne    1d43 <add_q+0x3c>
        q->head = n;
    1d38:	8b 45 08             	mov    0x8(%ebp),%eax
    1d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d3e:	89 50 04             	mov    %edx,0x4(%eax)
    1d41:	eb 0c                	jmp    1d4f <add_q+0x48>
    }else{
        q->tail->next = n;
    1d43:	8b 45 08             	mov    0x8(%ebp),%eax
    1d46:	8b 40 08             	mov    0x8(%eax),%eax
    1d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d4c:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1d4f:	8b 45 08             	mov    0x8(%ebp),%eax
    1d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d55:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1d58:	8b 45 08             	mov    0x8(%ebp),%eax
    1d5b:	8b 00                	mov    (%eax),%eax
    1d5d:	8d 50 01             	lea    0x1(%eax),%edx
    1d60:	8b 45 08             	mov    0x8(%ebp),%eax
    1d63:	89 10                	mov    %edx,(%eax)
}
    1d65:	c9                   	leave  
    1d66:	c3                   	ret    

00001d67 <empty_q>:

int empty_q(struct queue *q){
    1d67:	55                   	push   %ebp
    1d68:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1d6a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d6d:	8b 00                	mov    (%eax),%eax
    1d6f:	85 c0                	test   %eax,%eax
    1d71:	75 07                	jne    1d7a <empty_q+0x13>
        return 1;
    1d73:	b8 01 00 00 00       	mov    $0x1,%eax
    1d78:	eb 05                	jmp    1d7f <empty_q+0x18>
    else
        return 0;
    1d7a:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1d7f:	5d                   	pop    %ebp
    1d80:	c3                   	ret    

00001d81 <pop_q>:
int pop_q(struct queue *q){
    1d81:	55                   	push   %ebp
    1d82:	89 e5                	mov    %esp,%ebp
    1d84:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1d87:	8b 45 08             	mov    0x8(%ebp),%eax
    1d8a:	89 04 24             	mov    %eax,(%esp)
    1d8d:	e8 d5 ff ff ff       	call   1d67 <empty_q>
    1d92:	85 c0                	test   %eax,%eax
    1d94:	75 5d                	jne    1df3 <pop_q+0x72>
       val = q->head->value; 
    1d96:	8b 45 08             	mov    0x8(%ebp),%eax
    1d99:	8b 40 04             	mov    0x4(%eax),%eax
    1d9c:	8b 00                	mov    (%eax),%eax
    1d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1da1:	8b 45 08             	mov    0x8(%ebp),%eax
    1da4:	8b 40 04             	mov    0x4(%eax),%eax
    1da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1daa:	8b 45 08             	mov    0x8(%ebp),%eax
    1dad:	8b 40 04             	mov    0x4(%eax),%eax
    1db0:	8b 50 04             	mov    0x4(%eax),%edx
    1db3:	8b 45 08             	mov    0x8(%ebp),%eax
    1db6:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1dbc:	89 04 24             	mov    %eax,(%esp)
    1dbf:	e8 c0 fa ff ff       	call   1884 <free>
       q->size--;
    1dc4:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc7:	8b 00                	mov    (%eax),%eax
    1dc9:	8d 50 ff             	lea    -0x1(%eax),%edx
    1dcc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcf:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1dd1:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd4:	8b 00                	mov    (%eax),%eax
    1dd6:	85 c0                	test   %eax,%eax
    1dd8:	75 14                	jne    1dee <pop_q+0x6d>
            q->head = 0;
    1dda:	8b 45 08             	mov    0x8(%ebp),%eax
    1ddd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1de4:	8b 45 08             	mov    0x8(%ebp),%eax
    1de7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1df1:	eb 05                	jmp    1df8 <pop_q+0x77>
    }
    return -1;
    1df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1df8:	c9                   	leave  
    1df9:	c3                   	ret    
