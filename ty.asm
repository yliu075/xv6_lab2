
_ty:     file format elf32-i386


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
  19:	c7 04 24 c6 00 00 00 	movl   $0xc6,(%esp)
  20:	e8 b8 09 00 00       	call   9dd <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   printf(1,"Thread Created 1\n");
  29:	c7 44 24 04 00 0d 00 	movl   $0xd00,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 71 05 00 00       	call   5ae <printf>
   if(tid <= 0){
  3d:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  42:	75 19                	jne    5d <main+0x5d>
       printf(1,"wrong happen\n");
  44:	c7 44 24 04 12 0d 00 	movl   $0xd12,0x4(%esp)
  4b:	00 
  4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  53:	e8 56 05 00 00       	call   5ae <printf>
       exit();
  58:	e8 a1 03 00 00       	call   3fe <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  5d:	8d 44 24 18          	lea    0x18(%esp),%eax
  61:	89 44 24 04          	mov    %eax,0x4(%esp)
  65:	c7 04 24 2e 01 00 00 	movl   $0x12e,(%esp)
  6c:	e8 6c 09 00 00       	call   9dd <thread_create>
  71:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   printf(1,"Thread Created 2\n");
  75:	c7 44 24 04 20 0d 00 	movl   $0xd20,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  84:	e8 25 05 00 00       	call   5ae <printf>
   if(tid <= 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	75 19                	jne    a9 <main+0xa9>
       printf(1,"wrong happen\n");
  90:	c7 44 24 04 12 0d 00 	movl   $0xd12,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 0a 05 00 00       	call   5ae <printf>
       exit();
  a4:	e8 55 03 00 00       	call   3fe <exit>
   } 
   exit();
  a9:	e8 50 03 00 00       	call   3fe <exit>

000000ae <test_func>:
}

void test_func(void *arg_ptr){
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
  b4:	a1 d4 11 00 00       	mov    0x11d4,%eax
  b9:	83 c0 01             	add    $0x1,%eax
  bc:	a3 d4 11 00 00       	mov    %eax,0x11d4
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
  c1:	e8 e0 03 00 00       	call   4a6 <texit>

000000c6 <ping>:
}

void ping(void *arg_ptr){
  c6:	55                   	push   %ebp
  c7:	89 e5                	mov    %esp,%ebp
  c9:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
  d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d5:	8b 00                	mov    (%eax),%eax
  d7:	a3 d4 11 00 00       	mov    %eax,0x11d4
    int i = 0;
  dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
  e3:	eb 41                	jmp    126 <ping+0x60>
    // while(1) {
        printf(1,"\nPing %d %d \n",*num, i);
  e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e8:	8b 00                	mov    (%eax),%eax
  ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  f5:	c7 44 24 04 32 0d 00 	movl   $0xd32,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 104:	e8 a5 04 00 00       	call   5ae <printf>
        thread_yield2();
 109:	e8 05 0a 00 00       	call   b13 <thread_yield2>
        printf(1,"Pinged\n");
 10e:	c7 44 24 04 40 0d 00 	movl   $0xd40,0x4(%esp)
 115:	00 
 116:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 11d:	e8 8c 04 00 00       	call   5ae <printf>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
 122:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 126:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 12a:	7e b9                	jle    e5 <ping+0x1f>
    // while(1) {
        printf(1,"\nPing %d %d \n",*num, i);
        thread_yield2();
        printf(1,"Pinged\n");
    }
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <pong>:
void pong(void *arg_ptr){
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
 13a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 13d:	8b 00                	mov    (%eax),%eax
 13f:	a3 d4 11 00 00       	mov    %eax,0x11d4
    int i = 0;
 144:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
 14b:	eb 41                	jmp    18e <pong+0x60>
    // while(1) {
        printf(1,"\nPong %d %d \n",*num, i);
 14d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 150:	8b 00                	mov    (%eax),%eax
 152:	8b 55 f4             	mov    -0xc(%ebp),%edx
 155:	89 54 24 0c          	mov    %edx,0xc(%esp)
 159:	89 44 24 08          	mov    %eax,0x8(%esp)
 15d:	c7 44 24 04 48 0d 00 	movl   $0xd48,0x4(%esp)
 164:	00 
 165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16c:	e8 3d 04 00 00       	call   5ae <printf>
        thread_yield2();
 171:	e8 9d 09 00 00       	call   b13 <thread_yield2>
        printf(1,"Ponged\n");
 176:	c7 44 24 04 56 0d 00 	movl   $0xd56,0x4(%esp)
 17d:	00 
 17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 185:	e8 24 04 00 00       	call   5ae <printf>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
 18a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 18e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 192:	7e b9                	jle    14d <pong+0x1f>
    // while(1) {
        printf(1,"\nPong %d %d \n",*num, i);
        thread_yield2();
        printf(1,"Ponged\n");
    }
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	57                   	push   %edi
 19a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19e:	8b 55 10             	mov    0x10(%ebp),%edx
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	89 cb                	mov    %ecx,%ebx
 1a6:	89 df                	mov    %ebx,%edi
 1a8:	89 d1                	mov    %edx,%ecx
 1aa:	fc                   	cld    
 1ab:	f3 aa                	rep stos %al,%es:(%edi)
 1ad:	89 ca                	mov    %ecx,%edx
 1af:	89 fb                	mov    %edi,%ebx
 1b1:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1b4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1b7:	5b                   	pop    %ebx
 1b8:	5f                   	pop    %edi
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    

