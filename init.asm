
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
    1011:	c7 04 24 cd 1b 00 00 	movl   $0x1bcd,(%esp)
    1018:	e8 9a 03 00 00       	call   13b7 <open>
    101d:	85 c0                	test   %eax,%eax
    101f:	79 30                	jns    1051 <main+0x51>
    mknod("console", 1, 1);
    1021:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1028:	00 
    1029:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 cd 1b 00 00 	movl   $0x1bcd,(%esp)
    1038:	e8 82 03 00 00       	call   13bf <mknod>
    open("console", O_RDWR);
    103d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 cd 1b 00 00 	movl   $0x1bcd,(%esp)
    104c:	e8 66 03 00 00       	call   13b7 <open>
  }
  dup(0);  // stdout
    1051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1058:	e8 92 03 00 00       	call   13ef <dup>
  dup(0);  // stderr
    105d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1064:	e8 86 03 00 00       	call   13ef <dup>

  for(;;){
    printf(1, "init: starting sh\n");
    1069:	c7 44 24 04 d5 1b 00 	movl   $0x1bd5,0x4(%esp)
    1070:	00 
    1071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1078:	e8 aa 04 00 00       	call   1527 <printf>
    pid = fork();
    107d:	e8 ed 02 00 00       	call   136f <fork>
    1082:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
    1086:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    108b:	79 19                	jns    10a6 <main+0xa6>
      printf(1, "init: fork failed\n");
    108d:	c7 44 24 04 e8 1b 00 	movl   $0x1be8,0x4(%esp)
    1094:	00 
    1095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109c:	e8 86 04 00 00       	call   1527 <printf>
      exit();
    10a1:	e8 d1 02 00 00       	call   1377 <exit>
    }
    if(pid == 0){
    10a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    10ab:	75 2d                	jne    10da <main+0xda>
      //printf(1,"init to exec\n");
      exec("sh", argv);
    10ad:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
    10b4:	00 
    10b5:	c7 04 24 ca 1b 00 00 	movl   $0x1bca,(%esp)
    10bc:	e8 ee 02 00 00       	call   13af <exec>
      printf(1, "init: exec sh failed\n");
    10c1:	c7 44 24 04 fb 1b 00 	movl   $0x1bfb,0x4(%esp)
    10c8:	00 
    10c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d0:	e8 52 04 00 00       	call   1527 <printf>
      exit();
    10d5:	e8 9d 02 00 00       	call   1377 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10da:	eb 14                	jmp    10f0 <main+0xf0>
      printf(1, "zombie!\n");
    10dc:	c7 44 24 04 11 1c 00 	movl   $0x1c11,0x4(%esp)
    10e3:	00 
    10e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10eb:	e8 37 04 00 00       	call   1527 <printf>
      //printf(1,"init to exec\n");
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10f0:	e8 8a 02 00 00       	call   137f <wait>
    10f5:	89 44 24 18          	mov    %eax,0x18(%esp)
    10f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10fe:	78 0a                	js     110a <main+0x10a>
    1100:	8b 44 24 18          	mov    0x18(%esp),%eax
    1104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
    1108:	75 d2                	jne    10dc <main+0xdc>
      printf(1, "zombie!\n");
  }
    110a:	e9 5a ff ff ff       	jmp    1069 <main+0x69>

0000110f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	57                   	push   %edi
    1113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1114:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1117:	8b 55 10             	mov    0x10(%ebp),%edx
    111a:	8b 45 0c             	mov    0xc(%ebp),%eax
    111d:	89 cb                	mov    %ecx,%ebx
    111f:	89 df                	mov    %ebx,%edi
    1121:	89 d1                	mov    %edx,%ecx
    1123:	fc                   	cld    
    1124:	f3 aa                	rep stos %al,%es:(%edi)
    1126:	89 ca                	mov    %ecx,%edx
    1128:	89 fb                	mov    %edi,%ebx
    112a:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1130:	5b                   	pop    %ebx
    1131:	5f                   	pop    %edi
    1132:	5d                   	pop    %ebp
    1133:	c3                   	ret    

00001134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113a:	8b 45 08             	mov    0x8(%ebp),%eax
    113d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1140:	90                   	nop
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
    1144:	8d 50 01             	lea    0x1(%eax),%edx
    1147:	89 55 08             	mov    %edx,0x8(%ebp)
    114a:	8b 55 0c             	mov    0xc(%ebp),%edx
    114d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1153:	0f b6 12             	movzbl (%edx),%edx
    1156:	88 10                	mov    %dl,(%eax)
    1158:	0f b6 00             	movzbl (%eax),%eax
    115b:	84 c0                	test   %al,%al
    115d:	75 e2                	jne    1141 <strcpy+0xd>
    ;
  return os;
    115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1162:	c9                   	leave  
    1163:	c3                   	ret    

00001164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1167:	eb 08                	jmp    1171 <strcmp+0xd>
    p++, q++;
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	0f b6 00             	movzbl (%eax),%eax
    1177:	84 c0                	test   %al,%al
    1179:	74 10                	je     118b <strcmp+0x27>
    117b:	8b 45 08             	mov    0x8(%ebp),%eax
    117e:	0f b6 10             	movzbl (%eax),%edx
    1181:	8b 45 0c             	mov    0xc(%ebp),%eax
    1184:	0f b6 00             	movzbl (%eax),%eax
    1187:	38 c2                	cmp    %al,%dl
    1189:	74 de                	je     1169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	0f b6 00             	movzbl (%eax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	8b 45 0c             	mov    0xc(%ebp),%eax
    1197:	0f b6 00             	movzbl (%eax),%eax
    119a:	0f b6 c0             	movzbl %al,%eax
    119d:	29 c2                	sub    %eax,%edx
    119f:	89 d0                	mov    %edx,%eax
}
    11a1:	5d                   	pop    %ebp
    11a2:	c3                   	ret    

