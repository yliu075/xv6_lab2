
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 75 02 00 00       	call   283 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fd 02 00 00       	call   31b <sleep>
  exit();
  1e:	e8 68 02 00 00       	call   28b <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 44 01 00 00       	call   2a3 <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 07 01 00 00       	call   2cb <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 fd 00 00 00       	call   2e3 <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 bf 00 00 00       	call   2b3 <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exit>:
SYSCALL(exit)
 28b:	b8 02 00 00 00       	mov    $0x2,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <wait>:
SYSCALL(wait)
 293:	b8 03 00 00 00       	mov    $0x3,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <pipe>:
SYSCALL(pipe)
 29b:	b8 04 00 00 00       	mov    $0x4,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <read>:
SYSCALL(read)
 2a3:	b8 05 00 00 00       	mov    $0x5,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <write>:
SYSCALL(write)
 2ab:	b8 10 00 00 00       	mov    $0x10,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <close>:
SYSCALL(close)
 2b3:	b8 15 00 00 00       	mov    $0x15,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <kill>:
SYSCALL(kill)
 2bb:	b8 06 00 00 00       	mov    $0x6,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exec>:
SYSCALL(exec)
 2c3:	b8 07 00 00 00       	mov    $0x7,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <open>:
SYSCALL(open)
 2cb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <mknod>:
SYSCALL(mknod)
 2d3:	b8 11 00 00 00       	mov    $0x11,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <unlink>:
SYSCALL(unlink)
 2db:	b8 12 00 00 00       	mov    $0x12,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <fstat>:
SYSCALL(fstat)
 2e3:	b8 08 00 00 00       	mov    $0x8,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <link>:
SYSCALL(link)
 2eb:	b8 13 00 00 00       	mov    $0x13,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mkdir>:
SYSCALL(mkdir)
 2f3:	b8 14 00 00 00       	mov    $0x14,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <chdir>:
SYSCALL(chdir)
 2fb:	b8 09 00 00 00       	mov    $0x9,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <dup>:
SYSCALL(dup)
 303:	b8 0a 00 00 00       	mov    $0xa,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <getpid>:
SYSCALL(getpid)
 30b:	b8 0b 00 00 00       	mov    $0xb,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sbrk>:
SYSCALL(sbrk)
 313:	b8 0c 00 00 00       	mov    $0xc,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sleep>:
SYSCALL(sleep)
 31b:	b8 0d 00 00 00       	mov    $0xd,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <uptime>:
SYSCALL(uptime)
 323:	b8 0e 00 00 00       	mov    $0xe,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <clone>:
SYSCALL(clone)
 32b:	b8 16 00 00 00       	mov    $0x16,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <texit>:
SYSCALL(texit)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <tsleep>:
SYSCALL(tsleep)
 33b:	b8 18 00 00 00       	mov    $0x18,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <twakeup>:
SYSCALL(twakeup)
 343:	b8 19 00 00 00       	mov    $0x19,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <thread_yield>:
SYSCALL(thread_yield)
 34b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <thread_yield3>:
 353:	b8 1a 00 00 00       	mov    $0x1a,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 18             	sub    $0x18,%esp
 361:	8b 45 0c             	mov    0xc(%ebp),%eax
 364:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 367:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36e:	00 
 36f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 372:	89 44 24 04          	mov    %eax,0x4(%esp)
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	89 04 24             	mov    %eax,(%esp)
 37c:	e8 2a ff ff ff       	call   2ab <write>
}
 381:	c9                   	leave  
 382:	c3                   	ret    

