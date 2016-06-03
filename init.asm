
_init:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    1009:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1010:	00 
    1011:	c7 04 24 e1 1b 00 00 	movl   $0x1be1,(%esp)
    1018:	e8 ae 03 00 00       	call   13cb <open>
    101d:	85 c0                	test   %eax,%eax
    101f:	79 30                	jns    1051 <main+0x51>
    mknod("console", 1, 1);
    1021:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1028:	00 
    1029:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 e1 1b 00 00 	movl   $0x1be1,(%esp)
    1038:	e8 96 03 00 00       	call   13d3 <mknod>
    open("console", O_RDWR);
    103d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 e1 1b 00 00 	movl   $0x1be1,(%esp)
    104c:	e8 7a 03 00 00       	call   13cb <open>
  }
  dup(0);  // stdout
    1051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1058:	e8 a6 03 00 00       	call   1403 <dup>
  dup(0);  // stderr
    105d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1064:	e8 9a 03 00 00       	call   1403 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
    1069:	c7 44 24 04 e9 1b 00 	movl   $0x1be9,0x4(%esp)
    1070:	00 
    1071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1078:	e8 be 04 00 00       	call   153b <printf>
    pid = fork();
    107d:	e8 01 03 00 00       	call   1383 <fork>
    1082:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
    1086:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    108b:	79 19                	jns    10a6 <main+0xa6>
      printf(1, "init: fork failed\n");
    108d:	c7 44 24 04 fc 1b 00 	movl   $0x1bfc,0x4(%esp)
    1094:	00 
    1095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109c:	e8 9a 04 00 00       	call   153b <printf>
      exit();
    10a1:	e8 e5 02 00 00       	call   138b <exit>
    }
    if(pid == 0){
    10a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    10ab:	75 41                	jne    10ee <main+0xee>
      printf(1,"init to exec\n");
    10ad:	c7 44 24 04 0f 1c 00 	movl   $0x1c0f,0x4(%esp)
    10b4:	00 
    10b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10bc:	e8 7a 04 00 00       	call   153b <printf>
      exec("sh", argv);
    10c1:	c7 44 24 04 20 20 00 	movl   $0x2020,0x4(%esp)
    10c8:	00 
    10c9:	c7 04 24 de 1b 00 00 	movl   $0x1bde,(%esp)
    10d0:	e8 ee 02 00 00       	call   13c3 <exec>
      printf(1, "init: exec sh failed\n");
    10d5:	c7 44 24 04 1d 1c 00 	movl   $0x1c1d,0x4(%esp)
    10dc:	00 
    10dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e4:	e8 52 04 00 00       	call   153b <printf>
      exit();
    10e9:	e8 9d 02 00 00       	call   138b <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10ee:	eb 14                	jmp    1104 <main+0x104>
      printf(1, "zombie!\n");
    10f0:	c7 44 24 04 33 1c 00 	movl   $0x1c33,0x4(%esp)
    10f7:	00 
    10f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ff:	e8 37 04 00 00       	call   153b <printf>
      printf(1,"init to exec\n");
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    1104:	e8 8a 02 00 00       	call   1393 <wait>
    1109:	89 44 24 18          	mov    %eax,0x18(%esp)
    110d:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    1112:	78 0a                	js     111e <main+0x11e>
    1114:	8b 44 24 18          	mov    0x18(%esp),%eax
    1118:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
    111c:	75 d2                	jne    10f0 <main+0xf0>
      printf(1, "zombie!\n");
  }
    111e:	e9 46 ff ff ff       	jmp    1069 <main+0x69>

00001123 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1123:	55                   	push   %ebp
    1124:	89 e5                	mov    %esp,%ebp
    1126:	57                   	push   %edi
    1127:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1128:	8b 4d 08             	mov    0x8(%ebp),%ecx
    112b:	8b 55 10             	mov    0x10(%ebp),%edx
    112e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1131:	89 cb                	mov    %ecx,%ebx
    1133:	89 df                	mov    %ebx,%edi
    1135:	89 d1                	mov    %edx,%ecx
    1137:	fc                   	cld    
    1138:	f3 aa                	rep stos %al,%es:(%edi)
    113a:	89 ca                	mov    %ecx,%edx
    113c:	89 fb                	mov    %edi,%ebx
    113e:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1141:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1144:	5b                   	pop    %ebx
    1145:	5f                   	pop    %edi
    1146:	5d                   	pop    %ebp
    1147:	c3                   	ret    

00001148 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1148:	55                   	push   %ebp
    1149:	89 e5                	mov    %esp,%ebp
    114b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    114e:	8b 45 08             	mov    0x8(%ebp),%eax
    1151:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1154:	90                   	nop
    1155:	8b 45 08             	mov    0x8(%ebp),%eax
    1158:	8d 50 01             	lea    0x1(%eax),%edx
    115b:	89 55 08             	mov    %edx,0x8(%ebp)
    115e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1161:	8d 4a 01             	lea    0x1(%edx),%ecx
    1164:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1167:	0f b6 12             	movzbl (%edx),%edx
    116a:	88 10                	mov    %dl,(%eax)
    116c:	0f b6 00             	movzbl (%eax),%eax
    116f:	84 c0                	test   %al,%al
    1171:	75 e2                	jne    1155 <strcpy+0xd>
    ;
  return os;
    1173:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1176:	c9                   	leave  
    1177:	c3                   	ret    

