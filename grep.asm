
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
    1006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    100d:	e9 bb 00 00 00       	jmp    10cd <grep+0xcd>
    m += n;
    1012:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1015:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
    1018:	c7 45 f0 80 23 00 00 	movl   $0x2380,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    101f:	eb 51                	jmp    1072 <grep+0x72>
      *q = 0;
    1021:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1024:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
    1027:	8b 45 f0             	mov    -0x10(%ebp),%eax
    102a:	89 44 24 04          	mov    %eax,0x4(%esp)
    102e:	8b 45 08             	mov    0x8(%ebp),%eax
    1031:	89 04 24             	mov    %eax,(%esp)
    1034:	e8 bc 01 00 00       	call   11f5 <match>
    1039:	85 c0                	test   %eax,%eax
    103b:	74 2c                	je     1069 <grep+0x69>
        *q = '\n';
    103d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1040:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
    1043:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1046:	83 c0 01             	add    $0x1,%eax
    1049:	89 c2                	mov    %eax,%edx
    104b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    104e:	29 c2                	sub    %eax,%edx
    1050:	89 d0                	mov    %edx,%eax
    1052:	89 44 24 08          	mov    %eax,0x8(%esp)
    1056:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1059:	89 44 24 04          	mov    %eax,0x4(%esp)
    105d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1064:	e8 74 05 00 00       	call   15dd <write>
      }
      p = q+1;
    1069:	8b 45 e8             	mov    -0x18(%ebp),%eax
    106c:	83 c0 01             	add    $0x1,%eax
    106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
    1072:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    1079:	00 
    107a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    107d:	89 04 24             	mov    %eax,(%esp)
    1080:	e8 af 03 00 00       	call   1434 <strchr>
    1085:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1088:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    108c:	75 93                	jne    1021 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
    108e:	81 7d f0 80 23 00 00 	cmpl   $0x2380,-0x10(%ebp)
    1095:	75 07                	jne    109e <grep+0x9e>
      m = 0;
    1097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
    109e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a2:	7e 29                	jle    10cd <grep+0xcd>
      m -= p - buf;
    10a4:	ba 80 23 00 00       	mov    $0x2380,%edx
    10a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ac:	29 c2                	sub    %eax,%edx
    10ae:	89 d0                	mov    %edx,%eax
    10b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
    10b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c1:	c7 04 24 80 23 00 00 	movl   $0x2380,(%esp)
    10c8:	e8 ab 04 00 00       	call   1578 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    10cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d0:	ba 00 04 00 00       	mov    $0x400,%edx
    10d5:	29 c2                	sub    %eax,%edx
    10d7:	89 d0                	mov    %edx,%eax
    10d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10dc:	81 c2 80 23 00 00    	add    $0x2380,%edx
    10e2:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e6:	89 54 24 04          	mov    %edx,0x4(%esp)
    10ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ed:	89 04 24             	mov    %eax,(%esp)
    10f0:	e8 e0 04 00 00       	call   15d5 <read>
    10f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10fc:	0f 8f 10 ff ff ff    	jg     1012 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
    1102:	c9                   	leave  
    1103:	c3                   	ret    

00001104 <main>:

int
main(int argc, char *argv[])
{
    1104:	55                   	push   %ebp
    1105:	89 e5                	mov    %esp,%ebp
    1107:	83 e4 f0             	and    $0xfffffff0,%esp
    110a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    110d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1111:	7f 19                	jg     112c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
    1113:	c7 44 24 04 98 1e 00 	movl   $0x1e98,0x4(%esp)
    111a:	00 
    111b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1122:	e8 46 06 00 00       	call   176d <printf>
    exit();
    1127:	e8 91 04 00 00       	call   15bd <exit>
  }
  pattern = argv[1];
    112c:	8b 45 0c             	mov    0xc(%ebp),%eax
    112f:	8b 40 04             	mov    0x4(%eax),%eax
    1132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
    1136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    113a:	7f 19                	jg     1155 <main+0x51>
    grep(pattern, 0);
    113c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1143:	00 
    1144:	8b 44 24 18          	mov    0x18(%esp),%eax
    1148:	89 04 24             	mov    %eax,(%esp)
    114b:	e8 b0 fe ff ff       	call   1000 <grep>
    exit();
    1150:	e8 68 04 00 00       	call   15bd <exit>
  }

  for(i = 2; i < argc; i++){
    1155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
    115c:	00 
    115d:	e9 81 00 00 00       	jmp    11e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
    1162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    116d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1170:	01 d0                	add    %edx,%eax
    1172:	8b 00                	mov    (%eax),%eax
    1174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    117b:	00 
    117c:	89 04 24             	mov    %eax,(%esp)
    117f:	e8 79 04 00 00       	call   15fd <open>
    1184:	89 44 24 14          	mov    %eax,0x14(%esp)
    1188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    118d:	79 2f                	jns    11be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
    118f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119a:	8b 45 0c             	mov    0xc(%ebp),%eax
    119d:	01 d0                	add    %edx,%eax
    119f:	8b 00                	mov    (%eax),%eax
    11a1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11a5:	c7 44 24 04 b8 1e 00 	movl   $0x1eb8,0x4(%esp)
    11ac:	00 
    11ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11b4:	e8 b4 05 00 00       	call   176d <printf>
      exit();
    11b9:	e8 ff 03 00 00       	call   15bd <exit>
    }
    grep(pattern, fd);
    11be:	8b 44 24 14          	mov    0x14(%esp),%eax
    11c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11c6:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ca:	89 04 24             	mov    %eax,(%esp)
    11cd:	e8 2e fe ff ff       	call   1000 <grep>
    close(fd);
    11d2:	8b 44 24 14          	mov    0x14(%esp),%eax
    11d6:	89 04 24             	mov    %eax,(%esp)
    11d9:	e8 07 04 00 00       	call   15e5 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    11de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11e7:	3b 45 08             	cmp    0x8(%ebp),%eax
    11ea:	0f 8c 72 ff ff ff    	jl     1162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
    11f0:	e8 c8 03 00 00       	call   15bd <exit>

000011f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    11f5:	55                   	push   %ebp
    11f6:	89 e5                	mov    %esp,%ebp
    11f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	0f b6 00             	movzbl (%eax),%eax
    1201:	3c 5e                	cmp    $0x5e,%al
    1203:	75 17                	jne    121c <match+0x27>
    return matchhere(re+1, text);
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	8d 50 01             	lea    0x1(%eax),%edx
    120b:	8b 45 0c             	mov    0xc(%ebp),%eax
    120e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1212:	89 14 24             	mov    %edx,(%esp)
    1215:	e8 36 00 00 00       	call   1250 <matchhere>
    121a:	eb 32                	jmp    124e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
    121c:	8b 45 0c             	mov    0xc(%ebp),%eax
    121f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	89 04 24             	mov    %eax,(%esp)
    1229:	e8 22 00 00 00       	call   1250 <matchhere>
    122e:	85 c0                	test   %eax,%eax
    1230:	74 07                	je     1239 <match+0x44>
      return 1;
    1232:	b8 01 00 00 00       	mov    $0x1,%eax
    1237:	eb 15                	jmp    124e <match+0x59>
  }while(*text++ != '\0');
    1239:	8b 45 0c             	mov    0xc(%ebp),%eax
    123c:	8d 50 01             	lea    0x1(%eax),%edx
    123f:	89 55 0c             	mov    %edx,0xc(%ebp)
    1242:	0f b6 00             	movzbl (%eax),%eax
    1245:	84 c0                	test   %al,%al
    1247:	75 d3                	jne    121c <match+0x27>
  return 0;
    1249:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124e:	c9                   	leave  
    124f:	c3                   	ret    

