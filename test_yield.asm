
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
  20:	e8 68 09 00 00       	call   98d <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  29:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  2e:	75 19                	jne    49 <main+0x49>
       printf(1,"wrong happen");
  30:	c7 44 24 04 01 0c 00 	movl   $0xc01,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 1a 05 00 00       	call   55e <printf>
       exit();
  44:	e8 65 03 00 00       	call   3ae <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  49:	8d 44 24 18          	lea    0x18(%esp),%eax
  4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  51:	c7 04 24 f2 00 00 00 	movl   $0xf2,(%esp)
  58:	e8 30 09 00 00       	call   98d <thread_create>
  5d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  61:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  66:	75 19                	jne    81 <main+0x81>
       printf(1,"wrong happen");
  68:	c7 44 24 04 01 0c 00 	movl   $0xc01,0x4(%esp)
  6f:	00 
  70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  77:	e8 e2 04 00 00       	call   55e <printf>
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
  8c:	a1 68 10 00 00       	mov    0x1068,%eax
  91:	83 c0 01             	add    $0x1,%eax
  94:	a3 68 10 00 00       	mov    %eax,0x1068
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
  af:	a3 68 10 00 00       	mov    %eax,0x1068
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
  cd:	c7 44 24 04 0e 0c 00 	movl   $0xc0e,0x4(%esp)
  d4:	00 
  d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dc:	e8 7d 04 00 00       	call   55e <printf>
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
 103:	a3 68 10 00 00       	mov    %eax,0x1068
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
 121:	c7 44 24 04 1b 0c 00 	movl   $0xc1b,0x4(%esp)
 128:	00 
 129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 130:	e8 29 04 00 00       	call   55e <printf>
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

00000476 <thread_yield3>:
 476:	b8 1a 00 00 00       	mov    $0x1a,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	83 ec 18             	sub    $0x18,%esp
 484:	8b 45 0c             	mov    0xc(%ebp),%eax
 487:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 48a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 491:	00 
 492:	8d 45 f4             	lea    -0xc(%ebp),%eax
 495:	89 44 24 04          	mov    %eax,0x4(%esp)
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	89 04 24             	mov    %eax,(%esp)
 49f:	e8 2a ff ff ff       	call   3ce <write>
}
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	56                   	push   %esi
 4aa:	53                   	push   %ebx
 4ab:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b9:	74 17                	je     4d2 <printint+0x2c>
 4bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4bf:	79 11                	jns    4d2 <printint+0x2c>
    neg = 1;
 4c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cb:	f7 d8                	neg    %eax
 4cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d0:	eb 06                	jmp    4d8 <printint+0x32>
  } else {
    x = xx;
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e2:	8d 41 01             	lea    0x1(%ecx),%eax
 4e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ee:	ba 00 00 00 00       	mov    $0x0,%edx
 4f3:	f7 f3                	div    %ebx
 4f5:	89 d0                	mov    %edx,%eax
 4f7:	0f b6 80 6c 10 00 00 	movzbl 0x106c(%eax),%eax
 4fe:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 502:	8b 75 10             	mov    0x10(%ebp),%esi
 505:	8b 45 ec             	mov    -0x14(%ebp),%eax
 508:	ba 00 00 00 00       	mov    $0x0,%edx
 50d:	f7 f6                	div    %esi
 50f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 516:	75 c7                	jne    4df <printint+0x39>
  if(neg)
 518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51c:	74 10                	je     52e <printint+0x88>
    buf[i++] = '-';
 51e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 521:	8d 50 01             	lea    0x1(%eax),%edx
 524:	89 55 f4             	mov    %edx,-0xc(%ebp)
 527:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52c:	eb 1f                	jmp    54d <printint+0xa7>
 52e:	eb 1d                	jmp    54d <printint+0xa7>
    putc(fd, buf[i]);
 530:	8d 55 dc             	lea    -0x24(%ebp),%edx
 533:	8b 45 f4             	mov    -0xc(%ebp),%eax
 536:	01 d0                	add    %edx,%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	0f be c0             	movsbl %al,%eax
 53e:	89 44 24 04          	mov    %eax,0x4(%esp)
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	89 04 24             	mov    %eax,(%esp)
 548:	e8 31 ff ff ff       	call   47e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 555:	79 d9                	jns    530 <printint+0x8a>
    putc(fd, buf[i]);
}
 557:	83 c4 30             	add    $0x30,%esp
 55a:	5b                   	pop    %ebx
 55b:	5e                   	pop    %esi
 55c:	5d                   	pop    %ebp
 55d:	c3                   	ret    

