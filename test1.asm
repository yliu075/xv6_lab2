
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

int n = 1;

void test_func(void *arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp


   int pid = fork();
   9:	e8 e2 04 00 00       	call   4f0 <fork>
   e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid == 0){
  12:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  17:	0f 85 44 01 00 00    	jne    161 <main+0x161>
        void *tid = thread_create(test_func,(void *)0);
  1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  24:	00 
  25:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
  2c:	e8 a6 0a 00 00       	call   ad7 <thread_create>
  31:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
  35:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  3a:	75 19                	jne    55 <main+0x55>
            printf(1,"thread_create fails\n");
  3c:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 58 06 00 00       	call   6a8 <printf>
            exit();
  50:	e8 a3 04 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  55:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
  64:	e8 6e 0a 00 00       	call   ad7 <thread_create>
  69:	89 44 24 18          	mov    %eax,0x18(%esp)
        if(tid == 0){
  6d:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  72:	75 19                	jne    8d <main+0x8d>
            printf(1,"thread_create fails\n");
  74:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 20 06 00 00       	call   6a8 <printf>
            exit();
  88:	e8 6b 04 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  94:	00 
  95:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
  9c:	e8 36 0a 00 00       	call   ad7 <thread_create>
  a1:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
  a5:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  aa:	75 19                	jne    c5 <main+0xc5>
            printf(1,"thread_create fails\n");
  ac:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
  b3:	00 
  b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bb:	e8 e8 05 00 00       	call   6a8 <printf>
            exit();
  c0:	e8 33 04 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  cc:	00 
  cd:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
  d4:	e8 fe 09 00 00       	call   ad7 <thread_create>
  d9:	89 44 24 18          	mov    %eax,0x18(%esp)
          if(tid == 0){
  dd:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  e2:	75 19                	jne    fd <main+0xfd>
            printf(1,"thread_create fails\n");
  e4:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 b0 05 00 00       	call   6a8 <printf>
            exit();
  f8:	e8 fb 03 00 00       	call   4f8 <exit>
        }
       tid = thread_create(test_func,(void *)0);
  fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 104:	00 
 105:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
 10c:	e8 c6 09 00 00       	call   ad7 <thread_create>
 111:	89 44 24 18          	mov    %eax,0x18(%esp)
           if(tid == 0){
 115:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 11a:	75 19                	jne    135 <main+0x135>
            printf(1,"thread_create fails\n");
 11c:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
 123:	00 
 124:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12b:	e8 78 05 00 00       	call   6a8 <printf>
            exit();
 130:	e8 c3 03 00 00       	call   4f8 <exit>
        }
      while(wait()>=0);
 135:	90                   	nop
 136:	e8 c5 03 00 00       	call   500 <wait>
 13b:	85 c0                	test   %eax,%eax
 13d:	79 f7                	jns    136 <main+0x136>
        printf(1,"I am child, [6] n = %d\n",n);
 13f:	a1 94 11 00 00       	mov    0x1194,%eax
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	c7 44 24 04 60 0d 00 	movl   $0xd60,0x4(%esp)
 14f:	00 
 150:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 157:	e8 4c 05 00 00       	call   6a8 <printf>
 15c:	e9 12 01 00 00       	jmp    273 <main+0x273>
    }else if(pid > 0){
 161:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 166:	0f 8e 07 01 00 00    	jle    273 <main+0x273>
        void *tid = thread_create(test_func,(void *)0);
 16c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 173:	00 
 174:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
 17b:	e8 57 09 00 00       	call   ad7 <thread_create>
 180:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
 184:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 189:	75 19                	jne    1a4 <main+0x1a4>
            printf(1,"thread_create fails\n");
 18b:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
 192:	00 
 193:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19a:	e8 09 05 00 00       	call   6a8 <printf>
            exit();
 19f:	e8 54 03 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 1a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
 1b3:	e8 1f 09 00 00       	call   ad7 <thread_create>
 1b8:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
 1bc:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 1c1:	75 19                	jne    1dc <main+0x1dc>
            printf(1,"thread_create fails\n");
 1c3:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
 1ca:	00 
 1cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d2:	e8 d1 04 00 00       	call   6a8 <printf>
            exit();
 1d7:	e8 1c 03 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 1dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1e3:	00 
 1e4:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
 1eb:	e8 e7 08 00 00       	call   ad7 <thread_create>
 1f0:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
 1f4:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 1f9:	75 19                	jne    214 <main+0x214>
            printf(1,"thread_create fails\n");
 1fb:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
 202:	00 
 203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20a:	e8 99 04 00 00       	call   6a8 <printf>
            exit();
 20f:	e8 e4 02 00 00       	call   4f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21b:	00 
 21c:	c7 04 24 78 02 00 00 	movl   $0x278,(%esp)
 223:	e8 af 08 00 00       	call   ad7 <thread_create>
 228:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
 22c:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 231:	75 19                	jne    24c <main+0x24c>
            printf(1,"thread_create fails\n");
 233:	c7 44 24 04 4b 0d 00 	movl   $0xd4b,0x4(%esp)
 23a:	00 
 23b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 242:	e8 61 04 00 00       	call   6a8 <printf>
            exit();
 247:	e8 ac 02 00 00       	call   4f8 <exit>
        }
        while(wait()>=0);
 24c:	90                   	nop
 24d:	e8 ae 02 00 00       	call   500 <wait>
 252:	85 c0                	test   %eax,%eax
 254:	79 f7                	jns    24d <main+0x24d>
        printf(1,"I am parent, [5] n = %d\n",n);
 256:	a1 94 11 00 00       	mov    0x1194,%eax
 25b:	89 44 24 08          	mov    %eax,0x8(%esp)
 25f:	c7 44 24 04 78 0d 00 	movl   $0xd78,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 35 04 00 00       	call   6a8 <printf>
    }

   exit();
 273:	e8 80 02 00 00       	call   4f8 <exit>

