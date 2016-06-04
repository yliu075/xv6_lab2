
_mkdir:     file format elf32-i386


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

  if(argc < 2){
    1009:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
    100f:	c7 44 24 04 eb 1b 00 	movl   $0x1beb,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 84 04 00 00       	call   14a7 <printf>
    exit();
    1023:	e8 cf 02 00 00       	call   12f7 <exit>
  }

  for(i = 1; i < argc; i++){
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 4f                	jmp    1081 <main+0x81>
    if(mkdir(argv[i]) < 0){
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 13 03 00 00       	call   135f <mkdir>
    104c:	85 c0                	test   %eax,%eax
    104e:	79 2c                	jns    107c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
    1050:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    105b:	8b 45 0c             	mov    0xc(%ebp),%eax
    105e:	01 d0                	add    %edx,%eax
    1060:	8b 00                	mov    (%eax),%eax
    1062:	89 44 24 08          	mov    %eax,0x8(%esp)
    1066:	c7 44 24 04 02 1c 00 	movl   $0x1c02,0x4(%esp)
    106d:	00 
    106e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1075:	e8 2d 04 00 00       	call   14a7 <printf>
      break;
    107a:	eb 0e                	jmp    108a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    107c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1081:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1085:	3b 45 08             	cmp    0x8(%ebp),%eax
    1088:	7c a8                	jl     1032 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
    108a:	e8 68 02 00 00       	call   12f7 <exit>

0000108f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    108f:	55                   	push   %ebp
    1090:	89 e5                	mov    %esp,%ebp
    1092:	57                   	push   %edi
    1093:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1094:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1097:	8b 55 10             	mov    0x10(%ebp),%edx
    109a:	8b 45 0c             	mov    0xc(%ebp),%eax
    109d:	89 cb                	mov    %ecx,%ebx
    109f:	89 df                	mov    %ebx,%edi
    10a1:	89 d1                	mov    %edx,%ecx
    10a3:	fc                   	cld    
    10a4:	f3 aa                	rep stos %al,%es:(%edi)
    10a6:	89 ca                	mov    %ecx,%edx
    10a8:	89 fb                	mov    %edi,%ebx
    10aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10b0:	5b                   	pop    %ebx
    10b1:	5f                   	pop    %edi
    10b2:	5d                   	pop    %ebp
    10b3:	c3                   	ret    

000010b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b4:	55                   	push   %ebp
    10b5:	89 e5                	mov    %esp,%ebp
    10b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10c0:	90                   	nop
    10c1:	8b 45 08             	mov    0x8(%ebp),%eax
    10c4:	8d 50 01             	lea    0x1(%eax),%edx
    10c7:	89 55 08             	mov    %edx,0x8(%ebp)
    10ca:	8b 55 0c             	mov    0xc(%ebp),%edx
    10cd:	8d 4a 01             	lea    0x1(%edx),%ecx
    10d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10d3:	0f b6 12             	movzbl (%edx),%edx
    10d6:	88 10                	mov    %dl,(%eax)
    10d8:	0f b6 00             	movzbl (%eax),%eax
    10db:	84 c0                	test   %al,%al
    10dd:	75 e2                	jne    10c1 <strcpy+0xd>
    ;
  return os;
    10df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e2:	c9                   	leave  
    10e3:	c3                   	ret    

000010e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e7:	eb 08                	jmp    10f1 <strcmp+0xd>
    p++, q++;
    10e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10f1:	8b 45 08             	mov    0x8(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	84 c0                	test   %al,%al
    10f9:	74 10                	je     110b <strcmp+0x27>
    10fb:	8b 45 08             	mov    0x8(%ebp),%eax
    10fe:	0f b6 10             	movzbl (%eax),%edx
    1101:	8b 45 0c             	mov    0xc(%ebp),%eax
    1104:	0f b6 00             	movzbl (%eax),%eax
    1107:	38 c2                	cmp    %al,%dl
    1109:	74 de                	je     10e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	0f b6 00             	movzbl (%eax),%eax
    1111:	0f b6 d0             	movzbl %al,%edx
    1114:	8b 45 0c             	mov    0xc(%ebp),%eax
    1117:	0f b6 00             	movzbl (%eax),%eax
    111a:	0f b6 c0             	movzbl %al,%eax
    111d:	29 c2                	sub    %eax,%edx
    111f:	89 d0                	mov    %edx,%eax
}
    1121:	5d                   	pop    %ebp
    1122:	c3                   	ret    

00001123 <strlen>:

uint
strlen(char *s)
{
    1123:	55                   	push   %ebp
    1124:	89 e5                	mov    %esp,%ebp
    1126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1130:	eb 04                	jmp    1136 <strlen+0x13>
    1132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1136:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1139:	8b 45 08             	mov    0x8(%ebp),%eax
    113c:	01 d0                	add    %edx,%eax
    113e:	0f b6 00             	movzbl (%eax),%eax
    1141:	84 c0                	test   %al,%al
    1143:	75 ed                	jne    1132 <strlen+0xf>
    ;
  return n;
    1145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1148:	c9                   	leave  
    1149:	c3                   	ret    

0000114a <memset>:

void*
memset(void *dst, int c, uint n)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1150:	8b 45 10             	mov    0x10(%ebp),%eax
    1153:	89 44 24 08          	mov    %eax,0x8(%esp)
    1157:	8b 45 0c             	mov    0xc(%ebp),%eax
    115a:	89 44 24 04          	mov    %eax,0x4(%esp)
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	89 04 24             	mov    %eax,(%esp)
    1164:	e8 26 ff ff ff       	call   108f <stosb>
  return dst;
    1169:	8b 45 08             	mov    0x8(%ebp),%eax
}
    116c:	c9                   	leave  
    116d:	c3                   	ret    

0000116e <strchr>:

char*
strchr(const char *s, char c)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 04             	sub    $0x4,%esp
    1174:	8b 45 0c             	mov    0xc(%ebp),%eax
    1177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    117a:	eb 14                	jmp    1190 <strchr+0x22>
    if(*s == c)
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	0f b6 00             	movzbl (%eax),%eax
    1182:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1185:	75 05                	jne    118c <strchr+0x1e>
      return (char*)s;
    1187:	8b 45 08             	mov    0x8(%ebp),%eax
    118a:	eb 13                	jmp    119f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    118c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	0f b6 00             	movzbl (%eax),%eax
    1196:	84 c0                	test   %al,%al
    1198:	75 e2                	jne    117c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <gets>:

char*
gets(char *buf, int max)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
    11a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ae:	eb 4c                	jmp    11fc <gets+0x5b>
    cc = read(0, &c, 1);
    11b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11b7:	00 
    11b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11bb:	89 44 24 04          	mov    %eax,0x4(%esp)
    11bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c6:	e8 44 01 00 00       	call   130f <read>
    11cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11d2:	7f 02                	jg     11d6 <gets+0x35>
      break;
    11d4:	eb 31                	jmp    1207 <gets+0x66>
    buf[i++] = c;
    11d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d9:	8d 50 01             	lea    0x1(%eax),%edx
    11dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11df:	89 c2                	mov    %eax,%edx
    11e1:	8b 45 08             	mov    0x8(%ebp),%eax
    11e4:	01 c2                	add    %eax,%edx
    11e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f0:	3c 0a                	cmp    $0xa,%al
    11f2:	74 13                	je     1207 <gets+0x66>
    11f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f8:	3c 0d                	cmp    $0xd,%al
    11fa:	74 0b                	je     1207 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	83 c0 01             	add    $0x1,%eax
    1202:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1205:	7c a9                	jl     11b0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1207:	8b 55 f4             	mov    -0xc(%ebp),%edx
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	01 d0                	add    %edx,%eax
    120f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1215:	c9                   	leave  
    1216:	c3                   	ret    

00001217 <stat>:

int
stat(char *n, struct stat *st)
{
    1217:	55                   	push   %ebp
    1218:	89 e5                	mov    %esp,%ebp
    121a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    121d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1224:	00 
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
    1228:	89 04 24             	mov    %eax,(%esp)
    122b:	e8 07 01 00 00       	call   1337 <open>
    1230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1237:	79 07                	jns    1240 <stat+0x29>
    return -1;
    1239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    123e:	eb 23                	jmp    1263 <stat+0x4c>
  r = fstat(fd, st);
    1240:	8b 45 0c             	mov    0xc(%ebp),%eax
    1243:	89 44 24 04          	mov    %eax,0x4(%esp)
    1247:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124a:	89 04 24             	mov    %eax,(%esp)
    124d:	e8 fd 00 00 00       	call   134f <fstat>
    1252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1255:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 bf 00 00 00       	call   131f <close>
  return r;
    1260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1263:	c9                   	leave  
    1264:	c3                   	ret    

00001265 <atoi>:

int
atoi(const char *s)
{
    1265:	55                   	push   %ebp
    1266:	89 e5                	mov    %esp,%ebp
    1268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1272:	eb 25                	jmp    1299 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1274:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1277:	89 d0                	mov    %edx,%eax
    1279:	c1 e0 02             	shl    $0x2,%eax
    127c:	01 d0                	add    %edx,%eax
    127e:	01 c0                	add    %eax,%eax
    1280:	89 c1                	mov    %eax,%ecx
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
    1285:	8d 50 01             	lea    0x1(%eax),%edx
    1288:	89 55 08             	mov    %edx,0x8(%ebp)
    128b:	0f b6 00             	movzbl (%eax),%eax
    128e:	0f be c0             	movsbl %al,%eax
    1291:	01 c8                	add    %ecx,%eax
    1293:	83 e8 30             	sub    $0x30,%eax
    1296:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1299:	8b 45 08             	mov    0x8(%ebp),%eax
    129c:	0f b6 00             	movzbl (%eax),%eax
    129f:	3c 2f                	cmp    $0x2f,%al
    12a1:	7e 0a                	jle    12ad <atoi+0x48>
    12a3:	8b 45 08             	mov    0x8(%ebp),%eax
    12a6:	0f b6 00             	movzbl (%eax),%eax
    12a9:	3c 39                	cmp    $0x39,%al
    12ab:	7e c7                	jle    1274 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12b0:	c9                   	leave  
    12b1:	c3                   	ret    

000012b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12b2:	55                   	push   %ebp
    12b3:	89 e5                	mov    %esp,%ebp
    12b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12b8:	8b 45 08             	mov    0x8(%ebp),%eax
    12bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12c4:	eb 17                	jmp    12dd <memmove+0x2b>
    *dst++ = *src++;
    12c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c9:	8d 50 01             	lea    0x1(%eax),%edx
    12cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12d2:	8d 4a 01             	lea    0x1(%edx),%ecx
    12d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12d8:	0f b6 12             	movzbl (%edx),%edx
    12db:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12dd:	8b 45 10             	mov    0x10(%ebp),%eax
    12e0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12e3:	89 55 10             	mov    %edx,0x10(%ebp)
    12e6:	85 c0                	test   %eax,%eax
    12e8:	7f dc                	jg     12c6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ed:	c9                   	leave  
    12ee:	c3                   	ret    

000012ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ef:	b8 01 00 00 00       	mov    $0x1,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <exit>:
SYSCALL(exit)
    12f7:	b8 02 00 00 00       	mov    $0x2,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <wait>:
SYSCALL(wait)
    12ff:	b8 03 00 00 00       	mov    $0x3,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <pipe>:
SYSCALL(pipe)
    1307:	b8 04 00 00 00       	mov    $0x4,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <read>:
SYSCALL(read)
    130f:	b8 05 00 00 00       	mov    $0x5,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <write>:
SYSCALL(write)
    1317:	b8 10 00 00 00       	mov    $0x10,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <close>:
SYSCALL(close)
    131f:	b8 15 00 00 00       	mov    $0x15,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <kill>:
SYSCALL(kill)
    1327:	b8 06 00 00 00       	mov    $0x6,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <exec>:
SYSCALL(exec)
    132f:	b8 07 00 00 00       	mov    $0x7,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <open>:
SYSCALL(open)
    1337:	b8 0f 00 00 00       	mov    $0xf,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <mknod>:
SYSCALL(mknod)
    133f:	b8 11 00 00 00       	mov    $0x11,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <unlink>:
SYSCALL(unlink)
    1347:	b8 12 00 00 00       	mov    $0x12,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <fstat>:
SYSCALL(fstat)
    134f:	b8 08 00 00 00       	mov    $0x8,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <link>:
SYSCALL(link)
    1357:	b8 13 00 00 00       	mov    $0x13,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <mkdir>:
SYSCALL(mkdir)
    135f:	b8 14 00 00 00       	mov    $0x14,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <chdir>:
SYSCALL(chdir)
    1367:	b8 09 00 00 00       	mov    $0x9,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <dup>:
SYSCALL(dup)
    136f:	b8 0a 00 00 00       	mov    $0xa,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <getpid>:
SYSCALL(getpid)
    1377:	b8 0b 00 00 00       	mov    $0xb,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <sbrk>:
SYSCALL(sbrk)
    137f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <sleep>:
SYSCALL(sleep)
    1387:	b8 0d 00 00 00       	mov    $0xd,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <uptime>:
SYSCALL(uptime)
    138f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <clone>:
SYSCALL(clone)
    1397:	b8 16 00 00 00       	mov    $0x16,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <texit>:
SYSCALL(texit)
    139f:	b8 17 00 00 00       	mov    $0x17,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <tsleep>:
SYSCALL(tsleep)
    13a7:	b8 18 00 00 00       	mov    $0x18,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <twakeup>:
SYSCALL(twakeup)
    13af:	b8 19 00 00 00       	mov    $0x19,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <thread_yield>:
SYSCALL(thread_yield)
    13b7:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <thread_yield3>:
    13bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13c7:	55                   	push   %ebp
    13c8:	89 e5                	mov    %esp,%ebp
    13ca:	83 ec 18             	sub    $0x18,%esp
    13cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13d3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13da:	00 
    13db:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13de:	89 44 24 04          	mov    %eax,0x4(%esp)
    13e2:	8b 45 08             	mov    0x8(%ebp),%eax
    13e5:	89 04 24             	mov    %eax,(%esp)
    13e8:	e8 2a ff ff ff       	call   1317 <write>
}
    13ed:	c9                   	leave  
    13ee:	c3                   	ret    

000013ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13ef:	55                   	push   %ebp
    13f0:	89 e5                	mov    %esp,%ebp
    13f2:	56                   	push   %esi
    13f3:	53                   	push   %ebx
    13f4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1402:	74 17                	je     141b <printint+0x2c>
    1404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1408:	79 11                	jns    141b <printint+0x2c>
    neg = 1;
    140a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1411:	8b 45 0c             	mov    0xc(%ebp),%eax
    1414:	f7 d8                	neg    %eax
    1416:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1419:	eb 06                	jmp    1421 <printint+0x32>
  } else {
    x = xx;
    141b:	8b 45 0c             	mov    0xc(%ebp),%eax
    141e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1421:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1428:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    142b:	8d 41 01             	lea    0x1(%ecx),%eax
    142e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1431:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1434:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1437:	ba 00 00 00 00       	mov    $0x0,%edx
    143c:	f7 f3                	div    %ebx
    143e:	89 d0                	mov    %edx,%eax
    1440:	0f b6 80 30 20 00 00 	movzbl 0x2030(%eax),%eax
    1447:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    144b:	8b 75 10             	mov    0x10(%ebp),%esi
    144e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1451:	ba 00 00 00 00       	mov    $0x0,%edx
    1456:	f7 f6                	div    %esi
    1458:	89 45 ec             	mov    %eax,-0x14(%ebp)
    145b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    145f:	75 c7                	jne    1428 <printint+0x39>
  if(neg)
    1461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1465:	74 10                	je     1477 <printint+0x88>
    buf[i++] = '-';
    1467:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146a:	8d 50 01             	lea    0x1(%eax),%edx
    146d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1470:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1475:	eb 1f                	jmp    1496 <printint+0xa7>
    1477:	eb 1d                	jmp    1496 <printint+0xa7>
    putc(fd, buf[i]);
    1479:	8d 55 dc             	lea    -0x24(%ebp),%edx
    147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147f:	01 d0                	add    %edx,%eax
    1481:	0f b6 00             	movzbl (%eax),%eax
    1484:	0f be c0             	movsbl %al,%eax
    1487:	89 44 24 04          	mov    %eax,0x4(%esp)
    148b:	8b 45 08             	mov    0x8(%ebp),%eax
    148e:	89 04 24             	mov    %eax,(%esp)
    1491:	e8 31 ff ff ff       	call   13c7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1496:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    149a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    149e:	79 d9                	jns    1479 <printint+0x8a>
    putc(fd, buf[i]);
}
    14a0:	83 c4 30             	add    $0x30,%esp
    14a3:	5b                   	pop    %ebx
    14a4:	5e                   	pop    %esi
    14a5:	5d                   	pop    %ebp
    14a6:	c3                   	ret    

000014a7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14a7:	55                   	push   %ebp
    14a8:	89 e5                	mov    %esp,%ebp
    14aa:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14b4:	8d 45 0c             	lea    0xc(%ebp),%eax
    14b7:	83 c0 04             	add    $0x4,%eax
    14ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14c4:	e9 7c 01 00 00       	jmp    1645 <printf+0x19e>
    c = fmt[i] & 0xff;
    14c9:	8b 55 0c             	mov    0xc(%ebp),%edx
    14cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14cf:	01 d0                	add    %edx,%eax
    14d1:	0f b6 00             	movzbl (%eax),%eax
    14d4:	0f be c0             	movsbl %al,%eax
    14d7:	25 ff 00 00 00       	and    $0xff,%eax
    14dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14e3:	75 2c                	jne    1511 <printf+0x6a>
      if(c == '%'){
    14e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14e9:	75 0c                	jne    14f7 <printf+0x50>
        state = '%';
    14eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14f2:	e9 4a 01 00 00       	jmp    1641 <printf+0x19a>
      } else {
        putc(fd, c);
    14f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14fa:	0f be c0             	movsbl %al,%eax
    14fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1501:	8b 45 08             	mov    0x8(%ebp),%eax
    1504:	89 04 24             	mov    %eax,(%esp)
    1507:	e8 bb fe ff ff       	call   13c7 <putc>
    150c:	e9 30 01 00 00       	jmp    1641 <printf+0x19a>
      }
    } else if(state == '%'){
    1511:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1515:	0f 85 26 01 00 00    	jne    1641 <printf+0x19a>
      if(c == 'd'){
    151b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    151f:	75 2d                	jne    154e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1521:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1524:	8b 00                	mov    (%eax),%eax
    1526:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    152d:	00 
    152e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1535:	00 
    1536:	89 44 24 04          	mov    %eax,0x4(%esp)
    153a:	8b 45 08             	mov    0x8(%ebp),%eax
    153d:	89 04 24             	mov    %eax,(%esp)
    1540:	e8 aa fe ff ff       	call   13ef <printint>
        ap++;
    1545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1549:	e9 ec 00 00 00       	jmp    163a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    154e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1552:	74 06                	je     155a <printf+0xb3>
    1554:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1558:	75 2d                	jne    1587 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    155a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    155d:	8b 00                	mov    (%eax),%eax
    155f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1566:	00 
    1567:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    156e:	00 
    156f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1573:	8b 45 08             	mov    0x8(%ebp),%eax
    1576:	89 04 24             	mov    %eax,(%esp)
    1579:	e8 71 fe ff ff       	call   13ef <printint>
        ap++;
    157e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1582:	e9 b3 00 00 00       	jmp    163a <printf+0x193>
      } else if(c == 's'){
    1587:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    158b:	75 45                	jne    15d2 <printf+0x12b>
        s = (char*)*ap;
    158d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1590:	8b 00                	mov    (%eax),%eax
    1592:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    159d:	75 09                	jne    15a8 <printf+0x101>
          s = "(null)";
    159f:	c7 45 f4 1e 1c 00 00 	movl   $0x1c1e,-0xc(%ebp)
        while(*s != 0){
    15a6:	eb 1e                	jmp    15c6 <printf+0x11f>
    15a8:	eb 1c                	jmp    15c6 <printf+0x11f>
          putc(fd, *s);
    15aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ad:	0f b6 00             	movzbl (%eax),%eax
    15b0:	0f be c0             	movsbl %al,%eax
    15b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ba:	89 04 24             	mov    %eax,(%esp)
    15bd:	e8 05 fe ff ff       	call   13c7 <putc>
          s++;
    15c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c9:	0f b6 00             	movzbl (%eax),%eax
    15cc:	84 c0                	test   %al,%al
    15ce:	75 da                	jne    15aa <printf+0x103>
    15d0:	eb 68                	jmp    163a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15d2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15d6:	75 1d                	jne    15f5 <printf+0x14e>
        putc(fd, *ap);
    15d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15db:	8b 00                	mov    (%eax),%eax
    15dd:	0f be c0             	movsbl %al,%eax
    15e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e4:	8b 45 08             	mov    0x8(%ebp),%eax
    15e7:	89 04 24             	mov    %eax,(%esp)
    15ea:	e8 d8 fd ff ff       	call   13c7 <putc>
        ap++;
    15ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15f3:	eb 45                	jmp    163a <printf+0x193>
      } else if(c == '%'){
    15f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15f9:	75 17                	jne    1612 <printf+0x16b>
        putc(fd, c);
    15fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15fe:	0f be c0             	movsbl %al,%eax
    1601:	89 44 24 04          	mov    %eax,0x4(%esp)
    1605:	8b 45 08             	mov    0x8(%ebp),%eax
    1608:	89 04 24             	mov    %eax,(%esp)
    160b:	e8 b7 fd ff ff       	call   13c7 <putc>
    1610:	eb 28                	jmp    163a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1612:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1619:	00 
    161a:	8b 45 08             	mov    0x8(%ebp),%eax
    161d:	89 04 24             	mov    %eax,(%esp)
    1620:	e8 a2 fd ff ff       	call   13c7 <putc>
        putc(fd, c);
    1625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1628:	0f be c0             	movsbl %al,%eax
    162b:	89 44 24 04          	mov    %eax,0x4(%esp)
    162f:	8b 45 08             	mov    0x8(%ebp),%eax
    1632:	89 04 24             	mov    %eax,(%esp)
    1635:	e8 8d fd ff ff       	call   13c7 <putc>
      }
      state = 0;
    163a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1641:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1645:	8b 55 0c             	mov    0xc(%ebp),%edx
    1648:	8b 45 f0             	mov    -0x10(%ebp),%eax
    164b:	01 d0                	add    %edx,%eax
    164d:	0f b6 00             	movzbl (%eax),%eax
    1650:	84 c0                	test   %al,%al
    1652:	0f 85 71 fe ff ff    	jne    14c9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1658:	c9                   	leave  
    1659:	c3                   	ret    

0000165a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    165a:	55                   	push   %ebp
    165b:	89 e5                	mov    %esp,%ebp
    165d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1660:	8b 45 08             	mov    0x8(%ebp),%eax
    1663:	83 e8 08             	sub    $0x8,%eax
    1666:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1669:	a1 50 20 00 00       	mov    0x2050,%eax
    166e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1671:	eb 24                	jmp    1697 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1673:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1676:	8b 00                	mov    (%eax),%eax
    1678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    167b:	77 12                	ja     168f <free+0x35>
    167d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1683:	77 24                	ja     16a9 <free+0x4f>
    1685:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1688:	8b 00                	mov    (%eax),%eax
    168a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    168d:	77 1a                	ja     16a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1692:	8b 00                	mov    (%eax),%eax
    1694:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1697:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    169d:	76 d4                	jbe    1673 <free+0x19>
    169f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a2:	8b 00                	mov    (%eax),%eax
    16a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16a7:	76 ca                	jbe    1673 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ac:	8b 40 04             	mov    0x4(%eax),%eax
    16af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b9:	01 c2                	add    %eax,%edx
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	8b 00                	mov    (%eax),%eax
    16c0:	39 c2                	cmp    %eax,%edx
    16c2:	75 24                	jne    16e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c7:	8b 50 04             	mov    0x4(%eax),%edx
    16ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cd:	8b 00                	mov    (%eax),%eax
    16cf:	8b 40 04             	mov    0x4(%eax),%eax
    16d2:	01 c2                	add    %eax,%edx
    16d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16dd:	8b 00                	mov    (%eax),%eax
    16df:	8b 10                	mov    (%eax),%edx
    16e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e4:	89 10                	mov    %edx,(%eax)
    16e6:	eb 0a                	jmp    16f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16eb:	8b 10                	mov    (%eax),%edx
    16ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f5:	8b 40 04             	mov    0x4(%eax),%eax
    16f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1702:	01 d0                	add    %edx,%eax
    1704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1707:	75 20                	jne    1729 <free+0xcf>
    p->s.size += bp->s.size;
    1709:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170c:	8b 50 04             	mov    0x4(%eax),%edx
    170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1712:	8b 40 04             	mov    0x4(%eax),%eax
    1715:	01 c2                	add    %eax,%edx
    1717:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    171d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1720:	8b 10                	mov    (%eax),%edx
    1722:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1725:	89 10                	mov    %edx,(%eax)
    1727:	eb 08                	jmp    1731 <free+0xd7>
  } else
    p->s.ptr = bp;
    1729:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    172f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1731:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1734:	a3 50 20 00 00       	mov    %eax,0x2050
}
    1739:	c9                   	leave  
    173a:	c3                   	ret    

0000173b <morecore>:

static Header*
morecore(uint nu)
{
    173b:	55                   	push   %ebp
    173c:	89 e5                	mov    %esp,%ebp
    173e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1741:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1748:	77 07                	ja     1751 <morecore+0x16>
    nu = 4096;
    174a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1751:	8b 45 08             	mov    0x8(%ebp),%eax
    1754:	c1 e0 03             	shl    $0x3,%eax
    1757:	89 04 24             	mov    %eax,(%esp)
    175a:	e8 20 fc ff ff       	call   137f <sbrk>
    175f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1762:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1766:	75 07                	jne    176f <morecore+0x34>
    return 0;
    1768:	b8 00 00 00 00       	mov    $0x0,%eax
    176d:	eb 22                	jmp    1791 <morecore+0x56>
  hp = (Header*)p;
    176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1775:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1778:	8b 55 08             	mov    0x8(%ebp),%edx
    177b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1781:	83 c0 08             	add    $0x8,%eax
    1784:	89 04 24             	mov    %eax,(%esp)
    1787:	e8 ce fe ff ff       	call   165a <free>
  return freep;
    178c:	a1 50 20 00 00       	mov    0x2050,%eax
}
    1791:	c9                   	leave  
    1792:	c3                   	ret    

00001793 <malloc>:

void*
malloc(uint nbytes)
{
    1793:	55                   	push   %ebp
    1794:	89 e5                	mov    %esp,%ebp
    1796:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1799:	8b 45 08             	mov    0x8(%ebp),%eax
    179c:	83 c0 07             	add    $0x7,%eax
    179f:	c1 e8 03             	shr    $0x3,%eax
    17a2:	83 c0 01             	add    $0x1,%eax
    17a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17a8:	a1 50 20 00 00       	mov    0x2050,%eax
    17ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17b4:	75 23                	jne    17d9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17b6:	c7 45 f0 48 20 00 00 	movl   $0x2048,-0x10(%ebp)
    17bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c0:	a3 50 20 00 00       	mov    %eax,0x2050
    17c5:	a1 50 20 00 00       	mov    0x2050,%eax
    17ca:	a3 48 20 00 00       	mov    %eax,0x2048
    base.s.size = 0;
    17cf:	c7 05 4c 20 00 00 00 	movl   $0x0,0x204c
    17d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17dc:	8b 00                	mov    (%eax),%eax
    17de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e4:	8b 40 04             	mov    0x4(%eax),%eax
    17e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ea:	72 4d                	jb     1839 <malloc+0xa6>
      if(p->s.size == nunits)
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	8b 40 04             	mov    0x4(%eax),%eax
    17f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17f5:	75 0c                	jne    1803 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fa:	8b 10                	mov    (%eax),%edx
    17fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ff:	89 10                	mov    %edx,(%eax)
    1801:	eb 26                	jmp    1829 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1803:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1806:	8b 40 04             	mov    0x4(%eax),%eax
    1809:	2b 45 ec             	sub    -0x14(%ebp),%eax
    180c:	89 c2                	mov    %eax,%edx
    180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1811:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1814:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1817:	8b 40 04             	mov    0x4(%eax),%eax
    181a:	c1 e0 03             	shl    $0x3,%eax
    181d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1823:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1826:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1829:	8b 45 f0             	mov    -0x10(%ebp),%eax
    182c:	a3 50 20 00 00       	mov    %eax,0x2050
      return (void*)(p + 1);
    1831:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1834:	83 c0 08             	add    $0x8,%eax
    1837:	eb 38                	jmp    1871 <malloc+0xde>
    }
    if(p == freep)
    1839:	a1 50 20 00 00       	mov    0x2050,%eax
    183e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1841:	75 1b                	jne    185e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1843:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1846:	89 04 24             	mov    %eax,(%esp)
    1849:	e8 ed fe ff ff       	call   173b <morecore>
    184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1855:	75 07                	jne    185e <malloc+0xcb>
        return 0;
    1857:	b8 00 00 00 00       	mov    $0x0,%eax
    185c:	eb 13                	jmp    1871 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1861:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1864:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1867:	8b 00                	mov    (%eax),%eax
    1869:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    186c:	e9 70 ff ff ff       	jmp    17e1 <malloc+0x4e>
}
    1871:	c9                   	leave  
    1872:	c3                   	ret    

