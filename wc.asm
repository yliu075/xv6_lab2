
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    100d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
    1019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1020:	eb 68                	jmp    108a <wc+0x8a>
    for(i=0; i<n; i++){
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1029:	eb 57                	jmp    1082 <wc+0x82>
      c++;
    102b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	05 e0 21 00 00       	add    $0x21e0,%eax
    1037:	0f b6 00             	movzbl (%eax),%eax
    103a:	3c 0a                	cmp    $0xa,%al
    103c:	75 04                	jne    1042 <wc+0x42>
        l++;
    103e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
    1042:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1045:	05 e0 21 00 00       	add    $0x21e0,%eax
    104a:	0f b6 00             	movzbl (%eax),%eax
    104d:	0f be c0             	movsbl %al,%eax
    1050:	89 44 24 04          	mov    %eax,0x4(%esp)
    1054:	c7 04 24 35 1d 00 00 	movl   $0x1d35,(%esp)
    105b:	e8 58 02 00 00       	call   12b8 <strchr>
    1060:	85 c0                	test   %eax,%eax
    1062:	74 09                	je     106d <wc+0x6d>
        inword = 0;
    1064:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    106b:	eb 11                	jmp    107e <wc+0x7e>
      else if(!inword){
    106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1071:	75 0b                	jne    107e <wc+0x7e>
        w++;
    1073:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
    1077:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
    107e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1085:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    1088:	7c a1                	jl     102b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    108a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1091:	00 
    1092:	c7 44 24 04 e0 21 00 	movl   $0x21e0,0x4(%esp)
    1099:	00 
    109a:	8b 45 08             	mov    0x8(%ebp),%eax
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 b4 03 00 00       	call   1459 <read>
    10a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10ac:	0f 8f 70 ff ff ff    	jg     1022 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
    10b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b6:	79 19                	jns    10d1 <wc+0xd1>
    printf(1, "wc: read error\n");
    10b8:	c7 44 24 04 3b 1d 00 	movl   $0x1d3b,0x4(%esp)
    10bf:	00 
    10c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c7:	e8 25 05 00 00       	call   15f1 <printf>
    exit();
    10cc:	e8 70 03 00 00       	call   1441 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    10d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d4:	89 44 24 14          	mov    %eax,0x14(%esp)
    10d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10db:	89 44 24 10          	mov    %eax,0x10(%esp)
    10df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ed:	c7 44 24 04 4b 1d 00 	movl   $0x1d4b,0x4(%esp)
    10f4:	00 
    10f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fc:	e8 f0 04 00 00       	call   15f1 <printf>
}
    1101:	c9                   	leave  
    1102:	c3                   	ret    

00001103 <main>:

int
main(int argc, char *argv[])
{
    1103:	55                   	push   %ebp
    1104:	89 e5                	mov    %esp,%ebp
    1106:	83 e4 f0             	and    $0xfffffff0,%esp
    1109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    110c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1110:	7f 19                	jg     112b <main+0x28>
    wc(0, "");
    1112:	c7 44 24 04 58 1d 00 	movl   $0x1d58,0x4(%esp)
    1119:	00 
    111a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1121:	e8 da fe ff ff       	call   1000 <wc>
    exit();
    1126:	e8 16 03 00 00       	call   1441 <exit>
  }

  for(i = 1; i < argc; i++){
    112b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1132:	00 
    1133:	e9 8f 00 00 00       	jmp    11c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
    1138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    113c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1143:	8b 45 0c             	mov    0xc(%ebp),%eax
    1146:	01 d0                	add    %edx,%eax
    1148:	8b 00                	mov    (%eax),%eax
    114a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1151:	00 
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 27 03 00 00       	call   1481 <open>
    115a:	89 44 24 18          	mov    %eax,0x18(%esp)
    115e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    1163:	79 2f                	jns    1194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
    1165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1170:	8b 45 0c             	mov    0xc(%ebp),%eax
    1173:	01 d0                	add    %edx,%eax
    1175:	8b 00                	mov    (%eax),%eax
    1177:	89 44 24 08          	mov    %eax,0x8(%esp)
    117b:	c7 44 24 04 59 1d 00 	movl   $0x1d59,0x4(%esp)
    1182:	00 
    1183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    118a:	e8 62 04 00 00       	call   15f1 <printf>
      exit();
    118f:	e8 ad 02 00 00       	call   1441 <exit>
    }
    wc(fd, argv[i]);
    1194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119f:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a2:	01 d0                	add    %edx,%eax
    11a4:	8b 00                	mov    (%eax),%eax
    11a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    11aa:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ae:	89 04 24             	mov    %eax,(%esp)
    11b1:	e8 4a fe ff ff       	call   1000 <wc>
    close(fd);
    11b6:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ba:	89 04 24             	mov    %eax,(%esp)
    11bd:	e8 a7 02 00 00       	call   1469 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    11c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11cb:	3b 45 08             	cmp    0x8(%ebp),%eax
    11ce:	0f 8c 64 ff ff ff    	jl     1138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
    11d4:	e8 68 02 00 00       	call   1441 <exit>

000011d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11d9:	55                   	push   %ebp
    11da:	89 e5                	mov    %esp,%ebp
    11dc:	57                   	push   %edi
    11dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11de:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11e1:	8b 55 10             	mov    0x10(%ebp),%edx
    11e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e7:	89 cb                	mov    %ecx,%ebx
    11e9:	89 df                	mov    %ebx,%edi
    11eb:	89 d1                	mov    %edx,%ecx
    11ed:	fc                   	cld    
    11ee:	f3 aa                	rep stos %al,%es:(%edi)
    11f0:	89 ca                	mov    %ecx,%edx
    11f2:	89 fb                	mov    %edi,%ebx
    11f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11fa:	5b                   	pop    %ebx
    11fb:	5f                   	pop    %edi
    11fc:	5d                   	pop    %ebp
    11fd:	c3                   	ret    

000011fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11fe:	55                   	push   %ebp
    11ff:	89 e5                	mov    %esp,%ebp
    1201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    120a:	90                   	nop
    120b:	8b 45 08             	mov    0x8(%ebp),%eax
    120e:	8d 50 01             	lea    0x1(%eax),%edx
    1211:	89 55 08             	mov    %edx,0x8(%ebp)
    1214:	8b 55 0c             	mov    0xc(%ebp),%edx
    1217:	8d 4a 01             	lea    0x1(%edx),%ecx
    121a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    121d:	0f b6 12             	movzbl (%edx),%edx
    1220:	88 10                	mov    %dl,(%eax)
    1222:	0f b6 00             	movzbl (%eax),%eax
    1225:	84 c0                	test   %al,%al
    1227:	75 e2                	jne    120b <strcpy+0xd>
    ;
  return os;
    1229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    122c:	c9                   	leave  
    122d:	c3                   	ret    

0000122e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    122e:	55                   	push   %ebp
    122f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1231:	eb 08                	jmp    123b <strcmp+0xd>
    p++, q++;
    1233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	0f b6 00             	movzbl (%eax),%eax
    1241:	84 c0                	test   %al,%al
    1243:	74 10                	je     1255 <strcmp+0x27>
    1245:	8b 45 08             	mov    0x8(%ebp),%eax
    1248:	0f b6 10             	movzbl (%eax),%edx
    124b:	8b 45 0c             	mov    0xc(%ebp),%eax
    124e:	0f b6 00             	movzbl (%eax),%eax
    1251:	38 c2                	cmp    %al,%dl
    1253:	74 de                	je     1233 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	0f b6 00             	movzbl (%eax),%eax
    125b:	0f b6 d0             	movzbl %al,%edx
    125e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1261:	0f b6 00             	movzbl (%eax),%eax
    1264:	0f b6 c0             	movzbl %al,%eax
    1267:	29 c2                	sub    %eax,%edx
    1269:	89 d0                	mov    %edx,%eax
}
    126b:	5d                   	pop    %ebp
    126c:	c3                   	ret    

