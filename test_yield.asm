
_test_yield:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

void test_func(void *arg_ptr);
void ping(void *arg_ptr);
void pong(void *arg_ptr);

int main(int argc, char *argv[]){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
   int arg = 10;
    1009:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
    1010:	00 
   void *tid = thread_create(ping, (void *)&arg);
    1011:	8d 44 24 18          	lea    0x18(%esp),%eax
    1015:	89 44 24 04          	mov    %eax,0x4(%esp)
    1019:	c7 04 24 9e 10 00 00 	movl   $0x109e,(%esp)
    1020:	e8 68 09 00 00       	call   198d <thread_create>
    1025:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
    1029:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    102e:	75 19                	jne    1049 <main+0x49>
       printf(1,"wrong happen");
    1030:	c7 44 24 04 a2 1c 00 	movl   $0x1ca2,0x4(%esp)
    1037:	00 
    1038:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103f:	e8 1a 05 00 00       	call   155e <printf>
       exit();
    1044:	e8 65 03 00 00       	call   13ae <exit>
   } 
   tid = thread_create(pong, (void *)&arg);
    1049:	8d 44 24 18          	lea    0x18(%esp),%eax
    104d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1051:	c7 04 24 f2 10 00 00 	movl   $0x10f2,(%esp)
    1058:	e8 30 09 00 00       	call   198d <thread_create>
    105d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
    1061:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1066:	75 19                	jne    1081 <main+0x81>
       printf(1,"wrong happen");
    1068:	c7 44 24 04 a2 1c 00 	movl   $0x1ca2,0x4(%esp)
    106f:	00 
    1070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1077:	e8 e2 04 00 00       	call   155e <printf>
       exit();
    107c:	e8 2d 03 00 00       	call   13ae <exit>
   } 
   exit();
    1081:	e8 28 03 00 00       	call   13ae <exit>

00001086 <test_func>:
}

void test_func(void *arg_ptr){
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
    1089:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
    108c:	a1 38 21 00 00       	mov    0x2138,%eax
    1091:	83 c0 01             	add    $0x1,%eax
    1094:	a3 38 21 00 00       	mov    %eax,0x2138
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
    1099:	e8 b8 03 00 00       	call   1456 <texit>

0000109e <ping>:
}

void ping(void *arg_ptr){
    109e:	55                   	push   %ebp
    109f:	89 e5                	mov    %esp,%ebp
    10a1:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    10aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ad:	8b 00                	mov    (%eax),%eax
    10af:	a3 38 21 00 00       	mov    %eax,0x2138
    int i = 0;
    10b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
    10bb:	eb 2d                	jmp    10ea <ping+0x4c>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
    10bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10c0:	8b 00                	mov    (%eax),%eax
    10c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
    10c9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10cd:	c7 44 24 04 af 1c 00 	movl   $0x1caf,0x4(%esp)
    10d4:	00 
    10d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10dc:	e8 7d 04 00 00       	call   155e <printf>
        thread_yield();
    10e1:	e8 88 03 00 00       	call   146e <thread_yield>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
    10e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10ea:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    10ee:	7e cd                	jle    10bd <ping+0x1f>
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
        thread_yield();
    }
}
    10f0:	c9                   	leave  
    10f1:	c3                   	ret    

000010f2 <pong>:
void pong(void *arg_ptr){
    10f2:	55                   	push   %ebp
    10f3:	89 e5                	mov    %esp,%ebp
    10f5:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    10f8:	8b 45 08             	mov    0x8(%ebp),%eax
    10fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    10fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1101:	8b 00                	mov    (%eax),%eax
    1103:	a3 38 21 00 00       	mov    %eax,0x2138
    int i = 0;
    1108:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 10 ; i++) {
    110f:	eb 2d                	jmp    113e <pong+0x4c>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
    1111:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1114:	8b 00                	mov    (%eax),%eax
    1116:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1119:	89 54 24 0c          	mov    %edx,0xc(%esp)
    111d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1121:	c7 44 24 04 bc 1c 00 	movl   $0x1cbc,0x4(%esp)
    1128:	00 
    1129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1130:	e8 29 04 00 00       	call   155e <printf>
        thread_yield();
    1135:	e8 34 03 00 00       	call   146e <thread_yield>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
    113a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    113e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1142:	7e cd                	jle    1111 <pong+0x1f>
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
        thread_yield();
    }
}
    1144:	c9                   	leave  
    1145:	c3                   	ret    

00001146 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1146:	55                   	push   %ebp
    1147:	89 e5                	mov    %esp,%ebp
    1149:	57                   	push   %edi
    114a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    114b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    114e:	8b 55 10             	mov    0x10(%ebp),%edx
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	89 cb                	mov    %ecx,%ebx
    1156:	89 df                	mov    %ebx,%edi
    1158:	89 d1                	mov    %edx,%ecx
    115a:	fc                   	cld    
    115b:	f3 aa                	rep stos %al,%es:(%edi)
    115d:	89 ca                	mov    %ecx,%edx
    115f:	89 fb                	mov    %edi,%ebx
    1161:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1164:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1167:	5b                   	pop    %ebx
    1168:	5f                   	pop    %edi
    1169:	5d                   	pop    %ebp
    116a:	c3                   	ret    

0000116b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    116b:	55                   	push   %ebp
    116c:	89 e5                	mov    %esp,%ebp
    116e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1177:	90                   	nop
    1178:	8b 45 08             	mov    0x8(%ebp),%eax
    117b:	8d 50 01             	lea    0x1(%eax),%edx
    117e:	89 55 08             	mov    %edx,0x8(%ebp)
    1181:	8b 55 0c             	mov    0xc(%ebp),%edx
    1184:	8d 4a 01             	lea    0x1(%edx),%ecx
    1187:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    118a:	0f b6 12             	movzbl (%edx),%edx
    118d:	88 10                	mov    %dl,(%eax)
    118f:	0f b6 00             	movzbl (%eax),%eax
    1192:	84 c0                	test   %al,%al
    1194:	75 e2                	jne    1178 <strcpy+0xd>
    ;
  return os;
    1196:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1199:	c9                   	leave  
    119a:	c3                   	ret    

