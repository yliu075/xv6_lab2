
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
  20:	e8 b0 09 00 00       	call   9d5 <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   printf(1,"Thread Created 1\n");
  29:	c7 44 24 04 e2 0b 00 	movl   $0xbe2,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 69 05 00 00       	call   5a6 <printf>
   if(tid <= 0){
  3d:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  42:	75 19                	jne    5d <main+0x5d>
       printf(1,"wrong happen\n");
  44:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
  4b:	00 
  4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  53:	e8 4e 05 00 00       	call   5a6 <printf>
       exit();
  58:	e8 a1 03 00 00       	call   3fe <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  5d:	8d 44 24 18          	lea    0x18(%esp),%eax
  61:	89 44 24 04          	mov    %eax,0x4(%esp)
  65:	c7 04 24 2e 01 00 00 	movl   $0x12e,(%esp)
  6c:	e8 64 09 00 00       	call   9d5 <thread_create>
  71:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   printf(1,"Thread Created 2\n");
  75:	c7 44 24 04 02 0c 00 	movl   $0xc02,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  84:	e8 1d 05 00 00       	call   5a6 <printf>
   if(tid <= 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	75 19                	jne    a9 <main+0xa9>
       printf(1,"wrong happen\n");
  90:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 02 05 00 00       	call   5a6 <printf>
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
  b4:	a1 54 10 00 00       	mov    0x1054,%eax
  b9:	83 c0 01             	add    $0x1,%eax
  bc:	a3 54 10 00 00       	mov    %eax,0x1054
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
  d7:	a3 54 10 00 00       	mov    %eax,0x1054
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
  f5:	c7 44 24 04 14 0c 00 	movl   $0xc14,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 104:	e8 9d 04 00 00       	call   5a6 <printf>
        thread_yield();
 109:	e8 b0 03 00 00       	call   4be <thread_yield>
        printf(1,"Pinged\n");
 10e:	c7 44 24 04 22 0c 00 	movl   $0xc22,0x4(%esp)
 115:	00 
 116:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 11d:	e8 84 04 00 00       	call   5a6 <printf>

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
        thread_yield();
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
 13f:	a3 54 10 00 00       	mov    %eax,0x1054
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
 15d:	c7 44 24 04 2a 0c 00 	movl   $0xc2a,0x4(%esp)
 164:	00 
 165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16c:	e8 35 04 00 00       	call   5a6 <printf>
        thread_yield();
 171:	e8 48 03 00 00       	call   4be <thread_yield>
        printf(1,"Ponged\n");
 176:	c7 44 24 04 38 0c 00 	movl   $0xc38,0x4(%esp)
 17d:	00 
 17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 185:	e8 1c 04 00 00       	call   5a6 <printf>
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
        thread_yield();
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

000004c6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	83 ec 18             	sub    $0x18,%esp
 4cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cf:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d9:	00 
 4da:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	89 04 24             	mov    %eax,(%esp)
 4e7:	e8 32 ff ff ff       	call   41e <write>
}
 4ec:	c9                   	leave  
 4ed:	c3                   	ret    

000004ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
 4f1:	56                   	push   %esi
 4f2:	53                   	push   %ebx
 4f3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 501:	74 17                	je     51a <printint+0x2c>
 503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 507:	79 11                	jns    51a <printint+0x2c>
    neg = 1;
 509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	f7 d8                	neg    %eax
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
 518:	eb 06                	jmp    520 <printint+0x32>
  } else {
    x = xx;
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 527:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 52a:	8d 41 01             	lea    0x1(%ecx),%eax
 52d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 530:	8b 5d 10             	mov    0x10(%ebp),%ebx
 533:	8b 45 ec             	mov    -0x14(%ebp),%eax
 536:	ba 00 00 00 00       	mov    $0x0,%edx
 53b:	f7 f3                	div    %ebx
 53d:	89 d0                	mov    %edx,%eax
 53f:	0f b6 80 58 10 00 00 	movzbl 0x1058(%eax),%eax
 546:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 54a:	8b 75 10             	mov    0x10(%ebp),%esi
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f6                	div    %esi
 557:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 c7                	jne    527 <printint+0x39>
  if(neg)
 560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 564:	74 10                	je     576 <printint+0x88>
    buf[i++] = '-';
 566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 569:	8d 50 01             	lea    0x1(%eax),%edx
 56c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 574:	eb 1f                	jmp    595 <printint+0xa7>
 576:	eb 1d                	jmp    595 <printint+0xa7>
    putc(fd, buf[i]);
 578:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	01 d0                	add    %edx,%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 31 ff ff ff       	call   4c6 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 595:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59d:	79 d9                	jns    578 <printint+0x8a>
    putc(fd, buf[i]);
}
 59f:	83 c4 30             	add    $0x30,%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5d                   	pop    %ebp
 5a5:	c3                   	ret    

