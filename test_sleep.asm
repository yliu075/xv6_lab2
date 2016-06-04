
_test_sleep:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
    int total;
}ttable;

void func(void *arg_ptr);

int main(int argc, char *argv[]){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
    struct thread * t;
    int i;
    printf(1,"init ttable\n");
    1009:	c7 44 24 04 40 1d 00 	movl   $0x1d40,0x4(%esp)
    1010:	00 
    1011:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1018:	e8 df 05 00 00       	call   15fc <printf>
    lock_init(&ttable.lock);
    101d:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    1024:	e8 b9 09 00 00       	call   19e2 <lock_init>
    ttable.total = 0;
    1029:	c7 05 44 23 00 00 00 	movl   $0x0,0x2344
    1030:	00 00 00 

    lock_acquire(&ttable.lock);
    1033:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    103a:	e8 b1 09 00 00       	call   19f0 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
    103f:	c7 44 24 1c 44 22 00 	movl   $0x2244,0x1c(%esp)
    1046:	00 
    1047:	eb 0f                	jmp    1058 <main+0x58>
        t->tid = 0;
    1049:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    104d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    printf(1,"init ttable\n");
    lock_init(&ttable.lock);
    ttable.total = 0;

    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
    1053:	83 44 24 1c 04       	addl   $0x4,0x1c(%esp)
    1058:	81 7c 24 1c 44 23 00 	cmpl   $0x2344,0x1c(%esp)
    105f:	00 
    1060:	72 e7                	jb     1049 <main+0x49>
        t->tid = 0;
    }
    lock_release(&ttable.lock);
    1062:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    1069:	e8 a2 09 00 00       	call   1a10 <lock_release>
    printf(1,"testing thread sleep and wakeup \n\n\n");
    106e:	c7 44 24 04 50 1d 00 	movl   $0x1d50,0x4(%esp)
    1075:	00 
    1076:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    107d:	e8 7a 05 00 00       	call   15fc <printf>
    void *stack = thread_create(func,0);
    1082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1089:	00 
    108a:	c7 04 24 69 11 00 00 	movl   $0x1169,(%esp)
    1091:	e8 95 09 00 00       	call   1a2b <thread_create>
    1096:	89 44 24 14          	mov    %eax,0x14(%esp)
    thread_create(func,0);
    109a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10a1:	00 
    10a2:	c7 04 24 69 11 00 00 	movl   $0x1169,(%esp)
    10a9:	e8 7d 09 00 00       	call   1a2b <thread_create>
    thread_create(func,0);
    10ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10b5:	00 
    10b6:	c7 04 24 69 11 00 00 	movl   $0x1169,(%esp)
    10bd:	e8 69 09 00 00       	call   1a2b <thread_create>

    i=0;
    10c2:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
    10c9:	00 
    while(i++ < 1000000);
    10ca:	90                   	nop
    10cb:	8b 44 24 18          	mov    0x18(%esp),%eax
    10cf:	8d 50 01             	lea    0x1(%eax),%edx
    10d2:	89 54 24 18          	mov    %edx,0x18(%esp)
    10d6:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
    10db:	7e ee                	jle    10cb <main+0xcb>
    //find that thread
    lock_acquire(&ttable.lock);
    10dd:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    10e4:	e8 07 09 00 00       	call   19f0 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
    10e9:	c7 44 24 1c 44 22 00 	movl   $0x2244,0x1c(%esp)
    10f0:	00 
    10f1:	eb 40                	jmp    1133 <main+0x133>
        if(t->tid != 0){
    10f3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10f7:	8b 00                	mov    (%eax),%eax
    10f9:	85 c0                	test   %eax,%eax
    10fb:	74 31                	je     112e <main+0x12e>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
    10fd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1101:	8b 00                	mov    (%eax),%eax
    1103:	89 44 24 08          	mov    %eax,0x8(%esp)
    1107:	c7 44 24 04 74 1d 00 	movl   $0x1d74,0x4(%esp)
    110e:	00 
    110f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1116:	e8 e1 04 00 00       	call   15fc <printf>
            twakeup(t->tid);
    111b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    111f:	8b 00                	mov    (%eax),%eax
    1121:	89 04 24             	mov    %eax,(%esp)
    1124:	e8 db 03 00 00       	call   1504 <twakeup>
            i++;
    1129:	83 44 24 18 01       	addl   $0x1,0x18(%esp)

    i=0;
    while(i++ < 1000000);
    //find that thread
    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
    112e:	83 44 24 1c 04       	addl   $0x4,0x1c(%esp)
    1133:	81 7c 24 1c 44 23 00 	cmpl   $0x2344,0x1c(%esp)
    113a:	00 
    113b:	72 b6                	jb     10f3 <main+0xf3>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
            twakeup(t->tid);
            i++;
        }
    }
    lock_release(&ttable.lock);
    113d:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    1144:	e8 c7 08 00 00       	call   1a10 <lock_release>
    wait();
    1149:	e8 06 03 00 00       	call   1454 <wait>
    wait();
    114e:	e8 01 03 00 00       	call   1454 <wait>
    wait();
    1153:	e8 fc 02 00 00       	call   1454 <wait>
    free(stack);
    1158:	8b 44 24 14          	mov    0x14(%esp),%eax
    115c:	89 04 24             	mov    %eax,(%esp)
    115f:	e8 4b 06 00 00       	call   17af <free>
    exit();
    1164:	e8 e3 02 00 00       	call   144c <exit>

00001169 <func>:
}

