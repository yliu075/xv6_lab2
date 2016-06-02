
_test_q:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "queue.h"

int main(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    struct queue *q = malloc(sizeof(struct queue));
   9:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  10:	e8 79 07 00 00       	call   78e <malloc>
  15:	89 44 24 18          	mov    %eax,0x18(%esp)
    int i;
    init_q(q);
  19:	8b 44 24 18          	mov    0x18(%esp),%eax
  1d:	89 04 24             	mov    %eax,(%esp)
  20:	e8 ba 0a 00 00       	call   adf <init_q>
    for(i=0;i<10;i++){
  25:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  2c:	00 
  2d:	eb 19                	jmp    48 <main+0x48>
        add_q(q,i);
  2f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  33:	89 44 24 04          	mov    %eax,0x4(%esp)
  37:	8b 44 24 18          	mov    0x18(%esp),%eax
  3b:	89 04 24             	mov    %eax,(%esp)
  3e:	e8 be 0a 00 00       	call   b01 <add_q>

int main(){
    struct queue *q = malloc(sizeof(struct queue));
    int i;
    init_q(q);
    for(i=0;i<10;i++){
  43:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  48:	83 7c 24 1c 09       	cmpl   $0x9,0x1c(%esp)
  4d:	7e e0                	jle    2f <main+0x2f>
        add_q(q,i);
    }
    for(;!empty_q(q);){
  4f:	eb 24                	jmp    75 <main+0x75>
        printf(1,"pop %d\n",pop_q(q));
  51:	8b 44 24 18          	mov    0x18(%esp),%eax
  55:	89 04 24             	mov    %eax,(%esp)
  58:	e8 1e 0b 00 00       	call   b7b <pop_q>
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 2d 04 00 00       	call   4a2 <printf>
    int i;
    init_q(q);
    for(i=0;i<10;i++){
        add_q(q,i);
    }
    for(;!empty_q(q);){
  75:	8b 44 24 18          	mov    0x18(%esp),%eax
  79:	89 04 24             	mov    %eax,(%esp)
  7c:	e8 e0 0a 00 00       	call   b61 <empty_q>
  81:	85 c0                	test   %eax,%eax
  83:	74 cc                	je     51 <main+0x51>
        printf(1,"pop %d\n",pop_q(q));
    }
    exit();
  85:	e8 68 02 00 00       	call   2f2 <exit>

0000008a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	57                   	push   %edi
  8e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  92:	8b 55 10             	mov    0x10(%ebp),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	89 cb                	mov    %ecx,%ebx
  9a:	89 df                	mov    %ebx,%edi
  9c:	89 d1                	mov    %edx,%ecx
  9e:	fc                   	cld    
  9f:	f3 aa                	rep stos %al,%es:(%edi)
  a1:	89 ca                	mov    %ecx,%edx
  a3:	89 fb                	mov    %edi,%ebx
  a5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ab:	5b                   	pop    %ebx
  ac:	5f                   	pop    %edi
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  bb:	90                   	nop
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	8d 50 01             	lea    0x1(%eax),%edx
  c2:	89 55 08             	mov    %edx,0x8(%ebp)
  c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ce:	0f b6 12             	movzbl (%edx),%edx
  d1:	88 10                	mov    %dl,(%eax)
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	84 c0                	test   %al,%al
  d8:	75 e2                	jne    bc <strcpy+0xd>
    ;
  return os;
  da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dd:	c9                   	leave  
  de:	c3                   	ret    

000000df <strcmp>:

int
strcmp(const char *p, const char *q)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e2:	eb 08                	jmp    ec <strcmp+0xd>
    p++, q++;
  e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	84 c0                	test   %al,%al
  f4:	74 10                	je     106 <strcmp+0x27>
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 10             	movzbl (%eax),%edx
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	38 c2                	cmp    %al,%dl
 104:	74 de                	je     e4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	0f b6 d0             	movzbl %al,%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	0f b6 c0             	movzbl %al,%eax
 118:	29 c2                	sub    %eax,%edx
 11a:	89 d0                	mov    %edx,%eax
}
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    

0000011e <strlen>:

uint
strlen(char *s)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12b:	eb 04                	jmp    131 <strlen+0x13>
 12d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 131:	8b 55 fc             	mov    -0x4(%ebp),%edx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	01 d0                	add    %edx,%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	84 c0                	test   %al,%al
 13e:	75 ed                	jne    12d <strlen+0xf>
    ;
  return n;
 140:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <memset>:

void*
memset(void *dst, int c, uint n)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 14b:	8b 45 10             	mov    0x10(%ebp),%eax
 14e:	89 44 24 08          	mov    %eax,0x8(%esp)
 152:	8b 45 0c             	mov    0xc(%ebp),%eax
 155:	89 44 24 04          	mov    %eax,0x4(%esp)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	89 04 24             	mov    %eax,(%esp)
 15f:	e8 26 ff ff ff       	call   8a <stosb>
  return dst;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strchr>:

char*
strchr(const char *s, char c)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	83 ec 04             	sub    $0x4,%esp
 16f:	8b 45 0c             	mov    0xc(%ebp),%eax
 172:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 175:	eb 14                	jmp    18b <strchr+0x22>
    if(*s == c)
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 180:	75 05                	jne    187 <strchr+0x1e>
      return (char*)s;
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	eb 13                	jmp    19a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 187:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	84 c0                	test   %al,%al
 193:	75 e2                	jne    177 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 195:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <gets>:

char*
gets(char *buf, int max)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a9:	eb 4c                	jmp    1f7 <gets+0x5b>
    cc = read(0, &c, 1);
 1ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b2:	00 
 1b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c1:	e8 44 01 00 00       	call   30a <read>
 1c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cd:	7f 02                	jg     1d1 <gets+0x35>
      break;
 1cf:	eb 31                	jmp    202 <gets+0x66>
    buf[i++] = c;
 1d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d4:	8d 50 01             	lea    0x1(%eax),%edx
 1d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1da:	89 c2                	mov    %eax,%edx
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	01 c2                	add    %eax,%edx
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1eb:	3c 0a                	cmp    $0xa,%al
 1ed:	74 13                	je     202 <gets+0x66>
 1ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	74 0b                	je     202 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fa:	83 c0 01             	add    $0x1,%eax
 1fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 200:	7c a9                	jl     1ab <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 202:	8b 55 f4             	mov    -0xc(%ebp),%edx
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	01 d0                	add    %edx,%eax
 20a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 210:	c9                   	leave  
 211:	c3                   	ret    

00000212 <stat>:

int
stat(char *n, struct stat *st)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21f:	00 
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	89 04 24             	mov    %eax,(%esp)
 226:	e8 07 01 00 00       	call   332 <open>
 22b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 232:	79 07                	jns    23b <stat+0x29>
    return -1;
 234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 239:	eb 23                	jmp    25e <stat+0x4c>
  r = fstat(fd, st);
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	89 44 24 04          	mov    %eax,0x4(%esp)
 242:	8b 45 f4             	mov    -0xc(%ebp),%eax
 245:	89 04 24             	mov    %eax,(%esp)
 248:	e8 fd 00 00 00       	call   34a <fstat>
 24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 250:	8b 45 f4             	mov    -0xc(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 bf 00 00 00       	call   31a <close>
  return r;
 25b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	eb 25                	jmp    294 <atoi+0x34>
    n = n*10 + *s++ - '0';
 26f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 272:	89 d0                	mov    %edx,%eax
 274:	c1 e0 02             	shl    $0x2,%eax
 277:	01 d0                	add    %edx,%eax
 279:	01 c0                	add    %eax,%eax
 27b:	89 c1                	mov    %eax,%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	8d 50 01             	lea    0x1(%eax),%edx
 283:	89 55 08             	mov    %edx,0x8(%ebp)
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	0f be c0             	movsbl %al,%eax
 28c:	01 c8                	add    %ecx,%eax
 28e:	83 e8 30             	sub    $0x30,%eax
 291:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	3c 2f                	cmp    $0x2f,%al
 29c:	7e 0a                	jle    2a8 <atoi+0x48>
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	3c 39                	cmp    $0x39,%al
 2a6:	7e c7                	jle    26f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    

000002ad <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2bf:	eb 17                	jmp    2d8 <memmove+0x2b>
    *dst++ = *src++;
 2c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c4:	8d 50 01             	lea    0x1(%eax),%edx
 2c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cd:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d3:	0f b6 12             	movzbl (%edx),%edx
 2d6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d8:	8b 45 10             	mov    0x10(%ebp),%eax
 2db:	8d 50 ff             	lea    -0x1(%eax),%edx
 2de:	89 55 10             	mov    %edx,0x10(%ebp)
 2e1:	85 c0                	test   %eax,%eax
 2e3:	7f dc                	jg     2c1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ea:	b8 01 00 00 00       	mov    $0x1,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exit>:
SYSCALL(exit)
 2f2:	b8 02 00 00 00       	mov    $0x2,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <wait>:
SYSCALL(wait)
 2fa:	b8 03 00 00 00       	mov    $0x3,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <pipe>:
SYSCALL(pipe)
 302:	b8 04 00 00 00       	mov    $0x4,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <read>:
SYSCALL(read)
 30a:	b8 05 00 00 00       	mov    $0x5,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <write>:
SYSCALL(write)
 312:	b8 10 00 00 00       	mov    $0x10,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <close>:
SYSCALL(close)
 31a:	b8 15 00 00 00       	mov    $0x15,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <kill>:
SYSCALL(kill)
 322:	b8 06 00 00 00       	mov    $0x6,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exec>:
SYSCALL(exec)
 32a:	b8 07 00 00 00       	mov    $0x7,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <open>:
SYSCALL(open)
 332:	b8 0f 00 00 00       	mov    $0xf,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mknod>:
SYSCALL(mknod)
 33a:	b8 11 00 00 00       	mov    $0x11,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <unlink>:
SYSCALL(unlink)
 342:	b8 12 00 00 00       	mov    $0x12,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <fstat>:
SYSCALL(fstat)
 34a:	b8 08 00 00 00       	mov    $0x8,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <link>:
SYSCALL(link)
 352:	b8 13 00 00 00       	mov    $0x13,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mkdir>:
SYSCALL(mkdir)
 35a:	b8 14 00 00 00       	mov    $0x14,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <chdir>:
SYSCALL(chdir)
 362:	b8 09 00 00 00       	mov    $0x9,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <dup>:
SYSCALL(dup)
 36a:	b8 0a 00 00 00       	mov    $0xa,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getpid>:
SYSCALL(getpid)
 372:	b8 0b 00 00 00       	mov    $0xb,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sbrk>:
SYSCALL(sbrk)
 37a:	b8 0c 00 00 00       	mov    $0xc,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sleep>:
SYSCALL(sleep)
 382:	b8 0d 00 00 00       	mov    $0xd,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <uptime>:
SYSCALL(uptime)
 38a:	b8 0e 00 00 00       	mov    $0xe,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <clone>:
SYSCALL(clone)
 392:	b8 16 00 00 00       	mov    $0x16,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <texit>:
SYSCALL(texit)
 39a:	b8 17 00 00 00       	mov    $0x17,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <tsleep>:
SYSCALL(tsleep)
 3a2:	b8 18 00 00 00       	mov    $0x18,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <twakeup>:
SYSCALL(twakeup)
 3aa:	b8 19 00 00 00       	mov    $0x19,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <thread_yield>:
SYSCALL(thread_yield)
 3b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <thread_yield3>:
 3ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 18             	sub    $0x18,%esp
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d5:	00 
 3d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	89 04 24             	mov    %eax,(%esp)
 3e3:	e8 2a ff ff ff       	call   312 <write>
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	56                   	push   %esi
 3ee:	53                   	push   %ebx
 3ef:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3fd:	74 17                	je     416 <printint+0x2c>
 3ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 403:	79 11                	jns    416 <printint+0x2c>
    neg = 1;
 405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	f7 d8                	neg    %eax
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
 414:	eb 06                	jmp    41c <printint+0x32>
  } else {
    x = xx;
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 41c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 423:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 426:	8d 41 01             	lea    0x1(%ecx),%eax
 429:	89 45 f4             	mov    %eax,-0xc(%ebp)
 42c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 432:	ba 00 00 00 00       	mov    $0x0,%edx
 437:	f7 f3                	div    %ebx
 439:	89 d0                	mov    %edx,%eax
 43b:	0f b6 80 14 10 00 00 	movzbl 0x1014(%eax),%eax
 442:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 446:	8b 75 10             	mov    0x10(%ebp),%esi
 449:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44c:	ba 00 00 00 00       	mov    $0x0,%edx
 451:	f7 f6                	div    %esi
 453:	89 45 ec             	mov    %eax,-0x14(%ebp)
 456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45a:	75 c7                	jne    423 <printint+0x39>
  if(neg)
 45c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 460:	74 10                	je     472 <printint+0x88>
    buf[i++] = '-';
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	8d 50 01             	lea    0x1(%eax),%edx
 468:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 470:	eb 1f                	jmp    491 <printint+0xa7>
 472:	eb 1d                	jmp    491 <printint+0xa7>
    putc(fd, buf[i]);
 474:	8d 55 dc             	lea    -0x24(%ebp),%edx
 477:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	0f b6 00             	movzbl (%eax),%eax
 47f:	0f be c0             	movsbl %al,%eax
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	89 04 24             	mov    %eax,(%esp)
 48c:	e8 31 ff ff ff       	call   3c2 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 491:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 499:	79 d9                	jns    474 <printint+0x8a>
    putc(fd, buf[i]);
}
 49b:	83 c4 30             	add    $0x30,%esp
 49e:	5b                   	pop    %ebx
 49f:	5e                   	pop    %esi
 4a0:	5d                   	pop    %ebp
 4a1:	c3                   	ret    

000004a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4af:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b2:	83 c0 04             	add    $0x4,%eax
 4b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4bf:	e9 7c 01 00 00       	jmp    640 <printf+0x19e>
    c = fmt[i] & 0xff;
 4c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	0f b6 00             	movzbl (%eax),%eax
 4cf:	0f be c0             	movsbl %al,%eax
 4d2:	25 ff 00 00 00       	and    $0xff,%eax
 4d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4de:	75 2c                	jne    50c <printf+0x6a>
      if(c == '%'){
 4e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e4:	75 0c                	jne    4f2 <printf+0x50>
        state = '%';
 4e6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ed:	e9 4a 01 00 00       	jmp    63c <printf+0x19a>
      } else {
        putc(fd, c);
 4f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	89 04 24             	mov    %eax,(%esp)
 502:	e8 bb fe ff ff       	call   3c2 <putc>
 507:	e9 30 01 00 00       	jmp    63c <printf+0x19a>
      }
    } else if(state == '%'){
 50c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 510:	0f 85 26 01 00 00    	jne    63c <printf+0x19a>
      if(c == 'd'){
 516:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51a:	75 2d                	jne    549 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 51c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 528:	00 
 529:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 530:	00 
 531:	89 44 24 04          	mov    %eax,0x4(%esp)
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	89 04 24             	mov    %eax,(%esp)
 53b:	e8 aa fe ff ff       	call   3ea <printint>
        ap++;
 540:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 544:	e9 ec 00 00 00       	jmp    635 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 549:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 54d:	74 06                	je     555 <printf+0xb3>
 54f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 553:	75 2d                	jne    582 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 561:	00 
 562:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 569:	00 
 56a:	89 44 24 04          	mov    %eax,0x4(%esp)
 56e:	8b 45 08             	mov    0x8(%ebp),%eax
 571:	89 04 24             	mov    %eax,(%esp)
 574:	e8 71 fe ff ff       	call   3ea <printint>
        ap++;
 579:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57d:	e9 b3 00 00 00       	jmp    635 <printf+0x193>
      } else if(c == 's'){
 582:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 586:	75 45                	jne    5cd <printf+0x12b>
        s = (char*)*ap;
 588:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 590:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 598:	75 09                	jne    5a3 <printf+0x101>
          s = "(null)";
 59a:	c7 45 f4 fc 0b 00 00 	movl   $0xbfc,-0xc(%ebp)
        while(*s != 0){
 5a1:	eb 1e                	jmp    5c1 <printf+0x11f>
 5a3:	eb 1c                	jmp    5c1 <printf+0x11f>
          putc(fd, *s);
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 05 fe ff ff       	call   3c2 <putc>
          s++;
 5bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c4:	0f b6 00             	movzbl (%eax),%eax
 5c7:	84 c0                	test   %al,%al
 5c9:	75 da                	jne    5a5 <printf+0x103>
 5cb:	eb 68                	jmp    635 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5cd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d1:	75 1d                	jne    5f0 <printf+0x14e>
        putc(fd, *ap);
 5d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	89 44 24 04          	mov    %eax,0x4(%esp)
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 d8 fd ff ff       	call   3c2 <putc>
        ap++;
 5ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ee:	eb 45                	jmp    635 <printf+0x193>
      } else if(c == '%'){
 5f0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f4:	75 17                	jne    60d <printf+0x16b>
        putc(fd, c);
 5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 b7 fd ff ff       	call   3c2 <putc>
 60b:	eb 28                	jmp    635 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 614:	00 
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 a2 fd ff ff       	call   3c2 <putc>
        putc(fd, c);
 620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	89 44 24 04          	mov    %eax,0x4(%esp)
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	89 04 24             	mov    %eax,(%esp)
 630:	e8 8d fd ff ff       	call   3c2 <putc>
      }
      state = 0;
 635:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 63c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 640:	8b 55 0c             	mov    0xc(%ebp),%edx
 643:	8b 45 f0             	mov    -0x10(%ebp),%eax
 646:	01 d0                	add    %edx,%eax
 648:	0f b6 00             	movzbl (%eax),%eax
 64b:	84 c0                	test   %al,%al
 64d:	0f 85 71 fe ff ff    	jne    4c4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 653:	c9                   	leave  
 654:	c3                   	ret    

00000655 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 655:	55                   	push   %ebp
 656:	89 e5                	mov    %esp,%ebp
 658:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65b:	8b 45 08             	mov    0x8(%ebp),%eax
 65e:	83 e8 08             	sub    $0x8,%eax
 661:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	a1 34 10 00 00       	mov    0x1034,%eax
 669:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66c:	eb 24                	jmp    692 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 676:	77 12                	ja     68a <free+0x35>
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67e:	77 24                	ja     6a4 <free+0x4f>
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 688:	77 1a                	ja     6a4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 698:	76 d4                	jbe    66e <free+0x19>
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a2:	76 ca                	jbe    66e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	01 c2                	add    %eax,%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	39 c2                	cmp    %eax,%edx
 6bd:	75 24                	jne    6e3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 50 04             	mov    0x4(%eax),%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	01 c2                	add    %eax,%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	8b 10                	mov    (%eax),%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	89 10                	mov    %edx,(%eax)
 6e1:	eb 0a                	jmp    6ed <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 10                	mov    (%eax),%edx
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	01 d0                	add    %edx,%eax
 6ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 702:	75 20                	jne    724 <free+0xcf>
    p->s.size += bp->s.size;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 50 04             	mov    0x4(%eax),%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	8b 40 04             	mov    0x4(%eax),%eax
 710:	01 c2                	add    %eax,%edx
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	8b 10                	mov    (%eax),%edx
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	89 10                	mov    %edx,(%eax)
 722:	eb 08                	jmp    72c <free+0xd7>
  } else
    p->s.ptr = bp;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72a:	89 10                	mov    %edx,(%eax)
  freep = p;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	a3 34 10 00 00       	mov    %eax,0x1034
}
 734:	c9                   	leave  
 735:	c3                   	ret    

00000736 <morecore>:

static Header*
morecore(uint nu)
{
 736:	55                   	push   %ebp
 737:	89 e5                	mov    %esp,%ebp
 739:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 743:	77 07                	ja     74c <morecore+0x16>
    nu = 4096;
 745:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	c1 e0 03             	shl    $0x3,%eax
 752:	89 04 24             	mov    %eax,(%esp)
 755:	e8 20 fc ff ff       	call   37a <sbrk>
 75a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 75d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 761:	75 07                	jne    76a <morecore+0x34>
    return 0;
 763:	b8 00 00 00 00       	mov    $0x0,%eax
 768:	eb 22                	jmp    78c <morecore+0x56>
  hp = (Header*)p;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	8b 55 08             	mov    0x8(%ebp),%edx
 776:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 779:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	89 04 24             	mov    %eax,(%esp)
 782:	e8 ce fe ff ff       	call   655 <free>
  return freep;
 787:	a1 34 10 00 00       	mov    0x1034,%eax
}
 78c:	c9                   	leave  
 78d:	c3                   	ret    

0000078e <malloc>:

void*
malloc(uint nbytes)
{
 78e:	55                   	push   %ebp
 78f:	89 e5                	mov    %esp,%ebp
 791:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	83 c0 07             	add    $0x7,%eax
 79a:	c1 e8 03             	shr    $0x3,%eax
 79d:	83 c0 01             	add    $0x1,%eax
 7a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a3:	a1 34 10 00 00       	mov    0x1034,%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7af:	75 23                	jne    7d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b1:	c7 45 f0 2c 10 00 00 	movl   $0x102c,-0x10(%ebp)
 7b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bb:	a3 34 10 00 00       	mov    %eax,0x1034
 7c0:	a1 34 10 00 00       	mov    0x1034,%eax
 7c5:	a3 2c 10 00 00       	mov    %eax,0x102c
    base.s.size = 0;
 7ca:	c7 05 30 10 00 00 00 	movl   $0x0,0x1030
 7d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e5:	72 4d                	jb     834 <malloc+0xa6>
      if(p->s.size == nunits)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f0:	75 0c                	jne    7fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 10                	mov    (%eax),%edx
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	89 10                	mov    %edx,(%eax)
 7fc:	eb 26                	jmp    824 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	2b 45 ec             	sub    -0x14(%ebp),%eax
 807:	89 c2                	mov    %eax,%edx
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	c1 e0 03             	shl    $0x3,%eax
 818:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 821:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	a3 34 10 00 00       	mov    %eax,0x1034
      return (void*)(p + 1);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	83 c0 08             	add    $0x8,%eax
 832:	eb 38                	jmp    86c <malloc+0xde>
    }
    if(p == freep)
 834:	a1 34 10 00 00       	mov    0x1034,%eax
 839:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 83c:	75 1b                	jne    859 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 83e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 841:	89 04 24             	mov    %eax,(%esp)
 844:	e8 ed fe ff ff       	call   736 <morecore>
 849:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 850:	75 07                	jne    859 <malloc+0xcb>
        return 0;
 852:	b8 00 00 00 00       	mov    $0x0,%eax
 857:	eb 13                	jmp    86c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 867:	e9 70 ff ff ff       	jmp    7dc <malloc+0x4e>
}
 86c:	c9                   	leave  
 86d:	c3                   	ret    

0000086e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 86e:	55                   	push   %ebp
 86f:	89 e5                	mov    %esp,%ebp
 871:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 874:	8b 55 08             	mov    0x8(%ebp),%edx
 877:	8b 45 0c             	mov    0xc(%ebp),%eax
 87a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 87d:	f0 87 02             	lock xchg %eax,(%edx)
 880:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 886:	c9                   	leave  
 887:	c3                   	ret    

00000888 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 894:	5d                   	pop    %ebp
 895:	c3                   	ret    

00000896 <lock_acquire>:
void lock_acquire(lock_t *lock){
 896:	55                   	push   %ebp
 897:	89 e5                	mov    %esp,%ebp
 899:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 89c:	90                   	nop
 89d:	8b 45 08             	mov    0x8(%ebp),%eax
 8a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8a7:	00 
 8a8:	89 04 24             	mov    %eax,(%esp)
 8ab:	e8 be ff ff ff       	call   86e <xchg>
 8b0:	85 c0                	test   %eax,%eax
 8b2:	75 e9                	jne    89d <lock_acquire+0x7>
}
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    

000008b6 <lock_release>:
void lock_release(lock_t *lock){
 8b6:	55                   	push   %ebp
 8b7:	89 e5                	mov    %esp,%ebp
 8b9:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 8bc:	8b 45 08             	mov    0x8(%ebp),%eax
 8bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8c6:	00 
 8c7:	89 04 24             	mov    %eax,(%esp)
 8ca:	e8 9f ff ff ff       	call   86e <xchg>
}
 8cf:	c9                   	leave  
 8d0:	c3                   	ret    

000008d1 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 8d1:	55                   	push   %ebp
 8d2:	89 e5                	mov    %esp,%ebp
 8d4:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8d7:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8de:	e8 ab fe ff ff       	call   78e <malloc>
 8e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 8ec:	0f b6 05 38 10 00 00 	movzbl 0x1038,%eax
 8f3:	84 c0                	test   %al,%al
 8f5:	75 1c                	jne    913 <thread_create+0x42>
        init_q(thQ2);
 8f7:	a1 3c 10 00 00       	mov    0x103c,%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 db 01 00 00       	call   adf <init_q>
        inQ++;
 904:	0f b6 05 38 10 00 00 	movzbl 0x1038,%eax
 90b:	83 c0 01             	add    $0x1,%eax
 90e:	a2 38 10 00 00       	mov    %al,0x1038
    }

    if((uint)stack % 4096){
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	25 ff 0f 00 00       	and    $0xfff,%eax
 91b:	85 c0                	test   %eax,%eax
 91d:	74 14                	je     933 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	25 ff 0f 00 00       	and    $0xfff,%eax
 927:	89 c2                	mov    %eax,%edx
 929:	b8 00 10 00 00       	mov    $0x1000,%eax
 92e:	29 d0                	sub    %edx,%eax
 930:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 937:	75 1e                	jne    957 <thread_create+0x86>

        printf(1,"malloc fail \n");
 939:	c7 44 24 04 03 0c 00 	movl   $0xc03,0x4(%esp)
 940:	00 
 941:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 948:	e8 55 fb ff ff       	call   4a2 <printf>
        return 0;
 94d:	b8 00 00 00 00       	mov    $0x0,%eax
 952:	e9 83 00 00 00       	jmp    9da <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 95a:	8b 55 08             	mov    0x8(%ebp),%edx
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 964:	89 54 24 08          	mov    %edx,0x8(%esp)
 968:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 96f:	00 
 970:	89 04 24             	mov    %eax,(%esp)
 973:	e8 1a fa ff ff       	call   392 <clone>
 978:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 97b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 97f:	79 1b                	jns    99c <thread_create+0xcb>
        printf(1,"clone fails\n");
 981:	c7 44 24 04 11 0c 00 	movl   $0xc11,0x4(%esp)
 988:	00 
 989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 990:	e8 0d fb ff ff       	call   4a2 <printf>
        return 0;
 995:	b8 00 00 00 00       	mov    $0x0,%eax
 99a:	eb 3e                	jmp    9da <thread_create+0x109>
    }
    if(tid > 0){
 99c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a0:	7e 19                	jle    9bb <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 9a2:	a1 3c 10 00 00       	mov    0x103c,%eax
 9a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9aa:	89 54 24 04          	mov    %edx,0x4(%esp)
 9ae:	89 04 24             	mov    %eax,(%esp)
 9b1:	e8 4b 01 00 00       	call   b01 <add_q>
        return garbage_stack;
 9b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b9:	eb 1f                	jmp    9da <thread_create+0x109>
    }
    if(tid == 0){
 9bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9bf:	75 14                	jne    9d5 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 9c1:	c7 44 24 04 1e 0c 00 	movl   $0xc1e,0x4(%esp)
 9c8:	00 
 9c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9d0:	e8 cd fa ff ff       	call   4a2 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9da:	c9                   	leave  
 9db:	c3                   	ret    

000009dc <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 9dc:	55                   	push   %ebp
 9dd:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 9df:	a1 28 10 00 00       	mov    0x1028,%eax
 9e4:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 9ea:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 9ef:	a3 28 10 00 00       	mov    %eax,0x1028
    return (int)(rands % max);
 9f4:	a1 28 10 00 00       	mov    0x1028,%eax
 9f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9fc:	ba 00 00 00 00       	mov    $0x0,%edx
 a01:	f7 f1                	div    %ecx
 a03:	89 d0                	mov    %edx,%eax
}
 a05:	5d                   	pop    %ebp
 a06:	c3                   	ret    

