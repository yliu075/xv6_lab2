
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
  20:	e8 60 09 00 00       	call   985 <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  29:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  2e:	75 19                	jne    49 <main+0x49>
       printf(1,"wrong happen");
  30:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 12 05 00 00       	call   556 <printf>
       exit();
  44:	e8 65 03 00 00       	call   3ae <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  49:	8d 44 24 18          	lea    0x18(%esp),%eax
  4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  51:	c7 04 24 f2 00 00 00 	movl   $0xf2,(%esp)
  58:	e8 28 09 00 00       	call   985 <thread_create>
  5d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  61:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  66:	75 19                	jne    81 <main+0x81>
       printf(1,"wrong happen");
  68:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
  6f:	00 
  70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  77:	e8 da 04 00 00       	call   556 <printf>
       exit();
  7c:	e8 2d 03 00 00       	call   3ae <exit>
   } 
   exit();
  81:	e8 28 03 00 00       	call   3ae <exit>

00000086 <test_func>:
}

void test_func(void *arg_ptr){
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
  8c:	a1 cc 0f 00 00       	mov    0xfcc,%eax
  91:	83 c0 01             	add    $0x1,%eax
  94:	a3 cc 0f 00 00       	mov    %eax,0xfcc
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
  99:	e8 b8 03 00 00       	call   456 <texit>

0000009e <ping>:
}

void ping(void *arg_ptr){
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
  aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ad:	8b 00                	mov    (%eax),%eax
  af:	a3 cc 0f 00 00       	mov    %eax,0xfcc
    int i = 0;
  b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
  bb:	eb 2d                	jmp    ea <ping+0x4c>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
  bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  cd:	c7 44 24 04 9f 0b 00 	movl   $0xb9f,0x4(%esp)
  d4:	00 
  d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dc:	e8 75 04 00 00       	call   556 <printf>
        thread_yield();
  e1:	e8 88 03 00 00       	call   46e <thread_yield>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
  e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  ea:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  ee:	7e cd                	jle    bd <ping+0x1f>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
        thread_yield();
    }
}
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <pong>:
void pong(void *arg_ptr){
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  f5:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
  fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 101:	8b 00                	mov    (%eax),%eax
 103:	a3 cc 0f 00 00       	mov    %eax,0xfcc
    int i = 0;
 108:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
 10f:	eb 2d                	jmp    13e <pong+0x4c>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
 111:	8b 45 f0             	mov    -0x10(%ebp),%eax
 114:	8b 00                	mov    (%eax),%eax
 116:	8b 55 f4             	mov    -0xc(%ebp),%edx
 119:	89 54 24 0c          	mov    %edx,0xc(%esp)
 11d:	89 44 24 08          	mov    %eax,0x8(%esp)
 121:	c7 44 24 04 ac 0b 00 	movl   $0xbac,0x4(%esp)
 128:	00 
 129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 130:	e8 21 04 00 00       	call   556 <printf>
        thread_yield();
 135:	e8 34 03 00 00       	call   46e <thread_yield>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
 13a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 13e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 142:	7e cd                	jle    111 <pong+0x1f>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
        thread_yield();
    }
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	57                   	push   %edi
 14a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14e:	8b 55 10             	mov    0x10(%ebp),%edx
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	89 cb                	mov    %ecx,%ebx
 156:	89 df                	mov    %ebx,%edi
 158:	89 d1                	mov    %edx,%ecx
 15a:	fc                   	cld    
 15b:	f3 aa                	rep stos %al,%es:(%edi)
 15d:	89 ca                	mov    %ecx,%edx
 15f:	89 fb                	mov    %edi,%ebx
 161:	89 5d 08             	mov    %ebx,0x8(%ebp)
 164:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 167:	5b                   	pop    %ebx
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 177:	90                   	nop
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	8d 50 01             	lea    0x1(%eax),%edx
 17e:	89 55 08             	mov    %edx,0x8(%ebp)
 181:	8b 55 0c             	mov    0xc(%ebp),%edx
 184:	8d 4a 01             	lea    0x1(%edx),%ecx
 187:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18a:	0f b6 12             	movzbl (%edx),%edx
 18d:	88 10                	mov    %dl,(%eax)
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	84 c0                	test   %al,%al
 194:	75 e2                	jne    178 <strcpy+0xd>
    ;
  return os;
 196:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 199:	c9                   	leave  
 19a:	c3                   	ret    

