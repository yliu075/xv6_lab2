
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 1d 0d 00 	movl   $0xd1d,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 8b 05 00 00       	call   5cb <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 12 02 00 00       	call   26e <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 a5 03 00 00       	call   413 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 30 0d 00 	movl   $0xd30,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 26 05 00 00       	call   5cb <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 85 03 00 00       	call   45b <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 32 03 00 00       	call   43b <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 19 03 00 00       	call   443 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 3a 0d 00 	movl   $0xd3a,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 8d 04 00 00       	call   5cb <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 06 03 00 00       	call   45b <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 ab 02 00 00       	call   433 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 9a 02 00 00       	call   443 <close>

  wait();
 1a9:	e8 75 02 00 00       	call   423 <wait>
  
  exit();
 1ae:	e8 68 02 00 00       	call   41b <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e4:	90                   	nop
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8d 50 01             	lea    0x1(%eax),%edx
 1eb:	89 55 08             	mov    %edx,0x8(%ebp)
 1ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f7:	0f b6 12             	movzbl (%edx),%edx
 1fa:	88 10                	mov    %dl,(%eax)
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strcpy+0xd>
    ;
  return os;
 203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20b:	eb 08                	jmp    215 <strcmp+0xd>
    p++, q++;
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	74 10                	je     22f <strcmp+0x27>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 10             	movzbl (%eax),%edx
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	38 c2                	cmp    %al,%dl
 22d:	74 de                	je     20d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f b6 d0             	movzbl %al,%edx
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 c0             	movzbl %al,%eax
 241:	29 c2                	sub    %eax,%edx
 243:	89 d0                	mov    %edx,%eax
}
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <strlen>:

uint
strlen(char *s)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 254:	eb 04                	jmp    25a <strlen+0x13>
 256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	01 d0                	add    %edx,%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 ed                	jne    256 <strlen+0xf>
    ;
  return n;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	89 44 24 08          	mov    %eax,0x8(%esp)
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 26 ff ff ff       	call   1b3 <stosb>
  return dst;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 04             	sub    $0x4,%esp
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29e:	eb 14                	jmp    2b4 <strchr+0x22>
    if(*s == c)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a9:	75 05                	jne    2b0 <strchr+0x1e>
      return (char*)s;
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	eb 13                	jmp    2c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	75 e2                	jne    2a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <gets>:

char*
gets(char *buf, int max)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d2:	eb 4c                	jmp    320 <gets+0x5b>
    cc = read(0, &c, 1);
 2d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2db:	00 
 2dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2df:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ea:	e8 44 01 00 00       	call   433 <read>
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f6:	7f 02                	jg     2fa <gets+0x35>
      break;
 2f8:	eb 31                	jmp    32b <gets+0x66>
    buf[i++] = c;
 2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 55 f4             	mov    %edx,-0xc(%ebp)
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 13                	je     32b <gets+0x66>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0b                	je     32b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c a9                	jl     2d4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	01 d0                	add    %edx,%eax
 333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <stat>:

int
stat(char *n, struct stat *st)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 348:	00 
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 07 01 00 00       	call   45b <open>
 354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35b:	79 07                	jns    364 <stat+0x29>
    return -1;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	eb 23                	jmp    387 <stat+0x4c>
  r = fstat(fd, st);
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 44 24 04          	mov    %eax,0x4(%esp)
 36b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36e:	89 04 24             	mov    %eax,(%esp)
 371:	e8 fd 00 00 00       	call   473 <fstat>
 376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 bf 00 00 00       	call   443 <close>
  return r;
 384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <atoi>:

int
atoi(const char *s)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 38f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 396:	eb 25                	jmp    3bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 398:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e0 02             	shl    $0x2,%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	01 c0                	add    %eax,%eax
 3a4:	89 c1                	mov    %eax,%ecx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 08             	mov    %edx,0x8(%ebp)
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	01 c8                	add    %ecx,%eax
 3b7:	83 e8 30             	sub    $0x30,%eax
 3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x48>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c7                	jle    398 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e8:	eb 17                	jmp    401 <memmove+0x2b>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fc:	0f b6 12             	movzbl (%edx),%edx
 3ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	8d 50 ff             	lea    -0x1(%eax),%edx
 407:	89 55 10             	mov    %edx,0x10(%ebp)
 40a:	85 c0                	test   %eax,%eax
 40c:	7f dc                	jg     3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 413:	b8 01 00 00 00       	mov    $0x1,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <exit>:
SYSCALL(exit)
 41b:	b8 02 00 00 00       	mov    $0x2,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <wait>:
SYSCALL(wait)
 423:	b8 03 00 00 00       	mov    $0x3,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <pipe>:
SYSCALL(pipe)
 42b:	b8 04 00 00 00       	mov    $0x4,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <read>:
SYSCALL(read)
 433:	b8 05 00 00 00       	mov    $0x5,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <write>:
SYSCALL(write)
 43b:	b8 10 00 00 00       	mov    $0x10,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <close>:
SYSCALL(close)
 443:	b8 15 00 00 00       	mov    $0x15,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <kill>:
SYSCALL(kill)
 44b:	b8 06 00 00 00       	mov    $0x6,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exec>:
SYSCALL(exec)
 453:	b8 07 00 00 00       	mov    $0x7,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <open>:
SYSCALL(open)
 45b:	b8 0f 00 00 00       	mov    $0xf,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <mknod>:
SYSCALL(mknod)
 463:	b8 11 00 00 00       	mov    $0x11,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <unlink>:
SYSCALL(unlink)
 46b:	b8 12 00 00 00       	mov    $0x12,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <fstat>:
SYSCALL(fstat)
 473:	b8 08 00 00 00       	mov    $0x8,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <link>:
SYSCALL(link)
 47b:	b8 13 00 00 00       	mov    $0x13,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mkdir>:
SYSCALL(mkdir)
 483:	b8 14 00 00 00       	mov    $0x14,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <chdir>:
SYSCALL(chdir)
 48b:	b8 09 00 00 00       	mov    $0x9,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <dup>:
SYSCALL(dup)
 493:	b8 0a 00 00 00       	mov    $0xa,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <getpid>:
SYSCALL(getpid)
 49b:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sbrk>:
SYSCALL(sbrk)
 4a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sleep>:
SYSCALL(sleep)
 4ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <uptime>:
SYSCALL(uptime)
 4b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <clone>:
SYSCALL(clone)
 4bb:	b8 16 00 00 00       	mov    $0x16,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <texit>:
SYSCALL(texit)
 4c3:	b8 17 00 00 00       	mov    $0x17,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <tsleep>:
SYSCALL(tsleep)
 4cb:	b8 18 00 00 00       	mov    $0x18,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <twakeup>:
SYSCALL(twakeup)
 4d3:	b8 19 00 00 00       	mov    $0x19,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <thread_yield>:
SYSCALL(thread_yield)
 4db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <thread_yield3>:
 4e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	83 ec 18             	sub    $0x18,%esp
 4f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4fe:	00 
 4ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
 502:	89 44 24 04          	mov    %eax,0x4(%esp)
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 04 24             	mov    %eax,(%esp)
 50c:	e8 2a ff ff ff       	call   43b <write>
}
 511:	c9                   	leave  
 512:	c3                   	ret    

