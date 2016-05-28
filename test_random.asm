
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
  10:	e8 b9 09 00 00       	call   9ce <random>
  15:	89 44 24 08          	mov    %eax,0x8(%esp)
  19:	c7 44 24 04 0e 0b 00 	movl   $0xb0e,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 a5 04 00 00       	call   4d2 <printf>
    printf(1,"random number %d\n",random(100));
  2d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  34:	e8 95 09 00 00       	call   9ce <random>
  39:	89 44 24 08          	mov    %eax,0x8(%esp)
  3d:	c7 44 24 04 0e 0b 00 	movl   $0xb0e,0x4(%esp)
  44:	00 
  45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4c:	e8 81 04 00 00       	call   4d2 <printf>
    printf(1,"random number %d\n",random(100));
  51:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  58:	e8 71 09 00 00       	call   9ce <random>
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 0e 0b 00 	movl   $0xb0e,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 5d 04 00 00       	call   4d2 <printf>
    printf(1,"random number %d\n",random(100));
  75:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  7c:	e8 4d 09 00 00       	call   9ce <random>
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	c7 44 24 04 0e 0b 00 	movl   $0xb0e,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 39 04 00 00       	call   4d2 <printf>
    printf(1,"random number %d\n",random(100));
  99:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  a0:	e8 29 09 00 00       	call   9ce <random>
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	c7 44 24 04 0e 0b 00 	movl   $0xb0e,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 15 04 00 00       	call   4d2 <printf>

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

000003f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 18             	sub    $0x18,%esp
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 405:	00 
 406:	8d 45 f4             	lea    -0xc(%ebp),%eax
 409:	89 44 24 04          	mov    %eax,0x4(%esp)
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	89 04 24             	mov    %eax,(%esp)
 413:	e8 32 ff ff ff       	call   34a <write>
}
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	56                   	push   %esi
 41e:	53                   	push   %ebx
 41f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 422:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 429:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42d:	74 17                	je     446 <printint+0x2c>
 42f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 433:	79 11                	jns    446 <printint+0x2c>
    neg = 1;
 435:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	f7 d8                	neg    %eax
 441:	89 45 ec             	mov    %eax,-0x14(%ebp)
 444:	eb 06                	jmp    44c <printint+0x32>
  } else {
    x = xx;
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 453:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 456:	8d 41 01             	lea    0x1(%ecx),%eax
 459:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 462:	ba 00 00 00 00       	mov    $0x0,%edx
 467:	f7 f3                	div    %ebx
 469:	89 d0                	mov    %edx,%eax
 46b:	0f b6 80 d8 0e 00 00 	movzbl 0xed8(%eax),%eax
 472:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 476:	8b 75 10             	mov    0x10(%ebp),%esi
 479:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47c:	ba 00 00 00 00       	mov    $0x0,%edx
 481:	f7 f6                	div    %esi
 483:	89 45 ec             	mov    %eax,-0x14(%ebp)
 486:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48a:	75 c7                	jne    453 <printint+0x39>
  if(neg)
 48c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 490:	74 10                	je     4a2 <printint+0x88>
    buf[i++] = '-';
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	8d 50 01             	lea    0x1(%eax),%edx
 498:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a0:	eb 1f                	jmp    4c1 <printint+0xa7>
 4a2:	eb 1d                	jmp    4c1 <printint+0xa7>
    putc(fd, buf[i]);
 4a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	89 04 24             	mov    %eax,(%esp)
 4bc:	e8 31 ff ff ff       	call   3f2 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c9:	79 d9                	jns    4a4 <printint+0x8a>
    putc(fd, buf[i]);
}
 4cb:	83 c4 30             	add    $0x30,%esp
 4ce:	5b                   	pop    %ebx
 4cf:	5e                   	pop    %esi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    