00000383 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	56                   	push   %esi
 387:	53                   	push   %ebx
 388:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 392:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 396:	74 17                	je     3af <printint+0x2c>
 398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39c:	79 11                	jns    3af <printint+0x2c>
    neg = 1;
 39e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a8:	f7 d8                	neg    %eax
 3aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ad:	eb 06                	jmp    3b5 <printint+0x32>
  } else {
    x = xx;
 3af:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3bf:	8d 41 01             	lea    0x1(%ecx),%eax
 3c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cb:	ba 00 00 00 00       	mov    $0x0,%edx
 3d0:	f7 f3                	div    %ebx
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	0f b6 80 a4 0f 00 00 	movzbl 0xfa4(%eax),%eax
 3db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3df:	8b 75 10             	mov    0x10(%ebp),%esi
 3e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ea:	f7 f6                	div    %esi
 3ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f3:	75 c7                	jne    3bc <printint+0x39>
  if(neg)
 3f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f9:	74 10                	je     40b <printint+0x88>
    buf[i++] = '-';
 3fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fe:	8d 50 01             	lea    0x1(%eax),%edx
 401:	89 55 f4             	mov    %edx,-0xc(%ebp)
 404:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 409:	eb 1f                	jmp    42a <printint+0xa7>
 40b:	eb 1d                	jmp    42a <printint+0xa7>
    putc(fd, buf[i]);
 40d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 410:	8b 45 f4             	mov    -0xc(%ebp),%eax
 413:	01 d0                	add    %edx,%eax
 415:	0f b6 00             	movzbl (%eax),%eax
 418:	0f be c0             	movsbl %al,%eax
 41b:	89 44 24 04          	mov    %eax,0x4(%esp)
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	89 04 24             	mov    %eax,(%esp)
 425:	e8 31 ff ff ff       	call   35b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 432:	79 d9                	jns    40d <printint+0x8a>
    putc(fd, buf[i]);
}
 434:	83 c4 30             	add    $0x30,%esp
 437:	5b                   	pop    %ebx
 438:	5e                   	pop    %esi
 439:	5d                   	pop    %ebp
 43a:	c3                   	ret    

