
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1006:	eb 1b                	jmp    1023 <cat+0x23>
    write(1, buf, n);
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	89 44 24 08          	mov    %eax,0x8(%esp)
    100f:	c7 44 24 04 e0 20 00 	movl   $0x20e0,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    101e:	e8 82 03 00 00       	call   13a5 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1023:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    102a:	00 
    102b:	c7 44 24 04 e0 20 00 	movl   $0x20e0,0x4(%esp)
    1032:	00 
    1033:	8b 45 08             	mov    0x8(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 5f 03 00 00       	call   139d <read>
    103e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1045:	7f c1                	jg     1008 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
    1047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    104b:	79 19                	jns    1066 <cat+0x66>
    printf(1, "cat: read error\n");
    104d:	c7 44 24 04 5e 1c 00 	movl   $0x1c5e,0x4(%esp)
    1054:	00 
    1055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    105c:	e8 d4 04 00 00       	call   1535 <printf>
    exit();
    1061:	e8 1f 03 00 00       	call   1385 <exit>
  }
}
    1066:	c9                   	leave  
    1067:	c3                   	ret    

00001068 <main>:

int
main(int argc, char *argv[])
{
    1068:	55                   	push   %ebp
    1069:	89 e5                	mov    %esp,%ebp
    106b:	83 e4 f0             	and    $0xfffffff0,%esp
    106e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    1071:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1075:	7f 11                	jg     1088 <main+0x20>
    cat(0);
    1077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    107e:	e8 7d ff ff ff       	call   1000 <cat>
    exit();
    1083:	e8 fd 02 00 00       	call   1385 <exit>
  }

  for(i = 1; i < argc; i++){
    1088:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    108f:	00 
    1090:	eb 79                	jmp    110b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
    1092:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1096:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    109d:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a0:	01 d0                	add    %edx,%eax
    10a2:	8b 00                	mov    (%eax),%eax
    10a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10ab:	00 
    10ac:	89 04 24             	mov    %eax,(%esp)
    10af:	e8 11 03 00 00       	call   13c5 <open>
    10b4:	89 44 24 18          	mov    %eax,0x18(%esp)
    10b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10bd:	79 2f                	jns    10ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	01 d0                	add    %edx,%eax
    10cf:	8b 00                	mov    (%eax),%eax
    10d1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d5:	c7 44 24 04 6f 1c 00 	movl   $0x1c6f,0x4(%esp)
    10dc:	00 
    10dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e4:	e8 4c 04 00 00       	call   1535 <printf>
      exit();
    10e9:	e8 97 02 00 00       	call   1385 <exit>
    }
    cat(fd);
    10ee:	8b 44 24 18          	mov    0x18(%esp),%eax
    10f2:	89 04 24             	mov    %eax,(%esp)
    10f5:	e8 06 ff ff ff       	call   1000 <cat>
    close(fd);
    10fa:	8b 44 24 18          	mov    0x18(%esp),%eax
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 a7 02 00 00       	call   13ad <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    1106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    110b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    110f:	3b 45 08             	cmp    0x8(%ebp),%eax
    1112:	0f 8c 7a ff ff ff    	jl     1092 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
    1118:	e8 68 02 00 00       	call   1385 <exit>

0000111d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    111d:	55                   	push   %ebp
    111e:	89 e5                	mov    %esp,%ebp
    1120:	57                   	push   %edi
    1121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1122:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1125:	8b 55 10             	mov    0x10(%ebp),%edx
    1128:	8b 45 0c             	mov    0xc(%ebp),%eax
    112b:	89 cb                	mov    %ecx,%ebx
    112d:	89 df                	mov    %ebx,%edi
    112f:	89 d1                	mov    %edx,%ecx
    1131:	fc                   	cld    
    1132:	f3 aa                	rep stos %al,%es:(%edi)
    1134:	89 ca                	mov    %ecx,%edx
    1136:	89 fb                	mov    %edi,%ebx
    1138:	89 5d 08             	mov    %ebx,0x8(%ebp)
    113b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    113e:	5b                   	pop    %ebx
    113f:	5f                   	pop    %edi
    1140:	5d                   	pop    %ebp
    1141:	c3                   	ret    

00001142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1142:	55                   	push   %ebp
    1143:	89 e5                	mov    %esp,%ebp
    1145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    114e:	90                   	nop
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	8d 50 01             	lea    0x1(%eax),%edx
    1155:	89 55 08             	mov    %edx,0x8(%ebp)
    1158:	8b 55 0c             	mov    0xc(%ebp),%edx
    115b:	8d 4a 01             	lea    0x1(%edx),%ecx
    115e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1161:	0f b6 12             	movzbl (%edx),%edx
    1164:	88 10                	mov    %dl,(%eax)
    1166:	0f b6 00             	movzbl (%eax),%eax
    1169:	84 c0                	test   %al,%al
    116b:	75 e2                	jne    114f <strcpy+0xd>
    ;
  return os;
    116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1170:	c9                   	leave  
    1171:	c3                   	ret    

00001172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1172:	55                   	push   %ebp
    1173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1175:	eb 08                	jmp    117f <strcmp+0xd>
    p++, q++;
    1177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    117f:	8b 45 08             	mov    0x8(%ebp),%eax
    1182:	0f b6 00             	movzbl (%eax),%eax
    1185:	84 c0                	test   %al,%al
    1187:	74 10                	je     1199 <strcmp+0x27>
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	0f b6 10             	movzbl (%eax),%edx
    118f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1192:	0f b6 00             	movzbl (%eax),%eax
    1195:	38 c2                	cmp    %al,%dl
    1197:	74 de                	je     1177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
    119c:	0f b6 00             	movzbl (%eax),%eax
    119f:	0f b6 d0             	movzbl %al,%edx
    11a2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a5:	0f b6 00             	movzbl (%eax),%eax
    11a8:	0f b6 c0             	movzbl %al,%eax
    11ab:	29 c2                	sub    %eax,%edx
    11ad:	89 d0                	mov    %edx,%eax
}
    11af:	5d                   	pop    %ebp
    11b0:	c3                   	ret    

