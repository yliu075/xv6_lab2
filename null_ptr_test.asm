
_null_ptr_test:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
    int *ptr = 0;
    1009:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1010:	00 
    printf(1, "DeRef addr %p = %p\n", ptr,(*ptr));
    1011:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1015:	8b 00                	mov    (%eax),%eax
    1017:	89 44 24 0c          	mov    %eax,0xc(%esp)
    101b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    101f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1023:	c7 44 24 04 9a 1b 00 	movl   $0x1b9a,0x4(%esp)
    102a:	00 
    102b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1032:	e8 1f 04 00 00       	call   1456 <printf>
    return 0;
    1037:	b8 00 00 00 00       	mov    $0x0,%eax
}
    103c:	c9                   	leave  
    103d:	c3                   	ret    

0000103e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    103e:	55                   	push   %ebp
    103f:	89 e5                	mov    %esp,%ebp
    1041:	57                   	push   %edi
    1042:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1043:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1046:	8b 55 10             	mov    0x10(%ebp),%edx
    1049:	8b 45 0c             	mov    0xc(%ebp),%eax
    104c:	89 cb                	mov    %ecx,%ebx
    104e:	89 df                	mov    %ebx,%edi
    1050:	89 d1                	mov    %edx,%ecx
    1052:	fc                   	cld    
    1053:	f3 aa                	rep stos %al,%es:(%edi)
    1055:	89 ca                	mov    %ecx,%edx
    1057:	89 fb                	mov    %edi,%ebx
    1059:	89 5d 08             	mov    %ebx,0x8(%ebp)
    105c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    105f:	5b                   	pop    %ebx
    1060:	5f                   	pop    %edi
    1061:	5d                   	pop    %ebp
    1062:	c3                   	ret    

00001063 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1063:	55                   	push   %ebp
    1064:	89 e5                	mov    %esp,%ebp
    1066:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1069:	8b 45 08             	mov    0x8(%ebp),%eax
    106c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    106f:	90                   	nop
    1070:	8b 45 08             	mov    0x8(%ebp),%eax
    1073:	8d 50 01             	lea    0x1(%eax),%edx
    1076:	89 55 08             	mov    %edx,0x8(%ebp)
    1079:	8b 55 0c             	mov    0xc(%ebp),%edx
    107c:	8d 4a 01             	lea    0x1(%edx),%ecx
    107f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1082:	0f b6 12             	movzbl (%edx),%edx
    1085:	88 10                	mov    %dl,(%eax)
    1087:	0f b6 00             	movzbl (%eax),%eax
    108a:	84 c0                	test   %al,%al
    108c:	75 e2                	jne    1070 <strcpy+0xd>
    ;
  return os;
    108e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1091:	c9                   	leave  
    1092:	c3                   	ret    

00001093 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1093:	55                   	push   %ebp
    1094:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1096:	eb 08                	jmp    10a0 <strcmp+0xd>
    p++, q++;
    1098:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    109c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10a0:	8b 45 08             	mov    0x8(%ebp),%eax
    10a3:	0f b6 00             	movzbl (%eax),%eax
    10a6:	84 c0                	test   %al,%al
    10a8:	74 10                	je     10ba <strcmp+0x27>
    10aa:	8b 45 08             	mov    0x8(%ebp),%eax
    10ad:	0f b6 10             	movzbl (%eax),%edx
    10b0:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b3:	0f b6 00             	movzbl (%eax),%eax
    10b6:	38 c2                	cmp    %al,%dl
    10b8:	74 de                	je     1098 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	0f b6 00             	movzbl (%eax),%eax
    10c0:	0f b6 d0             	movzbl %al,%edx
    10c3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c6:	0f b6 00             	movzbl (%eax),%eax
    10c9:	0f b6 c0             	movzbl %al,%eax
    10cc:	29 c2                	sub    %eax,%edx
    10ce:	89 d0                	mov    %edx,%eax
}
    10d0:	5d                   	pop    %ebp
    10d1:	c3                   	ret    

000010d2 <strlen>:

uint
strlen(char *s)
{
    10d2:	55                   	push   %ebp
    10d3:	89 e5                	mov    %esp,%ebp
    10d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10df:	eb 04                	jmp    10e5 <strlen+0x13>
    10e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10e8:	8b 45 08             	mov    0x8(%ebp),%eax
    10eb:	01 d0                	add    %edx,%eax
    10ed:	0f b6 00             	movzbl (%eax),%eax
    10f0:	84 c0                	test   %al,%al
    10f2:	75 ed                	jne    10e1 <strlen+0xf>
    ;
  return n;
    10f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10f7:	c9                   	leave  
    10f8:	c3                   	ret    

000010f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10f9:	55                   	push   %ebp
    10fa:	89 e5                	mov    %esp,%ebp
    10fc:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10ff:	8b 45 10             	mov    0x10(%ebp),%eax
    1102:	89 44 24 08          	mov    %eax,0x8(%esp)
    1106:	8b 45 0c             	mov    0xc(%ebp),%eax
    1109:	89 44 24 04          	mov    %eax,0x4(%esp)
    110d:	8b 45 08             	mov    0x8(%ebp),%eax
    1110:	89 04 24             	mov    %eax,(%esp)
    1113:	e8 26 ff ff ff       	call   103e <stosb>
  return dst;
    1118:	8b 45 08             	mov    0x8(%ebp),%eax
}
    111b:	c9                   	leave  
    111c:	c3                   	ret    

0000111d <strchr>:

char*
strchr(const char *s, char c)
{
    111d:	55                   	push   %ebp
    111e:	89 e5                	mov    %esp,%ebp
    1120:	83 ec 04             	sub    $0x4,%esp
    1123:	8b 45 0c             	mov    0xc(%ebp),%eax
    1126:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1129:	eb 14                	jmp    113f <strchr+0x22>
    if(*s == c)
    112b:	8b 45 08             	mov    0x8(%ebp),%eax
    112e:	0f b6 00             	movzbl (%eax),%eax
    1131:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1134:	75 05                	jne    113b <strchr+0x1e>
      return (char*)s;
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	eb 13                	jmp    114e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    113b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
    1142:	0f b6 00             	movzbl (%eax),%eax
    1145:	84 c0                	test   %al,%al
    1147:	75 e2                	jne    112b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1149:	b8 00 00 00 00       	mov    $0x0,%eax
}
    114e:	c9                   	leave  
    114f:	c3                   	ret    

00001150 <gets>:

char*
gets(char *buf, int max)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    115d:	eb 4c                	jmp    11ab <gets+0x5b>
    cc = read(0, &c, 1);
    115f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1166:	00 
    1167:	8d 45 ef             	lea    -0x11(%ebp),%eax
    116a:	89 44 24 04          	mov    %eax,0x4(%esp)
    116e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1175:	e8 44 01 00 00       	call   12be <read>
    117a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    117d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1181:	7f 02                	jg     1185 <gets+0x35>
      break;
    1183:	eb 31                	jmp    11b6 <gets+0x66>
    buf[i++] = c;
    1185:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1188:	8d 50 01             	lea    0x1(%eax),%edx
    118b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    118e:	89 c2                	mov    %eax,%edx
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	01 c2                	add    %eax,%edx
    1195:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1199:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    119b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    119f:	3c 0a                	cmp    $0xa,%al
    11a1:	74 13                	je     11b6 <gets+0x66>
    11a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11a7:	3c 0d                	cmp    $0xd,%al
    11a9:	74 0b                	je     11b6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ae:	83 c0 01             	add    $0x1,%eax
    11b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11b4:	7c a9                	jl     115f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 d0                	add    %edx,%eax
    11be:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11c4:	c9                   	leave  
    11c5:	c3                   	ret    

000011c6 <stat>:

int
stat(char *n, struct stat *st)
{
    11c6:	55                   	push   %ebp
    11c7:	89 e5                	mov    %esp,%ebp
    11c9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11d3:	00 
    11d4:	8b 45 08             	mov    0x8(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 07 01 00 00       	call   12e6 <open>
    11df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11e6:	79 07                	jns    11ef <stat+0x29>
    return -1;
    11e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11ed:	eb 23                	jmp    1212 <stat+0x4c>
  r = fstat(fd, st);
    11ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f9:	89 04 24             	mov    %eax,(%esp)
    11fc:	e8 fd 00 00 00       	call   12fe <fstat>
    1201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1204:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1207:	89 04 24             	mov    %eax,(%esp)
    120a:	e8 bf 00 00 00       	call   12ce <close>
  return r;
    120f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1212:	c9                   	leave  
    1213:	c3                   	ret    

00001214 <atoi>:

int
atoi(const char *s)
{
    1214:	55                   	push   %ebp
    1215:	89 e5                	mov    %esp,%ebp
    1217:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1221:	eb 25                	jmp    1248 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1223:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1226:	89 d0                	mov    %edx,%eax
    1228:	c1 e0 02             	shl    $0x2,%eax
    122b:	01 d0                	add    %edx,%eax
    122d:	01 c0                	add    %eax,%eax
    122f:	89 c1                	mov    %eax,%ecx
    1231:	8b 45 08             	mov    0x8(%ebp),%eax
    1234:	8d 50 01             	lea    0x1(%eax),%edx
    1237:	89 55 08             	mov    %edx,0x8(%ebp)
    123a:	0f b6 00             	movzbl (%eax),%eax
    123d:	0f be c0             	movsbl %al,%eax
    1240:	01 c8                	add    %ecx,%eax
    1242:	83 e8 30             	sub    $0x30,%eax
    1245:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	0f b6 00             	movzbl (%eax),%eax
    124e:	3c 2f                	cmp    $0x2f,%al
    1250:	7e 0a                	jle    125c <atoi+0x48>
    1252:	8b 45 08             	mov    0x8(%ebp),%eax
    1255:	0f b6 00             	movzbl (%eax),%eax
    1258:	3c 39                	cmp    $0x39,%al
    125a:	7e c7                	jle    1223 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    125c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    125f:	c9                   	leave  
    1260:	c3                   	ret    

00001261 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1261:	55                   	push   %ebp
    1262:	89 e5                	mov    %esp,%ebp
    1264:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1267:	8b 45 08             	mov    0x8(%ebp),%eax
    126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    126d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1270:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1273:	eb 17                	jmp    128c <memmove+0x2b>
    *dst++ = *src++;
    1275:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1278:	8d 50 01             	lea    0x1(%eax),%edx
    127b:	89 55 fc             	mov    %edx,-0x4(%ebp)
    127e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1281:	8d 4a 01             	lea    0x1(%edx),%ecx
    1284:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1287:	0f b6 12             	movzbl (%edx),%edx
    128a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    128c:	8b 45 10             	mov    0x10(%ebp),%eax
    128f:	8d 50 ff             	lea    -0x1(%eax),%edx
    1292:	89 55 10             	mov    %edx,0x10(%ebp)
    1295:	85 c0                	test   %eax,%eax
    1297:	7f dc                	jg     1275 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1299:	8b 45 08             	mov    0x8(%ebp),%eax
}
    129c:	c9                   	leave  
    129d:	c3                   	ret    

0000129e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    129e:	b8 01 00 00 00       	mov    $0x1,%eax
    12a3:	cd 40                	int    $0x40
    12a5:	c3                   	ret    

000012a6 <exit>:
SYSCALL(exit)
    12a6:	b8 02 00 00 00       	mov    $0x2,%eax
    12ab:	cd 40                	int    $0x40
    12ad:	c3                   	ret    

000012ae <wait>:
SYSCALL(wait)
    12ae:	b8 03 00 00 00       	mov    $0x3,%eax
    12b3:	cd 40                	int    $0x40
    12b5:	c3                   	ret    

000012b6 <pipe>:
SYSCALL(pipe)
    12b6:	b8 04 00 00 00       	mov    $0x4,%eax
    12bb:	cd 40                	int    $0x40
    12bd:	c3                   	ret    

000012be <read>:
SYSCALL(read)
    12be:	b8 05 00 00 00       	mov    $0x5,%eax
    12c3:	cd 40                	int    $0x40
    12c5:	c3                   	ret    

000012c6 <write>:
SYSCALL(write)
    12c6:	b8 10 00 00 00       	mov    $0x10,%eax
    12cb:	cd 40                	int    $0x40
    12cd:	c3                   	ret    

000012ce <close>:
SYSCALL(close)
    12ce:	b8 15 00 00 00       	mov    $0x15,%eax
    12d3:	cd 40                	int    $0x40
    12d5:	c3                   	ret    

000012d6 <kill>:
SYSCALL(kill)
    12d6:	b8 06 00 00 00       	mov    $0x6,%eax
    12db:	cd 40                	int    $0x40
    12dd:	c3                   	ret    

000012de <exec>:
SYSCALL(exec)
    12de:	b8 07 00 00 00       	mov    $0x7,%eax
    12e3:	cd 40                	int    $0x40
    12e5:	c3                   	ret    

000012e6 <open>:
SYSCALL(open)
    12e6:	b8 0f 00 00 00       	mov    $0xf,%eax
    12eb:	cd 40                	int    $0x40
    12ed:	c3                   	ret    

000012ee <mknod>:
SYSCALL(mknod)
    12ee:	b8 11 00 00 00       	mov    $0x11,%eax
    12f3:	cd 40                	int    $0x40
    12f5:	c3                   	ret    

000012f6 <unlink>:
SYSCALL(unlink)
    12f6:	b8 12 00 00 00       	mov    $0x12,%eax
    12fb:	cd 40                	int    $0x40
    12fd:	c3                   	ret    

000012fe <fstat>:
SYSCALL(fstat)
    12fe:	b8 08 00 00 00       	mov    $0x8,%eax
    1303:	cd 40                	int    $0x40
    1305:	c3                   	ret    

00001306 <link>:
SYSCALL(link)
    1306:	b8 13 00 00 00       	mov    $0x13,%eax
    130b:	cd 40                	int    $0x40
    130d:	c3                   	ret    

0000130e <mkdir>:
SYSCALL(mkdir)
    130e:	b8 14 00 00 00       	mov    $0x14,%eax
    1313:	cd 40                	int    $0x40
    1315:	c3                   	ret    

00001316 <chdir>:
SYSCALL(chdir)
    1316:	b8 09 00 00 00       	mov    $0x9,%eax
    131b:	cd 40                	int    $0x40
    131d:	c3                   	ret    

0000131e <dup>:
SYSCALL(dup)
    131e:	b8 0a 00 00 00       	mov    $0xa,%eax
    1323:	cd 40                	int    $0x40
    1325:	c3                   	ret    

00001326 <getpid>:
SYSCALL(getpid)
    1326:	b8 0b 00 00 00       	mov    $0xb,%eax
    132b:	cd 40                	int    $0x40
    132d:	c3                   	ret    

0000132e <sbrk>:
SYSCALL(sbrk)
    132e:	b8 0c 00 00 00       	mov    $0xc,%eax
    1333:	cd 40                	int    $0x40
    1335:	c3                   	ret    

00001336 <sleep>:
SYSCALL(sleep)
    1336:	b8 0d 00 00 00       	mov    $0xd,%eax
    133b:	cd 40                	int    $0x40
    133d:	c3                   	ret    

0000133e <uptime>:
SYSCALL(uptime)
    133e:	b8 0e 00 00 00       	mov    $0xe,%eax
    1343:	cd 40                	int    $0x40
    1345:	c3                   	ret    

00001346 <clone>:
SYSCALL(clone)
    1346:	b8 16 00 00 00       	mov    $0x16,%eax
    134b:	cd 40                	int    $0x40
    134d:	c3                   	ret    

0000134e <texit>:
SYSCALL(texit)
    134e:	b8 17 00 00 00       	mov    $0x17,%eax
    1353:	cd 40                	int    $0x40
    1355:	c3                   	ret    

00001356 <tsleep>:
SYSCALL(tsleep)
    1356:	b8 18 00 00 00       	mov    $0x18,%eax
    135b:	cd 40                	int    $0x40
    135d:	c3                   	ret    

0000135e <twakeup>:
SYSCALL(twakeup)
    135e:	b8 19 00 00 00       	mov    $0x19,%eax
    1363:	cd 40                	int    $0x40
    1365:	c3                   	ret    

00001366 <thread_yield>:
SYSCALL(thread_yield)
    1366:	b8 1a 00 00 00       	mov    $0x1a,%eax
    136b:	cd 40                	int    $0x40
    136d:	c3                   	ret    

0000136e <thread_yield3>:
    136e:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1373:	cd 40                	int    $0x40
    1375:	c3                   	ret    

00001376 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1376:	55                   	push   %ebp
    1377:	89 e5                	mov    %esp,%ebp
    1379:	83 ec 18             	sub    $0x18,%esp
    137c:	8b 45 0c             	mov    0xc(%ebp),%eax
    137f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1382:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1389:	00 
    138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
    138d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1391:	8b 45 08             	mov    0x8(%ebp),%eax
    1394:	89 04 24             	mov    %eax,(%esp)
    1397:	e8 2a ff ff ff       	call   12c6 <write>
}
    139c:	c9                   	leave  
    139d:	c3                   	ret    

0000139e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    139e:	55                   	push   %ebp
    139f:	89 e5                	mov    %esp,%ebp
    13a1:	56                   	push   %esi
    13a2:	53                   	push   %ebx
    13a3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b1:	74 17                	je     13ca <printint+0x2c>
    13b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13b7:	79 11                	jns    13ca <printint+0x2c>
    neg = 1;
    13b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c3:	f7 d8                	neg    %eax
    13c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c8:	eb 06                	jmp    13d0 <printint+0x32>
  } else {
    x = xx;
    13ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13da:	8d 41 01             	lea    0x1(%ecx),%eax
    13dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e6:	ba 00 00 00 00       	mov    $0x0,%edx
    13eb:	f7 f3                	div    %ebx
    13ed:	89 d0                	mov    %edx,%eax
    13ef:	0f b6 80 c4 1f 00 00 	movzbl 0x1fc4(%eax),%eax
    13f6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13fa:	8b 75 10             	mov    0x10(%ebp),%esi
    13fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1400:	ba 00 00 00 00       	mov    $0x0,%edx
    1405:	f7 f6                	div    %esi
    1407:	89 45 ec             	mov    %eax,-0x14(%ebp)
    140a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    140e:	75 c7                	jne    13d7 <printint+0x39>
  if(neg)
    1410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1414:	74 10                	je     1426 <printint+0x88>
    buf[i++] = '-';
    1416:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1419:	8d 50 01             	lea    0x1(%eax),%edx
    141c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    141f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1424:	eb 1f                	jmp    1445 <printint+0xa7>
    1426:	eb 1d                	jmp    1445 <printint+0xa7>
    putc(fd, buf[i]);
    1428:	8d 55 dc             	lea    -0x24(%ebp),%edx
    142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142e:	01 d0                	add    %edx,%eax
    1430:	0f b6 00             	movzbl (%eax),%eax
    1433:	0f be c0             	movsbl %al,%eax
    1436:	89 44 24 04          	mov    %eax,0x4(%esp)
    143a:	8b 45 08             	mov    0x8(%ebp),%eax
    143d:	89 04 24             	mov    %eax,(%esp)
    1440:	e8 31 ff ff ff       	call   1376 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1445:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    144d:	79 d9                	jns    1428 <printint+0x8a>
    putc(fd, buf[i]);
}
    144f:	83 c4 30             	add    $0x30,%esp
    1452:	5b                   	pop    %ebx
    1453:	5e                   	pop    %esi
    1454:	5d                   	pop    %ebp
    1455:	c3                   	ret    