0000055e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 55e:	55                   	push   %ebp
 55f:	89 e5                	mov    %esp,%ebp
 561:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 56b:	8d 45 0c             	lea    0xc(%ebp),%eax
 56e:	83 c0 04             	add    $0x4,%eax
 571:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 574:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 57b:	e9 7c 01 00 00       	jmp    6fc <printf+0x19e>
    c = fmt[i] & 0xff;
 580:	8b 55 0c             	mov    0xc(%ebp),%edx
 583:	8b 45 f0             	mov    -0x10(%ebp),%eax
 586:	01 d0                	add    %edx,%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	25 ff 00 00 00       	and    $0xff,%eax
 593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 596:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59a:	75 2c                	jne    5c8 <printf+0x6a>
      if(c == '%'){
 59c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a0:	75 0c                	jne    5ae <printf+0x50>
        state = '%';
 5a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a9:	e9 4a 01 00 00       	jmp    6f8 <printf+0x19a>
      } else {
        putc(fd, c);
 5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	89 04 24             	mov    %eax,(%esp)
 5be:	e8 bb fe ff ff       	call   47e <putc>
 5c3:	e9 30 01 00 00       	jmp    6f8 <printf+0x19a>
      }
    } else if(state == '%'){
 5c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5cc:	0f 85 26 01 00 00    	jne    6f8 <printf+0x19a>
      if(c == 'd'){
 5d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d6:	75 2d                	jne    605 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e4:	00 
 5e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ec:	00 
 5ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	89 04 24             	mov    %eax,(%esp)
 5f7:	e8 aa fe ff ff       	call   4a6 <printint>
        ap++;
 5fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 600:	e9 ec 00 00 00       	jmp    6f1 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 605:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 609:	74 06                	je     611 <printf+0xb3>
 60b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60f:	75 2d                	jne    63e <printf+0xe0>
        printint(fd, *ap, 16, 0);
 611:	8b 45 e8             	mov    -0x18(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 61d:	00 
 61e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 625:	00 
 626:	89 44 24 04          	mov    %eax,0x4(%esp)
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	89 04 24             	mov    %eax,(%esp)
 630:	e8 71 fe ff ff       	call   4a6 <printint>
        ap++;
 635:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 639:	e9 b3 00 00 00       	jmp    6f1 <printf+0x193>
      } else if(c == 's'){
 63e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 642:	75 45                	jne    689 <printf+0x12b>
        s = (char*)*ap;
 644:	8b 45 e8             	mov    -0x18(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 654:	75 09                	jne    65f <printf+0x101>
          s = "(null)";
 656:	c7 45 f4 28 0c 00 00 	movl   $0xc28,-0xc(%ebp)
        while(*s != 0){
 65d:	eb 1e                	jmp    67d <printf+0x11f>
 65f:	eb 1c                	jmp    67d <printf+0x11f>
          putc(fd, *s);
 661:	8b 45 f4             	mov    -0xc(%ebp),%eax
 664:	0f b6 00             	movzbl (%eax),%eax
 667:	0f be c0             	movsbl %al,%eax
 66a:	89 44 24 04          	mov    %eax,0x4(%esp)
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	89 04 24             	mov    %eax,(%esp)
 674:	e8 05 fe ff ff       	call   47e <putc>
          s++;
 679:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	0f b6 00             	movzbl (%eax),%eax
 683:	84 c0                	test   %al,%al
 685:	75 da                	jne    661 <printf+0x103>
 687:	eb 68                	jmp    6f1 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 689:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68d:	75 1d                	jne    6ac <printf+0x14e>
        putc(fd, *ap);
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	0f be c0             	movsbl %al,%eax
 697:	89 44 24 04          	mov    %eax,0x4(%esp)
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	89 04 24             	mov    %eax,(%esp)
 6a1:	e8 d8 fd ff ff       	call   47e <putc>
        ap++;
 6a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6aa:	eb 45                	jmp    6f1 <printf+0x193>
      } else if(c == '%'){
 6ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b0:	75 17                	jne    6c9 <printf+0x16b>
        putc(fd, c);
 6b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 b7 fd ff ff       	call   47e <putc>
 6c7:	eb 28                	jmp    6f1 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6d0:	00 
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	89 04 24             	mov    %eax,(%esp)
 6d7:	e8 a2 fd ff ff       	call   47e <putc>
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	89 04 24             	mov    %eax,(%esp)
 6ec:	e8 8d fd ff ff       	call   47e <putc>
      }
      state = 0;
 6f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	84 c0                	test   %al,%al
 709:	0f 85 71 fe ff ff    	jne    580 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	83 e8 08             	sub    $0x8,%eax
 71d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	a1 8c 10 00 00       	mov    0x108c,%eax
 725:	89 45 fc             	mov    %eax,-0x4(%ebp)
 728:	eb 24                	jmp    74e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	77 12                	ja     746 <free+0x35>
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73a:	77 24                	ja     760 <free+0x4f>
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 744:	77 1a                	ja     760 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 754:	76 d4                	jbe    72a <free+0x19>
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75e:	76 ca                	jbe    72a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	01 c2                	add    %eax,%edx
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	39 c2                	cmp    %eax,%edx
 779:	75 24                	jne    79f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	01 c2                	add    %eax,%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 0a                	jmp    7a9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	01 d0                	add    %edx,%eax
 7bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7be:	75 20                	jne    7e0 <free+0xcf>
    p->s.size += bp->s.size;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 50 04             	mov    0x4(%eax),%edx
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	8b 10                	mov    (%eax),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	89 10                	mov    %edx,(%eax)
 7de:	eb 08                	jmp    7e8 <free+0xd7>
  } else
    p->s.ptr = bp;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e6:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	a3 8c 10 00 00       	mov    %eax,0x108c
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <morecore>:

static Header*
morecore(uint nu)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ff:	77 07                	ja     808 <morecore+0x16>
    nu = 4096;
 801:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 808:	8b 45 08             	mov    0x8(%ebp),%eax
 80b:	c1 e0 03             	shl    $0x3,%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 20 fc ff ff       	call   436 <sbrk>
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 819:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81d:	75 07                	jne    826 <morecore+0x34>
    return 0;
 81f:	b8 00 00 00 00       	mov    $0x0,%eax
 824:	eb 22                	jmp    848 <morecore+0x56>
  hp = (Header*)p;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82f:	8b 55 08             	mov    0x8(%ebp),%edx
 832:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	83 c0 08             	add    $0x8,%eax
 83b:	89 04 24             	mov    %eax,(%esp)
 83e:	e8 ce fe ff ff       	call   711 <free>
  return freep;
 843:	a1 8c 10 00 00       	mov    0x108c,%eax
}
 848:	c9                   	leave  
 849:	c3                   	ret    

0000084a <malloc>:

void*
malloc(uint nbytes)
{
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	83 c0 07             	add    $0x7,%eax
 856:	c1 e8 03             	shr    $0x3,%eax
 859:	83 c0 01             	add    $0x1,%eax
 85c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85f:	a1 8c 10 00 00       	mov    0x108c,%eax
 864:	89 45 f0             	mov    %eax,-0x10(%ebp)
 867:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86b:	75 23                	jne    890 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86d:	c7 45 f0 84 10 00 00 	movl   $0x1084,-0x10(%ebp)
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	a3 8c 10 00 00       	mov    %eax,0x108c
 87c:	a1 8c 10 00 00       	mov    0x108c,%eax
 881:	a3 84 10 00 00       	mov    %eax,0x1084
    base.s.size = 0;
 886:	c7 05 88 10 00 00 00 	movl   $0x0,0x1088
 88d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	8b 00                	mov    (%eax),%eax
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a1:	72 4d                	jb     8f0 <malloc+0xa6>
      if(p->s.size == nunits)
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 40 04             	mov    0x4(%eax),%eax
 8a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ac:	75 0c                	jne    8ba <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 10                	mov    (%eax),%edx
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	89 10                	mov    %edx,(%eax)
 8b8:	eb 26                	jmp    8e0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c3:	89 c2                	mov    %eax,%edx
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 40 04             	mov    0x4(%eax),%eax
 8d1:	c1 e0 03             	shl    $0x3,%eax
 8d4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8dd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e3:	a3 8c 10 00 00       	mov    %eax,0x108c
      return (void*)(p + 1);
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	83 c0 08             	add    $0x8,%eax
 8ee:	eb 38                	jmp    928 <malloc+0xde>
    }
    if(p == freep)
 8f0:	a1 8c 10 00 00       	mov    0x108c,%eax
 8f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f8:	75 1b                	jne    915 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fd:	89 04 24             	mov    %eax,(%esp)
 900:	e8 ed fe ff ff       	call   7f2 <morecore>
 905:	89 45 f4             	mov    %eax,-0xc(%ebp)
 908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90c:	75 07                	jne    915 <malloc+0xcb>
        return 0;
 90e:	b8 00 00 00 00       	mov    $0x0,%eax
 913:	eb 13                	jmp    928 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 923:	e9 70 ff ff ff       	jmp    898 <malloc+0x4e>
}
 928:	c9                   	leave  
 929:	c3                   	ret    

0000092a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 92a:	55                   	push   %ebp
 92b:	89 e5                	mov    %esp,%ebp
 92d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 930:	8b 55 08             	mov    0x8(%ebp),%edx
 933:	8b 45 0c             	mov    0xc(%ebp),%eax
 936:	8b 4d 08             	mov    0x8(%ebp),%ecx
 939:	f0 87 02             	lock xchg %eax,(%edx)
 93c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 942:	c9                   	leave  
 943:	c3                   	ret    

00000944 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 950:	5d                   	pop    %ebp
 951:	c3                   	ret    

00000952 <lock_acquire>:
void lock_acquire(lock_t *lock){
 952:	55                   	push   %ebp
 953:	89 e5                	mov    %esp,%ebp
 955:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 958:	90                   	nop
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 963:	00 
 964:	89 04 24             	mov    %eax,(%esp)
 967:	e8 be ff ff ff       	call   92a <xchg>
 96c:	85 c0                	test   %eax,%eax
 96e:	75 e9                	jne    959 <lock_acquire+0x7>
}
 970:	c9                   	leave  
 971:	c3                   	ret    

00000972 <lock_release>:
void lock_release(lock_t *lock){
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 982:	00 
 983:	89 04 24             	mov    %eax,(%esp)
 986:	e8 9f ff ff ff       	call   92a <xchg>
}
 98b:	c9                   	leave  
 98c:	c3                   	ret    

0000098d <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 98d:	55                   	push   %ebp
 98e:	89 e5                	mov    %esp,%ebp
 990:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 993:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 99a:	e8 ab fe ff ff       	call   84a <malloc>
 99f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 9a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 9a8:	0f b6 05 90 10 00 00 	movzbl 0x1090,%eax
 9af:	84 c0                	test   %al,%al
 9b1:	75 1c                	jne    9cf <thread_create+0x42>
        init_q(thQ2);
 9b3:	a1 94 10 00 00       	mov    0x1094,%eax
 9b8:	89 04 24             	mov    %eax,(%esp)
 9bb:	e8 2c 01 00 00       	call   aec <init_q>
        inQ++;
 9c0:	0f b6 05 90 10 00 00 	movzbl 0x1090,%eax
 9c7:	83 c0 01             	add    $0x1,%eax
 9ca:	a2 90 10 00 00       	mov    %al,0x1090
    }

    if((uint)stack % 4096){
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	25 ff 0f 00 00       	and    $0xfff,%eax
 9d7:	85 c0                	test   %eax,%eax
 9d9:	74 14                	je     9ef <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 9db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9de:	25 ff 0f 00 00       	and    $0xfff,%eax
 9e3:	89 c2                	mov    %eax,%edx
 9e5:	b8 00 10 00 00       	mov    $0x1000,%eax
 9ea:	29 d0                	sub    %edx,%eax
 9ec:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 9ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f3:	75 1e                	jne    a13 <thread_create+0x86>

        printf(1,"malloc fail \n");
 9f5:	c7 44 24 04 2f 0c 00 	movl   $0xc2f,0x4(%esp)
 9fc:	00 
 9fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a04:	e8 55 fb ff ff       	call   55e <printf>
        return 0;
 a09:	b8 00 00 00 00       	mov    $0x0,%eax
 a0e:	e9 83 00 00 00       	jmp    a96 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a16:	8b 55 08             	mov    0x8(%ebp),%edx
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a20:	89 54 24 08          	mov    %edx,0x8(%esp)
 a24:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a2b:	00 
 a2c:	89 04 24             	mov    %eax,(%esp)
 a2f:	e8 1a fa ff ff       	call   44e <clone>
 a34:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a3b:	79 1b                	jns    a58 <thread_create+0xcb>
        printf(1,"clone fails\n");
 a3d:	c7 44 24 04 3d 0c 00 	movl   $0xc3d,0x4(%esp)
 a44:	00 
 a45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a4c:	e8 0d fb ff ff       	call   55e <printf>
        return 0;
 a51:	b8 00 00 00 00       	mov    $0x0,%eax
 a56:	eb 3e                	jmp    a96 <thread_create+0x109>
    }
    if(tid > 0){
 a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a5c:	7e 19                	jle    a77 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 a5e:	a1 94 10 00 00       	mov    0x1094,%eax
 a63:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a66:	89 54 24 04          	mov    %edx,0x4(%esp)
 a6a:	89 04 24             	mov    %eax,(%esp)
 a6d:	e8 9c 00 00 00       	call   b0e <add_q>
        return garbage_stack;
 a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a75:	eb 1f                	jmp    a96 <thread_create+0x109>
    }
    if(tid == 0){
 a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a7b:	75 14                	jne    a91 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 a7d:	c7 44 24 04 4a 0c 00 	movl   $0xc4a,0x4(%esp)
 a84:	00 
 a85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a8c:	e8 cd fa ff ff       	call   55e <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a96:	c9                   	leave  
 a97:	c3                   	ret    

00000a98 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a98:	55                   	push   %ebp
 a99:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a9b:	a1 80 10 00 00       	mov    0x1080,%eax
 aa0:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 aa6:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 aab:	a3 80 10 00 00       	mov    %eax,0x1080
    return (int)(rands % max);
 ab0:	a1 80 10 00 00       	mov    0x1080,%eax
 ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 ab8:	ba 00 00 00 00       	mov    $0x0,%edx
 abd:	f7 f1                	div    %ecx
 abf:	89 d0                	mov    %edx,%eax
}
 ac1:	5d                   	pop    %ebp
 ac2:	c3                   	ret    