000011b1 <strlen>:

uint
strlen(char *s)
{
    11b1:	55                   	push   %ebp
    11b2:	89 e5                	mov    %esp,%ebp
    11b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11be:	eb 04                	jmp    11c4 <strlen+0x13>
    11c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11c7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ca:	01 d0                	add    %edx,%eax
    11cc:	0f b6 00             	movzbl (%eax),%eax
    11cf:	84 c0                	test   %al,%al
    11d1:	75 ed                	jne    11c0 <strlen+0xf>
    ;
  return n;
    11d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11d6:	c9                   	leave  
    11d7:	c3                   	ret    

000011d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d8:	55                   	push   %ebp
    11d9:	89 e5                	mov    %esp,%ebp
    11db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11de:	8b 45 10             	mov    0x10(%ebp),%eax
    11e1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ec:	8b 45 08             	mov    0x8(%ebp),%eax
    11ef:	89 04 24             	mov    %eax,(%esp)
    11f2:	e8 26 ff ff ff       	call   111d <stosb>
  return dst;
    11f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11fa:	c9                   	leave  
    11fb:	c3                   	ret    

000011fc <strchr>:

char*
strchr(const char *s, char c)
{
    11fc:	55                   	push   %ebp
    11fd:	89 e5                	mov    %esp,%ebp
    11ff:	83 ec 04             	sub    $0x4,%esp
    1202:	8b 45 0c             	mov    0xc(%ebp),%eax
    1205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1208:	eb 14                	jmp    121e <strchr+0x22>
    if(*s == c)
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	0f b6 00             	movzbl (%eax),%eax
    1210:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1213:	75 05                	jne    121a <strchr+0x1e>
      return (char*)s;
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	eb 13                	jmp    122d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    121a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    121e:	8b 45 08             	mov    0x8(%ebp),%eax
    1221:	0f b6 00             	movzbl (%eax),%eax
    1224:	84 c0                	test   %al,%al
    1226:	75 e2                	jne    120a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1228:	b8 00 00 00 00       	mov    $0x0,%eax
}
    122d:	c9                   	leave  
    122e:	c3                   	ret    

0000122f <gets>:

char*
gets(char *buf, int max)
{
    122f:	55                   	push   %ebp
    1230:	89 e5                	mov    %esp,%ebp
    1232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    123c:	eb 4c                	jmp    128a <gets+0x5b>
    cc = read(0, &c, 1);
    123e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1245:	00 
    1246:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1254:	e8 44 01 00 00       	call   139d <read>
    1259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    125c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1260:	7f 02                	jg     1264 <gets+0x35>
      break;
    1262:	eb 31                	jmp    1295 <gets+0x66>
    buf[i++] = c;
    1264:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1267:	8d 50 01             	lea    0x1(%eax),%edx
    126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    126d:	89 c2                	mov    %eax,%edx
    126f:	8b 45 08             	mov    0x8(%ebp),%eax
    1272:	01 c2                	add    %eax,%edx
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 13                	je     1295 <gets+0x66>
    1282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0b                	je     1295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1293:	7c a9                	jl     123e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1295:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1298:	8b 45 08             	mov    0x8(%ebp),%eax
    129b:	01 d0                	add    %edx,%eax
    129d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a3:	c9                   	leave  
    12a4:	c3                   	ret    

000012a5 <stat>:

int
stat(char *n, struct stat *st)
{
    12a5:	55                   	push   %ebp
    12a6:	89 e5                	mov    %esp,%ebp
    12a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12b2:	00 
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 07 01 00 00       	call   13c5 <open>
    12be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12c5:	79 07                	jns    12ce <stat+0x29>
    return -1;
    12c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12cc:	eb 23                	jmp    12f1 <stat+0x4c>
  r = fstat(fd, st);
    12ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 fd 00 00 00       	call   13dd <fstat>
    12e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12e6:	89 04 24             	mov    %eax,(%esp)
    12e9:	e8 bf 00 00 00       	call   13ad <close>
  return r;
    12ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12f1:	c9                   	leave  
    12f2:	c3                   	ret    

000012f3 <atoi>:

int
atoi(const char *s)
{
    12f3:	55                   	push   %ebp
    12f4:	89 e5                	mov    %esp,%ebp
    12f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1300:	eb 25                	jmp    1327 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1302:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1305:	89 d0                	mov    %edx,%eax
    1307:	c1 e0 02             	shl    $0x2,%eax
    130a:	01 d0                	add    %edx,%eax
    130c:	01 c0                	add    %eax,%eax
    130e:	89 c1                	mov    %eax,%ecx
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
    1313:	8d 50 01             	lea    0x1(%eax),%edx
    1316:	89 55 08             	mov    %edx,0x8(%ebp)
    1319:	0f b6 00             	movzbl (%eax),%eax
    131c:	0f be c0             	movsbl %al,%eax
    131f:	01 c8                	add    %ecx,%eax
    1321:	83 e8 30             	sub    $0x30,%eax
    1324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1327:	8b 45 08             	mov    0x8(%ebp),%eax
    132a:	0f b6 00             	movzbl (%eax),%eax
    132d:	3c 2f                	cmp    $0x2f,%al
    132f:	7e 0a                	jle    133b <atoi+0x48>
    1331:	8b 45 08             	mov    0x8(%ebp),%eax
    1334:	0f b6 00             	movzbl (%eax),%eax
    1337:	3c 39                	cmp    $0x39,%al
    1339:	7e c7                	jle    1302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    133e:	c9                   	leave  
    133f:	c3                   	ret    

00001340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    134c:	8b 45 0c             	mov    0xc(%ebp),%eax
    134f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1352:	eb 17                	jmp    136b <memmove+0x2b>
    *dst++ = *src++;
    1354:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1357:	8d 50 01             	lea    0x1(%eax),%edx
    135a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    135d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1360:	8d 4a 01             	lea    0x1(%edx),%ecx
    1363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1366:	0f b6 12             	movzbl (%edx),%edx
    1369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    136b:	8b 45 10             	mov    0x10(%ebp),%eax
    136e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1371:	89 55 10             	mov    %edx,0x10(%ebp)
    1374:	85 c0                	test   %eax,%eax
    1376:	7f dc                	jg     1354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1378:	8b 45 08             	mov    0x8(%ebp),%eax
}
    137b:	c9                   	leave  
    137c:	c3                   	ret    

0000137d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    137d:	b8 01 00 00 00       	mov    $0x1,%eax
    1382:	cd 40                	int    $0x40
    1384:	c3                   	ret    

00001385 <exit>:
SYSCALL(exit)
    1385:	b8 02 00 00 00       	mov    $0x2,%eax
    138a:	cd 40                	int    $0x40
    138c:	c3                   	ret    

0000138d <wait>:
SYSCALL(wait)
    138d:	b8 03 00 00 00       	mov    $0x3,%eax
    1392:	cd 40                	int    $0x40
    1394:	c3                   	ret    

00001395 <pipe>:
SYSCALL(pipe)
    1395:	b8 04 00 00 00       	mov    $0x4,%eax
    139a:	cd 40                	int    $0x40
    139c:	c3                   	ret    

0000139d <read>:
SYSCALL(read)
    139d:	b8 05 00 00 00       	mov    $0x5,%eax
    13a2:	cd 40                	int    $0x40
    13a4:	c3                   	ret    

000013a5 <write>:
SYSCALL(write)
    13a5:	b8 10 00 00 00       	mov    $0x10,%eax
    13aa:	cd 40                	int    $0x40
    13ac:	c3                   	ret    

000013ad <close>:
SYSCALL(close)
    13ad:	b8 15 00 00 00       	mov    $0x15,%eax
    13b2:	cd 40                	int    $0x40
    13b4:	c3                   	ret    

000013b5 <kill>:
SYSCALL(kill)
    13b5:	b8 06 00 00 00       	mov    $0x6,%eax
    13ba:	cd 40                	int    $0x40
    13bc:	c3                   	ret    

000013bd <exec>:
SYSCALL(exec)
    13bd:	b8 07 00 00 00       	mov    $0x7,%eax
    13c2:	cd 40                	int    $0x40
    13c4:	c3                   	ret    

000013c5 <open>:
SYSCALL(open)
    13c5:	b8 0f 00 00 00       	mov    $0xf,%eax
    13ca:	cd 40                	int    $0x40
    13cc:	c3                   	ret    

000013cd <mknod>:
SYSCALL(mknod)
    13cd:	b8 11 00 00 00       	mov    $0x11,%eax
    13d2:	cd 40                	int    $0x40
    13d4:	c3                   	ret    

000013d5 <unlink>:
SYSCALL(unlink)
    13d5:	b8 12 00 00 00       	mov    $0x12,%eax
    13da:	cd 40                	int    $0x40
    13dc:	c3                   	ret    

000013dd <fstat>:
SYSCALL(fstat)
    13dd:	b8 08 00 00 00       	mov    $0x8,%eax
    13e2:	cd 40                	int    $0x40
    13e4:	c3                   	ret    

000013e5 <link>:
SYSCALL(link)
    13e5:	b8 13 00 00 00       	mov    $0x13,%eax
    13ea:	cd 40                	int    $0x40
    13ec:	c3                   	ret    

000013ed <mkdir>:
SYSCALL(mkdir)
    13ed:	b8 14 00 00 00       	mov    $0x14,%eax
    13f2:	cd 40                	int    $0x40
    13f4:	c3                   	ret    

000013f5 <chdir>:
SYSCALL(chdir)
    13f5:	b8 09 00 00 00       	mov    $0x9,%eax
    13fa:	cd 40                	int    $0x40
    13fc:	c3                   	ret    

000013fd <dup>:
SYSCALL(dup)
    13fd:	b8 0a 00 00 00       	mov    $0xa,%eax
    1402:	cd 40                	int    $0x40
    1404:	c3                   	ret    

00001405 <getpid>:
SYSCALL(getpid)
    1405:	b8 0b 00 00 00       	mov    $0xb,%eax
    140a:	cd 40                	int    $0x40
    140c:	c3                   	ret    

0000140d <sbrk>:
SYSCALL(sbrk)
    140d:	b8 0c 00 00 00       	mov    $0xc,%eax
    1412:	cd 40                	int    $0x40
    1414:	c3                   	ret    

00001415 <sleep>:
SYSCALL(sleep)
    1415:	b8 0d 00 00 00       	mov    $0xd,%eax
    141a:	cd 40                	int    $0x40
    141c:	c3                   	ret    

0000141d <uptime>:
SYSCALL(uptime)
    141d:	b8 0e 00 00 00       	mov    $0xe,%eax
    1422:	cd 40                	int    $0x40
    1424:	c3                   	ret    

00001425 <clone>:
SYSCALL(clone)
    1425:	b8 16 00 00 00       	mov    $0x16,%eax
    142a:	cd 40                	int    $0x40
    142c:	c3                   	ret    

0000142d <texit>:
SYSCALL(texit)
    142d:	b8 17 00 00 00       	mov    $0x17,%eax
    1432:	cd 40                	int    $0x40
    1434:	c3                   	ret    

00001435 <tsleep>:
SYSCALL(tsleep)
    1435:	b8 18 00 00 00       	mov    $0x18,%eax
    143a:	cd 40                	int    $0x40
    143c:	c3                   	ret    

0000143d <twakeup>:
SYSCALL(twakeup)
    143d:	b8 19 00 00 00       	mov    $0x19,%eax
    1442:	cd 40                	int    $0x40
    1444:	c3                   	ret    

00001445 <thread_yield>:
SYSCALL(thread_yield)
    1445:	b8 1a 00 00 00       	mov    $0x1a,%eax
    144a:	cd 40                	int    $0x40
    144c:	c3                   	ret    

0000144d <thread_yield3>:
    144d:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1452:	cd 40                	int    $0x40
    1454:	c3                   	ret    

00001455 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1455:	55                   	push   %ebp
    1456:	89 e5                	mov    %esp,%ebp
    1458:	83 ec 18             	sub    $0x18,%esp
    145b:	8b 45 0c             	mov    0xc(%ebp),%eax
    145e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1468:	00 
    1469:	8d 45 f4             	lea    -0xc(%ebp),%eax
    146c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1470:	8b 45 08             	mov    0x8(%ebp),%eax
    1473:	89 04 24             	mov    %eax,(%esp)
    1476:	e8 2a ff ff ff       	call   13a5 <write>
}
    147b:	c9                   	leave  
    147c:	c3                   	ret    

0000147d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    147d:	55                   	push   %ebp
    147e:	89 e5                	mov    %esp,%ebp
    1480:	56                   	push   %esi
    1481:	53                   	push   %ebx
    1482:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    148c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1490:	74 17                	je     14a9 <printint+0x2c>
    1492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1496:	79 11                	jns    14a9 <printint+0x2c>
    neg = 1;
    1498:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    149f:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a2:	f7 d8                	neg    %eax
    14a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14a7:	eb 06                	jmp    14af <printint+0x32>
  } else {
    x = xx;
    14a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    14ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14b9:	8d 41 01             	lea    0x1(%ecx),%eax
    14bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c5:	ba 00 00 00 00       	mov    $0x0,%edx
    14ca:	f7 f3                	div    %ebx
    14cc:	89 d0                	mov    %edx,%eax
    14ce:	0f b6 80 9c 20 00 00 	movzbl 0x209c(%eax),%eax
    14d5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14d9:	8b 75 10             	mov    0x10(%ebp),%esi
    14dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14df:	ba 00 00 00 00       	mov    $0x0,%edx
    14e4:	f7 f6                	div    %esi
    14e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14ed:	75 c7                	jne    14b6 <printint+0x39>
  if(neg)
    14ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f3:	74 10                	je     1505 <printint+0x88>
    buf[i++] = '-';
    14f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f8:	8d 50 01             	lea    0x1(%eax),%edx
    14fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14fe:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1503:	eb 1f                	jmp    1524 <printint+0xa7>
    1505:	eb 1d                	jmp    1524 <printint+0xa7>
    putc(fd, buf[i]);
    1507:	8d 55 dc             	lea    -0x24(%ebp),%edx
    150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150d:	01 d0                	add    %edx,%eax
    150f:	0f b6 00             	movzbl (%eax),%eax
    1512:	0f be c0             	movsbl %al,%eax
    1515:	89 44 24 04          	mov    %eax,0x4(%esp)
    1519:	8b 45 08             	mov    0x8(%ebp),%eax
    151c:	89 04 24             	mov    %eax,(%esp)
    151f:	e8 31 ff ff ff       	call   1455 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1524:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152c:	79 d9                	jns    1507 <printint+0x8a>
    putc(fd, buf[i]);
}
    152e:	83 c4 30             	add    $0x30,%esp
    1531:	5b                   	pop    %ebx
    1532:	5e                   	pop    %esi
    1533:	5d                   	pop    %ebp
    1534:	c3                   	ret    

00001535 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1535:	55                   	push   %ebp
    1536:	89 e5                	mov    %esp,%ebp
    1538:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    153b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1542:	8d 45 0c             	lea    0xc(%ebp),%eax
    1545:	83 c0 04             	add    $0x4,%eax
    1548:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    154b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1552:	e9 7c 01 00 00       	jmp    16d3 <printf+0x19e>
    c = fmt[i] & 0xff;
    1557:	8b 55 0c             	mov    0xc(%ebp),%edx
    155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    155d:	01 d0                	add    %edx,%eax
    155f:	0f b6 00             	movzbl (%eax),%eax
    1562:	0f be c0             	movsbl %al,%eax
    1565:	25 ff 00 00 00       	and    $0xff,%eax
    156a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    156d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1571:	75 2c                	jne    159f <printf+0x6a>
      if(c == '%'){
    1573:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1577:	75 0c                	jne    1585 <printf+0x50>
        state = '%';
    1579:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1580:	e9 4a 01 00 00       	jmp    16cf <printf+0x19a>
      } else {
        putc(fd, c);
    1585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1588:	0f be c0             	movsbl %al,%eax
    158b:	89 44 24 04          	mov    %eax,0x4(%esp)
    158f:	8b 45 08             	mov    0x8(%ebp),%eax
    1592:	89 04 24             	mov    %eax,(%esp)
    1595:	e8 bb fe ff ff       	call   1455 <putc>
    159a:	e9 30 01 00 00       	jmp    16cf <printf+0x19a>
      }
    } else if(state == '%'){
    159f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a3:	0f 85 26 01 00 00    	jne    16cf <printf+0x19a>
      if(c == 'd'){
    15a9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15ad:	75 2d                	jne    15dc <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b2:	8b 00                	mov    (%eax),%eax
    15b4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15bb:	00 
    15bc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15c3:	00 
    15c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c8:	8b 45 08             	mov    0x8(%ebp),%eax
    15cb:	89 04 24             	mov    %eax,(%esp)
    15ce:	e8 aa fe ff ff       	call   147d <printint>
        ap++;
    15d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d7:	e9 ec 00 00 00       	jmp    16c8 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15dc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15e0:	74 06                	je     15e8 <printf+0xb3>
    15e2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15e6:	75 2d                	jne    1615 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15eb:	8b 00                	mov    (%eax),%eax
    15ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15f4:	00 
    15f5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15fc:	00 
    15fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1601:	8b 45 08             	mov    0x8(%ebp),%eax
    1604:	89 04 24             	mov    %eax,(%esp)
    1607:	e8 71 fe ff ff       	call   147d <printint>
        ap++;
    160c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1610:	e9 b3 00 00 00       	jmp    16c8 <printf+0x193>
      } else if(c == 's'){
    1615:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1619:	75 45                	jne    1660 <printf+0x12b>
        s = (char*)*ap;
    161b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    161e:	8b 00                	mov    (%eax),%eax
    1620:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1623:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    162b:	75 09                	jne    1636 <printf+0x101>
          s = "(null)";
    162d:	c7 45 f4 84 1c 00 00 	movl   $0x1c84,-0xc(%ebp)
        while(*s != 0){
    1634:	eb 1e                	jmp    1654 <printf+0x11f>
    1636:	eb 1c                	jmp    1654 <printf+0x11f>
          putc(fd, *s);
    1638:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163b:	0f b6 00             	movzbl (%eax),%eax
    163e:	0f be c0             	movsbl %al,%eax
    1641:	89 44 24 04          	mov    %eax,0x4(%esp)
    1645:	8b 45 08             	mov    0x8(%ebp),%eax
    1648:	89 04 24             	mov    %eax,(%esp)
    164b:	e8 05 fe ff ff       	call   1455 <putc>
          s++;
    1650:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1654:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1657:	0f b6 00             	movzbl (%eax),%eax
    165a:	84 c0                	test   %al,%al
    165c:	75 da                	jne    1638 <printf+0x103>
    165e:	eb 68                	jmp    16c8 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1660:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1664:	75 1d                	jne    1683 <printf+0x14e>
        putc(fd, *ap);
    1666:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1669:	8b 00                	mov    (%eax),%eax
    166b:	0f be c0             	movsbl %al,%eax
    166e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1672:	8b 45 08             	mov    0x8(%ebp),%eax
    1675:	89 04 24             	mov    %eax,(%esp)
    1678:	e8 d8 fd ff ff       	call   1455 <putc>
        ap++;
    167d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1681:	eb 45                	jmp    16c8 <printf+0x193>
      } else if(c == '%'){
    1683:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1687:	75 17                	jne    16a0 <printf+0x16b>
        putc(fd, c);
    1689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168c:	0f be c0             	movsbl %al,%eax
    168f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1693:	8b 45 08             	mov    0x8(%ebp),%eax
    1696:	89 04 24             	mov    %eax,(%esp)
    1699:	e8 b7 fd ff ff       	call   1455 <putc>
    169e:	eb 28                	jmp    16c8 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16a0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16a7:	00 
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	89 04 24             	mov    %eax,(%esp)
    16ae:	e8 a2 fd ff ff       	call   1455 <putc>
        putc(fd, c);
    16b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b6:	0f be c0             	movsbl %al,%eax
    16b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    16bd:	8b 45 08             	mov    0x8(%ebp),%eax
    16c0:	89 04 24             	mov    %eax,(%esp)
    16c3:	e8 8d fd ff ff       	call   1455 <putc>
      }
      state = 0;
    16c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d3:	8b 55 0c             	mov    0xc(%ebp),%edx
    16d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d9:	01 d0                	add    %edx,%eax
    16db:	0f b6 00             	movzbl (%eax),%eax
    16de:	84 c0                	test   %al,%al
    16e0:	0f 85 71 fe ff ff    	jne    1557 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16e6:	c9                   	leave  
    16e7:	c3                   	ret    

000016e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16e8:	55                   	push   %ebp
    16e9:	89 e5                	mov    %esp,%ebp
    16eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16ee:	8b 45 08             	mov    0x8(%ebp),%eax
    16f1:	83 e8 08             	sub    $0x8,%eax
    16f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f7:	a1 c8 20 00 00       	mov    0x20c8,%eax
    16fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16ff:	eb 24                	jmp    1725 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1701:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1704:	8b 00                	mov    (%eax),%eax
    1706:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1709:	77 12                	ja     171d <free+0x35>
    170b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1711:	77 24                	ja     1737 <free+0x4f>
    1713:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1716:	8b 00                	mov    (%eax),%eax
    1718:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    171b:	77 1a                	ja     1737 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1720:	8b 00                	mov    (%eax),%eax
    1722:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1725:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1728:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    172b:	76 d4                	jbe    1701 <free+0x19>
    172d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1730:	8b 00                	mov    (%eax),%eax
    1732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1735:	76 ca                	jbe    1701 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1737:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173a:	8b 40 04             	mov    0x4(%eax),%eax
    173d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1744:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1747:	01 c2                	add    %eax,%edx
    1749:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174c:	8b 00                	mov    (%eax),%eax
    174e:	39 c2                	cmp    %eax,%edx
    1750:	75 24                	jne    1776 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1752:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1755:	8b 50 04             	mov    0x4(%eax),%edx
    1758:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175b:	8b 00                	mov    (%eax),%eax
    175d:	8b 40 04             	mov    0x4(%eax),%eax
    1760:	01 c2                	add    %eax,%edx
    1762:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1765:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1768:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176b:	8b 00                	mov    (%eax),%eax
    176d:	8b 10                	mov    (%eax),%edx
    176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1772:	89 10                	mov    %edx,(%eax)
    1774:	eb 0a                	jmp    1780 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1776:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1779:	8b 10                	mov    (%eax),%edx
    177b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    177e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1780:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1783:	8b 40 04             	mov    0x4(%eax),%eax
    1786:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    178d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1790:	01 d0                	add    %edx,%eax
    1792:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1795:	75 20                	jne    17b7 <free+0xcf>
    p->s.size += bp->s.size;
    1797:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179a:	8b 50 04             	mov    0x4(%eax),%edx
    179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a0:	8b 40 04             	mov    0x4(%eax),%eax
    17a3:	01 c2                	add    %eax,%edx
    17a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ae:	8b 10                	mov    (%eax),%edx
    17b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b3:	89 10                	mov    %edx,(%eax)
    17b5:	eb 08                	jmp    17bf <free+0xd7>
  } else
    p->s.ptr = bp;
    17b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17bd:	89 10                	mov    %edx,(%eax)
  freep = p;
    17bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c2:	a3 c8 20 00 00       	mov    %eax,0x20c8
}
    17c7:	c9                   	leave  
    17c8:	c3                   	ret    

