
_test:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

int n = 1;

void test_func(void * arg_ptr);

int main(int argc, char *argv[]){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp

   printf(1,"thread_create test begin\n\n");
    1009:	c7 44 24 04 20 1c 00 	movl   $0x1c20,0x4(%esp)
    1010:	00 
    1011:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1018:	e8 da 04 00 00       	call   14f7 <printf>

   printf(1,"before thread_create n = %d\n",n);
    101d:	a1 a8 20 00 00       	mov    0x20a8,%eax
    1022:	89 44 24 08          	mov    %eax,0x8(%esp)
    1026:	c7 44 24 04 3b 1c 00 	movl   $0x1c3b,0x4(%esp)
    102d:	00 
    102e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1035:	e8 bd 04 00 00       	call   14f7 <printf>

   int arg = 10;
    103a:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
    1041:	00 
   void *tid = thread_create(test_func, (void *)&arg);
    1042:	8d 44 24 18          	lea    0x18(%esp),%eax
    1046:	89 44 24 04          	mov    %eax,0x4(%esp)
    104a:	c7 04 24 a7 10 00 00 	movl   $0x10a7,(%esp)
    1051:	e8 d0 08 00 00       	call   1926 <thread_create>
    1056:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
    105a:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    105f:	75 19                	jne    107a <main+0x7a>
       printf(1,"wrong happen");
    1061:	c7 44 24 04 58 1c 00 	movl   $0x1c58,0x4(%esp)
    1068:	00 
    1069:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1070:	e8 82 04 00 00       	call   14f7 <printf>
       exit();
    1075:	e8 cd 02 00 00       	call   1347 <exit>
   } 
   while(wait()>= 0)
    107a:	eb 1d                	jmp    1099 <main+0x99>
   printf(1,"\nback to parent n = %d\n",n);
    107c:	a1 a8 20 00 00       	mov    0x20a8,%eax
    1081:	89 44 24 08          	mov    %eax,0x8(%esp)
    1085:	c7 44 24 04 65 1c 00 	movl   $0x1c65,0x4(%esp)
    108c:	00 
    108d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1094:	e8 5e 04 00 00       	call   14f7 <printf>
   void *tid = thread_create(test_func, (void *)&arg);
   if(tid <= 0){
       printf(1,"wrong happen");
       exit();
   } 
   while(wait()>= 0)
    1099:	e8 b1 02 00 00       	call   134f <wait>
    109e:	85 c0                	test   %eax,%eax
    10a0:	79 da                	jns    107c <main+0x7c>
   printf(1,"\nback to parent n = %d\n",n);
   
   exit();
    10a2:	e8 a0 02 00 00       	call   1347 <exit>

000010a7 <test_func>:
}

//void test_func(void *arg_ptr){
void test_func(void *arg_ptr){
    10a7:	55                   	push   %ebp
    10a8:	89 e5                	mov    %esp,%ebp
    10aa:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
    10b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = *num; 
    10b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b6:	8b 00                	mov    (%eax),%eax
    10b8:	a3 a8 20 00 00       	mov    %eax,0x20a8
    printf(1,"\n n is updated as %d\n",*num);
    10bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c0:	8b 00                	mov    (%eax),%eax
    10c2:	89 44 24 08          	mov    %eax,0x8(%esp)
    10c6:	c7 44 24 04 7d 1c 00 	movl   $0x1c7d,0x4(%esp)
    10cd:	00 
    10ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d5:	e8 1d 04 00 00       	call   14f7 <printf>
    texit();
    10da:	e8 10 03 00 00       	call   13ef <texit>

000010df <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10df:	55                   	push   %ebp
    10e0:	89 e5                	mov    %esp,%ebp
    10e2:	57                   	push   %edi
    10e3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10e7:	8b 55 10             	mov    0x10(%ebp),%edx
    10ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ed:	89 cb                	mov    %ecx,%ebx
    10ef:	89 df                	mov    %ebx,%edi
    10f1:	89 d1                	mov    %edx,%ecx
    10f3:	fc                   	cld    
    10f4:	f3 aa                	rep stos %al,%es:(%edi)
    10f6:	89 ca                	mov    %ecx,%edx
    10f8:	89 fb                	mov    %edi,%ebx
    10fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10fd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1100:	5b                   	pop    %ebx
    1101:	5f                   	pop    %edi
    1102:	5d                   	pop    %ebp
    1103:	c3                   	ret    

00001104 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1104:	55                   	push   %ebp
    1105:	89 e5                	mov    %esp,%ebp
    1107:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    110a:	8b 45 08             	mov    0x8(%ebp),%eax
    110d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1110:	90                   	nop
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	8d 50 01             	lea    0x1(%eax),%edx
    1117:	89 55 08             	mov    %edx,0x8(%ebp)
    111a:	8b 55 0c             	mov    0xc(%ebp),%edx
    111d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1120:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1123:	0f b6 12             	movzbl (%edx),%edx
    1126:	88 10                	mov    %dl,(%eax)
    1128:	0f b6 00             	movzbl (%eax),%eax
    112b:	84 c0                	test   %al,%al
    112d:	75 e2                	jne    1111 <strcpy+0xd>
    ;
  return os;
    112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1132:	c9                   	leave  
    1133:	c3                   	ret    

00001134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1137:	eb 08                	jmp    1141 <strcmp+0xd>
    p++, q++;
    1139:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    113d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
    1144:	0f b6 00             	movzbl (%eax),%eax
    1147:	84 c0                	test   %al,%al
    1149:	74 10                	je     115b <strcmp+0x27>
    114b:	8b 45 08             	mov    0x8(%ebp),%eax
    114e:	0f b6 10             	movzbl (%eax),%edx
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	0f b6 00             	movzbl (%eax),%eax
    1157:	38 c2                	cmp    %al,%dl
    1159:	74 de                	je     1139 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    115b:	8b 45 08             	mov    0x8(%ebp),%eax
    115e:	0f b6 00             	movzbl (%eax),%eax
    1161:	0f b6 d0             	movzbl %al,%edx
    1164:	8b 45 0c             	mov    0xc(%ebp),%eax
    1167:	0f b6 00             	movzbl (%eax),%eax
    116a:	0f b6 c0             	movzbl %al,%eax
    116d:	29 c2                	sub    %eax,%edx
    116f:	89 d0                	mov    %edx,%eax
}
    1171:	5d                   	pop    %ebp
    1172:	c3                   	ret    