00000ac3 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 ac3:	55                   	push   %ebp
 ac4:	89 e5                	mov    %esp,%ebp
 ac6:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
 ac9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 acf:	8b 40 10             	mov    0x10(%eax),%eax
 ad2:	89 44 24 08          	mov    %eax,0x8(%esp)
 ad6:	c7 44 24 04 5b 0c 00 	movl   $0xc5b,0x4(%esp)
 add:	00 
 ade:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ae5:	e8 74 fa ff ff       	call   55e <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
 aea:	c9                   	leave  
 aeb:	c3                   	ret    

00000aec <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 aec:	55                   	push   %ebp
 aed:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 aef:	8b 45 08             	mov    0x8(%ebp),%eax
 af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 b02:	8b 45 08             	mov    0x8(%ebp),%eax
 b05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 b0c:	5d                   	pop    %ebp
 b0d:	c3                   	ret    

00000b0e <add_q>:

void add_q(struct queue *q, int v){
 b0e:	55                   	push   %ebp
 b0f:	89 e5                	mov    %esp,%ebp
 b11:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 b14:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b1b:	e8 2a fd ff ff       	call   84a <malloc>
 b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	8b 55 0c             	mov    0xc(%ebp),%edx
 b33:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b35:	8b 45 08             	mov    0x8(%ebp),%eax
 b38:	8b 40 04             	mov    0x4(%eax),%eax
 b3b:	85 c0                	test   %eax,%eax
 b3d:	75 0b                	jne    b4a <add_q+0x3c>
        q->head = n;
 b3f:	8b 45 08             	mov    0x8(%ebp),%eax
 b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b45:	89 50 04             	mov    %edx,0x4(%eax)
 b48:	eb 0c                	jmp    b56 <add_q+0x48>
    }else{
        q->tail->next = n;
 b4a:	8b 45 08             	mov    0x8(%ebp),%eax
 b4d:	8b 40 08             	mov    0x8(%eax),%eax
 b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b53:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b56:	8b 45 08             	mov    0x8(%ebp),%eax
 b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b5c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b5f:	8b 45 08             	mov    0x8(%ebp),%eax
 b62:	8b 00                	mov    (%eax),%eax
 b64:	8d 50 01             	lea    0x1(%eax),%edx
 b67:	8b 45 08             	mov    0x8(%ebp),%eax
 b6a:	89 10                	mov    %edx,(%eax)
}
 b6c:	c9                   	leave  
 b6d:	c3                   	ret    