000001bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1c7:	90                   	nop
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	8d 50 01             	lea    0x1(%eax),%edx
 1ce:	89 55 08             	mov    %edx,0x8(%ebp)
 1d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 1d4:	8d 4a 01             	lea    0x1(%edx),%ecx
 1d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1da:	0f b6 12             	movzbl (%edx),%edx
 1dd:	88 10                	mov    %dl,(%eax)
 1df:	0f b6 00             	movzbl (%eax),%eax
 1e2:	84 c0                	test   %al,%al
 1e4:	75 e2                	jne    1c8 <strcpy+0xd>
    ;
  return os;
 1e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ee:	eb 08                	jmp    1f8 <strcmp+0xd>
    p++, q++;
 1f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	0f b6 00             	movzbl (%eax),%eax
 1fe:	84 c0                	test   %al,%al
 200:	74 10                	je     212 <strcmp+0x27>
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	0f b6 10             	movzbl (%eax),%edx
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	38 c2                	cmp    %al,%dl
 210:	74 de                	je     1f0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	0f b6 d0             	movzbl %al,%edx
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	0f b6 c0             	movzbl %al,%eax
 224:	29 c2                	sub    %eax,%edx
 226:	89 d0                	mov    %edx,%eax
}
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    

0000022a <strlen>:

uint
strlen(char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 237:	eb 04                	jmp    23d <strlen+0x13>
 239:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 d0                	add    %edx,%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	75 ed                	jne    239 <strlen+0xf>
    ;
  return n;
 24c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <memset>:

void*
memset(void *dst, int c, uint n)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 257:	8b 45 10             	mov    0x10(%ebp),%eax
 25a:	89 44 24 08          	mov    %eax,0x8(%esp)
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	89 44 24 04          	mov    %eax,0x4(%esp)
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	89 04 24             	mov    %eax,(%esp)
 26b:	e8 26 ff ff ff       	call   196 <stosb>
  return dst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <strchr>:

char*
strchr(const char *s, char c)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 04             	sub    $0x4,%esp
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 281:	eb 14                	jmp    297 <strchr+0x22>
    if(*s == c)
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3a 45 fc             	cmp    -0x4(%ebp),%al
 28c:	75 05                	jne    293 <strchr+0x1e>
      return (char*)s;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	eb 13                	jmp    2a6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 293:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	84 c0                	test   %al,%al
 29f:	75 e2                	jne    283 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <gets>:

char*
gets(char *buf, int max)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b5:	eb 4c                	jmp    303 <gets+0x5b>
    cc = read(0, &c, 1);
 2b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2be:	00 
 2bf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2cd:	e8 44 01 00 00       	call   416 <read>
 2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2d9:	7f 02                	jg     2dd <gets+0x35>
      break;
 2db:	eb 31                	jmp    30e <gets+0x66>
    buf[i++] = c;
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2e6:	89 c2                	mov    %eax,%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	01 c2                	add    %eax,%edx
 2ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2f3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f7:	3c 0a                	cmp    $0xa,%al
 2f9:	74 13                	je     30e <gets+0x66>
 2fb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ff:	3c 0d                	cmp    $0xd,%al
 301:	74 0b                	je     30e <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 303:	8b 45 f4             	mov    -0xc(%ebp),%eax
 306:	83 c0 01             	add    $0x1,%eax
 309:	3b 45 0c             	cmp    0xc(%ebp),%eax
 30c:	7c a9                	jl     2b7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 30e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	01 d0                	add    %edx,%eax
 316:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <stat>:

int
stat(char *n, struct stat *st)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 32b:	00 
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 04 24             	mov    %eax,(%esp)
 332:	e8 07 01 00 00       	call   43e <open>
 337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 33a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 33e:	79 07                	jns    347 <stat+0x29>
    return -1;
 340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 345:	eb 23                	jmp    36a <stat+0x4c>
  r = fstat(fd, st);
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	89 44 24 04          	mov    %eax,0x4(%esp)
 34e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 351:	89 04 24             	mov    %eax,(%esp)
 354:	e8 fd 00 00 00       	call   456 <fstat>
 359:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35f:	89 04 24             	mov    %eax,(%esp)
 362:	e8 bf 00 00 00       	call   426 <close>
  return r;
 367:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <atoi>:

int
atoi(const char *s)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 372:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 379:	eb 25                	jmp    3a0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 37b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37e:	89 d0                	mov    %edx,%eax
 380:	c1 e0 02             	shl    $0x2,%eax
 383:	01 d0                	add    %edx,%eax
 385:	01 c0                	add    %eax,%eax
 387:	89 c1                	mov    %eax,%ecx
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	8d 50 01             	lea    0x1(%eax),%edx
 38f:	89 55 08             	mov    %edx,0x8(%ebp)
 392:	0f b6 00             	movzbl (%eax),%eax
 395:	0f be c0             	movsbl %al,%eax
 398:	01 c8                	add    %ecx,%eax
 39a:	83 e8 30             	sub    $0x30,%eax
 39d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 2f                	cmp    $0x2f,%al
 3a8:	7e 0a                	jle    3b4 <atoi+0x48>
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	0f b6 00             	movzbl (%eax),%eax
 3b0:	3c 39                	cmp    $0x39,%al
 3b2:	7e c7                	jle    37b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b7:	c9                   	leave  
 3b8:	c3                   	ret    

000003b9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3cb:	eb 17                	jmp    3e4 <memmove+0x2b>
    *dst++ = *src++;
 3cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d0:	8d 50 01             	lea    0x1(%eax),%edx
 3d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d9:	8d 4a 01             	lea    0x1(%edx),%ecx
 3dc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3df:	0f b6 12             	movzbl (%edx),%edx
 3e2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e4:	8b 45 10             	mov    0x10(%ebp),%eax
 3e7:	8d 50 ff             	lea    -0x1(%eax),%edx
 3ea:	89 55 10             	mov    %edx,0x10(%ebp)
 3ed:	85 c0                	test   %eax,%eax
 3ef:	7f dc                	jg     3cd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    

000003f6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f6:	b8 01 00 00 00       	mov    $0x1,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <exit>:
SYSCALL(exit)
 3fe:	b8 02 00 00 00       	mov    $0x2,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <wait>:
SYSCALL(wait)
 406:	b8 03 00 00 00       	mov    $0x3,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <pipe>:
SYSCALL(pipe)
 40e:	b8 04 00 00 00       	mov    $0x4,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <read>:
SYSCALL(read)
 416:	b8 05 00 00 00       	mov    $0x5,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <write>:
SYSCALL(write)
 41e:	b8 10 00 00 00       	mov    $0x10,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <close>:
SYSCALL(close)
 426:	b8 15 00 00 00       	mov    $0x15,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <kill>:
SYSCALL(kill)
 42e:	b8 06 00 00 00       	mov    $0x6,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <exec>:
SYSCALL(exec)
 436:	b8 07 00 00 00       	mov    $0x7,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <open>:
SYSCALL(open)
 43e:	b8 0f 00 00 00       	mov    $0xf,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <mknod>:
SYSCALL(mknod)
 446:	b8 11 00 00 00       	mov    $0x11,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <unlink>:
SYSCALL(unlink)
 44e:	b8 12 00 00 00       	mov    $0x12,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <fstat>:
SYSCALL(fstat)
 456:	b8 08 00 00 00       	mov    $0x8,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <link>:
SYSCALL(link)
 45e:	b8 13 00 00 00       	mov    $0x13,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <mkdir>:
SYSCALL(mkdir)
 466:	b8 14 00 00 00       	mov    $0x14,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <chdir>:
SYSCALL(chdir)
 46e:	b8 09 00 00 00       	mov    $0x9,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <dup>:
SYSCALL(dup)
 476:	b8 0a 00 00 00       	mov    $0xa,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <getpid>:
SYSCALL(getpid)
 47e:	b8 0b 00 00 00       	mov    $0xb,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <sbrk>:
SYSCALL(sbrk)
 486:	b8 0c 00 00 00       	mov    $0xc,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <sleep>:
SYSCALL(sleep)
 48e:	b8 0d 00 00 00       	mov    $0xd,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <uptime>:
SYSCALL(uptime)
 496:	b8 0e 00 00 00       	mov    $0xe,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <clone>:
SYSCALL(clone)
 49e:	b8 16 00 00 00       	mov    $0x16,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <texit>:
SYSCALL(texit)
 4a6:	b8 17 00 00 00       	mov    $0x17,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <tsleep>:
SYSCALL(tsleep)
 4ae:	b8 18 00 00 00       	mov    $0x18,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <twakeup>:
SYSCALL(twakeup)
 4b6:	b8 19 00 00 00       	mov    $0x19,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <thread_yield>:
SYSCALL(thread_yield)
 4be:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <thread_yield3>:
 4c6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	83 ec 18             	sub    $0x18,%esp
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e1:	00 
 4e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 2a ff ff ff       	call   41e <write>
}
 4f4:	c9                   	leave  
 4f5:	c3                   	ret    