0000126d <strlen>:

uint
strlen(char *s)
{
    126d:	55                   	push   %ebp
    126e:	89 e5                	mov    %esp,%ebp
    1270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    127a:	eb 04                	jmp    1280 <strlen+0x13>
    127c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1280:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	01 d0                	add    %edx,%eax
    1288:	0f b6 00             	movzbl (%eax),%eax
    128b:	84 c0                	test   %al,%al
    128d:	75 ed                	jne    127c <strlen+0xf>
    ;
  return n;
    128f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1292:	c9                   	leave  
    1293:	c3                   	ret    

00001294 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1294:	55                   	push   %ebp
    1295:	89 e5                	mov    %esp,%ebp
    1297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    129a:	8b 45 10             	mov    0x10(%ebp),%eax
    129d:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    12a8:	8b 45 08             	mov    0x8(%ebp),%eax
    12ab:	89 04 24             	mov    %eax,(%esp)
    12ae:	e8 26 ff ff ff       	call   11d9 <stosb>
  return dst;
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12b6:	c9                   	leave  
    12b7:	c3                   	ret    

000012b8 <strchr>:

char*
strchr(const char *s, char c)
{
    12b8:	55                   	push   %ebp
    12b9:	89 e5                	mov    %esp,%ebp
    12bb:	83 ec 04             	sub    $0x4,%esp
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12c4:	eb 14                	jmp    12da <strchr+0x22>
    if(*s == c)
    12c6:	8b 45 08             	mov    0x8(%ebp),%eax
    12c9:	0f b6 00             	movzbl (%eax),%eax
    12cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12cf:	75 05                	jne    12d6 <strchr+0x1e>
      return (char*)s;
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	eb 13                	jmp    12e9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12da:	8b 45 08             	mov    0x8(%ebp),%eax
    12dd:	0f b6 00             	movzbl (%eax),%eax
    12e0:	84 c0                	test   %al,%al
    12e2:	75 e2                	jne    12c6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12e9:	c9                   	leave  
    12ea:	c3                   	ret    

000012eb <gets>:

char*
gets(char *buf, int max)
{
    12eb:	55                   	push   %ebp
    12ec:	89 e5                	mov    %esp,%ebp
    12ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12f8:	eb 4c                	jmp    1346 <gets+0x5b>
    cc = read(0, &c, 1);
    12fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1301:	00 
    1302:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1305:	89 44 24 04          	mov    %eax,0x4(%esp)
    1309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1310:	e8 44 01 00 00       	call   1459 <read>
    1315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    131c:	7f 02                	jg     1320 <gets+0x35>
      break;
    131e:	eb 31                	jmp    1351 <gets+0x66>
    buf[i++] = c;
    1320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1323:	8d 50 01             	lea    0x1(%eax),%edx
    1326:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1329:	89 c2                	mov    %eax,%edx
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
    132e:	01 c2                	add    %eax,%edx
    1330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    133a:	3c 0a                	cmp    $0xa,%al
    133c:	74 13                	je     1351 <gets+0x66>
    133e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1342:	3c 0d                	cmp    $0xd,%al
    1344:	74 0b                	je     1351 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	83 c0 01             	add    $0x1,%eax
    134c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    134f:	7c a9                	jl     12fa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1351:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1354:	8b 45 08             	mov    0x8(%ebp),%eax
    1357:	01 d0                	add    %edx,%eax
    1359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    135c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135f:	c9                   	leave  
    1360:	c3                   	ret    

00001361 <stat>:

int
stat(char *n, struct stat *st)
{
    1361:	55                   	push   %ebp
    1362:	89 e5                	mov    %esp,%ebp
    1364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    136e:	00 
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	89 04 24             	mov    %eax,(%esp)
    1375:	e8 07 01 00 00       	call   1481 <open>
    137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1381:	79 07                	jns    138a <stat+0x29>
    return -1;
    1383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1388:	eb 23                	jmp    13ad <stat+0x4c>
  r = fstat(fd, st);
    138a:	8b 45 0c             	mov    0xc(%ebp),%eax
    138d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1391:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1394:	89 04 24             	mov    %eax,(%esp)
    1397:	e8 fd 00 00 00       	call   1499 <fstat>
    139c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a2:	89 04 24             	mov    %eax,(%esp)
    13a5:	e8 bf 00 00 00       	call   1469 <close>
  return r;
    13aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13ad:	c9                   	leave  
    13ae:	c3                   	ret    

000013af <atoi>:

int
atoi(const char *s)
{
    13af:	55                   	push   %ebp
    13b0:	89 e5                	mov    %esp,%ebp
    13b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    13b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13bc:	eb 25                	jmp    13e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
    13be:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13c1:	89 d0                	mov    %edx,%eax
    13c3:	c1 e0 02             	shl    $0x2,%eax
    13c6:	01 d0                	add    %edx,%eax
    13c8:	01 c0                	add    %eax,%eax
    13ca:	89 c1                	mov    %eax,%ecx
    13cc:	8b 45 08             	mov    0x8(%ebp),%eax
    13cf:	8d 50 01             	lea    0x1(%eax),%edx
    13d2:	89 55 08             	mov    %edx,0x8(%ebp)
    13d5:	0f b6 00             	movzbl (%eax),%eax
    13d8:	0f be c0             	movsbl %al,%eax
    13db:	01 c8                	add    %ecx,%eax
    13dd:	83 e8 30             	sub    $0x30,%eax
    13e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13e3:	8b 45 08             	mov    0x8(%ebp),%eax
    13e6:	0f b6 00             	movzbl (%eax),%eax
    13e9:	3c 2f                	cmp    $0x2f,%al
    13eb:	7e 0a                	jle    13f7 <atoi+0x48>
    13ed:	8b 45 08             	mov    0x8(%ebp),%eax
    13f0:	0f b6 00             	movzbl (%eax),%eax
    13f3:	3c 39                	cmp    $0x39,%al
    13f5:	7e c7                	jle    13be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13fa:	c9                   	leave  
    13fb:	c3                   	ret    

000013fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13fc:	55                   	push   %ebp
    13fd:	89 e5                	mov    %esp,%ebp
    13ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1402:	8b 45 08             	mov    0x8(%ebp),%eax
    1405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1408:	8b 45 0c             	mov    0xc(%ebp),%eax
    140b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    140e:	eb 17                	jmp    1427 <memmove+0x2b>
    *dst++ = *src++;
    1410:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1413:	8d 50 01             	lea    0x1(%eax),%edx
    1416:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1419:	8b 55 f8             	mov    -0x8(%ebp),%edx
    141c:	8d 4a 01             	lea    0x1(%edx),%ecx
    141f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1422:	0f b6 12             	movzbl (%edx),%edx
    1425:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1427:	8b 45 10             	mov    0x10(%ebp),%eax
    142a:	8d 50 ff             	lea    -0x1(%eax),%edx
    142d:	89 55 10             	mov    %edx,0x10(%ebp)
    1430:	85 c0                	test   %eax,%eax
    1432:	7f dc                	jg     1410 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1437:	c9                   	leave  
    1438:	c3                   	ret    

00001439 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1439:	b8 01 00 00 00       	mov    $0x1,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <exit>:
SYSCALL(exit)
    1441:	b8 02 00 00 00       	mov    $0x2,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <wait>:
SYSCALL(wait)
    1449:	b8 03 00 00 00       	mov    $0x3,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <pipe>:
SYSCALL(pipe)
    1451:	b8 04 00 00 00       	mov    $0x4,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <read>:
SYSCALL(read)
    1459:	b8 05 00 00 00       	mov    $0x5,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <write>:
SYSCALL(write)
    1461:	b8 10 00 00 00       	mov    $0x10,%eax
    1466:	cd 40                	int    $0x40
    1468:	c3                   	ret    

00001469 <close>:
SYSCALL(close)
    1469:	b8 15 00 00 00       	mov    $0x15,%eax
    146e:	cd 40                	int    $0x40
    1470:	c3                   	ret    

00001471 <kill>:
SYSCALL(kill)
    1471:	b8 06 00 00 00       	mov    $0x6,%eax
    1476:	cd 40                	int    $0x40
    1478:	c3                   	ret    

00001479 <exec>:
SYSCALL(exec)
    1479:	b8 07 00 00 00       	mov    $0x7,%eax
    147e:	cd 40                	int    $0x40
    1480:	c3                   	ret    

00001481 <open>:
SYSCALL(open)
    1481:	b8 0f 00 00 00       	mov    $0xf,%eax
    1486:	cd 40                	int    $0x40
    1488:	c3                   	ret    

00001489 <mknod>:
SYSCALL(mknod)
    1489:	b8 11 00 00 00       	mov    $0x11,%eax
    148e:	cd 40                	int    $0x40
    1490:	c3                   	ret    

00001491 <unlink>:
SYSCALL(unlink)
    1491:	b8 12 00 00 00       	mov    $0x12,%eax
    1496:	cd 40                	int    $0x40
    1498:	c3                   	ret    

00001499 <fstat>:
SYSCALL(fstat)
    1499:	b8 08 00 00 00       	mov    $0x8,%eax
    149e:	cd 40                	int    $0x40
    14a0:	c3                   	ret    

000014a1 <link>:
SYSCALL(link)
    14a1:	b8 13 00 00 00       	mov    $0x13,%eax
    14a6:	cd 40                	int    $0x40
    14a8:	c3                   	ret    

000014a9 <mkdir>:
SYSCALL(mkdir)
    14a9:	b8 14 00 00 00       	mov    $0x14,%eax
    14ae:	cd 40                	int    $0x40
    14b0:	c3                   	ret    

000014b1 <chdir>:
SYSCALL(chdir)
    14b1:	b8 09 00 00 00       	mov    $0x9,%eax
    14b6:	cd 40                	int    $0x40
    14b8:	c3                   	ret    

000014b9 <dup>:
SYSCALL(dup)
    14b9:	b8 0a 00 00 00       	mov    $0xa,%eax
    14be:	cd 40                	int    $0x40
    14c0:	c3                   	ret    

000014c1 <getpid>:
SYSCALL(getpid)
    14c1:	b8 0b 00 00 00       	mov    $0xb,%eax
    14c6:	cd 40                	int    $0x40
    14c8:	c3                   	ret    

000014c9 <sbrk>:
SYSCALL(sbrk)
    14c9:	b8 0c 00 00 00       	mov    $0xc,%eax
    14ce:	cd 40                	int    $0x40
    14d0:	c3                   	ret    

000014d1 <sleep>:
SYSCALL(sleep)
    14d1:	b8 0d 00 00 00       	mov    $0xd,%eax
    14d6:	cd 40                	int    $0x40
    14d8:	c3                   	ret    

000014d9 <uptime>:
SYSCALL(uptime)
    14d9:	b8 0e 00 00 00       	mov    $0xe,%eax
    14de:	cd 40                	int    $0x40
    14e0:	c3                   	ret    

000014e1 <clone>:
SYSCALL(clone)
    14e1:	b8 16 00 00 00       	mov    $0x16,%eax
    14e6:	cd 40                	int    $0x40
    14e8:	c3                   	ret    

000014e9 <texit>:
SYSCALL(texit)
    14e9:	b8 17 00 00 00       	mov    $0x17,%eax
    14ee:	cd 40                	int    $0x40
    14f0:	c3                   	ret    

000014f1 <tsleep>:
SYSCALL(tsleep)
    14f1:	b8 18 00 00 00       	mov    $0x18,%eax
    14f6:	cd 40                	int    $0x40
    14f8:	c3                   	ret    

000014f9 <twakeup>:
SYSCALL(twakeup)
    14f9:	b8 19 00 00 00       	mov    $0x19,%eax
    14fe:	cd 40                	int    $0x40
    1500:	c3                   	ret    

00001501 <thread_yield>:
SYSCALL(thread_yield)
    1501:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1506:	cd 40                	int    $0x40
    1508:	c3                   	ret    

00001509 <thread_yield3>:
    1509:	b8 1a 00 00 00       	mov    $0x1a,%eax
    150e:	cd 40                	int    $0x40
    1510:	c3                   	ret    

00001511 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1511:	55                   	push   %ebp
    1512:	89 e5                	mov    %esp,%ebp
    1514:	83 ec 18             	sub    $0x18,%esp
    1517:	8b 45 0c             	mov    0xc(%ebp),%eax
    151a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    151d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1524:	00 
    1525:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1528:	89 44 24 04          	mov    %eax,0x4(%esp)
    152c:	8b 45 08             	mov    0x8(%ebp),%eax
    152f:	89 04 24             	mov    %eax,(%esp)
    1532:	e8 2a ff ff ff       	call   1461 <write>
}
    1537:	c9                   	leave  
    1538:	c3                   	ret    

00001539 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1539:	55                   	push   %ebp
    153a:	89 e5                	mov    %esp,%ebp
    153c:	56                   	push   %esi
    153d:	53                   	push   %ebx
    153e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1548:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    154c:	74 17                	je     1565 <printint+0x2c>
    154e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1552:	79 11                	jns    1565 <printint+0x2c>
    neg = 1;
    1554:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    155b:	8b 45 0c             	mov    0xc(%ebp),%eax
    155e:	f7 d8                	neg    %eax
    1560:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1563:	eb 06                	jmp    156b <printint+0x32>
  } else {
    x = xx;
    1565:	8b 45 0c             	mov    0xc(%ebp),%eax
    1568:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    156b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1572:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1575:	8d 41 01             	lea    0x1(%ecx),%eax
    1578:	89 45 f4             	mov    %eax,-0xc(%ebp)
    157b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    157e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1581:	ba 00 00 00 00       	mov    $0x0,%edx
    1586:	f7 f3                	div    %ebx
    1588:	89 d0                	mov    %edx,%eax
    158a:	0f b6 80 a0 21 00 00 	movzbl 0x21a0(%eax),%eax
    1591:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1595:	8b 75 10             	mov    0x10(%ebp),%esi
    1598:	8b 45 ec             	mov    -0x14(%ebp),%eax
    159b:	ba 00 00 00 00       	mov    $0x0,%edx
    15a0:	f7 f6                	div    %esi
    15a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15a9:	75 c7                	jne    1572 <printint+0x39>
  if(neg)
    15ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15af:	74 10                	je     15c1 <printint+0x88>
    buf[i++] = '-';
    15b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b4:	8d 50 01             	lea    0x1(%eax),%edx
    15b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15ba:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    15bf:	eb 1f                	jmp    15e0 <printint+0xa7>
    15c1:	eb 1d                	jmp    15e0 <printint+0xa7>
    putc(fd, buf[i]);
    15c3:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c9:	01 d0                	add    %edx,%eax
    15cb:	0f b6 00             	movzbl (%eax),%eax
    15ce:	0f be c0             	movsbl %al,%eax
    15d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d5:	8b 45 08             	mov    0x8(%ebp),%eax
    15d8:	89 04 24             	mov    %eax,(%esp)
    15db:	e8 31 ff ff ff       	call   1511 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15e0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15e8:	79 d9                	jns    15c3 <printint+0x8a>
    putc(fd, buf[i]);
}
    15ea:	83 c4 30             	add    $0x30,%esp
    15ed:	5b                   	pop    %ebx
    15ee:	5e                   	pop    %esi
    15ef:	5d                   	pop    %ebp
    15f0:	c3                   	ret    

000015f1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15f1:	55                   	push   %ebp
    15f2:	89 e5                	mov    %esp,%ebp
    15f4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15fe:	8d 45 0c             	lea    0xc(%ebp),%eax
    1601:	83 c0 04             	add    $0x4,%eax
    1604:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1607:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    160e:	e9 7c 01 00 00       	jmp    178f <printf+0x19e>
    c = fmt[i] & 0xff;
    1613:	8b 55 0c             	mov    0xc(%ebp),%edx
    1616:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1619:	01 d0                	add    %edx,%eax
    161b:	0f b6 00             	movzbl (%eax),%eax
    161e:	0f be c0             	movsbl %al,%eax
    1621:	25 ff 00 00 00       	and    $0xff,%eax
    1626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    162d:	75 2c                	jne    165b <printf+0x6a>
      if(c == '%'){
    162f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1633:	75 0c                	jne    1641 <printf+0x50>
        state = '%';
    1635:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    163c:	e9 4a 01 00 00       	jmp    178b <printf+0x19a>
      } else {
        putc(fd, c);
    1641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1644:	0f be c0             	movsbl %al,%eax
    1647:	89 44 24 04          	mov    %eax,0x4(%esp)
    164b:	8b 45 08             	mov    0x8(%ebp),%eax
    164e:	89 04 24             	mov    %eax,(%esp)
    1651:	e8 bb fe ff ff       	call   1511 <putc>
    1656:	e9 30 01 00 00       	jmp    178b <printf+0x19a>
      }
    } else if(state == '%'){
    165b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    165f:	0f 85 26 01 00 00    	jne    178b <printf+0x19a>
      if(c == 'd'){
    1665:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1669:	75 2d                	jne    1698 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    166b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    166e:	8b 00                	mov    (%eax),%eax
    1670:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1677:	00 
    1678:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    167f:	00 
    1680:	89 44 24 04          	mov    %eax,0x4(%esp)
    1684:	8b 45 08             	mov    0x8(%ebp),%eax
    1687:	89 04 24             	mov    %eax,(%esp)
    168a:	e8 aa fe ff ff       	call   1539 <printint>
        ap++;
    168f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1693:	e9 ec 00 00 00       	jmp    1784 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1698:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    169c:	74 06                	je     16a4 <printf+0xb3>
    169e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    16a2:	75 2d                	jne    16d1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    16a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16a7:	8b 00                	mov    (%eax),%eax
    16a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    16b0:	00 
    16b1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    16b8:	00 
    16b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    16bd:	8b 45 08             	mov    0x8(%ebp),%eax
    16c0:	89 04 24             	mov    %eax,(%esp)
    16c3:	e8 71 fe ff ff       	call   1539 <printint>
        ap++;
    16c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16cc:	e9 b3 00 00 00       	jmp    1784 <printf+0x193>
      } else if(c == 's'){
    16d1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16d5:	75 45                	jne    171c <printf+0x12b>
        s = (char*)*ap;
    16d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16da:	8b 00                	mov    (%eax),%eax
    16dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16e7:	75 09                	jne    16f2 <printf+0x101>
          s = "(null)";
    16e9:	c7 45 f4 6d 1d 00 00 	movl   $0x1d6d,-0xc(%ebp)
        while(*s != 0){
    16f0:	eb 1e                	jmp    1710 <printf+0x11f>
    16f2:	eb 1c                	jmp    1710 <printf+0x11f>
          putc(fd, *s);
    16f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f7:	0f b6 00             	movzbl (%eax),%eax
    16fa:	0f be c0             	movsbl %al,%eax
    16fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1701:	8b 45 08             	mov    0x8(%ebp),%eax
    1704:	89 04 24             	mov    %eax,(%esp)
    1707:	e8 05 fe ff ff       	call   1511 <putc>
          s++;
    170c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1710:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1713:	0f b6 00             	movzbl (%eax),%eax
    1716:	84 c0                	test   %al,%al
    1718:	75 da                	jne    16f4 <printf+0x103>
    171a:	eb 68                	jmp    1784 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    171c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1720:	75 1d                	jne    173f <printf+0x14e>
        putc(fd, *ap);
    1722:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1725:	8b 00                	mov    (%eax),%eax
    1727:	0f be c0             	movsbl %al,%eax
    172a:	89 44 24 04          	mov    %eax,0x4(%esp)
    172e:	8b 45 08             	mov    0x8(%ebp),%eax
    1731:	89 04 24             	mov    %eax,(%esp)
    1734:	e8 d8 fd ff ff       	call   1511 <putc>
        ap++;
    1739:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    173d:	eb 45                	jmp    1784 <printf+0x193>
      } else if(c == '%'){
    173f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1743:	75 17                	jne    175c <printf+0x16b>
        putc(fd, c);
    1745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1748:	0f be c0             	movsbl %al,%eax
    174b:	89 44 24 04          	mov    %eax,0x4(%esp)
    174f:	8b 45 08             	mov    0x8(%ebp),%eax
    1752:	89 04 24             	mov    %eax,(%esp)
    1755:	e8 b7 fd ff ff       	call   1511 <putc>
    175a:	eb 28                	jmp    1784 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    175c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1763:	00 
    1764:	8b 45 08             	mov    0x8(%ebp),%eax
    1767:	89 04 24             	mov    %eax,(%esp)
    176a:	e8 a2 fd ff ff       	call   1511 <putc>
        putc(fd, c);
    176f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1772:	0f be c0             	movsbl %al,%eax
    1775:	89 44 24 04          	mov    %eax,0x4(%esp)
    1779:	8b 45 08             	mov    0x8(%ebp),%eax
    177c:	89 04 24             	mov    %eax,(%esp)
    177f:	e8 8d fd ff ff       	call   1511 <putc>
      }
      state = 0;
    1784:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    178b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    178f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1792:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1795:	01 d0                	add    %edx,%eax
    1797:	0f b6 00             	movzbl (%eax),%eax
    179a:	84 c0                	test   %al,%al
    179c:	0f 85 71 fe ff ff    	jne    1613 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    17a2:	c9                   	leave  
    17a3:	c3                   	ret    

000017a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17a4:	55                   	push   %ebp
    17a5:	89 e5                	mov    %esp,%ebp
    17a7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17aa:	8b 45 08             	mov    0x8(%ebp),%eax
    17ad:	83 e8 08             	sub    $0x8,%eax
    17b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b3:	a1 c8 21 00 00       	mov    0x21c8,%eax
    17b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17bb:	eb 24                	jmp    17e1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c0:	8b 00                	mov    (%eax),%eax
    17c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17c5:	77 12                	ja     17d9 <free+0x35>
    17c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17cd:	77 24                	ja     17f3 <free+0x4f>
    17cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d2:	8b 00                	mov    (%eax),%eax
    17d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17d7:	77 1a                	ja     17f3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dc:	8b 00                	mov    (%eax),%eax
    17de:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17e7:	76 d4                	jbe    17bd <free+0x19>
    17e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ec:	8b 00                	mov    (%eax),%eax
    17ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17f1:	76 ca                	jbe    17bd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f6:	8b 40 04             	mov    0x4(%eax),%eax
    17f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1800:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1803:	01 c2                	add    %eax,%edx
    1805:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1808:	8b 00                	mov    (%eax),%eax
    180a:	39 c2                	cmp    %eax,%edx
    180c:	75 24                	jne    1832 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    180e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1811:	8b 50 04             	mov    0x4(%eax),%edx
    1814:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1817:	8b 00                	mov    (%eax),%eax
    1819:	8b 40 04             	mov    0x4(%eax),%eax
    181c:	01 c2                	add    %eax,%edx
    181e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1821:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1824:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1827:	8b 00                	mov    (%eax),%eax
    1829:	8b 10                	mov    (%eax),%edx
    182b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    182e:	89 10                	mov    %edx,(%eax)
    1830:	eb 0a                	jmp    183c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1832:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1835:	8b 10                	mov    (%eax),%edx
    1837:	8b 45 f8             	mov    -0x8(%ebp),%eax
    183a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    183c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    183f:	8b 40 04             	mov    0x4(%eax),%eax
    1842:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1849:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184c:	01 d0                	add    %edx,%eax
    184e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1851:	75 20                	jne    1873 <free+0xcf>
    p->s.size += bp->s.size;
    1853:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1856:	8b 50 04             	mov    0x4(%eax),%edx
    1859:	8b 45 f8             	mov    -0x8(%ebp),%eax
    185c:	8b 40 04             	mov    0x4(%eax),%eax
    185f:	01 c2                	add    %eax,%edx
    1861:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1864:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1867:	8b 45 f8             	mov    -0x8(%ebp),%eax
    186a:	8b 10                	mov    (%eax),%edx
    186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    186f:	89 10                	mov    %edx,(%eax)
    1871:	eb 08                	jmp    187b <free+0xd7>
  } else
    p->s.ptr = bp;
    1873:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1876:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1879:	89 10                	mov    %edx,(%eax)
  freep = p;
    187b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    187e:	a3 c8 21 00 00       	mov    %eax,0x21c8
}
    1883:	c9                   	leave  
    1884:	c3                   	ret    

00001885 <morecore>:

static Header*
morecore(uint nu)
{
    1885:	55                   	push   %ebp
    1886:	89 e5                	mov    %esp,%ebp
    1888:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    188b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1892:	77 07                	ja     189b <morecore+0x16>
    nu = 4096;
    1894:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    189b:	8b 45 08             	mov    0x8(%ebp),%eax
    189e:	c1 e0 03             	shl    $0x3,%eax
    18a1:	89 04 24             	mov    %eax,(%esp)
    18a4:	e8 20 fc ff ff       	call   14c9 <sbrk>
    18a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    18ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    18b0:	75 07                	jne    18b9 <morecore+0x34>
    return 0;
    18b2:	b8 00 00 00 00       	mov    $0x0,%eax
    18b7:	eb 22                	jmp    18db <morecore+0x56>
  hp = (Header*)p;
    18b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    18bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c2:	8b 55 08             	mov    0x8(%ebp),%edx
    18c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18cb:	83 c0 08             	add    $0x8,%eax
    18ce:	89 04 24             	mov    %eax,(%esp)
    18d1:	e8 ce fe ff ff       	call   17a4 <free>
  return freep;
    18d6:	a1 c8 21 00 00       	mov    0x21c8,%eax
}
    18db:	c9                   	leave  
    18dc:	c3                   	ret    

000018dd <malloc>:

void*
malloc(uint nbytes)
{
    18dd:	55                   	push   %ebp
    18de:	89 e5                	mov    %esp,%ebp
    18e0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18e3:	8b 45 08             	mov    0x8(%ebp),%eax
    18e6:	83 c0 07             	add    $0x7,%eax
    18e9:	c1 e8 03             	shr    $0x3,%eax
    18ec:	83 c0 01             	add    $0x1,%eax
    18ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18f2:	a1 c8 21 00 00       	mov    0x21c8,%eax
    18f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18fe:	75 23                	jne    1923 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1900:	c7 45 f0 c0 21 00 00 	movl   $0x21c0,-0x10(%ebp)
    1907:	8b 45 f0             	mov    -0x10(%ebp),%eax
    190a:	a3 c8 21 00 00       	mov    %eax,0x21c8
    190f:	a1 c8 21 00 00       	mov    0x21c8,%eax
    1914:	a3 c0 21 00 00       	mov    %eax,0x21c0
    base.s.size = 0;
    1919:	c7 05 c4 21 00 00 00 	movl   $0x0,0x21c4
    1920:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1923:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1926:	8b 00                	mov    (%eax),%eax
    1928:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192e:	8b 40 04             	mov    0x4(%eax),%eax
    1931:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1934:	72 4d                	jb     1983 <malloc+0xa6>
      if(p->s.size == nunits)
    1936:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1939:	8b 40 04             	mov    0x4(%eax),%eax
    193c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    193f:	75 0c                	jne    194d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1941:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1944:	8b 10                	mov    (%eax),%edx
    1946:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1949:	89 10                	mov    %edx,(%eax)
    194b:	eb 26                	jmp    1973 <malloc+0x96>
      else {
        p->s.size -= nunits;
    194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1950:	8b 40 04             	mov    0x4(%eax),%eax
    1953:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1956:	89 c2                	mov    %eax,%edx
    1958:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1961:	8b 40 04             	mov    0x4(%eax),%eax
    1964:	c1 e0 03             	shl    $0x3,%eax
    1967:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1970:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1973:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1976:	a3 c8 21 00 00       	mov    %eax,0x21c8
      return (void*)(p + 1);
    197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    197e:	83 c0 08             	add    $0x8,%eax
    1981:	eb 38                	jmp    19bb <malloc+0xde>
    }
    if(p == freep)
    1983:	a1 c8 21 00 00       	mov    0x21c8,%eax
    1988:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    198b:	75 1b                	jne    19a8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1990:	89 04 24             	mov    %eax,(%esp)
    1993:	e8 ed fe ff ff       	call   1885 <morecore>
    1998:	89 45 f4             	mov    %eax,-0xc(%ebp)
    199b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    199f:	75 07                	jne    19a8 <malloc+0xcb>
        return 0;
    19a1:	b8 00 00 00 00       	mov    $0x0,%eax
    19a6:	eb 13                	jmp    19bb <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b1:	8b 00                	mov    (%eax),%eax
    19b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    19b6:	e9 70 ff ff ff       	jmp    192b <malloc+0x4e>
}
    19bb:	c9                   	leave  
    19bc:	c3                   	ret    

000019bd <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    19bd:	55                   	push   %ebp
    19be:	89 e5                	mov    %esp,%ebp
    19c0:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    19c3:	8b 55 08             	mov    0x8(%ebp),%edx
    19c6:	8b 45 0c             	mov    0xc(%ebp),%eax
    19c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19cc:	f0 87 02             	lock xchg %eax,(%edx)
    19cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    19d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    19d5:	c9                   	leave  
    19d6:	c3                   	ret    

000019d7 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    19d7:	55                   	push   %ebp
    19d8:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    19da:	8b 45 08             	mov    0x8(%ebp),%eax
    19dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    19e3:	5d                   	pop    %ebp
    19e4:	c3                   	ret    

000019e5 <lock_acquire>:
void lock_acquire(lock_t *lock){
    19e5:	55                   	push   %ebp
    19e6:	89 e5                	mov    %esp,%ebp
    19e8:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    19eb:	90                   	nop
    19ec:	8b 45 08             	mov    0x8(%ebp),%eax
    19ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    19f6:	00 
    19f7:	89 04 24             	mov    %eax,(%esp)
    19fa:	e8 be ff ff ff       	call   19bd <xchg>
    19ff:	85 c0                	test   %eax,%eax
    1a01:	75 e9                	jne    19ec <lock_acquire+0x7>
}
    1a03:	c9                   	leave  
    1a04:	c3                   	ret    

00001a05 <lock_release>:
void lock_release(lock_t *lock){
    1a05:	55                   	push   %ebp
    1a06:	89 e5                	mov    %esp,%ebp
    1a08:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1a0b:	8b 45 08             	mov    0x8(%ebp),%eax
    1a0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a15:	00 
    1a16:	89 04 24             	mov    %eax,(%esp)
    1a19:	e8 9f ff ff ff       	call   19bd <xchg>
}
    1a1e:	c9                   	leave  
    1a1f:	c3                   	ret    

00001a20 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1a20:	55                   	push   %ebp
    1a21:	89 e5                	mov    %esp,%ebp
    1a23:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1a26:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1a2d:	e8 ab fe ff ff       	call   18dd <malloc>
    1a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1a3b:	0f b6 05 cc 21 00 00 	movzbl 0x21cc,%eax
    1a42:	84 c0                	test   %al,%al
    1a44:	75 1c                	jne    1a62 <thread_create+0x42>
        init_q(thQ2);
    1a46:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1a4b:	89 04 24             	mov    %eax,(%esp)
    1a4e:	e8 cd 01 00 00       	call   1c20 <init_q>
        inQ++;
    1a53:	0f b6 05 cc 21 00 00 	movzbl 0x21cc,%eax
    1a5a:	83 c0 01             	add    $0x1,%eax
    1a5d:	a2 cc 21 00 00       	mov    %al,0x21cc
    }

    if((uint)stack % 4096){
    1a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a65:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a6a:	85 c0                	test   %eax,%eax
    1a6c:	74 14                	je     1a82 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a71:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a76:	89 c2                	mov    %eax,%edx
    1a78:	b8 00 10 00 00       	mov    $0x1000,%eax
    1a7d:	29 d0                	sub    %edx,%eax
    1a7f:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a86:	75 1e                	jne    1aa6 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1a88:	c7 44 24 04 74 1d 00 	movl   $0x1d74,0x4(%esp)
    1a8f:	00 
    1a90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a97:	e8 55 fb ff ff       	call   15f1 <printf>
        return 0;
    1a9c:	b8 00 00 00 00       	mov    $0x0,%eax
    1aa1:	e9 9e 00 00 00       	jmp    1b44 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1aa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1aa9:	8b 55 08             	mov    0x8(%ebp),%edx
    1aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1ab3:	89 54 24 08          	mov    %edx,0x8(%esp)
    1ab7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1abe:	00 
    1abf:	89 04 24             	mov    %eax,(%esp)
    1ac2:	e8 1a fa ff ff       	call   14e1 <clone>
    1ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1acd:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ad1:	c7 44 24 04 82 1d 00 	movl   $0x1d82,0x4(%esp)
    1ad8:	00 
    1ad9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ae0:	e8 0c fb ff ff       	call   15f1 <printf>
    if(tid < 0){
    1ae5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ae9:	79 1b                	jns    1b06 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1aeb:	c7 44 24 04 9b 1d 00 	movl   $0x1d9b,0x4(%esp)
    1af2:	00 
    1af3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1afa:	e8 f2 fa ff ff       	call   15f1 <printf>
        return 0;
    1aff:	b8 00 00 00 00       	mov    $0x0,%eax
    1b04:	eb 3e                	jmp    1b44 <thread_create+0x124>
    }
    if(tid > 0){
    1b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b0a:	7e 19                	jle    1b25 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1b0c:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b14:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b18:	89 04 24             	mov    %eax,(%esp)
    1b1b:	e8 22 01 00 00       	call   1c42 <add_q>
        return garbage_stack;
    1b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b23:	eb 1f                	jmp    1b44 <thread_create+0x124>
    }
    if(tid == 0){
    1b25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b29:	75 14                	jne    1b3f <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1b2b:	c7 44 24 04 a8 1d 00 	movl   $0x1da8,0x4(%esp)
    1b32:	00 
    1b33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b3a:	e8 b2 fa ff ff       	call   15f1 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1b3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1b44:	c9                   	leave  
    1b45:	c3                   	ret    

00001b46 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1b46:	55                   	push   %ebp
    1b47:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1b49:	a1 b4 21 00 00       	mov    0x21b4,%eax
    1b4e:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1b54:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1b59:	a3 b4 21 00 00       	mov    %eax,0x21b4
    return (int)(rands % max);
    1b5e:	a1 b4 21 00 00       	mov    0x21b4,%eax
    1b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b66:	ba 00 00 00 00       	mov    $0x0,%edx
    1b6b:	f7 f1                	div    %ecx
    1b6d:	89 d0                	mov    %edx,%eax
}
    1b6f:	5d                   	pop    %ebp
    1b70:	c3                   	ret    

00001b71 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1b71:	55                   	push   %ebp
    1b72:	89 e5                	mov    %esp,%ebp
    1b74:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1b77:	e8 45 f9 ff ff       	call   14c1 <getpid>
    1b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1b7f:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1b87:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b8b:	89 04 24             	mov    %eax,(%esp)
    1b8e:	e8 af 00 00 00       	call   1c42 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1b93:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1b98:	89 04 24             	mov    %eax,(%esp)
    1b9b:	e8 1c 01 00 00       	call   1cbc <pop_q>
    1ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1ba3:	a1 d0 21 00 00       	mov    0x21d0,%eax
    1ba8:	85 c0                	test   %eax,%eax
    1baa:	75 1f                	jne    1bcb <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1bac:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1bb1:	89 04 24             	mov    %eax,(%esp)
    1bb4:	e8 03 01 00 00       	call   1cbc <pop_q>
    1bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1bbc:	a1 d0 21 00 00       	mov    0x21d0,%eax
    1bc1:	83 c0 01             	add    $0x1,%eax
    1bc4:	a3 d0 21 00 00       	mov    %eax,0x21d0
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1bc9:	eb 12                	jmp    1bdd <thread_yield2+0x6c>
    1bcb:	eb 10                	jmp    1bdd <thread_yield2+0x6c>
    1bcd:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1bd2:	89 04 24             	mov    %eax,(%esp)
    1bd5:	e8 e2 00 00 00       	call   1cbc <pop_q>
    1bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1be3:	74 e8                	je     1bcd <thread_yield2+0x5c>
    1be5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1be9:	74 e2                	je     1bcd <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bee:	89 04 24             	mov    %eax,(%esp)
    1bf1:	e8 03 f9 ff ff       	call   14f9 <twakeup>
    tsleep();
    1bf6:	e8 f6 f8 ff ff       	call   14f1 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1bfb:	c9                   	leave  
    1bfc:	c3                   	ret    

00001bfd <thread_yield_last>:

void thread_yield_last(){
    1bfd:	55                   	push   %ebp
    1bfe:	89 e5                	mov    %esp,%ebp
    1c00:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1c03:	a1 e0 23 00 00       	mov    0x23e0,%eax
    1c08:	89 04 24             	mov    %eax,(%esp)
    1c0b:	e8 ac 00 00 00       	call   1cbc <pop_q>
    1c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c16:	89 04 24             	mov    %eax,(%esp)
    1c19:	e8 db f8 ff ff       	call   14f9 <twakeup>
    1c1e:	c9                   	leave  
    1c1f:	c3                   	ret    

00001c20 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1c20:	55                   	push   %ebp
    1c21:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1c23:	8b 45 08             	mov    0x8(%ebp),%eax
    1c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1c2c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1c36:	8b 45 08             	mov    0x8(%ebp),%eax
    1c39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1c40:	5d                   	pop    %ebp
    1c41:	c3                   	ret    

00001c42 <add_q>:

void add_q(struct queue *q, int v){
    1c42:	55                   	push   %ebp
    1c43:	89 e5                	mov    %esp,%ebp
    1c45:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1c48:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1c4f:	e8 89 fc ff ff       	call   18dd <malloc>
    1c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c64:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c67:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1c69:	8b 45 08             	mov    0x8(%ebp),%eax
    1c6c:	8b 40 04             	mov    0x4(%eax),%eax
    1c6f:	85 c0                	test   %eax,%eax
    1c71:	75 0b                	jne    1c7e <add_q+0x3c>
        q->head = n;
    1c73:	8b 45 08             	mov    0x8(%ebp),%eax
    1c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c79:	89 50 04             	mov    %edx,0x4(%eax)
    1c7c:	eb 0c                	jmp    1c8a <add_q+0x48>
    }else{
        q->tail->next = n;
    1c7e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c81:	8b 40 08             	mov    0x8(%eax),%eax
    1c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c87:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1c8a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c90:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1c93:	8b 45 08             	mov    0x8(%ebp),%eax
    1c96:	8b 00                	mov    (%eax),%eax
    1c98:	8d 50 01             	lea    0x1(%eax),%edx
    1c9b:	8b 45 08             	mov    0x8(%ebp),%eax
    1c9e:	89 10                	mov    %edx,(%eax)
}
    1ca0:	c9                   	leave  
    1ca1:	c3                   	ret    

00001ca2 <empty_q>:

int empty_q(struct queue *q){
    1ca2:	55                   	push   %ebp
    1ca3:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1ca5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca8:	8b 00                	mov    (%eax),%eax
    1caa:	85 c0                	test   %eax,%eax
    1cac:	75 07                	jne    1cb5 <empty_q+0x13>
        return 1;
    1cae:	b8 01 00 00 00       	mov    $0x1,%eax
    1cb3:	eb 05                	jmp    1cba <empty_q+0x18>
    else
        return 0;
    1cb5:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1cba:	5d                   	pop    %ebp
    1cbb:	c3                   	ret    

00001cbc <pop_q>:
int pop_q(struct queue *q){
    1cbc:	55                   	push   %ebp
    1cbd:	89 e5                	mov    %esp,%ebp
    1cbf:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1cc2:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc5:	89 04 24             	mov    %eax,(%esp)
    1cc8:	e8 d5 ff ff ff       	call   1ca2 <empty_q>
    1ccd:	85 c0                	test   %eax,%eax
    1ccf:	75 5d                	jne    1d2e <pop_q+0x72>
       val = q->head->value; 
    1cd1:	8b 45 08             	mov    0x8(%ebp),%eax
    1cd4:	8b 40 04             	mov    0x4(%eax),%eax
    1cd7:	8b 00                	mov    (%eax),%eax
    1cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1cdc:	8b 45 08             	mov    0x8(%ebp),%eax
    1cdf:	8b 40 04             	mov    0x4(%eax),%eax
    1ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1ce5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce8:	8b 40 04             	mov    0x4(%eax),%eax
    1ceb:	8b 50 04             	mov    0x4(%eax),%edx
    1cee:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf1:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1cf7:	89 04 24             	mov    %eax,(%esp)
    1cfa:	e8 a5 fa ff ff       	call   17a4 <free>
       q->size--;
    1cff:	8b 45 08             	mov    0x8(%ebp),%eax
    1d02:	8b 00                	mov    (%eax),%eax
    1d04:	8d 50 ff             	lea    -0x1(%eax),%edx
    1d07:	8b 45 08             	mov    0x8(%ebp),%eax
    1d0a:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1d0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d0f:	8b 00                	mov    (%eax),%eax
    1d11:	85 c0                	test   %eax,%eax
    1d13:	75 14                	jne    1d29 <pop_q+0x6d>
            q->head = 0;
    1d15:	8b 45 08             	mov    0x8(%ebp),%eax
    1d18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1d1f:	8b 45 08             	mov    0x8(%ebp),%eax
    1d22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d2c:	eb 05                	jmp    1d33 <pop_q+0x77>
    }
    return -1;
    1d2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1d33:	c9                   	leave  
    1d34:	c3                   	ret    