00001873 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1873:	55                   	push   %ebp
    1874:	89 e5                	mov    %esp,%ebp
    1876:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1879:	8b 55 08             	mov    0x8(%ebp),%edx
    187c:	8b 45 0c             	mov    0xc(%ebp),%eax
    187f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1882:	f0 87 02             	lock xchg %eax,(%edx)
    1885:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1888:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    188b:	c9                   	leave  
    188c:	c3                   	ret    

0000188d <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    188d:	55                   	push   %ebp
    188e:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1890:	8b 45 08             	mov    0x8(%ebp),%eax
    1893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1899:	5d                   	pop    %ebp
    189a:	c3                   	ret    

0000189b <lock_acquire>:
void lock_acquire(lock_t *lock){
    189b:	55                   	push   %ebp
    189c:	89 e5                	mov    %esp,%ebp
    189e:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    18a1:	90                   	nop
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18ac:	00 
    18ad:	89 04 24             	mov    %eax,(%esp)
    18b0:	e8 be ff ff ff       	call   1873 <xchg>
    18b5:	85 c0                	test   %eax,%eax
    18b7:	75 e9                	jne    18a2 <lock_acquire+0x7>
}
    18b9:	c9                   	leave  
    18ba:	c3                   	ret    

000018bb <lock_release>:
void lock_release(lock_t *lock){
    18bb:	55                   	push   %ebp
    18bc:	89 e5                	mov    %esp,%ebp
    18be:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    18c1:	8b 45 08             	mov    0x8(%ebp),%eax
    18c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18cb:	00 
    18cc:	89 04 24             	mov    %eax,(%esp)
    18cf:	e8 9f ff ff ff       	call   1873 <xchg>
}
    18d4:	c9                   	leave  
    18d5:	c3                   	ret    

