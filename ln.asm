
_ln:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
    1009:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
    100d:	74 19                	je     1028 <main+0x28>
    printf(2, "Usage: ln old new\n");
    100f:	c7 44 24 04 d5 1b 00 	movl   $0x1bd5,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 6e 04 00 00       	call   1491 <printf>
    exit();
    1023:	e8 b9 02 00 00       	call   12e1 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
    1028:	8b 45 0c             	mov    0xc(%ebp),%eax
    102b:	83 c0 08             	add    $0x8,%eax
    102e:	8b 10                	mov    (%eax),%edx
    1030:	8b 45 0c             	mov    0xc(%ebp),%eax
    1033:	83 c0 04             	add    $0x4,%eax
    1036:	8b 00                	mov    (%eax),%eax
    1038:	89 54 24 04          	mov    %edx,0x4(%esp)
    103c:	89 04 24             	mov    %eax,(%esp)
    103f:	e8 fd 02 00 00       	call   1341 <link>
    1044:	85 c0                	test   %eax,%eax
    1046:	79 2c                	jns    1074 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1048:	8b 45 0c             	mov    0xc(%ebp),%eax
    104b:	83 c0 08             	add    $0x8,%eax
    104e:	8b 10                	mov    (%eax),%edx
    1050:	8b 45 0c             	mov    0xc(%ebp),%eax
    1053:	83 c0 04             	add    $0x4,%eax
    1056:	8b 00                	mov    (%eax),%eax
    1058:	89 54 24 0c          	mov    %edx,0xc(%esp)
    105c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1060:	c7 44 24 04 e8 1b 00 	movl   $0x1be8,0x4(%esp)
    1067:	00 
    1068:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    106f:	e8 1d 04 00 00       	call   1491 <printf>
  exit();
    1074:	e8 68 02 00 00       	call   12e1 <exit>

00001079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1079:	55                   	push   %ebp
    107a:	89 e5                	mov    %esp,%ebp
    107c:	57                   	push   %edi
    107d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    107e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1081:	8b 55 10             	mov    0x10(%ebp),%edx
    1084:	8b 45 0c             	mov    0xc(%ebp),%eax
    1087:	89 cb                	mov    %ecx,%ebx
    1089:	89 df                	mov    %ebx,%edi
    108b:	89 d1                	mov    %edx,%ecx
    108d:	fc                   	cld    
    108e:	f3 aa                	rep stos %al,%es:(%edi)
    1090:	89 ca                	mov    %ecx,%edx
    1092:	89 fb                	mov    %edi,%ebx
    1094:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1097:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    109a:	5b                   	pop    %ebx
    109b:	5f                   	pop    %edi
    109c:	5d                   	pop    %ebp
    109d:	c3                   	ret    

0000109e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    109e:	55                   	push   %ebp
    109f:	89 e5                	mov    %esp,%ebp
    10a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10aa:	90                   	nop
    10ab:	8b 45 08             	mov    0x8(%ebp),%eax
    10ae:	8d 50 01             	lea    0x1(%eax),%edx
    10b1:	89 55 08             	mov    %edx,0x8(%ebp)
    10b4:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b7:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10bd:	0f b6 12             	movzbl (%edx),%edx
    10c0:	88 10                	mov    %dl,(%eax)
    10c2:	0f b6 00             	movzbl (%eax),%eax
    10c5:	84 c0                	test   %al,%al
    10c7:	75 e2                	jne    10ab <strcpy+0xd>
    ;
  return os;
    10c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10cc:	c9                   	leave  
    10cd:	c3                   	ret    

