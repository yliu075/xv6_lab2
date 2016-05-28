
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
  19:	c7 04 24 9e 00 00 00 	movl   $0x9e,(%esp)
  20:	e8 88 09 00 00       	call   9ad <thread_create>
  25:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  29:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  2e:	75 19                	jne    49 <main+0x49>
       printf(1,"wrong happen");
  30:	c7 44 24 04 ba 0b 00 	movl   $0xbba,0x4(%esp)
  37:	00 
  38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3f:	e8 3a 05 00 00       	call   57e <printf>
       exit();
  44:	e8 8d 03 00 00       	call   3d6 <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
  49:	8d 44 24 18          	lea    0x18(%esp),%eax
  4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  51:	c7 04 24 06 01 00 00 	movl   $0x106,(%esp)
  58:	e8 50 09 00 00       	call   9ad <thread_create>
  5d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  61:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  66:	75 19                	jne    81 <main+0x81>
       printf(1,"wrong happen");
  68:	c7 44 24 04 ba 0b 00 	movl   $0xbba,0x4(%esp)
  6f:	00 
  70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  77:	e8 02 05 00 00       	call   57e <printf>
       exit();
  7c:	e8 55 03 00 00       	call   3d6 <exit>
   } 
   exit();
  81:	e8 50 03 00 00       	call   3d6 <exit>

00000086 <test_func>:
}

void test_func(void *arg_ptr){
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
  8c:	a1 04 10 00 00       	mov    0x1004,%eax
  91:	83 c0 01             	add    $0x1,%eax
  94:	a3 04 10 00 00       	mov    %eax,0x1004
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
  99:	e8 e0 03 00 00       	call   47e <texit>

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
  af:	a3 04 10 00 00       	mov    %eax,0x1004
    int i = 0;
  b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
  bb:	eb 41                	jmp    fe <ping+0x60>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
  bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  cd:	c7 44 24 04 c7 0b 00 	movl   $0xbc7,0x4(%esp)
  d4:	00 
  d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dc:	e8 9d 04 00 00       	call   57e <printf>
        thread_yield();
  e1:	e8 b0 03 00 00       	call   496 <thread_yield>
        printf(1,"Pinged\n");
  e6:	c7 44 24 04 d4 0b 00 	movl   $0xbd4,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 84 04 00 00       	call   57e <printf>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
  fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  fe:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 102:	7e b9                	jle    bd <ping+0x1f>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
        thread_yield();
        printf(1,"Pinged\n");
    }
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <pong>:
void pong(void *arg_ptr){
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
 112:	8b 45 f0             	mov    -0x10(%ebp),%eax
 115:	8b 00                	mov    (%eax),%eax
 117:	a3 04 10 00 00       	mov    %eax,0x1004
    int i = 0;
 11c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
 123:	eb 41                	jmp    166 <pong+0x60>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
 125:	8b 45 f0             	mov    -0x10(%ebp),%eax
 128:	8b 00                	mov    (%eax),%eax
 12a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 12d:	89 54 24 0c          	mov    %edx,0xc(%esp)
 131:	89 44 24 08          	mov    %eax,0x8(%esp)
 135:	c7 44 24 04 dc 0b 00 	movl   $0xbdc,0x4(%esp)
 13c:	00 
 13d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 144:	e8 35 04 00 00       	call   57e <printf>
        thread_yield();
 149:	e8 48 03 00 00       	call   496 <thread_yield>
        printf(1,"Ponged\n");
 14e:	c7 44 24 04 e9 0b 00 	movl   $0xbe9,0x4(%esp)
 155:	00 
 156:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15d:	e8 1c 04 00 00       	call   57e <printf>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
 162:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 166:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 16a:	7e b9                	jle    125 <pong+0x1f>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
        thread_yield();
        printf(1,"Ponged\n");
    }
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	57                   	push   %edi
 172:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
 176:	8b 55 10             	mov    0x10(%ebp),%edx
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	89 cb                	mov    %ecx,%ebx
 17e:	89 df                	mov    %ebx,%edi
 180:	89 d1                	mov    %edx,%ecx
 182:	fc                   	cld    
 183:	f3 aa                	rep stos %al,%es:(%edi)
 185:	89 ca                	mov    %ecx,%edx
 187:	89 fb                	mov    %edi,%ebx
 189:	89 5d 08             	mov    %ebx,0x8(%ebp)
 18c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 18f:	5b                   	pop    %ebx
 190:	5f                   	pop    %edi
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 19f:	90                   	nop
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	8d 50 01             	lea    0x1(%eax),%edx
 1a6:	89 55 08             	mov    %edx,0x8(%ebp)
 1a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ac:	8d 4a 01             	lea    0x1(%edx),%ecx
 1af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1b2:	0f b6 12             	movzbl (%edx),%edx
 1b5:	88 10                	mov    %dl,(%eax)
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	84 c0                	test   %al,%al
 1bc:	75 e2                	jne    1a0 <strcpy+0xd>
    ;
  return os;
 1be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1c6:	eb 08                	jmp    1d0 <strcmp+0xd>
    p++, q++;
 1c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	74 10                	je     1ea <strcmp+0x27>
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 10             	movzbl (%eax),%edx
 1e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	38 c2                	cmp    %al,%dl
 1e8:	74 de                	je     1c8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	0f b6 d0             	movzbl %al,%edx
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	0f b6 c0             	movzbl %al,%eax
 1fc:	29 c2                	sub    %eax,%edx
 1fe:	89 d0                	mov    %edx,%eax
}
 200:	5d                   	pop    %ebp
 201:	c3                   	ret    