0000043b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 441:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 448:	8d 45 0c             	lea    0xc(%ebp),%eax
 44b:	83 c0 04             	add    $0x4,%eax
 44e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 458:	e9 7c 01 00 00       	jmp    5d9 <printf+0x19e>
    c = fmt[i] & 0xff;
 45d:	8b 55 0c             	mov    0xc(%ebp),%edx
 460:	8b 45 f0             	mov    -0x10(%ebp),%eax
 463:	01 d0                	add    %edx,%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	0f be c0             	movsbl %al,%eax
 46b:	25 ff 00 00 00       	and    $0xff,%eax
 470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 477:	75 2c                	jne    4a5 <printf+0x6a>
      if(c == '%'){
 479:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47d:	75 0c                	jne    48b <printf+0x50>
        state = '%';
 47f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 486:	e9 4a 01 00 00       	jmp    5d5 <printf+0x19a>
      } else {
        putc(fd, c);
 48b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 bb fe ff ff       	call   35b <putc>
 4a0:	e9 30 01 00 00       	jmp    5d5 <printf+0x19a>
      }
    } else if(state == '%'){
 4a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a9:	0f 85 26 01 00 00    	jne    5d5 <printf+0x19a>
      if(c == 'd'){
 4af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b3:	75 2d                	jne    4e2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b8:	8b 00                	mov    (%eax),%eax
 4ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c1:	00 
 4c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c9:	00 
 4ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	89 04 24             	mov    %eax,(%esp)
 4d4:	e8 aa fe ff ff       	call   383 <printint>
        ap++;
 4d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4dd:	e9 ec 00 00 00       	jmp    5ce <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e6:	74 06                	je     4ee <printf+0xb3>
 4e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ec:	75 2d                	jne    51b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4fa:	00 
 4fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 502:	00 
 503:	89 44 24 04          	mov    %eax,0x4(%esp)
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 71 fe ff ff       	call   383 <printint>
        ap++;
 512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 516:	e9 b3 00 00 00       	jmp    5ce <printf+0x193>
      } else if(c == 's'){
 51b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51f:	75 45                	jne    566 <printf+0x12b>
        s = (char*)*ap;
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 529:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 531:	75 09                	jne    53c <printf+0x101>
          s = "(null)";
 533:	c7 45 f4 8d 0b 00 00 	movl   $0xb8d,-0xc(%ebp)
        while(*s != 0){
 53a:	eb 1e                	jmp    55a <printf+0x11f>
 53c:	eb 1c                	jmp    55a <printf+0x11f>
          putc(fd, *s);
 53e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 541:	0f b6 00             	movzbl (%eax),%eax
 544:	0f be c0             	movsbl %al,%eax
 547:	89 44 24 04          	mov    %eax,0x4(%esp)
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	89 04 24             	mov    %eax,(%esp)
 551:	e8 05 fe ff ff       	call   35b <putc>
          s++;
 556:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	84 c0                	test   %al,%al
 562:	75 da                	jne    53e <printf+0x103>
 564:	eb 68                	jmp    5ce <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 566:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56a:	75 1d                	jne    589 <printf+0x14e>
        putc(fd, *ap);
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	89 44 24 04          	mov    %eax,0x4(%esp)
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 04 24             	mov    %eax,(%esp)
 57e:	e8 d8 fd ff ff       	call   35b <putc>
        ap++;
 583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 587:	eb 45                	jmp    5ce <printf+0x193>
      } else if(c == '%'){
 589:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58d:	75 17                	jne    5a6 <printf+0x16b>
        putc(fd, c);
 58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	89 44 24 04          	mov    %eax,0x4(%esp)
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	89 04 24             	mov    %eax,(%esp)
 59f:	e8 b7 fd ff ff       	call   35b <putc>
 5a4:	eb 28                	jmp    5ce <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ad:	00 
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 a2 fd ff ff       	call   35b <putc>
        putc(fd, c);
 5b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 8d fd ff ff       	call   35b <putc>
      }
      state = 0;
 5ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5df:	01 d0                	add    %edx,%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	84 c0                	test   %al,%al
 5e6:	0f 85 71 fe ff ff    	jne    45d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ec:	c9                   	leave  
 5ed:	c3                   	ret    

000005ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	83 e8 08             	sub    $0x8,%eax
 5fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fd:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 602:	89 45 fc             	mov    %eax,-0x4(%ebp)
 605:	eb 24                	jmp    62b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60f:	77 12                	ja     623 <free+0x35>
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 617:	77 24                	ja     63d <free+0x4f>
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 621:	77 1a                	ja     63d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	76 d4                	jbe    607 <free+0x19>
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63b:	76 ca                	jbe    607 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	8b 40 04             	mov    0x4(%eax),%eax
 643:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	01 c2                	add    %eax,%edx
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	39 c2                	cmp    %eax,%edx
 656:	75 24                	jne    67c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	8b 50 04             	mov    0x4(%eax),%edx
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	8b 40 04             	mov    0x4(%eax),%eax
 666:	01 c2                	add    %eax,%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	8b 10                	mov    (%eax),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	89 10                	mov    %edx,(%eax)
 67a:	eb 0a                	jmp    686 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 10                	mov    (%eax),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	01 d0                	add    %edx,%eax
 698:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69b:	75 20                	jne    6bd <free+0xcf>
    p->s.size += bp->s.size;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 40 04             	mov    0x4(%eax),%eax
 6a9:	01 c2                	add    %eax,%edx
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
 6bb:	eb 08                	jmp    6c5 <free+0xd7>
  } else
    p->s.ptr = bp;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	a3 c4 0f 00 00       	mov    %eax,0xfc4
}
 6cd:	c9                   	leave  
 6ce:	c3                   	ret    

000006cf <morecore>:

static Header*
morecore(uint nu)
{
 6cf:	55                   	push   %ebp
 6d0:	89 e5                	mov    %esp,%ebp
 6d2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6dc:	77 07                	ja     6e5 <morecore+0x16>
    nu = 4096;
 6de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	c1 e0 03             	shl    $0x3,%eax
 6eb:	89 04 24             	mov    %eax,(%esp)
 6ee:	e8 20 fc ff ff       	call   313 <sbrk>
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fa:	75 07                	jne    703 <morecore+0x34>
    return 0;
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb 22                	jmp    725 <morecore+0x56>
  hp = (Header*)p;
 703:	8b 45 f4             	mov    -0xc(%ebp),%eax
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 55 08             	mov    0x8(%ebp),%edx
 70f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	83 c0 08             	add    $0x8,%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 ce fe ff ff       	call   5ee <free>
  return freep;
 720:	a1 c4 0f 00 00       	mov    0xfc4,%eax
}
 725:	c9                   	leave  
 726:	c3                   	ret    

00000727 <malloc>:

void*
malloc(uint nbytes)
{
 727:	55                   	push   %ebp
 728:	89 e5                	mov    %esp,%ebp
 72a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
 730:	83 c0 07             	add    $0x7,%eax
 733:	c1 e8 03             	shr    $0x3,%eax
 736:	83 c0 01             	add    $0x1,%eax
 739:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73c:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 741:	89 45 f0             	mov    %eax,-0x10(%ebp)
 744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 748:	75 23                	jne    76d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74a:	c7 45 f0 bc 0f 00 00 	movl   $0xfbc,-0x10(%ebp)
 751:	8b 45 f0             	mov    -0x10(%ebp),%eax
 754:	a3 c4 0f 00 00       	mov    %eax,0xfc4
 759:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 75e:	a3 bc 0f 00 00       	mov    %eax,0xfbc
    base.s.size = 0;
 763:	c7 05 c0 0f 00 00 00 	movl   $0x0,0xfc0
 76a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	8b 40 04             	mov    0x4(%eax),%eax
 77b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77e:	72 4d                	jb     7cd <malloc+0xa6>
      if(p->s.size == nunits)
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 789:	75 0c                	jne    797 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 10                	mov    (%eax),%edx
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	89 10                	mov    %edx,(%eax)
 795:	eb 26                	jmp    7bd <malloc+0x96>
      else {
        p->s.size -= nunits;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	8b 40 04             	mov    0x4(%eax),%eax
 79d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a0:	89 c2                	mov    %eax,%edx
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	c1 e0 03             	shl    $0x3,%eax
 7b1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	a3 c4 0f 00 00       	mov    %eax,0xfc4
      return (void*)(p + 1);
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	83 c0 08             	add    $0x8,%eax
 7cb:	eb 38                	jmp    805 <malloc+0xde>
    }
    if(p == freep)
 7cd:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 7d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d5:	75 1b                	jne    7f2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7da:	89 04 24             	mov    %eax,(%esp)
 7dd:	e8 ed fe ff ff       	call   6cf <morecore>
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e9:	75 07                	jne    7f2 <malloc+0xcb>
        return 0;
 7eb:	b8 00 00 00 00       	mov    $0x0,%eax
 7f0:	eb 13                	jmp    805 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 800:	e9 70 ff ff ff       	jmp    775 <malloc+0x4e>
}
 805:	c9                   	leave  
 806:	c3                   	ret    

00000807 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 807:	55                   	push   %ebp
 808:	89 e5                	mov    %esp,%ebp
 80a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 80d:	8b 55 08             	mov    0x8(%ebp),%edx
 810:	8b 45 0c             	mov    0xc(%ebp),%eax
 813:	8b 4d 08             	mov    0x8(%ebp),%ecx
 816:	f0 87 02             	lock xchg %eax,(%edx)
 819:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 81f:	c9                   	leave  
 820:	c3                   	ret    

00000821 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 821:	55                   	push   %ebp
 822:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 824:	8b 45 08             	mov    0x8(%ebp),%eax
 827:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 82d:	5d                   	pop    %ebp
 82e:	c3                   	ret    

