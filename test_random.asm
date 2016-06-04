
_test_random:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "user.h"


int main(){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
    printf(1,"random number %d\n",random(100));
    1009:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    1010:	e8 1a 0a 00 00       	call   1a2f <random>
    1015:	89 44 24 08          	mov    %eax,0x8(%esp)
    1019:	c7 44 24 04 1e 1c 00 	movl   $0x1c1e,0x4(%esp)
    1020:	00 
    1021:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1028:	e8 ad 04 00 00       	call   14da <printf>
    printf(1,"random number %d\n",random(100));
    102d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    1034:	e8 f6 09 00 00       	call   1a2f <random>
    1039:	89 44 24 08          	mov    %eax,0x8(%esp)
    103d:	c7 44 24 04 1e 1c 00 	movl   $0x1c1e,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104c:	e8 89 04 00 00       	call   14da <printf>
    printf(1,"random number %d\n",random(100));
    1051:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    1058:	e8 d2 09 00 00       	call   1a2f <random>
    105d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1061:	c7 44 24 04 1e 1c 00 	movl   $0x1c1e,0x4(%esp)
    1068:	00 
    1069:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1070:	e8 65 04 00 00       	call   14da <printf>
    printf(1,"random number %d\n",random(100));
    1075:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    107c:	e8 ae 09 00 00       	call   1a2f <random>
    1081:	89 44 24 08          	mov    %eax,0x8(%esp)
    1085:	c7 44 24 04 1e 1c 00 	movl   $0x1c1e,0x4(%esp)
    108c:	00 
    108d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1094:	e8 41 04 00 00       	call   14da <printf>
    printf(1,"random number %d\n",random(100));
    1099:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    10a0:	e8 8a 09 00 00       	call   1a2f <random>
    10a5:	89 44 24 08          	mov    %eax,0x8(%esp)
    10a9:	c7 44 24 04 1e 1c 00 	movl   $0x1c1e,0x4(%esp)
    10b0:	00 
    10b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b8:	e8 1d 04 00 00       	call   14da <printf>

    exit();
    10bd:	e8 68 02 00 00       	call   132a <exit>

000010c2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10c2:	55                   	push   %ebp
    10c3:	89 e5                	mov    %esp,%ebp
    10c5:	57                   	push   %edi
    10c6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10ca:	8b 55 10             	mov    0x10(%ebp),%edx
    10cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d0:	89 cb                	mov    %ecx,%ebx
    10d2:	89 df                	mov    %ebx,%edi
    10d4:	89 d1                	mov    %edx,%ecx
    10d6:	fc                   	cld    
    10d7:	f3 aa                	rep stos %al,%es:(%edi)
    10d9:	89 ca                	mov    %ecx,%edx
    10db:	89 fb                	mov    %edi,%ebx
    10dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10e0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10e3:	5b                   	pop    %ebx
    10e4:	5f                   	pop    %edi
    10e5:	5d                   	pop    %ebp
    10e6:	c3                   	ret    

000010e7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10e7:	55                   	push   %ebp
    10e8:	89 e5                	mov    %esp,%ebp
    10ea:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10ed:	8b 45 08             	mov    0x8(%ebp),%eax
    10f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10f3:	90                   	nop
    10f4:	8b 45 08             	mov    0x8(%ebp),%eax
    10f7:	8d 50 01             	lea    0x1(%eax),%edx
    10fa:	89 55 08             	mov    %edx,0x8(%ebp)
    10fd:	8b 55 0c             	mov    0xc(%ebp),%edx
    1100:	8d 4a 01             	lea    0x1(%edx),%ecx
    1103:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1106:	0f b6 12             	movzbl (%edx),%edx
    1109:	88 10                	mov    %dl,(%eax)
    110b:	0f b6 00             	movzbl (%eax),%eax
    110e:	84 c0                	test   %al,%al
    1110:	75 e2                	jne    10f4 <strcpy+0xd>
    ;
  return os;
    1112:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1115:	c9                   	leave  
    1116:	c3                   	ret    

00001117 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1117:	55                   	push   %ebp
    1118:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    111a:	eb 08                	jmp    1124 <strcmp+0xd>
    p++, q++;
    111c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1120:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	0f b6 00             	movzbl (%eax),%eax
    112a:	84 c0                	test   %al,%al
    112c:	74 10                	je     113e <strcmp+0x27>
    112e:	8b 45 08             	mov    0x8(%ebp),%eax
    1131:	0f b6 10             	movzbl (%eax),%edx
    1134:	8b 45 0c             	mov    0xc(%ebp),%eax
    1137:	0f b6 00             	movzbl (%eax),%eax
    113a:	38 c2                	cmp    %al,%dl
    113c:	74 de                	je     111c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    113e:	8b 45 08             	mov    0x8(%ebp),%eax
    1141:	0f b6 00             	movzbl (%eax),%eax
    1144:	0f b6 d0             	movzbl %al,%edx
    1147:	8b 45 0c             	mov    0xc(%ebp),%eax
    114a:	0f b6 00             	movzbl (%eax),%eax
    114d:	0f b6 c0             	movzbl %al,%eax
    1150:	29 c2                	sub    %eax,%edx
    1152:	89 d0                	mov    %edx,%eax
}
    1154:	5d                   	pop    %ebp
    1155:	c3                   	ret    

00001156 <strlen>:

uint
strlen(char *s)
{
    1156:	55                   	push   %ebp
    1157:	89 e5                	mov    %esp,%ebp
    1159:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    115c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1163:	eb 04                	jmp    1169 <strlen+0x13>
    1165:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1169:	8b 55 fc             	mov    -0x4(%ebp),%edx
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	01 d0                	add    %edx,%eax
    1171:	0f b6 00             	movzbl (%eax),%eax
    1174:	84 c0                	test   %al,%al
    1176:	75 ed                	jne    1165 <strlen+0xf>
    ;
  return n;
    1178:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    117b:	c9                   	leave  
    117c:	c3                   	ret    

0000117d <memset>:

void*
memset(void *dst, int c, uint n)
{
    117d:	55                   	push   %ebp
    117e:	89 e5                	mov    %esp,%ebp
    1180:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1183:	8b 45 10             	mov    0x10(%ebp),%eax
    1186:	89 44 24 08          	mov    %eax,0x8(%esp)
    118a:	8b 45 0c             	mov    0xc(%ebp),%eax
    118d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1191:	8b 45 08             	mov    0x8(%ebp),%eax
    1194:	89 04 24             	mov    %eax,(%esp)
    1197:	e8 26 ff ff ff       	call   10c2 <stosb>
  return dst;
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <strchr>:

char*
strchr(const char *s, char c)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
    11a4:	83 ec 04             	sub    $0x4,%esp
    11a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11aa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11ad:	eb 14                	jmp    11c3 <strchr+0x22>
    if(*s == c)
    11af:	8b 45 08             	mov    0x8(%ebp),%eax
    11b2:	0f b6 00             	movzbl (%eax),%eax
    11b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11b8:	75 05                	jne    11bf <strchr+0x1e>
      return (char*)s;
    11ba:	8b 45 08             	mov    0x8(%ebp),%eax
    11bd:	eb 13                	jmp    11d2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11c3:	8b 45 08             	mov    0x8(%ebp),%eax
    11c6:	0f b6 00             	movzbl (%eax),%eax
    11c9:	84 c0                	test   %al,%al
    11cb:	75 e2                	jne    11af <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11d2:	c9                   	leave  
    11d3:	c3                   	ret    

000011d4 <gets>:

char*
gets(char *buf, int max)
{
    11d4:	55                   	push   %ebp
    11d5:	89 e5                	mov    %esp,%ebp
    11d7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11e1:	eb 4c                	jmp    122f <gets+0x5b>
    cc = read(0, &c, 1);
    11e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11ea:	00 
    11eb:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11f9:	e8 44 01 00 00       	call   1342 <read>
    11fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1205:	7f 02                	jg     1209 <gets+0x35>
      break;
    1207:	eb 31                	jmp    123a <gets+0x66>
    buf[i++] = c;
    1209:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120c:	8d 50 01             	lea    0x1(%eax),%edx
    120f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1212:	89 c2                	mov    %eax,%edx
    1214:	8b 45 08             	mov    0x8(%ebp),%eax
    1217:	01 c2                	add    %eax,%edx
    1219:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    121d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    121f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1223:	3c 0a                	cmp    $0xa,%al
    1225:	74 13                	je     123a <gets+0x66>
    1227:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    122b:	3c 0d                	cmp    $0xd,%al
    122d:	74 0b                	je     123a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    122f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1232:	83 c0 01             	add    $0x1,%eax
    1235:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1238:	7c a9                	jl     11e3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    123d:	8b 45 08             	mov    0x8(%ebp),%eax
    1240:	01 d0                	add    %edx,%eax
    1242:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1245:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1248:	c9                   	leave  
    1249:	c3                   	ret    

0000124a <stat>:

int
stat(char *n, struct stat *st)
{
    124a:	55                   	push   %ebp
    124b:	89 e5                	mov    %esp,%ebp
    124d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1250:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1257:	00 
    1258:	8b 45 08             	mov    0x8(%ebp),%eax
    125b:	89 04 24             	mov    %eax,(%esp)
    125e:	e8 07 01 00 00       	call   136a <open>
    1263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    126a:	79 07                	jns    1273 <stat+0x29>
    return -1;
    126c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1271:	eb 23                	jmp    1296 <stat+0x4c>
  r = fstat(fd, st);
    1273:	8b 45 0c             	mov    0xc(%ebp),%eax
    1276:	89 44 24 04          	mov    %eax,0x4(%esp)
    127a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127d:	89 04 24             	mov    %eax,(%esp)
    1280:	e8 fd 00 00 00       	call   1382 <fstat>
    1285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128b:	89 04 24             	mov    %eax,(%esp)
    128e:	e8 bf 00 00 00       	call   1352 <close>
  return r;
    1293:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1296:	c9                   	leave  
    1297:	c3                   	ret    

00001298 <atoi>:

int
atoi(const char *s)
{
    1298:	55                   	push   %ebp
    1299:	89 e5                	mov    %esp,%ebp
    129b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    129e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12a5:	eb 25                	jmp    12cc <atoi+0x34>
    n = n*10 + *s++ - '0';
    12a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12aa:	89 d0                	mov    %edx,%eax
    12ac:	c1 e0 02             	shl    $0x2,%eax
    12af:	01 d0                	add    %edx,%eax
    12b1:	01 c0                	add    %eax,%eax
    12b3:	89 c1                	mov    %eax,%ecx
    12b5:	8b 45 08             	mov    0x8(%ebp),%eax
    12b8:	8d 50 01             	lea    0x1(%eax),%edx
    12bb:	89 55 08             	mov    %edx,0x8(%ebp)
    12be:	0f b6 00             	movzbl (%eax),%eax
    12c1:	0f be c0             	movsbl %al,%eax
    12c4:	01 c8                	add    %ecx,%eax
    12c6:	83 e8 30             	sub    $0x30,%eax
    12c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
    12cf:	0f b6 00             	movzbl (%eax),%eax
    12d2:	3c 2f                	cmp    $0x2f,%al
    12d4:	7e 0a                	jle    12e0 <atoi+0x48>
    12d6:	8b 45 08             	mov    0x8(%ebp),%eax
    12d9:	0f b6 00             	movzbl (%eax),%eax
    12dc:	3c 39                	cmp    $0x39,%al
    12de:	7e c7                	jle    12a7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
    12e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12eb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12f7:	eb 17                	jmp    1310 <memmove+0x2b>
    *dst++ = *src++;
    12f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fc:	8d 50 01             	lea    0x1(%eax),%edx
    12ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1302:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1305:	8d 4a 01             	lea    0x1(%edx),%ecx
    1308:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    130b:	0f b6 12             	movzbl (%edx),%edx
    130e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1310:	8b 45 10             	mov    0x10(%ebp),%eax
    1313:	8d 50 ff             	lea    -0x1(%eax),%edx
    1316:	89 55 10             	mov    %edx,0x10(%ebp)
    1319:	85 c0                	test   %eax,%eax
    131b:	7f dc                	jg     12f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    131d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1320:	c9                   	leave  
    1321:	c3                   	ret    

00001322 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1322:	b8 01 00 00 00       	mov    $0x1,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <exit>:
SYSCALL(exit)
    132a:	b8 02 00 00 00       	mov    $0x2,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <wait>:
SYSCALL(wait)
    1332:	b8 03 00 00 00       	mov    $0x3,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <pipe>:
SYSCALL(pipe)
    133a:	b8 04 00 00 00       	mov    $0x4,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <read>:
SYSCALL(read)
    1342:	b8 05 00 00 00       	mov    $0x5,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <write>:
SYSCALL(write)
    134a:	b8 10 00 00 00       	mov    $0x10,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <close>:
SYSCALL(close)
    1352:	b8 15 00 00 00       	mov    $0x15,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <kill>:
SYSCALL(kill)
    135a:	b8 06 00 00 00       	mov    $0x6,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <exec>:
SYSCALL(exec)
    1362:	b8 07 00 00 00       	mov    $0x7,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <open>:
SYSCALL(open)
    136a:	b8 0f 00 00 00       	mov    $0xf,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <mknod>:
SYSCALL(mknod)
    1372:	b8 11 00 00 00       	mov    $0x11,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <unlink>:
SYSCALL(unlink)
    137a:	b8 12 00 00 00       	mov    $0x12,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <fstat>:
SYSCALL(fstat)
    1382:	b8 08 00 00 00       	mov    $0x8,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <link>:
SYSCALL(link)
    138a:	b8 13 00 00 00       	mov    $0x13,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <mkdir>:
SYSCALL(mkdir)
    1392:	b8 14 00 00 00       	mov    $0x14,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <chdir>:
SYSCALL(chdir)
    139a:	b8 09 00 00 00       	mov    $0x9,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <dup>:
SYSCALL(dup)
    13a2:	b8 0a 00 00 00       	mov    $0xa,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <getpid>:
SYSCALL(getpid)
    13aa:	b8 0b 00 00 00       	mov    $0xb,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <sbrk>:
SYSCALL(sbrk)
    13b2:	b8 0c 00 00 00       	mov    $0xc,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <sleep>:
SYSCALL(sleep)
    13ba:	b8 0d 00 00 00       	mov    $0xd,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <uptime>:
SYSCALL(uptime)
    13c2:	b8 0e 00 00 00       	mov    $0xe,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <clone>:
SYSCALL(clone)
    13ca:	b8 16 00 00 00       	mov    $0x16,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <texit>:
SYSCALL(texit)
    13d2:	b8 17 00 00 00       	mov    $0x17,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <tsleep>:
SYSCALL(tsleep)
    13da:	b8 18 00 00 00       	mov    $0x18,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <twakeup>:
SYSCALL(twakeup)
    13e2:	b8 19 00 00 00       	mov    $0x19,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <thread_yield>:
SYSCALL(thread_yield)
    13ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <thread_yield3>:
    13f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13fa:	55                   	push   %ebp
    13fb:	89 e5                	mov    %esp,%ebp
    13fd:	83 ec 18             	sub    $0x18,%esp
    1400:	8b 45 0c             	mov    0xc(%ebp),%eax
    1403:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1406:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    140d:	00 
    140e:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1411:	89 44 24 04          	mov    %eax,0x4(%esp)
    1415:	8b 45 08             	mov    0x8(%ebp),%eax
    1418:	89 04 24             	mov    %eax,(%esp)
    141b:	e8 2a ff ff ff       	call   134a <write>
}
    1420:	c9                   	leave  
    1421:	c3                   	ret    

00001422 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1422:	55                   	push   %ebp
    1423:	89 e5                	mov    %esp,%ebp
    1425:	56                   	push   %esi
    1426:	53                   	push   %ebx
    1427:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    142a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1431:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1435:	74 17                	je     144e <printint+0x2c>
    1437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    143b:	79 11                	jns    144e <printint+0x2c>
    neg = 1;
    143d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1444:	8b 45 0c             	mov    0xc(%ebp),%eax
    1447:	f7 d8                	neg    %eax
    1449:	89 45 ec             	mov    %eax,-0x14(%ebp)
    144c:	eb 06                	jmp    1454 <printint+0x32>
  } else {
    x = xx;
    144e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1451:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    145b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    145e:	8d 41 01             	lea    0x1(%ecx),%eax
    1461:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1464:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1467:	8b 45 ec             	mov    -0x14(%ebp),%eax
    146a:	ba 00 00 00 00       	mov    $0x0,%edx
    146f:	f7 f3                	div    %ebx
    1471:	89 d0                	mov    %edx,%eax
    1473:	0f b6 80 40 20 00 00 	movzbl 0x2040(%eax),%eax
    147a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    147e:	8b 75 10             	mov    0x10(%ebp),%esi
    1481:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1484:	ba 00 00 00 00       	mov    $0x0,%edx
    1489:	f7 f6                	div    %esi
    148b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    148e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1492:	75 c7                	jne    145b <printint+0x39>
  if(neg)
    1494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1498:	74 10                	je     14aa <printint+0x88>
    buf[i++] = '-';
    149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149d:	8d 50 01             	lea    0x1(%eax),%edx
    14a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14a3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14a8:	eb 1f                	jmp    14c9 <printint+0xa7>
    14aa:	eb 1d                	jmp    14c9 <printint+0xa7>
    putc(fd, buf[i]);
    14ac:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b2:	01 d0                	add    %edx,%eax
    14b4:	0f b6 00             	movzbl (%eax),%eax
    14b7:	0f be c0             	movsbl %al,%eax
    14ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    14be:	8b 45 08             	mov    0x8(%ebp),%eax
    14c1:	89 04 24             	mov    %eax,(%esp)
    14c4:	e8 31 ff ff ff       	call   13fa <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    14cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14d1:	79 d9                	jns    14ac <printint+0x8a>
    putc(fd, buf[i]);
}
    14d3:	83 c4 30             	add    $0x30,%esp
    14d6:	5b                   	pop    %ebx
    14d7:	5e                   	pop    %esi
    14d8:	5d                   	pop    %ebp
    14d9:	c3                   	ret    

000014da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14da:	55                   	push   %ebp
    14db:	89 e5                	mov    %esp,%ebp
    14dd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14e7:	8d 45 0c             	lea    0xc(%ebp),%eax
    14ea:	83 c0 04             	add    $0x4,%eax
    14ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14f7:	e9 7c 01 00 00       	jmp    1678 <printf+0x19e>
    c = fmt[i] & 0xff;
    14fc:	8b 55 0c             	mov    0xc(%ebp),%edx
    14ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1502:	01 d0                	add    %edx,%eax
    1504:	0f b6 00             	movzbl (%eax),%eax
    1507:	0f be c0             	movsbl %al,%eax
    150a:	25 ff 00 00 00       	and    $0xff,%eax
    150f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1516:	75 2c                	jne    1544 <printf+0x6a>
      if(c == '%'){
    1518:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    151c:	75 0c                	jne    152a <printf+0x50>
        state = '%';
    151e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1525:	e9 4a 01 00 00       	jmp    1674 <printf+0x19a>
      } else {
        putc(fd, c);
    152a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    152d:	0f be c0             	movsbl %al,%eax
    1530:	89 44 24 04          	mov    %eax,0x4(%esp)
    1534:	8b 45 08             	mov    0x8(%ebp),%eax
    1537:	89 04 24             	mov    %eax,(%esp)
    153a:	e8 bb fe ff ff       	call   13fa <putc>
    153f:	e9 30 01 00 00       	jmp    1674 <printf+0x19a>
      }
    } else if(state == '%'){
    1544:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1548:	0f 85 26 01 00 00    	jne    1674 <printf+0x19a>
      if(c == 'd'){
    154e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1552:	75 2d                	jne    1581 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1554:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1557:	8b 00                	mov    (%eax),%eax
    1559:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1560:	00 
    1561:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1568:	00 
    1569:	89 44 24 04          	mov    %eax,0x4(%esp)
    156d:	8b 45 08             	mov    0x8(%ebp),%eax
    1570:	89 04 24             	mov    %eax,(%esp)
    1573:	e8 aa fe ff ff       	call   1422 <printint>
        ap++;
    1578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    157c:	e9 ec 00 00 00       	jmp    166d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1581:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1585:	74 06                	je     158d <printf+0xb3>
    1587:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    158b:	75 2d                	jne    15ba <printf+0xe0>
        printint(fd, *ap, 16, 0);
    158d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1590:	8b 00                	mov    (%eax),%eax
    1592:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1599:	00 
    159a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15a1:	00 
    15a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a6:	8b 45 08             	mov    0x8(%ebp),%eax
    15a9:	89 04 24             	mov    %eax,(%esp)
    15ac:	e8 71 fe ff ff       	call   1422 <printint>
        ap++;
    15b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15b5:	e9 b3 00 00 00       	jmp    166d <printf+0x193>
      } else if(c == 's'){
    15ba:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15be:	75 45                	jne    1605 <printf+0x12b>
        s = (char*)*ap;
    15c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c3:	8b 00                	mov    (%eax),%eax
    15c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15d0:	75 09                	jne    15db <printf+0x101>
          s = "(null)";
    15d2:	c7 45 f4 30 1c 00 00 	movl   $0x1c30,-0xc(%ebp)
        while(*s != 0){
    15d9:	eb 1e                	jmp    15f9 <printf+0x11f>
    15db:	eb 1c                	jmp    15f9 <printf+0x11f>
          putc(fd, *s);
    15dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e0:	0f b6 00             	movzbl (%eax),%eax
    15e3:	0f be c0             	movsbl %al,%eax
    15e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ea:	8b 45 08             	mov    0x8(%ebp),%eax
    15ed:	89 04 24             	mov    %eax,(%esp)
    15f0:	e8 05 fe ff ff       	call   13fa <putc>
          s++;
    15f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fc:	0f b6 00             	movzbl (%eax),%eax
    15ff:	84 c0                	test   %al,%al
    1601:	75 da                	jne    15dd <printf+0x103>
    1603:	eb 68                	jmp    166d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1605:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1609:	75 1d                	jne    1628 <printf+0x14e>
        putc(fd, *ap);
    160b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    160e:	8b 00                	mov    (%eax),%eax
    1610:	0f be c0             	movsbl %al,%eax
    1613:	89 44 24 04          	mov    %eax,0x4(%esp)
    1617:	8b 45 08             	mov    0x8(%ebp),%eax
    161a:	89 04 24             	mov    %eax,(%esp)
    161d:	e8 d8 fd ff ff       	call   13fa <putc>
        ap++;
    1622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1626:	eb 45                	jmp    166d <printf+0x193>
      } else if(c == '%'){
    1628:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    162c:	75 17                	jne    1645 <printf+0x16b>
        putc(fd, c);
    162e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1631:	0f be c0             	movsbl %al,%eax
    1634:	89 44 24 04          	mov    %eax,0x4(%esp)
    1638:	8b 45 08             	mov    0x8(%ebp),%eax
    163b:	89 04 24             	mov    %eax,(%esp)
    163e:	e8 b7 fd ff ff       	call   13fa <putc>
    1643:	eb 28                	jmp    166d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1645:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    164c:	00 
    164d:	8b 45 08             	mov    0x8(%ebp),%eax
    1650:	89 04 24             	mov    %eax,(%esp)
    1653:	e8 a2 fd ff ff       	call   13fa <putc>
        putc(fd, c);
    1658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    165b:	0f be c0             	movsbl %al,%eax
    165e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1662:	8b 45 08             	mov    0x8(%ebp),%eax
    1665:	89 04 24             	mov    %eax,(%esp)
    1668:	e8 8d fd ff ff       	call   13fa <putc>
      }
      state = 0;
    166d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1674:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1678:	8b 55 0c             	mov    0xc(%ebp),%edx
    167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    167e:	01 d0                	add    %edx,%eax
    1680:	0f b6 00             	movzbl (%eax),%eax
    1683:	84 c0                	test   %al,%al
    1685:	0f 85 71 fe ff ff    	jne    14fc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    168b:	c9                   	leave  
    168c:	c3                   	ret    

0000168d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    168d:	55                   	push   %ebp
    168e:	89 e5                	mov    %esp,%ebp
    1690:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1693:	8b 45 08             	mov    0x8(%ebp),%eax
    1696:	83 e8 08             	sub    $0x8,%eax
    1699:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    169c:	a1 60 20 00 00       	mov    0x2060,%eax
    16a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16a4:	eb 24                	jmp    16ca <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a9:	8b 00                	mov    (%eax),%eax
    16ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16ae:	77 12                	ja     16c2 <free+0x35>
    16b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16b6:	77 24                	ja     16dc <free+0x4f>
    16b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bb:	8b 00                	mov    (%eax),%eax
    16bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16c0:	77 1a                	ja     16dc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c5:	8b 00                	mov    (%eax),%eax
    16c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16d0:	76 d4                	jbe    16a6 <free+0x19>
    16d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d5:	8b 00                	mov    (%eax),%eax
    16d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16da:	76 ca                	jbe    16a6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16df:	8b 40 04             	mov    0x4(%eax),%eax
    16e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ec:	01 c2                	add    %eax,%edx
    16ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f1:	8b 00                	mov    (%eax),%eax
    16f3:	39 c2                	cmp    %eax,%edx
    16f5:	75 24                	jne    171b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fa:	8b 50 04             	mov    0x4(%eax),%edx
    16fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1700:	8b 00                	mov    (%eax),%eax
    1702:	8b 40 04             	mov    0x4(%eax),%eax
    1705:	01 c2                	add    %eax,%edx
    1707:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    170d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1710:	8b 00                	mov    (%eax),%eax
    1712:	8b 10                	mov    (%eax),%edx
    1714:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1717:	89 10                	mov    %edx,(%eax)
    1719:	eb 0a                	jmp    1725 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    171b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171e:	8b 10                	mov    (%eax),%edx
    1720:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1723:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1725:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1728:	8b 40 04             	mov    0x4(%eax),%eax
    172b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1732:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1735:	01 d0                	add    %edx,%eax
    1737:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    173a:	75 20                	jne    175c <free+0xcf>
    p->s.size += bp->s.size;
    173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173f:	8b 50 04             	mov    0x4(%eax),%edx
    1742:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1745:	8b 40 04             	mov    0x4(%eax),%eax
    1748:	01 c2                	add    %eax,%edx
    174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1750:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1753:	8b 10                	mov    (%eax),%edx
    1755:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1758:	89 10                	mov    %edx,(%eax)
    175a:	eb 08                	jmp    1764 <free+0xd7>
  } else
    p->s.ptr = bp;
    175c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1762:	89 10                	mov    %edx,(%eax)
  freep = p;
    1764:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1767:	a3 60 20 00 00       	mov    %eax,0x2060
}
    176c:	c9                   	leave  
    176d:	c3                   	ret    

0000176e <morecore>:

static Header*
morecore(uint nu)
{
    176e:	55                   	push   %ebp
    176f:	89 e5                	mov    %esp,%ebp
    1771:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1774:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    177b:	77 07                	ja     1784 <morecore+0x16>
    nu = 4096;
    177d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1784:	8b 45 08             	mov    0x8(%ebp),%eax
    1787:	c1 e0 03             	shl    $0x3,%eax
    178a:	89 04 24             	mov    %eax,(%esp)
    178d:	e8 20 fc ff ff       	call   13b2 <sbrk>
    1792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1795:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1799:	75 07                	jne    17a2 <morecore+0x34>
    return 0;
    179b:	b8 00 00 00 00       	mov    $0x0,%eax
    17a0:	eb 22                	jmp    17c4 <morecore+0x56>
  hp = (Header*)p;
    17a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ab:	8b 55 08             	mov    0x8(%ebp),%edx
    17ae:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b4:	83 c0 08             	add    $0x8,%eax
    17b7:	89 04 24             	mov    %eax,(%esp)
    17ba:	e8 ce fe ff ff       	call   168d <free>
  return freep;
    17bf:	a1 60 20 00 00       	mov    0x2060,%eax
}
    17c4:	c9                   	leave  
    17c5:	c3                   	ret    

000017c6 <malloc>:

void*
malloc(uint nbytes)
{
    17c6:	55                   	push   %ebp
    17c7:	89 e5                	mov    %esp,%ebp
    17c9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17cc:	8b 45 08             	mov    0x8(%ebp),%eax
    17cf:	83 c0 07             	add    $0x7,%eax
    17d2:	c1 e8 03             	shr    $0x3,%eax
    17d5:	83 c0 01             	add    $0x1,%eax
    17d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17db:	a1 60 20 00 00       	mov    0x2060,%eax
    17e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17e7:	75 23                	jne    180c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17e9:	c7 45 f0 58 20 00 00 	movl   $0x2058,-0x10(%ebp)
    17f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f3:	a3 60 20 00 00       	mov    %eax,0x2060
    17f8:	a1 60 20 00 00       	mov    0x2060,%eax
    17fd:	a3 58 20 00 00       	mov    %eax,0x2058
    base.s.size = 0;
    1802:	c7 05 5c 20 00 00 00 	movl   $0x0,0x205c
    1809:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180f:	8b 00                	mov    (%eax),%eax
    1811:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1814:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1817:	8b 40 04             	mov    0x4(%eax),%eax
    181a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    181d:	72 4d                	jb     186c <malloc+0xa6>
      if(p->s.size == nunits)
    181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1822:	8b 40 04             	mov    0x4(%eax),%eax
    1825:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1828:	75 0c                	jne    1836 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182d:	8b 10                	mov    (%eax),%edx
    182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1832:	89 10                	mov    %edx,(%eax)
    1834:	eb 26                	jmp    185c <malloc+0x96>
      else {
        p->s.size -= nunits;
    1836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1839:	8b 40 04             	mov    0x4(%eax),%eax
    183c:	2b 45 ec             	sub    -0x14(%ebp),%eax
    183f:	89 c2                	mov    %eax,%edx
    1841:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1844:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1847:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184a:	8b 40 04             	mov    0x4(%eax),%eax
    184d:	c1 e0 03             	shl    $0x3,%eax
    1850:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1853:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1856:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1859:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185f:	a3 60 20 00 00       	mov    %eax,0x2060
      return (void*)(p + 1);
    1864:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1867:	83 c0 08             	add    $0x8,%eax
    186a:	eb 38                	jmp    18a4 <malloc+0xde>
    }
    if(p == freep)
    186c:	a1 60 20 00 00       	mov    0x2060,%eax
    1871:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1874:	75 1b                	jne    1891 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1876:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1879:	89 04 24             	mov    %eax,(%esp)
    187c:	e8 ed fe ff ff       	call   176e <morecore>
    1881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1888:	75 07                	jne    1891 <malloc+0xcb>
        return 0;
    188a:	b8 00 00 00 00       	mov    $0x0,%eax
    188f:	eb 13                	jmp    18a4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1897:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189a:	8b 00                	mov    (%eax),%eax
    189c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    189f:	e9 70 ff ff ff       	jmp    1814 <malloc+0x4e>
}
    18a4:	c9                   	leave  
    18a5:	c3                   	ret    

000018a6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18a6:	55                   	push   %ebp
    18a7:	89 e5                	mov    %esp,%ebp
    18a9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    18ac:	8b 55 08             	mov    0x8(%ebp),%edx
    18af:	8b 45 0c             	mov    0xc(%ebp),%eax
    18b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    18b5:	f0 87 02             	lock xchg %eax,(%edx)
    18b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    18bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    18be:	c9                   	leave  
    18bf:	c3                   	ret    

000018c0 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    18c0:	55                   	push   %ebp
    18c1:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    18c3:	8b 45 08             	mov    0x8(%ebp),%eax
    18c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    18cc:	5d                   	pop    %ebp
    18cd:	c3                   	ret    

000018ce <lock_acquire>:
void lock_acquire(lock_t *lock){
    18ce:	55                   	push   %ebp
    18cf:	89 e5                	mov    %esp,%ebp
    18d1:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    18d4:	90                   	nop
    18d5:	8b 45 08             	mov    0x8(%ebp),%eax
    18d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18df:	00 
    18e0:	89 04 24             	mov    %eax,(%esp)
    18e3:	e8 be ff ff ff       	call   18a6 <xchg>
    18e8:	85 c0                	test   %eax,%eax
    18ea:	75 e9                	jne    18d5 <lock_acquire+0x7>
}
    18ec:	c9                   	leave  
    18ed:	c3                   	ret    

000018ee <lock_release>:
void lock_release(lock_t *lock){
    18ee:	55                   	push   %ebp
    18ef:	89 e5                	mov    %esp,%ebp
    18f1:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    18f4:	8b 45 08             	mov    0x8(%ebp),%eax
    18f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18fe:	00 
    18ff:	89 04 24             	mov    %eax,(%esp)
    1902:	e8 9f ff ff ff       	call   18a6 <xchg>
}
    1907:	c9                   	leave  
    1908:	c3                   	ret    

00001909 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1909:	55                   	push   %ebp
    190a:	89 e5                	mov    %esp,%ebp
    190c:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    190f:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1916:	e8 ab fe ff ff       	call   17c6 <malloc>
    191b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1921:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1924:	0f b6 05 64 20 00 00 	movzbl 0x2064,%eax
    192b:	84 c0                	test   %al,%al
    192d:	75 1c                	jne    194b <thread_create+0x42>
        init_q(thQ2);
    192f:	a1 6c 20 00 00       	mov    0x206c,%eax
    1934:	89 04 24             	mov    %eax,(%esp)
    1937:	e8 cd 01 00 00       	call   1b09 <init_q>
        inQ++;
    193c:	0f b6 05 64 20 00 00 	movzbl 0x2064,%eax
    1943:	83 c0 01             	add    $0x1,%eax
    1946:	a2 64 20 00 00       	mov    %al,0x2064
    }

    if((uint)stack % 4096){
    194b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194e:	25 ff 0f 00 00       	and    $0xfff,%eax
    1953:	85 c0                	test   %eax,%eax
    1955:	74 14                	je     196b <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1957:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195a:	25 ff 0f 00 00       	and    $0xfff,%eax
    195f:	89 c2                	mov    %eax,%edx
    1961:	b8 00 10 00 00       	mov    $0x1000,%eax
    1966:	29 d0                	sub    %edx,%eax
    1968:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    196b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    196f:	75 1e                	jne    198f <thread_create+0x86>

        printf(1,"malloc fail \n");
    1971:	c7 44 24 04 37 1c 00 	movl   $0x1c37,0x4(%esp)
    1978:	00 
    1979:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1980:	e8 55 fb ff ff       	call   14da <printf>
        return 0;
    1985:	b8 00 00 00 00       	mov    $0x0,%eax
    198a:	e9 9e 00 00 00       	jmp    1a2d <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    198f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1992:	8b 55 08             	mov    0x8(%ebp),%edx
    1995:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1998:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    199c:	89 54 24 08          	mov    %edx,0x8(%esp)
    19a0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    19a7:	00 
    19a8:	89 04 24             	mov    %eax,(%esp)
    19ab:	e8 1a fa ff ff       	call   13ca <clone>
    19b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    19b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    19b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    19ba:	c7 44 24 04 45 1c 00 	movl   $0x1c45,0x4(%esp)
    19c1:	00 
    19c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19c9:	e8 0c fb ff ff       	call   14da <printf>
    if(tid < 0){
    19ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19d2:	79 1b                	jns    19ef <thread_create+0xe6>
        printf(1,"clone fails\n");
    19d4:	c7 44 24 04 5e 1c 00 	movl   $0x1c5e,0x4(%esp)
    19db:	00 
    19dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19e3:	e8 f2 fa ff ff       	call   14da <printf>
        return 0;
    19e8:	b8 00 00 00 00       	mov    $0x0,%eax
    19ed:	eb 3e                	jmp    1a2d <thread_create+0x124>
    }
    if(tid > 0){
    19ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19f3:	7e 19                	jle    1a0e <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    19f5:	a1 6c 20 00 00       	mov    0x206c,%eax
    19fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19fd:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a01:	89 04 24             	mov    %eax,(%esp)
    1a04:	e8 22 01 00 00       	call   1b2b <add_q>
        return garbage_stack;
    1a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a0c:	eb 1f                	jmp    1a2d <thread_create+0x124>
    }
    if(tid == 0){
    1a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a12:	75 14                	jne    1a28 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1a14:	c7 44 24 04 6b 1c 00 	movl   $0x1c6b,0x4(%esp)
    1a1b:	00 
    1a1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a23:	e8 b2 fa ff ff       	call   14da <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a2d:	c9                   	leave  
    1a2e:	c3                   	ret    

00001a2f <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a2f:	55                   	push   %ebp
    1a30:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a32:	a1 54 20 00 00       	mov    0x2054,%eax
    1a37:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a3d:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a42:	a3 54 20 00 00       	mov    %eax,0x2054
    return (int)(rands % max);
    1a47:	a1 54 20 00 00       	mov    0x2054,%eax
    1a4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a4f:	ba 00 00 00 00       	mov    $0x0,%edx
    1a54:	f7 f1                	div    %ecx
    1a56:	89 d0                	mov    %edx,%eax
}
    1a58:	5d                   	pop    %ebp
    1a59:	c3                   	ret    

00001a5a <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a5a:	55                   	push   %ebp
    1a5b:	89 e5                	mov    %esp,%ebp
    1a5d:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a60:	e8 45 f9 ff ff       	call   13aa <getpid>
    1a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a68:	a1 6c 20 00 00       	mov    0x206c,%eax
    1a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a70:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a74:	89 04 24             	mov    %eax,(%esp)
    1a77:	e8 af 00 00 00       	call   1b2b <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a7c:	a1 6c 20 00 00       	mov    0x206c,%eax
    1a81:	89 04 24             	mov    %eax,(%esp)
    1a84:	e8 1c 01 00 00       	call   1ba5 <pop_q>
    1a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a8c:	a1 68 20 00 00       	mov    0x2068,%eax
    1a91:	85 c0                	test   %eax,%eax
    1a93:	75 1f                	jne    1ab4 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a95:	a1 6c 20 00 00       	mov    0x206c,%eax
    1a9a:	89 04 24             	mov    %eax,(%esp)
    1a9d:	e8 03 01 00 00       	call   1ba5 <pop_q>
    1aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1aa5:	a1 68 20 00 00       	mov    0x2068,%eax
    1aaa:	83 c0 01             	add    $0x1,%eax
    1aad:	a3 68 20 00 00       	mov    %eax,0x2068
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1ab2:	eb 12                	jmp    1ac6 <thread_yield2+0x6c>
    1ab4:	eb 10                	jmp    1ac6 <thread_yield2+0x6c>
    1ab6:	a1 6c 20 00 00       	mov    0x206c,%eax
    1abb:	89 04 24             	mov    %eax,(%esp)
    1abe:	e8 e2 00 00 00       	call   1ba5 <pop_q>
    1ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ac9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1acc:	74 e8                	je     1ab6 <thread_yield2+0x5c>
    1ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ad2:	74 e2                	je     1ab6 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad7:	89 04 24             	mov    %eax,(%esp)
    1ada:	e8 03 f9 ff ff       	call   13e2 <twakeup>
    tsleep();
    1adf:	e8 f6 f8 ff ff       	call   13da <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1ae4:	c9                   	leave  
    1ae5:	c3                   	ret    

00001ae6 <thread_yield_last>:

void thread_yield_last(){
    1ae6:	55                   	push   %ebp
    1ae7:	89 e5                	mov    %esp,%ebp
    1ae9:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1aec:	a1 6c 20 00 00       	mov    0x206c,%eax
    1af1:	89 04 24             	mov    %eax,(%esp)
    1af4:	e8 ac 00 00 00       	call   1ba5 <pop_q>
    1af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aff:	89 04 24             	mov    %eax,(%esp)
    1b02:	e8 db f8 ff ff       	call   13e2 <twakeup>
    1b07:	c9                   	leave  
    1b08:	c3                   	ret    

00001b09 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b09:	55                   	push   %ebp
    1b0a:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b15:	8b 45 08             	mov    0x8(%ebp),%eax
    1b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1b1f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1b29:	5d                   	pop    %ebp
    1b2a:	c3                   	ret    

00001b2b <add_q>:

void add_q(struct queue *q, int v){
    1b2b:	55                   	push   %ebp
    1b2c:	89 e5                	mov    %esp,%ebp
    1b2e:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1b31:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1b38:	e8 89 fc ff ff       	call   17c6 <malloc>
    1b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b50:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b52:	8b 45 08             	mov    0x8(%ebp),%eax
    1b55:	8b 40 04             	mov    0x4(%eax),%eax
    1b58:	85 c0                	test   %eax,%eax
    1b5a:	75 0b                	jne    1b67 <add_q+0x3c>
        q->head = n;
    1b5c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b62:	89 50 04             	mov    %edx,0x4(%eax)
    1b65:	eb 0c                	jmp    1b73 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b67:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6a:	8b 40 08             	mov    0x8(%eax),%eax
    1b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b70:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b73:	8b 45 08             	mov    0x8(%ebp),%eax
    1b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b79:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b7c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7f:	8b 00                	mov    (%eax),%eax
    1b81:	8d 50 01             	lea    0x1(%eax),%edx
    1b84:	8b 45 08             	mov    0x8(%ebp),%eax
    1b87:	89 10                	mov    %edx,(%eax)
}
    1b89:	c9                   	leave  
    1b8a:	c3                   	ret    

00001b8b <empty_q>:

int empty_q(struct queue *q){
    1b8b:	55                   	push   %ebp
    1b8c:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b8e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b91:	8b 00                	mov    (%eax),%eax
    1b93:	85 c0                	test   %eax,%eax
    1b95:	75 07                	jne    1b9e <empty_q+0x13>
        return 1;
    1b97:	b8 01 00 00 00       	mov    $0x1,%eax
    1b9c:	eb 05                	jmp    1ba3 <empty_q+0x18>
    else
        return 0;
    1b9e:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1ba3:	5d                   	pop    %ebp
    1ba4:	c3                   	ret    

00001ba5 <pop_q>:
int pop_q(struct queue *q){
    1ba5:	55                   	push   %ebp
    1ba6:	89 e5                	mov    %esp,%ebp
    1ba8:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1bab:	8b 45 08             	mov    0x8(%ebp),%eax
    1bae:	89 04 24             	mov    %eax,(%esp)
    1bb1:	e8 d5 ff ff ff       	call   1b8b <empty_q>
    1bb6:	85 c0                	test   %eax,%eax
    1bb8:	75 5d                	jne    1c17 <pop_q+0x72>
       val = q->head->value; 
    1bba:	8b 45 08             	mov    0x8(%ebp),%eax
    1bbd:	8b 40 04             	mov    0x4(%eax),%eax
    1bc0:	8b 00                	mov    (%eax),%eax
    1bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1bc5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc8:	8b 40 04             	mov    0x4(%eax),%eax
    1bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1bce:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd1:	8b 40 04             	mov    0x4(%eax),%eax
    1bd4:	8b 50 04             	mov    0x4(%eax),%edx
    1bd7:	8b 45 08             	mov    0x8(%ebp),%eax
    1bda:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be0:	89 04 24             	mov    %eax,(%esp)
    1be3:	e8 a5 fa ff ff       	call   168d <free>
       q->size--;
    1be8:	8b 45 08             	mov    0x8(%ebp),%eax
    1beb:	8b 00                	mov    (%eax),%eax
    1bed:	8d 50 ff             	lea    -0x1(%eax),%edx
    1bf0:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf3:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1bf5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf8:	8b 00                	mov    (%eax),%eax
    1bfa:	85 c0                	test   %eax,%eax
    1bfc:	75 14                	jne    1c12 <pop_q+0x6d>
            q->head = 0;
    1bfe:	8b 45 08             	mov    0x8(%ebp),%eax
    1c01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c08:	8b 45 08             	mov    0x8(%ebp),%eax
    1c0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c15:	eb 05                	jmp    1c1c <pop_q+0x77>
    }
    return -1;
    1c17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1c1c:	c9                   	leave  
    1c1d:	c3                   	ret    
