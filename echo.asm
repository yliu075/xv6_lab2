
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 27 0b 00 00       	mov    $0xb27,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 29 0b 00 00       	mov    $0xb29,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 2b 0b 00 	movl   $0xb2b,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 2b 04 00 00       	call   484 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	0f b6 12             	movzbl (%edx),%edx
  b3:	88 10                	mov    %dl,(%eax)
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	29 c2                	sub    %eax,%edx
  fc:	89 d0                	mov    %edx,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10d:	eb 04                	jmp    113 <strlen+0x13>
 10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 113:	8b 55 fc             	mov    -0x4(%ebp),%edx
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	01 d0                	add    %edx,%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
 122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12d:	8b 45 10             	mov    0x10(%ebp),%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	eb 13                	jmp    17c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 44 01 00 00       	call   2ec <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
 1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
 1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b6:	8d 50 01             	lea    0x1(%eax),%edx
 1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 c2                	add    %eax,%edx
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 13                	je     1e4 <gets+0x66>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0b                	je     1e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c a9                	jl     18d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 201:	00 
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 07 01 00 00       	call   314 <open>
 20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 214:	79 07                	jns    21d <stat+0x29>
    return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 fd 00 00 00       	call   32c <fstat>
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 bf 00 00 00       	call   2fc <close>
  return r;
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
 251:	8b 55 fc             	mov    -0x4(%ebp),%edx
 254:	89 d0                	mov    %edx,%eax
 256:	c1 e0 02             	shl    $0x2,%eax
 259:	01 d0                	add    %edx,%eax
 25b:	01 c0                	add    %eax,%eax
 25d:	89 c1                	mov    %eax,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 08             	mov    %edx,0x8(%ebp)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f be c0             	movsbl %al,%eax
 26e:	01 c8                	add    %ecx,%eax
 270:	83 e8 30             	sub    $0x30,%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2f                	cmp    $0x2f,%al
 27e:	7e 0a                	jle    28a <atoi+0x48>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 39                	cmp    $0x39,%al
 288:	7e c7                	jle    251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2af:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b5:	0f b6 12             	movzbl (%edx),%edx
 2b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ba:	8b 45 10             	mov    0x10(%ebp),%eax
 2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c0:	89 55 10             	mov    %edx,0x10(%ebp)
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7f dc                	jg     2a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
 2e4:	b8 04 00 00 00       	mov    $0x4,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
 2ec:	b8 05 00 00 00       	mov    $0x5,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
 2f4:	b8 10 00 00 00       	mov    $0x10,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
 2fc:	b8 15 00 00 00       	mov    $0x15,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
 304:	b8 06 00 00 00       	mov    $0x6,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
 30c:	b8 07 00 00 00       	mov    $0x7,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
 314:	b8 0f 00 00 00       	mov    $0xf,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
 31c:	b8 11 00 00 00       	mov    $0x11,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
 324:	b8 12 00 00 00       	mov    $0x12,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
 32c:	b8 08 00 00 00       	mov    $0x8,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
 334:	b8 13 00 00 00       	mov    $0x13,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
 33c:	b8 14 00 00 00       	mov    $0x14,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
 344:	b8 09 00 00 00       	mov    $0x9,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
 34c:	b8 0a 00 00 00       	mov    $0xa,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
 354:	b8 0b 00 00 00       	mov    $0xb,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
 35c:	b8 0c 00 00 00       	mov    $0xc,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
 364:	b8 0d 00 00 00       	mov    $0xd,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
 36c:	b8 0e 00 00 00       	mov    $0xe,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <clone>:
SYSCALL(clone)
 374:	b8 16 00 00 00       	mov    $0x16,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <texit>:
SYSCALL(texit)
 37c:	b8 17 00 00 00       	mov    $0x17,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <tsleep>:
SYSCALL(tsleep)
 384:	b8 18 00 00 00       	mov    $0x18,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <twakeup>:
SYSCALL(twakeup)
 38c:	b8 19 00 00 00       	mov    $0x19,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <thread_yield>:
SYSCALL(thread_yield)
 394:	b8 1a 00 00 00       	mov    $0x1a,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <thread_yield3>:
 39c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	83 ec 18             	sub    $0x18,%esp
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b7:	00 
 3b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	89 04 24             	mov    %eax,(%esp)
 3c5:	e8 2a ff ff ff       	call   2f4 <write>
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	56                   	push   %esi
 3d0:	53                   	push   %ebx
 3d1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3df:	74 17                	je     3f8 <printint+0x2c>
 3e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e5:	79 11                	jns    3f8 <printint+0x2c>
    neg = 1;
 3e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	f7 d8                	neg    %eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f6:	eb 06                	jmp    3fe <printint+0x32>
  } else {
    x = xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 405:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 408:	8d 41 01             	lea    0x1(%ecx),%eax
 40b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 f3                	div    %ebx
 41b:	89 d0                	mov    %edx,%eax
 41d:	0f b6 80 14 0f 00 00 	movzbl 0xf14(%eax),%eax
 424:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 428:	8b 75 10             	mov    0x10(%ebp),%esi
 42b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42e:	ba 00 00 00 00       	mov    $0x0,%edx
 433:	f7 f6                	div    %esi
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43c:	75 c7                	jne    405 <printint+0x39>
  if(neg)
 43e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 442:	74 10                	je     454 <printint+0x88>
    buf[i++] = '-';
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	8d 50 01             	lea    0x1(%eax),%edx
 44a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 452:	eb 1f                	jmp    473 <printint+0xa7>
 454:	eb 1d                	jmp    473 <printint+0xa7>
    putc(fd, buf[i]);
 456:	8d 55 dc             	lea    -0x24(%ebp),%edx
 459:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45c:	01 d0                	add    %edx,%eax
 45e:	0f b6 00             	movzbl (%eax),%eax
 461:	0f be c0             	movsbl %al,%eax
 464:	89 44 24 04          	mov    %eax,0x4(%esp)
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	89 04 24             	mov    %eax,(%esp)
 46e:	e8 31 ff ff ff       	call   3a4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 473:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47b:	79 d9                	jns    456 <printint+0x8a>
    putc(fd, buf[i]);
}
 47d:	83 c4 30             	add    $0x30,%esp
 480:	5b                   	pop    %ebx
 481:	5e                   	pop    %esi
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    

