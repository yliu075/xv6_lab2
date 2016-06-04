
_th:     file format elf32-i386


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
    1018:	e8 54 0c 00 00       	call   1c71 <init_q>
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
    102e:	e8 fa 04 00 00       	call   152d <getpid>
    1033:	8b 55 08             	mov    0x8(%ebp),%edx
    1036:	83 c2 04             	add    $0x4,%edx
    1039:	89 44 24 04          	mov    %eax,0x4(%esp)
    103d:	89 14 24             	mov    %edx,(%esp)
    1040:	e8 4e 0c 00 00       	call   1c93 <add_q>
      while((s->count == 0) ) wait();
    1045:	eb 05                	jmp    104c <sema_acquire+0x2d>
    1047:	e8 69 04 00 00       	call   14b5 <wait>
    104c:	8b 45 08             	mov    0x8(%ebp),%eax
    104f:	8b 00                	mov    (%eax),%eax
    1051:	85 c0                	test   %eax,%eax
    1053:	74 f2                	je     1047 <sema_acquire+0x28>
      pop_q(&(s->q));
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	83 c0 04             	add    $0x4,%eax
    105b:	89 04 24             	mov    %eax,(%esp)
    105e:	e8 aa 0c 00 00       	call   1d0d <pop_q>
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
    108f:	a1 90 22 00 00       	mov    0x2290,%eax
    1094:	89 44 24 08          	mov    %eax,0x8(%esp)
    1098:	c7 44 24 04 86 1d 00 	movl   $0x1d86,0x4(%esp)
    109f:	00 
    10a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a7:	e8 b1 05 00 00       	call   165d <printf>
    sema_init(h);
    10ac:	a1 ac 22 00 00       	mov    0x22ac,%eax
    10b1:	89 04 24             	mov    %eax,(%esp)
    10b4:	e8 47 ff ff ff       	call   1000 <sema_init>
    //sema_init(h2);
    sema_init(o);
    10b9:	a1 a8 22 00 00       	mov    0x22a8,%eax
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 3a ff ff ff       	call   1000 <sema_init>
    h->count = 1;
    10c6:	a1 ac 22 00 00       	mov    0x22ac,%eax
    10cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    o->count = 1;
    10d1:	a1 a8 22 00 00       	mov    0x22a8,%eax
    10d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    thread_create(hReady, (void *)&water_molecules);
    10dc:	c7 44 24 04 90 22 00 	movl   $0x2290,0x4(%esp)
    10e3:	00 
    10e4:	c7 04 24 c0 11 00 00 	movl   $0x11c0,(%esp)
    10eb:	e8 9c 09 00 00       	call   1a8c <thread_create>
    thread_create(hReady, (void *)&water_molecules);
    10f0:	c7 44 24 04 90 22 00 	movl   $0x2290,0x4(%esp)
    10f7:	00 
    10f8:	c7 04 24 c0 11 00 00 	movl   $0x11c0,(%esp)
    10ff:	e8 88 09 00 00       	call   1a8c <thread_create>
    thread_create(oReady, (void *)&water_molecules);
    1104:	c7 44 24 04 90 22 00 	movl   $0x2290,0x4(%esp)
    110b:	00 
    110c:	c7 04 24 e5 11 00 00 	movl   $0x11e5,(%esp)
    1113:	e8 74 09 00 00       	call   1a8c <thread_create>
    while(wait() >= 0){}
    1118:	90                   	nop
    1119:	e8 97 03 00 00       	call   14b5 <wait>
    111e:	85 c0                	test   %eax,%eax
    1120:	79 f7                	jns    1119 <main+0x93>
    //wait();
    //printf(1,"Waited 2\n");
    //thread_yield_last();
    //wait();
    //printf(1,"Waited 3\n");
    printf(1,"Water Count: %d\n", water_molecules);
    1122:	a1 90 22 00 00       	mov    0x2290,%eax
    1127:	89 44 24 08          	mov    %eax,0x8(%esp)
    112b:	c7 44 24 04 86 1d 00 	movl   $0x1d86,0x4(%esp)
    1132:	00 
    1133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113a:	e8 1e 05 00 00       	call   165d <printf>
    exit();
    113f:	e8 69 03 00 00       	call   14ad <exit>

00001144 <ping>:
}


void ping(void *arg_ptr){
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    114a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    1151:	eb 24                	jmp    1177 <ping+0x33>
    // while(1) {
        printf(1,"Ping %d \n",i);
    1153:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1156:	89 44 24 08          	mov    %eax,0x8(%esp)
    115a:	c7 44 24 04 97 1d 00 	movl   $0x1d97,0x4(%esp)
    1161:	00 
    1162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1169:	e8 ef 04 00 00       	call   165d <printf>
        thread_yield2();
    116e:	e8 4f 0a 00 00       	call   1bc2 <thread_yield2>
}


void ping(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    1173:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1177:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    117b:	7e d6                	jle    1153 <ping+0xf>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    117d:	e8 d3 03 00 00       	call   1555 <texit>

00001182 <pong>:
}
void pong(void *arg_ptr){
    1182:	55                   	push   %ebp
    1183:	89 e5                	mov    %esp,%ebp
    1185:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    1188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    118f:	eb 24                	jmp    11b5 <pong+0x33>
    // while(1) {
        printf(1,"Pong %d \n",i);
    1191:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1194:	89 44 24 08          	mov    %eax,0x8(%esp)
    1198:	c7 44 24 04 a1 1d 00 	movl   $0x1da1,0x4(%esp)
    119f:	00 
    11a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11a7:	e8 b1 04 00 00       	call   165d <printf>
        thread_yield2();
    11ac:	e8 11 0a 00 00       	call   1bc2 <thread_yield2>
    //printf(1,"Pinged ALL\n");
    texit();
}
void pong(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    11b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11b5:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    11b9:	7e d6                	jle    1191 <pong+0xf>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    11bb:	e8 95 03 00 00       	call   1555 <texit>

000011c0 <hReady>:
}

void hReady(void *water) {
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	83 ec 18             	sub    $0x18,%esp
    //printf(1, "Added H\n");
    sema_signal(h);
    11c6:	a1 ac 22 00 00       	mov    0x22ac,%eax
    11cb:	89 04 24             	mov    %eax,(%esp)
    11ce:	e8 a1 fe ff ff       	call   1074 <sema_signal>
    sema_acquire(o);
    11d3:	a1 a8 22 00 00       	mov    0x22a8,%eax
    11d8:	89 04 24             	mov    %eax,(%esp)
    11db:	e8 3f fe ff ff       	call   101f <sema_acquire>
    //printf(1, "Exit H\n");
    texit();
    11e0:	e8 70 03 00 00       	call   1555 <texit>

000011e5 <oReady>:
}

