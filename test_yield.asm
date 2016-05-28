
_test_yield:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

void test_func(void *arg_ptr);
void ping(void *arg_ptr);
void pong(void *arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
   int arg = 10;
   9:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
  10:	00 
   void *tid = thread_create(ping, (void *)&arg);
  11:	8d 44 24 18          	lea    0x18(%esp),%eax
  15:	89 44 24 04          	mov    %eax,0x4(%esp)
  19:	c7 04 24 9e 00 00 00 	movl   $0x9e,(%esp)
  20:	e8 2c 09 00 00       	call   951 <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  29:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  2e:	75 19                	jne    49 <main+0x49>
       printf(1,"wrong happen");
  30:	c7 44 24 04 5e 0b 00 	movl   $0xb5e,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 de 04 00 00       	call   522 <printf>
       exit();
  44:	e8 31 03 00 00       	call   37a <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  49:	8d 44 24 18          	lea    0x18(%esp),%eax
  4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  51:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
  58:	e8 f4 08 00 00       	call   951 <thread_create>
  5d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  61:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  66:	75 19                	jne    81 <main+0x81>
       printf(1,"wrong happen");
  68:	c7 44 24 04 5e 0b 00 	movl   $0xb5e,0x4(%esp)
  6f:	00 
  70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  77:	e8 a6 04 00 00       	call   522 <printf>
       exit();
  7c:	e8 f9 02 00 00       	call   37a <exit>
   } 
   exit();
  81:	e8 f4 02 00 00       	call   37a <exit>

00000086 <test_func>:
}

void test_func(void *arg_ptr){
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
  8c:	a1 88 0f 00 00       	mov    0xf88,%eax
  91:	83 c0 01             	add    $0x1,%eax
  94:	a3 88 0f 00 00       	mov    %eax,0xf88
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
  99:	e8 84 03 00 00       	call   422 <texit>

0000009e <ping>:
}

void ping(void *arg_ptr){
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = *num; 
  aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ad:	8b 00                	mov    (%eax),%eax
  af:	a3 88 0f 00 00       	mov    %eax,0xf88
    while(1) {
        printf(1,"Ping %d\n",*num);
  b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b7:	8b 00                	mov    (%eax),%eax
  b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  bd:	c7 44 24 04 6b 0b 00 	movl   $0xb6b,0x4(%esp)
  c4:	00 
  c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cc:	e8 51 04 00 00       	call   522 <printf>
        thread_yield();
  d1:	e8 64 03 00 00       	call   43a <thread_yield>
    }
  d6:	eb dc                	jmp    b4 <ping+0x16>

000000d8 <pong>:
}
void pong(void *arg_ptr){
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = *num; 
  e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e7:	8b 00                	mov    (%eax),%eax
  e9:	a3 88 0f 00 00       	mov    %eax,0xf88
    while(1) {
        printf(1,"Pong %d\n",*num);
  ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f1:	8b 00                	mov    (%eax),%eax
  f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  f7:	c7 44 24 04 74 0b 00 	movl   $0xb74,0x4(%esp)
  fe:	00 
  ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 106:	e8 17 04 00 00       	call   522 <printf>
        thread_yield();
 10b:	e8 2a 03 00 00       	call   43a <thread_yield>
    }
 110:	eb dc                	jmp    ee <pong+0x16>

00000112 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	57                   	push   %edi
 116:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 10             	mov    0x10(%ebp),%edx
 11d:	8b 45 0c             	mov    0xc(%ebp),%eax
 120:	89 cb                	mov    %ecx,%ebx
 122:	89 df                	mov    %ebx,%edi
 124:	89 d1                	mov    %edx,%ecx
 126:	fc                   	cld    
 127:	f3 aa                	rep stos %al,%es:(%edi)
 129:	89 ca                	mov    %ecx,%edx
 12b:	89 fb                	mov    %edi,%ebx
 12d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 130:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 133:	5b                   	pop    %ebx
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    

00000137 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 143:	90                   	nop
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8d 50 01             	lea    0x1(%eax),%edx
 14a:	89 55 08             	mov    %edx,0x8(%ebp)
 14d:	8b 55 0c             	mov    0xc(%ebp),%edx
 150:	8d 4a 01             	lea    0x1(%edx),%ecx
 153:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 156:	0f b6 12             	movzbl (%edx),%edx
 159:	88 10                	mov    %dl,(%eax)
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	84 c0                	test   %al,%al
 160:	75 e2                	jne    144 <strcpy+0xd>
    ;
  return os;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16a:	eb 08                	jmp    174 <strcmp+0xd>
    p++, q++;
 16c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 170:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	84 c0                	test   %al,%al
 17c:	74 10                	je     18e <strcmp+0x27>
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 10             	movzbl (%eax),%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	38 c2                	cmp    %al,%dl
 18c:	74 de                	je     16c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	0f b6 d0             	movzbl %al,%edx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 c0             	movzbl %al,%eax
 1a0:	29 c2                	sub    %eax,%edx
 1a2:	89 d0                	mov    %edx,%eax
}
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    

