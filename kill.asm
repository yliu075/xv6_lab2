
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 d1 0b 00 	movl   $0xbd1,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 5c 04 00 00       	call   47f <printf>
    exit();
  23:	e8 a7 02 00 00       	call   2cf <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f1 01 00 00       	call   23d <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 ab 02 00 00       	call   2ff <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 68 02 00 00       	call   2cf <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  98:	90                   	nop
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	89 55 08             	mov    %edx,0x8(%ebp)
  a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ab:	0f b6 12             	movzbl (%edx),%edx
  ae:	88 10                	mov    %dl,(%eax)
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	84 c0                	test   %al,%al
  b5:	75 e2                	jne    99 <strcpy+0xd>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	29 c2                	sub    %eax,%edx
  f7:	89 d0                	mov    %edx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 04                	jmp    10e <strlen+0x13>
 10a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ed                	jne    10a <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 26 ff ff ff       	call   67 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 186:	eb 4c                	jmp    1d4 <gets+0x5b>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 44 01 00 00       	call   2e7 <read>
 1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1aa:	7f 02                	jg     1ae <gets+0x35>
      break;
 1ac:	eb 31                	jmp    1df <gets+0x66>
    buf[i++] = c;
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	8d 50 01             	lea    0x1(%eax),%edx
 1b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b7:	89 c2                	mov    %eax,%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 c2                	add    %eax,%edx
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 13                	je     1df <gets+0x66>
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	74 0b                	je     1df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dd:	7c a9                	jl     188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fc:	00 
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	89 04 24             	mov    %eax,(%esp)
 203:	e8 07 01 00 00       	call   30f <open>
 208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20f:	79 07                	jns    218 <stat+0x29>
    return -1;
 211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 216:	eb 23                	jmp    23b <stat+0x4c>
  r = fstat(fd, st);
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	89 44 24 04          	mov    %eax,0x4(%esp)
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 fd 00 00 00       	call   327 <fstat>
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 bf 00 00 00       	call   2f7 <close>
  return r;
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	c1 e0 02             	shl    $0x2,%eax
 254:	01 d0                	add    %edx,%eax
 256:	01 c0                	add    %eax,%eax
 258:	89 c1                	mov    %eax,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 08             	mov    %edx,0x8(%ebp)
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f be c0             	movsbl %al,%eax
 269:	01 c8                	add    %ecx,%eax
 26b:	83 e8 30             	sub    $0x30,%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 0a                	jle    285 <atoi+0x48>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	3c 39                	cmp    $0x39,%al
 283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getpid>:
SYSCALL(getpid)
 34f:	b8 0b 00 00 00       	mov    $0xb,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <clone>:
SYSCALL(clone)
 36f:	b8 16 00 00 00       	mov    $0x16,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <texit>:
SYSCALL(texit)
 377:	b8 17 00 00 00       	mov    $0x17,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <tsleep>:
SYSCALL(tsleep)
 37f:	b8 18 00 00 00       	mov    $0x18,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <twakeup>:
SYSCALL(twakeup)
 387:	b8 19 00 00 00       	mov    $0x19,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <thread_yield>:
SYSCALL(thread_yield)
 38f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <thread_yield3>:
 397:	b8 1a 00 00 00       	mov    $0x1a,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 18             	sub    $0x18,%esp
 3a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b2:	00 
 3b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	89 04 24             	mov    %eax,(%esp)
 3c0:	e8 2a ff ff ff       	call   2ef <write>
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	56                   	push   %esi
 3cb:	53                   	push   %ebx
 3cc:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3da:	74 17                	je     3f3 <printint+0x2c>
 3dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e0:	79 11                	jns    3f3 <printint+0x2c>
    neg = 1;
 3e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	f7 d8                	neg    %eax
 3ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f1:	eb 06                	jmp    3f9 <printint+0x32>
  } else {
    x = xx;
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 400:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 403:	8d 41 01             	lea    0x1(%ecx),%eax
 406:	89 45 f4             	mov    %eax,-0xc(%ebp)
 409:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
 414:	f7 f3                	div    %ebx
 416:	89 d0                	mov    %edx,%eax
 418:	0f b6 80 fc 0f 00 00 	movzbl 0xffc(%eax),%eax
 41f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 423:	8b 75 10             	mov    0x10(%ebp),%esi
 426:	8b 45 ec             	mov    -0x14(%ebp),%eax
 429:	ba 00 00 00 00       	mov    $0x0,%edx
 42e:	f7 f6                	div    %esi
 430:	89 45 ec             	mov    %eax,-0x14(%ebp)
 433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 437:	75 c7                	jne    400 <printint+0x39>
  if(neg)
 439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43d:	74 10                	je     44f <printint+0x88>
    buf[i++] = '-';
 43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 442:	8d 50 01             	lea    0x1(%eax),%edx
 445:	89 55 f4             	mov    %edx,-0xc(%ebp)
 448:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44d:	eb 1f                	jmp    46e <printint+0xa7>
 44f:	eb 1d                	jmp    46e <printint+0xa7>
    putc(fd, buf[i]);
 451:	8d 55 dc             	lea    -0x24(%ebp),%edx
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	01 d0                	add    %edx,%eax
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	89 44 24 04          	mov    %eax,0x4(%esp)
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	89 04 24             	mov    %eax,(%esp)
 469:	e8 31 ff ff ff       	call   39f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 476:	79 d9                	jns    451 <printint+0x8a>
    putc(fd, buf[i]);
}
 478:	83 c4 30             	add    $0x30,%esp
 47b:	5b                   	pop    %ebx
 47c:	5e                   	pop    %esi
 47d:	5d                   	pop    %ebp
 47e:	c3                   	ret    