00001456 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1456:	55                   	push   %ebp
    1457:	89 e5                	mov    %esp,%ebp
    1459:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    145c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1463:	8d 45 0c             	lea    0xc(%ebp),%eax
    1466:	83 c0 04             	add    $0x4,%eax
    1469:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    146c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1473:	e9 7c 01 00 00       	jmp    15f4 <printf+0x19e>
    c = fmt[i] & 0xff;
    1478:	8b 55 0c             	mov    0xc(%ebp),%edx
    147b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    147e:	01 d0                	add    %edx,%eax
    1480:	0f b6 00             	movzbl (%eax),%eax
    1483:	0f be c0             	movsbl %al,%eax
    1486:	25 ff 00 00 00       	and    $0xff,%eax
    148b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    148e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1492:	75 2c                	jne    14c0 <printf+0x6a>
      if(c == '%'){
    1494:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1498:	75 0c                	jne    14a6 <printf+0x50>
        state = '%';
    149a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a1:	e9 4a 01 00 00       	jmp    15f0 <printf+0x19a>
      } else {
        putc(fd, c);
    14a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14a9:	0f be c0             	movsbl %al,%eax
    14ac:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b0:	8b 45 08             	mov    0x8(%ebp),%eax
    14b3:	89 04 24             	mov    %eax,(%esp)
    14b6:	e8 bb fe ff ff       	call   1376 <putc>
    14bb:	e9 30 01 00 00       	jmp    15f0 <printf+0x19a>
      }
    } else if(state == '%'){
    14c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c4:	0f 85 26 01 00 00    	jne    15f0 <printf+0x19a>
      if(c == 'd'){
    14ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14ce:	75 2d                	jne    14fd <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d3:	8b 00                	mov    (%eax),%eax
    14d5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14dc:	00 
    14dd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14e4:	00 
    14e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e9:	8b 45 08             	mov    0x8(%ebp),%eax
    14ec:	89 04 24             	mov    %eax,(%esp)
    14ef:	e8 aa fe ff ff       	call   139e <printint>
        ap++;
    14f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14f8:	e9 ec 00 00 00       	jmp    15e9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14fd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1501:	74 06                	je     1509 <printf+0xb3>
    1503:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1507:	75 2d                	jne    1536 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1509:	8b 45 e8             	mov    -0x18(%ebp),%eax
    150c:	8b 00                	mov    (%eax),%eax
    150e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1515:	00 
    1516:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    151d:	00 
    151e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1522:	8b 45 08             	mov    0x8(%ebp),%eax
    1525:	89 04 24             	mov    %eax,(%esp)
    1528:	e8 71 fe ff ff       	call   139e <printint>
        ap++;
    152d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1531:	e9 b3 00 00 00       	jmp    15e9 <printf+0x193>
      } else if(c == 's'){
    1536:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    153a:	75 45                	jne    1581 <printf+0x12b>
        s = (char*)*ap;
    153c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    153f:	8b 00                	mov    (%eax),%eax
    1541:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1544:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    154c:	75 09                	jne    1557 <printf+0x101>
          s = "(null)";
    154e:	c7 45 f4 ae 1b 00 00 	movl   $0x1bae,-0xc(%ebp)
        while(*s != 0){
    1555:	eb 1e                	jmp    1575 <printf+0x11f>
    1557:	eb 1c                	jmp    1575 <printf+0x11f>
          putc(fd, *s);
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	0f b6 00             	movzbl (%eax),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	89 44 24 04          	mov    %eax,0x4(%esp)
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	89 04 24             	mov    %eax,(%esp)
    156c:	e8 05 fe ff ff       	call   1376 <putc>
          s++;
    1571:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1578:	0f b6 00             	movzbl (%eax),%eax
    157b:	84 c0                	test   %al,%al
    157d:	75 da                	jne    1559 <printf+0x103>
    157f:	eb 68                	jmp    15e9 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1581:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1585:	75 1d                	jne    15a4 <printf+0x14e>
        putc(fd, *ap);
    1587:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158a:	8b 00                	mov    (%eax),%eax
    158c:	0f be c0             	movsbl %al,%eax
    158f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1593:	8b 45 08             	mov    0x8(%ebp),%eax
    1596:	89 04 24             	mov    %eax,(%esp)
    1599:	e8 d8 fd ff ff       	call   1376 <putc>
        ap++;
    159e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a2:	eb 45                	jmp    15e9 <printf+0x193>
      } else if(c == '%'){
    15a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a8:	75 17                	jne    15c1 <printf+0x16b>
        putc(fd, c);
    15aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15ad:	0f be c0             	movsbl %al,%eax
    15b0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b4:	8b 45 08             	mov    0x8(%ebp),%eax
    15b7:	89 04 24             	mov    %eax,(%esp)
    15ba:	e8 b7 fd ff ff       	call   1376 <putc>
    15bf:	eb 28                	jmp    15e9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15c8:	00 
    15c9:	8b 45 08             	mov    0x8(%ebp),%eax
    15cc:	89 04 24             	mov    %eax,(%esp)
    15cf:	e8 a2 fd ff ff       	call   1376 <putc>
        putc(fd, c);
    15d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d7:	0f be c0             	movsbl %al,%eax
    15da:	89 44 24 04          	mov    %eax,0x4(%esp)
    15de:	8b 45 08             	mov    0x8(%ebp),%eax
    15e1:	89 04 24             	mov    %eax,(%esp)
    15e4:	e8 8d fd ff ff       	call   1376 <putc>
      }
      state = 0;
    15e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15f4:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15fa:	01 d0                	add    %edx,%eax
    15fc:	0f b6 00             	movzbl (%eax),%eax
    15ff:	84 c0                	test   %al,%al
    1601:	0f 85 71 fe ff ff    	jne    1478 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1607:	c9                   	leave  
    1608:	c3                   	ret    

00001609 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1609:	55                   	push   %ebp
    160a:	89 e5                	mov    %esp,%ebp
    160c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    160f:	8b 45 08             	mov    0x8(%ebp),%eax
    1612:	83 e8 08             	sub    $0x8,%eax
    1615:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1618:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
    161d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1620:	eb 24                	jmp    1646 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1622:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1625:	8b 00                	mov    (%eax),%eax
    1627:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162a:	77 12                	ja     163e <free+0x35>
    162c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1632:	77 24                	ja     1658 <free+0x4f>
    1634:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1637:	8b 00                	mov    (%eax),%eax
    1639:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163c:	77 1a                	ja     1658 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1641:	8b 00                	mov    (%eax),%eax
    1643:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1646:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1649:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    164c:	76 d4                	jbe    1622 <free+0x19>
    164e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1651:	8b 00                	mov    (%eax),%eax
    1653:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1656:	76 ca                	jbe    1622 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1658:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165b:	8b 40 04             	mov    0x4(%eax),%eax
    165e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1665:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1668:	01 c2                	add    %eax,%edx
    166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166d:	8b 00                	mov    (%eax),%eax
    166f:	39 c2                	cmp    %eax,%edx
    1671:	75 24                	jne    1697 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1673:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1676:	8b 50 04             	mov    0x4(%eax),%edx
    1679:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167c:	8b 00                	mov    (%eax),%eax
    167e:	8b 40 04             	mov    0x4(%eax),%eax
    1681:	01 c2                	add    %eax,%edx
    1683:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1686:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1689:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168c:	8b 00                	mov    (%eax),%eax
    168e:	8b 10                	mov    (%eax),%edx
    1690:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1693:	89 10                	mov    %edx,(%eax)
    1695:	eb 0a                	jmp    16a1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1697:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169a:	8b 10                	mov    (%eax),%edx
    169c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a4:	8b 40 04             	mov    0x4(%eax),%eax
    16a7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b1:	01 d0                	add    %edx,%eax
    16b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16b6:	75 20                	jne    16d8 <free+0xcf>
    p->s.size += bp->s.size;
    16b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bb:	8b 50 04             	mov    0x4(%eax),%edx
    16be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c1:	8b 40 04             	mov    0x4(%eax),%eax
    16c4:	01 c2                	add    %eax,%edx
    16c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16cf:	8b 10                	mov    (%eax),%edx
    16d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d4:	89 10                	mov    %edx,(%eax)
    16d6:	eb 08                	jmp    16e0 <free+0xd7>
  } else
    p->s.ptr = bp;
    16d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16db:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16de:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e3:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
}
    16e8:	c9                   	leave  
    16e9:	c3                   	ret    

