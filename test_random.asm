
_test_random:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"


int main(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    printf(1,"random number %d\n",random(100));
   9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  10:	e8 ff 09 00 00       	call   a14 <random>
  15:	89 44 24 08          	mov    %eax,0x8(%esp)
  19:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 ad 04 00 00       	call   4da <printf>
    printf(1,"random number %d\n",random(100));
  2d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  34:	e8 db 09 00 00       	call   a14 <random>
  39:	89 44 24 08          	mov    %eax,0x8(%esp)
  3d:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
  44:	00 
  45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4c:	e8 89 04 00 00       	call   4da <printf>
    printf(1,"random number %d\n",random(100));
  51:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  58:	e8 b7 09 00 00       	call   a14 <random>
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 65 04 00 00       	call   4da <printf>
    printf(1,"random number %d\n",random(100));
  75:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  7c:	e8 93 09 00 00       	call   a14 <random>
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 41 04 00 00       	call   4da <printf>
    printf(1,"random number %d\n",random(100));
  99:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  a0:	e8 6f 09 00 00       	call   a14 <random>
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 1d 04 00 00       	call   4da <printf>

    exit();
  bd:	e8 68 02 00 00       	call   32a <exit>

000000c2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	57                   	push   %edi
  c6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ca:	8b 55 10             	mov    0x10(%ebp),%edx
  cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  d0:	89 cb                	mov    %ecx,%ebx
  d2:	89 df                	mov    %ebx,%edi
  d4:	89 d1                	mov    %edx,%ecx
  d6:	fc                   	cld    
  d7:	f3 aa                	rep stos %al,%es:(%edi)
  d9:	89 ca                	mov    %ecx,%edx
  db:	89 fb                	mov    %edi,%ebx
  dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e3:	5b                   	pop    %ebx
  e4:	5f                   	pop    %edi
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    

000000e7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f3:	90                   	nop
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8d 50 01             	lea    0x1(%eax),%edx
  fa:	89 55 08             	mov    %edx,0x8(%ebp)
  fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 100:	8d 4a 01             	lea    0x1(%edx),%ecx
 103:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 106:	0f b6 12             	movzbl (%edx),%edx
 109:	88 10                	mov    %dl,(%eax)
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	84 c0                	test   %al,%al
 110:	75 e2                	jne    f4 <strcpy+0xd>
    ;
  return os;
 112:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 115:	c9                   	leave  
 116:	c3                   	ret    

00000117 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11a:	eb 08                	jmp    124 <strcmp+0xd>
    p++, q++;
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	74 10                	je     13e <strcmp+0x27>
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	0f b6 10             	movzbl (%eax),%edx
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	38 c2                	cmp    %al,%dl
 13c:	74 de                	je     11c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	0f b6 00             	movzbl (%eax),%eax
 144:	0f b6 d0             	movzbl %al,%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	0f b6 00             	movzbl (%eax),%eax
 14d:	0f b6 c0             	movzbl %al,%eax
 150:	29 c2                	sub    %eax,%edx
 152:	89 d0                	mov    %edx,%eax
}
 154:	5d                   	pop    %ebp
 155:	c3                   	ret    

00000156 <strlen>:

uint
strlen(char *s)
{
 156:	55                   	push   %ebp
 157:	89 e5                	mov    %esp,%ebp
 159:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 163:	eb 04                	jmp    169 <strlen+0x13>
 165:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 169:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	01 d0                	add    %edx,%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	84 c0                	test   %al,%al
 176:	75 ed                	jne    165 <strlen+0xf>
    ;
  return n;
 178:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <memset>:

void*
memset(void *dst, int c, uint n)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 183:	8b 45 10             	mov    0x10(%ebp),%eax
 186:	89 44 24 08          	mov    %eax,0x8(%esp)
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	89 44 24 04          	mov    %eax,0x4(%esp)
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	89 04 24             	mov    %eax,(%esp)
 197:	e8 26 ff ff ff       	call   c2 <stosb>
  return dst;
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <strchr>:

char*
strchr(const char *s, char c)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 04             	sub    $0x4,%esp
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ad:	eb 14                	jmp    1c3 <strchr+0x22>
    if(*s == c)
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
 1b2:	0f b6 00             	movzbl (%eax),%eax
 1b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b8:	75 05                	jne    1bf <strchr+0x1e>
      return (char*)s;
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	eb 13                	jmp    1d2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	75 e2                	jne    1af <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e1:	eb 4c                	jmp    22f <gets+0x5b>
    cc = read(0, &c, 1);
 1e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ea:	00 
 1eb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f9:	e8 44 01 00 00       	call   342 <read>
 1fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 205:	7f 02                	jg     209 <gets+0x35>
      break;
 207:	eb 31                	jmp    23a <gets+0x66>
    buf[i++] = c;
 209:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20c:	8d 50 01             	lea    0x1(%eax),%edx
 20f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 212:	89 c2                	mov    %eax,%edx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	01 c2                	add    %eax,%edx
 219:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 21f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 223:	3c 0a                	cmp    $0xa,%al
 225:	74 13                	je     23a <gets+0x66>
 227:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22b:	3c 0d                	cmp    $0xd,%al
 22d:	74 0b                	je     23a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 232:	83 c0 01             	add    $0x1,%eax
 235:	3b 45 0c             	cmp    0xc(%ebp),%eax
 238:	7c a9                	jl     1e3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	01 d0                	add    %edx,%eax
 242:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 245:	8b 45 08             	mov    0x8(%ebp),%eax
}
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <stat>:

int
stat(char *n, struct stat *st)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 250:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 257:	00 
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	89 04 24             	mov    %eax,(%esp)
 25e:	e8 07 01 00 00       	call   36a <open>
 263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26a:	79 07                	jns    273 <stat+0x29>
    return -1;
 26c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 271:	eb 23                	jmp    296 <stat+0x4c>
  r = fstat(fd, st);
 273:	8b 45 0c             	mov    0xc(%ebp),%eax
 276:	89 44 24 04          	mov    %eax,0x4(%esp)
 27a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27d:	89 04 24             	mov    %eax,(%esp)
 280:	e8 fd 00 00 00       	call   382 <fstat>
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 bf 00 00 00       	call   352 <close>
  return r;
 293:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <atoi>:

int
atoi(const char *s)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a5:	eb 25                	jmp    2cc <atoi+0x34>
    n = n*10 + *s++ - '0';
 2a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2aa:	89 d0                	mov    %edx,%eax
 2ac:	c1 e0 02             	shl    $0x2,%eax
 2af:	01 d0                	add    %edx,%eax
 2b1:	01 c0                	add    %eax,%eax
 2b3:	89 c1                	mov    %eax,%ecx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	8d 50 01             	lea    0x1(%eax),%edx
 2bb:	89 55 08             	mov    %edx,0x8(%ebp)
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	0f be c0             	movsbl %al,%eax
 2c4:	01 c8                	add    %ecx,%eax
 2c6:	83 e8 30             	sub    $0x30,%eax
 2c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 2f                	cmp    $0x2f,%al
 2d4:	7e 0a                	jle    2e0 <atoi+0x48>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	3c 39                	cmp    $0x39,%al
 2de:	7e c7                	jle    2a7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f7:	eb 17                	jmp    310 <memmove+0x2b>
    *dst++ = *src++;
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fc:	8d 50 01             	lea    0x1(%eax),%edx
 2ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
 302:	8b 55 f8             	mov    -0x8(%ebp),%edx
 305:	8d 4a 01             	lea    0x1(%edx),%ecx
 308:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30b:	0f b6 12             	movzbl (%edx),%edx
 30e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 310:	8b 45 10             	mov    0x10(%ebp),%eax
 313:	8d 50 ff             	lea    -0x1(%eax),%edx
 316:	89 55 10             	mov    %edx,0x10(%ebp)
 319:	85 c0                	test   %eax,%eax
 31b:	7f dc                	jg     2f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 322:	b8 01 00 00 00       	mov    $0x1,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exit>:
SYSCALL(exit)
 32a:	b8 02 00 00 00       	mov    $0x2,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <wait>:
SYSCALL(wait)
 332:	b8 03 00 00 00       	mov    $0x3,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <pipe>:
SYSCALL(pipe)
 33a:	b8 04 00 00 00       	mov    $0x4,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <read>:
SYSCALL(read)
 342:	b8 05 00 00 00       	mov    $0x5,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <write>:
SYSCALL(write)
 34a:	b8 10 00 00 00       	mov    $0x10,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <close>:
SYSCALL(close)
 352:	b8 15 00 00 00       	mov    $0x15,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <kill>:
SYSCALL(kill)
 35a:	b8 06 00 00 00       	mov    $0x6,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <exec>:
SYSCALL(exec)
 362:	b8 07 00 00 00       	mov    $0x7,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <open>:
SYSCALL(open)
 36a:	b8 0f 00 00 00       	mov    $0xf,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <mknod>:
SYSCALL(mknod)
 372:	b8 11 00 00 00       	mov    $0x11,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <unlink>:
SYSCALL(unlink)
 37a:	b8 12 00 00 00       	mov    $0x12,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <fstat>:
SYSCALL(fstat)
 382:	b8 08 00 00 00       	mov    $0x8,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <link>:
SYSCALL(link)
 38a:	b8 13 00 00 00       	mov    $0x13,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <mkdir>:
SYSCALL(mkdir)
 392:	b8 14 00 00 00       	mov    $0x14,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <chdir>:
SYSCALL(chdir)
 39a:	b8 09 00 00 00       	mov    $0x9,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <dup>:
SYSCALL(dup)
 3a2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <getpid>:
SYSCALL(getpid)
 3aa:	b8 0b 00 00 00       	mov    $0xb,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <sbrk>:
SYSCALL(sbrk)
 3b2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sleep>:
SYSCALL(sleep)
 3ba:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <uptime>:
SYSCALL(uptime)
 3c2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <clone>:
SYSCALL(clone)
 3ca:	b8 16 00 00 00       	mov    $0x16,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <texit>:
SYSCALL(texit)
 3d2:	b8 17 00 00 00       	mov    $0x17,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <tsleep>:
SYSCALL(tsleep)
 3da:	b8 18 00 00 00       	mov    $0x18,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <twakeup>:
SYSCALL(twakeup)
 3e2:	b8 19 00 00 00       	mov    $0x19,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <thread_yield>:
SYSCALL(thread_yield)
 3ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <thread_yield3>:
 3f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 18             	sub    $0x18,%esp
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 406:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 40d:	00 
 40e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 411:	89 44 24 04          	mov    %eax,0x4(%esp)
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	89 04 24             	mov    %eax,(%esp)
 41b:	e8 2a ff ff ff       	call   34a <write>
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	56                   	push   %esi
 426:	53                   	push   %ebx
 427:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 431:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 435:	74 17                	je     44e <printint+0x2c>
 437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43b:	79 11                	jns    44e <printint+0x2c>
    neg = 1;
 43d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	f7 d8                	neg    %eax
 449:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44c:	eb 06                	jmp    454 <printint+0x32>
  } else {
    x = xx;
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45e:	8d 41 01             	lea    0x1(%ecx),%eax
 461:	89 45 f4             	mov    %eax,-0xc(%ebp)
 464:	8b 5d 10             	mov    0x10(%ebp),%ebx
 467:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46a:	ba 00 00 00 00       	mov    $0x0,%edx
 46f:	f7 f3                	div    %ebx
 471:	89 d0                	mov    %edx,%eax
 473:	0f b6 80 58 10 00 00 	movzbl 0x1058(%eax),%eax
 47a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47e:	8b 75 10             	mov    0x10(%ebp),%esi
 481:	8b 45 ec             	mov    -0x14(%ebp),%eax
 484:	ba 00 00 00 00       	mov    $0x0,%edx
 489:	f7 f6                	div    %esi
 48b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 492:	75 c7                	jne    45b <printint+0x39>
  if(neg)
 494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 498:	74 10                	je     4aa <printint+0x88>
    buf[i++] = '-';
 49a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49d:	8d 50 01             	lea    0x1(%eax),%edx
 4a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a8:	eb 1f                	jmp    4c9 <printint+0xa7>
 4aa:	eb 1d                	jmp    4c9 <printint+0xa7>
    putc(fd, buf[i]);
 4ac:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	0f b6 00             	movzbl (%eax),%eax
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 31 ff ff ff       	call   3fa <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d1:	79 d9                	jns    4ac <printint+0x8a>
    putc(fd, buf[i]);
}
 4d3:	83 c4 30             	add    $0x30,%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    