000005a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a6:	55                   	push   %ebp
 5a7:	89 e5                	mov    %esp,%ebp
 5a9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b3:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b6:	83 c0 04             	add    $0x4,%eax
 5b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c3:	e9 7c 01 00 00       	jmp    744 <printf+0x19e>
    c = fmt[i] & 0xff;
 5c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ce:	01 d0                	add    %edx,%eax
 5d0:	0f b6 00             	movzbl (%eax),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	25 ff 00 00 00       	and    $0xff,%eax
 5db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e2:	75 2c                	jne    610 <printf+0x6a>
      if(c == '%'){
 5e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e8:	75 0c                	jne    5f6 <printf+0x50>
        state = '%';
 5ea:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f1:	e9 4a 01 00 00       	jmp    740 <printf+0x19a>
      } else {
        putc(fd, c);
 5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 bb fe ff ff       	call   4c6 <putc>
 60b:	e9 30 01 00 00       	jmp    740 <printf+0x19a>
      }
    } else if(state == '%'){
 610:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 614:	0f 85 26 01 00 00    	jne    740 <printf+0x19a>
      if(c == 'd'){
 61a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61e:	75 2d                	jne    64d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 620:	8b 45 e8             	mov    -0x18(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 62c:	00 
 62d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 634:	00 
 635:	89 44 24 04          	mov    %eax,0x4(%esp)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 aa fe ff ff       	call   4ee <printint>
        ap++;
 644:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 648:	e9 ec 00 00 00       	jmp    739 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 64d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 651:	74 06                	je     659 <printf+0xb3>
 653:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 657:	75 2d                	jne    686 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 659:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 665:	00 
 666:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 66d:	00 
 66e:	89 44 24 04          	mov    %eax,0x4(%esp)
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 71 fe ff ff       	call   4ee <printint>
        ap++;
 67d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 681:	e9 b3 00 00 00       	jmp    739 <printf+0x193>
      } else if(c == 's'){
 686:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 68a:	75 45                	jne    6d1 <printf+0x12b>
        s = (char*)*ap;
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 694:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69c:	75 09                	jne    6a7 <printf+0x101>
          s = "(null)";
 69e:	c7 45 f4 40 0c 00 00 	movl   $0xc40,-0xc(%ebp)
        while(*s != 0){
 6a5:	eb 1e                	jmp    6c5 <printf+0x11f>
 6a7:	eb 1c                	jmp    6c5 <printf+0x11f>
          putc(fd, *s);
 6a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 05 fe ff ff       	call   4c6 <putc>
          s++;
 6c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	75 da                	jne    6a9 <printf+0x103>
 6cf:	eb 68                	jmp    739 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d5:	75 1d                	jne    6f4 <printf+0x14e>
        putc(fd, *ap);
 6d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 d8 fd ff ff       	call   4c6 <putc>
        ap++;
 6ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f2:	eb 45                	jmp    739 <printf+0x193>
      } else if(c == '%'){
 6f4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f8:	75 17                	jne    711 <printf+0x16b>
        putc(fd, c);
 6fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fd:	0f be c0             	movsbl %al,%eax
 700:	89 44 24 04          	mov    %eax,0x4(%esp)
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	89 04 24             	mov    %eax,(%esp)
 70a:	e8 b7 fd ff ff       	call   4c6 <putc>
 70f:	eb 28                	jmp    739 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 711:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 718:	00 
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 a2 fd ff ff       	call   4c6 <putc>
        putc(fd, c);
 724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	89 44 24 04          	mov    %eax,0x4(%esp)
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	89 04 24             	mov    %eax,(%esp)
 734:	e8 8d fd ff ff       	call   4c6 <putc>
      }
      state = 0;
 739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 740:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 744:	8b 55 0c             	mov    0xc(%ebp),%edx
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	01 d0                	add    %edx,%eax
 74c:	0f b6 00             	movzbl (%eax),%eax
 74f:	84 c0                	test   %al,%al
 751:	0f 85 71 fe ff ff    	jne    5c8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	83 e8 08             	sub    $0x8,%eax
 765:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	a1 78 10 00 00       	mov    0x1078,%eax
 76d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 770:	eb 24                	jmp    796 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77a:	77 12                	ja     78e <free+0x35>
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 782:	77 24                	ja     7a8 <free+0x4f>
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78c:	77 1a                	ja     7a8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	89 45 fc             	mov    %eax,-0x4(%ebp)
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79c:	76 d4                	jbe    772 <free+0x19>
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a6:	76 ca                	jbe    772 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	01 c2                	add    %eax,%edx
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	39 c2                	cmp    %eax,%edx
 7c1:	75 24                	jne    7e7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	8b 50 04             	mov    0x4(%eax),%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	01 c2                	add    %eax,%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	8b 10                	mov    (%eax),%edx
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	89 10                	mov    %edx,(%eax)
 7e5:	eb 0a                	jmp    7f1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	01 d0                	add    %edx,%eax
 803:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 806:	75 20                	jne    828 <free+0xcf>
    p->s.size += bp->s.size;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 50 04             	mov    0x4(%eax),%edx
 80e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	01 c2                	add    %eax,%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 08                	jmp    830 <free+0xd7>
  } else
    p->s.ptr = bp;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82e:	89 10                	mov    %edx,(%eax)
  freep = p;
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	a3 78 10 00 00       	mov    %eax,0x1078
}
 838:	c9                   	leave  
 839:	c3                   	ret    

0000083a <morecore>:

static Header*
morecore(uint nu)
{
 83a:	55                   	push   %ebp
 83b:	89 e5                	mov    %esp,%ebp
 83d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 840:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 847:	77 07                	ja     850 <morecore+0x16>
    nu = 4096;
 849:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	c1 e0 03             	shl    $0x3,%eax
 856:	89 04 24             	mov    %eax,(%esp)
 859:	e8 28 fc ff ff       	call   486 <sbrk>
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 861:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 865:	75 07                	jne    86e <morecore+0x34>
    return 0;
 867:	b8 00 00 00 00       	mov    $0x0,%eax
 86c:	eb 22                	jmp    890 <morecore+0x56>
  hp = (Header*)p;
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	8b 55 08             	mov    0x8(%ebp),%edx
 87a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	83 c0 08             	add    $0x8,%eax
 883:	89 04 24             	mov    %eax,(%esp)
 886:	e8 ce fe ff ff       	call   759 <free>
  return freep;
 88b:	a1 78 10 00 00       	mov    0x1078,%eax
}
 890:	c9                   	leave  
 891:	c3                   	ret    

00000892 <malloc>:

void*
malloc(uint nbytes)
{
 892:	55                   	push   %ebp
 893:	89 e5                	mov    %esp,%ebp
 895:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	83 c0 07             	add    $0x7,%eax
 89e:	c1 e8 03             	shr    $0x3,%eax
 8a1:	83 c0 01             	add    $0x1,%eax
 8a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a7:	a1 78 10 00 00       	mov    0x1078,%eax
 8ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b3:	75 23                	jne    8d8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b5:	c7 45 f0 70 10 00 00 	movl   $0x1070,-0x10(%ebp)
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	a3 78 10 00 00       	mov    %eax,0x1078
 8c4:	a1 78 10 00 00       	mov    0x1078,%eax
 8c9:	a3 70 10 00 00       	mov    %eax,0x1070
    base.s.size = 0;
 8ce:	c7 05 74 10 00 00 00 	movl   $0x0,0x1074
 8d5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e9:	72 4d                	jb     938 <malloc+0xa6>
      if(p->s.size == nunits)
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f4:	75 0c                	jne    902 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	8b 10                	mov    (%eax),%edx
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	89 10                	mov    %edx,(%eax)
 900:	eb 26                	jmp    928 <malloc+0x96>
      else {
        p->s.size -= nunits;
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	2b 45 ec             	sub    -0x14(%ebp),%eax
 90b:	89 c2                	mov    %eax,%edx
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	c1 e0 03             	shl    $0x3,%eax
 91c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 55 ec             	mov    -0x14(%ebp),%edx
 925:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	a3 78 10 00 00       	mov    %eax,0x1078
      return (void*)(p + 1);
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	83 c0 08             	add    $0x8,%eax
 936:	eb 38                	jmp    970 <malloc+0xde>
    }
    if(p == freep)
 938:	a1 78 10 00 00       	mov    0x1078,%eax
 93d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 940:	75 1b                	jne    95d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 942:	8b 45 ec             	mov    -0x14(%ebp),%eax
 945:	89 04 24             	mov    %eax,(%esp)
 948:	e8 ed fe ff ff       	call   83a <morecore>
 94d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 950:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 954:	75 07                	jne    95d <malloc+0xcb>
        return 0;
 956:	b8 00 00 00 00       	mov    $0x0,%eax
 95b:	eb 13                	jmp    970 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	89 45 f0             	mov    %eax,-0x10(%ebp)
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	8b 00                	mov    (%eax),%eax
 968:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96b:	e9 70 ff ff ff       	jmp    8e0 <malloc+0x4e>
}
 970:	c9                   	leave  
 971:	c3                   	ret    

00000972 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 978:	8b 55 08             	mov    0x8(%ebp),%edx
 97b:	8b 45 0c             	mov    0xc(%ebp),%eax
 97e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 981:	f0 87 02             	lock xchg %eax,(%edx)
 984:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 987:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 98a:	c9                   	leave  
 98b:	c3                   	ret    

0000098c <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 98c:	55                   	push   %ebp
 98d:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 98f:	8b 45 08             	mov    0x8(%ebp),%eax
 992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 998:	5d                   	pop    %ebp
 999:	c3                   	ret    

0000099a <lock_acquire>:
void lock_acquire(lock_t *lock){
 99a:	55                   	push   %ebp
 99b:	89 e5                	mov    %esp,%ebp
 99d:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9a0:	90                   	nop
 9a1:	8b 45 08             	mov    0x8(%ebp),%eax
 9a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9ab:	00 
 9ac:	89 04 24             	mov    %eax,(%esp)
 9af:	e8 be ff ff ff       	call   972 <xchg>
 9b4:	85 c0                	test   %eax,%eax
 9b6:	75 e9                	jne    9a1 <lock_acquire+0x7>
}
 9b8:	c9                   	leave  
 9b9:	c3                   	ret    

000009ba <lock_release>:
void lock_release(lock_t *lock){
 9ba:	55                   	push   %ebp
 9bb:	89 e5                	mov    %esp,%ebp
 9bd:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9c0:	8b 45 08             	mov    0x8(%ebp),%eax
 9c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9ca:	00 
 9cb:	89 04 24             	mov    %eax,(%esp)
 9ce:	e8 9f ff ff ff       	call   972 <xchg>
}
 9d3:	c9                   	leave  
 9d4:	c3                   	ret    

000009d5 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 9d5:	55                   	push   %ebp
 9d6:	89 e5                	mov    %esp,%ebp
 9d8:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 9db:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 9e2:	e8 ab fe ff ff       	call   892 <malloc>
 9e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 9f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f3:	25 ff 0f 00 00       	and    $0xfff,%eax
 9f8:	85 c0                	test   %eax,%eax
 9fa:	74 14                	je     a10 <thread_create+0x3b>
        stack = stack + (4096 - (uint)stack % 4096);
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	25 ff 0f 00 00       	and    $0xfff,%eax
 a04:	89 c2                	mov    %eax,%edx
 a06:	b8 00 10 00 00       	mov    $0x1000,%eax
 a0b:	29 d0                	sub    %edx,%eax
 a0d:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a14:	75 1b                	jne    a31 <thread_create+0x5c>

        printf(1,"malloc fail \n");
 a16:	c7 44 24 04 47 0c 00 	movl   $0xc47,0x4(%esp)
 a1d:	00 
 a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a25:	e8 7c fb ff ff       	call   5a6 <printf>
        return 0;
 a2a:	b8 00 00 00 00       	mov    $0x0,%eax
 a2f:	eb 6f                	jmp    aa0 <thread_create+0xcb>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a34:	8b 55 08             	mov    0x8(%ebp),%edx
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a3e:	89 54 24 08          	mov    %edx,0x8(%esp)
 a42:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a49:	00 
 a4a:	89 04 24             	mov    %eax,(%esp)
 a4d:	e8 4c fa ff ff       	call   49e <clone>
 a52:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a59:	79 1b                	jns    a76 <thread_create+0xa1>
        printf(1,"clone fails\n");
 a5b:	c7 44 24 04 55 0c 00 	movl   $0xc55,0x4(%esp)
 a62:	00 
 a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a6a:	e8 37 fb ff ff       	call   5a6 <printf>
        return 0;
 a6f:	b8 00 00 00 00       	mov    $0x0,%eax
 a74:	eb 2a                	jmp    aa0 <thread_create+0xcb>
    }
    if(tid > 0){
 a76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a7a:	7e 05                	jle    a81 <thread_create+0xac>
        //store threads on thread table
        return garbage_stack;
 a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7f:	eb 1f                	jmp    aa0 <thread_create+0xcb>
    }
    if(tid == 0){
 a81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a85:	75 14                	jne    a9b <thread_create+0xc6>
        printf(1,"tid = 0 return \n");
 a87:	c7 44 24 04 62 0c 00 	movl   $0xc62,0x4(%esp)
 a8e:	00 
 a8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a96:	e8 0b fb ff ff       	call   5a6 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 aa0:	c9                   	leave  
 aa1:	c3                   	ret    

00000aa2 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 aa2:	55                   	push   %ebp
 aa3:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 aa5:	a1 6c 10 00 00       	mov    0x106c,%eax
 aaa:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 ab0:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 ab5:	a3 6c 10 00 00       	mov    %eax,0x106c
    return (int)(rands % max);
 aba:	a1 6c 10 00 00       	mov    0x106c,%eax
 abf:	8b 4d 08             	mov    0x8(%ebp),%ecx
 ac2:	ba 00 00 00 00       	mov    $0x0,%edx
 ac7:	f7 f1                	div    %ecx
 ac9:	89 d0                	mov    %edx,%eax
}
 acb:	5d                   	pop    %ebp
 acc:	c3                   	ret    