00000513 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	56                   	push   %esi
 517:	53                   	push   %ebx
 518:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 51b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 522:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 526:	74 17                	je     53f <printint+0x2c>
 528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 52c:	79 11                	jns    53f <printint+0x2c>
    neg = 1;
 52e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 535:	8b 45 0c             	mov    0xc(%ebp),%eax
 538:	f7 d8                	neg    %eax
 53a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53d:	eb 06                	jmp    545 <printint+0x32>
  } else {
    x = xx;
 53f:	8b 45 0c             	mov    0xc(%ebp),%eax
 542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 545:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 54c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 54f:	8d 41 01             	lea    0x1(%ecx),%eax
 552:	89 45 f4             	mov    %eax,-0xc(%ebp)
 555:	8b 5d 10             	mov    0x10(%ebp),%ebx
 558:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55b:	ba 00 00 00 00       	mov    $0x0,%edx
 560:	f7 f3                	div    %ebx
 562:	89 d0                	mov    %edx,%eax
 564:	0f b6 80 58 11 00 00 	movzbl 0x1158(%eax),%eax
 56b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 56f:	8b 75 10             	mov    0x10(%ebp),%esi
 572:	8b 45 ec             	mov    -0x14(%ebp),%eax
 575:	ba 00 00 00 00       	mov    $0x0,%edx
 57a:	f7 f6                	div    %esi
 57c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 583:	75 c7                	jne    54c <printint+0x39>
  if(neg)
 585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 589:	74 10                	je     59b <printint+0x88>
    buf[i++] = '-';
 58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58e:	8d 50 01             	lea    0x1(%eax),%edx
 591:	89 55 f4             	mov    %edx,-0xc(%ebp)
 594:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 599:	eb 1f                	jmp    5ba <printint+0xa7>
 59b:	eb 1d                	jmp    5ba <printint+0xa7>
    putc(fd, buf[i]);
 59d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a3:	01 d0                	add    %edx,%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 31 ff ff ff       	call   4eb <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c2:	79 d9                	jns    59d <printint+0x8a>
    putc(fd, buf[i]);
}
 5c4:	83 c4 30             	add    $0x30,%esp
 5c7:	5b                   	pop    %ebx
 5c8:	5e                   	pop    %esi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret    