00000484 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 491:	8d 45 0c             	lea    0xc(%ebp),%eax
 494:	83 c0 04             	add    $0x4,%eax
 497:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a1:	e9 7c 01 00 00       	jmp    622 <printf+0x19e>
    c = fmt[i] & 0xff;
 4a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ac:	01 d0                	add    %edx,%eax
 4ae:	0f b6 00             	movzbl (%eax),%eax
 4b1:	0f be c0             	movsbl %al,%eax
 4b4:	25 ff 00 00 00       	and    $0xff,%eax
 4b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c0:	75 2c                	jne    4ee <printf+0x6a>
      if(c == '%'){
 4c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c6:	75 0c                	jne    4d4 <printf+0x50>
        state = '%';
 4c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cf:	e9 4a 01 00 00       	jmp    61e <printf+0x19a>
      } else {
        putc(fd, c);
 4d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d7:	0f be c0             	movsbl %al,%eax
 4da:	89 44 24 04          	mov    %eax,0x4(%esp)
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	89 04 24             	mov    %eax,(%esp)
 4e4:	e8 bb fe ff ff       	call   3a4 <putc>
 4e9:	e9 30 01 00 00       	jmp    61e <printf+0x19a>
      }
    } else if(state == '%'){
 4ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f2:	0f 85 26 01 00 00    	jne    61e <printf+0x19a>
      if(c == 'd'){
 4f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fc:	75 2d                	jne    52b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50a:	00 
 50b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 512:	00 
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 aa fe ff ff       	call   3cc <printint>
        ap++;
 522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 526:	e9 ec 00 00 00       	jmp    617 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 52b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 52f:	74 06                	je     537 <printf+0xb3>
 531:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 535:	75 2d                	jne    564 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 543:	00 
 544:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54b:	00 
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	89 04 24             	mov    %eax,(%esp)
 556:	e8 71 fe ff ff       	call   3cc <printint>
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55f:	e9 b3 00 00 00       	jmp    617 <printf+0x193>
      } else if(c == 's'){
 564:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 568:	75 45                	jne    5af <printf+0x12b>
        s = (char*)*ap;
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57a:	75 09                	jne    585 <printf+0x101>
          s = "(null)";
 57c:	c7 45 f4 30 0b 00 00 	movl   $0xb30,-0xc(%ebp)
        while(*s != 0){
 583:	eb 1e                	jmp    5a3 <printf+0x11f>
 585:	eb 1c                	jmp    5a3 <printf+0x11f>
          putc(fd, *s);
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 05 fe ff ff       	call   3a4 <putc>
          s++;
 59f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	84 c0                	test   %al,%al
 5ab:	75 da                	jne    587 <printf+0x103>
 5ad:	eb 68                	jmp    617 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b3:	75 1d                	jne    5d2 <printf+0x14e>
        putc(fd, *ap);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 d8 fd ff ff       	call   3a4 <putc>
        ap++;
 5cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d0:	eb 45                	jmp    617 <printf+0x193>
      } else if(c == '%'){
 5d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d6:	75 17                	jne    5ef <printf+0x16b>
        putc(fd, c);
 5d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	89 04 24             	mov    %eax,(%esp)
 5e8:	e8 b7 fd ff ff       	call   3a4 <putc>
 5ed:	eb 28                	jmp    617 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ef:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f6:	00 
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	89 04 24             	mov    %eax,(%esp)
 5fd:	e8 a2 fd ff ff       	call   3a4 <putc>
        putc(fd, c);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	89 44 24 04          	mov    %eax,0x4(%esp)
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	89 04 24             	mov    %eax,(%esp)
 612:	e8 8d fd ff ff       	call   3a4 <putc>
      }
      state = 0;
 617:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 622:	8b 55 0c             	mov    0xc(%ebp),%edx
 625:	8b 45 f0             	mov    -0x10(%ebp),%eax
 628:	01 d0                	add    %edx,%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	84 c0                	test   %al,%al
 62f:	0f 85 71 fe ff ff    	jne    4a6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 635:	c9                   	leave  
 636:	c3                   	ret    

00000637 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	83 e8 08             	sub    $0x8,%eax
 643:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	a1 34 0f 00 00       	mov    0xf34,%eax
 64b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64e:	eb 24                	jmp    674 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	77 12                	ja     66c <free+0x35>
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	77 24                	ja     686 <free+0x4f>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	77 1a                	ja     686 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	89 45 fc             	mov    %eax,-0x4(%ebp)
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67a:	76 d4                	jbe    650 <free+0x19>
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 684:	76 ca                	jbe    650 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	01 c2                	add    %eax,%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	39 c2                	cmp    %eax,%edx
 69f:	75 24                	jne    6c5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	01 c2                	add    %eax,%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	89 10                	mov    %edx,(%eax)
 6c3:	eb 0a                	jmp    6cf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	01 d0                	add    %edx,%eax
 6e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e4:	75 20                	jne    706 <free+0xcf>
    p->s.size += bp->s.size;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 50 04             	mov    0x4(%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	01 c2                	add    %eax,%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	89 10                	mov    %edx,(%eax)
 704:	eb 08                	jmp    70e <free+0xd7>
  } else
    p->s.ptr = bp;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70c:	89 10                	mov    %edx,(%eax)
  freep = p;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	a3 34 0f 00 00       	mov    %eax,0xf34
}
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <morecore>:

static Header*
morecore(uint nu)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 725:	77 07                	ja     72e <morecore+0x16>
    nu = 4096;
 727:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	c1 e0 03             	shl    $0x3,%eax
 734:	89 04 24             	mov    %eax,(%esp)
 737:	e8 20 fc ff ff       	call   35c <sbrk>
 73c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 743:	75 07                	jne    74c <morecore+0x34>
    return 0;
 745:	b8 00 00 00 00       	mov    $0x0,%eax
 74a:	eb 22                	jmp    76e <morecore+0x56>
  hp = (Header*)p;
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	8b 55 08             	mov    0x8(%ebp),%edx
 758:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	83 c0 08             	add    $0x8,%eax
 761:	89 04 24             	mov    %eax,(%esp)
 764:	e8 ce fe ff ff       	call   637 <free>
  return freep;
 769:	a1 34 0f 00 00       	mov    0xf34,%eax
}
 76e:	c9                   	leave  
 76f:	c3                   	ret    