00000202 <strlen>:

uint
strlen(char *s)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 208:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 20f:	eb 04                	jmp    215 <strlen+0x13>
 211:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 215:	8b 55 fc             	mov    -0x4(%ebp),%edx
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	01 d0                	add    %edx,%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	84 c0                	test   %al,%al
 222:	75 ed                	jne    211 <strlen+0xf>
    ;
  return n;
 224:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <memset>:

void*
memset(void *dst, int c, uint n)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 22f:	8b 45 10             	mov    0x10(%ebp),%eax
 232:	89 44 24 08          	mov    %eax,0x8(%esp)
 236:	8b 45 0c             	mov    0xc(%ebp),%eax
 239:	89 44 24 04          	mov    %eax,0x4(%esp)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	89 04 24             	mov    %eax,(%esp)
 243:	e8 26 ff ff ff       	call   16e <stosb>
  return dst;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <strchr>:

char*
strchr(const char *s, char c)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 04             	sub    $0x4,%esp
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 259:	eb 14                	jmp    26f <strchr+0x22>
    if(*s == c)
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3a 45 fc             	cmp    -0x4(%ebp),%al
 264:	75 05                	jne    26b <strchr+0x1e>
      return (char*)s;
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	eb 13                	jmp    27e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	84 c0                	test   %al,%al
 277:	75 e2                	jne    25b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 279:	b8 00 00 00 00       	mov    $0x0,%eax
}
 27e:	c9                   	leave  
 27f:	c3                   	ret    

00000280 <gets>:

char*
gets(char *buf, int max)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 28d:	eb 4c                	jmp    2db <gets+0x5b>
    cc = read(0, &c, 1);
 28f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 296:	00 
 297:	8d 45 ef             	lea    -0x11(%ebp),%eax
 29a:	89 44 24 04          	mov    %eax,0x4(%esp)
 29e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a5:	e8 44 01 00 00       	call   3ee <read>
 2aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b1:	7f 02                	jg     2b5 <gets+0x35>
      break;
 2b3:	eb 31                	jmp    2e6 <gets+0x66>
    buf[i++] = c;
 2b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b8:	8d 50 01             	lea    0x1(%eax),%edx
 2bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2be:	89 c2                	mov    %eax,%edx
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	01 c2                	add    %eax,%edx
 2c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2cf:	3c 0a                	cmp    $0xa,%al
 2d1:	74 13                	je     2e6 <gets+0x66>
 2d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d7:	3c 0d                	cmp    $0xd,%al
 2d9:	74 0b                	je     2e6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	83 c0 01             	add    $0x1,%eax
 2e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e4:	7c a9                	jl     28f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <stat>:

int
stat(char *n, struct stat *st)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 303:	00 
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	89 04 24             	mov    %eax,(%esp)
 30a:	e8 07 01 00 00       	call   416 <open>
 30f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 316:	79 07                	jns    31f <stat+0x29>
    return -1;
 318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31d:	eb 23                	jmp    342 <stat+0x4c>
  r = fstat(fd, st);
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 44 24 04          	mov    %eax,0x4(%esp)
 326:	8b 45 f4             	mov    -0xc(%ebp),%eax
 329:	89 04 24             	mov    %eax,(%esp)
 32c:	e8 fd 00 00 00       	call   42e <fstat>
 331:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 334:	8b 45 f4             	mov    -0xc(%ebp),%eax
 337:	89 04 24             	mov    %eax,(%esp)
 33a:	e8 bf 00 00 00       	call   3fe <close>
  return r;
 33f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <atoi>:

int
atoi(const char *s)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 34a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 351:	eb 25                	jmp    378 <atoi+0x34>
    n = n*10 + *s++ - '0';
 353:	8b 55 fc             	mov    -0x4(%ebp),%edx
 356:	89 d0                	mov    %edx,%eax
 358:	c1 e0 02             	shl    $0x2,%eax
 35b:	01 d0                	add    %edx,%eax
 35d:	01 c0                	add    %eax,%eax
 35f:	89 c1                	mov    %eax,%ecx
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	8d 50 01             	lea    0x1(%eax),%edx
 367:	89 55 08             	mov    %edx,0x8(%ebp)
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	0f be c0             	movsbl %al,%eax
 370:	01 c8                	add    %ecx,%eax
 372:	83 e8 30             	sub    $0x30,%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	0f b6 00             	movzbl (%eax),%eax
 37e:	3c 2f                	cmp    $0x2f,%al
 380:	7e 0a                	jle    38c <atoi+0x48>
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	0f b6 00             	movzbl (%eax),%eax
 388:	3c 39                	cmp    $0x39,%al
 38a:	7e c7                	jle    353 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 391:	55                   	push   %ebp
 392:	89 e5                	mov    %esp,%ebp
 394:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a3:	eb 17                	jmp    3bc <memmove+0x2b>
    *dst++ = *src++;
 3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a8:	8d 50 01             	lea    0x1(%eax),%edx
 3ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b1:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3b7:	0f b6 12             	movzbl (%edx),%edx
 3ba:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3bc:	8b 45 10             	mov    0x10(%ebp),%eax
 3bf:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c2:	89 55 10             	mov    %edx,0x10(%ebp)
 3c5:	85 c0                	test   %eax,%eax
 3c7:	7f dc                	jg     3a5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ce:	b8 01 00 00 00       	mov    $0x1,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <exit>:
SYSCALL(exit)
 3d6:	b8 02 00 00 00       	mov    $0x2,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <wait>:
SYSCALL(wait)
 3de:	b8 03 00 00 00       	mov    $0x3,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <pipe>:
SYSCALL(pipe)
 3e6:	b8 04 00 00 00       	mov    $0x4,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <read>:
SYSCALL(read)
 3ee:	b8 05 00 00 00       	mov    $0x5,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <write>:
SYSCALL(write)
 3f6:	b8 10 00 00 00       	mov    $0x10,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <close>:
SYSCALL(close)
 3fe:	b8 15 00 00 00       	mov    $0x15,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <kill>:
SYSCALL(kill)
 406:	b8 06 00 00 00       	mov    $0x6,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <exec>:
SYSCALL(exec)
 40e:	b8 07 00 00 00       	mov    $0x7,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <open>:
SYSCALL(open)
 416:	b8 0f 00 00 00       	mov    $0xf,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <mknod>:
SYSCALL(mknod)
 41e:	b8 11 00 00 00       	mov    $0x11,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <unlink>:
SYSCALL(unlink)
 426:	b8 12 00 00 00       	mov    $0x12,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <fstat>:
SYSCALL(fstat)
 42e:	b8 08 00 00 00       	mov    $0x8,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <link>:
SYSCALL(link)
 436:	b8 13 00 00 00       	mov    $0x13,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <mkdir>:
SYSCALL(mkdir)
 43e:	b8 14 00 00 00       	mov    $0x14,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <chdir>:
SYSCALL(chdir)
 446:	b8 09 00 00 00       	mov    $0x9,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <dup>:
SYSCALL(dup)
 44e:	b8 0a 00 00 00       	mov    $0xa,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <getpid>:
SYSCALL(getpid)
 456:	b8 0b 00 00 00       	mov    $0xb,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <sbrk>:
SYSCALL(sbrk)
 45e:	b8 0c 00 00 00       	mov    $0xc,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <sleep>:
SYSCALL(sleep)
 466:	b8 0d 00 00 00       	mov    $0xd,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <uptime>:
SYSCALL(uptime)
 46e:	b8 0e 00 00 00       	mov    $0xe,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <clone>:
SYSCALL(clone)
 476:	b8 16 00 00 00       	mov    $0x16,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <texit>:
SYSCALL(texit)
 47e:	b8 17 00 00 00       	mov    $0x17,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <tsleep>:
SYSCALL(tsleep)
 486:	b8 18 00 00 00       	mov    $0x18,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <twakeup>:
SYSCALL(twakeup)
 48e:	b8 19 00 00 00       	mov    $0x19,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <thread_yield>:
SYSCALL(thread_yield)
 496:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	83 ec 18             	sub    $0x18,%esp
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b1:	00 
 4b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	89 04 24             	mov    %eax,(%esp)
 4bf:	e8 32 ff ff ff       	call   3f6 <write>
}
 4c4:	c9                   	leave  
 4c5:	c3                   	ret    

000004c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	56                   	push   %esi
 4ca:	53                   	push   %ebx
 4cb:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d9:	74 17                	je     4f2 <printint+0x2c>
 4db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4df:	79 11                	jns    4f2 <printint+0x2c>
    neg = 1;
 4e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4eb:	f7 d8                	neg    %eax
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f0:	eb 06                	jmp    4f8 <printint+0x32>
  } else {
    x = xx;
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 502:	8d 41 01             	lea    0x1(%ecx),%eax
 505:	89 45 f4             	mov    %eax,-0xc(%ebp)
 508:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50e:	ba 00 00 00 00       	mov    $0x0,%edx
 513:	f7 f3                	div    %ebx
 515:	89 d0                	mov    %edx,%eax
 517:	0f b6 80 08 10 00 00 	movzbl 0x1008(%eax),%eax
 51e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 522:	8b 75 10             	mov    0x10(%ebp),%esi
 525:	8b 45 ec             	mov    -0x14(%ebp),%eax
 528:	ba 00 00 00 00       	mov    $0x0,%edx
 52d:	f7 f6                	div    %esi
 52f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 532:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 536:	75 c7                	jne    4ff <printint+0x39>
  if(neg)
 538:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53c:	74 10                	je     54e <printint+0x88>
    buf[i++] = '-';
 53e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 541:	8d 50 01             	lea    0x1(%eax),%edx
 544:	89 55 f4             	mov    %edx,-0xc(%ebp)
 547:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 54c:	eb 1f                	jmp    56d <printint+0xa7>
 54e:	eb 1d                	jmp    56d <printint+0xa7>
    putc(fd, buf[i]);
 550:	8d 55 dc             	lea    -0x24(%ebp),%edx
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	01 d0                	add    %edx,%eax
 558:	0f b6 00             	movzbl (%eax),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	89 44 24 04          	mov    %eax,0x4(%esp)
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	89 04 24             	mov    %eax,(%esp)
 568:	e8 31 ff ff ff       	call   49e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 56d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 575:	79 d9                	jns    550 <printint+0x8a>
    putc(fd, buf[i]);
}
 577:	83 c4 30             	add    $0x30,%esp
 57a:	5b                   	pop    %ebx
 57b:	5e                   	pop    %esi
 57c:	5d                   	pop    %ebp
 57d:	c3                   	ret    