000001a6 <strlen>:

uint
strlen(char *s)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b3:	eb 04                	jmp    1b9 <strlen+0x13>
 1b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 ed                	jne    1b5 <strlen+0xf>
    ;
  return n;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d3:	8b 45 10             	mov    0x10(%ebp),%eax
 1d6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	89 04 24             	mov    %eax,(%esp)
 1e7:	e8 26 ff ff ff       	call   112 <stosb>
  return dst;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <strchr>:

char*
strchr(const char *s, char c)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 04             	sub    $0x4,%esp
 1f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fd:	eb 14                	jmp    213 <strchr+0x22>
    if(*s == c)
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	3a 45 fc             	cmp    -0x4(%ebp),%al
 208:	75 05                	jne    20f <strchr+0x1e>
      return (char*)s;
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	eb 13                	jmp    222 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 00             	movzbl (%eax),%eax
 219:	84 c0                	test   %al,%al
 21b:	75 e2                	jne    1ff <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <gets>:

char*
gets(char *buf, int max)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 231:	eb 4c                	jmp    27f <gets+0x5b>
    cc = read(0, &c, 1);
 233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23a:	00 
 23b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23e:	89 44 24 04          	mov    %eax,0x4(%esp)
 242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 249:	e8 44 01 00 00       	call   392 <read>
 24e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 255:	7f 02                	jg     259 <gets+0x35>
      break;
 257:	eb 31                	jmp    28a <gets+0x66>
    buf[i++] = c;
 259:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25c:	8d 50 01             	lea    0x1(%eax),%edx
 25f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 262:	89 c2                	mov    %eax,%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 c2                	add    %eax,%edx
 269:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0a                	cmp    $0xa,%al
 275:	74 13                	je     28a <gets+0x66>
 277:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27b:	3c 0d                	cmp    $0xd,%al
 27d:	74 0b                	je     28a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	83 c0 01             	add    $0x1,%eax
 285:	3b 45 0c             	cmp    0xc(%ebp),%eax
 288:	7c a9                	jl     233 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	01 d0                	add    %edx,%eax
 292:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <stat>:

int
stat(char *n, struct stat *st)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a7:	00 
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 04 24             	mov    %eax,(%esp)
 2ae:	e8 07 01 00 00       	call   3ba <open>
 2b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ba:	79 07                	jns    2c3 <stat+0x29>
    return -1;
 2bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c1:	eb 23                	jmp    2e6 <stat+0x4c>
  r = fstat(fd, st);
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cd:	89 04 24             	mov    %eax,(%esp)
 2d0:	e8 fd 00 00 00       	call   3d2 <fstat>
 2d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 bf 00 00 00       	call   3a2 <close>
  return r;
 2e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <atoi>:

int
atoi(const char *s)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f5:	eb 25                	jmp    31c <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fa:	89 d0                	mov    %edx,%eax
 2fc:	c1 e0 02             	shl    $0x2,%eax
 2ff:	01 d0                	add    %edx,%eax
 301:	01 c0                	add    %eax,%eax
 303:	89 c1                	mov    %eax,%ecx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	8d 50 01             	lea    0x1(%eax),%edx
 30b:	89 55 08             	mov    %edx,0x8(%ebp)
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	0f be c0             	movsbl %al,%eax
 314:	01 c8                	add    %ecx,%eax
 316:	83 e8 30             	sub    $0x30,%eax
 319:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	3c 2f                	cmp    $0x2f,%al
 324:	7e 0a                	jle    330 <atoi+0x48>
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 39                	cmp    $0x39,%al
 32e:	7e c7                	jle    2f7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 347:	eb 17                	jmp    360 <memmove+0x2b>
    *dst++ = *src++;
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34c:	8d 50 01             	lea    0x1(%eax),%edx
 34f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 352:	8b 55 f8             	mov    -0x8(%ebp),%edx
 355:	8d 4a 01             	lea    0x1(%edx),%ecx
 358:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 35b:	0f b6 12             	movzbl (%edx),%edx
 35e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 360:	8b 45 10             	mov    0x10(%ebp),%eax
 363:	8d 50 ff             	lea    -0x1(%eax),%edx
 366:	89 55 10             	mov    %edx,0x10(%ebp)
 369:	85 c0                	test   %eax,%eax
 36b:	7f dc                	jg     349 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 372:	b8 01 00 00 00       	mov    $0x1,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <exit>:
SYSCALL(exit)
 37a:	b8 02 00 00 00       	mov    $0x2,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <wait>:
SYSCALL(wait)
 382:	b8 03 00 00 00       	mov    $0x3,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <pipe>:
SYSCALL(pipe)
 38a:	b8 04 00 00 00       	mov    $0x4,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <read>:
SYSCALL(read)
 392:	b8 05 00 00 00       	mov    $0x5,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <write>:
SYSCALL(write)
 39a:	b8 10 00 00 00       	mov    $0x10,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <close>:
SYSCALL(close)
 3a2:	b8 15 00 00 00       	mov    $0x15,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <kill>:
SYSCALL(kill)
 3aa:	b8 06 00 00 00       	mov    $0x6,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <exec>:
SYSCALL(exec)
 3b2:	b8 07 00 00 00       	mov    $0x7,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <open>:
SYSCALL(open)
 3ba:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <mknod>:
SYSCALL(mknod)
 3c2:	b8 11 00 00 00       	mov    $0x11,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <unlink>:
SYSCALL(unlink)
 3ca:	b8 12 00 00 00       	mov    $0x12,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <fstat>:
SYSCALL(fstat)
 3d2:	b8 08 00 00 00       	mov    $0x8,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <link>:
SYSCALL(link)
 3da:	b8 13 00 00 00       	mov    $0x13,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <mkdir>:
SYSCALL(mkdir)
 3e2:	b8 14 00 00 00       	mov    $0x14,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <chdir>:
SYSCALL(chdir)
 3ea:	b8 09 00 00 00       	mov    $0x9,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <dup>:
SYSCALL(dup)
 3f2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <getpid>:
SYSCALL(getpid)
 3fa:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sbrk>:
SYSCALL(sbrk)
 402:	b8 0c 00 00 00       	mov    $0xc,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sleep>:
SYSCALL(sleep)
 40a:	b8 0d 00 00 00       	mov    $0xd,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <uptime>:
SYSCALL(uptime)
 412:	b8 0e 00 00 00       	mov    $0xe,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <clone>:
SYSCALL(clone)
 41a:	b8 16 00 00 00       	mov    $0x16,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <texit>:
SYSCALL(texit)
 422:	b8 17 00 00 00       	mov    $0x17,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <tsleep>:
SYSCALL(tsleep)
 42a:	b8 18 00 00 00       	mov    $0x18,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <twakeup>:
SYSCALL(twakeup)
 432:	b8 19 00 00 00       	mov    $0x19,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <thread_yield>:
SYSCALL(thread_yield)
 43a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp
 445:	83 ec 18             	sub    $0x18,%esp
 448:	8b 45 0c             	mov    0xc(%ebp),%eax
 44b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 455:	00 
 456:	8d 45 f4             	lea    -0xc(%ebp),%eax
 459:	89 44 24 04          	mov    %eax,0x4(%esp)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 32 ff ff ff       	call   39a <write>
}
 468:	c9                   	leave  
 469:	c3                   	ret    

0000046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	56                   	push   %esi
 46e:	53                   	push   %ebx
 46f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47d:	74 17                	je     496 <printint+0x2c>
 47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 483:	79 11                	jns    496 <printint+0x2c>
    neg = 1;
 485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	f7 d8                	neg    %eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
 494:	eb 06                	jmp    49c <printint+0x32>
  } else {
    x = xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a6:	8d 41 01             	lea    0x1(%ecx),%eax
 4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f3                	div    %ebx
 4b9:	89 d0                	mov    %edx,%eax
 4bb:	0f b6 80 8c 0f 00 00 	movzbl 0xf8c(%eax),%eax
 4c2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c6:	8b 75 10             	mov    0x10(%ebp),%esi
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f6                	div    %esi
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4da:	75 c7                	jne    4a3 <printint+0x39>
  if(neg)
 4dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e0:	74 10                	je     4f2 <printint+0x88>
    buf[i++] = '-';
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	8d 50 01             	lea    0x1(%eax),%edx
 4e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f0:	eb 1f                	jmp    511 <printint+0xa7>
 4f2:	eb 1d                	jmp    511 <printint+0xa7>
    putc(fd, buf[i]);
 4f4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	89 44 24 04          	mov    %eax,0x4(%esp)
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 04 24             	mov    %eax,(%esp)
 50c:	e8 31 ff ff ff       	call   442 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 511:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	79 d9                	jns    4f4 <printint+0x8a>
    putc(fd, buf[i]);
}
 51b:	83 c4 30             	add    $0x30,%esp
 51e:	5b                   	pop    %ebx
 51f:	5e                   	pop    %esi
 520:	5d                   	pop    %ebp
 521:	c3                   	ret    