000005cb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp
 5ce:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d8:	8d 45 0c             	lea    0xc(%ebp),%eax
 5db:	83 c0 04             	add    $0x4,%eax
 5de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e8:	e9 7c 01 00 00       	jmp    769 <printf+0x19e>
    c = fmt[i] & 0xff;
 5ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f3:	01 d0                	add    %edx,%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	25 ff 00 00 00       	and    $0xff,%eax
 600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 607:	75 2c                	jne    635 <printf+0x6a>
      if(c == '%'){
 609:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60d:	75 0c                	jne    61b <printf+0x50>
        state = '%';
 60f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 616:	e9 4a 01 00 00       	jmp    765 <printf+0x19a>
      } else {
        putc(fd, c);
 61b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61e:	0f be c0             	movsbl %al,%eax
 621:	89 44 24 04          	mov    %eax,0x4(%esp)
 625:	8b 45 08             	mov    0x8(%ebp),%eax
 628:	89 04 24             	mov    %eax,(%esp)
 62b:	e8 bb fe ff ff       	call   4eb <putc>
 630:	e9 30 01 00 00       	jmp    765 <printf+0x19a>
      }
    } else if(state == '%'){
 635:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 639:	0f 85 26 01 00 00    	jne    765 <printf+0x19a>
      if(c == 'd'){
 63f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 643:	75 2d                	jne    672 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 645:	8b 45 e8             	mov    -0x18(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 651:	00 
 652:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 659:	00 
 65a:	89 44 24 04          	mov    %eax,0x4(%esp)
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
 661:	89 04 24             	mov    %eax,(%esp)
 664:	e8 aa fe ff ff       	call   513 <printint>
        ap++;
 669:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66d:	e9 ec 00 00 00       	jmp    75e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 672:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 676:	74 06                	je     67e <printf+0xb3>
 678:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 67c:	75 2d                	jne    6ab <printf+0xe0>
        printint(fd, *ap, 16, 0);
 67e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 68a:	00 
 68b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 692:	00 
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 71 fe ff ff       	call   513 <printint>
        ap++;
 6a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a6:	e9 b3 00 00 00       	jmp    75e <printf+0x193>
      } else if(c == 's'){
 6ab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6af:	75 45                	jne    6f6 <printf+0x12b>
        s = (char*)*ap;
 6b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c1:	75 09                	jne    6cc <printf+0x101>
          s = "(null)";
 6c3:	c7 45 f4 40 0d 00 00 	movl   $0xd40,-0xc(%ebp)
        while(*s != 0){
 6ca:	eb 1e                	jmp    6ea <printf+0x11f>
 6cc:	eb 1c                	jmp    6ea <printf+0x11f>
          putc(fd, *s);
 6ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d1:	0f b6 00             	movzbl (%eax),%eax
 6d4:	0f be c0             	movsbl %al,%eax
 6d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	89 04 24             	mov    %eax,(%esp)
 6e1:	e8 05 fe ff ff       	call   4eb <putc>
          s++;
 6e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	84 c0                	test   %al,%al
 6f2:	75 da                	jne    6ce <printf+0x103>
 6f4:	eb 68                	jmp    75e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6fa:	75 1d                	jne    719 <printf+0x14e>
        putc(fd, *ap);
 6fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	0f be c0             	movsbl %al,%eax
 704:	89 44 24 04          	mov    %eax,0x4(%esp)
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	89 04 24             	mov    %eax,(%esp)
 70e:	e8 d8 fd ff ff       	call   4eb <putc>
        ap++;
 713:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 717:	eb 45                	jmp    75e <printf+0x193>
      } else if(c == '%'){
 719:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71d:	75 17                	jne    736 <printf+0x16b>
        putc(fd, c);
 71f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 722:	0f be c0             	movsbl %al,%eax
 725:	89 44 24 04          	mov    %eax,0x4(%esp)
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 b7 fd ff ff       	call   4eb <putc>
 734:	eb 28                	jmp    75e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 736:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 73d:	00 
 73e:	8b 45 08             	mov    0x8(%ebp),%eax
 741:	89 04 24             	mov    %eax,(%esp)
 744:	e8 a2 fd ff ff       	call   4eb <putc>
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	89 44 24 04          	mov    %eax,0x4(%esp)
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	89 04 24             	mov    %eax,(%esp)
 759:	e8 8d fd ff ff       	call   4eb <putc>
      }
      state = 0;
 75e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 765:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 769:	8b 55 0c             	mov    0xc(%ebp),%edx
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	01 d0                	add    %edx,%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	84 c0                	test   %al,%al
 776:	0f 85 71 fe ff ff    	jne    5ed <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 77c:	c9                   	leave  
 77d:	c3                   	ret    

0000077e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	83 e8 08             	sub    $0x8,%eax
 78a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	a1 78 11 00 00       	mov    0x1178,%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	eb 24                	jmp    7bb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79f:	77 12                	ja     7b3 <free+0x35>
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	77 24                	ja     7cd <free+0x4f>
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b1:	77 1a                	ja     7cd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c1:	76 d4                	jbe    797 <free+0x19>
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cb:	76 ca                	jbe    797 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	01 c2                	add    %eax,%edx
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	39 c2                	cmp    %eax,%edx
 7e6:	75 24                	jne    80c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 50 04             	mov    0x4(%eax),%edx
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	01 c2                	add    %eax,%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
 80a:	eb 0a                	jmp    816 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	01 d0                	add    %edx,%eax
 828:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 82b:	75 20                	jne    84d <free+0xcf>
    p->s.size += bp->s.size;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 50 04             	mov    0x4(%eax),%edx
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	01 c2                	add    %eax,%edx
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	8b 10                	mov    (%eax),%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	89 10                	mov    %edx,(%eax)
 84b:	eb 08                	jmp    855 <free+0xd7>
  } else
    p->s.ptr = bp;
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 55 f8             	mov    -0x8(%ebp),%edx
 853:	89 10                	mov    %edx,(%eax)
  freep = p;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	a3 78 11 00 00       	mov    %eax,0x1178
}
 85d:	c9                   	leave  
 85e:	c3                   	ret    

0000085f <morecore>:

static Header*
morecore(uint nu)
{
 85f:	55                   	push   %ebp
 860:	89 e5                	mov    %esp,%ebp
 862:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 865:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 86c:	77 07                	ja     875 <morecore+0x16>
    nu = 4096;
 86e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	c1 e0 03             	shl    $0x3,%eax
 87b:	89 04 24             	mov    %eax,(%esp)
 87e:	e8 20 fc ff ff       	call   4a3 <sbrk>
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 886:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 88a:	75 07                	jne    893 <morecore+0x34>
    return 0;
 88c:	b8 00 00 00 00       	mov    $0x0,%eax
 891:	eb 22                	jmp    8b5 <morecore+0x56>
  hp = (Header*)p;
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	8b 55 08             	mov    0x8(%ebp),%edx
 89f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	83 c0 08             	add    $0x8,%eax
 8a8:	89 04 24             	mov    %eax,(%esp)
 8ab:	e8 ce fe ff ff       	call   77e <free>
  return freep;
 8b0:	a1 78 11 00 00       	mov    0x1178,%eax
}
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    

000008b7 <malloc>:

void*
malloc(uint nbytes)
{
 8b7:	55                   	push   %ebp
 8b8:	89 e5                	mov    %esp,%ebp
 8ba:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8bd:	8b 45 08             	mov    0x8(%ebp),%eax
 8c0:	83 c0 07             	add    $0x7,%eax
 8c3:	c1 e8 03             	shr    $0x3,%eax
 8c6:	83 c0 01             	add    $0x1,%eax
 8c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8cc:	a1 78 11 00 00       	mov    0x1178,%eax
 8d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d8:	75 23                	jne    8fd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8da:	c7 45 f0 70 11 00 00 	movl   $0x1170,-0x10(%ebp)
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	a3 78 11 00 00       	mov    %eax,0x1178
 8e9:	a1 78 11 00 00       	mov    0x1178,%eax
 8ee:	a3 70 11 00 00       	mov    %eax,0x1170
    base.s.size = 0;
 8f3:	c7 05 74 11 00 00 00 	movl   $0x0,0x1174
 8fa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 905:	8b 45 f4             	mov    -0xc(%ebp),%eax
 908:	8b 40 04             	mov    0x4(%eax),%eax
 90b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 90e:	72 4d                	jb     95d <malloc+0xa6>
      if(p->s.size == nunits)
 910:	8b 45 f4             	mov    -0xc(%ebp),%eax
 913:	8b 40 04             	mov    0x4(%eax),%eax
 916:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 919:	75 0c                	jne    927 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 10                	mov    (%eax),%edx
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	89 10                	mov    %edx,(%eax)
 925:	eb 26                	jmp    94d <malloc+0x96>
      else {
        p->s.size -= nunits;
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8b 40 04             	mov    0x4(%eax),%eax
 92d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 930:	89 c2                	mov    %eax,%edx
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	c1 e0 03             	shl    $0x3,%eax
 941:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 944:	8b 45 f4             	mov    -0xc(%ebp),%eax
 947:	8b 55 ec             	mov    -0x14(%ebp),%edx
 94a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 94d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 950:	a3 78 11 00 00       	mov    %eax,0x1178
      return (void*)(p + 1);
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	83 c0 08             	add    $0x8,%eax
 95b:	eb 38                	jmp    995 <malloc+0xde>
    }
    if(p == freep)
 95d:	a1 78 11 00 00       	mov    0x1178,%eax
 962:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 965:	75 1b                	jne    982 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 967:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96a:	89 04 24             	mov    %eax,(%esp)
 96d:	e8 ed fe ff ff       	call   85f <morecore>
 972:	89 45 f4             	mov    %eax,-0xc(%ebp)
 975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 979:	75 07                	jne    982 <malloc+0xcb>
        return 0;
 97b:	b8 00 00 00 00       	mov    $0x0,%eax
 980:	eb 13                	jmp    995 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	8b 45 f4             	mov    -0xc(%ebp),%eax
 985:	89 45 f0             	mov    %eax,-0x10(%ebp)
 988:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 990:	e9 70 ff ff ff       	jmp    905 <malloc+0x4e>
}
 995:	c9                   	leave  
 996:	c3                   	ret    

00000997 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 997:	55                   	push   %ebp
 998:	89 e5                	mov    %esp,%ebp
 99a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 99d:	8b 55 08             	mov    0x8(%ebp),%edx
 9a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9a6:	f0 87 02             	lock xchg %eax,(%edx)
 9a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 9ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 9b4:	8b 45 08             	mov    0x8(%ebp),%eax
 9b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9bd:	5d                   	pop    %ebp
 9be:	c3                   	ret    

000009bf <lock_acquire>:
void lock_acquire(lock_t *lock){
 9bf:	55                   	push   %ebp
 9c0:	89 e5                	mov    %esp,%ebp
 9c2:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9c5:	90                   	nop
 9c6:	8b 45 08             	mov    0x8(%ebp),%eax
 9c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9d0:	00 
 9d1:	89 04 24             	mov    %eax,(%esp)
 9d4:	e8 be ff ff ff       	call   997 <xchg>
 9d9:	85 c0                	test   %eax,%eax
 9db:	75 e9                	jne    9c6 <lock_acquire+0x7>
}
 9dd:	c9                   	leave  
 9de:	c3                   	ret    

000009df <lock_release>:
void lock_release(lock_t *lock){
 9df:	55                   	push   %ebp
 9e0:	89 e5                	mov    %esp,%ebp
 9e2:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9ef:	00 
 9f0:	89 04 24             	mov    %eax,(%esp)
 9f3:	e8 9f ff ff ff       	call   997 <xchg>
}
 9f8:	c9                   	leave  
 9f9:	c3                   	ret    

000009fa <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 9fa:	55                   	push   %ebp
 9fb:	89 e5                	mov    %esp,%ebp
 9fd:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 a00:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 a07:	e8 ab fe ff ff       	call   8b7 <malloc>
 a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 a15:	0f b6 05 7c 11 00 00 	movzbl 0x117c,%eax
 a1c:	84 c0                	test   %al,%al
 a1e:	75 1c                	jne    a3c <thread_create+0x42>
        init_q(thQ2);
 a20:	a1 80 11 00 00       	mov    0x1180,%eax
 a25:	89 04 24             	mov    %eax,(%esp)
 a28:	e8 db 01 00 00       	call   c08 <init_q>
        inQ++;
 a2d:	0f b6 05 7c 11 00 00 	movzbl 0x117c,%eax
 a34:	83 c0 01             	add    $0x1,%eax
 a37:	a2 7c 11 00 00       	mov    %al,0x117c
    }

    if((uint)stack % 4096){
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	25 ff 0f 00 00       	and    $0xfff,%eax
 a44:	85 c0                	test   %eax,%eax
 a46:	74 14                	je     a5c <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	25 ff 0f 00 00       	and    $0xfff,%eax
 a50:	89 c2                	mov    %eax,%edx
 a52:	b8 00 10 00 00       	mov    $0x1000,%eax
 a57:	29 d0                	sub    %edx,%eax
 a59:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a60:	75 1e                	jne    a80 <thread_create+0x86>

        printf(1,"malloc fail \n");
 a62:	c7 44 24 04 47 0d 00 	movl   $0xd47,0x4(%esp)
 a69:	00 
 a6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a71:	e8 55 fb ff ff       	call   5cb <printf>
        return 0;
 a76:	b8 00 00 00 00       	mov    $0x0,%eax
 a7b:	e9 83 00 00 00       	jmp    b03 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a83:	8b 55 08             	mov    0x8(%ebp),%edx
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a8d:	89 54 24 08          	mov    %edx,0x8(%esp)
 a91:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a98:	00 
 a99:	89 04 24             	mov    %eax,(%esp)
 a9c:	e8 1a fa ff ff       	call   4bb <clone>
 aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 aa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 aa8:	79 1b                	jns    ac5 <thread_create+0xcb>
        printf(1,"clone fails\n");
 aaa:	c7 44 24 04 55 0d 00 	movl   $0xd55,0x4(%esp)
 ab1:	00 
 ab2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ab9:	e8 0d fb ff ff       	call   5cb <printf>
        return 0;
 abe:	b8 00 00 00 00       	mov    $0x0,%eax
 ac3:	eb 3e                	jmp    b03 <thread_create+0x109>
    }
    if(tid > 0){
 ac5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ac9:	7e 19                	jle    ae4 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 acb:	a1 80 11 00 00       	mov    0x1180,%eax
 ad0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad3:	89 54 24 04          	mov    %edx,0x4(%esp)
 ad7:	89 04 24             	mov    %eax,(%esp)
 ada:	e8 4b 01 00 00       	call   c2a <add_q>
        return garbage_stack;
 adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae2:	eb 1f                	jmp    b03 <thread_create+0x109>
    }
    if(tid == 0){
 ae4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ae8:	75 14                	jne    afe <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 aea:	c7 44 24 04 62 0d 00 	movl   $0xd62,0x4(%esp)
 af1:	00 
 af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 af9:	e8 cd fa ff ff       	call   5cb <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
 b03:	c9                   	leave  
 b04:	c3                   	ret    

00000b05 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 b05:	55                   	push   %ebp
 b06:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 b08:	a1 6c 11 00 00       	mov    0x116c,%eax
 b0d:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 b13:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 b18:	a3 6c 11 00 00       	mov    %eax,0x116c
    return (int)(rands % max);
 b1d:	a1 6c 11 00 00       	mov    0x116c,%eax
 b22:	8b 4d 08             	mov    0x8(%ebp),%ecx
 b25:	ba 00 00 00 00       	mov    $0x0,%edx
 b2a:	f7 f1                	div    %ecx
 b2c:	89 d0                	mov    %edx,%eax
}
 b2e:	5d                   	pop    %ebp
 b2f:	c3                   	ret    