000016ea <morecore>:

static Header*
morecore(uint nu)
{
    16ea:	55                   	push   %ebp
    16eb:	89 e5                	mov    %esp,%ebp
    16ed:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16f7:	77 07                	ja     1700 <morecore+0x16>
    nu = 4096;
    16f9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1700:	8b 45 08             	mov    0x8(%ebp),%eax
    1703:	c1 e0 03             	shl    $0x3,%eax
    1706:	89 04 24             	mov    %eax,(%esp)
    1709:	e8 20 fc ff ff       	call   132e <sbrk>
    170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1711:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1715:	75 07                	jne    171e <morecore+0x34>
    return 0;
    1717:	b8 00 00 00 00       	mov    $0x0,%eax
    171c:	eb 22                	jmp    1740 <morecore+0x56>
  hp = (Header*)p;
    171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1721:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1724:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1727:	8b 55 08             	mov    0x8(%ebp),%edx
    172a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1730:	83 c0 08             	add    $0x8,%eax
    1733:	89 04 24             	mov    %eax,(%esp)
    1736:	e8 ce fe ff ff       	call   1609 <free>
  return freep;
    173b:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
}
    1740:	c9                   	leave  
    1741:	c3                   	ret    

00001742 <malloc>:

void*
malloc(uint nbytes)
{
    1742:	55                   	push   %ebp
    1743:	89 e5                	mov    %esp,%ebp
    1745:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1748:	8b 45 08             	mov    0x8(%ebp),%eax
    174b:	83 c0 07             	add    $0x7,%eax
    174e:	c1 e8 03             	shr    $0x3,%eax
    1751:	83 c0 01             	add    $0x1,%eax
    1754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1757:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
    175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    175f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1763:	75 23                	jne    1788 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1765:	c7 45 f0 dc 1f 00 00 	movl   $0x1fdc,-0x10(%ebp)
    176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176f:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
    1774:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
    1779:	a3 dc 1f 00 00       	mov    %eax,0x1fdc
    base.s.size = 0;
    177e:	c7 05 e0 1f 00 00 00 	movl   $0x0,0x1fe0
    1785:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1788:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178b:	8b 00                	mov    (%eax),%eax
    178d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1790:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1793:	8b 40 04             	mov    0x4(%eax),%eax
    1796:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1799:	72 4d                	jb     17e8 <malloc+0xa6>
      if(p->s.size == nunits)
    179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179e:	8b 40 04             	mov    0x4(%eax),%eax
    17a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a4:	75 0c                	jne    17b2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a9:	8b 10                	mov    (%eax),%edx
    17ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ae:	89 10                	mov    %edx,(%eax)
    17b0:	eb 26                	jmp    17d8 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b5:	8b 40 04             	mov    0x4(%eax),%eax
    17b8:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17bb:	89 c2                	mov    %eax,%edx
    17bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c6:	8b 40 04             	mov    0x4(%eax),%eax
    17c9:	c1 e0 03             	shl    $0x3,%eax
    17cc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17d5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17db:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
      return (void*)(p + 1);
    17e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e3:	83 c0 08             	add    $0x8,%eax
    17e6:	eb 38                	jmp    1820 <malloc+0xde>
    }
    if(p == freep)
    17e8:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
    17ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f0:	75 1b                	jne    180d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17f5:	89 04 24             	mov    %eax,(%esp)
    17f8:	e8 ed fe ff ff       	call   16ea <morecore>
    17fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1804:	75 07                	jne    180d <malloc+0xcb>
        return 0;
    1806:	b8 00 00 00 00       	mov    $0x0,%eax
    180b:	eb 13                	jmp    1820 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1810:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1813:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1816:	8b 00                	mov    (%eax),%eax
    1818:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    181b:	e9 70 ff ff ff       	jmp    1790 <malloc+0x4e>
}
    1820:	c9                   	leave  
    1821:	c3                   	ret    