00001250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
    1256:	8b 45 08             	mov    0x8(%ebp),%eax
    1259:	0f b6 00             	movzbl (%eax),%eax
    125c:	84 c0                	test   %al,%al
    125e:	75 0a                	jne    126a <matchhere+0x1a>
    return 1;
    1260:	b8 01 00 00 00       	mov    $0x1,%eax
    1265:	e9 9b 00 00 00       	jmp    1305 <matchhere+0xb5>
  if(re[1] == '*')
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	83 c0 01             	add    $0x1,%eax
    1270:	0f b6 00             	movzbl (%eax),%eax
    1273:	3c 2a                	cmp    $0x2a,%al
    1275:	75 24                	jne    129b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	8d 48 02             	lea    0x2(%eax),%ecx
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	0f b6 00             	movzbl (%eax),%eax
    1283:	0f be c0             	movsbl %al,%eax
    1286:	8b 55 0c             	mov    0xc(%ebp),%edx
    1289:	89 54 24 08          	mov    %edx,0x8(%esp)
    128d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    1291:	89 04 24             	mov    %eax,(%esp)
    1294:	e8 6e 00 00 00       	call   1307 <matchstar>
    1299:	eb 6a                	jmp    1305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
    129b:	8b 45 08             	mov    0x8(%ebp),%eax
    129e:	0f b6 00             	movzbl (%eax),%eax
    12a1:	3c 24                	cmp    $0x24,%al
    12a3:	75 1d                	jne    12c2 <matchhere+0x72>
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	83 c0 01             	add    $0x1,%eax
    12ab:	0f b6 00             	movzbl (%eax),%eax
    12ae:	84 c0                	test   %al,%al
    12b0:	75 10                	jne    12c2 <matchhere+0x72>
    return *text == '\0';
    12b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b5:	0f b6 00             	movzbl (%eax),%eax
    12b8:	84 c0                	test   %al,%al
    12ba:	0f 94 c0             	sete   %al
    12bd:	0f b6 c0             	movzbl %al,%eax
    12c0:	eb 43                	jmp    1305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    12c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c5:	0f b6 00             	movzbl (%eax),%eax
    12c8:	84 c0                	test   %al,%al
    12ca:	74 34                	je     1300 <matchhere+0xb0>
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
    12cf:	0f b6 00             	movzbl (%eax),%eax
    12d2:	3c 2e                	cmp    $0x2e,%al
    12d4:	74 10                	je     12e6 <matchhere+0x96>
    12d6:	8b 45 08             	mov    0x8(%ebp),%eax
    12d9:	0f b6 10             	movzbl (%eax),%edx
    12dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    12df:	0f b6 00             	movzbl (%eax),%eax
    12e2:	38 c2                	cmp    %al,%dl
    12e4:	75 1a                	jne    1300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
    12e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    12e9:	8d 50 01             	lea    0x1(%eax),%edx
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	83 c0 01             	add    $0x1,%eax
    12f2:	89 54 24 04          	mov    %edx,0x4(%esp)
    12f6:	89 04 24             	mov    %eax,(%esp)
    12f9:	e8 52 ff ff ff       	call   1250 <matchhere>
    12fe:	eb 05                	jmp    1305 <matchhere+0xb5>
  return 0;
    1300:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1305:	c9                   	leave  
    1306:	c3                   	ret    

00001307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1307:	55                   	push   %ebp
    1308:	89 e5                	mov    %esp,%ebp
    130a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    130d:	8b 45 10             	mov    0x10(%ebp),%eax
    1310:	89 44 24 04          	mov    %eax,0x4(%esp)
    1314:	8b 45 0c             	mov    0xc(%ebp),%eax
    1317:	89 04 24             	mov    %eax,(%esp)
    131a:	e8 31 ff ff ff       	call   1250 <matchhere>
    131f:	85 c0                	test   %eax,%eax
    1321:	74 07                	je     132a <matchstar+0x23>
      return 1;
    1323:	b8 01 00 00 00       	mov    $0x1,%eax
    1328:	eb 29                	jmp    1353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
    132a:	8b 45 10             	mov    0x10(%ebp),%eax
    132d:	0f b6 00             	movzbl (%eax),%eax
    1330:	84 c0                	test   %al,%al
    1332:	74 1a                	je     134e <matchstar+0x47>
    1334:	8b 45 10             	mov    0x10(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 10             	mov    %edx,0x10(%ebp)
    133d:	0f b6 00             	movzbl (%eax),%eax
    1340:	0f be c0             	movsbl %al,%eax
    1343:	3b 45 08             	cmp    0x8(%ebp),%eax
    1346:	74 c5                	je     130d <matchstar+0x6>
    1348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
    134c:	74 bf                	je     130d <matchstar+0x6>
  return 0;
    134e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1353:	c9                   	leave  
    1354:	c3                   	ret    

00001355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1355:	55                   	push   %ebp
    1356:	89 e5                	mov    %esp,%ebp
    1358:	57                   	push   %edi
    1359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    135a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    135d:	8b 55 10             	mov    0x10(%ebp),%edx
    1360:	8b 45 0c             	mov    0xc(%ebp),%eax
    1363:	89 cb                	mov    %ecx,%ebx
    1365:	89 df                	mov    %ebx,%edi
    1367:	89 d1                	mov    %edx,%ecx
    1369:	fc                   	cld    
    136a:	f3 aa                	rep stos %al,%es:(%edi)
    136c:	89 ca                	mov    %ecx,%edx
    136e:	89 fb                	mov    %edi,%ebx
    1370:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1376:	5b                   	pop    %ebx
    1377:	5f                   	pop    %edi
    1378:	5d                   	pop    %ebp
    1379:	c3                   	ret    

0000137a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    137a:	55                   	push   %ebp
    137b:	89 e5                	mov    %esp,%ebp
    137d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1380:	8b 45 08             	mov    0x8(%ebp),%eax
    1383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1386:	90                   	nop
    1387:	8b 45 08             	mov    0x8(%ebp),%eax
    138a:	8d 50 01             	lea    0x1(%eax),%edx
    138d:	89 55 08             	mov    %edx,0x8(%ebp)
    1390:	8b 55 0c             	mov    0xc(%ebp),%edx
    1393:	8d 4a 01             	lea    0x1(%edx),%ecx
    1396:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1399:	0f b6 12             	movzbl (%edx),%edx
    139c:	88 10                	mov    %dl,(%eax)
    139e:	0f b6 00             	movzbl (%eax),%eax
    13a1:	84 c0                	test   %al,%al
    13a3:	75 e2                	jne    1387 <strcpy+0xd>
    ;
  return os;
    13a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13a8:	c9                   	leave  
    13a9:	c3                   	ret    

000013aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13aa:	55                   	push   %ebp
    13ab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13ad:	eb 08                	jmp    13b7 <strcmp+0xd>
    p++, q++;
    13af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13b7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ba:	0f b6 00             	movzbl (%eax),%eax
    13bd:	84 c0                	test   %al,%al
    13bf:	74 10                	je     13d1 <strcmp+0x27>
    13c1:	8b 45 08             	mov    0x8(%ebp),%eax
    13c4:	0f b6 10             	movzbl (%eax),%edx
    13c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ca:	0f b6 00             	movzbl (%eax),%eax
    13cd:	38 c2                	cmp    %al,%dl
    13cf:	74 de                	je     13af <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	0f b6 00             	movzbl (%eax),%eax
    13d7:	0f b6 d0             	movzbl %al,%edx
    13da:	8b 45 0c             	mov    0xc(%ebp),%eax
    13dd:	0f b6 00             	movzbl (%eax),%eax
    13e0:	0f b6 c0             	movzbl %al,%eax
    13e3:	29 c2                	sub    %eax,%edx
    13e5:	89 d0                	mov    %edx,%eax
}
    13e7:	5d                   	pop    %ebp
    13e8:	c3                   	ret    

