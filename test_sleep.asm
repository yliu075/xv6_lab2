
_test_sleep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    int total;
}ttable;

void func(void *arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    struct thread * t;
    int i;
    printf(1,"init ttable\n");
   9:	c7 44 24 04 a0 0c 00 	movl   $0xca0,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 df 05 00 00       	call   5fc <printf>
    lock_init(&ttable.lock);
  1d:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
  24:	e8 b9 09 00 00       	call   9e2 <lock_init>
    ttable.total = 0;
  29:	c7 05 84 12 00 00 00 	movl   $0x0,0x1284
  30:	00 00 00 

    lock_acquire(&ttable.lock);
  33:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
  3a:	e8 b1 09 00 00       	call   9f0 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  3f:	c7 44 24 1c 84 11 00 	movl   $0x1184,0x1c(%esp)
  46:	00 
  47:	eb 0f                	jmp    58 <main+0x58>
        t->tid = 0;
  49:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    printf(1,"init ttable\n");
    lock_init(&ttable.lock);
    ttable.total = 0;

    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  53:	83 44 24 1c 04       	addl   $0x4,0x1c(%esp)
  58:	81 7c 24 1c 84 12 00 	cmpl   $0x1284,0x1c(%esp)
  5f:	00 
  60:	72 e7                	jb     49 <main+0x49>
        t->tid = 0;
    }
    lock_release(&ttable.lock);
  62:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
  69:	e8 a2 09 00 00       	call   a10 <lock_release>
    printf(1,"testing thread sleep and wakeup \n\n\n");
  6e:	c7 44 24 04 b0 0c 00 	movl   $0xcb0,0x4(%esp)
  75:	00 
  76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7d:	e8 7a 05 00 00       	call   5fc <printf>
    void *stack = thread_create(func,0);
  82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  89:	00 
  8a:	c7 04 24 69 01 00 00 	movl   $0x169,(%esp)
  91:	e8 95 09 00 00       	call   a2b <thread_create>
  96:	89 44 24 14          	mov    %eax,0x14(%esp)
    thread_create(func,0);
  9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a1:	00 
  a2:	c7 04 24 69 01 00 00 	movl   $0x169,(%esp)
  a9:	e8 7d 09 00 00       	call   a2b <thread_create>
    thread_create(func,0);
  ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b5:	00 
  b6:	c7 04 24 69 01 00 00 	movl   $0x169,(%esp)
  bd:	e8 69 09 00 00       	call   a2b <thread_create>

    i=0;
  c2:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  c9:	00 
    while(i++ < 1000000);
  ca:	90                   	nop
  cb:	8b 44 24 18          	mov    0x18(%esp),%eax
  cf:	8d 50 01             	lea    0x1(%eax),%edx
  d2:	89 54 24 18          	mov    %edx,0x18(%esp)
  d6:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  db:	7e ee                	jle    cb <main+0xcb>
    //find that thread
    lock_acquire(&ttable.lock);
  dd:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
  e4:	e8 07 09 00 00       	call   9f0 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  e9:	c7 44 24 1c 84 11 00 	movl   $0x1184,0x1c(%esp)
  f0:	00 
  f1:	eb 40                	jmp    133 <main+0x133>
        if(t->tid != 0){
  f3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  f7:	8b 00                	mov    (%eax),%eax
  f9:	85 c0                	test   %eax,%eax
  fb:	74 31                	je     12e <main+0x12e>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
  fd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 101:	8b 00                	mov    (%eax),%eax
 103:	89 44 24 08          	mov    %eax,0x8(%esp)
 107:	c7 44 24 04 d4 0c 00 	movl   $0xcd4,0x4(%esp)
 10e:	00 
 10f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 116:	e8 e1 04 00 00       	call   5fc <printf>
            twakeup(t->tid);
 11b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 11f:	8b 00                	mov    (%eax),%eax
 121:	89 04 24             	mov    %eax,(%esp)
 124:	e8 db 03 00 00       	call   504 <twakeup>
            i++;
 129:	83 44 24 18 01       	addl   $0x1,0x18(%esp)

    i=0;
    while(i++ < 1000000);
    //find that thread
    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
 12e:	83 44 24 1c 04       	addl   $0x4,0x1c(%esp)
 133:	81 7c 24 1c 84 12 00 	cmpl   $0x1284,0x1c(%esp)
 13a:	00 
 13b:	72 b6                	jb     f3 <main+0xf3>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
            twakeup(t->tid);
            i++;
        }
    }
    lock_release(&ttable.lock);
 13d:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
 144:	e8 c7 08 00 00       	call   a10 <lock_release>
    wait();
 149:	e8 06 03 00 00       	call   454 <wait>
    wait();
 14e:	e8 01 03 00 00       	call   454 <wait>
    wait();
 153:	e8 fc 02 00 00       	call   454 <wait>
    free(stack);
 158:	8b 44 24 14          	mov    0x14(%esp),%eax
 15c:	89 04 24             	mov    %eax,(%esp)
 15f:	e8 4b 06 00 00       	call   7af <free>
    exit();
 164:	e8 e3 02 00 00       	call   44c <exit>

