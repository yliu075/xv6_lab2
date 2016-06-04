
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
    1009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "usage: kill pid...\n");
    100f:	c7 44 24 04 a8 1b 00 	movl   $0x1ba8,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 5c 04 00 00       	call   147f <printf>
    exit();
    1023:	e8 a7 02 00 00       	call   12cf <exit>
  }
  for(i=1; i<argc; i++)
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 27                	jmp    1059 <main+0x59>
    kill(atoi(argv[i]));
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 f1 01 00 00       	call   123d <atoi>
    104c:	89 04 24             	mov    %eax,(%esp)
    104f:	e8 ab 02 00 00       	call   12ff <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    1054:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1059:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    105d:	3b 45 08             	cmp    0x8(%ebp),%eax
    1060:	7c d0                	jl     1032 <main+0x32>
    kill(atoi(argv[i]));
  exit();
    1062:	e8 68 02 00 00       	call   12cf <exit>

00001067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1067:	55                   	push   %ebp
    1068:	89 e5                	mov    %esp,%ebp
    106a:	57                   	push   %edi
    106b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    106c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    106f:	8b 55 10             	mov    0x10(%ebp),%edx
    1072:	8b 45 0c             	mov    0xc(%ebp),%eax
    1075:	89 cb                	mov    %ecx,%ebx
    1077:	89 df                	mov    %ebx,%edi
    1079:	89 d1                	mov    %edx,%ecx
    107b:	fc                   	cld    
    107c:	f3 aa                	rep stos %al,%es:(%edi)
    107e:	89 ca                	mov    %ecx,%edx
    1080:	89 fb                	mov    %edi,%ebx
    1082:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1085:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1088:	5b                   	pop    %ebx
    1089:	5f                   	pop    %edi
    108a:	5d                   	pop    %ebp
    108b:	c3                   	ret    

0000108c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    108c:	55                   	push   %ebp
    108d:	89 e5                	mov    %esp,%ebp
    108f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1092:	8b 45 08             	mov    0x8(%ebp),%eax
    1095:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1098:	90                   	nop
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	8d 50 01             	lea    0x1(%eax),%edx
    109f:	89 55 08             	mov    %edx,0x8(%ebp)
    10a2:	8b 55 0c             	mov    0xc(%ebp),%edx
    10a5:	8d 4a 01             	lea    0x1(%edx),%ecx
    10a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10ab:	0f b6 12             	movzbl (%edx),%edx
    10ae:	88 10                	mov    %dl,(%eax)
    10b0:	0f b6 00             	movzbl (%eax),%eax
    10b3:	84 c0                	test   %al,%al
    10b5:	75 e2                	jne    1099 <strcpy+0xd>
    ;
  return os;
    10b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ba:	c9                   	leave  
    10bb:	c3                   	ret    

000010bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bc:	55                   	push   %ebp
    10bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10bf:	eb 08                	jmp    10c9 <strcmp+0xd>
    p++, q++;
    10c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c9:	8b 45 08             	mov    0x8(%ebp),%eax
    10cc:	0f b6 00             	movzbl (%eax),%eax
    10cf:	84 c0                	test   %al,%al
    10d1:	74 10                	je     10e3 <strcmp+0x27>
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	0f b6 10             	movzbl (%eax),%edx
    10d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dc:	0f b6 00             	movzbl (%eax),%eax
    10df:	38 c2                	cmp    %al,%dl
    10e1:	74 de                	je     10c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	0f b6 00             	movzbl (%eax),%eax
    10e9:	0f b6 d0             	movzbl %al,%edx
    10ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ef:	0f b6 00             	movzbl (%eax),%eax
    10f2:	0f b6 c0             	movzbl %al,%eax
    10f5:	29 c2                	sub    %eax,%edx
    10f7:	89 d0                	mov    %edx,%eax
}
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    

000010fb <strlen>:

uint
strlen(char *s)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1108:	eb 04                	jmp    110e <strlen+0x13>
    110a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    110e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	01 d0                	add    %edx,%eax
    1116:	0f b6 00             	movzbl (%eax),%eax
    1119:	84 c0                	test   %al,%al
    111b:	75 ed                	jne    110a <strlen+0xf>
    ;
  return n;
    111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1120:	c9                   	leave  
    1121:	c3                   	ret    

00001122 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1122:	55                   	push   %ebp
    1123:	89 e5                	mov    %esp,%ebp
    1125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1128:	8b 45 10             	mov    0x10(%ebp),%eax
    112b:	89 44 24 08          	mov    %eax,0x8(%esp)
    112f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1132:	89 44 24 04          	mov    %eax,0x4(%esp)
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	89 04 24             	mov    %eax,(%esp)
    113c:	e8 26 ff ff ff       	call   1067 <stosb>
  return dst;
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1144:	c9                   	leave  
    1145:	c3                   	ret    

00001146 <strchr>:

char*
strchr(const char *s, char c)
{
    1146:	55                   	push   %ebp
    1147:	89 e5                	mov    %esp,%ebp
    1149:	83 ec 04             	sub    $0x4,%esp
    114c:	8b 45 0c             	mov    0xc(%ebp),%eax
    114f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1152:	eb 14                	jmp    1168 <strchr+0x22>
    if(*s == c)
    1154:	8b 45 08             	mov    0x8(%ebp),%eax
    1157:	0f b6 00             	movzbl (%eax),%eax
    115a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    115d:	75 05                	jne    1164 <strchr+0x1e>
      return (char*)s;
    115f:	8b 45 08             	mov    0x8(%ebp),%eax
    1162:	eb 13                	jmp    1177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	0f b6 00             	movzbl (%eax),%eax
    116e:	84 c0                	test   %al,%al
    1170:	75 e2                	jne    1154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1172:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1177:	c9                   	leave  
    1178:	c3                   	ret    

00001179 <gets>:

char*
gets(char *buf, int max)
{
    1179:	55                   	push   %ebp
    117a:	89 e5                	mov    %esp,%ebp
    117c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1186:	eb 4c                	jmp    11d4 <gets+0x5b>
    cc = read(0, &c, 1);
    1188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    118f:	00 
    1190:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1193:	89 44 24 04          	mov    %eax,0x4(%esp)
    1197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    119e:	e8 44 01 00 00       	call   12e7 <read>
    11a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11aa:	7f 02                	jg     11ae <gets+0x35>
      break;
    11ac:	eb 31                	jmp    11df <gets+0x66>
    buf[i++] = c;
    11ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b1:	8d 50 01             	lea    0x1(%eax),%edx
    11b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11b7:	89 c2                	mov    %eax,%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 c2                	add    %eax,%edx
    11be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c8:	3c 0a                	cmp    $0xa,%al
    11ca:	74 13                	je     11df <gets+0x66>
    11cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d0:	3c 0d                	cmp    $0xd,%al
    11d2:	74 0b                	je     11df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d7:	83 c0 01             	add    $0x1,%eax
    11da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11dd:	7c a9                	jl     1188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11df:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e2:	8b 45 08             	mov    0x8(%ebp),%eax
    11e5:	01 d0                	add    %edx,%eax
    11e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ed:	c9                   	leave  
    11ee:	c3                   	ret    

000011ef <stat>:

int
stat(char *n, struct stat *st)
{
    11ef:	55                   	push   %ebp
    11f0:	89 e5                	mov    %esp,%ebp
    11f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11fc:	00 
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1200:	89 04 24             	mov    %eax,(%esp)
    1203:	e8 07 01 00 00       	call   130f <open>
    1208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    120f:	79 07                	jns    1218 <stat+0x29>
    return -1;
    1211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1216:	eb 23                	jmp    123b <stat+0x4c>
  r = fstat(fd, st);
    1218:	8b 45 0c             	mov    0xc(%ebp),%eax
    121b:	89 44 24 04          	mov    %eax,0x4(%esp)
    121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 fd 00 00 00       	call   1327 <fstat>
    122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1230:	89 04 24             	mov    %eax,(%esp)
    1233:	e8 bf 00 00 00       	call   12f7 <close>
  return r;
    1238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    123b:	c9                   	leave  
    123c:	c3                   	ret    

0000123d <atoi>:

int
atoi(const char *s)
{
    123d:	55                   	push   %ebp
    123e:	89 e5                	mov    %esp,%ebp
    1240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124a:	eb 25                	jmp    1271 <atoi+0x34>
    n = n*10 + *s++ - '0';
    124c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    124f:	89 d0                	mov    %edx,%eax
    1251:	c1 e0 02             	shl    $0x2,%eax
    1254:	01 d0                	add    %edx,%eax
    1256:	01 c0                	add    %eax,%eax
    1258:	89 c1                	mov    %eax,%ecx
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 08             	mov    %edx,0x8(%ebp)
    1263:	0f b6 00             	movzbl (%eax),%eax
    1266:	0f be c0             	movsbl %al,%eax
    1269:	01 c8                	add    %ecx,%eax
    126b:	83 e8 30             	sub    $0x30,%eax
    126e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1271:	8b 45 08             	mov    0x8(%ebp),%eax
    1274:	0f b6 00             	movzbl (%eax),%eax
    1277:	3c 2f                	cmp    $0x2f,%al
    1279:	7e 0a                	jle    1285 <atoi+0x48>
    127b:	8b 45 08             	mov    0x8(%ebp),%eax
    127e:	0f b6 00             	movzbl (%eax),%eax
    1281:	3c 39                	cmp    $0x39,%al
    1283:	7e c7                	jle    124c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1288:	c9                   	leave  
    1289:	c3                   	ret    

0000128a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128a:	55                   	push   %ebp
    128b:	89 e5                	mov    %esp,%ebp
    128d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1290:	8b 45 08             	mov    0x8(%ebp),%eax
    1293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1296:	8b 45 0c             	mov    0xc(%ebp),%eax
    1299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    129c:	eb 17                	jmp    12b5 <memmove+0x2b>
    *dst++ = *src++;
    129e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a1:	8d 50 01             	lea    0x1(%eax),%edx
    12a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    12ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b0:	0f b6 12             	movzbl (%edx),%edx
    12b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12b5:	8b 45 10             	mov    0x10(%ebp),%eax
    12b8:	8d 50 ff             	lea    -0x1(%eax),%edx
    12bb:	89 55 10             	mov    %edx,0x10(%ebp)
    12be:	85 c0                	test   %eax,%eax
    12c0:	7f dc                	jg     129e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c5:	c9                   	leave  
    12c6:	c3                   	ret    

000012c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c7:	b8 01 00 00 00       	mov    $0x1,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <exit>:
SYSCALL(exit)
    12cf:	b8 02 00 00 00       	mov    $0x2,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <wait>:
SYSCALL(wait)
    12d7:	b8 03 00 00 00       	mov    $0x3,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <pipe>:
SYSCALL(pipe)
    12df:	b8 04 00 00 00       	mov    $0x4,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <read>:
SYSCALL(read)
    12e7:	b8 05 00 00 00       	mov    $0x5,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <write>:
SYSCALL(write)
    12ef:	b8 10 00 00 00       	mov    $0x10,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <close>:
SYSCALL(close)
    12f7:	b8 15 00 00 00       	mov    $0x15,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <kill>:
SYSCALL(kill)
    12ff:	b8 06 00 00 00       	mov    $0x6,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <exec>:
SYSCALL(exec)
    1307:	b8 07 00 00 00       	mov    $0x7,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <open>:
SYSCALL(open)
    130f:	b8 0f 00 00 00       	mov    $0xf,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <mknod>:
SYSCALL(mknod)
    1317:	b8 11 00 00 00       	mov    $0x11,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <unlink>:
SYSCALL(unlink)
    131f:	b8 12 00 00 00       	mov    $0x12,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <fstat>:
SYSCALL(fstat)
    1327:	b8 08 00 00 00       	mov    $0x8,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <link>:
SYSCALL(link)
    132f:	b8 13 00 00 00       	mov    $0x13,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <mkdir>:
SYSCALL(mkdir)
    1337:	b8 14 00 00 00       	mov    $0x14,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <chdir>:
SYSCALL(chdir)
    133f:	b8 09 00 00 00       	mov    $0x9,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <dup>:
SYSCALL(dup)
    1347:	b8 0a 00 00 00       	mov    $0xa,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <getpid>:
SYSCALL(getpid)
    134f:	b8 0b 00 00 00       	mov    $0xb,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <sbrk>:
SYSCALL(sbrk)
    1357:	b8 0c 00 00 00       	mov    $0xc,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <sleep>:
SYSCALL(sleep)
    135f:	b8 0d 00 00 00       	mov    $0xd,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <uptime>:
SYSCALL(uptime)
    1367:	b8 0e 00 00 00       	mov    $0xe,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <clone>:
SYSCALL(clone)
    136f:	b8 16 00 00 00       	mov    $0x16,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <texit>:
SYSCALL(texit)
    1377:	b8 17 00 00 00       	mov    $0x17,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <tsleep>:
SYSCALL(tsleep)
    137f:	b8 18 00 00 00       	mov    $0x18,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <twakeup>:
SYSCALL(twakeup)
    1387:	b8 19 00 00 00       	mov    $0x19,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <thread_yield>:
SYSCALL(thread_yield)
    138f:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <thread_yield3>:
    1397:	b8 1a 00 00 00       	mov    $0x1a,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    139f:	55                   	push   %ebp
    13a0:	89 e5                	mov    %esp,%ebp
    13a2:	83 ec 18             	sub    $0x18,%esp
    13a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b2:	00 
    13b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    13ba:	8b 45 08             	mov    0x8(%ebp),%eax
    13bd:	89 04 24             	mov    %eax,(%esp)
    13c0:	e8 2a ff ff ff       	call   12ef <write>
}
    13c5:	c9                   	leave  
    13c6:	c3                   	ret    

000013c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13c7:	55                   	push   %ebp
    13c8:	89 e5                	mov    %esp,%ebp
    13ca:	56                   	push   %esi
    13cb:	53                   	push   %ebx
    13cc:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13da:	74 17                	je     13f3 <printint+0x2c>
    13dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13e0:	79 11                	jns    13f3 <printint+0x2c>
    neg = 1;
    13e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ec:	f7 d8                	neg    %eax
    13ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f1:	eb 06                	jmp    13f9 <printint+0x32>
  } else {
    x = xx;
    13f3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1400:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1403:	8d 41 01             	lea    0x1(%ecx),%eax
    1406:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1409:	8b 5d 10             	mov    0x10(%ebp),%ebx
    140c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    140f:	ba 00 00 00 00       	mov    $0x0,%edx
    1414:	f7 f3                	div    %ebx
    1416:	89 d0                	mov    %edx,%eax
    1418:	0f b6 80 b4 1f 00 00 	movzbl 0x1fb4(%eax),%eax
    141f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1423:	8b 75 10             	mov    0x10(%ebp),%esi
    1426:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1429:	ba 00 00 00 00       	mov    $0x0,%edx
    142e:	f7 f6                	div    %esi
    1430:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1437:	75 c7                	jne    1400 <printint+0x39>
  if(neg)
    1439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    143d:	74 10                	je     144f <printint+0x88>
    buf[i++] = '-';
    143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1442:	8d 50 01             	lea    0x1(%eax),%edx
    1445:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1448:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    144d:	eb 1f                	jmp    146e <printint+0xa7>
    144f:	eb 1d                	jmp    146e <printint+0xa7>
    putc(fd, buf[i]);
    1451:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1454:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1457:	01 d0                	add    %edx,%eax
    1459:	0f b6 00             	movzbl (%eax),%eax
    145c:	0f be c0             	movsbl %al,%eax
    145f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1463:	8b 45 08             	mov    0x8(%ebp),%eax
    1466:	89 04 24             	mov    %eax,(%esp)
    1469:	e8 31 ff ff ff       	call   139f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    146e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1476:	79 d9                	jns    1451 <printint+0x8a>
    putc(fd, buf[i]);
}
    1478:	83 c4 30             	add    $0x30,%esp
    147b:	5b                   	pop    %ebx
    147c:	5e                   	pop    %esi
    147d:	5d                   	pop    %ebp
    147e:	c3                   	ret    

0000147f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    147f:	55                   	push   %ebp
    1480:	89 e5                	mov    %esp,%ebp
    1482:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    148c:	8d 45 0c             	lea    0xc(%ebp),%eax
    148f:	83 c0 04             	add    $0x4,%eax
    1492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    149c:	e9 7c 01 00 00       	jmp    161d <printf+0x19e>
    c = fmt[i] & 0xff;
    14a1:	8b 55 0c             	mov    0xc(%ebp),%edx
    14a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a7:	01 d0                	add    %edx,%eax
    14a9:	0f b6 00             	movzbl (%eax),%eax
    14ac:	0f be c0             	movsbl %al,%eax
    14af:	25 ff 00 00 00       	and    $0xff,%eax
    14b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14bb:	75 2c                	jne    14e9 <printf+0x6a>
      if(c == '%'){
    14bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14c1:	75 0c                	jne    14cf <printf+0x50>
        state = '%';
    14c3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14ca:	e9 4a 01 00 00       	jmp    1619 <printf+0x19a>
      } else {
        putc(fd, c);
    14cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14d2:	0f be c0             	movsbl %al,%eax
    14d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14d9:	8b 45 08             	mov    0x8(%ebp),%eax
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 bb fe ff ff       	call   139f <putc>
    14e4:	e9 30 01 00 00       	jmp    1619 <printf+0x19a>
      }
    } else if(state == '%'){
    14e9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ed:	0f 85 26 01 00 00    	jne    1619 <printf+0x19a>
      if(c == 'd'){
    14f3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14f7:	75 2d                	jne    1526 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14fc:	8b 00                	mov    (%eax),%eax
    14fe:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1505:	00 
    1506:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    150d:	00 
    150e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1512:	8b 45 08             	mov    0x8(%ebp),%eax
    1515:	89 04 24             	mov    %eax,(%esp)
    1518:	e8 aa fe ff ff       	call   13c7 <printint>
        ap++;
    151d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1521:	e9 ec 00 00 00       	jmp    1612 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1526:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    152a:	74 06                	je     1532 <printf+0xb3>
    152c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1530:	75 2d                	jne    155f <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1532:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1535:	8b 00                	mov    (%eax),%eax
    1537:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    153e:	00 
    153f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1546:	00 
    1547:	89 44 24 04          	mov    %eax,0x4(%esp)
    154b:	8b 45 08             	mov    0x8(%ebp),%eax
    154e:	89 04 24             	mov    %eax,(%esp)
    1551:	e8 71 fe ff ff       	call   13c7 <printint>
        ap++;
    1556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    155a:	e9 b3 00 00 00       	jmp    1612 <printf+0x193>
      } else if(c == 's'){
    155f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1563:	75 45                	jne    15aa <printf+0x12b>
        s = (char*)*ap;
    1565:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1568:	8b 00                	mov    (%eax),%eax
    156a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    156d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1575:	75 09                	jne    1580 <printf+0x101>
          s = "(null)";
    1577:	c7 45 f4 bc 1b 00 00 	movl   $0x1bbc,-0xc(%ebp)
        while(*s != 0){
    157e:	eb 1e                	jmp    159e <printf+0x11f>
    1580:	eb 1c                	jmp    159e <printf+0x11f>
          putc(fd, *s);
    1582:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1585:	0f b6 00             	movzbl (%eax),%eax
    1588:	0f be c0             	movsbl %al,%eax
    158b:	89 44 24 04          	mov    %eax,0x4(%esp)
    158f:	8b 45 08             	mov    0x8(%ebp),%eax
    1592:	89 04 24             	mov    %eax,(%esp)
    1595:	e8 05 fe ff ff       	call   139f <putc>
          s++;
    159a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a1:	0f b6 00             	movzbl (%eax),%eax
    15a4:	84 c0                	test   %al,%al
    15a6:	75 da                	jne    1582 <printf+0x103>
    15a8:	eb 68                	jmp    1612 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15ae:	75 1d                	jne    15cd <printf+0x14e>
        putc(fd, *ap);
    15b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b3:	8b 00                	mov    (%eax),%eax
    15b5:	0f be c0             	movsbl %al,%eax
    15b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bc:	8b 45 08             	mov    0x8(%ebp),%eax
    15bf:	89 04 24             	mov    %eax,(%esp)
    15c2:	e8 d8 fd ff ff       	call   139f <putc>
        ap++;
    15c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15cb:	eb 45                	jmp    1612 <printf+0x193>
      } else if(c == '%'){
    15cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15d1:	75 17                	jne    15ea <printf+0x16b>
        putc(fd, c);
    15d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d6:	0f be c0             	movsbl %al,%eax
    15d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15dd:	8b 45 08             	mov    0x8(%ebp),%eax
    15e0:	89 04 24             	mov    %eax,(%esp)
    15e3:	e8 b7 fd ff ff       	call   139f <putc>
    15e8:	eb 28                	jmp    1612 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15ea:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15f1:	00 
    15f2:	8b 45 08             	mov    0x8(%ebp),%eax
    15f5:	89 04 24             	mov    %eax,(%esp)
    15f8:	e8 a2 fd ff ff       	call   139f <putc>
        putc(fd, c);
    15fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1600:	0f be c0             	movsbl %al,%eax
    1603:	89 44 24 04          	mov    %eax,0x4(%esp)
    1607:	8b 45 08             	mov    0x8(%ebp),%eax
    160a:	89 04 24             	mov    %eax,(%esp)
    160d:	e8 8d fd ff ff       	call   139f <putc>
      }
      state = 0;
    1612:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1619:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    161d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1620:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1623:	01 d0                	add    %edx,%eax
    1625:	0f b6 00             	movzbl (%eax),%eax
    1628:	84 c0                	test   %al,%al
    162a:	0f 85 71 fe ff ff    	jne    14a1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1630:	c9                   	leave  
    1631:	c3                   	ret    

00001632 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1632:	55                   	push   %ebp
    1633:	89 e5                	mov    %esp,%ebp
    1635:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1638:	8b 45 08             	mov    0x8(%ebp),%eax
    163b:	83 e8 08             	sub    $0x8,%eax
    163e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1641:	a1 d4 1f 00 00       	mov    0x1fd4,%eax
    1646:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1649:	eb 24                	jmp    166f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    164b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164e:	8b 00                	mov    (%eax),%eax
    1650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1653:	77 12                	ja     1667 <free+0x35>
    1655:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165b:	77 24                	ja     1681 <free+0x4f>
    165d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1660:	8b 00                	mov    (%eax),%eax
    1662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1665:	77 1a                	ja     1681 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1667:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166a:	8b 00                	mov    (%eax),%eax
    166c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1675:	76 d4                	jbe    164b <free+0x19>
    1677:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167a:	8b 00                	mov    (%eax),%eax
    167c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    167f:	76 ca                	jbe    164b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	8b 40 04             	mov    0x4(%eax),%eax
    1687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    168e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1691:	01 c2                	add    %eax,%edx
    1693:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1696:	8b 00                	mov    (%eax),%eax
    1698:	39 c2                	cmp    %eax,%edx
    169a:	75 24                	jne    16c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    169c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169f:	8b 50 04             	mov    0x4(%eax),%edx
    16a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a5:	8b 00                	mov    (%eax),%eax
    16a7:	8b 40 04             	mov    0x4(%eax),%eax
    16aa:	01 c2                	add    %eax,%edx
    16ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b5:	8b 00                	mov    (%eax),%eax
    16b7:	8b 10                	mov    (%eax),%edx
    16b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16bc:	89 10                	mov    %edx,(%eax)
    16be:	eb 0a                	jmp    16ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c3:	8b 10                	mov    (%eax),%edx
    16c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cd:	8b 40 04             	mov    0x4(%eax),%eax
    16d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	01 d0                	add    %edx,%eax
    16dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16df:	75 20                	jne    1701 <free+0xcf>
    p->s.size += bp->s.size;
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	8b 50 04             	mov    0x4(%eax),%edx
    16e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ea:	8b 40 04             	mov    0x4(%eax),%eax
    16ed:	01 c2                	add    %eax,%edx
    16ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f8:	8b 10                	mov    (%eax),%edx
    16fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fd:	89 10                	mov    %edx,(%eax)
    16ff:	eb 08                	jmp    1709 <free+0xd7>
  } else
    p->s.ptr = bp;
    1701:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1704:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1707:	89 10                	mov    %edx,(%eax)
  freep = p;
    1709:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170c:	a3 d4 1f 00 00       	mov    %eax,0x1fd4
}
    1711:	c9                   	leave  
    1712:	c3                   	ret    

00001713 <morecore>:

static Header*
morecore(uint nu)
{
    1713:	55                   	push   %ebp
    1714:	89 e5                	mov    %esp,%ebp
    1716:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1719:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1720:	77 07                	ja     1729 <morecore+0x16>
    nu = 4096;
    1722:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1729:	8b 45 08             	mov    0x8(%ebp),%eax
    172c:	c1 e0 03             	shl    $0x3,%eax
    172f:	89 04 24             	mov    %eax,(%esp)
    1732:	e8 20 fc ff ff       	call   1357 <sbrk>
    1737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    173a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    173e:	75 07                	jne    1747 <morecore+0x34>
    return 0;
    1740:	b8 00 00 00 00       	mov    $0x0,%eax
    1745:	eb 22                	jmp    1769 <morecore+0x56>
  hp = (Header*)p;
    1747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1750:	8b 55 08             	mov    0x8(%ebp),%edx
    1753:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1756:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1759:	83 c0 08             	add    $0x8,%eax
    175c:	89 04 24             	mov    %eax,(%esp)
    175f:	e8 ce fe ff ff       	call   1632 <free>
  return freep;
    1764:	a1 d4 1f 00 00       	mov    0x1fd4,%eax
}
    1769:	c9                   	leave  
    176a:	c3                   	ret    

0000176b <malloc>:

void*
malloc(uint nbytes)
{
    176b:	55                   	push   %ebp
    176c:	89 e5                	mov    %esp,%ebp
    176e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1771:	8b 45 08             	mov    0x8(%ebp),%eax
    1774:	83 c0 07             	add    $0x7,%eax
    1777:	c1 e8 03             	shr    $0x3,%eax
    177a:	83 c0 01             	add    $0x1,%eax
    177d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1780:	a1 d4 1f 00 00       	mov    0x1fd4,%eax
    1785:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    178c:	75 23                	jne    17b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    178e:	c7 45 f0 cc 1f 00 00 	movl   $0x1fcc,-0x10(%ebp)
    1795:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1798:	a3 d4 1f 00 00       	mov    %eax,0x1fd4
    179d:	a1 d4 1f 00 00       	mov    0x1fd4,%eax
    17a2:	a3 cc 1f 00 00       	mov    %eax,0x1fcc
    base.s.size = 0;
    17a7:	c7 05 d0 1f 00 00 00 	movl   $0x0,0x1fd0
    17ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b4:	8b 00                	mov    (%eax),%eax
    17b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 40 04             	mov    0x4(%eax),%eax
    17bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17c2:	72 4d                	jb     1811 <malloc+0xa6>
      if(p->s.size == nunits)
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	8b 40 04             	mov    0x4(%eax),%eax
    17ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17cd:	75 0c                	jne    17db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d2:	8b 10                	mov    (%eax),%edx
    17d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d7:	89 10                	mov    %edx,(%eax)
    17d9:	eb 26                	jmp    1801 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17de:	8b 40 04             	mov    0x4(%eax),%eax
    17e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17e4:	89 c2                	mov    %eax,%edx
    17e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	8b 40 04             	mov    0x4(%eax),%eax
    17f2:	c1 e0 03             	shl    $0x3,%eax
    17f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1801:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1804:	a3 d4 1f 00 00       	mov    %eax,0x1fd4
      return (void*)(p + 1);
    1809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180c:	83 c0 08             	add    $0x8,%eax
    180f:	eb 38                	jmp    1849 <malloc+0xde>
    }
    if(p == freep)
    1811:	a1 d4 1f 00 00       	mov    0x1fd4,%eax
    1816:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1819:	75 1b                	jne    1836 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    181b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    181e:	89 04 24             	mov    %eax,(%esp)
    1821:	e8 ed fe ff ff       	call   1713 <morecore>
    1826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    182d:	75 07                	jne    1836 <malloc+0xcb>
        return 0;
    182f:	b8 00 00 00 00       	mov    $0x0,%eax
    1834:	eb 13                	jmp    1849 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1839:	89 45 f0             	mov    %eax,-0x10(%ebp)
    183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183f:	8b 00                	mov    (%eax),%eax
    1841:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1844:	e9 70 ff ff ff       	jmp    17b9 <malloc+0x4e>
}
    1849:	c9                   	leave  
    184a:	c3                   	ret    