0000019b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 19e:	eb 08                	jmp    1a8 <strcmp+0xd>
    p++, q++;
 1a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	84 c0                	test   %al,%al
 1b0:	74 10                	je     1c2 <strcmp+0x27>
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 10             	movzbl (%eax),%edx
 1b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	38 c2                	cmp    %al,%dl
 1c0:	74 de                	je     1a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	0f b6 00             	movzbl (%eax),%eax
 1c8:	0f b6 d0             	movzbl %al,%edx
 1cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ce:	0f b6 00             	movzbl (%eax),%eax
 1d1:	0f b6 c0             	movzbl %al,%eax
 1d4:	29 c2                	sub    %eax,%edx
 1d6:	89 d0                	mov    %edx,%eax
}
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <strlen>:

uint
strlen(char *s)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e7:	eb 04                	jmp    1ed <strlen+0x13>
 1e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	0f b6 00             	movzbl (%eax),%eax
 1f8:	84 c0                	test   %al,%al
 1fa:	75 ed                	jne    1e9 <strlen+0xf>
    ;
  return n;
 1fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <memset>:

void*
memset(void *dst, int c, uint n)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 207:	8b 45 10             	mov    0x10(%ebp),%eax
 20a:	89 44 24 08          	mov    %eax,0x8(%esp)
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	89 44 24 04          	mov    %eax,0x4(%esp)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	89 04 24             	mov    %eax,(%esp)
 21b:	e8 26 ff ff ff       	call   146 <stosb>
  return dst;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <strchr>:

char*
strchr(const char *s, char c)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	8b 45 0c             	mov    0xc(%ebp),%eax
 22e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 231:	eb 14                	jmp    247 <strchr+0x22>
    if(*s == c)
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23c:	75 05                	jne    243 <strchr+0x1e>
      return (char*)s;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	eb 13                	jmp    256 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 243:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	84 c0                	test   %al,%al
 24f:	75 e2                	jne    233 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 251:	b8 00 00 00 00       	mov    $0x0,%eax
}
 256:	c9                   	leave  
 257:	c3                   	ret    

00000258 <gets>:

char*
gets(char *buf, int max)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 265:	eb 4c                	jmp    2b3 <gets+0x5b>
    cc = read(0, &c, 1);
 267:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 26e:	00 
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	89 44 24 04          	mov    %eax,0x4(%esp)
 276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 27d:	e8 44 01 00 00       	call   3c6 <read>
 282:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 285:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 289:	7f 02                	jg     28d <gets+0x35>
      break;
 28b:	eb 31                	jmp    2be <gets+0x66>
    buf[i++] = c;
 28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 290:	8d 50 01             	lea    0x1(%eax),%edx
 293:	89 55 f4             	mov    %edx,-0xc(%ebp)
 296:	89 c2                	mov    %eax,%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 c2                	add    %eax,%edx
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a7:	3c 0a                	cmp    $0xa,%al
 2a9:	74 13                	je     2be <gets+0x66>
 2ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2af:	3c 0d                	cmp    $0xd,%al
 2b1:	74 0b                	je     2be <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b6:	83 c0 01             	add    $0x1,%eax
 2b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2bc:	7c a9                	jl     267 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2be:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	01 d0                	add    %edx,%eax
 2c6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <stat>:

int
stat(char *n, struct stat *st)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2db:	00 
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	89 04 24             	mov    %eax,(%esp)
 2e2:	e8 07 01 00 00       	call   3ee <open>
 2e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ee:	79 07                	jns    2f7 <stat+0x29>
    return -1;
 2f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f5:	eb 23                	jmp    31a <stat+0x4c>
  r = fstat(fd, st);
 2f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 fd 00 00 00       	call   406 <fstat>
 309:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30f:	89 04 24             	mov    %eax,(%esp)
 312:	e8 bf 00 00 00       	call   3d6 <close>
  return r;
 317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <atoi>:

int
atoi(const char *s)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 329:	eb 25                	jmp    350 <atoi+0x34>
    n = n*10 + *s++ - '0';
 32b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32e:	89 d0                	mov    %edx,%eax
 330:	c1 e0 02             	shl    $0x2,%eax
 333:	01 d0                	add    %edx,%eax
 335:	01 c0                	add    %eax,%eax
 337:	89 c1                	mov    %eax,%ecx
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	8d 50 01             	lea    0x1(%eax),%edx
 33f:	89 55 08             	mov    %edx,0x8(%ebp)
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	0f be c0             	movsbl %al,%eax
 348:	01 c8                	add    %ecx,%eax
 34a:	83 e8 30             	sub    $0x30,%eax
 34d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	3c 2f                	cmp    $0x2f,%al
 358:	7e 0a                	jle    364 <atoi+0x48>
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	3c 39                	cmp    $0x39,%al
 362:	7e c7                	jle    32b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 364:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37b:	eb 17                	jmp    394 <memmove+0x2b>
    *dst++ = *src++;
 37d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 380:	8d 50 01             	lea    0x1(%eax),%edx
 383:	89 55 fc             	mov    %edx,-0x4(%ebp)
 386:	8b 55 f8             	mov    -0x8(%ebp),%edx
 389:	8d 4a 01             	lea    0x1(%edx),%ecx
 38c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38f:	0f b6 12             	movzbl (%edx),%edx
 392:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 394:	8b 45 10             	mov    0x10(%ebp),%eax
 397:	8d 50 ff             	lea    -0x1(%eax),%edx
 39a:	89 55 10             	mov    %edx,0x10(%ebp)
 39d:	85 c0                	test   %eax,%eax
 39f:	7f dc                	jg     37d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a6:	b8 01 00 00 00       	mov    $0x1,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <exit>:
SYSCALL(exit)
 3ae:	b8 02 00 00 00       	mov    $0x2,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <wait>:
SYSCALL(wait)
 3b6:	b8 03 00 00 00       	mov    $0x3,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <pipe>:
SYSCALL(pipe)
 3be:	b8 04 00 00 00       	mov    $0x4,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <read>:
SYSCALL(read)
 3c6:	b8 05 00 00 00       	mov    $0x5,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <write>:
SYSCALL(write)
 3ce:	b8 10 00 00 00       	mov    $0x10,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <close>:
SYSCALL(close)
 3d6:	b8 15 00 00 00       	mov    $0x15,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <kill>:
SYSCALL(kill)
 3de:	b8 06 00 00 00       	mov    $0x6,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <exec>:
SYSCALL(exec)
 3e6:	b8 07 00 00 00       	mov    $0x7,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <open>:
SYSCALL(open)
 3ee:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <mknod>:
SYSCALL(mknod)
 3f6:	b8 11 00 00 00       	mov    $0x11,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <unlink>:
SYSCALL(unlink)
 3fe:	b8 12 00 00 00       	mov    $0x12,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <fstat>:
SYSCALL(fstat)
 406:	b8 08 00 00 00       	mov    $0x8,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <link>:
SYSCALL(link)
 40e:	b8 13 00 00 00       	mov    $0x13,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <mkdir>:
SYSCALL(mkdir)
 416:	b8 14 00 00 00       	mov    $0x14,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <chdir>:
SYSCALL(chdir)
 41e:	b8 09 00 00 00       	mov    $0x9,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <dup>:
SYSCALL(dup)
 426:	b8 0a 00 00 00       	mov    $0xa,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <getpid>:
SYSCALL(getpid)
 42e:	b8 0b 00 00 00       	mov    $0xb,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <sbrk>:
SYSCALL(sbrk)
 436:	b8 0c 00 00 00       	mov    $0xc,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <sleep>:
SYSCALL(sleep)
 43e:	b8 0d 00 00 00       	mov    $0xd,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <uptime>:
SYSCALL(uptime)
 446:	b8 0e 00 00 00       	mov    $0xe,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <clone>:
SYSCALL(clone)
 44e:	b8 16 00 00 00       	mov    $0x16,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <texit>:
SYSCALL(texit)
 456:	b8 17 00 00 00       	mov    $0x17,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <tsleep>:
SYSCALL(tsleep)
 45e:	b8 18 00 00 00       	mov    $0x18,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <twakeup>:
SYSCALL(twakeup)
 466:	b8 19 00 00 00       	mov    $0x19,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <thread_yield>:
SYSCALL(thread_yield)
 46e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	83 ec 18             	sub    $0x18,%esp
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 489:	00 
 48a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 48d:	89 44 24 04          	mov    %eax,0x4(%esp)
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	89 04 24             	mov    %eax,(%esp)
 497:	e8 32 ff ff ff       	call   3ce <write>
}
 49c:	c9                   	leave  
 49d:	c3                   	ret    

0000049e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	56                   	push   %esi
 4a2:	53                   	push   %ebx
 4a3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b1:	74 17                	je     4ca <printint+0x2c>
 4b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b7:	79 11                	jns    4ca <printint+0x2c>
    neg = 1;
 4b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c3:	f7 d8                	neg    %eax
 4c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c8:	eb 06                	jmp    4d0 <printint+0x32>
  } else {
    x = xx;
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4da:	8d 41 01             	lea    0x1(%ecx),%eax
 4dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	ba 00 00 00 00       	mov    $0x0,%edx
 4eb:	f7 f3                	div    %ebx
 4ed:	89 d0                	mov    %edx,%eax
 4ef:	0f b6 80 d0 0f 00 00 	movzbl 0xfd0(%eax),%eax
 4f6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4fa:	8b 75 10             	mov    0x10(%ebp),%esi
 4fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 500:	ba 00 00 00 00       	mov    $0x0,%edx
 505:	f7 f6                	div    %esi
 507:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50e:	75 c7                	jne    4d7 <printint+0x39>
  if(neg)
 510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 514:	74 10                	je     526 <printint+0x88>
    buf[i++] = '-';
 516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 519:	8d 50 01             	lea    0x1(%eax),%edx
 51c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 524:	eb 1f                	jmp    545 <printint+0xa7>
 526:	eb 1d                	jmp    545 <printint+0xa7>
    putc(fd, buf[i]);
 528:	8d 55 dc             	lea    -0x24(%ebp),%edx
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	01 d0                	add    %edx,%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 31 ff ff ff       	call   476 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 545:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54d:	79 d9                	jns    528 <printint+0x8a>
    putc(fd, buf[i]);
}
 54f:	83 c4 30             	add    $0x30,%esp
 552:	5b                   	pop    %ebx
 553:	5e                   	pop    %esi
 554:	5d                   	pop    %ebp
 555:	c3                   	ret    