00000169 <func>:
}

void func(void *arg_ptr){
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    tid = getpid();
 16f:	e8 58 03 00 00       	call   4cc <getpid>
 174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_acquire(&ttable.lock);
 177:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
 17e:	e8 6d 08 00 00       	call   9f0 <lock_acquire>
    (ttable.threads[ttable.total]).tid = tid;
 183:	a1 84 12 00 00       	mov    0x1284,%eax
 188:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18b:	89 14 85 84 11 00 00 	mov    %edx,0x1184(,%eax,4)
    ttable.total++;
 192:	a1 84 12 00 00       	mov    0x1284,%eax
 197:	83 c0 01             	add    $0x1,%eax
 19a:	a3 84 12 00 00       	mov    %eax,0x1284
    lock_release(&ttable.lock);
 19f:	c7 04 24 80 11 00 00 	movl   $0x1180,(%esp)
 1a6:	e8 65 08 00 00       	call   a10 <lock_release>

    printf(1,"I am thread %d, is about to sleep\n",tid);
 1ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b2:	c7 44 24 04 00 0d 00 	movl   $0xd00,0x4(%esp)
 1b9:	00 
 1ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c1:	e8 36 04 00 00       	call   5fc <printf>
    tsleep();
 1c6:	e8 31 03 00 00       	call   4fc <tsleep>
    printf(1,"I am wake up!\n");
 1cb:	c7 44 24 04 23 0d 00 	movl   $0xd23,0x4(%esp)
 1d2:	00 
 1d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1da:	e8 1d 04 00 00       	call   5fc <printf>
    texit();
 1df:	e8 10 03 00 00       	call   4f4 <texit>

000001e4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ec:	8b 55 10             	mov    0x10(%ebp),%edx
 1ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f2:	89 cb                	mov    %ecx,%ebx
 1f4:	89 df                	mov    %ebx,%edi
 1f6:	89 d1                	mov    %edx,%ecx
 1f8:	fc                   	cld    
 1f9:	f3 aa                	rep stos %al,%es:(%edi)
 1fb:	89 ca                	mov    %ecx,%edx
 1fd:	89 fb                	mov    %edi,%ebx
 1ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
 202:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 205:	5b                   	pop    %ebx
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 215:	90                   	nop
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	8b 55 0c             	mov    0xc(%ebp),%edx
 222:	8d 4a 01             	lea    0x1(%edx),%ecx
 225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 228:	0f b6 12             	movzbl (%edx),%edx
 22b:	88 10                	mov    %dl,(%eax)
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	84 c0                	test   %al,%al
 232:	75 e2                	jne    216 <strcpy+0xd>
    ;
  return os;
 234:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 23c:	eb 08                	jmp    246 <strcmp+0xd>
    p++, q++;
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	84 c0                	test   %al,%al
 24e:	74 10                	je     260 <strcmp+0x27>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 10             	movzbl (%eax),%edx
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	38 c2                	cmp    %al,%dl
 25e:	74 de                	je     23e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f b6 d0             	movzbl %al,%edx
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	0f b6 c0             	movzbl %al,%eax
 272:	29 c2                	sub    %eax,%edx
 274:	89 d0                	mov    %edx,%eax
}
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    

00000278 <strlen>:

uint
strlen(char *s)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 285:	eb 04                	jmp    28b <strlen+0x13>
 287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 d0                	add    %edx,%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	84 c0                	test   %al,%al
 298:	75 ed                	jne    287 <strlen+0xf>
    ;
  return n;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <memset>:

void*
memset(void *dst, int c, uint n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a5:	8b 45 10             	mov    0x10(%ebp),%eax
 2a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 26 ff ff ff       	call   1e4 <stosb>
  return dst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <strchr>:

char*
strchr(const char *s, char c)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 04             	sub    $0x4,%esp
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2cf:	eb 14                	jmp    2e5 <strchr+0x22>
    if(*s == c)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2da:	75 05                	jne    2e1 <strchr+0x1e>
      return (char*)s;
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	eb 13                	jmp    2f4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	84 c0                	test   %al,%al
 2ed:	75 e2                	jne    2d1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <gets>:

char*
gets(char *buf, int max)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 303:	eb 4c                	jmp    351 <gets+0x5b>
    cc = read(0, &c, 1);
 305:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 30c:	00 
 30d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 31b:	e8 44 01 00 00       	call   464 <read>
 320:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 327:	7f 02                	jg     32b <gets+0x35>
      break;
 329:	eb 31                	jmp    35c <gets+0x66>
    buf[i++] = c;
 32b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 f4             	mov    %edx,-0xc(%ebp)
 334:	89 c2                	mov    %eax,%edx
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	01 c2                	add    %eax,%edx
 33b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 345:	3c 0a                	cmp    $0xa,%al
 347:	74 13                	je     35c <gets+0x66>
 349:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34d:	3c 0d                	cmp    $0xd,%al
 34f:	74 0b                	je     35c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	83 c0 01             	add    $0x1,%eax
 357:	3b 45 0c             	cmp    0xc(%ebp),%eax
 35a:	7c a9                	jl     305 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 35c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	01 d0                	add    %edx,%eax
 364:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <stat>:

int
stat(char *n, struct stat *st)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 379:	00 
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 07 01 00 00       	call   48c <open>
 385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 38c:	79 07                	jns    395 <stat+0x29>
    return -1;
 38e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 393:	eb 23                	jmp    3b8 <stat+0x4c>
  r = fstat(fd, st);
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 44 24 04          	mov    %eax,0x4(%esp)
 39c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39f:	89 04 24             	mov    %eax,(%esp)
 3a2:	e8 fd 00 00 00       	call   4a4 <fstat>
 3a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ad:	89 04 24             	mov    %eax,(%esp)
 3b0:	e8 bf 00 00 00       	call   474 <close>
  return r;
 3b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <atoi>:

int
atoi(const char *s)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c7:	eb 25                	jmp    3ee <atoi+0x34>
    n = n*10 + *s++ - '0';
 3c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cc:	89 d0                	mov    %edx,%eax
 3ce:	c1 e0 02             	shl    $0x2,%eax
 3d1:	01 d0                	add    %edx,%eax
 3d3:	01 c0                	add    %eax,%eax
 3d5:	89 c1                	mov    %eax,%ecx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 08             	mov    %edx,0x8(%ebp)
 3e0:	0f b6 00             	movzbl (%eax),%eax
 3e3:	0f be c0             	movsbl %al,%eax
 3e6:	01 c8                	add    %ecx,%eax
 3e8:	83 e8 30             	sub    $0x30,%eax
 3eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	3c 2f                	cmp    $0x2f,%al
 3f6:	7e 0a                	jle    402 <atoi+0x48>
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	3c 39                	cmp    $0x39,%al
 400:	7e c7                	jle    3c9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 402:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 405:	c9                   	leave  
 406:	c3                   	ret    

00000407 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 407:	55                   	push   %ebp
 408:	89 e5                	mov    %esp,%ebp
 40a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 419:	eb 17                	jmp    432 <memmove+0x2b>
    *dst++ = *src++;
 41b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41e:	8d 50 01             	lea    0x1(%eax),%edx
 421:	89 55 fc             	mov    %edx,-0x4(%ebp)
 424:	8b 55 f8             	mov    -0x8(%ebp),%edx
 427:	8d 4a 01             	lea    0x1(%edx),%ecx
 42a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 42d:	0f b6 12             	movzbl (%edx),%edx
 430:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 432:	8b 45 10             	mov    0x10(%ebp),%eax
 435:	8d 50 ff             	lea    -0x1(%eax),%edx
 438:	89 55 10             	mov    %edx,0x10(%ebp)
 43b:	85 c0                	test   %eax,%eax
 43d:	7f dc                	jg     41b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 444:	b8 01 00 00 00       	mov    $0x1,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exit>:
SYSCALL(exit)
 44c:	b8 02 00 00 00       	mov    $0x2,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <wait>:
SYSCALL(wait)
 454:	b8 03 00 00 00       	mov    $0x3,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <pipe>:
SYSCALL(pipe)
 45c:	b8 04 00 00 00       	mov    $0x4,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <read>:
SYSCALL(read)
 464:	b8 05 00 00 00       	mov    $0x5,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <write>:
SYSCALL(write)
 46c:	b8 10 00 00 00       	mov    $0x10,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <close>:
SYSCALL(close)
 474:	b8 15 00 00 00       	mov    $0x15,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <kill>:
SYSCALL(kill)
 47c:	b8 06 00 00 00       	mov    $0x6,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <exec>:
SYSCALL(exec)
 484:	b8 07 00 00 00       	mov    $0x7,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <open>:
SYSCALL(open)
 48c:	b8 0f 00 00 00       	mov    $0xf,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <mknod>:
SYSCALL(mknod)
 494:	b8 11 00 00 00       	mov    $0x11,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <unlink>:
SYSCALL(unlink)
 49c:	b8 12 00 00 00       	mov    $0x12,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <fstat>:
SYSCALL(fstat)
 4a4:	b8 08 00 00 00       	mov    $0x8,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <link>:
SYSCALL(link)
 4ac:	b8 13 00 00 00       	mov    $0x13,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <mkdir>:
SYSCALL(mkdir)
 4b4:	b8 14 00 00 00       	mov    $0x14,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <chdir>:
SYSCALL(chdir)
 4bc:	b8 09 00 00 00       	mov    $0x9,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <dup>:
SYSCALL(dup)
 4c4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <getpid>:
SYSCALL(getpid)
 4cc:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sbrk>:
SYSCALL(sbrk)
 4d4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sleep>:
SYSCALL(sleep)
 4dc:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <uptime>:
SYSCALL(uptime)
 4e4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <clone>:
SYSCALL(clone)
 4ec:	b8 16 00 00 00       	mov    $0x16,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <texit>:
SYSCALL(texit)
 4f4:	b8 17 00 00 00       	mov    $0x17,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <tsleep>:
SYSCALL(tsleep)
 4fc:	b8 18 00 00 00       	mov    $0x18,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <twakeup>:
SYSCALL(twakeup)
 504:	b8 19 00 00 00       	mov    $0x19,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <thread_yield>:
SYSCALL(thread_yield)
 50c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <thread_yield3>:
 514:	b8 1a 00 00 00       	mov    $0x1a,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 18             	sub    $0x18,%esp
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 528:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52f:	00 
 530:	8d 45 f4             	lea    -0xc(%ebp),%eax
 533:	89 44 24 04          	mov    %eax,0x4(%esp)
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	89 04 24             	mov    %eax,(%esp)
 53d:	e8 2a ff ff ff       	call   46c <write>
}
 542:	c9                   	leave  
 543:	c3                   	ret    