00000acd <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 acd:	55                   	push   %ebp
 ace:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 ad0:	8b 45 08             	mov    0x8(%ebp),%eax
 ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ad9:	8b 45 08             	mov    0x8(%ebp),%eax
 adc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 ae3:	8b 45 08             	mov    0x8(%ebp),%eax
 ae6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 aed:	5d                   	pop    %ebp
 aee:	c3                   	ret    

00000aef <add_q>:

void add_q(struct queue *q, int v){
 aef:	55                   	push   %ebp
 af0:	89 e5                	mov    %esp,%ebp
 af2:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 af5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 afc:	e8 91 fd ff ff       	call   892 <malloc>
 b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b11:	8b 55 0c             	mov    0xc(%ebp),%edx
 b14:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b16:	8b 45 08             	mov    0x8(%ebp),%eax
 b19:	8b 40 04             	mov    0x4(%eax),%eax
 b1c:	85 c0                	test   %eax,%eax
 b1e:	75 0b                	jne    b2b <add_q+0x3c>
        q->head = n;
 b20:	8b 45 08             	mov    0x8(%ebp),%eax
 b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b26:	89 50 04             	mov    %edx,0x4(%eax)
 b29:	eb 0c                	jmp    b37 <add_q+0x48>
    }else{
        q->tail->next = n;
 b2b:	8b 45 08             	mov    0x8(%ebp),%eax
 b2e:	8b 40 08             	mov    0x8(%eax),%eax
 b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b34:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b37:	8b 45 08             	mov    0x8(%ebp),%eax
 b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b3d:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b40:	8b 45 08             	mov    0x8(%ebp),%eax
 b43:	8b 00                	mov    (%eax),%eax
 b45:	8d 50 01             	lea    0x1(%eax),%edx
 b48:	8b 45 08             	mov    0x8(%ebp),%eax
 b4b:	89 10                	mov    %edx,(%eax)
}
 b4d:	c9                   	leave  
 b4e:	c3                   	ret    