000004d2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4df:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e2:	83 c0 04             	add    $0x4,%eax
 4e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ef:	e9 7c 01 00 00       	jmp    670 <printf+0x19e>
    c = fmt[i] & 0xff;
 4f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	25 ff 00 00 00       	and    $0xff,%eax
 507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50e:	75 2c                	jne    53c <printf+0x6a>
      if(c == '%'){
 510:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 514:	75 0c                	jne    522 <printf+0x50>
        state = '%';
 516:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51d:	e9 4a 01 00 00       	jmp    66c <printf+0x19a>
      } else {
        putc(fd, c);
 522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	89 44 24 04          	mov    %eax,0x4(%esp)
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	89 04 24             	mov    %eax,(%esp)
 532:	e8 bb fe ff ff       	call   3f2 <putc>
 537:	e9 30 01 00 00       	jmp    66c <printf+0x19a>
      }
    } else if(state == '%'){
 53c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 540:	0f 85 26 01 00 00    	jne    66c <printf+0x19a>
      if(c == 'd'){
 546:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54a:	75 2d                	jne    579 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 558:	00 
 559:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 560:	00 
 561:	89 44 24 04          	mov    %eax,0x4(%esp)
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	89 04 24             	mov    %eax,(%esp)
 56b:	e8 aa fe ff ff       	call   41a <printint>
        ap++;
 570:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 574:	e9 ec 00 00 00       	jmp    665 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 579:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57d:	74 06                	je     585 <printf+0xb3>
 57f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 583:	75 2d                	jne    5b2 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 591:	00 
 592:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 599:	00 
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 71 fe ff ff       	call   41a <printint>
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	e9 b3 00 00 00       	jmp    665 <printf+0x193>
      } else if(c == 's'){
 5b2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b6:	75 45                	jne    5fd <printf+0x12b>
        s = (char*)*ap;
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c8:	75 09                	jne    5d3 <printf+0x101>
          s = "(null)";
 5ca:	c7 45 f4 20 0b 00 00 	movl   $0xb20,-0xc(%ebp)
        while(*s != 0){
 5d1:	eb 1e                	jmp    5f1 <printf+0x11f>
 5d3:	eb 1c                	jmp    5f1 <printf+0x11f>
          putc(fd, *s);
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	89 04 24             	mov    %eax,(%esp)
 5e8:	e8 05 fe ff ff       	call   3f2 <putc>
          s++;
 5ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	84 c0                	test   %al,%al
 5f9:	75 da                	jne    5d5 <printf+0x103>
 5fb:	eb 68                	jmp    665 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 601:	75 1d                	jne    620 <printf+0x14e>
        putc(fd, *ap);
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 d8 fd ff ff       	call   3f2 <putc>
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	eb 45                	jmp    665 <printf+0x193>
      } else if(c == '%'){
 620:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 624:	75 17                	jne    63d <printf+0x16b>
        putc(fd, c);
 626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 b7 fd ff ff       	call   3f2 <putc>
 63b:	eb 28                	jmp    665 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 644:	00 
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	89 04 24             	mov    %eax,(%esp)
 64b:	e8 a2 fd ff ff       	call   3f2 <putc>
        putc(fd, c);
 650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 8d fd ff ff       	call   3f2 <putc>
      }
      state = 0;
 665:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 670:	8b 55 0c             	mov    0xc(%ebp),%edx
 673:	8b 45 f0             	mov    -0x10(%ebp),%eax
 676:	01 d0                	add    %edx,%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	84 c0                	test   %al,%al
 67d:	0f 85 71 fe ff ff    	jne    4f4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	83 e8 08             	sub    $0x8,%eax
 691:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	a1 f8 0e 00 00       	mov    0xef8,%eax
 699:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69c:	eb 24                	jmp    6c2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a6:	77 12                	ja     6ba <free+0x35>
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ae:	77 24                	ja     6d4 <free+0x4f>
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b8:	77 1a                	ja     6d4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c8:	76 d4                	jbe    69e <free+0x19>
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d2:	76 ca                	jbe    69e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 40 04             	mov    0x4(%eax),%eax
 6da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	39 c2                	cmp    %eax,%edx
 6ed:	75 24                	jne    713 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	8b 10                	mov    (%eax),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	89 10                	mov    %edx,(%eax)
 711:	eb 0a                	jmp    71d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	01 d0                	add    %edx,%eax
 72f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 732:	75 20                	jne    754 <free+0xcf>
    p->s.size += bp->s.size;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 50 04             	mov    0x4(%eax),%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 40 04             	mov    0x4(%eax),%eax
 740:	01 c2                	add    %eax,%edx
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 748:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74b:	8b 10                	mov    (%eax),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	89 10                	mov    %edx,(%eax)
 752:	eb 08                	jmp    75c <free+0xd7>
  } else
    p->s.ptr = bp;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75a:	89 10                	mov    %edx,(%eax)
  freep = p;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	a3 f8 0e 00 00       	mov    %eax,0xef8
}
 764:	c9                   	leave  
 765:	c3                   	ret    