000011a3 <strlen>:

uint
strlen(char *s)
{
    11a3:	55                   	push   %ebp
    11a4:	89 e5                	mov    %esp,%ebp
    11a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b0:	eb 04                	jmp    11b6 <strlen+0x13>
    11b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 d0                	add    %edx,%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	84 c0                	test   %al,%al
    11c3:	75 ed                	jne    11b2 <strlen+0xf>
    ;
  return n;
    11c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c8:	c9                   	leave  
    11c9:	c3                   	ret    

000011ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    11ca:	55                   	push   %ebp
    11cb:	89 e5                	mov    %esp,%ebp
    11cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d0:	8b 45 10             	mov    0x10(%ebp),%eax
    11d3:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11da:	89 44 24 04          	mov    %eax,0x4(%esp)
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	89 04 24             	mov    %eax,(%esp)
    11e4:	e8 26 ff ff ff       	call   110f <stosb>
  return dst;
    11e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ec:	c9                   	leave  
    11ed:	c3                   	ret    

000011ee <strchr>:

char*
strchr(const char *s, char c)
{
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 04             	sub    $0x4,%esp
    11f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11fa:	eb 14                	jmp    1210 <strchr+0x22>
    if(*s == c)
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	0f b6 00             	movzbl (%eax),%eax
    1202:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1205:	75 05                	jne    120c <strchr+0x1e>
      return (char*)s;
    1207:	8b 45 08             	mov    0x8(%ebp),%eax
    120a:	eb 13                	jmp    121f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    120c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	0f b6 00             	movzbl (%eax),%eax
    1216:	84 c0                	test   %al,%al
    1218:	75 e2                	jne    11fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    121a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121f:	c9                   	leave  
    1220:	c3                   	ret    

00001221 <gets>:

char*
gets(char *buf, int max)
{
    1221:	55                   	push   %ebp
    1222:	89 e5                	mov    %esp,%ebp
    1224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    122e:	eb 4c                	jmp    127c <gets+0x5b>
    cc = read(0, &c, 1);
    1230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1237:	00 
    1238:	8d 45 ef             	lea    -0x11(%ebp),%eax
    123b:	89 44 24 04          	mov    %eax,0x4(%esp)
    123f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1246:	e8 44 01 00 00       	call   138f <read>
    124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    124e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1252:	7f 02                	jg     1256 <gets+0x35>
      break;
    1254:	eb 31                	jmp    1287 <gets+0x66>
    buf[i++] = c;
    1256:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    125f:	89 c2                	mov    %eax,%edx
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	01 c2                	add    %eax,%edx
    1266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    126a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    126c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1270:	3c 0a                	cmp    $0xa,%al
    1272:	74 13                	je     1287 <gets+0x66>
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	3c 0d                	cmp    $0xd,%al
    127a:	74 0b                	je     1287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	83 c0 01             	add    $0x1,%eax
    1282:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1285:	7c a9                	jl     1230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1287:	8b 55 f4             	mov    -0xc(%ebp),%edx
    128a:	8b 45 08             	mov    0x8(%ebp),%eax
    128d:	01 d0                	add    %edx,%eax
    128f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1295:	c9                   	leave  
    1296:	c3                   	ret    

00001297 <stat>:

int
stat(char *n, struct stat *st)
{
    1297:	55                   	push   %ebp
    1298:	89 e5                	mov    %esp,%ebp
    129a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12a4:	00 
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	89 04 24             	mov    %eax,(%esp)
    12ab:	e8 07 01 00 00       	call   13b7 <open>
    12b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12b7:	79 07                	jns    12c0 <stat+0x29>
    return -1;
    12b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12be:	eb 23                	jmp    12e3 <stat+0x4c>
  r = fstat(fd, st);
    12c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 fd 00 00 00       	call   13cf <fstat>
    12d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 bf 00 00 00       	call   139f <close>
  return r;
    12e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <atoi>:

int
atoi(const char *s)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
    12e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12f2:	eb 25                	jmp    1319 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12f7:	89 d0                	mov    %edx,%eax
    12f9:	c1 e0 02             	shl    $0x2,%eax
    12fc:	01 d0                	add    %edx,%eax
    12fe:	01 c0                	add    %eax,%eax
    1300:	89 c1                	mov    %eax,%ecx
    1302:	8b 45 08             	mov    0x8(%ebp),%eax
    1305:	8d 50 01             	lea    0x1(%eax),%edx
    1308:	89 55 08             	mov    %edx,0x8(%ebp)
    130b:	0f b6 00             	movzbl (%eax),%eax
    130e:	0f be c0             	movsbl %al,%eax
    1311:	01 c8                	add    %ecx,%eax
    1313:	83 e8 30             	sub    $0x30,%eax
    1316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1319:	8b 45 08             	mov    0x8(%ebp),%eax
    131c:	0f b6 00             	movzbl (%eax),%eax
    131f:	3c 2f                	cmp    $0x2f,%al
    1321:	7e 0a                	jle    132d <atoi+0x48>
    1323:	8b 45 08             	mov    0x8(%ebp),%eax
    1326:	0f b6 00             	movzbl (%eax),%eax
    1329:	3c 39                	cmp    $0x39,%al
    132b:	7e c7                	jle    12f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1330:	c9                   	leave  
    1331:	c3                   	ret    

00001332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1332:	55                   	push   %ebp
    1333:	89 e5                	mov    %esp,%ebp
    1335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1338:	8b 45 08             	mov    0x8(%ebp),%eax
    133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    133e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1344:	eb 17                	jmp    135d <memmove+0x2b>
    *dst++ = *src++;
    1346:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1349:	8d 50 01             	lea    0x1(%eax),%edx
    134c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1352:	8d 4a 01             	lea    0x1(%edx),%ecx
    1355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1358:	0f b6 12             	movzbl (%edx),%edx
    135b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    135d:	8b 45 10             	mov    0x10(%ebp),%eax
    1360:	8d 50 ff             	lea    -0x1(%eax),%edx
    1363:	89 55 10             	mov    %edx,0x10(%ebp)
    1366:	85 c0                	test   %eax,%eax
    1368:	7f dc                	jg     1346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136d:	c9                   	leave  
    136e:	c3                   	ret    

0000136f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136f:	b8 01 00 00 00       	mov    $0x1,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <exit>:
SYSCALL(exit)
    1377:	b8 02 00 00 00       	mov    $0x2,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <wait>:
SYSCALL(wait)
    137f:	b8 03 00 00 00       	mov    $0x3,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <pipe>:
SYSCALL(pipe)
    1387:	b8 04 00 00 00       	mov    $0x4,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <read>:
SYSCALL(read)
    138f:	b8 05 00 00 00       	mov    $0x5,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <write>:
SYSCALL(write)
    1397:	b8 10 00 00 00       	mov    $0x10,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <close>:
SYSCALL(close)
    139f:	b8 15 00 00 00       	mov    $0x15,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <kill>:
SYSCALL(kill)
    13a7:	b8 06 00 00 00       	mov    $0x6,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <exec>:
SYSCALL(exec)
    13af:	b8 07 00 00 00       	mov    $0x7,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <open>:
SYSCALL(open)
    13b7:	b8 0f 00 00 00       	mov    $0xf,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <mknod>:
SYSCALL(mknod)
    13bf:	b8 11 00 00 00       	mov    $0x11,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <unlink>:
SYSCALL(unlink)
    13c7:	b8 12 00 00 00       	mov    $0x12,%eax
    13cc:	cd 40                	int    $0x40
    13ce:	c3                   	ret    

000013cf <fstat>:
SYSCALL(fstat)
    13cf:	b8 08 00 00 00       	mov    $0x8,%eax
    13d4:	cd 40                	int    $0x40
    13d6:	c3                   	ret    

000013d7 <link>:
SYSCALL(link)
    13d7:	b8 13 00 00 00       	mov    $0x13,%eax
    13dc:	cd 40                	int    $0x40
    13de:	c3                   	ret    

000013df <mkdir>:
SYSCALL(mkdir)
    13df:	b8 14 00 00 00       	mov    $0x14,%eax
    13e4:	cd 40                	int    $0x40
    13e6:	c3                   	ret    

000013e7 <chdir>:
SYSCALL(chdir)
    13e7:	b8 09 00 00 00       	mov    $0x9,%eax
    13ec:	cd 40                	int    $0x40
    13ee:	c3                   	ret    

000013ef <dup>:
SYSCALL(dup)
    13ef:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f4:	cd 40                	int    $0x40
    13f6:	c3                   	ret    

000013f7 <getpid>:
SYSCALL(getpid)
    13f7:	b8 0b 00 00 00       	mov    $0xb,%eax
    13fc:	cd 40                	int    $0x40
    13fe:	c3                   	ret    

000013ff <sbrk>:
SYSCALL(sbrk)
    13ff:	b8 0c 00 00 00       	mov    $0xc,%eax
    1404:	cd 40                	int    $0x40
    1406:	c3                   	ret    

00001407 <sleep>:
SYSCALL(sleep)
    1407:	b8 0d 00 00 00       	mov    $0xd,%eax
    140c:	cd 40                	int    $0x40
    140e:	c3                   	ret    

0000140f <uptime>:
SYSCALL(uptime)
    140f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1414:	cd 40                	int    $0x40
    1416:	c3                   	ret    

00001417 <clone>:
SYSCALL(clone)
    1417:	b8 16 00 00 00       	mov    $0x16,%eax
    141c:	cd 40                	int    $0x40
    141e:	c3                   	ret    

0000141f <texit>:
SYSCALL(texit)
    141f:	b8 17 00 00 00       	mov    $0x17,%eax
    1424:	cd 40                	int    $0x40
    1426:	c3                   	ret    

00001427 <tsleep>:
SYSCALL(tsleep)
    1427:	b8 18 00 00 00       	mov    $0x18,%eax
    142c:	cd 40                	int    $0x40
    142e:	c3                   	ret    

0000142f <twakeup>:
SYSCALL(twakeup)
    142f:	b8 19 00 00 00       	mov    $0x19,%eax
    1434:	cd 40                	int    $0x40
    1436:	c3                   	ret    

00001437 <thread_yield>:
SYSCALL(thread_yield)
    1437:	b8 1a 00 00 00       	mov    $0x1a,%eax
    143c:	cd 40                	int    $0x40
    143e:	c3                   	ret    

0000143f <thread_yield3>:
    143f:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1444:	cd 40                	int    $0x40
    1446:	c3                   	ret    

00001447 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1447:	55                   	push   %ebp
    1448:	89 e5                	mov    %esp,%ebp
    144a:	83 ec 18             	sub    $0x18,%esp
    144d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1450:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1453:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    145a:	00 
    145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    145e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1462:	8b 45 08             	mov    0x8(%ebp),%eax
    1465:	89 04 24             	mov    %eax,(%esp)
    1468:	e8 2a ff ff ff       	call   1397 <write>
}
    146d:	c9                   	leave  
    146e:	c3                   	ret    

0000146f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    146f:	55                   	push   %ebp
    1470:	89 e5                	mov    %esp,%ebp
    1472:	56                   	push   %esi
    1473:	53                   	push   %ebx
    1474:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    147e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1482:	74 17                	je     149b <printint+0x2c>
    1484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1488:	79 11                	jns    149b <printint+0x2c>
    neg = 1;
    148a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1491:	8b 45 0c             	mov    0xc(%ebp),%eax
    1494:	f7 d8                	neg    %eax
    1496:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1499:	eb 06                	jmp    14a1 <printint+0x32>
  } else {
    x = xx;
    149b:	8b 45 0c             	mov    0xc(%ebp),%eax
    149e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14ab:	8d 41 01             	lea    0x1(%ecx),%eax
    14ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b7:	ba 00 00 00 00       	mov    $0x0,%edx
    14bc:	f7 f3                	div    %ebx
    14be:	89 d0                	mov    %edx,%eax
    14c0:	0f b6 80 08 20 00 00 	movzbl 0x2008(%eax),%eax
    14c7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14cb:	8b 75 10             	mov    0x10(%ebp),%esi
    14ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14d1:	ba 00 00 00 00       	mov    $0x0,%edx
    14d6:	f7 f6                	div    %esi
    14d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14df:	75 c7                	jne    14a8 <printint+0x39>
  if(neg)
    14e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14e5:	74 10                	je     14f7 <printint+0x88>
    buf[i++] = '-';
    14e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ea:	8d 50 01             	lea    0x1(%eax),%edx
    14ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14f0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14f5:	eb 1f                	jmp    1516 <printint+0xa7>
    14f7:	eb 1d                	jmp    1516 <printint+0xa7>
    putc(fd, buf[i]);
    14f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ff:	01 d0                	add    %edx,%eax
    1501:	0f b6 00             	movzbl (%eax),%eax
    1504:	0f be c0             	movsbl %al,%eax
    1507:	89 44 24 04          	mov    %eax,0x4(%esp)
    150b:	8b 45 08             	mov    0x8(%ebp),%eax
    150e:	89 04 24             	mov    %eax,(%esp)
    1511:	e8 31 ff ff ff       	call   1447 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1516:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    151a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    151e:	79 d9                	jns    14f9 <printint+0x8a>
    putc(fd, buf[i]);
}
    1520:	83 c4 30             	add    $0x30,%esp
    1523:	5b                   	pop    %ebx
    1524:	5e                   	pop    %esi
    1525:	5d                   	pop    %ebp
    1526:	c3                   	ret    

00001527 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1527:	55                   	push   %ebp
    1528:	89 e5                	mov    %esp,%ebp
    152a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    152d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1534:	8d 45 0c             	lea    0xc(%ebp),%eax
    1537:	83 c0 04             	add    $0x4,%eax
    153a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    153d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1544:	e9 7c 01 00 00       	jmp    16c5 <printf+0x19e>
    c = fmt[i] & 0xff;
    1549:	8b 55 0c             	mov    0xc(%ebp),%edx
    154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    154f:	01 d0                	add    %edx,%eax
    1551:	0f b6 00             	movzbl (%eax),%eax
    1554:	0f be c0             	movsbl %al,%eax
    1557:	25 ff 00 00 00       	and    $0xff,%eax
    155c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    155f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1563:	75 2c                	jne    1591 <printf+0x6a>
      if(c == '%'){
    1565:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1569:	75 0c                	jne    1577 <printf+0x50>
        state = '%';
    156b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1572:	e9 4a 01 00 00       	jmp    16c1 <printf+0x19a>
      } else {
        putc(fd, c);
    1577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    157a:	0f be c0             	movsbl %al,%eax
    157d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1581:	8b 45 08             	mov    0x8(%ebp),%eax
    1584:	89 04 24             	mov    %eax,(%esp)
    1587:	e8 bb fe ff ff       	call   1447 <putc>
    158c:	e9 30 01 00 00       	jmp    16c1 <printf+0x19a>
      }
    } else if(state == '%'){
    1591:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1595:	0f 85 26 01 00 00    	jne    16c1 <printf+0x19a>
      if(c == 'd'){
    159b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    159f:	75 2d                	jne    15ce <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15a4:	8b 00                	mov    (%eax),%eax
    15a6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15ad:	00 
    15ae:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15b5:	00 
    15b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ba:	8b 45 08             	mov    0x8(%ebp),%eax
    15bd:	89 04 24             	mov    %eax,(%esp)
    15c0:	e8 aa fe ff ff       	call   146f <printint>
        ap++;
    15c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15c9:	e9 ec 00 00 00       	jmp    16ba <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15ce:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15d2:	74 06                	je     15da <printf+0xb3>
    15d4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15d8:	75 2d                	jne    1607 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15da:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15dd:	8b 00                	mov    (%eax),%eax
    15df:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15e6:	00 
    15e7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15ee:	00 
    15ef:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f3:	8b 45 08             	mov    0x8(%ebp),%eax
    15f6:	89 04 24             	mov    %eax,(%esp)
    15f9:	e8 71 fe ff ff       	call   146f <printint>
        ap++;
    15fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1602:	e9 b3 00 00 00       	jmp    16ba <printf+0x193>
      } else if(c == 's'){
    1607:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    160b:	75 45                	jne    1652 <printf+0x12b>
        s = (char*)*ap;
    160d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1610:	8b 00                	mov    (%eax),%eax
    1612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    161d:	75 09                	jne    1628 <printf+0x101>
          s = "(null)";
    161f:	c7 45 f4 1a 1c 00 00 	movl   $0x1c1a,-0xc(%ebp)
        while(*s != 0){
    1626:	eb 1e                	jmp    1646 <printf+0x11f>
    1628:	eb 1c                	jmp    1646 <printf+0x11f>
          putc(fd, *s);
    162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162d:	0f b6 00             	movzbl (%eax),%eax
    1630:	0f be c0             	movsbl %al,%eax
    1633:	89 44 24 04          	mov    %eax,0x4(%esp)
    1637:	8b 45 08             	mov    0x8(%ebp),%eax
    163a:	89 04 24             	mov    %eax,(%esp)
    163d:	e8 05 fe ff ff       	call   1447 <putc>
          s++;
    1642:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1646:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1649:	0f b6 00             	movzbl (%eax),%eax
    164c:	84 c0                	test   %al,%al
    164e:	75 da                	jne    162a <printf+0x103>
    1650:	eb 68                	jmp    16ba <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1652:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1656:	75 1d                	jne    1675 <printf+0x14e>
        putc(fd, *ap);
    1658:	8b 45 e8             	mov    -0x18(%ebp),%eax
    165b:	8b 00                	mov    (%eax),%eax
    165d:	0f be c0             	movsbl %al,%eax
    1660:	89 44 24 04          	mov    %eax,0x4(%esp)
    1664:	8b 45 08             	mov    0x8(%ebp),%eax
    1667:	89 04 24             	mov    %eax,(%esp)
    166a:	e8 d8 fd ff ff       	call   1447 <putc>
        ap++;
    166f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1673:	eb 45                	jmp    16ba <printf+0x193>
      } else if(c == '%'){
    1675:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1679:	75 17                	jne    1692 <printf+0x16b>
        putc(fd, c);
    167b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    167e:	0f be c0             	movsbl %al,%eax
    1681:	89 44 24 04          	mov    %eax,0x4(%esp)
    1685:	8b 45 08             	mov    0x8(%ebp),%eax
    1688:	89 04 24             	mov    %eax,(%esp)
    168b:	e8 b7 fd ff ff       	call   1447 <putc>
    1690:	eb 28                	jmp    16ba <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1692:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1699:	00 
    169a:	8b 45 08             	mov    0x8(%ebp),%eax
    169d:	89 04 24             	mov    %eax,(%esp)
    16a0:	e8 a2 fd ff ff       	call   1447 <putc>
        putc(fd, c);
    16a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16a8:	0f be c0             	movsbl %al,%eax
    16ab:	89 44 24 04          	mov    %eax,0x4(%esp)
    16af:	8b 45 08             	mov    0x8(%ebp),%eax
    16b2:	89 04 24             	mov    %eax,(%esp)
    16b5:	e8 8d fd ff ff       	call   1447 <putc>
      }
      state = 0;
    16ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16c5:	8b 55 0c             	mov    0xc(%ebp),%edx
    16c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16cb:	01 d0                	add    %edx,%eax
    16cd:	0f b6 00             	movzbl (%eax),%eax
    16d0:	84 c0                	test   %al,%al
    16d2:	0f 85 71 fe ff ff    	jne    1549 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16d8:	c9                   	leave  
    16d9:	c3                   	ret    

000016da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16da:	55                   	push   %ebp
    16db:	89 e5                	mov    %esp,%ebp
    16dd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16e0:	8b 45 08             	mov    0x8(%ebp),%eax
    16e3:	83 e8 08             	sub    $0x8,%eax
    16e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e9:	a1 28 20 00 00       	mov    0x2028,%eax
    16ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16f1:	eb 24                	jmp    1717 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	8b 00                	mov    (%eax),%eax
    16f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16fb:	77 12                	ja     170f <free+0x35>
    16fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1700:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1703:	77 24                	ja     1729 <free+0x4f>
    1705:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1708:	8b 00                	mov    (%eax),%eax
    170a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    170d:	77 1a                	ja     1729 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1712:	8b 00                	mov    (%eax),%eax
    1714:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1717:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    171d:	76 d4                	jbe    16f3 <free+0x19>
    171f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1722:	8b 00                	mov    (%eax),%eax
    1724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1727:	76 ca                	jbe    16f3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1729:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172c:	8b 40 04             	mov    0x4(%eax),%eax
    172f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1736:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1739:	01 c2                	add    %eax,%edx
    173b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173e:	8b 00                	mov    (%eax),%eax
    1740:	39 c2                	cmp    %eax,%edx
    1742:	75 24                	jne    1768 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1744:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1747:	8b 50 04             	mov    0x4(%eax),%edx
    174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174d:	8b 00                	mov    (%eax),%eax
    174f:	8b 40 04             	mov    0x4(%eax),%eax
    1752:	01 c2                	add    %eax,%edx
    1754:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1757:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    175a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175d:	8b 00                	mov    (%eax),%eax
    175f:	8b 10                	mov    (%eax),%edx
    1761:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1764:	89 10                	mov    %edx,(%eax)
    1766:	eb 0a                	jmp    1772 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1768:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176b:	8b 10                	mov    (%eax),%edx
    176d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1770:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1772:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1775:	8b 40 04             	mov    0x4(%eax),%eax
    1778:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    177f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1782:	01 d0                	add    %edx,%eax
    1784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1787:	75 20                	jne    17a9 <free+0xcf>
    p->s.size += bp->s.size;
    1789:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178c:	8b 50 04             	mov    0x4(%eax),%edx
    178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1792:	8b 40 04             	mov    0x4(%eax),%eax
    1795:	01 c2                	add    %eax,%edx
    1797:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a0:	8b 10                	mov    (%eax),%edx
    17a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a5:	89 10                	mov    %edx,(%eax)
    17a7:	eb 08                	jmp    17b1 <free+0xd7>
  } else
    p->s.ptr = bp;
    17a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17af:	89 10                	mov    %edx,(%eax)
  freep = p;
    17b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b4:	a3 28 20 00 00       	mov    %eax,0x2028
}
    17b9:	c9                   	leave  
    17ba:	c3                   	ret    

000017bb <morecore>:

static Header*
morecore(uint nu)
{
    17bb:	55                   	push   %ebp
    17bc:	89 e5                	mov    %esp,%ebp
    17be:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17c1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17c8:	77 07                	ja     17d1 <morecore+0x16>
    nu = 4096;
    17ca:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17d1:	8b 45 08             	mov    0x8(%ebp),%eax
    17d4:	c1 e0 03             	shl    $0x3,%eax
    17d7:	89 04 24             	mov    %eax,(%esp)
    17da:	e8 20 fc ff ff       	call   13ff <sbrk>
    17df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17e2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17e6:	75 07                	jne    17ef <morecore+0x34>
    return 0;
    17e8:	b8 00 00 00 00       	mov    $0x0,%eax
    17ed:	eb 22                	jmp    1811 <morecore+0x56>
  hp = (Header*)p;
    17ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f8:	8b 55 08             	mov    0x8(%ebp),%edx
    17fb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1801:	83 c0 08             	add    $0x8,%eax
    1804:	89 04 24             	mov    %eax,(%esp)
    1807:	e8 ce fe ff ff       	call   16da <free>
  return freep;
    180c:	a1 28 20 00 00       	mov    0x2028,%eax
}
    1811:	c9                   	leave  
    1812:	c3                   	ret    

00001813 <malloc>:

void*
malloc(uint nbytes)
{
    1813:	55                   	push   %ebp
    1814:	89 e5                	mov    %esp,%ebp
    1816:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1819:	8b 45 08             	mov    0x8(%ebp),%eax
    181c:	83 c0 07             	add    $0x7,%eax
    181f:	c1 e8 03             	shr    $0x3,%eax
    1822:	83 c0 01             	add    $0x1,%eax
    1825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1828:	a1 28 20 00 00       	mov    0x2028,%eax
    182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1830:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1834:	75 23                	jne    1859 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1836:	c7 45 f0 20 20 00 00 	movl   $0x2020,-0x10(%ebp)
    183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1840:	a3 28 20 00 00       	mov    %eax,0x2028
    1845:	a1 28 20 00 00       	mov    0x2028,%eax
    184a:	a3 20 20 00 00       	mov    %eax,0x2020
    base.s.size = 0;
    184f:	c7 05 24 20 00 00 00 	movl   $0x0,0x2024
    1856:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1859:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185c:	8b 00                	mov    (%eax),%eax
    185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1861:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1864:	8b 40 04             	mov    0x4(%eax),%eax
    1867:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    186a:	72 4d                	jb     18b9 <malloc+0xa6>
      if(p->s.size == nunits)
    186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186f:	8b 40 04             	mov    0x4(%eax),%eax
    1872:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1875:	75 0c                	jne    1883 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1877:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187a:	8b 10                	mov    (%eax),%edx
    187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187f:	89 10                	mov    %edx,(%eax)
    1881:	eb 26                	jmp    18a9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1883:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1886:	8b 40 04             	mov    0x4(%eax),%eax
    1889:	2b 45 ec             	sub    -0x14(%ebp),%eax
    188c:	89 c2                	mov    %eax,%edx
    188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1891:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1894:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1897:	8b 40 04             	mov    0x4(%eax),%eax
    189a:	c1 e0 03             	shl    $0x3,%eax
    189d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18a6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ac:	a3 28 20 00 00       	mov    %eax,0x2028
      return (void*)(p + 1);
    18b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b4:	83 c0 08             	add    $0x8,%eax
    18b7:	eb 38                	jmp    18f1 <malloc+0xde>
    }
    if(p == freep)
    18b9:	a1 28 20 00 00       	mov    0x2028,%eax
    18be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18c1:	75 1b                	jne    18de <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18c6:	89 04 24             	mov    %eax,(%esp)
    18c9:	e8 ed fe ff ff       	call   17bb <morecore>
    18ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18d5:	75 07                	jne    18de <malloc+0xcb>
        return 0;
    18d7:	b8 00 00 00 00       	mov    $0x0,%eax
    18dc:	eb 13                	jmp    18f1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e7:	8b 00                	mov    (%eax),%eax
    18e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18ec:	e9 70 ff ff ff       	jmp    1861 <malloc+0x4e>
}
    18f1:	c9                   	leave  
    18f2:	c3                   	ret    