00000b30 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 b36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 b3c:	8b 40 10             	mov    0x10(%eax),%eax
 b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 b42:	a1 80 11 00 00       	mov    0x1180,%eax
 b47:	8b 00                	mov    (%eax),%eax
 b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b4c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 b50:	89 44 24 08          	mov    %eax,0x8(%esp)
 b54:	c7 44 24 04 73 0d 00 	movl   $0xd73,0x4(%esp)
 b5b:	00 
 b5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b63:	e8 63 fa ff ff       	call   5cb <printf>
    add_q(thQ2, tid2);
 b68:	a1 80 11 00 00       	mov    0x1180,%eax
 b6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b70:	89 54 24 04          	mov    %edx,0x4(%esp)
 b74:	89 04 24             	mov    %eax,(%esp)
 b77:	e8 ae 00 00 00       	call   c2a <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 b7c:	a1 80 11 00 00       	mov    0x1180,%eax
 b81:	8b 00                	mov    (%eax),%eax
 b83:	89 44 24 08          	mov    %eax,0x8(%esp)
 b87:	c7 44 24 04 8b 0d 00 	movl   $0xd8b,0x4(%esp)
 b8e:	00 
 b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b96:	e8 30 fa ff ff       	call   5cb <printf>
    int tidNext = pop_q(thQ2);
 b9b:	a1 80 11 00 00       	mov    0x1180,%eax
 ba0:	89 04 24             	mov    %eax,(%esp)
 ba3:	e8 fc 00 00 00       	call   ca4 <pop_q>
 ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 bab:	eb 10                	jmp    bbd <thread_yield2+0x8d>
 bad:	a1 80 11 00 00       	mov    0x1180,%eax
 bb2:	89 04 24             	mov    %eax,(%esp)
 bb5:	e8 ea 00 00 00       	call   ca4 <pop_q>
 bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 bc3:	74 e8                	je     bad <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 bc5:	a1 80 11 00 00       	mov    0x1180,%eax
 bca:	8b 00                	mov    (%eax),%eax
 bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bcf:	89 54 24 0c          	mov    %edx,0xc(%esp)
 bd3:	89 44 24 08          	mov    %eax,0x8(%esp)
 bd7:	c7 44 24 04 9b 0d 00 	movl   $0xd9b,0x4(%esp)
 bde:	00 
 bdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 be6:	e8 e0 f9 ff ff       	call   5cb <printf>
    tsleep();
 beb:	e8 db f8 ff ff       	call   4cb <tsleep>
    twakeup(tidNext);
 bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf3:	89 04 24             	mov    %eax,(%esp)
 bf6:	e8 d8 f8 ff ff       	call   4d3 <twakeup>
    thread_yield3(tidNext);
 bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfe:	89 04 24             	mov    %eax,(%esp)
 c01:	e8 dd f8 ff ff       	call   4e3 <thread_yield3>
    //yield();
 c06:	c9                   	leave  
 c07:	c3                   	ret    