00000766 <morecore>:

static Header*
morecore(uint nu)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 773:	77 07                	ja     77c <morecore+0x16>
    nu = 4096;
 775:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	c1 e0 03             	shl    $0x3,%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 28 fc ff ff       	call   3b2 <sbrk>
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 791:	75 07                	jne    79a <morecore+0x34>
    return 0;
 793:	b8 00 00 00 00       	mov    $0x0,%eax
 798:	eb 22                	jmp    7bc <morecore+0x56>
  hp = (Header*)p;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	8b 55 08             	mov    0x8(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	83 c0 08             	add    $0x8,%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 ce fe ff ff       	call   685 <free>
  return freep;
 7b7:	a1 f8 0e 00 00       	mov    0xef8,%eax
}
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    

000007be <malloc>:

void*
malloc(uint nbytes)
{
 7be:	55                   	push   %ebp
 7bf:	89 e5                	mov    %esp,%ebp
 7c1:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	83 c0 07             	add    $0x7,%eax
 7ca:	c1 e8 03             	shr    $0x3,%eax
 7cd:	83 c0 01             	add    $0x1,%eax
 7d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d3:	a1 f8 0e 00 00       	mov    0xef8,%eax
 7d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7df:	75 23                	jne    804 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e1:	c7 45 f0 f0 0e 00 00 	movl   $0xef0,-0x10(%ebp)
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 f8 0e 00 00       	mov    %eax,0xef8
 7f0:	a1 f8 0e 00 00       	mov    0xef8,%eax
 7f5:	a3 f0 0e 00 00       	mov    %eax,0xef0
    base.s.size = 0;
 7fa:	c7 05 f4 0e 00 00 00 	movl   $0x0,0xef4
 801:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 815:	72 4d                	jb     864 <malloc+0xa6>
      if(p->s.size == nunits)
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 820:	75 0c                	jne    82e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 10                	mov    (%eax),%edx
 827:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82a:	89 10                	mov    %edx,(%eax)
 82c:	eb 26                	jmp    854 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	2b 45 ec             	sub    -0x14(%ebp),%eax
 837:	89 c2                	mov    %eax,%edx
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	c1 e0 03             	shl    $0x3,%eax
 848:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 851:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	a3 f8 0e 00 00       	mov    %eax,0xef8
      return (void*)(p + 1);
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	83 c0 08             	add    $0x8,%eax
 862:	eb 38                	jmp    89c <malloc+0xde>
    }
    if(p == freep)
 864:	a1 f8 0e 00 00       	mov    0xef8,%eax
 869:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86c:	75 1b                	jne    889 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 86e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 871:	89 04 24             	mov    %eax,(%esp)
 874:	e8 ed fe ff ff       	call   766 <morecore>
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 880:	75 07                	jne    889 <malloc+0xcb>
        return 0;
 882:	b8 00 00 00 00       	mov    $0x0,%eax
 887:	eb 13                	jmp    89c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 897:	e9 70 ff ff ff       	jmp    80c <malloc+0x4e>
}
 89c:	c9                   	leave  
 89d:	c3                   	ret    

0000089e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 89e:	55                   	push   %ebp
 89f:	89 e5                	mov    %esp,%ebp
 8a1:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8a4:	8b 55 08             	mov    0x8(%ebp),%edx
 8a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8ad:	f0 87 02             	lock xchg %eax,(%edx)
 8b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8b6:	c9                   	leave  
 8b7:	c3                   	ret    

000008b8 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 8b8:	55                   	push   %ebp
 8b9:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8c4:	5d                   	pop    %ebp
 8c5:	c3                   	ret    