00000b6e <empty_q>:

int empty_q(struct queue *q){
 b6e:	55                   	push   %ebp
 b6f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b71:	8b 45 08             	mov    0x8(%ebp),%eax
 b74:	8b 00                	mov    (%eax),%eax
 b76:	85 c0                	test   %eax,%eax
 b78:	75 07                	jne    b81 <empty_q+0x13>
        return 1;
 b7a:	b8 01 00 00 00       	mov    $0x1,%eax
 b7f:	eb 05                	jmp    b86 <empty_q+0x18>
    else
        return 0;
 b81:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b86:	5d                   	pop    %ebp
 b87:	c3                   	ret    

00000b88 <pop_q>:
int pop_q(struct queue *q){
 b88:	55                   	push   %ebp
 b89:	89 e5                	mov    %esp,%ebp
 b8b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b8e:	8b 45 08             	mov    0x8(%ebp),%eax
 b91:	89 04 24             	mov    %eax,(%esp)
 b94:	e8 d5 ff ff ff       	call   b6e <empty_q>
 b99:	85 c0                	test   %eax,%eax
 b9b:	75 5d                	jne    bfa <pop_q+0x72>
       val = q->head->value; 
 b9d:	8b 45 08             	mov    0x8(%ebp),%eax
 ba0:	8b 40 04             	mov    0x4(%eax),%eax
 ba3:	8b 00                	mov    (%eax),%eax
 ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 ba8:	8b 45 08             	mov    0x8(%ebp),%eax
 bab:	8b 40 04             	mov    0x4(%eax),%eax
 bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 bb1:	8b 45 08             	mov    0x8(%ebp),%eax
 bb4:	8b 40 04             	mov    0x4(%eax),%eax
 bb7:	8b 50 04             	mov    0x4(%eax),%edx
 bba:	8b 45 08             	mov    0x8(%ebp),%eax
 bbd:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc3:	89 04 24             	mov    %eax,(%esp)
 bc6:	e8 46 fb ff ff       	call   711 <free>
       q->size--;
 bcb:	8b 45 08             	mov    0x8(%ebp),%eax
 bce:	8b 00                	mov    (%eax),%eax
 bd0:	8d 50 ff             	lea    -0x1(%eax),%edx
 bd3:	8b 45 08             	mov    0x8(%ebp),%eax
 bd6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 bd8:	8b 45 08             	mov    0x8(%ebp),%eax
 bdb:	8b 00                	mov    (%eax),%eax
 bdd:	85 c0                	test   %eax,%eax
 bdf:	75 14                	jne    bf5 <pop_q+0x6d>
            q->head = 0;
 be1:	8b 45 08             	mov    0x8(%ebp),%eax
 be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 beb:	8b 45 08             	mov    0x8(%ebp),%eax
 bee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf8:	eb 05                	jmp    bff <pop_q+0x77>
    }
    return -1;
 bfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bff:	c9                   	leave  
 c00:	c3                   	ret    