0000184b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    184b:	55                   	push   %ebp
    184c:	89 e5                	mov    %esp,%ebp
    184e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1851:	8b 55 08             	mov    0x8(%ebp),%edx
    1854:	8b 45 0c             	mov    0xc(%ebp),%eax
    1857:	8b 4d 08             	mov    0x8(%ebp),%ecx
    185a:	f0 87 02             	lock xchg %eax,(%edx)
    185d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1860:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1863:	c9                   	leave  
    1864:	c3                   	ret    

00001865 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1865:	55                   	push   %ebp
    1866:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1868:	8b 45 08             	mov    0x8(%ebp),%eax
    186b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1871:	5d                   	pop    %ebp
    1872:	c3                   	ret    

00001873 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1873:	55                   	push   %ebp
    1874:	89 e5                	mov    %esp,%ebp
    1876:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1879:	90                   	nop
    187a:	8b 45 08             	mov    0x8(%ebp),%eax
    187d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1884:	00 
    1885:	89 04 24             	mov    %eax,(%esp)
    1888:	e8 be ff ff ff       	call   184b <xchg>
    188d:	85 c0                	test   %eax,%eax
    188f:	75 e9                	jne    187a <lock_acquire+0x7>
}
    1891:	c9                   	leave  
    1892:	c3                   	ret    