0000119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    119b:	55                   	push   %ebp
    119c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    119e:	eb 08                	jmp    11a8 <strcmp+0xd>
    p++, q++;
    11a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11a4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11a8:	8b 45 08             	mov    0x8(%ebp),%eax
    11ab:	0f b6 00             	movzbl (%eax),%eax
    11ae:	84 c0                	test   %al,%al
    11b0:	74 10                	je     11c2 <strcmp+0x27>
    11b2:	8b 45 08             	mov    0x8(%ebp),%eax
    11b5:	0f b6 10             	movzbl (%eax),%edx
    11b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11bb:	0f b6 00             	movzbl (%eax),%eax
    11be:	38 c2                	cmp    %al,%dl
    11c0:	74 de                	je     11a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11c2:	8b 45 08             	mov    0x8(%ebp),%eax
    11c5:	0f b6 00             	movzbl (%eax),%eax
    11c8:	0f b6 d0             	movzbl %al,%edx
    11cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ce:	0f b6 00             	movzbl (%eax),%eax
    11d1:	0f b6 c0             	movzbl %al,%eax
    11d4:	29 c2                	sub    %eax,%edx
    11d6:	89 d0                	mov    %edx,%eax
}
    11d8:	5d                   	pop    %ebp
    11d9:	c3                   	ret    

000011da <strlen>:

uint
strlen(char *s)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11e7:	eb 04                	jmp    11ed <strlen+0x13>
    11e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11f0:	8b 45 08             	mov    0x8(%ebp),%eax
    11f3:	01 d0                	add    %edx,%eax
    11f5:	0f b6 00             	movzbl (%eax),%eax
    11f8:	84 c0                	test   %al,%al
    11fa:	75 ed                	jne    11e9 <strlen+0xf>
    ;
  return n;
    11fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11ff:	c9                   	leave  
    1200:	c3                   	ret    

00001201 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1201:	55                   	push   %ebp
    1202:	89 e5                	mov    %esp,%ebp
    1204:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1207:	8b 45 10             	mov    0x10(%ebp),%eax
    120a:	89 44 24 08          	mov    %eax,0x8(%esp)
    120e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1211:	89 44 24 04          	mov    %eax,0x4(%esp)
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	89 04 24             	mov    %eax,(%esp)
    121b:	e8 26 ff ff ff       	call   1146 <stosb>
  return dst;
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1223:	c9                   	leave  
    1224:	c3                   	ret    

00001225 <strchr>:

char*
strchr(const char *s, char c)
{
    1225:	55                   	push   %ebp
    1226:	89 e5                	mov    %esp,%ebp
    1228:	83 ec 04             	sub    $0x4,%esp
    122b:	8b 45 0c             	mov    0xc(%ebp),%eax
    122e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1231:	eb 14                	jmp    1247 <strchr+0x22>
    if(*s == c)
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	0f b6 00             	movzbl (%eax),%eax
    1239:	3a 45 fc             	cmp    -0x4(%ebp),%al
    123c:	75 05                	jne    1243 <strchr+0x1e>
      return (char*)s;
    123e:	8b 45 08             	mov    0x8(%ebp),%eax
    1241:	eb 13                	jmp    1256 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1243:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1247:	8b 45 08             	mov    0x8(%ebp),%eax
    124a:	0f b6 00             	movzbl (%eax),%eax
    124d:	84 c0                	test   %al,%al
    124f:	75 e2                	jne    1233 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1251:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1256:	c9                   	leave  
    1257:	c3                   	ret    

00001258 <gets>:

char*
gets(char *buf, int max)
{
    1258:	55                   	push   %ebp
    1259:	89 e5                	mov    %esp,%ebp
    125b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    125e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1265:	eb 4c                	jmp    12b3 <gets+0x5b>
    cc = read(0, &c, 1);
    1267:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    126e:	00 
    126f:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1272:	89 44 24 04          	mov    %eax,0x4(%esp)
    1276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    127d:	e8 44 01 00 00       	call   13c6 <read>
    1282:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1285:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1289:	7f 02                	jg     128d <gets+0x35>
      break;
    128b:	eb 31                	jmp    12be <gets+0x66>
    buf[i++] = c;
    128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1290:	8d 50 01             	lea    0x1(%eax),%edx
    1293:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1296:	89 c2                	mov    %eax,%edx
    1298:	8b 45 08             	mov    0x8(%ebp),%eax
    129b:	01 c2                	add    %eax,%edx
    129d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    12a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a7:	3c 0a                	cmp    $0xa,%al
    12a9:	74 13                	je     12be <gets+0x66>
    12ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12af:	3c 0d                	cmp    $0xd,%al
    12b1:	74 0b                	je     12be <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b6:	83 c0 01             	add    $0x1,%eax
    12b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12bc:	7c a9                	jl     1267 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12be:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12c1:	8b 45 08             	mov    0x8(%ebp),%eax
    12c4:	01 d0                	add    %edx,%eax
    12c6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12cc:	c9                   	leave  
    12cd:	c3                   	ret    

000012ce <stat>:

int
stat(char *n, struct stat *st)
{
    12ce:	55                   	push   %ebp
    12cf:	89 e5                	mov    %esp,%ebp
    12d1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12db:	00 
    12dc:	8b 45 08             	mov    0x8(%ebp),%eax
    12df:	89 04 24             	mov    %eax,(%esp)
    12e2:	e8 07 01 00 00       	call   13ee <open>
    12e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12ee:	79 07                	jns    12f7 <stat+0x29>
    return -1;
    12f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12f5:	eb 23                	jmp    131a <stat+0x4c>
  r = fstat(fd, st);
    12f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    12fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    12fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1301:	89 04 24             	mov    %eax,(%esp)
    1304:	e8 fd 00 00 00       	call   1406 <fstat>
    1309:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    130f:	89 04 24             	mov    %eax,(%esp)
    1312:	e8 bf 00 00 00       	call   13d6 <close>
  return r;
    1317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    131a:	c9                   	leave  
    131b:	c3                   	ret    

0000131c <atoi>:

int
atoi(const char *s)
{
    131c:	55                   	push   %ebp
    131d:	89 e5                	mov    %esp,%ebp
    131f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1329:	eb 25                	jmp    1350 <atoi+0x34>
    n = n*10 + *s++ - '0';
    132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    132e:	89 d0                	mov    %edx,%eax
    1330:	c1 e0 02             	shl    $0x2,%eax
    1333:	01 d0                	add    %edx,%eax
    1335:	01 c0                	add    %eax,%eax
    1337:	89 c1                	mov    %eax,%ecx
    1339:	8b 45 08             	mov    0x8(%ebp),%eax
    133c:	8d 50 01             	lea    0x1(%eax),%edx
    133f:	89 55 08             	mov    %edx,0x8(%ebp)
    1342:	0f b6 00             	movzbl (%eax),%eax
    1345:	0f be c0             	movsbl %al,%eax
    1348:	01 c8                	add    %ecx,%eax
    134a:	83 e8 30             	sub    $0x30,%eax
    134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1350:	8b 45 08             	mov    0x8(%ebp),%eax
    1353:	0f b6 00             	movzbl (%eax),%eax
    1356:	3c 2f                	cmp    $0x2f,%al
    1358:	7e 0a                	jle    1364 <atoi+0x48>
    135a:	8b 45 08             	mov    0x8(%ebp),%eax
    135d:	0f b6 00             	movzbl (%eax),%eax
    1360:	3c 39                	cmp    $0x39,%al
    1362:	7e c7                	jle    132b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1364:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1367:	c9                   	leave  
    1368:	c3                   	ret    

00001369 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1369:	55                   	push   %ebp
    136a:	89 e5                	mov    %esp,%ebp
    136c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1375:	8b 45 0c             	mov    0xc(%ebp),%eax
    1378:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    137b:	eb 17                	jmp    1394 <memmove+0x2b>
    *dst++ = *src++;
    137d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1380:	8d 50 01             	lea    0x1(%eax),%edx
    1383:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1386:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1389:	8d 4a 01             	lea    0x1(%edx),%ecx
    138c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    138f:	0f b6 12             	movzbl (%edx),%edx
    1392:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1394:	8b 45 10             	mov    0x10(%ebp),%eax
    1397:	8d 50 ff             	lea    -0x1(%eax),%edx
    139a:	89 55 10             	mov    %edx,0x10(%ebp)
    139d:	85 c0                	test   %eax,%eax
    139f:	7f dc                	jg     137d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    13a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13a4:	c9                   	leave  
    13a5:	c3                   	ret    

000013a6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13a6:	b8 01 00 00 00       	mov    $0x1,%eax
    13ab:	cd 40                	int    $0x40
    13ad:	c3                   	ret    

000013ae <exit>:
SYSCALL(exit)
    13ae:	b8 02 00 00 00       	mov    $0x2,%eax
    13b3:	cd 40                	int    $0x40
    13b5:	c3                   	ret    

000013b6 <wait>:
SYSCALL(wait)
    13b6:	b8 03 00 00 00       	mov    $0x3,%eax
    13bb:	cd 40                	int    $0x40
    13bd:	c3                   	ret    

000013be <pipe>:
SYSCALL(pipe)
    13be:	b8 04 00 00 00       	mov    $0x4,%eax
    13c3:	cd 40                	int    $0x40
    13c5:	c3                   	ret    

000013c6 <read>:
SYSCALL(read)
    13c6:	b8 05 00 00 00       	mov    $0x5,%eax
    13cb:	cd 40                	int    $0x40
    13cd:	c3                   	ret    

000013ce <write>:
SYSCALL(write)
    13ce:	b8 10 00 00 00       	mov    $0x10,%eax
    13d3:	cd 40                	int    $0x40
    13d5:	c3                   	ret    

000013d6 <close>:
SYSCALL(close)
    13d6:	b8 15 00 00 00       	mov    $0x15,%eax
    13db:	cd 40                	int    $0x40
    13dd:	c3                   	ret    

000013de <kill>:
SYSCALL(kill)
    13de:	b8 06 00 00 00       	mov    $0x6,%eax
    13e3:	cd 40                	int    $0x40
    13e5:	c3                   	ret    

000013e6 <exec>:
SYSCALL(exec)
    13e6:	b8 07 00 00 00       	mov    $0x7,%eax
    13eb:	cd 40                	int    $0x40
    13ed:	c3                   	ret    

000013ee <open>:
SYSCALL(open)
    13ee:	b8 0f 00 00 00       	mov    $0xf,%eax
    13f3:	cd 40                	int    $0x40
    13f5:	c3                   	ret    

000013f6 <mknod>:
SYSCALL(mknod)
    13f6:	b8 11 00 00 00       	mov    $0x11,%eax
    13fb:	cd 40                	int    $0x40
    13fd:	c3                   	ret    

000013fe <unlink>:
SYSCALL(unlink)
    13fe:	b8 12 00 00 00       	mov    $0x12,%eax
    1403:	cd 40                	int    $0x40
    1405:	c3                   	ret    

00001406 <fstat>:
SYSCALL(fstat)
    1406:	b8 08 00 00 00       	mov    $0x8,%eax
    140b:	cd 40                	int    $0x40
    140d:	c3                   	ret    

0000140e <link>:
SYSCALL(link)
    140e:	b8 13 00 00 00       	mov    $0x13,%eax
    1413:	cd 40                	int    $0x40
    1415:	c3                   	ret    

00001416 <mkdir>:
SYSCALL(mkdir)
    1416:	b8 14 00 00 00       	mov    $0x14,%eax
    141b:	cd 40                	int    $0x40
    141d:	c3                   	ret    

0000141e <chdir>:
SYSCALL(chdir)
    141e:	b8 09 00 00 00       	mov    $0x9,%eax
    1423:	cd 40                	int    $0x40
    1425:	c3                   	ret    

00001426 <dup>:
SYSCALL(dup)
    1426:	b8 0a 00 00 00       	mov    $0xa,%eax
    142b:	cd 40                	int    $0x40
    142d:	c3                   	ret    

0000142e <getpid>:
SYSCALL(getpid)
    142e:	b8 0b 00 00 00       	mov    $0xb,%eax
    1433:	cd 40                	int    $0x40
    1435:	c3                   	ret    

00001436 <sbrk>:
SYSCALL(sbrk)
    1436:	b8 0c 00 00 00       	mov    $0xc,%eax
    143b:	cd 40                	int    $0x40
    143d:	c3                   	ret    

0000143e <sleep>:
SYSCALL(sleep)
    143e:	b8 0d 00 00 00       	mov    $0xd,%eax
    1443:	cd 40                	int    $0x40
    1445:	c3                   	ret    

00001446 <uptime>:
SYSCALL(uptime)
    1446:	b8 0e 00 00 00       	mov    $0xe,%eax
    144b:	cd 40                	int    $0x40
    144d:	c3                   	ret    

0000144e <clone>:
SYSCALL(clone)
    144e:	b8 16 00 00 00       	mov    $0x16,%eax
    1453:	cd 40                	int    $0x40
    1455:	c3                   	ret    

00001456 <texit>:
SYSCALL(texit)
    1456:	b8 17 00 00 00       	mov    $0x17,%eax
    145b:	cd 40                	int    $0x40
    145d:	c3                   	ret    

0000145e <tsleep>:
SYSCALL(tsleep)
    145e:	b8 18 00 00 00       	mov    $0x18,%eax
    1463:	cd 40                	int    $0x40
    1465:	c3                   	ret    

00001466 <twakeup>:
SYSCALL(twakeup)
    1466:	b8 19 00 00 00       	mov    $0x19,%eax
    146b:	cd 40                	int    $0x40
    146d:	c3                   	ret    

0000146e <thread_yield>:
SYSCALL(thread_yield)
    146e:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1473:	cd 40                	int    $0x40
    1475:	c3                   	ret    

00001476 <thread_yield3>:
    1476:	b8 1a 00 00 00       	mov    $0x1a,%eax
    147b:	cd 40                	int    $0x40
    147d:	c3                   	ret    

0000147e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    147e:	55                   	push   %ebp
    147f:	89 e5                	mov    %esp,%ebp
    1481:	83 ec 18             	sub    $0x18,%esp
    1484:	8b 45 0c             	mov    0xc(%ebp),%eax
    1487:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    148a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1491:	00 
    1492:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1495:	89 44 24 04          	mov    %eax,0x4(%esp)
    1499:	8b 45 08             	mov    0x8(%ebp),%eax
    149c:	89 04 24             	mov    %eax,(%esp)
    149f:	e8 2a ff ff ff       	call   13ce <write>
}
    14a4:	c9                   	leave  
    14a5:	c3                   	ret    

000014a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14a6:	55                   	push   %ebp
    14a7:	89 e5                	mov    %esp,%ebp
    14a9:	56                   	push   %esi
    14aa:	53                   	push   %ebx
    14ab:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    14b9:	74 17                	je     14d2 <printint+0x2c>
    14bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14bf:	79 11                	jns    14d2 <printint+0x2c>
    neg = 1;
    14c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    14cb:	f7 d8                	neg    %eax
    14cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14d0:	eb 06                	jmp    14d8 <printint+0x32>
  } else {
    x = xx;
    14d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14e2:	8d 41 01             	lea    0x1(%ecx),%eax
    14e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14ee:	ba 00 00 00 00       	mov    $0x0,%edx
    14f3:	f7 f3                	div    %ebx
    14f5:	89 d0                	mov    %edx,%eax
    14f7:	0f b6 80 3c 21 00 00 	movzbl 0x213c(%eax),%eax
    14fe:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1502:	8b 75 10             	mov    0x10(%ebp),%esi
    1505:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1508:	ba 00 00 00 00       	mov    $0x0,%edx
    150d:	f7 f6                	div    %esi
    150f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1516:	75 c7                	jne    14df <printint+0x39>
  if(neg)
    1518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    151c:	74 10                	je     152e <printint+0x88>
    buf[i++] = '-';
    151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1521:	8d 50 01             	lea    0x1(%eax),%edx
    1524:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1527:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    152c:	eb 1f                	jmp    154d <printint+0xa7>
    152e:	eb 1d                	jmp    154d <printint+0xa7>
    putc(fd, buf[i]);
    1530:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1533:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1536:	01 d0                	add    %edx,%eax
    1538:	0f b6 00             	movzbl (%eax),%eax
    153b:	0f be c0             	movsbl %al,%eax
    153e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1542:	8b 45 08             	mov    0x8(%ebp),%eax
    1545:	89 04 24             	mov    %eax,(%esp)
    1548:	e8 31 ff ff ff       	call   147e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    154d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1555:	79 d9                	jns    1530 <printint+0x8a>
    putc(fd, buf[i]);
}
    1557:	83 c4 30             	add    $0x30,%esp
    155a:	5b                   	pop    %ebx
    155b:	5e                   	pop    %esi
    155c:	5d                   	pop    %ebp
    155d:	c3                   	ret    

0000155e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    155e:	55                   	push   %ebp
    155f:	89 e5                	mov    %esp,%ebp
    1561:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    156b:	8d 45 0c             	lea    0xc(%ebp),%eax
    156e:	83 c0 04             	add    $0x4,%eax
    1571:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1574:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    157b:	e9 7c 01 00 00       	jmp    16fc <printf+0x19e>
    c = fmt[i] & 0xff;
    1580:	8b 55 0c             	mov    0xc(%ebp),%edx
    1583:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1586:	01 d0                	add    %edx,%eax
    1588:	0f b6 00             	movzbl (%eax),%eax
    158b:	0f be c0             	movsbl %al,%eax
    158e:	25 ff 00 00 00       	and    $0xff,%eax
    1593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1596:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    159a:	75 2c                	jne    15c8 <printf+0x6a>
      if(c == '%'){
    159c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a0:	75 0c                	jne    15ae <printf+0x50>
        state = '%';
    15a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15a9:	e9 4a 01 00 00       	jmp    16f8 <printf+0x19a>
      } else {
        putc(fd, c);
    15ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b1:	0f be c0             	movsbl %al,%eax
    15b4:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b8:	8b 45 08             	mov    0x8(%ebp),%eax
    15bb:	89 04 24             	mov    %eax,(%esp)
    15be:	e8 bb fe ff ff       	call   147e <putc>
    15c3:	e9 30 01 00 00       	jmp    16f8 <printf+0x19a>
      }
    } else if(state == '%'){
    15c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15cc:	0f 85 26 01 00 00    	jne    16f8 <printf+0x19a>
      if(c == 'd'){
    15d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15d6:	75 2d                	jne    1605 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15db:	8b 00                	mov    (%eax),%eax
    15dd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15e4:	00 
    15e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15ec:	00 
    15ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f1:	8b 45 08             	mov    0x8(%ebp),%eax
    15f4:	89 04 24             	mov    %eax,(%esp)
    15f7:	e8 aa fe ff ff       	call   14a6 <printint>
        ap++;
    15fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1600:	e9 ec 00 00 00       	jmp    16f1 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1605:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1609:	74 06                	je     1611 <printf+0xb3>
    160b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    160f:	75 2d                	jne    163e <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1611:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1614:	8b 00                	mov    (%eax),%eax
    1616:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    161d:	00 
    161e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1625:	00 
    1626:	89 44 24 04          	mov    %eax,0x4(%esp)
    162a:	8b 45 08             	mov    0x8(%ebp),%eax
    162d:	89 04 24             	mov    %eax,(%esp)
    1630:	e8 71 fe ff ff       	call   14a6 <printint>
        ap++;
    1635:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1639:	e9 b3 00 00 00       	jmp    16f1 <printf+0x193>
      } else if(c == 's'){
    163e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1642:	75 45                	jne    1689 <printf+0x12b>
        s = (char*)*ap;
    1644:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1647:	8b 00                	mov    (%eax),%eax
    1649:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    164c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1654:	75 09                	jne    165f <printf+0x101>
          s = "(null)";
    1656:	c7 45 f4 c9 1c 00 00 	movl   $0x1cc9,-0xc(%ebp)
        while(*s != 0){
    165d:	eb 1e                	jmp    167d <printf+0x11f>
    165f:	eb 1c                	jmp    167d <printf+0x11f>
          putc(fd, *s);
    1661:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1664:	0f b6 00             	movzbl (%eax),%eax
    1667:	0f be c0             	movsbl %al,%eax
    166a:	89 44 24 04          	mov    %eax,0x4(%esp)
    166e:	8b 45 08             	mov    0x8(%ebp),%eax
    1671:	89 04 24             	mov    %eax,(%esp)
    1674:	e8 05 fe ff ff       	call   147e <putc>
          s++;
    1679:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1680:	0f b6 00             	movzbl (%eax),%eax
    1683:	84 c0                	test   %al,%al
    1685:	75 da                	jne    1661 <printf+0x103>
    1687:	eb 68                	jmp    16f1 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1689:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    168d:	75 1d                	jne    16ac <printf+0x14e>
        putc(fd, *ap);
    168f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1692:	8b 00                	mov    (%eax),%eax
    1694:	0f be c0             	movsbl %al,%eax
    1697:	89 44 24 04          	mov    %eax,0x4(%esp)
    169b:	8b 45 08             	mov    0x8(%ebp),%eax
    169e:	89 04 24             	mov    %eax,(%esp)
    16a1:	e8 d8 fd ff ff       	call   147e <putc>
        ap++;
    16a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16aa:	eb 45                	jmp    16f1 <printf+0x193>
      } else if(c == '%'){
    16ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16b0:	75 17                	jne    16c9 <printf+0x16b>
        putc(fd, c);
    16b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b5:	0f be c0             	movsbl %al,%eax
    16b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    16bc:	8b 45 08             	mov    0x8(%ebp),%eax
    16bf:	89 04 24             	mov    %eax,(%esp)
    16c2:	e8 b7 fd ff ff       	call   147e <putc>
    16c7:	eb 28                	jmp    16f1 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16c9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16d0:	00 
    16d1:	8b 45 08             	mov    0x8(%ebp),%eax
    16d4:	89 04 24             	mov    %eax,(%esp)
    16d7:	e8 a2 fd ff ff       	call   147e <putc>
        putc(fd, c);
    16dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16df:	0f be c0             	movsbl %al,%eax
    16e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    16e6:	8b 45 08             	mov    0x8(%ebp),%eax
    16e9:	89 04 24             	mov    %eax,(%esp)
    16ec:	e8 8d fd ff ff       	call   147e <putc>
      }
      state = 0;
    16f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16fc:	8b 55 0c             	mov    0xc(%ebp),%edx
    16ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1702:	01 d0                	add    %edx,%eax
    1704:	0f b6 00             	movzbl (%eax),%eax
    1707:	84 c0                	test   %al,%al
    1709:	0f 85 71 fe ff ff    	jne    1580 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    170f:	c9                   	leave  
    1710:	c3                   	ret    

00001711 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1711:	55                   	push   %ebp
    1712:	89 e5                	mov    %esp,%ebp
    1714:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1717:	8b 45 08             	mov    0x8(%ebp),%eax
    171a:	83 e8 08             	sub    $0x8,%eax
    171d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1720:	a1 5c 21 00 00       	mov    0x215c,%eax
    1725:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1728:	eb 24                	jmp    174e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172d:	8b 00                	mov    (%eax),%eax
    172f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1732:	77 12                	ja     1746 <free+0x35>
    1734:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    173a:	77 24                	ja     1760 <free+0x4f>
    173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173f:	8b 00                	mov    (%eax),%eax
    1741:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1744:	77 1a                	ja     1760 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1746:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1749:	8b 00                	mov    (%eax),%eax
    174b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    174e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1754:	76 d4                	jbe    172a <free+0x19>
    1756:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1759:	8b 00                	mov    (%eax),%eax
    175b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    175e:	76 ca                	jbe    172a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1760:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1763:	8b 40 04             	mov    0x4(%eax),%eax
    1766:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    176d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1770:	01 c2                	add    %eax,%edx
    1772:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1775:	8b 00                	mov    (%eax),%eax
    1777:	39 c2                	cmp    %eax,%edx
    1779:	75 24                	jne    179f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    177b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    177e:	8b 50 04             	mov    0x4(%eax),%edx
    1781:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1784:	8b 00                	mov    (%eax),%eax
    1786:	8b 40 04             	mov    0x4(%eax),%eax
    1789:	01 c2                	add    %eax,%edx
    178b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    178e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1791:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1794:	8b 00                	mov    (%eax),%eax
    1796:	8b 10                	mov    (%eax),%edx
    1798:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179b:	89 10                	mov    %edx,(%eax)
    179d:	eb 0a                	jmp    17a9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a2:	8b 10                	mov    (%eax),%edx
    17a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ac:	8b 40 04             	mov    0x4(%eax),%eax
    17af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b9:	01 d0                	add    %edx,%eax
    17bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17be:	75 20                	jne    17e0 <free+0xcf>
    p->s.size += bp->s.size;
    17c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c3:	8b 50 04             	mov    0x4(%eax),%edx
    17c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c9:	8b 40 04             	mov    0x4(%eax),%eax
    17cc:	01 c2                	add    %eax,%edx
    17ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d7:	8b 10                	mov    (%eax),%edx
    17d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dc:	89 10                	mov    %edx,(%eax)
    17de:	eb 08                	jmp    17e8 <free+0xd7>
  } else
    p->s.ptr = bp;
    17e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17e6:	89 10                	mov    %edx,(%eax)
  freep = p;
    17e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17eb:	a3 5c 21 00 00       	mov    %eax,0x215c
}
    17f0:	c9                   	leave  
    17f1:	c3                   	ret    

000017f2 <morecore>:

static Header*
morecore(uint nu)
{
    17f2:	55                   	push   %ebp
    17f3:	89 e5                	mov    %esp,%ebp
    17f5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17f8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17ff:	77 07                	ja     1808 <morecore+0x16>
    nu = 4096;
    1801:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1808:	8b 45 08             	mov    0x8(%ebp),%eax
    180b:	c1 e0 03             	shl    $0x3,%eax
    180e:	89 04 24             	mov    %eax,(%esp)
    1811:	e8 20 fc ff ff       	call   1436 <sbrk>
    1816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1819:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    181d:	75 07                	jne    1826 <morecore+0x34>
    return 0;
    181f:	b8 00 00 00 00       	mov    $0x0,%eax
    1824:	eb 22                	jmp    1848 <morecore+0x56>
  hp = (Header*)p;
    1826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1829:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    182c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    182f:	8b 55 08             	mov    0x8(%ebp),%edx
    1832:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1835:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1838:	83 c0 08             	add    $0x8,%eax
    183b:	89 04 24             	mov    %eax,(%esp)
    183e:	e8 ce fe ff ff       	call   1711 <free>
  return freep;
    1843:	a1 5c 21 00 00       	mov    0x215c,%eax
}
    1848:	c9                   	leave  
    1849:	c3                   	ret    

0000184a <malloc>:

void*
malloc(uint nbytes)
{
    184a:	55                   	push   %ebp
    184b:	89 e5                	mov    %esp,%ebp
    184d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1850:	8b 45 08             	mov    0x8(%ebp),%eax
    1853:	83 c0 07             	add    $0x7,%eax
    1856:	c1 e8 03             	shr    $0x3,%eax
    1859:	83 c0 01             	add    $0x1,%eax
    185c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    185f:	a1 5c 21 00 00       	mov    0x215c,%eax
    1864:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1867:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    186b:	75 23                	jne    1890 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    186d:	c7 45 f0 54 21 00 00 	movl   $0x2154,-0x10(%ebp)
    1874:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1877:	a3 5c 21 00 00       	mov    %eax,0x215c
    187c:	a1 5c 21 00 00       	mov    0x215c,%eax
    1881:	a3 54 21 00 00       	mov    %eax,0x2154
    base.s.size = 0;
    1886:	c7 05 58 21 00 00 00 	movl   $0x0,0x2158
    188d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1890:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1893:	8b 00                	mov    (%eax),%eax
    1895:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1898:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189b:	8b 40 04             	mov    0x4(%eax),%eax
    189e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18a1:	72 4d                	jb     18f0 <malloc+0xa6>
      if(p->s.size == nunits)
    18a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a6:	8b 40 04             	mov    0x4(%eax),%eax
    18a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18ac:	75 0c                	jne    18ba <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    18ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b1:	8b 10                	mov    (%eax),%edx
    18b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b6:	89 10                	mov    %edx,(%eax)
    18b8:	eb 26                	jmp    18e0 <malloc+0x96>
      else {
        p->s.size -= nunits;
    18ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bd:	8b 40 04             	mov    0x4(%eax),%eax
    18c0:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18c3:	89 c2                	mov    %eax,%edx
    18c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ce:	8b 40 04             	mov    0x4(%eax),%eax
    18d1:	c1 e0 03             	shl    $0x3,%eax
    18d4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18da:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18dd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e3:	a3 5c 21 00 00       	mov    %eax,0x215c
      return (void*)(p + 1);
    18e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18eb:	83 c0 08             	add    $0x8,%eax
    18ee:	eb 38                	jmp    1928 <malloc+0xde>
    }
    if(p == freep)
    18f0:	a1 5c 21 00 00       	mov    0x215c,%eax
    18f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18f8:	75 1b                	jne    1915 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18fd:	89 04 24             	mov    %eax,(%esp)
    1900:	e8 ed fe ff ff       	call   17f2 <morecore>
    1905:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    190c:	75 07                	jne    1915 <malloc+0xcb>
        return 0;
    190e:	b8 00 00 00 00       	mov    $0x0,%eax
    1913:	eb 13                	jmp    1928 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1915:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1918:	89 45 f0             	mov    %eax,-0x10(%ebp)
    191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191e:	8b 00                	mov    (%eax),%eax
    1920:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1923:	e9 70 ff ff ff       	jmp    1898 <malloc+0x4e>
}
    1928:	c9                   	leave  
    1929:	c3                   	ret    

0000192a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    192a:	55                   	push   %ebp
    192b:	89 e5                	mov    %esp,%ebp
    192d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1930:	8b 55 08             	mov    0x8(%ebp),%edx
    1933:	8b 45 0c             	mov    0xc(%ebp),%eax
    1936:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1939:	f0 87 02             	lock xchg %eax,(%edx)
    193c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1942:	c9                   	leave  
    1943:	c3                   	ret    

00001944 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1944:	55                   	push   %ebp
    1945:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1947:	8b 45 08             	mov    0x8(%ebp),%eax
    194a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1950:	5d                   	pop    %ebp
    1951:	c3                   	ret    

00001952 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1952:	55                   	push   %ebp
    1953:	89 e5                	mov    %esp,%ebp
    1955:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1958:	90                   	nop
    1959:	8b 45 08             	mov    0x8(%ebp),%eax
    195c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1963:	00 
    1964:	89 04 24             	mov    %eax,(%esp)
    1967:	e8 be ff ff ff       	call   192a <xchg>
    196c:	85 c0                	test   %eax,%eax
    196e:	75 e9                	jne    1959 <lock_acquire+0x7>
}
    1970:	c9                   	leave  
    1971:	c3                   	ret    