000004f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	56                   	push   %esi
 4fa:	53                   	push   %ebx
 4fb:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 505:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 509:	74 17                	je     522 <printint+0x2c>
 50b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 50f:	79 11                	jns    522 <printint+0x2c>
    neg = 1;
 511:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	f7 d8                	neg    %eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 520:	eb 06                	jmp    528 <printint+0x32>
  } else {
    x = xx;
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 52f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 532:	8d 41 01             	lea    0x1(%ecx),%eax
 535:	89 45 f4             	mov    %eax,-0xc(%ebp)
 538:	8b 5d 10             	mov    0x10(%ebp),%ebx
 53b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53e:	ba 00 00 00 00       	mov    $0x0,%edx
 543:	f7 f3                	div    %ebx
 545:	89 d0                	mov    %edx,%eax
 547:	0f b6 80 d8 11 00 00 	movzbl 0x11d8(%eax),%eax
 54e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 552:	8b 75 10             	mov    0x10(%ebp),%esi
 555:	8b 45 ec             	mov    -0x14(%ebp),%eax
 558:	ba 00 00 00 00       	mov    $0x0,%edx
 55d:	f7 f6                	div    %esi
 55f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 562:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 566:	75 c7                	jne    52f <printint+0x39>
  if(neg)
 568:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56c:	74 10                	je     57e <printint+0x88>
    buf[i++] = '-';
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	8d 50 01             	lea    0x1(%eax),%edx
 574:	89 55 f4             	mov    %edx,-0xc(%ebp)
 577:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 57c:	eb 1f                	jmp    59d <printint+0xa7>
 57e:	eb 1d                	jmp    59d <printint+0xa7>
    putc(fd, buf[i]);
 580:	8d 55 dc             	lea    -0x24(%ebp),%edx
 583:	8b 45 f4             	mov    -0xc(%ebp),%eax
 586:	01 d0                	add    %edx,%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 31 ff ff ff       	call   4ce <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 59d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a5:	79 d9                	jns    580 <printint+0x8a>
    putc(fd, buf[i]);
}
 5a7:	83 c4 30             	add    $0x30,%esp
 5aa:	5b                   	pop    %ebx
 5ab:	5e                   	pop    %esi
 5ac:	5d                   	pop    %ebp
 5ad:	c3                   	ret    

