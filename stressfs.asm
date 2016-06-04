
_stressfs:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
    100c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
    1013:	73 74 72 65 
    1017:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
    101e:	73 73 66 73 
    1022:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
    1029:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
    102c:	c7 44 24 04 0f 1d 00 	movl   $0x1d0f,0x4(%esp)
    1033:	00 
    1034:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103b:	e8 8b 05 00 00       	call   15cb <printf>
  memset(data, 'a', sizeof(data));
    1040:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1047:	00 
    1048:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
    104f:	00 
    1050:	8d 44 24 1e          	lea    0x1e(%esp),%eax
    1054:	89 04 24             	mov    %eax,(%esp)
    1057:	e8 12 02 00 00       	call   126e <memset>

  for(i = 0; i < 4; i++)
    105c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
    1063:	00 00 00 00 
    1067:	eb 13                	jmp    107c <main+0x7c>
    if(fork() > 0)
    1069:	e8 a5 03 00 00       	call   1413 <fork>
    106e:	85 c0                	test   %eax,%eax
    1070:	7e 02                	jle    1074 <main+0x74>
      break;
    1072:	eb 12                	jmp    1086 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
    1074:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
    107b:	01 
    107c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
    1083:	03 
    1084:	7e e3                	jle    1069 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
    1086:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
    108d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1091:	c7 44 24 04 22 1d 00 	movl   $0x1d22,0x4(%esp)
    1098:	00 
    1099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a0:	e8 26 05 00 00       	call   15cb <printf>

  path[8] += i;
    10a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
    10ac:	00 
    10ad:	89 c2                	mov    %eax,%edx
    10af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
    10b6:	01 d0                	add    %edx,%eax
    10b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
    10bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10c6:	00 
    10c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
    10ce:	89 04 24             	mov    %eax,(%esp)
    10d1:	e8 85 03 00 00       	call   145b <open>
    10d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
    10dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
    10e4:	00 00 00 00 
    10e8:	eb 27                	jmp    1111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10f1:	00 
    10f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
    10f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    10fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
    1101:	89 04 24             	mov    %eax,(%esp)
    1104:	e8 32 03 00 00       	call   143b <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
    1109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
    1110:	01 
    1111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
    1118:	13 
    1119:	7e cf                	jle    10ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
    111b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
    1122:	89 04 24             	mov    %eax,(%esp)
    1125:	e8 19 03 00 00       	call   1443 <close>

  printf(1, "read\n");
    112a:	c7 44 24 04 2c 1d 00 	movl   $0x1d2c,0x4(%esp)
    1131:	00 
    1132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1139:	e8 8d 04 00 00       	call   15cb <printf>

  fd = open(path, O_RDONLY);
    113e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1145:	00 
    1146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
    114d:	89 04 24             	mov    %eax,(%esp)
    1150:	e8 06 03 00 00       	call   145b <open>
    1155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
    115c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
    1163:	00 00 00 00 
    1167:	eb 27                	jmp    1190 <main+0x190>
    read(fd, data, sizeof(data));
    1169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1170:	00 
    1171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
    1175:	89 44 24 04          	mov    %eax,0x4(%esp)
    1179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
    1180:	89 04 24             	mov    %eax,(%esp)
    1183:	e8 ab 02 00 00       	call   1433 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
    1188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
    118f:	01 
    1190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
    1197:	13 
    1198:	7e cf                	jle    1169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
    119a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
    11a1:	89 04 24             	mov    %eax,(%esp)
    11a4:	e8 9a 02 00 00       	call   1443 <close>

  wait();
    11a9:	e8 75 02 00 00       	call   1423 <wait>
  
  exit();
    11ae:	e8 68 02 00 00       	call   141b <exit>

000011b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11b3:	55                   	push   %ebp
    11b4:	89 e5                	mov    %esp,%ebp
    11b6:	57                   	push   %edi
    11b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11bb:	8b 55 10             	mov    0x10(%ebp),%edx
    11be:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c1:	89 cb                	mov    %ecx,%ebx
    11c3:	89 df                	mov    %ebx,%edi
    11c5:	89 d1                	mov    %edx,%ecx
    11c7:	fc                   	cld    
    11c8:	f3 aa                	rep stos %al,%es:(%edi)
    11ca:	89 ca                	mov    %ecx,%edx
    11cc:	89 fb                	mov    %edi,%ebx
    11ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11d4:	5b                   	pop    %ebx
    11d5:	5f                   	pop    %edi
    11d6:	5d                   	pop    %ebp
    11d7:	c3                   	ret    

000011d8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11d8:	55                   	push   %ebp
    11d9:	89 e5                	mov    %esp,%ebp
    11db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    11e4:	90                   	nop
    11e5:	8b 45 08             	mov    0x8(%ebp),%eax
    11e8:	8d 50 01             	lea    0x1(%eax),%edx
    11eb:	89 55 08             	mov    %edx,0x8(%ebp)
    11ee:	8b 55 0c             	mov    0xc(%ebp),%edx
    11f1:	8d 4a 01             	lea    0x1(%edx),%ecx
    11f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    11f7:	0f b6 12             	movzbl (%edx),%edx
    11fa:	88 10                	mov    %dl,(%eax)
    11fc:	0f b6 00             	movzbl (%eax),%eax
    11ff:	84 c0                	test   %al,%al
    1201:	75 e2                	jne    11e5 <strcpy+0xd>
    ;
  return os;
    1203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1206:	c9                   	leave  
    1207:	c3                   	ret    

00001208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1208:	55                   	push   %ebp
    1209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    120b:	eb 08                	jmp    1215 <strcmp+0xd>
    p++, q++;
    120d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	0f b6 00             	movzbl (%eax),%eax
    121b:	84 c0                	test   %al,%al
    121d:	74 10                	je     122f <strcmp+0x27>
    121f:	8b 45 08             	mov    0x8(%ebp),%eax
    1222:	0f b6 10             	movzbl (%eax),%edx
    1225:	8b 45 0c             	mov    0xc(%ebp),%eax
    1228:	0f b6 00             	movzbl (%eax),%eax
    122b:	38 c2                	cmp    %al,%dl
    122d:	74 de                	je     120d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    122f:	8b 45 08             	mov    0x8(%ebp),%eax
    1232:	0f b6 00             	movzbl (%eax),%eax
    1235:	0f b6 d0             	movzbl %al,%edx
    1238:	8b 45 0c             	mov    0xc(%ebp),%eax
    123b:	0f b6 00             	movzbl (%eax),%eax
    123e:	0f b6 c0             	movzbl %al,%eax
    1241:	29 c2                	sub    %eax,%edx
    1243:	89 d0                	mov    %edx,%eax
}
    1245:	5d                   	pop    %ebp
    1246:	c3                   	ret    