000017c9 <morecore>:

static Header*
morecore(uint nu)
{
    17c9:	55                   	push   %ebp
    17ca:	89 e5                	mov    %esp,%ebp
    17cc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17d6:	77 07                	ja     17df <morecore+0x16>
    nu = 4096;
    17d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17df:	8b 45 08             	mov    0x8(%ebp),%eax
    17e2:	c1 e0 03             	shl    $0x3,%eax
    17e5:	89 04 24             	mov    %eax,(%esp)
    17e8:	e8 20 fc ff ff       	call   140d <sbrk>
    17ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17f4:	75 07                	jne    17fd <morecore+0x34>
    return 0;
    17f6:	b8 00 00 00 00       	mov    $0x0,%eax
    17fb:	eb 22                	jmp    181f <morecore+0x56>
  hp = (Header*)p;
    17fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1803:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1806:	8b 55 08             	mov    0x8(%ebp),%edx
    1809:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180f:	83 c0 08             	add    $0x8,%eax
    1812:	89 04 24             	mov    %eax,(%esp)
    1815:	e8 ce fe ff ff       	call   16e8 <free>
  return freep;
    181a:	a1 c8 20 00 00       	mov    0x20c8,%eax
}
    181f:	c9                   	leave  
    1820:	c3                   	ret    