000018d6 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    18d6:	55                   	push   %ebp
    18d7:	89 e5                	mov    %esp,%ebp
    18d9:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    18dc:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    18e3:	e8 ab fe ff ff       	call   1793 <malloc>
    18e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    18eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18f1:	0f b6 05 54 20 00 00 	movzbl 0x2054,%eax
    18f8:	84 c0                	test   %al,%al
    18fa:	75 1c                	jne    1918 <thread_create+0x42>
        init_q(thQ2);
    18fc:	a1 5c 20 00 00       	mov    0x205c,%eax
    1901:	89 04 24             	mov    %eax,(%esp)
    1904:	e8 cd 01 00 00       	call   1ad6 <init_q>
        inQ++;
    1909:	0f b6 05 54 20 00 00 	movzbl 0x2054,%eax
    1910:	83 c0 01             	add    $0x1,%eax
    1913:	a2 54 20 00 00       	mov    %al,0x2054
    }

    if((uint)stack % 4096){
    1918:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191b:	25 ff 0f 00 00       	and    $0xfff,%eax
    1920:	85 c0                	test   %eax,%eax
    1922:	74 14                	je     1938 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1924:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1927:	25 ff 0f 00 00       	and    $0xfff,%eax
    192c:	89 c2                	mov    %eax,%edx
    192e:	b8 00 10 00 00       	mov    $0x1000,%eax
    1933:	29 d0                	sub    %edx,%eax
    1935:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    193c:	75 1e                	jne    195c <thread_create+0x86>

        printf(1,"malloc fail \n");
    193e:	c7 44 24 04 25 1c 00 	movl   $0x1c25,0x4(%esp)
    1945:	00 
    1946:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    194d:	e8 55 fb ff ff       	call   14a7 <printf>
        return 0;
    1952:	b8 00 00 00 00       	mov    $0x0,%eax
    1957:	e9 9e 00 00 00       	jmp    19fa <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    195c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    195f:	8b 55 08             	mov    0x8(%ebp),%edx
    1962:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1969:	89 54 24 08          	mov    %edx,0x8(%esp)
    196d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1974:	00 
    1975:	89 04 24             	mov    %eax,(%esp)
    1978:	e8 1a fa ff ff       	call   1397 <clone>
    197d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1980:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1983:	89 44 24 08          	mov    %eax,0x8(%esp)
    1987:	c7 44 24 04 33 1c 00 	movl   $0x1c33,0x4(%esp)
    198e:	00 
    198f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1996:	e8 0c fb ff ff       	call   14a7 <printf>
    if(tid < 0){
    199b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    199f:	79 1b                	jns    19bc <thread_create+0xe6>
        printf(1,"clone fails\n");
    19a1:	c7 44 24 04 4c 1c 00 	movl   $0x1c4c,0x4(%esp)
    19a8:	00 
    19a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19b0:	e8 f2 fa ff ff       	call   14a7 <printf>
        return 0;
    19b5:	b8 00 00 00 00       	mov    $0x0,%eax
    19ba:	eb 3e                	jmp    19fa <thread_create+0x124>
    }
    if(tid > 0){
    19bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19c0:	7e 19                	jle    19db <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    19c2:	a1 5c 20 00 00       	mov    0x205c,%eax
    19c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19ca:	89 54 24 04          	mov    %edx,0x4(%esp)
    19ce:	89 04 24             	mov    %eax,(%esp)
    19d1:	e8 22 01 00 00       	call   1af8 <add_q>
        return garbage_stack;
    19d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19d9:	eb 1f                	jmp    19fa <thread_create+0x124>
    }
    if(tid == 0){
    19db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19df:	75 14                	jne    19f5 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    19e1:	c7 44 24 04 59 1c 00 	movl   $0x1c59,0x4(%esp)
    19e8:	00 
    19e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19f0:	e8 b2 fa ff ff       	call   14a7 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19fa:	c9                   	leave  
    19fb:	c3                   	ret    

000019fc <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19fc:	55                   	push   %ebp
    19fd:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19ff:	a1 44 20 00 00       	mov    0x2044,%eax
    1a04:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a0a:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a0f:	a3 44 20 00 00       	mov    %eax,0x2044
    return (int)(rands % max);
    1a14:	a1 44 20 00 00       	mov    0x2044,%eax
    1a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a1c:	ba 00 00 00 00       	mov    $0x0,%edx
    1a21:	f7 f1                	div    %ecx
    1a23:	89 d0                	mov    %edx,%eax
}
    1a25:	5d                   	pop    %ebp
    1a26:	c3                   	ret    

00001a27 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a27:	55                   	push   %ebp
    1a28:	89 e5                	mov    %esp,%ebp
    1a2a:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a2d:	e8 45 f9 ff ff       	call   1377 <getpid>
    1a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a35:	a1 5c 20 00 00       	mov    0x205c,%eax
    1a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a41:	89 04 24             	mov    %eax,(%esp)
    1a44:	e8 af 00 00 00       	call   1af8 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a49:	a1 5c 20 00 00       	mov    0x205c,%eax
    1a4e:	89 04 24             	mov    %eax,(%esp)
    1a51:	e8 1c 01 00 00       	call   1b72 <pop_q>
    1a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a59:	a1 58 20 00 00       	mov    0x2058,%eax
    1a5e:	85 c0                	test   %eax,%eax
    1a60:	75 1f                	jne    1a81 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a62:	a1 5c 20 00 00       	mov    0x205c,%eax
    1a67:	89 04 24             	mov    %eax,(%esp)
    1a6a:	e8 03 01 00 00       	call   1b72 <pop_q>
    1a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a72:	a1 58 20 00 00       	mov    0x2058,%eax
    1a77:	83 c0 01             	add    $0x1,%eax
    1a7a:	a3 58 20 00 00       	mov    %eax,0x2058
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a7f:	eb 12                	jmp    1a93 <thread_yield2+0x6c>
    1a81:	eb 10                	jmp    1a93 <thread_yield2+0x6c>
    1a83:	a1 5c 20 00 00       	mov    0x205c,%eax
    1a88:	89 04 24             	mov    %eax,(%esp)
    1a8b:	e8 e2 00 00 00       	call   1b72 <pop_q>
    1a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a99:	74 e8                	je     1a83 <thread_yield2+0x5c>
    1a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a9f:	74 e2                	je     1a83 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa4:	89 04 24             	mov    %eax,(%esp)
    1aa7:	e8 03 f9 ff ff       	call   13af <twakeup>
    tsleep();
    1aac:	e8 f6 f8 ff ff       	call   13a7 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1ab1:	c9                   	leave  
    1ab2:	c3                   	ret    

00001ab3 <thread_yield_last>:

void thread_yield_last(){
    1ab3:	55                   	push   %ebp
    1ab4:	89 e5                	mov    %esp,%ebp
    1ab6:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1ab9:	a1 5c 20 00 00       	mov    0x205c,%eax
    1abe:	89 04 24             	mov    %eax,(%esp)
    1ac1:	e8 ac 00 00 00       	call   1b72 <pop_q>
    1ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acc:	89 04 24             	mov    %eax,(%esp)
    1acf:	e8 db f8 ff ff       	call   13af <twakeup>
    1ad4:	c9                   	leave  
    1ad5:	c3                   	ret    

00001ad6 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ad6:	55                   	push   %ebp
    1ad7:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ad9:	8b 45 08             	mov    0x8(%ebp),%eax
    1adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1ae2:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1aec:	8b 45 08             	mov    0x8(%ebp),%eax
    1aef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1af6:	5d                   	pop    %ebp
    1af7:	c3                   	ret    

00001af8 <add_q>:

void add_q(struct queue *q, int v){
    1af8:	55                   	push   %ebp
    1af9:	89 e5                	mov    %esp,%ebp
    1afb:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1afe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1b05:	e8 89 fc ff ff       	call   1793 <malloc>
    1b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b1d:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b1f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b22:	8b 40 04             	mov    0x4(%eax),%eax
    1b25:	85 c0                	test   %eax,%eax
    1b27:	75 0b                	jne    1b34 <add_q+0x3c>
        q->head = n;
    1b29:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b2f:	89 50 04             	mov    %edx,0x4(%eax)
    1b32:	eb 0c                	jmp    1b40 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b34:	8b 45 08             	mov    0x8(%ebp),%eax
    1b37:	8b 40 08             	mov    0x8(%eax),%eax
    1b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b3d:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b40:	8b 45 08             	mov    0x8(%ebp),%eax
    1b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b46:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b49:	8b 45 08             	mov    0x8(%ebp),%eax
    1b4c:	8b 00                	mov    (%eax),%eax
    1b4e:	8d 50 01             	lea    0x1(%eax),%edx
    1b51:	8b 45 08             	mov    0x8(%ebp),%eax
    1b54:	89 10                	mov    %edx,(%eax)
}
    1b56:	c9                   	leave  
    1b57:	c3                   	ret    

00001b58 <empty_q>:

int empty_q(struct queue *q){
    1b58:	55                   	push   %ebp
    1b59:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b5b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5e:	8b 00                	mov    (%eax),%eax
    1b60:	85 c0                	test   %eax,%eax
    1b62:	75 07                	jne    1b6b <empty_q+0x13>
        return 1;
    1b64:	b8 01 00 00 00       	mov    $0x1,%eax
    1b69:	eb 05                	jmp    1b70 <empty_q+0x18>
    else
        return 0;
    1b6b:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b70:	5d                   	pop    %ebp
    1b71:	c3                   	ret    

00001b72 <pop_q>:
int pop_q(struct queue *q){
    1b72:	55                   	push   %ebp
    1b73:	89 e5                	mov    %esp,%ebp
    1b75:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b78:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7b:	89 04 24             	mov    %eax,(%esp)
    1b7e:	e8 d5 ff ff ff       	call   1b58 <empty_q>
    1b83:	85 c0                	test   %eax,%eax
    1b85:	75 5d                	jne    1be4 <pop_q+0x72>
       val = q->head->value; 
    1b87:	8b 45 08             	mov    0x8(%ebp),%eax
    1b8a:	8b 40 04             	mov    0x4(%eax),%eax
    1b8d:	8b 00                	mov    (%eax),%eax
    1b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b92:	8b 45 08             	mov    0x8(%ebp),%eax
    1b95:	8b 40 04             	mov    0x4(%eax),%eax
    1b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b9b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9e:	8b 40 04             	mov    0x4(%eax),%eax
    1ba1:	8b 50 04             	mov    0x4(%eax),%edx
    1ba4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba7:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bad:	89 04 24             	mov    %eax,(%esp)
    1bb0:	e8 a5 fa ff ff       	call   165a <free>
       q->size--;
    1bb5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb8:	8b 00                	mov    (%eax),%eax
    1bba:	8d 50 ff             	lea    -0x1(%eax),%edx
    1bbd:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc0:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1bc2:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc5:	8b 00                	mov    (%eax),%eax
    1bc7:	85 c0                	test   %eax,%eax
    1bc9:	75 14                	jne    1bdf <pop_q+0x6d>
            q->head = 0;
    1bcb:	8b 45 08             	mov    0x8(%ebp),%eax
    1bce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bd5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be2:	eb 05                	jmp    1be9 <pop_q+0x77>
    }
    return -1;
    1be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1be9:	c9                   	leave  
    1bea:	c3                   	ret    