00000556 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 563:	8d 45 0c             	lea    0xc(%ebp),%eax
 566:	83 c0 04             	add    $0x4,%eax
 569:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 573:	e9 7c 01 00 00       	jmp    6f4 <printf+0x19e>
    c = fmt[i] & 0xff;
 578:	8b 55 0c             	mov    0xc(%ebp),%edx
 57b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57e:	01 d0                	add    %edx,%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	25 ff 00 00 00       	and    $0xff,%eax
 58b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 592:	75 2c                	jne    5c0 <printf+0x6a>
      if(c == '%'){
 594:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 598:	75 0c                	jne    5a6 <printf+0x50>
        state = '%';
 59a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a1:	e9 4a 01 00 00       	jmp    6f0 <printf+0x19a>
      } else {
        putc(fd, c);
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 bb fe ff ff       	call   476 <putc>
 5bb:	e9 30 01 00 00       	jmp    6f0 <printf+0x19a>
      }
    } else if(state == '%'){
 5c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c4:	0f 85 26 01 00 00    	jne    6f0 <printf+0x19a>
      if(c == 'd'){
 5ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ce:	75 2d                	jne    5fd <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5dc:	00 
 5dd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5e4:	00 
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	89 04 24             	mov    %eax,(%esp)
 5ef:	e8 aa fe ff ff       	call   49e <printint>
        ap++;
 5f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f8:	e9 ec 00 00 00       	jmp    6e9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5fd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 601:	74 06                	je     609 <printf+0xb3>
 603:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 607:	75 2d                	jne    636 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 609:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 615:	00 
 616:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 61d:	00 
 61e:	89 44 24 04          	mov    %eax,0x4(%esp)
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	89 04 24             	mov    %eax,(%esp)
 628:	e8 71 fe ff ff       	call   49e <printint>
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 631:	e9 b3 00 00 00       	jmp    6e9 <printf+0x193>
      } else if(c == 's'){
 636:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63a:	75 45                	jne    681 <printf+0x12b>
        s = (char*)*ap;
 63c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 644:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64c:	75 09                	jne    657 <printf+0x101>
          s = "(null)";
 64e:	c7 45 f4 b9 0b 00 00 	movl   $0xbb9,-0xc(%ebp)
        while(*s != 0){
 655:	eb 1e                	jmp    675 <printf+0x11f>
 657:	eb 1c                	jmp    675 <printf+0x11f>
          putc(fd, *s);
 659:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	89 44 24 04          	mov    %eax,0x4(%esp)
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	89 04 24             	mov    %eax,(%esp)
 66c:	e8 05 fe ff ff       	call   476 <putc>
          s++;
 671:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	84 c0                	test   %al,%al
 67d:	75 da                	jne    659 <printf+0x103>
 67f:	eb 68                	jmp    6e9 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 681:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 685:	75 1d                	jne    6a4 <printf+0x14e>
        putc(fd, *ap);
 687:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	89 44 24 04          	mov    %eax,0x4(%esp)
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	89 04 24             	mov    %eax,(%esp)
 699:	e8 d8 fd ff ff       	call   476 <putc>
        ap++;
 69e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a2:	eb 45                	jmp    6e9 <printf+0x193>
      } else if(c == '%'){
 6a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a8:	75 17                	jne    6c1 <printf+0x16b>
        putc(fd, c);
 6aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ad:	0f be c0             	movsbl %al,%eax
 6b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	89 04 24             	mov    %eax,(%esp)
 6ba:	e8 b7 fd ff ff       	call   476 <putc>
 6bf:	eb 28                	jmp    6e9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6c8:	00 
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 a2 fd ff ff       	call   476 <putc>
        putc(fd, c);
 6d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	89 44 24 04          	mov    %eax,0x4(%esp)
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 8d fd ff ff       	call   476 <putc>
      }
      state = 0;
 6e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	01 d0                	add    %edx,%eax
 6fc:	0f b6 00             	movzbl (%eax),%eax
 6ff:	84 c0                	test   %al,%al
 701:	0f 85 71 fe ff ff    	jne    578 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	83 e8 08             	sub    $0x8,%eax
 715:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	a1 f0 0f 00 00       	mov    0xff0,%eax
 71d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 720:	eb 24                	jmp    746 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72a:	77 12                	ja     73e <free+0x35>
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	77 24                	ja     758 <free+0x4f>
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	77 1a                	ja     758 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	89 45 fc             	mov    %eax,-0x4(%ebp)
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	76 d4                	jbe    722 <free+0x19>
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 756:	76 ca                	jbe    722 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	01 c2                	add    %eax,%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 00                	mov    (%eax),%eax
 76f:	39 c2                	cmp    %eax,%edx
 771:	75 24                	jne    797 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 50 04             	mov    0x4(%eax),%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	8b 10                	mov    (%eax),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	89 10                	mov    %edx,(%eax)
 795:	eb 0a                	jmp    7a1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	01 d0                	add    %edx,%eax
 7b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b6:	75 20                	jne    7d8 <free+0xcf>
    p->s.size += bp->s.size;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	01 c2                	add    %eax,%edx
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	8b 10                	mov    (%eax),%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	89 10                	mov    %edx,(%eax)
 7d6:	eb 08                	jmp    7e0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7de:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	a3 f0 0f 00 00       	mov    %eax,0xff0
}
 7e8:	c9                   	leave  
 7e9:	c3                   	ret    

000007ea <morecore>:

static Header*
morecore(uint nu)
{
 7ea:	55                   	push   %ebp
 7eb:	89 e5                	mov    %esp,%ebp
 7ed:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f7:	77 07                	ja     800 <morecore+0x16>
    nu = 4096;
 7f9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	c1 e0 03             	shl    $0x3,%eax
 806:	89 04 24             	mov    %eax,(%esp)
 809:	e8 28 fc ff ff       	call   436 <sbrk>
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 811:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 815:	75 07                	jne    81e <morecore+0x34>
    return 0;
 817:	b8 00 00 00 00       	mov    $0x0,%eax
 81c:	eb 22                	jmp    840 <morecore+0x56>
  hp = (Header*)p;
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	8b 55 08             	mov    0x8(%ebp),%edx
 82a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	83 c0 08             	add    $0x8,%eax
 833:	89 04 24             	mov    %eax,(%esp)
 836:	e8 ce fe ff ff       	call   709 <free>
  return freep;
 83b:	a1 f0 0f 00 00       	mov    0xff0,%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <malloc>:

void*
malloc(uint nbytes)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	8b 45 08             	mov    0x8(%ebp),%eax
 84b:	83 c0 07             	add    $0x7,%eax
 84e:	c1 e8 03             	shr    $0x3,%eax
 851:	83 c0 01             	add    $0x1,%eax
 854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 857:	a1 f0 0f 00 00       	mov    0xff0,%eax
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 863:	75 23                	jne    888 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 865:	c7 45 f0 e8 0f 00 00 	movl   $0xfe8,-0x10(%ebp)
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	a3 f0 0f 00 00       	mov    %eax,0xff0
 874:	a1 f0 0f 00 00       	mov    0xff0,%eax
 879:	a3 e8 0f 00 00       	mov    %eax,0xfe8
    base.s.size = 0;
 87e:	c7 05 ec 0f 00 00 00 	movl   $0x0,0xfec
 885:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 899:	72 4d                	jb     8e8 <malloc+0xa6>
      if(p->s.size == nunits)
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a4:	75 0c                	jne    8b2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 10                	mov    (%eax),%edx
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	89 10                	mov    %edx,(%eax)
 8b0:	eb 26                	jmp    8d8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8b 40 04             	mov    0x4(%eax),%eax
 8b8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8bb:	89 c2                	mov    %eax,%edx
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	c1 e0 03             	shl    $0x3,%eax
 8cc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	a3 f0 0f 00 00       	mov    %eax,0xff0
      return (void*)(p + 1);
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	83 c0 08             	add    $0x8,%eax
 8e6:	eb 38                	jmp    920 <malloc+0xde>
    }
    if(p == freep)
 8e8:	a1 f0 0f 00 00       	mov    0xff0,%eax
 8ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f0:	75 1b                	jne    90d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f5:	89 04 24             	mov    %eax,(%esp)
 8f8:	e8 ed fe ff ff       	call   7ea <morecore>
 8fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 904:	75 07                	jne    90d <malloc+0xcb>
        return 0;
 906:	b8 00 00 00 00       	mov    $0x0,%eax
 90b:	eb 13                	jmp    920 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	89 45 f0             	mov    %eax,-0x10(%ebp)
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 91b:	e9 70 ff ff ff       	jmp    890 <malloc+0x4e>
}
 920:	c9                   	leave  
 921:	c3                   	ret    