0000047f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48c:	8d 45 0c             	lea    0xc(%ebp),%eax
 48f:	83 c0 04             	add    $0x4,%eax
 492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49c:	e9 7c 01 00 00       	jmp    61d <printf+0x19e>
    c = fmt[i] & 0xff;
 4a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	0f b6 00             	movzbl (%eax),%eax
 4ac:	0f be c0             	movsbl %al,%eax
 4af:	25 ff 00 00 00       	and    $0xff,%eax
 4b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bb:	75 2c                	jne    4e9 <printf+0x6a>
      if(c == '%'){
 4bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c1:	75 0c                	jne    4cf <printf+0x50>
        state = '%';
 4c3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ca:	e9 4a 01 00 00       	jmp    619 <printf+0x19a>
      } else {
        putc(fd, c);
 4cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d2:	0f be c0             	movsbl %al,%eax
 4d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	89 04 24             	mov    %eax,(%esp)
 4df:	e8 bb fe ff ff       	call   39f <putc>
 4e4:	e9 30 01 00 00       	jmp    619 <printf+0x19a>
      }
    } else if(state == '%'){
 4e9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ed:	0f 85 26 01 00 00    	jne    619 <printf+0x19a>
      if(c == 'd'){
 4f3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f7:	75 2d                	jne    526 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 505:	00 
 506:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 50d:	00 
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 aa fe ff ff       	call   3c7 <printint>
        ap++;
 51d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 521:	e9 ec 00 00 00       	jmp    612 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 526:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 52a:	74 06                	je     532 <printf+0xb3>
 52c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 530:	75 2d                	jne    55f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 532:	8b 45 e8             	mov    -0x18(%ebp),%eax
 535:	8b 00                	mov    (%eax),%eax
 537:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 53e:	00 
 53f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 546:	00 
 547:	89 44 24 04          	mov    %eax,0x4(%esp)
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	89 04 24             	mov    %eax,(%esp)
 551:	e8 71 fe ff ff       	call   3c7 <printint>
        ap++;
 556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55a:	e9 b3 00 00 00       	jmp    612 <printf+0x193>
      } else if(c == 's'){
 55f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 563:	75 45                	jne    5aa <printf+0x12b>
        s = (char*)*ap;
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 575:	75 09                	jne    580 <printf+0x101>
          s = "(null)";
 577:	c7 45 f4 e5 0b 00 00 	movl   $0xbe5,-0xc(%ebp)
        while(*s != 0){
 57e:	eb 1e                	jmp    59e <printf+0x11f>
 580:	eb 1c                	jmp    59e <printf+0x11f>
          putc(fd, *s);
 582:	8b 45 f4             	mov    -0xc(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 05 fe ff ff       	call   39f <putc>
          s++;
 59a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a1:	0f b6 00             	movzbl (%eax),%eax
 5a4:	84 c0                	test   %al,%al
 5a6:	75 da                	jne    582 <printf+0x103>
 5a8:	eb 68                	jmp    612 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ae:	75 1d                	jne    5cd <printf+0x14e>
        putc(fd, *ap);
 5b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b3:	8b 00                	mov    (%eax),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 d8 fd ff ff       	call   39f <putc>
        ap++;
 5c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cb:	eb 45                	jmp    612 <printf+0x193>
      } else if(c == '%'){
 5cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d1:	75 17                	jne    5ea <printf+0x16b>
        putc(fd, c);
 5d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	89 04 24             	mov    %eax,(%esp)
 5e3:	e8 b7 fd ff ff       	call   39f <putc>
 5e8:	eb 28                	jmp    612 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ea:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f1:	00 
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	89 04 24             	mov    %eax,(%esp)
 5f8:	e8 a2 fd ff ff       	call   39f <putc>
        putc(fd, c);
 5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	89 44 24 04          	mov    %eax,0x4(%esp)
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	89 04 24             	mov    %eax,(%esp)
 60d:	e8 8d fd ff ff       	call   39f <putc>
      }
      state = 0;
 612:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 619:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61d:	8b 55 0c             	mov    0xc(%ebp),%edx
 620:	8b 45 f0             	mov    -0x10(%ebp),%eax
 623:	01 d0                	add    %edx,%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	84 c0                	test   %al,%al
 62a:	0f 85 71 fe ff ff    	jne    4a1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 630:	c9                   	leave  
 631:	c3                   	ret    

00000632 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 638:	8b 45 08             	mov    0x8(%ebp),%eax
 63b:	83 e8 08             	sub    $0x8,%eax
 63e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 1c 10 00 00       	mov    0x101c,%eax
 646:	89 45 fc             	mov    %eax,-0x4(%ebp)
 649:	eb 24                	jmp    66f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 653:	77 12                	ja     667 <free+0x35>
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	77 24                	ja     681 <free+0x4f>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	77 1a                	ja     681 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 675:	76 d4                	jbe    64b <free+0x19>
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67f:	76 ca                	jbe    64b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	39 c2                	cmp    %eax,%edx
 69a:	75 24                	jne    6c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 50 04             	mov    0x4(%eax),%edx
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	01 c2                	add    %eax,%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	8b 10                	mov    (%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	89 10                	mov    %edx,(%eax)
 6be:	eb 0a                	jmp    6ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 10                	mov    (%eax),%edx
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 40 04             	mov    0x4(%eax),%eax
 6d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	01 d0                	add    %edx,%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	75 20                	jne    701 <free+0xcf>
    p->s.size += bp->s.size;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 50 04             	mov    0x4(%eax),%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	8b 40 04             	mov    0x4(%eax),%eax
 6ed:	01 c2                	add    %eax,%edx
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 10                	mov    %edx,(%eax)
 6ff:	eb 08                	jmp    709 <free+0xd7>
  } else
    p->s.ptr = bp;
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 55 f8             	mov    -0x8(%ebp),%edx
 707:	89 10                	mov    %edx,(%eax)
  freep = p;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	a3 1c 10 00 00       	mov    %eax,0x101c
}
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <morecore>:

static Header*
morecore(uint nu)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 719:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 720:	77 07                	ja     729 <morecore+0x16>
    nu = 4096;
 722:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	c1 e0 03             	shl    $0x3,%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 20 fc ff ff       	call   357 <sbrk>
 737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73e:	75 07                	jne    747 <morecore+0x34>
    return 0;
 740:	b8 00 00 00 00       	mov    $0x0,%eax
 745:	eb 22                	jmp    769 <morecore+0x56>
  hp = (Header*)p;
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	8b 55 08             	mov    0x8(%ebp),%edx
 753:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	83 c0 08             	add    $0x8,%eax
 75c:	89 04 24             	mov    %eax,(%esp)
 75f:	e8 ce fe ff ff       	call   632 <free>
  return freep;
 764:	a1 1c 10 00 00       	mov    0x101c,%eax
}
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <malloc>:

void*
malloc(uint nbytes)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 771:	8b 45 08             	mov    0x8(%ebp),%eax
 774:	83 c0 07             	add    $0x7,%eax
 777:	c1 e8 03             	shr    $0x3,%eax
 77a:	83 c0 01             	add    $0x1,%eax
 77d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 780:	a1 1c 10 00 00       	mov    0x101c,%eax
 785:	89 45 f0             	mov    %eax,-0x10(%ebp)
 788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78c:	75 23                	jne    7b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78e:	c7 45 f0 14 10 00 00 	movl   $0x1014,-0x10(%ebp)
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	a3 1c 10 00 00       	mov    %eax,0x101c
 79d:	a1 1c 10 00 00       	mov    0x101c,%eax
 7a2:	a3 14 10 00 00       	mov    %eax,0x1014
    base.s.size = 0;
 7a7:	c7 05 18 10 00 00 00 	movl   $0x0,0x1018
 7ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c2:	72 4d                	jb     811 <malloc+0xa6>
      if(p->s.size == nunits)
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cd:	75 0c                	jne    7db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 10                	mov    (%eax),%edx
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	89 10                	mov    %edx,(%eax)
 7d9:	eb 26                	jmp    801 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e4:	89 c2                	mov    %eax,%edx
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	c1 e0 03             	shl    $0x3,%eax
 7f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	a3 1c 10 00 00       	mov    %eax,0x101c
      return (void*)(p + 1);
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	83 c0 08             	add    $0x8,%eax
 80f:	eb 38                	jmp    849 <malloc+0xde>
    }
    if(p == freep)
 811:	a1 1c 10 00 00       	mov    0x101c,%eax
 816:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 819:	75 1b                	jne    836 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 81b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81e:	89 04 24             	mov    %eax,(%esp)
 821:	e8 ed fe ff ff       	call   713 <morecore>
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
 829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82d:	75 07                	jne    836 <malloc+0xcb>
        return 0;
 82f:	b8 00 00 00 00       	mov    $0x0,%eax
 834:	eb 13                	jmp    849 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 00                	mov    (%eax),%eax
 841:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 844:	e9 70 ff ff ff       	jmp    7b9 <malloc+0x4e>
}
 849:	c9                   	leave  
 84a:	c3                   	ret    