000005ae <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5bb:	8d 45 0c             	lea    0xc(%ebp),%eax
 5be:	83 c0 04             	add    $0x4,%eax
 5c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5cb:	e9 7c 01 00 00       	jmp    74c <printf+0x19e>
    c = fmt[i] & 0xff;
 5d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d6:	01 d0                	add    %edx,%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	25 ff 00 00 00       	and    $0xff,%eax
 5e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ea:	75 2c                	jne    618 <printf+0x6a>
      if(c == '%'){
 5ec:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f0:	75 0c                	jne    5fe <printf+0x50>
        state = '%';
 5f2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f9:	e9 4a 01 00 00       	jmp    748 <printf+0x19a>
      } else {
        putc(fd, c);
 5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 bb fe ff ff       	call   4ce <putc>
 613:	e9 30 01 00 00       	jmp    748 <printf+0x19a>
      }
    } else if(state == '%'){
 618:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 61c:	0f 85 26 01 00 00    	jne    748 <printf+0x19a>
      if(c == 'd'){
 622:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 626:	75 2d                	jne    655 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 634:	00 
 635:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 63c:	00 
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 aa fe ff ff       	call   4f6 <printint>
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	e9 ec 00 00 00       	jmp    741 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 655:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 659:	74 06                	je     661 <printf+0xb3>
 65b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65f:	75 2d                	jne    68e <printf+0xe0>
        printint(fd, *ap, 16, 0);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 66d:	00 
 66e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 675:	00 
 676:	89 44 24 04          	mov    %eax,0x4(%esp)
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	89 04 24             	mov    %eax,(%esp)
 680:	e8 71 fe ff ff       	call   4f6 <printint>
        ap++;
 685:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 689:	e9 b3 00 00 00       	jmp    741 <printf+0x193>
      } else if(c == 's'){
 68e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 692:	75 45                	jne    6d9 <printf+0x12b>
        s = (char*)*ap;
 694:	8b 45 e8             	mov    -0x18(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 69c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a4:	75 09                	jne    6af <printf+0x101>
          s = "(null)";
 6a6:	c7 45 f4 5e 0d 00 00 	movl   $0xd5e,-0xc(%ebp)
        while(*s != 0){
 6ad:	eb 1e                	jmp    6cd <printf+0x11f>
 6af:	eb 1c                	jmp    6cd <printf+0x11f>
          putc(fd, *s);
 6b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b4:	0f b6 00             	movzbl (%eax),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 05 fe ff ff       	call   4ce <putc>
          s++;
 6c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d0:	0f b6 00             	movzbl (%eax),%eax
 6d3:	84 c0                	test   %al,%al
 6d5:	75 da                	jne    6b1 <printf+0x103>
 6d7:	eb 68                	jmp    741 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6dd:	75 1d                	jne    6fc <printf+0x14e>
        putc(fd, *ap);
 6df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	0f be c0             	movsbl %al,%eax
 6e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	89 04 24             	mov    %eax,(%esp)
 6f1:	e8 d8 fd ff ff       	call   4ce <putc>
        ap++;
 6f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fa:	eb 45                	jmp    741 <printf+0x193>
      } else if(c == '%'){
 6fc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 700:	75 17                	jne    719 <printf+0x16b>
        putc(fd, c);
 702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	89 44 24 04          	mov    %eax,0x4(%esp)
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 b7 fd ff ff       	call   4ce <putc>
 717:	eb 28                	jmp    741 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 719:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 720:	00 
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 a2 fd ff ff       	call   4ce <putc>
        putc(fd, c);
 72c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	89 44 24 04          	mov    %eax,0x4(%esp)
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 8d fd ff ff       	call   4ce <putc>
      }
      state = 0;
 741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 748:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 74c:	8b 55 0c             	mov    0xc(%ebp),%edx
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	01 d0                	add    %edx,%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	84 c0                	test   %al,%al
 759:	0f 85 71 fe ff ff    	jne    5d0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 75f:	c9                   	leave  
 760:	c3                   	ret    

00000761 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	83 e8 08             	sub    $0x8,%eax
 76d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 770:	a1 f8 11 00 00       	mov    0x11f8,%eax
 775:	89 45 fc             	mov    %eax,-0x4(%ebp)
 778:	eb 24                	jmp    79e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 782:	77 12                	ja     796 <free+0x35>
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78a:	77 24                	ja     7b0 <free+0x4f>
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 794:	77 1a                	ja     7b0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a4:	76 d4                	jbe    77a <free+0x19>
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ae:	76 ca                	jbe    77a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	01 c2                	add    %eax,%edx
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	39 c2                	cmp    %eax,%edx
 7c9:	75 24                	jne    7ef <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ce:	8b 50 04             	mov    0x4(%eax),%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	01 c2                	add    %eax,%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	89 10                	mov    %edx,(%eax)
 7ed:	eb 0a                	jmp    7f9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 10                	mov    (%eax),%edx
 7f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	01 d0                	add    %edx,%eax
 80b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80e:	75 20                	jne    830 <free+0xcf>
    p->s.size += bp->s.size;
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	01 c2                	add    %eax,%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 824:	8b 45 f8             	mov    -0x8(%ebp),%eax
 827:	8b 10                	mov    (%eax),%edx
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	89 10                	mov    %edx,(%eax)
 82e:	eb 08                	jmp    838 <free+0xd7>
  } else
    p->s.ptr = bp;
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 55 f8             	mov    -0x8(%ebp),%edx
 836:	89 10                	mov    %edx,(%eax)
  freep = p;
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	a3 f8 11 00 00       	mov    %eax,0x11f8
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <morecore>:

static Header*
morecore(uint nu)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 848:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84f:	77 07                	ja     858 <morecore+0x16>
    nu = 4096;
 851:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 858:	8b 45 08             	mov    0x8(%ebp),%eax
 85b:	c1 e0 03             	shl    $0x3,%eax
 85e:	89 04 24             	mov    %eax,(%esp)
 861:	e8 20 fc ff ff       	call   486 <sbrk>
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 869:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 86d:	75 07                	jne    876 <morecore+0x34>
    return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb 22                	jmp    898 <morecore+0x56>
  hp = (Header*)p;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	8b 55 08             	mov    0x8(%ebp),%edx
 882:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	83 c0 08             	add    $0x8,%eax
 88b:	89 04 24             	mov    %eax,(%esp)
 88e:	e8 ce fe ff ff       	call   761 <free>
  return freep;
 893:	a1 f8 11 00 00       	mov    0x11f8,%eax
}
 898:	c9                   	leave  
 899:	c3                   	ret    

0000089a <malloc>:

void*
malloc(uint nbytes)
{
 89a:	55                   	push   %ebp
 89b:	89 e5                	mov    %esp,%ebp
 89d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
 8a3:	83 c0 07             	add    $0x7,%eax
 8a6:	c1 e8 03             	shr    $0x3,%eax
 8a9:	83 c0 01             	add    $0x1,%eax
 8ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8af:	a1 f8 11 00 00       	mov    0x11f8,%eax
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8bb:	75 23                	jne    8e0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8bd:	c7 45 f0 f0 11 00 00 	movl   $0x11f0,-0x10(%ebp)
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	a3 f8 11 00 00       	mov    %eax,0x11f8
 8cc:	a1 f8 11 00 00       	mov    0x11f8,%eax
 8d1:	a3 f0 11 00 00       	mov    %eax,0x11f0
    base.s.size = 0;
 8d6:	c7 05 f4 11 00 00 00 	movl   $0x0,0x11f4
 8dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f1:	72 4d                	jb     940 <malloc+0xa6>
      if(p->s.size == nunits)
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fc:	75 0c                	jne    90a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 10                	mov    (%eax),%edx
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	89 10                	mov    %edx,(%eax)
 908:	eb 26                	jmp    930 <malloc+0x96>
      else {
        p->s.size -= nunits;
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	2b 45 ec             	sub    -0x14(%ebp),%eax
 913:	89 c2                	mov    %eax,%edx
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 40 04             	mov    0x4(%eax),%eax
 921:	c1 e0 03             	shl    $0x3,%eax
 924:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 92d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 930:	8b 45 f0             	mov    -0x10(%ebp),%eax
 933:	a3 f8 11 00 00       	mov    %eax,0x11f8
      return (void*)(p + 1);
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	83 c0 08             	add    $0x8,%eax
 93e:	eb 38                	jmp    978 <malloc+0xde>
    }
    if(p == freep)
 940:	a1 f8 11 00 00       	mov    0x11f8,%eax
 945:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 948:	75 1b                	jne    965 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 94a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 ed fe ff ff       	call   842 <morecore>
 955:	89 45 f4             	mov    %eax,-0xc(%ebp)
 958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95c:	75 07                	jne    965 <malloc+0xcb>
        return 0;
 95e:	b8 00 00 00 00       	mov    $0x0,%eax
 963:	eb 13                	jmp    978 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	8b 00                	mov    (%eax),%eax
 970:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 973:	e9 70 ff ff ff       	jmp    8e8 <malloc+0x4e>
}
 978:	c9                   	leave  
 979:	c3                   	ret    

0000097a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 980:	8b 55 08             	mov    0x8(%ebp),%edx
 983:	8b 45 0c             	mov    0xc(%ebp),%eax
 986:	8b 4d 08             	mov    0x8(%ebp),%ecx
 989:	f0 87 02             	lock xchg %eax,(%edx)
 98c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 992:	c9                   	leave  
 993:	c3                   	ret    

00000994 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 994:	55                   	push   %ebp
 995:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 997:	8b 45 08             	mov    0x8(%ebp),%eax
 99a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9a0:	5d                   	pop    %ebp
 9a1:	c3                   	ret    

000009a2 <lock_acquire>:
void lock_acquire(lock_t *lock){
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
 9a5:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9a8:	90                   	nop
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9b3:	00 
 9b4:	89 04 24             	mov    %eax,(%esp)
 9b7:	e8 be ff ff ff       	call   97a <xchg>
 9bc:	85 c0                	test   %eax,%eax
 9be:	75 e9                	jne    9a9 <lock_acquire+0x7>
}
 9c0:	c9                   	leave  
 9c1:	c3                   	ret    

000009c2 <lock_release>:
void lock_release(lock_t *lock){
 9c2:	55                   	push   %ebp
 9c3:	89 e5                	mov    %esp,%ebp
 9c5:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9c8:	8b 45 08             	mov    0x8(%ebp),%eax
 9cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9d2:	00 
 9d3:	89 04 24             	mov    %eax,(%esp)
 9d6:	e8 9f ff ff ff       	call   97a <xchg>
}
 9db:	c9                   	leave  
 9dc:	c3                   	ret    

000009dd <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 9dd:	55                   	push   %ebp
 9de:	89 e5                	mov    %esp,%ebp
 9e0:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 9e3:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 9ea:	e8 ab fe ff ff       	call   89a <malloc>
 9ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 9f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 9f8:	0f b6 05 fc 11 00 00 	movzbl 0x11fc,%eax
 9ff:	84 c0                	test   %al,%al
 a01:	75 1c                	jne    a1f <thread_create+0x42>
        init_q(thQ2);
 a03:	a1 00 12 00 00       	mov    0x1200,%eax
 a08:	89 04 24             	mov    %eax,(%esp)
 a0b:	e8 db 01 00 00       	call   beb <init_q>
        inQ++;
 a10:	0f b6 05 fc 11 00 00 	movzbl 0x11fc,%eax
 a17:	83 c0 01             	add    $0x1,%eax
 a1a:	a2 fc 11 00 00       	mov    %al,0x11fc
    }

    if((uint)stack % 4096){
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	25 ff 0f 00 00       	and    $0xfff,%eax
 a27:	85 c0                	test   %eax,%eax
 a29:	74 14                	je     a3f <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2e:	25 ff 0f 00 00       	and    $0xfff,%eax
 a33:	89 c2                	mov    %eax,%edx
 a35:	b8 00 10 00 00       	mov    $0x1000,%eax
 a3a:	29 d0                	sub    %edx,%eax
 a3c:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a43:	75 1e                	jne    a63 <thread_create+0x86>

        printf(1,"malloc fail \n");
 a45:	c7 44 24 04 65 0d 00 	movl   $0xd65,0x4(%esp)
 a4c:	00 
 a4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a54:	e8 55 fb ff ff       	call   5ae <printf>
        return 0;
 a59:	b8 00 00 00 00       	mov    $0x0,%eax
 a5e:	e9 83 00 00 00       	jmp    ae6 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a66:	8b 55 08             	mov    0x8(%ebp),%edx
 a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a70:	89 54 24 08          	mov    %edx,0x8(%esp)
 a74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a7b:	00 
 a7c:	89 04 24             	mov    %eax,(%esp)
 a7f:	e8 1a fa ff ff       	call   49e <clone>
 a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a8b:	79 1b                	jns    aa8 <thread_create+0xcb>
        printf(1,"clone fails\n");
 a8d:	c7 44 24 04 73 0d 00 	movl   $0xd73,0x4(%esp)
 a94:	00 
 a95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a9c:	e8 0d fb ff ff       	call   5ae <printf>
        return 0;
 aa1:	b8 00 00 00 00       	mov    $0x0,%eax
 aa6:	eb 3e                	jmp    ae6 <thread_create+0x109>
    }
    if(tid > 0){
 aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 aac:	7e 19                	jle    ac7 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 aae:	a1 00 12 00 00       	mov    0x1200,%eax
 ab3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ab6:	89 54 24 04          	mov    %edx,0x4(%esp)
 aba:	89 04 24             	mov    %eax,(%esp)
 abd:	e8 4b 01 00 00       	call   c0d <add_q>
        return garbage_stack;
 ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac5:	eb 1f                	jmp    ae6 <thread_create+0x109>
    }
    if(tid == 0){
 ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 acb:	75 14                	jne    ae1 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 acd:	c7 44 24 04 80 0d 00 	movl   $0xd80,0x4(%esp)
 ad4:	00 
 ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 adc:	e8 cd fa ff ff       	call   5ae <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ae6:	c9                   	leave  
 ae7:	c3                   	ret    

00000ae8 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 ae8:	55                   	push   %ebp
 ae9:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 aeb:	a1 ec 11 00 00       	mov    0x11ec,%eax
 af0:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 af6:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 afb:	a3 ec 11 00 00       	mov    %eax,0x11ec
    return (int)(rands % max);
 b00:	a1 ec 11 00 00       	mov    0x11ec,%eax
 b05:	8b 4d 08             	mov    0x8(%ebp),%ecx
 b08:	ba 00 00 00 00       	mov    $0x0,%edx
 b0d:	f7 f1                	div    %ecx
 b0f:	89 d0                	mov    %edx,%eax
}
 b11:	5d                   	pop    %ebp
 b12:	c3                   	ret    