0000057e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 57e:	55                   	push   %ebp
 57f:	89 e5                	mov    %esp,%ebp
 581:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58b:	8d 45 0c             	lea    0xc(%ebp),%eax
 58e:	83 c0 04             	add    $0x4,%eax
 591:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59b:	e9 7c 01 00 00       	jmp    71c <printf+0x19e>
    c = fmt[i] & 0xff;
 5a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a6:	01 d0                	add    %edx,%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	25 ff 00 00 00       	and    $0xff,%eax
 5b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ba:	75 2c                	jne    5e8 <printf+0x6a>
      if(c == '%'){
 5bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c0:	75 0c                	jne    5ce <printf+0x50>
        state = '%';
 5c2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c9:	e9 4a 01 00 00       	jmp    718 <printf+0x19a>
      } else {
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	89 04 24             	mov    %eax,(%esp)
 5de:	e8 bb fe ff ff       	call   49e <putc>
 5e3:	e9 30 01 00 00       	jmp    718 <printf+0x19a>
      }
    } else if(state == '%'){
 5e8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ec:	0f 85 26 01 00 00    	jne    718 <printf+0x19a>
      if(c == 'd'){
 5f2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f6:	75 2d                	jne    625 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 604:	00 
 605:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 60c:	00 
 60d:	89 44 24 04          	mov    %eax,0x4(%esp)
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	89 04 24             	mov    %eax,(%esp)
 617:	e8 aa fe ff ff       	call   4c6 <printint>
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 620:	e9 ec 00 00 00       	jmp    711 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 625:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 629:	74 06                	je     631 <printf+0xb3>
 62b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 62f:	75 2d                	jne    65e <printf+0xe0>
        printint(fd, *ap, 16, 0);
 631:	8b 45 e8             	mov    -0x18(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 63d:	00 
 63e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 645:	00 
 646:	89 44 24 04          	mov    %eax,0x4(%esp)
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
 64d:	89 04 24             	mov    %eax,(%esp)
 650:	e8 71 fe ff ff       	call   4c6 <printint>
        ap++;
 655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 659:	e9 b3 00 00 00       	jmp    711 <printf+0x193>
      } else if(c == 's'){
 65e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 662:	75 45                	jne    6a9 <printf+0x12b>
        s = (char*)*ap;
 664:	8b 45 e8             	mov    -0x18(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 674:	75 09                	jne    67f <printf+0x101>
          s = "(null)";
 676:	c7 45 f4 f1 0b 00 00 	movl   $0xbf1,-0xc(%ebp)
        while(*s != 0){
 67d:	eb 1e                	jmp    69d <printf+0x11f>
 67f:	eb 1c                	jmp    69d <printf+0x11f>
          putc(fd, *s);
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	0f b6 00             	movzbl (%eax),%eax
 687:	0f be c0             	movsbl %al,%eax
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 05 fe ff ff       	call   49e <putc>
          s++;
 699:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a0:	0f b6 00             	movzbl (%eax),%eax
 6a3:	84 c0                	test   %al,%al
 6a5:	75 da                	jne    681 <printf+0x103>
 6a7:	eb 68                	jmp    711 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ad:	75 1d                	jne    6cc <printf+0x14e>
        putc(fd, *ap);
 6af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	89 04 24             	mov    %eax,(%esp)
 6c1:	e8 d8 fd ff ff       	call   49e <putc>
        ap++;
 6c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ca:	eb 45                	jmp    711 <printf+0x193>
      } else if(c == '%'){
 6cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d0:	75 17                	jne    6e9 <printf+0x16b>
        putc(fd, c);
 6d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d5:	0f be c0             	movsbl %al,%eax
 6d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	89 04 24             	mov    %eax,(%esp)
 6e2:	e8 b7 fd ff ff       	call   49e <putc>
 6e7:	eb 28                	jmp    711 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6f0:	00 
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 a2 fd ff ff       	call   49e <putc>
        putc(fd, c);
 6fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	89 44 24 04          	mov    %eax,0x4(%esp)
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 8d fd ff ff       	call   49e <putc>
      }
      state = 0;
 711:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 718:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	84 c0                	test   %al,%al
 729:	0f 85 71 fe ff ff    	jne    5a0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	83 e8 08             	sub    $0x8,%eax
 73d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 740:	a1 28 10 00 00       	mov    0x1028,%eax
 745:	89 45 fc             	mov    %eax,-0x4(%ebp)
 748:	eb 24                	jmp    76e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 752:	77 12                	ja     766 <free+0x35>
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75a:	77 24                	ja     780 <free+0x4f>
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 764:	77 1a                	ja     780 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 774:	76 d4                	jbe    74a <free+0x19>
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77e:	76 ca                	jbe    74a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	01 c2                	add    %eax,%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	39 c2                	cmp    %eax,%edx
 799:	75 24                	jne    7bf <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	8b 50 04             	mov    0x4(%eax),%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	01 c2                	add    %eax,%edx
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	89 10                	mov    %edx,(%eax)
 7bd:	eb 0a                	jmp    7c9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	01 d0                	add    %edx,%eax
 7db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7de:	75 20                	jne    800 <free+0xcf>
    p->s.size += bp->s.size;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 50 04             	mov    0x4(%eax),%edx
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	01 c2                	add    %eax,%edx
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f7:	8b 10                	mov    (%eax),%edx
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	89 10                	mov    %edx,(%eax)
 7fe:	eb 08                	jmp    808 <free+0xd7>
  } else
    p->s.ptr = bp;
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 55 f8             	mov    -0x8(%ebp),%edx
 806:	89 10                	mov    %edx,(%eax)
  freep = p;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	a3 28 10 00 00       	mov    %eax,0x1028
}
 810:	c9                   	leave  
 811:	c3                   	ret    

00000812 <morecore>:

static Header*
morecore(uint nu)
{
 812:	55                   	push   %ebp
 813:	89 e5                	mov    %esp,%ebp
 815:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 818:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 81f:	77 07                	ja     828 <morecore+0x16>
    nu = 4096;
 821:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 828:	8b 45 08             	mov    0x8(%ebp),%eax
 82b:	c1 e0 03             	shl    $0x3,%eax
 82e:	89 04 24             	mov    %eax,(%esp)
 831:	e8 28 fc ff ff       	call   45e <sbrk>
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 839:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83d:	75 07                	jne    846 <morecore+0x34>
    return 0;
 83f:	b8 00 00 00 00       	mov    $0x0,%eax
 844:	eb 22                	jmp    868 <morecore+0x56>
  hp = (Header*)p;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	8b 55 08             	mov    0x8(%ebp),%edx
 852:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	83 c0 08             	add    $0x8,%eax
 85b:	89 04 24             	mov    %eax,(%esp)
 85e:	e8 ce fe ff ff       	call   731 <free>
  return freep;
 863:	a1 28 10 00 00       	mov    0x1028,%eax
}
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <malloc>:

void*
malloc(uint nbytes)
{
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
 86d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	83 c0 07             	add    $0x7,%eax
 876:	c1 e8 03             	shr    $0x3,%eax
 879:	83 c0 01             	add    $0x1,%eax
 87c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 87f:	a1 28 10 00 00       	mov    0x1028,%eax
 884:	89 45 f0             	mov    %eax,-0x10(%ebp)
 887:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88b:	75 23                	jne    8b0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 88d:	c7 45 f0 20 10 00 00 	movl   $0x1020,-0x10(%ebp)
 894:	8b 45 f0             	mov    -0x10(%ebp),%eax
 897:	a3 28 10 00 00       	mov    %eax,0x1028
 89c:	a1 28 10 00 00       	mov    0x1028,%eax
 8a1:	a3 20 10 00 00       	mov    %eax,0x1020
    base.s.size = 0;
 8a6:	c7 05 24 10 00 00 00 	movl   $0x0,0x1024
 8ad:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c1:	72 4d                	jb     910 <malloc+0xa6>
      if(p->s.size == nunits)
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cc:	75 0c                	jne    8da <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	8b 10                	mov    (%eax),%edx
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	89 10                	mov    %edx,(%eax)
 8d8:	eb 26                	jmp    900 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	8b 40 04             	mov    0x4(%eax),%eax
 8e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e3:	89 c2                	mov    %eax,%edx
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	c1 e0 03             	shl    $0x3,%eax
 8f4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8fd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 900:	8b 45 f0             	mov    -0x10(%ebp),%eax
 903:	a3 28 10 00 00       	mov    %eax,0x1028
      return (void*)(p + 1);
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	83 c0 08             	add    $0x8,%eax
 90e:	eb 38                	jmp    948 <malloc+0xde>
    }
    if(p == freep)
 910:	a1 28 10 00 00       	mov    0x1028,%eax
 915:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 918:	75 1b                	jne    935 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 91a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91d:	89 04 24             	mov    %eax,(%esp)
 920:	e8 ed fe ff ff       	call   812 <morecore>
 925:	89 45 f4             	mov    %eax,-0xc(%ebp)
 928:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92c:	75 07                	jne    935 <malloc+0xcb>
        return 0;
 92e:	b8 00 00 00 00       	mov    $0x0,%eax
 933:	eb 13                	jmp    948 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 943:	e9 70 ff ff ff       	jmp    8b8 <malloc+0x4e>
}
 948:	c9                   	leave  
 949:	c3                   	ret    

0000094a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 94a:	55                   	push   %ebp
 94b:	89 e5                	mov    %esp,%ebp
 94d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 950:	8b 55 08             	mov    0x8(%ebp),%edx
 953:	8b 45 0c             	mov    0xc(%ebp),%eax
 956:	8b 4d 08             	mov    0x8(%ebp),%ecx
 959:	f0 87 02             	lock xchg %eax,(%edx)
 95c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 962:	c9                   	leave  
 963:	c3                   	ret    

00000964 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 964:	55                   	push   %ebp
 965:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 970:	5d                   	pop    %ebp
 971:	c3                   	ret    

00000972 <lock_acquire>:
void lock_acquire(lock_t *lock){
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 978:	90                   	nop
 979:	8b 45 08             	mov    0x8(%ebp),%eax
 97c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 983:	00 
 984:	89 04 24             	mov    %eax,(%esp)
 987:	e8 be ff ff ff       	call   94a <xchg>
 98c:	85 c0                	test   %eax,%eax
 98e:	75 e9                	jne    979 <lock_acquire+0x7>
}
 990:	c9                   	leave  
 991:	c3                   	ret    

00000992 <lock_release>:
void lock_release(lock_t *lock){
 992:	55                   	push   %ebp
 993:	89 e5                	mov    %esp,%ebp
 995:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 998:	8b 45 08             	mov    0x8(%ebp),%eax
 99b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9a2:	00 
 9a3:	89 04 24             	mov    %eax,(%esp)
 9a6:	e8 9f ff ff ff       	call   94a <xchg>
}
 9ab:	c9                   	leave  
 9ac:	c3                   	ret    

000009ad <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 9ad:	55                   	push   %ebp
 9ae:	89 e5                	mov    %esp,%ebp
 9b0:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 9b3:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 9ba:	e8 ab fe ff ff       	call   86a <malloc>
 9bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	25 ff 0f 00 00       	and    $0xfff,%eax
 9d0:	85 c0                	test   %eax,%eax
 9d2:	74 14                	je     9e8 <thread_create+0x3b>
        stack = stack + (4096 - (uint)stack % 4096);
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	25 ff 0f 00 00       	and    $0xfff,%eax
 9dc:	89 c2                	mov    %eax,%edx
 9de:	b8 00 10 00 00       	mov    $0x1000,%eax
 9e3:	29 d0                	sub    %edx,%eax
 9e5:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 9e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ec:	75 1b                	jne    a09 <thread_create+0x5c>

        printf(1,"malloc fail \n");
 9ee:	c7 44 24 04 f8 0b 00 	movl   $0xbf8,0x4(%esp)
 9f5:	00 
 9f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9fd:	e8 7c fb ff ff       	call   57e <printf>
        return 0;
 a02:	b8 00 00 00 00       	mov    $0x0,%eax
 a07:	eb 6f                	jmp    a78 <thread_create+0xcb>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a0c:	8b 55 08             	mov    0x8(%ebp),%edx
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a16:	89 54 24 08          	mov    %edx,0x8(%esp)
 a1a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a21:	00 
 a22:	89 04 24             	mov    %eax,(%esp)
 a25:	e8 4c fa ff ff       	call   476 <clone>
 a2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a31:	79 1b                	jns    a4e <thread_create+0xa1>
        printf(1,"clone fails\n");
 a33:	c7 44 24 04 06 0c 00 	movl   $0xc06,0x4(%esp)
 a3a:	00 
 a3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a42:	e8 37 fb ff ff       	call   57e <printf>
        return 0;
 a47:	b8 00 00 00 00       	mov    $0x0,%eax
 a4c:	eb 2a                	jmp    a78 <thread_create+0xcb>
    }
    if(tid > 0){
 a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a52:	7e 05                	jle    a59 <thread_create+0xac>
        //store threads on thread table
        return garbage_stack;
 a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a57:	eb 1f                	jmp    a78 <thread_create+0xcb>
    }
    if(tid == 0){
 a59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a5d:	75 14                	jne    a73 <thread_create+0xc6>
        printf(1,"tid = 0 return \n");
 a5f:	c7 44 24 04 13 0c 00 	movl   $0xc13,0x4(%esp)
 a66:	00 
 a67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a6e:	e8 0b fb ff ff       	call   57e <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a78:	c9                   	leave  
 a79:	c3                   	ret    

00000a7a <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 a7a:	55                   	push   %ebp
 a7b:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 a7d:	a1 1c 10 00 00       	mov    0x101c,%eax
 a82:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 a88:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 a8d:	a3 1c 10 00 00       	mov    %eax,0x101c
    return (int)(rands % max);
 a92:	a1 1c 10 00 00       	mov    0x101c,%eax
 a97:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a9a:	ba 00 00 00 00       	mov    $0x0,%edx
 a9f:	f7 f1                	div    %ecx
 aa1:	89 d0                	mov    %edx,%eax
}
 aa3:	5d                   	pop    %ebp
 aa4:	c3                   	ret    