00000a07 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 a07:	55                   	push   %ebp
 a08:	89 e5                	mov    %esp,%ebp
 a0a:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 a0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 a13:	8b 40 10             	mov    0x10(%eax),%eax
 a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 a19:	a1 3c 10 00 00       	mov    0x103c,%eax
 a1e:	8b 00                	mov    (%eax),%eax
 a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a23:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a27:	89 44 24 08          	mov    %eax,0x8(%esp)
 a2b:	c7 44 24 04 2f 0c 00 	movl   $0xc2f,0x4(%esp)
 a32:	00 
 a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a3a:	e8 63 fa ff ff       	call   4a2 <printf>
    add_q(thQ2, tid2);
 a3f:	a1 3c 10 00 00       	mov    0x103c,%eax
 a44:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a47:	89 54 24 04          	mov    %edx,0x4(%esp)
 a4b:	89 04 24             	mov    %eax,(%esp)
 a4e:	e8 ae 00 00 00       	call   b01 <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 a53:	a1 3c 10 00 00       	mov    0x103c,%eax
 a58:	8b 00                	mov    (%eax),%eax
 a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
 a5e:	c7 44 24 04 47 0c 00 	movl   $0xc47,0x4(%esp)
 a65:	00 
 a66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a6d:	e8 30 fa ff ff       	call   4a2 <printf>
    int tidNext = pop_q(thQ2);
 a72:	a1 3c 10 00 00       	mov    0x103c,%eax
 a77:	89 04 24             	mov    %eax,(%esp)
 a7a:	e8 fc 00 00 00       	call   b7b <pop_q>
 a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 a82:	eb 10                	jmp    a94 <thread_yield2+0x8d>
 a84:	a1 3c 10 00 00       	mov    0x103c,%eax
 a89:	89 04 24             	mov    %eax,(%esp)
 a8c:	e8 ea 00 00 00       	call   b7b <pop_q>
 a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a9a:	74 e8                	je     a84 <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 a9c:	a1 3c 10 00 00       	mov    0x103c,%eax
 aa1:	8b 00                	mov    (%eax),%eax
 aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aa6:	89 54 24 0c          	mov    %edx,0xc(%esp)
 aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
 aae:	c7 44 24 04 57 0c 00 	movl   $0xc57,0x4(%esp)
 ab5:	00 
 ab6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 abd:	e8 e0 f9 ff ff       	call   4a2 <printf>
    tsleep();
 ac2:	e8 db f8 ff ff       	call   3a2 <tsleep>
    twakeup(tidNext);
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 d8 f8 ff ff       	call   3aa <twakeup>
    thread_yield3(tidNext);
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	89 04 24             	mov    %eax,(%esp)
 ad8:	e8 dd f8 ff ff       	call   3ba <thread_yield3>
    //yield();
 add:	c9                   	leave  
 ade:	c3                   	ret    