00001821 <malloc>:

void*
malloc(uint nbytes)
{
    1821:	55                   	push   %ebp
    1822:	89 e5                	mov    %esp,%ebp
    1824:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1827:	8b 45 08             	mov    0x8(%ebp),%eax
    182a:	83 c0 07             	add    $0x7,%eax
    182d:	c1 e8 03             	shr    $0x3,%eax
    1830:	83 c0 01             	add    $0x1,%eax
    1833:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1836:	a1 c8 20 00 00       	mov    0x20c8,%eax
    183b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    183e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1842:	75 23                	jne    1867 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1844:	c7 45 f0 c0 20 00 00 	movl   $0x20c0,-0x10(%ebp)
    184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184e:	a3 c8 20 00 00       	mov    %eax,0x20c8
    1853:	a1 c8 20 00 00       	mov    0x20c8,%eax
    1858:	a3 c0 20 00 00       	mov    %eax,0x20c0
    base.s.size = 0;
    185d:	c7 05 c4 20 00 00 00 	movl   $0x0,0x20c4
    1864:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1867:	8b 45 f0             	mov    -0x10(%ebp),%eax
    186a:	8b 00                	mov    (%eax),%eax
    186c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1872:	8b 40 04             	mov    0x4(%eax),%eax
    1875:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1878:	72 4d                	jb     18c7 <malloc+0xa6>
      if(p->s.size == nunits)
    187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187d:	8b 40 04             	mov    0x4(%eax),%eax
    1880:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1883:	75 0c                	jne    1891 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1885:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1888:	8b 10                	mov    (%eax),%edx
    188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    188d:	89 10                	mov    %edx,(%eax)
    188f:	eb 26                	jmp    18b7 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	8b 40 04             	mov    0x4(%eax),%eax
    1897:	2b 45 ec             	sub    -0x14(%ebp),%eax
    189a:	89 c2                	mov    %eax,%edx
    189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a5:	8b 40 04             	mov    0x4(%eax),%eax
    18a8:	c1 e0 03             	shl    $0x3,%eax
    18ab:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18b4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ba:	a3 c8 20 00 00       	mov    %eax,0x20c8
      return (void*)(p + 1);
    18bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c2:	83 c0 08             	add    $0x8,%eax
    18c5:	eb 38                	jmp    18ff <malloc+0xde>
    }
    if(p == freep)
    18c7:	a1 c8 20 00 00       	mov    0x20c8,%eax
    18cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18cf:	75 1b                	jne    18ec <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18d4:	89 04 24             	mov    %eax,(%esp)
    18d7:	e8 ed fe ff ff       	call   17c9 <morecore>
    18dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e3:	75 07                	jne    18ec <malloc+0xcb>
        return 0;
    18e5:	b8 00 00 00 00       	mov    $0x0,%eax
    18ea:	eb 13                	jmp    18ff <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f5:	8b 00                	mov    (%eax),%eax
    18f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18fa:	e9 70 ff ff ff       	jmp    186f <malloc+0x4e>
}
    18ff:	c9                   	leave  
    1900:	c3                   	ret    