00000770 <malloc>:

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 776:	8b 45 08             	mov    0x8(%ebp),%eax
 779:	83 c0 07             	add    $0x7,%eax
 77c:	c1 e8 03             	shr    $0x3,%eax
 77f:	83 c0 01             	add    $0x1,%eax
 782:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 785:	a1 34 0f 00 00       	mov    0xf34,%eax
 78a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 791:	75 23                	jne    7b6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 793:	c7 45 f0 2c 0f 00 00 	movl   $0xf2c,-0x10(%ebp)
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	a3 34 0f 00 00       	mov    %eax,0xf34
 7a2:	a1 34 0f 00 00       	mov    0xf34,%eax
 7a7:	a3 2c 0f 00 00       	mov    %eax,0xf2c
    base.s.size = 0;
 7ac:	c7 05 30 0f 00 00 00 	movl   $0x0,0xf30
 7b3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c7:	72 4d                	jb     816 <malloc+0xa6>
      if(p->s.size == nunits)
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d2:	75 0c                	jne    7e0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 10                	mov    (%eax),%edx
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	89 10                	mov    %edx,(%eax)
 7de:	eb 26                	jmp    806 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e9:	89 c2                	mov    %eax,%edx
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	c1 e0 03             	shl    $0x3,%eax
 7fa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 55 ec             	mov    -0x14(%ebp),%edx
 803:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	a3 34 0f 00 00       	mov    %eax,0xf34
      return (void*)(p + 1);
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	83 c0 08             	add    $0x8,%eax
 814:	eb 38                	jmp    84e <malloc+0xde>
    }
    if(p == freep)
 816:	a1 34 0f 00 00       	mov    0xf34,%eax
 81b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81e:	75 1b                	jne    83b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 820:	8b 45 ec             	mov    -0x14(%ebp),%eax
 823:	89 04 24             	mov    %eax,(%esp)
 826:	e8 ed fe ff ff       	call   718 <morecore>
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 832:	75 07                	jne    83b <malloc+0xcb>
        return 0;
 834:	b8 00 00 00 00       	mov    $0x0,%eax
 839:	eb 13                	jmp    84e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 849:	e9 70 ff ff ff       	jmp    7be <malloc+0x4e>
}
 84e:	c9                   	leave  
 84f:	c3                   	ret    

00000850 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 856:	8b 55 08             	mov    0x8(%ebp),%edx
 859:	8b 45 0c             	mov    0xc(%ebp),%eax
 85c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 85f:	f0 87 02             	lock xchg %eax,(%edx)
 862:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 876:	5d                   	pop    %ebp
 877:	c3                   	ret    

00000878 <lock_acquire>:
void lock_acquire(lock_t *lock){
 878:	55                   	push   %ebp
 879:	89 e5                	mov    %esp,%ebp
 87b:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 87e:	90                   	nop
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 889:	00 
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 be ff ff ff       	call   850 <xchg>
 892:	85 c0                	test   %eax,%eax
 894:	75 e9                	jne    87f <lock_acquire+0x7>
}
 896:	c9                   	leave  
 897:	c3                   	ret    