00001173 <strlen>:

uint
strlen(char *s)
{
    1173:	55                   	push   %ebp
    1174:	89 e5                	mov    %esp,%ebp
    1176:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1180:	eb 04                	jmp    1186 <strlen+0x13>
    1182:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1186:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	01 d0                	add    %edx,%eax
    118e:	0f b6 00             	movzbl (%eax),%eax
    1191:	84 c0                	test   %al,%al
    1193:	75 ed                	jne    1182 <strlen+0xf>
    ;
  return n;
    1195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1198:	c9                   	leave  
    1199:	c3                   	ret    

0000119a <memset>:

void*
memset(void *dst, int c, uint n)
{
    119a:	55                   	push   %ebp
    119b:	89 e5                	mov    %esp,%ebp
    119d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11a0:	8b 45 10             	mov    0x10(%ebp),%eax
    11a3:	89 44 24 08          	mov    %eax,0x8(%esp)
    11a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11aa:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ae:	8b 45 08             	mov    0x8(%ebp),%eax
    11b1:	89 04 24             	mov    %eax,(%esp)
    11b4:	e8 26 ff ff ff       	call   10df <stosb>
  return dst;
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11bc:	c9                   	leave  
    11bd:	c3                   	ret    

000011be <strchr>:

char*
strchr(const char *s, char c)
{
    11be:	55                   	push   %ebp
    11bf:	89 e5                	mov    %esp,%ebp
    11c1:	83 ec 04             	sub    $0x4,%esp
    11c4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11ca:	eb 14                	jmp    11e0 <strchr+0x22>
    if(*s == c)
    11cc:	8b 45 08             	mov    0x8(%ebp),%eax
    11cf:	0f b6 00             	movzbl (%eax),%eax
    11d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11d5:	75 05                	jne    11dc <strchr+0x1e>
      return (char*)s;
    11d7:	8b 45 08             	mov    0x8(%ebp),%eax
    11da:	eb 13                	jmp    11ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11e0:	8b 45 08             	mov    0x8(%ebp),%eax
    11e3:	0f b6 00             	movzbl (%eax),%eax
    11e6:	84 c0                	test   %al,%al
    11e8:	75 e2                	jne    11cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11ef:	c9                   	leave  
    11f0:	c3                   	ret    

000011f1 <gets>:

char*
gets(char *buf, int max)
{
    11f1:	55                   	push   %ebp
    11f2:	89 e5                	mov    %esp,%ebp
    11f4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11fe:	eb 4c                	jmp    124c <gets+0x5b>
    cc = read(0, &c, 1);
    1200:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1207:	00 
    1208:	8d 45 ef             	lea    -0x11(%ebp),%eax
    120b:	89 44 24 04          	mov    %eax,0x4(%esp)
    120f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1216:	e8 44 01 00 00       	call   135f <read>
    121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    121e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1222:	7f 02                	jg     1226 <gets+0x35>
      break;
    1224:	eb 31                	jmp    1257 <gets+0x66>
    buf[i++] = c;
    1226:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1229:	8d 50 01             	lea    0x1(%eax),%edx
    122c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    122f:	89 c2                	mov    %eax,%edx
    1231:	8b 45 08             	mov    0x8(%ebp),%eax
    1234:	01 c2                	add    %eax,%edx
    1236:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    123a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    123c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1240:	3c 0a                	cmp    $0xa,%al
    1242:	74 13                	je     1257 <gets+0x66>
    1244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1248:	3c 0d                	cmp    $0xd,%al
    124a:	74 0b                	je     1257 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124f:	83 c0 01             	add    $0x1,%eax
    1252:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1255:	7c a9                	jl     1200 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1257:	8b 55 f4             	mov    -0xc(%ebp),%edx
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	01 d0                	add    %edx,%eax
    125f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1262:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1265:	c9                   	leave  
    1266:	c3                   	ret    

00001267 <stat>:

int
stat(char *n, struct stat *st)
{
    1267:	55                   	push   %ebp
    1268:	89 e5                	mov    %esp,%ebp
    126a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    126d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1274:	00 
    1275:	8b 45 08             	mov    0x8(%ebp),%eax
    1278:	89 04 24             	mov    %eax,(%esp)
    127b:	e8 07 01 00 00       	call   1387 <open>
    1280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1287:	79 07                	jns    1290 <stat+0x29>
    return -1;
    1289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    128e:	eb 23                	jmp    12b3 <stat+0x4c>
  r = fstat(fd, st);
    1290:	8b 45 0c             	mov    0xc(%ebp),%eax
    1293:	89 44 24 04          	mov    %eax,0x4(%esp)
    1297:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129a:	89 04 24             	mov    %eax,(%esp)
    129d:	e8 fd 00 00 00       	call   139f <fstat>
    12a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a8:	89 04 24             	mov    %eax,(%esp)
    12ab:	e8 bf 00 00 00       	call   136f <close>
  return r;
    12b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12b3:	c9                   	leave  
    12b4:	c3                   	ret    

000012b5 <atoi>:

int
atoi(const char *s)
{
    12b5:	55                   	push   %ebp
    12b6:	89 e5                	mov    %esp,%ebp
    12b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12c2:	eb 25                	jmp    12e9 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12c7:	89 d0                	mov    %edx,%eax
    12c9:	c1 e0 02             	shl    $0x2,%eax
    12cc:	01 d0                	add    %edx,%eax
    12ce:	01 c0                	add    %eax,%eax
    12d0:	89 c1                	mov    %eax,%ecx
    12d2:	8b 45 08             	mov    0x8(%ebp),%eax
    12d5:	8d 50 01             	lea    0x1(%eax),%edx
    12d8:	89 55 08             	mov    %edx,0x8(%ebp)
    12db:	0f b6 00             	movzbl (%eax),%eax
    12de:	0f be c0             	movsbl %al,%eax
    12e1:	01 c8                	add    %ecx,%eax
    12e3:	83 e8 30             	sub    $0x30,%eax
    12e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12e9:	8b 45 08             	mov    0x8(%ebp),%eax
    12ec:	0f b6 00             	movzbl (%eax),%eax
    12ef:	3c 2f                	cmp    $0x2f,%al
    12f1:	7e 0a                	jle    12fd <atoi+0x48>
    12f3:	8b 45 08             	mov    0x8(%ebp),%eax
    12f6:	0f b6 00             	movzbl (%eax),%eax
    12f9:	3c 39                	cmp    $0x39,%al
    12fb:	7e c7                	jle    12c4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1300:	c9                   	leave  
    1301:	c3                   	ret    

00001302 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1302:	55                   	push   %ebp
    1303:	89 e5                	mov    %esp,%ebp
    1305:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    130e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1311:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1314:	eb 17                	jmp    132d <memmove+0x2b>
    *dst++ = *src++;
    1316:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1319:	8d 50 01             	lea    0x1(%eax),%edx
    131c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    131f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1322:	8d 4a 01             	lea    0x1(%edx),%ecx
    1325:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1328:	0f b6 12             	movzbl (%edx),%edx
    132b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    132d:	8b 45 10             	mov    0x10(%ebp),%eax
    1330:	8d 50 ff             	lea    -0x1(%eax),%edx
    1333:	89 55 10             	mov    %edx,0x10(%ebp)
    1336:	85 c0                	test   %eax,%eax
    1338:	7f dc                	jg     1316 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    133a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    133d:	c9                   	leave  
    133e:	c3                   	ret    

0000133f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    133f:	b8 01 00 00 00       	mov    $0x1,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <exit>:
SYSCALL(exit)
    1347:	b8 02 00 00 00       	mov    $0x2,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <wait>:
SYSCALL(wait)
    134f:	b8 03 00 00 00       	mov    $0x3,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <pipe>:
SYSCALL(pipe)
    1357:	b8 04 00 00 00       	mov    $0x4,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <read>:
SYSCALL(read)
    135f:	b8 05 00 00 00       	mov    $0x5,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <write>:
SYSCALL(write)
    1367:	b8 10 00 00 00       	mov    $0x10,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <close>:
SYSCALL(close)
    136f:	b8 15 00 00 00       	mov    $0x15,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <kill>:
SYSCALL(kill)
    1377:	b8 06 00 00 00       	mov    $0x6,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <exec>:
SYSCALL(exec)
    137f:	b8 07 00 00 00       	mov    $0x7,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <open>:
SYSCALL(open)
    1387:	b8 0f 00 00 00       	mov    $0xf,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <mknod>:
SYSCALL(mknod)
    138f:	b8 11 00 00 00       	mov    $0x11,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <unlink>:
SYSCALL(unlink)
    1397:	b8 12 00 00 00       	mov    $0x12,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <fstat>:
SYSCALL(fstat)
    139f:	b8 08 00 00 00       	mov    $0x8,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <link>:
SYSCALL(link)
    13a7:	b8 13 00 00 00       	mov    $0x13,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <mkdir>:
SYSCALL(mkdir)
    13af:	b8 14 00 00 00       	mov    $0x14,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <chdir>:
SYSCALL(chdir)
    13b7:	b8 09 00 00 00       	mov    $0x9,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <dup>:
SYSCALL(dup)
    13bf:	b8 0a 00 00 00       	mov    $0xa,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <getpid>:
SYSCALL(getpid)
    13c7:	b8 0b 00 00 00       	mov    $0xb,%eax
    13cc:	cd 40                	int    $0x40
    13ce:	c3                   	ret    

000013cf <sbrk>:
SYSCALL(sbrk)
    13cf:	b8 0c 00 00 00       	mov    $0xc,%eax
    13d4:	cd 40                	int    $0x40
    13d6:	c3                   	ret    

000013d7 <sleep>:
SYSCALL(sleep)
    13d7:	b8 0d 00 00 00       	mov    $0xd,%eax
    13dc:	cd 40                	int    $0x40
    13de:	c3                   	ret    

000013df <uptime>:
SYSCALL(uptime)
    13df:	b8 0e 00 00 00       	mov    $0xe,%eax
    13e4:	cd 40                	int    $0x40
    13e6:	c3                   	ret    

000013e7 <clone>:
SYSCALL(clone)
    13e7:	b8 16 00 00 00       	mov    $0x16,%eax
    13ec:	cd 40                	int    $0x40
    13ee:	c3                   	ret    

000013ef <texit>:
SYSCALL(texit)
    13ef:	b8 17 00 00 00       	mov    $0x17,%eax
    13f4:	cd 40                	int    $0x40
    13f6:	c3                   	ret    

000013f7 <tsleep>:
SYSCALL(tsleep)
    13f7:	b8 18 00 00 00       	mov    $0x18,%eax
    13fc:	cd 40                	int    $0x40
    13fe:	c3                   	ret    

000013ff <twakeup>:
SYSCALL(twakeup)
    13ff:	b8 19 00 00 00       	mov    $0x19,%eax
    1404:	cd 40                	int    $0x40
    1406:	c3                   	ret    

00001407 <thread_yield>:
SYSCALL(thread_yield)
    1407:	b8 1a 00 00 00       	mov    $0x1a,%eax
    140c:	cd 40                	int    $0x40
    140e:	c3                   	ret    

0000140f <thread_yield3>:
    140f:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1414:	cd 40                	int    $0x40
    1416:	c3                   	ret    

00001417 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1417:	55                   	push   %ebp
    1418:	89 e5                	mov    %esp,%ebp
    141a:	83 ec 18             	sub    $0x18,%esp
    141d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1420:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1423:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    142a:	00 
    142b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    142e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1432:	8b 45 08             	mov    0x8(%ebp),%eax
    1435:	89 04 24             	mov    %eax,(%esp)
    1438:	e8 2a ff ff ff       	call   1367 <write>
}
    143d:	c9                   	leave  
    143e:	c3                   	ret    

0000143f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    143f:	55                   	push   %ebp
    1440:	89 e5                	mov    %esp,%ebp
    1442:	56                   	push   %esi
    1443:	53                   	push   %ebx
    1444:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1447:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    144e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1452:	74 17                	je     146b <printint+0x2c>
    1454:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1458:	79 11                	jns    146b <printint+0x2c>
    neg = 1;
    145a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1461:	8b 45 0c             	mov    0xc(%ebp),%eax
    1464:	f7 d8                	neg    %eax
    1466:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1469:	eb 06                	jmp    1471 <printint+0x32>
  } else {
    x = xx;
    146b:	8b 45 0c             	mov    0xc(%ebp),%eax
    146e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1478:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    147b:	8d 41 01             	lea    0x1(%ecx),%eax
    147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1481:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1484:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1487:	ba 00 00 00 00       	mov    $0x0,%edx
    148c:	f7 f3                	div    %ebx
    148e:	89 d0                	mov    %edx,%eax
    1490:	0f b6 80 ac 20 00 00 	movzbl 0x20ac(%eax),%eax
    1497:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    149b:	8b 75 10             	mov    0x10(%ebp),%esi
    149e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14a1:	ba 00 00 00 00       	mov    $0x0,%edx
    14a6:	f7 f6                	div    %esi
    14a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14af:	75 c7                	jne    1478 <printint+0x39>
  if(neg)
    14b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14b5:	74 10                	je     14c7 <printint+0x88>
    buf[i++] = '-';
    14b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ba:	8d 50 01             	lea    0x1(%eax),%edx
    14bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14c5:	eb 1f                	jmp    14e6 <printint+0xa7>
    14c7:	eb 1d                	jmp    14e6 <printint+0xa7>
    putc(fd, buf[i]);
    14c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cf:	01 d0                	add    %edx,%eax
    14d1:	0f b6 00             	movzbl (%eax),%eax
    14d4:	0f be c0             	movsbl %al,%eax
    14d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14db:	8b 45 08             	mov    0x8(%ebp),%eax
    14de:	89 04 24             	mov    %eax,(%esp)
    14e1:	e8 31 ff ff ff       	call   1417 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    14ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14ee:	79 d9                	jns    14c9 <printint+0x8a>
    putc(fd, buf[i]);
}
    14f0:	83 c4 30             	add    $0x30,%esp
    14f3:	5b                   	pop    %ebx
    14f4:	5e                   	pop    %esi
    14f5:	5d                   	pop    %ebp
    14f6:	c3                   	ret    

000014f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14f7:	55                   	push   %ebp
    14f8:	89 e5                	mov    %esp,%ebp
    14fa:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1504:	8d 45 0c             	lea    0xc(%ebp),%eax
    1507:	83 c0 04             	add    $0x4,%eax
    150a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    150d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1514:	e9 7c 01 00 00       	jmp    1695 <printf+0x19e>
    c = fmt[i] & 0xff;
    1519:	8b 55 0c             	mov    0xc(%ebp),%edx
    151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    151f:	01 d0                	add    %edx,%eax
    1521:	0f b6 00             	movzbl (%eax),%eax
    1524:	0f be c0             	movsbl %al,%eax
    1527:	25 ff 00 00 00       	and    $0xff,%eax
    152c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    152f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1533:	75 2c                	jne    1561 <printf+0x6a>
      if(c == '%'){
    1535:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1539:	75 0c                	jne    1547 <printf+0x50>
        state = '%';
    153b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1542:	e9 4a 01 00 00       	jmp    1691 <printf+0x19a>
      } else {
        putc(fd, c);
    1547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    154a:	0f be c0             	movsbl %al,%eax
    154d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1551:	8b 45 08             	mov    0x8(%ebp),%eax
    1554:	89 04 24             	mov    %eax,(%esp)
    1557:	e8 bb fe ff ff       	call   1417 <putc>
    155c:	e9 30 01 00 00       	jmp    1691 <printf+0x19a>
      }
    } else if(state == '%'){
    1561:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1565:	0f 85 26 01 00 00    	jne    1691 <printf+0x19a>
      if(c == 'd'){
    156b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    156f:	75 2d                	jne    159e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1571:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1574:	8b 00                	mov    (%eax),%eax
    1576:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    157d:	00 
    157e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1585:	00 
    1586:	89 44 24 04          	mov    %eax,0x4(%esp)
    158a:	8b 45 08             	mov    0x8(%ebp),%eax
    158d:	89 04 24             	mov    %eax,(%esp)
    1590:	e8 aa fe ff ff       	call   143f <printint>
        ap++;
    1595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1599:	e9 ec 00 00 00       	jmp    168a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    159e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15a2:	74 06                	je     15aa <printf+0xb3>
    15a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15a8:	75 2d                	jne    15d7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15ad:	8b 00                	mov    (%eax),%eax
    15af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15b6:	00 
    15b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15be:	00 
    15bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c3:	8b 45 08             	mov    0x8(%ebp),%eax
    15c6:	89 04 24             	mov    %eax,(%esp)
    15c9:	e8 71 fe ff ff       	call   143f <printint>
        ap++;
    15ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d2:	e9 b3 00 00 00       	jmp    168a <printf+0x193>
      } else if(c == 's'){
    15d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15db:	75 45                	jne    1622 <printf+0x12b>
        s = (char*)*ap;
    15dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e0:	8b 00                	mov    (%eax),%eax
    15e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15ed:	75 09                	jne    15f8 <printf+0x101>
          s = "(null)";
    15ef:	c7 45 f4 93 1c 00 00 	movl   $0x1c93,-0xc(%ebp)
        while(*s != 0){
    15f6:	eb 1e                	jmp    1616 <printf+0x11f>
    15f8:	eb 1c                	jmp    1616 <printf+0x11f>
          putc(fd, *s);
    15fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fd:	0f b6 00             	movzbl (%eax),%eax
    1600:	0f be c0             	movsbl %al,%eax
    1603:	89 44 24 04          	mov    %eax,0x4(%esp)
    1607:	8b 45 08             	mov    0x8(%ebp),%eax
    160a:	89 04 24             	mov    %eax,(%esp)
    160d:	e8 05 fe ff ff       	call   1417 <putc>
          s++;
    1612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1616:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1619:	0f b6 00             	movzbl (%eax),%eax
    161c:	84 c0                	test   %al,%al
    161e:	75 da                	jne    15fa <printf+0x103>
    1620:	eb 68                	jmp    168a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1622:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1626:	75 1d                	jne    1645 <printf+0x14e>
        putc(fd, *ap);
    1628:	8b 45 e8             	mov    -0x18(%ebp),%eax
    162b:	8b 00                	mov    (%eax),%eax
    162d:	0f be c0             	movsbl %al,%eax
    1630:	89 44 24 04          	mov    %eax,0x4(%esp)
    1634:	8b 45 08             	mov    0x8(%ebp),%eax
    1637:	89 04 24             	mov    %eax,(%esp)
    163a:	e8 d8 fd ff ff       	call   1417 <putc>
        ap++;
    163f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1643:	eb 45                	jmp    168a <printf+0x193>
      } else if(c == '%'){
    1645:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1649:	75 17                	jne    1662 <printf+0x16b>
        putc(fd, c);
    164b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    164e:	0f be c0             	movsbl %al,%eax
    1651:	89 44 24 04          	mov    %eax,0x4(%esp)
    1655:	8b 45 08             	mov    0x8(%ebp),%eax
    1658:	89 04 24             	mov    %eax,(%esp)
    165b:	e8 b7 fd ff ff       	call   1417 <putc>
    1660:	eb 28                	jmp    168a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1662:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1669:	00 
    166a:	8b 45 08             	mov    0x8(%ebp),%eax
    166d:	89 04 24             	mov    %eax,(%esp)
    1670:	e8 a2 fd ff ff       	call   1417 <putc>
        putc(fd, c);
    1675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1678:	0f be c0             	movsbl %al,%eax
    167b:	89 44 24 04          	mov    %eax,0x4(%esp)
    167f:	8b 45 08             	mov    0x8(%ebp),%eax
    1682:	89 04 24             	mov    %eax,(%esp)
    1685:	e8 8d fd ff ff       	call   1417 <putc>
      }
      state = 0;
    168a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1691:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1695:	8b 55 0c             	mov    0xc(%ebp),%edx
    1698:	8b 45 f0             	mov    -0x10(%ebp),%eax
    169b:	01 d0                	add    %edx,%eax
    169d:	0f b6 00             	movzbl (%eax),%eax
    16a0:	84 c0                	test   %al,%al
    16a2:	0f 85 71 fe ff ff    	jne    1519 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16a8:	c9                   	leave  
    16a9:	c3                   	ret    

000016aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16aa:	55                   	push   %ebp
    16ab:	89 e5                	mov    %esp,%ebp
    16ad:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16b0:	8b 45 08             	mov    0x8(%ebp),%eax
    16b3:	83 e8 08             	sub    $0x8,%eax
    16b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16b9:	a1 cc 20 00 00       	mov    0x20cc,%eax
    16be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16c1:	eb 24                	jmp    16e7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c6:	8b 00                	mov    (%eax),%eax
    16c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16cb:	77 12                	ja     16df <free+0x35>
    16cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16d3:	77 24                	ja     16f9 <free+0x4f>
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8b 00                	mov    (%eax),%eax
    16da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16dd:	77 1a                	ja     16f9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e2:	8b 00                	mov    (%eax),%eax
    16e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16ed:	76 d4                	jbe    16c3 <free+0x19>
    16ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f2:	8b 00                	mov    (%eax),%eax
    16f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f7:	76 ca                	jbe    16c3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fc:	8b 40 04             	mov    0x4(%eax),%eax
    16ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1706:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1709:	01 c2                	add    %eax,%edx
    170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170e:	8b 00                	mov    (%eax),%eax
    1710:	39 c2                	cmp    %eax,%edx
    1712:	75 24                	jne    1738 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1714:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1717:	8b 50 04             	mov    0x4(%eax),%edx
    171a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171d:	8b 00                	mov    (%eax),%eax
    171f:	8b 40 04             	mov    0x4(%eax),%eax
    1722:	01 c2                	add    %eax,%edx
    1724:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1727:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172d:	8b 00                	mov    (%eax),%eax
    172f:	8b 10                	mov    (%eax),%edx
    1731:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1734:	89 10                	mov    %edx,(%eax)
    1736:	eb 0a                	jmp    1742 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1738:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173b:	8b 10                	mov    (%eax),%edx
    173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1740:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1742:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1745:	8b 40 04             	mov    0x4(%eax),%eax
    1748:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    174f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1752:	01 d0                	add    %edx,%eax
    1754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1757:	75 20                	jne    1779 <free+0xcf>
    p->s.size += bp->s.size;
    1759:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175c:	8b 50 04             	mov    0x4(%eax),%edx
    175f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1762:	8b 40 04             	mov    0x4(%eax),%eax
    1765:	01 c2                	add    %eax,%edx
    1767:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    176d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1770:	8b 10                	mov    (%eax),%edx
    1772:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1775:	89 10                	mov    %edx,(%eax)
    1777:	eb 08                	jmp    1781 <free+0xd7>
  } else
    p->s.ptr = bp;
    1779:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    177f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1781:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1784:	a3 cc 20 00 00       	mov    %eax,0x20cc
}
    1789:	c9                   	leave  
    178a:	c3                   	ret    

0000178b <morecore>:

static Header*
morecore(uint nu)
{
    178b:	55                   	push   %ebp
    178c:	89 e5                	mov    %esp,%ebp
    178e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1791:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1798:	77 07                	ja     17a1 <morecore+0x16>
    nu = 4096;
    179a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17a1:	8b 45 08             	mov    0x8(%ebp),%eax
    17a4:	c1 e0 03             	shl    $0x3,%eax
    17a7:	89 04 24             	mov    %eax,(%esp)
    17aa:	e8 20 fc ff ff       	call   13cf <sbrk>
    17af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17b6:	75 07                	jne    17bf <morecore+0x34>
    return 0;
    17b8:	b8 00 00 00 00       	mov    $0x0,%eax
    17bd:	eb 22                	jmp    17e1 <morecore+0x56>
  hp = (Header*)p;
    17bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c8:	8b 55 08             	mov    0x8(%ebp),%edx
    17cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d1:	83 c0 08             	add    $0x8,%eax
    17d4:	89 04 24             	mov    %eax,(%esp)
    17d7:	e8 ce fe ff ff       	call   16aa <free>
  return freep;
    17dc:	a1 cc 20 00 00       	mov    0x20cc,%eax
}
    17e1:	c9                   	leave  
    17e2:	c3                   	ret    

000017e3 <malloc>:

void*
malloc(uint nbytes)
{
    17e3:	55                   	push   %ebp
    17e4:	89 e5                	mov    %esp,%ebp
    17e6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17e9:	8b 45 08             	mov    0x8(%ebp),%eax
    17ec:	83 c0 07             	add    $0x7,%eax
    17ef:	c1 e8 03             	shr    $0x3,%eax
    17f2:	83 c0 01             	add    $0x1,%eax
    17f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17f8:	a1 cc 20 00 00       	mov    0x20cc,%eax
    17fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1804:	75 23                	jne    1829 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1806:	c7 45 f0 c4 20 00 00 	movl   $0x20c4,-0x10(%ebp)
    180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1810:	a3 cc 20 00 00       	mov    %eax,0x20cc
    1815:	a1 cc 20 00 00       	mov    0x20cc,%eax
    181a:	a3 c4 20 00 00       	mov    %eax,0x20c4
    base.s.size = 0;
    181f:	c7 05 c8 20 00 00 00 	movl   $0x0,0x20c8
    1826:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1829:	8b 45 f0             	mov    -0x10(%ebp),%eax
    182c:	8b 00                	mov    (%eax),%eax
    182e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1831:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1834:	8b 40 04             	mov    0x4(%eax),%eax
    1837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    183a:	72 4d                	jb     1889 <malloc+0xa6>
      if(p->s.size == nunits)
    183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183f:	8b 40 04             	mov    0x4(%eax),%eax
    1842:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1845:	75 0c                	jne    1853 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1847:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184a:	8b 10                	mov    (%eax),%edx
    184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184f:	89 10                	mov    %edx,(%eax)
    1851:	eb 26                	jmp    1879 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1853:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1856:	8b 40 04             	mov    0x4(%eax),%eax
    1859:	2b 45 ec             	sub    -0x14(%ebp),%eax
    185c:	89 c2                	mov    %eax,%edx
    185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1861:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1864:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1867:	8b 40 04             	mov    0x4(%eax),%eax
    186a:	c1 e0 03             	shl    $0x3,%eax
    186d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1870:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1873:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1876:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1879:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187c:	a3 cc 20 00 00       	mov    %eax,0x20cc
      return (void*)(p + 1);
    1881:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1884:	83 c0 08             	add    $0x8,%eax
    1887:	eb 38                	jmp    18c1 <malloc+0xde>
    }
    if(p == freep)
    1889:	a1 cc 20 00 00       	mov    0x20cc,%eax
    188e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1891:	75 1b                	jne    18ae <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1893:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1896:	89 04 24             	mov    %eax,(%esp)
    1899:	e8 ed fe ff ff       	call   178b <morecore>
    189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18a5:	75 07                	jne    18ae <malloc+0xcb>
        return 0;
    18a7:	b8 00 00 00 00       	mov    $0x0,%eax
    18ac:	eb 13                	jmp    18c1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b7:	8b 00                	mov    (%eax),%eax
    18b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18bc:	e9 70 ff ff ff       	jmp    1831 <malloc+0x4e>
}
    18c1:	c9                   	leave  
    18c2:	c3                   	ret    

000018c3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18c3:	55                   	push   %ebp
    18c4:	89 e5                	mov    %esp,%ebp
    18c6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    18c9:	8b 55 08             	mov    0x8(%ebp),%edx
    18cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    18cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
    18d2:	f0 87 02             	lock xchg %eax,(%edx)
    18d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    18d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    18db:	c9                   	leave  
    18dc:	c3                   	ret    

000018dd <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    18dd:	55                   	push   %ebp
    18de:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    18e0:	8b 45 08             	mov    0x8(%ebp),%eax
    18e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    18e9:	5d                   	pop    %ebp
    18ea:	c3                   	ret    

000018eb <lock_acquire>:
void lock_acquire(lock_t *lock){
    18eb:	55                   	push   %ebp
    18ec:	89 e5                	mov    %esp,%ebp
    18ee:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    18f1:	90                   	nop
    18f2:	8b 45 08             	mov    0x8(%ebp),%eax
    18f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18fc:	00 
    18fd:	89 04 24             	mov    %eax,(%esp)
    1900:	e8 be ff ff ff       	call   18c3 <xchg>
    1905:	85 c0                	test   %eax,%eax
    1907:	75 e9                	jne    18f2 <lock_acquire+0x7>
}
    1909:	c9                   	leave  
    190a:	c3                   	ret    

0000190b <lock_release>:
void lock_release(lock_t *lock){
    190b:	55                   	push   %ebp
    190c:	89 e5                	mov    %esp,%ebp
    190e:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1911:	8b 45 08             	mov    0x8(%ebp),%eax
    1914:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    191b:	00 
    191c:	89 04 24             	mov    %eax,(%esp)
    191f:	e8 9f ff ff ff       	call   18c3 <xchg>
}
    1924:	c9                   	leave  
    1925:	c3                   	ret    

00001926 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1926:	55                   	push   %ebp
    1927:	89 e5                	mov    %esp,%ebp
    1929:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    192c:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1933:	e8 ab fe ff ff       	call   17e3 <malloc>
    1938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1941:	0f b6 05 d0 20 00 00 	movzbl 0x20d0,%eax
    1948:	84 c0                	test   %al,%al
    194a:	75 1c                	jne    1968 <thread_create+0x42>
        init_q(thQ2);
    194c:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1951:	89 04 24             	mov    %eax,(%esp)
    1954:	e8 b2 01 00 00       	call   1b0b <init_q>
        inQ++;
    1959:	0f b6 05 d0 20 00 00 	movzbl 0x20d0,%eax
    1960:	83 c0 01             	add    $0x1,%eax
    1963:	a2 d0 20 00 00       	mov    %al,0x20d0
    }

    if((uint)stack % 4096){
    1968:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196b:	25 ff 0f 00 00       	and    $0xfff,%eax
    1970:	85 c0                	test   %eax,%eax
    1972:	74 14                	je     1988 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1974:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1977:	25 ff 0f 00 00       	and    $0xfff,%eax
    197c:	89 c2                	mov    %eax,%edx
    197e:	b8 00 10 00 00       	mov    $0x1000,%eax
    1983:	29 d0                	sub    %edx,%eax
    1985:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    198c:	75 1e                	jne    19ac <thread_create+0x86>

        printf(1,"malloc fail \n");
    198e:	c7 44 24 04 9a 1c 00 	movl   $0x1c9a,0x4(%esp)
    1995:	00 
    1996:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    199d:	e8 55 fb ff ff       	call   14f7 <printf>
        return 0;
    19a2:	b8 00 00 00 00       	mov    $0x0,%eax
    19a7:	e9 83 00 00 00       	jmp    1a2f <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    19ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    19af:	8b 55 08             	mov    0x8(%ebp),%edx
    19b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    19b9:	89 54 24 08          	mov    %edx,0x8(%esp)
    19bd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    19c4:	00 
    19c5:	89 04 24             	mov    %eax,(%esp)
    19c8:	e8 1a fa ff ff       	call   13e7 <clone>
    19cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    19d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19d4:	79 1b                	jns    19f1 <thread_create+0xcb>
        printf(1,"clone fails\n");
    19d6:	c7 44 24 04 a8 1c 00 	movl   $0x1ca8,0x4(%esp)
    19dd:	00 
    19de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19e5:	e8 0d fb ff ff       	call   14f7 <printf>
        return 0;
    19ea:	b8 00 00 00 00       	mov    $0x0,%eax
    19ef:	eb 3e                	jmp    1a2f <thread_create+0x109>
    }
    if(tid > 0){
    19f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19f5:	7e 19                	jle    1a10 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    19f7:	a1 d8 20 00 00       	mov    0x20d8,%eax
    19fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19ff:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a03:	89 04 24             	mov    %eax,(%esp)
    1a06:	e8 22 01 00 00       	call   1b2d <add_q>
        return garbage_stack;
    1a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a0e:	eb 1f                	jmp    1a2f <thread_create+0x109>
    }
    if(tid == 0){
    1a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a14:	75 14                	jne    1a2a <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a16:	c7 44 24 04 b5 1c 00 	movl   $0x1cb5,0x4(%esp)
    1a1d:	00 
    1a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a25:	e8 cd fa ff ff       	call   14f7 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a2f:	c9                   	leave  
    1a30:	c3                   	ret    

00001a31 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a31:	55                   	push   %ebp
    1a32:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a34:	a1 c0 20 00 00       	mov    0x20c0,%eax
    1a39:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a3f:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a44:	a3 c0 20 00 00       	mov    %eax,0x20c0
    return (int)(rands % max);
    1a49:	a1 c0 20 00 00       	mov    0x20c0,%eax
    1a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a51:	ba 00 00 00 00       	mov    $0x0,%edx
    1a56:	f7 f1                	div    %ecx
    1a58:	89 d0                	mov    %edx,%eax
}
    1a5a:	5d                   	pop    %ebp
    1a5b:	c3                   	ret    

00001a5c <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a5c:	55                   	push   %ebp
    1a5d:	89 e5                	mov    %esp,%ebp
    1a5f:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a62:	e8 60 f9 ff ff       	call   13c7 <getpid>
    1a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a6a:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1a6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1a72:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a76:	89 04 24             	mov    %eax,(%esp)
    1a79:	e8 af 00 00 00       	call   1b2d <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1a7e:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1a83:	89 04 24             	mov    %eax,(%esp)
    1a86:	e8 1c 01 00 00       	call   1ba7 <pop_q>
    1a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1a8e:	a1 d4 20 00 00       	mov    0x20d4,%eax
    1a93:	85 c0                	test   %eax,%eax
    1a95:	75 1f                	jne    1ab6 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1a97:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1a9c:	89 04 24             	mov    %eax,(%esp)
    1a9f:	e8 03 01 00 00       	call   1ba7 <pop_q>
    1aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1aa7:	a1 d4 20 00 00       	mov    0x20d4,%eax
    1aac:	83 c0 01             	add    $0x1,%eax
    1aaf:	a3 d4 20 00 00       	mov    %eax,0x20d4
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1ab4:	eb 12                	jmp    1ac8 <thread_yield2+0x6c>
    1ab6:	eb 10                	jmp    1ac8 <thread_yield2+0x6c>
    1ab8:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1abd:	89 04 24             	mov    %eax,(%esp)
    1ac0:	e8 e2 00 00 00       	call   1ba7 <pop_q>
    1ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1acb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1ace:	74 e8                	je     1ab8 <thread_yield2+0x5c>
    1ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ad4:	74 e2                	je     1ab8 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad9:	89 04 24             	mov    %eax,(%esp)
    1adc:	e8 1e f9 ff ff       	call   13ff <twakeup>
    tsleep();
    1ae1:	e8 11 f9 ff ff       	call   13f7 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1ae6:	c9                   	leave  
    1ae7:	c3                   	ret    

00001ae8 <thread_yield_last>:

void thread_yield_last(){
    1ae8:	55                   	push   %ebp
    1ae9:	89 e5                	mov    %esp,%ebp
    1aeb:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1aee:	a1 d8 20 00 00       	mov    0x20d8,%eax
    1af3:	89 04 24             	mov    %eax,(%esp)
    1af6:	e8 ac 00 00 00       	call   1ba7 <pop_q>
    1afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b01:	89 04 24             	mov    %eax,(%esp)
    1b04:	e8 f6 f8 ff ff       	call   13ff <twakeup>
    1b09:	c9                   	leave  
    1b0a:	c3                   	ret    

00001b0b <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b0b:	55                   	push   %ebp
    1b0c:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b0e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b17:	8b 45 08             	mov    0x8(%ebp),%eax
    1b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1b21:	8b 45 08             	mov    0x8(%ebp),%eax
    1b24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1b2b:	5d                   	pop    %ebp
    1b2c:	c3                   	ret    

00001b2d <add_q>:

void add_q(struct queue *q, int v){
    1b2d:	55                   	push   %ebp
    1b2e:	89 e5                	mov    %esp,%ebp
    1b30:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1b33:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1b3a:	e8 a4 fc ff ff       	call   17e3 <malloc>
    1b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b52:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b54:	8b 45 08             	mov    0x8(%ebp),%eax
    1b57:	8b 40 04             	mov    0x4(%eax),%eax
    1b5a:	85 c0                	test   %eax,%eax
    1b5c:	75 0b                	jne    1b69 <add_q+0x3c>
        q->head = n;
    1b5e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b64:	89 50 04             	mov    %edx,0x4(%eax)
    1b67:	eb 0c                	jmp    1b75 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b69:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6c:	8b 40 08             	mov    0x8(%eax),%eax
    1b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b72:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1b75:	8b 45 08             	mov    0x8(%ebp),%eax
    1b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b7b:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1b7e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b81:	8b 00                	mov    (%eax),%eax
    1b83:	8d 50 01             	lea    0x1(%eax),%edx
    1b86:	8b 45 08             	mov    0x8(%ebp),%eax
    1b89:	89 10                	mov    %edx,(%eax)
}
    1b8b:	c9                   	leave  
    1b8c:	c3                   	ret    

00001b8d <empty_q>:

int empty_q(struct queue *q){
    1b8d:	55                   	push   %ebp
    1b8e:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1b90:	8b 45 08             	mov    0x8(%ebp),%eax
    1b93:	8b 00                	mov    (%eax),%eax
    1b95:	85 c0                	test   %eax,%eax
    1b97:	75 07                	jne    1ba0 <empty_q+0x13>
        return 1;
    1b99:	b8 01 00 00 00       	mov    $0x1,%eax
    1b9e:	eb 05                	jmp    1ba5 <empty_q+0x18>
    else
        return 0;
    1ba0:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1ba5:	5d                   	pop    %ebp
    1ba6:	c3                   	ret    

00001ba7 <pop_q>:
int pop_q(struct queue *q){
    1ba7:	55                   	push   %ebp
    1ba8:	89 e5                	mov    %esp,%ebp
    1baa:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1bad:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb0:	89 04 24             	mov    %eax,(%esp)
    1bb3:	e8 d5 ff ff ff       	call   1b8d <empty_q>
    1bb8:	85 c0                	test   %eax,%eax
    1bba:	75 5d                	jne    1c19 <pop_q+0x72>
       val = q->head->value; 
    1bbc:	8b 45 08             	mov    0x8(%ebp),%eax
    1bbf:	8b 40 04             	mov    0x4(%eax),%eax
    1bc2:	8b 00                	mov    (%eax),%eax
    1bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1bc7:	8b 45 08             	mov    0x8(%ebp),%eax
    1bca:	8b 40 04             	mov    0x4(%eax),%eax
    1bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1bd0:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd3:	8b 40 04             	mov    0x4(%eax),%eax
    1bd6:	8b 50 04             	mov    0x4(%eax),%edx
    1bd9:	8b 45 08             	mov    0x8(%ebp),%eax
    1bdc:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be2:	89 04 24             	mov    %eax,(%esp)
    1be5:	e8 c0 fa ff ff       	call   16aa <free>
       q->size--;
    1bea:	8b 45 08             	mov    0x8(%ebp),%eax
    1bed:	8b 00                	mov    (%eax),%eax
    1bef:	8d 50 ff             	lea    -0x1(%eax),%edx
    1bf2:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf5:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1bf7:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfa:	8b 00                	mov    (%eax),%eax
    1bfc:	85 c0                	test   %eax,%eax
    1bfe:	75 14                	jne    1c14 <pop_q+0x6d>
            q->head = 0;
    1c00:	8b 45 08             	mov    0x8(%ebp),%eax
    1c03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c0a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c17:	eb 05                	jmp    1c1e <pop_q+0x77>
    }
    return -1;
    1c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1c1e:	c9                   	leave  
    1c1f:	c3                   	ret    