00000922 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 922:	55                   	push   %ebp
 923:	89 e5                	mov    %esp,%ebp
 925:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 928:	8b 55 08             	mov    0x8(%ebp),%edx
 92b:	8b 45 0c             	mov    0xc(%ebp),%eax
 92e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 931:	f0 87 02             	lock xchg %eax,(%edx)
 934:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 93a:	c9                   	leave  
 93b:	c3                   	ret    

0000093c <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 93c:	55                   	push   %ebp
 93d:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 948:	5d                   	pop    %ebp
 949:	c3                   	ret    

0000094a <lock_acquire>:
void lock_acquire(lock_t *lock){
 94a:	55                   	push   %ebp
 94b:	89 e5                	mov    %esp,%ebp
 94d:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 950:	90                   	nop
 951:	8b 45 08             	mov    0x8(%ebp),%eax
 954:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 95b:	00 
 95c:	89 04 24             	mov    %eax,(%esp)
 95f:	e8 be ff ff ff       	call   922 <xchg>
 964:	85 c0                	test   %eax,%eax
 966:	75 e9                	jne    951 <lock_acquire+0x7>
}
 968:	c9                   	leave  
 969:	c3                   	ret    

0000096a <lock_release>:
void lock_release(lock_t *lock){
 96a:	55                   	push   %ebp
 96b:	89 e5                	mov    %esp,%ebp
 96d:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 970:	8b 45 08             	mov    0x8(%ebp),%eax
 973:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 97a:	00 
 97b:	89 04 24             	mov    %eax,(%esp)
 97e:	e8 9f ff ff ff       	call   922 <xchg>
}
 983:	c9                   	leave  
 984:	c3                   	ret    