00001972 <lock_release>:
void lock_release(lock_t *lock){
    1972:	55                   	push   %ebp
    1973:	89 e5                	mov    %esp,%ebp
    1975:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1978:	8b 45 08             	mov    0x8(%ebp),%eax
    197b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1982:	00 
    1983:	89 04 24             	mov    %eax,(%esp)
    1986:	e8 9f ff ff ff       	call   192a <xchg>
}
    198b:	c9                   	leave  
    198c:	c3                   	ret    

0000198d <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    198d:	55                   	push   %ebp
    198e:	89 e5                	mov    %esp,%ebp
    1990:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1993:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    199a:	e8 ab fe ff ff       	call   184a <malloc>
    199f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    19a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    19a8:	0f b6 05 60 21 00 00 	movzbl 0x2160,%eax
    19af:	84 c0                	test   %al,%al
    19b1:	75 1c                	jne    19cf <thread_create+0x42>
        init_q(thQ2);
    19b3:	a1 68 21 00 00       	mov    0x2168,%eax
    19b8:	89 04 24             	mov    %eax,(%esp)
    19bb:	e8 cd 01 00 00       	call   1b8d <init_q>
        inQ++;
    19c0:	0f b6 05 60 21 00 00 	movzbl 0x2160,%eax
    19c7:	83 c0 01             	add    $0x1,%eax
    19ca:	a2 60 21 00 00       	mov    %al,0x2160
    }

    if((uint)stack % 4096){
    19cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d2:	25 ff 0f 00 00       	and    $0xfff,%eax
    19d7:	85 c0                	test   %eax,%eax
    19d9:	74 14                	je     19ef <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19de:	25 ff 0f 00 00       	and    $0xfff,%eax
    19e3:	89 c2                	mov    %eax,%edx
    19e5:	b8 00 10 00 00       	mov    $0x1000,%eax
    19ea:	29 d0                	sub    %edx,%eax
    19ec:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19f3:	75 1e                	jne    1a13 <thread_create+0x86>

        printf(1,"malloc fail \n");
    19f5:	c7 44 24 04 d0 1c 00 	movl   $0x1cd0,0x4(%esp)
    19fc:	00 
    19fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a04:	e8 55 fb ff ff       	call   155e <printf>
        return 0;
    1a09:	b8 00 00 00 00       	mov    $0x0,%eax
    1a0e:	e9 9e 00 00 00       	jmp    1ab1 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1a16:	8b 55 08             	mov    0x8(%ebp),%edx
    1a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a1c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1a20:	89 54 24 08          	mov    %edx,0x8(%esp)
    1a24:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a2b:	00 
    1a2c:	89 04 24             	mov    %eax,(%esp)
    1a2f:	e8 1a fa ff ff       	call   144e <clone>
    1a34:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a3e:	c7 44 24 04 de 1c 00 	movl   $0x1cde,0x4(%esp)
    1a45:	00 
    1a46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a4d:	e8 0c fb ff ff       	call   155e <printf>
    if(tid < 0){
    1a52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a56:	79 1b                	jns    1a73 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1a58:	c7 44 24 04 f7 1c 00 	movl   $0x1cf7,0x4(%esp)
    1a5f:	00 
    1a60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a67:	e8 f2 fa ff ff       	call   155e <printf>
        return 0;
    1a6c:	b8 00 00 00 00       	mov    $0x0,%eax
    1a71:	eb 3e                	jmp    1ab1 <thread_create+0x124>
    }
    if(tid > 0){
    1a73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a77:	7e 19                	jle    1a92 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1a79:	a1 68 21 00 00       	mov    0x2168,%eax
    1a7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a81:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a85:	89 04 24             	mov    %eax,(%esp)
    1a88:	e8 22 01 00 00       	call   1baf <add_q>
        return garbage_stack;
    1a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a90:	eb 1f                	jmp    1ab1 <thread_create+0x124>
    }
    if(tid == 0){
    1a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a96:	75 14                	jne    1aac <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1a98:	c7 44 24 04 04 1d 00 	movl   $0x1d04,0x4(%esp)
    1a9f:	00 
    1aa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aa7:	e8 b2 fa ff ff       	call   155e <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1ab1:	c9                   	leave  
    1ab2:	c3                   	ret    

00001ab3 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1ab3:	55                   	push   %ebp
    1ab4:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1ab6:	a1 50 21 00 00       	mov    0x2150,%eax
    1abb:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1ac1:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1ac6:	a3 50 21 00 00       	mov    %eax,0x2150
    return (int)(rands % max);
    1acb:	a1 50 21 00 00       	mov    0x2150,%eax
    1ad0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1ad3:	ba 00 00 00 00       	mov    $0x0,%edx
    1ad8:	f7 f1                	div    %ecx
    1ada:	89 d0                	mov    %edx,%eax
}
    1adc:	5d                   	pop    %ebp
    1add:	c3                   	ret    

00001ade <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1ade:	55                   	push   %ebp
    1adf:	89 e5                	mov    %esp,%ebp
    1ae1:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1ae4:	e8 45 f9 ff ff       	call   142e <getpid>
    1ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1aec:	a1 68 21 00 00       	mov    0x2168,%eax
    1af1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1af4:	89 54 24 04          	mov    %edx,0x4(%esp)
    1af8:	89 04 24             	mov    %eax,(%esp)
    1afb:	e8 af 00 00 00       	call   1baf <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1b00:	a1 68 21 00 00       	mov    0x2168,%eax
    1b05:	89 04 24             	mov    %eax,(%esp)
    1b08:	e8 1c 01 00 00       	call   1c29 <pop_q>
    1b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1b10:	a1 64 21 00 00       	mov    0x2164,%eax
    1b15:	85 c0                	test   %eax,%eax
    1b17:	75 1f                	jne    1b38 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1b19:	a1 68 21 00 00       	mov    0x2168,%eax
    1b1e:	89 04 24             	mov    %eax,(%esp)
    1b21:	e8 03 01 00 00       	call   1c29 <pop_q>
    1b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1b29:	a1 64 21 00 00       	mov    0x2164,%eax
    1b2e:	83 c0 01             	add    $0x1,%eax
    1b31:	a3 64 21 00 00       	mov    %eax,0x2164
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1b36:	eb 12                	jmp    1b4a <thread_yield2+0x6c>
    1b38:	eb 10                	jmp    1b4a <thread_yield2+0x6c>
    1b3a:	a1 68 21 00 00       	mov    0x2168,%eax
    1b3f:	89 04 24             	mov    %eax,(%esp)
    1b42:	e8 e2 00 00 00       	call   1c29 <pop_q>
    1b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1b50:	74 e8                	je     1b3a <thread_yield2+0x5c>
    1b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b56:	74 e2                	je     1b3a <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b5b:	89 04 24             	mov    %eax,(%esp)
    1b5e:	e8 03 f9 ff ff       	call   1466 <twakeup>
    tsleep();
    1b63:	e8 f6 f8 ff ff       	call   145e <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1b68:	c9                   	leave  
    1b69:	c3                   	ret    

00001b6a <thread_yield_last>:

void thread_yield_last(){
    1b6a:	55                   	push   %ebp
    1b6b:	89 e5                	mov    %esp,%ebp
    1b6d:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1b70:	a1 68 21 00 00       	mov    0x2168,%eax
    1b75:	89 04 24             	mov    %eax,(%esp)
    1b78:	e8 ac 00 00 00       	call   1c29 <pop_q>
    1b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b83:	89 04 24             	mov    %eax,(%esp)
    1b86:	e8 db f8 ff ff       	call   1466 <twakeup>
    1b8b:	c9                   	leave  
    1b8c:	c3                   	ret    

00001b8d <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b8d:	55                   	push   %ebp
    1b8e:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b90:	8b 45 08             	mov    0x8(%ebp),%eax
    1b93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b99:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1ba3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1bad:	5d                   	pop    %ebp
    1bae:	c3                   	ret    

00001baf <add_q>:

void add_q(struct queue *q, int v){
    1baf:	55                   	push   %ebp
    1bb0:	89 e5                	mov    %esp,%ebp
    1bb2:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1bb5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1bbc:	e8 89 fc ff ff       	call   184a <malloc>
    1bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
    1bd4:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1bd6:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd9:	8b 40 04             	mov    0x4(%eax),%eax
    1bdc:	85 c0                	test   %eax,%eax
    1bde:	75 0b                	jne    1beb <add_q+0x3c>
        q->head = n;
    1be0:	8b 45 08             	mov    0x8(%ebp),%eax
    1be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1be6:	89 50 04             	mov    %edx,0x4(%eax)
    1be9:	eb 0c                	jmp    1bf7 <add_q+0x48>
    }else{
        q->tail->next = n;
    1beb:	8b 45 08             	mov    0x8(%ebp),%eax
    1bee:	8b 40 08             	mov    0x8(%eax),%eax
    1bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bf4:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1bf7:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bfd:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1c00:	8b 45 08             	mov    0x8(%ebp),%eax
    1c03:	8b 00                	mov    (%eax),%eax
    1c05:	8d 50 01             	lea    0x1(%eax),%edx
    1c08:	8b 45 08             	mov    0x8(%ebp),%eax
    1c0b:	89 10                	mov    %edx,(%eax)
}
    1c0d:	c9                   	leave  
    1c0e:	c3                   	ret    

00001c0f <empty_q>:

int empty_q(struct queue *q){
    1c0f:	55                   	push   %ebp
    1c10:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1c12:	8b 45 08             	mov    0x8(%ebp),%eax
    1c15:	8b 00                	mov    (%eax),%eax
    1c17:	85 c0                	test   %eax,%eax
    1c19:	75 07                	jne    1c22 <empty_q+0x13>
        return 1;
    1c1b:	b8 01 00 00 00       	mov    $0x1,%eax
    1c20:	eb 05                	jmp    1c27 <empty_q+0x18>
    else
        return 0;
    1c22:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1c27:	5d                   	pop    %ebp
    1c28:	c3                   	ret    

00001c29 <pop_q>:
int pop_q(struct queue *q){
    1c29:	55                   	push   %ebp
    1c2a:	89 e5                	mov    %esp,%ebp
    1c2c:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1c2f:	8b 45 08             	mov    0x8(%ebp),%eax
    1c32:	89 04 24             	mov    %eax,(%esp)
    1c35:	e8 d5 ff ff ff       	call   1c0f <empty_q>
    1c3a:	85 c0                	test   %eax,%eax
    1c3c:	75 5d                	jne    1c9b <pop_q+0x72>
       val = q->head->value; 
    1c3e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c41:	8b 40 04             	mov    0x4(%eax),%eax
    1c44:	8b 00                	mov    (%eax),%eax
    1c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1c49:	8b 45 08             	mov    0x8(%ebp),%eax
    1c4c:	8b 40 04             	mov    0x4(%eax),%eax
    1c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1c52:	8b 45 08             	mov    0x8(%ebp),%eax
    1c55:	8b 40 04             	mov    0x4(%eax),%eax
    1c58:	8b 50 04             	mov    0x4(%eax),%edx
    1c5b:	8b 45 08             	mov    0x8(%ebp),%eax
    1c5e:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c64:	89 04 24             	mov    %eax,(%esp)
    1c67:	e8 a5 fa ff ff       	call   1711 <free>
       q->size--;
    1c6c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c6f:	8b 00                	mov    (%eax),%eax
    1c71:	8d 50 ff             	lea    -0x1(%eax),%edx
    1c74:	8b 45 08             	mov    0x8(%ebp),%eax
    1c77:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1c79:	8b 45 08             	mov    0x8(%ebp),%eax
    1c7c:	8b 00                	mov    (%eax),%eax
    1c7e:	85 c0                	test   %eax,%eax
    1c80:	75 14                	jne    1c96 <pop_q+0x6d>
            q->head = 0;
    1c82:	8b 45 08             	mov    0x8(%ebp),%eax
    1c85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c8c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c99:	eb 05                	jmp    1ca0 <pop_q+0x77>
    }
    return -1;
    1c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1ca0:	c9                   	leave  
    1ca1:	c3                   	ret    