0000084b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 84b:	55                   	push   %ebp
 84c:	89 e5                	mov    %esp,%ebp
 84e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 851:	8b 55 08             	mov    0x8(%ebp),%edx
 854:	8b 45 0c             	mov    0xc(%ebp),%eax
 857:	8b 4d 08             	mov    0x8(%ebp),%ecx
 85a:	f0 87 02             	lock xchg %eax,(%edx)
 85d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 863:	c9                   	leave  
 864:	c3                   	ret    

00000865 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 865:	55                   	push   %ebp
 866:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 868:	8b 45 08             	mov    0x8(%ebp),%eax
 86b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 871:	5d                   	pop    %ebp
 872:	c3                   	ret    

00000873 <lock_acquire>:
void lock_acquire(lock_t *lock){
 873:	55                   	push   %ebp
 874:	89 e5                	mov    %esp,%ebp
 876:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 879:	90                   	nop
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 884:	00 
 885:	89 04 24             	mov    %eax,(%esp)
 888:	e8 be ff ff ff       	call   84b <xchg>
 88d:	85 c0                	test   %eax,%eax
 88f:	75 e9                	jne    87a <lock_acquire+0x7>
}
 891:	c9                   	leave  
 892:	c3                   	ret    

00000893 <lock_release>:
void lock_release(lock_t *lock){
 893:	55                   	push   %ebp
 894:	89 e5                	mov    %esp,%ebp
 896:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8a3:	00 
 8a4:	89 04 24             	mov    %eax,(%esp)
 8a7:	e8 9f ff ff ff       	call   84b <xchg>
}
 8ac:	c9                   	leave  
 8ad:	c3                   	ret    

