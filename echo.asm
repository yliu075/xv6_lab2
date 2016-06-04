
_echo:     file format elf32-i386


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
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
    1009:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1010:	00 
    1011:	eb 4b                	jmp    105e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1013:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1017:	83 c0 01             	add    $0x1,%eax
    101a:	3b 45 08             	cmp    0x8(%ebp),%eax
    101d:	7d 07                	jge    1026 <main+0x26>
    101f:	b8 c8 1b 00 00       	mov    $0x1bc8,%eax
    1024:	eb 05                	jmp    102b <main+0x2b>
    1026:	b8 ca 1b 00 00       	mov    $0x1bca,%eax
    102b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    102f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
    1036:	8b 55 0c             	mov    0xc(%ebp),%edx
    1039:	01 ca                	add    %ecx,%edx
    103b:	8b 12                	mov    (%edx),%edx
    103d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1041:	89 54 24 08          	mov    %edx,0x8(%esp)
    1045:	c7 44 24 04 cc 1b 00 	movl   $0x1bcc,0x4(%esp)
    104c:	00 
    104d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1054:	e8 2b 04 00 00       	call   1484 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
    1059:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    105e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1062:	3b 45 08             	cmp    0x8(%ebp),%eax
    1065:	7c ac                	jl     1013 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
    1067:	e8 68 02 00 00       	call   12d4 <exit>

0000106c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	57                   	push   %edi
    1070:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1071:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1074:	8b 55 10             	mov    0x10(%ebp),%edx
    1077:	8b 45 0c             	mov    0xc(%ebp),%eax
    107a:	89 cb                	mov    %ecx,%ebx
    107c:	89 df                	mov    %ebx,%edi
    107e:	89 d1                	mov    %edx,%ecx
    1080:	fc                   	cld    
    1081:	f3 aa                	rep stos %al,%es:(%edi)
    1083:	89 ca                	mov    %ecx,%edx
    1085:	89 fb                	mov    %edi,%ebx
    1087:	89 5d 08             	mov    %ebx,0x8(%ebp)
    108a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    108d:	5b                   	pop    %ebx
    108e:	5f                   	pop    %edi
    108f:	5d                   	pop    %ebp
    1090:	c3                   	ret    

00001091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1091:	55                   	push   %ebp
    1092:	89 e5                	mov    %esp,%ebp
    1094:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1097:	8b 45 08             	mov    0x8(%ebp),%eax
    109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    109d:	90                   	nop
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	8d 50 01             	lea    0x1(%eax),%edx
    10a4:	89 55 08             	mov    %edx,0x8(%ebp)
    10a7:	8b 55 0c             	mov    0xc(%ebp),%edx
    10aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10b0:	0f b6 12             	movzbl (%edx),%edx
    10b3:	88 10                	mov    %dl,(%eax)
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	84 c0                	test   %al,%al
    10ba:	75 e2                	jne    109e <strcpy+0xd>
    ;
  return os;
    10bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10bf:	c9                   	leave  
    10c0:	c3                   	ret    

000010c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10c4:	eb 08                	jmp    10ce <strcmp+0xd>
    p++, q++;
    10c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10ce:	8b 45 08             	mov    0x8(%ebp),%eax
    10d1:	0f b6 00             	movzbl (%eax),%eax
    10d4:	84 c0                	test   %al,%al
    10d6:	74 10                	je     10e8 <strcmp+0x27>
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	0f b6 10             	movzbl (%eax),%edx
    10de:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e1:	0f b6 00             	movzbl (%eax),%eax
    10e4:	38 c2                	cmp    %al,%dl
    10e6:	74 de                	je     10c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e8:	8b 45 08             	mov    0x8(%ebp),%eax
    10eb:	0f b6 00             	movzbl (%eax),%eax
    10ee:	0f b6 d0             	movzbl %al,%edx
    10f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	0f b6 c0             	movzbl %al,%eax
    10fa:	29 c2                	sub    %eax,%edx
    10fc:	89 d0                	mov    %edx,%eax
}
    10fe:	5d                   	pop    %ebp
    10ff:	c3                   	ret    

00001100 <strlen>:

uint
strlen(char *s)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    110d:	eb 04                	jmp    1113 <strlen+0x13>
    110f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1113:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1116:	8b 45 08             	mov    0x8(%ebp),%eax
    1119:	01 d0                	add    %edx,%eax
    111b:	0f b6 00             	movzbl (%eax),%eax
    111e:	84 c0                	test   %al,%al
    1120:	75 ed                	jne    110f <strlen+0xf>
    ;
  return n;
    1122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1125:	c9                   	leave  
    1126:	c3                   	ret    

00001127 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1127:	55                   	push   %ebp
    1128:	89 e5                	mov    %esp,%ebp
    112a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    112d:	8b 45 10             	mov    0x10(%ebp),%eax
    1130:	89 44 24 08          	mov    %eax,0x8(%esp)
    1134:	8b 45 0c             	mov    0xc(%ebp),%eax
    1137:	89 44 24 04          	mov    %eax,0x4(%esp)
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 04 24             	mov    %eax,(%esp)
    1141:	e8 26 ff ff ff       	call   106c <stosb>
  return dst;
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1149:	c9                   	leave  
    114a:	c3                   	ret    

0000114b <strchr>:

char*
strchr(const char *s, char c)
{
    114b:	55                   	push   %ebp
    114c:	89 e5                	mov    %esp,%ebp
    114e:	83 ec 04             	sub    $0x4,%esp
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1157:	eb 14                	jmp    116d <strchr+0x22>
    if(*s == c)
    1159:	8b 45 08             	mov    0x8(%ebp),%eax
    115c:	0f b6 00             	movzbl (%eax),%eax
    115f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1162:	75 05                	jne    1169 <strchr+0x1e>
      return (char*)s;
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	eb 13                	jmp    117c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	0f b6 00             	movzbl (%eax),%eax
    1173:	84 c0                	test   %al,%al
    1175:	75 e2                	jne    1159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1177:	b8 00 00 00 00       	mov    $0x0,%eax
}
    117c:	c9                   	leave  
    117d:	c3                   	ret    

0000117e <gets>:

char*
gets(char *buf, int max)
{
    117e:	55                   	push   %ebp
    117f:	89 e5                	mov    %esp,%ebp
    1181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    118b:	eb 4c                	jmp    11d9 <gets+0x5b>
    cc = read(0, &c, 1);
    118d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1194:	00 
    1195:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1198:	89 44 24 04          	mov    %eax,0x4(%esp)
    119c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11a3:	e8 44 01 00 00       	call   12ec <read>
    11a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11af:	7f 02                	jg     11b3 <gets+0x35>
      break;
    11b1:	eb 31                	jmp    11e4 <gets+0x66>
    buf[i++] = c;
    11b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b6:	8d 50 01             	lea    0x1(%eax),%edx
    11b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11bc:	89 c2                	mov    %eax,%edx
    11be:	8b 45 08             	mov    0x8(%ebp),%eax
    11c1:	01 c2                	add    %eax,%edx
    11c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11cd:	3c 0a                	cmp    $0xa,%al
    11cf:	74 13                	je     11e4 <gets+0x66>
    11d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d5:	3c 0d                	cmp    $0xd,%al
    11d7:	74 0b                	je     11e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11dc:	83 c0 01             	add    $0x1,%eax
    11df:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11e2:	7c a9                	jl     118d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	01 d0                	add    %edx,%eax
    11ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11f2:	c9                   	leave  
    11f3:	c3                   	ret    

000011f4 <stat>:

int
stat(char *n, struct stat *st)
{
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1201:	00 
    1202:	8b 45 08             	mov    0x8(%ebp),%eax
    1205:	89 04 24             	mov    %eax,(%esp)
    1208:	e8 07 01 00 00       	call   1314 <open>
    120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1214:	79 07                	jns    121d <stat+0x29>
    return -1;
    1216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    121b:	eb 23                	jmp    1240 <stat+0x4c>
  r = fstat(fd, st);
    121d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1220:	89 44 24 04          	mov    %eax,0x4(%esp)
    1224:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1227:	89 04 24             	mov    %eax,(%esp)
    122a:	e8 fd 00 00 00       	call   132c <fstat>
    122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1232:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1235:	89 04 24             	mov    %eax,(%esp)
    1238:	e8 bf 00 00 00       	call   12fc <close>
  return r;
    123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1240:	c9                   	leave  
    1241:	c3                   	ret    

00001242 <atoi>:

int
atoi(const char *s)
{
    1242:	55                   	push   %ebp
    1243:	89 e5                	mov    %esp,%ebp
    1245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124f:	eb 25                	jmp    1276 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1251:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1254:	89 d0                	mov    %edx,%eax
    1256:	c1 e0 02             	shl    $0x2,%eax
    1259:	01 d0                	add    %edx,%eax
    125b:	01 c0                	add    %eax,%eax
    125d:	89 c1                	mov    %eax,%ecx
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	89 55 08             	mov    %edx,0x8(%ebp)
    1268:	0f b6 00             	movzbl (%eax),%eax
    126b:	0f be c0             	movsbl %al,%eax
    126e:	01 c8                	add    %ecx,%eax
    1270:	83 e8 30             	sub    $0x30,%eax
    1273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1276:	8b 45 08             	mov    0x8(%ebp),%eax
    1279:	0f b6 00             	movzbl (%eax),%eax
    127c:	3c 2f                	cmp    $0x2f,%al
    127e:	7e 0a                	jle    128a <atoi+0x48>
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	0f b6 00             	movzbl (%eax),%eax
    1286:	3c 39                	cmp    $0x39,%al
    1288:	7e c7                	jle    1251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    128a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    128d:	c9                   	leave  
    128e:	c3                   	ret    

0000128f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128f:	55                   	push   %ebp
    1290:	89 e5                	mov    %esp,%ebp
    1292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1295:	8b 45 08             	mov    0x8(%ebp),%eax
    1298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    129b:	8b 45 0c             	mov    0xc(%ebp),%eax
    129e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12a1:	eb 17                	jmp    12ba <memmove+0x2b>
    *dst++ = *src++;
    12a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a6:	8d 50 01             	lea    0x1(%eax),%edx
    12a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12af:	8d 4a 01             	lea    0x1(%edx),%ecx
    12b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b5:	0f b6 12             	movzbl (%edx),%edx
    12b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12ba:	8b 45 10             	mov    0x10(%ebp),%eax
    12bd:	8d 50 ff             	lea    -0x1(%eax),%edx
    12c0:	89 55 10             	mov    %edx,0x10(%ebp)
    12c3:	85 c0                	test   %eax,%eax
    12c5:	7f dc                	jg     12a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ca:	c9                   	leave  
    12cb:	c3                   	ret    

000012cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12cc:	b8 01 00 00 00       	mov    $0x1,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <exit>:
SYSCALL(exit)
    12d4:	b8 02 00 00 00       	mov    $0x2,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <wait>:
SYSCALL(wait)
    12dc:	b8 03 00 00 00       	mov    $0x3,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <pipe>:
SYSCALL(pipe)
    12e4:	b8 04 00 00 00       	mov    $0x4,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <read>:
SYSCALL(read)
    12ec:	b8 05 00 00 00       	mov    $0x5,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <write>:
SYSCALL(write)
    12f4:	b8 10 00 00 00       	mov    $0x10,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <close>:
SYSCALL(close)
    12fc:	b8 15 00 00 00       	mov    $0x15,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <kill>:
SYSCALL(kill)
    1304:	b8 06 00 00 00       	mov    $0x6,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <exec>:
SYSCALL(exec)
    130c:	b8 07 00 00 00       	mov    $0x7,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <open>:
SYSCALL(open)
    1314:	b8 0f 00 00 00       	mov    $0xf,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <mknod>:
SYSCALL(mknod)
    131c:	b8 11 00 00 00       	mov    $0x11,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <unlink>:
SYSCALL(unlink)
    1324:	b8 12 00 00 00       	mov    $0x12,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <fstat>:
SYSCALL(fstat)
    132c:	b8 08 00 00 00       	mov    $0x8,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <link>:
SYSCALL(link)
    1334:	b8 13 00 00 00       	mov    $0x13,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <mkdir>:
SYSCALL(mkdir)
    133c:	b8 14 00 00 00       	mov    $0x14,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <chdir>:
SYSCALL(chdir)
    1344:	b8 09 00 00 00       	mov    $0x9,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <dup>:
SYSCALL(dup)
    134c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <getpid>:
SYSCALL(getpid)
    1354:	b8 0b 00 00 00       	mov    $0xb,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <sbrk>:
SYSCALL(sbrk)
    135c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <sleep>:
SYSCALL(sleep)
    1364:	b8 0d 00 00 00       	mov    $0xd,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <uptime>:
SYSCALL(uptime)
    136c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <clone>:
SYSCALL(clone)
    1374:	b8 16 00 00 00       	mov    $0x16,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <texit>:
SYSCALL(texit)
    137c:	b8 17 00 00 00       	mov    $0x17,%eax
    1381:	cd 40                	int    $0x40
    1383:	c3                   	ret    

00001384 <tsleep>:
SYSCALL(tsleep)
    1384:	b8 18 00 00 00       	mov    $0x18,%eax
    1389:	cd 40                	int    $0x40
    138b:	c3                   	ret    

0000138c <twakeup>:
SYSCALL(twakeup)
    138c:	b8 19 00 00 00       	mov    $0x19,%eax
    1391:	cd 40                	int    $0x40
    1393:	c3                   	ret    

00001394 <thread_yield>:
SYSCALL(thread_yield)
    1394:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1399:	cd 40                	int    $0x40
    139b:	c3                   	ret    

0000139c <thread_yield3>:
    139c:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13a1:	cd 40                	int    $0x40
    13a3:	c3                   	ret    

000013a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13a4:	55                   	push   %ebp
    13a5:	89 e5                	mov    %esp,%ebp
    13a7:	83 ec 18             	sub    $0x18,%esp
    13aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b7:	00 
    13b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13bb:	89 44 24 04          	mov    %eax,0x4(%esp)
    13bf:	8b 45 08             	mov    0x8(%ebp),%eax
    13c2:	89 04 24             	mov    %eax,(%esp)
    13c5:	e8 2a ff ff ff       	call   12f4 <write>
}
    13ca:	c9                   	leave  
    13cb:	c3                   	ret    

000013cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13cc:	55                   	push   %ebp
    13cd:	89 e5                	mov    %esp,%ebp
    13cf:	56                   	push   %esi
    13d0:	53                   	push   %ebx
    13d1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13df:	74 17                	je     13f8 <printint+0x2c>
    13e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13e5:	79 11                	jns    13f8 <printint+0x2c>
    neg = 1;
    13e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f1:	f7 d8                	neg    %eax
    13f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f6:	eb 06                	jmp    13fe <printint+0x32>
  } else {
    x = xx;
    13f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1405:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1408:	8d 41 01             	lea    0x1(%ecx),%eax
    140b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    140e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1411:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1414:	ba 00 00 00 00       	mov    $0x0,%edx
    1419:	f7 f3                	div    %ebx
    141b:	89 d0                	mov    %edx,%eax
    141d:	0f b6 80 e4 1f 00 00 	movzbl 0x1fe4(%eax),%eax
    1424:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1428:	8b 75 10             	mov    0x10(%ebp),%esi
    142b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    142e:	ba 00 00 00 00       	mov    $0x0,%edx
    1433:	f7 f6                	div    %esi
    1435:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1438:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    143c:	75 c7                	jne    1405 <printint+0x39>
  if(neg)
    143e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1442:	74 10                	je     1454 <printint+0x88>
    buf[i++] = '-';
    1444:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1447:	8d 50 01             	lea    0x1(%eax),%edx
    144a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    144d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1452:	eb 1f                	jmp    1473 <printint+0xa7>
    1454:	eb 1d                	jmp    1473 <printint+0xa7>
    putc(fd, buf[i]);
    1456:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1459:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145c:	01 d0                	add    %edx,%eax
    145e:	0f b6 00             	movzbl (%eax),%eax
    1461:	0f be c0             	movsbl %al,%eax
    1464:	89 44 24 04          	mov    %eax,0x4(%esp)
    1468:	8b 45 08             	mov    0x8(%ebp),%eax
    146b:	89 04 24             	mov    %eax,(%esp)
    146e:	e8 31 ff ff ff       	call   13a4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1473:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    147b:	79 d9                	jns    1456 <printint+0x8a>
    putc(fd, buf[i]);
}
    147d:	83 c4 30             	add    $0x30,%esp
    1480:	5b                   	pop    %ebx
    1481:	5e                   	pop    %esi
    1482:	5d                   	pop    %ebp
    1483:	c3                   	ret    

00001484 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1484:	55                   	push   %ebp
    1485:	89 e5                	mov    %esp,%ebp
    1487:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    148a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1491:	8d 45 0c             	lea    0xc(%ebp),%eax
    1494:	83 c0 04             	add    $0x4,%eax
    1497:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    149a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14a1:	e9 7c 01 00 00       	jmp    1622 <printf+0x19e>
    c = fmt[i] & 0xff;
    14a6:	8b 55 0c             	mov    0xc(%ebp),%edx
    14a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14ac:	01 d0                	add    %edx,%eax
    14ae:	0f b6 00             	movzbl (%eax),%eax
    14b1:	0f be c0             	movsbl %al,%eax
    14b4:	25 ff 00 00 00       	and    $0xff,%eax
    14b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14c0:	75 2c                	jne    14ee <printf+0x6a>
      if(c == '%'){
    14c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14c6:	75 0c                	jne    14d4 <printf+0x50>
        state = '%';
    14c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14cf:	e9 4a 01 00 00       	jmp    161e <printf+0x19a>
      } else {
        putc(fd, c);
    14d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14d7:	0f be c0             	movsbl %al,%eax
    14da:	89 44 24 04          	mov    %eax,0x4(%esp)
    14de:	8b 45 08             	mov    0x8(%ebp),%eax
    14e1:	89 04 24             	mov    %eax,(%esp)
    14e4:	e8 bb fe ff ff       	call   13a4 <putc>
    14e9:	e9 30 01 00 00       	jmp    161e <printf+0x19a>
      }
    } else if(state == '%'){
    14ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14f2:	0f 85 26 01 00 00    	jne    161e <printf+0x19a>
      if(c == 'd'){
    14f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14fc:	75 2d                	jne    152b <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1501:	8b 00                	mov    (%eax),%eax
    1503:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    150a:	00 
    150b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1512:	00 
    1513:	89 44 24 04          	mov    %eax,0x4(%esp)
    1517:	8b 45 08             	mov    0x8(%ebp),%eax
    151a:	89 04 24             	mov    %eax,(%esp)
    151d:	e8 aa fe ff ff       	call   13cc <printint>
        ap++;
    1522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1526:	e9 ec 00 00 00       	jmp    1617 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    152b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    152f:	74 06                	je     1537 <printf+0xb3>
    1531:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1535:	75 2d                	jne    1564 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1537:	8b 45 e8             	mov    -0x18(%ebp),%eax
    153a:	8b 00                	mov    (%eax),%eax
    153c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1543:	00 
    1544:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    154b:	00 
    154c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1550:	8b 45 08             	mov    0x8(%ebp),%eax
    1553:	89 04 24             	mov    %eax,(%esp)
    1556:	e8 71 fe ff ff       	call   13cc <printint>
        ap++;
    155b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    155f:	e9 b3 00 00 00       	jmp    1617 <printf+0x193>
      } else if(c == 's'){
    1564:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1568:	75 45                	jne    15af <printf+0x12b>
        s = (char*)*ap;
    156a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    156d:	8b 00                	mov    (%eax),%eax
    156f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157a:	75 09                	jne    1585 <printf+0x101>
          s = "(null)";
    157c:	c7 45 f4 d1 1b 00 00 	movl   $0x1bd1,-0xc(%ebp)
        while(*s != 0){
    1583:	eb 1e                	jmp    15a3 <printf+0x11f>
    1585:	eb 1c                	jmp    15a3 <printf+0x11f>
          putc(fd, *s);
    1587:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158a:	0f b6 00             	movzbl (%eax),%eax
    158d:	0f be c0             	movsbl %al,%eax
    1590:	89 44 24 04          	mov    %eax,0x4(%esp)
    1594:	8b 45 08             	mov    0x8(%ebp),%eax
    1597:	89 04 24             	mov    %eax,(%esp)
    159a:	e8 05 fe ff ff       	call   13a4 <putc>
          s++;
    159f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a6:	0f b6 00             	movzbl (%eax),%eax
    15a9:	84 c0                	test   %al,%al
    15ab:	75 da                	jne    1587 <printf+0x103>
    15ad:	eb 68                	jmp    1617 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15b3:	75 1d                	jne    15d2 <printf+0x14e>
        putc(fd, *ap);
    15b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b8:	8b 00                	mov    (%eax),%eax
    15ba:	0f be c0             	movsbl %al,%eax
    15bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c1:	8b 45 08             	mov    0x8(%ebp),%eax
    15c4:	89 04 24             	mov    %eax,(%esp)
    15c7:	e8 d8 fd ff ff       	call   13a4 <putc>
        ap++;
    15cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d0:	eb 45                	jmp    1617 <printf+0x193>
      } else if(c == '%'){
    15d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15d6:	75 17                	jne    15ef <printf+0x16b>
        putc(fd, c);
    15d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15db:	0f be c0             	movsbl %al,%eax
    15de:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e2:	8b 45 08             	mov    0x8(%ebp),%eax
    15e5:	89 04 24             	mov    %eax,(%esp)
    15e8:	e8 b7 fd ff ff       	call   13a4 <putc>
    15ed:	eb 28                	jmp    1617 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15ef:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15f6:	00 
    15f7:	8b 45 08             	mov    0x8(%ebp),%eax
    15fa:	89 04 24             	mov    %eax,(%esp)
    15fd:	e8 a2 fd ff ff       	call   13a4 <putc>
        putc(fd, c);
    1602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1605:	0f be c0             	movsbl %al,%eax
    1608:	89 44 24 04          	mov    %eax,0x4(%esp)
    160c:	8b 45 08             	mov    0x8(%ebp),%eax
    160f:	89 04 24             	mov    %eax,(%esp)
    1612:	e8 8d fd ff ff       	call   13a4 <putc>
      }
      state = 0;
    1617:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    161e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1622:	8b 55 0c             	mov    0xc(%ebp),%edx
    1625:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1628:	01 d0                	add    %edx,%eax
    162a:	0f b6 00             	movzbl (%eax),%eax
    162d:	84 c0                	test   %al,%al
    162f:	0f 85 71 fe ff ff    	jne    14a6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1635:	c9                   	leave  
    1636:	c3                   	ret    

00001637 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1637:	55                   	push   %ebp
    1638:	89 e5                	mov    %esp,%ebp
    163a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    163d:	8b 45 08             	mov    0x8(%ebp),%eax
    1640:	83 e8 08             	sub    $0x8,%eax
    1643:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1646:	a1 04 20 00 00       	mov    0x2004,%eax
    164b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    164e:	eb 24                	jmp    1674 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1650:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1653:	8b 00                	mov    (%eax),%eax
    1655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1658:	77 12                	ja     166c <free+0x35>
    165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1660:	77 24                	ja     1686 <free+0x4f>
    1662:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1665:	8b 00                	mov    (%eax),%eax
    1667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    166a:	77 1a                	ja     1686 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    166c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166f:	8b 00                	mov    (%eax),%eax
    1671:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1674:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    167a:	76 d4                	jbe    1650 <free+0x19>
    167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167f:	8b 00                	mov    (%eax),%eax
    1681:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1684:	76 ca                	jbe    1650 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1686:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1689:	8b 40 04             	mov    0x4(%eax),%eax
    168c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1693:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1696:	01 c2                	add    %eax,%edx
    1698:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169b:	8b 00                	mov    (%eax),%eax
    169d:	39 c2                	cmp    %eax,%edx
    169f:	75 24                	jne    16c5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a4:	8b 50 04             	mov    0x4(%eax),%edx
    16a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16aa:	8b 00                	mov    (%eax),%eax
    16ac:	8b 40 04             	mov    0x4(%eax),%eax
    16af:	01 c2                	add    %eax,%edx
    16b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ba:	8b 00                	mov    (%eax),%eax
    16bc:	8b 10                	mov    (%eax),%edx
    16be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c1:	89 10                	mov    %edx,(%eax)
    16c3:	eb 0a                	jmp    16cf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c8:	8b 10                	mov    (%eax),%edx
    16ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16cd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d2:	8b 40 04             	mov    0x4(%eax),%eax
    16d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16df:	01 d0                	add    %edx,%eax
    16e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16e4:	75 20                	jne    1706 <free+0xcf>
    p->s.size += bp->s.size;
    16e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e9:	8b 50 04             	mov    0x4(%eax),%edx
    16ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ef:	8b 40 04             	mov    0x4(%eax),%eax
    16f2:	01 c2                	add    %eax,%edx
    16f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fd:	8b 10                	mov    (%eax),%edx
    16ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1702:	89 10                	mov    %edx,(%eax)
    1704:	eb 08                	jmp    170e <free+0xd7>
  } else
    p->s.ptr = bp;
    1706:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1709:	8b 55 f8             	mov    -0x8(%ebp),%edx
    170c:	89 10                	mov    %edx,(%eax)
  freep = p;
    170e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1711:	a3 04 20 00 00       	mov    %eax,0x2004
}
    1716:	c9                   	leave  
    1717:	c3                   	ret    

