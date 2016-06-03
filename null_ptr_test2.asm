
_null_ptr_test2:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
   int *ptr = 0;
    1009:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1010:	00 
   *ptr = 10;
    1011:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1015:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
   printf(1,"Change val at NULL addr\n");
    101b:	c7 44 24 04 f1 1a 00 	movl   $0x1af1,0x4(%esp)
    1022:	00 
    1023:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    102a:	e8 1f 04 00 00       	call   144e <printf>
   return 0;
    102f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1034:	c9                   	leave  
    1035:	c3                   	ret    

00001036 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1036:	55                   	push   %ebp
    1037:	89 e5                	mov    %esp,%ebp
    1039:	57                   	push   %edi
    103a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    103b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    103e:	8b 55 10             	mov    0x10(%ebp),%edx
    1041:	8b 45 0c             	mov    0xc(%ebp),%eax
    1044:	89 cb                	mov    %ecx,%ebx
    1046:	89 df                	mov    %ebx,%edi
    1048:	89 d1                	mov    %edx,%ecx
    104a:	fc                   	cld    
    104b:	f3 aa                	rep stos %al,%es:(%edi)
    104d:	89 ca                	mov    %ecx,%edx
    104f:	89 fb                	mov    %edi,%ebx
    1051:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1054:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1057:	5b                   	pop    %ebx
    1058:	5f                   	pop    %edi
    1059:	5d                   	pop    %ebp
    105a:	c3                   	ret    

0000105b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    105b:	55                   	push   %ebp
    105c:	89 e5                	mov    %esp,%ebp
    105e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1061:	8b 45 08             	mov    0x8(%ebp),%eax
    1064:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1067:	90                   	nop
    1068:	8b 45 08             	mov    0x8(%ebp),%eax
    106b:	8d 50 01             	lea    0x1(%eax),%edx
    106e:	89 55 08             	mov    %edx,0x8(%ebp)
    1071:	8b 55 0c             	mov    0xc(%ebp),%edx
    1074:	8d 4a 01             	lea    0x1(%edx),%ecx
    1077:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    107a:	0f b6 12             	movzbl (%edx),%edx
    107d:	88 10                	mov    %dl,(%eax)
    107f:	0f b6 00             	movzbl (%eax),%eax
    1082:	84 c0                	test   %al,%al
    1084:	75 e2                	jne    1068 <strcpy+0xd>
    ;
  return os;
    1086:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1089:	c9                   	leave  
    108a:	c3                   	ret    

0000108b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    108b:	55                   	push   %ebp
    108c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    108e:	eb 08                	jmp    1098 <strcmp+0xd>
    p++, q++;
    1090:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1094:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1098:	8b 45 08             	mov    0x8(%ebp),%eax
    109b:	0f b6 00             	movzbl (%eax),%eax
    109e:	84 c0                	test   %al,%al
    10a0:	74 10                	je     10b2 <strcmp+0x27>
    10a2:	8b 45 08             	mov    0x8(%ebp),%eax
    10a5:	0f b6 10             	movzbl (%eax),%edx
    10a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ab:	0f b6 00             	movzbl (%eax),%eax
    10ae:	38 c2                	cmp    %al,%dl
    10b0:	74 de                	je     1090 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10b2:	8b 45 08             	mov    0x8(%ebp),%eax
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	0f b6 d0             	movzbl %al,%edx
    10bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10be:	0f b6 00             	movzbl (%eax),%eax
    10c1:	0f b6 c0             	movzbl %al,%eax
    10c4:	29 c2                	sub    %eax,%edx
    10c6:	89 d0                	mov    %edx,%eax
}
    10c8:	5d                   	pop    %ebp
    10c9:	c3                   	ret    

000010ca <strlen>:

uint
strlen(char *s)
{
    10ca:	55                   	push   %ebp
    10cb:	89 e5                	mov    %esp,%ebp
    10cd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10d7:	eb 04                	jmp    10dd <strlen+0x13>
    10d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10e0:	8b 45 08             	mov    0x8(%ebp),%eax
    10e3:	01 d0                	add    %edx,%eax
    10e5:	0f b6 00             	movzbl (%eax),%eax
    10e8:	84 c0                	test   %al,%al
    10ea:	75 ed                	jne    10d9 <strlen+0xf>
    ;
  return n;
    10ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ef:	c9                   	leave  
    10f0:	c3                   	ret    

000010f1 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10f1:	55                   	push   %ebp
    10f2:	89 e5                	mov    %esp,%ebp
    10f4:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10f7:	8b 45 10             	mov    0x10(%ebp),%eax
    10fa:	89 44 24 08          	mov    %eax,0x8(%esp)
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	89 44 24 04          	mov    %eax,0x4(%esp)
    1105:	8b 45 08             	mov    0x8(%ebp),%eax
    1108:	89 04 24             	mov    %eax,(%esp)
    110b:	e8 26 ff ff ff       	call   1036 <stosb>
  return dst;
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1113:	c9                   	leave  
    1114:	c3                   	ret    

00001115 <strchr>:

char*
strchr(const char *s, char c)
{
    1115:	55                   	push   %ebp
    1116:	89 e5                	mov    %esp,%ebp
    1118:	83 ec 04             	sub    $0x4,%esp
    111b:	8b 45 0c             	mov    0xc(%ebp),%eax
    111e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1121:	eb 14                	jmp    1137 <strchr+0x22>
    if(*s == c)
    1123:	8b 45 08             	mov    0x8(%ebp),%eax
    1126:	0f b6 00             	movzbl (%eax),%eax
    1129:	3a 45 fc             	cmp    -0x4(%ebp),%al
    112c:	75 05                	jne    1133 <strchr+0x1e>
      return (char*)s;
    112e:	8b 45 08             	mov    0x8(%ebp),%eax
    1131:	eb 13                	jmp    1146 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1133:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1137:	8b 45 08             	mov    0x8(%ebp),%eax
    113a:	0f b6 00             	movzbl (%eax),%eax
    113d:	84 c0                	test   %al,%al
    113f:	75 e2                	jne    1123 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1141:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1146:	c9                   	leave  
    1147:	c3                   	ret    

00001148 <gets>:

char*
gets(char *buf, int max)
{
    1148:	55                   	push   %ebp
    1149:	89 e5                	mov    %esp,%ebp
    114b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    114e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1155:	eb 4c                	jmp    11a3 <gets+0x5b>
    cc = read(0, &c, 1);
    1157:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    115e:	00 
    115f:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1162:	89 44 24 04          	mov    %eax,0x4(%esp)
    1166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    116d:	e8 44 01 00 00       	call   12b6 <read>
    1172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1175:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1179:	7f 02                	jg     117d <gets+0x35>
      break;
    117b:	eb 31                	jmp    11ae <gets+0x66>
    buf[i++] = c;
    117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1180:	8d 50 01             	lea    0x1(%eax),%edx
    1183:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1186:	89 c2                	mov    %eax,%edx
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	01 c2                	add    %eax,%edx
    118d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1191:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1193:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1197:	3c 0a                	cmp    $0xa,%al
    1199:	74 13                	je     11ae <gets+0x66>
    119b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    119f:	3c 0d                	cmp    $0xd,%al
    11a1:	74 0b                	je     11ae <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a6:	83 c0 01             	add    $0x1,%eax
    11a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11ac:	7c a9                	jl     1157 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11b1:	8b 45 08             	mov    0x8(%ebp),%eax
    11b4:	01 d0                	add    %edx,%eax
    11b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11bc:	c9                   	leave  
    11bd:	c3                   	ret    

000011be <stat>:

int
stat(char *n, struct stat *st)
{
    11be:	55                   	push   %ebp
    11bf:	89 e5                	mov    %esp,%ebp
    11c1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11cb:	00 
    11cc:	8b 45 08             	mov    0x8(%ebp),%eax
    11cf:	89 04 24             	mov    %eax,(%esp)
    11d2:	e8 07 01 00 00       	call   12de <open>
    11d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11de:	79 07                	jns    11e7 <stat+0x29>
    return -1;
    11e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11e5:	eb 23                	jmp    120a <stat+0x4c>
  r = fstat(fd, st);
    11e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ea:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f1:	89 04 24             	mov    %eax,(%esp)
    11f4:	e8 fd 00 00 00       	call   12f6 <fstat>
    11f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	89 04 24             	mov    %eax,(%esp)
    1202:	e8 bf 00 00 00       	call   12c6 <close>
  return r;
    1207:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    120a:	c9                   	leave  
    120b:	c3                   	ret    

0000120c <atoi>:

int
atoi(const char *s)
{
    120c:	55                   	push   %ebp
    120d:	89 e5                	mov    %esp,%ebp
    120f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1219:	eb 25                	jmp    1240 <atoi+0x34>
    n = n*10 + *s++ - '0';
    121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    121e:	89 d0                	mov    %edx,%eax
    1220:	c1 e0 02             	shl    $0x2,%eax
    1223:	01 d0                	add    %edx,%eax
    1225:	01 c0                	add    %eax,%eax
    1227:	89 c1                	mov    %eax,%ecx
    1229:	8b 45 08             	mov    0x8(%ebp),%eax
    122c:	8d 50 01             	lea    0x1(%eax),%edx
    122f:	89 55 08             	mov    %edx,0x8(%ebp)
    1232:	0f b6 00             	movzbl (%eax),%eax
    1235:	0f be c0             	movsbl %al,%eax
    1238:	01 c8                	add    %ecx,%eax
    123a:	83 e8 30             	sub    $0x30,%eax
    123d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1240:	8b 45 08             	mov    0x8(%ebp),%eax
    1243:	0f b6 00             	movzbl (%eax),%eax
    1246:	3c 2f                	cmp    $0x2f,%al
    1248:	7e 0a                	jle    1254 <atoi+0x48>
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	0f b6 00             	movzbl (%eax),%eax
    1250:	3c 39                	cmp    $0x39,%al
    1252:	7e c7                	jle    121b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1257:	c9                   	leave  
    1258:	c3                   	ret    

00001259 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1259:	55                   	push   %ebp
    125a:	89 e5                	mov    %esp,%ebp
    125c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1265:	8b 45 0c             	mov    0xc(%ebp),%eax
    1268:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    126b:	eb 17                	jmp    1284 <memmove+0x2b>
    *dst++ = *src++;
    126d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1270:	8d 50 01             	lea    0x1(%eax),%edx
    1273:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1276:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1279:	8d 4a 01             	lea    0x1(%edx),%ecx
    127c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    127f:	0f b6 12             	movzbl (%edx),%edx
    1282:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1284:	8b 45 10             	mov    0x10(%ebp),%eax
    1287:	8d 50 ff             	lea    -0x1(%eax),%edx
    128a:	89 55 10             	mov    %edx,0x10(%ebp)
    128d:	85 c0                	test   %eax,%eax
    128f:	7f dc                	jg     126d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1291:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1294:	c9                   	leave  
    1295:	c3                   	ret    

00001296 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1296:	b8 01 00 00 00       	mov    $0x1,%eax
    129b:	cd 40                	int    $0x40
    129d:	c3                   	ret    

0000129e <exit>:
SYSCALL(exit)
    129e:	b8 02 00 00 00       	mov    $0x2,%eax
    12a3:	cd 40                	int    $0x40
    12a5:	c3                   	ret    

000012a6 <wait>:
SYSCALL(wait)
    12a6:	b8 03 00 00 00       	mov    $0x3,%eax
    12ab:	cd 40                	int    $0x40
    12ad:	c3                   	ret    

000012ae <pipe>:
SYSCALL(pipe)
    12ae:	b8 04 00 00 00       	mov    $0x4,%eax
    12b3:	cd 40                	int    $0x40
    12b5:	c3                   	ret    

000012b6 <read>:
SYSCALL(read)
    12b6:	b8 05 00 00 00       	mov    $0x5,%eax
    12bb:	cd 40                	int    $0x40
    12bd:	c3                   	ret    

000012be <write>:
SYSCALL(write)
    12be:	b8 10 00 00 00       	mov    $0x10,%eax
    12c3:	cd 40                	int    $0x40
    12c5:	c3                   	ret    

000012c6 <close>:
SYSCALL(close)
    12c6:	b8 15 00 00 00       	mov    $0x15,%eax
    12cb:	cd 40                	int    $0x40
    12cd:	c3                   	ret    

000012ce <kill>:
SYSCALL(kill)
    12ce:	b8 06 00 00 00       	mov    $0x6,%eax
    12d3:	cd 40                	int    $0x40
    12d5:	c3                   	ret    

000012d6 <exec>:
SYSCALL(exec)
    12d6:	b8 07 00 00 00       	mov    $0x7,%eax
    12db:	cd 40                	int    $0x40
    12dd:	c3                   	ret    

000012de <open>:
SYSCALL(open)
    12de:	b8 0f 00 00 00       	mov    $0xf,%eax
    12e3:	cd 40                	int    $0x40
    12e5:	c3                   	ret    

000012e6 <mknod>:
SYSCALL(mknod)
    12e6:	b8 11 00 00 00       	mov    $0x11,%eax
    12eb:	cd 40                	int    $0x40
    12ed:	c3                   	ret    

000012ee <unlink>:
SYSCALL(unlink)
    12ee:	b8 12 00 00 00       	mov    $0x12,%eax
    12f3:	cd 40                	int    $0x40
    12f5:	c3                   	ret    

000012f6 <fstat>:
SYSCALL(fstat)
    12f6:	b8 08 00 00 00       	mov    $0x8,%eax
    12fb:	cd 40                	int    $0x40
    12fd:	c3                   	ret    

000012fe <link>:
SYSCALL(link)
    12fe:	b8 13 00 00 00       	mov    $0x13,%eax
    1303:	cd 40                	int    $0x40
    1305:	c3                   	ret    

00001306 <mkdir>:
SYSCALL(mkdir)
    1306:	b8 14 00 00 00       	mov    $0x14,%eax
    130b:	cd 40                	int    $0x40
    130d:	c3                   	ret    

0000130e <chdir>:
SYSCALL(chdir)
    130e:	b8 09 00 00 00       	mov    $0x9,%eax
    1313:	cd 40                	int    $0x40
    1315:	c3                   	ret    

00001316 <dup>:
SYSCALL(dup)
    1316:	b8 0a 00 00 00       	mov    $0xa,%eax
    131b:	cd 40                	int    $0x40
    131d:	c3                   	ret    

0000131e <getpid>:
SYSCALL(getpid)
    131e:	b8 0b 00 00 00       	mov    $0xb,%eax
    1323:	cd 40                	int    $0x40
    1325:	c3                   	ret    

00001326 <sbrk>:
SYSCALL(sbrk)
    1326:	b8 0c 00 00 00       	mov    $0xc,%eax
    132b:	cd 40                	int    $0x40
    132d:	c3                   	ret    

0000132e <sleep>:
SYSCALL(sleep)
    132e:	b8 0d 00 00 00       	mov    $0xd,%eax
    1333:	cd 40                	int    $0x40
    1335:	c3                   	ret    

00001336 <uptime>:
SYSCALL(uptime)
    1336:	b8 0e 00 00 00       	mov    $0xe,%eax
    133b:	cd 40                	int    $0x40
    133d:	c3                   	ret    

0000133e <clone>:
SYSCALL(clone)
    133e:	b8 16 00 00 00       	mov    $0x16,%eax
    1343:	cd 40                	int    $0x40
    1345:	c3                   	ret    

00001346 <texit>:
SYSCALL(texit)
    1346:	b8 17 00 00 00       	mov    $0x17,%eax
    134b:	cd 40                	int    $0x40
    134d:	c3                   	ret    

0000134e <tsleep>:
SYSCALL(tsleep)
    134e:	b8 18 00 00 00       	mov    $0x18,%eax
    1353:	cd 40                	int    $0x40
    1355:	c3                   	ret    

00001356 <twakeup>:
SYSCALL(twakeup)
    1356:	b8 19 00 00 00       	mov    $0x19,%eax
    135b:	cd 40                	int    $0x40
    135d:	c3                   	ret    

0000135e <thread_yield>:
SYSCALL(thread_yield)
    135e:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1363:	cd 40                	int    $0x40
    1365:	c3                   	ret    

00001366 <thread_yield3>:
    1366:	b8 1a 00 00 00       	mov    $0x1a,%eax
    136b:	cd 40                	int    $0x40
    136d:	c3                   	ret    

0000136e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    136e:	55                   	push   %ebp
    136f:	89 e5                	mov    %esp,%ebp
    1371:	83 ec 18             	sub    $0x18,%esp
    1374:	8b 45 0c             	mov    0xc(%ebp),%eax
    1377:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    137a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1381:	00 
    1382:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1385:	89 44 24 04          	mov    %eax,0x4(%esp)
    1389:	8b 45 08             	mov    0x8(%ebp),%eax
    138c:	89 04 24             	mov    %eax,(%esp)
    138f:	e8 2a ff ff ff       	call   12be <write>
}
    1394:	c9                   	leave  
    1395:	c3                   	ret    

00001396 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1396:	55                   	push   %ebp
    1397:	89 e5                	mov    %esp,%ebp
    1399:	56                   	push   %esi
    139a:	53                   	push   %ebx
    139b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    139e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13a9:	74 17                	je     13c2 <printint+0x2c>
    13ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13af:	79 11                	jns    13c2 <printint+0x2c>
    neg = 1;
    13b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bb:	f7 d8                	neg    %eax
    13bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c0:	eb 06                	jmp    13c8 <printint+0x32>
  } else {
    x = xx;
    13c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13d2:	8d 41 01             	lea    0x1(%ecx),%eax
    13d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13db:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13de:	ba 00 00 00 00       	mov    $0x0,%edx
    13e3:	f7 f3                	div    %ebx
    13e5:	89 d0                	mov    %edx,%eax
    13e7:	0f b6 80 f4 1e 00 00 	movzbl 0x1ef4(%eax),%eax
    13ee:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13f2:	8b 75 10             	mov    0x10(%ebp),%esi
    13f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f8:	ba 00 00 00 00       	mov    $0x0,%edx
    13fd:	f7 f6                	div    %esi
    13ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1406:	75 c7                	jne    13cf <printint+0x39>
  if(neg)
    1408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    140c:	74 10                	je     141e <printint+0x88>
    buf[i++] = '-';
    140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1411:	8d 50 01             	lea    0x1(%eax),%edx
    1414:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1417:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    141c:	eb 1f                	jmp    143d <printint+0xa7>
    141e:	eb 1d                	jmp    143d <printint+0xa7>
    putc(fd, buf[i]);
    1420:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1423:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1426:	01 d0                	add    %edx,%eax
    1428:	0f b6 00             	movzbl (%eax),%eax
    142b:	0f be c0             	movsbl %al,%eax
    142e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1432:	8b 45 08             	mov    0x8(%ebp),%eax
    1435:	89 04 24             	mov    %eax,(%esp)
    1438:	e8 31 ff ff ff       	call   136e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    143d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1445:	79 d9                	jns    1420 <printint+0x8a>
    putc(fd, buf[i]);
}
    1447:	83 c4 30             	add    $0x30,%esp
    144a:	5b                   	pop    %ebx
    144b:	5e                   	pop    %esi
    144c:	5d                   	pop    %ebp
    144d:	c3                   	ret    

0000144e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    144e:	55                   	push   %ebp
    144f:	89 e5                	mov    %esp,%ebp
    1451:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1454:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    145b:	8d 45 0c             	lea    0xc(%ebp),%eax
    145e:	83 c0 04             	add    $0x4,%eax
    1461:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1464:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    146b:	e9 7c 01 00 00       	jmp    15ec <printf+0x19e>
    c = fmt[i] & 0xff;
    1470:	8b 55 0c             	mov    0xc(%ebp),%edx
    1473:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1476:	01 d0                	add    %edx,%eax
    1478:	0f b6 00             	movzbl (%eax),%eax
    147b:	0f be c0             	movsbl %al,%eax
    147e:	25 ff 00 00 00       	and    $0xff,%eax
    1483:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1486:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    148a:	75 2c                	jne    14b8 <printf+0x6a>
      if(c == '%'){
    148c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1490:	75 0c                	jne    149e <printf+0x50>
        state = '%';
    1492:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1499:	e9 4a 01 00 00       	jmp    15e8 <printf+0x19a>
      } else {
        putc(fd, c);
    149e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14a1:	0f be c0             	movsbl %al,%eax
    14a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a8:	8b 45 08             	mov    0x8(%ebp),%eax
    14ab:	89 04 24             	mov    %eax,(%esp)
    14ae:	e8 bb fe ff ff       	call   136e <putc>
    14b3:	e9 30 01 00 00       	jmp    15e8 <printf+0x19a>
      }
    } else if(state == '%'){
    14b8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14bc:	0f 85 26 01 00 00    	jne    15e8 <printf+0x19a>
      if(c == 'd'){
    14c2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14c6:	75 2d                	jne    14f5 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14cb:	8b 00                	mov    (%eax),%eax
    14cd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14d4:	00 
    14d5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14dc:	00 
    14dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e1:	8b 45 08             	mov    0x8(%ebp),%eax
    14e4:	89 04 24             	mov    %eax,(%esp)
    14e7:	e8 aa fe ff ff       	call   1396 <printint>
        ap++;
    14ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14f0:	e9 ec 00 00 00       	jmp    15e1 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14f5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14f9:	74 06                	je     1501 <printf+0xb3>
    14fb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14ff:	75 2d                	jne    152e <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1501:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1504:	8b 00                	mov    (%eax),%eax
    1506:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    150d:	00 
    150e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1515:	00 
    1516:	89 44 24 04          	mov    %eax,0x4(%esp)
    151a:	8b 45 08             	mov    0x8(%ebp),%eax
    151d:	89 04 24             	mov    %eax,(%esp)
    1520:	e8 71 fe ff ff       	call   1396 <printint>
        ap++;
    1525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1529:	e9 b3 00 00 00       	jmp    15e1 <printf+0x193>
      } else if(c == 's'){
    152e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1532:	75 45                	jne    1579 <printf+0x12b>
        s = (char*)*ap;
    1534:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1537:	8b 00                	mov    (%eax),%eax
    1539:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    153c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1544:	75 09                	jne    154f <printf+0x101>
          s = "(null)";
    1546:	c7 45 f4 0a 1b 00 00 	movl   $0x1b0a,-0xc(%ebp)
        while(*s != 0){
    154d:	eb 1e                	jmp    156d <printf+0x11f>
    154f:	eb 1c                	jmp    156d <printf+0x11f>
          putc(fd, *s);
    1551:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1554:	0f b6 00             	movzbl (%eax),%eax
    1557:	0f be c0             	movsbl %al,%eax
    155a:	89 44 24 04          	mov    %eax,0x4(%esp)
    155e:	8b 45 08             	mov    0x8(%ebp),%eax
    1561:	89 04 24             	mov    %eax,(%esp)
    1564:	e8 05 fe ff ff       	call   136e <putc>
          s++;
    1569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1570:	0f b6 00             	movzbl (%eax),%eax
    1573:	84 c0                	test   %al,%al
    1575:	75 da                	jne    1551 <printf+0x103>
    1577:	eb 68                	jmp    15e1 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1579:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    157d:	75 1d                	jne    159c <printf+0x14e>
        putc(fd, *ap);
    157f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1582:	8b 00                	mov    (%eax),%eax
    1584:	0f be c0             	movsbl %al,%eax
    1587:	89 44 24 04          	mov    %eax,0x4(%esp)
    158b:	8b 45 08             	mov    0x8(%ebp),%eax
    158e:	89 04 24             	mov    %eax,(%esp)
    1591:	e8 d8 fd ff ff       	call   136e <putc>
        ap++;
    1596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    159a:	eb 45                	jmp    15e1 <printf+0x193>
      } else if(c == '%'){
    159c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a0:	75 17                	jne    15b9 <printf+0x16b>
        putc(fd, c);
    15a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15a5:	0f be c0             	movsbl %al,%eax
    15a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ac:	8b 45 08             	mov    0x8(%ebp),%eax
    15af:	89 04 24             	mov    %eax,(%esp)
    15b2:	e8 b7 fd ff ff       	call   136e <putc>
    15b7:	eb 28                	jmp    15e1 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15c0:	00 
    15c1:	8b 45 08             	mov    0x8(%ebp),%eax
    15c4:	89 04 24             	mov    %eax,(%esp)
    15c7:	e8 a2 fd ff ff       	call   136e <putc>
        putc(fd, c);
    15cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15cf:	0f be c0             	movsbl %al,%eax
    15d2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d6:	8b 45 08             	mov    0x8(%ebp),%eax
    15d9:	89 04 24             	mov    %eax,(%esp)
    15dc:	e8 8d fd ff ff       	call   136e <putc>
      }
      state = 0;
    15e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15ec:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f2:	01 d0                	add    %edx,%eax
    15f4:	0f b6 00             	movzbl (%eax),%eax
    15f7:	84 c0                	test   %al,%al
    15f9:	0f 85 71 fe ff ff    	jne    1470 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15ff:	c9                   	leave  
    1600:	c3                   	ret    

00001601 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1601:	55                   	push   %ebp
    1602:	89 e5                	mov    %esp,%ebp
    1604:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1607:	8b 45 08             	mov    0x8(%ebp),%eax
    160a:	83 e8 08             	sub    $0x8,%eax
    160d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1610:	a1 14 1f 00 00       	mov    0x1f14,%eax
    1615:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1618:	eb 24                	jmp    163e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    161a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161d:	8b 00                	mov    (%eax),%eax
    161f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1622:	77 12                	ja     1636 <free+0x35>
    1624:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1627:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162a:	77 24                	ja     1650 <free+0x4f>
    162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162f:	8b 00                	mov    (%eax),%eax
    1631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1634:	77 1a                	ja     1650 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1636:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1639:	8b 00                	mov    (%eax),%eax
    163b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1641:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1644:	76 d4                	jbe    161a <free+0x19>
    1646:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1649:	8b 00                	mov    (%eax),%eax
    164b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164e:	76 ca                	jbe    161a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1650:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1653:	8b 40 04             	mov    0x4(%eax),%eax
    1656:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1660:	01 c2                	add    %eax,%edx
    1662:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1665:	8b 00                	mov    (%eax),%eax
    1667:	39 c2                	cmp    %eax,%edx
    1669:	75 24                	jne    168f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166e:	8b 50 04             	mov    0x4(%eax),%edx
    1671:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1674:	8b 00                	mov    (%eax),%eax
    1676:	8b 40 04             	mov    0x4(%eax),%eax
    1679:	01 c2                	add    %eax,%edx
    167b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1681:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1684:	8b 00                	mov    (%eax),%eax
    1686:	8b 10                	mov    (%eax),%edx
    1688:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168b:	89 10                	mov    %edx,(%eax)
    168d:	eb 0a                	jmp    1699 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1692:	8b 10                	mov    (%eax),%edx
    1694:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1697:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1699:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169c:	8b 40 04             	mov    0x4(%eax),%eax
    169f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a9:	01 d0                	add    %edx,%eax
    16ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16ae:	75 20                	jne    16d0 <free+0xcf>
    p->s.size += bp->s.size;
    16b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b3:	8b 50 04             	mov    0x4(%eax),%edx
    16b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b9:	8b 40 04             	mov    0x4(%eax),%eax
    16bc:	01 c2                	add    %eax,%edx
    16be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c7:	8b 10                	mov    (%eax),%edx
    16c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cc:	89 10                	mov    %edx,(%eax)
    16ce:	eb 08                	jmp    16d8 <free+0xd7>
  } else
    p->s.ptr = bp;
    16d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16d6:	89 10                	mov    %edx,(%eax)
  freep = p;
    16d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16db:	a3 14 1f 00 00       	mov    %eax,0x1f14
}
    16e0:	c9                   	leave  
    16e1:	c3                   	ret    

000016e2 <morecore>:

static Header*
morecore(uint nu)
{
    16e2:	55                   	push   %ebp
    16e3:	89 e5                	mov    %esp,%ebp
    16e5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16ef:	77 07                	ja     16f8 <morecore+0x16>
    nu = 4096;
    16f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16f8:	8b 45 08             	mov    0x8(%ebp),%eax
    16fb:	c1 e0 03             	shl    $0x3,%eax
    16fe:	89 04 24             	mov    %eax,(%esp)
    1701:	e8 20 fc ff ff       	call   1326 <sbrk>
    1706:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1709:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    170d:	75 07                	jne    1716 <morecore+0x34>
    return 0;
    170f:	b8 00 00 00 00       	mov    $0x0,%eax
    1714:	eb 22                	jmp    1738 <morecore+0x56>
  hp = (Header*)p;
    1716:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1719:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    171f:	8b 55 08             	mov    0x8(%ebp),%edx
    1722:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1725:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1728:	83 c0 08             	add    $0x8,%eax
    172b:	89 04 24             	mov    %eax,(%esp)
    172e:	e8 ce fe ff ff       	call   1601 <free>
  return freep;
    1733:	a1 14 1f 00 00       	mov    0x1f14,%eax
}
    1738:	c9                   	leave  
    1739:	c3                   	ret    

0000173a <malloc>:

void*
malloc(uint nbytes)
{
    173a:	55                   	push   %ebp
    173b:	89 e5                	mov    %esp,%ebp
    173d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1740:	8b 45 08             	mov    0x8(%ebp),%eax
    1743:	83 c0 07             	add    $0x7,%eax
    1746:	c1 e8 03             	shr    $0x3,%eax
    1749:	83 c0 01             	add    $0x1,%eax
    174c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    174f:	a1 14 1f 00 00       	mov    0x1f14,%eax
    1754:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    175b:	75 23                	jne    1780 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    175d:	c7 45 f0 0c 1f 00 00 	movl   $0x1f0c,-0x10(%ebp)
    1764:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1767:	a3 14 1f 00 00       	mov    %eax,0x1f14
    176c:	a1 14 1f 00 00       	mov    0x1f14,%eax
    1771:	a3 0c 1f 00 00       	mov    %eax,0x1f0c
    base.s.size = 0;
    1776:	c7 05 10 1f 00 00 00 	movl   $0x0,0x1f10
    177d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1780:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1783:	8b 00                	mov    (%eax),%eax
    1785:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1788:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178b:	8b 40 04             	mov    0x4(%eax),%eax
    178e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1791:	72 4d                	jb     17e0 <malloc+0xa6>
      if(p->s.size == nunits)
    1793:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1796:	8b 40 04             	mov    0x4(%eax),%eax
    1799:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179c:	75 0c                	jne    17aa <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a1:	8b 10                	mov    (%eax),%edx
    17a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a6:	89 10                	mov    %edx,(%eax)
    17a8:	eb 26                	jmp    17d0 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ad:	8b 40 04             	mov    0x4(%eax),%eax
    17b0:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17b3:	89 c2                	mov    %eax,%edx
    17b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17be:	8b 40 04             	mov    0x4(%eax),%eax
    17c1:	c1 e0 03             	shl    $0x3,%eax
    17c4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17cd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d3:	a3 14 1f 00 00       	mov    %eax,0x1f14
      return (void*)(p + 1);
    17d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17db:	83 c0 08             	add    $0x8,%eax
    17de:	eb 38                	jmp    1818 <malloc+0xde>
    }
    if(p == freep)
    17e0:	a1 14 1f 00 00       	mov    0x1f14,%eax
    17e5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17e8:	75 1b                	jne    1805 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17ed:	89 04 24             	mov    %eax,(%esp)
    17f0:	e8 ed fe ff ff       	call   16e2 <morecore>
    17f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17fc:	75 07                	jne    1805 <malloc+0xcb>
        return 0;
    17fe:	b8 00 00 00 00       	mov    $0x0,%eax
    1803:	eb 13                	jmp    1818 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1805:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1808:	89 45 f0             	mov    %eax,-0x10(%ebp)
    180b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180e:	8b 00                	mov    (%eax),%eax
    1810:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1813:	e9 70 ff ff ff       	jmp    1788 <malloc+0x4e>
}
    1818:	c9                   	leave  
    1819:	c3                   	ret    

0000181a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    181a:	55                   	push   %ebp
    181b:	89 e5                	mov    %esp,%ebp
    181d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1820:	8b 55 08             	mov    0x8(%ebp),%edx
    1823:	8b 45 0c             	mov    0xc(%ebp),%eax
    1826:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1829:	f0 87 02             	lock xchg %eax,(%edx)
    182c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1832:	c9                   	leave  
    1833:	c3                   	ret    

00001834 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1834:	55                   	push   %ebp
    1835:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1837:	8b 45 08             	mov    0x8(%ebp),%eax
    183a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1840:	5d                   	pop    %ebp
    1841:	c3                   	ret    

00001842 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1842:	55                   	push   %ebp
    1843:	89 e5                	mov    %esp,%ebp
    1845:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1848:	90                   	nop
    1849:	8b 45 08             	mov    0x8(%ebp),%eax
    184c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1853:	00 
    1854:	89 04 24             	mov    %eax,(%esp)
    1857:	e8 be ff ff ff       	call   181a <xchg>
    185c:	85 c0                	test   %eax,%eax
    185e:	75 e9                	jne    1849 <lock_acquire+0x7>
}
    1860:	c9                   	leave  
    1861:	c3                   	ret    

