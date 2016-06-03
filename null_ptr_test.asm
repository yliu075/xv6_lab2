
_null_ptr_test:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
}
*/


int main()
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
    int *ptr = 0;
    1009:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1010:	00 
    printf(1, "Read byte at address 0: %p\n", *ptr);
    1011:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1015:	8b 00                	mov    (%eax),%eax
    1017:	89 44 24 08          	mov    %eax,0x8(%esp)
    101b:	c7 44 24 04 ef 1a 00 	movl   $0x1aef,0x4(%esp)
    1022:	00 
    1023:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    102a:	e8 1d 04 00 00       	call   144c <printf>
    exit();
    102f:	e8 68 02 00 00       	call   129c <exit>

00001034 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1034:	55                   	push   %ebp
    1035:	89 e5                	mov    %esp,%ebp
    1037:	57                   	push   %edi
    1038:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1039:	8b 4d 08             	mov    0x8(%ebp),%ecx
    103c:	8b 55 10             	mov    0x10(%ebp),%edx
    103f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1042:	89 cb                	mov    %ecx,%ebx
    1044:	89 df                	mov    %ebx,%edi
    1046:	89 d1                	mov    %edx,%ecx
    1048:	fc                   	cld    
    1049:	f3 aa                	rep stos %al,%es:(%edi)
    104b:	89 ca                	mov    %ecx,%edx
    104d:	89 fb                	mov    %edi,%ebx
    104f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1052:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1055:	5b                   	pop    %ebx
    1056:	5f                   	pop    %edi
    1057:	5d                   	pop    %ebp
    1058:	c3                   	ret    

00001059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1059:	55                   	push   %ebp
    105a:	89 e5                	mov    %esp,%ebp
    105c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    105f:	8b 45 08             	mov    0x8(%ebp),%eax
    1062:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1065:	90                   	nop
    1066:	8b 45 08             	mov    0x8(%ebp),%eax
    1069:	8d 50 01             	lea    0x1(%eax),%edx
    106c:	89 55 08             	mov    %edx,0x8(%ebp)
    106f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1072:	8d 4a 01             	lea    0x1(%edx),%ecx
    1075:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1078:	0f b6 12             	movzbl (%edx),%edx
    107b:	88 10                	mov    %dl,(%eax)
    107d:	0f b6 00             	movzbl (%eax),%eax
    1080:	84 c0                	test   %al,%al
    1082:	75 e2                	jne    1066 <strcpy+0xd>
    ;
  return os;
    1084:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1087:	c9                   	leave  
    1088:	c3                   	ret    

00001089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1089:	55                   	push   %ebp
    108a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    108c:	eb 08                	jmp    1096 <strcmp+0xd>
    p++, q++;
    108e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1092:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1096:	8b 45 08             	mov    0x8(%ebp),%eax
    1099:	0f b6 00             	movzbl (%eax),%eax
    109c:	84 c0                	test   %al,%al
    109e:	74 10                	je     10b0 <strcmp+0x27>
    10a0:	8b 45 08             	mov    0x8(%ebp),%eax
    10a3:	0f b6 10             	movzbl (%eax),%edx
    10a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a9:	0f b6 00             	movzbl (%eax),%eax
    10ac:	38 c2                	cmp    %al,%dl
    10ae:	74 de                	je     108e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10b0:	8b 45 08             	mov    0x8(%ebp),%eax
    10b3:	0f b6 00             	movzbl (%eax),%eax
    10b6:	0f b6 d0             	movzbl %al,%edx
    10b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10bc:	0f b6 00             	movzbl (%eax),%eax
    10bf:	0f b6 c0             	movzbl %al,%eax
    10c2:	29 c2                	sub    %eax,%edx
    10c4:	89 d0                	mov    %edx,%eax
}
    10c6:	5d                   	pop    %ebp
    10c7:	c3                   	ret    

000010c8 <strlen>:

uint
strlen(char *s)
{
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
    10cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10d5:	eb 04                	jmp    10db <strlen+0x13>
    10d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10db:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10de:	8b 45 08             	mov    0x8(%ebp),%eax
    10e1:	01 d0                	add    %edx,%eax
    10e3:	0f b6 00             	movzbl (%eax),%eax
    10e6:	84 c0                	test   %al,%al
    10e8:	75 ed                	jne    10d7 <strlen+0xf>
    ;
  return n;
    10ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ed:	c9                   	leave  
    10ee:	c3                   	ret    

000010ef <memset>:

void*
memset(void *dst, int c, uint n)
{
    10ef:	55                   	push   %ebp
    10f0:	89 e5                	mov    %esp,%ebp
    10f2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10f5:	8b 45 10             	mov    0x10(%ebp),%eax
    10f8:	89 44 24 08          	mov    %eax,0x8(%esp)
    10fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	89 04 24             	mov    %eax,(%esp)
    1109:	e8 26 ff ff ff       	call   1034 <stosb>
  return dst;
    110e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1111:	c9                   	leave  
    1112:	c3                   	ret    

00001113 <strchr>:

char*
strchr(const char *s, char c)
{
    1113:	55                   	push   %ebp
    1114:	89 e5                	mov    %esp,%ebp
    1116:	83 ec 04             	sub    $0x4,%esp
    1119:	8b 45 0c             	mov    0xc(%ebp),%eax
    111c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    111f:	eb 14                	jmp    1135 <strchr+0x22>
    if(*s == c)
    1121:	8b 45 08             	mov    0x8(%ebp),%eax
    1124:	0f b6 00             	movzbl (%eax),%eax
    1127:	3a 45 fc             	cmp    -0x4(%ebp),%al
    112a:	75 05                	jne    1131 <strchr+0x1e>
      return (char*)s;
    112c:	8b 45 08             	mov    0x8(%ebp),%eax
    112f:	eb 13                	jmp    1144 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1135:	8b 45 08             	mov    0x8(%ebp),%eax
    1138:	0f b6 00             	movzbl (%eax),%eax
    113b:	84 c0                	test   %al,%al
    113d:	75 e2                	jne    1121 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    113f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1144:	c9                   	leave  
    1145:	c3                   	ret    

00001146 <gets>:

char*
gets(char *buf, int max)
{
    1146:	55                   	push   %ebp
    1147:	89 e5                	mov    %esp,%ebp
    1149:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    114c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1153:	eb 4c                	jmp    11a1 <gets+0x5b>
    cc = read(0, &c, 1);
    1155:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    115c:	00 
    115d:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1160:	89 44 24 04          	mov    %eax,0x4(%esp)
    1164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    116b:	e8 44 01 00 00       	call   12b4 <read>
    1170:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1177:	7f 02                	jg     117b <gets+0x35>
      break;
    1179:	eb 31                	jmp    11ac <gets+0x66>
    buf[i++] = c;
    117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117e:	8d 50 01             	lea    0x1(%eax),%edx
    1181:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1184:	89 c2                	mov    %eax,%edx
    1186:	8b 45 08             	mov    0x8(%ebp),%eax
    1189:	01 c2                	add    %eax,%edx
    118b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    118f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1191:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1195:	3c 0a                	cmp    $0xa,%al
    1197:	74 13                	je     11ac <gets+0x66>
    1199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    119d:	3c 0d                	cmp    $0xd,%al
    119f:	74 0b                	je     11ac <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a4:	83 c0 01             	add    $0x1,%eax
    11a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11aa:	7c a9                	jl     1155 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11af:	8b 45 08             	mov    0x8(%ebp),%eax
    11b2:	01 d0                	add    %edx,%eax
    11b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ba:	c9                   	leave  
    11bb:	c3                   	ret    

000011bc <stat>:

int
stat(char *n, struct stat *st)
{
    11bc:	55                   	push   %ebp
    11bd:	89 e5                	mov    %esp,%ebp
    11bf:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11c9:	00 
    11ca:	8b 45 08             	mov    0x8(%ebp),%eax
    11cd:	89 04 24             	mov    %eax,(%esp)
    11d0:	e8 07 01 00 00       	call   12dc <open>
    11d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11dc:	79 07                	jns    11e5 <stat+0x29>
    return -1;
    11de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11e3:	eb 23                	jmp    1208 <stat+0x4c>
  r = fstat(fd, st);
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ef:	89 04 24             	mov    %eax,(%esp)
    11f2:	e8 fd 00 00 00       	call   12f4 <fstat>
    11f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11fd:	89 04 24             	mov    %eax,(%esp)
    1200:	e8 bf 00 00 00       	call   12c4 <close>
  return r;
    1205:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1208:	c9                   	leave  
    1209:	c3                   	ret    

0000120a <atoi>:

int
atoi(const char *s)
{
    120a:	55                   	push   %ebp
    120b:	89 e5                	mov    %esp,%ebp
    120d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1217:	eb 25                	jmp    123e <atoi+0x34>
    n = n*10 + *s++ - '0';
    1219:	8b 55 fc             	mov    -0x4(%ebp),%edx
    121c:	89 d0                	mov    %edx,%eax
    121e:	c1 e0 02             	shl    $0x2,%eax
    1221:	01 d0                	add    %edx,%eax
    1223:	01 c0                	add    %eax,%eax
    1225:	89 c1                	mov    %eax,%ecx
    1227:	8b 45 08             	mov    0x8(%ebp),%eax
    122a:	8d 50 01             	lea    0x1(%eax),%edx
    122d:	89 55 08             	mov    %edx,0x8(%ebp)
    1230:	0f b6 00             	movzbl (%eax),%eax
    1233:	0f be c0             	movsbl %al,%eax
    1236:	01 c8                	add    %ecx,%eax
    1238:	83 e8 30             	sub    $0x30,%eax
    123b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    123e:	8b 45 08             	mov    0x8(%ebp),%eax
    1241:	0f b6 00             	movzbl (%eax),%eax
    1244:	3c 2f                	cmp    $0x2f,%al
    1246:	7e 0a                	jle    1252 <atoi+0x48>
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	0f b6 00             	movzbl (%eax),%eax
    124e:	3c 39                	cmp    $0x39,%al
    1250:	7e c7                	jle    1219 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1255:	c9                   	leave  
    1256:	c3                   	ret    

00001257 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1257:	55                   	push   %ebp
    1258:	89 e5                	mov    %esp,%ebp
    125a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    125d:	8b 45 08             	mov    0x8(%ebp),%eax
    1260:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1263:	8b 45 0c             	mov    0xc(%ebp),%eax
    1266:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1269:	eb 17                	jmp    1282 <memmove+0x2b>
    *dst++ = *src++;
    126b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126e:	8d 50 01             	lea    0x1(%eax),%edx
    1271:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1274:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1277:	8d 4a 01             	lea    0x1(%edx),%ecx
    127a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    127d:	0f b6 12             	movzbl (%edx),%edx
    1280:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1282:	8b 45 10             	mov    0x10(%ebp),%eax
    1285:	8d 50 ff             	lea    -0x1(%eax),%edx
    1288:	89 55 10             	mov    %edx,0x10(%ebp)
    128b:	85 c0                	test   %eax,%eax
    128d:	7f dc                	jg     126b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    128f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1292:	c9                   	leave  
    1293:	c3                   	ret    

00001294 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1294:	b8 01 00 00 00       	mov    $0x1,%eax
    1299:	cd 40                	int    $0x40
    129b:	c3                   	ret    

0000129c <exit>:
SYSCALL(exit)
    129c:	b8 02 00 00 00       	mov    $0x2,%eax
    12a1:	cd 40                	int    $0x40
    12a3:	c3                   	ret    

000012a4 <wait>:
SYSCALL(wait)
    12a4:	b8 03 00 00 00       	mov    $0x3,%eax
    12a9:	cd 40                	int    $0x40
    12ab:	c3                   	ret    

000012ac <pipe>:
SYSCALL(pipe)
    12ac:	b8 04 00 00 00       	mov    $0x4,%eax
    12b1:	cd 40                	int    $0x40
    12b3:	c3                   	ret    

000012b4 <read>:
SYSCALL(read)
    12b4:	b8 05 00 00 00       	mov    $0x5,%eax
    12b9:	cd 40                	int    $0x40
    12bb:	c3                   	ret    

000012bc <write>:
SYSCALL(write)
    12bc:	b8 10 00 00 00       	mov    $0x10,%eax
    12c1:	cd 40                	int    $0x40
    12c3:	c3                   	ret    

000012c4 <close>:
SYSCALL(close)
    12c4:	b8 15 00 00 00       	mov    $0x15,%eax
    12c9:	cd 40                	int    $0x40
    12cb:	c3                   	ret    

000012cc <kill>:
SYSCALL(kill)
    12cc:	b8 06 00 00 00       	mov    $0x6,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <exec>:
SYSCALL(exec)
    12d4:	b8 07 00 00 00       	mov    $0x7,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <open>:
SYSCALL(open)
    12dc:	b8 0f 00 00 00       	mov    $0xf,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <mknod>:
SYSCALL(mknod)
    12e4:	b8 11 00 00 00       	mov    $0x11,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <unlink>:
SYSCALL(unlink)
    12ec:	b8 12 00 00 00       	mov    $0x12,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <fstat>:
SYSCALL(fstat)
    12f4:	b8 08 00 00 00       	mov    $0x8,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <link>:
SYSCALL(link)
    12fc:	b8 13 00 00 00       	mov    $0x13,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <mkdir>:
SYSCALL(mkdir)
    1304:	b8 14 00 00 00       	mov    $0x14,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <chdir>:
SYSCALL(chdir)
    130c:	b8 09 00 00 00       	mov    $0x9,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <dup>:
SYSCALL(dup)
    1314:	b8 0a 00 00 00       	mov    $0xa,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <getpid>:
SYSCALL(getpid)
    131c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <sbrk>:
SYSCALL(sbrk)
    1324:	b8 0c 00 00 00       	mov    $0xc,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <sleep>:
SYSCALL(sleep)
    132c:	b8 0d 00 00 00       	mov    $0xd,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <uptime>:
SYSCALL(uptime)
    1334:	b8 0e 00 00 00       	mov    $0xe,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <clone>:
SYSCALL(clone)
    133c:	b8 16 00 00 00       	mov    $0x16,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <texit>:
SYSCALL(texit)
    1344:	b8 17 00 00 00       	mov    $0x17,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <tsleep>:
SYSCALL(tsleep)
    134c:	b8 18 00 00 00       	mov    $0x18,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <twakeup>:
SYSCALL(twakeup)
    1354:	b8 19 00 00 00       	mov    $0x19,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <thread_yield>:
SYSCALL(thread_yield)
    135c:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <thread_yield3>:
    1364:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    136c:	55                   	push   %ebp
    136d:	89 e5                	mov    %esp,%ebp
    136f:	83 ec 18             	sub    $0x18,%esp
    1372:	8b 45 0c             	mov    0xc(%ebp),%eax
    1375:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1378:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    137f:	00 
    1380:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1383:	89 44 24 04          	mov    %eax,0x4(%esp)
    1387:	8b 45 08             	mov    0x8(%ebp),%eax
    138a:	89 04 24             	mov    %eax,(%esp)
    138d:	e8 2a ff ff ff       	call   12bc <write>
}
    1392:	c9                   	leave  
    1393:	c3                   	ret    

00001394 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1394:	55                   	push   %ebp
    1395:	89 e5                	mov    %esp,%ebp
    1397:	56                   	push   %esi
    1398:	53                   	push   %ebx
    1399:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    139c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13a3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13a7:	74 17                	je     13c0 <printint+0x2c>
    13a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13ad:	79 11                	jns    13c0 <printint+0x2c>
    neg = 1;
    13af:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b9:	f7 d8                	neg    %eax
    13bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13be:	eb 06                	jmp    13c6 <printint+0x32>
  } else {
    x = xx;
    13c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13d0:	8d 41 01             	lea    0x1(%ecx),%eax
    13d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13dc:	ba 00 00 00 00       	mov    $0x0,%edx
    13e1:	f7 f3                	div    %ebx
    13e3:	89 d0                	mov    %edx,%eax
    13e5:	0f b6 80 f0 1e 00 00 	movzbl 0x1ef0(%eax),%eax
    13ec:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13f0:	8b 75 10             	mov    0x10(%ebp),%esi
    13f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f6:	ba 00 00 00 00       	mov    $0x0,%edx
    13fb:	f7 f6                	div    %esi
    13fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1400:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1404:	75 c7                	jne    13cd <printint+0x39>
  if(neg)
    1406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    140a:	74 10                	je     141c <printint+0x88>
    buf[i++] = '-';
    140c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140f:	8d 50 01             	lea    0x1(%eax),%edx
    1412:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1415:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    141a:	eb 1f                	jmp    143b <printint+0xa7>
    141c:	eb 1d                	jmp    143b <printint+0xa7>
    putc(fd, buf[i]);
    141e:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1424:	01 d0                	add    %edx,%eax
    1426:	0f b6 00             	movzbl (%eax),%eax
    1429:	0f be c0             	movsbl %al,%eax
    142c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1430:	8b 45 08             	mov    0x8(%ebp),%eax
    1433:	89 04 24             	mov    %eax,(%esp)
    1436:	e8 31 ff ff ff       	call   136c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    143b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    143f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1443:	79 d9                	jns    141e <printint+0x8a>
    putc(fd, buf[i]);
}
    1445:	83 c4 30             	add    $0x30,%esp
    1448:	5b                   	pop    %ebx
    1449:	5e                   	pop    %esi
    144a:	5d                   	pop    %ebp
    144b:	c3                   	ret    

0000144c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    144c:	55                   	push   %ebp
    144d:	89 e5                	mov    %esp,%ebp
    144f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1452:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1459:	8d 45 0c             	lea    0xc(%ebp),%eax
    145c:	83 c0 04             	add    $0x4,%eax
    145f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1469:	e9 7c 01 00 00       	jmp    15ea <printf+0x19e>
    c = fmt[i] & 0xff;
    146e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1471:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1474:	01 d0                	add    %edx,%eax
    1476:	0f b6 00             	movzbl (%eax),%eax
    1479:	0f be c0             	movsbl %al,%eax
    147c:	25 ff 00 00 00       	and    $0xff,%eax
    1481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1484:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1488:	75 2c                	jne    14b6 <printf+0x6a>
      if(c == '%'){
    148a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    148e:	75 0c                	jne    149c <printf+0x50>
        state = '%';
    1490:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1497:	e9 4a 01 00 00       	jmp    15e6 <printf+0x19a>
      } else {
        putc(fd, c);
    149c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    149f:	0f be c0             	movsbl %al,%eax
    14a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a6:	8b 45 08             	mov    0x8(%ebp),%eax
    14a9:	89 04 24             	mov    %eax,(%esp)
    14ac:	e8 bb fe ff ff       	call   136c <putc>
    14b1:	e9 30 01 00 00       	jmp    15e6 <printf+0x19a>
      }
    } else if(state == '%'){
    14b6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ba:	0f 85 26 01 00 00    	jne    15e6 <printf+0x19a>
      if(c == 'd'){
    14c0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14c4:	75 2d                	jne    14f3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14c9:	8b 00                	mov    (%eax),%eax
    14cb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14d2:	00 
    14d3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14da:	00 
    14db:	89 44 24 04          	mov    %eax,0x4(%esp)
    14df:	8b 45 08             	mov    0x8(%ebp),%eax
    14e2:	89 04 24             	mov    %eax,(%esp)
    14e5:	e8 aa fe ff ff       	call   1394 <printint>
        ap++;
    14ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14ee:	e9 ec 00 00 00       	jmp    15df <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14f3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14f7:	74 06                	je     14ff <printf+0xb3>
    14f9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14fd:	75 2d                	jne    152c <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1502:	8b 00                	mov    (%eax),%eax
    1504:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    150b:	00 
    150c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1513:	00 
    1514:	89 44 24 04          	mov    %eax,0x4(%esp)
    1518:	8b 45 08             	mov    0x8(%ebp),%eax
    151b:	89 04 24             	mov    %eax,(%esp)
    151e:	e8 71 fe ff ff       	call   1394 <printint>
        ap++;
    1523:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1527:	e9 b3 00 00 00       	jmp    15df <printf+0x193>
      } else if(c == 's'){
    152c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1530:	75 45                	jne    1577 <printf+0x12b>
        s = (char*)*ap;
    1532:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1535:	8b 00                	mov    (%eax),%eax
    1537:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    153a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    153e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1542:	75 09                	jne    154d <printf+0x101>
          s = "(null)";
    1544:	c7 45 f4 0b 1b 00 00 	movl   $0x1b0b,-0xc(%ebp)
        while(*s != 0){
    154b:	eb 1e                	jmp    156b <printf+0x11f>
    154d:	eb 1c                	jmp    156b <printf+0x11f>
          putc(fd, *s);
    154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1552:	0f b6 00             	movzbl (%eax),%eax
    1555:	0f be c0             	movsbl %al,%eax
    1558:	89 44 24 04          	mov    %eax,0x4(%esp)
    155c:	8b 45 08             	mov    0x8(%ebp),%eax
    155f:	89 04 24             	mov    %eax,(%esp)
    1562:	e8 05 fe ff ff       	call   136c <putc>
          s++;
    1567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156e:	0f b6 00             	movzbl (%eax),%eax
    1571:	84 c0                	test   %al,%al
    1573:	75 da                	jne    154f <printf+0x103>
    1575:	eb 68                	jmp    15df <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1577:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    157b:	75 1d                	jne    159a <printf+0x14e>
        putc(fd, *ap);
    157d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1580:	8b 00                	mov    (%eax),%eax
    1582:	0f be c0             	movsbl %al,%eax
    1585:	89 44 24 04          	mov    %eax,0x4(%esp)
    1589:	8b 45 08             	mov    0x8(%ebp),%eax
    158c:	89 04 24             	mov    %eax,(%esp)
    158f:	e8 d8 fd ff ff       	call   136c <putc>
        ap++;
    1594:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1598:	eb 45                	jmp    15df <printf+0x193>
      } else if(c == '%'){
    159a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    159e:	75 17                	jne    15b7 <printf+0x16b>
        putc(fd, c);
    15a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15a3:	0f be c0             	movsbl %al,%eax
    15a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15aa:	8b 45 08             	mov    0x8(%ebp),%eax
    15ad:	89 04 24             	mov    %eax,(%esp)
    15b0:	e8 b7 fd ff ff       	call   136c <putc>
    15b5:	eb 28                	jmp    15df <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15b7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15be:	00 
    15bf:	8b 45 08             	mov    0x8(%ebp),%eax
    15c2:	89 04 24             	mov    %eax,(%esp)
    15c5:	e8 a2 fd ff ff       	call   136c <putc>
        putc(fd, c);
    15ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15cd:	0f be c0             	movsbl %al,%eax
    15d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d4:	8b 45 08             	mov    0x8(%ebp),%eax
    15d7:	89 04 24             	mov    %eax,(%esp)
    15da:	e8 8d fd ff ff       	call   136c <putc>
      }
      state = 0;
    15df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15ea:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f0:	01 d0                	add    %edx,%eax
    15f2:	0f b6 00             	movzbl (%eax),%eax
    15f5:	84 c0                	test   %al,%al
    15f7:	0f 85 71 fe ff ff    	jne    146e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15fd:	c9                   	leave  
    15fe:	c3                   	ret    

000015ff <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15ff:	55                   	push   %ebp
    1600:	89 e5                	mov    %esp,%ebp
    1602:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1605:	8b 45 08             	mov    0x8(%ebp),%eax
    1608:	83 e8 08             	sub    $0x8,%eax
    160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    160e:	a1 10 1f 00 00       	mov    0x1f10,%eax
    1613:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1616:	eb 24                	jmp    163c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1618:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161b:	8b 00                	mov    (%eax),%eax
    161d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1620:	77 12                	ja     1634 <free+0x35>
    1622:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1625:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1628:	77 24                	ja     164e <free+0x4f>
    162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162d:	8b 00                	mov    (%eax),%eax
    162f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1632:	77 1a                	ja     164e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1634:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1637:	8b 00                	mov    (%eax),%eax
    1639:	89 45 fc             	mov    %eax,-0x4(%ebp)
    163c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1642:	76 d4                	jbe    1618 <free+0x19>
    1644:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1647:	8b 00                	mov    (%eax),%eax
    1649:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164c:	76 ca                	jbe    1618 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1651:	8b 40 04             	mov    0x4(%eax),%eax
    1654:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165e:	01 c2                	add    %eax,%edx
    1660:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1663:	8b 00                	mov    (%eax),%eax
    1665:	39 c2                	cmp    %eax,%edx
    1667:	75 24                	jne    168d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1669:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166c:	8b 50 04             	mov    0x4(%eax),%edx
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	8b 00                	mov    (%eax),%eax
    1674:	8b 40 04             	mov    0x4(%eax),%eax
    1677:	01 c2                	add    %eax,%edx
    1679:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1682:	8b 00                	mov    (%eax),%eax
    1684:	8b 10                	mov    (%eax),%edx
    1686:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1689:	89 10                	mov    %edx,(%eax)
    168b:	eb 0a                	jmp    1697 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    168d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1690:	8b 10                	mov    (%eax),%edx
    1692:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1695:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1697:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169a:	8b 40 04             	mov    0x4(%eax),%eax
    169d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a7:	01 d0                	add    %edx,%eax
    16a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16ac:	75 20                	jne    16ce <free+0xcf>
    p->s.size += bp->s.size;
    16ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b1:	8b 50 04             	mov    0x4(%eax),%edx
    16b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b7:	8b 40 04             	mov    0x4(%eax),%eax
    16ba:	01 c2                	add    %eax,%edx
    16bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c5:	8b 10                	mov    (%eax),%edx
    16c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ca:	89 10                	mov    %edx,(%eax)
    16cc:	eb 08                	jmp    16d6 <free+0xd7>
  } else
    p->s.ptr = bp;
    16ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16d4:	89 10                	mov    %edx,(%eax)
  freep = p;
    16d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d9:	a3 10 1f 00 00       	mov    %eax,0x1f10
}
    16de:	c9                   	leave  
    16df:	c3                   	ret    

000016e0 <morecore>:

static Header*
morecore(uint nu)
{
    16e0:	55                   	push   %ebp
    16e1:	89 e5                	mov    %esp,%ebp
    16e3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16e6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16ed:	77 07                	ja     16f6 <morecore+0x16>
    nu = 4096;
    16ef:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16f6:	8b 45 08             	mov    0x8(%ebp),%eax
    16f9:	c1 e0 03             	shl    $0x3,%eax
    16fc:	89 04 24             	mov    %eax,(%esp)
    16ff:	e8 20 fc ff ff       	call   1324 <sbrk>
    1704:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1707:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    170b:	75 07                	jne    1714 <morecore+0x34>
    return 0;
    170d:	b8 00 00 00 00       	mov    $0x0,%eax
    1712:	eb 22                	jmp    1736 <morecore+0x56>
  hp = (Header*)p;
    1714:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    171d:	8b 55 08             	mov    0x8(%ebp),%edx
    1720:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1723:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1726:	83 c0 08             	add    $0x8,%eax
    1729:	89 04 24             	mov    %eax,(%esp)
    172c:	e8 ce fe ff ff       	call   15ff <free>
  return freep;
    1731:	a1 10 1f 00 00       	mov    0x1f10,%eax
}
    1736:	c9                   	leave  
    1737:	c3                   	ret    

00001738 <malloc>:

void*
malloc(uint nbytes)
{
    1738:	55                   	push   %ebp
    1739:	89 e5                	mov    %esp,%ebp
    173b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    173e:	8b 45 08             	mov    0x8(%ebp),%eax
    1741:	83 c0 07             	add    $0x7,%eax
    1744:	c1 e8 03             	shr    $0x3,%eax
    1747:	83 c0 01             	add    $0x1,%eax
    174a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    174d:	a1 10 1f 00 00       	mov    0x1f10,%eax
    1752:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1759:	75 23                	jne    177e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    175b:	c7 45 f0 08 1f 00 00 	movl   $0x1f08,-0x10(%ebp)
    1762:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1765:	a3 10 1f 00 00       	mov    %eax,0x1f10
    176a:	a1 10 1f 00 00       	mov    0x1f10,%eax
    176f:	a3 08 1f 00 00       	mov    %eax,0x1f08
    base.s.size = 0;
    1774:	c7 05 0c 1f 00 00 00 	movl   $0x0,0x1f0c
    177b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1781:	8b 00                	mov    (%eax),%eax
    1783:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1786:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1789:	8b 40 04             	mov    0x4(%eax),%eax
    178c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    178f:	72 4d                	jb     17de <malloc+0xa6>
      if(p->s.size == nunits)
    1791:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1794:	8b 40 04             	mov    0x4(%eax),%eax
    1797:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179a:	75 0c                	jne    17a8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179f:	8b 10                	mov    (%eax),%edx
    17a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a4:	89 10                	mov    %edx,(%eax)
    17a6:	eb 26                	jmp    17ce <malloc+0x96>
      else {
        p->s.size -= nunits;
    17a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ab:	8b 40 04             	mov    0x4(%eax),%eax
    17ae:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17b1:	89 c2                	mov    %eax,%edx
    17b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 40 04             	mov    0x4(%eax),%eax
    17bf:	c1 e0 03             	shl    $0x3,%eax
    17c2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17cb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d1:	a3 10 1f 00 00       	mov    %eax,0x1f10
      return (void*)(p + 1);
    17d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d9:	83 c0 08             	add    $0x8,%eax
    17dc:	eb 38                	jmp    1816 <malloc+0xde>
    }
    if(p == freep)
    17de:	a1 10 1f 00 00       	mov    0x1f10,%eax
    17e3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17e6:	75 1b                	jne    1803 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17eb:	89 04 24             	mov    %eax,(%esp)
    17ee:	e8 ed fe ff ff       	call   16e0 <morecore>
    17f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17fa:	75 07                	jne    1803 <malloc+0xcb>
        return 0;
    17fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1801:	eb 13                	jmp    1816 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1803:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1806:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180c:	8b 00                	mov    (%eax),%eax
    180e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1811:	e9 70 ff ff ff       	jmp    1786 <malloc+0x4e>
}
    1816:	c9                   	leave  
    1817:	c3                   	ret    

00001818 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1818:	55                   	push   %ebp
    1819:	89 e5                	mov    %esp,%ebp
    181b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    181e:	8b 55 08             	mov    0x8(%ebp),%edx
    1821:	8b 45 0c             	mov    0xc(%ebp),%eax
    1824:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1827:	f0 87 02             	lock xchg %eax,(%edx)
    182a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1830:	c9                   	leave  
    1831:	c3                   	ret    

00001832 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1832:	55                   	push   %ebp
    1833:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1835:	8b 45 08             	mov    0x8(%ebp),%eax
    1838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    183e:	5d                   	pop    %ebp
    183f:	c3                   	ret    

00001840 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1840:	55                   	push   %ebp
    1841:	89 e5                	mov    %esp,%ebp
    1843:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1846:	90                   	nop
    1847:	8b 45 08             	mov    0x8(%ebp),%eax
    184a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1851:	00 
    1852:	89 04 24             	mov    %eax,(%esp)
    1855:	e8 be ff ff ff       	call   1818 <xchg>
    185a:	85 c0                	test   %eax,%eax
    185c:	75 e9                	jne    1847 <lock_acquire+0x7>
}
    185e:	c9                   	leave  
    185f:	c3                   	ret    

00001860 <lock_release>:
void lock_release(lock_t *lock){
    1860:	55                   	push   %ebp
    1861:	89 e5                	mov    %esp,%ebp
    1863:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1866:	8b 45 08             	mov    0x8(%ebp),%eax
    1869:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1870:	00 
    1871:	89 04 24             	mov    %eax,(%esp)
    1874:	e8 9f ff ff ff       	call   1818 <xchg>
}
    1879:	c9                   	leave  
    187a:	c3                   	ret    

0000187b <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    187b:	55                   	push   %ebp
    187c:	89 e5                	mov    %esp,%ebp
    187e:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1881:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1888:	e8 ab fe ff ff       	call   1738 <malloc>
    188d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1890:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1893:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1896:	0f b6 05 14 1f 00 00 	movzbl 0x1f14,%eax
    189d:	84 c0                	test   %al,%al
    189f:	75 1c                	jne    18bd <thread_create+0x42>
        init_q(thQ2);
    18a1:	a1 18 1f 00 00       	mov    0x1f18,%eax
    18a6:	89 04 24             	mov    %eax,(%esp)
    18a9:	e8 2c 01 00 00       	call   19da <init_q>
        inQ++;
    18ae:	0f b6 05 14 1f 00 00 	movzbl 0x1f14,%eax
    18b5:	83 c0 01             	add    $0x1,%eax
    18b8:	a2 14 1f 00 00       	mov    %al,0x1f14
    }

    if((uint)stack % 4096){
    18bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c0:	25 ff 0f 00 00       	and    $0xfff,%eax
    18c5:	85 c0                	test   %eax,%eax
    18c7:	74 14                	je     18dd <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    18c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cc:	25 ff 0f 00 00       	and    $0xfff,%eax
    18d1:	89 c2                	mov    %eax,%edx
    18d3:	b8 00 10 00 00       	mov    $0x1000,%eax
    18d8:	29 d0                	sub    %edx,%eax
    18da:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    18dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e1:	75 1e                	jne    1901 <thread_create+0x86>

        printf(1,"malloc fail \n");
    18e3:	c7 44 24 04 12 1b 00 	movl   $0x1b12,0x4(%esp)
    18ea:	00 
    18eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f2:	e8 55 fb ff ff       	call   144c <printf>
        return 0;
    18f7:	b8 00 00 00 00       	mov    $0x0,%eax
    18fc:	e9 83 00 00 00       	jmp    1984 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1901:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1904:	8b 55 08             	mov    0x8(%ebp),%edx
    1907:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    190e:	89 54 24 08          	mov    %edx,0x8(%esp)
    1912:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1919:	00 
    191a:	89 04 24             	mov    %eax,(%esp)
    191d:	e8 1a fa ff ff       	call   133c <clone>
    1922:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    1925:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1929:	79 1b                	jns    1946 <thread_create+0xcb>
        printf(1,"clone fails\n");
    192b:	c7 44 24 04 20 1b 00 	movl   $0x1b20,0x4(%esp)
    1932:	00 
    1933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    193a:	e8 0d fb ff ff       	call   144c <printf>
        return 0;
    193f:	b8 00 00 00 00       	mov    $0x0,%eax
    1944:	eb 3e                	jmp    1984 <thread_create+0x109>
    }
    if(tid > 0){
    1946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    194a:	7e 19                	jle    1965 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    194c:	a1 18 1f 00 00       	mov    0x1f18,%eax
    1951:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1954:	89 54 24 04          	mov    %edx,0x4(%esp)
    1958:	89 04 24             	mov    %eax,(%esp)
    195b:	e8 9c 00 00 00       	call   19fc <add_q>
        return garbage_stack;
    1960:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1963:	eb 1f                	jmp    1984 <thread_create+0x109>
    }
    if(tid == 0){
    1965:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1969:	75 14                	jne    197f <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    196b:	c7 44 24 04 2d 1b 00 	movl   $0x1b2d,0x4(%esp)
    1972:	00 
    1973:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    197a:	e8 cd fa ff ff       	call   144c <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1984:	c9                   	leave  
    1985:	c3                   	ret    

00001986 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1986:	55                   	push   %ebp
    1987:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1989:	a1 04 1f 00 00       	mov    0x1f04,%eax
    198e:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1994:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1999:	a3 04 1f 00 00       	mov    %eax,0x1f04
    return (int)(rands % max);
    199e:	a1 04 1f 00 00       	mov    0x1f04,%eax
    19a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19a6:	ba 00 00 00 00       	mov    $0x0,%edx
    19ab:	f7 f1                	div    %ecx
    19ad:	89 d0                	mov    %edx,%eax
}
    19af:	5d                   	pop    %ebp
    19b0:	c3                   	ret    

000019b1 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    19b1:	55                   	push   %ebp
    19b2:	89 e5                	mov    %esp,%ebp
    19b4:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
    19b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    19bd:	8b 40 10             	mov    0x10(%eax),%eax
    19c0:	89 44 24 08          	mov    %eax,0x8(%esp)
    19c4:	c7 44 24 04 3e 1b 00 	movl   $0x1b3e,0x4(%esp)
    19cb:	00 
    19cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19d3:	e8 74 fa ff ff       	call   144c <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
    19d8:	c9                   	leave  
    19d9:	c3                   	ret    

000019da <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    19da:	55                   	push   %ebp
    19db:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    19dd:	8b 45 08             	mov    0x8(%ebp),%eax
    19e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    19e6:	8b 45 08             	mov    0x8(%ebp),%eax
    19e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    19f0:	8b 45 08             	mov    0x8(%ebp),%eax
    19f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    19fa:	5d                   	pop    %ebp
    19fb:	c3                   	ret    

000019fc <add_q>:

void add_q(struct queue *q, int v){
    19fc:	55                   	push   %ebp
    19fd:	89 e5                	mov    %esp,%ebp
    19ff:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1a02:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1a09:	e8 2a fd ff ff       	call   1738 <malloc>
    1a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1a21:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1a23:	8b 45 08             	mov    0x8(%ebp),%eax
    1a26:	8b 40 04             	mov    0x4(%eax),%eax
    1a29:	85 c0                	test   %eax,%eax
    1a2b:	75 0b                	jne    1a38 <add_q+0x3c>
        q->head = n;
    1a2d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a33:	89 50 04             	mov    %edx,0x4(%eax)
    1a36:	eb 0c                	jmp    1a44 <add_q+0x48>
    }else{
        q->tail->next = n;
    1a38:	8b 45 08             	mov    0x8(%ebp),%eax
    1a3b:	8b 40 08             	mov    0x8(%eax),%eax
    1a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a41:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1a44:	8b 45 08             	mov    0x8(%ebp),%eax
    1a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a4a:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1a4d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a50:	8b 00                	mov    (%eax),%eax
    1a52:	8d 50 01             	lea    0x1(%eax),%edx
    1a55:	8b 45 08             	mov    0x8(%ebp),%eax
    1a58:	89 10                	mov    %edx,(%eax)
}
    1a5a:	c9                   	leave  
    1a5b:	c3                   	ret    

00001a5c <empty_q>:

int empty_q(struct queue *q){
    1a5c:	55                   	push   %ebp
    1a5d:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1a5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a62:	8b 00                	mov    (%eax),%eax
    1a64:	85 c0                	test   %eax,%eax
    1a66:	75 07                	jne    1a6f <empty_q+0x13>
        return 1;
    1a68:	b8 01 00 00 00       	mov    $0x1,%eax
    1a6d:	eb 05                	jmp    1a74 <empty_q+0x18>
    else
        return 0;
    1a6f:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1a74:	5d                   	pop    %ebp
    1a75:	c3                   	ret    

00001a76 <pop_q>:
int pop_q(struct queue *q){
    1a76:	55                   	push   %ebp
    1a77:	89 e5                	mov    %esp,%ebp
    1a79:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1a7c:	8b 45 08             	mov    0x8(%ebp),%eax
    1a7f:	89 04 24             	mov    %eax,(%esp)
    1a82:	e8 d5 ff ff ff       	call   1a5c <empty_q>
    1a87:	85 c0                	test   %eax,%eax
    1a89:	75 5d                	jne    1ae8 <pop_q+0x72>
       val = q->head->value; 
    1a8b:	8b 45 08             	mov    0x8(%ebp),%eax
    1a8e:	8b 40 04             	mov    0x4(%eax),%eax
    1a91:	8b 00                	mov    (%eax),%eax
    1a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1a96:	8b 45 08             	mov    0x8(%ebp),%eax
    1a99:	8b 40 04             	mov    0x4(%eax),%eax
    1a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1a9f:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa2:	8b 40 04             	mov    0x4(%eax),%eax
    1aa5:	8b 50 04             	mov    0x4(%eax),%edx
    1aa8:	8b 45 08             	mov    0x8(%ebp),%eax
    1aab:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab1:	89 04 24             	mov    %eax,(%esp)
    1ab4:	e8 46 fb ff ff       	call   15ff <free>
       q->size--;
    1ab9:	8b 45 08             	mov    0x8(%ebp),%eax
    1abc:	8b 00                	mov    (%eax),%eax
    1abe:	8d 50 ff             	lea    -0x1(%eax),%edx
    1ac1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac4:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ac6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac9:	8b 00                	mov    (%eax),%eax
    1acb:	85 c0                	test   %eax,%eax
    1acd:	75 14                	jne    1ae3 <pop_q+0x6d>
            q->head = 0;
    1acf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1ad9:	8b 45 08             	mov    0x8(%ebp),%eax
    1adc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae6:	eb 05                	jmp    1aed <pop_q+0x77>
    }
    return -1;
    1ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1aed:	c9                   	leave  
    1aee:	c3                   	ret    