00000adf <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 adf:	55                   	push   %ebp
 ae0:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 ae2:	8b 45 08             	mov    0x8(%ebp),%eax
 ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 af5:	8b 45 08             	mov    0x8(%ebp),%eax
 af8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 aff:	5d                   	pop    %ebp
 b00:	c3                   	ret    

00000b01 <add_q>:

void add_q(struct queue *q, int v){
 b01:	55                   	push   %ebp
 b02:	89 e5                	mov    %esp,%ebp
 b04:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 b07:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b0e:	e8 7b fc ff ff       	call   78e <malloc>
 b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b23:	8b 55 0c             	mov    0xc(%ebp),%edx
 b26:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b28:	8b 45 08             	mov    0x8(%ebp),%eax
 b2b:	8b 40 04             	mov    0x4(%eax),%eax
 b2e:	85 c0                	test   %eax,%eax
 b30:	75 0b                	jne    b3d <add_q+0x3c>
        q->head = n;
 b32:	8b 45 08             	mov    0x8(%ebp),%eax
 b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b38:	89 50 04             	mov    %edx,0x4(%eax)
 b3b:	eb 0c                	jmp    b49 <add_q+0x48>
    }else{
        q->tail->next = n;
 b3d:	8b 45 08             	mov    0x8(%ebp),%eax
 b40:	8b 40 08             	mov    0x8(%eax),%eax
 b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b46:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b49:	8b 45 08             	mov    0x8(%ebp),%eax
 b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b4f:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b52:	8b 45 08             	mov    0x8(%ebp),%eax
 b55:	8b 00                	mov    (%eax),%eax
 b57:	8d 50 01             	lea    0x1(%eax),%edx
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	89 10                	mov    %edx,(%eax)
}
 b5f:	c9                   	leave  
 b60:	c3                   	ret    