000004da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ea:	83 c0 04             	add    $0x4,%eax
 4ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f7:	e9 7c 01 00 00       	jmp    678 <printf+0x19e>
    c = fmt[i] & 0xff;
 4fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 502:	01 d0                	add    %edx,%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	25 ff 00 00 00       	and    $0xff,%eax
 50f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 516:	75 2c                	jne    544 <printf+0x6a>
      if(c == '%'){
 518:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51c:	75 0c                	jne    52a <printf+0x50>
        state = '%';
 51e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 525:	e9 4a 01 00 00       	jmp    674 <printf+0x19a>
      } else {
        putc(fd, c);
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	89 44 24 04          	mov    %eax,0x4(%esp)
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	89 04 24             	mov    %eax,(%esp)
 53a:	e8 bb fe ff ff       	call   3fa <putc>
 53f:	e9 30 01 00 00       	jmp    674 <printf+0x19a>
      }
    } else if(state == '%'){
 544:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 548:	0f 85 26 01 00 00    	jne    674 <printf+0x19a>
      if(c == 'd'){
 54e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 552:	75 2d                	jne    581 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 560:	00 
 561:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 568:	00 
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 aa fe ff ff       	call   422 <printint>
        ap++;
 578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57c:	e9 ec 00 00 00       	jmp    66d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 581:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 585:	74 06                	je     58d <printf+0xb3>
 587:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58b:	75 2d                	jne    5ba <printf+0xe0>
        printint(fd, *ap, 16, 0);
 58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 590:	8b 00                	mov    (%eax),%eax
 592:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 599:	00 
 59a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5a1:	00 
 5a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	89 04 24             	mov    %eax,(%esp)
 5ac:	e8 71 fe ff ff       	call   422 <printint>
        ap++;
 5b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b5:	e9 b3 00 00 00       	jmp    66d <printf+0x193>
      } else if(c == 's'){
 5ba:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5be:	75 45                	jne    605 <printf+0x12b>
        s = (char*)*ap;
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d0:	75 09                	jne    5db <printf+0x101>
          s = "(null)";
 5d2:	c7 45 f4 3e 0c 00 00 	movl   $0xc3e,-0xc(%ebp)
        while(*s != 0){
 5d9:	eb 1e                	jmp    5f9 <printf+0x11f>
 5db:	eb 1c                	jmp    5f9 <printf+0x11f>
          putc(fd, *s);
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 05 fe ff ff       	call   3fa <putc>
          s++;
 5f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	75 da                	jne    5dd <printf+0x103>
 603:	eb 68                	jmp    66d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 605:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 609:	75 1d                	jne    628 <printf+0x14e>
        putc(fd, *ap);
 60b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 d8 fd ff ff       	call   3fa <putc>
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 626:	eb 45                	jmp    66d <printf+0x193>
      } else if(c == '%'){
 628:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62c:	75 17                	jne    645 <printf+0x16b>
        putc(fd, c);
 62e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 631:	0f be c0             	movsbl %al,%eax
 634:	89 44 24 04          	mov    %eax,0x4(%esp)
 638:	8b 45 08             	mov    0x8(%ebp),%eax
 63b:	89 04 24             	mov    %eax,(%esp)
 63e:	e8 b7 fd ff ff       	call   3fa <putc>
 643:	eb 28                	jmp    66d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 645:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 64c:	00 
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 a2 fd ff ff       	call   3fa <putc>
        putc(fd, c);
 658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 8d fd ff ff       	call   3fa <putc>
      }
      state = 0;
 66d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 674:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 678:	8b 55 0c             	mov    0xc(%ebp),%edx
 67b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67e:	01 d0                	add    %edx,%eax
 680:	0f b6 00             	movzbl (%eax),%eax
 683:	84 c0                	test   %al,%al
 685:	0f 85 71 fe ff ff    	jne    4fc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68b:	c9                   	leave  
 68c:	c3                   	ret    

0000068d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
 690:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	83 e8 08             	sub    $0x8,%eax
 699:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	a1 78 10 00 00       	mov    0x1078,%eax
 6a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a4:	eb 24                	jmp    6ca <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ae:	77 12                	ja     6c2 <free+0x35>
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b6:	77 24                	ja     6dc <free+0x4f>
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c0:	77 1a                	ja     6dc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d0:	76 d4                	jbe    6a6 <free+0x19>
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6da:	76 ca                	jbe    6a6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 40 04             	mov    0x4(%eax),%eax
 6e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	01 c2                	add    %eax,%edx
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	39 c2                	cmp    %eax,%edx
 6f5:	75 24                	jne    71b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 50 04             	mov    0x4(%eax),%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	01 c2                	add    %eax,%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	8b 10                	mov    (%eax),%edx
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	89 10                	mov    %edx,(%eax)
 719:	eb 0a                	jmp    725 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 10                	mov    (%eax),%edx
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	01 d0                	add    %edx,%eax
 737:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73a:	75 20                	jne    75c <free+0xcf>
    p->s.size += bp->s.size;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 50 04             	mov    0x4(%eax),%edx
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	8b 10                	mov    (%eax),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	89 10                	mov    %edx,(%eax)
 75a:	eb 08                	jmp    764 <free+0xd7>
  } else
    p->s.ptr = bp;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 762:	89 10                	mov    %edx,(%eax)
  freep = p;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	a3 78 10 00 00       	mov    %eax,0x1078
}
 76c:	c9                   	leave  
 76d:	c3                   	ret    