000013e9 <strlen>:

uint
strlen(char *s)
{
    13e9:	55                   	push   %ebp
    13ea:	89 e5                	mov    %esp,%ebp
    13ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13f6:	eb 04                	jmp    13fc <strlen+0x13>
    13f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1402:	01 d0                	add    %edx,%eax
    1404:	0f b6 00             	movzbl (%eax),%eax
    1407:	84 c0                	test   %al,%al
    1409:	75 ed                	jne    13f8 <strlen+0xf>
    ;
  return n;
    140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    140e:	c9                   	leave  
    140f:	c3                   	ret    

00001410 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1416:	8b 45 10             	mov    0x10(%ebp),%eax
    1419:	89 44 24 08          	mov    %eax,0x8(%esp)
    141d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1420:	89 44 24 04          	mov    %eax,0x4(%esp)
    1424:	8b 45 08             	mov    0x8(%ebp),%eax
    1427:	89 04 24             	mov    %eax,(%esp)
    142a:	e8 26 ff ff ff       	call   1355 <stosb>
  return dst;
    142f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1432:	c9                   	leave  
    1433:	c3                   	ret    

00001434 <strchr>:

char*
strchr(const char *s, char c)
{
    1434:	55                   	push   %ebp
    1435:	89 e5                	mov    %esp,%ebp
    1437:	83 ec 04             	sub    $0x4,%esp
    143a:	8b 45 0c             	mov    0xc(%ebp),%eax
    143d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1440:	eb 14                	jmp    1456 <strchr+0x22>
    if(*s == c)
    1442:	8b 45 08             	mov    0x8(%ebp),%eax
    1445:	0f b6 00             	movzbl (%eax),%eax
    1448:	3a 45 fc             	cmp    -0x4(%ebp),%al
    144b:	75 05                	jne    1452 <strchr+0x1e>
      return (char*)s;
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	eb 13                	jmp    1465 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1456:	8b 45 08             	mov    0x8(%ebp),%eax
    1459:	0f b6 00             	movzbl (%eax),%eax
    145c:	84 c0                	test   %al,%al
    145e:	75 e2                	jne    1442 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1460:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1465:	c9                   	leave  
    1466:	c3                   	ret    

00001467 <gets>:

char*
gets(char *buf, int max)
{
    1467:	55                   	push   %ebp
    1468:	89 e5                	mov    %esp,%ebp
    146a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    146d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1474:	eb 4c                	jmp    14c2 <gets+0x5b>
    cc = read(0, &c, 1);
    1476:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    147d:	00 
    147e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1481:	89 44 24 04          	mov    %eax,0x4(%esp)
    1485:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    148c:	e8 44 01 00 00       	call   15d5 <read>
    1491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1498:	7f 02                	jg     149c <gets+0x35>
      break;
    149a:	eb 31                	jmp    14cd <gets+0x66>
    buf[i++] = c;
    149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149f:	8d 50 01             	lea    0x1(%eax),%edx
    14a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14a5:	89 c2                	mov    %eax,%edx
    14a7:	8b 45 08             	mov    0x8(%ebp),%eax
    14aa:	01 c2                	add    %eax,%edx
    14ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	3c 0a                	cmp    $0xa,%al
    14b8:	74 13                	je     14cd <gets+0x66>
    14ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14be:	3c 0d                	cmp    $0xd,%al
    14c0:	74 0b                	je     14cd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c5:	83 c0 01             	add    $0x1,%eax
    14c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14cb:	7c a9                	jl     1476 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14d0:	8b 45 08             	mov    0x8(%ebp),%eax
    14d3:	01 d0                	add    %edx,%eax
    14d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14db:	c9                   	leave  
    14dc:	c3                   	ret    

000014dd <stat>:

int
stat(char *n, struct stat *st)
{
    14dd:	55                   	push   %ebp
    14de:	89 e5                	mov    %esp,%ebp
    14e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14ea:	00 
    14eb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ee:	89 04 24             	mov    %eax,(%esp)
    14f1:	e8 07 01 00 00       	call   15fd <open>
    14f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14fd:	79 07                	jns    1506 <stat+0x29>
    return -1;
    14ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1504:	eb 23                	jmp    1529 <stat+0x4c>
  r = fstat(fd, st);
    1506:	8b 45 0c             	mov    0xc(%ebp),%eax
    1509:	89 44 24 04          	mov    %eax,0x4(%esp)
    150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1510:	89 04 24             	mov    %eax,(%esp)
    1513:	e8 fd 00 00 00       	call   1615 <fstat>
    1518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	89 04 24             	mov    %eax,(%esp)
    1521:	e8 bf 00 00 00       	call   15e5 <close>
  return r;
    1526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1529:	c9                   	leave  
    152a:	c3                   	ret    

0000152b <atoi>:

int
atoi(const char *s)
{
    152b:	55                   	push   %ebp
    152c:	89 e5                	mov    %esp,%ebp
    152e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1538:	eb 25                	jmp    155f <atoi+0x34>
    n = n*10 + *s++ - '0';
    153a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    153d:	89 d0                	mov    %edx,%eax
    153f:	c1 e0 02             	shl    $0x2,%eax
    1542:	01 d0                	add    %edx,%eax
    1544:	01 c0                	add    %eax,%eax
    1546:	89 c1                	mov    %eax,%ecx
    1548:	8b 45 08             	mov    0x8(%ebp),%eax
    154b:	8d 50 01             	lea    0x1(%eax),%edx
    154e:	89 55 08             	mov    %edx,0x8(%ebp)
    1551:	0f b6 00             	movzbl (%eax),%eax
    1554:	0f be c0             	movsbl %al,%eax
    1557:	01 c8                	add    %ecx,%eax
    1559:	83 e8 30             	sub    $0x30,%eax
    155c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    155f:	8b 45 08             	mov    0x8(%ebp),%eax
    1562:	0f b6 00             	movzbl (%eax),%eax
    1565:	3c 2f                	cmp    $0x2f,%al
    1567:	7e 0a                	jle    1573 <atoi+0x48>
    1569:	8b 45 08             	mov    0x8(%ebp),%eax
    156c:	0f b6 00             	movzbl (%eax),%eax
    156f:	3c 39                	cmp    $0x39,%al
    1571:	7e c7                	jle    153a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1576:	c9                   	leave  
    1577:	c3                   	ret    

00001578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1578:	55                   	push   %ebp
    1579:	89 e5                	mov    %esp,%ebp
    157b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    157e:	8b 45 08             	mov    0x8(%ebp),%eax
    1581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1584:	8b 45 0c             	mov    0xc(%ebp),%eax
    1587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    158a:	eb 17                	jmp    15a3 <memmove+0x2b>
    *dst++ = *src++;
    158c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    158f:	8d 50 01             	lea    0x1(%eax),%edx
    1592:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1595:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1598:	8d 4a 01             	lea    0x1(%edx),%ecx
    159b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    159e:	0f b6 12             	movzbl (%edx),%edx
    15a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    15a3:	8b 45 10             	mov    0x10(%ebp),%eax
    15a6:	8d 50 ff             	lea    -0x1(%eax),%edx
    15a9:	89 55 10             	mov    %edx,0x10(%ebp)
    15ac:	85 c0                	test   %eax,%eax
    15ae:	7f dc                	jg     158c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b3:	c9                   	leave  
    15b4:	c3                   	ret    

000015b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15b5:	b8 01 00 00 00       	mov    $0x1,%eax
    15ba:	cd 40                	int    $0x40
    15bc:	c3                   	ret    

000015bd <exit>:
SYSCALL(exit)
    15bd:	b8 02 00 00 00       	mov    $0x2,%eax
    15c2:	cd 40                	int    $0x40
    15c4:	c3                   	ret    

000015c5 <wait>:
SYSCALL(wait)
    15c5:	b8 03 00 00 00       	mov    $0x3,%eax
    15ca:	cd 40                	int    $0x40
    15cc:	c3                   	ret    

000015cd <pipe>:
SYSCALL(pipe)
    15cd:	b8 04 00 00 00       	mov    $0x4,%eax
    15d2:	cd 40                	int    $0x40
    15d4:	c3                   	ret    

000015d5 <read>:
SYSCALL(read)
    15d5:	b8 05 00 00 00       	mov    $0x5,%eax
    15da:	cd 40                	int    $0x40
    15dc:	c3                   	ret    

000015dd <write>:
SYSCALL(write)
    15dd:	b8 10 00 00 00       	mov    $0x10,%eax
    15e2:	cd 40                	int    $0x40
    15e4:	c3                   	ret    

000015e5 <close>:
SYSCALL(close)
    15e5:	b8 15 00 00 00       	mov    $0x15,%eax
    15ea:	cd 40                	int    $0x40
    15ec:	c3                   	ret    

000015ed <kill>:
SYSCALL(kill)
    15ed:	b8 06 00 00 00       	mov    $0x6,%eax
    15f2:	cd 40                	int    $0x40
    15f4:	c3                   	ret    

000015f5 <exec>:
SYSCALL(exec)
    15f5:	b8 07 00 00 00       	mov    $0x7,%eax
    15fa:	cd 40                	int    $0x40
    15fc:	c3                   	ret    

000015fd <open>:
SYSCALL(open)
    15fd:	b8 0f 00 00 00       	mov    $0xf,%eax
    1602:	cd 40                	int    $0x40
    1604:	c3                   	ret    

00001605 <mknod>:
SYSCALL(mknod)
    1605:	b8 11 00 00 00       	mov    $0x11,%eax
    160a:	cd 40                	int    $0x40
    160c:	c3                   	ret    

0000160d <unlink>:
SYSCALL(unlink)
    160d:	b8 12 00 00 00       	mov    $0x12,%eax
    1612:	cd 40                	int    $0x40
    1614:	c3                   	ret    

00001615 <fstat>:
SYSCALL(fstat)
    1615:	b8 08 00 00 00       	mov    $0x8,%eax
    161a:	cd 40                	int    $0x40
    161c:	c3                   	ret    

0000161d <link>:
SYSCALL(link)
    161d:	b8 13 00 00 00       	mov    $0x13,%eax
    1622:	cd 40                	int    $0x40
    1624:	c3                   	ret    

00001625 <mkdir>:
SYSCALL(mkdir)
    1625:	b8 14 00 00 00       	mov    $0x14,%eax
    162a:	cd 40                	int    $0x40
    162c:	c3                   	ret    

0000162d <chdir>:
SYSCALL(chdir)
    162d:	b8 09 00 00 00       	mov    $0x9,%eax
    1632:	cd 40                	int    $0x40
    1634:	c3                   	ret    

00001635 <dup>:
SYSCALL(dup)
    1635:	b8 0a 00 00 00       	mov    $0xa,%eax
    163a:	cd 40                	int    $0x40
    163c:	c3                   	ret    

0000163d <getpid>:
SYSCALL(getpid)
    163d:	b8 0b 00 00 00       	mov    $0xb,%eax
    1642:	cd 40                	int    $0x40
    1644:	c3                   	ret    

00001645 <sbrk>:
SYSCALL(sbrk)
    1645:	b8 0c 00 00 00       	mov    $0xc,%eax
    164a:	cd 40                	int    $0x40
    164c:	c3                   	ret    

0000164d <sleep>:
SYSCALL(sleep)
    164d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1652:	cd 40                	int    $0x40
    1654:	c3                   	ret    

00001655 <uptime>:
SYSCALL(uptime)
    1655:	b8 0e 00 00 00       	mov    $0xe,%eax
    165a:	cd 40                	int    $0x40
    165c:	c3                   	ret    

0000165d <clone>:
SYSCALL(clone)
    165d:	b8 16 00 00 00       	mov    $0x16,%eax
    1662:	cd 40                	int    $0x40
    1664:	c3                   	ret    

00001665 <texit>:
SYSCALL(texit)
    1665:	b8 17 00 00 00       	mov    $0x17,%eax
    166a:	cd 40                	int    $0x40
    166c:	c3                   	ret    

0000166d <tsleep>:
SYSCALL(tsleep)
    166d:	b8 18 00 00 00       	mov    $0x18,%eax
    1672:	cd 40                	int    $0x40
    1674:	c3                   	ret    

00001675 <twakeup>:
SYSCALL(twakeup)
    1675:	b8 19 00 00 00       	mov    $0x19,%eax
    167a:	cd 40                	int    $0x40
    167c:	c3                   	ret    

0000167d <thread_yield>:
SYSCALL(thread_yield)
    167d:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1682:	cd 40                	int    $0x40
    1684:	c3                   	ret    

00001685 <thread_yield3>:
    1685:	b8 1a 00 00 00       	mov    $0x1a,%eax
    168a:	cd 40                	int    $0x40
    168c:	c3                   	ret    

0000168d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    168d:	55                   	push   %ebp
    168e:	89 e5                	mov    %esp,%ebp
    1690:	83 ec 18             	sub    $0x18,%esp
    1693:	8b 45 0c             	mov    0xc(%ebp),%eax
    1696:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1699:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    16a0:	00 
    16a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
    16a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	89 04 24             	mov    %eax,(%esp)
    16ae:	e8 2a ff ff ff       	call   15dd <write>
}
    16b3:	c9                   	leave  
    16b4:	c3                   	ret    

000016b5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16b5:	55                   	push   %ebp
    16b6:	89 e5                	mov    %esp,%ebp
    16b8:	56                   	push   %esi
    16b9:	53                   	push   %ebx
    16ba:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16c4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16c8:	74 17                	je     16e1 <printint+0x2c>
    16ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16ce:	79 11                	jns    16e1 <printint+0x2c>
    neg = 1;
    16d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    16da:	f7 d8                	neg    %eax
    16dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16df:	eb 06                	jmp    16e7 <printint+0x32>
  } else {
    x = xx;
    16e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    16e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16ee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16f1:	8d 41 01             	lea    0x1(%ecx),%eax
    16f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16fd:	ba 00 00 00 00       	mov    $0x0,%edx
    1702:	f7 f3                	div    %ebx
    1704:	89 d0                	mov    %edx,%eax
    1706:	0f b6 80 48 23 00 00 	movzbl 0x2348(%eax),%eax
    170d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1711:	8b 75 10             	mov    0x10(%ebp),%esi
    1714:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1717:	ba 00 00 00 00       	mov    $0x0,%edx
    171c:	f7 f6                	div    %esi
    171e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1721:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1725:	75 c7                	jne    16ee <printint+0x39>
  if(neg)
    1727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    172b:	74 10                	je     173d <printint+0x88>
    buf[i++] = '-';
    172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1730:	8d 50 01             	lea    0x1(%eax),%edx
    1733:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1736:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    173b:	eb 1f                	jmp    175c <printint+0xa7>
    173d:	eb 1d                	jmp    175c <printint+0xa7>
    putc(fd, buf[i]);
    173f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1742:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1745:	01 d0                	add    %edx,%eax
    1747:	0f b6 00             	movzbl (%eax),%eax
    174a:	0f be c0             	movsbl %al,%eax
    174d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1751:	8b 45 08             	mov    0x8(%ebp),%eax
    1754:	89 04 24             	mov    %eax,(%esp)
    1757:	e8 31 ff ff ff       	call   168d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    175c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1764:	79 d9                	jns    173f <printint+0x8a>
    putc(fd, buf[i]);
}
    1766:	83 c4 30             	add    $0x30,%esp
    1769:	5b                   	pop    %ebx
    176a:	5e                   	pop    %esi
    176b:	5d                   	pop    %ebp
    176c:	c3                   	ret    

0000176d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    176d:	55                   	push   %ebp
    176e:	89 e5                	mov    %esp,%ebp
    1770:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1773:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    177a:	8d 45 0c             	lea    0xc(%ebp),%eax
    177d:	83 c0 04             	add    $0x4,%eax
    1780:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    178a:	e9 7c 01 00 00       	jmp    190b <printf+0x19e>
    c = fmt[i] & 0xff;
    178f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1792:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1795:	01 d0                	add    %edx,%eax
    1797:	0f b6 00             	movzbl (%eax),%eax
    179a:	0f be c0             	movsbl %al,%eax
    179d:	25 ff 00 00 00       	and    $0xff,%eax
    17a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    17a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17a9:	75 2c                	jne    17d7 <printf+0x6a>
      if(c == '%'){
    17ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17af:	75 0c                	jne    17bd <printf+0x50>
        state = '%';
    17b1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17b8:	e9 4a 01 00 00       	jmp    1907 <printf+0x19a>
      } else {
        putc(fd, c);
    17bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17c0:	0f be c0             	movsbl %al,%eax
    17c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    17c7:	8b 45 08             	mov    0x8(%ebp),%eax
    17ca:	89 04 24             	mov    %eax,(%esp)
    17cd:	e8 bb fe ff ff       	call   168d <putc>
    17d2:	e9 30 01 00 00       	jmp    1907 <printf+0x19a>
      }
    } else if(state == '%'){
    17d7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17db:	0f 85 26 01 00 00    	jne    1907 <printf+0x19a>
      if(c == 'd'){
    17e1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17e5:	75 2d                	jne    1814 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17ea:	8b 00                	mov    (%eax),%eax
    17ec:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17f3:	00 
    17f4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17fb:	00 
    17fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1800:	8b 45 08             	mov    0x8(%ebp),%eax
    1803:	89 04 24             	mov    %eax,(%esp)
    1806:	e8 aa fe ff ff       	call   16b5 <printint>
        ap++;
    180b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    180f:	e9 ec 00 00 00       	jmp    1900 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1814:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1818:	74 06                	je     1820 <printf+0xb3>
    181a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    181e:	75 2d                	jne    184d <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1820:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1823:	8b 00                	mov    (%eax),%eax
    1825:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    182c:	00 
    182d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1834:	00 
    1835:	89 44 24 04          	mov    %eax,0x4(%esp)
    1839:	8b 45 08             	mov    0x8(%ebp),%eax
    183c:	89 04 24             	mov    %eax,(%esp)
    183f:	e8 71 fe ff ff       	call   16b5 <printint>
        ap++;
    1844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1848:	e9 b3 00 00 00       	jmp    1900 <printf+0x193>
      } else if(c == 's'){
    184d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1851:	75 45                	jne    1898 <printf+0x12b>
        s = (char*)*ap;
    1853:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1856:	8b 00                	mov    (%eax),%eax
    1858:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    185b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    185f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1863:	75 09                	jne    186e <printf+0x101>
          s = "(null)";
    1865:	c7 45 f4 ce 1e 00 00 	movl   $0x1ece,-0xc(%ebp)
        while(*s != 0){
    186c:	eb 1e                	jmp    188c <printf+0x11f>
    186e:	eb 1c                	jmp    188c <printf+0x11f>
          putc(fd, *s);
    1870:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1873:	0f b6 00             	movzbl (%eax),%eax
    1876:	0f be c0             	movsbl %al,%eax
    1879:	89 44 24 04          	mov    %eax,0x4(%esp)
    187d:	8b 45 08             	mov    0x8(%ebp),%eax
    1880:	89 04 24             	mov    %eax,(%esp)
    1883:	e8 05 fe ff ff       	call   168d <putc>
          s++;
    1888:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188f:	0f b6 00             	movzbl (%eax),%eax
    1892:	84 c0                	test   %al,%al
    1894:	75 da                	jne    1870 <printf+0x103>
    1896:	eb 68                	jmp    1900 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1898:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    189c:	75 1d                	jne    18bb <printf+0x14e>
        putc(fd, *ap);
    189e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18a1:	8b 00                	mov    (%eax),%eax
    18a3:	0f be c0             	movsbl %al,%eax
    18a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    18aa:	8b 45 08             	mov    0x8(%ebp),%eax
    18ad:	89 04 24             	mov    %eax,(%esp)
    18b0:	e8 d8 fd ff ff       	call   168d <putc>
        ap++;
    18b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18b9:	eb 45                	jmp    1900 <printf+0x193>
      } else if(c == '%'){
    18bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18bf:	75 17                	jne    18d8 <printf+0x16b>
        putc(fd, c);
    18c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18c4:	0f be c0             	movsbl %al,%eax
    18c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    18cb:	8b 45 08             	mov    0x8(%ebp),%eax
    18ce:	89 04 24             	mov    %eax,(%esp)
    18d1:	e8 b7 fd ff ff       	call   168d <putc>
    18d6:	eb 28                	jmp    1900 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18d8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18df:	00 
    18e0:	8b 45 08             	mov    0x8(%ebp),%eax
    18e3:	89 04 24             	mov    %eax,(%esp)
    18e6:	e8 a2 fd ff ff       	call   168d <putc>
        putc(fd, c);
    18eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18ee:	0f be c0             	movsbl %al,%eax
    18f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    18f5:	8b 45 08             	mov    0x8(%ebp),%eax
    18f8:	89 04 24             	mov    %eax,(%esp)
    18fb:	e8 8d fd ff ff       	call   168d <putc>
      }
      state = 0;
    1900:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1907:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    190b:	8b 55 0c             	mov    0xc(%ebp),%edx
    190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1911:	01 d0                	add    %edx,%eax
    1913:	0f b6 00             	movzbl (%eax),%eax
    1916:	84 c0                	test   %al,%al
    1918:	0f 85 71 fe ff ff    	jne    178f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    191e:	c9                   	leave  
    191f:	c3                   	ret    

00001920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1920:	55                   	push   %ebp
    1921:	89 e5                	mov    %esp,%ebp
    1923:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1926:	8b 45 08             	mov    0x8(%ebp),%eax
    1929:	83 e8 08             	sub    $0x8,%eax
    192c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    192f:	a1 68 23 00 00       	mov    0x2368,%eax
    1934:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1937:	eb 24                	jmp    195d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1939:	8b 45 fc             	mov    -0x4(%ebp),%eax
    193c:	8b 00                	mov    (%eax),%eax
    193e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1941:	77 12                	ja     1955 <free+0x35>
    1943:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1949:	77 24                	ja     196f <free+0x4f>
    194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    194e:	8b 00                	mov    (%eax),%eax
    1950:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1953:	77 1a                	ja     196f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1955:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1958:	8b 00                	mov    (%eax),%eax
    195a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    195d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1960:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1963:	76 d4                	jbe    1939 <free+0x19>
    1965:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1968:	8b 00                	mov    (%eax),%eax
    196a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    196d:	76 ca                	jbe    1939 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    196f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1972:	8b 40 04             	mov    0x4(%eax),%eax
    1975:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    197c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197f:	01 c2                	add    %eax,%edx
    1981:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1984:	8b 00                	mov    (%eax),%eax
    1986:	39 c2                	cmp    %eax,%edx
    1988:	75 24                	jne    19ae <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    198a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    198d:	8b 50 04             	mov    0x4(%eax),%edx
    1990:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1993:	8b 00                	mov    (%eax),%eax
    1995:	8b 40 04             	mov    0x4(%eax),%eax
    1998:	01 c2                	add    %eax,%edx
    199a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    199d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    19a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a3:	8b 00                	mov    (%eax),%eax
    19a5:	8b 10                	mov    (%eax),%edx
    19a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19aa:	89 10                	mov    %edx,(%eax)
    19ac:	eb 0a                	jmp    19b8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    19ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b1:	8b 10                	mov    (%eax),%edx
    19b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19bb:	8b 40 04             	mov    0x4(%eax),%eax
    19be:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c8:	01 d0                	add    %edx,%eax
    19ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19cd:	75 20                	jne    19ef <free+0xcf>
    p->s.size += bp->s.size;
    19cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d2:	8b 50 04             	mov    0x4(%eax),%edx
    19d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19d8:	8b 40 04             	mov    0x4(%eax),%eax
    19db:	01 c2                	add    %eax,%edx
    19dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19e6:	8b 10                	mov    (%eax),%edx
    19e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19eb:	89 10                	mov    %edx,(%eax)
    19ed:	eb 08                	jmp    19f7 <free+0xd7>
  } else
    p->s.ptr = bp;
    19ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19f5:	89 10                	mov    %edx,(%eax)
  freep = p;
    19f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19fa:	a3 68 23 00 00       	mov    %eax,0x2368
}
    19ff:	c9                   	leave  
    1a00:	c3                   	ret    

00001a01 <morecore>:

static Header*
morecore(uint nu)
{
    1a01:	55                   	push   %ebp
    1a02:	89 e5                	mov    %esp,%ebp
    1a04:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a07:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a0e:	77 07                	ja     1a17 <morecore+0x16>
    nu = 4096;
    1a10:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a17:	8b 45 08             	mov    0x8(%ebp),%eax
    1a1a:	c1 e0 03             	shl    $0x3,%eax
    1a1d:	89 04 24             	mov    %eax,(%esp)
    1a20:	e8 20 fc ff ff       	call   1645 <sbrk>
    1a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a28:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a2c:	75 07                	jne    1a35 <morecore+0x34>
    return 0;
    1a2e:	b8 00 00 00 00       	mov    $0x0,%eax
    1a33:	eb 22                	jmp    1a57 <morecore+0x56>
  hp = (Header*)p;
    1a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a3e:	8b 55 08             	mov    0x8(%ebp),%edx
    1a41:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a47:	83 c0 08             	add    $0x8,%eax
    1a4a:	89 04 24             	mov    %eax,(%esp)
    1a4d:	e8 ce fe ff ff       	call   1920 <free>
  return freep;
    1a52:	a1 68 23 00 00       	mov    0x2368,%eax
}
    1a57:	c9                   	leave  
    1a58:	c3                   	ret    

00001a59 <malloc>:

void*
malloc(uint nbytes)
{
    1a59:	55                   	push   %ebp
    1a5a:	89 e5                	mov    %esp,%ebp
    1a5c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a62:	83 c0 07             	add    $0x7,%eax
    1a65:	c1 e8 03             	shr    $0x3,%eax
    1a68:	83 c0 01             	add    $0x1,%eax
    1a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a6e:	a1 68 23 00 00       	mov    0x2368,%eax
    1a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a7a:	75 23                	jne    1a9f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a7c:	c7 45 f0 60 23 00 00 	movl   $0x2360,-0x10(%ebp)
    1a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a86:	a3 68 23 00 00       	mov    %eax,0x2368
    1a8b:	a1 68 23 00 00       	mov    0x2368,%eax
    1a90:	a3 60 23 00 00       	mov    %eax,0x2360
    base.s.size = 0;
    1a95:	c7 05 64 23 00 00 00 	movl   $0x0,0x2364
    1a9c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa2:	8b 00                	mov    (%eax),%eax
    1aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aaa:	8b 40 04             	mov    0x4(%eax),%eax
    1aad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ab0:	72 4d                	jb     1aff <malloc+0xa6>
      if(p->s.size == nunits)
    1ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab5:	8b 40 04             	mov    0x4(%eax),%eax
    1ab8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1abb:	75 0c                	jne    1ac9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac0:	8b 10                	mov    (%eax),%edx
    1ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ac5:	89 10                	mov    %edx,(%eax)
    1ac7:	eb 26                	jmp    1aef <malloc+0x96>
      else {
        p->s.size -= nunits;
    1ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acc:	8b 40 04             	mov    0x4(%eax),%eax
    1acf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ad2:	89 c2                	mov    %eax,%edx
    1ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1add:	8b 40 04             	mov    0x4(%eax),%eax
    1ae0:	c1 e0 03             	shl    $0x3,%eax
    1ae3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1aec:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1af2:	a3 68 23 00 00       	mov    %eax,0x2368
      return (void*)(p + 1);
    1af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1afa:	83 c0 08             	add    $0x8,%eax
    1afd:	eb 38                	jmp    1b37 <malloc+0xde>
    }
    if(p == freep)
    1aff:	a1 68 23 00 00       	mov    0x2368,%eax
    1b04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b07:	75 1b                	jne    1b24 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b0c:	89 04 24             	mov    %eax,(%esp)
    1b0f:	e8 ed fe ff ff       	call   1a01 <morecore>
    1b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b1b:	75 07                	jne    1b24 <malloc+0xcb>
        return 0;
    1b1d:	b8 00 00 00 00       	mov    $0x0,%eax
    1b22:	eb 13                	jmp    1b37 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2d:	8b 00                	mov    (%eax),%eax
    1b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b32:	e9 70 ff ff ff       	jmp    1aa7 <malloc+0x4e>
}
    1b37:	c9                   	leave  
    1b38:	c3                   	ret    

00001b39 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1b39:	55                   	push   %ebp
    1b3a:	89 e5                	mov    %esp,%ebp
    1b3c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1b3f:	8b 55 08             	mov    0x8(%ebp),%edx
    1b42:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b48:	f0 87 02             	lock xchg %eax,(%edx)
    1b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1b51:	c9                   	leave  
    1b52:	c3                   	ret    

00001b53 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1b53:	55                   	push   %ebp
    1b54:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1b56:	8b 45 08             	mov    0x8(%ebp),%eax
    1b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b5f:	5d                   	pop    %ebp
    1b60:	c3                   	ret    

00001b61 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1b61:	55                   	push   %ebp
    1b62:	89 e5                	mov    %esp,%ebp
    1b64:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1b67:	90                   	nop
    1b68:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b72:	00 
    1b73:	89 04 24             	mov    %eax,(%esp)
    1b76:	e8 be ff ff ff       	call   1b39 <xchg>
    1b7b:	85 c0                	test   %eax,%eax
    1b7d:	75 e9                	jne    1b68 <lock_acquire+0x7>
}
    1b7f:	c9                   	leave  
    1b80:	c3                   	ret    

00001b81 <lock_release>:
void lock_release(lock_t *lock){
    1b81:	55                   	push   %ebp
    1b82:	89 e5                	mov    %esp,%ebp
    1b84:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1b87:	8b 45 08             	mov    0x8(%ebp),%eax
    1b8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b91:	00 
    1b92:	89 04 24             	mov    %eax,(%esp)
    1b95:	e8 9f ff ff ff       	call   1b39 <xchg>
}
    1b9a:	c9                   	leave  
    1b9b:	c3                   	ret    

00001b9c <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1b9c:	55                   	push   %ebp
    1b9d:	89 e5                	mov    %esp,%ebp
    1b9f:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1ba2:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1ba9:	e8 ab fe ff ff       	call   1a59 <malloc>
    1bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1bb7:	0f b6 05 6c 23 00 00 	movzbl 0x236c,%eax
    1bbe:	84 c0                	test   %al,%al
    1bc0:	75 1c                	jne    1bde <thread_create+0x42>
        init_q(thQ2);
    1bc2:	a1 80 27 00 00       	mov    0x2780,%eax
    1bc7:	89 04 24             	mov    %eax,(%esp)
    1bca:	e8 b2 01 00 00       	call   1d81 <init_q>
        inQ++;
    1bcf:	0f b6 05 6c 23 00 00 	movzbl 0x236c,%eax
    1bd6:	83 c0 01             	add    $0x1,%eax
    1bd9:	a2 6c 23 00 00       	mov    %al,0x236c
    }

    if((uint)stack % 4096){
    1bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be1:	25 ff 0f 00 00       	and    $0xfff,%eax
    1be6:	85 c0                	test   %eax,%eax
    1be8:	74 14                	je     1bfe <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bed:	25 ff 0f 00 00       	and    $0xfff,%eax
    1bf2:	89 c2                	mov    %eax,%edx
    1bf4:	b8 00 10 00 00       	mov    $0x1000,%eax
    1bf9:	29 d0                	sub    %edx,%eax
    1bfb:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c02:	75 1e                	jne    1c22 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1c04:	c7 44 24 04 d5 1e 00 	movl   $0x1ed5,0x4(%esp)
    1c0b:	00 
    1c0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c13:	e8 55 fb ff ff       	call   176d <printf>
        return 0;
    1c18:	b8 00 00 00 00       	mov    $0x0,%eax
    1c1d:	e9 83 00 00 00       	jmp    1ca5 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1c25:	8b 55 08             	mov    0x8(%ebp),%edx
    1c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1c2f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1c33:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1c3a:	00 
    1c3b:	89 04 24             	mov    %eax,(%esp)
    1c3e:	e8 1a fa ff ff       	call   165d <clone>
    1c43:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1c46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c4a:	79 1b                	jns    1c67 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1c4c:	c7 44 24 04 e3 1e 00 	movl   $0x1ee3,0x4(%esp)
    1c53:	00 
    1c54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c5b:	e8 0d fb ff ff       	call   176d <printf>
        return 0;
    1c60:	b8 00 00 00 00       	mov    $0x0,%eax
    1c65:	eb 3e                	jmp    1ca5 <thread_create+0x109>
    }
    if(tid > 0){
    1c67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c6b:	7e 19                	jle    1c86 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1c6d:	a1 80 27 00 00       	mov    0x2780,%eax
    1c72:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1c75:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c79:	89 04 24             	mov    %eax,(%esp)
    1c7c:	e8 22 01 00 00       	call   1da3 <add_q>
        return garbage_stack;
    1c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c84:	eb 1f                	jmp    1ca5 <thread_create+0x109>
    }
    if(tid == 0){
    1c86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c8a:	75 14                	jne    1ca0 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1c8c:	c7 44 24 04 f0 1e 00 	movl   $0x1ef0,0x4(%esp)
    1c93:	00 
    1c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c9b:	e8 cd fa ff ff       	call   176d <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1ca5:	c9                   	leave  
    1ca6:	c3                   	ret    

00001ca7 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1ca7:	55                   	push   %ebp
    1ca8:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1caa:	a1 5c 23 00 00       	mov    0x235c,%eax
    1caf:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1cb5:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1cba:	a3 5c 23 00 00       	mov    %eax,0x235c
    return (int)(rands % max);
    1cbf:	a1 5c 23 00 00       	mov    0x235c,%eax
    1cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1cc7:	ba 00 00 00 00       	mov    $0x0,%edx
    1ccc:	f7 f1                	div    %ecx
    1cce:	89 d0                	mov    %edx,%eax
}
    1cd0:	5d                   	pop    %ebp
    1cd1:	c3                   	ret    