00000aa5 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 aa5:	55                   	push   %ebp
 aa6:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 aa8:	8b 45 08             	mov    0x8(%ebp),%eax
 aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ab1:	8b 45 08             	mov    0x8(%ebp),%eax
 ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 abb:	8b 45 08             	mov    0x8(%ebp),%eax
 abe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 ac5:	5d                   	pop    %ebp
 ac6:	c3                   	ret    

00000ac7 <add_q>:

void add_q(struct queue *q, int v){
 ac7:	55                   	push   %ebp
 ac8:	89 e5                	mov    %esp,%ebp
 aca:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 acd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ad4:	e8 91 fd ff ff       	call   86a <malloc>
 ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
 aec:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 aee:	8b 45 08             	mov    0x8(%ebp),%eax
 af1:	8b 40 04             	mov    0x4(%eax),%eax
 af4:	85 c0                	test   %eax,%eax
 af6:	75 0b                	jne    b03 <add_q+0x3c>
        q->head = n;
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 afe:	89 50 04             	mov    %edx,0x4(%eax)
 b01:	eb 0c                	jmp    b0f <add_q+0x48>
    }else{
        q->tail->next = n;
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	8b 40 08             	mov    0x8(%eax),%eax
 b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b0c:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b0f:	8b 45 08             	mov    0x8(%ebp),%eax
 b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b15:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b18:	8b 45 08             	mov    0x8(%ebp),%eax
 b1b:	8b 00                	mov    (%eax),%eax
 b1d:	8d 50 01             	lea    0x1(%eax),%edx
 b20:	8b 45 08             	mov    0x8(%ebp),%eax
 b23:	89 10                	mov    %edx,(%eax)
}
 b25:	c9                   	leave  
 b26:	c3                   	ret    