0000082f <lock_acquire>:
void lock_acquire(lock_t *lock){
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 835:	90                   	nop
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 840:	00 
 841:	89 04 24             	mov    %eax,(%esp)
 844:	e8 be ff ff ff       	call   807 <xchg>
 849:	85 c0                	test   %eax,%eax
 84b:	75 e9                	jne    836 <lock_acquire+0x7>
}
 84d:	c9                   	leave  
 84e:	c3                   	ret    

0000084f <lock_release>:
void lock_release(lock_t *lock){
 84f:	55                   	push   %ebp
 850:	89 e5                	mov    %esp,%ebp
 852:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 85f:	00 
 860:	89 04 24             	mov    %eax,(%esp)
 863:	e8 9f ff ff ff       	call   807 <xchg>
}
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
 86d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 870:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 877:	e8 ab fe ff ff       	call   727 <malloc>
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 885:	0f b6 05 c8 0f 00 00 	movzbl 0xfc8,%eax
 88c:	84 c0                	test   %al,%al
 88e:	75 1c                	jne    8ac <thread_create+0x42>
        init_q(thQ2);
 890:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 895:	89 04 24             	mov    %eax,(%esp)
 898:	e8 db 01 00 00       	call   a78 <init_q>
        inQ++;
 89d:	0f b6 05 c8 0f 00 00 	movzbl 0xfc8,%eax
 8a4:	83 c0 01             	add    $0x1,%eax
 8a7:	a2 c8 0f 00 00       	mov    %al,0xfc8
    }

    if((uint)stack % 4096){
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	25 ff 0f 00 00       	and    $0xfff,%eax
 8b4:	85 c0                	test   %eax,%eax
 8b6:	74 14                	je     8cc <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	25 ff 0f 00 00       	and    $0xfff,%eax
 8c0:	89 c2                	mov    %eax,%edx
 8c2:	b8 00 10 00 00       	mov    $0x1000,%eax
 8c7:	29 d0                	sub    %edx,%eax
 8c9:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 8cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d0:	75 1e                	jne    8f0 <thread_create+0x86>

        printf(1,"malloc fail \n");
 8d2:	c7 44 24 04 94 0b 00 	movl   $0xb94,0x4(%esp)
 8d9:	00 
 8da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8e1:	e8 55 fb ff ff       	call   43b <printf>
        return 0;
 8e6:	b8 00 00 00 00       	mov    $0x0,%eax
 8eb:	e9 83 00 00 00       	jmp    973 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 8f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8f3:	8b 55 08             	mov    0x8(%ebp),%edx
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8fd:	89 54 24 08          	mov    %edx,0x8(%esp)
 901:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 908:	00 
 909:	89 04 24             	mov    %eax,(%esp)
 90c:	e8 1a fa ff ff       	call   32b <clone>
 911:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 914:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 918:	79 1b                	jns    935 <thread_create+0xcb>
        printf(1,"clone fails\n");
 91a:	c7 44 24 04 a2 0b 00 	movl   $0xba2,0x4(%esp)
 921:	00 
 922:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 929:	e8 0d fb ff ff       	call   43b <printf>
        return 0;
 92e:	b8 00 00 00 00       	mov    $0x0,%eax
 933:	eb 3e                	jmp    973 <thread_create+0x109>
    }
    if(tid > 0){
 935:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 939:	7e 19                	jle    954 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 93b:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 940:	8b 55 ec             	mov    -0x14(%ebp),%edx
 943:	89 54 24 04          	mov    %edx,0x4(%esp)
 947:	89 04 24             	mov    %eax,(%esp)
 94a:	e8 4b 01 00 00       	call   a9a <add_q>
        return garbage_stack;
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	eb 1f                	jmp    973 <thread_create+0x109>
    }
    if(tid == 0){
 954:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 958:	75 14                	jne    96e <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 95a:	c7 44 24 04 af 0b 00 	movl   $0xbaf,0x4(%esp)
 961:	00 
 962:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 969:	e8 cd fa ff ff       	call   43b <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 96e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 973:	c9                   	leave  
 974:	c3                   	ret    

00000975 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 975:	55                   	push   %ebp
 976:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 978:	a1 b8 0f 00 00       	mov    0xfb8,%eax
 97d:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 983:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 988:	a3 b8 0f 00 00       	mov    %eax,0xfb8
    return (int)(rands % max);
 98d:	a1 b8 0f 00 00       	mov    0xfb8,%eax
 992:	8b 4d 08             	mov    0x8(%ebp),%ecx
 995:	ba 00 00 00 00       	mov    $0x0,%edx
 99a:	f7 f1                	div    %ecx
 99c:	89 d0                	mov    %edx,%eax
}
 99e:	5d                   	pop    %ebp
 99f:	c3                   	ret    