00001178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1178:	55                   	push   %ebp
    1179:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    117b:	eb 08                	jmp    1185 <strcmp+0xd>
    p++, q++;
    117d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1181:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1185:	8b 45 08             	mov    0x8(%ebp),%eax
    1188:	0f b6 00             	movzbl (%eax),%eax
    118b:	84 c0                	test   %al,%al
    118d:	74 10                	je     119f <strcmp+0x27>
    118f:	8b 45 08             	mov    0x8(%ebp),%eax
    1192:	0f b6 10             	movzbl (%eax),%edx
    1195:	8b 45 0c             	mov    0xc(%ebp),%eax
    1198:	0f b6 00             	movzbl (%eax),%eax
    119b:	38 c2                	cmp    %al,%dl
    119d:	74 de                	je     117d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    119f:	8b 45 08             	mov    0x8(%ebp),%eax
    11a2:	0f b6 00             	movzbl (%eax),%eax
    11a5:	0f b6 d0             	movzbl %al,%edx
    11a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ab:	0f b6 00             	movzbl (%eax),%eax
    11ae:	0f b6 c0             	movzbl %al,%eax
    11b1:	29 c2                	sub    %eax,%edx
    11b3:	89 d0                	mov    %edx,%eax
}
    11b5:	5d                   	pop    %ebp
    11b6:	c3                   	ret    

000011b7 <strlen>:

uint
strlen(char *s)
{
    11b7:	55                   	push   %ebp
    11b8:	89 e5                	mov    %esp,%ebp
    11ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11c4:	eb 04                	jmp    11ca <strlen+0x13>
    11c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11cd:	8b 45 08             	mov    0x8(%ebp),%eax
    11d0:	01 d0                	add    %edx,%eax
    11d2:	0f b6 00             	movzbl (%eax),%eax
    11d5:	84 c0                	test   %al,%al
    11d7:	75 ed                	jne    11c6 <strlen+0xf>
    ;
  return n;
    11d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11dc:	c9                   	leave  
    11dd:	c3                   	ret    

000011de <memset>:

void*
memset(void *dst, int c, uint n)
{
    11de:	55                   	push   %ebp
    11df:	89 e5                	mov    %esp,%ebp
    11e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11e4:	8b 45 10             	mov    0x10(%ebp),%eax
    11e7:	89 44 24 08          	mov    %eax,0x8(%esp)
    11eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f2:	8b 45 08             	mov    0x8(%ebp),%eax
    11f5:	89 04 24             	mov    %eax,(%esp)
    11f8:	e8 26 ff ff ff       	call   1123 <stosb>
  return dst;
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1200:	c9                   	leave  
    1201:	c3                   	ret    

00001202 <strchr>:

char*
strchr(const char *s, char c)
{
    1202:	55                   	push   %ebp
    1203:	89 e5                	mov    %esp,%ebp
    1205:	83 ec 04             	sub    $0x4,%esp
    1208:	8b 45 0c             	mov    0xc(%ebp),%eax
    120b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    120e:	eb 14                	jmp    1224 <strchr+0x22>
    if(*s == c)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	0f b6 00             	movzbl (%eax),%eax
    1216:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1219:	75 05                	jne    1220 <strchr+0x1e>
      return (char*)s;
    121b:	8b 45 08             	mov    0x8(%ebp),%eax
    121e:	eb 13                	jmp    1233 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1220:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1224:	8b 45 08             	mov    0x8(%ebp),%eax
    1227:	0f b6 00             	movzbl (%eax),%eax
    122a:	84 c0                	test   %al,%al
    122c:	75 e2                	jne    1210 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    122e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1233:	c9                   	leave  
    1234:	c3                   	ret    

00001235 <gets>:

char*
gets(char *buf, int max)
{
    1235:	55                   	push   %ebp
    1236:	89 e5                	mov    %esp,%ebp
    1238:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    123b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1242:	eb 4c                	jmp    1290 <gets+0x5b>
    cc = read(0, &c, 1);
    1244:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    124b:	00 
    124c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    124f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    125a:	e8 44 01 00 00       	call   13a3 <read>
    125f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1266:	7f 02                	jg     126a <gets+0x35>
      break;
    1268:	eb 31                	jmp    129b <gets+0x66>
    buf[i++] = c;
    126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126d:	8d 50 01             	lea    0x1(%eax),%edx
    1270:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1273:	89 c2                	mov    %eax,%edx
    1275:	8b 45 08             	mov    0x8(%ebp),%eax
    1278:	01 c2                	add    %eax,%edx
    127a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1280:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1284:	3c 0a                	cmp    $0xa,%al
    1286:	74 13                	je     129b <gets+0x66>
    1288:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    128c:	3c 0d                	cmp    $0xd,%al
    128e:	74 0b                	je     129b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1290:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1293:	83 c0 01             	add    $0x1,%eax
    1296:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1299:	7c a9                	jl     1244 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    129b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    129e:	8b 45 08             	mov    0x8(%ebp),%eax
    12a1:	01 d0                	add    %edx,%eax
    12a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a9:	c9                   	leave  
    12aa:	c3                   	ret    

000012ab <stat>:

int
stat(char *n, struct stat *st)
{
    12ab:	55                   	push   %ebp
    12ac:	89 e5                	mov    %esp,%ebp
    12ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12b8:	00 
    12b9:	8b 45 08             	mov    0x8(%ebp),%eax
    12bc:	89 04 24             	mov    %eax,(%esp)
    12bf:	e8 07 01 00 00       	call   13cb <open>
    12c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12cb:	79 07                	jns    12d4 <stat+0x29>
    return -1;
    12cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12d2:	eb 23                	jmp    12f7 <stat+0x4c>
  r = fstat(fd, st);
    12d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    12db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12de:	89 04 24             	mov    %eax,(%esp)
    12e1:	e8 fd 00 00 00       	call   13e3 <fstat>
    12e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ec:	89 04 24             	mov    %eax,(%esp)
    12ef:	e8 bf 00 00 00       	call   13b3 <close>
  return r;
    12f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12f7:	c9                   	leave  
    12f8:	c3                   	ret    

000012f9 <atoi>:

int
atoi(const char *s)
{
    12f9:	55                   	push   %ebp
    12fa:	89 e5                	mov    %esp,%ebp
    12fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1306:	eb 25                	jmp    132d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1308:	8b 55 fc             	mov    -0x4(%ebp),%edx
    130b:	89 d0                	mov    %edx,%eax
    130d:	c1 e0 02             	shl    $0x2,%eax
    1310:	01 d0                	add    %edx,%eax
    1312:	01 c0                	add    %eax,%eax
    1314:	89 c1                	mov    %eax,%ecx
    1316:	8b 45 08             	mov    0x8(%ebp),%eax
    1319:	8d 50 01             	lea    0x1(%eax),%edx
    131c:	89 55 08             	mov    %edx,0x8(%ebp)
    131f:	0f b6 00             	movzbl (%eax),%eax
    1322:	0f be c0             	movsbl %al,%eax
    1325:	01 c8                	add    %ecx,%eax
    1327:	83 e8 30             	sub    $0x30,%eax
    132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    132d:	8b 45 08             	mov    0x8(%ebp),%eax
    1330:	0f b6 00             	movzbl (%eax),%eax
    1333:	3c 2f                	cmp    $0x2f,%al
    1335:	7e 0a                	jle    1341 <atoi+0x48>
    1337:	8b 45 08             	mov    0x8(%ebp),%eax
    133a:	0f b6 00             	movzbl (%eax),%eax
    133d:	3c 39                	cmp    $0x39,%al
    133f:	7e c7                	jle    1308 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1341:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1344:	c9                   	leave  
    1345:	c3                   	ret    

00001346 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1346:	55                   	push   %ebp
    1347:	89 e5                	mov    %esp,%ebp
    1349:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    134c:	8b 45 08             	mov    0x8(%ebp),%eax
    134f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1352:	8b 45 0c             	mov    0xc(%ebp),%eax
    1355:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1358:	eb 17                	jmp    1371 <memmove+0x2b>
    *dst++ = *src++;
    135a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135d:	8d 50 01             	lea    0x1(%eax),%edx
    1360:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1363:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1366:	8d 4a 01             	lea    0x1(%edx),%ecx
    1369:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    136c:	0f b6 12             	movzbl (%edx),%edx
    136f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1371:	8b 45 10             	mov    0x10(%ebp),%eax
    1374:	8d 50 ff             	lea    -0x1(%eax),%edx
    1377:	89 55 10             	mov    %edx,0x10(%ebp)
    137a:	85 c0                	test   %eax,%eax
    137c:	7f dc                	jg     135a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    137e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1381:	c9                   	leave  
    1382:	c3                   	ret    

00001383 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1383:	b8 01 00 00 00       	mov    $0x1,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <exit>:
SYSCALL(exit)
    138b:	b8 02 00 00 00       	mov    $0x2,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <wait>:
SYSCALL(wait)
    1393:	b8 03 00 00 00       	mov    $0x3,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <pipe>:
SYSCALL(pipe)
    139b:	b8 04 00 00 00       	mov    $0x4,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <read>:
SYSCALL(read)
    13a3:	b8 05 00 00 00       	mov    $0x5,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <write>:
SYSCALL(write)
    13ab:	b8 10 00 00 00       	mov    $0x10,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <close>:
SYSCALL(close)
    13b3:	b8 15 00 00 00       	mov    $0x15,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <kill>:
SYSCALL(kill)
    13bb:	b8 06 00 00 00       	mov    $0x6,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <exec>:
SYSCALL(exec)
    13c3:	b8 07 00 00 00       	mov    $0x7,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <open>:
SYSCALL(open)
    13cb:	b8 0f 00 00 00       	mov    $0xf,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <mknod>:
SYSCALL(mknod)
    13d3:	b8 11 00 00 00       	mov    $0x11,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <unlink>:
SYSCALL(unlink)
    13db:	b8 12 00 00 00       	mov    $0x12,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <fstat>:
SYSCALL(fstat)
    13e3:	b8 08 00 00 00       	mov    $0x8,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <link>:
SYSCALL(link)
    13eb:	b8 13 00 00 00       	mov    $0x13,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <mkdir>:
SYSCALL(mkdir)
    13f3:	b8 14 00 00 00       	mov    $0x14,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <chdir>:
SYSCALL(chdir)
    13fb:	b8 09 00 00 00       	mov    $0x9,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <dup>:
SYSCALL(dup)
    1403:	b8 0a 00 00 00       	mov    $0xa,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <getpid>:
SYSCALL(getpid)
    140b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <sbrk>:
SYSCALL(sbrk)
    1413:	b8 0c 00 00 00       	mov    $0xc,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <sleep>:
SYSCALL(sleep)
    141b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <uptime>:
SYSCALL(uptime)
    1423:	b8 0e 00 00 00       	mov    $0xe,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <clone>:
SYSCALL(clone)
    142b:	b8 16 00 00 00       	mov    $0x16,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <texit>:
SYSCALL(texit)
    1433:	b8 17 00 00 00       	mov    $0x17,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <tsleep>:
SYSCALL(tsleep)
    143b:	b8 18 00 00 00       	mov    $0x18,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <twakeup>:
SYSCALL(twakeup)
    1443:	b8 19 00 00 00       	mov    $0x19,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <thread_yield>:
SYSCALL(thread_yield)
    144b:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <thread_yield3>:
    1453:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    145b:	55                   	push   %ebp
    145c:	89 e5                	mov    %esp,%ebp
    145e:	83 ec 18             	sub    $0x18,%esp
    1461:	8b 45 0c             	mov    0xc(%ebp),%eax
    1464:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1467:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    146e:	00 
    146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1472:	89 44 24 04          	mov    %eax,0x4(%esp)
    1476:	8b 45 08             	mov    0x8(%ebp),%eax
    1479:	89 04 24             	mov    %eax,(%esp)
    147c:	e8 2a ff ff ff       	call   13ab <write>
}
    1481:	c9                   	leave  
    1482:	c3                   	ret    

00001483 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1483:	55                   	push   %ebp
    1484:	89 e5                	mov    %esp,%ebp
    1486:	56                   	push   %esi
    1487:	53                   	push   %ebx
    1488:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    148b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1492:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1496:	74 17                	je     14af <printint+0x2c>
    1498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    149c:	79 11                	jns    14af <printint+0x2c>
    neg = 1;
    149e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a8:	f7 d8                	neg    %eax
    14aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ad:	eb 06                	jmp    14b5 <printint+0x32>
  } else {
    x = xx;
    14af:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14bf:	8d 41 01             	lea    0x1(%ecx),%eax
    14c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14cb:	ba 00 00 00 00       	mov    $0x0,%edx
    14d0:	f7 f3                	div    %ebx
    14d2:	89 d0                	mov    %edx,%eax
    14d4:	0f b6 80 28 20 00 00 	movzbl 0x2028(%eax),%eax
    14db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14df:	8b 75 10             	mov    0x10(%ebp),%esi
    14e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14e5:	ba 00 00 00 00       	mov    $0x0,%edx
    14ea:	f7 f6                	div    %esi
    14ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14f3:	75 c7                	jne    14bc <printint+0x39>
  if(neg)
    14f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f9:	74 10                	je     150b <printint+0x88>
    buf[i++] = '-';
    14fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fe:	8d 50 01             	lea    0x1(%eax),%edx
    1501:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1504:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1509:	eb 1f                	jmp    152a <printint+0xa7>
    150b:	eb 1d                	jmp    152a <printint+0xa7>
    putc(fd, buf[i]);
    150d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1510:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1513:	01 d0                	add    %edx,%eax
    1515:	0f b6 00             	movzbl (%eax),%eax
    1518:	0f be c0             	movsbl %al,%eax
    151b:	89 44 24 04          	mov    %eax,0x4(%esp)
    151f:	8b 45 08             	mov    0x8(%ebp),%eax
    1522:	89 04 24             	mov    %eax,(%esp)
    1525:	e8 31 ff ff ff       	call   145b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    152a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    152e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1532:	79 d9                	jns    150d <printint+0x8a>
    putc(fd, buf[i]);
}
    1534:	83 c4 30             	add    $0x30,%esp
    1537:	5b                   	pop    %ebx
    1538:	5e                   	pop    %esi
    1539:	5d                   	pop    %ebp
    153a:	c3                   	ret    

0000153b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    153b:	55                   	push   %ebp
    153c:	89 e5                	mov    %esp,%ebp
    153e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1548:	8d 45 0c             	lea    0xc(%ebp),%eax
    154b:	83 c0 04             	add    $0x4,%eax
    154e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1558:	e9 7c 01 00 00       	jmp    16d9 <printf+0x19e>
    c = fmt[i] & 0xff;
    155d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1560:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1563:	01 d0                	add    %edx,%eax
    1565:	0f b6 00             	movzbl (%eax),%eax
    1568:	0f be c0             	movsbl %al,%eax
    156b:	25 ff 00 00 00       	and    $0xff,%eax
    1570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1577:	75 2c                	jne    15a5 <printf+0x6a>
      if(c == '%'){
    1579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    157d:	75 0c                	jne    158b <printf+0x50>
        state = '%';
    157f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1586:	e9 4a 01 00 00       	jmp    16d5 <printf+0x19a>
      } else {
        putc(fd, c);
    158b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    158e:	0f be c0             	movsbl %al,%eax
    1591:	89 44 24 04          	mov    %eax,0x4(%esp)
    1595:	8b 45 08             	mov    0x8(%ebp),%eax
    1598:	89 04 24             	mov    %eax,(%esp)
    159b:	e8 bb fe ff ff       	call   145b <putc>
    15a0:	e9 30 01 00 00       	jmp    16d5 <printf+0x19a>
      }
    } else if(state == '%'){
    15a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a9:	0f 85 26 01 00 00    	jne    16d5 <printf+0x19a>
      if(c == 'd'){
    15af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15b3:	75 2d                	jne    15e2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b8:	8b 00                	mov    (%eax),%eax
    15ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15c1:	00 
    15c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15c9:	00 
    15ca:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ce:	8b 45 08             	mov    0x8(%ebp),%eax
    15d1:	89 04 24             	mov    %eax,(%esp)
    15d4:	e8 aa fe ff ff       	call   1483 <printint>
        ap++;
    15d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15dd:	e9 ec 00 00 00       	jmp    16ce <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15e6:	74 06                	je     15ee <printf+0xb3>
    15e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15ec:	75 2d                	jne    161b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15f1:	8b 00                	mov    (%eax),%eax
    15f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15fa:	00 
    15fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1602:	00 
    1603:	89 44 24 04          	mov    %eax,0x4(%esp)
    1607:	8b 45 08             	mov    0x8(%ebp),%eax
    160a:	89 04 24             	mov    %eax,(%esp)
    160d:	e8 71 fe ff ff       	call   1483 <printint>
        ap++;
    1612:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1616:	e9 b3 00 00 00       	jmp    16ce <printf+0x193>
      } else if(c == 's'){
    161b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    161f:	75 45                	jne    1666 <printf+0x12b>
        s = (char*)*ap;
    1621:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1624:	8b 00                	mov    (%eax),%eax
    1626:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    162d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1631:	75 09                	jne    163c <printf+0x101>
          s = "(null)";
    1633:	c7 45 f4 3c 1c 00 00 	movl   $0x1c3c,-0xc(%ebp)
        while(*s != 0){
    163a:	eb 1e                	jmp    165a <printf+0x11f>
    163c:	eb 1c                	jmp    165a <printf+0x11f>
          putc(fd, *s);
    163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1641:	0f b6 00             	movzbl (%eax),%eax
    1644:	0f be c0             	movsbl %al,%eax
    1647:	89 44 24 04          	mov    %eax,0x4(%esp)
    164b:	8b 45 08             	mov    0x8(%ebp),%eax
    164e:	89 04 24             	mov    %eax,(%esp)
    1651:	e8 05 fe ff ff       	call   145b <putc>
          s++;
    1656:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    165a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165d:	0f b6 00             	movzbl (%eax),%eax
    1660:	84 c0                	test   %al,%al
    1662:	75 da                	jne    163e <printf+0x103>
    1664:	eb 68                	jmp    16ce <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1666:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    166a:	75 1d                	jne    1689 <printf+0x14e>
        putc(fd, *ap);
    166c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    166f:	8b 00                	mov    (%eax),%eax
    1671:	0f be c0             	movsbl %al,%eax
    1674:	89 44 24 04          	mov    %eax,0x4(%esp)
    1678:	8b 45 08             	mov    0x8(%ebp),%eax
    167b:	89 04 24             	mov    %eax,(%esp)
    167e:	e8 d8 fd ff ff       	call   145b <putc>
        ap++;
    1683:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1687:	eb 45                	jmp    16ce <printf+0x193>
      } else if(c == '%'){
    1689:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    168d:	75 17                	jne    16a6 <printf+0x16b>
        putc(fd, c);
    168f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1692:	0f be c0             	movsbl %al,%eax
    1695:	89 44 24 04          	mov    %eax,0x4(%esp)
    1699:	8b 45 08             	mov    0x8(%ebp),%eax
    169c:	89 04 24             	mov    %eax,(%esp)
    169f:	e8 b7 fd ff ff       	call   145b <putc>
    16a4:	eb 28                	jmp    16ce <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16a6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16ad:	00 
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	89 04 24             	mov    %eax,(%esp)
    16b4:	e8 a2 fd ff ff       	call   145b <putc>
        putc(fd, c);
    16b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16bc:	0f be c0             	movsbl %al,%eax
    16bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    16c3:	8b 45 08             	mov    0x8(%ebp),%eax
    16c6:	89 04 24             	mov    %eax,(%esp)
    16c9:	e8 8d fd ff ff       	call   145b <putc>
      }
      state = 0;
    16ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d9:	8b 55 0c             	mov    0xc(%ebp),%edx
    16dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16df:	01 d0                	add    %edx,%eax
    16e1:	0f b6 00             	movzbl (%eax),%eax
    16e4:	84 c0                	test   %al,%al
    16e6:	0f 85 71 fe ff ff    	jne    155d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16ec:	c9                   	leave  
    16ed:	c3                   	ret    

000016ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16ee:	55                   	push   %ebp
    16ef:	89 e5                	mov    %esp,%ebp
    16f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16f4:	8b 45 08             	mov    0x8(%ebp),%eax
    16f7:	83 e8 08             	sub    $0x8,%eax
    16fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16fd:	a1 48 20 00 00       	mov    0x2048,%eax
    1702:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1705:	eb 24                	jmp    172b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1707:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170a:	8b 00                	mov    (%eax),%eax
    170c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170f:	77 12                	ja     1723 <free+0x35>
    1711:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1714:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1717:	77 24                	ja     173d <free+0x4f>
    1719:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171c:	8b 00                	mov    (%eax),%eax
    171e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1721:	77 1a                	ja     173d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1723:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1726:	8b 00                	mov    (%eax),%eax
    1728:	89 45 fc             	mov    %eax,-0x4(%ebp)
    172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1731:	76 d4                	jbe    1707 <free+0x19>
    1733:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1736:	8b 00                	mov    (%eax),%eax
    1738:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    173b:	76 ca                	jbe    1707 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1740:	8b 40 04             	mov    0x4(%eax),%eax
    1743:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    174a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    174d:	01 c2                	add    %eax,%edx
    174f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1752:	8b 00                	mov    (%eax),%eax
    1754:	39 c2                	cmp    %eax,%edx
    1756:	75 24                	jne    177c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1758:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175b:	8b 50 04             	mov    0x4(%eax),%edx
    175e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1761:	8b 00                	mov    (%eax),%eax
    1763:	8b 40 04             	mov    0x4(%eax),%eax
    1766:	01 c2                	add    %eax,%edx
    1768:	8b 45 f8             	mov    -0x8(%ebp),%eax
    176b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    176e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1771:	8b 00                	mov    (%eax),%eax
    1773:	8b 10                	mov    (%eax),%edx
    1775:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1778:	89 10                	mov    %edx,(%eax)
    177a:	eb 0a                	jmp    1786 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177f:	8b 10                	mov    (%eax),%edx
    1781:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1784:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1786:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1789:	8b 40 04             	mov    0x4(%eax),%eax
    178c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1793:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1796:	01 d0                	add    %edx,%eax
    1798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    179b:	75 20                	jne    17bd <free+0xcf>
    p->s.size += bp->s.size;
    179d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a0:	8b 50 04             	mov    0x4(%eax),%edx
    17a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a6:	8b 40 04             	mov    0x4(%eax),%eax
    17a9:	01 c2                	add    %eax,%edx
    17ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b4:	8b 10                	mov    (%eax),%edx
    17b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b9:	89 10                	mov    %edx,(%eax)
    17bb:	eb 08                	jmp    17c5 <free+0xd7>
  } else
    p->s.ptr = bp;
    17bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17c3:	89 10                	mov    %edx,(%eax)
  freep = p;
    17c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c8:	a3 48 20 00 00       	mov    %eax,0x2048
}
    17cd:	c9                   	leave  
    17ce:	c3                   	ret    

000017cf <morecore>:

static Header*
morecore(uint nu)
{
    17cf:	55                   	push   %ebp
    17d0:	89 e5                	mov    %esp,%ebp
    17d2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17dc:	77 07                	ja     17e5 <morecore+0x16>
    nu = 4096;
    17de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17e5:	8b 45 08             	mov    0x8(%ebp),%eax
    17e8:	c1 e0 03             	shl    $0x3,%eax
    17eb:	89 04 24             	mov    %eax,(%esp)
    17ee:	e8 20 fc ff ff       	call   1413 <sbrk>
    17f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17fa:	75 07                	jne    1803 <morecore+0x34>
    return 0;
    17fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1801:	eb 22                	jmp    1825 <morecore+0x56>
  hp = (Header*)p;
    1803:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1809:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180c:	8b 55 08             	mov    0x8(%ebp),%edx
    180f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1812:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1815:	83 c0 08             	add    $0x8,%eax
    1818:	89 04 24             	mov    %eax,(%esp)
    181b:	e8 ce fe ff ff       	call   16ee <free>
  return freep;
    1820:	a1 48 20 00 00       	mov    0x2048,%eax
}
    1825:	c9                   	leave  
    1826:	c3                   	ret    

00001827 <malloc>:

void*
malloc(uint nbytes)
{
    1827:	55                   	push   %ebp
    1828:	89 e5                	mov    %esp,%ebp
    182a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    182d:	8b 45 08             	mov    0x8(%ebp),%eax
    1830:	83 c0 07             	add    $0x7,%eax
    1833:	c1 e8 03             	shr    $0x3,%eax
    1836:	83 c0 01             	add    $0x1,%eax
    1839:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    183c:	a1 48 20 00 00       	mov    0x2048,%eax
    1841:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1844:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1848:	75 23                	jne    186d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    184a:	c7 45 f0 40 20 00 00 	movl   $0x2040,-0x10(%ebp)
    1851:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1854:	a3 48 20 00 00       	mov    %eax,0x2048
    1859:	a1 48 20 00 00       	mov    0x2048,%eax
    185e:	a3 40 20 00 00       	mov    %eax,0x2040
    base.s.size = 0;
    1863:	c7 05 44 20 00 00 00 	movl   $0x0,0x2044
    186a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1870:	8b 00                	mov    (%eax),%eax
    1872:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1875:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1878:	8b 40 04             	mov    0x4(%eax),%eax
    187b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    187e:	72 4d                	jb     18cd <malloc+0xa6>
      if(p->s.size == nunits)
    1880:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1883:	8b 40 04             	mov    0x4(%eax),%eax
    1886:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1889:	75 0c                	jne    1897 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188e:	8b 10                	mov    (%eax),%edx
    1890:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1893:	89 10                	mov    %edx,(%eax)
    1895:	eb 26                	jmp    18bd <malloc+0x96>
      else {
        p->s.size -= nunits;
    1897:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189a:	8b 40 04             	mov    0x4(%eax),%eax
    189d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18a0:	89 c2                	mov    %eax,%edx
    18a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ab:	8b 40 04             	mov    0x4(%eax),%eax
    18ae:	c1 e0 03             	shl    $0x3,%eax
    18b1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c0:	a3 48 20 00 00       	mov    %eax,0x2048
      return (void*)(p + 1);
    18c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c8:	83 c0 08             	add    $0x8,%eax
    18cb:	eb 38                	jmp    1905 <malloc+0xde>
    }
    if(p == freep)
    18cd:	a1 48 20 00 00       	mov    0x2048,%eax
    18d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18d5:	75 1b                	jne    18f2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18da:	89 04 24             	mov    %eax,(%esp)
    18dd:	e8 ed fe ff ff       	call   17cf <morecore>
    18e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e9:	75 07                	jne    18f2 <malloc+0xcb>
        return 0;
    18eb:	b8 00 00 00 00       	mov    $0x0,%eax
    18f0:	eb 13                	jmp    1905 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18fb:	8b 00                	mov    (%eax),%eax
    18fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1900:	e9 70 ff ff ff       	jmp    1875 <malloc+0x4e>
}
    1905:	c9                   	leave  
    1906:	c3                   	ret    

00001907 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1907:	55                   	push   %ebp
    1908:	89 e5                	mov    %esp,%ebp
    190a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    190d:	8b 55 08             	mov    0x8(%ebp),%edx
    1910:	8b 45 0c             	mov    0xc(%ebp),%eax
    1913:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1916:	f0 87 02             	lock xchg %eax,(%edx)
    1919:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    191f:	c9                   	leave  
    1920:	c3                   	ret    

00001921 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1921:	55                   	push   %ebp
    1922:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1924:	8b 45 08             	mov    0x8(%ebp),%eax
    1927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    192d:	5d                   	pop    %ebp
    192e:	c3                   	ret    

0000192f <lock_acquire>:
void lock_acquire(lock_t *lock){
    192f:	55                   	push   %ebp
    1930:	89 e5                	mov    %esp,%ebp
    1932:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1935:	90                   	nop
    1936:	8b 45 08             	mov    0x8(%ebp),%eax
    1939:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1940:	00 
    1941:	89 04 24             	mov    %eax,(%esp)
    1944:	e8 be ff ff ff       	call   1907 <xchg>
    1949:	85 c0                	test   %eax,%eax
    194b:	75 e9                	jne    1936 <lock_acquire+0x7>
}
    194d:	c9                   	leave  
    194e:	c3                   	ret    

0000194f <lock_release>:
void lock_release(lock_t *lock){
    194f:	55                   	push   %ebp
    1950:	89 e5                	mov    %esp,%ebp
    1952:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1955:	8b 45 08             	mov    0x8(%ebp),%eax
    1958:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    195f:	00 
    1960:	89 04 24             	mov    %eax,(%esp)
    1963:	e8 9f ff ff ff       	call   1907 <xchg>
}
    1968:	c9                   	leave  
    1969:	c3                   	ret    

0000196a <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    196a:	55                   	push   %ebp
    196b:	89 e5                	mov    %esp,%ebp
    196d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1970:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1977:	e8 ab fe ff ff       	call   1827 <malloc>
    197c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1982:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1985:	0f b6 05 4c 20 00 00 	movzbl 0x204c,%eax
    198c:	84 c0                	test   %al,%al
    198e:	75 1c                	jne    19ac <thread_create+0x42>
        init_q(thQ2);
    1990:	a1 50 20 00 00       	mov    0x2050,%eax
    1995:	89 04 24             	mov    %eax,(%esp)
    1998:	e8 2c 01 00 00       	call   1ac9 <init_q>
        inQ++;
    199d:	0f b6 05 4c 20 00 00 	movzbl 0x204c,%eax
    19a4:	83 c0 01             	add    $0x1,%eax
    19a7:	a2 4c 20 00 00       	mov    %al,0x204c
    }

    if((uint)stack % 4096){
    19ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19af:	25 ff 0f 00 00       	and    $0xfff,%eax
    19b4:	85 c0                	test   %eax,%eax
    19b6:	74 14                	je     19cc <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19bb:	25 ff 0f 00 00       	and    $0xfff,%eax
    19c0:	89 c2                	mov    %eax,%edx
    19c2:	b8 00 10 00 00       	mov    $0x1000,%eax
    19c7:	29 d0                	sub    %edx,%eax
    19c9:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19d0:	75 1e                	jne    19f0 <thread_create+0x86>

        printf(1,"malloc fail \n");
    19d2:	c7 44 24 04 43 1c 00 	movl   $0x1c43,0x4(%esp)
    19d9:	00 
    19da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19e1:	e8 55 fb ff ff       	call   153b <printf>
        return 0;
    19e6:	b8 00 00 00 00       	mov    $0x0,%eax
    19eb:	e9 83 00 00 00       	jmp    1a73 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    19f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    19f3:	8b 55 08             	mov    0x8(%ebp),%edx
    19f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    19fd:	89 54 24 08          	mov    %edx,0x8(%esp)
    1a01:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a08:	00 
    1a09:	89 04 24             	mov    %eax,(%esp)
    1a0c:	e8 1a fa ff ff       	call   142b <clone>
    1a11:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    1a14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a18:	79 1b                	jns    1a35 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1a1a:	c7 44 24 04 51 1c 00 	movl   $0x1c51,0x4(%esp)
    1a21:	00 
    1a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a29:	e8 0d fb ff ff       	call   153b <printf>
        return 0;
    1a2e:	b8 00 00 00 00       	mov    $0x0,%eax
    1a33:	eb 3e                	jmp    1a73 <thread_create+0x109>
    }
    if(tid > 0){
    1a35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a39:	7e 19                	jle    1a54 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1a3b:	a1 50 20 00 00       	mov    0x2050,%eax
    1a40:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a43:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a47:	89 04 24             	mov    %eax,(%esp)
    1a4a:	e8 9c 00 00 00       	call   1aeb <add_q>
        return garbage_stack;
    1a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a52:	eb 1f                	jmp    1a73 <thread_create+0x109>
    }
    if(tid == 0){
    1a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a58:	75 14                	jne    1a6e <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a5a:	c7 44 24 04 5e 1c 00 	movl   $0x1c5e,0x4(%esp)
    1a61:	00 
    1a62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a69:	e8 cd fa ff ff       	call   153b <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a73:	c9                   	leave  
    1a74:	c3                   	ret    

00001a75 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a75:	55                   	push   %ebp
    1a76:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a78:	a1 3c 20 00 00       	mov    0x203c,%eax
    1a7d:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a83:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a88:	a3 3c 20 00 00       	mov    %eax,0x203c
    return (int)(rands % max);
    1a8d:	a1 3c 20 00 00       	mov    0x203c,%eax
    1a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a95:	ba 00 00 00 00       	mov    $0x0,%edx
    1a9a:	f7 f1                	div    %ecx
    1a9c:	89 d0                	mov    %edx,%eax
}
    1a9e:	5d                   	pop    %ebp
    1a9f:	c3                   	ret    

00001aa0 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1aa0:	55                   	push   %ebp
    1aa1:	89 e5                	mov    %esp,%ebp
    1aa3:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
    1aa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    1aac:	8b 40 10             	mov    0x10(%eax),%eax
    1aaf:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ab3:	c7 44 24 04 6f 1c 00 	movl   $0x1c6f,0x4(%esp)
    1aba:	00 
    1abb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ac2:	e8 74 fa ff ff       	call   153b <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
    1ac7:	c9                   	leave  
    1ac8:	c3                   	ret    

00001ac9 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ac9:	55                   	push   %ebp
    1aca:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1acc:	8b 45 08             	mov    0x8(%ebp),%eax
    1acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1ad5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1adf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ae9:	5d                   	pop    %ebp
    1aea:	c3                   	ret    

00001aeb <add_q>:

void add_q(struct queue *q, int v){
    1aeb:	55                   	push   %ebp
    1aec:	89 e5                	mov    %esp,%ebp
    1aee:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1af1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1af8:	e8 2a fd ff ff       	call   1827 <malloc>
    1afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b10:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b12:	8b 45 08             	mov    0x8(%ebp),%eax
    1b15:	8b 40 04             	mov    0x4(%eax),%eax
    1b18:	85 c0                	test   %eax,%eax
    1b1a:	75 0b                	jne    1b27 <add_q+0x3c>
        q->head = n;
    1b1c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b22:	89 50 04             	mov    %edx,0x4(%eax)
    1b25:	eb 0c                	jmp    1b33 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b27:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2a:	8b 40 08             	mov    0x8(%eax),%eax
    1b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b30:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b33:	8b 45 08             	mov    0x8(%ebp),%eax
    1b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b39:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3f:	8b 00                	mov    (%eax),%eax
    1b41:	8d 50 01             	lea    0x1(%eax),%edx
    1b44:	8b 45 08             	mov    0x8(%ebp),%eax
    1b47:	89 10                	mov    %edx,(%eax)
}
    1b49:	c9                   	leave  
    1b4a:	c3                   	ret    

00001b4b <empty_q>:

int empty_q(struct queue *q){
    1b4b:	55                   	push   %ebp
    1b4c:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b4e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b51:	8b 00                	mov    (%eax),%eax
    1b53:	85 c0                	test   %eax,%eax
    1b55:	75 07                	jne    1b5e <empty_q+0x13>
        return 1;
    1b57:	b8 01 00 00 00       	mov    $0x1,%eax
    1b5c:	eb 05                	jmp    1b63 <empty_q+0x18>
    else
        return 0;
    1b5e:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b63:	5d                   	pop    %ebp
    1b64:	c3                   	ret    

00001b65 <pop_q>:
int pop_q(struct queue *q){
    1b65:	55                   	push   %ebp
    1b66:	89 e5                	mov    %esp,%ebp
    1b68:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b6b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6e:	89 04 24             	mov    %eax,(%esp)
    1b71:	e8 d5 ff ff ff       	call   1b4b <empty_q>
    1b76:	85 c0                	test   %eax,%eax
    1b78:	75 5d                	jne    1bd7 <pop_q+0x72>
       val = q->head->value; 
    1b7a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7d:	8b 40 04             	mov    0x4(%eax),%eax
    1b80:	8b 00                	mov    (%eax),%eax
    1b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b85:	8b 45 08             	mov    0x8(%ebp),%eax
    1b88:	8b 40 04             	mov    0x4(%eax),%eax
    1b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b8e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b91:	8b 40 04             	mov    0x4(%eax),%eax
    1b94:	8b 50 04             	mov    0x4(%eax),%edx
    1b97:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9a:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ba0:	89 04 24             	mov    %eax,(%esp)
    1ba3:	e8 46 fb ff ff       	call   16ee <free>
       q->size--;
    1ba8:	8b 45 08             	mov    0x8(%ebp),%eax
    1bab:	8b 00                	mov    (%eax),%eax
    1bad:	8d 50 ff             	lea    -0x1(%eax),%edx
    1bb0:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb3:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1bb5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb8:	8b 00                	mov    (%eax),%eax
    1bba:	85 c0                	test   %eax,%eax
    1bbc:	75 14                	jne    1bd2 <pop_q+0x6d>
            q->head = 0;
    1bbe:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bc8:	8b 45 08             	mov    0x8(%ebp),%eax
    1bcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd5:	eb 05                	jmp    1bdc <pop_q+0x77>
    }
    return -1;
    1bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1bdc:	c9                   	leave  
    1bdd:	c3                   	ret    