void oReady(void *water) {
    11e5:	55                   	push   %ebp
    11e6:	89 e5                	mov    %esp,%ebp
    11e8:	83 ec 18             	sub    $0x18,%esp
    //printf(1, "Added O\n");
    sema_acquire(h);
    11eb:	a1 ac 22 00 00       	mov    0x22ac,%eax
    11f0:	89 04 24             	mov    %eax,(%esp)
    11f3:	e8 27 fe ff ff       	call   101f <sema_acquire>
    //printf(1, "After H1\n");
    sema_acquire(h);
    11f8:	a1 ac 22 00 00       	mov    0x22ac,%eax
    11fd:	89 04 24             	mov    %eax,(%esp)
    1200:	e8 1a fe ff ff       	call   101f <sema_acquire>
    //printf(1, "After H2\n");
    sema_signal(o);
    1205:	a1 a8 22 00 00       	mov    0x22a8,%eax
    120a:	89 04 24             	mov    %eax,(%esp)
    120d:	e8 62 fe ff ff       	call   1074 <sema_signal>
    sema_signal(o);
    1212:	a1 a8 22 00 00       	mov    0x22a8,%eax
    1217:	89 04 24             	mov    %eax,(%esp)
    121a:	e8 55 fe ff ff       	call   1074 <sema_signal>
    water_molecules++;
    121f:	a1 90 22 00 00       	mov    0x2290,%eax
    1224:	83 c0 01             	add    $0x1,%eax
    1227:	a3 90 22 00 00       	mov    %eax,0x2290
    printf(1, "H2O\n");
    122c:	c7 44 24 04 ab 1d 00 	movl   $0x1dab,0x4(%esp)
    1233:	00 
    1234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    123b:	e8 1d 04 00 00       	call   165d <printf>
    //printf(1, "Exit O\n");
    texit();
    1240:	e8 10 03 00 00       	call   1555 <texit>

00001245 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1245:	55                   	push   %ebp
    1246:	89 e5                	mov    %esp,%ebp
    1248:	57                   	push   %edi
    1249:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    124a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    124d:	8b 55 10             	mov    0x10(%ebp),%edx
    1250:	8b 45 0c             	mov    0xc(%ebp),%eax
    1253:	89 cb                	mov    %ecx,%ebx
    1255:	89 df                	mov    %ebx,%edi
    1257:	89 d1                	mov    %edx,%ecx
    1259:	fc                   	cld    
    125a:	f3 aa                	rep stos %al,%es:(%edi)
    125c:	89 ca                	mov    %ecx,%edx
    125e:	89 fb                	mov    %edi,%ebx
    1260:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1263:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1266:	5b                   	pop    %ebx
    1267:	5f                   	pop    %edi
    1268:	5d                   	pop    %ebp
    1269:	c3                   	ret    

0000126a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    126a:	55                   	push   %ebp
    126b:	89 e5                	mov    %esp,%ebp
    126d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1270:	8b 45 08             	mov    0x8(%ebp),%eax
    1273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1276:	90                   	nop
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	8d 50 01             	lea    0x1(%eax),%edx
    127d:	89 55 08             	mov    %edx,0x8(%ebp)
    1280:	8b 55 0c             	mov    0xc(%ebp),%edx
    1283:	8d 4a 01             	lea    0x1(%edx),%ecx
    1286:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1289:	0f b6 12             	movzbl (%edx),%edx
    128c:	88 10                	mov    %dl,(%eax)
    128e:	0f b6 00             	movzbl (%eax),%eax
    1291:	84 c0                	test   %al,%al
    1293:	75 e2                	jne    1277 <strcpy+0xd>
    ;
  return os;
    1295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1298:	c9                   	leave  
    1299:	c3                   	ret    

0000129a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    129a:	55                   	push   %ebp
    129b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    129d:	eb 08                	jmp    12a7 <strcmp+0xd>
    p++, q++;
    129f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    12a7:	8b 45 08             	mov    0x8(%ebp),%eax
    12aa:	0f b6 00             	movzbl (%eax),%eax
    12ad:	84 c0                	test   %al,%al
    12af:	74 10                	je     12c1 <strcmp+0x27>
    12b1:	8b 45 08             	mov    0x8(%ebp),%eax
    12b4:	0f b6 10             	movzbl (%eax),%edx
    12b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ba:	0f b6 00             	movzbl (%eax),%eax
    12bd:	38 c2                	cmp    %al,%dl
    12bf:	74 de                	je     129f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    12c1:	8b 45 08             	mov    0x8(%ebp),%eax
    12c4:	0f b6 00             	movzbl (%eax),%eax
    12c7:	0f b6 d0             	movzbl %al,%edx
    12ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    12cd:	0f b6 00             	movzbl (%eax),%eax
    12d0:	0f b6 c0             	movzbl %al,%eax
    12d3:	29 c2                	sub    %eax,%edx
    12d5:	89 d0                	mov    %edx,%eax
}
    12d7:	5d                   	pop    %ebp
    12d8:	c3                   	ret    

000012d9 <strlen>:

uint
strlen(char *s)
{
    12d9:	55                   	push   %ebp
    12da:	89 e5                	mov    %esp,%ebp
    12dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    12df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    12e6:	eb 04                	jmp    12ec <strlen+0x13>
    12e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    12ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12ef:	8b 45 08             	mov    0x8(%ebp),%eax
    12f2:	01 d0                	add    %edx,%eax
    12f4:	0f b6 00             	movzbl (%eax),%eax
    12f7:	84 c0                	test   %al,%al
    12f9:	75 ed                	jne    12e8 <strlen+0xf>
    ;
  return n;
    12fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12fe:	c9                   	leave  
    12ff:	c3                   	ret    

00001300 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1300:	55                   	push   %ebp
    1301:	89 e5                	mov    %esp,%ebp
    1303:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1306:	8b 45 10             	mov    0x10(%ebp),%eax
    1309:	89 44 24 08          	mov    %eax,0x8(%esp)
    130d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1310:	89 44 24 04          	mov    %eax,0x4(%esp)
    1314:	8b 45 08             	mov    0x8(%ebp),%eax
    1317:	89 04 24             	mov    %eax,(%esp)
    131a:	e8 26 ff ff ff       	call   1245 <stosb>
  return dst;
    131f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1322:	c9                   	leave  
    1323:	c3                   	ret    

00001324 <strchr>:

char*
strchr(const char *s, char c)
{
    1324:	55                   	push   %ebp
    1325:	89 e5                	mov    %esp,%ebp
    1327:	83 ec 04             	sub    $0x4,%esp
    132a:	8b 45 0c             	mov    0xc(%ebp),%eax
    132d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1330:	eb 14                	jmp    1346 <strchr+0x22>
    if(*s == c)
    1332:	8b 45 08             	mov    0x8(%ebp),%eax
    1335:	0f b6 00             	movzbl (%eax),%eax
    1338:	3a 45 fc             	cmp    -0x4(%ebp),%al
    133b:	75 05                	jne    1342 <strchr+0x1e>
      return (char*)s;
    133d:	8b 45 08             	mov    0x8(%ebp),%eax
    1340:	eb 13                	jmp    1355 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1342:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	0f b6 00             	movzbl (%eax),%eax
    134c:	84 c0                	test   %al,%al
    134e:	75 e2                	jne    1332 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1350:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1355:	c9                   	leave  
    1356:	c3                   	ret    

00001357 <gets>:

char*
gets(char *buf, int max)
{
    1357:	55                   	push   %ebp
    1358:	89 e5                	mov    %esp,%ebp
    135a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    135d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1364:	eb 4c                	jmp    13b2 <gets+0x5b>
    cc = read(0, &c, 1);
    1366:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    136d:	00 
    136e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1371:	89 44 24 04          	mov    %eax,0x4(%esp)
    1375:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    137c:	e8 44 01 00 00       	call   14c5 <read>
    1381:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1388:	7f 02                	jg     138c <gets+0x35>
      break;
    138a:	eb 31                	jmp    13bd <gets+0x66>
    buf[i++] = c;
    138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    138f:	8d 50 01             	lea    0x1(%eax),%edx
    1392:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1395:	89 c2                	mov    %eax,%edx
    1397:	8b 45 08             	mov    0x8(%ebp),%eax
    139a:	01 c2                	add    %eax,%edx
    139c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13a0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    13a2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13a6:	3c 0a                	cmp    $0xa,%al
    13a8:	74 13                	je     13bd <gets+0x66>
    13aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13ae:	3c 0d                	cmp    $0xd,%al
    13b0:	74 0b                	je     13bd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b5:	83 c0 01             	add    $0x1,%eax
    13b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
    13bb:	7c a9                	jl     1366 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    13bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13c0:	8b 45 08             	mov    0x8(%ebp),%eax
    13c3:	01 d0                	add    %edx,%eax
    13c5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    13c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13cb:	c9                   	leave  
    13cc:	c3                   	ret    

000013cd <stat>:

int
stat(char *n, struct stat *st)
{
    13cd:	55                   	push   %ebp
    13ce:	89 e5                	mov    %esp,%ebp
    13d0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13da:	00 
    13db:	8b 45 08             	mov    0x8(%ebp),%eax
    13de:	89 04 24             	mov    %eax,(%esp)
    13e1:	e8 07 01 00 00       	call   14ed <open>
    13e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    13e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13ed:	79 07                	jns    13f6 <stat+0x29>
    return -1;
    13ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13f4:	eb 23                	jmp    1419 <stat+0x4c>
  r = fstat(fd, st);
    13f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f9:	89 44 24 04          	mov    %eax,0x4(%esp)
    13fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1400:	89 04 24             	mov    %eax,(%esp)
    1403:	e8 fd 00 00 00       	call   1505 <fstat>
    1408:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    140b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140e:	89 04 24             	mov    %eax,(%esp)
    1411:	e8 bf 00 00 00       	call   14d5 <close>
  return r;
    1416:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1419:	c9                   	leave  
    141a:	c3                   	ret    

0000141b <atoi>:

int
atoi(const char *s)
{
    141b:	55                   	push   %ebp
    141c:	89 e5                	mov    %esp,%ebp
    141e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1428:	eb 25                	jmp    144f <atoi+0x34>
    n = n*10 + *s++ - '0';
    142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    142d:	89 d0                	mov    %edx,%eax
    142f:	c1 e0 02             	shl    $0x2,%eax
    1432:	01 d0                	add    %edx,%eax
    1434:	01 c0                	add    %eax,%eax
    1436:	89 c1                	mov    %eax,%ecx
    1438:	8b 45 08             	mov    0x8(%ebp),%eax
    143b:	8d 50 01             	lea    0x1(%eax),%edx
    143e:	89 55 08             	mov    %edx,0x8(%ebp)
    1441:	0f b6 00             	movzbl (%eax),%eax
    1444:	0f be c0             	movsbl %al,%eax
    1447:	01 c8                	add    %ecx,%eax
    1449:	83 e8 30             	sub    $0x30,%eax
    144c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    144f:	8b 45 08             	mov    0x8(%ebp),%eax
    1452:	0f b6 00             	movzbl (%eax),%eax
    1455:	3c 2f                	cmp    $0x2f,%al
    1457:	7e 0a                	jle    1463 <atoi+0x48>
    1459:	8b 45 08             	mov    0x8(%ebp),%eax
    145c:	0f b6 00             	movzbl (%eax),%eax
    145f:	3c 39                	cmp    $0x39,%al
    1461:	7e c7                	jle    142a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1466:	c9                   	leave  
    1467:	c3                   	ret    

00001468 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1468:	55                   	push   %ebp
    1469:	89 e5                	mov    %esp,%ebp
    146b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    146e:	8b 45 08             	mov    0x8(%ebp),%eax
    1471:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1474:	8b 45 0c             	mov    0xc(%ebp),%eax
    1477:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    147a:	eb 17                	jmp    1493 <memmove+0x2b>
    *dst++ = *src++;
    147c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    147f:	8d 50 01             	lea    0x1(%eax),%edx
    1482:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1485:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1488:	8d 4a 01             	lea    0x1(%edx),%ecx
    148b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    148e:	0f b6 12             	movzbl (%edx),%edx
    1491:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1493:	8b 45 10             	mov    0x10(%ebp),%eax
    1496:	8d 50 ff             	lea    -0x1(%eax),%edx
    1499:	89 55 10             	mov    %edx,0x10(%ebp)
    149c:	85 c0                	test   %eax,%eax
    149e:	7f dc                	jg     147c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    14a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14a3:	c9                   	leave  
    14a4:	c3                   	ret    

000014a5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    14a5:	b8 01 00 00 00       	mov    $0x1,%eax
    14aa:	cd 40                	int    $0x40
    14ac:	c3                   	ret    

000014ad <exit>:
SYSCALL(exit)
    14ad:	b8 02 00 00 00       	mov    $0x2,%eax
    14b2:	cd 40                	int    $0x40
    14b4:	c3                   	ret    

000014b5 <wait>:
SYSCALL(wait)
    14b5:	b8 03 00 00 00       	mov    $0x3,%eax
    14ba:	cd 40                	int    $0x40
    14bc:	c3                   	ret    

000014bd <pipe>:
SYSCALL(pipe)
    14bd:	b8 04 00 00 00       	mov    $0x4,%eax
    14c2:	cd 40                	int    $0x40
    14c4:	c3                   	ret    

000014c5 <read>:
SYSCALL(read)
    14c5:	b8 05 00 00 00       	mov    $0x5,%eax
    14ca:	cd 40                	int    $0x40
    14cc:	c3                   	ret    

000014cd <write>:
SYSCALL(write)
    14cd:	b8 10 00 00 00       	mov    $0x10,%eax
    14d2:	cd 40                	int    $0x40
    14d4:	c3                   	ret    

000014d5 <close>:
SYSCALL(close)
    14d5:	b8 15 00 00 00       	mov    $0x15,%eax
    14da:	cd 40                	int    $0x40
    14dc:	c3                   	ret    

000014dd <kill>:
SYSCALL(kill)
    14dd:	b8 06 00 00 00       	mov    $0x6,%eax
    14e2:	cd 40                	int    $0x40
    14e4:	c3                   	ret    

000014e5 <exec>:
SYSCALL(exec)
    14e5:	b8 07 00 00 00       	mov    $0x7,%eax
    14ea:	cd 40                	int    $0x40
    14ec:	c3                   	ret    

000014ed <open>:
SYSCALL(open)
    14ed:	b8 0f 00 00 00       	mov    $0xf,%eax
    14f2:	cd 40                	int    $0x40
    14f4:	c3                   	ret    

000014f5 <mknod>:
SYSCALL(mknod)
    14f5:	b8 11 00 00 00       	mov    $0x11,%eax
    14fa:	cd 40                	int    $0x40
    14fc:	c3                   	ret    

000014fd <unlink>:
SYSCALL(unlink)
    14fd:	b8 12 00 00 00       	mov    $0x12,%eax
    1502:	cd 40                	int    $0x40
    1504:	c3                   	ret    

00001505 <fstat>:
SYSCALL(fstat)
    1505:	b8 08 00 00 00       	mov    $0x8,%eax
    150a:	cd 40                	int    $0x40
    150c:	c3                   	ret    

0000150d <link>:
SYSCALL(link)
    150d:	b8 13 00 00 00       	mov    $0x13,%eax
    1512:	cd 40                	int    $0x40
    1514:	c3                   	ret    

00001515 <mkdir>:
SYSCALL(mkdir)
    1515:	b8 14 00 00 00       	mov    $0x14,%eax
    151a:	cd 40                	int    $0x40
    151c:	c3                   	ret    

0000151d <chdir>:
SYSCALL(chdir)
    151d:	b8 09 00 00 00       	mov    $0x9,%eax
    1522:	cd 40                	int    $0x40
    1524:	c3                   	ret    

00001525 <dup>:
SYSCALL(dup)
    1525:	b8 0a 00 00 00       	mov    $0xa,%eax
    152a:	cd 40                	int    $0x40
    152c:	c3                   	ret    

0000152d <getpid>:
SYSCALL(getpid)
    152d:	b8 0b 00 00 00       	mov    $0xb,%eax
    1532:	cd 40                	int    $0x40
    1534:	c3                   	ret    

00001535 <sbrk>:
SYSCALL(sbrk)
    1535:	b8 0c 00 00 00       	mov    $0xc,%eax
    153a:	cd 40                	int    $0x40
    153c:	c3                   	ret    

0000153d <sleep>:
SYSCALL(sleep)
    153d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1542:	cd 40                	int    $0x40
    1544:	c3                   	ret    

00001545 <uptime>:
SYSCALL(uptime)
    1545:	b8 0e 00 00 00       	mov    $0xe,%eax
    154a:	cd 40                	int    $0x40
    154c:	c3                   	ret    

0000154d <clone>:
SYSCALL(clone)
    154d:	b8 16 00 00 00       	mov    $0x16,%eax
    1552:	cd 40                	int    $0x40
    1554:	c3                   	ret    

00001555 <texit>:
SYSCALL(texit)
    1555:	b8 17 00 00 00       	mov    $0x17,%eax
    155a:	cd 40                	int    $0x40
    155c:	c3                   	ret    

0000155d <tsleep>:
SYSCALL(tsleep)
    155d:	b8 18 00 00 00       	mov    $0x18,%eax
    1562:	cd 40                	int    $0x40
    1564:	c3                   	ret    

00001565 <twakeup>:
SYSCALL(twakeup)
    1565:	b8 19 00 00 00       	mov    $0x19,%eax
    156a:	cd 40                	int    $0x40
    156c:	c3                   	ret    

0000156d <thread_yield>:
SYSCALL(thread_yield)
    156d:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1572:	cd 40                	int    $0x40
    1574:	c3                   	ret    

00001575 <thread_yield3>:
    1575:	b8 1a 00 00 00       	mov    $0x1a,%eax
    157a:	cd 40                	int    $0x40
    157c:	c3                   	ret    

0000157d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    157d:	55                   	push   %ebp
    157e:	89 e5                	mov    %esp,%ebp
    1580:	83 ec 18             	sub    $0x18,%esp
    1583:	8b 45 0c             	mov    0xc(%ebp),%eax
    1586:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1589:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1590:	00 
    1591:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1594:	89 44 24 04          	mov    %eax,0x4(%esp)
    1598:	8b 45 08             	mov    0x8(%ebp),%eax
    159b:	89 04 24             	mov    %eax,(%esp)
    159e:	e8 2a ff ff ff       	call   14cd <write>
}
    15a3:	c9                   	leave  
    15a4:	c3                   	ret    

000015a5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    15a5:	55                   	push   %ebp
    15a6:	89 e5                	mov    %esp,%ebp
    15a8:	56                   	push   %esi
    15a9:	53                   	push   %ebx
    15aa:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    15ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    15b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    15b8:	74 17                	je     15d1 <printint+0x2c>
    15ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    15be:	79 11                	jns    15d1 <printint+0x2c>
    neg = 1;
    15c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    15c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    15ca:	f7 d8                	neg    %eax
    15cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15cf:	eb 06                	jmp    15d7 <printint+0x32>
  } else {
    x = xx;
    15d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    15d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    15d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    15de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    15e1:	8d 41 01             	lea    0x1(%ecx),%eax
    15e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    15e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    15ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15ed:	ba 00 00 00 00       	mov    $0x0,%edx
    15f2:	f7 f3                	div    %ebx
    15f4:	89 d0                	mov    %edx,%eax
    15f6:	0f b6 80 78 22 00 00 	movzbl 0x2278(%eax),%eax
    15fd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1601:	8b 75 10             	mov    0x10(%ebp),%esi
    1604:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1607:	ba 00 00 00 00       	mov    $0x0,%edx
    160c:	f7 f6                	div    %esi
    160e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1611:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1615:	75 c7                	jne    15de <printint+0x39>
  if(neg)
    1617:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    161b:	74 10                	je     162d <printint+0x88>
    buf[i++] = '-';
    161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1620:	8d 50 01             	lea    0x1(%eax),%edx
    1623:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1626:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    162b:	eb 1f                	jmp    164c <printint+0xa7>
    162d:	eb 1d                	jmp    164c <printint+0xa7>
    putc(fd, buf[i]);
    162f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1632:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1635:	01 d0                	add    %edx,%eax
    1637:	0f b6 00             	movzbl (%eax),%eax
    163a:	0f be c0             	movsbl %al,%eax
    163d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1641:	8b 45 08             	mov    0x8(%ebp),%eax
    1644:	89 04 24             	mov    %eax,(%esp)
    1647:	e8 31 ff ff ff       	call   157d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    164c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1654:	79 d9                	jns    162f <printint+0x8a>
    putc(fd, buf[i]);
}
    1656:	83 c4 30             	add    $0x30,%esp
    1659:	5b                   	pop    %ebx
    165a:	5e                   	pop    %esi
    165b:	5d                   	pop    %ebp
    165c:	c3                   	ret    

0000165d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    165d:	55                   	push   %ebp
    165e:	89 e5                	mov    %esp,%ebp
    1660:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1663:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    166a:	8d 45 0c             	lea    0xc(%ebp),%eax
    166d:	83 c0 04             	add    $0x4,%eax
    1670:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    167a:	e9 7c 01 00 00       	jmp    17fb <printf+0x19e>
    c = fmt[i] & 0xff;
    167f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1682:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1685:	01 d0                	add    %edx,%eax
    1687:	0f b6 00             	movzbl (%eax),%eax
    168a:	0f be c0             	movsbl %al,%eax
    168d:	25 ff 00 00 00       	and    $0xff,%eax
    1692:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1695:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1699:	75 2c                	jne    16c7 <printf+0x6a>
      if(c == '%'){
    169b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    169f:	75 0c                	jne    16ad <printf+0x50>
        state = '%';
    16a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    16a8:	e9 4a 01 00 00       	jmp    17f7 <printf+0x19a>
      } else {
        putc(fd, c);
    16ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b0:	0f be c0             	movsbl %al,%eax
    16b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b7:	8b 45 08             	mov    0x8(%ebp),%eax
    16ba:	89 04 24             	mov    %eax,(%esp)
    16bd:	e8 bb fe ff ff       	call   157d <putc>
    16c2:	e9 30 01 00 00       	jmp    17f7 <printf+0x19a>
      }
    } else if(state == '%'){
    16c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    16cb:	0f 85 26 01 00 00    	jne    17f7 <printf+0x19a>
      if(c == 'd'){
    16d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    16d5:	75 2d                	jne    1704 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    16d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16da:	8b 00                	mov    (%eax),%eax
    16dc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    16e3:	00 
    16e4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    16eb:	00 
    16ec:	89 44 24 04          	mov    %eax,0x4(%esp)
    16f0:	8b 45 08             	mov    0x8(%ebp),%eax
    16f3:	89 04 24             	mov    %eax,(%esp)
    16f6:	e8 aa fe ff ff       	call   15a5 <printint>
        ap++;
    16fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16ff:	e9 ec 00 00 00       	jmp    17f0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1704:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1708:	74 06                	je     1710 <printf+0xb3>
    170a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    170e:	75 2d                	jne    173d <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1710:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1713:	8b 00                	mov    (%eax),%eax
    1715:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    171c:	00 
    171d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1724:	00 
    1725:	89 44 24 04          	mov    %eax,0x4(%esp)
    1729:	8b 45 08             	mov    0x8(%ebp),%eax
    172c:	89 04 24             	mov    %eax,(%esp)
    172f:	e8 71 fe ff ff       	call   15a5 <printint>
        ap++;
    1734:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1738:	e9 b3 00 00 00       	jmp    17f0 <printf+0x193>
      } else if(c == 's'){
    173d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1741:	75 45                	jne    1788 <printf+0x12b>
        s = (char*)*ap;
    1743:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1746:	8b 00                	mov    (%eax),%eax
    1748:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    174b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    174f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1753:	75 09                	jne    175e <printf+0x101>
          s = "(null)";
    1755:	c7 45 f4 b0 1d 00 00 	movl   $0x1db0,-0xc(%ebp)
        while(*s != 0){
    175c:	eb 1e                	jmp    177c <printf+0x11f>
    175e:	eb 1c                	jmp    177c <printf+0x11f>
          putc(fd, *s);
    1760:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1763:	0f b6 00             	movzbl (%eax),%eax
    1766:	0f be c0             	movsbl %al,%eax
    1769:	89 44 24 04          	mov    %eax,0x4(%esp)
    176d:	8b 45 08             	mov    0x8(%ebp),%eax
    1770:	89 04 24             	mov    %eax,(%esp)
    1773:	e8 05 fe ff ff       	call   157d <putc>
          s++;
    1778:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177f:	0f b6 00             	movzbl (%eax),%eax
    1782:	84 c0                	test   %al,%al
    1784:	75 da                	jne    1760 <printf+0x103>
    1786:	eb 68                	jmp    17f0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1788:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    178c:	75 1d                	jne    17ab <printf+0x14e>
        putc(fd, *ap);
    178e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1791:	8b 00                	mov    (%eax),%eax
    1793:	0f be c0             	movsbl %al,%eax
    1796:	89 44 24 04          	mov    %eax,0x4(%esp)
    179a:	8b 45 08             	mov    0x8(%ebp),%eax
    179d:	89 04 24             	mov    %eax,(%esp)
    17a0:	e8 d8 fd ff ff       	call   157d <putc>
        ap++;
    17a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17a9:	eb 45                	jmp    17f0 <printf+0x193>
      } else if(c == '%'){
    17ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17af:	75 17                	jne    17c8 <printf+0x16b>
        putc(fd, c);
    17b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17b4:	0f be c0             	movsbl %al,%eax
    17b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    17bb:	8b 45 08             	mov    0x8(%ebp),%eax
    17be:	89 04 24             	mov    %eax,(%esp)
    17c1:	e8 b7 fd ff ff       	call   157d <putc>
    17c6:	eb 28                	jmp    17f0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    17c8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    17cf:	00 
    17d0:	8b 45 08             	mov    0x8(%ebp),%eax
    17d3:	89 04 24             	mov    %eax,(%esp)
    17d6:	e8 a2 fd ff ff       	call   157d <putc>
        putc(fd, c);
    17db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17de:	0f be c0             	movsbl %al,%eax
    17e1:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e5:	8b 45 08             	mov    0x8(%ebp),%eax
    17e8:	89 04 24             	mov    %eax,(%esp)
    17eb:	e8 8d fd ff ff       	call   157d <putc>
      }
      state = 0;
    17f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    17f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    17fb:	8b 55 0c             	mov    0xc(%ebp),%edx
    17fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1801:	01 d0                	add    %edx,%eax
    1803:	0f b6 00             	movzbl (%eax),%eax
    1806:	84 c0                	test   %al,%al
    1808:	0f 85 71 fe ff ff    	jne    167f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    180e:	c9                   	leave  
    180f:	c3                   	ret    

00001810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1810:	55                   	push   %ebp
    1811:	89 e5                	mov    %esp,%ebp
    1813:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1816:	8b 45 08             	mov    0x8(%ebp),%eax
    1819:	83 e8 08             	sub    $0x8,%eax
    181c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    181f:	a1 9c 22 00 00       	mov    0x229c,%eax
    1824:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1827:	eb 24                	jmp    184d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1829:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182c:	8b 00                	mov    (%eax),%eax
    182e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1831:	77 12                	ja     1845 <free+0x35>
    1833:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1836:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1839:	77 24                	ja     185f <free+0x4f>
    183b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183e:	8b 00                	mov    (%eax),%eax
    1840:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1843:	77 1a                	ja     185f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1845:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1848:	8b 00                	mov    (%eax),%eax
    184a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    184d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1850:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1853:	76 d4                	jbe    1829 <free+0x19>
    1855:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1858:	8b 00                	mov    (%eax),%eax
    185a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    185d:	76 ca                	jbe    1829 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    185f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1862:	8b 40 04             	mov    0x4(%eax),%eax
    1865:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    186c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    186f:	01 c2                	add    %eax,%edx
    1871:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1874:	8b 00                	mov    (%eax),%eax
    1876:	39 c2                	cmp    %eax,%edx
    1878:	75 24                	jne    189e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    187d:	8b 50 04             	mov    0x4(%eax),%edx
    1880:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1883:	8b 00                	mov    (%eax),%eax
    1885:	8b 40 04             	mov    0x4(%eax),%eax
    1888:	01 c2                	add    %eax,%edx
    188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    188d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1890:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1893:	8b 00                	mov    (%eax),%eax
    1895:	8b 10                	mov    (%eax),%edx
    1897:	8b 45 f8             	mov    -0x8(%ebp),%eax
    189a:	89 10                	mov    %edx,(%eax)
    189c:	eb 0a                	jmp    18a8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18a1:	8b 10                	mov    (%eax),%edx
    18a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18a6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    18a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ab:	8b 40 04             	mov    0x4(%eax),%eax
    18ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    18b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18b8:	01 d0                	add    %edx,%eax
    18ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18bd:	75 20                	jne    18df <free+0xcf>
    p->s.size += bp->s.size;
    18bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18c2:	8b 50 04             	mov    0x4(%eax),%edx
    18c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18c8:	8b 40 04             	mov    0x4(%eax),%eax
    18cb:	01 c2                	add    %eax,%edx
    18cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    18d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18d6:	8b 10                	mov    (%eax),%edx
    18d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18db:	89 10                	mov    %edx,(%eax)
    18dd:	eb 08                	jmp    18e7 <free+0xd7>
  } else
    p->s.ptr = bp;
    18df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    18e5:	89 10                	mov    %edx,(%eax)
  freep = p;
    18e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ea:	a3 9c 22 00 00       	mov    %eax,0x229c
}
    18ef:	c9                   	leave  
    18f0:	c3                   	ret    

000018f1 <morecore>:

static Header*
morecore(uint nu)
{
    18f1:	55                   	push   %ebp
    18f2:	89 e5                	mov    %esp,%ebp
    18f4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    18f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    18fe:	77 07                	ja     1907 <morecore+0x16>
    nu = 4096;
    1900:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1907:	8b 45 08             	mov    0x8(%ebp),%eax
    190a:	c1 e0 03             	shl    $0x3,%eax
    190d:	89 04 24             	mov    %eax,(%esp)
    1910:	e8 20 fc ff ff       	call   1535 <sbrk>
    1915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1918:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    191c:	75 07                	jne    1925 <morecore+0x34>
    return 0;
    191e:	b8 00 00 00 00       	mov    $0x0,%eax
    1923:	eb 22                	jmp    1947 <morecore+0x56>
  hp = (Header*)p;
    1925:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1928:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    192e:	8b 55 08             	mov    0x8(%ebp),%edx
    1931:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1934:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1937:	83 c0 08             	add    $0x8,%eax
    193a:	89 04 24             	mov    %eax,(%esp)
    193d:	e8 ce fe ff ff       	call   1810 <free>
  return freep;
    1942:	a1 9c 22 00 00       	mov    0x229c,%eax
}
    1947:	c9                   	leave  
    1948:	c3                   	ret    

00001949 <malloc>:

void*
malloc(uint nbytes)
{
    1949:	55                   	push   %ebp
    194a:	89 e5                	mov    %esp,%ebp
    194c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    194f:	8b 45 08             	mov    0x8(%ebp),%eax
    1952:	83 c0 07             	add    $0x7,%eax
    1955:	c1 e8 03             	shr    $0x3,%eax
    1958:	83 c0 01             	add    $0x1,%eax
    195b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    195e:	a1 9c 22 00 00       	mov    0x229c,%eax
    1963:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1966:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    196a:	75 23                	jne    198f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    196c:	c7 45 f0 94 22 00 00 	movl   $0x2294,-0x10(%ebp)
    1973:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1976:	a3 9c 22 00 00       	mov    %eax,0x229c
    197b:	a1 9c 22 00 00       	mov    0x229c,%eax
    1980:	a3 94 22 00 00       	mov    %eax,0x2294
    base.s.size = 0;
    1985:	c7 05 98 22 00 00 00 	movl   $0x0,0x2298
    198c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1992:	8b 00                	mov    (%eax),%eax
    1994:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1997:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199a:	8b 40 04             	mov    0x4(%eax),%eax
    199d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19a0:	72 4d                	jb     19ef <malloc+0xa6>
      if(p->s.size == nunits)
    19a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a5:	8b 40 04             	mov    0x4(%eax),%eax
    19a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19ab:	75 0c                	jne    19b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    19ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b0:	8b 10                	mov    (%eax),%edx
    19b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19b5:	89 10                	mov    %edx,(%eax)
    19b7:	eb 26                	jmp    19df <malloc+0x96>
      else {
        p->s.size -= nunits;
    19b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19bc:	8b 40 04             	mov    0x4(%eax),%eax
    19bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    19c2:	89 c2                	mov    %eax,%edx
    19c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    19ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19cd:	8b 40 04             	mov    0x4(%eax),%eax
    19d0:	c1 e0 03             	shl    $0x3,%eax
    19d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    19d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    19df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19e2:	a3 9c 22 00 00       	mov    %eax,0x229c
      return (void*)(p + 1);
    19e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ea:	83 c0 08             	add    $0x8,%eax
    19ed:	eb 38                	jmp    1a27 <malloc+0xde>
    }
    if(p == freep)
    19ef:	a1 9c 22 00 00       	mov    0x229c,%eax
    19f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    19f7:	75 1b                	jne    1a14 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    19f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    19fc:	89 04 24             	mov    %eax,(%esp)
    19ff:	e8 ed fe ff ff       	call   18f1 <morecore>
    1a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a0b:	75 07                	jne    1a14 <malloc+0xcb>
        return 0;
    1a0d:	b8 00 00 00 00       	mov    $0x0,%eax
    1a12:	eb 13                	jmp    1a27 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a1d:	8b 00                	mov    (%eax),%eax
    1a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1a22:	e9 70 ff ff ff       	jmp    1997 <malloc+0x4e>
}
    1a27:	c9                   	leave  
    1a28:	c3                   	ret    

00001a29 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1a29:	55                   	push   %ebp
    1a2a:	89 e5                	mov    %esp,%ebp
    1a2c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1a2f:	8b 55 08             	mov    0x8(%ebp),%edx
    1a32:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a38:	f0 87 02             	lock xchg %eax,(%edx)
    1a3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1a41:	c9                   	leave  
    1a42:	c3                   	ret    

00001a43 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1a43:	55                   	push   %ebp
    1a44:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1a46:	8b 45 08             	mov    0x8(%ebp),%eax
    1a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1a4f:	5d                   	pop    %ebp
    1a50:	c3                   	ret    

00001a51 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1a51:	55                   	push   %ebp
    1a52:	89 e5                	mov    %esp,%ebp
    1a54:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1a57:	90                   	nop
    1a58:	8b 45 08             	mov    0x8(%ebp),%eax
    1a5b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1a62:	00 
    1a63:	89 04 24             	mov    %eax,(%esp)
    1a66:	e8 be ff ff ff       	call   1a29 <xchg>
    1a6b:	85 c0                	test   %eax,%eax
    1a6d:	75 e9                	jne    1a58 <lock_acquire+0x7>
}
    1a6f:	c9                   	leave  
    1a70:	c3                   	ret    

00001a71 <lock_release>:
void lock_release(lock_t *lock){
    1a71:	55                   	push   %ebp
    1a72:	89 e5                	mov    %esp,%ebp
    1a74:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1a77:	8b 45 08             	mov    0x8(%ebp),%eax
    1a7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a81:	00 
    1a82:	89 04 24             	mov    %eax,(%esp)
    1a85:	e8 9f ff ff ff       	call   1a29 <xchg>
}
    1a8a:	c9                   	leave  
    1a8b:	c3                   	ret    

00001a8c <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1a8c:	55                   	push   %ebp
    1a8d:	89 e5                	mov    %esp,%ebp
    1a8f:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1a92:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1a99:	e8 ab fe ff ff       	call   1949 <malloc>
    1a9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1aa7:	0f b6 05 a0 22 00 00 	movzbl 0x22a0,%eax
    1aae:	84 c0                	test   %al,%al
    1ab0:	75 1c                	jne    1ace <thread_create+0x42>
        init_q(thQ2);
    1ab2:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1ab7:	89 04 24             	mov    %eax,(%esp)
    1aba:	e8 b2 01 00 00       	call   1c71 <init_q>
        inQ++;
    1abf:	0f b6 05 a0 22 00 00 	movzbl 0x22a0,%eax
    1ac6:	83 c0 01             	add    $0x1,%eax
    1ac9:	a2 a0 22 00 00       	mov    %al,0x22a0
    }

    if((uint)stack % 4096){
    1ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad1:	25 ff 0f 00 00       	and    $0xfff,%eax
    1ad6:	85 c0                	test   %eax,%eax
    1ad8:	74 14                	je     1aee <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1add:	25 ff 0f 00 00       	and    $0xfff,%eax
    1ae2:	89 c2                	mov    %eax,%edx
    1ae4:	b8 00 10 00 00       	mov    $0x1000,%eax
    1ae9:	29 d0                	sub    %edx,%eax
    1aeb:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1af2:	75 1e                	jne    1b12 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1af4:	c7 44 24 04 b7 1d 00 	movl   $0x1db7,0x4(%esp)
    1afb:	00 
    1afc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b03:	e8 55 fb ff ff       	call   165d <printf>
        return 0;
    1b08:	b8 00 00 00 00       	mov    $0x0,%eax
    1b0d:	e9 83 00 00 00       	jmp    1b95 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1b12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1b15:	8b 55 08             	mov    0x8(%ebp),%edx
    1b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1b1f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1b23:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1b2a:	00 
    1b2b:	89 04 24             	mov    %eax,(%esp)
    1b2e:	e8 1a fa ff ff       	call   154d <clone>
    1b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1b36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b3a:	79 1b                	jns    1b57 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1b3c:	c7 44 24 04 c5 1d 00 	movl   $0x1dc5,0x4(%esp)
    1b43:	00 
    1b44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b4b:	e8 0d fb ff ff       	call   165d <printf>
        return 0;
    1b50:	b8 00 00 00 00       	mov    $0x0,%eax
    1b55:	eb 3e                	jmp    1b95 <thread_create+0x109>
    }
    if(tid > 0){
    1b57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b5b:	7e 19                	jle    1b76 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1b5d:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1b62:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b65:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b69:	89 04 24             	mov    %eax,(%esp)
    1b6c:	e8 22 01 00 00       	call   1c93 <add_q>
        return garbage_stack;
    1b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b74:	eb 1f                	jmp    1b95 <thread_create+0x109>
    }
    if(tid == 0){
    1b76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b7a:	75 14                	jne    1b90 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1b7c:	c7 44 24 04 d2 1d 00 	movl   $0x1dd2,0x4(%esp)
    1b83:	00 
    1b84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b8b:	e8 cd fa ff ff       	call   165d <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1b95:	c9                   	leave  
    1b96:	c3                   	ret    

00001b97 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1b97:	55                   	push   %ebp
    1b98:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1b9a:	a1 8c 22 00 00       	mov    0x228c,%eax
    1b9f:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1ba5:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1baa:	a3 8c 22 00 00       	mov    %eax,0x228c
    return (int)(rands % max);
    1baf:	a1 8c 22 00 00       	mov    0x228c,%eax
    1bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1bb7:	ba 00 00 00 00       	mov    $0x0,%edx
    1bbc:	f7 f1                	div    %ecx
    1bbe:	89 d0                	mov    %edx,%eax
}
    1bc0:	5d                   	pop    %ebp
    1bc1:	c3                   	ret    