00001893 <lock_release>:
void lock_release(lock_t *lock){
    1893:	55                   	push   %ebp
    1894:	89 e5                	mov    %esp,%ebp
    1896:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1899:	8b 45 08             	mov    0x8(%ebp),%eax
    189c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18a3:	00 
    18a4:	89 04 24             	mov    %eax,(%esp)
    18a7:	e8 9f ff ff ff       	call   184b <xchg>
}
    18ac:	c9                   	leave  
    18ad:	c3                   	ret    

000018ae <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    18ae:	55                   	push   %ebp
    18af:	89 e5                	mov    %esp,%ebp
    18b1:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    18b4:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    18bb:	e8 ab fe ff ff       	call   176b <malloc>
    18c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    18c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18c9:	0f b6 05 d8 1f 00 00 	movzbl 0x1fd8,%eax
    18d0:	84 c0                	test   %al,%al
    18d2:	75 1c                	jne    18f0 <thread_create+0x42>
        init_q(thQ2);
    18d4:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    18d9:	89 04 24             	mov    %eax,(%esp)
    18dc:	e8 b2 01 00 00       	call   1a93 <init_q>
        inQ++;
    18e1:	0f b6 05 d8 1f 00 00 	movzbl 0x1fd8,%eax
    18e8:	83 c0 01             	add    $0x1,%eax
    18eb:	a2 d8 1f 00 00       	mov    %al,0x1fd8
    }

    if((uint)stack % 4096){
    18f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f3:	25 ff 0f 00 00       	and    $0xfff,%eax
    18f8:	85 c0                	test   %eax,%eax
    18fa:	74 14                	je     1910 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    18fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ff:	25 ff 0f 00 00       	and    $0xfff,%eax
    1904:	89 c2                	mov    %eax,%edx
    1906:	b8 00 10 00 00       	mov    $0x1000,%eax
    190b:	29 d0                	sub    %edx,%eax
    190d:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1914:	75 1e                	jne    1934 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1916:	c7 44 24 04 c3 1b 00 	movl   $0x1bc3,0x4(%esp)
    191d:	00 
    191e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1925:	e8 55 fb ff ff       	call   147f <printf>
        return 0;
    192a:	b8 00 00 00 00       	mov    $0x0,%eax
    192f:	e9 83 00 00 00       	jmp    19b7 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1937:	8b 55 08             	mov    0x8(%ebp),%edx
    193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1941:	89 54 24 08          	mov    %edx,0x8(%esp)
    1945:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    194c:	00 
    194d:	89 04 24             	mov    %eax,(%esp)
    1950:	e8 1a fa ff ff       	call   136f <clone>
    1955:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1958:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    195c:	79 1b                	jns    1979 <thread_create+0xcb>
        printf(1,"clone fails\n");
    195e:	c7 44 24 04 d1 1b 00 	movl   $0x1bd1,0x4(%esp)
    1965:	00 
    1966:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    196d:	e8 0d fb ff ff       	call   147f <printf>
        return 0;
    1972:	b8 00 00 00 00       	mov    $0x0,%eax
    1977:	eb 3e                	jmp    19b7 <thread_create+0x109>
    }
    if(tid > 0){
    1979:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    197d:	7e 19                	jle    1998 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    197f:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    1984:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1987:	89 54 24 04          	mov    %edx,0x4(%esp)
    198b:	89 04 24             	mov    %eax,(%esp)
    198e:	e8 22 01 00 00       	call   1ab5 <add_q>
        return garbage_stack;
    1993:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1996:	eb 1f                	jmp    19b7 <thread_create+0x109>
    }
    if(tid == 0){
    1998:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    199c:	75 14                	jne    19b2 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    199e:	c7 44 24 04 de 1b 00 	movl   $0x1bde,0x4(%esp)
    19a5:	00 
    19a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19ad:	e8 cd fa ff ff       	call   147f <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19b7:	c9                   	leave  
    19b8:	c3                   	ret    

000019b9 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19b9:	55                   	push   %ebp
    19ba:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19bc:	a1 c8 1f 00 00       	mov    0x1fc8,%eax
    19c1:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    19c7:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19cc:	a3 c8 1f 00 00       	mov    %eax,0x1fc8
    return (int)(rands % max);
    19d1:	a1 c8 1f 00 00       	mov    0x1fc8,%eax
    19d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19d9:	ba 00 00 00 00       	mov    $0x0,%edx
    19de:	f7 f1                	div    %ecx
    19e0:	89 d0                	mov    %edx,%eax
}
    19e2:	5d                   	pop    %ebp
    19e3:	c3                   	ret    