00001247 <strlen>:

uint
strlen(char *s)
{
    1247:	55                   	push   %ebp
    1248:	89 e5                	mov    %esp,%ebp
    124a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1254:	eb 04                	jmp    125a <strlen+0x13>
    1256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    125a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    125d:	8b 45 08             	mov    0x8(%ebp),%eax
    1260:	01 d0                	add    %edx,%eax
    1262:	0f b6 00             	movzbl (%eax),%eax
    1265:	84 c0                	test   %al,%al
    1267:	75 ed                	jne    1256 <strlen+0xf>
    ;
  return n;
    1269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    126c:	c9                   	leave  
    126d:	c3                   	ret    

0000126e <memset>:

void*
memset(void *dst, int c, uint n)
{
    126e:	55                   	push   %ebp
    126f:	89 e5                	mov    %esp,%ebp
    1271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1274:	8b 45 10             	mov    0x10(%ebp),%eax
    1277:	89 44 24 08          	mov    %eax,0x8(%esp)
    127b:	8b 45 0c             	mov    0xc(%ebp),%eax
    127e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
    1285:	89 04 24             	mov    %eax,(%esp)
    1288:	e8 26 ff ff ff       	call   11b3 <stosb>
  return dst;
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1290:	c9                   	leave  
    1291:	c3                   	ret    

00001292 <strchr>:

char*
strchr(const char *s, char c)
{
    1292:	55                   	push   %ebp
    1293:	89 e5                	mov    %esp,%ebp
    1295:	83 ec 04             	sub    $0x4,%esp
    1298:	8b 45 0c             	mov    0xc(%ebp),%eax
    129b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    129e:	eb 14                	jmp    12b4 <strchr+0x22>
    if(*s == c)
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	0f b6 00             	movzbl (%eax),%eax
    12a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12a9:	75 05                	jne    12b0 <strchr+0x1e>
      return (char*)s;
    12ab:	8b 45 08             	mov    0x8(%ebp),%eax
    12ae:	eb 13                	jmp    12c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12b4:	8b 45 08             	mov    0x8(%ebp),%eax
    12b7:	0f b6 00             	movzbl (%eax),%eax
    12ba:	84 c0                	test   %al,%al
    12bc:	75 e2                	jne    12a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12be:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12c3:	c9                   	leave  
    12c4:	c3                   	ret    

000012c5 <gets>:

char*
gets(char *buf, int max)
{
    12c5:	55                   	push   %ebp
    12c6:	89 e5                	mov    %esp,%ebp
    12c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12d2:	eb 4c                	jmp    1320 <gets+0x5b>
    cc = read(0, &c, 1);
    12d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12db:	00 
    12dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12df:	89 44 24 04          	mov    %eax,0x4(%esp)
    12e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    12ea:	e8 44 01 00 00       	call   1433 <read>
    12ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    12f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12f6:	7f 02                	jg     12fa <gets+0x35>
      break;
    12f8:	eb 31                	jmp    132b <gets+0x66>
    buf[i++] = c;
    12fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12fd:	8d 50 01             	lea    0x1(%eax),%edx
    1300:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1303:	89 c2                	mov    %eax,%edx
    1305:	8b 45 08             	mov    0x8(%ebp),%eax
    1308:	01 c2                	add    %eax,%edx
    130a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    130e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1314:	3c 0a                	cmp    $0xa,%al
    1316:	74 13                	je     132b <gets+0x66>
    1318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    131c:	3c 0d                	cmp    $0xd,%al
    131e:	74 0b                	je     132b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1323:	83 c0 01             	add    $0x1,%eax
    1326:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1329:	7c a9                	jl     12d4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    132b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    132e:	8b 45 08             	mov    0x8(%ebp),%eax
    1331:	01 d0                	add    %edx,%eax
    1333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1336:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1339:	c9                   	leave  
    133a:	c3                   	ret    

0000133b <stat>:

int
stat(char *n, struct stat *st)
{
    133b:	55                   	push   %ebp
    133c:	89 e5                	mov    %esp,%ebp
    133e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1348:	00 
    1349:	8b 45 08             	mov    0x8(%ebp),%eax
    134c:	89 04 24             	mov    %eax,(%esp)
    134f:	e8 07 01 00 00       	call   145b <open>
    1354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    135b:	79 07                	jns    1364 <stat+0x29>
    return -1;
    135d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1362:	eb 23                	jmp    1387 <stat+0x4c>
  r = fstat(fd, st);
    1364:	8b 45 0c             	mov    0xc(%ebp),%eax
    1367:	89 44 24 04          	mov    %eax,0x4(%esp)
    136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136e:	89 04 24             	mov    %eax,(%esp)
    1371:	e8 fd 00 00 00       	call   1473 <fstat>
    1376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1379:	8b 45 f4             	mov    -0xc(%ebp),%eax
    137c:	89 04 24             	mov    %eax,(%esp)
    137f:	e8 bf 00 00 00       	call   1443 <close>
  return r;
    1384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1387:	c9                   	leave  
    1388:	c3                   	ret    

00001389 <atoi>:

int
atoi(const char *s)
{
    1389:	55                   	push   %ebp
    138a:	89 e5                	mov    %esp,%ebp
    138c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1396:	eb 25                	jmp    13bd <atoi+0x34>
    n = n*10 + *s++ - '0';
    1398:	8b 55 fc             	mov    -0x4(%ebp),%edx
    139b:	89 d0                	mov    %edx,%eax
    139d:	c1 e0 02             	shl    $0x2,%eax
    13a0:	01 d0                	add    %edx,%eax
    13a2:	01 c0                	add    %eax,%eax
    13a4:	89 c1                	mov    %eax,%ecx
    13a6:	8b 45 08             	mov    0x8(%ebp),%eax
    13a9:	8d 50 01             	lea    0x1(%eax),%edx
    13ac:	89 55 08             	mov    %edx,0x8(%ebp)
    13af:	0f b6 00             	movzbl (%eax),%eax
    13b2:	0f be c0             	movsbl %al,%eax
    13b5:	01 c8                	add    %ecx,%eax
    13b7:	83 e8 30             	sub    $0x30,%eax
    13ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	0f b6 00             	movzbl (%eax),%eax
    13c3:	3c 2f                	cmp    $0x2f,%al
    13c5:	7e 0a                	jle    13d1 <atoi+0x48>
    13c7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ca:	0f b6 00             	movzbl (%eax),%eax
    13cd:	3c 39                	cmp    $0x39,%al
    13cf:	7e c7                	jle    1398 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13d4:	c9                   	leave  
    13d5:	c3                   	ret    

000013d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13d6:	55                   	push   %ebp
    13d7:	89 e5                	mov    %esp,%ebp
    13d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13dc:	8b 45 08             	mov    0x8(%ebp),%eax
    13df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13e2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13e8:	eb 17                	jmp    1401 <memmove+0x2b>
    *dst++ = *src++;
    13ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13ed:	8d 50 01             	lea    0x1(%eax),%edx
    13f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13f6:	8d 4a 01             	lea    0x1(%edx),%ecx
    13f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13fc:	0f b6 12             	movzbl (%edx),%edx
    13ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1401:	8b 45 10             	mov    0x10(%ebp),%eax
    1404:	8d 50 ff             	lea    -0x1(%eax),%edx
    1407:	89 55 10             	mov    %edx,0x10(%ebp)
    140a:	85 c0                	test   %eax,%eax
    140c:	7f dc                	jg     13ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    140e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1411:	c9                   	leave  
    1412:	c3                   	ret    

00001413 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1413:	b8 01 00 00 00       	mov    $0x1,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <exit>:
SYSCALL(exit)
    141b:	b8 02 00 00 00       	mov    $0x2,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <wait>:
SYSCALL(wait)
    1423:	b8 03 00 00 00       	mov    $0x3,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <pipe>:
SYSCALL(pipe)
    142b:	b8 04 00 00 00       	mov    $0x4,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <read>:
SYSCALL(read)
    1433:	b8 05 00 00 00       	mov    $0x5,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <write>:
SYSCALL(write)
    143b:	b8 10 00 00 00       	mov    $0x10,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <close>:
SYSCALL(close)
    1443:	b8 15 00 00 00       	mov    $0x15,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <kill>:
SYSCALL(kill)
    144b:	b8 06 00 00 00       	mov    $0x6,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <exec>:
SYSCALL(exec)
    1453:	b8 07 00 00 00       	mov    $0x7,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <open>:
SYSCALL(open)
    145b:	b8 0f 00 00 00       	mov    $0xf,%eax
    1460:	cd 40                	int    $0x40
    1462:	c3                   	ret    

00001463 <mknod>:
SYSCALL(mknod)
    1463:	b8 11 00 00 00       	mov    $0x11,%eax
    1468:	cd 40                	int    $0x40
    146a:	c3                   	ret    

0000146b <unlink>:
SYSCALL(unlink)
    146b:	b8 12 00 00 00       	mov    $0x12,%eax
    1470:	cd 40                	int    $0x40
    1472:	c3                   	ret    

00001473 <fstat>:
SYSCALL(fstat)
    1473:	b8 08 00 00 00       	mov    $0x8,%eax
    1478:	cd 40                	int    $0x40
    147a:	c3                   	ret    

0000147b <link>:
SYSCALL(link)
    147b:	b8 13 00 00 00       	mov    $0x13,%eax
    1480:	cd 40                	int    $0x40
    1482:	c3                   	ret    

00001483 <mkdir>:
SYSCALL(mkdir)
    1483:	b8 14 00 00 00       	mov    $0x14,%eax
    1488:	cd 40                	int    $0x40
    148a:	c3                   	ret    

0000148b <chdir>:
SYSCALL(chdir)
    148b:	b8 09 00 00 00       	mov    $0x9,%eax
    1490:	cd 40                	int    $0x40
    1492:	c3                   	ret    

00001493 <dup>:
SYSCALL(dup)
    1493:	b8 0a 00 00 00       	mov    $0xa,%eax
    1498:	cd 40                	int    $0x40
    149a:	c3                   	ret    

0000149b <getpid>:
SYSCALL(getpid)
    149b:	b8 0b 00 00 00       	mov    $0xb,%eax
    14a0:	cd 40                	int    $0x40
    14a2:	c3                   	ret    

000014a3 <sbrk>:
SYSCALL(sbrk)
    14a3:	b8 0c 00 00 00       	mov    $0xc,%eax
    14a8:	cd 40                	int    $0x40
    14aa:	c3                   	ret    

000014ab <sleep>:
SYSCALL(sleep)
    14ab:	b8 0d 00 00 00       	mov    $0xd,%eax
    14b0:	cd 40                	int    $0x40
    14b2:	c3                   	ret    

000014b3 <uptime>:
SYSCALL(uptime)
    14b3:	b8 0e 00 00 00       	mov    $0xe,%eax
    14b8:	cd 40                	int    $0x40
    14ba:	c3                   	ret    

000014bb <clone>:
SYSCALL(clone)
    14bb:	b8 16 00 00 00       	mov    $0x16,%eax
    14c0:	cd 40                	int    $0x40
    14c2:	c3                   	ret    

000014c3 <texit>:
SYSCALL(texit)
    14c3:	b8 17 00 00 00       	mov    $0x17,%eax
    14c8:	cd 40                	int    $0x40
    14ca:	c3                   	ret    

000014cb <tsleep>:
SYSCALL(tsleep)
    14cb:	b8 18 00 00 00       	mov    $0x18,%eax
    14d0:	cd 40                	int    $0x40
    14d2:	c3                   	ret    

000014d3 <twakeup>:
SYSCALL(twakeup)
    14d3:	b8 19 00 00 00       	mov    $0x19,%eax
    14d8:	cd 40                	int    $0x40
    14da:	c3                   	ret    

000014db <thread_yield>:
SYSCALL(thread_yield)
    14db:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14e0:	cd 40                	int    $0x40
    14e2:	c3                   	ret    

000014e3 <thread_yield3>:
    14e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14e8:	cd 40                	int    $0x40
    14ea:	c3                   	ret    

000014eb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14eb:	55                   	push   %ebp
    14ec:	89 e5                	mov    %esp,%ebp
    14ee:	83 ec 18             	sub    $0x18,%esp
    14f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14fe:	00 
    14ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1502:	89 44 24 04          	mov    %eax,0x4(%esp)
    1506:	8b 45 08             	mov    0x8(%ebp),%eax
    1509:	89 04 24             	mov    %eax,(%esp)
    150c:	e8 2a ff ff ff       	call   143b <write>
}
    1511:	c9                   	leave  
    1512:	c3                   	ret    

00001513 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1513:	55                   	push   %ebp
    1514:	89 e5                	mov    %esp,%ebp
    1516:	56                   	push   %esi
    1517:	53                   	push   %ebx
    1518:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    151b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1522:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1526:	74 17                	je     153f <printint+0x2c>
    1528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152c:	79 11                	jns    153f <printint+0x2c>
    neg = 1;
    152e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1535:	8b 45 0c             	mov    0xc(%ebp),%eax
    1538:	f7 d8                	neg    %eax
    153a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153d:	eb 06                	jmp    1545 <printint+0x32>
  } else {
    x = xx;
    153f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1545:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    154c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    154f:	8d 41 01             	lea    0x1(%ecx),%eax
    1552:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1555:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1558:	8b 45 ec             	mov    -0x14(%ebp),%eax
    155b:	ba 00 00 00 00       	mov    $0x0,%edx
    1560:	f7 f3                	div    %ebx
    1562:	89 d0                	mov    %edx,%eax
    1564:	0f b6 80 44 21 00 00 	movzbl 0x2144(%eax),%eax
    156b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    156f:	8b 75 10             	mov    0x10(%ebp),%esi
    1572:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1575:	ba 00 00 00 00       	mov    $0x0,%edx
    157a:	f7 f6                	div    %esi
    157c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    157f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1583:	75 c7                	jne    154c <printint+0x39>
  if(neg)
    1585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1589:	74 10                	je     159b <printint+0x88>
    buf[i++] = '-';
    158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158e:	8d 50 01             	lea    0x1(%eax),%edx
    1591:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1594:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1599:	eb 1f                	jmp    15ba <printint+0xa7>
    159b:	eb 1d                	jmp    15ba <printint+0xa7>
    putc(fd, buf[i]);
    159d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a3:	01 d0                	add    %edx,%eax
    15a5:	0f b6 00             	movzbl (%eax),%eax
    15a8:	0f be c0             	movsbl %al,%eax
    15ab:	89 44 24 04          	mov    %eax,0x4(%esp)
    15af:	8b 45 08             	mov    0x8(%ebp),%eax
    15b2:	89 04 24             	mov    %eax,(%esp)
    15b5:	e8 31 ff ff ff       	call   14eb <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c2:	79 d9                	jns    159d <printint+0x8a>
    putc(fd, buf[i]);
}
    15c4:	83 c4 30             	add    $0x30,%esp
    15c7:	5b                   	pop    %ebx
    15c8:	5e                   	pop    %esi
    15c9:	5d                   	pop    %ebp
    15ca:	c3                   	ret    

000015cb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15cb:	55                   	push   %ebp
    15cc:	89 e5                	mov    %esp,%ebp
    15ce:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d8:	8d 45 0c             	lea    0xc(%ebp),%eax
    15db:	83 c0 04             	add    $0x4,%eax
    15de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e8:	e9 7c 01 00 00       	jmp    1769 <printf+0x19e>
    c = fmt[i] & 0xff;
    15ed:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f3:	01 d0                	add    %edx,%eax
    15f5:	0f b6 00             	movzbl (%eax),%eax
    15f8:	0f be c0             	movsbl %al,%eax
    15fb:	25 ff 00 00 00       	and    $0xff,%eax
    1600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1607:	75 2c                	jne    1635 <printf+0x6a>
      if(c == '%'){
    1609:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160d:	75 0c                	jne    161b <printf+0x50>
        state = '%';
    160f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1616:	e9 4a 01 00 00       	jmp    1765 <printf+0x19a>
      } else {
        putc(fd, c);
    161b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161e:	0f be c0             	movsbl %al,%eax
    1621:	89 44 24 04          	mov    %eax,0x4(%esp)
    1625:	8b 45 08             	mov    0x8(%ebp),%eax
    1628:	89 04 24             	mov    %eax,(%esp)
    162b:	e8 bb fe ff ff       	call   14eb <putc>
    1630:	e9 30 01 00 00       	jmp    1765 <printf+0x19a>
      }
    } else if(state == '%'){
    1635:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1639:	0f 85 26 01 00 00    	jne    1765 <printf+0x19a>
      if(c == 'd'){
    163f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1643:	75 2d                	jne    1672 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1645:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1648:	8b 00                	mov    (%eax),%eax
    164a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1651:	00 
    1652:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1659:	00 
    165a:	89 44 24 04          	mov    %eax,0x4(%esp)
    165e:	8b 45 08             	mov    0x8(%ebp),%eax
    1661:	89 04 24             	mov    %eax,(%esp)
    1664:	e8 aa fe ff ff       	call   1513 <printint>
        ap++;
    1669:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    166d:	e9 ec 00 00 00       	jmp    175e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1672:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1676:	74 06                	je     167e <printf+0xb3>
    1678:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    167c:	75 2d                	jne    16ab <printf+0xe0>
        printint(fd, *ap, 16, 0);
    167e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1681:	8b 00                	mov    (%eax),%eax
    1683:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    168a:	00 
    168b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1692:	00 
    1693:	89 44 24 04          	mov    %eax,0x4(%esp)
    1697:	8b 45 08             	mov    0x8(%ebp),%eax
    169a:	89 04 24             	mov    %eax,(%esp)
    169d:	e8 71 fe ff ff       	call   1513 <printint>
        ap++;
    16a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16a6:	e9 b3 00 00 00       	jmp    175e <printf+0x193>
      } else if(c == 's'){
    16ab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16af:	75 45                	jne    16f6 <printf+0x12b>
        s = (char*)*ap;
    16b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b4:	8b 00                	mov    (%eax),%eax
    16b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16c1:	75 09                	jne    16cc <printf+0x101>
          s = "(null)";
    16c3:	c7 45 f4 32 1d 00 00 	movl   $0x1d32,-0xc(%ebp)
        while(*s != 0){
    16ca:	eb 1e                	jmp    16ea <printf+0x11f>
    16cc:	eb 1c                	jmp    16ea <printf+0x11f>
          putc(fd, *s);
    16ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16d1:	0f b6 00             	movzbl (%eax),%eax
    16d4:	0f be c0             	movsbl %al,%eax
    16d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    16db:	8b 45 08             	mov    0x8(%ebp),%eax
    16de:	89 04 24             	mov    %eax,(%esp)
    16e1:	e8 05 fe ff ff       	call   14eb <putc>
          s++;
    16e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ed:	0f b6 00             	movzbl (%eax),%eax
    16f0:	84 c0                	test   %al,%al
    16f2:	75 da                	jne    16ce <printf+0x103>
    16f4:	eb 68                	jmp    175e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16f6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16fa:	75 1d                	jne    1719 <printf+0x14e>
        putc(fd, *ap);
    16fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16ff:	8b 00                	mov    (%eax),%eax
    1701:	0f be c0             	movsbl %al,%eax
    1704:	89 44 24 04          	mov    %eax,0x4(%esp)
    1708:	8b 45 08             	mov    0x8(%ebp),%eax
    170b:	89 04 24             	mov    %eax,(%esp)
    170e:	e8 d8 fd ff ff       	call   14eb <putc>
        ap++;
    1713:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1717:	eb 45                	jmp    175e <printf+0x193>
      } else if(c == '%'){
    1719:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    171d:	75 17                	jne    1736 <printf+0x16b>
        putc(fd, c);
    171f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1722:	0f be c0             	movsbl %al,%eax
    1725:	89 44 24 04          	mov    %eax,0x4(%esp)
    1729:	8b 45 08             	mov    0x8(%ebp),%eax
    172c:	89 04 24             	mov    %eax,(%esp)
    172f:	e8 b7 fd ff ff       	call   14eb <putc>
    1734:	eb 28                	jmp    175e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1736:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    173d:	00 
    173e:	8b 45 08             	mov    0x8(%ebp),%eax
    1741:	89 04 24             	mov    %eax,(%esp)
    1744:	e8 a2 fd ff ff       	call   14eb <putc>
        putc(fd, c);
    1749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    174c:	0f be c0             	movsbl %al,%eax
    174f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1753:	8b 45 08             	mov    0x8(%ebp),%eax
    1756:	89 04 24             	mov    %eax,(%esp)
    1759:	e8 8d fd ff ff       	call   14eb <putc>
      }
      state = 0;
    175e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1765:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1769:	8b 55 0c             	mov    0xc(%ebp),%edx
    176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176f:	01 d0                	add    %edx,%eax
    1771:	0f b6 00             	movzbl (%eax),%eax
    1774:	84 c0                	test   %al,%al
    1776:	0f 85 71 fe ff ff    	jne    15ed <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    177c:	c9                   	leave  
    177d:	c3                   	ret    

0000177e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    177e:	55                   	push   %ebp
    177f:	89 e5                	mov    %esp,%ebp
    1781:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1784:	8b 45 08             	mov    0x8(%ebp),%eax
    1787:	83 e8 08             	sub    $0x8,%eax
    178a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178d:	a1 64 21 00 00       	mov    0x2164,%eax
    1792:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1795:	eb 24                	jmp    17bb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1797:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179a:	8b 00                	mov    (%eax),%eax
    179c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179f:	77 12                	ja     17b3 <free+0x35>
    17a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17a7:	77 24                	ja     17cd <free+0x4f>
    17a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ac:	8b 00                	mov    (%eax),%eax
    17ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17b1:	77 1a                	ja     17cd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b6:	8b 00                	mov    (%eax),%eax
    17b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17c1:	76 d4                	jbe    1797 <free+0x19>
    17c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c6:	8b 00                	mov    (%eax),%eax
    17c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17cb:	76 ca                	jbe    1797 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d0:	8b 40 04             	mov    0x4(%eax),%eax
    17d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17da:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17dd:	01 c2                	add    %eax,%edx
    17df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e2:	8b 00                	mov    (%eax),%eax
    17e4:	39 c2                	cmp    %eax,%edx
    17e6:	75 24                	jne    180c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17eb:	8b 50 04             	mov    0x4(%eax),%edx
    17ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f1:	8b 00                	mov    (%eax),%eax
    17f3:	8b 40 04             	mov    0x4(%eax),%eax
    17f6:	01 c2                	add    %eax,%edx
    17f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17fb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1801:	8b 00                	mov    (%eax),%eax
    1803:	8b 10                	mov    (%eax),%edx
    1805:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1808:	89 10                	mov    %edx,(%eax)
    180a:	eb 0a                	jmp    1816 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    180c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180f:	8b 10                	mov    (%eax),%edx
    1811:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1814:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1816:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1819:	8b 40 04             	mov    0x4(%eax),%eax
    181c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1823:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1826:	01 d0                	add    %edx,%eax
    1828:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    182b:	75 20                	jne    184d <free+0xcf>
    p->s.size += bp->s.size;
    182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1830:	8b 50 04             	mov    0x4(%eax),%edx
    1833:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1836:	8b 40 04             	mov    0x4(%eax),%eax
    1839:	01 c2                	add    %eax,%edx
    183b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1841:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1844:	8b 10                	mov    (%eax),%edx
    1846:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1849:	89 10                	mov    %edx,(%eax)
    184b:	eb 08                	jmp    1855 <free+0xd7>
  } else
    p->s.ptr = bp;
    184d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1850:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1853:	89 10                	mov    %edx,(%eax)
  freep = p;
    1855:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1858:	a3 64 21 00 00       	mov    %eax,0x2164
}
    185d:	c9                   	leave  
    185e:	c3                   	ret    

0000185f <morecore>:

static Header*
morecore(uint nu)
{
    185f:	55                   	push   %ebp
    1860:	89 e5                	mov    %esp,%ebp
    1862:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1865:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    186c:	77 07                	ja     1875 <morecore+0x16>
    nu = 4096;
    186e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1875:	8b 45 08             	mov    0x8(%ebp),%eax
    1878:	c1 e0 03             	shl    $0x3,%eax
    187b:	89 04 24             	mov    %eax,(%esp)
    187e:	e8 20 fc ff ff       	call   14a3 <sbrk>
    1883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1886:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    188a:	75 07                	jne    1893 <morecore+0x34>
    return 0;
    188c:	b8 00 00 00 00       	mov    $0x0,%eax
    1891:	eb 22                	jmp    18b5 <morecore+0x56>
  hp = (Header*)p;
    1893:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1899:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189c:	8b 55 08             	mov    0x8(%ebp),%edx
    189f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a5:	83 c0 08             	add    $0x8,%eax
    18a8:	89 04 24             	mov    %eax,(%esp)
    18ab:	e8 ce fe ff ff       	call   177e <free>
  return freep;
    18b0:	a1 64 21 00 00       	mov    0x2164,%eax
}
    18b5:	c9                   	leave  
    18b6:	c3                   	ret    

000018b7 <malloc>:

void*
malloc(uint nbytes)
{
    18b7:	55                   	push   %ebp
    18b8:	89 e5                	mov    %esp,%ebp
    18ba:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18bd:	8b 45 08             	mov    0x8(%ebp),%eax
    18c0:	83 c0 07             	add    $0x7,%eax
    18c3:	c1 e8 03             	shr    $0x3,%eax
    18c6:	83 c0 01             	add    $0x1,%eax
    18c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18cc:	a1 64 21 00 00       	mov    0x2164,%eax
    18d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18d8:	75 23                	jne    18fd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18da:	c7 45 f0 5c 21 00 00 	movl   $0x215c,-0x10(%ebp)
    18e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e4:	a3 64 21 00 00       	mov    %eax,0x2164
    18e9:	a1 64 21 00 00       	mov    0x2164,%eax
    18ee:	a3 5c 21 00 00       	mov    %eax,0x215c
    base.s.size = 0;
    18f3:	c7 05 60 21 00 00 00 	movl   $0x0,0x2160
    18fa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1900:	8b 00                	mov    (%eax),%eax
    1902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1905:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1908:	8b 40 04             	mov    0x4(%eax),%eax
    190b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    190e:	72 4d                	jb     195d <malloc+0xa6>
      if(p->s.size == nunits)
    1910:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1913:	8b 40 04             	mov    0x4(%eax),%eax
    1916:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1919:	75 0c                	jne    1927 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191e:	8b 10                	mov    (%eax),%edx
    1920:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1923:	89 10                	mov    %edx,(%eax)
    1925:	eb 26                	jmp    194d <malloc+0x96>
      else {
        p->s.size -= nunits;
    1927:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192a:	8b 40 04             	mov    0x4(%eax),%eax
    192d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1930:	89 c2                	mov    %eax,%edx
    1932:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1935:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1938:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193b:	8b 40 04             	mov    0x4(%eax),%eax
    193e:	c1 e0 03             	shl    $0x3,%eax
    1941:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1944:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1947:	8b 55 ec             	mov    -0x14(%ebp),%edx
    194a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1950:	a3 64 21 00 00       	mov    %eax,0x2164
      return (void*)(p + 1);
    1955:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1958:	83 c0 08             	add    $0x8,%eax
    195b:	eb 38                	jmp    1995 <malloc+0xde>
    }
    if(p == freep)
    195d:	a1 64 21 00 00       	mov    0x2164,%eax
    1962:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1965:	75 1b                	jne    1982 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1967:	8b 45 ec             	mov    -0x14(%ebp),%eax
    196a:	89 04 24             	mov    %eax,(%esp)
    196d:	e8 ed fe ff ff       	call   185f <morecore>
    1972:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1979:	75 07                	jne    1982 <malloc+0xcb>
        return 0;
    197b:	b8 00 00 00 00       	mov    $0x0,%eax
    1980:	eb 13                	jmp    1995 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1982:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1985:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1988:	8b 45 f4             	mov    -0xc(%ebp),%eax
    198b:	8b 00                	mov    (%eax),%eax
    198d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1990:	e9 70 ff ff ff       	jmp    1905 <malloc+0x4e>
}
    1995:	c9                   	leave  
    1996:	c3                   	ret    

00001997 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1997:	55                   	push   %ebp
    1998:	89 e5                	mov    %esp,%ebp
    199a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    199d:	8b 55 08             	mov    0x8(%ebp),%edx
    19a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    19a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19a6:	f0 87 02             	lock xchg %eax,(%edx)
    19a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    19ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    19af:	c9                   	leave  
    19b0:	c3                   	ret    

000019b1 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    19b1:	55                   	push   %ebp
    19b2:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    19b4:	8b 45 08             	mov    0x8(%ebp),%eax
    19b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    19bd:	5d                   	pop    %ebp
    19be:	c3                   	ret    

000019bf <lock_acquire>:
void lock_acquire(lock_t *lock){
    19bf:	55                   	push   %ebp
    19c0:	89 e5                	mov    %esp,%ebp
    19c2:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    19c5:	90                   	nop
    19c6:	8b 45 08             	mov    0x8(%ebp),%eax
    19c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    19d0:	00 
    19d1:	89 04 24             	mov    %eax,(%esp)
    19d4:	e8 be ff ff ff       	call   1997 <xchg>
    19d9:	85 c0                	test   %eax,%eax
    19db:	75 e9                	jne    19c6 <lock_acquire+0x7>
}
    19dd:	c9                   	leave  
    19de:	c3                   	ret    

000019df <lock_release>:
void lock_release(lock_t *lock){
    19df:	55                   	push   %ebp
    19e0:	89 e5                	mov    %esp,%ebp
    19e2:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    19e5:	8b 45 08             	mov    0x8(%ebp),%eax
    19e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19ef:	00 
    19f0:	89 04 24             	mov    %eax,(%esp)
    19f3:	e8 9f ff ff ff       	call   1997 <xchg>
}
    19f8:	c9                   	leave  
    19f9:	c3                   	ret    

000019fa <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    19fa:	55                   	push   %ebp
    19fb:	89 e5                	mov    %esp,%ebp
    19fd:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1a00:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1a07:	e8 ab fe ff ff       	call   18b7 <malloc>
    1a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1a15:	0f b6 05 68 21 00 00 	movzbl 0x2168,%eax
    1a1c:	84 c0                	test   %al,%al
    1a1e:	75 1c                	jne    1a3c <thread_create+0x42>
        init_q(thQ2);
    1a20:	a1 70 21 00 00       	mov    0x2170,%eax
    1a25:	89 04 24             	mov    %eax,(%esp)
    1a28:	e8 cd 01 00 00       	call   1bfa <init_q>
        inQ++;
    1a2d:	0f b6 05 68 21 00 00 	movzbl 0x2168,%eax
    1a34:	83 c0 01             	add    $0x1,%eax
    1a37:	a2 68 21 00 00       	mov    %al,0x2168
    }

    if((uint)stack % 4096){
    1a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a3f:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a44:	85 c0                	test   %eax,%eax
    1a46:	74 14                	je     1a5c <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4b:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a50:	89 c2                	mov    %eax,%edx
    1a52:	b8 00 10 00 00       	mov    $0x1000,%eax
    1a57:	29 d0                	sub    %edx,%eax
    1a59:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a60:	75 1e                	jne    1a80 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1a62:	c7 44 24 04 39 1d 00 	movl   $0x1d39,0x4(%esp)
    1a69:	00 
    1a6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a71:	e8 55 fb ff ff       	call   15cb <printf>
        return 0;
    1a76:	b8 00 00 00 00       	mov    $0x0,%eax
    1a7b:	e9 9e 00 00 00       	jmp    1b1e <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1a83:	8b 55 08             	mov    0x8(%ebp),%edx
    1a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a89:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1a8d:	89 54 24 08          	mov    %edx,0x8(%esp)
    1a91:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a98:	00 
    1a99:	89 04 24             	mov    %eax,(%esp)
    1a9c:	e8 1a fa ff ff       	call   14bb <clone>
    1aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aa7:	89 44 24 08          	mov    %eax,0x8(%esp)
    1aab:	c7 44 24 04 47 1d 00 	movl   $0x1d47,0x4(%esp)
    1ab2:	00 
    1ab3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aba:	e8 0c fb ff ff       	call   15cb <printf>
    if(tid < 0){
    1abf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ac3:	79 1b                	jns    1ae0 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1ac5:	c7 44 24 04 60 1d 00 	movl   $0x1d60,0x4(%esp)
    1acc:	00 
    1acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ad4:	e8 f2 fa ff ff       	call   15cb <printf>
        return 0;
    1ad9:	b8 00 00 00 00       	mov    $0x0,%eax
    1ade:	eb 3e                	jmp    1b1e <thread_create+0x124>
    }
    if(tid > 0){
    1ae0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ae4:	7e 19                	jle    1aff <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1ae6:	a1 70 21 00 00       	mov    0x2170,%eax
    1aeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1aee:	89 54 24 04          	mov    %edx,0x4(%esp)
    1af2:	89 04 24             	mov    %eax,(%esp)
    1af5:	e8 22 01 00 00       	call   1c1c <add_q>
        return garbage_stack;
    1afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1afd:	eb 1f                	jmp    1b1e <thread_create+0x124>
    }
    if(tid == 0){
    1aff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b03:	75 14                	jne    1b19 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1b05:	c7 44 24 04 6d 1d 00 	movl   $0x1d6d,0x4(%esp)
    1b0c:	00 
    1b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b14:	e8 b2 fa ff ff       	call   15cb <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1b1e:	c9                   	leave  
    1b1f:	c3                   	ret    

00001b20 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1b20:	55                   	push   %ebp
    1b21:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1b23:	a1 58 21 00 00       	mov    0x2158,%eax
    1b28:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1b2e:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1b33:	a3 58 21 00 00       	mov    %eax,0x2158
    return (int)(rands % max);
    1b38:	a1 58 21 00 00       	mov    0x2158,%eax
    1b3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b40:	ba 00 00 00 00       	mov    $0x0,%edx
    1b45:	f7 f1                	div    %ecx
    1b47:	89 d0                	mov    %edx,%eax
}
    1b49:	5d                   	pop    %ebp
    1b4a:	c3                   	ret    

00001b4b <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1b4b:	55                   	push   %ebp
    1b4c:	89 e5                	mov    %esp,%ebp
    1b4e:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1b51:	e8 45 f9 ff ff       	call   149b <getpid>
    1b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1b59:	a1 70 21 00 00       	mov    0x2170,%eax
    1b5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1b61:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b65:	89 04 24             	mov    %eax,(%esp)
    1b68:	e8 af 00 00 00       	call   1c1c <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1b6d:	a1 70 21 00 00       	mov    0x2170,%eax
    1b72:	89 04 24             	mov    %eax,(%esp)
    1b75:	e8 1c 01 00 00       	call   1c96 <pop_q>
    1b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1b7d:	a1 6c 21 00 00       	mov    0x216c,%eax
    1b82:	85 c0                	test   %eax,%eax
    1b84:	75 1f                	jne    1ba5 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1b86:	a1 70 21 00 00       	mov    0x2170,%eax
    1b8b:	89 04 24             	mov    %eax,(%esp)
    1b8e:	e8 03 01 00 00       	call   1c96 <pop_q>
    1b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1b96:	a1 6c 21 00 00       	mov    0x216c,%eax
    1b9b:	83 c0 01             	add    $0x1,%eax
    1b9e:	a3 6c 21 00 00       	mov    %eax,0x216c
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1ba3:	eb 12                	jmp    1bb7 <thread_yield2+0x6c>
    1ba5:	eb 10                	jmp    1bb7 <thread_yield2+0x6c>
    1ba7:	a1 70 21 00 00       	mov    0x2170,%eax
    1bac:	89 04 24             	mov    %eax,(%esp)
    1baf:	e8 e2 00 00 00       	call   1c96 <pop_q>
    1bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1bbd:	74 e8                	je     1ba7 <thread_yield2+0x5c>
    1bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bc3:	74 e2                	je     1ba7 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc8:	89 04 24             	mov    %eax,(%esp)
    1bcb:	e8 03 f9 ff ff       	call   14d3 <twakeup>
    tsleep();
    1bd0:	e8 f6 f8 ff ff       	call   14cb <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1bd5:	c9                   	leave  
    1bd6:	c3                   	ret    

00001bd7 <thread_yield_last>:

void thread_yield_last(){
    1bd7:	55                   	push   %ebp
    1bd8:	89 e5                	mov    %esp,%ebp
    1bda:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1bdd:	a1 70 21 00 00       	mov    0x2170,%eax
    1be2:	89 04 24             	mov    %eax,(%esp)
    1be5:	e8 ac 00 00 00       	call   1c96 <pop_q>
    1bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bf0:	89 04 24             	mov    %eax,(%esp)
    1bf3:	e8 db f8 ff ff       	call   14d3 <twakeup>
    1bf8:	c9                   	leave  
    1bf9:	c3                   	ret    

00001bfa <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1bfa:	55                   	push   %ebp
    1bfb:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1bfd:	8b 45 08             	mov    0x8(%ebp),%eax
    1c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1c06:	8b 45 08             	mov    0x8(%ebp),%eax
    1c09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1c10:	8b 45 08             	mov    0x8(%ebp),%eax
    1c13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1c1a:	5d                   	pop    %ebp
    1c1b:	c3                   	ret    

00001c1c <add_q>:

void add_q(struct queue *q, int v){
    1c1c:	55                   	push   %ebp
    1c1d:	89 e5                	mov    %esp,%ebp
    1c1f:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1c22:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1c29:	e8 89 fc ff ff       	call   18b7 <malloc>
    1c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c41:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1c43:	8b 45 08             	mov    0x8(%ebp),%eax
    1c46:	8b 40 04             	mov    0x4(%eax),%eax
    1c49:	85 c0                	test   %eax,%eax
    1c4b:	75 0b                	jne    1c58 <add_q+0x3c>
        q->head = n;
    1c4d:	8b 45 08             	mov    0x8(%ebp),%eax
    1c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c53:	89 50 04             	mov    %edx,0x4(%eax)
    1c56:	eb 0c                	jmp    1c64 <add_q+0x48>
    }else{
        q->tail->next = n;
    1c58:	8b 45 08             	mov    0x8(%ebp),%eax
    1c5b:	8b 40 08             	mov    0x8(%eax),%eax
    1c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c61:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1c64:	8b 45 08             	mov    0x8(%ebp),%eax
    1c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c6a:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1c6d:	8b 45 08             	mov    0x8(%ebp),%eax
    1c70:	8b 00                	mov    (%eax),%eax
    1c72:	8d 50 01             	lea    0x1(%eax),%edx
    1c75:	8b 45 08             	mov    0x8(%ebp),%eax
    1c78:	89 10                	mov    %edx,(%eax)
}
    1c7a:	c9                   	leave  
    1c7b:	c3                   	ret    

00001c7c <empty_q>:

int empty_q(struct queue *q){
    1c7c:	55                   	push   %ebp
    1c7d:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1c7f:	8b 45 08             	mov    0x8(%ebp),%eax
    1c82:	8b 00                	mov    (%eax),%eax
    1c84:	85 c0                	test   %eax,%eax
    1c86:	75 07                	jne    1c8f <empty_q+0x13>
        return 1;
    1c88:	b8 01 00 00 00       	mov    $0x1,%eax
    1c8d:	eb 05                	jmp    1c94 <empty_q+0x18>
    else
        return 0;
    1c8f:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1c94:	5d                   	pop    %ebp
    1c95:	c3                   	ret    

00001c96 <pop_q>:
int pop_q(struct queue *q){
    1c96:	55                   	push   %ebp
    1c97:	89 e5                	mov    %esp,%ebp
    1c99:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1c9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c9f:	89 04 24             	mov    %eax,(%esp)
    1ca2:	e8 d5 ff ff ff       	call   1c7c <empty_q>
    1ca7:	85 c0                	test   %eax,%eax
    1ca9:	75 5d                	jne    1d08 <pop_q+0x72>
       val = q->head->value; 
    1cab:	8b 45 08             	mov    0x8(%ebp),%eax
    1cae:	8b 40 04             	mov    0x4(%eax),%eax
    1cb1:	8b 00                	mov    (%eax),%eax
    1cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1cb6:	8b 45 08             	mov    0x8(%ebp),%eax
    1cb9:	8b 40 04             	mov    0x4(%eax),%eax
    1cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1cbf:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc2:	8b 40 04             	mov    0x4(%eax),%eax
    1cc5:	8b 50 04             	mov    0x4(%eax),%edx
    1cc8:	8b 45 08             	mov    0x8(%ebp),%eax
    1ccb:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1cd1:	89 04 24             	mov    %eax,(%esp)
    1cd4:	e8 a5 fa ff ff       	call   177e <free>
       q->size--;
    1cd9:	8b 45 08             	mov    0x8(%ebp),%eax
    1cdc:	8b 00                	mov    (%eax),%eax
    1cde:	8d 50 ff             	lea    -0x1(%eax),%edx
    1ce1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce4:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ce6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce9:	8b 00                	mov    (%eax),%eax
    1ceb:	85 c0                	test   %eax,%eax
    1ced:	75 14                	jne    1d03 <pop_q+0x6d>
            q->head = 0;
    1cef:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1cf9:	8b 45 08             	mov    0x8(%ebp),%eax
    1cfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d06:	eb 05                	jmp    1d0d <pop_q+0x77>
    }
    return -1;
    1d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1d0d:	c9                   	leave  
    1d0e:	c3                   	ret    