00001822 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1822:	55                   	push   %ebp
    1823:	89 e5                	mov    %esp,%ebp
    1825:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1828:	8b 55 08             	mov    0x8(%ebp),%edx
    182b:	8b 45 0c             	mov    0xc(%ebp),%eax
    182e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1831:	f0 87 02             	lock xchg %eax,(%edx)
    1834:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1837:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    183a:	c9                   	leave  
    183b:	c3                   	ret    

0000183c <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    183c:	55                   	push   %ebp
    183d:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    183f:	8b 45 08             	mov    0x8(%ebp),%eax
    1842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1848:	5d                   	pop    %ebp
    1849:	c3                   	ret    

0000184a <lock_acquire>:
void lock_acquire(lock_t *lock){
    184a:	55                   	push   %ebp
    184b:	89 e5                	mov    %esp,%ebp
    184d:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1850:	90                   	nop
    1851:	8b 45 08             	mov    0x8(%ebp),%eax
    1854:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    185b:	00 
    185c:	89 04 24             	mov    %eax,(%esp)
    185f:	e8 be ff ff ff       	call   1822 <xchg>
    1864:	85 c0                	test   %eax,%eax
    1866:	75 e9                	jne    1851 <lock_acquire+0x7>
}
    1868:	c9                   	leave  
    1869:	c3                   	ret    

0000186a <lock_release>:
void lock_release(lock_t *lock){
    186a:	55                   	push   %ebp
    186b:	89 e5                	mov    %esp,%ebp
    186d:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1870:	8b 45 08             	mov    0x8(%ebp),%eax
    1873:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    187a:	00 
    187b:	89 04 24             	mov    %eax,(%esp)
    187e:	e8 9f ff ff ff       	call   1822 <xchg>
}
    1883:	c9                   	leave  
    1884:	c3                   	ret    