000019e4 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    19e4:	55                   	push   %ebp
    19e5:	89 e5                	mov    %esp,%ebp
    19e7:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    19ea:	e8 60 f9 ff ff       	call   134f <getpid>
    19ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    19f2:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    19f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    19fa:	89 54 24 04          	mov    %edx,0x4(%esp)
    19fe:	89 04 24             	mov    %eax,(%esp)
    1a01:	e8 af 00 00 00       	call   1ab5 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a06:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    1a0b:	89 04 24             	mov    %eax,(%esp)
    1a0e:	e8 1c 01 00 00       	call   1b2f <pop_q>
    1a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a16:	a1 dc 1f 00 00       	mov    0x1fdc,%eax
    1a1b:	85 c0                	test   %eax,%eax
    1a1d:	75 1f                	jne    1a3e <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a1f:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    1a24:	89 04 24             	mov    %eax,(%esp)
    1a27:	e8 03 01 00 00       	call   1b2f <pop_q>
    1a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a2f:	a1 dc 1f 00 00       	mov    0x1fdc,%eax
    1a34:	83 c0 01             	add    $0x1,%eax
    1a37:	a3 dc 1f 00 00       	mov    %eax,0x1fdc
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a3c:	eb 12                	jmp    1a50 <thread_yield2+0x6c>
    1a3e:	eb 10                	jmp    1a50 <thread_yield2+0x6c>
    1a40:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    1a45:	89 04 24             	mov    %eax,(%esp)
    1a48:	e8 e2 00 00 00       	call   1b2f <pop_q>
    1a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a56:	74 e8                	je     1a40 <thread_yield2+0x5c>
    1a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a5c:	74 e2                	je     1a40 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a61:	89 04 24             	mov    %eax,(%esp)
    1a64:	e8 1e f9 ff ff       	call   1387 <twakeup>
    tsleep();
    1a69:	e8 11 f9 ff ff       	call   137f <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a6e:	c9                   	leave  
    1a6f:	c3                   	ret    