000010ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ce:	55                   	push   %ebp
    10cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10d1:	eb 08                	jmp    10db <strcmp+0xd>
    p++, q++;
    10d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	0f b6 00             	movzbl (%eax),%eax
    10e1:	84 c0                	test   %al,%al
    10e3:	74 10                	je     10f5 <strcmp+0x27>
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	0f b6 10             	movzbl (%eax),%edx
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	0f b6 00             	movzbl (%eax),%eax
    10f1:	38 c2                	cmp    %al,%dl
    10f3:	74 de                	je     10d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	0f b6 00             	movzbl (%eax),%eax
    10fb:	0f b6 d0             	movzbl %al,%edx
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	0f b6 00             	movzbl (%eax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	5d                   	pop    %ebp
    110c:	c3                   	ret    

0000110d <strlen>:

uint
strlen(char *s)
{
    110d:	55                   	push   %ebp
    110e:	89 e5                	mov    %esp,%ebp
    1110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    111a:	eb 04                	jmp    1120 <strlen+0x13>
    111c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1120:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1123:	8b 45 08             	mov    0x8(%ebp),%eax
    1126:	01 d0                	add    %edx,%eax
    1128:	0f b6 00             	movzbl (%eax),%eax
    112b:	84 c0                	test   %al,%al
    112d:	75 ed                	jne    111c <strlen+0xf>
    ;
  return n;
    112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1132:	c9                   	leave  
    1133:	c3                   	ret    

00001134 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    113a:	8b 45 10             	mov    0x10(%ebp),%eax
    113d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1141:	8b 45 0c             	mov    0xc(%ebp),%eax
    1144:	89 44 24 04          	mov    %eax,0x4(%esp)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 04 24             	mov    %eax,(%esp)
    114e:	e8 26 ff ff ff       	call   1079 <stosb>
  return dst;
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1156:	c9                   	leave  
    1157:	c3                   	ret    

00001158 <strchr>:

char*
strchr(const char *s, char c)
{
    1158:	55                   	push   %ebp
    1159:	89 e5                	mov    %esp,%ebp
    115b:	83 ec 04             	sub    $0x4,%esp
    115e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1164:	eb 14                	jmp    117a <strchr+0x22>
    if(*s == c)
    1166:	8b 45 08             	mov    0x8(%ebp),%eax
    1169:	0f b6 00             	movzbl (%eax),%eax
    116c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    116f:	75 05                	jne    1176 <strchr+0x1e>
      return (char*)s;
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	eb 13                	jmp    1189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	0f b6 00             	movzbl (%eax),%eax
    1180:	84 c0                	test   %al,%al
    1182:	75 e2                	jne    1166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1184:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1189:	c9                   	leave  
    118a:	c3                   	ret    

0000118b <gets>:

char*
gets(char *buf, int max)
{
    118b:	55                   	push   %ebp
    118c:	89 e5                	mov    %esp,%ebp
    118e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1198:	eb 4c                	jmp    11e6 <gets+0x5b>
    cc = read(0, &c, 1);
    119a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11a1:	00 
    11a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11b0:	e8 44 01 00 00       	call   12f9 <read>
    11b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11bc:	7f 02                	jg     11c0 <gets+0x35>
      break;
    11be:	eb 31                	jmp    11f1 <gets+0x66>
    buf[i++] = c;
    11c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c3:	8d 50 01             	lea    0x1(%eax),%edx
    11c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11c9:	89 c2                	mov    %eax,%edx
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	01 c2                	add    %eax,%edx
    11d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11da:	3c 0a                	cmp    $0xa,%al
    11dc:	74 13                	je     11f1 <gets+0x66>
    11de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11e2:	3c 0d                	cmp    $0xd,%al
    11e4:	74 0b                	je     11f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e9:	83 c0 01             	add    $0x1,%eax
    11ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11ef:	7c a9                	jl     119a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	01 d0                	add    %edx,%eax
    11f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ff:	c9                   	leave  
    1200:	c3                   	ret    

00001201 <stat>:

int
stat(char *n, struct stat *st)
{
    1201:	55                   	push   %ebp
    1202:	89 e5                	mov    %esp,%ebp
    1204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    120e:	00 
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 07 01 00 00       	call   1321 <open>
    121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    121d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1221:	79 07                	jns    122a <stat+0x29>
    return -1;
    1223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1228:	eb 23                	jmp    124d <stat+0x4c>
  r = fstat(fd, st);
    122a:	8b 45 0c             	mov    0xc(%ebp),%eax
    122d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1231:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 fd 00 00 00       	call   1339 <fstat>
    123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1242:	89 04 24             	mov    %eax,(%esp)
    1245:	e8 bf 00 00 00       	call   1309 <close>
  return r;
    124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    124d:	c9                   	leave  
    124e:	c3                   	ret    

0000124f <atoi>:

int
atoi(const char *s)
{
    124f:	55                   	push   %ebp
    1250:	89 e5                	mov    %esp,%ebp
    1252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    125c:	eb 25                	jmp    1283 <atoi+0x34>
    n = n*10 + *s++ - '0';
    125e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1261:	89 d0                	mov    %edx,%eax
    1263:	c1 e0 02             	shl    $0x2,%eax
    1266:	01 d0                	add    %edx,%eax
    1268:	01 c0                	add    %eax,%eax
    126a:	89 c1                	mov    %eax,%ecx
    126c:	8b 45 08             	mov    0x8(%ebp),%eax
    126f:	8d 50 01             	lea    0x1(%eax),%edx
    1272:	89 55 08             	mov    %edx,0x8(%ebp)
    1275:	0f b6 00             	movzbl (%eax),%eax
    1278:	0f be c0             	movsbl %al,%eax
    127b:	01 c8                	add    %ecx,%eax
    127d:	83 e8 30             	sub    $0x30,%eax
    1280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	0f b6 00             	movzbl (%eax),%eax
    1289:	3c 2f                	cmp    $0x2f,%al
    128b:	7e 0a                	jle    1297 <atoi+0x48>
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
    1290:	0f b6 00             	movzbl (%eax),%eax
    1293:	3c 39                	cmp    $0x39,%al
    1295:	7e c7                	jle    125e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    129a:	c9                   	leave  
    129b:	c3                   	ret    

0000129c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12a2:	8b 45 08             	mov    0x8(%ebp),%eax
    12a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12ae:	eb 17                	jmp    12c7 <memmove+0x2b>
    *dst++ = *src++;
    12b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b3:	8d 50 01             	lea    0x1(%eax),%edx
    12b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12bc:	8d 4a 01             	lea    0x1(%edx),%ecx
    12bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12c2:	0f b6 12             	movzbl (%edx),%edx
    12c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12c7:	8b 45 10             	mov    0x10(%ebp),%eax
    12ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    12cd:	89 55 10             	mov    %edx,0x10(%ebp)
    12d0:	85 c0                	test   %eax,%eax
    12d2:	7f dc                	jg     12b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12d7:	c9                   	leave  
    12d8:	c3                   	ret    

000012d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12d9:	b8 01 00 00 00       	mov    $0x1,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <exit>:
SYSCALL(exit)
    12e1:	b8 02 00 00 00       	mov    $0x2,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <wait>:
SYSCALL(wait)
    12e9:	b8 03 00 00 00       	mov    $0x3,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <pipe>:
SYSCALL(pipe)
    12f1:	b8 04 00 00 00       	mov    $0x4,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <read>:
SYSCALL(read)
    12f9:	b8 05 00 00 00       	mov    $0x5,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <write>:
SYSCALL(write)
    1301:	b8 10 00 00 00       	mov    $0x10,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <close>:
SYSCALL(close)
    1309:	b8 15 00 00 00       	mov    $0x15,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <kill>:
SYSCALL(kill)
    1311:	b8 06 00 00 00       	mov    $0x6,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <exec>:
SYSCALL(exec)
    1319:	b8 07 00 00 00       	mov    $0x7,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <open>:
SYSCALL(open)
    1321:	b8 0f 00 00 00       	mov    $0xf,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <mknod>:
SYSCALL(mknod)
    1329:	b8 11 00 00 00       	mov    $0x11,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <unlink>:
SYSCALL(unlink)
    1331:	b8 12 00 00 00       	mov    $0x12,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <fstat>:
SYSCALL(fstat)
    1339:	b8 08 00 00 00       	mov    $0x8,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <link>:
SYSCALL(link)
    1341:	b8 13 00 00 00       	mov    $0x13,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <mkdir>:
SYSCALL(mkdir)
    1349:	b8 14 00 00 00       	mov    $0x14,%eax
    134e:	cd 40                	int    $0x40
    1350:	c3                   	ret    

00001351 <chdir>:
SYSCALL(chdir)
    1351:	b8 09 00 00 00       	mov    $0x9,%eax
    1356:	cd 40                	int    $0x40
    1358:	c3                   	ret    

00001359 <dup>:
SYSCALL(dup)
    1359:	b8 0a 00 00 00       	mov    $0xa,%eax
    135e:	cd 40                	int    $0x40
    1360:	c3                   	ret    

00001361 <getpid>:
SYSCALL(getpid)
    1361:	b8 0b 00 00 00       	mov    $0xb,%eax
    1366:	cd 40                	int    $0x40
    1368:	c3                   	ret    

00001369 <sbrk>:
SYSCALL(sbrk)
    1369:	b8 0c 00 00 00       	mov    $0xc,%eax
    136e:	cd 40                	int    $0x40
    1370:	c3                   	ret    

00001371 <sleep>:
SYSCALL(sleep)
    1371:	b8 0d 00 00 00       	mov    $0xd,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <uptime>:
SYSCALL(uptime)
    1379:	b8 0e 00 00 00       	mov    $0xe,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <clone>:
SYSCALL(clone)
    1381:	b8 16 00 00 00       	mov    $0x16,%eax
    1386:	cd 40                	int    $0x40
    1388:	c3                   	ret    

00001389 <texit>:
SYSCALL(texit)
    1389:	b8 17 00 00 00       	mov    $0x17,%eax
    138e:	cd 40                	int    $0x40
    1390:	c3                   	ret    

00001391 <tsleep>:
SYSCALL(tsleep)
    1391:	b8 18 00 00 00       	mov    $0x18,%eax
    1396:	cd 40                	int    $0x40
    1398:	c3                   	ret    

00001399 <twakeup>:
SYSCALL(twakeup)
    1399:	b8 19 00 00 00       	mov    $0x19,%eax
    139e:	cd 40                	int    $0x40
    13a0:	c3                   	ret    

000013a1 <thread_yield>:
SYSCALL(thread_yield)
    13a1:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13a6:	cd 40                	int    $0x40
    13a8:	c3                   	ret    

000013a9 <thread_yield3>:
    13a9:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13b1:	55                   	push   %ebp
    13b2:	89 e5                	mov    %esp,%ebp
    13b4:	83 ec 18             	sub    $0x18,%esp
    13b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13c4:	00 
    13c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    13cc:	8b 45 08             	mov    0x8(%ebp),%eax
    13cf:	89 04 24             	mov    %eax,(%esp)
    13d2:	e8 2a ff ff ff       	call   1301 <write>
}
    13d7:	c9                   	leave  
    13d8:	c3                   	ret    

000013d9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13d9:	55                   	push   %ebp
    13da:	89 e5                	mov    %esp,%ebp
    13dc:	56                   	push   %esi
    13dd:	53                   	push   %ebx
    13de:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13ec:	74 17                	je     1405 <printint+0x2c>
    13ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13f2:	79 11                	jns    1405 <printint+0x2c>
    neg = 1;
    13f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13fb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13fe:	f7 d8                	neg    %eax
    1400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1403:	eb 06                	jmp    140b <printint+0x32>
  } else {
    x = xx;
    1405:	8b 45 0c             	mov    0xc(%ebp),%eax
    1408:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    140b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1412:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1415:	8d 41 01             	lea    0x1(%ecx),%eax
    1418:	89 45 f4             	mov    %eax,-0xc(%ebp)
    141b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    141e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1421:	ba 00 00 00 00       	mov    $0x0,%edx
    1426:	f7 f3                	div    %ebx
    1428:	89 d0                	mov    %edx,%eax
    142a:	0f b6 80 0c 20 00 00 	movzbl 0x200c(%eax),%eax
    1431:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1435:	8b 75 10             	mov    0x10(%ebp),%esi
    1438:	8b 45 ec             	mov    -0x14(%ebp),%eax
    143b:	ba 00 00 00 00       	mov    $0x0,%edx
    1440:	f7 f6                	div    %esi
    1442:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1449:	75 c7                	jne    1412 <printint+0x39>
  if(neg)
    144b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    144f:	74 10                	je     1461 <printint+0x88>
    buf[i++] = '-';
    1451:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1454:	8d 50 01             	lea    0x1(%eax),%edx
    1457:	89 55 f4             	mov    %edx,-0xc(%ebp)
    145a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    145f:	eb 1f                	jmp    1480 <printint+0xa7>
    1461:	eb 1d                	jmp    1480 <printint+0xa7>
    putc(fd, buf[i]);
    1463:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1466:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1469:	01 d0                	add    %edx,%eax
    146b:	0f b6 00             	movzbl (%eax),%eax
    146e:	0f be c0             	movsbl %al,%eax
    1471:	89 44 24 04          	mov    %eax,0x4(%esp)
    1475:	8b 45 08             	mov    0x8(%ebp),%eax
    1478:	89 04 24             	mov    %eax,(%esp)
    147b:	e8 31 ff ff ff       	call   13b1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1480:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1488:	79 d9                	jns    1463 <printint+0x8a>
    putc(fd, buf[i]);
}
    148a:	83 c4 30             	add    $0x30,%esp
    148d:	5b                   	pop    %ebx
    148e:	5e                   	pop    %esi
    148f:	5d                   	pop    %ebp
    1490:	c3                   	ret    

00001491 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1491:	55                   	push   %ebp
    1492:	89 e5                	mov    %esp,%ebp
    1494:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1497:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    149e:	8d 45 0c             	lea    0xc(%ebp),%eax
    14a1:	83 c0 04             	add    $0x4,%eax
    14a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14ae:	e9 7c 01 00 00       	jmp    162f <printf+0x19e>
    c = fmt[i] & 0xff;
    14b3:	8b 55 0c             	mov    0xc(%ebp),%edx
    14b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14b9:	01 d0                	add    %edx,%eax
    14bb:	0f b6 00             	movzbl (%eax),%eax
    14be:	0f be c0             	movsbl %al,%eax
    14c1:	25 ff 00 00 00       	and    $0xff,%eax
    14c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14cd:	75 2c                	jne    14fb <printf+0x6a>
      if(c == '%'){
    14cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14d3:	75 0c                	jne    14e1 <printf+0x50>
        state = '%';
    14d5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14dc:	e9 4a 01 00 00       	jmp    162b <printf+0x19a>
      } else {
        putc(fd, c);
    14e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14e4:	0f be c0             	movsbl %al,%eax
    14e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14eb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ee:	89 04 24             	mov    %eax,(%esp)
    14f1:	e8 bb fe ff ff       	call   13b1 <putc>
    14f6:	e9 30 01 00 00       	jmp    162b <printf+0x19a>
      }
    } else if(state == '%'){
    14fb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ff:	0f 85 26 01 00 00    	jne    162b <printf+0x19a>
      if(c == 'd'){
    1505:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1509:	75 2d                	jne    1538 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    150b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    150e:	8b 00                	mov    (%eax),%eax
    1510:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1517:	00 
    1518:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    151f:	00 
    1520:	89 44 24 04          	mov    %eax,0x4(%esp)
    1524:	8b 45 08             	mov    0x8(%ebp),%eax
    1527:	89 04 24             	mov    %eax,(%esp)
    152a:	e8 aa fe ff ff       	call   13d9 <printint>
        ap++;
    152f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1533:	e9 ec 00 00 00       	jmp    1624 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1538:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    153c:	74 06                	je     1544 <printf+0xb3>
    153e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1542:	75 2d                	jne    1571 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1544:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1547:	8b 00                	mov    (%eax),%eax
    1549:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1550:	00 
    1551:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1558:	00 
    1559:	89 44 24 04          	mov    %eax,0x4(%esp)
    155d:	8b 45 08             	mov    0x8(%ebp),%eax
    1560:	89 04 24             	mov    %eax,(%esp)
    1563:	e8 71 fe ff ff       	call   13d9 <printint>
        ap++;
    1568:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    156c:	e9 b3 00 00 00       	jmp    1624 <printf+0x193>
      } else if(c == 's'){
    1571:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1575:	75 45                	jne    15bc <printf+0x12b>
        s = (char*)*ap;
    1577:	8b 45 e8             	mov    -0x18(%ebp),%eax
    157a:	8b 00                	mov    (%eax),%eax
    157c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    157f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1587:	75 09                	jne    1592 <printf+0x101>
          s = "(null)";
    1589:	c7 45 f4 fc 1b 00 00 	movl   $0x1bfc,-0xc(%ebp)
        while(*s != 0){
    1590:	eb 1e                	jmp    15b0 <printf+0x11f>
    1592:	eb 1c                	jmp    15b0 <printf+0x11f>
          putc(fd, *s);
    1594:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1597:	0f b6 00             	movzbl (%eax),%eax
    159a:	0f be c0             	movsbl %al,%eax
    159d:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a1:	8b 45 08             	mov    0x8(%ebp),%eax
    15a4:	89 04 24             	mov    %eax,(%esp)
    15a7:	e8 05 fe ff ff       	call   13b1 <putc>
          s++;
    15ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b3:	0f b6 00             	movzbl (%eax),%eax
    15b6:	84 c0                	test   %al,%al
    15b8:	75 da                	jne    1594 <printf+0x103>
    15ba:	eb 68                	jmp    1624 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15bc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15c0:	75 1d                	jne    15df <printf+0x14e>
        putc(fd, *ap);
    15c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c5:	8b 00                	mov    (%eax),%eax
    15c7:	0f be c0             	movsbl %al,%eax
    15ca:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ce:	8b 45 08             	mov    0x8(%ebp),%eax
    15d1:	89 04 24             	mov    %eax,(%esp)
    15d4:	e8 d8 fd ff ff       	call   13b1 <putc>
        ap++;
    15d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15dd:	eb 45                	jmp    1624 <printf+0x193>
      } else if(c == '%'){
    15df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15e3:	75 17                	jne    15fc <printf+0x16b>
        putc(fd, c);
    15e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15e8:	0f be c0             	movsbl %al,%eax
    15eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ef:	8b 45 08             	mov    0x8(%ebp),%eax
    15f2:	89 04 24             	mov    %eax,(%esp)
    15f5:	e8 b7 fd ff ff       	call   13b1 <putc>
    15fa:	eb 28                	jmp    1624 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15fc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1603:	00 
    1604:	8b 45 08             	mov    0x8(%ebp),%eax
    1607:	89 04 24             	mov    %eax,(%esp)
    160a:	e8 a2 fd ff ff       	call   13b1 <putc>
        putc(fd, c);
    160f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1612:	0f be c0             	movsbl %al,%eax
    1615:	89 44 24 04          	mov    %eax,0x4(%esp)
    1619:	8b 45 08             	mov    0x8(%ebp),%eax
    161c:	89 04 24             	mov    %eax,(%esp)
    161f:	e8 8d fd ff ff       	call   13b1 <putc>
      }
      state = 0;
    1624:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    162b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    162f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1632:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1635:	01 d0                	add    %edx,%eax
    1637:	0f b6 00             	movzbl (%eax),%eax
    163a:	84 c0                	test   %al,%al
    163c:	0f 85 71 fe ff ff    	jne    14b3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1642:	c9                   	leave  
    1643:	c3                   	ret    

00001644 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1644:	55                   	push   %ebp
    1645:	89 e5                	mov    %esp,%ebp
    1647:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    164a:	8b 45 08             	mov    0x8(%ebp),%eax
    164d:	83 e8 08             	sub    $0x8,%eax
    1650:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1653:	a1 2c 20 00 00       	mov    0x202c,%eax
    1658:	89 45 fc             	mov    %eax,-0x4(%ebp)
    165b:	eb 24                	jmp    1681 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    165d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1660:	8b 00                	mov    (%eax),%eax
    1662:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1665:	77 12                	ja     1679 <free+0x35>
    1667:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    166d:	77 24                	ja     1693 <free+0x4f>
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	8b 00                	mov    (%eax),%eax
    1674:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1677:	77 1a                	ja     1693 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1679:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167c:	8b 00                	mov    (%eax),%eax
    167e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1687:	76 d4                	jbe    165d <free+0x19>
    1689:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168c:	8b 00                	mov    (%eax),%eax
    168e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1691:	76 ca                	jbe    165d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1693:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1696:	8b 40 04             	mov    0x4(%eax),%eax
    1699:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a3:	01 c2                	add    %eax,%edx
    16a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a8:	8b 00                	mov    (%eax),%eax
    16aa:	39 c2                	cmp    %eax,%edx
    16ac:	75 24                	jne    16d2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b1:	8b 50 04             	mov    0x4(%eax),%edx
    16b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b7:	8b 00                	mov    (%eax),%eax
    16b9:	8b 40 04             	mov    0x4(%eax),%eax
    16bc:	01 c2                	add    %eax,%edx
    16be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c7:	8b 00                	mov    (%eax),%eax
    16c9:	8b 10                	mov    (%eax),%edx
    16cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ce:	89 10                	mov    %edx,(%eax)
    16d0:	eb 0a                	jmp    16dc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d5:	8b 10                	mov    (%eax),%edx
    16d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16da:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16df:	8b 40 04             	mov    0x4(%eax),%eax
    16e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ec:	01 d0                	add    %edx,%eax
    16ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f1:	75 20                	jne    1713 <free+0xcf>
    p->s.size += bp->s.size;
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	8b 50 04             	mov    0x4(%eax),%edx
    16f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fc:	8b 40 04             	mov    0x4(%eax),%eax
    16ff:	01 c2                	add    %eax,%edx
    1701:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1704:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1707:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170a:	8b 10                	mov    (%eax),%edx
    170c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170f:	89 10                	mov    %edx,(%eax)
    1711:	eb 08                	jmp    171b <free+0xd7>
  } else
    p->s.ptr = bp;
    1713:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1716:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1719:	89 10                	mov    %edx,(%eax)
  freep = p;
    171b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171e:	a3 2c 20 00 00       	mov    %eax,0x202c
}
    1723:	c9                   	leave  
    1724:	c3                   	ret    

00001725 <morecore>:

static Header*
morecore(uint nu)
{
    1725:	55                   	push   %ebp
    1726:	89 e5                	mov    %esp,%ebp
    1728:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    172b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1732:	77 07                	ja     173b <morecore+0x16>
    nu = 4096;
    1734:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    173b:	8b 45 08             	mov    0x8(%ebp),%eax
    173e:	c1 e0 03             	shl    $0x3,%eax
    1741:	89 04 24             	mov    %eax,(%esp)
    1744:	e8 20 fc ff ff       	call   1369 <sbrk>
    1749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    174c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1750:	75 07                	jne    1759 <morecore+0x34>
    return 0;
    1752:	b8 00 00 00 00       	mov    $0x0,%eax
    1757:	eb 22                	jmp    177b <morecore+0x56>
  hp = (Header*)p;
    1759:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1762:	8b 55 08             	mov    0x8(%ebp),%edx
    1765:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1768:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176b:	83 c0 08             	add    $0x8,%eax
    176e:	89 04 24             	mov    %eax,(%esp)
    1771:	e8 ce fe ff ff       	call   1644 <free>
  return freep;
    1776:	a1 2c 20 00 00       	mov    0x202c,%eax
}
    177b:	c9                   	leave  
    177c:	c3                   	ret    

0000177d <malloc>:

void*
malloc(uint nbytes)
{
    177d:	55                   	push   %ebp
    177e:	89 e5                	mov    %esp,%ebp
    1780:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1783:	8b 45 08             	mov    0x8(%ebp),%eax
    1786:	83 c0 07             	add    $0x7,%eax
    1789:	c1 e8 03             	shr    $0x3,%eax
    178c:	83 c0 01             	add    $0x1,%eax
    178f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1792:	a1 2c 20 00 00       	mov    0x202c,%eax
    1797:	89 45 f0             	mov    %eax,-0x10(%ebp)
    179a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    179e:	75 23                	jne    17c3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17a0:	c7 45 f0 24 20 00 00 	movl   $0x2024,-0x10(%ebp)
    17a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17aa:	a3 2c 20 00 00       	mov    %eax,0x202c
    17af:	a1 2c 20 00 00       	mov    0x202c,%eax
    17b4:	a3 24 20 00 00       	mov    %eax,0x2024
    base.s.size = 0;
    17b9:	c7 05 28 20 00 00 00 	movl   $0x0,0x2028
    17c0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c6:	8b 00                	mov    (%eax),%eax
    17c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ce:	8b 40 04             	mov    0x4(%eax),%eax
    17d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17d4:	72 4d                	jb     1823 <malloc+0xa6>
      if(p->s.size == nunits)
    17d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d9:	8b 40 04             	mov    0x4(%eax),%eax
    17dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17df:	75 0c                	jne    17ed <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e4:	8b 10                	mov    (%eax),%edx
    17e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e9:	89 10                	mov    %edx,(%eax)
    17eb:	eb 26                	jmp    1813 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f0:	8b 40 04             	mov    0x4(%eax),%eax
    17f3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17f6:	89 c2                	mov    %eax,%edx
    17f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1801:	8b 40 04             	mov    0x4(%eax),%eax
    1804:	c1 e0 03             	shl    $0x3,%eax
    1807:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1810:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1813:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1816:	a3 2c 20 00 00       	mov    %eax,0x202c
      return (void*)(p + 1);
    181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181e:	83 c0 08             	add    $0x8,%eax
    1821:	eb 38                	jmp    185b <malloc+0xde>
    }
    if(p == freep)
    1823:	a1 2c 20 00 00       	mov    0x202c,%eax
    1828:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    182b:	75 1b                	jne    1848 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1830:	89 04 24             	mov    %eax,(%esp)
    1833:	e8 ed fe ff ff       	call   1725 <morecore>
    1838:	89 45 f4             	mov    %eax,-0xc(%ebp)
    183b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    183f:	75 07                	jne    1848 <malloc+0xcb>
        return 0;
    1841:	b8 00 00 00 00       	mov    $0x0,%eax
    1846:	eb 13                	jmp    185b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1848:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1851:	8b 00                	mov    (%eax),%eax
    1853:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1856:	e9 70 ff ff ff       	jmp    17cb <malloc+0x4e>
}
    185b:	c9                   	leave  
    185c:	c3                   	ret    

0000185d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    185d:	55                   	push   %ebp
    185e:	89 e5                	mov    %esp,%ebp
    1860:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1863:	8b 55 08             	mov    0x8(%ebp),%edx
    1866:	8b 45 0c             	mov    0xc(%ebp),%eax
    1869:	8b 4d 08             	mov    0x8(%ebp),%ecx
    186c:	f0 87 02             	lock xchg %eax,(%edx)
    186f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1872:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1875:	c9                   	leave  
    1876:	c3                   	ret    

00001877 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1877:	55                   	push   %ebp
    1878:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    187a:	8b 45 08             	mov    0x8(%ebp),%eax
    187d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1883:	5d                   	pop    %ebp
    1884:	c3                   	ret    

00001885 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1885:	55                   	push   %ebp
    1886:	89 e5                	mov    %esp,%ebp
    1888:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    188b:	90                   	nop
    188c:	8b 45 08             	mov    0x8(%ebp),%eax
    188f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1896:	00 
    1897:	89 04 24             	mov    %eax,(%esp)
    189a:	e8 be ff ff ff       	call   185d <xchg>
    189f:	85 c0                	test   %eax,%eax
    18a1:	75 e9                	jne    188c <lock_acquire+0x7>
}
    18a3:	c9                   	leave  
    18a4:	c3                   	ret    

000018a5 <lock_release>:
void lock_release(lock_t *lock){
    18a5:	55                   	push   %ebp
    18a6:	89 e5                	mov    %esp,%ebp
    18a8:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    18ab:	8b 45 08             	mov    0x8(%ebp),%eax
    18ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18b5:	00 
    18b6:	89 04 24             	mov    %eax,(%esp)
    18b9:	e8 9f ff ff ff       	call   185d <xchg>
}
    18be:	c9                   	leave  
    18bf:	c3                   	ret    

000018c0 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    18c0:	55                   	push   %ebp
    18c1:	89 e5                	mov    %esp,%ebp
    18c3:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    18c6:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    18cd:	e8 ab fe ff ff       	call   177d <malloc>
    18d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    18d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18db:	0f b6 05 30 20 00 00 	movzbl 0x2030,%eax
    18e2:	84 c0                	test   %al,%al
    18e4:	75 1c                	jne    1902 <thread_create+0x42>
        init_q(thQ2);
    18e6:	a1 38 20 00 00       	mov    0x2038,%eax
    18eb:	89 04 24             	mov    %eax,(%esp)
    18ee:	e8 cd 01 00 00       	call   1ac0 <init_q>
        inQ++;
    18f3:	0f b6 05 30 20 00 00 	movzbl 0x2030,%eax
    18fa:	83 c0 01             	add    $0x1,%eax
    18fd:	a2 30 20 00 00       	mov    %al,0x2030
    }

    if((uint)stack % 4096){
    1902:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1905:	25 ff 0f 00 00       	and    $0xfff,%eax
    190a:	85 c0                	test   %eax,%eax
    190c:	74 14                	je     1922 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1911:	25 ff 0f 00 00       	and    $0xfff,%eax
    1916:	89 c2                	mov    %eax,%edx
    1918:	b8 00 10 00 00       	mov    $0x1000,%eax
    191d:	29 d0                	sub    %edx,%eax
    191f:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1926:	75 1e                	jne    1946 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1928:	c7 44 24 04 03 1c 00 	movl   $0x1c03,0x4(%esp)
    192f:	00 
    1930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1937:	e8 55 fb ff ff       	call   1491 <printf>
        return 0;
    193c:	b8 00 00 00 00       	mov    $0x0,%eax
    1941:	e9 9e 00 00 00       	jmp    19e4 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1949:	8b 55 08             	mov    0x8(%ebp),%edx
    194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1953:	89 54 24 08          	mov    %edx,0x8(%esp)
    1957:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    195e:	00 
    195f:	89 04 24             	mov    %eax,(%esp)
    1962:	e8 1a fa ff ff       	call   1381 <clone>
    1967:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    196a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    196d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1971:	c7 44 24 04 11 1c 00 	movl   $0x1c11,0x4(%esp)
    1978:	00 
    1979:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1980:	e8 0c fb ff ff       	call   1491 <printf>
    if(tid < 0){
    1985:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1989:	79 1b                	jns    19a6 <thread_create+0xe6>
        printf(1,"clone fails\n");
    198b:	c7 44 24 04 2a 1c 00 	movl   $0x1c2a,0x4(%esp)
    1992:	00 
    1993:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    199a:	e8 f2 fa ff ff       	call   1491 <printf>
        return 0;
    199f:	b8 00 00 00 00       	mov    $0x0,%eax
    19a4:	eb 3e                	jmp    19e4 <thread_create+0x124>
    }
    if(tid > 0){
    19a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19aa:	7e 19                	jle    19c5 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    19ac:	a1 38 20 00 00       	mov    0x2038,%eax
    19b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19b4:	89 54 24 04          	mov    %edx,0x4(%esp)
    19b8:	89 04 24             	mov    %eax,(%esp)
    19bb:	e8 22 01 00 00       	call   1ae2 <add_q>
        return garbage_stack;
    19c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19c3:	eb 1f                	jmp    19e4 <thread_create+0x124>
    }
    if(tid == 0){
    19c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19c9:	75 14                	jne    19df <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    19cb:	c7 44 24 04 37 1c 00 	movl   $0x1c37,0x4(%esp)
    19d2:	00 
    19d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19da:	e8 b2 fa ff ff       	call   1491 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19df:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19e4:	c9                   	leave  
    19e5:	c3                   	ret    

000019e6 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19e6:	55                   	push   %ebp
    19e7:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19e9:	a1 20 20 00 00       	mov    0x2020,%eax
    19ee:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    19f4:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19f9:	a3 20 20 00 00       	mov    %eax,0x2020
    return (int)(rands % max);
    19fe:	a1 20 20 00 00       	mov    0x2020,%eax
    1a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a06:	ba 00 00 00 00       	mov    $0x0,%edx
    1a0b:	f7 f1                	div    %ecx
    1a0d:	89 d0                	mov    %edx,%eax
}
    1a0f:	5d                   	pop    %ebp
    1a10:	c3                   	ret    

00001a11 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a11:	55                   	push   %ebp
    1a12:	89 e5                	mov    %esp,%ebp
    1a14:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a17:	e8 45 f9 ff ff       	call   1361 <getpid>
    1a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a1f:	a1 38 20 00 00       	mov    0x2038,%eax
    1a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a27:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a2b:	89 04 24             	mov    %eax,(%esp)
    1a2e:	e8 af 00 00 00       	call   1ae2 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a33:	a1 38 20 00 00       	mov    0x2038,%eax
    1a38:	89 04 24             	mov    %eax,(%esp)
    1a3b:	e8 1c 01 00 00       	call   1b5c <pop_q>
    1a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a43:	a1 34 20 00 00       	mov    0x2034,%eax
    1a48:	85 c0                	test   %eax,%eax
    1a4a:	75 1f                	jne    1a6b <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a4c:	a1 38 20 00 00       	mov    0x2038,%eax
    1a51:	89 04 24             	mov    %eax,(%esp)
    1a54:	e8 03 01 00 00       	call   1b5c <pop_q>
    1a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a5c:	a1 34 20 00 00       	mov    0x2034,%eax
    1a61:	83 c0 01             	add    $0x1,%eax
    1a64:	a3 34 20 00 00       	mov    %eax,0x2034
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a69:	eb 12                	jmp    1a7d <thread_yield2+0x6c>
    1a6b:	eb 10                	jmp    1a7d <thread_yield2+0x6c>
    1a6d:	a1 38 20 00 00       	mov    0x2038,%eax
    1a72:	89 04 24             	mov    %eax,(%esp)
    1a75:	e8 e2 00 00 00       	call   1b5c <pop_q>
    1a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a80:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a83:	74 e8                	je     1a6d <thread_yield2+0x5c>
    1a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a89:	74 e2                	je     1a6d <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8e:	89 04 24             	mov    %eax,(%esp)
    1a91:	e8 03 f9 ff ff       	call   1399 <twakeup>
    tsleep();
    1a96:	e8 f6 f8 ff ff       	call   1391 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a9b:	c9                   	leave  
    1a9c:	c3                   	ret    

00001a9d <thread_yield_last>:

void thread_yield_last(){
    1a9d:	55                   	push   %ebp
    1a9e:	89 e5                	mov    %esp,%ebp
    1aa0:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1aa3:	a1 38 20 00 00       	mov    0x2038,%eax
    1aa8:	89 04 24             	mov    %eax,(%esp)
    1aab:	e8 ac 00 00 00       	call   1b5c <pop_q>
    1ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab6:	89 04 24             	mov    %eax,(%esp)
    1ab9:	e8 db f8 ff ff       	call   1399 <twakeup>
    1abe:	c9                   	leave  
    1abf:	c3                   	ret    

00001ac0 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ac0:	55                   	push   %ebp
    1ac1:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ac3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1acc:	8b 45 08             	mov    0x8(%ebp),%eax
    1acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1ad6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ae0:	5d                   	pop    %ebp
    1ae1:	c3                   	ret    

00001ae2 <add_q>:

void add_q(struct queue *q, int v){
    1ae2:	55                   	push   %ebp
    1ae3:	89 e5                	mov    %esp,%ebp
    1ae5:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1ae8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1aef:	e8 89 fc ff ff       	call   177d <malloc>
    1af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b04:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b07:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b09:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0c:	8b 40 04             	mov    0x4(%eax),%eax
    1b0f:	85 c0                	test   %eax,%eax
    1b11:	75 0b                	jne    1b1e <add_q+0x3c>
        q->head = n;
    1b13:	8b 45 08             	mov    0x8(%ebp),%eax
    1b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b19:	89 50 04             	mov    %edx,0x4(%eax)
    1b1c:	eb 0c                	jmp    1b2a <add_q+0x48>
    }else{
        q->tail->next = n;
    1b1e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b21:	8b 40 08             	mov    0x8(%eax),%eax
    1b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b27:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b2a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b30:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b33:	8b 45 08             	mov    0x8(%ebp),%eax
    1b36:	8b 00                	mov    (%eax),%eax
    1b38:	8d 50 01             	lea    0x1(%eax),%edx
    1b3b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3e:	89 10                	mov    %edx,(%eax)
}
    1b40:	c9                   	leave  
    1b41:	c3                   	ret    

00001b42 <empty_q>:

int empty_q(struct queue *q){
    1b42:	55                   	push   %ebp
    1b43:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b45:	8b 45 08             	mov    0x8(%ebp),%eax
    1b48:	8b 00                	mov    (%eax),%eax
    1b4a:	85 c0                	test   %eax,%eax
    1b4c:	75 07                	jne    1b55 <empty_q+0x13>
        return 1;
    1b4e:	b8 01 00 00 00       	mov    $0x1,%eax
    1b53:	eb 05                	jmp    1b5a <empty_q+0x18>
    else
        return 0;
    1b55:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b5a:	5d                   	pop    %ebp
    1b5b:	c3                   	ret    

00001b5c <pop_q>:
int pop_q(struct queue *q){
    1b5c:	55                   	push   %ebp
    1b5d:	89 e5                	mov    %esp,%ebp
    1b5f:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b62:	8b 45 08             	mov    0x8(%ebp),%eax
    1b65:	89 04 24             	mov    %eax,(%esp)
    1b68:	e8 d5 ff ff ff       	call   1b42 <empty_q>
    1b6d:	85 c0                	test   %eax,%eax
    1b6f:	75 5d                	jne    1bce <pop_q+0x72>
       val = q->head->value; 
    1b71:	8b 45 08             	mov    0x8(%ebp),%eax
    1b74:	8b 40 04             	mov    0x4(%eax),%eax
    1b77:	8b 00                	mov    (%eax),%eax
    1b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b7c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7f:	8b 40 04             	mov    0x4(%eax),%eax
    1b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b85:	8b 45 08             	mov    0x8(%ebp),%eax
    1b88:	8b 40 04             	mov    0x4(%eax),%eax
    1b8b:	8b 50 04             	mov    0x4(%eax),%edx
    1b8e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b91:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b97:	89 04 24             	mov    %eax,(%esp)
    1b9a:	e8 a5 fa ff ff       	call   1644 <free>
       q->size--;
    1b9f:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba2:	8b 00                	mov    (%eax),%eax
    1ba4:	8d 50 ff             	lea    -0x1(%eax),%edx
    1ba7:	8b 45 08             	mov    0x8(%ebp),%eax
    1baa:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1bac:	8b 45 08             	mov    0x8(%ebp),%eax
    1baf:	8b 00                	mov    (%eax),%eax
    1bb1:	85 c0                	test   %eax,%eax
    1bb3:	75 14                	jne    1bc9 <pop_q+0x6d>
            q->head = 0;
    1bb5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bbf:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bcc:	eb 05                	jmp    1bd3 <pop_q+0x77>
    }
    return -1;
    1bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1bd3:	c9                   	leave  
    1bd4:	c3                   	ret    