00001cd2 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1cd2:	55                   	push   %ebp
    1cd3:	89 e5                	mov    %esp,%ebp
    1cd5:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1cd8:	e8 60 f9 ff ff       	call   163d <getpid>
    1cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1ce0:	a1 80 27 00 00       	mov    0x2780,%eax
    1ce5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1ce8:	89 54 24 04          	mov    %edx,0x4(%esp)
    1cec:	89 04 24             	mov    %eax,(%esp)
    1cef:	e8 af 00 00 00       	call   1da3 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1cf4:	a1 80 27 00 00       	mov    0x2780,%eax
    1cf9:	89 04 24             	mov    %eax,(%esp)
    1cfc:	e8 1c 01 00 00       	call   1e1d <pop_q>
    1d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1d04:	a1 70 23 00 00       	mov    0x2370,%eax
    1d09:	85 c0                	test   %eax,%eax
    1d0b:	75 1f                	jne    1d2c <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1d0d:	a1 80 27 00 00       	mov    0x2780,%eax
    1d12:	89 04 24             	mov    %eax,(%esp)
    1d15:	e8 03 01 00 00       	call   1e1d <pop_q>
    1d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1d1d:	a1 70 23 00 00       	mov    0x2370,%eax
    1d22:	83 c0 01             	add    $0x1,%eax
    1d25:	a3 70 23 00 00       	mov    %eax,0x2370
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1d2a:	eb 12                	jmp    1d3e <thread_yield2+0x6c>
    1d2c:	eb 10                	jmp    1d3e <thread_yield2+0x6c>
    1d2e:	a1 80 27 00 00       	mov    0x2780,%eax
    1d33:	89 04 24             	mov    %eax,(%esp)
    1d36:	e8 e2 00 00 00       	call   1e1d <pop_q>
    1d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1d44:	74 e8                	je     1d2e <thread_yield2+0x5c>
    1d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d4a:	74 e2                	je     1d2e <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d4f:	89 04 24             	mov    %eax,(%esp)
    1d52:	e8 1e f9 ff ff       	call   1675 <twakeup>
    tsleep();
    1d57:	e8 11 f9 ff ff       	call   166d <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1d5c:	c9                   	leave  
    1d5d:	c3                   	ret    