00001bc2 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1bc2:	55                   	push   %ebp
    1bc3:	89 e5                	mov    %esp,%ebp
    1bc5:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1bc8:	e8 60 f9 ff ff       	call   152d <getpid>
    1bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1bd0:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1bd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1bd8:	89 54 24 04          	mov    %edx,0x4(%esp)
    1bdc:	89 04 24             	mov    %eax,(%esp)
    1bdf:	e8 af 00 00 00       	call   1c93 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1be4:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1be9:	89 04 24             	mov    %eax,(%esp)
    1bec:	e8 1c 01 00 00       	call   1d0d <pop_q>
    1bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1bf4:	a1 a4 22 00 00       	mov    0x22a4,%eax
    1bf9:	85 c0                	test   %eax,%eax
    1bfb:	75 1f                	jne    1c1c <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1bfd:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1c02:	89 04 24             	mov    %eax,(%esp)
    1c05:	e8 03 01 00 00       	call   1d0d <pop_q>
    1c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1c0d:	a1 a4 22 00 00       	mov    0x22a4,%eax
    1c12:	83 c0 01             	add    $0x1,%eax
    1c15:	a3 a4 22 00 00       	mov    %eax,0x22a4
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1c1a:	eb 12                	jmp    1c2e <thread_yield2+0x6c>
    1c1c:	eb 10                	jmp    1c2e <thread_yield2+0x6c>
    1c1e:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1c23:	89 04 24             	mov    %eax,(%esp)
    1c26:	e8 e2 00 00 00       	call   1d0d <pop_q>
    1c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1c34:	74 e8                	je     1c1e <thread_yield2+0x5c>
    1c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c3a:	74 e2                	je     1c1e <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c3f:	89 04 24             	mov    %eax,(%esp)
    1c42:	e8 1e f9 ff ff       	call   1565 <twakeup>
    tsleep();
    1c47:	e8 11 f9 ff ff       	call   155d <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1c4c:	c9                   	leave  
    1c4d:	c3                   	ret    