00000522 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 528:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52f:	8d 45 0c             	lea    0xc(%ebp),%eax
 532:	83 c0 04             	add    $0x4,%eax
 535:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53f:	e9 7c 01 00 00       	jmp    6c0 <printf+0x19e>
    c = fmt[i] & 0xff;
 544:	8b 55 0c             	mov    0xc(%ebp),%edx
 547:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54a:	01 d0                	add    %edx,%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	0f be c0             	movsbl %al,%eax
 552:	25 ff 00 00 00       	and    $0xff,%eax
 557:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 2c                	jne    58c <printf+0x6a>
      if(c == '%'){
 560:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 564:	75 0c                	jne    572 <printf+0x50>
        state = '%';
 566:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56d:	e9 4a 01 00 00       	jmp    6bc <printf+0x19a>
      } else {
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	89 44 24 04          	mov    %eax,0x4(%esp)
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	89 04 24             	mov    %eax,(%esp)
 582:	e8 bb fe ff ff       	call   442 <putc>
 587:	e9 30 01 00 00       	jmp    6bc <printf+0x19a>
      }
    } else if(state == '%'){
 58c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 590:	0f 85 26 01 00 00    	jne    6bc <printf+0x19a>
      if(c == 'd'){
 596:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59a:	75 2d                	jne    5c9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a8:	00 
 5a9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5b0:	00 
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 aa fe ff ff       	call   46a <printint>
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c4:	e9 ec 00 00 00       	jmp    6b5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5c9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5cd:	74 06                	je     5d5 <printf+0xb3>
 5cf:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d3:	75 2d                	jne    602 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5e1:	00 
 5e2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e9:	00 
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 71 fe ff ff       	call   46a <printint>
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	e9 b3 00 00 00       	jmp    6b5 <printf+0x193>
      } else if(c == 's'){
 602:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 606:	75 45                	jne    64d <printf+0x12b>
        s = (char*)*ap;
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 618:	75 09                	jne    623 <printf+0x101>
          s = "(null)";
 61a:	c7 45 f4 7d 0b 00 00 	movl   $0xb7d,-0xc(%ebp)
        while(*s != 0){
 621:	eb 1e                	jmp    641 <printf+0x11f>
 623:	eb 1c                	jmp    641 <printf+0x11f>
          putc(fd, *s);
 625:	8b 45 f4             	mov    -0xc(%ebp),%eax
 628:	0f b6 00             	movzbl (%eax),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	89 44 24 04          	mov    %eax,0x4(%esp)
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	89 04 24             	mov    %eax,(%esp)
 638:	e8 05 fe ff ff       	call   442 <putc>
          s++;
 63d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	0f b6 00             	movzbl (%eax),%eax
 647:	84 c0                	test   %al,%al
 649:	75 da                	jne    625 <printf+0x103>
 64b:	eb 68                	jmp    6b5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 651:	75 1d                	jne    670 <printf+0x14e>
        putc(fd, *ap);
 653:	8b 45 e8             	mov    -0x18(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	89 44 24 04          	mov    %eax,0x4(%esp)
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	89 04 24             	mov    %eax,(%esp)
 665:	e8 d8 fd ff ff       	call   442 <putc>
        ap++;
 66a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66e:	eb 45                	jmp    6b5 <printf+0x193>
      } else if(c == '%'){
 670:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 674:	75 17                	jne    68d <printf+0x16b>
        putc(fd, c);
 676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 b7 fd ff ff       	call   442 <putc>
 68b:	eb 28                	jmp    6b5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 694:	00 
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	89 04 24             	mov    %eax,(%esp)
 69b:	e8 a2 fd ff ff       	call   442 <putc>
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6aa:	8b 45 08             	mov    0x8(%ebp),%eax
 6ad:	89 04 24             	mov    %eax,(%esp)
 6b0:	e8 8d fd ff ff       	call   442 <putc>
      }
      state = 0;
 6b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	0f 85 71 fe ff ff    	jne    544 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	83 e8 08             	sub    $0x8,%eax
 6e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	a1 ac 0f 00 00       	mov    0xfac,%eax
 6e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ec:	eb 24                	jmp    712 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f6:	77 12                	ja     70a <free+0x35>
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fe:	77 24                	ja     724 <free+0x4f>
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 708:	77 1a                	ja     724 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	76 d4                	jbe    6ee <free+0x19>
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 722:	76 ca                	jbe    6ee <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	39 c2                	cmp    %eax,%edx
 73d:	75 24                	jne    763 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 50 04             	mov    0x4(%eax),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	01 c2                	add    %eax,%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	89 10                	mov    %edx,(%eax)
 761:	eb 0a                	jmp    76d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	01 d0                	add    %edx,%eax
 77f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 782:	75 20                	jne    7a4 <free+0xcf>
    p->s.size += bp->s.size;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 50 04             	mov    0x4(%eax),%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	01 c2                	add    %eax,%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 10                	mov    (%eax),%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	89 10                	mov    %edx,(%eax)
 7a2:	eb 08                	jmp    7ac <free+0xd7>
  } else
    p->s.ptr = bp;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7aa:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	a3 ac 0f 00 00       	mov    %eax,0xfac
}
 7b4:	c9                   	leave  
 7b5:	c3                   	ret    

000007b6 <morecore>:

static Header*
morecore(uint nu)
{
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7bc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c3:	77 07                	ja     7cc <morecore+0x16>
    nu = 4096;
 7c5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	c1 e0 03             	shl    $0x3,%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 28 fc ff ff       	call   402 <sbrk>
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7dd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e1:	75 07                	jne    7ea <morecore+0x34>
    return 0;
 7e3:	b8 00 00 00 00       	mov    $0x0,%eax
 7e8:	eb 22                	jmp    80c <morecore+0x56>
  hp = (Header*)p;
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	8b 55 08             	mov    0x8(%ebp),%edx
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	89 04 24             	mov    %eax,(%esp)
 802:	e8 ce fe ff ff       	call   6d5 <free>
  return freep;
 807:	a1 ac 0f 00 00       	mov    0xfac,%eax
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    

0000080e <malloc>:

void*
malloc(uint nbytes)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	83 c0 07             	add    $0x7,%eax
 81a:	c1 e8 03             	shr    $0x3,%eax
 81d:	83 c0 01             	add    $0x1,%eax
 820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 823:	a1 ac 0f 00 00       	mov    0xfac,%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82f:	75 23                	jne    854 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 831:	c7 45 f0 a4 0f 00 00 	movl   $0xfa4,-0x10(%ebp)
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	a3 ac 0f 00 00       	mov    %eax,0xfac
 840:	a1 ac 0f 00 00       	mov    0xfac,%eax
 845:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    base.s.size = 0;
 84a:	c7 05 a8 0f 00 00 00 	movl   $0x0,0xfa8
 851:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 865:	72 4d                	jb     8b4 <malloc+0xa6>
      if(p->s.size == nunits)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 40 04             	mov    0x4(%eax),%eax
 86d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 870:	75 0c                	jne    87e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 26                	jmp    8a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	2b 45 ec             	sub    -0x14(%ebp),%eax
 887:	89 c2                	mov    %eax,%edx
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	a3 ac 0f 00 00       	mov    %eax,0xfac
      return (void*)(p + 1);
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	eb 38                	jmp    8ec <malloc+0xde>
    }
    if(p == freep)
 8b4:	a1 ac 0f 00 00       	mov    0xfac,%eax
 8b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bc:	75 1b                	jne    8d9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c1:	89 04 24             	mov    %eax,(%esp)
 8c4:	e8 ed fe ff ff       	call   7b6 <morecore>
 8c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d0:	75 07                	jne    8d9 <malloc+0xcb>
        return 0;
 8d2:	b8 00 00 00 00       	mov    $0x0,%eax
 8d7:	eb 13                	jmp    8ec <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e7:	e9 70 ff ff ff       	jmp    85c <malloc+0x4e>
}
 8ec:	c9                   	leave  
 8ed:	c3                   	ret    