00000278 <test_func>:
}

void test_func(void *arg_ptr){
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
 27e:	a1 94 11 00 00       	mov    0x1194,%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	a3 94 11 00 00       	mov    %eax,0x1194
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
 28b:	e8 10 03 00 00       	call   5a0 <texit>

00000290 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 295:	8b 4d 08             	mov    0x8(%ebp),%ecx
 298:	8b 55 10             	mov    0x10(%ebp),%edx
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 cb                	mov    %ecx,%ebx
 2a0:	89 df                	mov    %ebx,%edi
 2a2:	89 d1                	mov    %edx,%ecx
 2a4:	fc                   	cld    
 2a5:	f3 aa                	rep stos %al,%es:(%edi)
 2a7:	89 ca                	mov    %ecx,%edx
 2a9:	89 fb                	mov    %edi,%ebx
 2ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2b1:	5b                   	pop    %ebx
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    

000002b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2c1:	90                   	nop
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 2ce:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2d4:	0f b6 12             	movzbl (%edx),%edx
 2d7:	88 10                	mov    %dl,(%eax)
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	84 c0                	test   %al,%al
 2de:	75 e2                	jne    2c2 <strcpy+0xd>
    ;
  return os;
 2e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e8:	eb 08                	jmp    2f2 <strcmp+0xd>
    p++, q++;
 2ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	84 c0                	test   %al,%al
 2fa:	74 10                	je     30c <strcmp+0x27>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 10             	movzbl (%eax),%edx
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	38 c2                	cmp    %al,%dl
 30a:	74 de                	je     2ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	0f b6 d0             	movzbl %al,%edx
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	0f b6 c0             	movzbl %al,%eax
 31e:	29 c2                	sub    %eax,%edx
 320:	89 d0                	mov    %edx,%eax
}
 322:	5d                   	pop    %ebp
 323:	c3                   	ret    

00000324 <strlen>:

uint
strlen(char *s)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 32a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 331:	eb 04                	jmp    337 <strlen+0x13>
 333:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 337:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	01 d0                	add    %edx,%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	84 c0                	test   %al,%al
 344:	75 ed                	jne    333 <strlen+0xf>
    ;
  return n;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <memset>:

void*
memset(void *dst, int c, uint n)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 351:	8b 45 10             	mov    0x10(%ebp),%eax
 354:	89 44 24 08          	mov    %eax,0x8(%esp)
 358:	8b 45 0c             	mov    0xc(%ebp),%eax
 35b:	89 44 24 04          	mov    %eax,0x4(%esp)
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 26 ff ff ff       	call   290 <stosb>
  return dst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <strchr>:

char*
strchr(const char *s, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 04             	sub    $0x4,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 37b:	eb 14                	jmp    391 <strchr+0x22>
    if(*s == c)
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3a 45 fc             	cmp    -0x4(%ebp),%al
 386:	75 05                	jne    38d <strchr+0x1e>
      return (char*)s;
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	eb 13                	jmp    3a0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 38d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	0f b6 00             	movzbl (%eax),%eax
 397:	84 c0                	test   %al,%al
 399:	75 e2                	jne    37d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <gets>:

char*
gets(char *buf, int max)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3af:	eb 4c                	jmp    3fd <gets+0x5b>
    cc = read(0, &c, 1);
 3b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b8:	00 
 3b9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3c7:	e8 44 01 00 00       	call   510 <read>
 3cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d3:	7f 02                	jg     3d7 <gets+0x35>
      break;
 3d5:	eb 31                	jmp    408 <gets+0x66>
    buf[i++] = c;
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e0:	89 c2                	mov    %eax,%edx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	01 c2                	add    %eax,%edx
 3e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3eb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f1:	3c 0a                	cmp    $0xa,%al
 3f3:	74 13                	je     408 <gets+0x66>
 3f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f9:	3c 0d                	cmp    $0xd,%al
 3fb:	74 0b                	je     408 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	83 c0 01             	add    $0x1,%eax
 403:	3b 45 0c             	cmp    0xc(%ebp),%eax
 406:	7c a9                	jl     3b1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 408:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	01 d0                	add    %edx,%eax
 410:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 413:	8b 45 08             	mov    0x8(%ebp),%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <stat>:

int
stat(char *n, struct stat *st)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 425:	00 
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 07 01 00 00       	call   538 <open>
 431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 438:	79 07                	jns    441 <stat+0x29>
    return -1;
 43a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43f:	eb 23                	jmp    464 <stat+0x4c>
  r = fstat(fd, st);
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	89 44 24 04          	mov    %eax,0x4(%esp)
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	89 04 24             	mov    %eax,(%esp)
 44e:	e8 fd 00 00 00       	call   550 <fstat>
 453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 456:	8b 45 f4             	mov    -0xc(%ebp),%eax
 459:	89 04 24             	mov    %eax,(%esp)
 45c:	e8 bf 00 00 00       	call   520 <close>
  return r;
 461:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <atoi>:

int
atoi(const char *s)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 46c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 473:	eb 25                	jmp    49a <atoi+0x34>
    n = n*10 + *s++ - '0';
 475:	8b 55 fc             	mov    -0x4(%ebp),%edx
 478:	89 d0                	mov    %edx,%eax
 47a:	c1 e0 02             	shl    $0x2,%eax
 47d:	01 d0                	add    %edx,%eax
 47f:	01 c0                	add    %eax,%eax
 481:	89 c1                	mov    %eax,%ecx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	8d 50 01             	lea    0x1(%eax),%edx
 489:	89 55 08             	mov    %edx,0x8(%ebp)
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	01 c8                	add    %ecx,%eax
 494:	83 e8 30             	sub    $0x30,%eax
 497:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	3c 2f                	cmp    $0x2f,%al
 4a2:	7e 0a                	jle    4ae <atoi+0x48>
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	3c 39                	cmp    $0x39,%al
 4ac:	7e c7                	jle    475 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c5:	eb 17                	jmp    4de <memmove+0x2b>
    *dst++ = *src++;
 4c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ca:	8d 50 01             	lea    0x1(%eax),%edx
 4cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d3:	8d 4a 01             	lea    0x1(%edx),%ecx
 4d6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d9:	0f b6 12             	movzbl (%edx),%edx
 4dc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4de:	8b 45 10             	mov    0x10(%ebp),%eax
 4e1:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e4:	89 55 10             	mov    %edx,0x10(%ebp)
 4e7:	85 c0                	test   %eax,%eax
 4e9:	7f dc                	jg     4c7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f0:	b8 01 00 00 00       	mov    $0x1,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <exit>:
SYSCALL(exit)
 4f8:	b8 02 00 00 00       	mov    $0x2,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <wait>:
SYSCALL(wait)
 500:	b8 03 00 00 00       	mov    $0x3,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <pipe>:
SYSCALL(pipe)
 508:	b8 04 00 00 00       	mov    $0x4,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <read>:
SYSCALL(read)
 510:	b8 05 00 00 00       	mov    $0x5,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <write>:
SYSCALL(write)
 518:	b8 10 00 00 00       	mov    $0x10,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <close>:
SYSCALL(close)
 520:	b8 15 00 00 00       	mov    $0x15,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <kill>:
SYSCALL(kill)
 528:	b8 06 00 00 00       	mov    $0x6,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <exec>:
SYSCALL(exec)
 530:	b8 07 00 00 00       	mov    $0x7,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <open>:
SYSCALL(open)
 538:	b8 0f 00 00 00       	mov    $0xf,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <mknod>:
SYSCALL(mknod)
 540:	b8 11 00 00 00       	mov    $0x11,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <unlink>:
SYSCALL(unlink)
 548:	b8 12 00 00 00       	mov    $0x12,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <fstat>:
SYSCALL(fstat)
 550:	b8 08 00 00 00       	mov    $0x8,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <link>:
SYSCALL(link)
 558:	b8 13 00 00 00       	mov    $0x13,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <mkdir>:
SYSCALL(mkdir)
 560:	b8 14 00 00 00       	mov    $0x14,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <chdir>:
SYSCALL(chdir)
 568:	b8 09 00 00 00       	mov    $0x9,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <dup>:
SYSCALL(dup)
 570:	b8 0a 00 00 00       	mov    $0xa,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <getpid>:
SYSCALL(getpid)
 578:	b8 0b 00 00 00       	mov    $0xb,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <sbrk>:
SYSCALL(sbrk)
 580:	b8 0c 00 00 00       	mov    $0xc,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <sleep>:
SYSCALL(sleep)
 588:	b8 0d 00 00 00       	mov    $0xd,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <uptime>:
SYSCALL(uptime)
 590:	b8 0e 00 00 00       	mov    $0xe,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <clone>:
SYSCALL(clone)
 598:	b8 16 00 00 00       	mov    $0x16,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <texit>:
SYSCALL(texit)
 5a0:	b8 17 00 00 00       	mov    $0x17,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <tsleep>:
SYSCALL(tsleep)
 5a8:	b8 18 00 00 00       	mov    $0x18,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <twakeup>:
SYSCALL(twakeup)
 5b0:	b8 19 00 00 00       	mov    $0x19,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <thread_yield>:
SYSCALL(thread_yield)
 5b8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <thread_yield3>:
 5c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	83 ec 18             	sub    $0x18,%esp
 5ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5db:	00 
 5dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5df:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 2a ff ff ff       	call   518 <write>
}
 5ee:	c9                   	leave  
 5ef:	c3                   	ret    