00000b13 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 b13:	55                   	push   %ebp
 b14:	89 e5                	mov    %esp,%ebp
 b16:	83 ec 28             	sub    $0x28,%esp
    int tid2 = proc->pid;
 b19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 b1f:	8b 40 10             	mov    0x10(%eax),%eax
 b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
 b25:	a1 00 12 00 00       	mov    0x1200,%eax
 b2a:	8b 00                	mov    (%eax),%eax
 b2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b2f:	89 54 24 0c          	mov    %edx,0xc(%esp)
 b33:	89 44 24 08          	mov    %eax,0x8(%esp)
 b37:	c7 44 24 04 91 0d 00 	movl   $0xd91,0x4(%esp)
 b3e:	00 
 b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b46:	e8 63 fa ff ff       	call   5ae <printf>
    add_q(thQ2, tid2);
 b4b:	a1 00 12 00 00       	mov    0x1200,%eax
 b50:	8b 55 f0             	mov    -0x10(%ebp),%edx
 b53:	89 54 24 04          	mov    %edx,0x4(%esp)
 b57:	89 04 24             	mov    %eax,(%esp)
 b5a:	e8 ae 00 00 00       	call   c0d <add_q>
    printf(1,"thQ2 Size2 %d \n", thQ2->size);
 b5f:	a1 00 12 00 00       	mov    0x1200,%eax
 b64:	8b 00                	mov    (%eax),%eax
 b66:	89 44 24 08          	mov    %eax,0x8(%esp)
 b6a:	c7 44 24 04 a9 0d 00 	movl   $0xda9,0x4(%esp)
 b71:	00 
 b72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b79:	e8 30 fa ff ff       	call   5ae <printf>
    int tidNext = pop_q(thQ2);
 b7e:	a1 00 12 00 00       	mov    0x1200,%eax
 b83:	89 04 24             	mov    %eax,(%esp)
 b86:	e8 fc 00 00 00       	call   c87 <pop_q>
 b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tid2 == tidNext) tidNext = pop_q(thQ2);
 b8e:	eb 10                	jmp    ba0 <thread_yield2+0x8d>
 b90:	a1 00 12 00 00       	mov    0x1200,%eax
 b95:	89 04 24             	mov    %eax,(%esp)
 b98:	e8 ea 00 00 00       	call   c87 <pop_q>
 b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ba6:	74 e8                	je     b90 <thread_yield2+0x7d>
    printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
 ba8:	a1 00 12 00 00       	mov    0x1200,%eax
 bad:	8b 00                	mov    (%eax),%eax
 baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bb2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
 bba:	c7 44 24 04 b9 0d 00 	movl   $0xdb9,0x4(%esp)
 bc1:	00 
 bc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 bc9:	e8 e0 f9 ff ff       	call   5ae <printf>
    tsleep();
 bce:	e8 db f8 ff ff       	call   4ae <tsleep>
    twakeup(tidNext);
 bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd6:	89 04 24             	mov    %eax,(%esp)
 bd9:	e8 d8 f8 ff ff       	call   4b6 <twakeup>
    thread_yield3(tidNext);
 bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be1:	89 04 24             	mov    %eax,(%esp)
 be4:	e8 dd f8 ff ff       	call   4c6 <thread_yield3>
    //yield();
 be9:	c9                   	leave  
 bea:	c3                   	ret    