00001862 <lock_release>:
void lock_release(lock_t *lock){
    1862:	55                   	push   %ebp
    1863:	89 e5                	mov    %esp,%ebp
    1865:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1868:	8b 45 08             	mov    0x8(%ebp),%eax
    186b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1872:	00 
    1873:	89 04 24             	mov    %eax,(%esp)
    1876:	e8 9f ff ff ff       	call   181a <xchg>
}
    187b:	c9                   	leave  
    187c:	c3                   	ret    

0000187d <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    187d:	55                   	push   %ebp
    187e:	89 e5                	mov    %esp,%ebp
    1880:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1883:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    188a:	e8 ab fe ff ff       	call   173a <malloc>
    188f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1892:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1895:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1898:	0f b6 05 18 1f 00 00 	movzbl 0x1f18,%eax
    189f:	84 c0                	test   %al,%al
    18a1:	75 1c                	jne    18bf <thread_create+0x42>
        init_q(thQ2);
    18a3:	a1 1c 1f 00 00       	mov    0x1f1c,%eax
    18a8:	89 04 24             	mov    %eax,(%esp)
    18ab:	e8 2c 01 00 00       	call   19dc <init_q>
        inQ++;
    18b0:	0f b6 05 18 1f 00 00 	movzbl 0x1f18,%eax
    18b7:	83 c0 01             	add    $0x1,%eax
    18ba:	a2 18 1f 00 00       	mov    %al,0x1f18
    }

    if((uint)stack % 4096){
    18bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c2:	25 ff 0f 00 00       	and    $0xfff,%eax
    18c7:	85 c0                	test   %eax,%eax
    18c9:	74 14                	je     18df <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    18cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ce:	25 ff 0f 00 00       	and    $0xfff,%eax
    18d3:	89 c2                	mov    %eax,%edx
    18d5:	b8 00 10 00 00       	mov    $0x1000,%eax
    18da:	29 d0                	sub    %edx,%eax
    18dc:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    18df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e3:	75 1e                	jne    1903 <thread_create+0x86>

        printf(1,"malloc fail \n");
    18e5:	c7 44 24 04 11 1b 00 	movl   $0x1b11,0x4(%esp)
    18ec:	00 
    18ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f4:	e8 55 fb ff ff       	call   144e <printf>
        return 0;
    18f9:	b8 00 00 00 00       	mov    $0x0,%eax
    18fe:	e9 83 00 00 00       	jmp    1986 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1903:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1906:	8b 55 08             	mov    0x8(%ebp),%edx
    1909:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1910:	89 54 24 08          	mov    %edx,0x8(%esp)
    1914:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    191b:	00 
    191c:	89 04 24             	mov    %eax,(%esp)
    191f:	e8 1a fa ff ff       	call   133e <clone>
    1924:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    1927:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    192b:	79 1b                	jns    1948 <thread_create+0xcb>
        printf(1,"clone fails\n");
    192d:	c7 44 24 04 1f 1b 00 	movl   $0x1b1f,0x4(%esp)
    1934:	00 
    1935:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    193c:	e8 0d fb ff ff       	call   144e <printf>
        return 0;
    1941:	b8 00 00 00 00       	mov    $0x0,%eax
    1946:	eb 3e                	jmp    1986 <thread_create+0x109>
    }
    if(tid > 0){
    1948:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    194c:	7e 19                	jle    1967 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    194e:	a1 1c 1f 00 00       	mov    0x1f1c,%eax
    1953:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1956:	89 54 24 04          	mov    %edx,0x4(%esp)
    195a:	89 04 24             	mov    %eax,(%esp)
    195d:	e8 9c 00 00 00       	call   19fe <add_q>
        return garbage_stack;
    1962:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1965:	eb 1f                	jmp    1986 <thread_create+0x109>
    }
    if(tid == 0){
    1967:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    196b:	75 14                	jne    1981 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    196d:	c7 44 24 04 2c 1b 00 	movl   $0x1b2c,0x4(%esp)
    1974:	00 
    1975:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    197c:	e8 cd fa ff ff       	call   144e <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1981:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1986:	c9                   	leave  
    1987:	c3                   	ret    

00001988 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1988:	55                   	push   %ebp
    1989:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    198b:	a1 08 1f 00 00       	mov    0x1f08,%eax
    1990:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1996:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    199b:	a3 08 1f 00 00       	mov    %eax,0x1f08
    return (int)(rands % max);
    19a0:	a1 08 1f 00 00       	mov    0x1f08,%eax
    19a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19a8:	ba 00 00 00 00       	mov    $0x0,%edx
    19ad:	f7 f1                	div    %ecx
    19af:	89 d0                	mov    %edx,%eax
}
    19b1:	5d                   	pop    %ebp
    19b2:	c3                   	ret    