000005f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
 5f5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 603:	74 17                	je     61c <printint+0x2c>
 605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 609:	79 11                	jns    61c <printint+0x2c>
    neg = 1;
 60b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	f7 d8                	neg    %eax
 617:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61a:	eb 06                	jmp    622 <printint+0x32>
  } else {
    x = xx;
 61c:	8b 45 0c             	mov    0xc(%ebp),%eax
 61f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 629:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 62c:	8d 41 01             	lea    0x1(%ecx),%eax
 62f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 632:	8b 5d 10             	mov    0x10(%ebp),%ebx
 635:	8b 45 ec             	mov    -0x14(%ebp),%eax
 638:	ba 00 00 00 00       	mov    $0x0,%edx
 63d:	f7 f3                	div    %ebx
 63f:	89 d0                	mov    %edx,%eax
 641:	0f b6 80 98 11 00 00 	movzbl 0x1198(%eax),%eax
 648:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 64c:	8b 75 10             	mov    0x10(%ebp),%esi
 64f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 652:	ba 00 00 00 00       	mov    $0x0,%edx
 657:	f7 f6                	div    %esi
 659:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 660:	75 c7                	jne    629 <printint+0x39>
  if(neg)
 662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 666:	74 10                	je     678 <printint+0x88>
    buf[i++] = '-';
 668:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66b:	8d 50 01             	lea    0x1(%eax),%edx
 66e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 671:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 676:	eb 1f                	jmp    697 <printint+0xa7>
 678:	eb 1d                	jmp    697 <printint+0xa7>
    putc(fd, buf[i]);
 67a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	01 d0                	add    %edx,%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	89 44 24 04          	mov    %eax,0x4(%esp)
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 31 ff ff ff       	call   5c8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 697:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 69b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69f:	79 d9                	jns    67a <printint+0x8a>
    putc(fd, buf[i]);
}
 6a1:	83 c4 30             	add    $0x30,%esp
 6a4:	5b                   	pop    %ebx
 6a5:	5e                   	pop    %esi
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret    