00000beb <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 beb:	55                   	push   %ebp
 bec:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 bee:	8b 45 08             	mov    0x8(%ebp),%eax
 bf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 bf7:	8b 45 08             	mov    0x8(%ebp),%eax
 bfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 c01:	8b 45 08             	mov    0x8(%ebp),%eax
 c04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 c0b:	5d                   	pop    %ebp
 c0c:	c3                   	ret    

00000c0d <add_q>:

void add_q(struct queue *q, int v){
 c0d:	55                   	push   %ebp
 c0e:	89 e5                	mov    %esp,%ebp
 c10:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 c13:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c1a:	e8 7b fc ff ff       	call   89a <malloc>
 c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
 c32:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 c34:	8b 45 08             	mov    0x8(%ebp),%eax
 c37:	8b 40 04             	mov    0x4(%eax),%eax
 c3a:	85 c0                	test   %eax,%eax
 c3c:	75 0b                	jne    c49 <add_q+0x3c>
        q->head = n;
 c3e:	8b 45 08             	mov    0x8(%ebp),%eax
 c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c44:	89 50 04             	mov    %edx,0x4(%eax)
 c47:	eb 0c                	jmp    c55 <add_q+0x48>
    }else{
        q->tail->next = n;
 c49:	8b 45 08             	mov    0x8(%ebp),%eax
 c4c:	8b 40 08             	mov    0x8(%eax),%eax
 c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c52:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 c55:	8b 45 08             	mov    0x8(%ebp),%eax
 c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c5b:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 c5e:	8b 45 08             	mov    0x8(%ebp),%eax
 c61:	8b 00                	mov    (%eax),%eax
 c63:	8d 50 01             	lea    0x1(%eax),%edx
 c66:	8b 45 08             	mov    0x8(%ebp),%eax
 c69:	89 10                	mov    %edx,(%eax)
}
 c6b:	c9                   	leave  
 c6c:	c3                   	ret    