0000076e <morecore>:

static Header*
morecore(uint nu)
{
 76e:	55                   	push   %ebp
 76f:	89 e5                	mov    %esp,%ebp
 771:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 774:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77b:	77 07                	ja     784 <morecore+0x16>
    nu = 4096;
 77d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	c1 e0 03             	shl    $0x3,%eax
 78a:	89 04 24             	mov    %eax,(%esp)
 78d:	e8 20 fc ff ff       	call   3b2 <sbrk>
 792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 795:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 799:	75 07                	jne    7a2 <morecore+0x34>
    return 0;
 79b:	b8 00 00 00 00       	mov    $0x0,%eax
 7a0:	eb 22                	jmp    7c4 <morecore+0x56>
  hp = (Header*)p;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	8b 55 08             	mov    0x8(%ebp),%edx
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	89 04 24             	mov    %eax,(%esp)
 7ba:	e8 ce fe ff ff       	call   68d <free>
  return freep;
 7bf:	a1 78 10 00 00       	mov    0x1078,%eax
}
 7c4:	c9                   	leave  
 7c5:	c3                   	ret    

000007c6 <malloc>:

void*
malloc(uint nbytes)
{
 7c6:	55                   	push   %ebp
 7c7:	89 e5                	mov    %esp,%ebp
 7c9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	83 c0 07             	add    $0x7,%eax
 7d2:	c1 e8 03             	shr    $0x3,%eax
 7d5:	83 c0 01             	add    $0x1,%eax
 7d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7db:	a1 78 10 00 00       	mov    0x1078,%eax
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e7:	75 23                	jne    80c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e9:	c7 45 f0 70 10 00 00 	movl   $0x1070,-0x10(%ebp)
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	a3 78 10 00 00       	mov    %eax,0x1078
 7f8:	a1 78 10 00 00       	mov    0x1078,%eax
 7fd:	a3 70 10 00 00       	mov    %eax,0x1070
    base.s.size = 0;
 802:	c7 05 74 10 00 00 00 	movl   $0x0,0x1074
 809:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81d:	72 4d                	jb     86c <malloc+0xa6>
      if(p->s.size == nunits)
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 40 04             	mov    0x4(%eax),%eax
 825:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 828:	75 0c                	jne    836 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	89 10                	mov    %edx,(%eax)
 834:	eb 26                	jmp    85c <malloc+0x96>
      else {
        p->s.size -= nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83f:	89 c2                	mov    %eax,%edx
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	c1 e0 03             	shl    $0x3,%eax
 850:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 55 ec             	mov    -0x14(%ebp),%edx
 859:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	a3 78 10 00 00       	mov    %eax,0x1078
      return (void*)(p + 1);
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	83 c0 08             	add    $0x8,%eax
 86a:	eb 38                	jmp    8a4 <malloc+0xde>
    }
    if(p == freep)
 86c:	a1 78 10 00 00       	mov    0x1078,%eax
 871:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 874:	75 1b                	jne    891 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 876:	8b 45 ec             	mov    -0x14(%ebp),%eax
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 ed fe ff ff       	call   76e <morecore>
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
 884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 888:	75 07                	jne    891 <malloc+0xcb>
        return 0;
 88a:	b8 00 00 00 00       	mov    $0x0,%eax
 88f:	eb 13                	jmp    8a4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	89 45 f0             	mov    %eax,-0x10(%ebp)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89f:	e9 70 ff ff ff       	jmp    814 <malloc+0x4e>
}
 8a4:	c9                   	leave  
 8a5:	c3                   	ret    

000008a6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8a6:	55                   	push   %ebp
 8a7:	89 e5                	mov    %esp,%ebp
 8a9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8ac:	8b 55 08             	mov    0x8(%ebp),%edx
 8af:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8b5:	f0 87 02             	lock xchg %eax,(%edx)
 8b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8be:	c9                   	leave  
 8bf:	c3                   	ret    