00001a70 <thread_yield_last>:

void thread_yield_last(){
    1a70:	55                   	push   %ebp
    1a71:	89 e5                	mov    %esp,%ebp
    1a73:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1a76:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    1a7b:	89 04 24             	mov    %eax,(%esp)
    1a7e:	e8 ac 00 00 00       	call   1b2f <pop_q>
    1a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a89:	89 04 24             	mov    %eax,(%esp)
    1a8c:	e8 f6 f8 ff ff       	call   1387 <twakeup>
    1a91:	c9                   	leave  
    1a92:	c3                   	ret    

00001a93 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1a93:	55                   	push   %ebp
    1a94:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1a96:	8b 45 08             	mov    0x8(%ebp),%eax
    1a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1a9f:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1aa9:	8b 45 08             	mov    0x8(%ebp),%eax
    1aac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ab3:	5d                   	pop    %ebp
    1ab4:	c3                   	ret    

00001ab5 <add_q>:

void add_q(struct queue *q, int v){
    1ab5:	55                   	push   %ebp
    1ab6:	89 e5                	mov    %esp,%ebp
    1ab8:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1abb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ac2:	e8 a4 fc ff ff       	call   176b <malloc>
    1ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
    1ada:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1adc:	8b 45 08             	mov    0x8(%ebp),%eax
    1adf:	8b 40 04             	mov    0x4(%eax),%eax
    1ae2:	85 c0                	test   %eax,%eax
    1ae4:	75 0b                	jne    1af1 <add_q+0x3c>
        q->head = n;
    1ae6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1aec:	89 50 04             	mov    %edx,0x4(%eax)
    1aef:	eb 0c                	jmp    1afd <add_q+0x48>
    }else{
        q->tail->next = n;
    1af1:	8b 45 08             	mov    0x8(%ebp),%eax
    1af4:	8b 40 08             	mov    0x8(%eax),%eax
    1af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1afa:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1afd:	8b 45 08             	mov    0x8(%ebp),%eax
    1b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b03:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b06:	8b 45 08             	mov    0x8(%ebp),%eax
    1b09:	8b 00                	mov    (%eax),%eax
    1b0b:	8d 50 01             	lea    0x1(%eax),%edx
    1b0e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b11:	89 10                	mov    %edx,(%eax)
}
    1b13:	c9                   	leave  
    1b14:	c3                   	ret    

00001b15 <empty_q>:

int empty_q(struct queue *q){
    1b15:	55                   	push   %ebp
    1b16:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b18:	8b 45 08             	mov    0x8(%ebp),%eax
    1b1b:	8b 00                	mov    (%eax),%eax
    1b1d:	85 c0                	test   %eax,%eax
    1b1f:	75 07                	jne    1b28 <empty_q+0x13>
        return 1;
    1b21:	b8 01 00 00 00       	mov    $0x1,%eax
    1b26:	eb 05                	jmp    1b2d <empty_q+0x18>
    else
        return 0;
    1b28:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b2d:	5d                   	pop    %ebp
    1b2e:	c3                   	ret    

00001b2f <pop_q>:
int pop_q(struct queue *q){
    1b2f:	55                   	push   %ebp
    1b30:	89 e5                	mov    %esp,%ebp
    1b32:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b35:	8b 45 08             	mov    0x8(%ebp),%eax
    1b38:	89 04 24             	mov    %eax,(%esp)
    1b3b:	e8 d5 ff ff ff       	call   1b15 <empty_q>
    1b40:	85 c0                	test   %eax,%eax
    1b42:	75 5d                	jne    1ba1 <pop_q+0x72>
       val = q->head->value; 
    1b44:	8b 45 08             	mov    0x8(%ebp),%eax
    1b47:	8b 40 04             	mov    0x4(%eax),%eax
    1b4a:	8b 00                	mov    (%eax),%eax
    1b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b4f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b52:	8b 40 04             	mov    0x4(%eax),%eax
    1b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b58:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5b:	8b 40 04             	mov    0x4(%eax),%eax
    1b5e:	8b 50 04             	mov    0x4(%eax),%edx
    1b61:	8b 45 08             	mov    0x8(%ebp),%eax
    1b64:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b6a:	89 04 24             	mov    %eax,(%esp)
    1b6d:	e8 c0 fa ff ff       	call   1632 <free>
       q->size--;
    1b72:	8b 45 08             	mov    0x8(%ebp),%eax
    1b75:	8b 00                	mov    (%eax),%eax
    1b77:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b7a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7d:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1b7f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b82:	8b 00                	mov    (%eax),%eax
    1b84:	85 c0                	test   %eax,%eax
    1b86:	75 14                	jne    1b9c <pop_q+0x6d>
            q->head = 0;
    1b88:	8b 45 08             	mov    0x8(%ebp),%eax
    1b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1b92:	8b 45 08             	mov    0x8(%ebp),%eax
    1b95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b9f:	eb 05                	jmp    1ba6 <pop_q+0x77>
    }
    return -1;
    1ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1ba6:	c9                   	leave  
    1ba7:	c3                   	ret    
