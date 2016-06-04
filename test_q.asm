
_test_q:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "user.h"
#include "queue.h"

int main(){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
    struct queue *q = malloc(sizeof(struct queue));
    1009:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    1010:	e8 79 07 00 00       	call   178e <malloc>
    1015:	89 44 24 18          	mov    %eax,0x18(%esp)
    int i;
    init_q(q);
    1019:	8b 44 24 18          	mov    0x18(%esp),%eax
    101d:	89 04 24             	mov    %eax,(%esp)
    1020:	e8 91 0a 00 00       	call   1ab6 <init_q>
    for(i=0;i<10;i++){
    1025:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    102c:	00 
    102d:	eb 19                	jmp    1048 <main+0x48>
        add_q(q,i);
    102f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1033:	89 44 24 04          	mov    %eax,0x4(%esp)
    1037:	8b 44 24 18          	mov    0x18(%esp),%eax
    103b:	89 04 24             	mov    %eax,(%esp)
    103e:	e8 95 0a 00 00       	call   1ad8 <add_q>

int main(){
    struct queue *q = malloc(sizeof(struct queue));
    int i;
    init_q(q);
    for(i=0;i<10;i++){
    1043:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1048:	83 7c 24 1c 09       	cmpl   $0x9,0x1c(%esp)
    104d:	7e e0                	jle    102f <main+0x2f>
        add_q(q,i);
    }
    for(;!empty_q(q);){
    104f:	eb 24                	jmp    1075 <main+0x75>
        printf(1,"pop %d\n",pop_q(q));
    1051:	8b 44 24 18          	mov    0x18(%esp),%eax
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 f5 0a 00 00       	call   1b52 <pop_q>
    105d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1061:	c7 44 24 04 cb 1b 00 	movl   $0x1bcb,0x4(%esp)
    1068:	00 
    1069:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1070:	e8 2d 04 00 00       	call   14a2 <printf>
    int i;
    init_q(q);
    for(i=0;i<10;i++){
        add_q(q,i);
    }
    for(;!empty_q(q);){
    1075:	8b 44 24 18          	mov    0x18(%esp),%eax
    1079:	89 04 24             	mov    %eax,(%esp)
    107c:	e8 b7 0a 00 00       	call   1b38 <empty_q>
    1081:	85 c0                	test   %eax,%eax
    1083:	74 cc                	je     1051 <main+0x51>
        printf(1,"pop %d\n",pop_q(q));
    }
    exit();
    1085:	e8 68 02 00 00       	call   12f2 <exit>

0000108a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    108a:	55                   	push   %ebp
    108b:	89 e5                	mov    %esp,%ebp
    108d:	57                   	push   %edi
    108e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    108f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1092:	8b 55 10             	mov    0x10(%ebp),%edx
    1095:	8b 45 0c             	mov    0xc(%ebp),%eax
    1098:	89 cb                	mov    %ecx,%ebx
    109a:	89 df                	mov    %ebx,%edi
    109c:	89 d1                	mov    %edx,%ecx
    109e:	fc                   	cld    
    109f:	f3 aa                	rep stos %al,%es:(%edi)
    10a1:	89 ca                	mov    %ecx,%edx
    10a3:	89 fb                	mov    %edi,%ebx
    10a5:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10a8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10ab:	5b                   	pop    %ebx
    10ac:	5f                   	pop    %edi
    10ad:	5d                   	pop    %ebp
    10ae:	c3                   	ret    

000010af <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10af:	55                   	push   %ebp
    10b0:	89 e5                	mov    %esp,%ebp
    10b2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10b5:	8b 45 08             	mov    0x8(%ebp),%eax
    10b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10bb:	90                   	nop
    10bc:	8b 45 08             	mov    0x8(%ebp),%eax
    10bf:	8d 50 01             	lea    0x1(%eax),%edx
    10c2:	89 55 08             	mov    %edx,0x8(%ebp)
    10c5:	8b 55 0c             	mov    0xc(%ebp),%edx
    10c8:	8d 4a 01             	lea    0x1(%edx),%ecx
    10cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10ce:	0f b6 12             	movzbl (%edx),%edx
    10d1:	88 10                	mov    %dl,(%eax)
    10d3:	0f b6 00             	movzbl (%eax),%eax
    10d6:	84 c0                	test   %al,%al
    10d8:	75 e2                	jne    10bc <strcpy+0xd>
    ;
  return os;
    10da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10dd:	c9                   	leave  
    10de:	c3                   	ret    

000010df <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10df:	55                   	push   %ebp
    10e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e2:	eb 08                	jmp    10ec <strcmp+0xd>
    p++, q++;
    10e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10ec:	8b 45 08             	mov    0x8(%ebp),%eax
    10ef:	0f b6 00             	movzbl (%eax),%eax
    10f2:	84 c0                	test   %al,%al
    10f4:	74 10                	je     1106 <strcmp+0x27>
    10f6:	8b 45 08             	mov    0x8(%ebp),%eax
    10f9:	0f b6 10             	movzbl (%eax),%edx
    10fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ff:	0f b6 00             	movzbl (%eax),%eax
    1102:	38 c2                	cmp    %al,%dl
    1104:	74 de                	je     10e4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
    1109:	0f b6 00             	movzbl (%eax),%eax
    110c:	0f b6 d0             	movzbl %al,%edx
    110f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1112:	0f b6 00             	movzbl (%eax),%eax
    1115:	0f b6 c0             	movzbl %al,%eax
    1118:	29 c2                	sub    %eax,%edx
    111a:	89 d0                	mov    %edx,%eax
}
    111c:	5d                   	pop    %ebp
    111d:	c3                   	ret    

0000111e <strlen>:

uint
strlen(char *s)
{
    111e:	55                   	push   %ebp
    111f:	89 e5                	mov    %esp,%ebp
    1121:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    112b:	eb 04                	jmp    1131 <strlen+0x13>
    112d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1131:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1134:	8b 45 08             	mov    0x8(%ebp),%eax
    1137:	01 d0                	add    %edx,%eax
    1139:	0f b6 00             	movzbl (%eax),%eax
    113c:	84 c0                	test   %al,%al
    113e:	75 ed                	jne    112d <strlen+0xf>
    ;
  return n;
    1140:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1143:	c9                   	leave  
    1144:	c3                   	ret    

00001145 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1145:	55                   	push   %ebp
    1146:	89 e5                	mov    %esp,%ebp
    1148:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    114b:	8b 45 10             	mov    0x10(%ebp),%eax
    114e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1152:	8b 45 0c             	mov    0xc(%ebp),%eax
    1155:	89 44 24 04          	mov    %eax,0x4(%esp)
    1159:	8b 45 08             	mov    0x8(%ebp),%eax
    115c:	89 04 24             	mov    %eax,(%esp)
    115f:	e8 26 ff ff ff       	call   108a <stosb>
  return dst;
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1167:	c9                   	leave  
    1168:	c3                   	ret    

00001169 <strchr>:

char*
strchr(const char *s, char c)
{
    1169:	55                   	push   %ebp
    116a:	89 e5                	mov    %esp,%ebp
    116c:	83 ec 04             	sub    $0x4,%esp
    116f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1172:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1175:	eb 14                	jmp    118b <strchr+0x22>
    if(*s == c)
    1177:	8b 45 08             	mov    0x8(%ebp),%eax
    117a:	0f b6 00             	movzbl (%eax),%eax
    117d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1180:	75 05                	jne    1187 <strchr+0x1e>
      return (char*)s;
    1182:	8b 45 08             	mov    0x8(%ebp),%eax
    1185:	eb 13                	jmp    119a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1187:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	0f b6 00             	movzbl (%eax),%eax
    1191:	84 c0                	test   %al,%al
    1193:	75 e2                	jne    1177 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1195:	b8 00 00 00 00       	mov    $0x0,%eax
}
    119a:	c9                   	leave  
    119b:	c3                   	ret    

0000119c <gets>:

char*
gets(char *buf, int max)
{
    119c:	55                   	push   %ebp
    119d:	89 e5                	mov    %esp,%ebp
    119f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11a9:	eb 4c                	jmp    11f7 <gets+0x5b>
    cc = read(0, &c, 1);
    11ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11b2:	00 
    11b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c1:	e8 44 01 00 00       	call   130a <read>
    11c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11cd:	7f 02                	jg     11d1 <gets+0x35>
      break;
    11cf:	eb 31                	jmp    1202 <gets+0x66>
    buf[i++] = c;
    11d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d4:	8d 50 01             	lea    0x1(%eax),%edx
    11d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11da:	89 c2                	mov    %eax,%edx
    11dc:	8b 45 08             	mov    0x8(%ebp),%eax
    11df:	01 c2                	add    %eax,%edx
    11e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11e5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11eb:	3c 0a                	cmp    $0xa,%al
    11ed:	74 13                	je     1202 <gets+0x66>
    11ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f3:	3c 0d                	cmp    $0xd,%al
    11f5:	74 0b                	je     1202 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11fa:	83 c0 01             	add    $0x1,%eax
    11fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1200:	7c a9                	jl     11ab <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1202:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	01 d0                	add    %edx,%eax
    120a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    120d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1210:	c9                   	leave  
    1211:	c3                   	ret    

00001212 <stat>:

int
stat(char *n, struct stat *st)
{
    1212:	55                   	push   %ebp
    1213:	89 e5                	mov    %esp,%ebp
    1215:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1218:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    121f:	00 
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
    1223:	89 04 24             	mov    %eax,(%esp)
    1226:	e8 07 01 00 00       	call   1332 <open>
    122b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    122e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1232:	79 07                	jns    123b <stat+0x29>
    return -1;
    1234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1239:	eb 23                	jmp    125e <stat+0x4c>
  r = fstat(fd, st);
    123b:	8b 45 0c             	mov    0xc(%ebp),%eax
    123e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1242:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1245:	89 04 24             	mov    %eax,(%esp)
    1248:	e8 fd 00 00 00       	call   134a <fstat>
    124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1250:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 bf 00 00 00       	call   131a <close>
  return r;
    125b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    125e:	c9                   	leave  
    125f:	c3                   	ret    

00001260 <atoi>:

int
atoi(const char *s)
{
    1260:	55                   	push   %ebp
    1261:	89 e5                	mov    %esp,%ebp
    1263:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    126d:	eb 25                	jmp    1294 <atoi+0x34>
    n = n*10 + *s++ - '0';
    126f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1272:	89 d0                	mov    %edx,%eax
    1274:	c1 e0 02             	shl    $0x2,%eax
    1277:	01 d0                	add    %edx,%eax
    1279:	01 c0                	add    %eax,%eax
    127b:	89 c1                	mov    %eax,%ecx
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	8d 50 01             	lea    0x1(%eax),%edx
    1283:	89 55 08             	mov    %edx,0x8(%ebp)
    1286:	0f b6 00             	movzbl (%eax),%eax
    1289:	0f be c0             	movsbl %al,%eax
    128c:	01 c8                	add    %ecx,%eax
    128e:	83 e8 30             	sub    $0x30,%eax
    1291:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1294:	8b 45 08             	mov    0x8(%ebp),%eax
    1297:	0f b6 00             	movzbl (%eax),%eax
    129a:	3c 2f                	cmp    $0x2f,%al
    129c:	7e 0a                	jle    12a8 <atoi+0x48>
    129e:	8b 45 08             	mov    0x8(%ebp),%eax
    12a1:	0f b6 00             	movzbl (%eax),%eax
    12a4:	3c 39                	cmp    $0x39,%al
    12a6:	7e c7                	jle    126f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12ab:	c9                   	leave  
    12ac:	c3                   	ret    

000012ad <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12ad:	55                   	push   %ebp
    12ae:	89 e5                	mov    %esp,%ebp
    12b0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
    12b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12bf:	eb 17                	jmp    12d8 <memmove+0x2b>
    *dst++ = *src++;
    12c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c4:	8d 50 01             	lea    0x1(%eax),%edx
    12c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12cd:	8d 4a 01             	lea    0x1(%edx),%ecx
    12d0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12d3:	0f b6 12             	movzbl (%edx),%edx
    12d6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12d8:	8b 45 10             	mov    0x10(%ebp),%eax
    12db:	8d 50 ff             	lea    -0x1(%eax),%edx
    12de:	89 55 10             	mov    %edx,0x10(%ebp)
    12e1:	85 c0                	test   %eax,%eax
    12e3:	7f dc                	jg     12c1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12e8:	c9                   	leave  
    12e9:	c3                   	ret    

000012ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ea:	b8 01 00 00 00       	mov    $0x1,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <exit>:
SYSCALL(exit)
    12f2:	b8 02 00 00 00       	mov    $0x2,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <wait>:
SYSCALL(wait)
    12fa:	b8 03 00 00 00       	mov    $0x3,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <pipe>:
SYSCALL(pipe)
    1302:	b8 04 00 00 00       	mov    $0x4,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    

0000130a <read>:
SYSCALL(read)
    130a:	b8 05 00 00 00       	mov    $0x5,%eax
    130f:	cd 40                	int    $0x40
    1311:	c3                   	ret    

00001312 <write>:
SYSCALL(write)
    1312:	b8 10 00 00 00       	mov    $0x10,%eax
    1317:	cd 40                	int    $0x40
    1319:	c3                   	ret    

0000131a <close>:
SYSCALL(close)
    131a:	b8 15 00 00 00       	mov    $0x15,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    

00001322 <kill>:
SYSCALL(kill)
    1322:	b8 06 00 00 00       	mov    $0x6,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <exec>:
SYSCALL(exec)
    132a:	b8 07 00 00 00       	mov    $0x7,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <open>:
SYSCALL(open)
    1332:	b8 0f 00 00 00       	mov    $0xf,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <mknod>:
SYSCALL(mknod)
    133a:	b8 11 00 00 00       	mov    $0x11,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <unlink>:
SYSCALL(unlink)
    1342:	b8 12 00 00 00       	mov    $0x12,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <fstat>:
SYSCALL(fstat)
    134a:	b8 08 00 00 00       	mov    $0x8,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <link>:
SYSCALL(link)
    1352:	b8 13 00 00 00       	mov    $0x13,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <mkdir>:
SYSCALL(mkdir)
    135a:	b8 14 00 00 00       	mov    $0x14,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <chdir>:
SYSCALL(chdir)
    1362:	b8 09 00 00 00       	mov    $0x9,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <dup>:
SYSCALL(dup)
    136a:	b8 0a 00 00 00       	mov    $0xa,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <getpid>:
SYSCALL(getpid)
    1372:	b8 0b 00 00 00       	mov    $0xb,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <sbrk>:
SYSCALL(sbrk)
    137a:	b8 0c 00 00 00       	mov    $0xc,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <sleep>:
SYSCALL(sleep)
    1382:	b8 0d 00 00 00       	mov    $0xd,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <uptime>:
SYSCALL(uptime)
    138a:	b8 0e 00 00 00       	mov    $0xe,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <clone>:
SYSCALL(clone)
    1392:	b8 16 00 00 00       	mov    $0x16,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <texit>:
SYSCALL(texit)
    139a:	b8 17 00 00 00       	mov    $0x17,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <tsleep>:
SYSCALL(tsleep)
    13a2:	b8 18 00 00 00       	mov    $0x18,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <twakeup>:
SYSCALL(twakeup)
    13aa:	b8 19 00 00 00       	mov    $0x19,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <thread_yield>:
SYSCALL(thread_yield)
    13b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <thread_yield3>:
    13ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13c2:	55                   	push   %ebp
    13c3:	89 e5                	mov    %esp,%ebp
    13c5:	83 ec 18             	sub    $0x18,%esp
    13c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13d5:	00 
    13d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    13dd:	8b 45 08             	mov    0x8(%ebp),%eax
    13e0:	89 04 24             	mov    %eax,(%esp)
    13e3:	e8 2a ff ff ff       	call   1312 <write>
}
    13e8:	c9                   	leave  
    13e9:	c3                   	ret    

000013ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13ea:	55                   	push   %ebp
    13eb:	89 e5                	mov    %esp,%ebp
    13ed:	56                   	push   %esi
    13ee:	53                   	push   %ebx
    13ef:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13fd:	74 17                	je     1416 <printint+0x2c>
    13ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1403:	79 11                	jns    1416 <printint+0x2c>
    neg = 1;
    1405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    140c:	8b 45 0c             	mov    0xc(%ebp),%eax
    140f:	f7 d8                	neg    %eax
    1411:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1414:	eb 06                	jmp    141c <printint+0x32>
  } else {
    x = xx;
    1416:	8b 45 0c             	mov    0xc(%ebp),%eax
    1419:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1423:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1426:	8d 41 01             	lea    0x1(%ecx),%eax
    1429:	89 45 f4             	mov    %eax,-0xc(%ebp)
    142c:	8b 5d 10             	mov    0x10(%ebp),%ebx
    142f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1432:	ba 00 00 00 00       	mov    $0x0,%edx
    1437:	f7 f3                	div    %ebx
    1439:	89 d0                	mov    %edx,%eax
    143b:	0f b6 80 cc 1f 00 00 	movzbl 0x1fcc(%eax),%eax
    1442:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1446:	8b 75 10             	mov    0x10(%ebp),%esi
    1449:	8b 45 ec             	mov    -0x14(%ebp),%eax
    144c:	ba 00 00 00 00       	mov    $0x0,%edx
    1451:	f7 f6                	div    %esi
    1453:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    145a:	75 c7                	jne    1423 <printint+0x39>
  if(neg)
    145c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1460:	74 10                	je     1472 <printint+0x88>
    buf[i++] = '-';
    1462:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1465:	8d 50 01             	lea    0x1(%eax),%edx
    1468:	89 55 f4             	mov    %edx,-0xc(%ebp)
    146b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1470:	eb 1f                	jmp    1491 <printint+0xa7>
    1472:	eb 1d                	jmp    1491 <printint+0xa7>
    putc(fd, buf[i]);
    1474:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1477:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147a:	01 d0                	add    %edx,%eax
    147c:	0f b6 00             	movzbl (%eax),%eax
    147f:	0f be c0             	movsbl %al,%eax
    1482:	89 44 24 04          	mov    %eax,0x4(%esp)
    1486:	8b 45 08             	mov    0x8(%ebp),%eax
    1489:	89 04 24             	mov    %eax,(%esp)
    148c:	e8 31 ff ff ff       	call   13c2 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1491:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1499:	79 d9                	jns    1474 <printint+0x8a>
    putc(fd, buf[i]);
}
    149b:	83 c4 30             	add    $0x30,%esp
    149e:	5b                   	pop    %ebx
    149f:	5e                   	pop    %esi
    14a0:	5d                   	pop    %ebp
    14a1:	c3                   	ret    

000014a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14a2:	55                   	push   %ebp
    14a3:	89 e5                	mov    %esp,%ebp
    14a5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14af:	8d 45 0c             	lea    0xc(%ebp),%eax
    14b2:	83 c0 04             	add    $0x4,%eax
    14b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14bf:	e9 7c 01 00 00       	jmp    1640 <printf+0x19e>
    c = fmt[i] & 0xff;
    14c4:	8b 55 0c             	mov    0xc(%ebp),%edx
    14c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14ca:	01 d0                	add    %edx,%eax
    14cc:	0f b6 00             	movzbl (%eax),%eax
    14cf:	0f be c0             	movsbl %al,%eax
    14d2:	25 ff 00 00 00       	and    $0xff,%eax
    14d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14de:	75 2c                	jne    150c <printf+0x6a>
      if(c == '%'){
    14e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14e4:	75 0c                	jne    14f2 <printf+0x50>
        state = '%';
    14e6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14ed:	e9 4a 01 00 00       	jmp    163c <printf+0x19a>
      } else {
        putc(fd, c);
    14f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14f5:	0f be c0             	movsbl %al,%eax
    14f8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fc:	8b 45 08             	mov    0x8(%ebp),%eax
    14ff:	89 04 24             	mov    %eax,(%esp)
    1502:	e8 bb fe ff ff       	call   13c2 <putc>
    1507:	e9 30 01 00 00       	jmp    163c <printf+0x19a>
      }
    } else if(state == '%'){
    150c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1510:	0f 85 26 01 00 00    	jne    163c <printf+0x19a>
      if(c == 'd'){
    1516:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    151a:	75 2d                	jne    1549 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    151c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151f:	8b 00                	mov    (%eax),%eax
    1521:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1528:	00 
    1529:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1530:	00 
    1531:	89 44 24 04          	mov    %eax,0x4(%esp)
    1535:	8b 45 08             	mov    0x8(%ebp),%eax
    1538:	89 04 24             	mov    %eax,(%esp)
    153b:	e8 aa fe ff ff       	call   13ea <printint>
        ap++;
    1540:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1544:	e9 ec 00 00 00       	jmp    1635 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1549:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    154d:	74 06                	je     1555 <printf+0xb3>
    154f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1553:	75 2d                	jne    1582 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1555:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1558:	8b 00                	mov    (%eax),%eax
    155a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1561:	00 
    1562:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1569:	00 
    156a:	89 44 24 04          	mov    %eax,0x4(%esp)
    156e:	8b 45 08             	mov    0x8(%ebp),%eax
    1571:	89 04 24             	mov    %eax,(%esp)
    1574:	e8 71 fe ff ff       	call   13ea <printint>
        ap++;
    1579:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    157d:	e9 b3 00 00 00       	jmp    1635 <printf+0x193>
      } else if(c == 's'){
    1582:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1586:	75 45                	jne    15cd <printf+0x12b>
        s = (char*)*ap;
    1588:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158b:	8b 00                	mov    (%eax),%eax
    158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1590:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1598:	75 09                	jne    15a3 <printf+0x101>
          s = "(null)";
    159a:	c7 45 f4 d3 1b 00 00 	movl   $0x1bd3,-0xc(%ebp)
        while(*s != 0){
    15a1:	eb 1e                	jmp    15c1 <printf+0x11f>
    15a3:	eb 1c                	jmp    15c1 <printf+0x11f>
          putc(fd, *s);
    15a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a8:	0f b6 00             	movzbl (%eax),%eax
    15ab:	0f be c0             	movsbl %al,%eax
    15ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b2:	8b 45 08             	mov    0x8(%ebp),%eax
    15b5:	89 04 24             	mov    %eax,(%esp)
    15b8:	e8 05 fe ff ff       	call   13c2 <putc>
          s++;
    15bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c4:	0f b6 00             	movzbl (%eax),%eax
    15c7:	84 c0                	test   %al,%al
    15c9:	75 da                	jne    15a5 <printf+0x103>
    15cb:	eb 68                	jmp    1635 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15cd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15d1:	75 1d                	jne    15f0 <printf+0x14e>
        putc(fd, *ap);
    15d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15d6:	8b 00                	mov    (%eax),%eax
    15d8:	0f be c0             	movsbl %al,%eax
    15db:	89 44 24 04          	mov    %eax,0x4(%esp)
    15df:	8b 45 08             	mov    0x8(%ebp),%eax
    15e2:	89 04 24             	mov    %eax,(%esp)
    15e5:	e8 d8 fd ff ff       	call   13c2 <putc>
        ap++;
    15ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ee:	eb 45                	jmp    1635 <printf+0x193>
      } else if(c == '%'){
    15f0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15f4:	75 17                	jne    160d <printf+0x16b>
        putc(fd, c);
    15f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15f9:	0f be c0             	movsbl %al,%eax
    15fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1600:	8b 45 08             	mov    0x8(%ebp),%eax
    1603:	89 04 24             	mov    %eax,(%esp)
    1606:	e8 b7 fd ff ff       	call   13c2 <putc>
    160b:	eb 28                	jmp    1635 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    160d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1614:	00 
    1615:	8b 45 08             	mov    0x8(%ebp),%eax
    1618:	89 04 24             	mov    %eax,(%esp)
    161b:	e8 a2 fd ff ff       	call   13c2 <putc>
        putc(fd, c);
    1620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1623:	0f be c0             	movsbl %al,%eax
    1626:	89 44 24 04          	mov    %eax,0x4(%esp)
    162a:	8b 45 08             	mov    0x8(%ebp),%eax
    162d:	89 04 24             	mov    %eax,(%esp)
    1630:	e8 8d fd ff ff       	call   13c2 <putc>
      }
      state = 0;
    1635:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    163c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1640:	8b 55 0c             	mov    0xc(%ebp),%edx
    1643:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1646:	01 d0                	add    %edx,%eax
    1648:	0f b6 00             	movzbl (%eax),%eax
    164b:	84 c0                	test   %al,%al
    164d:	0f 85 71 fe ff ff    	jne    14c4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1653:	c9                   	leave  
    1654:	c3                   	ret    

00001655 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1655:	55                   	push   %ebp
    1656:	89 e5                	mov    %esp,%ebp
    1658:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    165b:	8b 45 08             	mov    0x8(%ebp),%eax
    165e:	83 e8 08             	sub    $0x8,%eax
    1661:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1664:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    1669:	89 45 fc             	mov    %eax,-0x4(%ebp)
    166c:	eb 24                	jmp    1692 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1671:	8b 00                	mov    (%eax),%eax
    1673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1676:	77 12                	ja     168a <free+0x35>
    1678:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    167e:	77 24                	ja     16a4 <free+0x4f>
    1680:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1683:	8b 00                	mov    (%eax),%eax
    1685:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1688:	77 1a                	ja     16a4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168d:	8b 00                	mov    (%eax),%eax
    168f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1692:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1695:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1698:	76 d4                	jbe    166e <free+0x19>
    169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169d:	8b 00                	mov    (%eax),%eax
    169f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16a2:	76 ca                	jbe    166e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a7:	8b 40 04             	mov    0x4(%eax),%eax
    16aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b4:	01 c2                	add    %eax,%edx
    16b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b9:	8b 00                	mov    (%eax),%eax
    16bb:	39 c2                	cmp    %eax,%edx
    16bd:	75 24                	jne    16e3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c2:	8b 50 04             	mov    0x4(%eax),%edx
    16c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c8:	8b 00                	mov    (%eax),%eax
    16ca:	8b 40 04             	mov    0x4(%eax),%eax
    16cd:	01 c2                	add    %eax,%edx
    16cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8b 00                	mov    (%eax),%eax
    16da:	8b 10                	mov    (%eax),%edx
    16dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16df:	89 10                	mov    %edx,(%eax)
    16e1:	eb 0a                	jmp    16ed <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e6:	8b 10                	mov    (%eax),%edx
    16e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16eb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f0:	8b 40 04             	mov    0x4(%eax),%eax
    16f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fd:	01 d0                	add    %edx,%eax
    16ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1702:	75 20                	jne    1724 <free+0xcf>
    p->s.size += bp->s.size;
    1704:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1707:	8b 50 04             	mov    0x4(%eax),%edx
    170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170d:	8b 40 04             	mov    0x4(%eax),%eax
    1710:	01 c2                	add    %eax,%edx
    1712:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1715:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1718:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171b:	8b 10                	mov    (%eax),%edx
    171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1720:	89 10                	mov    %edx,(%eax)
    1722:	eb 08                	jmp    172c <free+0xd7>
  } else
    p->s.ptr = bp;
    1724:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1727:	8b 55 f8             	mov    -0x8(%ebp),%edx
    172a:	89 10                	mov    %edx,(%eax)
  freep = p;
    172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172f:	a3 ec 1f 00 00       	mov    %eax,0x1fec
}
    1734:	c9                   	leave  
    1735:	c3                   	ret    

00001736 <morecore>:

static Header*
morecore(uint nu)
{
    1736:	55                   	push   %ebp
    1737:	89 e5                	mov    %esp,%ebp
    1739:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    173c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1743:	77 07                	ja     174c <morecore+0x16>
    nu = 4096;
    1745:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    174c:	8b 45 08             	mov    0x8(%ebp),%eax
    174f:	c1 e0 03             	shl    $0x3,%eax
    1752:	89 04 24             	mov    %eax,(%esp)
    1755:	e8 20 fc ff ff       	call   137a <sbrk>
    175a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    175d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1761:	75 07                	jne    176a <morecore+0x34>
    return 0;
    1763:	b8 00 00 00 00       	mov    $0x0,%eax
    1768:	eb 22                	jmp    178c <morecore+0x56>
  hp = (Header*)p;
    176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1770:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1773:	8b 55 08             	mov    0x8(%ebp),%edx
    1776:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1779:	8b 45 f0             	mov    -0x10(%ebp),%eax
    177c:	83 c0 08             	add    $0x8,%eax
    177f:	89 04 24             	mov    %eax,(%esp)
    1782:	e8 ce fe ff ff       	call   1655 <free>
  return freep;
    1787:	a1 ec 1f 00 00       	mov    0x1fec,%eax
}
    178c:	c9                   	leave  
    178d:	c3                   	ret    

0000178e <malloc>:

void*
malloc(uint nbytes)
{
    178e:	55                   	push   %ebp
    178f:	89 e5                	mov    %esp,%ebp
    1791:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1794:	8b 45 08             	mov    0x8(%ebp),%eax
    1797:	83 c0 07             	add    $0x7,%eax
    179a:	c1 e8 03             	shr    $0x3,%eax
    179d:	83 c0 01             	add    $0x1,%eax
    17a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17a3:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    17a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17af:	75 23                	jne    17d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17b1:	c7 45 f0 e4 1f 00 00 	movl   $0x1fe4,-0x10(%ebp)
    17b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17bb:	a3 ec 1f 00 00       	mov    %eax,0x1fec
    17c0:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    17c5:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
    base.s.size = 0;
    17ca:	c7 05 e8 1f 00 00 00 	movl   $0x0,0x1fe8
    17d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d7:	8b 00                	mov    (%eax),%eax
    17d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17df:	8b 40 04             	mov    0x4(%eax),%eax
    17e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17e5:	72 4d                	jb     1834 <malloc+0xa6>
      if(p->s.size == nunits)
    17e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ea:	8b 40 04             	mov    0x4(%eax),%eax
    17ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17f0:	75 0c                	jne    17fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f5:	8b 10                	mov    (%eax),%edx
    17f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17fa:	89 10                	mov    %edx,(%eax)
    17fc:	eb 26                	jmp    1824 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1801:	8b 40 04             	mov    0x4(%eax),%eax
    1804:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1807:	89 c2                	mov    %eax,%edx
    1809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1812:	8b 40 04             	mov    0x4(%eax),%eax
    1815:	c1 e0 03             	shl    $0x3,%eax
    1818:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1821:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1824:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1827:	a3 ec 1f 00 00       	mov    %eax,0x1fec
      return (void*)(p + 1);
    182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182f:	83 c0 08             	add    $0x8,%eax
    1832:	eb 38                	jmp    186c <malloc+0xde>
    }
    if(p == freep)
    1834:	a1 ec 1f 00 00       	mov    0x1fec,%eax
    1839:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    183c:	75 1b                	jne    1859 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    183e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1841:	89 04 24             	mov    %eax,(%esp)
    1844:	e8 ed fe ff ff       	call   1736 <morecore>
    1849:	89 45 f4             	mov    %eax,-0xc(%ebp)
    184c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1850:	75 07                	jne    1859 <malloc+0xcb>
        return 0;
    1852:	b8 00 00 00 00       	mov    $0x0,%eax
    1857:	eb 13                	jmp    186c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1859:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1862:	8b 00                	mov    (%eax),%eax
    1864:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1867:	e9 70 ff ff ff       	jmp    17dc <malloc+0x4e>
}
    186c:	c9                   	leave  
    186d:	c3                   	ret    

0000186e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    186e:	55                   	push   %ebp
    186f:	89 e5                	mov    %esp,%ebp
    1871:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1874:	8b 55 08             	mov    0x8(%ebp),%edx
    1877:	8b 45 0c             	mov    0xc(%ebp),%eax
    187a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    187d:	f0 87 02             	lock xchg %eax,(%edx)
    1880:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1883:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1886:	c9                   	leave  
    1887:	c3                   	ret    

00001888 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1888:	55                   	push   %ebp
    1889:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    188b:	8b 45 08             	mov    0x8(%ebp),%eax
    188e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1894:	5d                   	pop    %ebp
    1895:	c3                   	ret    

00001896 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1896:	55                   	push   %ebp
    1897:	89 e5                	mov    %esp,%ebp
    1899:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    189c:	90                   	nop
    189d:	8b 45 08             	mov    0x8(%ebp),%eax
    18a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18a7:	00 
    18a8:	89 04 24             	mov    %eax,(%esp)
    18ab:	e8 be ff ff ff       	call   186e <xchg>
    18b0:	85 c0                	test   %eax,%eax
    18b2:	75 e9                	jne    189d <lock_acquire+0x7>
}
    18b4:	c9                   	leave  
    18b5:	c3                   	ret    

000018b6 <lock_release>:
void lock_release(lock_t *lock){
    18b6:	55                   	push   %ebp
    18b7:	89 e5                	mov    %esp,%ebp
    18b9:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    18bc:	8b 45 08             	mov    0x8(%ebp),%eax
    18bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18c6:	00 
    18c7:	89 04 24             	mov    %eax,(%esp)
    18ca:	e8 9f ff ff ff       	call   186e <xchg>
}
    18cf:	c9                   	leave  
    18d0:	c3                   	ret    

000018d1 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    18d1:	55                   	push   %ebp
    18d2:	89 e5                	mov    %esp,%ebp
    18d4:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    18d7:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    18de:	e8 ab fe ff ff       	call   178e <malloc>
    18e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    18e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    18ec:	0f b6 05 f0 1f 00 00 	movzbl 0x1ff0,%eax
    18f3:	84 c0                	test   %al,%al
    18f5:	75 1c                	jne    1913 <thread_create+0x42>
        init_q(thQ2);
    18f7:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    18fc:	89 04 24             	mov    %eax,(%esp)
    18ff:	e8 b2 01 00 00       	call   1ab6 <init_q>
        inQ++;
    1904:	0f b6 05 f0 1f 00 00 	movzbl 0x1ff0,%eax
    190b:	83 c0 01             	add    $0x1,%eax
    190e:	a2 f0 1f 00 00       	mov    %al,0x1ff0
    }

    if((uint)stack % 4096){
    1913:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1916:	25 ff 0f 00 00       	and    $0xfff,%eax
    191b:	85 c0                	test   %eax,%eax
    191d:	74 14                	je     1933 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1922:	25 ff 0f 00 00       	and    $0xfff,%eax
    1927:	89 c2                	mov    %eax,%edx
    1929:	b8 00 10 00 00       	mov    $0x1000,%eax
    192e:	29 d0                	sub    %edx,%eax
    1930:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1937:	75 1e                	jne    1957 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1939:	c7 44 24 04 da 1b 00 	movl   $0x1bda,0x4(%esp)
    1940:	00 
    1941:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1948:	e8 55 fb ff ff       	call   14a2 <printf>
        return 0;
    194d:	b8 00 00 00 00       	mov    $0x0,%eax
    1952:	e9 83 00 00 00       	jmp    19da <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    195a:	8b 55 08             	mov    0x8(%ebp),%edx
    195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1960:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1964:	89 54 24 08          	mov    %edx,0x8(%esp)
    1968:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    196f:	00 
    1970:	89 04 24             	mov    %eax,(%esp)
    1973:	e8 1a fa ff ff       	call   1392 <clone>
    1978:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    197b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    197f:	79 1b                	jns    199c <thread_create+0xcb>
        printf(1,"clone fails\n");
    1981:	c7 44 24 04 e8 1b 00 	movl   $0x1be8,0x4(%esp)
    1988:	00 
    1989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1990:	e8 0d fb ff ff       	call   14a2 <printf>
        return 0;
    1995:	b8 00 00 00 00       	mov    $0x0,%eax
    199a:	eb 3e                	jmp    19da <thread_create+0x109>
    }
    if(tid > 0){
    199c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a0:	7e 19                	jle    19bb <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    19a2:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    19a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19aa:	89 54 24 04          	mov    %edx,0x4(%esp)
    19ae:	89 04 24             	mov    %eax,(%esp)
    19b1:	e8 22 01 00 00       	call   1ad8 <add_q>
        return garbage_stack;
    19b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19b9:	eb 1f                	jmp    19da <thread_create+0x109>
    }
    if(tid == 0){
    19bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19bf:	75 14                	jne    19d5 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    19c1:	c7 44 24 04 f5 1b 00 	movl   $0x1bf5,0x4(%esp)
    19c8:	00 
    19c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19d0:	e8 cd fa ff ff       	call   14a2 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    19d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    19da:	c9                   	leave  
    19db:	c3                   	ret    

000019dc <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    19dc:	55                   	push   %ebp
    19dd:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    19df:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    19e4:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    19ea:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    19ef:	a3 e0 1f 00 00       	mov    %eax,0x1fe0
    return (int)(rands % max);
    19f4:	a1 e0 1f 00 00       	mov    0x1fe0,%eax
    19f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19fc:	ba 00 00 00 00       	mov    $0x0,%edx
    1a01:	f7 f1                	div    %ecx
    1a03:	89 d0                	mov    %edx,%eax
}
    1a05:	5d                   	pop    %ebp
    1a06:	c3                   	ret    

00001a07 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a07:	55                   	push   %ebp
    1a08:	89 e5                	mov    %esp,%ebp
    1a0a:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a0d:	e8 60 f9 ff ff       	call   1372 <getpid>
    1a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a15:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    1a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a1d:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a21:	89 04 24             	mov    %eax,(%esp)
    1a24:	e8 af 00 00 00       	call   1ad8 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a29:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    1a2e:	89 04 24             	mov    %eax,(%esp)
    1a31:	e8 1c 01 00 00       	call   1b52 <pop_q>
    1a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a39:	a1 f4 1f 00 00       	mov    0x1ff4,%eax
    1a3e:	85 c0                	test   %eax,%eax
    1a40:	75 1f                	jne    1a61 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a42:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    1a47:	89 04 24             	mov    %eax,(%esp)
    1a4a:	e8 03 01 00 00       	call   1b52 <pop_q>
    1a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1a52:	a1 f4 1f 00 00       	mov    0x1ff4,%eax
    1a57:	83 c0 01             	add    $0x1,%eax
    1a5a:	a3 f4 1f 00 00       	mov    %eax,0x1ff4
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1a5f:	eb 12                	jmp    1a73 <thread_yield2+0x6c>
    1a61:	eb 10                	jmp    1a73 <thread_yield2+0x6c>
    1a63:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    1a68:	89 04 24             	mov    %eax,(%esp)
    1a6b:	e8 e2 00 00 00       	call   1b52 <pop_q>
    1a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a79:	74 e8                	je     1a63 <thread_yield2+0x5c>
    1a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a7f:	74 e2                	je     1a63 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a84:	89 04 24             	mov    %eax,(%esp)
    1a87:	e8 1e f9 ff ff       	call   13aa <twakeup>
    tsleep();
    1a8c:	e8 11 f9 ff ff       	call   13a2 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1a91:	c9                   	leave  
    1a92:	c3                   	ret    

00001a93 <thread_yield_last>:

void thread_yield_last(){
    1a93:	55                   	push   %ebp
    1a94:	89 e5                	mov    %esp,%ebp
    1a96:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1a99:	a1 f8 1f 00 00       	mov    0x1ff8,%eax
    1a9e:	89 04 24             	mov    %eax,(%esp)
    1aa1:	e8 ac 00 00 00       	call   1b52 <pop_q>
    1aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aac:	89 04 24             	mov    %eax,(%esp)
    1aaf:	e8 f6 f8 ff ff       	call   13aa <twakeup>
    1ab4:	c9                   	leave  
    1ab5:	c3                   	ret    

00001ab6 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1ab6:	55                   	push   %ebp
    1ab7:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1ab9:	8b 45 08             	mov    0x8(%ebp),%eax
    1abc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1ac2:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1acc:	8b 45 08             	mov    0x8(%ebp),%eax
    1acf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1ad6:	5d                   	pop    %ebp
    1ad7:	c3                   	ret    

00001ad8 <add_q>:

void add_q(struct queue *q, int v){
    1ad8:	55                   	push   %ebp
    1ad9:	89 e5                	mov    %esp,%ebp
    1adb:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1ade:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ae5:	e8 a4 fc ff ff       	call   178e <malloc>
    1aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afa:	8b 55 0c             	mov    0xc(%ebp),%edx
    1afd:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1aff:	8b 45 08             	mov    0x8(%ebp),%eax
    1b02:	8b 40 04             	mov    0x4(%eax),%eax
    1b05:	85 c0                	test   %eax,%eax
    1b07:	75 0b                	jne    1b14 <add_q+0x3c>
        q->head = n;
    1b09:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b0f:	89 50 04             	mov    %edx,0x4(%eax)
    1b12:	eb 0c                	jmp    1b20 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b14:	8b 45 08             	mov    0x8(%ebp),%eax
    1b17:	8b 40 08             	mov    0x8(%eax),%eax
    1b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b1d:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b20:	8b 45 08             	mov    0x8(%ebp),%eax
    1b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b26:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b29:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2c:	8b 00                	mov    (%eax),%eax
    1b2e:	8d 50 01             	lea    0x1(%eax),%edx
    1b31:	8b 45 08             	mov    0x8(%ebp),%eax
    1b34:	89 10                	mov    %edx,(%eax)
}
    1b36:	c9                   	leave  
    1b37:	c3                   	ret    

00001b38 <empty_q>:

int empty_q(struct queue *q){
    1b38:	55                   	push   %ebp
    1b39:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b3b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3e:	8b 00                	mov    (%eax),%eax
    1b40:	85 c0                	test   %eax,%eax
    1b42:	75 07                	jne    1b4b <empty_q+0x13>
        return 1;
    1b44:	b8 01 00 00 00       	mov    $0x1,%eax
    1b49:	eb 05                	jmp    1b50 <empty_q+0x18>
    else
        return 0;
    1b4b:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1b50:	5d                   	pop    %ebp
    1b51:	c3                   	ret    

00001b52 <pop_q>:
int pop_q(struct queue *q){
    1b52:	55                   	push   %ebp
    1b53:	89 e5                	mov    %esp,%ebp
    1b55:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1b58:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5b:	89 04 24             	mov    %eax,(%esp)
    1b5e:	e8 d5 ff ff ff       	call   1b38 <empty_q>
    1b63:	85 c0                	test   %eax,%eax
    1b65:	75 5d                	jne    1bc4 <pop_q+0x72>
       val = q->head->value; 
    1b67:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6a:	8b 40 04             	mov    0x4(%eax),%eax
    1b6d:	8b 00                	mov    (%eax),%eax
    1b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1b72:	8b 45 08             	mov    0x8(%ebp),%eax
    1b75:	8b 40 04             	mov    0x4(%eax),%eax
    1b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1b7b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7e:	8b 40 04             	mov    0x4(%eax),%eax
    1b81:	8b 50 04             	mov    0x4(%eax),%edx
    1b84:	8b 45 08             	mov    0x8(%ebp),%eax
    1b87:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b8d:	89 04 24             	mov    %eax,(%esp)
    1b90:	e8 c0 fa ff ff       	call   1655 <free>
       q->size--;
    1b95:	8b 45 08             	mov    0x8(%ebp),%eax
    1b98:	8b 00                	mov    (%eax),%eax
    1b9a:	8d 50 ff             	lea    -0x1(%eax),%edx
    1b9d:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba0:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ba2:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba5:	8b 00                	mov    (%eax),%eax
    1ba7:	85 c0                	test   %eax,%eax
    1ba9:	75 14                	jne    1bbf <pop_q+0x6d>
            q->head = 0;
    1bab:	8b 45 08             	mov    0x8(%ebp),%eax
    1bae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1bb5:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc2:	eb 05                	jmp    1bc9 <pop_q+0x77>
    }
    return -1;
    1bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1bc9:	c9                   	leave  
    1bca:	c3                   	ret    