000006a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6b5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6b8:	83 c0 04             	add    $0x4,%eax
 6bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6c5:	e9 7c 01 00 00       	jmp    846 <printf+0x19e>
    c = fmt[i] & 0xff;
 6ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	0f be c0             	movsbl %al,%eax
 6d8:	25 ff 00 00 00       	and    $0xff,%eax
 6dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e4:	75 2c                	jne    712 <printf+0x6a>
      if(c == '%'){
 6e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ea:	75 0c                	jne    6f8 <printf+0x50>
        state = '%';
 6ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6f3:	e9 4a 01 00 00       	jmp    842 <printf+0x19a>
      } else {
        putc(fd, c);
 6f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fb:	0f be c0             	movsbl %al,%eax
 6fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	89 04 24             	mov    %eax,(%esp)
 708:	e8 bb fe ff ff       	call   5c8 <putc>
 70d:	e9 30 01 00 00       	jmp    842 <printf+0x19a>
      }
    } else if(state == '%'){
 712:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 716:	0f 85 26 01 00 00    	jne    842 <printf+0x19a>
      if(c == 'd'){
 71c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 720:	75 2d                	jne    74f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 722:	8b 45 e8             	mov    -0x18(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 72e:	00 
 72f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 736:	00 
 737:	89 44 24 04          	mov    %eax,0x4(%esp)
 73b:	8b 45 08             	mov    0x8(%ebp),%eax
 73e:	89 04 24             	mov    %eax,(%esp)
 741:	e8 aa fe ff ff       	call   5f0 <printint>
        ap++;
 746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74a:	e9 ec 00 00 00       	jmp    83b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 74f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 753:	74 06                	je     75b <printf+0xb3>
 755:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 759:	75 2d                	jne    788 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 75b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 767:	00 
 768:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 76f:	00 
 770:	89 44 24 04          	mov    %eax,0x4(%esp)
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	89 04 24             	mov    %eax,(%esp)
 77a:	e8 71 fe ff ff       	call   5f0 <printint>
        ap++;
 77f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 783:	e9 b3 00 00 00       	jmp    83b <printf+0x193>
      } else if(c == 's'){
 788:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 78c:	75 45                	jne    7d3 <printf+0x12b>
        s = (char*)*ap;
 78e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 796:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 79a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79e:	75 09                	jne    7a9 <printf+0x101>
          s = "(null)";
 7a0:	c7 45 f4 91 0d 00 00 	movl   $0xd91,-0xc(%ebp)
        while(*s != 0){
 7a7:	eb 1e                	jmp    7c7 <printf+0x11f>
 7a9:	eb 1c                	jmp    7c7 <printf+0x11f>
          putc(fd, *s);
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	0f b6 00             	movzbl (%eax),%eax
 7b1:	0f be c0             	movsbl %al,%eax
 7b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	89 04 24             	mov    %eax,(%esp)
 7be:	e8 05 fe ff ff       	call   5c8 <putc>
          s++;
 7c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	0f b6 00             	movzbl (%eax),%eax
 7cd:	84 c0                	test   %al,%al
 7cf:	75 da                	jne    7ab <printf+0x103>
 7d1:	eb 68                	jmp    83b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7d3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7d7:	75 1d                	jne    7f6 <printf+0x14e>
        putc(fd, *ap);
 7d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	0f be c0             	movsbl %al,%eax
 7e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	89 04 24             	mov    %eax,(%esp)
 7eb:	e8 d8 fd ff ff       	call   5c8 <putc>
        ap++;
 7f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f4:	eb 45                	jmp    83b <printf+0x193>
      } else if(c == '%'){
 7f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7fa:	75 17                	jne    813 <printf+0x16b>
        putc(fd, c);
 7fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ff:	0f be c0             	movsbl %al,%eax
 802:	89 44 24 04          	mov    %eax,0x4(%esp)
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	89 04 24             	mov    %eax,(%esp)
 80c:	e8 b7 fd ff ff       	call   5c8 <putc>
 811:	eb 28                	jmp    83b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 813:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 81a:	00 
 81b:	8b 45 08             	mov    0x8(%ebp),%eax
 81e:	89 04 24             	mov    %eax,(%esp)
 821:	e8 a2 fd ff ff       	call   5c8 <putc>
        putc(fd, c);
 826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 829:	0f be c0             	movsbl %al,%eax
 82c:	89 44 24 04          	mov    %eax,0x4(%esp)
 830:	8b 45 08             	mov    0x8(%ebp),%eax
 833:	89 04 24             	mov    %eax,(%esp)
 836:	e8 8d fd ff ff       	call   5c8 <putc>
      }
      state = 0;
 83b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 842:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 846:	8b 55 0c             	mov    0xc(%ebp),%edx
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	01 d0                	add    %edx,%eax
 84e:	0f b6 00             	movzbl (%eax),%eax
 851:	84 c0                	test   %al,%al
 853:	0f 85 71 fe ff ff    	jne    6ca <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 861:	8b 45 08             	mov    0x8(%ebp),%eax
 864:	83 e8 08             	sub    $0x8,%eax
 867:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	a1 b8 11 00 00       	mov    0x11b8,%eax
 86f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 872:	eb 24                	jmp    898 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87c:	77 12                	ja     890 <free+0x35>
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 884:	77 24                	ja     8aa <free+0x4f>
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	8b 00                	mov    (%eax),%eax
 88b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88e:	77 1a                	ja     8aa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 890:	8b 45 fc             	mov    -0x4(%ebp),%eax
 893:	8b 00                	mov    (%eax),%eax
 895:	89 45 fc             	mov    %eax,-0x4(%ebp)
 898:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89e:	76 d4                	jbe    874 <free+0x19>
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a8:	76 ca                	jbe    874 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	01 c2                	add    %eax,%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	39 c2                	cmp    %eax,%edx
 8c3:	75 24                	jne    8e9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c8:	8b 50 04             	mov    0x4(%eax),%edx
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 00                	mov    (%eax),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	01 c2                	add    %eax,%edx
 8d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8de:	8b 00                	mov    (%eax),%eax
 8e0:	8b 10                	mov    (%eax),%edx
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	89 10                	mov    %edx,(%eax)
 8e7:	eb 0a                	jmp    8f3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	8b 10                	mov    (%eax),%edx
 8ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	01 d0                	add    %edx,%eax
 905:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 908:	75 20                	jne    92a <free+0xcf>
    p->s.size += bp->s.size;
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 50 04             	mov    0x4(%eax),%edx
 910:	8b 45 f8             	mov    -0x8(%ebp),%eax
 913:	8b 40 04             	mov    0x4(%eax),%eax
 916:	01 c2                	add    %eax,%edx
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 91e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 921:	8b 10                	mov    (%eax),%edx
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	89 10                	mov    %edx,(%eax)
 928:	eb 08                	jmp    932 <free+0xd7>
  } else
    p->s.ptr = bp;
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 930:	89 10                	mov    %edx,(%eax)
  freep = p;
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	a3 b8 11 00 00       	mov    %eax,0x11b8
}
 93a:	c9                   	leave  
 93b:	c3                   	ret    

0000093c <morecore>:

static Header*
morecore(uint nu)
{
 93c:	55                   	push   %ebp
 93d:	89 e5                	mov    %esp,%ebp
 93f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 942:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 949:	77 07                	ja     952 <morecore+0x16>
    nu = 4096;
 94b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 952:	8b 45 08             	mov    0x8(%ebp),%eax
 955:	c1 e0 03             	shl    $0x3,%eax
 958:	89 04 24             	mov    %eax,(%esp)
 95b:	e8 20 fc ff ff       	call   580 <sbrk>
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 963:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 967:	75 07                	jne    970 <morecore+0x34>
    return 0;
 969:	b8 00 00 00 00       	mov    $0x0,%eax
 96e:	eb 22                	jmp    992 <morecore+0x56>
  hp = (Header*)p;
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 976:	8b 45 f0             	mov    -0x10(%ebp),%eax
 979:	8b 55 08             	mov    0x8(%ebp),%edx
 97c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 982:	83 c0 08             	add    $0x8,%eax
 985:	89 04 24             	mov    %eax,(%esp)
 988:	e8 ce fe ff ff       	call   85b <free>
  return freep;
 98d:	a1 b8 11 00 00       	mov    0x11b8,%eax
}
 992:	c9                   	leave  
 993:	c3                   	ret    

00000994 <malloc>:

void*
malloc(uint nbytes)
{
 994:	55                   	push   %ebp
 995:	89 e5                	mov    %esp,%ebp
 997:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99a:	8b 45 08             	mov    0x8(%ebp),%eax
 99d:	83 c0 07             	add    $0x7,%eax
 9a0:	c1 e8 03             	shr    $0x3,%eax
 9a3:	83 c0 01             	add    $0x1,%eax
 9a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a9:	a1 b8 11 00 00       	mov    0x11b8,%eax
 9ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b5:	75 23                	jne    9da <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9b7:	c7 45 f0 b0 11 00 00 	movl   $0x11b0,-0x10(%ebp)
 9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c1:	a3 b8 11 00 00       	mov    %eax,0x11b8
 9c6:	a1 b8 11 00 00       	mov    0x11b8,%eax
 9cb:	a3 b0 11 00 00       	mov    %eax,0x11b0
    base.s.size = 0;
 9d0:	c7 05 b4 11 00 00 00 	movl   $0x0,0x11b4
 9d7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9dd:	8b 00                	mov    (%eax),%eax
 9df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	8b 40 04             	mov    0x4(%eax),%eax
 9e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9eb:	72 4d                	jb     a3a <malloc+0xa6>
      if(p->s.size == nunits)
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	8b 40 04             	mov    0x4(%eax),%eax
 9f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f6:	75 0c                	jne    a04 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	8b 10                	mov    (%eax),%edx
 9fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a00:	89 10                	mov    %edx,(%eax)
 a02:	eb 26                	jmp    a2a <malloc+0x96>
      else {
        p->s.size -= nunits;
 a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a07:	8b 40 04             	mov    0x4(%eax),%eax
 a0a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a0d:	89 c2                	mov    %eax,%edx
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	8b 40 04             	mov    0x4(%eax),%eax
 a1b:	c1 e0 03             	shl    $0x3,%eax
 a1e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a24:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a27:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2d:	a3 b8 11 00 00       	mov    %eax,0x11b8
      return (void*)(p + 1);
 a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a35:	83 c0 08             	add    $0x8,%eax
 a38:	eb 38                	jmp    a72 <malloc+0xde>
    }
    if(p == freep)
 a3a:	a1 b8 11 00 00       	mov    0x11b8,%eax
 a3f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a42:	75 1b                	jne    a5f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a47:	89 04 24             	mov    %eax,(%esp)
 a4a:	e8 ed fe ff ff       	call   93c <morecore>
 a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a56:	75 07                	jne    a5f <malloc+0xcb>
        return 0;
 a58:	b8 00 00 00 00       	mov    $0x0,%eax
 a5d:	eb 13                	jmp    a72 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a68:	8b 00                	mov    (%eax),%eax
 a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a6d:	e9 70 ff ff ff       	jmp    9e2 <malloc+0x4e>
}
 a72:	c9                   	leave  
 a73:	c3                   	ret    

00000a74 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 a74:	55                   	push   %ebp
 a75:	89 e5                	mov    %esp,%ebp
 a77:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 a7a:	8b 55 08             	mov    0x8(%ebp),%edx
 a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
 a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a83:	f0 87 02             	lock xchg %eax,(%edx)
 a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 a8c:	c9                   	leave  
 a8d:	c3                   	ret    

00000a8e <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
 a8e:	55                   	push   %ebp
 a8f:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 a91:	8b 45 08             	mov    0x8(%ebp),%eax
 a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 a9a:	5d                   	pop    %ebp
 a9b:	c3                   	ret    

00000a9c <lock_acquire>:
void lock_acquire(lock_t *lock){
 a9c:	55                   	push   %ebp
 a9d:	89 e5                	mov    %esp,%ebp
 a9f:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 aa2:	90                   	nop
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
 aa6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 aad:	00 
 aae:	89 04 24             	mov    %eax,(%esp)
 ab1:	e8 be ff ff ff       	call   a74 <xchg>
 ab6:	85 c0                	test   %eax,%eax
 ab8:	75 e9                	jne    aa3 <lock_acquire+0x7>
}
 aba:	c9                   	leave  
 abb:	c3                   	ret    

00000abc <lock_release>:
void lock_release(lock_t *lock){
 abc:	55                   	push   %ebp
 abd:	89 e5                	mov    %esp,%ebp
 abf:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 ac2:	8b 45 08             	mov    0x8(%ebp),%eax
 ac5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 acc:	00 
 acd:	89 04 24             	mov    %eax,(%esp)
 ad0:	e8 9f ff ff ff       	call   a74 <xchg>
}
 ad5:	c9                   	leave  
 ad6:	c3                   	ret    

00000ad7 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
 ad7:	55                   	push   %ebp
 ad8:	89 e5                	mov    %esp,%ebp
 ada:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 add:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 ae4:	e8 ab fe ff ff       	call   994 <malloc>
 ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
 af2:	0f b6 05 bc 11 00 00 	movzbl 0x11bc,%eax
 af9:	84 c0                	test   %al,%al
 afb:	75 1c                	jne    b19 <thread_create+0x42>
        init_q(thQ2);
 afd:	a1 c0 11 00 00       	mov    0x11c0,%eax
 b02:	89 04 24             	mov    %eax,(%esp)
 b05:	e8 2c 01 00 00       	call   c36 <init_q>
        inQ++;
 b0a:	0f b6 05 bc 11 00 00 	movzbl 0x11bc,%eax
 b11:	83 c0 01             	add    $0x1,%eax
 b14:	a2 bc 11 00 00       	mov    %al,0x11bc
    }

    if((uint)stack % 4096){
 b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1c:	25 ff 0f 00 00       	and    $0xfff,%eax
 b21:	85 c0                	test   %eax,%eax
 b23:	74 14                	je     b39 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
 b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b28:	25 ff 0f 00 00       	and    $0xfff,%eax
 b2d:	89 c2                	mov    %eax,%edx
 b2f:	b8 00 10 00 00       	mov    $0x1000,%eax
 b34:	29 d0                	sub    %edx,%eax
 b36:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
 b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b3d:	75 1e                	jne    b5d <thread_create+0x86>

        printf(1,"malloc fail \n");
 b3f:	c7 44 24 04 98 0d 00 	movl   $0xd98,0x4(%esp)
 b46:	00 
 b47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b4e:	e8 55 fb ff ff       	call   6a8 <printf>
        return 0;
 b53:	b8 00 00 00 00       	mov    $0x0,%eax
 b58:	e9 83 00 00 00       	jmp    be0 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 b60:	8b 55 08             	mov    0x8(%ebp),%edx
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 b6a:	89 54 24 08          	mov    %edx,0x8(%esp)
 b6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 b75:	00 
 b76:	89 04 24             	mov    %eax,(%esp)
 b79:	e8 1a fa ff ff       	call   598 <clone>
 b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 b81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b85:	79 1b                	jns    ba2 <thread_create+0xcb>
        printf(1,"clone fails\n");
 b87:	c7 44 24 04 a6 0d 00 	movl   $0xda6,0x4(%esp)
 b8e:	00 
 b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b96:	e8 0d fb ff ff       	call   6a8 <printf>
        return 0;
 b9b:	b8 00 00 00 00       	mov    $0x0,%eax
 ba0:	eb 3e                	jmp    be0 <thread_create+0x109>
    }
    if(tid > 0){
 ba2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ba6:	7e 19                	jle    bc1 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
 ba8:	a1 c0 11 00 00       	mov    0x11c0,%eax
 bad:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bb0:	89 54 24 04          	mov    %edx,0x4(%esp)
 bb4:	89 04 24             	mov    %eax,(%esp)
 bb7:	e8 9c 00 00 00       	call   c58 <add_q>
        return garbage_stack;
 bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbf:	eb 1f                	jmp    be0 <thread_create+0x109>
    }
    if(tid == 0){
 bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bc5:	75 14                	jne    bdb <thread_create+0x104>
        printf(1,"tid = 0 return \n");
 bc7:	c7 44 24 04 b3 0d 00 	movl   $0xdb3,0x4(%esp)
 bce:	00 
 bcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 bd6:	e8 cd fa ff ff       	call   6a8 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 be0:	c9                   	leave  
 be1:	c3                   	ret    

00000be2 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
 be2:	55                   	push   %ebp
 be3:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
 be5:	a1 ac 11 00 00       	mov    0x11ac,%eax
 bea:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
 bf0:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
 bf5:	a3 ac 11 00 00       	mov    %eax,0x11ac
    return (int)(rands % max);
 bfa:	a1 ac 11 00 00       	mov    0x11ac,%eax
 bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
 c02:	ba 00 00 00 00       	mov    $0x0,%edx
 c07:	f7 f1                	div    %ecx
 c09:	89 d0                	mov    %edx,%eax
}
 c0b:	5d                   	pop    %ebp
 c0c:	c3                   	ret    