00001718 <morecore>:

static Header*
morecore(uint nu)
{
    1718:	55                   	push   %ebp
    1719:	89 e5                	mov    %esp,%ebp
    171b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    171e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1725:	77 07                	ja     172e <morecore+0x16>
    nu = 4096;
    1727:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    172e:	8b 45 08             	mov    0x8(%ebp),%eax
    1731:	c1 e0 03             	shl    $0x3,%eax
    1734:	89 04 24             	mov    %eax,(%esp)
    1737:	e8 20 fc ff ff       	call   135c <sbrk>
    173c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    173f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1743:	75 07                	jne    174c <morecore+0x34>
    return 0;
    1745:	b8 00 00 00 00       	mov    $0x0,%eax
    174a:	eb 22                	jmp    176e <morecore+0x56>
  hp = (Header*)p;
    174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1752:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1755:	8b 55 08             	mov    0x8(%ebp),%edx
    1758:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    175e:	83 c0 08             	add    $0x8,%eax
    1761:	89 04 24             	mov    %eax,(%esp)
    1764:	e8 ce fe ff ff       	call   1637 <free>
  return freep;
    1769:	a1 04 20 00 00       	mov    0x2004,%eax
}
    176e:	c9                   	leave  
    176f:	c3                   	ret    

00001770 <malloc>:

void*
malloc(uint nbytes)
{
    1770:	55                   	push   %ebp
    1771:	89 e5                	mov    %esp,%ebp
    1773:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1776:	8b 45 08             	mov    0x8(%ebp),%eax
    1779:	83 c0 07             	add    $0x7,%eax
    177c:	c1 e8 03             	shr    $0x3,%eax
    177f:	83 c0 01             	add    $0x1,%eax
    1782:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1785:	a1 04 20 00 00       	mov    0x2004,%eax
    178a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    178d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1791:	75 23                	jne    17b6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1793:	c7 45 f0 fc 1f 00 00 	movl   $0x1ffc,-0x10(%ebp)
    179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179d:	a3 04 20 00 00       	mov    %eax,0x2004
    17a2:	a1 04 20 00 00       	mov    0x2004,%eax
    17a7:	a3 fc 1f 00 00       	mov    %eax,0x1ffc
    base.s.size = 0;
    17ac:	c7 05 00 20 00 00 00 	movl   $0x0,0x2000
    17b3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b9:	8b 00                	mov    (%eax),%eax
    17bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c1:	8b 40 04             	mov    0x4(%eax),%eax
    17c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17c7:	72 4d                	jb     1816 <malloc+0xa6>
      if(p->s.size == nunits)
    17c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cc:	8b 40 04             	mov    0x4(%eax),%eax
    17cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17d2:	75 0c                	jne    17e0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d7:	8b 10                	mov    (%eax),%edx
    17d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17dc:	89 10                	mov    %edx,(%eax)
    17de:	eb 26                	jmp    1806 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e3:	8b 40 04             	mov    0x4(%eax),%eax
    17e6:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17e9:	89 c2                	mov    %eax,%edx
    17eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ee:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f4:	8b 40 04             	mov    0x4(%eax),%eax
    17f7:	c1 e0 03             	shl    $0x3,%eax
    17fa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1800:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1803:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1806:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1809:	a3 04 20 00 00       	mov    %eax,0x2004
      return (void*)(p + 1);
    180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1811:	83 c0 08             	add    $0x8,%eax
    1814:	eb 38                	jmp    184e <malloc+0xde>
    }
    if(p == freep)
    1816:	a1 04 20 00 00       	mov    0x2004,%eax
    181b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    181e:	75 1b                	jne    183b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1820:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1823:	89 04 24             	mov    %eax,(%esp)
    1826:	e8 ed fe ff ff       	call   1718 <morecore>
    182b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    182e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1832:	75 07                	jne    183b <malloc+0xcb>
        return 0;
    1834:	b8 00 00 00 00       	mov    $0x0,%eax
    1839:	eb 13                	jmp    184e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    183b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1841:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1844:	8b 00                	mov    (%eax),%eax
    1846:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1849:	e9 70 ff ff ff       	jmp    17be <malloc+0x4e>
}
    184e:	c9                   	leave  
    184f:	c3                   	ret    