00000b61 <empty_q>:

int empty_q(struct queue *q){
 b61:	55                   	push   %ebp
 b62:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b64:	8b 45 08             	mov    0x8(%ebp),%eax
 b67:	8b 00                	mov    (%eax),%eax
 b69:	85 c0                	test   %eax,%eax
 b6b:	75 07                	jne    b74 <empty_q+0x13>
        return 1;
 b6d:	b8 01 00 00 00       	mov    $0x1,%eax
 b72:	eb 05                	jmp    b79 <empty_q+0x18>
    else
        return 0;
 b74:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b79:	5d                   	pop    %ebp
 b7a:	c3                   	ret    

00000b7b <pop_q>:
int pop_q(struct queue *q){
 b7b:	55                   	push   %ebp
 b7c:	89 e5                	mov    %esp,%ebp
 b7e:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b81:	8b 45 08             	mov    0x8(%ebp),%eax
 b84:	89 04 24             	mov    %eax,(%esp)
 b87:	e8 d5 ff ff ff       	call   b61 <empty_q>
 b8c:	85 c0                	test   %eax,%eax
 b8e:	75 5d                	jne    bed <pop_q+0x72>
       val = q->head->value; 
 b90:	8b 45 08             	mov    0x8(%ebp),%eax
 b93:	8b 40 04             	mov    0x4(%eax),%eax
 b96:	8b 00                	mov    (%eax),%eax
 b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	8b 40 04             	mov    0x4(%eax),%eax
 ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 ba4:	8b 45 08             	mov    0x8(%ebp),%eax
 ba7:	8b 40 04             	mov    0x4(%eax),%eax
 baa:	8b 50 04             	mov    0x4(%eax),%edx
 bad:	8b 45 08             	mov    0x8(%ebp),%eax
 bb0:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb6:	89 04 24             	mov    %eax,(%esp)
 bb9:	e8 97 fa ff ff       	call   655 <free>
       q->size--;
 bbe:	8b 45 08             	mov    0x8(%ebp),%eax
 bc1:	8b 00                	mov    (%eax),%eax
 bc3:	8d 50 ff             	lea    -0x1(%eax),%edx
 bc6:	8b 45 08             	mov    0x8(%ebp),%eax
 bc9:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 bcb:	8b 45 08             	mov    0x8(%ebp),%eax
 bce:	8b 00                	mov    (%eax),%eax
 bd0:	85 c0                	test   %eax,%eax
 bd2:	75 14                	jne    be8 <pop_q+0x6d>
            q->head = 0;
 bd4:	8b 45 08             	mov    0x8(%ebp),%eax
 bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bde:	8b 45 08             	mov    0x8(%ebp),%eax
 be1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 beb:	eb 05                	jmp    bf2 <pop_q+0x77>
    }
    return -1;
 bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bf2:	c9                   	leave  
 bf3:	c3                   	ret    