000008c0 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
 8c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8cc:	5d                   	pop    %ebp
 8cd:	c3                   	ret    

000008ce <lock_acquire>:
void lock_acquire(lock_t *lock){
 8ce:	55                   	push   %ebp
 8cf:	89 e5                	mov    %esp,%ebp
 8d1:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 8d4:	90                   	nop
 8d5:	8b 45 08             	mov    0x8(%ebp),%eax
 8d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8df:	00 
 8e0:	89 04 24             	mov    %eax,(%esp)
 8e3:	e8 be ff ff ff       	call   8a6 <xchg>
 8e8:	85 c0                	test   %eax,%eax
 8ea:	75 e9                	jne    8d5 <lock_acquire+0x7>
}
 8ec:	c9                   	leave  
 8ed:	c3                   	ret    

000008ee <lock_release>:
void lock_release(lock_t *lock){
 8ee:	55                   	push   %ebp
 8ef:	89 e5                	mov    %esp,%ebp
 8f1:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 8f4:	8b 45 08             	mov    0x8(%ebp),%eax
 8f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8fe:	00 
 8ff:	89 04 24             	mov    %eax,(%esp)
 902:	e8 9f ff ff ff       	call   8a6 <xchg>
}
 907:	c9                   	leave  
 908:	c3                   	ret    

00000909 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 909:	55                   	push   %ebp
 90a:	89 e5                	mov    %esp,%ebp
 90c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 90f:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 916:	e8 ab fe ff ff       	call   7c6 <malloc>
 91b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 924:	0f b6 05 7c 10 00 00 	movzbl 0x107c,%eax
 92b:	84 c0                	test   %al,%al
 92d:	75 1c                	jne    94b <thread_create+0x42>
        init_q(thQ2);
 92f:	a1 80 10 00 00       	mov    0x1080,%eax
 934:	89 04 24             	mov    %eax,(%esp)
 937:	e8 db 01 00 00       	call   b17 <init_q>
        inQ++;
 93c:	0f b6 05 7c 10 00 00 	movzbl 0x107c,%eax
 943:	83 c0 01             	add    $0x1,%eax
 946:	a2 7c 10 00 00       	mov    %al,0x107c
    }

    if((uint)stack % 4096){
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	25 ff 0f 00 00       	and    $0xfff,%eax
 953:	85 c0                	test   %eax,%eax
 955:	74 14                	je     96b <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	25 ff 0f 00 00       	and    $0xfff,%eax
 95f:	89 c2                	mov    %eax,%edx
 961:	b8 00 10 00 00       	mov    $0x1000,%eax
 966:	29 d0                	sub    %edx,%eax
 968:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 96b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 96f:	75 1e                	jne    98f <thread_create+0x86>

        printf(1,"malloc fail \n");
 971:	c7 44 24 04 45 0c 00 	movl   $0xc45,0x4(%esp)
 978:	00 
 979:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 980:	e8 55 fb ff ff       	call   4da <printf>
        return 0;
 985:	b8 00 00 00 00       	mov    $0x0,%eax
 98a:	e9 83 00 00 00       	jmp    a12 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 98f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 992:	8b 55 08             	mov    0x8(%ebp),%edx
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 99c:	89 54 24 08          	mov    %edx,0x8(%esp)
 9a0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9a7:	00 
 9a8:	89 04 24             	mov    %eax,(%esp)
 9ab:	e8 1a fa ff ff       	call   3ca <clone>
 9b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 9b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9b7:	79 1b                	jns    9d4 <thread_create+0xcb>
        printf(1,"clone fails\n");
 9b9:	c7 44 24 04 53 0c 00 	movl   $0xc53,0x4(%esp)
 9c0:	00 
 9c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9c8:	e8 0d fb ff ff       	call   4da <printf>
        return 0;
 9cd:	b8 00 00 00 00       	mov    $0x0,%eax
 9d2:	eb 3e                	jmp    a12 <thread_create+0x109>
    }
    if(tid > 0){
 9d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9d8:	7e 19                	jle    9f3 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 9da:	a1 80 10 00 00       	mov    0x1080,%eax
 9df:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9e2:	89 54 24 04          	mov    %edx,0x4(%esp)
 9e6:	89 04 24             	mov    %eax,(%esp)
 9e9:	e8 4b 01 00 00       	call   b39 <add_q>
        return garbage_stack;
 9ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f1:	eb 1f                	jmp    a12 <thread_create+0x109>
    }
    if(tid == 0){
 9f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f7:	75 14                	jne    a0d <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 9f9:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
 a00:	00 
 a01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a08:	e8 cd fa ff ff       	call   4da <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a12:	c9                   	leave  
 a13:	c3                   	ret    

00000a14 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a14:	55                   	push   %ebp
 a15:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a17:	a1 6c 10 00 00       	mov    0x106c,%eax
 a1c:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 a22:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 a27:	a3 6c 10 00 00       	mov    %eax,0x106c
    return (int)(rands % max);
 a2c:	a1 6c 10 00 00       	mov    0x106c,%eax
 a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a34:	ba 00 00 00 00       	mov    $0x0,%edx
 a39:	f7 f1                	div    %ecx
 a3b:	89 d0                	mov    %edx,%eax
}
 a3d:	5d                   	pop    %ebp
 a3e:	c3                   	ret    