00001850 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1850:	55                   	push   %ebp
    1851:	89 e5                	mov    %esp,%ebp
    1853:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1856:	8b 55 08             	mov    0x8(%ebp),%edx
    1859:	8b 45 0c             	mov    0xc(%ebp),%eax
    185c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    185f:	f0 87 02             	lock xchg %eax,(%edx)
    1862:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1865:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1868:	c9                   	leave  
    1869:	c3                   	ret    

0000186a <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    186a:	55                   	push   %ebp
    186b:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    186d:	8b 45 08             	mov    0x8(%ebp),%eax
    1870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1876:	5d                   	pop    %ebp
    1877:	c3                   	ret    

00001878 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1878:	55                   	push   %ebp
    1879:	89 e5                	mov    %esp,%ebp
    187b:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    187e:	90                   	nop
    187f:	8b 45 08             	mov    0x8(%ebp),%eax
    1882:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1889:	00 
    188a:	89 04 24             	mov    %eax,(%esp)
    188d:	e8 be ff ff ff       	call   1850 <xchg>
    1892:	85 c0                	test   %eax,%eax
    1894:	75 e9                	jne    187f <lock_acquire+0x7>
}
    1896:	c9                   	leave  
    1897:	c3                   	ret    

00001898 <lock_release>:
void lock_release(lock_t *lock){
    1898:	55                   	push   %ebp
    1899:	89 e5                	mov    %esp,%ebp
    189b:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    189e:	8b 45 08             	mov    0x8(%ebp),%eax
    18a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18a8:	00 
    18a9:	89 04 24             	mov    %eax,(%esp)
    18ac:	e8 9f ff ff ff       	call   1850 <xchg>
}
    18b1:	c9                   	leave  
    18b2:	c3                   	ret    