00000b4f <empty_q>:

int empty_q(struct queue *q){
 b4f:	55                   	push   %ebp
 b50:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b52:	8b 45 08             	mov    0x8(%ebp),%eax
 b55:	8b 00                	mov    (%eax),%eax
 b57:	85 c0                	test   %eax,%eax
 b59:	75 07                	jne    b62 <empty_q+0x13>
        return 1;
 b5b:	b8 01 00 00 00       	mov    $0x1,%eax
 b60:	eb 05                	jmp    b67 <empty_q+0x18>
    else
        return 0;
 b62:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b67:	5d                   	pop    %ebp
 b68:	c3                   	ret    

00000b69 <pop_q>:
int pop_q(struct queue *q){
 b69:	55                   	push   %ebp
 b6a:	89 e5                	mov    %esp,%ebp
 b6c:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b6f:	8b 45 08             	mov    0x8(%ebp),%eax
 b72:	89 04 24             	mov    %eax,(%esp)
 b75:	e8 d5 ff ff ff       	call   b4f <empty_q>
 b7a:	85 c0                	test   %eax,%eax
 b7c:	75 5d                	jne    bdb <pop_q+0x72>
       val = q->head->value; 
 b7e:	8b 45 08             	mov    0x8(%ebp),%eax
 b81:	8b 40 04             	mov    0x4(%eax),%eax
 b84:	8b 00                	mov    (%eax),%eax
 b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b89:	8b 45 08             	mov    0x8(%ebp),%eax
 b8c:	8b 40 04             	mov    0x4(%eax),%eax
 b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b92:	8b 45 08             	mov    0x8(%ebp),%eax
 b95:	8b 40 04             	mov    0x4(%eax),%eax
 b98:	8b 50 04             	mov    0x4(%eax),%edx
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba4:	89 04 24             	mov    %eax,(%esp)
 ba7:	e8 ad fb ff ff       	call   759 <free>
       q->size--;
 bac:	8b 45 08             	mov    0x8(%ebp),%eax
 baf:	8b 00                	mov    (%eax),%eax
 bb1:	8d 50 ff             	lea    -0x1(%eax),%edx
 bb4:	8b 45 08             	mov    0x8(%ebp),%eax
 bb7:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 bb9:	8b 45 08             	mov    0x8(%ebp),%eax
 bbc:	8b 00                	mov    (%eax),%eax
 bbe:	85 c0                	test   %eax,%eax
 bc0:	75 14                	jne    bd6 <pop_q+0x6d>
            q->head = 0;
 bc2:	8b 45 08             	mov    0x8(%ebp),%eax
 bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bcc:	8b 45 08             	mov    0x8(%ebp),%eax
 bcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd9:	eb 05                	jmp    be0 <pop_q+0x77>
    }
    return -1;
 bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 be0:	c9                   	leave  
 be1:	c3                   	ret    