00001885 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1885:	55                   	push   %ebp
    1886:	89 e5                	mov    %esp,%ebp
    1888:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    188b:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1892:	e8 ab fe ff ff       	call   1742 <malloc>
    1897:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18a0:	0f b6 05 e8 1f 00 00 	movzbl 0x1fe8,%eax
    18a7:	84 c0                	test   %al,%al
    18a9:	75 1c                	jne    18c7 <thread_create+0x42>
        init_q(thQ2);
    18ab:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    18b0:	89 04 24             	mov    %eax,(%esp)
    18b3:	e8 cd 01 00 00       	call   1a85 <init_q>
        inQ++;
    18b8:	0f b6 05 e8 1f 00 00 	movzbl 0x1fe8,%eax
    18bf:	83 c0 01             	add    $0x1,%eax
    18c2:	a2 e8 1f 00 00       	mov    %al,0x1fe8
    }

    if((uint)stack % 4096){
    18c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ca:	25 ff 0f 00 00       	and    $0xfff,%eax
    18cf:	85 c0                	test   %eax,%eax
    18d1:	74 14                	je     18e7 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    18d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d6:	25 ff 0f 00 00       	and    $0xfff,%eax
    18db:	89 c2                	mov    %eax,%edx
    18dd:	b8 00 10 00 00       	mov    $0x1000,%eax
    18e2:	29 d0                	sub    %edx,%eax
    18e4:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    18e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18eb:	75 1e                	jne    190b <thread_create+0x86>

        printf(1,"malloc fail \n");
    18ed:	c7 44 24 04 b5 1b 00 	movl   $0x1bb5,0x4(%esp)
    18f4:	00 
    18f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18fc:	e8 55 fb ff ff       	call   1456 <printf>
        return 0;
    1901:	b8 00 00 00 00       	mov    $0x0,%eax
    1906:	e9 9e 00 00 00       	jmp    19a9 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    190b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    190e:	8b 55 08             	mov    0x8(%ebp),%edx
    1911:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1914:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1918:	89 54 24 08          	mov    %edx,0x8(%esp)
    191c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1923:	00 
    1924:	89 04 24             	mov    %eax,(%esp)
    1927:	e8 1a fa ff ff       	call   1346 <clone>
    192c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    192f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1932:	89 44 24 08          	mov    %eax,0x8(%esp)
    1936:	c7 44 24 04 c3 1b 00 	movl   $0x1bc3,0x4(%esp)
    193d:	00 
    193e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1945:	e8 0c fb ff ff       	call   1456 <printf>
    if(tid < 0){
    194a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    194e:	79 1b                	jns    196b <thread_create+0xe6>
        printf(1,"clone fails\n");
    1950:	c7 44 24 04 dc 1b 00 	movl   $0x1bdc,0x4(%esp)
    1957:	00 
    1958:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    195f:	e8 f2 fa ff ff       	call   1456 <printf>
        return 0;
    1964:	b8 00 00 00 00       	mov    $0x0,%eax
    1969:	eb 3e                	jmp    19a9 <thread_create+0x124>
    }
    if(tid > 0){
    196b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    196f:	7e 19                	jle    198a <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1971:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    1976:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1979:	89 54 24 04          	mov    %edx,0x4(%esp)
    197d:	89 04 24             	mov    %eax,(%esp)
    1980:	e8 22 01 00 00       	call   1aa7 <add_q>
        return garbage_stack;
    1985:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1988:	eb 1f                	jmp    19a9 <thread_create+0x124>
    }
    if(tid == 0){
    198a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    198e:	75 14                	jne    19a4 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1990:	c7 44 24 04 e9 1b 00 	movl   $0x1be9,0x4(%esp)
    1997:	00 
    1998:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    199f:	e8 b2 fa ff ff       	call   1456 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19a9:	c9                   	leave  
    19aa:	c3                   	ret    

000019ab <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19ab:	55                   	push   %ebp
    19ac:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19ae:	a1 d8 1f 00 00       	mov    0x1fd8,%eax
    19b3:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    19b9:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19be:	a3 d8 1f 00 00       	mov    %eax,0x1fd8
    return (int)(rands % max);
    19c3:	a1 d8 1f 00 00       	mov    0x1fd8,%eax
    19c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19cb:	ba 00 00 00 00       	mov    $0x0,%edx
    19d0:	f7 f1                	div    %ecx
    19d2:	89 d0                	mov    %edx,%eax
}
    19d4:	5d                   	pop    %ebp
    19d5:	c3                   	ret    

000019d6 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    19d6:	55                   	push   %ebp
    19d7:	89 e5                	mov    %esp,%ebp
    19d9:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    19dc:	e8 45 f9 ff ff       	call   1326 <getpid>
    19e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    19e4:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    19e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    19ec:	89 54 24 04          	mov    %edx,0x4(%esp)
    19f0:	89 04 24             	mov    %eax,(%esp)
    19f3:	e8 af 00 00 00       	call   1aa7 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    19f8:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    19fd:	89 04 24             	mov    %eax,(%esp)
    1a00:	e8 1c 01 00 00       	call   1b21 <pop_q>
    1a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a08:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    1a0d:	85 c0                	test   %eax,%eax
    1a0f:	75 1f                	jne    1a30 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a11:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    1a16:	89 04 24             	mov    %eax,(%esp)
    1a19:	e8 03 01 00 00       	call   1b21 <pop_q>
    1a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a21:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    1a26:	83 c0 01             	add    $0x1,%eax
    1a29:	a3 ec 1f 00 00       	mov    %eax,0x1fec
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a2e:	eb 12                	jmp    1a42 <thread_yield2+0x6c>
    1a30:	eb 10                	jmp    1a42 <thread_yield2+0x6c>
    1a32:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    1a37:	89 04 24             	mov    %eax,(%esp)
    1a3a:	e8 e2 00 00 00       	call   1b21 <pop_q>
    1a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a48:	74 e8                	je     1a32 <thread_yield2+0x5c>
    1a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a4e:	74 e2                	je     1a32 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a53:	89 04 24             	mov    %eax,(%esp)
    1a56:	e8 03 f9 ff ff       	call   135e <twakeup>
    tsleep();
    1a5b:	e8 f6 f8 ff ff       	call   1356 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a60:	c9                   	leave  
    1a61:	c3                   	ret    

00001a62 <thread_yield_last>:

void thread_yield_last(){
    1a62:	55                   	push   %ebp
    1a63:	89 e5                	mov    %esp,%ebp
    1a65:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1a68:	a1 f0 1f 00 00       	mov    0x1ff0,%eax
    1a6d:	89 04 24             	mov    %eax,(%esp)
    1a70:	e8 ac 00 00 00       	call   1b21 <pop_q>
    1a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7b:	89 04 24             	mov    %eax,(%esp)
    1a7e:	e8 db f8 ff ff       	call   135e <twakeup>
    1a83:	c9                   	leave  
    1a84:	c3                   	ret    

00001a85 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1a85:	55                   	push   %ebp
    1a86:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1a88:	8b 45 08             	mov    0x8(%ebp),%eax
    1a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1a91:	8b 45 08             	mov    0x8(%ebp),%eax
    1a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1a9b:	8b 45 08             	mov    0x8(%ebp),%eax
    1a9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1aa5:	5d                   	pop    %ebp
    1aa6:	c3                   	ret    

00001aa7 <add_q>:

void add_q(struct queue *q, int v){
    1aa7:	55                   	push   %ebp
    1aa8:	89 e5                	mov    %esp,%ebp
    1aaa:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1aad:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ab4:	e8 89 fc ff ff       	call   1742 <malloc>
    1ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
    1acc:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1ace:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad1:	8b 40 04             	mov    0x4(%eax),%eax
    1ad4:	85 c0                	test   %eax,%eax
    1ad6:	75 0b                	jne    1ae3 <add_q+0x3c>
        q->head = n;
    1ad8:	8b 45 08             	mov    0x8(%ebp),%eax
    1adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ade:	89 50 04             	mov    %edx,0x4(%eax)
    1ae1:	eb 0c                	jmp    1aef <add_q+0x48>
    }else{
        q->tail->next = n;
    1ae3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae6:	8b 40 08             	mov    0x8(%eax),%eax
    1ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1aec:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1aef:	8b 45 08             	mov    0x8(%ebp),%eax
    1af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1af5:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1af8:	8b 45 08             	mov    0x8(%ebp),%eax
    1afb:	8b 00                	mov    (%eax),%eax
    1afd:	8d 50 01             	lea    0x1(%eax),%edx
    1b00:	8b 45 08             	mov    0x8(%ebp),%eax
    1b03:	89 10                	mov    %edx,(%eax)
}
    1b05:	c9                   	leave  
    1b06:	c3                   	ret    

00001b07 <empty_q>:

int empty_q(struct queue *q){
    1b07:	55                   	push   %ebp
    1b08:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b0a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0d:	8b 00                	mov    (%eax),%eax
    1b0f:	85 c0                	test   %eax,%eax
    1b11:	75 07                	jne    1b1a <empty_q+0x13>
        return 1;
    1b13:	b8 01 00 00 00       	mov    $0x1,%eax
    1b18:	eb 05                	jmp    1b1f <empty_q+0x18>
    else
        return 0;
    1b1a:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b1f:	5d                   	pop    %ebp
    1b20:	c3                   	ret    

00001b21 <pop_q>:
int pop_q(struct queue *q){
    1b21:	55                   	push   %ebp
    1b22:	89 e5                	mov    %esp,%ebp
    1b24:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b27:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2a:	89 04 24             	mov    %eax,(%esp)
    1b2d:	e8 d5 ff ff ff       	call   1b07 <empty_q>
    1b32:	85 c0                	test   %eax,%eax
    1b34:	75 5d                	jne    1b93 <pop_q+0x72>
       val = q->head->value; 
    1b36:	8b 45 08             	mov    0x8(%ebp),%eax
    1b39:	8b 40 04             	mov    0x4(%eax),%eax
    1b3c:	8b 00                	mov    (%eax),%eax
    1b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b41:	8b 45 08             	mov    0x8(%ebp),%eax
    1b44:	8b 40 04             	mov    0x4(%eax),%eax
    1b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b4a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b4d:	8b 40 04             	mov    0x4(%eax),%eax
    1b50:	8b 50 04             	mov    0x4(%eax),%edx
    1b53:	8b 45 08             	mov    0x8(%ebp),%eax
    1b56:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b5c:	89 04 24             	mov    %eax,(%esp)
    1b5f:	e8 a5 fa ff ff       	call   1609 <free>
       q->size--;
    1b64:	8b 45 08             	mov    0x8(%ebp),%eax
    1b67:	8b 00                	mov    (%eax),%eax
    1b69:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b6c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1b71:	8b 45 08             	mov    0x8(%ebp),%eax
    1b74:	8b 00                	mov    (%eax),%eax
    1b76:	85 c0                	test   %eax,%eax
    1b78:	75 14                	jne    1b8e <pop_q+0x6d>
            q->head = 0;
    1b7a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1b84:	8b 45 08             	mov    0x8(%ebp),%eax
    1b87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b91:	eb 05                	jmp    1b98 <pop_q+0x77>
    }
    return -1;
    1b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1b98:	c9                   	leave  
    1b99:	c3                   	ret    
