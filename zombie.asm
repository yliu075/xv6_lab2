
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
    1009:	e8 75 02 00 00       	call   1283 <fork>
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 0c                	jle    101e <main+0x1e>
    sleep(5);  // Let child exit before parent.
    1012:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    1019:	e8 fd 02 00 00       	call   131b <sleep>
  exit();
    101e:	e8 68 02 00 00       	call   128b <exit>

00001023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1023:	55                   	push   %ebp
    1024:	89 e5                	mov    %esp,%ebp
    1026:	57                   	push   %edi
    1027:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1028:	8b 4d 08             	mov    0x8(%ebp),%ecx
    102b:	8b 55 10             	mov    0x10(%ebp),%edx
    102e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1031:	89 cb                	mov    %ecx,%ebx
    1033:	89 df                	mov    %ebx,%edi
    1035:	89 d1                	mov    %edx,%ecx
    1037:	fc                   	cld    
    1038:	f3 aa                	rep stos %al,%es:(%edi)
    103a:	89 ca                	mov    %ecx,%edx
    103c:	89 fb                	mov    %edi,%ebx
    103e:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1041:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1044:	5b                   	pop    %ebx
    1045:	5f                   	pop    %edi
    1046:	5d                   	pop    %ebp
    1047:	c3                   	ret    

00001048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1048:	55                   	push   %ebp
    1049:	89 e5                	mov    %esp,%ebp
    104b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    104e:	8b 45 08             	mov    0x8(%ebp),%eax
    1051:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1054:	90                   	nop
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	8d 50 01             	lea    0x1(%eax),%edx
    105b:	89 55 08             	mov    %edx,0x8(%ebp)
    105e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1061:	8d 4a 01             	lea    0x1(%edx),%ecx
    1064:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1067:	0f b6 12             	movzbl (%edx),%edx
    106a:	88 10                	mov    %dl,(%eax)
    106c:	0f b6 00             	movzbl (%eax),%eax
    106f:	84 c0                	test   %al,%al
    1071:	75 e2                	jne    1055 <strcpy+0xd>
    ;
  return os;
    1073:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1076:	c9                   	leave  
    1077:	c3                   	ret    

00001078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1078:	55                   	push   %ebp
    1079:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    107b:	eb 08                	jmp    1085 <strcmp+0xd>
    p++, q++;
    107d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1081:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1085:	8b 45 08             	mov    0x8(%ebp),%eax
    1088:	0f b6 00             	movzbl (%eax),%eax
    108b:	84 c0                	test   %al,%al
    108d:	74 10                	je     109f <strcmp+0x27>
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	0f b6 10             	movzbl (%eax),%edx
    1095:	8b 45 0c             	mov    0xc(%ebp),%eax
    1098:	0f b6 00             	movzbl (%eax),%eax
    109b:	38 c2                	cmp    %al,%dl
    109d:	74 de                	je     107d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	0f b6 00             	movzbl (%eax),%eax
    10a5:	0f b6 d0             	movzbl %al,%edx
    10a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ab:	0f b6 00             	movzbl (%eax),%eax
    10ae:	0f b6 c0             	movzbl %al,%eax
    10b1:	29 c2                	sub    %eax,%edx
    10b3:	89 d0                	mov    %edx,%eax
}
    10b5:	5d                   	pop    %ebp
    10b6:	c3                   	ret    

000010b7 <strlen>:

uint
strlen(char *s)
{
    10b7:	55                   	push   %ebp
    10b8:	89 e5                	mov    %esp,%ebp
    10ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10c4:	eb 04                	jmp    10ca <strlen+0x13>
    10c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	01 d0                	add    %edx,%eax
    10d2:	0f b6 00             	movzbl (%eax),%eax
    10d5:	84 c0                	test   %al,%al
    10d7:	75 ed                	jne    10c6 <strlen+0xf>
    ;
  return n;
    10d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10dc:	c9                   	leave  
    10dd:	c3                   	ret    

000010de <memset>:

void*
memset(void *dst, int c, uint n)
{
    10de:	55                   	push   %ebp
    10df:	89 e5                	mov    %esp,%ebp
    10e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10e4:	8b 45 10             	mov    0x10(%ebp),%eax
    10e7:	89 44 24 08          	mov    %eax,0x8(%esp)
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f2:	8b 45 08             	mov    0x8(%ebp),%eax
    10f5:	89 04 24             	mov    %eax,(%esp)
    10f8:	e8 26 ff ff ff       	call   1023 <stosb>
  return dst;
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1100:	c9                   	leave  
    1101:	c3                   	ret    

00001102 <strchr>:

char*
strchr(const char *s, char c)
{
    1102:	55                   	push   %ebp
    1103:	89 e5                	mov    %esp,%ebp
    1105:	83 ec 04             	sub    $0x4,%esp
    1108:	8b 45 0c             	mov    0xc(%ebp),%eax
    110b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    110e:	eb 14                	jmp    1124 <strchr+0x22>
    if(*s == c)
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1119:	75 05                	jne    1120 <strchr+0x1e>
      return (char*)s;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	eb 13                	jmp    1133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	0f b6 00             	movzbl (%eax),%eax
    112a:	84 c0                	test   %al,%al
    112c:	75 e2                	jne    1110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    112e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1133:	c9                   	leave  
    1134:	c3                   	ret    

00001135 <gets>:

char*
gets(char *buf, int max)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1142:	eb 4c                	jmp    1190 <gets+0x5b>
    cc = read(0, &c, 1);
    1144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    114b:	00 
    114c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    114f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    115a:	e8 44 01 00 00       	call   12a3 <read>
    115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1166:	7f 02                	jg     116a <gets+0x35>
      break;
    1168:	eb 31                	jmp    119b <gets+0x66>
    buf[i++] = c;
    116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    116d:	8d 50 01             	lea    0x1(%eax),%edx
    1170:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1173:	89 c2                	mov    %eax,%edx
    1175:	8b 45 08             	mov    0x8(%ebp),%eax
    1178:	01 c2                	add    %eax,%edx
    117a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    117e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1184:	3c 0a                	cmp    $0xa,%al
    1186:	74 13                	je     119b <gets+0x66>
    1188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    118c:	3c 0d                	cmp    $0xd,%al
    118e:	74 0b                	je     119b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1190:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1193:	83 c0 01             	add    $0x1,%eax
    1196:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1199:	7c a9                	jl     1144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    119e:	8b 45 08             	mov    0x8(%ebp),%eax
    11a1:	01 d0                	add    %edx,%eax
    11a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a9:	c9                   	leave  
    11aa:	c3                   	ret    

000011ab <stat>:

int
stat(char *n, struct stat *st)
{
    11ab:	55                   	push   %ebp
    11ac:	89 e5                	mov    %esp,%ebp
    11ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11b8:	00 
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 07 01 00 00       	call   12cb <open>
    11c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11cb:	79 07                	jns    11d4 <stat+0x29>
    return -1;
    11cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11d2:	eb 23                	jmp    11f7 <stat+0x4c>
  r = fstat(fd, st);
    11d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    11db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11de:	89 04 24             	mov    %eax,(%esp)
    11e1:	e8 fd 00 00 00       	call   12e3 <fstat>
    11e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ec:	89 04 24             	mov    %eax,(%esp)
    11ef:	e8 bf 00 00 00       	call   12b3 <close>
  return r;
    11f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    

000011f9 <atoi>:

int
atoi(const char *s)
{
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1206:	eb 25                	jmp    122d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1208:	8b 55 fc             	mov    -0x4(%ebp),%edx
    120b:	89 d0                	mov    %edx,%eax
    120d:	c1 e0 02             	shl    $0x2,%eax
    1210:	01 d0                	add    %edx,%eax
    1212:	01 c0                	add    %eax,%eax
    1214:	89 c1                	mov    %eax,%ecx
    1216:	8b 45 08             	mov    0x8(%ebp),%eax
    1219:	8d 50 01             	lea    0x1(%eax),%edx
    121c:	89 55 08             	mov    %edx,0x8(%ebp)
    121f:	0f b6 00             	movzbl (%eax),%eax
    1222:	0f be c0             	movsbl %al,%eax
    1225:	01 c8                	add    %ecx,%eax
    1227:	83 e8 30             	sub    $0x30,%eax
    122a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    122d:	8b 45 08             	mov    0x8(%ebp),%eax
    1230:	0f b6 00             	movzbl (%eax),%eax
    1233:	3c 2f                	cmp    $0x2f,%al
    1235:	7e 0a                	jle    1241 <atoi+0x48>
    1237:	8b 45 08             	mov    0x8(%ebp),%eax
    123a:	0f b6 00             	movzbl (%eax),%eax
    123d:	3c 39                	cmp    $0x39,%al
    123f:	7e c7                	jle    1208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1244:	c9                   	leave  
    1245:	c3                   	ret    

00001246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1246:	55                   	push   %ebp
    1247:	89 e5                	mov    %esp,%ebp
    1249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1252:	8b 45 0c             	mov    0xc(%ebp),%eax
    1255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1258:	eb 17                	jmp    1271 <memmove+0x2b>
    *dst++ = *src++;
    125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1263:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1266:	8d 4a 01             	lea    0x1(%edx),%ecx
    1269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    126c:	0f b6 12             	movzbl (%edx),%edx
    126f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1271:	8b 45 10             	mov    0x10(%ebp),%eax
    1274:	8d 50 ff             	lea    -0x1(%eax),%edx
    1277:	89 55 10             	mov    %edx,0x10(%ebp)
    127a:	85 c0                	test   %eax,%eax
    127c:	7f dc                	jg     125a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    127e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1281:	c9                   	leave  
    1282:	c3                   	ret    

00001283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1283:	b8 01 00 00 00       	mov    $0x1,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <exit>:
SYSCALL(exit)
    128b:	b8 02 00 00 00       	mov    $0x2,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <wait>:
SYSCALL(wait)
    1293:	b8 03 00 00 00       	mov    $0x3,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <pipe>:
SYSCALL(pipe)
    129b:	b8 04 00 00 00       	mov    $0x4,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <read>:
SYSCALL(read)
    12a3:	b8 05 00 00 00       	mov    $0x5,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <write>:
SYSCALL(write)
    12ab:	b8 10 00 00 00       	mov    $0x10,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <close>:
SYSCALL(close)
    12b3:	b8 15 00 00 00       	mov    $0x15,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <kill>:
SYSCALL(kill)
    12bb:	b8 06 00 00 00       	mov    $0x6,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <exec>:
SYSCALL(exec)
    12c3:	b8 07 00 00 00       	mov    $0x7,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <open>:
SYSCALL(open)
    12cb:	b8 0f 00 00 00       	mov    $0xf,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <mknod>:
SYSCALL(mknod)
    12d3:	b8 11 00 00 00       	mov    $0x11,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <unlink>:
SYSCALL(unlink)
    12db:	b8 12 00 00 00       	mov    $0x12,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <fstat>:
SYSCALL(fstat)
    12e3:	b8 08 00 00 00       	mov    $0x8,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <link>:
SYSCALL(link)
    12eb:	b8 13 00 00 00       	mov    $0x13,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <mkdir>:
SYSCALL(mkdir)
    12f3:	b8 14 00 00 00       	mov    $0x14,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <chdir>:
SYSCALL(chdir)
    12fb:	b8 09 00 00 00       	mov    $0x9,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <dup>:
SYSCALL(dup)
    1303:	b8 0a 00 00 00       	mov    $0xa,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <getpid>:
SYSCALL(getpid)
    130b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <sbrk>:
SYSCALL(sbrk)
    1313:	b8 0c 00 00 00       	mov    $0xc,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <sleep>:
SYSCALL(sleep)
    131b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <uptime>:
SYSCALL(uptime)
    1323:	b8 0e 00 00 00       	mov    $0xe,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <clone>:
SYSCALL(clone)
    132b:	b8 16 00 00 00       	mov    $0x16,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <texit>:
SYSCALL(texit)
    1333:	b8 17 00 00 00       	mov    $0x17,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <tsleep>:
SYSCALL(tsleep)
    133b:	b8 18 00 00 00       	mov    $0x18,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <twakeup>:
SYSCALL(twakeup)
    1343:	b8 19 00 00 00       	mov    $0x19,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <thread_yield>:
SYSCALL(thread_yield)
    134b:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <thread_yield3>:
    1353:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    135b:	55                   	push   %ebp
    135c:	89 e5                	mov    %esp,%ebp
    135e:	83 ec 18             	sub    $0x18,%esp
    1361:	8b 45 0c             	mov    0xc(%ebp),%eax
    1364:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1367:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    136e:	00 
    136f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1372:	89 44 24 04          	mov    %eax,0x4(%esp)
    1376:	8b 45 08             	mov    0x8(%ebp),%eax
    1379:	89 04 24             	mov    %eax,(%esp)
    137c:	e8 2a ff ff ff       	call   12ab <write>
}
    1381:	c9                   	leave  
    1382:	c3                   	ret    

00001383 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1383:	55                   	push   %ebp
    1384:	89 e5                	mov    %esp,%ebp
    1386:	56                   	push   %esi
    1387:	53                   	push   %ebx
    1388:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    138b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1392:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1396:	74 17                	je     13af <printint+0x2c>
    1398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    139c:	79 11                	jns    13af <printint+0x2c>
    neg = 1;
    139e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a8:	f7 d8                	neg    %eax
    13aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13ad:	eb 06                	jmp    13b5 <printint+0x32>
  } else {
    x = xx;
    13af:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13bf:	8d 41 01             	lea    0x1(%ecx),%eax
    13c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13cb:	ba 00 00 00 00       	mov    $0x0,%edx
    13d0:	f7 f3                	div    %ebx
    13d2:	89 d0                	mov    %edx,%eax
    13d4:	0f b6 80 90 1f 00 00 	movzbl 0x1f90(%eax),%eax
    13db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13df:	8b 75 10             	mov    0x10(%ebp),%esi
    13e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e5:	ba 00 00 00 00       	mov    $0x0,%edx
    13ea:	f7 f6                	div    %esi
    13ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13f3:	75 c7                	jne    13bc <printint+0x39>
  if(neg)
    13f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13f9:	74 10                	je     140b <printint+0x88>
    buf[i++] = '-';
    13fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fe:	8d 50 01             	lea    0x1(%eax),%edx
    1401:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1404:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1409:	eb 1f                	jmp    142a <printint+0xa7>
    140b:	eb 1d                	jmp    142a <printint+0xa7>
    putc(fd, buf[i]);
    140d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	01 d0                	add    %edx,%eax
    1415:	0f b6 00             	movzbl (%eax),%eax
    1418:	0f be c0             	movsbl %al,%eax
    141b:	89 44 24 04          	mov    %eax,0x4(%esp)
    141f:	8b 45 08             	mov    0x8(%ebp),%eax
    1422:	89 04 24             	mov    %eax,(%esp)
    1425:	e8 31 ff ff ff       	call   135b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    142a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    142e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1432:	79 d9                	jns    140d <printint+0x8a>
    putc(fd, buf[i]);
}
    1434:	83 c4 30             	add    $0x30,%esp
    1437:	5b                   	pop    %ebx
    1438:	5e                   	pop    %esi
    1439:	5d                   	pop    %ebp
    143a:	c3                   	ret    

0000143b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    143b:	55                   	push   %ebp
    143c:	89 e5                	mov    %esp,%ebp
    143e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1441:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1448:	8d 45 0c             	lea    0xc(%ebp),%eax
    144b:	83 c0 04             	add    $0x4,%eax
    144e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1458:	e9 7c 01 00 00       	jmp    15d9 <printf+0x19e>
    c = fmt[i] & 0xff;
    145d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1460:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1463:	01 d0                	add    %edx,%eax
    1465:	0f b6 00             	movzbl (%eax),%eax
    1468:	0f be c0             	movsbl %al,%eax
    146b:	25 ff 00 00 00       	and    $0xff,%eax
    1470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1477:	75 2c                	jne    14a5 <printf+0x6a>
      if(c == '%'){
    1479:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    147d:	75 0c                	jne    148b <printf+0x50>
        state = '%';
    147f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1486:	e9 4a 01 00 00       	jmp    15d5 <printf+0x19a>
      } else {
        putc(fd, c);
    148b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    148e:	0f be c0             	movsbl %al,%eax
    1491:	89 44 24 04          	mov    %eax,0x4(%esp)
    1495:	8b 45 08             	mov    0x8(%ebp),%eax
    1498:	89 04 24             	mov    %eax,(%esp)
    149b:	e8 bb fe ff ff       	call   135b <putc>
    14a0:	e9 30 01 00 00       	jmp    15d5 <printf+0x19a>
      }
    } else if(state == '%'){
    14a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14a9:	0f 85 26 01 00 00    	jne    15d5 <printf+0x19a>
      if(c == 'd'){
    14af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14b3:	75 2d                	jne    14e2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14b8:	8b 00                	mov    (%eax),%eax
    14ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14c1:	00 
    14c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14c9:	00 
    14ca:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ce:	8b 45 08             	mov    0x8(%ebp),%eax
    14d1:	89 04 24             	mov    %eax,(%esp)
    14d4:	e8 aa fe ff ff       	call   1383 <printint>
        ap++;
    14d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14dd:	e9 ec 00 00 00       	jmp    15ce <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14e6:	74 06                	je     14ee <printf+0xb3>
    14e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14ec:	75 2d                	jne    151b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14f1:	8b 00                	mov    (%eax),%eax
    14f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14fa:	00 
    14fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1502:	00 
    1503:	89 44 24 04          	mov    %eax,0x4(%esp)
    1507:	8b 45 08             	mov    0x8(%ebp),%eax
    150a:	89 04 24             	mov    %eax,(%esp)
    150d:	e8 71 fe ff ff       	call   1383 <printint>
        ap++;
    1512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1516:	e9 b3 00 00 00       	jmp    15ce <printf+0x193>
      } else if(c == 's'){
    151b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    151f:	75 45                	jne    1566 <printf+0x12b>
        s = (char*)*ap;
    1521:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1524:	8b 00                	mov    (%eax),%eax
    1526:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1529:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    152d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1531:	75 09                	jne    153c <printf+0x101>
          s = "(null)";
    1533:	c7 45 f4 7f 1b 00 00 	movl   $0x1b7f,-0xc(%ebp)
        while(*s != 0){
    153a:	eb 1e                	jmp    155a <printf+0x11f>
    153c:	eb 1c                	jmp    155a <printf+0x11f>
          putc(fd, *s);
    153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1541:	0f b6 00             	movzbl (%eax),%eax
    1544:	0f be c0             	movsbl %al,%eax
    1547:	89 44 24 04          	mov    %eax,0x4(%esp)
    154b:	8b 45 08             	mov    0x8(%ebp),%eax
    154e:	89 04 24             	mov    %eax,(%esp)
    1551:	e8 05 fe ff ff       	call   135b <putc>
          s++;
    1556:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155d:	0f b6 00             	movzbl (%eax),%eax
    1560:	84 c0                	test   %al,%al
    1562:	75 da                	jne    153e <printf+0x103>
    1564:	eb 68                	jmp    15ce <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1566:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    156a:	75 1d                	jne    1589 <printf+0x14e>
        putc(fd, *ap);
    156c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    156f:	8b 00                	mov    (%eax),%eax
    1571:	0f be c0             	movsbl %al,%eax
    1574:	89 44 24 04          	mov    %eax,0x4(%esp)
    1578:	8b 45 08             	mov    0x8(%ebp),%eax
    157b:	89 04 24             	mov    %eax,(%esp)
    157e:	e8 d8 fd ff ff       	call   135b <putc>
        ap++;
    1583:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1587:	eb 45                	jmp    15ce <printf+0x193>
      } else if(c == '%'){
    1589:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    158d:	75 17                	jne    15a6 <printf+0x16b>
        putc(fd, c);
    158f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1592:	0f be c0             	movsbl %al,%eax
    1595:	89 44 24 04          	mov    %eax,0x4(%esp)
    1599:	8b 45 08             	mov    0x8(%ebp),%eax
    159c:	89 04 24             	mov    %eax,(%esp)
    159f:	e8 b7 fd ff ff       	call   135b <putc>
    15a4:	eb 28                	jmp    15ce <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15ad:	00 
    15ae:	8b 45 08             	mov    0x8(%ebp),%eax
    15b1:	89 04 24             	mov    %eax,(%esp)
    15b4:	e8 a2 fd ff ff       	call   135b <putc>
        putc(fd, c);
    15b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15bc:	0f be c0             	movsbl %al,%eax
    15bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c3:	8b 45 08             	mov    0x8(%ebp),%eax
    15c6:	89 04 24             	mov    %eax,(%esp)
    15c9:	e8 8d fd ff ff       	call   135b <putc>
      }
      state = 0;
    15ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15d9:	8b 55 0c             	mov    0xc(%ebp),%edx
    15dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15df:	01 d0                	add    %edx,%eax
    15e1:	0f b6 00             	movzbl (%eax),%eax
    15e4:	84 c0                	test   %al,%al
    15e6:	0f 85 71 fe ff ff    	jne    145d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15ec:	c9                   	leave  
    15ed:	c3                   	ret    

000015ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15ee:	55                   	push   %ebp
    15ef:	89 e5                	mov    %esp,%ebp
    15f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15f4:	8b 45 08             	mov    0x8(%ebp),%eax
    15f7:	83 e8 08             	sub    $0x8,%eax
    15fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15fd:	a1 b0 1f 00 00       	mov    0x1fb0,%eax
    1602:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1605:	eb 24                	jmp    162b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1607:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160a:	8b 00                	mov    (%eax),%eax
    160c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    160f:	77 12                	ja     1623 <free+0x35>
    1611:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1614:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1617:	77 24                	ja     163d <free+0x4f>
    1619:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161c:	8b 00                	mov    (%eax),%eax
    161e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1621:	77 1a                	ja     163d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1623:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1626:	8b 00                	mov    (%eax),%eax
    1628:	89 45 fc             	mov    %eax,-0x4(%ebp)
    162b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1631:	76 d4                	jbe    1607 <free+0x19>
    1633:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1636:	8b 00                	mov    (%eax),%eax
    1638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163b:	76 ca                	jbe    1607 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1640:	8b 40 04             	mov    0x4(%eax),%eax
    1643:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    164a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164d:	01 c2                	add    %eax,%edx
    164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1652:	8b 00                	mov    (%eax),%eax
    1654:	39 c2                	cmp    %eax,%edx
    1656:	75 24                	jne    167c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1658:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165b:	8b 50 04             	mov    0x4(%eax),%edx
    165e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1661:	8b 00                	mov    (%eax),%eax
    1663:	8b 40 04             	mov    0x4(%eax),%eax
    1666:	01 c2                	add    %eax,%edx
    1668:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1671:	8b 00                	mov    (%eax),%eax
    1673:	8b 10                	mov    (%eax),%edx
    1675:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1678:	89 10                	mov    %edx,(%eax)
    167a:	eb 0a                	jmp    1686 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167f:	8b 10                	mov    (%eax),%edx
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1686:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1689:	8b 40 04             	mov    0x4(%eax),%eax
    168c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1693:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1696:	01 d0                	add    %edx,%eax
    1698:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    169b:	75 20                	jne    16bd <free+0xcf>
    p->s.size += bp->s.size;
    169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a0:	8b 50 04             	mov    0x4(%eax),%edx
    16a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a6:	8b 40 04             	mov    0x4(%eax),%eax
    16a9:	01 c2                	add    %eax,%edx
    16ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b4:	8b 10                	mov    (%eax),%edx
    16b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b9:	89 10                	mov    %edx,(%eax)
    16bb:	eb 08                	jmp    16c5 <free+0xd7>
  } else
    p->s.ptr = bp;
    16bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16c3:	89 10                	mov    %edx,(%eax)
  freep = p;
    16c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c8:	a3 b0 1f 00 00       	mov    %eax,0x1fb0
}
    16cd:	c9                   	leave  
    16ce:	c3                   	ret    

000016cf <morecore>:

static Header*
morecore(uint nu)
{
    16cf:	55                   	push   %ebp
    16d0:	89 e5                	mov    %esp,%ebp
    16d2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16dc:	77 07                	ja     16e5 <morecore+0x16>
    nu = 4096;
    16de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16e5:	8b 45 08             	mov    0x8(%ebp),%eax
    16e8:	c1 e0 03             	shl    $0x3,%eax
    16eb:	89 04 24             	mov    %eax,(%esp)
    16ee:	e8 20 fc ff ff       	call   1313 <sbrk>
    16f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16fa:	75 07                	jne    1703 <morecore+0x34>
    return 0;
    16fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1701:	eb 22                	jmp    1725 <morecore+0x56>
  hp = (Header*)p;
    1703:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1709:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170c:	8b 55 08             	mov    0x8(%ebp),%edx
    170f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1712:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1715:	83 c0 08             	add    $0x8,%eax
    1718:	89 04 24             	mov    %eax,(%esp)
    171b:	e8 ce fe ff ff       	call   15ee <free>
  return freep;
    1720:	a1 b0 1f 00 00       	mov    0x1fb0,%eax
}
    1725:	c9                   	leave  
    1726:	c3                   	ret    

00001727 <malloc>:

void*
malloc(uint nbytes)
{
    1727:	55                   	push   %ebp
    1728:	89 e5                	mov    %esp,%ebp
    172a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    172d:	8b 45 08             	mov    0x8(%ebp),%eax
    1730:	83 c0 07             	add    $0x7,%eax
    1733:	c1 e8 03             	shr    $0x3,%eax
    1736:	83 c0 01             	add    $0x1,%eax
    1739:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    173c:	a1 b0 1f 00 00       	mov    0x1fb0,%eax
    1741:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1748:	75 23                	jne    176d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    174a:	c7 45 f0 a8 1f 00 00 	movl   $0x1fa8,-0x10(%ebp)
    1751:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1754:	a3 b0 1f 00 00       	mov    %eax,0x1fb0
    1759:	a1 b0 1f 00 00       	mov    0x1fb0,%eax
    175e:	a3 a8 1f 00 00       	mov    %eax,0x1fa8
    base.s.size = 0;
    1763:	c7 05 ac 1f 00 00 00 	movl   $0x0,0x1fac
    176a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1770:	8b 00                	mov    (%eax),%eax
    1772:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1775:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1778:	8b 40 04             	mov    0x4(%eax),%eax
    177b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    177e:	72 4d                	jb     17cd <malloc+0xa6>
      if(p->s.size == nunits)
    1780:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1783:	8b 40 04             	mov    0x4(%eax),%eax
    1786:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1789:	75 0c                	jne    1797 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178e:	8b 10                	mov    (%eax),%edx
    1790:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1793:	89 10                	mov    %edx,(%eax)
    1795:	eb 26                	jmp    17bd <malloc+0x96>
      else {
        p->s.size -= nunits;
    1797:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179a:	8b 40 04             	mov    0x4(%eax),%eax
    179d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17a0:	89 c2                	mov    %eax,%edx
    17a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ab:	8b 40 04             	mov    0x4(%eax),%eax
    17ae:	c1 e0 03             	shl    $0x3,%eax
    17b1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c0:	a3 b0 1f 00 00       	mov    %eax,0x1fb0
      return (void*)(p + 1);
    17c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c8:	83 c0 08             	add    $0x8,%eax
    17cb:	eb 38                	jmp    1805 <malloc+0xde>
    }
    if(p == freep)
    17cd:	a1 b0 1f 00 00       	mov    0x1fb0,%eax
    17d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17d5:	75 1b                	jne    17f2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17da:	89 04 24             	mov    %eax,(%esp)
    17dd:	e8 ed fe ff ff       	call   16cf <morecore>
    17e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e9:	75 07                	jne    17f2 <malloc+0xcb>
        return 0;
    17eb:	b8 00 00 00 00       	mov    $0x0,%eax
    17f0:	eb 13                	jmp    1805 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fb:	8b 00                	mov    (%eax),%eax
    17fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1800:	e9 70 ff ff ff       	jmp    1775 <malloc+0x4e>
}
    1805:	c9                   	leave  
    1806:	c3                   	ret    

00001807 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1807:	55                   	push   %ebp
    1808:	89 e5                	mov    %esp,%ebp
    180a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    180d:	8b 55 08             	mov    0x8(%ebp),%edx
    1810:	8b 45 0c             	mov    0xc(%ebp),%eax
    1813:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1816:	f0 87 02             	lock xchg %eax,(%edx)
    1819:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    181c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    181f:	c9                   	leave  
    1820:	c3                   	ret    

00001821 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1821:	55                   	push   %ebp
    1822:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1824:	8b 45 08             	mov    0x8(%ebp),%eax
    1827:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    182d:	5d                   	pop    %ebp
    182e:	c3                   	ret    

0000182f <lock_acquire>:
void lock_acquire(lock_t *lock){
    182f:	55                   	push   %ebp
    1830:	89 e5                	mov    %esp,%ebp
    1832:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1835:	90                   	nop
    1836:	8b 45 08             	mov    0x8(%ebp),%eax
    1839:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1840:	00 
    1841:	89 04 24             	mov    %eax,(%esp)
    1844:	e8 be ff ff ff       	call   1807 <xchg>
    1849:	85 c0                	test   %eax,%eax
    184b:	75 e9                	jne    1836 <lock_acquire+0x7>
}
    184d:	c9                   	leave  
    184e:	c3                   	ret    

0000184f <lock_release>:
void lock_release(lock_t *lock){
    184f:	55                   	push   %ebp
    1850:	89 e5                	mov    %esp,%ebp
    1852:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1855:	8b 45 08             	mov    0x8(%ebp),%eax
    1858:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    185f:	00 
    1860:	89 04 24             	mov    %eax,(%esp)
    1863:	e8 9f ff ff ff       	call   1807 <xchg>
}
    1868:	c9                   	leave  
    1869:	c3                   	ret    

0000186a <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    186a:	55                   	push   %ebp
    186b:	89 e5                	mov    %esp,%ebp
    186d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1870:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1877:	e8 ab fe ff ff       	call   1727 <malloc>
    187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1882:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1885:	0f b6 05 b4 1f 00 00 	movzbl 0x1fb4,%eax
    188c:	84 c0                	test   %al,%al
    188e:	75 1c                	jne    18ac <thread_create+0x42>
        init_q(thQ2);
    1890:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    1895:	89 04 24             	mov    %eax,(%esp)
    1898:	e8 cd 01 00 00       	call   1a6a <init_q>
        inQ++;
    189d:	0f b6 05 b4 1f 00 00 	movzbl 0x1fb4,%eax
    18a4:	83 c0 01             	add    $0x1,%eax
    18a7:	a2 b4 1f 00 00       	mov    %al,0x1fb4
    }

    if((uint)stack % 4096){
    18ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18af:	25 ff 0f 00 00       	and    $0xfff,%eax
    18b4:	85 c0                	test   %eax,%eax
    18b6:	74 14                	je     18cc <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    18b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bb:	25 ff 0f 00 00       	and    $0xfff,%eax
    18c0:	89 c2                	mov    %eax,%edx
    18c2:	b8 00 10 00 00       	mov    $0x1000,%eax
    18c7:	29 d0                	sub    %edx,%eax
    18c9:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    18cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18d0:	75 1e                	jne    18f0 <thread_create+0x86>

        printf(1,"malloc fail \n");
    18d2:	c7 44 24 04 86 1b 00 	movl   $0x1b86,0x4(%esp)
    18d9:	00 
    18da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18e1:	e8 55 fb ff ff       	call   143b <printf>
        return 0;
    18e6:	b8 00 00 00 00       	mov    $0x0,%eax
    18eb:	e9 9e 00 00 00       	jmp    198e <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    18f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    18f3:	8b 55 08             	mov    0x8(%ebp),%edx
    18f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    18fd:	89 54 24 08          	mov    %edx,0x8(%esp)
    1901:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1908:	00 
    1909:	89 04 24             	mov    %eax,(%esp)
    190c:	e8 1a fa ff ff       	call   132b <clone>
    1911:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1914:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1917:	89 44 24 08          	mov    %eax,0x8(%esp)
    191b:	c7 44 24 04 94 1b 00 	movl   $0x1b94,0x4(%esp)
    1922:	00 
    1923:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    192a:	e8 0c fb ff ff       	call   143b <printf>
    if(tid < 0){
    192f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1933:	79 1b                	jns    1950 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1935:	c7 44 24 04 ad 1b 00 	movl   $0x1bad,0x4(%esp)
    193c:	00 
    193d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1944:	e8 f2 fa ff ff       	call   143b <printf>
        return 0;
    1949:	b8 00 00 00 00       	mov    $0x0,%eax
    194e:	eb 3e                	jmp    198e <thread_create+0x124>
    }
    if(tid > 0){
    1950:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1954:	7e 19                	jle    196f <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1956:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    195b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    195e:	89 54 24 04          	mov    %edx,0x4(%esp)
    1962:	89 04 24             	mov    %eax,(%esp)
    1965:	e8 22 01 00 00       	call   1a8c <add_q>
        return garbage_stack;
    196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    196d:	eb 1f                	jmp    198e <thread_create+0x124>
    }
    if(tid == 0){
    196f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1973:	75 14                	jne    1989 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1975:	c7 44 24 04 ba 1b 00 	movl   $0x1bba,0x4(%esp)
    197c:	00 
    197d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1984:	e8 b2 fa ff ff       	call   143b <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1989:	b8 00 00 00 00       	mov    $0x0,%eax
}
    198e:	c9                   	leave  
    198f:	c3                   	ret    

00001990 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1990:	55                   	push   %ebp
    1991:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1993:	a1 a4 1f 00 00       	mov    0x1fa4,%eax
    1998:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    199e:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19a3:	a3 a4 1f 00 00       	mov    %eax,0x1fa4
    return (int)(rands % max);
    19a8:	a1 a4 1f 00 00       	mov    0x1fa4,%eax
    19ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19b0:	ba 00 00 00 00       	mov    $0x0,%edx
    19b5:	f7 f1                	div    %ecx
    19b7:	89 d0                	mov    %edx,%eax
}
    19b9:	5d                   	pop    %ebp
    19ba:	c3                   	ret    

000019bb <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    19bb:	55                   	push   %ebp
    19bc:	89 e5                	mov    %esp,%ebp
    19be:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    19c1:	e8 45 f9 ff ff       	call   130b <getpid>
    19c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    19c9:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    19ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
    19d1:	89 54 24 04          	mov    %edx,0x4(%esp)
    19d5:	89 04 24             	mov    %eax,(%esp)
    19d8:	e8 af 00 00 00       	call   1a8c <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    19dd:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    19e2:	89 04 24             	mov    %eax,(%esp)
    19e5:	e8 1c 01 00 00       	call   1b06 <pop_q>
    19ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    19ed:	a1 b8 1f 00 00       	mov    0x1fb8,%eax
    19f2:	85 c0                	test   %eax,%eax
    19f4:	75 1f                	jne    1a15 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    19f6:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    19fb:	89 04 24             	mov    %eax,(%esp)
    19fe:	e8 03 01 00 00       	call   1b06 <pop_q>
    1a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a06:	a1 b8 1f 00 00       	mov    0x1fb8,%eax
    1a0b:	83 c0 01             	add    $0x1,%eax
    1a0e:	a3 b8 1f 00 00       	mov    %eax,0x1fb8
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a13:	eb 12                	jmp    1a27 <thread_yield2+0x6c>
    1a15:	eb 10                	jmp    1a27 <thread_yield2+0x6c>
    1a17:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    1a1c:	89 04 24             	mov    %eax,(%esp)
    1a1f:	e8 e2 00 00 00       	call   1b06 <pop_q>
    1a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a2d:	74 e8                	je     1a17 <thread_yield2+0x5c>
    1a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a33:	74 e2                	je     1a17 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a38:	89 04 24             	mov    %eax,(%esp)
    1a3b:	e8 03 f9 ff ff       	call   1343 <twakeup>
    tsleep();
    1a40:	e8 f6 f8 ff ff       	call   133b <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a45:	c9                   	leave  
    1a46:	c3                   	ret    

00001a47 <thread_yield_last>:

void thread_yield_last(){
    1a47:	55                   	push   %ebp
    1a48:	89 e5                	mov    %esp,%ebp
    1a4a:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1a4d:	a1 bc 1f 00 00       	mov    0x1fbc,%eax
    1a52:	89 04 24             	mov    %eax,(%esp)
    1a55:	e8 ac 00 00 00       	call   1b06 <pop_q>
    1a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a60:	89 04 24             	mov    %eax,(%esp)
    1a63:	e8 db f8 ff ff       	call   1343 <twakeup>
    1a68:	c9                   	leave  
    1a69:	c3                   	ret    

00001a6a <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1a6a:	55                   	push   %ebp
    1a6b:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1a6d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1a76:	8b 45 08             	mov    0x8(%ebp),%eax
    1a79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1a80:	8b 45 08             	mov    0x8(%ebp),%eax
    1a83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1a8a:	5d                   	pop    %ebp
    1a8b:	c3                   	ret    

00001a8c <add_q>:

void add_q(struct queue *q, int v){
    1a8c:	55                   	push   %ebp
    1a8d:	89 e5                	mov    %esp,%ebp
    1a8f:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1a92:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1a99:	e8 89 fc ff ff       	call   1727 <malloc>
    1a9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aae:	8b 55 0c             	mov    0xc(%ebp),%edx
    1ab1:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1ab3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ab6:	8b 40 04             	mov    0x4(%eax),%eax
    1ab9:	85 c0                	test   %eax,%eax
    1abb:	75 0b                	jne    1ac8 <add_q+0x3c>
        q->head = n;
    1abd:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ac3:	89 50 04             	mov    %edx,0x4(%eax)
    1ac6:	eb 0c                	jmp    1ad4 <add_q+0x48>
    }else{
        q->tail->next = n;
    1ac8:	8b 45 08             	mov    0x8(%ebp),%eax
    1acb:	8b 40 08             	mov    0x8(%eax),%eax
    1ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ad1:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1ad4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ada:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1add:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae0:	8b 00                	mov    (%eax),%eax
    1ae2:	8d 50 01             	lea    0x1(%eax),%edx
    1ae5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae8:	89 10                	mov    %edx,(%eax)
}
    1aea:	c9                   	leave  
    1aeb:	c3                   	ret    

00001aec <empty_q>:

int empty_q(struct queue *q){
    1aec:	55                   	push   %ebp
    1aed:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1aef:	8b 45 08             	mov    0x8(%ebp),%eax
    1af2:	8b 00                	mov    (%eax),%eax
    1af4:	85 c0                	test   %eax,%eax
    1af6:	75 07                	jne    1aff <empty_q+0x13>
        return 1;
    1af8:	b8 01 00 00 00       	mov    $0x1,%eax
    1afd:	eb 05                	jmp    1b04 <empty_q+0x18>
    else
        return 0;
    1aff:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b04:	5d                   	pop    %ebp
    1b05:	c3                   	ret    

00001b06 <pop_q>:
int pop_q(struct queue *q){
    1b06:	55                   	push   %ebp
    1b07:	89 e5                	mov    %esp,%ebp
    1b09:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0f:	89 04 24             	mov    %eax,(%esp)
    1b12:	e8 d5 ff ff ff       	call   1aec <empty_q>
    1b17:	85 c0                	test   %eax,%eax
    1b19:	75 5d                	jne    1b78 <pop_q+0x72>
       val = q->head->value; 
    1b1b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b1e:	8b 40 04             	mov    0x4(%eax),%eax
    1b21:	8b 00                	mov    (%eax),%eax
    1b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b26:	8b 45 08             	mov    0x8(%ebp),%eax
    1b29:	8b 40 04             	mov    0x4(%eax),%eax
    1b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b2f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b32:	8b 40 04             	mov    0x4(%eax),%eax
    1b35:	8b 50 04             	mov    0x4(%eax),%edx
    1b38:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3b:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b41:	89 04 24             	mov    %eax,(%esp)
    1b44:	e8 a5 fa ff ff       	call   15ee <free>
       q->size--;
    1b49:	8b 45 08             	mov    0x8(%ebp),%eax
    1b4c:	8b 00                	mov    (%eax),%eax
    1b4e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b51:	8b 45 08             	mov    0x8(%ebp),%eax
    1b54:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1b56:	8b 45 08             	mov    0x8(%ebp),%eax
    1b59:	8b 00                	mov    (%eax),%eax
    1b5b:	85 c0                	test   %eax,%eax
    1b5d:	75 14                	jne    1b73 <pop_q+0x6d>
            q->head = 0;
    1b5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1b69:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b76:	eb 05                	jmp    1b7d <pop_q+0x77>
    }
    return -1;
    1b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1b7d:	c9                   	leave  
    1b7e:	c3                   	ret    
