
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

int n = 1;

void test_func(void * arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp

   printf(1,"thread_create test begin\n\n");
   9:	c7 44 24 04 49 0c 00 	movl   $0xc49,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 da 04 00 00       	call   4f7 <printf>

   printf(1,"before thread_create n = %d\n",n);
  1d:	a1 f0 10 00 00       	mov    0x10f0,%eax
  22:	89 44 24 08          	mov    %eax,0x8(%esp)
  26:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  35:	e8 bd 04 00 00       	call   4f7 <printf>

   int arg = 10;
  3a:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
  41:	00 
   void *tid = thread_create(test_func, (void *)&arg);
  42:	8d 44 24 18          	lea    0x18(%esp),%eax
  46:	89 44 24 04          	mov    %eax,0x4(%esp)
  4a:	c7 04 24 a7 00 00 00 	movl   $0xa7,(%esp)
  51:	e8 d0 08 00 00       	call   926 <thread_create>
  56:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  5a:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  5f:	75 19                	jne    7a <main+0x7a>
       printf(1,"wrong happen");
  61:	c7 44 24 04 81 0c 00 	movl   $0xc81,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 82 04 00 00       	call   4f7 <printf>
       exit();
  75:	e8 cd 02 00 00       	call   347 <exit>
   } 
   while(wait()>= 0)
  7a:	eb 1d                	jmp    99 <main+0x99>
   printf(1,"\nback to parent n = %d\n",n);
  7c:	a1 f0 10 00 00       	mov    0x10f0,%eax
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	c7 44 24 04 8e 0c 00 	movl   $0xc8e,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 5e 04 00 00       	call   4f7 <printf>
   void *tid = thread_create(test_func, (void *)&arg);
   if(tid <= 0){
       printf(1,"wrong happen");
       exit();
   } 
   while(wait()>= 0)
  99:	e8 b1 02 00 00       	call   34f <wait>
  9e:	85 c0                	test   %eax,%eax
  a0:	79 da                	jns    7c <main+0x7c>
   printf(1,"\nback to parent n = %d\n",n);
   
   exit();
  a2:	e8 a0 02 00 00       	call   347 <exit>

000000a7 <test_func>:
}

//void test_func(void *arg_ptr){
void test_func(void *arg_ptr){
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  ad:	8b 45 08             	mov    0x8(%ebp),%eax
  b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = *num; 
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	8b 00                	mov    (%eax),%eax
  b8:	a3 f0 10 00 00       	mov    %eax,0x10f0
    printf(1,"\n n is updated as %d\n",*num);
  bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  c6:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
  cd:	00 
  ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d5:	e8 1d 04 00 00       	call   4f7 <printf>
    texit();
  da:	e8 10 03 00 00       	call   3ef <texit>

000000df <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	57                   	push   %edi
  e3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e7:	8b 55 10             	mov    0x10(%ebp),%edx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 cb                	mov    %ecx,%ebx
  ef:	89 df                	mov    %ebx,%edi
  f1:	89 d1                	mov    %edx,%ecx
  f3:	fc                   	cld    
  f4:	f3 aa                	rep stos %al,%es:(%edi)
  f6:	89 ca                	mov    %ecx,%edx
  f8:	89 fb                	mov    %edi,%ebx
  fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  fd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 100:	5b                   	pop    %ebx
 101:	5f                   	pop    %edi
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    

00000104 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 110:	90                   	nop
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	8d 50 01             	lea    0x1(%eax),%edx
 117:	89 55 08             	mov    %edx,0x8(%ebp)
 11a:	8b 55 0c             	mov    0xc(%ebp),%edx
 11d:	8d 4a 01             	lea    0x1(%edx),%ecx
 120:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 123:	0f b6 12             	movzbl (%edx),%edx
 126:	88 10                	mov    %dl,(%eax)
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 e2                	jne    111 <strcpy+0xd>
    ;
  return os;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 137:	eb 08                	jmp    141 <strcmp+0xd>
    p++, q++;
 139:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	84 c0                	test   %al,%al
 149:	74 10                	je     15b <strcmp+0x27>
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 10             	movzbl (%eax),%edx
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	38 c2                	cmp    %al,%dl
 159:	74 de                	je     139 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	0f b6 d0             	movzbl %al,%edx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	0f b6 c0             	movzbl %al,%eax
 16d:	29 c2                	sub    %eax,%edx
 16f:	89 d0                	mov    %edx,%eax
}
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    

00000173 <strlen>:

uint
strlen(char *s)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 180:	eb 04                	jmp    186 <strlen+0x13>
 182:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 186:	8b 55 fc             	mov    -0x4(%ebp),%edx
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	01 d0                	add    %edx,%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	84 c0                	test   %al,%al
 193:	75 ed                	jne    182 <strlen+0xf>
    ;
  return n;
 195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <memset>:

void*
memset(void *dst, int c, uint n)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1a0:	8b 45 10             	mov    0x10(%ebp),%eax
 1a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	89 04 24             	mov    %eax,(%esp)
 1b4:	e8 26 ff ff ff       	call   df <stosb>
  return dst;
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <strchr>:

char*
strchr(const char *s, char c)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ca:	eb 14                	jmp    1e0 <strchr+0x22>
    if(*s == c)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d5:	75 05                	jne    1dc <strchr+0x1e>
      return (char*)s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	eb 13                	jmp    1ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	84 c0                	test   %al,%al
 1e8:	75 e2                	jne    1cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <gets>:

char*
gets(char *buf, int max)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fe:	eb 4c                	jmp    24c <gets+0x5b>
    cc = read(0, &c, 1);
 200:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 207:	00 
 208:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20b:	89 44 24 04          	mov    %eax,0x4(%esp)
 20f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 216:	e8 44 01 00 00       	call   35f <read>
 21b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 222:	7f 02                	jg     226 <gets+0x35>
      break;
 224:	eb 31                	jmp    257 <gets+0x66>
    buf[i++] = c;
 226:	8b 45 f4             	mov    -0xc(%ebp),%eax
 229:	8d 50 01             	lea    0x1(%eax),%edx
 22c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22f:	89 c2                	mov    %eax,%edx
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	01 c2                	add    %eax,%edx
 236:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 240:	3c 0a                	cmp    $0xa,%al
 242:	74 13                	je     257 <gets+0x66>
 244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 248:	3c 0d                	cmp    $0xd,%al
 24a:	74 0b                	je     257 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24f:	83 c0 01             	add    $0x1,%eax
 252:	3b 45 0c             	cmp    0xc(%ebp),%eax
 255:	7c a9                	jl     200 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 257:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	01 d0                	add    %edx,%eax
 25f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 262:	8b 45 08             	mov    0x8(%ebp),%eax
}
 265:	c9                   	leave  
 266:	c3                   	ret    

00000267 <stat>:

int
stat(char *n, struct stat *st)
{
 267:	55                   	push   %ebp
 268:	89 e5                	mov    %esp,%ebp
 26a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 274:	00 
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	89 04 24             	mov    %eax,(%esp)
 27b:	e8 07 01 00 00       	call   387 <open>
 280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 287:	79 07                	jns    290 <stat+0x29>
    return -1;
 289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28e:	eb 23                	jmp    2b3 <stat+0x4c>
  r = fstat(fd, st);
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 44 24 04          	mov    %eax,0x4(%esp)
 297:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 fd 00 00 00       	call   39f <fstat>
 2a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	89 04 24             	mov    %eax,(%esp)
 2ab:	e8 bf 00 00 00       	call   36f <close>
  return r;
 2b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b3:	c9                   	leave  
 2b4:	c3                   	ret    

000002b5 <atoi>:

int
atoi(const char *s)
{
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c2:	eb 25                	jmp    2e9 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c7:	89 d0                	mov    %edx,%eax
 2c9:	c1 e0 02             	shl    $0x2,%eax
 2cc:	01 d0                	add    %edx,%eax
 2ce:	01 c0                	add    %eax,%eax
 2d0:	89 c1                	mov    %eax,%ecx
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	8d 50 01             	lea    0x1(%eax),%edx
 2d8:	89 55 08             	mov    %edx,0x8(%ebp)
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	0f be c0             	movsbl %al,%eax
 2e1:	01 c8                	add    %ecx,%eax
 2e3:	83 e8 30             	sub    $0x30,%eax
 2e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 2f                	cmp    $0x2f,%al
 2f1:	7e 0a                	jle    2fd <atoi+0x48>
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 39                	cmp    $0x39,%al
 2fb:	7e c7                	jle    2c4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 300:	c9                   	leave  
 301:	c3                   	ret    

00000302 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30e:	8b 45 0c             	mov    0xc(%ebp),%eax
 311:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 314:	eb 17                	jmp    32d <memmove+0x2b>
    *dst++ = *src++;
 316:	8b 45 fc             	mov    -0x4(%ebp),%eax
 319:	8d 50 01             	lea    0x1(%eax),%edx
 31c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 31f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 322:	8d 4a 01             	lea    0x1(%edx),%ecx
 325:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 328:	0f b6 12             	movzbl (%edx),%edx
 32b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32d:	8b 45 10             	mov    0x10(%ebp),%eax
 330:	8d 50 ff             	lea    -0x1(%eax),%edx
 333:	89 55 10             	mov    %edx,0x10(%ebp)
 336:	85 c0                	test   %eax,%eax
 338:	7f dc                	jg     316 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33f:	b8 01 00 00 00       	mov    $0x1,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <exit>:
SYSCALL(exit)
 347:	b8 02 00 00 00       	mov    $0x2,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <wait>:
SYSCALL(wait)
 34f:	b8 03 00 00 00       	mov    $0x3,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <pipe>:
SYSCALL(pipe)
 357:	b8 04 00 00 00       	mov    $0x4,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <read>:
SYSCALL(read)
 35f:	b8 05 00 00 00       	mov    $0x5,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <write>:
SYSCALL(write)
 367:	b8 10 00 00 00       	mov    $0x10,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <close>:
SYSCALL(close)
 36f:	b8 15 00 00 00       	mov    $0x15,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <kill>:
SYSCALL(kill)
 377:	b8 06 00 00 00       	mov    $0x6,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <exec>:
SYSCALL(exec)
 37f:	b8 07 00 00 00       	mov    $0x7,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <open>:
SYSCALL(open)
 387:	b8 0f 00 00 00       	mov    $0xf,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <mknod>:
SYSCALL(mknod)
 38f:	b8 11 00 00 00       	mov    $0x11,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <unlink>:
SYSCALL(unlink)
 397:	b8 12 00 00 00       	mov    $0x12,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <fstat>:
SYSCALL(fstat)
 39f:	b8 08 00 00 00       	mov    $0x8,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <link>:
SYSCALL(link)
 3a7:	b8 13 00 00 00       	mov    $0x13,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <mkdir>:
SYSCALL(mkdir)
 3af:	b8 14 00 00 00       	mov    $0x14,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <chdir>:
SYSCALL(chdir)
 3b7:	b8 09 00 00 00       	mov    $0x9,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <dup>:
SYSCALL(dup)
 3bf:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <getpid>:
SYSCALL(getpid)
 3c7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <sbrk>:
SYSCALL(sbrk)
 3cf:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <sleep>:
SYSCALL(sleep)
 3d7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <uptime>:
SYSCALL(uptime)
 3df:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <clone>:
SYSCALL(clone)
 3e7:	b8 16 00 00 00       	mov    $0x16,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <texit>:
SYSCALL(texit)
 3ef:	b8 17 00 00 00       	mov    $0x17,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <tsleep>:
SYSCALL(tsleep)
 3f7:	b8 18 00 00 00       	mov    $0x18,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <twakeup>:
SYSCALL(twakeup)
 3ff:	b8 19 00 00 00       	mov    $0x19,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <thread_yield>:
SYSCALL(thread_yield)
 407:	b8 1a 00 00 00       	mov    $0x1a,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <thread_yield3>:
 40f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	83 ec 18             	sub    $0x18,%esp
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 423:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42a:	00 
 42b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42e:	89 44 24 04          	mov    %eax,0x4(%esp)
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	89 04 24             	mov    %eax,(%esp)
 438:	e8 2a ff ff ff       	call   367 <write>
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	56                   	push   %esi
 443:	53                   	push   %ebx
 444:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 447:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 452:	74 17                	je     46b <printint+0x2c>
 454:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 458:	79 11                	jns    46b <printint+0x2c>
    neg = 1;
 45a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 461:	8b 45 0c             	mov    0xc(%ebp),%eax
 464:	f7 d8                	neg    %eax
 466:	89 45 ec             	mov    %eax,-0x14(%ebp)
 469:	eb 06                	jmp    471 <printint+0x32>
  } else {
    x = xx;
 46b:	8b 45 0c             	mov    0xc(%ebp),%eax
 46e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 478:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 47b:	8d 41 01             	lea    0x1(%ecx),%eax
 47e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 481:	8b 5d 10             	mov    0x10(%ebp),%ebx
 484:	8b 45 ec             	mov    -0x14(%ebp),%eax
 487:	ba 00 00 00 00       	mov    $0x0,%edx
 48c:	f7 f3                	div    %ebx
 48e:	89 d0                	mov    %edx,%eax
 490:	0f b6 80 f4 10 00 00 	movzbl 0x10f4(%eax),%eax
 497:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 49b:	8b 75 10             	mov    0x10(%ebp),%esi
 49e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a1:	ba 00 00 00 00       	mov    $0x0,%edx
 4a6:	f7 f6                	div    %esi
 4a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4af:	75 c7                	jne    478 <printint+0x39>
  if(neg)
 4b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b5:	74 10                	je     4c7 <printint+0x88>
    buf[i++] = '-';
 4b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ba:	8d 50 01             	lea    0x1(%eax),%edx
 4bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c5:	eb 1f                	jmp    4e6 <printint+0xa7>
 4c7:	eb 1d                	jmp    4e6 <printint+0xa7>
    putc(fd, buf[i]);
 4c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cf:	01 d0                	add    %edx,%eax
 4d1:	0f b6 00             	movzbl (%eax),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	89 04 24             	mov    %eax,(%esp)
 4e1:	e8 31 ff ff ff       	call   417 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ee:	79 d9                	jns    4c9 <printint+0x8a>
    putc(fd, buf[i]);
}
 4f0:	83 c4 30             	add    $0x30,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5d                   	pop    %ebp
 4f6:	c3                   	ret    

000004f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f7:	55                   	push   %ebp
 4f8:	89 e5                	mov    %esp,%ebp
 4fa:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 504:	8d 45 0c             	lea    0xc(%ebp),%eax
 507:	83 c0 04             	add    $0x4,%eax
 50a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 514:	e9 7c 01 00 00       	jmp    695 <printf+0x19e>
    c = fmt[i] & 0xff;
 519:	8b 55 0c             	mov    0xc(%ebp),%edx
 51c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51f:	01 d0                	add    %edx,%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	25 ff 00 00 00       	and    $0xff,%eax
 52c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 2c                	jne    561 <printf+0x6a>
      if(c == '%'){
 535:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 539:	75 0c                	jne    547 <printf+0x50>
        state = '%';
 53b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 542:	e9 4a 01 00 00       	jmp    691 <printf+0x19a>
      } else {
        putc(fd, c);
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	89 44 24 04          	mov    %eax,0x4(%esp)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	89 04 24             	mov    %eax,(%esp)
 557:	e8 bb fe ff ff       	call   417 <putc>
 55c:	e9 30 01 00 00       	jmp    691 <printf+0x19a>
      }
    } else if(state == '%'){
 561:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 565:	0f 85 26 01 00 00    	jne    691 <printf+0x19a>
      if(c == 'd'){
 56b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56f:	75 2d                	jne    59e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57d:	00 
 57e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 585:	00 
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 aa fe ff ff       	call   43f <printint>
        ap++;
 595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 599:	e9 ec 00 00 00       	jmp    68a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 59e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a2:	74 06                	je     5aa <printf+0xb3>
 5a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a8:	75 2d                	jne    5d7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b6:	00 
 5b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5be:	00 
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 71 fe ff ff       	call   43f <printint>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 b3 00 00 00       	jmp    68a <printf+0x193>
      } else if(c == 's'){
 5d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5db:	75 45                	jne    622 <printf+0x12b>
        s = (char*)*ap;
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ed:	75 09                	jne    5f8 <printf+0x101>
          s = "(null)";
 5ef:	c7 45 f4 bc 0c 00 00 	movl   $0xcbc,-0xc(%ebp)
        while(*s != 0){
 5f6:	eb 1e                	jmp    616 <printf+0x11f>
 5f8:	eb 1c                	jmp    616 <printf+0x11f>
          putc(fd, *s);
 5fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	89 44 24 04          	mov    %eax,0x4(%esp)
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	89 04 24             	mov    %eax,(%esp)
 60d:	e8 05 fe ff ff       	call   417 <putc>
          s++;
 612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 616:	8b 45 f4             	mov    -0xc(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	84 c0                	test   %al,%al
 61e:	75 da                	jne    5fa <printf+0x103>
 620:	eb 68                	jmp    68a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 622:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 626:	75 1d                	jne    645 <printf+0x14e>
        putc(fd, *ap);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	89 44 24 04          	mov    %eax,0x4(%esp)
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 d8 fd ff ff       	call   417 <putc>
        ap++;
 63f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 643:	eb 45                	jmp    68a <printf+0x193>
      } else if(c == '%'){
 645:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 649:	75 17                	jne    662 <printf+0x16b>
        putc(fd, c);
 64b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64e:	0f be c0             	movsbl %al,%eax
 651:	89 44 24 04          	mov    %eax,0x4(%esp)
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 b7 fd ff ff       	call   417 <putc>
 660:	eb 28                	jmp    68a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 662:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 669:	00 
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	89 04 24             	mov    %eax,(%esp)
 670:	e8 a2 fd ff ff       	call   417 <putc>
        putc(fd, c);
 675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	89 44 24 04          	mov    %eax,0x4(%esp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 8d fd ff ff       	call   417 <putc>
      }
      state = 0;
 68a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 691:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 695:	8b 55 0c             	mov    0xc(%ebp),%edx
 698:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	0f b6 00             	movzbl (%eax),%eax
 6a0:	84 c0                	test   %al,%al
 6a2:	0f 85 71 fe ff ff    	jne    519 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a8:	c9                   	leave  
 6a9:	c3                   	ret    

000006aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6aa:	55                   	push   %ebp
 6ab:	89 e5                	mov    %esp,%ebp
 6ad:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	83 e8 08             	sub    $0x8,%eax
 6b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b9:	a1 14 11 00 00       	mov    0x1114,%eax
 6be:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c1:	eb 24                	jmp    6e7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	77 12                	ja     6df <free+0x35>
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d3:	77 24                	ja     6f9 <free+0x4f>
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dd:	77 1a                	ja     6f9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	76 d4                	jbe    6c3 <free+0x19>
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f7:	76 ca                	jbe    6c3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	8b 40 04             	mov    0x4(%eax),%eax
 6ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	01 c2                	add    %eax,%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	39 c2                	cmp    %eax,%edx
 712:	75 24                	jne    738 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	8b 50 04             	mov    0x4(%eax),%edx
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	01 c2                	add    %eax,%edx
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	8b 10                	mov    (%eax),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	89 10                	mov    %edx,(%eax)
 736:	eb 0a                	jmp    742 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 10                	mov    (%eax),%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	01 d0                	add    %edx,%eax
 754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 757:	75 20                	jne    779 <free+0xcf>
    p->s.size += bp->s.size;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 50 04             	mov    0x4(%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	8b 40 04             	mov    0x4(%eax),%eax
 765:	01 c2                	add    %eax,%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	8b 10                	mov    (%eax),%edx
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	89 10                	mov    %edx,(%eax)
 777:	eb 08                	jmp    781 <free+0xd7>
  } else
    p->s.ptr = bp;
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 77f:	89 10                	mov    %edx,(%eax)
  freep = p;
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	a3 14 11 00 00       	mov    %eax,0x1114
}
 789:	c9                   	leave  
 78a:	c3                   	ret    

0000078b <morecore>:

static Header*
morecore(uint nu)
{
 78b:	55                   	push   %ebp
 78c:	89 e5                	mov    %esp,%ebp
 78e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 791:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 798:	77 07                	ja     7a1 <morecore+0x16>
    nu = 4096;
 79a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	c1 e0 03             	shl    $0x3,%eax
 7a7:	89 04 24             	mov    %eax,(%esp)
 7aa:	e8 20 fc ff ff       	call   3cf <sbrk>
 7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b6:	75 07                	jne    7bf <morecore+0x34>
    return 0;
 7b8:	b8 00 00 00 00       	mov    $0x0,%eax
 7bd:	eb 22                	jmp    7e1 <morecore+0x56>
  hp = (Header*)p;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	8b 55 08             	mov    0x8(%ebp),%edx
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	83 c0 08             	add    $0x8,%eax
 7d4:	89 04 24             	mov    %eax,(%esp)
 7d7:	e8 ce fe ff ff       	call   6aa <free>
  return freep;
 7dc:	a1 14 11 00 00       	mov    0x1114,%eax
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    

000007e3 <malloc>:

void*
malloc(uint nbytes)
{
 7e3:	55                   	push   %ebp
 7e4:	89 e5                	mov    %esp,%ebp
 7e6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ec:	83 c0 07             	add    $0x7,%eax
 7ef:	c1 e8 03             	shr    $0x3,%eax
 7f2:	83 c0 01             	add    $0x1,%eax
 7f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f8:	a1 14 11 00 00       	mov    0x1114,%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 804:	75 23                	jne    829 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 806:	c7 45 f0 0c 11 00 00 	movl   $0x110c,-0x10(%ebp)
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	a3 14 11 00 00       	mov    %eax,0x1114
 815:	a1 14 11 00 00       	mov    0x1114,%eax
 81a:	a3 0c 11 00 00       	mov    %eax,0x110c
    base.s.size = 0;
 81f:	c7 05 10 11 00 00 00 	movl   $0x0,0x1110
 826:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83a:	72 4d                	jb     889 <malloc+0xa6>
      if(p->s.size == nunits)
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 845:	75 0c                	jne    853 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 10                	mov    (%eax),%edx
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	89 10                	mov    %edx,(%eax)
 851:	eb 26                	jmp    879 <malloc+0x96>
      else {
        p->s.size -= nunits;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	2b 45 ec             	sub    -0x14(%ebp),%eax
 85c:	89 c2                	mov    %eax,%edx
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	c1 e0 03             	shl    $0x3,%eax
 86d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 55 ec             	mov    -0x14(%ebp),%edx
 876:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 879:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87c:	a3 14 11 00 00       	mov    %eax,0x1114
      return (void*)(p + 1);
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	83 c0 08             	add    $0x8,%eax
 887:	eb 38                	jmp    8c1 <malloc+0xde>
    }
    if(p == freep)
 889:	a1 14 11 00 00       	mov    0x1114,%eax
 88e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 891:	75 1b                	jne    8ae <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 893:	8b 45 ec             	mov    -0x14(%ebp),%eax
 896:	89 04 24             	mov    %eax,(%esp)
 899:	e8 ed fe ff ff       	call   78b <morecore>
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a5:	75 07                	jne    8ae <malloc+0xcb>
        return 0;
 8a7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ac:	eb 13                	jmp    8c1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8bc:	e9 70 ff ff ff       	jmp    831 <malloc+0x4e>
}
 8c1:	c9                   	leave  
 8c2:	c3                   	ret    

000008c3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8c3:	55                   	push   %ebp
 8c4:	89 e5                	mov    %esp,%ebp
 8c6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8c9:	8b 55 08             	mov    0x8(%ebp),%edx
 8cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 8cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8d2:	f0 87 02             	lock xchg %eax,(%edx)
 8d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    

000008dd <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8e9:	5d                   	pop    %ebp
 8ea:	c3                   	ret    

000008eb <lock_acquire>:
void lock_acquire(lock_t *lock){
 8eb:	55                   	push   %ebp
 8ec:	89 e5                	mov    %esp,%ebp
 8ee:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 8f1:	90                   	nop
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8fc:	00 
 8fd:	89 04 24             	mov    %eax,(%esp)
 900:	e8 be ff ff ff       	call   8c3 <xchg>
 905:	85 c0                	test   %eax,%eax
 907:	75 e9                	jne    8f2 <lock_acquire+0x7>
}
 909:	c9                   	leave  
 90a:	c3                   	ret    

0000090b <lock_release>:
void lock_release(lock_t *lock){
 90b:	55                   	push   %ebp
 90c:	89 e5                	mov    %esp,%ebp
 90e:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 911:	8b 45 08             	mov    0x8(%ebp),%eax
 914:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 91b:	00 
 91c:	89 04 24             	mov    %eax,(%esp)
 91f:	e8 9f ff ff ff       	call   8c3 <xchg>
}
 924:	c9                   	leave  
 925:	c3                   	ret    

00000926 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 926:	55                   	push   %ebp
 927:	89 e5                	mov    %esp,%ebp
 929:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 92c:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 933:	e8 ab fe ff ff       	call   7e3 <malloc>
 938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 941:	0f b6 05 18 11 00 00 	movzbl 0x1118,%eax
 948:	84 c0                	test   %al,%al
 94a:	75 1c                	jne    968 <thread_create+0x42>
        init_q(thQ2);
 94c:	a1 1c 11 00 00       	mov    0x111c,%eax
 951:	89 04 24             	mov    %eax,(%esp)
 954:	e8 db 01 00 00       	call   b34 <init_q>
        inQ++;
 959:	0f b6 05 18 11 00 00 	movzbl 0x1118,%eax
 960:	83 c0 01             	add    $0x1,%eax
 963:	a2 18 11 00 00       	mov    %al,0x1118
    }

    if((uint)stack % 4096){
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	25 ff 0f 00 00       	and    $0xfff,%eax
 970:	85 c0                	test   %eax,%eax
 972:	74 14                	je     988 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 977:	25 ff 0f 00 00       	and    $0xfff,%eax
 97c:	89 c2                	mov    %eax,%edx
 97e:	b8 00 10 00 00       	mov    $0x1000,%eax
 983:	29 d0                	sub    %edx,%eax
 985:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98c:	75 1e                	jne    9ac <thread_create+0x86>

        printf(1,"malloc fail \n");
 98e:	c7 44 24 04 c3 0c 00 	movl   $0xcc3,0x4(%esp)
 995:	00 
 996:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 99d:	e8 55 fb ff ff       	call   4f7 <printf>
        return 0;
 9a2:	b8 00 00 00 00       	mov    $0x0,%eax
 9a7:	e9 83 00 00 00       	jmp    a2f <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 9ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 9af:	8b 55 08             	mov    0x8(%ebp),%edx
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 9b9:	89 54 24 08          	mov    %edx,0x8(%esp)
 9bd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9c4:	00 
 9c5:	89 04 24             	mov    %eax,(%esp)
 9c8:	e8 1a fa ff ff       	call   3e7 <clone>
 9cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 9d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9d4:	79 1b                	jns    9f1 <thread_create+0xcb>
        printf(1,"clone fails\n");
 9d6:	c7 44 24 04 d1 0c 00 	movl   $0xcd1,0x4(%esp)
 9dd:	00 
 9de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9e5:	e8 0d fb ff ff       	call   4f7 <printf>
        return 0;
 9ea:	b8 00 00 00 00       	mov    $0x0,%eax
 9ef:	eb 3e                	jmp    a2f <thread_create+0x109>
    }
    if(tid > 0){
 9f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f5:	7e 19                	jle    a10 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 9f7:	a1 1c 11 00 00       	mov    0x111c,%eax
 9fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9ff:	89 54 24 04          	mov    %edx,0x4(%esp)
 a03:	89 04 24             	mov    %eax,(%esp)
 a06:	e8 4b 01 00 00       	call   b56 <add_q>
        return garbage_stack;
 a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0e:	eb 1f                	jmp    a2f <thread_create+0x109>
    }
    if(tid == 0){
 a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a14:	75 14                	jne    a2a <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 a16:	c7 44 24 04 de 0c 00 	movl   $0xcde,0x4(%esp)
 a1d:	00 
 a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a25:	e8 cd fa ff ff       	call   4f7 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a2f:	c9                   	leave  
 a30:	c3                   	ret    

00000a31 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a31:	55                   	push   %ebp
 a32:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a34:	a1 08 11 00 00       	mov    0x1108,%eax
 a39:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 a3f:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 a44:	a3 08 11 00 00       	mov    %eax,0x1108
    return (int)(rands % max);
 a49:	a1 08 11 00 00       	mov    0x1108,%eax
 a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a51:	ba 00 00 00 00       	mov    $0x0,%edx
 a56:	f7 f1                	div    %ecx
 a58:	89 d0                	mov    %edx,%eax
}
 a5a:	5d                   	pop    %ebp
 a5b:	c3                   	ret    

00000a5c <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 a5c:	55                   	push   %ebp
 a5d:	89 e5                	mov    %esp,%ebp
 a5f:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 a62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 a68:	8b 40 10             	mov    0x10(%eax),%eax
 a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 a6e:	a1 1c 11 00 00       	mov    0x111c,%eax
 a73:	8b 00                	mov    (%eax),%eax
 a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a78:	89 54 24 0c          	mov    %edx,0xc(%esp)
 a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
 a80:	c7 44 24 04 ef 0c 00 	movl   $0xcef,0x4(%esp)
 a87:	00 
 a88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a8f:	e8 63 fa ff ff       	call   4f7 <printf>
    add_q(thQ2, tid2);
 a94:	a1 1c 11 00 00       	mov    0x111c,%eax
 a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a9c:	89 54 24 04          	mov    %edx,0x4(%esp)
 aa0:	89 04 24             	mov    %eax,(%esp)
 aa3:	e8 ae 00 00 00       	call   b56 <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 aa8:	a1 1c 11 00 00       	mov    0x111c,%eax
 aad:	8b 00                	mov    (%eax),%eax
 aaf:	89 44 24 08          	mov    %eax,0x8(%esp)
 ab3:	c7 44 24 04 07 0d 00 	movl   $0xd07,0x4(%esp)
 aba:	00 
 abb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ac2:	e8 30 fa ff ff       	call   4f7 <printf>
    int tidNext = pop_q(thQ2);
 ac7:	a1 1c 11 00 00       	mov    0x111c,%eax
 acc:	89 04 24             	mov    %eax,(%esp)
 acf:	e8 fc 00 00 00       	call   bd0 <pop_q>
 ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 ad7:	eb 10                	jmp    ae9 <thread_yield2+0x8d>
 ad9:	a1 1c 11 00 00       	mov    0x111c,%eax
 ade:	89 04 24             	mov    %eax,(%esp)
 ae1:	e8 ea 00 00 00       	call   bd0 <pop_q>
 ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 aef:	74 e8                	je     ad9 <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 af1:	a1 1c 11 00 00       	mov    0x111c,%eax
 af6:	8b 00                	mov    (%eax),%eax
 af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 afb:	89 54 24 0c          	mov    %edx,0xc(%esp)
 aff:	89 44 24 08          	mov    %eax,0x8(%esp)
 b03:	c7 44 24 04 17 0d 00 	movl   $0xd17,0x4(%esp)
 b0a:	00 
 b0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b12:	e8 e0 f9 ff ff       	call   4f7 <printf>
    tsleep();
 b17:	e8 db f8 ff ff       	call   3f7 <tsleep>
    twakeup(tidNext);
 b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1f:	89 04 24             	mov    %eax,(%esp)
 b22:	e8 d8 f8 ff ff       	call   3ff <twakeup>
    thread_yield3(tidNext);
 b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2a:	89 04 24             	mov    %eax,(%esp)
 b2d:	e8 dd f8 ff ff       	call   40f <thread_yield3>
    //yield();
 b32:	c9                   	leave  
 b33:	c3                   	ret    

00000b34 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 b34:	55                   	push   %ebp
 b35:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 b37:	8b 45 08             	mov    0x8(%ebp),%eax
 b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 b40:	8b 45 08             	mov    0x8(%ebp),%eax
 b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 b4a:	8b 45 08             	mov    0x8(%ebp),%eax
 b4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 b54:	5d                   	pop    %ebp
 b55:	c3                   	ret    

00000b56 <add_q>:

void add_q(struct queue *q, int v){
 b56:	55                   	push   %ebp
 b57:	89 e5                	mov    %esp,%ebp
 b59:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 b5c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b63:	e8 7b fc ff ff       	call   7e3 <malloc>
 b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b78:	8b 55 0c             	mov    0xc(%ebp),%edx
 b7b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b7d:	8b 45 08             	mov    0x8(%ebp),%eax
 b80:	8b 40 04             	mov    0x4(%eax),%eax
 b83:	85 c0                	test   %eax,%eax
 b85:	75 0b                	jne    b92 <add_q+0x3c>
        q->head = n;
 b87:	8b 45 08             	mov    0x8(%ebp),%eax
 b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b8d:	89 50 04             	mov    %edx,0x4(%eax)
 b90:	eb 0c                	jmp    b9e <add_q+0x48>
    }else{
        q->tail->next = n;
 b92:	8b 45 08             	mov    0x8(%ebp),%eax
 b95:	8b 40 08             	mov    0x8(%eax),%eax
 b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b9b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b9e:	8b 45 08             	mov    0x8(%ebp),%eax
 ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ba4:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 ba7:	8b 45 08             	mov    0x8(%ebp),%eax
 baa:	8b 00                	mov    (%eax),%eax
 bac:	8d 50 01             	lea    0x1(%eax),%edx
 baf:	8b 45 08             	mov    0x8(%ebp),%eax
 bb2:	89 10                	mov    %edx,(%eax)
}
 bb4:	c9                   	leave  
 bb5:	c3                   	ret    

00000bb6 <empty_q>:

int empty_q(struct queue *q){
 bb6:	55                   	push   %ebp
 bb7:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 bb9:	8b 45 08             	mov    0x8(%ebp),%eax
 bbc:	8b 00                	mov    (%eax),%eax
 bbe:	85 c0                	test   %eax,%eax
 bc0:	75 07                	jne    bc9 <empty_q+0x13>
        return 1;
 bc2:	b8 01 00 00 00       	mov    $0x1,%eax
 bc7:	eb 05                	jmp    bce <empty_q+0x18>
    else
        return 0;
 bc9:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 bce:	5d                   	pop    %ebp
 bcf:	c3                   	ret    

00000bd0 <pop_q>:
int pop_q(struct queue *q){
 bd0:	55                   	push   %ebp
 bd1:	89 e5                	mov    %esp,%ebp
 bd3:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 bd6:	8b 45 08             	mov    0x8(%ebp),%eax
 bd9:	89 04 24             	mov    %eax,(%esp)
 bdc:	e8 d5 ff ff ff       	call   bb6 <empty_q>
 be1:	85 c0                	test   %eax,%eax
 be3:	75 5d                	jne    c42 <pop_q+0x72>
       val = q->head->value; 
 be5:	8b 45 08             	mov    0x8(%ebp),%eax
 be8:	8b 40 04             	mov    0x4(%eax),%eax
 beb:	8b 00                	mov    (%eax),%eax
 bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 bf0:	8b 45 08             	mov    0x8(%ebp),%eax
 bf3:	8b 40 04             	mov    0x4(%eax),%eax
 bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 bf9:	8b 45 08             	mov    0x8(%ebp),%eax
 bfc:	8b 40 04             	mov    0x4(%eax),%eax
 bff:	8b 50 04             	mov    0x4(%eax),%edx
 c02:	8b 45 08             	mov    0x8(%ebp),%eax
 c05:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0b:	89 04 24             	mov    %eax,(%esp)
 c0e:	e8 97 fa ff ff       	call   6aa <free>
       q->size--;
 c13:	8b 45 08             	mov    0x8(%ebp),%eax
 c16:	8b 00                	mov    (%eax),%eax
 c18:	8d 50 ff             	lea    -0x1(%eax),%edx
 c1b:	8b 45 08             	mov    0x8(%ebp),%eax
 c1e:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 c20:	8b 45 08             	mov    0x8(%ebp),%eax
 c23:	8b 00                	mov    (%eax),%eax
 c25:	85 c0                	test   %eax,%eax
 c27:	75 14                	jne    c3d <pop_q+0x6d>
            q->head = 0;
 c29:	8b 45 08             	mov    0x8(%ebp),%eax
 c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 c33:	8b 45 08             	mov    0x8(%ebp),%eax
 c36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c40:	eb 05                	jmp    c47 <pop_q+0x77>
    }
    return -1;
 c42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 c47:	c9                   	leave  
 c48:	c3                   	ret    