00001901 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1901:	55                   	push   %ebp
    1902:	89 e5                	mov    %esp,%ebp
    1904:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1907:	8b 55 08             	mov    0x8(%ebp),%edx
    190a:	8b 45 0c             	mov    0xc(%ebp),%eax
    190d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1910:	f0 87 02             	lock xchg %eax,(%edx)
    1913:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1919:	c9                   	leave  
    191a:	c3                   	ret    

0000191b <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    191b:	55                   	push   %ebp
    191c:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    191e:	8b 45 08             	mov    0x8(%ebp),%eax
    1921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1927:	5d                   	pop    %ebp
    1928:	c3                   	ret    

00001929 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1929:	55                   	push   %ebp
    192a:	89 e5                	mov    %esp,%ebp
    192c:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    192f:	90                   	nop
    1930:	8b 45 08             	mov    0x8(%ebp),%eax
    1933:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    193a:	00 
    193b:	89 04 24             	mov    %eax,(%esp)
    193e:	e8 be ff ff ff       	call   1901 <xchg>
    1943:	85 c0                	test   %eax,%eax
    1945:	75 e9                	jne    1930 <lock_acquire+0x7>
}
    1947:	c9                   	leave  
    1948:	c3                   	ret    

00001949 <lock_release>:
void lock_release(lock_t *lock){
    1949:	55                   	push   %ebp
    194a:	89 e5                	mov    %esp,%ebp
    194c:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    194f:	8b 45 08             	mov    0x8(%ebp),%eax
    1952:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1959:	00 
    195a:	89 04 24             	mov    %eax,(%esp)
    195d:	e8 9f ff ff ff       	call   1901 <xchg>
}
    1962:	c9                   	leave  
    1963:	c3                   	ret    