000008ae <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 8ae:	55                   	push   %ebp
 8af:	89 e5                	mov    %esp,%ebp
 8b1:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8b4:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8bb:	e8 ab fe ff ff       	call   76b <malloc>
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 8c9:	0f b6 05 20 10 00 00 	movzbl 0x1020,%eax
 8d0:	84 c0                	test   %al,%al
 8d2:	75 1c                	jne    8f0 <thread_create+0x42>
        init_q(thQ2);
 8d4:	a1 24 10 00 00       	mov    0x1024,%eax
 8d9:	89 04 24             	mov    %eax,(%esp)
 8dc:	e8 db 01 00 00       	call   abc <init_q>
        inQ++;
 8e1:	0f b6 05 20 10 00 00 	movzbl 0x1020,%eax
 8e8:	83 c0 01             	add    $0x1,%eax
 8eb:	a2 20 10 00 00       	mov    %al,0x1020
    }

    if((uint)stack % 4096){
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	25 ff 0f 00 00       	and    $0xfff,%eax
 8f8:	85 c0                	test   %eax,%eax
 8fa:	74 14                	je     910 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	25 ff 0f 00 00       	and    $0xfff,%eax
 904:	89 c2                	mov    %eax,%edx
 906:	b8 00 10 00 00       	mov    $0x1000,%eax
 90b:	29 d0                	sub    %edx,%eax
 90d:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 914:	75 1e                	jne    934 <thread_create+0x86>

        printf(1,"malloc fail \n");
 916:	c7 44 24 04 ec 0b 00 	movl   $0xbec,0x4(%esp)
 91d:	00 
 91e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 925:	e8 55 fb ff ff       	call   47f <printf>
        return 0;
 92a:	b8 00 00 00 00       	mov    $0x0,%eax
 92f:	e9 83 00 00 00       	jmp    9b7 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 937:	8b 55 08             	mov    0x8(%ebp),%edx
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 941:	89 54 24 08          	mov    %edx,0x8(%esp)
 945:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 94c:	00 
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 1a fa ff ff       	call   36f <clone>
 955:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 958:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 95c:	79 1b                	jns    979 <thread_create+0xcb>
        printf(1,"clone fails\n");
 95e:	c7 44 24 04 fa 0b 00 	movl   $0xbfa,0x4(%esp)
 965:	00 
 966:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 96d:	e8 0d fb ff ff       	call   47f <printf>
        return 0;
 972:	b8 00 00 00 00       	mov    $0x0,%eax
 977:	eb 3e                	jmp    9b7 <thread_create+0x109>
    }
    if(tid > 0){
 979:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 97d:	7e 19                	jle    998 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 97f:	a1 24 10 00 00       	mov    0x1024,%eax
 984:	8b 55 ec             	mov    -0x14(%ebp),%edx
 987:	89 54 24 04          	mov    %edx,0x4(%esp)
 98b:	89 04 24             	mov    %eax,(%esp)
 98e:	e8 4b 01 00 00       	call   ade <add_q>
        return garbage_stack;
 993:	8b 45 f0             	mov    -0x10(%ebp),%eax
 996:	eb 1f                	jmp    9b7 <thread_create+0x109>
    }
    if(tid == 0){
 998:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 99c:	75 14                	jne    9b2 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 99e:	c7 44 24 04 07 0c 00 	movl   $0xc07,0x4(%esp)
 9a5:	00 
 9a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9ad:	e8 cd fa ff ff       	call   47f <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9b7:	c9                   	leave  
 9b8:	c3                   	ret    

000009b9 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 9b9:	55                   	push   %ebp
 9ba:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 9bc:	a1 10 10 00 00       	mov    0x1010,%eax
 9c1:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 9c7:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 9cc:	a3 10 10 00 00       	mov    %eax,0x1010
    return (int)(rands % max);
 9d1:	a1 10 10 00 00       	mov    0x1010,%eax
 9d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9d9:	ba 00 00 00 00       	mov    $0x0,%edx
 9de:	f7 f1                	div    %ecx
 9e0:	89 d0                	mov    %edx,%eax
}
 9e2:	5d                   	pop    %ebp
 9e3:	c3                   	ret    