00000898 <lock_release>:
void lock_release(lock_t *lock){
 898:	55                   	push   %ebp
 899:	89 e5                	mov    %esp,%ebp
 89b:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8a8:	00 
 8a9:	89 04 24             	mov    %eax,(%esp)
 8ac:	e8 9f ff ff ff       	call   850 <xchg>
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    

000008b3 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 8b3:	55                   	push   %ebp
 8b4:	89 e5                	mov    %esp,%ebp
 8b6:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8b9:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8c0:	e8 ab fe ff ff       	call   770 <malloc>
 8c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 8ce:	0f b6 05 38 0f 00 00 	movzbl 0xf38,%eax
 8d5:	84 c0                	test   %al,%al
 8d7:	75 1c                	jne    8f5 <thread_create+0x42>
        init_q(thQ2);
 8d9:	a1 3c 0f 00 00       	mov    0xf3c,%eax
 8de:	89 04 24             	mov    %eax,(%esp)
 8e1:	e8 2c 01 00 00       	call   a12 <init_q>
        inQ++;
 8e6:	0f b6 05 38 0f 00 00 	movzbl 0xf38,%eax
 8ed:	83 c0 01             	add    $0x1,%eax
 8f0:	a2 38 0f 00 00       	mov    %al,0xf38
    }

    if((uint)stack % 4096){
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	25 ff 0f 00 00       	and    $0xfff,%eax
 8fd:	85 c0                	test   %eax,%eax
 8ff:	74 14                	je     915 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	25 ff 0f 00 00       	and    $0xfff,%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	b8 00 10 00 00       	mov    $0x1000,%eax
 910:	29 d0                	sub    %edx,%eax
 912:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 919:	75 1e                	jne    939 <thread_create+0x86>

        printf(1,"malloc fail \n");
 91b:	c7 44 24 04 37 0b 00 	movl   $0xb37,0x4(%esp)
 922:	00 
 923:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 92a:	e8 55 fb ff ff       	call   484 <printf>
        return 0;
 92f:	b8 00 00 00 00       	mov    $0x0,%eax
 934:	e9 83 00 00 00       	jmp    9bc <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 939:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 93c:	8b 55 08             	mov    0x8(%ebp),%edx
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 946:	89 54 24 08          	mov    %edx,0x8(%esp)
 94a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 951:	00 
 952:	89 04 24             	mov    %eax,(%esp)
 955:	e8 1a fa ff ff       	call   374 <clone>
 95a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 95d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 961:	79 1b                	jns    97e <thread_create+0xcb>
        printf(1,"clone fails\n");
 963:	c7 44 24 04 45 0b 00 	movl   $0xb45,0x4(%esp)
 96a:	00 
 96b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 972:	e8 0d fb ff ff       	call   484 <printf>
        return 0;
 977:	b8 00 00 00 00       	mov    $0x0,%eax
 97c:	eb 3e                	jmp    9bc <thread_create+0x109>
    }
    if(tid > 0){
 97e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 982:	7e 19                	jle    99d <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 984:	a1 3c 0f 00 00       	mov    0xf3c,%eax
 989:	8b 55 ec             	mov    -0x14(%ebp),%edx
 98c:	89 54 24 04          	mov    %edx,0x4(%esp)
 990:	89 04 24             	mov    %eax,(%esp)
 993:	e8 9c 00 00 00       	call   a34 <add_q>
        return garbage_stack;
 998:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99b:	eb 1f                	jmp    9bc <thread_create+0x109>
    }
    if(tid == 0){
 99d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a1:	75 14                	jne    9b7 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 9a3:	c7 44 24 04 52 0b 00 	movl   $0xb52,0x4(%esp)
 9aa:	00 
 9ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9b2:	e8 cd fa ff ff       	call   484 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9bc:	c9                   	leave  
 9bd:	c3                   	ret    

000009be <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 9be:	55                   	push   %ebp
 9bf:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 9c1:	a1 28 0f 00 00       	mov    0xf28,%eax
 9c6:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 9cc:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 9d1:	a3 28 0f 00 00       	mov    %eax,0xf28
    return (int)(rands % max);
 9d6:	a1 28 0f 00 00       	mov    0xf28,%eax
 9db:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9de:	ba 00 00 00 00       	mov    $0x0,%edx
 9e3:	f7 f1                	div    %ecx
 9e5:	89 d0                	mov    %edx,%eax
}
 9e7:	5d                   	pop    %ebp
 9e8:	c3                   	ret    

000009e9 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
 9ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 9f5:	8b 40 10             	mov    0x10(%eax),%eax
 9f8:	89 44 24 08          	mov    %eax,0x8(%esp)
 9fc:	c7 44 24 04 63 0b 00 	movl   $0xb63,0x4(%esp)
 a03:	00 
 a04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a0b:	e8 74 fa ff ff       	call   484 <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
 a10:	c9                   	leave  
 a11:	c3                   	ret    

00000a12 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 a12:	55                   	push   %ebp
 a13:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a15:	8b 45 08             	mov    0x8(%ebp),%eax
 a18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a1e:	8b 45 08             	mov    0x8(%ebp),%eax
 a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a28:	8b 45 08             	mov    0x8(%ebp),%eax
 a2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a32:	5d                   	pop    %ebp
 a33:	c3                   	ret    