00001964 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1964:	55                   	push   %ebp
    1965:	89 e5                	mov    %esp,%ebp
    1967:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    196a:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1971:	e8 ab fe ff ff       	call   1821 <malloc>
    1976:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1979:	8b 45 f4             	mov    -0xc(%ebp),%eax
    197c:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    197f:	0f b6 05 cc 20 00 00 	movzbl 0x20cc,%eax
    1986:	84 c0                	test   %al,%al
    1988:	75 1c                	jne    19a6 <thread_create+0x42>
        init_q(thQ2);
    198a:	a1 e0 22 00 00       	mov    0x22e0,%eax
    198f:	89 04 24             	mov    %eax,(%esp)
    1992:	e8 b2 01 00 00       	call   1b49 <init_q>
        inQ++;
    1997:	0f b6 05 cc 20 00 00 	movzbl 0x20cc,%eax
    199e:	83 c0 01             	add    $0x1,%eax
    19a1:	a2 cc 20 00 00       	mov    %al,0x20cc
    }

    if((uint)stack % 4096){
    19a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a9:	25 ff 0f 00 00       	and    $0xfff,%eax
    19ae:	85 c0                	test   %eax,%eax
    19b0:	74 14                	je     19c6 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b5:	25 ff 0f 00 00       	and    $0xfff,%eax
    19ba:	89 c2                	mov    %eax,%edx
    19bc:	b8 00 10 00 00       	mov    $0x1000,%eax
    19c1:	29 d0                	sub    %edx,%eax
    19c3:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19ca:	75 1e                	jne    19ea <thread_create+0x86>

        printf(1,"malloc fail \n");
    19cc:	c7 44 24 04 8b 1c 00 	movl   $0x1c8b,0x4(%esp)
    19d3:	00 
    19d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19db:	e8 55 fb ff ff       	call   1535 <printf>
        return 0;
    19e0:	b8 00 00 00 00       	mov    $0x0,%eax
    19e5:	e9 83 00 00 00       	jmp    1a6d <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    19ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    19ed:	8b 55 08             	mov    0x8(%ebp),%edx
    19f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    19f7:	89 54 24 08          	mov    %edx,0x8(%esp)
    19fb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a02:	00 
    1a03:	89 04 24             	mov    %eax,(%esp)
    1a06:	e8 1a fa ff ff       	call   1425 <clone>
    1a0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a12:	79 1b                	jns    1a2f <thread_create+0xcb>
        printf(1,"clone fails\n");
    1a14:	c7 44 24 04 99 1c 00 	movl   $0x1c99,0x4(%esp)
    1a1b:	00 
    1a1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a23:	e8 0d fb ff ff       	call   1535 <printf>
        return 0;
    1a28:	b8 00 00 00 00       	mov    $0x0,%eax
    1a2d:	eb 3e                	jmp    1a6d <thread_create+0x109>
    }
    if(tid > 0){
    1a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a33:	7e 19                	jle    1a4e <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1a35:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1a3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a41:	89 04 24             	mov    %eax,(%esp)
    1a44:	e8 22 01 00 00       	call   1b6b <add_q>
        return garbage_stack;
    1a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a4c:	eb 1f                	jmp    1a6d <thread_create+0x109>
    }
    if(tid == 0){
    1a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a52:	75 14                	jne    1a68 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a54:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
    1a5b:	00 
    1a5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a63:	e8 cd fa ff ff       	call   1535 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a6d:	c9                   	leave  
    1a6e:	c3                   	ret    

00001a6f <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a6f:	55                   	push   %ebp
    1a70:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a72:	a1 b0 20 00 00       	mov    0x20b0,%eax
    1a77:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a7d:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a82:	a3 b0 20 00 00       	mov    %eax,0x20b0
    return (int)(rands % max);
    1a87:	a1 b0 20 00 00       	mov    0x20b0,%eax
    1a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a8f:	ba 00 00 00 00       	mov    $0x0,%edx
    1a94:	f7 f1                	div    %ecx
    1a96:	89 d0                	mov    %edx,%eax
}
    1a98:	5d                   	pop    %ebp
    1a99:	c3                   	ret    