000018f3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18f3:	55                   	push   %ebp
    18f4:	89 e5                	mov    %esp,%ebp
    18f6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    18f9:	8b 55 08             	mov    0x8(%ebp),%edx
    18fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    18ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1902:	f0 87 02             	lock xchg %eax,(%edx)
    1905:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1908:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    190b:	c9                   	leave  
    190c:	c3                   	ret    

0000190d <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    190d:	55                   	push   %ebp
    190e:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1910:	8b 45 08             	mov    0x8(%ebp),%eax
    1913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1919:	5d                   	pop    %ebp
    191a:	c3                   	ret    

0000191b <lock_acquire>:
void lock_acquire(lock_t *lock){
    191b:	55                   	push   %ebp
    191c:	89 e5                	mov    %esp,%ebp
    191e:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1921:	90                   	nop
    1922:	8b 45 08             	mov    0x8(%ebp),%eax
    1925:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    192c:	00 
    192d:	89 04 24             	mov    %eax,(%esp)
    1930:	e8 be ff ff ff       	call   18f3 <xchg>
    1935:	85 c0                	test   %eax,%eax
    1937:	75 e9                	jne    1922 <lock_acquire+0x7>
}
    1939:	c9                   	leave  
    193a:	c3                   	ret    

0000193b <lock_release>:
void lock_release(lock_t *lock){
    193b:	55                   	push   %ebp
    193c:	89 e5                	mov    %esp,%ebp
    193e:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1941:	8b 45 08             	mov    0x8(%ebp),%eax
    1944:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    194b:	00 
    194c:	89 04 24             	mov    %eax,(%esp)
    194f:	e8 9f ff ff ff       	call   18f3 <xchg>
}
    1954:	c9                   	leave  
    1955:	c3                   	ret    