00000544 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	56                   	push   %esi
 548:	53                   	push   %ebx
 549:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 54c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 553:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 557:	74 17                	je     570 <printint+0x2c>
 559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 55d:	79 11                	jns    570 <printint+0x2c>
    neg = 1;
 55f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 566:	8b 45 0c             	mov    0xc(%ebp),%eax
 569:	f7 d8                	neg    %eax
 56b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56e:	eb 06                	jmp    576 <printint+0x32>
  } else {
    x = xx;
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
 573:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 57d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 580:	8d 41 01             	lea    0x1(%ecx),%eax
 583:	89 45 f4             	mov    %eax,-0xc(%ebp)
 586:	8b 5d 10             	mov    0x10(%ebp),%ebx
 589:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58c:	ba 00 00 00 00       	mov    $0x0,%edx
 591:	f7 f3                	div    %ebx
 593:	89 d0                	mov    %edx,%eax
 595:	0f b6 80 34 11 00 00 	movzbl 0x1134(%eax),%eax
 59c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5a0:	8b 75 10             	mov    0x10(%ebp),%esi
 5a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a6:	ba 00 00 00 00       	mov    $0x0,%edx
 5ab:	f7 f6                	div    %esi
 5ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b4:	75 c7                	jne    57d <printint+0x39>
  if(neg)
 5b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ba:	74 10                	je     5cc <printint+0x88>
    buf[i++] = '-';
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	8d 50 01             	lea    0x1(%eax),%edx
 5c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5c5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5ca:	eb 1f                	jmp    5eb <printint+0xa7>
 5cc:	eb 1d                	jmp    5eb <printint+0xa7>
    putc(fd, buf[i]);
 5ce:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	01 d0                	add    %edx,%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e0:	8b 45 08             	mov    0x8(%ebp),%eax
 5e3:	89 04 24             	mov    %eax,(%esp)
 5e6:	e8 31 ff ff ff       	call   51c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5eb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f3:	79 d9                	jns    5ce <printint+0x8a>
    putc(fd, buf[i]);
}
 5f5:	83 c4 30             	add    $0x30,%esp
 5f8:	5b                   	pop    %ebx
 5f9:	5e                   	pop    %esi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    