00001a9a <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a9a:	55                   	push   %ebp
    1a9b:	89 e5                	mov    %esp,%ebp
    1a9d:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1aa0:	e8 60 f9 ff ff       	call   1405 <getpid>
    1aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1aa8:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1ab0:	89 54 24 04          	mov    %edx,0x4(%esp)
    1ab4:	89 04 24             	mov    %eax,(%esp)
    1ab7:	e8 af 00 00 00       	call   1b6b <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1abc:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1ac1:	89 04 24             	mov    %eax,(%esp)
    1ac4:	e8 1c 01 00 00       	call   1be5 <pop_q>
    1ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1acc:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1ad1:	85 c0                	test   %eax,%eax
    1ad3:	75 1f                	jne    1af4 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1ad5:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1ada:	89 04 24             	mov    %eax,(%esp)
    1add:	e8 03 01 00 00       	call   1be5 <pop_q>
    1ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1ae5:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1aea:	83 c0 01             	add    $0x1,%eax
    1aed:	a3 d0 20 00 00       	mov    %eax,0x20d0
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1af2:	eb 12                	jmp    1b06 <thread_yield2+0x6c>
    1af4:	eb 10                	jmp    1b06 <thread_yield2+0x6c>
    1af6:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1afb:	89 04 24             	mov    %eax,(%esp)
    1afe:	e8 e2 00 00 00       	call   1be5 <pop_q>
    1b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1b0c:	74 e8                	je     1af6 <thread_yield2+0x5c>
    1b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b12:	74 e2                	je     1af6 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b17:	89 04 24             	mov    %eax,(%esp)
    1b1a:	e8 1e f9 ff ff       	call   143d <twakeup>
    tsleep();
    1b1f:	e8 11 f9 ff ff       	call   1435 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1b24:	c9                   	leave  
    1b25:	c3                   	ret    