00001956 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1956:	55                   	push   %ebp
    1957:	89 e5                	mov    %esp,%ebp
    1959:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    195c:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1963:	e8 ab fe ff ff       	call   1813 <malloc>
    1968:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196e:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1971:	0f b6 05 2c 20 00 00 	movzbl 0x202c,%eax
    1978:	84 c0                	test   %al,%al
    197a:	75 1c                	jne    1998 <thread_create+0x42>
        init_q(thQ2);
    197c:	a1 30 20 00 00       	mov    0x2030,%eax
    1981:	89 04 24             	mov    %eax,(%esp)
    1984:	e8 2c 01 00 00       	call   1ab5 <init_q>
        inQ++;
    1989:	0f b6 05 2c 20 00 00 	movzbl 0x202c,%eax
    1990:	83 c0 01             	add    $0x1,%eax
    1993:	a2 2c 20 00 00       	mov    %al,0x202c
    }

    if((uint)stack % 4096){
    1998:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199b:	25 ff 0f 00 00       	and    $0xfff,%eax
    19a0:	85 c0                	test   %eax,%eax
    19a2:	74 14                	je     19b8 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a7:	25 ff 0f 00 00       	and    $0xfff,%eax
    19ac:	89 c2                	mov    %eax,%edx
    19ae:	b8 00 10 00 00       	mov    $0x1000,%eax
    19b3:	29 d0                	sub    %edx,%eax
    19b5:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19bc:	75 1e                	jne    19dc <thread_create+0x86>

        printf(1,"malloc fail \n");
    19be:	c7 44 24 04 21 1c 00 	movl   $0x1c21,0x4(%esp)
    19c5:	00 
    19c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19cd:	e8 55 fb ff ff       	call   1527 <printf>
        return 0;
    19d2:	b8 00 00 00 00       	mov    $0x0,%eax
    19d7:	e9 83 00 00 00       	jmp    1a5f <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    19dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    19df:	8b 55 08             	mov    0x8(%ebp),%edx
    19e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    19e9:	89 54 24 08          	mov    %edx,0x8(%esp)
    19ed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    19f4:	00 
    19f5:	89 04 24             	mov    %eax,(%esp)
    19f8:	e8 1a fa ff ff       	call   1417 <clone>
    19fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    1a00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a04:	79 1b                	jns    1a21 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1a06:	c7 44 24 04 2f 1c 00 	movl   $0x1c2f,0x4(%esp)
    1a0d:	00 
    1a0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a15:	e8 0d fb ff ff       	call   1527 <printf>
        return 0;
    1a1a:	b8 00 00 00 00       	mov    $0x0,%eax
    1a1f:	eb 3e                	jmp    1a5f <thread_create+0x109>
    }
    if(tid > 0){
    1a21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a25:	7e 19                	jle    1a40 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1a27:	a1 30 20 00 00       	mov    0x2030,%eax
    1a2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a2f:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a33:	89 04 24             	mov    %eax,(%esp)
    1a36:	e8 9c 00 00 00       	call   1ad7 <add_q>
        return garbage_stack;
    1a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a3e:	eb 1f                	jmp    1a5f <thread_create+0x109>
    }
    if(tid == 0){
    1a40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a44:	75 14                	jne    1a5a <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a46:	c7 44 24 04 3c 1c 00 	movl   $0x1c3c,0x4(%esp)
    1a4d:	00 
    1a4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a55:	e8 cd fa ff ff       	call   1527 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a5f:	c9                   	leave  
    1a60:	c3                   	ret    

00001a61 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a61:	55                   	push   %ebp
    1a62:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a64:	a1 1c 20 00 00       	mov    0x201c,%eax
    1a69:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a6f:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a74:	a3 1c 20 00 00       	mov    %eax,0x201c
    return (int)(rands % max);
    1a79:	a1 1c 20 00 00       	mov    0x201c,%eax
    1a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a81:	ba 00 00 00 00       	mov    $0x0,%edx
    1a86:	f7 f1                	div    %ecx
    1a88:	89 d0                	mov    %edx,%eax
}
    1a8a:	5d                   	pop    %ebp
    1a8b:	c3                   	ret    

