
_test1:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

int n = 1;

void test_func(void *arg_ptr);

int main(int argc, char *argv[]){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp


   int pid = fork();
    1009:	e8 e2 04 00 00       	call   14f0 <fork>
    100e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid == 0){
    1012:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1017:	0f 85 44 01 00 00    	jne    1161 <main+0x161>
        void *tid = thread_create(test_func,(void *)0);
    101d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1024:	00 
    1025:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    102c:	e8 a6 0a 00 00       	call   1ad7 <thread_create>
    1031:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
    1035:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    103a:	75 19                	jne    1055 <main+0x55>
            printf(1,"thread_create fails\n");
    103c:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    1043:	00 
    1044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104b:	e8 58 06 00 00       	call   16a8 <printf>
            exit();
    1050:	e8 a3 04 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    1055:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    105c:	00 
    105d:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    1064:	e8 6e 0a 00 00       	call   1ad7 <thread_create>
    1069:	89 44 24 18          	mov    %eax,0x18(%esp)
        if(tid == 0){
    106d:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    1072:	75 19                	jne    108d <main+0x8d>
            printf(1,"thread_create fails\n");
    1074:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    107b:	00 
    107c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1083:	e8 20 06 00 00       	call   16a8 <printf>
            exit();
    1088:	e8 6b 04 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    108d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1094:	00 
    1095:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    109c:	e8 36 0a 00 00       	call   1ad7 <thread_create>
    10a1:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
    10a5:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10aa:	75 19                	jne    10c5 <main+0xc5>
            printf(1,"thread_create fails\n");
    10ac:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    10b3:	00 
    10b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10bb:	e8 e8 05 00 00       	call   16a8 <printf>
            exit();
    10c0:	e8 33 04 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    10c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10cc:	00 
    10cd:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    10d4:	e8 fe 09 00 00       	call   1ad7 <thread_create>
    10d9:	89 44 24 18          	mov    %eax,0x18(%esp)
          if(tid == 0){
    10dd:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10e2:	75 19                	jne    10fd <main+0xfd>
            printf(1,"thread_create fails\n");
    10e4:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    10eb:	00 
    10ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f3:	e8 b0 05 00 00       	call   16a8 <printf>
            exit();
    10f8:	e8 fb 03 00 00       	call   14f8 <exit>
        }
       tid = thread_create(test_func,(void *)0);
    10fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1104:	00 
    1105:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    110c:	e8 c6 09 00 00       	call   1ad7 <thread_create>
    1111:	89 44 24 18          	mov    %eax,0x18(%esp)
           if(tid == 0){
    1115:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    111a:	75 19                	jne    1135 <main+0x135>
            printf(1,"thread_create fails\n");
    111c:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    1123:	00 
    1124:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112b:	e8 78 05 00 00       	call   16a8 <printf>
            exit();
    1130:	e8 c3 03 00 00       	call   14f8 <exit>
        }
      while(wait()>=0);
    1135:	90                   	nop
    1136:	e8 c5 03 00 00       	call   1500 <wait>
    113b:	85 c0                	test   %eax,%eax
    113d:	79 f7                	jns    1136 <main+0x136>
        printf(1,"I am child, [6] n = %d\n",n);
    113f:	a1 60 22 00 00       	mov    0x2260,%eax
    1144:	89 44 24 08          	mov    %eax,0x8(%esp)
    1148:	c7 44 24 04 01 1e 00 	movl   $0x1e01,0x4(%esp)
    114f:	00 
    1150:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1157:	e8 4c 05 00 00       	call   16a8 <printf>
    115c:	e9 12 01 00 00       	jmp    1273 <main+0x273>
    }else if(pid > 0){
    1161:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1166:	0f 8e 07 01 00 00    	jle    1273 <main+0x273>
        void *tid = thread_create(test_func,(void *)0);
    116c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1173:	00 
    1174:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    117b:	e8 57 09 00 00       	call   1ad7 <thread_create>
    1180:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
    1184:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    1189:	75 19                	jne    11a4 <main+0x1a4>
            printf(1,"thread_create fails\n");
    118b:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    1192:	00 
    1193:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    119a:	e8 09 05 00 00       	call   16a8 <printf>
            exit();
    119f:	e8 54 03 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    11a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11ab:	00 
    11ac:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    11b3:	e8 1f 09 00 00       	call   1ad7 <thread_create>
    11b8:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
    11bc:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    11c1:	75 19                	jne    11dc <main+0x1dc>
            printf(1,"thread_create fails\n");
    11c3:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    11ca:	00 
    11cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11d2:	e8 d1 04 00 00       	call   16a8 <printf>
            exit();
    11d7:	e8 1c 03 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    11dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11e3:	00 
    11e4:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    11eb:	e8 e7 08 00 00       	call   1ad7 <thread_create>
    11f0:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
    11f4:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    11f9:	75 19                	jne    1214 <main+0x214>
            printf(1,"thread_create fails\n");
    11fb:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    1202:	00 
    1203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    120a:	e8 99 04 00 00       	call   16a8 <printf>
            exit();
    120f:	e8 e4 02 00 00       	call   14f8 <exit>
        }
        tid = thread_create(test_func,(void *)0);
    1214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    121b:	00 
    121c:	c7 04 24 78 12 00 00 	movl   $0x1278,(%esp)
    1223:	e8 af 08 00 00       	call   1ad7 <thread_create>
    1228:	89 44 24 14          	mov    %eax,0x14(%esp)
         if(tid == 0){
    122c:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    1231:	75 19                	jne    124c <main+0x24c>
            printf(1,"thread_create fails\n");
    1233:	c7 44 24 04 ec 1d 00 	movl   $0x1dec,0x4(%esp)
    123a:	00 
    123b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1242:	e8 61 04 00 00       	call   16a8 <printf>
            exit();
    1247:	e8 ac 02 00 00       	call   14f8 <exit>
        }
        while(wait()>=0);
    124c:	90                   	nop
    124d:	e8 ae 02 00 00       	call   1500 <wait>
    1252:	85 c0                	test   %eax,%eax
    1254:	79 f7                	jns    124d <main+0x24d>
        printf(1,"I am parent, [5] n = %d\n",n);
    1256:	a1 60 22 00 00       	mov    0x2260,%eax
    125b:	89 44 24 08          	mov    %eax,0x8(%esp)
    125f:	c7 44 24 04 19 1e 00 	movl   $0x1e19,0x4(%esp)
    1266:	00 
    1267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    126e:	e8 35 04 00 00       	call   16a8 <printf>
    }

   exit();
    1273:	e8 80 02 00 00       	call   14f8 <exit>

00001278 <test_func>:
}