00000b27 <empty_q>:

int empty_q(struct queue *q){
 b27:	55                   	push   %ebp
 b28:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b2a:	8b 45 08             	mov    0x8(%ebp),%eax
 b2d:	8b 00                	mov    (%eax),%eax
 b2f:	85 c0                	test   %eax,%eax
 b31:	75 07                	jne    b3a <empty_q+0x13>
        return 1;
 b33:	b8 01 00 00 00       	mov    $0x1,%eax
 b38:	eb 05                	jmp    b3f <empty_q+0x18>
    else
        return 0;
 b3a:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b3f:	5d                   	pop    %ebp
 b40:	c3                   	ret    

00000b41 <pop_q>:
int pop_q(struct queue *q){
 b41:	55                   	push   %ebp
 b42:	89 e5                	mov    %esp,%ebp
 b44:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b47:	8b 45 08             	mov    0x8(%ebp),%eax
 b4a:	89 04 24             	mov    %eax,(%esp)
 b4d:	e8 d5 ff ff ff       	call   b27 <empty_q>
 b52:	85 c0                	test   %eax,%eax
 b54:	75 5d                	jne    bb3 <pop_q+0x72>
       val = q->head->value; 
 b56:	8b 45 08             	mov    0x8(%ebp),%eax
 b59:	8b 40 04             	mov    0x4(%eax),%eax
 b5c:	8b 00                	mov    (%eax),%eax
 b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 b61:	8b 45 08             	mov    0x8(%ebp),%eax
 b64:	8b 40 04             	mov    0x4(%eax),%eax
 b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 b6a:	8b 45 08             	mov    0x8(%ebp),%eax
 b6d:	8b 40 04             	mov    0x4(%eax),%eax
 b70:	8b 50 04             	mov    0x4(%eax),%edx
 b73:	8b 45 08             	mov    0x8(%ebp),%eax
 b76:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7c:	89 04 24             	mov    %eax,(%esp)
 b7f:	e8 ad fb ff ff       	call   731 <free>
       q->size--;
 b84:	8b 45 08             	mov    0x8(%ebp),%eax
 b87:	8b 00                	mov    (%eax),%eax
 b89:	8d 50 ff             	lea    -0x1(%eax),%edx
 b8c:	8b 45 08             	mov    0x8(%ebp),%eax
 b8f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 b91:	8b 45 08             	mov    0x8(%ebp),%eax
 b94:	8b 00                	mov    (%eax),%eax
 b96:	85 c0                	test   %eax,%eax
 b98:	75 14                	jne    bae <pop_q+0x6d>
            q->head = 0;
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 ba4:	8b 45 08             	mov    0x8(%ebp),%eax
 ba7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb1:	eb 05                	jmp    bb8 <pop_q+0x77>
    }
    return -1;
 bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bb8:	c9                   	leave  
 bb9:	c3                   	ret    