000019b3 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    19b3:	55                   	push   %ebp
    19b4:	89 e5                	mov    %esp,%ebp
    19b6:	83 ec 18             	sub    $0x18,%esp
    printf(1,"My PID: %d \n", proc->pid);
    19b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    19bf:	8b 40 10             	mov    0x10(%eax),%eax
    19c2:	89 44 24 08          	mov    %eax,0x8(%esp)
    19c6:	c7 44 24 04 3d 1b 00 	movl   $0x1b3d,0x4(%esp)
    19cd:	00 
    19ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19d5:	e8 74 fa ff ff       	call   144e <printf>
    */
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    
    //yield();
    19da:	c9                   	leave  
    19db:	c3                   	ret    

000019dc <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    19dc:	55                   	push   %ebp
    19dd:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    19df:	8b 45 08             	mov    0x8(%ebp),%eax
    19e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    19e8:	8b 45 08             	mov    0x8(%ebp),%eax
    19eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    19f2:	8b 45 08             	mov    0x8(%ebp),%eax
    19f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    19fc:	5d                   	pop    %ebp
    19fd:	c3                   	ret    

000019fe <add_q>:

void add_q(struct queue *q, int v){
    19fe:	55                   	push   %ebp
    19ff:	89 e5                	mov    %esp,%ebp
    1a01:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1a04:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1a0b:	e8 2a fd ff ff       	call   173a <malloc>
    1a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a20:	8b 55 0c             	mov    0xc(%ebp),%edx
    1a23:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1a25:	8b 45 08             	mov    0x8(%ebp),%eax
    1a28:	8b 40 04             	mov    0x4(%eax),%eax
    1a2b:	85 c0                	test   %eax,%eax
    1a2d:	75 0b                	jne    1a3a <add_q+0x3c>
        q->head = n;
    1a2f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a35:	89 50 04             	mov    %edx,0x4(%eax)
    1a38:	eb 0c                	jmp    1a46 <add_q+0x48>
    }else{
        q->tail->next = n;
    1a3a:	8b 45 08             	mov    0x8(%ebp),%eax
    1a3d:	8b 40 08             	mov    0x8(%eax),%eax
    1a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a43:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1a46:	8b 45 08             	mov    0x8(%ebp),%eax
    1a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1a4c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1a4f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a52:	8b 00                	mov    (%eax),%eax
    1a54:	8d 50 01             	lea    0x1(%eax),%edx
    1a57:	8b 45 08             	mov    0x8(%ebp),%eax
    1a5a:	89 10                	mov    %edx,(%eax)
}
    1a5c:	c9                   	leave  
    1a5d:	c3                   	ret    