void func(void *arg_ptr){
    1169:	55                   	push   %ebp
    116a:	89 e5                	mov    %esp,%ebp
    116c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    tid = getpid();
    116f:	e8 58 03 00 00       	call   14cc <getpid>
    1174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_acquire(&ttable.lock);
    1177:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    117e:	e8 6d 08 00 00       	call   19f0 <lock_acquire>
    (ttable.threads[ttable.total]).tid = tid;
    1183:	a1 44 23 00 00       	mov    0x2344,%eax
    1188:	8b 55 f4             	mov    -0xc(%ebp),%edx
    118b:	89 14 85 44 22 00 00 	mov    %edx,0x2244(,%eax,4)
    ttable.total++;
    1192:	a1 44 23 00 00       	mov    0x2344,%eax
    1197:	83 c0 01             	add    $0x1,%eax
    119a:	a3 44 23 00 00       	mov    %eax,0x2344
    lock_release(&ttable.lock);
    119f:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
    11a6:	e8 65 08 00 00       	call   1a10 <lock_release>

    printf(1,"I am thread %d, is about to sleep\n",tid);
    11ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ae:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b2:	c7 44 24 04 a0 1d 00 	movl   $0x1da0,0x4(%esp)
    11b9:	00 
    11ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c1:	e8 36 04 00 00       	call   15fc <printf>
    tsleep();
    11c6:	e8 31 03 00 00       	call   14fc <tsleep>
    printf(1,"I am wake up!\n");
    11cb:	c7 44 24 04 c3 1d 00 	movl   $0x1dc3,0x4(%esp)
    11d2:	00 
    11d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11da:	e8 1d 04 00 00       	call   15fc <printf>
    texit();
    11df:	e8 10 03 00 00       	call   14f4 <texit>

000011e4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11e4:	55                   	push   %ebp
    11e5:	89 e5                	mov    %esp,%ebp
    11e7:	57                   	push   %edi
    11e8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11ec:	8b 55 10             	mov    0x10(%ebp),%edx
    11ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f2:	89 cb                	mov    %ecx,%ebx
    11f4:	89 df                	mov    %ebx,%edi
    11f6:	89 d1                	mov    %edx,%ecx
    11f8:	fc                   	cld    
    11f9:	f3 aa                	rep stos %al,%es:(%edi)
    11fb:	89 ca                	mov    %ecx,%edx
    11fd:	89 fb                	mov    %edi,%ebx
    11ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1202:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1205:	5b                   	pop    %ebx
    1206:	5f                   	pop    %edi
    1207:	5d                   	pop    %ebp
    1208:	c3                   	ret    

00001209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1209:	55                   	push   %ebp
    120a:	89 e5                	mov    %esp,%ebp
    120c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1215:	90                   	nop
    1216:	8b 45 08             	mov    0x8(%ebp),%eax
    1219:	8d 50 01             	lea    0x1(%eax),%edx
    121c:	89 55 08             	mov    %edx,0x8(%ebp)
    121f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1222:	8d 4a 01             	lea    0x1(%edx),%ecx
    1225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1228:	0f b6 12             	movzbl (%edx),%edx
    122b:	88 10                	mov    %dl,(%eax)
    122d:	0f b6 00             	movzbl (%eax),%eax
    1230:	84 c0                	test   %al,%al
    1232:	75 e2                	jne    1216 <strcpy+0xd>
    ;
  return os;
    1234:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1237:	c9                   	leave  
    1238:	c3                   	ret    

00001239 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1239:	55                   	push   %ebp
    123a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    123c:	eb 08                	jmp    1246 <strcmp+0xd>
    p++, q++;
    123e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
    1249:	0f b6 00             	movzbl (%eax),%eax
    124c:	84 c0                	test   %al,%al
    124e:	74 10                	je     1260 <strcmp+0x27>
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	0f b6 10             	movzbl (%eax),%edx
    1256:	8b 45 0c             	mov    0xc(%ebp),%eax
    1259:	0f b6 00             	movzbl (%eax),%eax
    125c:	38 c2                	cmp    %al,%dl
    125e:	74 de                	je     123e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1260:	8b 45 08             	mov    0x8(%ebp),%eax
    1263:	0f b6 00             	movzbl (%eax),%eax
    1266:	0f b6 d0             	movzbl %al,%edx
    1269:	8b 45 0c             	mov    0xc(%ebp),%eax
    126c:	0f b6 00             	movzbl (%eax),%eax
    126f:	0f b6 c0             	movzbl %al,%eax
    1272:	29 c2                	sub    %eax,%edx
    1274:	89 d0                	mov    %edx,%eax
}
    1276:	5d                   	pop    %ebp
    1277:	c3                   	ret    

00001278 <strlen>:

uint
strlen(char *s)
{
    1278:	55                   	push   %ebp
    1279:	89 e5                	mov    %esp,%ebp
    127b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    127e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1285:	eb 04                	jmp    128b <strlen+0x13>
    1287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    128e:	8b 45 08             	mov    0x8(%ebp),%eax
    1291:	01 d0                	add    %edx,%eax
    1293:	0f b6 00             	movzbl (%eax),%eax
    1296:	84 c0                	test   %al,%al
    1298:	75 ed                	jne    1287 <strlen+0xf>
    ;
  return n;
    129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    129d:	c9                   	leave  
    129e:	c3                   	ret    

0000129f <memset>:

void*
memset(void *dst, int c, uint n)
{
    129f:	55                   	push   %ebp
    12a0:	89 e5                	mov    %esp,%ebp
    12a2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    12a5:	8b 45 10             	mov    0x10(%ebp),%eax
    12a8:	89 44 24 08          	mov    %eax,0x8(%esp)
    12ac:	8b 45 0c             	mov    0xc(%ebp),%eax
    12af:	89 44 24 04          	mov    %eax,0x4(%esp)
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 26 ff ff ff       	call   11e4 <stosb>
  return dst;
    12be:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c1:	c9                   	leave  
    12c2:	c3                   	ret    

000012c3 <strchr>:

char*
strchr(const char *s, char c)
{
    12c3:	55                   	push   %ebp
    12c4:	89 e5                	mov    %esp,%ebp
    12c6:	83 ec 04             	sub    $0x4,%esp
    12c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12cc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12cf:	eb 14                	jmp    12e5 <strchr+0x22>
    if(*s == c)
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	0f b6 00             	movzbl (%eax),%eax
    12d7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12da:	75 05                	jne    12e1 <strchr+0x1e>
      return (char*)s;
    12dc:	8b 45 08             	mov    0x8(%ebp),%eax
    12df:	eb 13                	jmp    12f4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12e5:	8b 45 08             	mov    0x8(%ebp),%eax
    12e8:	0f b6 00             	movzbl (%eax),%eax
    12eb:	84 c0                	test   %al,%al
    12ed:	75 e2                	jne    12d1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12f4:	c9                   	leave  
    12f5:	c3                   	ret    

000012f6 <gets>:

char*
gets(char *buf, int max)
{
    12f6:	55                   	push   %ebp
    12f7:	89 e5                	mov    %esp,%ebp
    12f9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1303:	eb 4c                	jmp    1351 <gets+0x5b>
    cc = read(0, &c, 1);
    1305:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    130c:	00 
    130d:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1310:	89 44 24 04          	mov    %eax,0x4(%esp)
    1314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    131b:	e8 44 01 00 00       	call   1464 <read>
    1320:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1327:	7f 02                	jg     132b <gets+0x35>
      break;
    1329:	eb 31                	jmp    135c <gets+0x66>
    buf[i++] = c;
    132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132e:	8d 50 01             	lea    0x1(%eax),%edx
    1331:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1334:	89 c2                	mov    %eax,%edx
    1336:	8b 45 08             	mov    0x8(%ebp),%eax
    1339:	01 c2                	add    %eax,%edx
    133b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    133f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1345:	3c 0a                	cmp    $0xa,%al
    1347:	74 13                	je     135c <gets+0x66>
    1349:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    134d:	3c 0d                	cmp    $0xd,%al
    134f:	74 0b                	je     135c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1351:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1354:	83 c0 01             	add    $0x1,%eax
    1357:	3b 45 0c             	cmp    0xc(%ebp),%eax
    135a:	7c a9                	jl     1305 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    135c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    135f:	8b 45 08             	mov    0x8(%ebp),%eax
    1362:	01 d0                	add    %edx,%eax
    1364:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1367:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136a:	c9                   	leave  
    136b:	c3                   	ret    

0000136c <stat>:

int
stat(char *n, struct stat *st)
{
    136c:	55                   	push   %ebp
    136d:	89 e5                	mov    %esp,%ebp
    136f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1379:	00 
    137a:	8b 45 08             	mov    0x8(%ebp),%eax
    137d:	89 04 24             	mov    %eax,(%esp)
    1380:	e8 07 01 00 00       	call   148c <open>
    1385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    138c:	79 07                	jns    1395 <stat+0x29>
    return -1;
    138e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1393:	eb 23                	jmp    13b8 <stat+0x4c>
  r = fstat(fd, st);
    1395:	8b 45 0c             	mov    0xc(%ebp),%eax
    1398:	89 44 24 04          	mov    %eax,0x4(%esp)
    139c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139f:	89 04 24             	mov    %eax,(%esp)
    13a2:	e8 fd 00 00 00       	call   14a4 <fstat>
    13a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    13aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ad:	89 04 24             	mov    %eax,(%esp)
    13b0:	e8 bf 00 00 00       	call   1474 <close>
  return r;
    13b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13b8:	c9                   	leave  
    13b9:	c3                   	ret    

000013ba <atoi>:

int
atoi(const char *s)
{
    13ba:	55                   	push   %ebp
    13bb:	89 e5                	mov    %esp,%ebp
    13bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    13c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13c7:	eb 25                	jmp    13ee <atoi+0x34>
    n = n*10 + *s++ - '0';
    13c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13cc:	89 d0                	mov    %edx,%eax
    13ce:	c1 e0 02             	shl    $0x2,%eax
    13d1:	01 d0                	add    %edx,%eax
    13d3:	01 c0                	add    %eax,%eax
    13d5:	89 c1                	mov    %eax,%ecx
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	8d 50 01             	lea    0x1(%eax),%edx
    13dd:	89 55 08             	mov    %edx,0x8(%ebp)
    13e0:	0f b6 00             	movzbl (%eax),%eax
    13e3:	0f be c0             	movsbl %al,%eax
    13e6:	01 c8                	add    %ecx,%eax
    13e8:	83 e8 30             	sub    $0x30,%eax
    13eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13ee:	8b 45 08             	mov    0x8(%ebp),%eax
    13f1:	0f b6 00             	movzbl (%eax),%eax
    13f4:	3c 2f                	cmp    $0x2f,%al
    13f6:	7e 0a                	jle    1402 <atoi+0x48>
    13f8:	8b 45 08             	mov    0x8(%ebp),%eax
    13fb:	0f b6 00             	movzbl (%eax),%eax
    13fe:	3c 39                	cmp    $0x39,%al
    1400:	7e c7                	jle    13c9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1402:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1405:	c9                   	leave  
    1406:	c3                   	ret    

00001407 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1407:	55                   	push   %ebp
    1408:	89 e5                	mov    %esp,%ebp
    140a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    140d:	8b 45 08             	mov    0x8(%ebp),%eax
    1410:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1413:	8b 45 0c             	mov    0xc(%ebp),%eax
    1416:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1419:	eb 17                	jmp    1432 <memmove+0x2b>
    *dst++ = *src++;
    141b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    141e:	8d 50 01             	lea    0x1(%eax),%edx
    1421:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1424:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1427:	8d 4a 01             	lea    0x1(%edx),%ecx
    142a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    142d:	0f b6 12             	movzbl (%edx),%edx
    1430:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1432:	8b 45 10             	mov    0x10(%ebp),%eax
    1435:	8d 50 ff             	lea    -0x1(%eax),%edx
    1438:	89 55 10             	mov    %edx,0x10(%ebp)
    143b:	85 c0                	test   %eax,%eax
    143d:	7f dc                	jg     141b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    143f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1442:	c9                   	leave  
    1443:	c3                   	ret    

00001444 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1444:	b8 01 00 00 00       	mov    $0x1,%eax
    1449:	cd 40                	int    $0x40
    144b:	c3                   	ret    

0000144c <exit>:
SYSCALL(exit)
    144c:	b8 02 00 00 00       	mov    $0x2,%eax
    1451:	cd 40                	int    $0x40
    1453:	c3                   	ret    

00001454 <wait>:
SYSCALL(wait)
    1454:	b8 03 00 00 00       	mov    $0x3,%eax
    1459:	cd 40                	int    $0x40
    145b:	c3                   	ret    

0000145c <pipe>:
SYSCALL(pipe)
    145c:	b8 04 00 00 00       	mov    $0x4,%eax
    1461:	cd 40                	int    $0x40
    1463:	c3                   	ret    

00001464 <read>:
SYSCALL(read)
    1464:	b8 05 00 00 00       	mov    $0x5,%eax
    1469:	cd 40                	int    $0x40
    146b:	c3                   	ret    

0000146c <write>:
SYSCALL(write)
    146c:	b8 10 00 00 00       	mov    $0x10,%eax
    1471:	cd 40                	int    $0x40
    1473:	c3                   	ret    

00001474 <close>:
SYSCALL(close)
    1474:	b8 15 00 00 00       	mov    $0x15,%eax
    1479:	cd 40                	int    $0x40
    147b:	c3                   	ret    

0000147c <kill>:
SYSCALL(kill)
    147c:	b8 06 00 00 00       	mov    $0x6,%eax
    1481:	cd 40                	int    $0x40
    1483:	c3                   	ret    

00001484 <exec>:
SYSCALL(exec)
    1484:	b8 07 00 00 00       	mov    $0x7,%eax
    1489:	cd 40                	int    $0x40
    148b:	c3                   	ret    

0000148c <open>:
SYSCALL(open)
    148c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1491:	cd 40                	int    $0x40
    1493:	c3                   	ret    

00001494 <mknod>:
SYSCALL(mknod)
    1494:	b8 11 00 00 00       	mov    $0x11,%eax
    1499:	cd 40                	int    $0x40
    149b:	c3                   	ret    

0000149c <unlink>:
SYSCALL(unlink)
    149c:	b8 12 00 00 00       	mov    $0x12,%eax
    14a1:	cd 40                	int    $0x40
    14a3:	c3                   	ret    

000014a4 <fstat>:
SYSCALL(fstat)
    14a4:	b8 08 00 00 00       	mov    $0x8,%eax
    14a9:	cd 40                	int    $0x40
    14ab:	c3                   	ret    

000014ac <link>:
SYSCALL(link)
    14ac:	b8 13 00 00 00       	mov    $0x13,%eax
    14b1:	cd 40                	int    $0x40
    14b3:	c3                   	ret    

000014b4 <mkdir>:
SYSCALL(mkdir)
    14b4:	b8 14 00 00 00       	mov    $0x14,%eax
    14b9:	cd 40                	int    $0x40
    14bb:	c3                   	ret    

000014bc <chdir>:
SYSCALL(chdir)
    14bc:	b8 09 00 00 00       	mov    $0x9,%eax
    14c1:	cd 40                	int    $0x40
    14c3:	c3                   	ret    

000014c4 <dup>:
SYSCALL(dup)
    14c4:	b8 0a 00 00 00       	mov    $0xa,%eax
    14c9:	cd 40                	int    $0x40
    14cb:	c3                   	ret    

000014cc <getpid>:
SYSCALL(getpid)
    14cc:	b8 0b 00 00 00       	mov    $0xb,%eax
    14d1:	cd 40                	int    $0x40
    14d3:	c3                   	ret    

000014d4 <sbrk>:
SYSCALL(sbrk)
    14d4:	b8 0c 00 00 00       	mov    $0xc,%eax
    14d9:	cd 40                	int    $0x40
    14db:	c3                   	ret    

000014dc <sleep>:
SYSCALL(sleep)
    14dc:	b8 0d 00 00 00       	mov    $0xd,%eax
    14e1:	cd 40                	int    $0x40
    14e3:	c3                   	ret    

000014e4 <uptime>:
SYSCALL(uptime)
    14e4:	b8 0e 00 00 00       	mov    $0xe,%eax
    14e9:	cd 40                	int    $0x40
    14eb:	c3                   	ret    

000014ec <clone>:
SYSCALL(clone)
    14ec:	b8 16 00 00 00       	mov    $0x16,%eax
    14f1:	cd 40                	int    $0x40
    14f3:	c3                   	ret    

000014f4 <texit>:
SYSCALL(texit)
    14f4:	b8 17 00 00 00       	mov    $0x17,%eax
    14f9:	cd 40                	int    $0x40
    14fb:	c3                   	ret    

000014fc <tsleep>:
SYSCALL(tsleep)
    14fc:	b8 18 00 00 00       	mov    $0x18,%eax
    1501:	cd 40                	int    $0x40
    1503:	c3                   	ret    

00001504 <twakeup>:
SYSCALL(twakeup)
    1504:	b8 19 00 00 00       	mov    $0x19,%eax
    1509:	cd 40                	int    $0x40
    150b:	c3                   	ret    

0000150c <thread_yield>:
SYSCALL(thread_yield)
    150c:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1511:	cd 40                	int    $0x40
    1513:	c3                   	ret    

00001514 <thread_yield3>:
    1514:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1519:	cd 40                	int    $0x40
    151b:	c3                   	ret    

0000151c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    151c:	55                   	push   %ebp
    151d:	89 e5                	mov    %esp,%ebp
    151f:	83 ec 18             	sub    $0x18,%esp
    1522:	8b 45 0c             	mov    0xc(%ebp),%eax
    1525:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1528:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    152f:	00 
    1530:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1533:	89 44 24 04          	mov    %eax,0x4(%esp)
    1537:	8b 45 08             	mov    0x8(%ebp),%eax
    153a:	89 04 24             	mov    %eax,(%esp)
    153d:	e8 2a ff ff ff       	call   146c <write>
}
    1542:	c9                   	leave  
    1543:	c3                   	ret    

00001544 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1544:	55                   	push   %ebp
    1545:	89 e5                	mov    %esp,%ebp
    1547:	56                   	push   %esi
    1548:	53                   	push   %ebx
    1549:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    154c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1553:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1557:	74 17                	je     1570 <printint+0x2c>
    1559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    155d:	79 11                	jns    1570 <printint+0x2c>
    neg = 1;
    155f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1566:	8b 45 0c             	mov    0xc(%ebp),%eax
    1569:	f7 d8                	neg    %eax
    156b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    156e:	eb 06                	jmp    1576 <printint+0x32>
  } else {
    x = xx;
    1570:	8b 45 0c             	mov    0xc(%ebp),%eax
    1573:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    157d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1580:	8d 41 01             	lea    0x1(%ecx),%eax
    1583:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1586:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1589:	8b 45 ec             	mov    -0x14(%ebp),%eax
    158c:	ba 00 00 00 00       	mov    $0x0,%edx
    1591:	f7 f3                	div    %ebx
    1593:	89 d0                	mov    %edx,%eax
    1595:	0f b6 80 00 22 00 00 	movzbl 0x2200(%eax),%eax
    159c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    15a0:	8b 75 10             	mov    0x10(%ebp),%esi
    15a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15a6:	ba 00 00 00 00       	mov    $0x0,%edx
    15ab:	f7 f6                	div    %esi
    15ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15b4:	75 c7                	jne    157d <printint+0x39>
  if(neg)
    15b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15ba:	74 10                	je     15cc <printint+0x88>
    buf[i++] = '-';
    15bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15bf:	8d 50 01             	lea    0x1(%eax),%edx
    15c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15c5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    15ca:	eb 1f                	jmp    15eb <printint+0xa7>
    15cc:	eb 1d                	jmp    15eb <printint+0xa7>
    putc(fd, buf[i]);
    15ce:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d4:	01 d0                	add    %edx,%eax
    15d6:	0f b6 00             	movzbl (%eax),%eax
    15d9:	0f be c0             	movsbl %al,%eax
    15dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e0:	8b 45 08             	mov    0x8(%ebp),%eax
    15e3:	89 04 24             	mov    %eax,(%esp)
    15e6:	e8 31 ff ff ff       	call   151c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15eb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15f3:	79 d9                	jns    15ce <printint+0x8a>
    putc(fd, buf[i]);
}
    15f5:	83 c4 30             	add    $0x30,%esp
    15f8:	5b                   	pop    %ebx
    15f9:	5e                   	pop    %esi
    15fa:	5d                   	pop    %ebp
    15fb:	c3                   	ret    

000015fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15fc:	55                   	push   %ebp
    15fd:	89 e5                	mov    %esp,%ebp
    15ff:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1602:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1609:	8d 45 0c             	lea    0xc(%ebp),%eax
    160c:	83 c0 04             	add    $0x4,%eax
    160f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1612:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1619:	e9 7c 01 00 00       	jmp    179a <printf+0x19e>
    c = fmt[i] & 0xff;
    161e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1621:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1624:	01 d0                	add    %edx,%eax
    1626:	0f b6 00             	movzbl (%eax),%eax
    1629:	0f be c0             	movsbl %al,%eax
    162c:	25 ff 00 00 00       	and    $0xff,%eax
    1631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1634:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1638:	75 2c                	jne    1666 <printf+0x6a>
      if(c == '%'){
    163a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    163e:	75 0c                	jne    164c <printf+0x50>
        state = '%';
    1640:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1647:	e9 4a 01 00 00       	jmp    1796 <printf+0x19a>
      } else {
        putc(fd, c);
    164c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    164f:	0f be c0             	movsbl %al,%eax
    1652:	89 44 24 04          	mov    %eax,0x4(%esp)
    1656:	8b 45 08             	mov    0x8(%ebp),%eax
    1659:	89 04 24             	mov    %eax,(%esp)
    165c:	e8 bb fe ff ff       	call   151c <putc>
    1661:	e9 30 01 00 00       	jmp    1796 <printf+0x19a>
      }
    } else if(state == '%'){
    1666:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    166a:	0f 85 26 01 00 00    	jne    1796 <printf+0x19a>
      if(c == 'd'){
    1670:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1674:	75 2d                	jne    16a3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1676:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1679:	8b 00                	mov    (%eax),%eax
    167b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1682:	00 
    1683:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    168a:	00 
    168b:	89 44 24 04          	mov    %eax,0x4(%esp)
    168f:	8b 45 08             	mov    0x8(%ebp),%eax
    1692:	89 04 24             	mov    %eax,(%esp)
    1695:	e8 aa fe ff ff       	call   1544 <printint>
        ap++;
    169a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    169e:	e9 ec 00 00 00       	jmp    178f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    16a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    16a7:	74 06                	je     16af <printf+0xb3>
    16a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    16ad:	75 2d                	jne    16dc <printf+0xe0>
        printint(fd, *ap, 16, 0);
    16af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b2:	8b 00                	mov    (%eax),%eax
    16b4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    16bb:	00 
    16bc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    16c3:	00 
    16c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    16c8:	8b 45 08             	mov    0x8(%ebp),%eax
    16cb:	89 04 24             	mov    %eax,(%esp)
    16ce:	e8 71 fe ff ff       	call   1544 <printint>
        ap++;
    16d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16d7:	e9 b3 00 00 00       	jmp    178f <printf+0x193>
      } else if(c == 's'){
    16dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16e0:	75 45                	jne    1727 <printf+0x12b>
        s = (char*)*ap;
    16e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16e5:	8b 00                	mov    (%eax),%eax
    16e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16f2:	75 09                	jne    16fd <printf+0x101>
          s = "(null)";
    16f4:	c7 45 f4 d2 1d 00 00 	movl   $0x1dd2,-0xc(%ebp)
        while(*s != 0){
    16fb:	eb 1e                	jmp    171b <printf+0x11f>
    16fd:	eb 1c                	jmp    171b <printf+0x11f>
          putc(fd, *s);
    16ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1702:	0f b6 00             	movzbl (%eax),%eax
    1705:	0f be c0             	movsbl %al,%eax
    1708:	89 44 24 04          	mov    %eax,0x4(%esp)
    170c:	8b 45 08             	mov    0x8(%ebp),%eax
    170f:	89 04 24             	mov    %eax,(%esp)
    1712:	e8 05 fe ff ff       	call   151c <putc>
          s++;
    1717:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171e:	0f b6 00             	movzbl (%eax),%eax
    1721:	84 c0                	test   %al,%al
    1723:	75 da                	jne    16ff <printf+0x103>
    1725:	eb 68                	jmp    178f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1727:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    172b:	75 1d                	jne    174a <printf+0x14e>
        putc(fd, *ap);
    172d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1730:	8b 00                	mov    (%eax),%eax
    1732:	0f be c0             	movsbl %al,%eax
    1735:	89 44 24 04          	mov    %eax,0x4(%esp)
    1739:	8b 45 08             	mov    0x8(%ebp),%eax
    173c:	89 04 24             	mov    %eax,(%esp)
    173f:	e8 d8 fd ff ff       	call   151c <putc>
        ap++;
    1744:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1748:	eb 45                	jmp    178f <printf+0x193>
      } else if(c == '%'){
    174a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    174e:	75 17                	jne    1767 <printf+0x16b>
        putc(fd, c);
    1750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1753:	0f be c0             	movsbl %al,%eax
    1756:	89 44 24 04          	mov    %eax,0x4(%esp)
    175a:	8b 45 08             	mov    0x8(%ebp),%eax
    175d:	89 04 24             	mov    %eax,(%esp)
    1760:	e8 b7 fd ff ff       	call   151c <putc>
    1765:	eb 28                	jmp    178f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1767:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    176e:	00 
    176f:	8b 45 08             	mov    0x8(%ebp),%eax
    1772:	89 04 24             	mov    %eax,(%esp)
    1775:	e8 a2 fd ff ff       	call   151c <putc>
        putc(fd, c);
    177a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    177d:	0f be c0             	movsbl %al,%eax
    1780:	89 44 24 04          	mov    %eax,0x4(%esp)
    1784:	8b 45 08             	mov    0x8(%ebp),%eax
    1787:	89 04 24             	mov    %eax,(%esp)
    178a:	e8 8d fd ff ff       	call   151c <putc>
      }
      state = 0;
    178f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1796:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    179a:	8b 55 0c             	mov    0xc(%ebp),%edx
    179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a0:	01 d0                	add    %edx,%eax
    17a2:	0f b6 00             	movzbl (%eax),%eax
    17a5:	84 c0                	test   %al,%al
    17a7:	0f 85 71 fe ff ff    	jne    161e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    17ad:	c9                   	leave  
    17ae:	c3                   	ret    

000017af <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17af:	55                   	push   %ebp
    17b0:	89 e5                	mov    %esp,%ebp
    17b2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17b5:	8b 45 08             	mov    0x8(%ebp),%eax
    17b8:	83 e8 08             	sub    $0x8,%eax
    17bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17be:	a1 28 22 00 00       	mov    0x2228,%eax
    17c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17c6:	eb 24                	jmp    17ec <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cb:	8b 00                	mov    (%eax),%eax
    17cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17d0:	77 12                	ja     17e4 <free+0x35>
    17d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17d8:	77 24                	ja     17fe <free+0x4f>
    17da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dd:	8b 00                	mov    (%eax),%eax
    17df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17e2:	77 1a                	ja     17fe <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e7:	8b 00                	mov    (%eax),%eax
    17e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17f2:	76 d4                	jbe    17c8 <free+0x19>
    17f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f7:	8b 00                	mov    (%eax),%eax
    17f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17fc:	76 ca                	jbe    17c8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1801:	8b 40 04             	mov    0x4(%eax),%eax
    1804:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    180e:	01 c2                	add    %eax,%edx
    1810:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1813:	8b 00                	mov    (%eax),%eax
    1815:	39 c2                	cmp    %eax,%edx
    1817:	75 24                	jne    183d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1819:	8b 45 f8             	mov    -0x8(%ebp),%eax
    181c:	8b 50 04             	mov    0x4(%eax),%edx
    181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1822:	8b 00                	mov    (%eax),%eax
    1824:	8b 40 04             	mov    0x4(%eax),%eax
    1827:	01 c2                	add    %eax,%edx
    1829:	8b 45 f8             	mov    -0x8(%ebp),%eax
    182c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1832:	8b 00                	mov    (%eax),%eax
    1834:	8b 10                	mov    (%eax),%edx
    1836:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1839:	89 10                	mov    %edx,(%eax)
    183b:	eb 0a                	jmp    1847 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1840:	8b 10                	mov    (%eax),%edx
    1842:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1845:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1847:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184a:	8b 40 04             	mov    0x4(%eax),%eax
    184d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1854:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1857:	01 d0                	add    %edx,%eax
    1859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    185c:	75 20                	jne    187e <free+0xcf>
    p->s.size += bp->s.size;
    185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1861:	8b 50 04             	mov    0x4(%eax),%edx
    1864:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1867:	8b 40 04             	mov    0x4(%eax),%eax
    186a:	01 c2                	add    %eax,%edx
    186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    186f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1872:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1875:	8b 10                	mov    (%eax),%edx
    1877:	8b 45 fc             	mov    -0x4(%ebp),%eax
    187a:	89 10                	mov    %edx,(%eax)
    187c:	eb 08                	jmp    1886 <free+0xd7>
  } else
    p->s.ptr = bp;
    187e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1881:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1884:	89 10                	mov    %edx,(%eax)
  freep = p;
    1886:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1889:	a3 28 22 00 00       	mov    %eax,0x2228
}
    188e:	c9                   	leave  
    188f:	c3                   	ret    

00001890 <morecore>:

static Header*
morecore(uint nu)
{
    1890:	55                   	push   %ebp
    1891:	89 e5                	mov    %esp,%ebp
    1893:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1896:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    189d:	77 07                	ja     18a6 <morecore+0x16>
    nu = 4096;
    189f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    18a6:	8b 45 08             	mov    0x8(%ebp),%eax
    18a9:	c1 e0 03             	shl    $0x3,%eax
    18ac:	89 04 24             	mov    %eax,(%esp)
    18af:	e8 20 fc ff ff       	call   14d4 <sbrk>
    18b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    18b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    18bb:	75 07                	jne    18c4 <morecore+0x34>
    return 0;
    18bd:	b8 00 00 00 00       	mov    $0x0,%eax
    18c2:	eb 22                	jmp    18e6 <morecore+0x56>
  hp = (Header*)p;
    18c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    18ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18cd:	8b 55 08             	mov    0x8(%ebp),%edx
    18d0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18d6:	83 c0 08             	add    $0x8,%eax
    18d9:	89 04 24             	mov    %eax,(%esp)
    18dc:	e8 ce fe ff ff       	call   17af <free>
  return freep;
    18e1:	a1 28 22 00 00       	mov    0x2228,%eax
}
    18e6:	c9                   	leave  
    18e7:	c3                   	ret    

000018e8 <malloc>:

void*
malloc(uint nbytes)
{
    18e8:	55                   	push   %ebp
    18e9:	89 e5                	mov    %esp,%ebp
    18eb:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18ee:	8b 45 08             	mov    0x8(%ebp),%eax
    18f1:	83 c0 07             	add    $0x7,%eax
    18f4:	c1 e8 03             	shr    $0x3,%eax
    18f7:	83 c0 01             	add    $0x1,%eax
    18fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18fd:	a1 28 22 00 00       	mov    0x2228,%eax
    1902:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1909:	75 23                	jne    192e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    190b:	c7 45 f0 20 22 00 00 	movl   $0x2220,-0x10(%ebp)
    1912:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1915:	a3 28 22 00 00       	mov    %eax,0x2228
    191a:	a1 28 22 00 00       	mov    0x2228,%eax
    191f:	a3 20 22 00 00       	mov    %eax,0x2220
    base.s.size = 0;
    1924:	c7 05 24 22 00 00 00 	movl   $0x0,0x2224
    192b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1931:	8b 00                	mov    (%eax),%eax
    1933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1936:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1939:	8b 40 04             	mov    0x4(%eax),%eax
    193c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    193f:	72 4d                	jb     198e <malloc+0xa6>
      if(p->s.size == nunits)
    1941:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1944:	8b 40 04             	mov    0x4(%eax),%eax
    1947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    194a:	75 0c                	jne    1958 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194f:	8b 10                	mov    (%eax),%edx
    1951:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1954:	89 10                	mov    %edx,(%eax)
    1956:	eb 26                	jmp    197e <malloc+0x96>
      else {
        p->s.size -= nunits;
    1958:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195b:	8b 40 04             	mov    0x4(%eax),%eax
    195e:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1961:	89 c2                	mov    %eax,%edx
    1963:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1966:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1969:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196c:	8b 40 04             	mov    0x4(%eax),%eax
    196f:	c1 e0 03             	shl    $0x3,%eax
    1972:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1975:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1978:	8b 55 ec             	mov    -0x14(%ebp),%edx
    197b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1981:	a3 28 22 00 00       	mov    %eax,0x2228
      return (void*)(p + 1);
    1986:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1989:	83 c0 08             	add    $0x8,%eax
    198c:	eb 38                	jmp    19c6 <malloc+0xde>
    }
    if(p == freep)
    198e:	a1 28 22 00 00       	mov    0x2228,%eax
    1993:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1996:	75 1b                	jne    19b3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1998:	8b 45 ec             	mov    -0x14(%ebp),%eax
    199b:	89 04 24             	mov    %eax,(%esp)
    199e:	e8 ed fe ff ff       	call   1890 <morecore>
    19a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    19a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19aa:	75 07                	jne    19b3 <malloc+0xcb>
        return 0;
    19ac:	b8 00 00 00 00       	mov    $0x0,%eax
    19b1:	eb 13                	jmp    19c6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19bc:	8b 00                	mov    (%eax),%eax
    19be:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    19c1:	e9 70 ff ff ff       	jmp    1936 <malloc+0x4e>
}
    19c6:	c9                   	leave  
    19c7:	c3                   	ret    

000019c8 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    19c8:	55                   	push   %ebp
    19c9:	89 e5                	mov    %esp,%ebp
    19cb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    19ce:	8b 55 08             	mov    0x8(%ebp),%edx
    19d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    19d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19d7:	f0 87 02             	lock xchg %eax,(%edx)
    19da:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    19dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    19e0:	c9                   	leave  
    19e1:	c3                   	ret    

000019e2 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    19e2:	55                   	push   %ebp
    19e3:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    19e5:	8b 45 08             	mov    0x8(%ebp),%eax
    19e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    19ee:	5d                   	pop    %ebp
    19ef:	c3                   	ret    

000019f0 <lock_acquire>:
void lock_acquire(lock_t *lock){
    19f0:	55                   	push   %ebp
    19f1:	89 e5                	mov    %esp,%ebp
    19f3:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    19f6:	90                   	nop
    19f7:	8b 45 08             	mov    0x8(%ebp),%eax
    19fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1a01:	00 
    1a02:	89 04 24             	mov    %eax,(%esp)
    1a05:	e8 be ff ff ff       	call   19c8 <xchg>
    1a0a:	85 c0                	test   %eax,%eax
    1a0c:	75 e9                	jne    19f7 <lock_acquire+0x7>
}
    1a0e:	c9                   	leave  
    1a0f:	c3                   	ret    

00001a10 <lock_release>:
void lock_release(lock_t *lock){
    1a10:	55                   	push   %ebp
    1a11:	89 e5                	mov    %esp,%ebp
    1a13:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1a16:	8b 45 08             	mov    0x8(%ebp),%eax
    1a19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a20:	00 
    1a21:	89 04 24             	mov    %eax,(%esp)
    1a24:	e8 9f ff ff ff       	call   19c8 <xchg>
}
    1a29:	c9                   	leave  
    1a2a:	c3                   	ret    

00001a2b <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1a2b:	55                   	push   %ebp
    1a2c:	89 e5                	mov    %esp,%ebp
    1a2e:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1a31:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1a38:	e8 ab fe ff ff       	call   18e8 <malloc>
    1a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1a46:	0f b6 05 2c 22 00 00 	movzbl 0x222c,%eax
    1a4d:	84 c0                	test   %al,%al
    1a4f:	75 1c                	jne    1a6d <thread_create+0x42>
        init_q(thQ2);
    1a51:	a1 48 23 00 00       	mov    0x2348,%eax
    1a56:	89 04 24             	mov    %eax,(%esp)
    1a59:	e8 cd 01 00 00       	call   1c2b <init_q>
        inQ++;
    1a5e:	0f b6 05 2c 22 00 00 	movzbl 0x222c,%eax
    1a65:	83 c0 01             	add    $0x1,%eax
    1a68:	a2 2c 22 00 00       	mov    %al,0x222c
    }

    if((uint)stack % 4096){
    1a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a70:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a75:	85 c0                	test   %eax,%eax
    1a77:	74 14                	je     1a8d <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7c:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a81:	89 c2                	mov    %eax,%edx
    1a83:	b8 00 10 00 00       	mov    $0x1000,%eax
    1a88:	29 d0                	sub    %edx,%eax
    1a8a:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a91:	75 1e                	jne    1ab1 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1a93:	c7 44 24 04 d9 1d 00 	movl   $0x1dd9,0x4(%esp)
    1a9a:	00 
    1a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aa2:	e8 55 fb ff ff       	call   15fc <printf>
        return 0;
    1aa7:	b8 00 00 00 00       	mov    $0x0,%eax
    1aac:	e9 9e 00 00 00       	jmp    1b4f <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1ab1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1ab4:	8b 55 08             	mov    0x8(%ebp),%edx
    1ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aba:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1abe:	89 54 24 08          	mov    %edx,0x8(%esp)
    1ac2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1ac9:	00 
    1aca:	89 04 24             	mov    %eax,(%esp)
    1acd:	e8 1a fa ff ff       	call   14ec <clone>
    1ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
    1adc:	c7 44 24 04 e7 1d 00 	movl   $0x1de7,0x4(%esp)
    1ae3:	00 
    1ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aeb:	e8 0c fb ff ff       	call   15fc <printf>
    if(tid < 0){
    1af0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1af4:	79 1b                	jns    1b11 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1af6:	c7 44 24 04 00 1e 00 	movl   $0x1e00,0x4(%esp)
    1afd:	00 
    1afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b05:	e8 f2 fa ff ff       	call   15fc <printf>
        return 0;
    1b0a:	b8 00 00 00 00       	mov    $0x0,%eax
    1b0f:	eb 3e                	jmp    1b4f <thread_create+0x124>
    }
    if(tid > 0){
    1b11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b15:	7e 19                	jle    1b30 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1b17:	a1 48 23 00 00       	mov    0x2348,%eax
    1b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b1f:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b23:	89 04 24             	mov    %eax,(%esp)
    1b26:	e8 22 01 00 00       	call   1c4d <add_q>
        return garbage_stack;
    1b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b2e:	eb 1f                	jmp    1b4f <thread_create+0x124>
    }
    if(tid == 0){
    1b30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b34:	75 14                	jne    1b4a <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1b36:	c7 44 24 04 0d 1e 00 	movl   $0x1e0d,0x4(%esp)
    1b3d:	00 
    1b3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b45:	e8 b2 fa ff ff       	call   15fc <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1b4f:	c9                   	leave  
    1b50:	c3                   	ret    

00001b51 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1b51:	55                   	push   %ebp
    1b52:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1b54:	a1 14 22 00 00       	mov    0x2214,%eax
    1b59:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1b5f:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1b64:	a3 14 22 00 00       	mov    %eax,0x2214
    return (int)(rands % max);
    1b69:	a1 14 22 00 00       	mov    0x2214,%eax
    1b6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b71:	ba 00 00 00 00       	mov    $0x0,%edx
    1b76:	f7 f1                	div    %ecx
    1b78:	89 d0                	mov    %edx,%eax
}
    1b7a:	5d                   	pop    %ebp
    1b7b:	c3                   	ret    

00001b7c <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1b7c:	55                   	push   %ebp
    1b7d:	89 e5                	mov    %esp,%ebp
    1b7f:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1b82:	e8 45 f9 ff ff       	call   14cc <getpid>
    1b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1b8a:	a1 48 23 00 00       	mov    0x2348,%eax
    1b8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1b92:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b96:	89 04 24             	mov    %eax,(%esp)
    1b99:	e8 af 00 00 00       	call   1c4d <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1b9e:	a1 48 23 00 00       	mov    0x2348,%eax
    1ba3:	89 04 24             	mov    %eax,(%esp)
    1ba6:	e8 1c 01 00 00       	call   1cc7 <pop_q>
    1bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1bae:	a1 30 22 00 00       	mov    0x2230,%eax
    1bb3:	85 c0                	test   %eax,%eax
    1bb5:	75 1f                	jne    1bd6 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1bb7:	a1 48 23 00 00       	mov    0x2348,%eax
    1bbc:	89 04 24             	mov    %eax,(%esp)
    1bbf:	e8 03 01 00 00       	call   1cc7 <pop_q>
    1bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1bc7:	a1 30 22 00 00       	mov    0x2230,%eax
    1bcc:	83 c0 01             	add    $0x1,%eax
    1bcf:	a3 30 22 00 00       	mov    %eax,0x2230
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1bd4:	eb 12                	jmp    1be8 <thread_yield2+0x6c>
    1bd6:	eb 10                	jmp    1be8 <thread_yield2+0x6c>
    1bd8:	a1 48 23 00 00       	mov    0x2348,%eax
    1bdd:	89 04 24             	mov    %eax,(%esp)
    1be0:	e8 e2 00 00 00       	call   1cc7 <pop_q>
    1be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1beb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1bee:	74 e8                	je     1bd8 <thread_yield2+0x5c>
    1bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bf4:	74 e2                	je     1bd8 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bf9:	89 04 24             	mov    %eax,(%esp)
    1bfc:	e8 03 f9 ff ff       	call   1504 <twakeup>
    tsleep();
    1c01:	e8 f6 f8 ff ff       	call   14fc <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1c06:	c9                   	leave  
    1c07:	c3                   	ret    

00001c08 <thread_yield_last>:

void thread_yield_last(){
    1c08:	55                   	push   %ebp
    1c09:	89 e5                	mov    %esp,%ebp
    1c0b:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1c0e:	a1 48 23 00 00       	mov    0x2348,%eax
    1c13:	89 04 24             	mov    %eax,(%esp)
    1c16:	e8 ac 00 00 00       	call   1cc7 <pop_q>
    1c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c21:	89 04 24             	mov    %eax,(%esp)
    1c24:	e8 db f8 ff ff       	call   1504 <twakeup>
    1c29:	c9                   	leave  
    1c2a:	c3                   	ret    

00001c2b <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1c2b:	55                   	push   %ebp
    1c2c:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1c2e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1c37:	8b 45 08             	mov    0x8(%ebp),%eax
    1c3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1c41:	8b 45 08             	mov    0x8(%ebp),%eax
    1c44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1c4b:	5d                   	pop    %ebp
    1c4c:	c3                   	ret    

00001c4d <add_q>:

void add_q(struct queue *q, int v){
    1c4d:	55                   	push   %ebp
    1c4e:	89 e5                	mov    %esp,%ebp
    1c50:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1c53:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1c5a:	e8 89 fc ff ff       	call   18e8 <malloc>
    1c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c72:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1c74:	8b 45 08             	mov    0x8(%ebp),%eax
    1c77:	8b 40 04             	mov    0x4(%eax),%eax
    1c7a:	85 c0                	test   %eax,%eax
    1c7c:	75 0b                	jne    1c89 <add_q+0x3c>
        q->head = n;
    1c7e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c84:	89 50 04             	mov    %edx,0x4(%eax)
    1c87:	eb 0c                	jmp    1c95 <add_q+0x48>
    }else{
        q->tail->next = n;
    1c89:	8b 45 08             	mov    0x8(%ebp),%eax
    1c8c:	8b 40 08             	mov    0x8(%eax),%eax
    1c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c92:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1c95:	8b 45 08             	mov    0x8(%ebp),%eax
    1c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c9b:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1c9e:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca1:	8b 00                	mov    (%eax),%eax
    1ca3:	8d 50 01             	lea    0x1(%eax),%edx
    1ca6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca9:	89 10                	mov    %edx,(%eax)
}
    1cab:	c9                   	leave  
    1cac:	c3                   	ret    

00001cad <empty_q>:

int empty_q(struct queue *q){
    1cad:	55                   	push   %ebp
    1cae:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1cb0:	8b 45 08             	mov    0x8(%ebp),%eax
    1cb3:	8b 00                	mov    (%eax),%eax
    1cb5:	85 c0                	test   %eax,%eax
    1cb7:	75 07                	jne    1cc0 <empty_q+0x13>
        return 1;
    1cb9:	b8 01 00 00 00       	mov    $0x1,%eax
    1cbe:	eb 05                	jmp    1cc5 <empty_q+0x18>
    else
        return 0;
    1cc0:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1cc5:	5d                   	pop    %ebp
    1cc6:	c3                   	ret    

00001cc7 <pop_q>:
int pop_q(struct queue *q){
    1cc7:	55                   	push   %ebp
    1cc8:	89 e5                	mov    %esp,%ebp
    1cca:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1ccd:	8b 45 08             	mov    0x8(%ebp),%eax
    1cd0:	89 04 24             	mov    %eax,(%esp)
    1cd3:	e8 d5 ff ff ff       	call   1cad <empty_q>
    1cd8:	85 c0                	test   %eax,%eax
    1cda:	75 5d                	jne    1d39 <pop_q+0x72>
       val = q->head->value; 
    1cdc:	8b 45 08             	mov    0x8(%ebp),%eax
    1cdf:	8b 40 04             	mov    0x4(%eax),%eax
    1ce2:	8b 00                	mov    (%eax),%eax
    1ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1ce7:	8b 45 08             	mov    0x8(%ebp),%eax
    1cea:	8b 40 04             	mov    0x4(%eax),%eax
    1ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1cf0:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf3:	8b 40 04             	mov    0x4(%eax),%eax
    1cf6:	8b 50 04             	mov    0x4(%eax),%edx
    1cf9:	8b 45 08             	mov    0x8(%ebp),%eax
    1cfc:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d02:	89 04 24             	mov    %eax,(%esp)
    1d05:	e8 a5 fa ff ff       	call   17af <free>
       q->size--;
    1d0a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d0d:	8b 00                	mov    (%eax),%eax
    1d0f:	8d 50 ff             	lea    -0x1(%eax),%edx
    1d12:	8b 45 08             	mov    0x8(%ebp),%eax
    1d15:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1d17:	8b 45 08             	mov    0x8(%ebp),%eax
    1d1a:	8b 00                	mov    (%eax),%eax
    1d1c:	85 c0                	test   %eax,%eax
    1d1e:	75 14                	jne    1d34 <pop_q+0x6d>
            q->head = 0;
    1d20:	8b 45 08             	mov    0x8(%ebp),%eax
    1d23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1d2a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d37:	eb 05                	jmp    1d3e <pop_q+0x77>
    }
    return -1;
    1d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1d3e:	c9                   	leave  
    1d3f:	c3                   	ret    