00001a8c <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a8c:	55                   	push   %ebp
    1a8d:	89 e5                	mov    %esp,%ebp
    1a8f:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
    1a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    1a98:	8b 40 10             	mov    0x10(%eax),%eax
    1a9b:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a9f:	c7 44 24 04 4d 1c 00 	movl   $0x1c4d,0x4(%esp)
    1aa6:	00 
    1aa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aae:	e8 74 fa ff ff       	call   1527 <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
    1ab3:	c9                   	leave  
    1ab4:	c3                   	ret    

00001ab5 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ab5:	55                   	push   %ebp
    1ab6:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ab8:	8b 45 08             	mov    0x8(%ebp),%eax
    1abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1ac1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1acb:	8b 45 08             	mov    0x8(%ebp),%eax
    1ace:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ad5:	5d                   	pop    %ebp
    1ad6:	c3                   	ret    

00001ad7 <add_q>:

void add_q(struct queue *q, int v){
    1ad7:	55                   	push   %ebp
    1ad8:	89 e5                	mov    %esp,%ebp
    1ada:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1add:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ae4:	e8 2a fd ff ff       	call   1813 <malloc>
    1ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af9:	8b 55 0c             	mov    0xc(%ebp),%edx
    1afc:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1afe:	8b 45 08             	mov    0x8(%ebp),%eax
    1b01:	8b 40 04             	mov    0x4(%eax),%eax
    1b04:	85 c0                	test   %eax,%eax
    1b06:	75 0b                	jne    1b13 <add_q+0x3c>
        q->head = n;
    1b08:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b0e:	89 50 04             	mov    %edx,0x4(%eax)
    1b11:	eb 0c                	jmp    1b1f <add_q+0x48>
    }else{
        q->tail->next = n;
    1b13:	8b 45 08             	mov    0x8(%ebp),%eax
    1b16:	8b 40 08             	mov    0x8(%eax),%eax
    1b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b1c:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b1f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b25:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b28:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2b:	8b 00                	mov    (%eax),%eax
    1b2d:	8d 50 01             	lea    0x1(%eax),%edx
    1b30:	8b 45 08             	mov    0x8(%ebp),%eax
    1b33:	89 10                	mov    %edx,(%eax)
}
    1b35:	c9                   	leave  
    1b36:	c3                   	ret    