000008c6 <lock_acquire>:
void lock_acquire(lock_t *lock){
 8c6:	55                   	push   %ebp
 8c7:	89 e5                	mov    %esp,%ebp
 8c9:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 8cc:	90                   	nop
 8cd:	8b 45 08             	mov    0x8(%ebp),%eax
 8d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8d7:	00 
 8d8:	89 04 24             	mov    %eax,(%esp)
 8db:	e8 be ff ff ff       	call   89e <xchg>
 8e0:	85 c0                	test   %eax,%eax
 8e2:	75 e9                	jne    8cd <lock_acquire+0x7>
}
 8e4:	c9                   	leave  
 8e5:	c3                   	ret    

000008e6 <lock_release>:
void lock_release(lock_t *lock){
 8e6:	55                   	push   %ebp
 8e7:	89 e5                	mov    %esp,%ebp
 8e9:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8f6:	00 
 8f7:	89 04 24             	mov    %eax,(%esp)
 8fa:	e8 9f ff ff ff       	call   89e <xchg>
}
 8ff:	c9                   	leave  
 900:	c3                   	ret    

00000901 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 901:	55                   	push   %ebp
 902:	89 e5                	mov    %esp,%ebp
 904:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 907:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 90e:	e8 ab fe ff ff       	call   7be <malloc>
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 91c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91f:	25 ff 0f 00 00       	and    $0xfff,%eax
 924:	85 c0                	test   %eax,%eax
 926:	74 14                	je     93c <thread_create+0x3b>
        stack = stack + (4096 - (uint)stack % 4096);
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	25 ff 0f 00 00       	and    $0xfff,%eax
 930:	89 c2                	mov    %eax,%edx
 932:	b8 00 10 00 00       	mov    $0x1000,%eax
 937:	29 d0                	sub    %edx,%eax
 939:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 93c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 940:	75 1b                	jne    95d <thread_create+0x5c>

        printf(1,"malloc fail \n");
 942:	c7 44 24 04 27 0b 00 	movl   $0xb27,0x4(%esp)
 949:	00 
 94a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 951:	e8 7c fb ff ff       	call   4d2 <printf>
        return 0;
 956:	b8 00 00 00 00       	mov    $0x0,%eax
 95b:	eb 6f                	jmp    9cc <thread_create+0xcb>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 95d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 960:	8b 55 08             	mov    0x8(%ebp),%edx
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 96a:	89 54 24 08          	mov    %edx,0x8(%esp)
 96e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 975:	00 
 976:	89 04 24             	mov    %eax,(%esp)
 979:	e8 4c fa ff ff       	call   3ca <clone>
 97e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 981:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 985:	79 1b                	jns    9a2 <thread_create+0xa1>
        printf(1,"clone fails\n");
 987:	c7 44 24 04 35 0b 00 	movl   $0xb35,0x4(%esp)
 98e:	00 
 98f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 996:	e8 37 fb ff ff       	call   4d2 <printf>
        return 0;
 99b:	b8 00 00 00 00       	mov    $0x0,%eax
 9a0:	eb 2a                	jmp    9cc <thread_create+0xcb>
    }
    if(tid > 0){
 9a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a6:	7e 05                	jle    9ad <thread_create+0xac>
        //store threads on thread table
        return garbage_stack;
 9a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ab:	eb 1f                	jmp    9cc <thread_create+0xcb>
    }
    if(tid == 0){
 9ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9b1:	75 14                	jne    9c7 <thread_create+0xc6>
        printf(1,"tid = 0 return \n");
 9b3:	c7 44 24 04 42 0b 00 	movl   $0xb42,0x4(%esp)
 9ba:	00 
 9bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9c2:	e8 0b fb ff ff       	call   4d2 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9cc:	c9                   	leave  
 9cd:	c3                   	ret    

000009ce <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 9ce:	55                   	push   %ebp
 9cf:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 9d1:	a1 ec 0e 00 00       	mov    0xeec,%eax
 9d6:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 9dc:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 9e1:	a3 ec 0e 00 00       	mov    %eax,0xeec
    return (int)(rands % max);
 9e6:	a1 ec 0e 00 00       	mov    0xeec,%eax
 9eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9ee:	ba 00 00 00 00       	mov    $0x0,%edx
 9f3:	f7 f1                	div    %ecx
 9f5:	89 d0                	mov    %edx,%eax
}
 9f7:	5d                   	pop    %ebp
 9f8:	c3                   	ret    