void test_func(void *arg_ptr){
    1278:	55                   	push   %ebp
    1279:	89 e5                	mov    %esp,%ebp
    127b:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
    127e:	a1 60 22 00 00       	mov    0x2260,%eax
    1283:	83 c0 01             	add    $0x1,%eax
    1286:	a3 60 22 00 00       	mov    %eax,0x2260
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
    128b:	e8 10 03 00 00       	call   15a0 <texit>

00001290 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	57                   	push   %edi
    1294:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1295:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1298:	8b 55 10             	mov    0x10(%ebp),%edx
    129b:	8b 45 0c             	mov    0xc(%ebp),%eax
    129e:	89 cb                	mov    %ecx,%ebx
    12a0:	89 df                	mov    %ebx,%edi
    12a2:	89 d1                	mov    %edx,%ecx
    12a4:	fc                   	cld    
    12a5:	f3 aa                	rep stos %al,%es:(%edi)
    12a7:	89 ca                	mov    %ecx,%edx
    12a9:	89 fb                	mov    %edi,%ebx
    12ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
    12ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12b1:	5b                   	pop    %ebx
    12b2:	5f                   	pop    %edi
    12b3:	5d                   	pop    %ebp
    12b4:	c3                   	ret    

000012b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12b5:	55                   	push   %ebp
    12b6:	89 e5                	mov    %esp,%ebp
    12b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    12bb:	8b 45 08             	mov    0x8(%ebp),%eax
    12be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    12c1:	90                   	nop
    12c2:	8b 45 08             	mov    0x8(%ebp),%eax
    12c5:	8d 50 01             	lea    0x1(%eax),%edx
    12c8:	89 55 08             	mov    %edx,0x8(%ebp)
    12cb:	8b 55 0c             	mov    0xc(%ebp),%edx
    12ce:	8d 4a 01             	lea    0x1(%edx),%ecx
    12d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    12d4:	0f b6 12             	movzbl (%edx),%edx
    12d7:	88 10                	mov    %dl,(%eax)
    12d9:	0f b6 00             	movzbl (%eax),%eax
    12dc:	84 c0                	test   %al,%al
    12de:	75 e2                	jne    12c2 <strcpy+0xd>
    ;
  return os;
    12e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    12e8:	eb 08                	jmp    12f2 <strcmp+0xd>
    p++, q++;
    12ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    12f2:	8b 45 08             	mov    0x8(%ebp),%eax
    12f5:	0f b6 00             	movzbl (%eax),%eax
    12f8:	84 c0                	test   %al,%al
    12fa:	74 10                	je     130c <strcmp+0x27>
    12fc:	8b 45 08             	mov    0x8(%ebp),%eax
    12ff:	0f b6 10             	movzbl (%eax),%edx
    1302:	8b 45 0c             	mov    0xc(%ebp),%eax
    1305:	0f b6 00             	movzbl (%eax),%eax
    1308:	38 c2                	cmp    %al,%dl
    130a:	74 de                	je     12ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    130c:	8b 45 08             	mov    0x8(%ebp),%eax
    130f:	0f b6 00             	movzbl (%eax),%eax
    1312:	0f b6 d0             	movzbl %al,%edx
    1315:	8b 45 0c             	mov    0xc(%ebp),%eax
    1318:	0f b6 00             	movzbl (%eax),%eax
    131b:	0f b6 c0             	movzbl %al,%eax
    131e:	29 c2                	sub    %eax,%edx
    1320:	89 d0                	mov    %edx,%eax
}
    1322:	5d                   	pop    %ebp
    1323:	c3                   	ret    

00001324 <strlen>:

uint
strlen(char *s)
{
    1324:	55                   	push   %ebp
    1325:	89 e5                	mov    %esp,%ebp
    1327:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1331:	eb 04                	jmp    1337 <strlen+0x13>
    1333:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1337:	8b 55 fc             	mov    -0x4(%ebp),%edx
    133a:	8b 45 08             	mov    0x8(%ebp),%eax
    133d:	01 d0                	add    %edx,%eax
    133f:	0f b6 00             	movzbl (%eax),%eax
    1342:	84 c0                	test   %al,%al
    1344:	75 ed                	jne    1333 <strlen+0xf>
    ;
  return n;
    1346:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1349:	c9                   	leave  
    134a:	c3                   	ret    

0000134b <memset>:

void*
memset(void *dst, int c, uint n)
{
    134b:	55                   	push   %ebp
    134c:	89 e5                	mov    %esp,%ebp
    134e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1351:	8b 45 10             	mov    0x10(%ebp),%eax
    1354:	89 44 24 08          	mov    %eax,0x8(%esp)
    1358:	8b 45 0c             	mov    0xc(%ebp),%eax
    135b:	89 44 24 04          	mov    %eax,0x4(%esp)
    135f:	8b 45 08             	mov    0x8(%ebp),%eax
    1362:	89 04 24             	mov    %eax,(%esp)
    1365:	e8 26 ff ff ff       	call   1290 <stosb>
  return dst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136d:	c9                   	leave  
    136e:	c3                   	ret    

0000136f <strchr>:

char*
strchr(const char *s, char c)
{
    136f:	55                   	push   %ebp
    1370:	89 e5                	mov    %esp,%ebp
    1372:	83 ec 04             	sub    $0x4,%esp
    1375:	8b 45 0c             	mov    0xc(%ebp),%eax
    1378:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    137b:	eb 14                	jmp    1391 <strchr+0x22>
    if(*s == c)
    137d:	8b 45 08             	mov    0x8(%ebp),%eax
    1380:	0f b6 00             	movzbl (%eax),%eax
    1383:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1386:	75 05                	jne    138d <strchr+0x1e>
      return (char*)s;
    1388:	8b 45 08             	mov    0x8(%ebp),%eax
    138b:	eb 13                	jmp    13a0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    138d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1391:	8b 45 08             	mov    0x8(%ebp),%eax
    1394:	0f b6 00             	movzbl (%eax),%eax
    1397:	84 c0                	test   %al,%al
    1399:	75 e2                	jne    137d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13a0:	c9                   	leave  
    13a1:	c3                   	ret    

000013a2 <gets>:

char*
gets(char *buf, int max)
{
    13a2:	55                   	push   %ebp
    13a3:	89 e5                	mov    %esp,%ebp
    13a5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13af:	eb 4c                	jmp    13fd <gets+0x5b>
    cc = read(0, &c, 1);
    13b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b8:	00 
    13b9:	8d 45 ef             	lea    -0x11(%ebp),%eax
    13bc:	89 44 24 04          	mov    %eax,0x4(%esp)
    13c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    13c7:	e8 44 01 00 00       	call   1510 <read>
    13cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    13cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13d3:	7f 02                	jg     13d7 <gets+0x35>
      break;
    13d5:	eb 31                	jmp    1408 <gets+0x66>
    buf[i++] = c;
    13d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13da:	8d 50 01             	lea    0x1(%eax),%edx
    13dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13e0:	89 c2                	mov    %eax,%edx
    13e2:	8b 45 08             	mov    0x8(%ebp),%eax
    13e5:	01 c2                	add    %eax,%edx
    13e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13eb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    13ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13f1:	3c 0a                	cmp    $0xa,%al
    13f3:	74 13                	je     1408 <gets+0x66>
    13f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    13f9:	3c 0d                	cmp    $0xd,%al
    13fb:	74 0b                	je     1408 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1400:	83 c0 01             	add    $0x1,%eax
    1403:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1406:	7c a9                	jl     13b1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1408:	8b 55 f4             	mov    -0xc(%ebp),%edx
    140b:	8b 45 08             	mov    0x8(%ebp),%eax
    140e:	01 d0                	add    %edx,%eax
    1410:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1413:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1416:	c9                   	leave  
    1417:	c3                   	ret    

00001418 <stat>:

int
stat(char *n, struct stat *st)
{
    1418:	55                   	push   %ebp
    1419:	89 e5                	mov    %esp,%ebp
    141b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    141e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1425:	00 
    1426:	8b 45 08             	mov    0x8(%ebp),%eax
    1429:	89 04 24             	mov    %eax,(%esp)
    142c:	e8 07 01 00 00       	call   1538 <open>
    1431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1438:	79 07                	jns    1441 <stat+0x29>
    return -1;
    143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    143f:	eb 23                	jmp    1464 <stat+0x4c>
  r = fstat(fd, st);
    1441:	8b 45 0c             	mov    0xc(%ebp),%eax
    1444:	89 44 24 04          	mov    %eax,0x4(%esp)
    1448:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144b:	89 04 24             	mov    %eax,(%esp)
    144e:	e8 fd 00 00 00       	call   1550 <fstat>
    1453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1456:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1459:	89 04 24             	mov    %eax,(%esp)
    145c:	e8 bf 00 00 00       	call   1520 <close>
  return r;
    1461:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1464:	c9                   	leave  
    1465:	c3                   	ret    

00001466 <atoi>:

int
atoi(const char *s)
{
    1466:	55                   	push   %ebp
    1467:	89 e5                	mov    %esp,%ebp
    1469:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    146c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1473:	eb 25                	jmp    149a <atoi+0x34>
    n = n*10 + *s++ - '0';
    1475:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1478:	89 d0                	mov    %edx,%eax
    147a:	c1 e0 02             	shl    $0x2,%eax
    147d:	01 d0                	add    %edx,%eax
    147f:	01 c0                	add    %eax,%eax
    1481:	89 c1                	mov    %eax,%ecx
    1483:	8b 45 08             	mov    0x8(%ebp),%eax
    1486:	8d 50 01             	lea    0x1(%eax),%edx
    1489:	89 55 08             	mov    %edx,0x8(%ebp)
    148c:	0f b6 00             	movzbl (%eax),%eax
    148f:	0f be c0             	movsbl %al,%eax
    1492:	01 c8                	add    %ecx,%eax
    1494:	83 e8 30             	sub    $0x30,%eax
    1497:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    149a:	8b 45 08             	mov    0x8(%ebp),%eax
    149d:	0f b6 00             	movzbl (%eax),%eax
    14a0:	3c 2f                	cmp    $0x2f,%al
    14a2:	7e 0a                	jle    14ae <atoi+0x48>
    14a4:	8b 45 08             	mov    0x8(%ebp),%eax
    14a7:	0f b6 00             	movzbl (%eax),%eax
    14aa:	3c 39                	cmp    $0x39,%al
    14ac:	7e c7                	jle    1475 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    14ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14b1:	c9                   	leave  
    14b2:	c3                   	ret    

000014b3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14b3:	55                   	push   %ebp
    14b4:	89 e5                	mov    %esp,%ebp
    14b6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    14b9:	8b 45 08             	mov    0x8(%ebp),%eax
    14bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    14bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    14c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    14c5:	eb 17                	jmp    14de <memmove+0x2b>
    *dst++ = *src++;
    14c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14ca:	8d 50 01             	lea    0x1(%eax),%edx
    14cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
    14d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    14d3:	8d 4a 01             	lea    0x1(%edx),%ecx
    14d6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    14d9:	0f b6 12             	movzbl (%edx),%edx
    14dc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    14de:	8b 45 10             	mov    0x10(%ebp),%eax
    14e1:	8d 50 ff             	lea    -0x1(%eax),%edx
    14e4:	89 55 10             	mov    %edx,0x10(%ebp)
    14e7:	85 c0                	test   %eax,%eax
    14e9:	7f dc                	jg     14c7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    14eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14ee:	c9                   	leave  
    14ef:	c3                   	ret    

000014f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    14f0:	b8 01 00 00 00       	mov    $0x1,%eax
    14f5:	cd 40                	int    $0x40
    14f7:	c3                   	ret    

000014f8 <exit>:
SYSCALL(exit)
    14f8:	b8 02 00 00 00       	mov    $0x2,%eax
    14fd:	cd 40                	int    $0x40
    14ff:	c3                   	ret    

00001500 <wait>:
SYSCALL(wait)
    1500:	b8 03 00 00 00       	mov    $0x3,%eax
    1505:	cd 40                	int    $0x40
    1507:	c3                   	ret    

00001508 <pipe>:
SYSCALL(pipe)
    1508:	b8 04 00 00 00       	mov    $0x4,%eax
    150d:	cd 40                	int    $0x40
    150f:	c3                   	ret    

00001510 <read>:
SYSCALL(read)
    1510:	b8 05 00 00 00       	mov    $0x5,%eax
    1515:	cd 40                	int    $0x40
    1517:	c3                   	ret    

00001518 <write>:
SYSCALL(write)
    1518:	b8 10 00 00 00       	mov    $0x10,%eax
    151d:	cd 40                	int    $0x40
    151f:	c3                   	ret    

00001520 <close>:
SYSCALL(close)
    1520:	b8 15 00 00 00       	mov    $0x15,%eax
    1525:	cd 40                	int    $0x40
    1527:	c3                   	ret    

00001528 <kill>:
SYSCALL(kill)
    1528:	b8 06 00 00 00       	mov    $0x6,%eax
    152d:	cd 40                	int    $0x40
    152f:	c3                   	ret    

00001530 <exec>:
SYSCALL(exec)
    1530:	b8 07 00 00 00       	mov    $0x7,%eax
    1535:	cd 40                	int    $0x40
    1537:	c3                   	ret    

00001538 <open>:
SYSCALL(open)
    1538:	b8 0f 00 00 00       	mov    $0xf,%eax
    153d:	cd 40                	int    $0x40
    153f:	c3                   	ret    

00001540 <mknod>:
SYSCALL(mknod)
    1540:	b8 11 00 00 00       	mov    $0x11,%eax
    1545:	cd 40                	int    $0x40
    1547:	c3                   	ret    

00001548 <unlink>:
SYSCALL(unlink)
    1548:	b8 12 00 00 00       	mov    $0x12,%eax
    154d:	cd 40                	int    $0x40
    154f:	c3                   	ret    

00001550 <fstat>:
SYSCALL(fstat)
    1550:	b8 08 00 00 00       	mov    $0x8,%eax
    1555:	cd 40                	int    $0x40
    1557:	c3                   	ret    

00001558 <link>:
SYSCALL(link)
    1558:	b8 13 00 00 00       	mov    $0x13,%eax
    155d:	cd 40                	int    $0x40
    155f:	c3                   	ret    

00001560 <mkdir>:
SYSCALL(mkdir)
    1560:	b8 14 00 00 00       	mov    $0x14,%eax
    1565:	cd 40                	int    $0x40
    1567:	c3                   	ret    

00001568 <chdir>:
SYSCALL(chdir)
    1568:	b8 09 00 00 00       	mov    $0x9,%eax
    156d:	cd 40                	int    $0x40
    156f:	c3                   	ret    

00001570 <dup>:
SYSCALL(dup)
    1570:	b8 0a 00 00 00       	mov    $0xa,%eax
    1575:	cd 40                	int    $0x40
    1577:	c3                   	ret    

00001578 <getpid>:
SYSCALL(getpid)
    1578:	b8 0b 00 00 00       	mov    $0xb,%eax
    157d:	cd 40                	int    $0x40
    157f:	c3                   	ret    

00001580 <sbrk>:
SYSCALL(sbrk)
    1580:	b8 0c 00 00 00       	mov    $0xc,%eax
    1585:	cd 40                	int    $0x40
    1587:	c3                   	ret    

00001588 <sleep>:
SYSCALL(sleep)
    1588:	b8 0d 00 00 00       	mov    $0xd,%eax
    158d:	cd 40                	int    $0x40
    158f:	c3                   	ret    

00001590 <uptime>:
SYSCALL(uptime)
    1590:	b8 0e 00 00 00       	mov    $0xe,%eax
    1595:	cd 40                	int    $0x40
    1597:	c3                   	ret    

00001598 <clone>:
SYSCALL(clone)
    1598:	b8 16 00 00 00       	mov    $0x16,%eax
    159d:	cd 40                	int    $0x40
    159f:	c3                   	ret    

000015a0 <texit>:
SYSCALL(texit)
    15a0:	b8 17 00 00 00       	mov    $0x17,%eax
    15a5:	cd 40                	int    $0x40
    15a7:	c3                   	ret    

000015a8 <tsleep>:
SYSCALL(tsleep)
    15a8:	b8 18 00 00 00       	mov    $0x18,%eax
    15ad:	cd 40                	int    $0x40
    15af:	c3                   	ret    

000015b0 <twakeup>:
SYSCALL(twakeup)
    15b0:	b8 19 00 00 00       	mov    $0x19,%eax
    15b5:	cd 40                	int    $0x40
    15b7:	c3                   	ret    

000015b8 <thread_yield>:
SYSCALL(thread_yield)
    15b8:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15bd:	cd 40                	int    $0x40
    15bf:	c3                   	ret    

000015c0 <thread_yield3>:
    15c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
    15c5:	cd 40                	int    $0x40
    15c7:	c3                   	ret    

000015c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    15c8:	55                   	push   %ebp
    15c9:	89 e5                	mov    %esp,%ebp
    15cb:	83 ec 18             	sub    $0x18,%esp
    15ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    15d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    15d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15db:	00 
    15dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    15df:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e3:	8b 45 08             	mov    0x8(%ebp),%eax
    15e6:	89 04 24             	mov    %eax,(%esp)
    15e9:	e8 2a ff ff ff       	call   1518 <write>
}
    15ee:	c9                   	leave  
    15ef:	c3                   	ret    

000015f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    15f0:	55                   	push   %ebp
    15f1:	89 e5                	mov    %esp,%ebp
    15f3:	56                   	push   %esi
    15f4:	53                   	push   %ebx
    15f5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    15f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    15ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1603:	74 17                	je     161c <printint+0x2c>
    1605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1609:	79 11                	jns    161c <printint+0x2c>
    neg = 1;
    160b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1612:	8b 45 0c             	mov    0xc(%ebp),%eax
    1615:	f7 d8                	neg    %eax
    1617:	89 45 ec             	mov    %eax,-0x14(%ebp)
    161a:	eb 06                	jmp    1622 <printint+0x32>
  } else {
    x = xx;
    161c:	8b 45 0c             	mov    0xc(%ebp),%eax
    161f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1629:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    162c:	8d 41 01             	lea    0x1(%ecx),%eax
    162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1632:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1635:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1638:	ba 00 00 00 00       	mov    $0x0,%edx
    163d:	f7 f3                	div    %ebx
    163f:	89 d0                	mov    %edx,%eax
    1641:	0f b6 80 64 22 00 00 	movzbl 0x2264(%eax),%eax
    1648:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    164c:	8b 75 10             	mov    0x10(%ebp),%esi
    164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1652:	ba 00 00 00 00       	mov    $0x0,%edx
    1657:	f7 f6                	div    %esi
    1659:	89 45 ec             	mov    %eax,-0x14(%ebp)
    165c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1660:	75 c7                	jne    1629 <printint+0x39>
  if(neg)
    1662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1666:	74 10                	je     1678 <printint+0x88>
    buf[i++] = '-';
    1668:	8b 45 f4             	mov    -0xc(%ebp),%eax
    166b:	8d 50 01             	lea    0x1(%eax),%edx
    166e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1671:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1676:	eb 1f                	jmp    1697 <printint+0xa7>
    1678:	eb 1d                	jmp    1697 <printint+0xa7>
    putc(fd, buf[i]);
    167a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1680:	01 d0                	add    %edx,%eax
    1682:	0f b6 00             	movzbl (%eax),%eax
    1685:	0f be c0             	movsbl %al,%eax
    1688:	89 44 24 04          	mov    %eax,0x4(%esp)
    168c:	8b 45 08             	mov    0x8(%ebp),%eax
    168f:	89 04 24             	mov    %eax,(%esp)
    1692:	e8 31 ff ff ff       	call   15c8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1697:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    169b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    169f:	79 d9                	jns    167a <printint+0x8a>
    putc(fd, buf[i]);
}
    16a1:	83 c4 30             	add    $0x30,%esp
    16a4:	5b                   	pop    %ebx
    16a5:	5e                   	pop    %esi
    16a6:	5d                   	pop    %ebp
    16a7:	c3                   	ret    

000016a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    16a8:	55                   	push   %ebp
    16a9:	89 e5                	mov    %esp,%ebp
    16ab:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    16ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    16b5:	8d 45 0c             	lea    0xc(%ebp),%eax
    16b8:	83 c0 04             	add    $0x4,%eax
    16bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    16be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    16c5:	e9 7c 01 00 00       	jmp    1846 <printf+0x19e>
    c = fmt[i] & 0xff;
    16ca:	8b 55 0c             	mov    0xc(%ebp),%edx
    16cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d0:	01 d0                	add    %edx,%eax
    16d2:	0f b6 00             	movzbl (%eax),%eax
    16d5:	0f be c0             	movsbl %al,%eax
    16d8:	25 ff 00 00 00       	and    $0xff,%eax
    16dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    16e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16e4:	75 2c                	jne    1712 <printf+0x6a>
      if(c == '%'){
    16e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16ea:	75 0c                	jne    16f8 <printf+0x50>
        state = '%';
    16ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    16f3:	e9 4a 01 00 00       	jmp    1842 <printf+0x19a>
      } else {
        putc(fd, c);
    16f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16fb:	0f be c0             	movsbl %al,%eax
    16fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1702:	8b 45 08             	mov    0x8(%ebp),%eax
    1705:	89 04 24             	mov    %eax,(%esp)
    1708:	e8 bb fe ff ff       	call   15c8 <putc>
    170d:	e9 30 01 00 00       	jmp    1842 <printf+0x19a>
      }
    } else if(state == '%'){
    1712:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1716:	0f 85 26 01 00 00    	jne    1842 <printf+0x19a>
      if(c == 'd'){
    171c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1720:	75 2d                	jne    174f <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1722:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1725:	8b 00                	mov    (%eax),%eax
    1727:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    172e:	00 
    172f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1736:	00 
    1737:	89 44 24 04          	mov    %eax,0x4(%esp)
    173b:	8b 45 08             	mov    0x8(%ebp),%eax
    173e:	89 04 24             	mov    %eax,(%esp)
    1741:	e8 aa fe ff ff       	call   15f0 <printint>
        ap++;
    1746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    174a:	e9 ec 00 00 00       	jmp    183b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    174f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1753:	74 06                	je     175b <printf+0xb3>
    1755:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1759:	75 2d                	jne    1788 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    175b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    175e:	8b 00                	mov    (%eax),%eax
    1760:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1767:	00 
    1768:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    176f:	00 
    1770:	89 44 24 04          	mov    %eax,0x4(%esp)
    1774:	8b 45 08             	mov    0x8(%ebp),%eax
    1777:	89 04 24             	mov    %eax,(%esp)
    177a:	e8 71 fe ff ff       	call   15f0 <printint>
        ap++;
    177f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1783:	e9 b3 00 00 00       	jmp    183b <printf+0x193>
      } else if(c == 's'){
    1788:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    178c:	75 45                	jne    17d3 <printf+0x12b>
        s = (char*)*ap;
    178e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1791:	8b 00                	mov    (%eax),%eax
    1793:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1796:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    179a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    179e:	75 09                	jne    17a9 <printf+0x101>
          s = "(null)";
    17a0:	c7 45 f4 32 1e 00 00 	movl   $0x1e32,-0xc(%ebp)
        while(*s != 0){
    17a7:	eb 1e                	jmp    17c7 <printf+0x11f>
    17a9:	eb 1c                	jmp    17c7 <printf+0x11f>
          putc(fd, *s);
    17ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ae:	0f b6 00             	movzbl (%eax),%eax
    17b1:	0f be c0             	movsbl %al,%eax
    17b4:	89 44 24 04          	mov    %eax,0x4(%esp)
    17b8:	8b 45 08             	mov    0x8(%ebp),%eax
    17bb:	89 04 24             	mov    %eax,(%esp)
    17be:	e8 05 fe ff ff       	call   15c8 <putc>
          s++;
    17c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    17c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ca:	0f b6 00             	movzbl (%eax),%eax
    17cd:	84 c0                	test   %al,%al
    17cf:	75 da                	jne    17ab <printf+0x103>
    17d1:	eb 68                	jmp    183b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    17d3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    17d7:	75 1d                	jne    17f6 <printf+0x14e>
        putc(fd, *ap);
    17d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17dc:	8b 00                	mov    (%eax),%eax
    17de:	0f be c0             	movsbl %al,%eax
    17e1:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e5:	8b 45 08             	mov    0x8(%ebp),%eax
    17e8:	89 04 24             	mov    %eax,(%esp)
    17eb:	e8 d8 fd ff ff       	call   15c8 <putc>
        ap++;
    17f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17f4:	eb 45                	jmp    183b <printf+0x193>
      } else if(c == '%'){
    17f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17fa:	75 17                	jne    1813 <printf+0x16b>
        putc(fd, c);
    17fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17ff:	0f be c0             	movsbl %al,%eax
    1802:	89 44 24 04          	mov    %eax,0x4(%esp)
    1806:	8b 45 08             	mov    0x8(%ebp),%eax
    1809:	89 04 24             	mov    %eax,(%esp)
    180c:	e8 b7 fd ff ff       	call   15c8 <putc>
    1811:	eb 28                	jmp    183b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1813:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    181a:	00 
    181b:	8b 45 08             	mov    0x8(%ebp),%eax
    181e:	89 04 24             	mov    %eax,(%esp)
    1821:	e8 a2 fd ff ff       	call   15c8 <putc>
        putc(fd, c);
    1826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1829:	0f be c0             	movsbl %al,%eax
    182c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1830:	8b 45 08             	mov    0x8(%ebp),%eax
    1833:	89 04 24             	mov    %eax,(%esp)
    1836:	e8 8d fd ff ff       	call   15c8 <putc>
      }
      state = 0;
    183b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1842:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1846:	8b 55 0c             	mov    0xc(%ebp),%edx
    1849:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184c:	01 d0                	add    %edx,%eax
    184e:	0f b6 00             	movzbl (%eax),%eax
    1851:	84 c0                	test   %al,%al
    1853:	0f 85 71 fe ff ff    	jne    16ca <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1859:	c9                   	leave  
    185a:	c3                   	ret    

0000185b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    185b:	55                   	push   %ebp
    185c:	89 e5                	mov    %esp,%ebp
    185e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1861:	8b 45 08             	mov    0x8(%ebp),%eax
    1864:	83 e8 08             	sub    $0x8,%eax
    1867:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    186a:	a1 84 22 00 00       	mov    0x2284,%eax
    186f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1872:	eb 24                	jmp    1898 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1874:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1877:	8b 00                	mov    (%eax),%eax
    1879:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    187c:	77 12                	ja     1890 <free+0x35>
    187e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1881:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1884:	77 24                	ja     18aa <free+0x4f>
    1886:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1889:	8b 00                	mov    (%eax),%eax
    188b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    188e:	77 1a                	ja     18aa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1890:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1893:	8b 00                	mov    (%eax),%eax
    1895:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1898:	8b 45 f8             	mov    -0x8(%ebp),%eax
    189b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    189e:	76 d4                	jbe    1874 <free+0x19>
    18a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18a3:	8b 00                	mov    (%eax),%eax
    18a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18a8:	76 ca                	jbe    1874 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    18aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ad:	8b 40 04             	mov    0x4(%eax),%eax
    18b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    18b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ba:	01 c2                	add    %eax,%edx
    18bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18bf:	8b 00                	mov    (%eax),%eax
    18c1:	39 c2                	cmp    %eax,%edx
    18c3:	75 24                	jne    18e9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    18c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18c8:	8b 50 04             	mov    0x4(%eax),%edx
    18cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ce:	8b 00                	mov    (%eax),%eax
    18d0:	8b 40 04             	mov    0x4(%eax),%eax
    18d3:	01 c2                	add    %eax,%edx
    18d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18d8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    18db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18de:	8b 00                	mov    (%eax),%eax
    18e0:	8b 10                	mov    (%eax),%edx
    18e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18e5:	89 10                	mov    %edx,(%eax)
    18e7:	eb 0a                	jmp    18f3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    18e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ec:	8b 10                	mov    (%eax),%edx
    18ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18f1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    18f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f6:	8b 40 04             	mov    0x4(%eax),%eax
    18f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1900:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1903:	01 d0                	add    %edx,%eax
    1905:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1908:	75 20                	jne    192a <free+0xcf>
    p->s.size += bp->s.size;
    190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    190d:	8b 50 04             	mov    0x4(%eax),%edx
    1910:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1913:	8b 40 04             	mov    0x4(%eax),%eax
    1916:	01 c2                	add    %eax,%edx
    1918:	8b 45 fc             	mov    -0x4(%ebp),%eax
    191b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1921:	8b 10                	mov    (%eax),%edx
    1923:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1926:	89 10                	mov    %edx,(%eax)
    1928:	eb 08                	jmp    1932 <free+0xd7>
  } else
    p->s.ptr = bp;
    192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1930:	89 10                	mov    %edx,(%eax)
  freep = p;
    1932:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1935:	a3 84 22 00 00       	mov    %eax,0x2284
}
    193a:	c9                   	leave  
    193b:	c3                   	ret    

0000193c <morecore>:

static Header*
morecore(uint nu)
{
    193c:	55                   	push   %ebp
    193d:	89 e5                	mov    %esp,%ebp
    193f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1942:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1949:	77 07                	ja     1952 <morecore+0x16>
    nu = 4096;
    194b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1952:	8b 45 08             	mov    0x8(%ebp),%eax
    1955:	c1 e0 03             	shl    $0x3,%eax
    1958:	89 04 24             	mov    %eax,(%esp)
    195b:	e8 20 fc ff ff       	call   1580 <sbrk>
    1960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1963:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1967:	75 07                	jne    1970 <morecore+0x34>
    return 0;
    1969:	b8 00 00 00 00       	mov    $0x0,%eax
    196e:	eb 22                	jmp    1992 <morecore+0x56>
  hp = (Header*)p;
    1970:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1976:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1979:	8b 55 08             	mov    0x8(%ebp),%edx
    197c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1982:	83 c0 08             	add    $0x8,%eax
    1985:	89 04 24             	mov    %eax,(%esp)
    1988:	e8 ce fe ff ff       	call   185b <free>
  return freep;
    198d:	a1 84 22 00 00       	mov    0x2284,%eax
}
    1992:	c9                   	leave  
    1993:	c3                   	ret    

00001994 <malloc>:

void*
malloc(uint nbytes)
{
    1994:	55                   	push   %ebp
    1995:	89 e5                	mov    %esp,%ebp
    1997:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    199a:	8b 45 08             	mov    0x8(%ebp),%eax
    199d:	83 c0 07             	add    $0x7,%eax
    19a0:	c1 e8 03             	shr    $0x3,%eax
    19a3:	83 c0 01             	add    $0x1,%eax
    19a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    19a9:	a1 84 22 00 00       	mov    0x2284,%eax
    19ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    19b5:	75 23                	jne    19da <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    19b7:	c7 45 f0 7c 22 00 00 	movl   $0x227c,-0x10(%ebp)
    19be:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19c1:	a3 84 22 00 00       	mov    %eax,0x2284
    19c6:	a1 84 22 00 00       	mov    0x2284,%eax
    19cb:	a3 7c 22 00 00       	mov    %eax,0x227c
    base.s.size = 0;
    19d0:	c7 05 80 22 00 00 00 	movl   $0x0,0x2280
    19d7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19da:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19dd:	8b 00                	mov    (%eax),%eax
    19df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    19e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e5:	8b 40 04             	mov    0x4(%eax),%eax
    19e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19eb:	72 4d                	jb     1a3a <malloc+0xa6>
      if(p->s.size == nunits)
    19ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19f0:	8b 40 04             	mov    0x4(%eax),%eax
    19f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19f6:	75 0c                	jne    1a04 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    19f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19fb:	8b 10                	mov    (%eax),%edx
    19fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a00:	89 10                	mov    %edx,(%eax)
    1a02:	eb 26                	jmp    1a2a <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a07:	8b 40 04             	mov    0x4(%eax),%eax
    1a0a:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1a0d:	89 c2                	mov    %eax,%edx
    1a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a12:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a18:	8b 40 04             	mov    0x4(%eax),%eax
    1a1b:	c1 e0 03             	shl    $0x3,%eax
    1a1e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a24:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a27:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a2d:	a3 84 22 00 00       	mov    %eax,0x2284
      return (void*)(p + 1);
    1a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a35:	83 c0 08             	add    $0x8,%eax
    1a38:	eb 38                	jmp    1a72 <malloc+0xde>
    }
    if(p == freep)
    1a3a:	a1 84 22 00 00       	mov    0x2284,%eax
    1a3f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1a42:	75 1b                	jne    1a5f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1a47:	89 04 24             	mov    %eax,(%esp)
    1a4a:	e8 ed fe ff ff       	call   193c <morecore>
    1a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a56:	75 07                	jne    1a5f <malloc+0xcb>
        return 0;
    1a58:	b8 00 00 00 00       	mov    $0x0,%eax
    1a5d:	eb 13                	jmp    1a72 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a68:	8b 00                	mov    (%eax),%eax
    1a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1a6d:	e9 70 ff ff ff       	jmp    19e2 <malloc+0x4e>
}
    1a72:	c9                   	leave  
    1a73:	c3                   	ret    

00001a74 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1a74:	55                   	push   %ebp
    1a75:	89 e5                	mov    %esp,%ebp
    1a77:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1a7a:	8b 55 08             	mov    0x8(%ebp),%edx
    1a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a83:	f0 87 02             	lock xchg %eax,(%edx)
    1a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1a8c:	c9                   	leave  
    1a8d:	c3                   	ret    

00001a8e <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1a8e:	55                   	push   %ebp
    1a8f:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1a91:	8b 45 08             	mov    0x8(%ebp),%eax
    1a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1a9a:	5d                   	pop    %ebp
    1a9b:	c3                   	ret    

00001a9c <lock_acquire>:
void lock_acquire(lock_t *lock){
    1a9c:	55                   	push   %ebp
    1a9d:	89 e5                	mov    %esp,%ebp
    1a9f:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1aa2:	90                   	nop
    1aa3:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1aad:	00 
    1aae:	89 04 24             	mov    %eax,(%esp)
    1ab1:	e8 be ff ff ff       	call   1a74 <xchg>
    1ab6:	85 c0                	test   %eax,%eax
    1ab8:	75 e9                	jne    1aa3 <lock_acquire+0x7>
}
    1aba:	c9                   	leave  
    1abb:	c3                   	ret    

00001abc <lock_release>:
void lock_release(lock_t *lock){
    1abc:	55                   	push   %ebp
    1abd:	89 e5                	mov    %esp,%ebp
    1abf:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1ac2:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1acc:	00 
    1acd:	89 04 24             	mov    %eax,(%esp)
    1ad0:	e8 9f ff ff ff       	call   1a74 <xchg>
}
    1ad5:	c9                   	leave  
    1ad6:	c3                   	ret    

00001ad7 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1ad7:	55                   	push   %ebp
    1ad8:	89 e5                	mov    %esp,%ebp
    1ada:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1add:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1ae4:	e8 ab fe ff ff       	call   1994 <malloc>
    1ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1af2:	0f b6 05 88 22 00 00 	movzbl 0x2288,%eax
    1af9:	84 c0                	test   %al,%al
    1afb:	75 1c                	jne    1b19 <thread_create+0x42>
        init_q(thQ2);
    1afd:	a1 90 22 00 00       	mov    0x2290,%eax
    1b02:	89 04 24             	mov    %eax,(%esp)
    1b05:	e8 cd 01 00 00       	call   1cd7 <init_q>
        inQ++;
    1b0a:	0f b6 05 88 22 00 00 	movzbl 0x2288,%eax
    1b11:	83 c0 01             	add    $0x1,%eax
    1b14:	a2 88 22 00 00       	mov    %al,0x2288
    }

    if((uint)stack % 4096){
    1b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1c:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b21:	85 c0                	test   %eax,%eax
    1b23:	74 14                	je     1b39 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b28:	25 ff 0f 00 00       	and    $0xfff,%eax
    1b2d:	89 c2                	mov    %eax,%edx
    1b2f:	b8 00 10 00 00       	mov    $0x1000,%eax
    1b34:	29 d0                	sub    %edx,%eax
    1b36:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b3d:	75 1e                	jne    1b5d <thread_create+0x86>

        printf(1,"malloc fail \n");
    1b3f:	c7 44 24 04 39 1e 00 	movl   $0x1e39,0x4(%esp)
    1b46:	00 
    1b47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b4e:	e8 55 fb ff ff       	call   16a8 <printf>
        return 0;
    1b53:	b8 00 00 00 00       	mov    $0x0,%eax
    1b58:	e9 9e 00 00 00       	jmp    1bfb <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1b60:	8b 55 08             	mov    0x8(%ebp),%edx
    1b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b66:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1b6a:	89 54 24 08          	mov    %edx,0x8(%esp)
    1b6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1b75:	00 
    1b76:	89 04 24             	mov    %eax,(%esp)
    1b79:	e8 1a fa ff ff       	call   1598 <clone>
    1b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b84:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b88:	c7 44 24 04 47 1e 00 	movl   $0x1e47,0x4(%esp)
    1b8f:	00 
    1b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b97:	e8 0c fb ff ff       	call   16a8 <printf>
    if(tid < 0){
    1b9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ba0:	79 1b                	jns    1bbd <thread_create+0xe6>
        printf(1,"clone fails\n");
    1ba2:	c7 44 24 04 60 1e 00 	movl   $0x1e60,0x4(%esp)
    1ba9:	00 
    1baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bb1:	e8 f2 fa ff ff       	call   16a8 <printf>
        return 0;
    1bb6:	b8 00 00 00 00       	mov    $0x0,%eax
    1bbb:	eb 3e                	jmp    1bfb <thread_create+0x124>
    }
    if(tid > 0){
    1bbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bc1:	7e 19                	jle    1bdc <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1bc3:	a1 90 22 00 00       	mov    0x2290,%eax
    1bc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1bcb:	89 54 24 04          	mov    %edx,0x4(%esp)
    1bcf:	89 04 24             	mov    %eax,(%esp)
    1bd2:	e8 22 01 00 00       	call   1cf9 <add_q>
        return garbage_stack;
    1bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bda:	eb 1f                	jmp    1bfb <thread_create+0x124>
    }
    if(tid == 0){
    1bdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1be0:	75 14                	jne    1bf6 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1be2:	c7 44 24 04 6d 1e 00 	movl   $0x1e6d,0x4(%esp)
    1be9:	00 
    1bea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bf1:	e8 b2 fa ff ff       	call   16a8 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1bfb:	c9                   	leave  
    1bfc:	c3                   	ret    

00001bfd <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1bfd:	55                   	push   %ebp
    1bfe:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1c00:	a1 78 22 00 00       	mov    0x2278,%eax
    1c05:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1c0b:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1c10:	a3 78 22 00 00       	mov    %eax,0x2278
    return (int)(rands % max);
    1c15:	a1 78 22 00 00       	mov    0x2278,%eax
    1c1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1c1d:	ba 00 00 00 00       	mov    $0x0,%edx
    1c22:	f7 f1                	div    %ecx
    1c24:	89 d0                	mov    %edx,%eax
}
    1c26:	5d                   	pop    %ebp
    1c27:	c3                   	ret    

00001c28 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1c28:	55                   	push   %ebp
    1c29:	89 e5                	mov    %esp,%ebp
    1c2b:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1c2e:	e8 45 f9 ff ff       	call   1578 <getpid>
    1c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1c36:	a1 90 22 00 00       	mov    0x2290,%eax
    1c3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1c3e:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c42:	89 04 24             	mov    %eax,(%esp)
    1c45:	e8 af 00 00 00       	call   1cf9 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1c4a:	a1 90 22 00 00       	mov    0x2290,%eax
    1c4f:	89 04 24             	mov    %eax,(%esp)
    1c52:	e8 1c 01 00 00       	call   1d73 <pop_q>
    1c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1c5a:	a1 8c 22 00 00       	mov    0x228c,%eax
    1c5f:	85 c0                	test   %eax,%eax
    1c61:	75 1f                	jne    1c82 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1c63:	a1 90 22 00 00       	mov    0x2290,%eax
    1c68:	89 04 24             	mov    %eax,(%esp)
    1c6b:	e8 03 01 00 00       	call   1d73 <pop_q>
    1c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1c73:	a1 8c 22 00 00       	mov    0x228c,%eax
    1c78:	83 c0 01             	add    $0x1,%eax
    1c7b:	a3 8c 22 00 00       	mov    %eax,0x228c
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1c80:	eb 12                	jmp    1c94 <thread_yield2+0x6c>
    1c82:	eb 10                	jmp    1c94 <thread_yield2+0x6c>
    1c84:	a1 90 22 00 00       	mov    0x2290,%eax
    1c89:	89 04 24             	mov    %eax,(%esp)
    1c8c:	e8 e2 00 00 00       	call   1d73 <pop_q>
    1c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1c9a:	74 e8                	je     1c84 <thread_yield2+0x5c>
    1c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ca0:	74 e2                	je     1c84 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ca5:	89 04 24             	mov    %eax,(%esp)
    1ca8:	e8 03 f9 ff ff       	call   15b0 <twakeup>
    tsleep();
    1cad:	e8 f6 f8 ff ff       	call   15a8 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1cb2:	c9                   	leave  
    1cb3:	c3                   	ret    

00001cb4 <thread_yield_last>:

void thread_yield_last(){
    1cb4:	55                   	push   %ebp
    1cb5:	89 e5                	mov    %esp,%ebp
    1cb7:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1cba:	a1 90 22 00 00       	mov    0x2290,%eax
    1cbf:	89 04 24             	mov    %eax,(%esp)
    1cc2:	e8 ac 00 00 00       	call   1d73 <pop_q>
    1cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ccd:	89 04 24             	mov    %eax,(%esp)
    1cd0:	e8 db f8 ff ff       	call   15b0 <twakeup>
    1cd5:	c9                   	leave  
    1cd6:	c3                   	ret    

00001cd7 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1cd7:	55                   	push   %ebp
    1cd8:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1cda:	8b 45 08             	mov    0x8(%ebp),%eax
    1cdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1ce3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1ced:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1cf7:	5d                   	pop    %ebp
    1cf8:	c3                   	ret    

00001cf9 <add_q>:

void add_q(struct queue *q, int v){
    1cf9:	55                   	push   %ebp
    1cfa:	89 e5                	mov    %esp,%ebp
    1cfc:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1cff:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1d06:	e8 89 fc ff ff       	call   1994 <malloc>
    1d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d1e:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1d20:	8b 45 08             	mov    0x8(%ebp),%eax
    1d23:	8b 40 04             	mov    0x4(%eax),%eax
    1d26:	85 c0                	test   %eax,%eax
    1d28:	75 0b                	jne    1d35 <add_q+0x3c>
        q->head = n;
    1d2a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d30:	89 50 04             	mov    %edx,0x4(%eax)
    1d33:	eb 0c                	jmp    1d41 <add_q+0x48>
    }else{
        q->tail->next = n;
    1d35:	8b 45 08             	mov    0x8(%ebp),%eax
    1d38:	8b 40 08             	mov    0x8(%eax),%eax
    1d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d3e:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1d41:	8b 45 08             	mov    0x8(%ebp),%eax
    1d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d47:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1d4a:	8b 45 08             	mov    0x8(%ebp),%eax
    1d4d:	8b 00                	mov    (%eax),%eax
    1d4f:	8d 50 01             	lea    0x1(%eax),%edx
    1d52:	8b 45 08             	mov    0x8(%ebp),%eax
    1d55:	89 10                	mov    %edx,(%eax)
}
    1d57:	c9                   	leave  
    1d58:	c3                   	ret    

00001d59 <empty_q>:

int empty_q(struct queue *q){
    1d59:	55                   	push   %ebp
    1d5a:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1d5c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d5f:	8b 00                	mov    (%eax),%eax
    1d61:	85 c0                	test   %eax,%eax
    1d63:	75 07                	jne    1d6c <empty_q+0x13>
        return 1;
    1d65:	b8 01 00 00 00       	mov    $0x1,%eax
    1d6a:	eb 05                	jmp    1d71 <empty_q+0x18>
    else
        return 0;
    1d6c:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1d71:	5d                   	pop    %ebp
    1d72:	c3                   	ret    

00001d73 <pop_q>:
int pop_q(struct queue *q){
    1d73:	55                   	push   %ebp
    1d74:	89 e5                	mov    %esp,%ebp
    1d76:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1d79:	8b 45 08             	mov    0x8(%ebp),%eax
    1d7c:	89 04 24             	mov    %eax,(%esp)
    1d7f:	e8 d5 ff ff ff       	call   1d59 <empty_q>
    1d84:	85 c0                	test   %eax,%eax
    1d86:	75 5d                	jne    1de5 <pop_q+0x72>
       val = q->head->value; 
    1d88:	8b 45 08             	mov    0x8(%ebp),%eax
    1d8b:	8b 40 04             	mov    0x4(%eax),%eax
    1d8e:	8b 00                	mov    (%eax),%eax
    1d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1d93:	8b 45 08             	mov    0x8(%ebp),%eax
    1d96:	8b 40 04             	mov    0x4(%eax),%eax
    1d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1d9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d9f:	8b 40 04             	mov    0x4(%eax),%eax
    1da2:	8b 50 04             	mov    0x4(%eax),%edx
    1da5:	8b 45 08             	mov    0x8(%ebp),%eax
    1da8:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1dae:	89 04 24             	mov    %eax,(%esp)
    1db1:	e8 a5 fa ff ff       	call   185b <free>
       q->size--;
    1db6:	8b 45 08             	mov    0x8(%ebp),%eax
    1db9:	8b 00                	mov    (%eax),%eax
    1dbb:	8d 50 ff             	lea    -0x1(%eax),%edx
    1dbe:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc1:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1dc3:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc6:	8b 00                	mov    (%eax),%eax
    1dc8:	85 c0                	test   %eax,%eax
    1dca:	75 14                	jne    1de0 <pop_q+0x6d>
            q->head = 0;
    1dcc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1dd6:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1de3:	eb 05                	jmp    1dea <pop_q+0x77>
    }
    return -1;
    1de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1dea:	c9                   	leave  
    1deb:	c3                   	ret    