000009a0 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 9a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 9ac:	8b 40 10             	mov    0x10(%eax),%eax
 9af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 9b2:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
 9bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
 9c0:	89 44 24 08          	mov    %eax,0x8(%esp)
 9c4:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
 9cb:	00 
 9cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9d3:	e8 63 fa ff ff       	call   43b <printf>
    add_q(thQ2, tid2);
 9d8:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 9dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 9e0:	89 54 24 04          	mov    %edx,0x4(%esp)
 9e4:	89 04 24             	mov    %eax,(%esp)
 9e7:	e8 ae 00 00 00       	call   a9a <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 9ec:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 9f1:	8b 00                	mov    (%eax),%eax
 9f3:	89 44 24 08          	mov    %eax,0x8(%esp)
 9f7:	c7 44 24 04 d8 0b 00 	movl   $0xbd8,0x4(%esp)
 9fe:	00 
 9ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a06:	e8 30 fa ff ff       	call   43b <printf>
    int tidNext = pop_q(thQ2);
 a0b:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 a10:	89 04 24             	mov    %eax,(%esp)
 a13:	e8 fc 00 00 00       	call   b14 <pop_q>
 a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 a1b:	eb 10                	jmp    a2d <thread_yield2+0x8d>
 a1d:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 a22:	89 04 24             	mov    %eax,(%esp)
 a25:	e8 ea 00 00 00       	call   b14 <pop_q>
 a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a33:	74 e8                	je     a1d <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 a35:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 a3a:	8b 00                	mov    (%eax),%eax
 a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3f:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a43:	89 44 24 08          	mov    %eax,0x8(%esp)
 a47:	c7 44 24 04 e8 0b 00 	movl   $0xbe8,0x4(%esp)
 a4e:	00 
 a4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a56:	e8 e0 f9 ff ff       	call   43b <printf>
    tsleep();
 a5b:	e8 db f8 ff ff       	call   33b <tsleep>
    twakeup(tidNext);
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	89 04 24             	mov    %eax,(%esp)
 a66:	e8 d8 f8 ff ff       	call   343 <twakeup>
    thread_yield3(tidNext);
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	89 04 24             	mov    %eax,(%esp)
 a71:	e8 dd f8 ff ff       	call   353 <thread_yield3>
    //yield();
 a76:	c9                   	leave  
 a77:	c3                   	ret    

00000a78 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 a78:	55                   	push   %ebp
 a79:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a7b:	8b 45 08             	mov    0x8(%ebp),%eax
 a7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a84:	8b 45 08             	mov    0x8(%ebp),%eax
 a87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a8e:	8b 45 08             	mov    0x8(%ebp),%eax
 a91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a98:	5d                   	pop    %ebp
 a99:	c3                   	ret    

00000a9a <add_q>:

void add_q(struct queue *q, int v){
 a9a:	55                   	push   %ebp
 a9b:	89 e5                	mov    %esp,%ebp
 a9d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 aa0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 aa7:	e8 7b fc ff ff       	call   727 <malloc>
 aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 55 0c             	mov    0xc(%ebp),%edx
 abf:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 ac1:	8b 45 08             	mov    0x8(%ebp),%eax
 ac4:	8b 40 04             	mov    0x4(%eax),%eax
 ac7:	85 c0                	test   %eax,%eax
 ac9:	75 0b                	jne    ad6 <add_q+0x3c>
        q->head = n;
 acb:	8b 45 08             	mov    0x8(%ebp),%eax
 ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ad1:	89 50 04             	mov    %edx,0x4(%eax)
 ad4:	eb 0c                	jmp    ae2 <add_q+0x48>
    }else{
        q->tail->next = n;
 ad6:	8b 45 08             	mov    0x8(%ebp),%eax
 ad9:	8b 40 08             	mov    0x8(%eax),%eax
 adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 adf:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 ae2:	8b 45 08             	mov    0x8(%ebp),%eax
 ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ae8:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	8b 00                	mov    (%eax),%eax
 af0:	8d 50 01             	lea    0x1(%eax),%edx
 af3:	8b 45 08             	mov    0x8(%ebp),%eax
 af6:	89 10                	mov    %edx,(%eax)
}
 af8:	c9                   	leave  
 af9:	c3                   	ret    

00000afa <empty_q>:

int empty_q(struct queue *q){
 afa:	55                   	push   %ebp
 afb:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 afd:	8b 45 08             	mov    0x8(%ebp),%eax
 b00:	8b 00                	mov    (%eax),%eax
 b02:	85 c0                	test   %eax,%eax
 b04:	75 07                	jne    b0d <empty_q+0x13>
        return 1;
 b06:	b8 01 00 00 00       	mov    $0x1,%eax
 b0b:	eb 05                	jmp    b12 <empty_q+0x18>
    else
        return 0;
 b0d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b12:	5d                   	pop    %ebp
 b13:	c3                   	ret    

00000b14 <pop_q>:
int pop_q(struct queue *q){
 b14:	55                   	push   %ebp
 b15:	89 e5                	mov    %esp,%ebp
 b17:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b1a:	8b 45 08             	mov    0x8(%ebp),%eax
 b1d:	89 04 24             	mov    %eax,(%esp)
 b20:	e8 d5 ff ff ff       	call   afa <empty_q>
 b25:	85 c0                	test   %eax,%eax
 b27:	75 5d                	jne    b86 <pop_q+0x72>
       val = q->head->value; 
 b29:	8b 45 08             	mov    0x8(%ebp),%eax
 b2c:	8b 40 04             	mov    0x4(%eax),%eax
 b2f:	8b 00                	mov    (%eax),%eax
 b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b34:	8b 45 08             	mov    0x8(%ebp),%eax
 b37:	8b 40 04             	mov    0x4(%eax),%eax
 b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b3d:	8b 45 08             	mov    0x8(%ebp),%eax
 b40:	8b 40 04             	mov    0x4(%eax),%eax
 b43:	8b 50 04             	mov    0x4(%eax),%edx
 b46:	8b 45 08             	mov    0x8(%ebp),%eax
 b49:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4f:	89 04 24             	mov    %eax,(%esp)
 b52:	e8 97 fa ff ff       	call   5ee <free>
       q->size--;
 b57:	8b 45 08             	mov    0x8(%ebp),%eax
 b5a:	8b 00                	mov    (%eax),%eax
 b5c:	8d 50 ff             	lea    -0x1(%eax),%edx
 b5f:	8b 45 08             	mov    0x8(%ebp),%eax
 b62:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 b64:	8b 45 08             	mov    0x8(%ebp),%eax
 b67:	8b 00                	mov    (%eax),%eax
 b69:	85 c0                	test   %eax,%eax
 b6b:	75 14                	jne    b81 <pop_q+0x6d>
            q->head = 0;
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
 b70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b77:	8b 45 08             	mov    0x8(%ebp),%eax
 b7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	eb 05                	jmp    b8b <pop_q+0x77>
    }
    return -1;
 b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b8b:	c9                   	leave  
 b8c:	c3                   	ret    