000018b3 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    18b3:	55                   	push   %ebp
    18b4:	89 e5                	mov    %esp,%ebp
    18b6:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    18b9:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    18c0:	e8 ab fe ff ff       	call   1770 <malloc>
    18c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    18c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18ce:	0f b6 05 08 20 00 00 	movzbl 0x2008,%eax
    18d5:	84 c0                	test   %al,%al
    18d7:	75 1c                	jne    18f5 <thread_create+0x42>
        init_q(thQ2);
    18d9:	a1 10 20 00 00       	mov    0x2010,%eax
    18de:	89 04 24             	mov    %eax,(%esp)
    18e1:	e8 cd 01 00 00       	call   1ab3 <init_q>
        inQ++;
    18e6:	0f b6 05 08 20 00 00 	movzbl 0x2008,%eax
    18ed:	83 c0 01             	add    $0x1,%eax
    18f0:	a2 08 20 00 00       	mov    %al,0x2008
    }

    if((uint)stack % 4096){
    18f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f8:	25 ff 0f 00 00       	and    $0xfff,%eax
    18fd:	85 c0                	test   %eax,%eax
    18ff:	74 14                	je     1915 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1901:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1904:	25 ff 0f 00 00       	and    $0xfff,%eax
    1909:	89 c2                	mov    %eax,%edx
    190b:	b8 00 10 00 00       	mov    $0x1000,%eax
    1910:	29 d0                	sub    %edx,%eax
    1912:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1919:	75 1e                	jne    1939 <thread_create+0x86>

        printf(1,"malloc fail \n");
    191b:	c7 44 24 04 d8 1b 00 	movl   $0x1bd8,0x4(%esp)
    1922:	00 
    1923:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    192a:	e8 55 fb ff ff       	call   1484 <printf>
        return 0;
    192f:	b8 00 00 00 00       	mov    $0x0,%eax
    1934:	e9 9e 00 00 00       	jmp    19d7 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1939:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    193c:	8b 55 08             	mov    0x8(%ebp),%edx
    193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1942:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1946:	89 54 24 08          	mov    %edx,0x8(%esp)
    194a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1951:	00 
    1952:	89 04 24             	mov    %eax,(%esp)
    1955:	e8 1a fa ff ff       	call   1374 <clone>
    195a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    195d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1960:	89 44 24 08          	mov    %eax,0x8(%esp)
    1964:	c7 44 24 04 e6 1b 00 	movl   $0x1be6,0x4(%esp)
    196b:	00 
    196c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1973:	e8 0c fb ff ff       	call   1484 <printf>
    if(tid < 0){
    1978:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    197c:	79 1b                	jns    1999 <thread_create+0xe6>
        printf(1,"clone fails\n");
    197e:	c7 44 24 04 ff 1b 00 	movl   $0x1bff,0x4(%esp)
    1985:	00 
    1986:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    198d:	e8 f2 fa ff ff       	call   1484 <printf>
        return 0;
    1992:	b8 00 00 00 00       	mov    $0x0,%eax
    1997:	eb 3e                	jmp    19d7 <thread_create+0x124>
    }
    if(tid > 0){
    1999:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    199d:	7e 19                	jle    19b8 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    199f:	a1 10 20 00 00       	mov    0x2010,%eax
    19a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19a7:	89 54 24 04          	mov    %edx,0x4(%esp)
    19ab:	89 04 24             	mov    %eax,(%esp)
    19ae:	e8 22 01 00 00       	call   1ad5 <add_q>
        return garbage_stack;
    19b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19b6:	eb 1f                	jmp    19d7 <thread_create+0x124>
    }
    if(tid == 0){
    19b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19bc:	75 14                	jne    19d2 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    19be:	c7 44 24 04 0c 1c 00 	movl   $0x1c0c,0x4(%esp)
    19c5:	00 
    19c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19cd:	e8 b2 fa ff ff       	call   1484 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19d7:	c9                   	leave  
    19d8:	c3                   	ret    

000019d9 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19d9:	55                   	push   %ebp
    19da:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19dc:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    19e1:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    19e7:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19ec:	a3 f8 1f 00 00       	mov    %eax,0x1ff8
    return (int)(rands % max);
    19f1:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    19f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19f9:	ba 00 00 00 00       	mov    $0x0,%edx
    19fe:	f7 f1                	div    %ecx
    1a00:	89 d0                	mov    %edx,%eax
}
    1a02:	5d                   	pop    %ebp
    1a03:	c3                   	ret    

00001a04 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a04:	55                   	push   %ebp
    1a05:	89 e5                	mov    %esp,%ebp
    1a07:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a0a:	e8 45 f9 ff ff       	call   1354 <getpid>
    1a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a12:	a1 10 20 00 00       	mov    0x2010,%eax
    1a17:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a1a:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a1e:	89 04 24             	mov    %eax,(%esp)
    1a21:	e8 af 00 00 00       	call   1ad5 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a26:	a1 10 20 00 00       	mov    0x2010,%eax
    1a2b:	89 04 24             	mov    %eax,(%esp)
    1a2e:	e8 1c 01 00 00       	call   1b4f <pop_q>
    1a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a36:	a1 0c 20 00 00       	mov    0x200c,%eax
    1a3b:	85 c0                	test   %eax,%eax
    1a3d:	75 1f                	jne    1a5e <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a3f:	a1 10 20 00 00       	mov    0x2010,%eax
    1a44:	89 04 24             	mov    %eax,(%esp)
    1a47:	e8 03 01 00 00       	call   1b4f <pop_q>
    1a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a4f:	a1 0c 20 00 00       	mov    0x200c,%eax
    1a54:	83 c0 01             	add    $0x1,%eax
    1a57:	a3 0c 20 00 00       	mov    %eax,0x200c
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a5c:	eb 12                	jmp    1a70 <thread_yield2+0x6c>
    1a5e:	eb 10                	jmp    1a70 <thread_yield2+0x6c>
    1a60:	a1 10 20 00 00       	mov    0x2010,%eax
    1a65:	89 04 24             	mov    %eax,(%esp)
    1a68:	e8 e2 00 00 00       	call   1b4f <pop_q>
    1a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a76:	74 e8                	je     1a60 <thread_yield2+0x5c>
    1a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a7c:	74 e2                	je     1a60 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a81:	89 04 24             	mov    %eax,(%esp)
    1a84:	e8 03 f9 ff ff       	call   138c <twakeup>
    tsleep();
    1a89:	e8 f6 f8 ff ff       	call   1384 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a8e:	c9                   	leave  
    1a8f:	c3                   	ret    

00001a90 <thread_yield_last>:

void thread_yield_last(){
    1a90:	55                   	push   %ebp
    1a91:	89 e5                	mov    %esp,%ebp
    1a93:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1a96:	a1 10 20 00 00       	mov    0x2010,%eax
    1a9b:	89 04 24             	mov    %eax,(%esp)
    1a9e:	e8 ac 00 00 00       	call   1b4f <pop_q>
    1aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa9:	89 04 24             	mov    %eax,(%esp)
    1aac:	e8 db f8 ff ff       	call   138c <twakeup>
    1ab1:	c9                   	leave  
    1ab2:	c3                   	ret    

00001ab3 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ab3:	55                   	push   %ebp
    1ab4:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ab6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1abf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1ac9:	8b 45 08             	mov    0x8(%ebp),%eax
    1acc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ad3:	5d                   	pop    %ebp
    1ad4:	c3                   	ret    

00001ad5 <add_q>:

void add_q(struct queue *q, int v){
    1ad5:	55                   	push   %ebp
    1ad6:	89 e5                	mov    %esp,%ebp
    1ad8:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1adb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ae2:	e8 89 fc ff ff       	call   1770 <malloc>
    1ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af7:	8b 55 0c             	mov    0xc(%ebp),%edx
    1afa:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1afc:	8b 45 08             	mov    0x8(%ebp),%eax
    1aff:	8b 40 04             	mov    0x4(%eax),%eax
    1b02:	85 c0                	test   %eax,%eax
    1b04:	75 0b                	jne    1b11 <add_q+0x3c>
        q->head = n;
    1b06:	8b 45 08             	mov    0x8(%ebp),%eax
    1b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b0c:	89 50 04             	mov    %edx,0x4(%eax)
    1b0f:	eb 0c                	jmp    1b1d <add_q+0x48>
    }else{
        q->tail->next = n;
    1b11:	8b 45 08             	mov    0x8(%ebp),%eax
    1b14:	8b 40 08             	mov    0x8(%eax),%eax
    1b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b1a:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b1d:	8b 45 08             	mov    0x8(%ebp),%eax
    1b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b23:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b26:	8b 45 08             	mov    0x8(%ebp),%eax
    1b29:	8b 00                	mov    (%eax),%eax
    1b2b:	8d 50 01             	lea    0x1(%eax),%edx
    1b2e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b31:	89 10                	mov    %edx,(%eax)
}
    1b33:	c9                   	leave  
    1b34:	c3                   	ret    

00001b35 <empty_q>:

int empty_q(struct queue *q){
    1b35:	55                   	push   %ebp
    1b36:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b38:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3b:	8b 00                	mov    (%eax),%eax
    1b3d:	85 c0                	test   %eax,%eax
    1b3f:	75 07                	jne    1b48 <empty_q+0x13>
        return 1;
    1b41:	b8 01 00 00 00       	mov    $0x1,%eax
    1b46:	eb 05                	jmp    1b4d <empty_q+0x18>
    else
        return 0;
    1b48:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b4d:	5d                   	pop    %ebp
    1b4e:	c3                   	ret    

00001b4f <pop_q>:
int pop_q(struct queue *q){
    1b4f:	55                   	push   %ebp
    1b50:	89 e5                	mov    %esp,%ebp
    1b52:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b55:	8b 45 08             	mov    0x8(%ebp),%eax
    1b58:	89 04 24             	mov    %eax,(%esp)
    1b5b:	e8 d5 ff ff ff       	call   1b35 <empty_q>
    1b60:	85 c0                	test   %eax,%eax
    1b62:	75 5d                	jne    1bc1 <pop_q+0x72>
       val = q->head->value; 
    1b64:	8b 45 08             	mov    0x8(%ebp),%eax
    1b67:	8b 40 04             	mov    0x4(%eax),%eax
    1b6a:	8b 00                	mov    (%eax),%eax
    1b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b6f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b72:	8b 40 04             	mov    0x4(%eax),%eax
    1b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b78:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7b:	8b 40 04             	mov    0x4(%eax),%eax
    1b7e:	8b 50 04             	mov    0x4(%eax),%edx
    1b81:	8b 45 08             	mov    0x8(%ebp),%eax
    1b84:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b8a:	89 04 24             	mov    %eax,(%esp)
    1b8d:	e8 a5 fa ff ff       	call   1637 <free>
       q->size--;
    1b92:	8b 45 08             	mov    0x8(%ebp),%eax
    1b95:	8b 00                	mov    (%eax),%eax
    1b97:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b9a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9d:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1b9f:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba2:	8b 00                	mov    (%eax),%eax
    1ba4:	85 c0                	test   %eax,%eax
    1ba6:	75 14                	jne    1bbc <pop_q+0x6d>
            q->head = 0;
    1ba8:	8b 45 08             	mov    0x8(%ebp),%eax
    1bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bb2:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bbf:	eb 05                	jmp    1bc6 <pop_q+0x77>
    }
    return -1;
    1bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1bc6:	c9                   	leave  
    1bc7:	c3                   	ret    