00000a3f <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 a3f:	55                   	push   %ebp
 a40:	89 e5                	mov    %esp,%ebp
 a42:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 a45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 a4b:	8b 40 10             	mov    0x10(%eax),%eax
 a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 a51:	a1 80 10 00 00       	mov    0x1080,%eax
 a56:	8b 00                	mov    (%eax),%eax
 a58:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a5f:	89 44 24 08          	mov    %eax,0x8(%esp)
 a63:	c7 44 24 04 71 0c 00 	movl   $0xc71,0x4(%esp)
 a6a:	00 
 a6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a72:	e8 63 fa ff ff       	call   4da <printf>
    add_q(thQ2, tid2);
 a77:	a1 80 10 00 00       	mov    0x1080,%eax
 a7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a7f:	89 54 24 04          	mov    %edx,0x4(%esp)
 a83:	89 04 24             	mov    %eax,(%esp)
 a86:	e8 ae 00 00 00       	call   b39 <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 a8b:	a1 80 10 00 00       	mov    0x1080,%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	89 44 24 08          	mov    %eax,0x8(%esp)
 a96:	c7 44 24 04 89 0c 00 	movl   $0xc89,0x4(%esp)
 a9d:	00 
 a9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aa5:	e8 30 fa ff ff       	call   4da <printf>
    int tidNext = pop_q(thQ2);
 aaa:	a1 80 10 00 00       	mov    0x1080,%eax
 aaf:	89 04 24             	mov    %eax,(%esp)
 ab2:	e8 fc 00 00 00       	call   bb3 <pop_q>
 ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 aba:	eb 10                	jmp    acc <thread_yield2+0x8d>
 abc:	a1 80 10 00 00       	mov    0x1080,%eax
 ac1:	89 04 24             	mov    %eax,(%esp)
 ac4:	e8 ea 00 00 00       	call   bb3 <pop_q>
 ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ad2:	74 e8                	je     abc <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 ad4:	a1 80 10 00 00       	mov    0x1080,%eax
 ad9:	8b 00                	mov    (%eax),%eax
 adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ade:	89 54 24 0c          	mov    %edx,0xc(%esp)
 ae2:	89 44 24 08          	mov    %eax,0x8(%esp)
 ae6:	c7 44 24 04 99 0c 00 	movl   $0xc99,0x4(%esp)
 aed:	00 
 aee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 af5:	e8 e0 f9 ff ff       	call   4da <printf>
    tsleep();
 afa:	e8 db f8 ff ff       	call   3da <tsleep>
    twakeup(tidNext);
 aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b02:	89 04 24             	mov    %eax,(%esp)
 b05:	e8 d8 f8 ff ff       	call   3e2 <twakeup>
    thread_yield3(tidNext);
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	89 04 24             	mov    %eax,(%esp)
 b10:	e8 dd f8 ff ff       	call   3f2 <thread_yield3>
    //yield();
 b15:	c9                   	leave  
 b16:	c3                   	ret    

00000b17 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 b17:	55                   	push   %ebp
 b18:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 b1a:	8b 45 08             	mov    0x8(%ebp),%eax
 b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 b23:	8b 45 08             	mov    0x8(%ebp),%eax
 b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 b2d:	8b 45 08             	mov    0x8(%ebp),%eax
 b30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 b37:	5d                   	pop    %ebp
 b38:	c3                   	ret    

00000b39 <add_q>:

void add_q(struct queue *q, int v){
 b39:	55                   	push   %ebp
 b3a:	89 e5                	mov    %esp,%ebp
 b3c:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 b3f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b46:	e8 7b fc ff ff       	call   7c6 <malloc>
 b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
 b5e:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b60:	8b 45 08             	mov    0x8(%ebp),%eax
 b63:	8b 40 04             	mov    0x4(%eax),%eax
 b66:	85 c0                	test   %eax,%eax
 b68:	75 0b                	jne    b75 <add_q+0x3c>
        q->head = n;
 b6a:	8b 45 08             	mov    0x8(%ebp),%eax
 b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b70:	89 50 04             	mov    %edx,0x4(%eax)
 b73:	eb 0c                	jmp    b81 <add_q+0x48>
    }else{
        q->tail->next = n;
 b75:	8b 45 08             	mov    0x8(%ebp),%eax
 b78:	8b 40 08             	mov    0x8(%eax),%eax
 b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b7e:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b81:	8b 45 08             	mov    0x8(%ebp),%eax
 b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b87:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b8a:	8b 45 08             	mov    0x8(%ebp),%eax
 b8d:	8b 00                	mov    (%eax),%eax
 b8f:	8d 50 01             	lea    0x1(%eax),%edx
 b92:	8b 45 08             	mov    0x8(%ebp),%eax
 b95:	89 10                	mov    %edx,(%eax)
}
 b97:	c9                   	leave  
 b98:	c3                   	ret    

00000b99 <empty_q>:

int empty_q(struct queue *q){
 b99:	55                   	push   %ebp
 b9a:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b9c:	8b 45 08             	mov    0x8(%ebp),%eax
 b9f:	8b 00                	mov    (%eax),%eax
 ba1:	85 c0                	test   %eax,%eax
 ba3:	75 07                	jne    bac <empty_q+0x13>
        return 1;
 ba5:	b8 01 00 00 00       	mov    $0x1,%eax
 baa:	eb 05                	jmp    bb1 <empty_q+0x18>
    else
        return 0;
 bac:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 bb1:	5d                   	pop    %ebp
 bb2:	c3                   	ret    

00000bb3 <pop_q>:
int pop_q(struct queue *q){
 bb3:	55                   	push   %ebp
 bb4:	89 e5                	mov    %esp,%ebp
 bb6:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 bb9:	8b 45 08             	mov    0x8(%ebp),%eax
 bbc:	89 04 24             	mov    %eax,(%esp)
 bbf:	e8 d5 ff ff ff       	call   b99 <empty_q>
 bc4:	85 c0                	test   %eax,%eax
 bc6:	75 5d                	jne    c25 <pop_q+0x72>
       val = q->head->value; 
 bc8:	8b 45 08             	mov    0x8(%ebp),%eax
 bcb:	8b 40 04             	mov    0x4(%eax),%eax
 bce:	8b 00                	mov    (%eax),%eax
 bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 bd3:	8b 45 08             	mov    0x8(%ebp),%eax
 bd6:	8b 40 04             	mov    0x4(%eax),%eax
 bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 bdc:	8b 45 08             	mov    0x8(%ebp),%eax
 bdf:	8b 40 04             	mov    0x4(%eax),%eax
 be2:	8b 50 04             	mov    0x4(%eax),%edx
 be5:	8b 45 08             	mov    0x8(%ebp),%eax
 be8:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bee:	89 04 24             	mov    %eax,(%esp)
 bf1:	e8 97 fa ff ff       	call   68d <free>
       q->size--;
 bf6:	8b 45 08             	mov    0x8(%ebp),%eax
 bf9:	8b 00                	mov    (%eax),%eax
 bfb:	8d 50 ff             	lea    -0x1(%eax),%edx
 bfe:	8b 45 08             	mov    0x8(%ebp),%eax
 c01:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 c03:	8b 45 08             	mov    0x8(%ebp),%eax
 c06:	8b 00                	mov    (%eax),%eax
 c08:	85 c0                	test   %eax,%eax
 c0a:	75 14                	jne    c20 <pop_q+0x6d>
            q->head = 0;
 c0c:	8b 45 08             	mov    0x8(%ebp),%eax
 c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 c16:	8b 45 08             	mov    0x8(%ebp),%eax
 c19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c23:	eb 05                	jmp    c2a <pop_q+0x77>
    }
    return -1;
 c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 c2a:	c9                   	leave  
 c2b:	c3                   	ret    