00000c6d <empty_q>:

int empty_q(struct queue *q){
 c6d:	55                   	push   %ebp
 c6e:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 c70:	8b 45 08             	mov    0x8(%ebp),%eax
 c73:	8b 00                	mov    (%eax),%eax
 c75:	85 c0                	test   %eax,%eax
 c77:	75 07                	jne    c80 <empty_q+0x13>
        return 1;
 c79:	b8 01 00 00 00       	mov    $0x1,%eax
 c7e:	eb 05                	jmp    c85 <empty_q+0x18>
    else
        return 0;
 c80:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 c85:	5d                   	pop    %ebp
 c86:	c3                   	ret    

00000c87 <pop_q>:
int pop_q(struct queue *q){
 c87:	55                   	push   %ebp
 c88:	89 e5                	mov    %esp,%ebp
 c8a:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 c8d:	8b 45 08             	mov    0x8(%ebp),%eax
 c90:	89 04 24             	mov    %eax,(%esp)
 c93:	e8 d5 ff ff ff       	call   c6d <empty_q>
 c98:	85 c0                	test   %eax,%eax
 c9a:	75 5d                	jne    cf9 <pop_q+0x72>
       val = q->head->value; 
 c9c:	8b 45 08             	mov    0x8(%ebp),%eax
 c9f:	8b 40 04             	mov    0x4(%eax),%eax
 ca2:	8b 00                	mov    (%eax),%eax
 ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 ca7:	8b 45 08             	mov    0x8(%ebp),%eax
 caa:	8b 40 04             	mov    0x4(%eax),%eax
 cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 cb0:	8b 45 08             	mov    0x8(%ebp),%eax
 cb3:	8b 40 04             	mov    0x4(%eax),%eax
 cb6:	8b 50 04             	mov    0x4(%eax),%edx
 cb9:	8b 45 08             	mov    0x8(%ebp),%eax
 cbc:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc2:	89 04 24             	mov    %eax,(%esp)
 cc5:	e8 97 fa ff ff       	call   761 <free>
       q->size--;
 cca:	8b 45 08             	mov    0x8(%ebp),%eax
 ccd:	8b 00                	mov    (%eax),%eax
 ccf:	8d 50 ff             	lea    -0x1(%eax),%edx
 cd2:	8b 45 08             	mov    0x8(%ebp),%eax
 cd5:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 cd7:	8b 45 08             	mov    0x8(%ebp),%eax
 cda:	8b 00                	mov    (%eax),%eax
 cdc:	85 c0                	test   %eax,%eax
 cde:	75 14                	jne    cf4 <pop_q+0x6d>
            q->head = 0;
 ce0:	8b 45 08             	mov    0x8(%ebp),%eax
 ce3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 cea:	8b 45 08             	mov    0x8(%ebp),%eax
 ced:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf7:	eb 05                	jmp    cfe <pop_q+0x77>
    }
    return -1;
 cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 cfe:	c9                   	leave  
 cff:	c3                   	ret    