00001b26 <thread_yield_last>:

void thread_yield_last(){
    1b26:	55                   	push   %ebp
    1b27:	89 e5                	mov    %esp,%ebp
    1b29:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1b2c:	a1 e0 22 00 00       	mov    0x22e0,%eax
    1b31:	89 04 24             	mov    %eax,(%esp)
    1b34:	e8 ac 00 00 00       	call   1be5 <pop_q>
    1b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3f:	89 04 24             	mov    %eax,(%esp)
    1b42:	e8 f6 f8 ff ff       	call   143d <twakeup>
    1b47:	c9                   	leave  
    1b48:	c3                   	ret    

00001b49 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b49:	55                   	push   %ebp
    1b4a:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b4c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b55:	8b 45 08             	mov    0x8(%ebp),%eax
    1b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1b5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1b62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1b69:	5d                   	pop    %ebp
    1b6a:	c3                   	ret    

00001b6b <add_q>:

void add_q(struct queue *q, int v){
    1b6b:	55                   	push   %ebp
    1b6c:	89 e5                	mov    %esp,%ebp
    1b6e:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1b71:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1b78:	e8 a4 fc ff ff       	call   1821 <malloc>
    1b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b90:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b92:	8b 45 08             	mov    0x8(%ebp),%eax
    1b95:	8b 40 04             	mov    0x4(%eax),%eax
    1b98:	85 c0                	test   %eax,%eax
    1b9a:	75 0b                	jne    1ba7 <add_q+0x3c>
        q->head = n;
    1b9c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ba2:	89 50 04             	mov    %edx,0x4(%eax)
    1ba5:	eb 0c                	jmp    1bb3 <add_q+0x48>
    }else{
        q->tail->next = n;
    1ba7:	8b 45 08             	mov    0x8(%ebp),%eax
    1baa:	8b 40 08             	mov    0x8(%eax),%eax
    1bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bb0:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1bb3:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bb9:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1bbc:	8b 45 08             	mov    0x8(%ebp),%eax
    1bbf:	8b 00                	mov    (%eax),%eax
    1bc1:	8d 50 01             	lea    0x1(%eax),%edx
    1bc4:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc7:	89 10                	mov    %edx,(%eax)
}
    1bc9:	c9                   	leave  
    1bca:	c3                   	ret    

00001bcb <empty_q>:

int empty_q(struct queue *q){
    1bcb:	55                   	push   %ebp
    1bcc:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1bce:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd1:	8b 00                	mov    (%eax),%eax
    1bd3:	85 c0                	test   %eax,%eax
    1bd5:	75 07                	jne    1bde <empty_q+0x13>
        return 1;
    1bd7:	b8 01 00 00 00       	mov    $0x1,%eax
    1bdc:	eb 05                	jmp    1be3 <empty_q+0x18>
    else
        return 0;
    1bde:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1be3:	5d                   	pop    %ebp
    1be4:	c3                   	ret    

00001be5 <pop_q>:
int pop_q(struct queue *q){
    1be5:	55                   	push   %ebp
    1be6:	89 e5                	mov    %esp,%ebp
    1be8:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1beb:	8b 45 08             	mov    0x8(%ebp),%eax
    1bee:	89 04 24             	mov    %eax,(%esp)
    1bf1:	e8 d5 ff ff ff       	call   1bcb <empty_q>
    1bf6:	85 c0                	test   %eax,%eax
    1bf8:	75 5d                	jne    1c57 <pop_q+0x72>
       val = q->head->value; 
    1bfa:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfd:	8b 40 04             	mov    0x4(%eax),%eax
    1c00:	8b 00                	mov    (%eax),%eax
    1c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1c05:	8b 45 08             	mov    0x8(%ebp),%eax
    1c08:	8b 40 04             	mov    0x4(%eax),%eax
    1c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1c0e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c11:	8b 40 04             	mov    0x4(%eax),%eax
    1c14:	8b 50 04             	mov    0x4(%eax),%edx
    1c17:	8b 45 08             	mov    0x8(%ebp),%eax
    1c1a:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c20:	89 04 24             	mov    %eax,(%esp)
    1c23:	e8 c0 fa ff ff       	call   16e8 <free>
       q->size--;
    1c28:	8b 45 08             	mov    0x8(%ebp),%eax
    1c2b:	8b 00                	mov    (%eax),%eax
    1c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
    1c30:	8b 45 08             	mov    0x8(%ebp),%eax
    1c33:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1c35:	8b 45 08             	mov    0x8(%ebp),%eax
    1c38:	8b 00                	mov    (%eax),%eax
    1c3a:	85 c0                	test   %eax,%eax
    1c3c:	75 14                	jne    1c52 <pop_q+0x6d>
            q->head = 0;
    1c3e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c48:	8b 45 08             	mov    0x8(%ebp),%eax
    1c4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c55:	eb 05                	jmp    1c5c <pop_q+0x77>
    }
    return -1;
    1c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1c5c:	c9                   	leave  
    1c5d:	c3                   	ret    