00001a5e <empty_q>:

int empty_q(struct queue *q){
    1a5e:	55                   	push   %ebp
    1a5f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1a61:	8b 45 08             	mov    0x8(%ebp),%eax
    1a64:	8b 00                	mov    (%eax),%eax
    1a66:	85 c0                	test   %eax,%eax
    1a68:	75 07                	jne    1a71 <empty_q+0x13>
        return 1;
    1a6a:	b8 01 00 00 00       	mov    $0x1,%eax
    1a6f:	eb 05                	jmp    1a76 <empty_q+0x18>
    else
        return 0;
    1a71:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1a76:	5d                   	pop    %ebp
    1a77:	c3                   	ret    

00001a78 <pop_q>:
int pop_q(struct queue *q){
    1a78:	55                   	push   %ebp
    1a79:	89 e5                	mov    %esp,%ebp
    1a7b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1a7e:	8b 45 08             	mov    0x8(%ebp),%eax
    1a81:	89 04 24             	mov    %eax,(%esp)
    1a84:	e8 d5 ff ff ff       	call   1a5e <empty_q>
    1a89:	85 c0                	test   %eax,%eax
    1a8b:	75 5d                	jne    1aea <pop_q+0x72>
       val = q->head->value; 
    1a8d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a90:	8b 40 04             	mov    0x4(%eax),%eax
    1a93:	8b 00                	mov    (%eax),%eax
    1a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1a98:	8b 45 08             	mov    0x8(%ebp),%eax
    1a9b:	8b 40 04             	mov    0x4(%eax),%eax
    1a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1aa1:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa4:	8b 40 04             	mov    0x4(%eax),%eax
    1aa7:	8b 50 04             	mov    0x4(%eax),%edx
    1aaa:	8b 45 08             	mov    0x8(%ebp),%eax
    1aad:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab3:	89 04 24             	mov    %eax,(%esp)
    1ab6:	e8 46 fb ff ff       	call   1601 <free>
       q->size--;
    1abb:	8b 45 08             	mov    0x8(%ebp),%eax
    1abe:	8b 00                	mov    (%eax),%eax
    1ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
    1ac3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ac8:	8b 45 08             	mov    0x8(%ebp),%eax
    1acb:	8b 00                	mov    (%eax),%eax
    1acd:	85 c0                	test   %eax,%eax
    1acf:	75 14                	jne    1ae5 <pop_q+0x6d>
            q->head = 0;
    1ad1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1adb:	8b 45 08             	mov    0x8(%ebp),%eax
    1ade:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae8:	eb 05                	jmp    1aef <pop_q+0x77>
    }
    return -1;
    1aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1aef:	c9                   	leave  
    1af0:	c3                   	ret    