00000c0d <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
 c0d:	55                   	push   %ebp
 c0e:	89 e5                	mov    %esp,%ebp
 c10:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
 c13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 c19:	8b 40 10             	mov    0x10(%eax),%eax
 c1c:	89 44 24 08          	mov    %eax,0x8(%esp)
 c20:	c7 44 24 04 c4 0d 00 	movl   $0xdc4,0x4(%esp)
 c27:	00 
 c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c2f:	e8 74 fa ff ff       	call   6a8 <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
 c34:	c9                   	leave  
 c35:	c3                   	ret    

00000c36 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
 c36:	55                   	push   %ebp
 c37:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 c39:	8b 45 08             	mov    0x8(%ebp),%eax
 c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 c42:	8b 45 08             	mov    0x8(%ebp),%eax
 c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 c4c:	8b 45 08             	mov    0x8(%ebp),%eax
 c4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 c56:	5d                   	pop    %ebp
 c57:	c3                   	ret    

00000c58 <add_q>:

void add_q(struct queue *q, int v){
 c58:	55                   	push   %ebp
 c59:	89 e5                	mov    %esp,%ebp
 c5b:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 c5e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c65:	e8 2a fd ff ff       	call   994 <malloc>
 c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
 c7d:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	8b 40 04             	mov    0x4(%eax),%eax
 c85:	85 c0                	test   %eax,%eax
 c87:	75 0b                	jne    c94 <add_q+0x3c>
        q->head = n;
 c89:	8b 45 08             	mov    0x8(%ebp),%eax
 c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c8f:	89 50 04             	mov    %edx,0x4(%eax)
 c92:	eb 0c                	jmp    ca0 <add_q+0x48>
    }else{
        q->tail->next = n;
 c94:	8b 45 08             	mov    0x8(%ebp),%eax
 c97:	8b 40 08             	mov    0x8(%eax),%eax
 c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c9d:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 ca0:	8b 45 08             	mov    0x8(%ebp),%eax
 ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ca6:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 ca9:	8b 45 08             	mov    0x8(%ebp),%eax
 cac:	8b 00                	mov    (%eax),%eax
 cae:	8d 50 01             	lea    0x1(%eax),%edx
 cb1:	8b 45 08             	mov    0x8(%ebp),%eax
 cb4:	89 10                	mov    %edx,(%eax)
}
 cb6:	c9                   	leave  
 cb7:	c3                   	ret    