000008ee <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8ee:	55                   	push   %ebp
 8ef:	89 e5                	mov    %esp,%ebp
 8f1:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8f4:	8b 55 08             	mov    0x8(%ebp),%edx
 8f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8fd:	f0 87 02             	lock xchg %eax,(%edx)
 900:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 906:	c9                   	leave  
 907:	c3                   	ret    

00000908 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 908:	55                   	push   %ebp
 909:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 914:	5d                   	pop    %ebp
 915:	c3                   	ret    

00000916 <lock_acquire>:
void lock_acquire(lock_t *lock){
 916:	55                   	push   %ebp
 917:	89 e5                	mov    %esp,%ebp
 919:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 91c:	90                   	nop
 91d:	8b 45 08             	mov    0x8(%ebp),%eax
 920:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 927:	00 
 928:	89 04 24             	mov    %eax,(%esp)
 92b:	e8 be ff ff ff       	call   8ee <xchg>
 930:	85 c0                	test   %eax,%eax
 932:	75 e9                	jne    91d <lock_acquire+0x7>
}
 934:	c9                   	leave  
 935:	c3                   	ret    

00000936 <lock_release>:
void lock_release(lock_t *lock){
 936:	55                   	push   %ebp
 937:	89 e5                	mov    %esp,%ebp
 939:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 93c:	8b 45 08             	mov    0x8(%ebp),%eax
 93f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 946:	00 
 947:	89 04 24             	mov    %eax,(%esp)
 94a:	e8 9f ff ff ff       	call   8ee <xchg>
}
 94f:	c9                   	leave  
 950:	c3                   	ret    