00001c4e <thread_yield_last>:

void thread_yield_last(){
    1c4e:	55                   	push   %ebp
    1c4f:	89 e5                	mov    %esp,%ebp
    1c51:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1c54:	a1 b0 22 00 00       	mov    0x22b0,%eax
    1c59:	89 04 24             	mov    %eax,(%esp)
    1c5c:	e8 ac 00 00 00       	call   1d0d <pop_q>
    1c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c67:	89 04 24             	mov    %eax,(%esp)
    1c6a:	e8 f6 f8 ff ff       	call   1565 <twakeup>
    1c6f:	c9                   	leave  
    1c70:	c3                   	ret    

00001c71 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1c71:	55                   	push   %ebp
    1c72:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1c74:	8b 45 08             	mov    0x8(%ebp),%eax
    1c77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1c7d:	8b 45 08             	mov    0x8(%ebp),%eax
    1c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1c87:	8b 45 08             	mov    0x8(%ebp),%eax
    1c8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1c91:	5d                   	pop    %ebp
    1c92:	c3                   	ret    

00001c93 <add_q>:

void add_q(struct queue *q, int v){
    1c93:	55                   	push   %ebp
    1c94:	89 e5                	mov    %esp,%ebp
    1c96:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1c99:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ca0:	e8 a4 fc ff ff       	call   1949 <malloc>
    1ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
    1cb8:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1cba:	8b 45 08             	mov    0x8(%ebp),%eax
    1cbd:	8b 40 04             	mov    0x4(%eax),%eax
    1cc0:	85 c0                	test   %eax,%eax
    1cc2:	75 0b                	jne    1ccf <add_q+0x3c>
        q->head = n;
    1cc4:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1cca:	89 50 04             	mov    %edx,0x4(%eax)
    1ccd:	eb 0c                	jmp    1cdb <add_q+0x48>
    }else{
        q->tail->next = n;
    1ccf:	8b 45 08             	mov    0x8(%ebp),%eax
    1cd2:	8b 40 08             	mov    0x8(%eax),%eax
    1cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1cd8:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1cdb:	8b 45 08             	mov    0x8(%ebp),%eax
    1cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ce1:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1ce4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce7:	8b 00                	mov    (%eax),%eax
    1ce9:	8d 50 01             	lea    0x1(%eax),%edx
    1cec:	8b 45 08             	mov    0x8(%ebp),%eax
    1cef:	89 10                	mov    %edx,(%eax)
}
    1cf1:	c9                   	leave  
    1cf2:	c3                   	ret    

00001cf3 <empty_q>:

int empty_q(struct queue *q){
    1cf3:	55                   	push   %ebp
    1cf4:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1cf6:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf9:	8b 00                	mov    (%eax),%eax
    1cfb:	85 c0                	test   %eax,%eax
    1cfd:	75 07                	jne    1d06 <empty_q+0x13>
        return 1;
    1cff:	b8 01 00 00 00       	mov    $0x1,%eax
    1d04:	eb 05                	jmp    1d0b <empty_q+0x18>
    else
        return 0;
    1d06:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1d0b:	5d                   	pop    %ebp
    1d0c:	c3                   	ret    

00001d0d <pop_q>:
int pop_q(struct queue *q){
    1d0d:	55                   	push   %ebp
    1d0e:	89 e5                	mov    %esp,%ebp
    1d10:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1d13:	8b 45 08             	mov    0x8(%ebp),%eax
    1d16:	89 04 24             	mov    %eax,(%esp)
    1d19:	e8 d5 ff ff ff       	call   1cf3 <empty_q>
    1d1e:	85 c0                	test   %eax,%eax
    1d20:	75 5d                	jne    1d7f <pop_q+0x72>
       val = q->head->value; 
    1d22:	8b 45 08             	mov    0x8(%ebp),%eax
    1d25:	8b 40 04             	mov    0x4(%eax),%eax
    1d28:	8b 00                	mov    (%eax),%eax
    1d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1d2d:	8b 45 08             	mov    0x8(%ebp),%eax
    1d30:	8b 40 04             	mov    0x4(%eax),%eax
    1d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1d36:	8b 45 08             	mov    0x8(%ebp),%eax
    1d39:	8b 40 04             	mov    0x4(%eax),%eax
    1d3c:	8b 50 04             	mov    0x4(%eax),%edx
    1d3f:	8b 45 08             	mov    0x8(%ebp),%eax
    1d42:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d48:	89 04 24             	mov    %eax,(%esp)
    1d4b:	e8 c0 fa ff ff       	call   1810 <free>
       q->size--;
    1d50:	8b 45 08             	mov    0x8(%ebp),%eax
    1d53:	8b 00                	mov    (%eax),%eax
    1d55:	8d 50 ff             	lea    -0x1(%eax),%edx
    1d58:	8b 45 08             	mov    0x8(%ebp),%eax
    1d5b:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1d5d:	8b 45 08             	mov    0x8(%ebp),%eax
    1d60:	8b 00                	mov    (%eax),%eax
    1d62:	85 c0                	test   %eax,%eax
    1d64:	75 14                	jne    1d7a <pop_q+0x6d>
            q->head = 0;
    1d66:	8b 45 08             	mov    0x8(%ebp),%eax
    1d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1d70:	8b 45 08             	mov    0x8(%ebp),%eax
    1d73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d7d:	eb 05                	jmp    1d84 <pop_q+0x77>
    }
    return -1;
    1d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1d84:	c9                   	leave  
    1d85:	c3                   	ret    