000009f9 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 9f9:	55                   	push   %ebp
 9fa:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 9fc:	8b 45 08             	mov    0x8(%ebp),%eax
 9ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a05:	8b 45 08             	mov    0x8(%ebp),%eax
 a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a0f:	8b 45 08             	mov    0x8(%ebp),%eax
 a12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a19:	5d                   	pop    %ebp
 a1a:	c3                   	ret    

00000a1b <add_q>:

void add_q(struct queue *q, int v){
 a1b:	55                   	push   %ebp
 a1c:	89 e5                	mov    %esp,%ebp
 a1e:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a21:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a28:	e8 91 fd ff ff       	call   7be <malloc>
 a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
 a40:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a42:	8b 45 08             	mov    0x8(%ebp),%eax
 a45:	8b 40 04             	mov    0x4(%eax),%eax
 a48:	85 c0                	test   %eax,%eax
 a4a:	75 0b                	jne    a57 <add_q+0x3c>
        q->head = n;
 a4c:	8b 45 08             	mov    0x8(%ebp),%eax
 a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a52:	89 50 04             	mov    %edx,0x4(%eax)
 a55:	eb 0c                	jmp    a63 <add_q+0x48>
    }else{
        q->tail->next = n;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	8b 40 08             	mov    0x8(%eax),%eax
 a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a60:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a63:	8b 45 08             	mov    0x8(%ebp),%eax
 a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a69:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a6c:	8b 45 08             	mov    0x8(%ebp),%eax
 a6f:	8b 00                	mov    (%eax),%eax
 a71:	8d 50 01             	lea    0x1(%eax),%edx
 a74:	8b 45 08             	mov    0x8(%ebp),%eax
 a77:	89 10                	mov    %edx,(%eax)
}
 a79:	c9                   	leave  
 a7a:	c3                   	ret    

00000a7b <empty_q>:

int empty_q(struct queue *q){
 a7b:	55                   	push   %ebp
 a7c:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a7e:	8b 45 08             	mov    0x8(%ebp),%eax
 a81:	8b 00                	mov    (%eax),%eax
 a83:	85 c0                	test   %eax,%eax
 a85:	75 07                	jne    a8e <empty_q+0x13>
        return 1;
 a87:	b8 01 00 00 00       	mov    $0x1,%eax
 a8c:	eb 05                	jmp    a93 <empty_q+0x18>
    else
        return 0;
 a8e:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a93:	5d                   	pop    %ebp
 a94:	c3                   	ret    

00000a95 <pop_q>:
int pop_q(struct queue *q){
 a95:	55                   	push   %ebp
 a96:	89 e5                	mov    %esp,%ebp
 a98:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 a9b:	8b 45 08             	mov    0x8(%ebp),%eax
 a9e:	89 04 24             	mov    %eax,(%esp)
 aa1:	e8 d5 ff ff ff       	call   a7b <empty_q>
 aa6:	85 c0                	test   %eax,%eax
 aa8:	75 5d                	jne    b07 <pop_q+0x72>
       val = q->head->value; 
 aaa:	8b 45 08             	mov    0x8(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	8b 00                	mov    (%eax),%eax
 ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 ab5:	8b 45 08             	mov    0x8(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 abe:	8b 45 08             	mov    0x8(%ebp),%eax
 ac1:	8b 40 04             	mov    0x4(%eax),%eax
 ac4:	8b 50 04             	mov    0x4(%eax),%edx
 ac7:	8b 45 08             	mov    0x8(%ebp),%eax
 aca:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad0:	89 04 24             	mov    %eax,(%esp)
 ad3:	e8 ad fb ff ff       	call   685 <free>
       q->size--;
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	8d 50 ff             	lea    -0x1(%eax),%edx
 ae0:	8b 45 08             	mov    0x8(%ebp),%eax
 ae3:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 ae5:	8b 45 08             	mov    0x8(%ebp),%eax
 ae8:	8b 00                	mov    (%eax),%eax
 aea:	85 c0                	test   %eax,%eax
 aec:	75 14                	jne    b02 <pop_q+0x6d>
            q->head = 0;
 aee:	8b 45 08             	mov    0x8(%ebp),%eax
 af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b05:	eb 05                	jmp    b0c <pop_q+0x77>
    }
    return -1;
 b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b0c:	c9                   	leave  
 b0d:	c3                   	ret    