00000cb8 <empty_q>:

int empty_q(struct queue *q){
 cb8:	55                   	push   %ebp
 cb9:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 cbb:	8b 45 08             	mov    0x8(%ebp),%eax
 cbe:	8b 00                	mov    (%eax),%eax
 cc0:	85 c0                	test   %eax,%eax
 cc2:	75 07                	jne    ccb <empty_q+0x13>
        return 1;
 cc4:	b8 01 00 00 00       	mov    $0x1,%eax
 cc9:	eb 05                	jmp    cd0 <empty_q+0x18>
    else
        return 0;
 ccb:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 cd0:	5d                   	pop    %ebp
 cd1:	c3                   	ret    

00000cd2 <pop_q>:
int pop_q(struct queue *q){
 cd2:	55                   	push   %ebp
 cd3:	89 e5                	mov    %esp,%ebp
 cd5:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 cd8:	8b 45 08             	mov    0x8(%ebp),%eax
 cdb:	89 04 24             	mov    %eax,(%esp)
 cde:	e8 d5 ff ff ff       	call   cb8 <empty_q>
 ce3:	85 c0                	test   %eax,%eax
 ce5:	75 5d                	jne    d44 <pop_q+0x72>
       val = q->head->value; 
 ce7:	8b 45 08             	mov    0x8(%ebp),%eax
 cea:	8b 40 04             	mov    0x4(%eax),%eax
 ced:	8b 00                	mov    (%eax),%eax
 cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
 cf2:	8b 45 08             	mov    0x8(%ebp),%eax
 cf5:	8b 40 04             	mov    0x4(%eax),%eax
 cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
 cfb:	8b 45 08             	mov    0x8(%ebp),%eax
 cfe:	8b 40 04             	mov    0x4(%eax),%eax
 d01:	8b 50 04             	mov    0x4(%eax),%edx
 d04:	8b 45 08             	mov    0x8(%ebp),%eax
 d07:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d0d:	89 04 24             	mov    %eax,(%esp)
 d10:	e8 46 fb ff ff       	call   85b <free>
       q->size--;
 d15:	8b 45 08             	mov    0x8(%ebp),%eax
 d18:	8b 00                	mov    (%eax),%eax
 d1a:	8d 50 ff             	lea    -0x1(%eax),%edx
 d1d:	8b 45 08             	mov    0x8(%ebp),%eax
 d20:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 d22:	8b 45 08             	mov    0x8(%ebp),%eax
 d25:	8b 00                	mov    (%eax),%eax
 d27:	85 c0                	test   %eax,%eax
 d29:	75 14                	jne    d3f <pop_q+0x6d>
            q->head = 0;
 d2b:	8b 45 08             	mov    0x8(%ebp),%eax
 d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 d35:	8b 45 08             	mov    0x8(%ebp),%eax
 d38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d42:	eb 05                	jmp    d49 <pop_q+0x77>
    }
    return -1;
 d44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 d49:	c9                   	leave  
 d4a:	c3                   	ret    