00000a34 <add_q>:

void add_q(struct queue *q, int v){
 a34:	55                   	push   %ebp
 a35:	89 e5                	mov    %esp,%ebp
 a37:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a3a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a41:	e8 2a fd ff ff       	call   770 <malloc>
 a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	8b 55 0c             	mov    0xc(%ebp),%edx
 a59:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a5b:	8b 45 08             	mov    0x8(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	85 c0                	test   %eax,%eax
 a63:	75 0b                	jne    a70 <add_q+0x3c>
        q->head = n;
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a6b:	89 50 04             	mov    %edx,0x4(%eax)
 a6e:	eb 0c                	jmp    a7c <add_q+0x48>
    }else{
        q->tail->next = n;
 a70:	8b 45 08             	mov    0x8(%ebp),%eax
 a73:	8b 40 08             	mov    0x8(%eax),%eax
 a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a79:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a7c:	8b 45 08             	mov    0x8(%ebp),%eax
 a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a82:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a85:	8b 45 08             	mov    0x8(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	8d 50 01             	lea    0x1(%eax),%edx
 a8d:	8b 45 08             	mov    0x8(%ebp),%eax
 a90:	89 10                	mov    %edx,(%eax)
}
 a92:	c9                   	leave  
 a93:	c3                   	ret    

00000a94 <empty_q>:

int empty_q(struct queue *q){
 a94:	55                   	push   %ebp
 a95:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a97:	8b 45 08             	mov    0x8(%ebp),%eax
 a9a:	8b 00                	mov    (%eax),%eax
 a9c:	85 c0                	test   %eax,%eax
 a9e:	75 07                	jne    aa7 <empty_q+0x13>
        return 1;
 aa0:	b8 01 00 00 00       	mov    $0x1,%eax
 aa5:	eb 05                	jmp    aac <empty_q+0x18>
    else
        return 0;
 aa7:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 aac:	5d                   	pop    %ebp
 aad:	c3                   	ret    

00000aae <pop_q>:
int pop_q(struct queue *q){
 aae:	55                   	push   %ebp
 aaf:	89 e5                	mov    %esp,%ebp
 ab1:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 ab4:	8b 45 08             	mov    0x8(%ebp),%eax
 ab7:	89 04 24             	mov    %eax,(%esp)
 aba:	e8 d5 ff ff ff       	call   a94 <empty_q>
 abf:	85 c0                	test   %eax,%eax
 ac1:	75 5d                	jne    b20 <pop_q+0x72>
       val = q->head->value; 
 ac3:	8b 45 08             	mov    0x8(%ebp),%eax
 ac6:	8b 40 04             	mov    0x4(%eax),%eax
 ac9:	8b 00                	mov    (%eax),%eax
 acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 ace:	8b 45 08             	mov    0x8(%ebp),%eax
 ad1:	8b 40 04             	mov    0x4(%eax),%eax
 ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 ad7:	8b 45 08             	mov    0x8(%ebp),%eax
 ada:	8b 40 04             	mov    0x4(%eax),%eax
 add:	8b 50 04             	mov    0x4(%eax),%edx
 ae0:	8b 45 08             	mov    0x8(%ebp),%eax
 ae3:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae9:	89 04 24             	mov    %eax,(%esp)
 aec:	e8 46 fb ff ff       	call   637 <free>
       q->size--;
 af1:	8b 45 08             	mov    0x8(%ebp),%eax
 af4:	8b 00                	mov    (%eax),%eax
 af6:	8d 50 ff             	lea    -0x1(%eax),%edx
 af9:	8b 45 08             	mov    0x8(%ebp),%eax
 afc:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 afe:	8b 45 08             	mov    0x8(%ebp),%eax
 b01:	8b 00                	mov    (%eax),%eax
 b03:	85 c0                	test   %eax,%eax
 b05:	75 14                	jne    b1b <pop_q+0x6d>
            q->head = 0;
 b07:	8b 45 08             	mov    0x8(%ebp),%eax
 b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b11:	8b 45 08             	mov    0x8(%ebp),%eax
 b14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1e:	eb 05                	jmp    b25 <pop_q+0x77>
    }
    return -1;
 b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b25:	c9                   	leave  
 b26:	c3                   	ret    