000009e4 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 9e4:	55                   	push   %ebp
 9e5:	89 e5                	mov    %esp,%ebp
 9e7:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 9ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 9f0:	8b 40 10             	mov    0x10(%eax),%eax
 9f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 9f6:	a1 24 10 00 00       	mov    0x1024,%eax
 9fb:	8b 00                	mov    (%eax),%eax
 9fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a00:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a04:	89 44 24 08          	mov    %eax,0x8(%esp)
 a08:	c7 44 24 04 18 0c 00 	movl   $0xc18,0x4(%esp)
 a0f:	00 
 a10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a17:	e8 63 fa ff ff       	call   47f <printf>
    add_q(thQ2, tid2);
 a1c:	a1 24 10 00 00       	mov    0x1024,%eax
 a21:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a24:	89 54 24 04          	mov    %edx,0x4(%esp)
 a28:	89 04 24             	mov    %eax,(%esp)
 a2b:	e8 ae 00 00 00       	call   ade <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 a30:	a1 24 10 00 00       	mov    0x1024,%eax
 a35:	8b 00                	mov    (%eax),%eax
 a37:	89 44 24 08          	mov    %eax,0x8(%esp)
 a3b:	c7 44 24 04 30 0c 00 	movl   $0xc30,0x4(%esp)
 a42:	00 
 a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a4a:	e8 30 fa ff ff       	call   47f <printf>
    int tidNext = pop_q(thQ2);
 a4f:	a1 24 10 00 00       	mov    0x1024,%eax
 a54:	89 04 24             	mov    %eax,(%esp)
 a57:	e8 fc 00 00 00       	call   b58 <pop_q>
 a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 a5f:	eb 10                	jmp    a71 <thread_yield2+0x8d>
 a61:	a1 24 10 00 00       	mov    0x1024,%eax
 a66:	89 04 24             	mov    %eax,(%esp)
 a69:	e8 ea 00 00 00       	call   b58 <pop_q>
 a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a77:	74 e8                	je     a61 <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 a79:	a1 24 10 00 00       	mov    0x1024,%eax
 a7e:	8b 00                	mov    (%eax),%eax
 a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a83:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a87:	89 44 24 08          	mov    %eax,0x8(%esp)
 a8b:	c7 44 24 04 40 0c 00 	movl   $0xc40,0x4(%esp)
 a92:	00 
 a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a9a:	e8 e0 f9 ff ff       	call   47f <printf>
    tsleep();
 a9f:	e8 db f8 ff ff       	call   37f <tsleep>
    twakeup(tidNext);
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	89 04 24             	mov    %eax,(%esp)
 aaa:	e8 d8 f8 ff ff       	call   387 <twakeup>
    thread_yield3(tidNext);
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	89 04 24             	mov    %eax,(%esp)
 ab5:	e8 dd f8 ff ff       	call   397 <thread_yield3>
    //yield();
 aba:	c9                   	leave  
 abb:	c3                   	ret    

00000abc <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 abc:	55                   	push   %ebp
 abd:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 abf:	8b 45 08             	mov    0x8(%ebp),%eax
 ac2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ac8:	8b 45 08             	mov    0x8(%ebp),%eax
 acb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 ad2:	8b 45 08             	mov    0x8(%ebp),%eax
 ad5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 adc:	5d                   	pop    %ebp
 add:	c3                   	ret    

00000ade <add_q>:

void add_q(struct queue *q, int v){
 ade:	55                   	push   %ebp
 adf:	89 e5                	mov    %esp,%ebp
 ae1:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 ae4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 aeb:	e8 7b fc ff ff       	call   76b <malloc>
 af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b00:	8b 55 0c             	mov    0xc(%ebp),%edx
 b03:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b05:	8b 45 08             	mov    0x8(%ebp),%eax
 b08:	8b 40 04             	mov    0x4(%eax),%eax
 b0b:	85 c0                	test   %eax,%eax
 b0d:	75 0b                	jne    b1a <add_q+0x3c>
        q->head = n;
 b0f:	8b 45 08             	mov    0x8(%ebp),%eax
 b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b15:	89 50 04             	mov    %edx,0x4(%eax)
 b18:	eb 0c                	jmp    b26 <add_q+0x48>
    }else{
        q->tail->next = n;
 b1a:	8b 45 08             	mov    0x8(%ebp),%eax
 b1d:	8b 40 08             	mov    0x8(%eax),%eax
 b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b23:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b26:	8b 45 08             	mov    0x8(%ebp),%eax
 b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b2c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b2f:	8b 45 08             	mov    0x8(%ebp),%eax
 b32:	8b 00                	mov    (%eax),%eax
 b34:	8d 50 01             	lea    0x1(%eax),%edx
 b37:	8b 45 08             	mov    0x8(%ebp),%eax
 b3a:	89 10                	mov    %edx,(%eax)
}
 b3c:	c9                   	leave  
 b3d:	c3                   	ret    

00000b3e <empty_q>:

int empty_q(struct queue *q){
 b3e:	55                   	push   %ebp
 b3f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b41:	8b 45 08             	mov    0x8(%ebp),%eax
 b44:	8b 00                	mov    (%eax),%eax
 b46:	85 c0                	test   %eax,%eax
 b48:	75 07                	jne    b51 <empty_q+0x13>
        return 1;
 b4a:	b8 01 00 00 00       	mov    $0x1,%eax
 b4f:	eb 05                	jmp    b56 <empty_q+0x18>
    else
        return 0;
 b51:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b56:	5d                   	pop    %ebp
 b57:	c3                   	ret    

00000b58 <pop_q>:
int pop_q(struct queue *q){
 b58:	55                   	push   %ebp
 b59:	89 e5                	mov    %esp,%ebp
 b5b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b5e:	8b 45 08             	mov    0x8(%ebp),%eax
 b61:	89 04 24             	mov    %eax,(%esp)
 b64:	e8 d5 ff ff ff       	call   b3e <empty_q>
 b69:	85 c0                	test   %eax,%eax
 b6b:	75 5d                	jne    bca <pop_q+0x72>
       val = q->head->value; 
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
 b70:	8b 40 04             	mov    0x4(%eax),%eax
 b73:	8b 00                	mov    (%eax),%eax
 b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b78:	8b 45 08             	mov    0x8(%ebp),%eax
 b7b:	8b 40 04             	mov    0x4(%eax),%eax
 b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b81:	8b 45 08             	mov    0x8(%ebp),%eax
 b84:	8b 40 04             	mov    0x4(%eax),%eax
 b87:	8b 50 04             	mov    0x4(%eax),%edx
 b8a:	8b 45 08             	mov    0x8(%ebp),%eax
 b8d:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b93:	89 04 24             	mov    %eax,(%esp)
 b96:	e8 97 fa ff ff       	call   632 <free>
       q->size--;
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	8b 00                	mov    (%eax),%eax
 ba0:	8d 50 ff             	lea    -0x1(%eax),%edx
 ba3:	8b 45 08             	mov    0x8(%ebp),%eax
 ba6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 ba8:	8b 45 08             	mov    0x8(%ebp),%eax
 bab:	8b 00                	mov    (%eax),%eax
 bad:	85 c0                	test   %eax,%eax
 baf:	75 14                	jne    bc5 <pop_q+0x6d>
            q->head = 0;
 bb1:	8b 45 08             	mov    0x8(%ebp),%eax
 bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bbb:	8b 45 08             	mov    0x8(%ebp),%eax
 bbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc8:	eb 05                	jmp    bcf <pop_q+0x77>
    }
    return -1;
 bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bcf:	c9                   	leave  
 bd0:	c3                   	ret    