00001b37 <empty_q>:

int empty_q(struct queue *q){
    1b37:	55                   	push   %ebp
    1b38:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b3a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3d:	8b 00                	mov    (%eax),%eax
    1b3f:	85 c0                	test   %eax,%eax
    1b41:	75 07                	jne    1b4a <empty_q+0x13>
        return 1;
    1b43:	b8 01 00 00 00       	mov    $0x1,%eax
    1b48:	eb 05                	jmp    1b4f <empty_q+0x18>
    else
        return 0;
    1b4a:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b4f:	5d                   	pop    %ebp
    1b50:	c3                   	ret    

00001b51 <pop_q>:
int pop_q(struct queue *q){
    1b51:	55                   	push   %ebp
    1b52:	89 e5                	mov    %esp,%ebp
    1b54:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b57:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5a:	89 04 24             	mov    %eax,(%esp)
    1b5d:	e8 d5 ff ff ff       	call   1b37 <empty_q>
    1b62:	85 c0                	test   %eax,%eax
    1b64:	75 5d                	jne    1bc3 <pop_q+0x72>
       val = q->head->value; 
    1b66:	8b 45 08             	mov    0x8(%ebp),%eax
    1b69:	8b 40 04             	mov    0x4(%eax),%eax
    1b6c:	8b 00                	mov    (%eax),%eax
    1b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b71:	8b 45 08             	mov    0x8(%ebp),%eax
    1b74:	8b 40 04             	mov    0x4(%eax),%eax
    1b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b7a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7d:	8b 40 04             	mov    0x4(%eax),%eax
    1b80:	8b 50 04             	mov    0x4(%eax),%edx
    1b83:	8b 45 08             	mov    0x8(%ebp),%eax
    1b86:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b8c:	89 04 24             	mov    %eax,(%esp)
    1b8f:	e8 46 fb ff ff       	call   16da <free>
       q->size--;
    1b94:	8b 45 08             	mov    0x8(%ebp),%eax
    1b97:	8b 00                	mov    (%eax),%eax
    1b99:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ba1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba4:	8b 00                	mov    (%eax),%eax
    1ba6:	85 c0                	test   %eax,%eax
    1ba8:	75 14                	jne    1bbe <pop_q+0x6d>
            q->head = 0;
    1baa:	8b 45 08             	mov    0x8(%ebp),%eax
    1bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bb4:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc1:	eb 05                	jmp    1bc8 <pop_q+0x77>
    }
    return -1;
    1bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1bc8:	c9                   	leave  
    1bc9:	c3                   	ret    