00000985 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 985:	55                   	push   %ebp
 986:	89 e5                	mov    %esp,%ebp
 988:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 98b:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 992:	e8 ab fe ff ff       	call   842 <malloc>
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a3:	25 ff 0f 00 00       	and    $0xfff,%eax
 9a8:	85 c0                	test   %eax,%eax
 9aa:	74 14                	je     9c0 <thread_create+0x3b>
        stack = stack + (4096 - (uint)stack % 4096);
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	25 ff 0f 00 00       	and    $0xfff,%eax
 9b4:	89 c2                	mov    %eax,%edx
 9b6:	b8 00 10 00 00       	mov    $0x1000,%eax
 9bb:	29 d0                	sub    %edx,%eax
 9bd:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 9c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c4:	75 1b                	jne    9e1 <thread_create+0x5c>

        printf(1,"malloc fail \n");
 9c6:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
 9cd:	00 
 9ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9d5:	e8 7c fb ff ff       	call   556 <printf>
        return 0;
 9da:	b8 00 00 00 00       	mov    $0x0,%eax
 9df:	eb 6f                	jmp    a50 <thread_create+0xcb>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 9e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 9e4:	8b 55 08             	mov    0x8(%ebp),%edx
 9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ea:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 9ee:	89 54 24 08          	mov    %edx,0x8(%esp)
 9f2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9f9:	00 
 9fa:	89 04 24             	mov    %eax,(%esp)
 9fd:	e8 4c fa ff ff       	call   44e <clone>
 a02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a09:	79 1b                	jns    a26 <thread_create+0xa1>
        printf(1,"clone fails\n");
 a0b:	c7 44 24 04 ce 0b 00 	movl   $0xbce,0x4(%esp)
 a12:	00 
 a13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a1a:	e8 37 fb ff ff       	call   556 <printf>
        return 0;
 a1f:	b8 00 00 00 00       	mov    $0x0,%eax
 a24:	eb 2a                	jmp    a50 <thread_create+0xcb>
    }
    if(tid > 0){
 a26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a2a:	7e 05                	jle    a31 <thread_create+0xac>
        //store threads on thread table
        return garbage_stack;
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	eb 1f                	jmp    a50 <thread_create+0xcb>
    }
    if(tid == 0){
 a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a35:	75 14                	jne    a4b <thread_create+0xc6>
        printf(1,"tid = 0 return \n");
 a37:	c7 44 24 04 db 0b 00 	movl   $0xbdb,0x4(%esp)
 a3e:	00 
 a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a46:	e8 0b fb ff ff       	call   556 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a50:	c9                   	leave  
 a51:	c3                   	ret    

00000a52 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a52:	55                   	push   %ebp
 a53:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a55:	a1 e4 0f 00 00       	mov    0xfe4,%eax
 a5a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 a60:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 a65:	a3 e4 0f 00 00       	mov    %eax,0xfe4
    return (int)(rands % max);
 a6a:	a1 e4 0f 00 00       	mov    0xfe4,%eax
 a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a72:	ba 00 00 00 00       	mov    $0x0,%edx
 a77:	f7 f1                	div    %ecx
 a79:	89 d0                	mov    %edx,%eax
}
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret    

00000a7d <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 a7d:	55                   	push   %ebp
 a7e:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a80:	8b 45 08             	mov    0x8(%ebp),%eax
 a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a89:	8b 45 08             	mov    0x8(%ebp),%eax
 a8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
 a96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a9d:	5d                   	pop    %ebp
 a9e:	c3                   	ret    

00000a9f <add_q>:

void add_q(struct queue *q, int v){
 a9f:	55                   	push   %ebp
 aa0:	89 e5                	mov    %esp,%ebp
 aa2:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 aa5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 aac:	e8 91 fd ff ff       	call   842 <malloc>
 ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
 ac4:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 ac6:	8b 45 08             	mov    0x8(%ebp),%eax
 ac9:	8b 40 04             	mov    0x4(%eax),%eax
 acc:	85 c0                	test   %eax,%eax
 ace:	75 0b                	jne    adb <add_q+0x3c>
        q->head = n;
 ad0:	8b 45 08             	mov    0x8(%ebp),%eax
 ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ad6:	89 50 04             	mov    %edx,0x4(%eax)
 ad9:	eb 0c                	jmp    ae7 <add_q+0x48>
    }else{
        q->tail->next = n;
 adb:	8b 45 08             	mov    0x8(%ebp),%eax
 ade:	8b 40 08             	mov    0x8(%eax),%eax
 ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ae4:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 ae7:	8b 45 08             	mov    0x8(%ebp),%eax
 aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aed:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 af0:	8b 45 08             	mov    0x8(%ebp),%eax
 af3:	8b 00                	mov    (%eax),%eax
 af5:	8d 50 01             	lea    0x1(%eax),%edx
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	89 10                	mov    %edx,(%eax)
}
 afd:	c9                   	leave  
 afe:	c3                   	ret    

00000aff <empty_q>:

int empty_q(struct queue *q){
 aff:	55                   	push   %ebp
 b00:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b02:	8b 45 08             	mov    0x8(%ebp),%eax
 b05:	8b 00                	mov    (%eax),%eax
 b07:	85 c0                	test   %eax,%eax
 b09:	75 07                	jne    b12 <empty_q+0x13>
        return 1;
 b0b:	b8 01 00 00 00       	mov    $0x1,%eax
 b10:	eb 05                	jmp    b17 <empty_q+0x18>
    else
        return 0;
 b12:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b17:	5d                   	pop    %ebp
 b18:	c3                   	ret    

00000b19 <pop_q>:
int pop_q(struct queue *q){
 b19:	55                   	push   %ebp
 b1a:	89 e5                	mov    %esp,%ebp
 b1c:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	89 04 24             	mov    %eax,(%esp)
 b25:	e8 d5 ff ff ff       	call   aff <empty_q>
 b2a:	85 c0                	test   %eax,%eax
 b2c:	75 5d                	jne    b8b <pop_q+0x72>
       val = q->head->value; 
 b2e:	8b 45 08             	mov    0x8(%ebp),%eax
 b31:	8b 40 04             	mov    0x4(%eax),%eax
 b34:	8b 00                	mov    (%eax),%eax
 b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b39:	8b 45 08             	mov    0x8(%ebp),%eax
 b3c:	8b 40 04             	mov    0x4(%eax),%eax
 b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b42:	8b 45 08             	mov    0x8(%ebp),%eax
 b45:	8b 40 04             	mov    0x4(%eax),%eax
 b48:	8b 50 04             	mov    0x4(%eax),%edx
 b4b:	8b 45 08             	mov    0x8(%ebp),%eax
 b4e:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b54:	89 04 24             	mov    %eax,(%esp)
 b57:	e8 ad fb ff ff       	call   709 <free>
       q->size--;
 b5c:	8b 45 08             	mov    0x8(%ebp),%eax
 b5f:	8b 00                	mov    (%eax),%eax
 b61:	8d 50 ff             	lea    -0x1(%eax),%edx
 b64:	8b 45 08             	mov    0x8(%ebp),%eax
 b67:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 b69:	8b 45 08             	mov    0x8(%ebp),%eax
 b6c:	8b 00                	mov    (%eax),%eax
 b6e:	85 c0                	test   %eax,%eax
 b70:	75 14                	jne    b86 <pop_q+0x6d>
            q->head = 0;
 b72:	8b 45 08             	mov    0x8(%ebp),%eax
 b75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b7c:	8b 45 08             	mov    0x8(%ebp),%eax
 b7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b89:	eb 05                	jmp    b90 <pop_q+0x77>
    }
    return -1;
 b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b90:	c9                   	leave  
 b91:	c3                   	ret    