00001d5e <thread_yield_last>:

void thread_yield_last(){
    1d5e:	55                   	push   %ebp
    1d5f:	89 e5                	mov    %esp,%ebp
    1d61:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1d64:	a1 80 27 00 00       	mov    0x2780,%eax
    1d69:	89 04 24             	mov    %eax,(%esp)
    1d6c:	e8 ac 00 00 00       	call   1e1d <pop_q>
    1d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d77:	89 04 24             	mov    %eax,(%esp)
    1d7a:	e8 f6 f8 ff ff       	call   1675 <twakeup>
    1d7f:	c9                   	leave  
    1d80:	c3                   	ret    

00001d81 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1d81:	55                   	push   %ebp
    1d82:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1d84:	8b 45 08             	mov    0x8(%ebp),%eax
    1d87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1d8d:	8b 45 08             	mov    0x8(%ebp),%eax
    1d90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1d97:	8b 45 08             	mov    0x8(%ebp),%eax
    1d9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1da1:	5d                   	pop    %ebp
    1da2:	c3                   	ret    

00001da3 <add_q>:

void add_q(struct queue *q, int v){
    1da3:	55                   	push   %ebp
    1da4:	89 e5                	mov    %esp,%ebp
    1da6:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1da9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1db0:	e8 a4 fc ff ff       	call   1a59 <malloc>
    1db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
    1dc8:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1dca:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcd:	8b 40 04             	mov    0x4(%eax),%eax
    1dd0:	85 c0                	test   %eax,%eax
    1dd2:	75 0b                	jne    1ddf <add_q+0x3c>
        q->head = n;
    1dd4:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1dda:	89 50 04             	mov    %edx,0x4(%eax)
    1ddd:	eb 0c                	jmp    1deb <add_q+0x48>
    }else{
        q->tail->next = n;
    1ddf:	8b 45 08             	mov    0x8(%ebp),%eax
    1de2:	8b 40 08             	mov    0x8(%eax),%eax
    1de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1de8:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1deb:	8b 45 08             	mov    0x8(%ebp),%eax
    1dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1df1:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1df4:	8b 45 08             	mov    0x8(%ebp),%eax
    1df7:	8b 00                	mov    (%eax),%eax
    1df9:	8d 50 01             	lea    0x1(%eax),%edx
    1dfc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dff:	89 10                	mov    %edx,(%eax)
}
    1e01:	c9                   	leave  
    1e02:	c3                   	ret    

00001e03 <empty_q>:

int empty_q(struct queue *q){
    1e03:	55                   	push   %ebp
    1e04:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1e06:	8b 45 08             	mov    0x8(%ebp),%eax
    1e09:	8b 00                	mov    (%eax),%eax
    1e0b:	85 c0                	test   %eax,%eax
    1e0d:	75 07                	jne    1e16 <empty_q+0x13>
        return 1;
    1e0f:	b8 01 00 00 00       	mov    $0x1,%eax
    1e14:	eb 05                	jmp    1e1b <empty_q+0x18>
    else
        return 0;
    1e16:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1e1b:	5d                   	pop    %ebp
    1e1c:	c3                   	ret    

00001e1d <pop_q>:
int pop_q(struct queue *q){
    1e1d:	55                   	push   %ebp
    1e1e:	89 e5                	mov    %esp,%ebp
    1e20:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1e23:	8b 45 08             	mov    0x8(%ebp),%eax
    1e26:	89 04 24             	mov    %eax,(%esp)
    1e29:	e8 d5 ff ff ff       	call   1e03 <empty_q>
    1e2e:	85 c0                	test   %eax,%eax
    1e30:	75 5d                	jne    1e8f <pop_q+0x72>
       val = q->head->value; 
    1e32:	8b 45 08             	mov    0x8(%ebp),%eax
    1e35:	8b 40 04             	mov    0x4(%eax),%eax
    1e38:	8b 00                	mov    (%eax),%eax
    1e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1e3d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e40:	8b 40 04             	mov    0x4(%eax),%eax
    1e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1e46:	8b 45 08             	mov    0x8(%ebp),%eax
    1e49:	8b 40 04             	mov    0x4(%eax),%eax
    1e4c:	8b 50 04             	mov    0x4(%eax),%edx
    1e4f:	8b 45 08             	mov    0x8(%ebp),%eax
    1e52:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e58:	89 04 24             	mov    %eax,(%esp)
    1e5b:	e8 c0 fa ff ff       	call   1920 <free>
       q->size--;
    1e60:	8b 45 08             	mov    0x8(%ebp),%eax
    1e63:	8b 00                	mov    (%eax),%eax
    1e65:	8d 50 ff             	lea    -0x1(%eax),%edx
    1e68:	8b 45 08             	mov    0x8(%ebp),%eax
    1e6b:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1e6d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e70:	8b 00                	mov    (%eax),%eax
    1e72:	85 c0                	test   %eax,%eax
    1e74:	75 14                	jne    1e8a <pop_q+0x6d>
            q->head = 0;
    1e76:	8b 45 08             	mov    0x8(%ebp),%eax
    1e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1e80:	8b 45 08             	mov    0x8(%ebp),%eax
    1e83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e8d:	eb 05                	jmp    1e94 <pop_q+0x77>
    }
    return -1;
    1e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1e94:	c9                   	leave  
    1e95:	c3                   	ret    