00000c08 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 c08:	55                   	push   %ebp
 c09:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 c0b:	8b 45 08             	mov    0x8(%ebp),%eax
 c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 c14:	8b 45 08             	mov    0x8(%ebp),%eax
 c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 c1e:	8b 45 08             	mov    0x8(%ebp),%eax
 c21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 c28:	5d                   	pop    %ebp
 c29:	c3                   	ret    

00000c2a <add_q>:

void add_q(struct queue *q, int v){
 c2a:	55                   	push   %ebp
 c2b:	89 e5                	mov    %esp,%ebp
 c2d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 c30:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c37:	e8 7b fc ff ff       	call   8b7 <malloc>
 c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
 c4f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 c51:	8b 45 08             	mov    0x8(%ebp),%eax
 c54:	8b 40 04             	mov    0x4(%eax),%eax
 c57:	85 c0                	test   %eax,%eax
 c59:	75 0b                	jne    c66 <add_q+0x3c>
        q->head = n;
 c5b:	8b 45 08             	mov    0x8(%ebp),%eax
 c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c61:	89 50 04             	mov    %edx,0x4(%eax)
 c64:	eb 0c                	jmp    c72 <add_q+0x48>
    }else{
        q->tail->next = n;
 c66:	8b 45 08             	mov    0x8(%ebp),%eax
 c69:	8b 40 08             	mov    0x8(%eax),%eax
 c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c6f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 c72:	8b 45 08             	mov    0x8(%ebp),%eax
 c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c78:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 c7b:	8b 45 08             	mov    0x8(%ebp),%eax
 c7e:	8b 00                	mov    (%eax),%eax
 c80:	8d 50 01             	lea    0x1(%eax),%edx
 c83:	8b 45 08             	mov    0x8(%ebp),%eax
 c86:	89 10                	mov    %edx,(%eax)
}
 c88:	c9                   	leave  
 c89:	c3                   	ret    