00000951 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 951:	55                   	push   %ebp
 952:	89 e5                	mov    %esp,%ebp
 954:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 957:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 95e:	e8 ab fe ff ff       	call   80e <malloc>
 963:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	25 ff 0f 00 00       	and    $0xfff,%eax
 974:	85 c0                	test   %eax,%eax
 976:	74 14                	je     98c <thread_create+0x3b>
        stack = stack + (4096 - (uint)stack % 4096);
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	25 ff 0f 00 00       	and    $0xfff,%eax
 980:	89 c2                	mov    %eax,%edx
 982:	b8 00 10 00 00       	mov    $0x1000,%eax
 987:	29 d0                	sub    %edx,%eax
 989:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 98c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 990:	75 1b                	jne    9ad <thread_create+0x5c>

        printf(1,"malloc fail \n");
 992:	c7 44 24 04 84 0b 00 	movl   $0xb84,0x4(%esp)
 999:	00 
 99a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9a1:	e8 7c fb ff ff       	call   522 <printf>
        return 0;
 9a6:	b8 00 00 00 00       	mov    $0x0,%eax
 9ab:	eb 6f                	jmp    a1c <thread_create+0xcb>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 9ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 9b0:	8b 55 08             	mov    0x8(%ebp),%edx
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 9ba:	89 54 24 08          	mov    %edx,0x8(%esp)
 9be:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9c5:	00 
 9c6:	89 04 24             	mov    %eax,(%esp)
 9c9:	e8 4c fa ff ff       	call   41a <clone>
 9ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 9d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9d5:	79 1b                	jns    9f2 <thread_create+0xa1>
        printf(1,"clone fails\n");
 9d7:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 9de:	00 
 9df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9e6:	e8 37 fb ff ff       	call   522 <printf>
        return 0;
 9eb:	b8 00 00 00 00       	mov    $0x0,%eax
 9f0:	eb 2a                	jmp    a1c <thread_create+0xcb>
    }
    if(tid > 0){
 9f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f6:	7e 05                	jle    9fd <thread_create+0xac>
        //store threads on thread table
        return garbage_stack;
 9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fb:	eb 1f                	jmp    a1c <thread_create+0xcb>
    }
    if(tid == 0){
 9fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a01:	75 14                	jne    a17 <thread_create+0xc6>
        printf(1,"tid = 0 return \n");
 a03:	c7 44 24 04 9f 0b 00 	movl   $0xb9f,0x4(%esp)
 a0a:	00 
 a0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a12:	e8 0b fb ff ff       	call   522 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a1c:	c9                   	leave  
 a1d:	c3                   	ret    

00000a1e <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a1e:	55                   	push   %ebp
 a1f:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a21:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 a26:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 a2c:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 a31:	a3 a0 0f 00 00       	mov    %eax,0xfa0
    return (int)(rands % max);
 a36:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 a3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a3e:	ba 00 00 00 00       	mov    $0x0,%edx
 a43:	f7 f1                	div    %ecx
 a45:	89 d0                	mov    %edx,%eax
}
 a47:	5d                   	pop    %ebp
 a48:	c3                   	ret    

00000a49 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 a49:	55                   	push   %ebp
 a4a:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a4c:	8b 45 08             	mov    0x8(%ebp),%eax
 a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a55:	8b 45 08             	mov    0x8(%ebp),%eax
 a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a69:	5d                   	pop    %ebp
 a6a:	c3                   	ret    

00000a6b <add_q>:

void add_q(struct queue *q, int v){
 a6b:	55                   	push   %ebp
 a6c:	89 e5                	mov    %esp,%ebp
 a6e:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a71:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a78:	e8 91 fd ff ff       	call   80e <malloc>
 a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
 a90:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a92:	8b 45 08             	mov    0x8(%ebp),%eax
 a95:	8b 40 04             	mov    0x4(%eax),%eax
 a98:	85 c0                	test   %eax,%eax
 a9a:	75 0b                	jne    aa7 <add_q+0x3c>
        q->head = n;
 a9c:	8b 45 08             	mov    0x8(%ebp),%eax
 a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aa2:	89 50 04             	mov    %edx,0x4(%eax)
 aa5:	eb 0c                	jmp    ab3 <add_q+0x48>
    }else{
        q->tail->next = n;
 aa7:	8b 45 08             	mov    0x8(%ebp),%eax
 aaa:	8b 40 08             	mov    0x8(%eax),%eax
 aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ab0:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ab9:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 abc:	8b 45 08             	mov    0x8(%ebp),%eax
 abf:	8b 00                	mov    (%eax),%eax
 ac1:	8d 50 01             	lea    0x1(%eax),%edx
 ac4:	8b 45 08             	mov    0x8(%ebp),%eax
 ac7:	89 10                	mov    %edx,(%eax)
}
 ac9:	c9                   	leave  
 aca:	c3                   	ret    

00000acb <empty_q>:

int empty_q(struct queue *q){
 acb:	55                   	push   %ebp
 acc:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 ace:	8b 45 08             	mov    0x8(%ebp),%eax
 ad1:	8b 00                	mov    (%eax),%eax
 ad3:	85 c0                	test   %eax,%eax
 ad5:	75 07                	jne    ade <empty_q+0x13>
        return 1;
 ad7:	b8 01 00 00 00       	mov    $0x1,%eax
 adc:	eb 05                	jmp    ae3 <empty_q+0x18>
    else
        return 0;
 ade:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 ae3:	5d                   	pop    %ebp
 ae4:	c3                   	ret    

00000ae5 <pop_q>:
int pop_q(struct queue *q){
 ae5:	55                   	push   %ebp
 ae6:	89 e5                	mov    %esp,%ebp
 ae8:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	89 04 24             	mov    %eax,(%esp)
 af1:	e8 d5 ff ff ff       	call   acb <empty_q>
 af6:	85 c0                	test   %eax,%eax
 af8:	75 5d                	jne    b57 <pop_q+0x72>
       val = q->head->value; 
 afa:	8b 45 08             	mov    0x8(%ebp),%eax
 afd:	8b 40 04             	mov    0x4(%eax),%eax
 b00:	8b 00                	mov    (%eax),%eax
 b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b05:	8b 45 08             	mov    0x8(%ebp),%eax
 b08:	8b 40 04             	mov    0x4(%eax),%eax
 b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b0e:	8b 45 08             	mov    0x8(%ebp),%eax
 b11:	8b 40 04             	mov    0x4(%eax),%eax
 b14:	8b 50 04             	mov    0x4(%eax),%edx
 b17:	8b 45 08             	mov    0x8(%ebp),%eax
 b1a:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b20:	89 04 24             	mov    %eax,(%esp)
 b23:	e8 ad fb ff ff       	call   6d5 <free>
       q->size--;
 b28:	8b 45 08             	mov    0x8(%ebp),%eax
 b2b:	8b 00                	mov    (%eax),%eax
 b2d:	8d 50 ff             	lea    -0x1(%eax),%edx
 b30:	8b 45 08             	mov    0x8(%ebp),%eax
 b33:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 b35:	8b 45 08             	mov    0x8(%ebp),%eax
 b38:	8b 00                	mov    (%eax),%eax
 b3a:	85 c0                	test   %eax,%eax
 b3c:	75 14                	jne    b52 <pop_q+0x6d>
            q->head = 0;
 b3e:	8b 45 08             	mov    0x8(%ebp),%eax
 b41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b48:	8b 45 08             	mov    0x8(%ebp),%eax
 b4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b55:	eb 05                	jmp    b5c <pop_q+0x77>
    }
    return -1;
 b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b5c:	c9                   	leave  
 b5d:	c3                   	ret    