000005fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 602:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 609:	8d 45 0c             	lea    0xc(%ebp),%eax
 60c:	83 c0 04             	add    $0x4,%eax
 60f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 612:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 619:	e9 7c 01 00 00       	jmp    79a <printf+0x19e>
    c = fmt[i] & 0xff;
 61e:	8b 55 0c             	mov    0xc(%ebp),%edx
 621:	8b 45 f0             	mov    -0x10(%ebp),%eax
 624:	01 d0                	add    %edx,%eax
 626:	0f b6 00             	movzbl (%eax),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	25 ff 00 00 00       	and    $0xff,%eax
 631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 634:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 638:	75 2c                	jne    666 <printf+0x6a>
      if(c == '%'){
 63a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63e:	75 0c                	jne    64c <printf+0x50>
        state = '%';
 640:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 647:	e9 4a 01 00 00       	jmp    796 <printf+0x19a>
      } else {
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 bb fe ff ff       	call   51c <putc>
 661:	e9 30 01 00 00       	jmp    796 <printf+0x19a>
      }
    } else if(state == '%'){
 666:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 66a:	0f 85 26 01 00 00    	jne    796 <printf+0x19a>
      if(c == 'd'){
 670:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 674:	75 2d                	jne    6a3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 676:	8b 45 e8             	mov    -0x18(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 682:	00 
 683:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 68a:	00 
 68b:	89 44 24 04          	mov    %eax,0x4(%esp)
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 aa fe ff ff       	call   544 <printint>
        ap++;
 69a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69e:	e9 ec 00 00 00       	jmp    78f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a7:	74 06                	je     6af <printf+0xb3>
 6a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ad:	75 2d                	jne    6dc <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6bb:	00 
 6bc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6c3:	00 
 6c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
 6cb:	89 04 24             	mov    %eax,(%esp)
 6ce:	e8 71 fe ff ff       	call   544 <printint>
        ap++;
 6d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d7:	e9 b3 00 00 00       	jmp    78f <printf+0x193>
      } else if(c == 's'){
 6dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e0:	75 45                	jne    727 <printf+0x12b>
        s = (char*)*ap;
 6e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f2:	75 09                	jne    6fd <printf+0x101>
          s = "(null)";
 6f4:	c7 45 f4 32 0d 00 00 	movl   $0xd32,-0xc(%ebp)
        while(*s != 0){
 6fb:	eb 1e                	jmp    71b <printf+0x11f>
 6fd:	eb 1c                	jmp    71b <printf+0x11f>
          putc(fd, *s);
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	0f b6 00             	movzbl (%eax),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	89 44 24 04          	mov    %eax,0x4(%esp)
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 05 fe ff ff       	call   51c <putc>
          s++;
 717:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	0f b6 00             	movzbl (%eax),%eax
 721:	84 c0                	test   %al,%al
 723:	75 da                	jne    6ff <printf+0x103>
 725:	eb 68                	jmp    78f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 727:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72b:	75 1d                	jne    74a <printf+0x14e>
        putc(fd, *ap);
 72d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	0f be c0             	movsbl %al,%eax
 735:	89 44 24 04          	mov    %eax,0x4(%esp)
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 d8 fd ff ff       	call   51c <putc>
        ap++;
 744:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 748:	eb 45                	jmp    78f <printf+0x193>
      } else if(c == '%'){
 74a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74e:	75 17                	jne    767 <printf+0x16b>
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 b7 fd ff ff       	call   51c <putc>
 765:	eb 28                	jmp    78f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 767:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 76e:	00 
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 a2 fd ff ff       	call   51c <putc>
        putc(fd, c);
 77a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77d:	0f be c0             	movsbl %al,%eax
 780:	89 44 24 04          	mov    %eax,0x4(%esp)
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 8d fd ff ff       	call   51c <putc>
      }
      state = 0;
 78f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 796:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 79a:	8b 55 0c             	mov    0xc(%ebp),%edx
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	01 d0                	add    %edx,%eax
 7a2:	0f b6 00             	movzbl (%eax),%eax
 7a5:	84 c0                	test   %al,%al
 7a7:	0f 85 71 fe ff ff    	jne    61e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	83 e8 08             	sub    $0x8,%eax
 7bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	a1 68 11 00 00       	mov    0x1168,%eax
 7c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c6:	eb 24                	jmp    7ec <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d0:	77 12                	ja     7e4 <free+0x35>
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d8:	77 24                	ja     7fe <free+0x4f>
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e2:	77 1a                	ja     7fe <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f2:	76 d4                	jbe    7c8 <free+0x19>
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fc:	76 ca                	jbe    7c8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	01 c2                	add    %eax,%edx
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	39 c2                	cmp    %eax,%edx
 817:	75 24                	jne    83d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	8b 50 04             	mov    0x4(%eax),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	01 c2                	add    %eax,%edx
 829:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 0a                	jmp    847 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	01 d0                	add    %edx,%eax
 859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85c:	75 20                	jne    87e <free+0xcf>
    p->s.size += bp->s.size;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	01 c2                	add    %eax,%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 872:	8b 45 f8             	mov    -0x8(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 08                	jmp    886 <free+0xd7>
  } else
    p->s.ptr = bp;
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 55 f8             	mov    -0x8(%ebp),%edx
 884:	89 10                	mov    %edx,(%eax)
  freep = p;
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	a3 68 11 00 00       	mov    %eax,0x1168
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <morecore>:

static Header*
morecore(uint nu)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 896:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89d:	77 07                	ja     8a6 <morecore+0x16>
    nu = 4096;
 89f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	c1 e0 03             	shl    $0x3,%eax
 8ac:	89 04 24             	mov    %eax,(%esp)
 8af:	e8 20 fc ff ff       	call   4d4 <sbrk>
 8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8bb:	75 07                	jne    8c4 <morecore+0x34>
    return 0;
 8bd:	b8 00 00 00 00       	mov    $0x0,%eax
 8c2:	eb 22                	jmp    8e6 <morecore+0x56>
  hp = (Header*)p;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	8b 55 08             	mov    0x8(%ebp),%edx
 8d0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	83 c0 08             	add    $0x8,%eax
 8d9:	89 04 24             	mov    %eax,(%esp)
 8dc:	e8 ce fe ff ff       	call   7af <free>
  return freep;
 8e1:	a1 68 11 00 00       	mov    0x1168,%eax
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <malloc>:

void*
malloc(uint nbytes)
{
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	83 c0 07             	add    $0x7,%eax
 8f4:	c1 e8 03             	shr    $0x3,%eax
 8f7:	83 c0 01             	add    $0x1,%eax
 8fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fd:	a1 68 11 00 00       	mov    0x1168,%eax
 902:	89 45 f0             	mov    %eax,-0x10(%ebp)
 905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 909:	75 23                	jne    92e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 90b:	c7 45 f0 60 11 00 00 	movl   $0x1160,-0x10(%ebp)
 912:	8b 45 f0             	mov    -0x10(%ebp),%eax
 915:	a3 68 11 00 00       	mov    %eax,0x1168
 91a:	a1 68 11 00 00       	mov    0x1168,%eax
 91f:	a3 60 11 00 00       	mov    %eax,0x1160
    base.s.size = 0;
 924:	c7 05 64 11 00 00 00 	movl   $0x0,0x1164
 92b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 931:	8b 00                	mov    (%eax),%eax
 933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	8b 40 04             	mov    0x4(%eax),%eax
 93c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93f:	72 4d                	jb     98e <malloc+0xa6>
      if(p->s.size == nunits)
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 94a:	75 0c                	jne    958 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 10                	mov    (%eax),%edx
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	89 10                	mov    %edx,(%eax)
 956:	eb 26                	jmp    97e <malloc+0x96>
      else {
        p->s.size -= nunits;
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 961:	89 c2                	mov    %eax,%edx
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	c1 e0 03             	shl    $0x3,%eax
 972:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 981:	a3 68 11 00 00       	mov    %eax,0x1168
      return (void*)(p + 1);
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	83 c0 08             	add    $0x8,%eax
 98c:	eb 38                	jmp    9c6 <malloc+0xde>
    }
    if(p == freep)
 98e:	a1 68 11 00 00       	mov    0x1168,%eax
 993:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 996:	75 1b                	jne    9b3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 998:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99b:	89 04 24             	mov    %eax,(%esp)
 99e:	e8 ed fe ff ff       	call   890 <morecore>
 9a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9aa:	75 07                	jne    9b3 <malloc+0xcb>
        return 0;
 9ac:	b8 00 00 00 00       	mov    $0x0,%eax
 9b1:	eb 13                	jmp    9c6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	8b 00                	mov    (%eax),%eax
 9be:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c1:	e9 70 ff ff ff       	jmp    936 <malloc+0x4e>
}
 9c6:	c9                   	leave  
 9c7:	c3                   	ret    

000009c8 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 9c8:	55                   	push   %ebp
 9c9:	89 e5                	mov    %esp,%ebp
 9cb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 9ce:	8b 55 08             	mov    0x8(%ebp),%edx
 9d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 9d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9d7:	f0 87 02             	lock xchg %eax,(%edx)
 9da:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9e0:	c9                   	leave  
 9e1:	c3                   	ret    

000009e2 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 9e2:	55                   	push   %ebp
 9e3:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9ee:	5d                   	pop    %ebp
 9ef:	c3                   	ret    

000009f0 <lock_acquire>:
void lock_acquire(lock_t *lock){
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9f6:	90                   	nop
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 a01:	00 
 a02:	89 04 24             	mov    %eax,(%esp)
 a05:	e8 be ff ff ff       	call   9c8 <xchg>
 a0a:	85 c0                	test   %eax,%eax
 a0c:	75 e9                	jne    9f7 <lock_acquire+0x7>
}
 a0e:	c9                   	leave  
 a0f:	c3                   	ret    

00000a10 <lock_release>:
void lock_release(lock_t *lock){
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 a16:	8b 45 08             	mov    0x8(%ebp),%eax
 a19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 a20:	00 
 a21:	89 04 24             	mov    %eax,(%esp)
 a24:	e8 9f ff ff ff       	call   9c8 <xchg>
}
 a29:	c9                   	leave  
 a2a:	c3                   	ret    

00000a2b <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 a2b:	55                   	push   %ebp
 a2c:	89 e5                	mov    %esp,%ebp
 a2e:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 a31:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 a38:	e8 ab fe ff ff       	call   8e8 <malloc>
 a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 a46:	0f b6 05 6c 11 00 00 	movzbl 0x116c,%eax
 a4d:	84 c0                	test   %al,%al
 a4f:	75 1c                	jne    a6d <thread_create+0x42>
        init_q(thQ2);
 a51:	a1 88 12 00 00       	mov    0x1288,%eax
 a56:	89 04 24             	mov    %eax,(%esp)
 a59:	e8 2c 01 00 00       	call   b8a <init_q>
        inQ++;
 a5e:	0f b6 05 6c 11 00 00 	movzbl 0x116c,%eax
 a65:	83 c0 01             	add    $0x1,%eax
 a68:	a2 6c 11 00 00       	mov    %al,0x116c
    }

    if((uint)stack % 4096){
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	25 ff 0f 00 00       	and    $0xfff,%eax
 a75:	85 c0                	test   %eax,%eax
 a77:	74 14                	je     a8d <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7c:	25 ff 0f 00 00       	and    $0xfff,%eax
 a81:	89 c2                	mov    %eax,%edx
 a83:	b8 00 10 00 00       	mov    $0x1000,%eax
 a88:	29 d0                	sub    %edx,%eax
 a8a:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a91:	75 1e                	jne    ab1 <thread_create+0x86>

        printf(1,"malloc fail \n");
 a93:	c7 44 24 04 39 0d 00 	movl   $0xd39,0x4(%esp)
 a9a:	00 
 a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aa2:	e8 55 fb ff ff       	call   5fc <printf>
        return 0;
 aa7:	b8 00 00 00 00       	mov    $0x0,%eax
 aac:	e9 83 00 00 00       	jmp    b34 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 ab1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 ab4:	8b 55 08             	mov    0x8(%ebp),%edx
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 abe:	89 54 24 08          	mov    %edx,0x8(%esp)
 ac2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 ac9:	00 
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 1a fa ff ff       	call   4ec <clone>
 ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad9:	79 1b                	jns    af6 <thread_create+0xcb>
        printf(1,"clone fails\n");
 adb:	c7 44 24 04 47 0d 00 	movl   $0xd47,0x4(%esp)
 ae2:	00 
 ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aea:	e8 0d fb ff ff       	call   5fc <printf>
        return 0;
 aef:	b8 00 00 00 00       	mov    $0x0,%eax
 af4:	eb 3e                	jmp    b34 <thread_create+0x109>
    }
    if(tid > 0){
 af6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 afa:	7e 19                	jle    b15 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 afc:	a1 88 12 00 00       	mov    0x1288,%eax
 b01:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b04:	89 54 24 04          	mov    %edx,0x4(%esp)
 b08:	89 04 24             	mov    %eax,(%esp)
 b0b:	e8 9c 00 00 00       	call   bac <add_q>
        return garbage_stack;
 b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b13:	eb 1f                	jmp    b34 <thread_create+0x109>
    }
    if(tid == 0){
 b15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b19:	75 14                	jne    b2f <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 b1b:	c7 44 24 04 54 0d 00 	movl   $0xd54,0x4(%esp)
 b22:	00 
 b23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b2a:	e8 cd fa ff ff       	call   5fc <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 b34:	c9                   	leave  
 b35:	c3                   	ret    

00000b36 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 b36:	55                   	push   %ebp
 b37:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 b39:	a1 48 11 00 00       	mov    0x1148,%eax
 b3e:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 b44:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 b49:	a3 48 11 00 00       	mov    %eax,0x1148
    return (int)(rands % max);
 b4e:	a1 48 11 00 00       	mov    0x1148,%eax
 b53:	8b 4d 08             	mov    0x8(%ebp),%ecx
 b56:	ba 00 00 00 00       	mov    $0x0,%edx
 b5b:	f7 f1                	div    %ecx
 b5d:	89 d0                	mov    %edx,%eax
}
 b5f:	5d                   	pop    %ebp
 b60:	c3                   	ret    

00000b61 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 b61:	55                   	push   %ebp
 b62:	89 e5                	mov    %esp,%ebp
 b64:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
 b67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 b6d:	8b 40 10             	mov    0x10(%eax),%eax
 b70:	89 44 24 08          	mov    %eax,0x8(%esp)
 b74:	c7 44 24 04 65 0d 00 	movl   $0xd65,0x4(%esp)
 b7b:	00 
 b7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b83:	e8 74 fa ff ff       	call   5fc <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
 b88:	c9                   	leave  
 b89:	c3                   	ret    

00000b8a <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 b8a:	55                   	push   %ebp
 b8b:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 b8d:	8b 45 08             	mov    0x8(%ebp),%eax
 b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 b96:	8b 45 08             	mov    0x8(%ebp),%eax
 b99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 ba0:	8b 45 08             	mov    0x8(%ebp),%eax
 ba3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 baa:	5d                   	pop    %ebp
 bab:	c3                   	ret    

00000bac <add_q>:

void add_q(struct queue *q, int v){
 bac:	55                   	push   %ebp
 bad:	89 e5                	mov    %esp,%ebp
 baf:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 bb2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 bb9:	e8 2a fd ff ff       	call   8e8 <malloc>
 bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bce:	8b 55 0c             	mov    0xc(%ebp),%edx
 bd1:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 bd3:	8b 45 08             	mov    0x8(%ebp),%eax
 bd6:	8b 40 04             	mov    0x4(%eax),%eax
 bd9:	85 c0                	test   %eax,%eax
 bdb:	75 0b                	jne    be8 <add_q+0x3c>
        q->head = n;
 bdd:	8b 45 08             	mov    0x8(%ebp),%eax
 be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 be3:	89 50 04             	mov    %edx,0x4(%eax)
 be6:	eb 0c                	jmp    bf4 <add_q+0x48>
    }else{
        q->tail->next = n;
 be8:	8b 45 08             	mov    0x8(%ebp),%eax
 beb:	8b 40 08             	mov    0x8(%eax),%eax
 bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bf1:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 bf4:	8b 45 08             	mov    0x8(%ebp),%eax
 bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bfa:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 bfd:	8b 45 08             	mov    0x8(%ebp),%eax
 c00:	8b 00                	mov    (%eax),%eax
 c02:	8d 50 01             	lea    0x1(%eax),%edx
 c05:	8b 45 08             	mov    0x8(%ebp),%eax
 c08:	89 10                	mov    %edx,(%eax)
}
 c0a:	c9                   	leave  
 c0b:	c3                   	ret    

00000c0c <empty_q>:

int empty_q(struct queue *q){
 c0c:	55                   	push   %ebp
 c0d:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 c0f:	8b 45 08             	mov    0x8(%ebp),%eax
 c12:	8b 00                	mov    (%eax),%eax
 c14:	85 c0                	test   %eax,%eax
 c16:	75 07                	jne    c1f <empty_q+0x13>
        return 1;
 c18:	b8 01 00 00 00       	mov    $0x1,%eax
 c1d:	eb 05                	jmp    c24 <empty_q+0x18>
    else
        return 0;
 c1f:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 c24:	5d                   	pop    %ebp
 c25:	c3                   	ret    

00000c26 <pop_q>:
int pop_q(struct queue *q){
 c26:	55                   	push   %ebp
 c27:	89 e5                	mov    %esp,%ebp
 c29:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 c2c:	8b 45 08             	mov    0x8(%ebp),%eax
 c2f:	89 04 24             	mov    %eax,(%esp)
 c32:	e8 d5 ff ff ff       	call   c0c <empty_q>
 c37:	85 c0                	test   %eax,%eax
 c39:	75 5d                	jne    c98 <pop_q+0x72>
       val = q->head->value; 
 c3b:	8b 45 08             	mov    0x8(%ebp),%eax
 c3e:	8b 40 04             	mov    0x4(%eax),%eax
 c41:	8b 00                	mov    (%eax),%eax
 c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 c46:	8b 45 08             	mov    0x8(%ebp),%eax
 c49:	8b 40 04             	mov    0x4(%eax),%eax
 c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 c4f:	8b 45 08             	mov    0x8(%ebp),%eax
 c52:	8b 40 04             	mov    0x4(%eax),%eax
 c55:	8b 50 04             	mov    0x4(%eax),%edx
 c58:	8b 45 08             	mov    0x8(%ebp),%eax
 c5b:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c61:	89 04 24             	mov    %eax,(%esp)
 c64:	e8 46 fb ff ff       	call   7af <free>
       q->size--;
 c69:	8b 45 08             	mov    0x8(%ebp),%eax
 c6c:	8b 00                	mov    (%eax),%eax
 c6e:	8d 50 ff             	lea    -0x1(%eax),%edx
 c71:	8b 45 08             	mov    0x8(%ebp),%eax
 c74:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 c76:	8b 45 08             	mov    0x8(%ebp),%eax
 c79:	8b 00                	mov    (%eax),%eax
 c7b:	85 c0                	test   %eax,%eax
 c7d:	75 14                	jne    c93 <pop_q+0x6d>
            q->head = 0;
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 c89:	8b 45 08             	mov    0x8(%ebp),%eax
 c8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c96:	eb 05                	jmp    c9d <pop_q+0x77>
    }
    return -1;
 c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 c9d:	c9                   	leave  
 c9e:	c3                   	ret    