00000c8a <empty_q>:

int empty_q(struct queue *q){
 c8a:	55                   	push   %ebp
 c8b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 c8d:	8b 45 08             	mov    0x8(%ebp),%eax
 c90:	8b 00                	mov    (%eax),%eax
 c92:	85 c0                	test   %eax,%eax
 c94:	75 07                	jne    c9d <empty_q+0x13>
        return 1;
 c96:	b8 01 00 00 00       	mov    $0x1,%eax
 c9b:	eb 05                	jmp    ca2 <empty_q+0x18>
    else
        return 0;
 c9d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 ca2:	5d                   	pop    %ebp
 ca3:	c3                   	ret    

00000ca4 <pop_q>:
int pop_q(struct queue *q){
 ca4:	55                   	push   %ebp
 ca5:	89 e5                	mov    %esp,%ebp
 ca7:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 caa:	8b 45 08             	mov    0x8(%ebp),%eax
 cad:	89 04 24             	mov    %eax,(%esp)
 cb0:	e8 d5 ff ff ff       	call   c8a <empty_q>
 cb5:	85 c0                	test   %eax,%eax
 cb7:	75 5d                	jne    d16 <pop_q+0x72>
       val = q->head->value; 
 cb9:	8b 45 08             	mov    0x8(%ebp),%eax
 cbc:	8b 40 04             	mov    0x4(%eax),%eax
 cbf:	8b 00                	mov    (%eax),%eax
 cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 cc4:	8b 45 08             	mov    0x8(%ebp),%eax
 cc7:	8b 40 04             	mov    0x4(%eax),%eax
 cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 ccd:	8b 45 08             	mov    0x8(%ebp),%eax
 cd0:	8b 40 04             	mov    0x4(%eax),%eax
 cd3:	8b 50 04             	mov    0x4(%eax),%edx
 cd6:	8b 45 08             	mov    0x8(%ebp),%eax
 cd9:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cdf:	89 04 24             	mov    %eax,(%esp)
 ce2:	e8 97 fa ff ff       	call   77e <free>
       q->size--;
 ce7:	8b 45 08             	mov    0x8(%ebp),%eax
 cea:	8b 00                	mov    (%eax),%eax
 cec:	8d 50 ff             	lea    -0x1(%eax),%edx
 cef:	8b 45 08             	mov    0x8(%ebp),%eax
 cf2:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 cf4:	8b 45 08             	mov    0x8(%ebp),%eax
 cf7:	8b 00                	mov    (%eax),%eax
 cf9:	85 c0                	test   %eax,%eax
 cfb:	75 14                	jne    d11 <pop_q+0x6d>
            q->head = 0;
 cfd:	8b 45 08             	mov    0x8(%ebp),%eax
 d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 d07:	8b 45 08             	mov    0x8(%ebp),%eax
 d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d14:	eb 05                	jmp    d1b <pop_q+0x77>
    }
    return -1;
 d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 d1b:	c9                   	leave  
 d1c:	c3                   	ret    
