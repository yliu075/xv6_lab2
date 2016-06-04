
_ty:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"

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
    
    //thread_create(ping, (void *)&arg);
    //thread_create(pong, (void *)&arg);
    
    void *tid = thread_create(ping, (void *)&arg);
    1011:	8d 44 24 18          	lea    0x18(%esp),%eax
    1015:	89 44 24 04          	mov    %eax,0x4(%esp)
    1019:	c7 04 24 95 10 00 00 	movl   $0x1095,(%esp)
    1020:	e8 33 09 00 00       	call   1958 <thread_create>
    1025:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    //printf(1,"Thread Created 1\n");
    if(tid <= 0){
    1029:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    102e:	75 19                	jne    1049 <main+0x49>
        printf(1,"wrong happen\n");
    1030:	c7 44 24 04 52 1c 00 	movl   $0x1c52,0x4(%esp)
    1037:	00 
    1038:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103f:	e8 e5 04 00 00       	call   1529 <printf>
        exit();
    1044:	e8 30 03 00 00       	call   1379 <exit>
    } 
    tid = thread_create(pong, (void *)&arg);
    1049:	8d 44 24 18          	lea    0x18(%esp),%eax
    104d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1051:	c7 04 24 d3 10 00 00 	movl   $0x10d3,(%esp)
    1058:	e8 fb 08 00 00       	call   1958 <thread_create>
    105d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    //printf(1,"Thread Created 2\n");
    if(tid <= 0){
    1061:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1066:	75 19                	jne    1081 <main+0x81>
        printf(1,"wrong happen\n");
    1068:	c7 44 24 04 52 1c 00 	movl   $0x1c52,0x4(%esp)
    106f:	00 
    1070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1077:	e8 ad 04 00 00       	call   1529 <printf>
        exit();
    107c:	e8 f8 02 00 00       	call   1379 <exit>
    } 
    
    
    //printf(1,"Going to Wait\n");
    wait();
    1081:	e8 fb 02 00 00       	call   1381 <wait>
    //printf(1,"Waited 1st Thread\n");
    thread_yield_last();
    1086:	e8 8f 0a 00 00       	call   1b1a <thread_yield_last>
    wait();
    108b:	e8 f1 02 00 00       	call   1381 <wait>
    //printf(1,"Waited 2nd Thread\n");
    
    exit();
    1090:	e8 e4 02 00 00       	call   1379 <exit>

00001095 <ping>:
}


void ping(void *arg_ptr){
    1095:	55                   	push   %ebp
    1096:	89 e5                	mov    %esp,%ebp
    1098:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    109b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    10a2:	eb 24                	jmp    10c8 <ping+0x33>
    // while(1) {
        printf(1,"Ping %d \n",i);
    10a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a7:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ab:	c7 44 24 04 60 1c 00 	movl   $0x1c60,0x4(%esp)
    10b2:	00 
    10b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ba:	e8 6a 04 00 00       	call   1529 <printf>
        thread_yield2();
    10bf:	e8 ca 09 00 00       	call   1a8e <thread_yield2>
}


void ping(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    10c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10c8:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    10cc:	7e d6                	jle    10a4 <ping+0xf>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    10ce:	e8 4e 03 00 00       	call   1421 <texit>

000010d3 <pong>:
}
void pong(void *arg_ptr){
    10d3:	55                   	push   %ebp
    10d4:	89 e5                	mov    %esp,%ebp
    10d6:	83 ec 28             	sub    $0x28,%esp
    int i = 0;
    10d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    10e0:	eb 24                	jmp    1106 <pong+0x33>
    // while(1) {
        printf(1,"Pong %d \n",i);
    10e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e5:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e9:	c7 44 24 04 6a 1c 00 	movl   $0x1c6a,0x4(%esp)
    10f0:	00 
    10f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f8:	e8 2c 04 00 00       	call   1529 <printf>
        thread_yield2();
    10fd:	e8 8c 09 00 00       	call   1a8e <thread_yield2>
    //printf(1,"Pinged ALL\n");
    texit();
}
void pong(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    1102:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1106:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    110a:	7e d6                	jle    10e2 <pong+0xf>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    110c:	e8 10 03 00 00       	call   1421 <texit>

00001111 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1111:	55                   	push   %ebp
    1112:	89 e5                	mov    %esp,%ebp
    1114:	57                   	push   %edi
    1115:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1116:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1119:	8b 55 10             	mov    0x10(%ebp),%edx
    111c:	8b 45 0c             	mov    0xc(%ebp),%eax
    111f:	89 cb                	mov    %ecx,%ebx
    1121:	89 df                	mov    %ebx,%edi
    1123:	89 d1                	mov    %edx,%ecx
    1125:	fc                   	cld    
    1126:	f3 aa                	rep stos %al,%es:(%edi)
    1128:	89 ca                	mov    %ecx,%edx
    112a:	89 fb                	mov    %edi,%ebx
    112c:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1132:	5b                   	pop    %ebx
    1133:	5f                   	pop    %edi
    1134:	5d                   	pop    %ebp
    1135:	c3                   	ret    

00001136 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1136:	55                   	push   %ebp
    1137:	89 e5                	mov    %esp,%ebp
    1139:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113c:	8b 45 08             	mov    0x8(%ebp),%eax
    113f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1142:	90                   	nop
    1143:	8b 45 08             	mov    0x8(%ebp),%eax
    1146:	8d 50 01             	lea    0x1(%eax),%edx
    1149:	89 55 08             	mov    %edx,0x8(%ebp)
    114c:	8b 55 0c             	mov    0xc(%ebp),%edx
    114f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1152:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1155:	0f b6 12             	movzbl (%edx),%edx
    1158:	88 10                	mov    %dl,(%eax)
    115a:	0f b6 00             	movzbl (%eax),%eax
    115d:	84 c0                	test   %al,%al
    115f:	75 e2                	jne    1143 <strcpy+0xd>
    ;
  return os;
    1161:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1164:	c9                   	leave  
    1165:	c3                   	ret    

00001166 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1166:	55                   	push   %ebp
    1167:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1169:	eb 08                	jmp    1173 <strcmp+0xd>
    p++, q++;
    116b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1173:	8b 45 08             	mov    0x8(%ebp),%eax
    1176:	0f b6 00             	movzbl (%eax),%eax
    1179:	84 c0                	test   %al,%al
    117b:	74 10                	je     118d <strcmp+0x27>
    117d:	8b 45 08             	mov    0x8(%ebp),%eax
    1180:	0f b6 10             	movzbl (%eax),%edx
    1183:	8b 45 0c             	mov    0xc(%ebp),%eax
    1186:	0f b6 00             	movzbl (%eax),%eax
    1189:	38 c2                	cmp    %al,%dl
    118b:	74 de                	je     116b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118d:	8b 45 08             	mov    0x8(%ebp),%eax
    1190:	0f b6 00             	movzbl (%eax),%eax
    1193:	0f b6 d0             	movzbl %al,%edx
    1196:	8b 45 0c             	mov    0xc(%ebp),%eax
    1199:	0f b6 00             	movzbl (%eax),%eax
    119c:	0f b6 c0             	movzbl %al,%eax
    119f:	29 c2                	sub    %eax,%edx
    11a1:	89 d0                	mov    %edx,%eax
}
    11a3:	5d                   	pop    %ebp
    11a4:	c3                   	ret    

000011a5 <strlen>:

uint
strlen(char *s)
{
    11a5:	55                   	push   %ebp
    11a6:	89 e5                	mov    %esp,%ebp
    11a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b2:	eb 04                	jmp    11b8 <strlen+0x13>
    11b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11bb:	8b 45 08             	mov    0x8(%ebp),%eax
    11be:	01 d0                	add    %edx,%eax
    11c0:	0f b6 00             	movzbl (%eax),%eax
    11c3:	84 c0                	test   %al,%al
    11c5:	75 ed                	jne    11b4 <strlen+0xf>
    ;
  return n;
    11c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11ca:	c9                   	leave  
    11cb:	c3                   	ret    

000011cc <memset>:

void*
memset(void *dst, int c, uint n)
{
    11cc:	55                   	push   %ebp
    11cd:	89 e5                	mov    %esp,%ebp
    11cf:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d2:	8b 45 10             	mov    0x10(%ebp),%eax
    11d5:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    11dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e0:	8b 45 08             	mov    0x8(%ebp),%eax
    11e3:	89 04 24             	mov    %eax,(%esp)
    11e6:	e8 26 ff ff ff       	call   1111 <stosb>
  return dst;
    11eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ee:	c9                   	leave  
    11ef:	c3                   	ret    

000011f0 <strchr>:

char*
strchr(const char *s, char c)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	83 ec 04             	sub    $0x4,%esp
    11f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11fc:	eb 14                	jmp    1212 <strchr+0x22>
    if(*s == c)
    11fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1201:	0f b6 00             	movzbl (%eax),%eax
    1204:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1207:	75 05                	jne    120e <strchr+0x1e>
      return (char*)s;
    1209:	8b 45 08             	mov    0x8(%ebp),%eax
    120c:	eb 13                	jmp    1221 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    120e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
    1215:	0f b6 00             	movzbl (%eax),%eax
    1218:	84 c0                	test   %al,%al
    121a:	75 e2                	jne    11fe <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    121c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1221:	c9                   	leave  
    1222:	c3                   	ret    

00001223 <gets>:

char*
gets(char *buf, int max)
{
    1223:	55                   	push   %ebp
    1224:	89 e5                	mov    %esp,%ebp
    1226:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1230:	eb 4c                	jmp    127e <gets+0x5b>
    cc = read(0, &c, 1);
    1232:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1239:	00 
    123a:	8d 45 ef             	lea    -0x11(%ebp),%eax
    123d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1248:	e8 44 01 00 00       	call   1391 <read>
    124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1254:	7f 02                	jg     1258 <gets+0x35>
      break;
    1256:	eb 31                	jmp    1289 <gets+0x66>
    buf[i++] = c;
    1258:	8b 45 f4             	mov    -0xc(%ebp),%eax
    125b:	8d 50 01             	lea    0x1(%eax),%edx
    125e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1261:	89 c2                	mov    %eax,%edx
    1263:	8b 45 08             	mov    0x8(%ebp),%eax
    1266:	01 c2                	add    %eax,%edx
    1268:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    126c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    126e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1272:	3c 0a                	cmp    $0xa,%al
    1274:	74 13                	je     1289 <gets+0x66>
    1276:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127a:	3c 0d                	cmp    $0xd,%al
    127c:	74 0b                	je     1289 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1281:	83 c0 01             	add    $0x1,%eax
    1284:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1287:	7c a9                	jl     1232 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1289:	8b 55 f4             	mov    -0xc(%ebp),%edx
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	01 d0                	add    %edx,%eax
    1291:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1294:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1297:	c9                   	leave  
    1298:	c3                   	ret    

00001299 <stat>:

int
stat(char *n, struct stat *st)
{
    1299:	55                   	push   %ebp
    129a:	89 e5                	mov    %esp,%ebp
    129c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12a6:	00 
    12a7:	8b 45 08             	mov    0x8(%ebp),%eax
    12aa:	89 04 24             	mov    %eax,(%esp)
    12ad:	e8 07 01 00 00       	call   13b9 <open>
    12b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12b9:	79 07                	jns    12c2 <stat+0x29>
    return -1;
    12bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c0:	eb 23                	jmp    12e5 <stat+0x4c>
  r = fstat(fd, st);
    12c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12cc:	89 04 24             	mov    %eax,(%esp)
    12cf:	e8 fd 00 00 00       	call   13d1 <fstat>
    12d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 bf 00 00 00       	call   13a1 <close>
  return r;
    12e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12e5:	c9                   	leave  
    12e6:	c3                   	ret    

000012e7 <atoi>:

int
atoi(const char *s)
{
    12e7:	55                   	push   %ebp
    12e8:	89 e5                	mov    %esp,%ebp
    12ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12f4:	eb 25                	jmp    131b <atoi+0x34>
    n = n*10 + *s++ - '0';
    12f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12f9:	89 d0                	mov    %edx,%eax
    12fb:	c1 e0 02             	shl    $0x2,%eax
    12fe:	01 d0                	add    %edx,%eax
    1300:	01 c0                	add    %eax,%eax
    1302:	89 c1                	mov    %eax,%ecx
    1304:	8b 45 08             	mov    0x8(%ebp),%eax
    1307:	8d 50 01             	lea    0x1(%eax),%edx
    130a:	89 55 08             	mov    %edx,0x8(%ebp)
    130d:	0f b6 00             	movzbl (%eax),%eax
    1310:	0f be c0             	movsbl %al,%eax
    1313:	01 c8                	add    %ecx,%eax
    1315:	83 e8 30             	sub    $0x30,%eax
    1318:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    131b:	8b 45 08             	mov    0x8(%ebp),%eax
    131e:	0f b6 00             	movzbl (%eax),%eax
    1321:	3c 2f                	cmp    $0x2f,%al
    1323:	7e 0a                	jle    132f <atoi+0x48>
    1325:	8b 45 08             	mov    0x8(%ebp),%eax
    1328:	0f b6 00             	movzbl (%eax),%eax
    132b:	3c 39                	cmp    $0x39,%al
    132d:	7e c7                	jle    12f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    132f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1332:	c9                   	leave  
    1333:	c3                   	ret    

00001334 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1334:	55                   	push   %ebp
    1335:	89 e5                	mov    %esp,%ebp
    1337:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    133a:	8b 45 08             	mov    0x8(%ebp),%eax
    133d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1340:	8b 45 0c             	mov    0xc(%ebp),%eax
    1343:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1346:	eb 17                	jmp    135f <memmove+0x2b>
    *dst++ = *src++;
    1348:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134b:	8d 50 01             	lea    0x1(%eax),%edx
    134e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1351:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1354:	8d 4a 01             	lea    0x1(%edx),%ecx
    1357:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    135a:	0f b6 12             	movzbl (%edx),%edx
    135d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    135f:	8b 45 10             	mov    0x10(%ebp),%eax
    1362:	8d 50 ff             	lea    -0x1(%eax),%edx
    1365:	89 55 10             	mov    %edx,0x10(%ebp)
    1368:	85 c0                	test   %eax,%eax
    136a:	7f dc                	jg     1348 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    136c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136f:	c9                   	leave  
    1370:	c3                   	ret    

00001371 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1371:	b8 01 00 00 00       	mov    $0x1,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <exit>:
SYSCALL(exit)
    1379:	b8 02 00 00 00       	mov    $0x2,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <wait>:
SYSCALL(wait)
    1381:	b8 03 00 00 00       	mov    $0x3,%eax
    1386:	cd 40                	int    $0x40
    1388:	c3                   	ret    

00001389 <pipe>:
SYSCALL(pipe)
    1389:	b8 04 00 00 00       	mov    $0x4,%eax
    138e:	cd 40                	int    $0x40
    1390:	c3                   	ret    

00001391 <read>:
SYSCALL(read)
    1391:	b8 05 00 00 00       	mov    $0x5,%eax
    1396:	cd 40                	int    $0x40
    1398:	c3                   	ret    

00001399 <write>:
SYSCALL(write)
    1399:	b8 10 00 00 00       	mov    $0x10,%eax
    139e:	cd 40                	int    $0x40
    13a0:	c3                   	ret    

000013a1 <close>:
SYSCALL(close)
    13a1:	b8 15 00 00 00       	mov    $0x15,%eax
    13a6:	cd 40                	int    $0x40
    13a8:	c3                   	ret    

000013a9 <kill>:
SYSCALL(kill)
    13a9:	b8 06 00 00 00       	mov    $0x6,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <exec>:
SYSCALL(exec)
    13b1:	b8 07 00 00 00       	mov    $0x7,%eax
    13b6:	cd 40                	int    $0x40
    13b8:	c3                   	ret    

000013b9 <open>:
SYSCALL(open)
    13b9:	b8 0f 00 00 00       	mov    $0xf,%eax
    13be:	cd 40                	int    $0x40
    13c0:	c3                   	ret    

000013c1 <mknod>:
SYSCALL(mknod)
    13c1:	b8 11 00 00 00       	mov    $0x11,%eax
    13c6:	cd 40                	int    $0x40
    13c8:	c3                   	ret    

000013c9 <unlink>:
SYSCALL(unlink)
    13c9:	b8 12 00 00 00       	mov    $0x12,%eax
    13ce:	cd 40                	int    $0x40
    13d0:	c3                   	ret    

000013d1 <fstat>:
SYSCALL(fstat)
    13d1:	b8 08 00 00 00       	mov    $0x8,%eax
    13d6:	cd 40                	int    $0x40
    13d8:	c3                   	ret    

000013d9 <link>:
SYSCALL(link)
    13d9:	b8 13 00 00 00       	mov    $0x13,%eax
    13de:	cd 40                	int    $0x40
    13e0:	c3                   	ret    

000013e1 <mkdir>:
SYSCALL(mkdir)
    13e1:	b8 14 00 00 00       	mov    $0x14,%eax
    13e6:	cd 40                	int    $0x40
    13e8:	c3                   	ret    

000013e9 <chdir>:
SYSCALL(chdir)
    13e9:	b8 09 00 00 00       	mov    $0x9,%eax
    13ee:	cd 40                	int    $0x40
    13f0:	c3                   	ret    

000013f1 <dup>:
SYSCALL(dup)
    13f1:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f6:	cd 40                	int    $0x40
    13f8:	c3                   	ret    

000013f9 <getpid>:
SYSCALL(getpid)
    13f9:	b8 0b 00 00 00       	mov    $0xb,%eax
    13fe:	cd 40                	int    $0x40
    1400:	c3                   	ret    

00001401 <sbrk>:
SYSCALL(sbrk)
    1401:	b8 0c 00 00 00       	mov    $0xc,%eax
    1406:	cd 40                	int    $0x40
    1408:	c3                   	ret    

00001409 <sleep>:
SYSCALL(sleep)
    1409:	b8 0d 00 00 00       	mov    $0xd,%eax
    140e:	cd 40                	int    $0x40
    1410:	c3                   	ret    

00001411 <uptime>:
SYSCALL(uptime)
    1411:	b8 0e 00 00 00       	mov    $0xe,%eax
    1416:	cd 40                	int    $0x40
    1418:	c3                   	ret    

00001419 <clone>:
SYSCALL(clone)
    1419:	b8 16 00 00 00       	mov    $0x16,%eax
    141e:	cd 40                	int    $0x40
    1420:	c3                   	ret    

00001421 <texit>:
SYSCALL(texit)
    1421:	b8 17 00 00 00       	mov    $0x17,%eax
    1426:	cd 40                	int    $0x40
    1428:	c3                   	ret    

00001429 <tsleep>:
SYSCALL(tsleep)
    1429:	b8 18 00 00 00       	mov    $0x18,%eax
    142e:	cd 40                	int    $0x40
    1430:	c3                   	ret    

00001431 <twakeup>:
SYSCALL(twakeup)
    1431:	b8 19 00 00 00       	mov    $0x19,%eax
    1436:	cd 40                	int    $0x40
    1438:	c3                   	ret    

00001439 <thread_yield>:
SYSCALL(thread_yield)
    1439:	b8 1a 00 00 00       	mov    $0x1a,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <thread_yield3>:
    1441:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1449:	55                   	push   %ebp
    144a:	89 e5                	mov    %esp,%ebp
    144c:	83 ec 18             	sub    $0x18,%esp
    144f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1452:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1455:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    145c:	00 
    145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1460:	89 44 24 04          	mov    %eax,0x4(%esp)
    1464:	8b 45 08             	mov    0x8(%ebp),%eax
    1467:	89 04 24             	mov    %eax,(%esp)
    146a:	e8 2a ff ff ff       	call   1399 <write>
}
    146f:	c9                   	leave  
    1470:	c3                   	ret    

00001471 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1471:	55                   	push   %ebp
    1472:	89 e5                	mov    %esp,%ebp
    1474:	56                   	push   %esi
    1475:	53                   	push   %ebx
    1476:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1479:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1480:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1484:	74 17                	je     149d <printint+0x2c>
    1486:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    148a:	79 11                	jns    149d <printint+0x2c>
    neg = 1;
    148c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1493:	8b 45 0c             	mov    0xc(%ebp),%eax
    1496:	f7 d8                	neg    %eax
    1498:	89 45 ec             	mov    %eax,-0x14(%ebp)
    149b:	eb 06                	jmp    14a3 <printint+0x32>
  } else {
    x = xx;
    149d:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14ad:	8d 41 01             	lea    0x1(%ecx),%eax
    14b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b9:	ba 00 00 00 00       	mov    $0x0,%edx
    14be:	f7 f3                	div    %ebx
    14c0:	89 d0                	mov    %edx,%eax
    14c2:	0f b6 80 a4 20 00 00 	movzbl 0x20a4(%eax),%eax
    14c9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14cd:	8b 75 10             	mov    0x10(%ebp),%esi
    14d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14d3:	ba 00 00 00 00       	mov    $0x0,%edx
    14d8:	f7 f6                	div    %esi
    14da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14e1:	75 c7                	jne    14aa <printint+0x39>
  if(neg)
    14e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14e7:	74 10                	je     14f9 <printint+0x88>
    buf[i++] = '-';
    14e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ec:	8d 50 01             	lea    0x1(%eax),%edx
    14ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14f2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14f7:	eb 1f                	jmp    1518 <printint+0xa7>
    14f9:	eb 1d                	jmp    1518 <printint+0xa7>
    putc(fd, buf[i]);
    14fb:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1501:	01 d0                	add    %edx,%eax
    1503:	0f b6 00             	movzbl (%eax),%eax
    1506:	0f be c0             	movsbl %al,%eax
    1509:	89 44 24 04          	mov    %eax,0x4(%esp)
    150d:	8b 45 08             	mov    0x8(%ebp),%eax
    1510:	89 04 24             	mov    %eax,(%esp)
    1513:	e8 31 ff ff ff       	call   1449 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1518:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    151c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1520:	79 d9                	jns    14fb <printint+0x8a>
    putc(fd, buf[i]);
}
    1522:	83 c4 30             	add    $0x30,%esp
    1525:	5b                   	pop    %ebx
    1526:	5e                   	pop    %esi
    1527:	5d                   	pop    %ebp
    1528:	c3                   	ret    

00001529 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1529:	55                   	push   %ebp
    152a:	89 e5                	mov    %esp,%ebp
    152c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    152f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1536:	8d 45 0c             	lea    0xc(%ebp),%eax
    1539:	83 c0 04             	add    $0x4,%eax
    153c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    153f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1546:	e9 7c 01 00 00       	jmp    16c7 <printf+0x19e>
    c = fmt[i] & 0xff;
    154b:	8b 55 0c             	mov    0xc(%ebp),%edx
    154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1551:	01 d0                	add    %edx,%eax
    1553:	0f b6 00             	movzbl (%eax),%eax
    1556:	0f be c0             	movsbl %al,%eax
    1559:	25 ff 00 00 00       	and    $0xff,%eax
    155e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1565:	75 2c                	jne    1593 <printf+0x6a>
      if(c == '%'){
    1567:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    156b:	75 0c                	jne    1579 <printf+0x50>
        state = '%';
    156d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1574:	e9 4a 01 00 00       	jmp    16c3 <printf+0x19a>
      } else {
        putc(fd, c);
    1579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    157c:	0f be c0             	movsbl %al,%eax
    157f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1583:	8b 45 08             	mov    0x8(%ebp),%eax
    1586:	89 04 24             	mov    %eax,(%esp)
    1589:	e8 bb fe ff ff       	call   1449 <putc>
    158e:	e9 30 01 00 00       	jmp    16c3 <printf+0x19a>
      }
    } else if(state == '%'){
    1593:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1597:	0f 85 26 01 00 00    	jne    16c3 <printf+0x19a>
      if(c == 'd'){
    159d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15a1:	75 2d                	jne    15d0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15a6:	8b 00                	mov    (%eax),%eax
    15a8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15af:	00 
    15b0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15b7:	00 
    15b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bc:	8b 45 08             	mov    0x8(%ebp),%eax
    15bf:	89 04 24             	mov    %eax,(%esp)
    15c2:	e8 aa fe ff ff       	call   1471 <printint>
        ap++;
    15c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15cb:	e9 ec 00 00 00       	jmp    16bc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15d0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15d4:	74 06                	je     15dc <printf+0xb3>
    15d6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15da:	75 2d                	jne    1609 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15df:	8b 00                	mov    (%eax),%eax
    15e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15e8:	00 
    15e9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15f0:	00 
    15f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f5:	8b 45 08             	mov    0x8(%ebp),%eax
    15f8:	89 04 24             	mov    %eax,(%esp)
    15fb:	e8 71 fe ff ff       	call   1471 <printint>
        ap++;
    1600:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1604:	e9 b3 00 00 00       	jmp    16bc <printf+0x193>
      } else if(c == 's'){
    1609:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    160d:	75 45                	jne    1654 <printf+0x12b>
        s = (char*)*ap;
    160f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1612:	8b 00                	mov    (%eax),%eax
    1614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1617:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    161b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    161f:	75 09                	jne    162a <printf+0x101>
          s = "(null)";
    1621:	c7 45 f4 74 1c 00 00 	movl   $0x1c74,-0xc(%ebp)
        while(*s != 0){
    1628:	eb 1e                	jmp    1648 <printf+0x11f>
    162a:	eb 1c                	jmp    1648 <printf+0x11f>
          putc(fd, *s);
    162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162f:	0f b6 00             	movzbl (%eax),%eax
    1632:	0f be c0             	movsbl %al,%eax
    1635:	89 44 24 04          	mov    %eax,0x4(%esp)
    1639:	8b 45 08             	mov    0x8(%ebp),%eax
    163c:	89 04 24             	mov    %eax,(%esp)
    163f:	e8 05 fe ff ff       	call   1449 <putc>
          s++;
    1644:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1648:	8b 45 f4             	mov    -0xc(%ebp),%eax
    164b:	0f b6 00             	movzbl (%eax),%eax
    164e:	84 c0                	test   %al,%al
    1650:	75 da                	jne    162c <printf+0x103>
    1652:	eb 68                	jmp    16bc <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1654:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1658:	75 1d                	jne    1677 <printf+0x14e>
        putc(fd, *ap);
    165a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    165d:	8b 00                	mov    (%eax),%eax
    165f:	0f be c0             	movsbl %al,%eax
    1662:	89 44 24 04          	mov    %eax,0x4(%esp)
    1666:	8b 45 08             	mov    0x8(%ebp),%eax
    1669:	89 04 24             	mov    %eax,(%esp)
    166c:	e8 d8 fd ff ff       	call   1449 <putc>
        ap++;
    1671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1675:	eb 45                	jmp    16bc <printf+0x193>
      } else if(c == '%'){
    1677:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    167b:	75 17                	jne    1694 <printf+0x16b>
        putc(fd, c);
    167d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1680:	0f be c0             	movsbl %al,%eax
    1683:	89 44 24 04          	mov    %eax,0x4(%esp)
    1687:	8b 45 08             	mov    0x8(%ebp),%eax
    168a:	89 04 24             	mov    %eax,(%esp)
    168d:	e8 b7 fd ff ff       	call   1449 <putc>
    1692:	eb 28                	jmp    16bc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1694:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    169b:	00 
    169c:	8b 45 08             	mov    0x8(%ebp),%eax
    169f:	89 04 24             	mov    %eax,(%esp)
    16a2:	e8 a2 fd ff ff       	call   1449 <putc>
        putc(fd, c);
    16a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16aa:	0f be c0             	movsbl %al,%eax
    16ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b1:	8b 45 08             	mov    0x8(%ebp),%eax
    16b4:	89 04 24             	mov    %eax,(%esp)
    16b7:	e8 8d fd ff ff       	call   1449 <putc>
      }
      state = 0;
    16bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16c7:	8b 55 0c             	mov    0xc(%ebp),%edx
    16ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16cd:	01 d0                	add    %edx,%eax
    16cf:	0f b6 00             	movzbl (%eax),%eax
    16d2:	84 c0                	test   %al,%al
    16d4:	0f 85 71 fe ff ff    	jne    154b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16da:	c9                   	leave  
    16db:	c3                   	ret    

000016dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16dc:	55                   	push   %ebp
    16dd:	89 e5                	mov    %esp,%ebp
    16df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16e2:	8b 45 08             	mov    0x8(%ebp),%eax
    16e5:	83 e8 08             	sub    $0x8,%eax
    16e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16eb:	a1 c4 20 00 00       	mov    0x20c4,%eax
    16f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16f3:	eb 24                	jmp    1719 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f8:	8b 00                	mov    (%eax),%eax
    16fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16fd:	77 12                	ja     1711 <free+0x35>
    16ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1705:	77 24                	ja     172b <free+0x4f>
    1707:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170a:	8b 00                	mov    (%eax),%eax
    170c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    170f:	77 1a                	ja     172b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1711:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1714:	8b 00                	mov    (%eax),%eax
    1716:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1719:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    171f:	76 d4                	jbe    16f5 <free+0x19>
    1721:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1724:	8b 00                	mov    (%eax),%eax
    1726:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1729:	76 ca                	jbe    16f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172e:	8b 40 04             	mov    0x4(%eax),%eax
    1731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1738:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173b:	01 c2                	add    %eax,%edx
    173d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1740:	8b 00                	mov    (%eax),%eax
    1742:	39 c2                	cmp    %eax,%edx
    1744:	75 24                	jne    176a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1746:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1749:	8b 50 04             	mov    0x4(%eax),%edx
    174c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174f:	8b 00                	mov    (%eax),%eax
    1751:	8b 40 04             	mov    0x4(%eax),%eax
    1754:	01 c2                	add    %eax,%edx
    1756:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1759:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    175c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175f:	8b 00                	mov    (%eax),%eax
    1761:	8b 10                	mov    (%eax),%edx
    1763:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1766:	89 10                	mov    %edx,(%eax)
    1768:	eb 0a                	jmp    1774 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    176a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176d:	8b 10                	mov    (%eax),%edx
    176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1772:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1774:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1777:	8b 40 04             	mov    0x4(%eax),%eax
    177a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1781:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1784:	01 d0                	add    %edx,%eax
    1786:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1789:	75 20                	jne    17ab <free+0xcf>
    p->s.size += bp->s.size;
    178b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178e:	8b 50 04             	mov    0x4(%eax),%edx
    1791:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1794:	8b 40 04             	mov    0x4(%eax),%eax
    1797:	01 c2                	add    %eax,%edx
    1799:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    179f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a2:	8b 10                	mov    (%eax),%edx
    17a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a7:	89 10                	mov    %edx,(%eax)
    17a9:	eb 08                	jmp    17b3 <free+0xd7>
  } else
    p->s.ptr = bp;
    17ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17b1:	89 10                	mov    %edx,(%eax)
  freep = p;
    17b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b6:	a3 c4 20 00 00       	mov    %eax,0x20c4
}
    17bb:	c9                   	leave  
    17bc:	c3                   	ret    

000017bd <morecore>:

static Header*
morecore(uint nu)
{
    17bd:	55                   	push   %ebp
    17be:	89 e5                	mov    %esp,%ebp
    17c0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17c3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17ca:	77 07                	ja     17d3 <morecore+0x16>
    nu = 4096;
    17cc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17d3:	8b 45 08             	mov    0x8(%ebp),%eax
    17d6:	c1 e0 03             	shl    $0x3,%eax
    17d9:	89 04 24             	mov    %eax,(%esp)
    17dc:	e8 20 fc ff ff       	call   1401 <sbrk>
    17e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17e4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17e8:	75 07                	jne    17f1 <morecore+0x34>
    return 0;
    17ea:	b8 00 00 00 00       	mov    $0x0,%eax
    17ef:	eb 22                	jmp    1813 <morecore+0x56>
  hp = (Header*)p;
    17f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17fa:	8b 55 08             	mov    0x8(%ebp),%edx
    17fd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1800:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1803:	83 c0 08             	add    $0x8,%eax
    1806:	89 04 24             	mov    %eax,(%esp)
    1809:	e8 ce fe ff ff       	call   16dc <free>
  return freep;
    180e:	a1 c4 20 00 00       	mov    0x20c4,%eax
}
    1813:	c9                   	leave  
    1814:	c3                   	ret    

00001815 <malloc>:

void*
malloc(uint nbytes)
{
    1815:	55                   	push   %ebp
    1816:	89 e5                	mov    %esp,%ebp
    1818:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    181b:	8b 45 08             	mov    0x8(%ebp),%eax
    181e:	83 c0 07             	add    $0x7,%eax
    1821:	c1 e8 03             	shr    $0x3,%eax
    1824:	83 c0 01             	add    $0x1,%eax
    1827:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    182a:	a1 c4 20 00 00       	mov    0x20c4,%eax
    182f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1836:	75 23                	jne    185b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1838:	c7 45 f0 bc 20 00 00 	movl   $0x20bc,-0x10(%ebp)
    183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1842:	a3 c4 20 00 00       	mov    %eax,0x20c4
    1847:	a1 c4 20 00 00       	mov    0x20c4,%eax
    184c:	a3 bc 20 00 00       	mov    %eax,0x20bc
    base.s.size = 0;
    1851:	c7 05 c0 20 00 00 00 	movl   $0x0,0x20c0
    1858:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185e:	8b 00                	mov    (%eax),%eax
    1860:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1863:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1866:	8b 40 04             	mov    0x4(%eax),%eax
    1869:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    186c:	72 4d                	jb     18bb <malloc+0xa6>
      if(p->s.size == nunits)
    186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1871:	8b 40 04             	mov    0x4(%eax),%eax
    1874:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1877:	75 0c                	jne    1885 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1879:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187c:	8b 10                	mov    (%eax),%edx
    187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1881:	89 10                	mov    %edx,(%eax)
    1883:	eb 26                	jmp    18ab <malloc+0x96>
      else {
        p->s.size -= nunits;
    1885:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1888:	8b 40 04             	mov    0x4(%eax),%eax
    188b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    188e:	89 c2                	mov    %eax,%edx
    1890:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1893:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1896:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1899:	8b 40 04             	mov    0x4(%eax),%eax
    189c:	c1 e0 03             	shl    $0x3,%eax
    189f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18a8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ae:	a3 c4 20 00 00       	mov    %eax,0x20c4
      return (void*)(p + 1);
    18b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b6:	83 c0 08             	add    $0x8,%eax
    18b9:	eb 38                	jmp    18f3 <malloc+0xde>
    }
    if(p == freep)
    18bb:	a1 c4 20 00 00       	mov    0x20c4,%eax
    18c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18c3:	75 1b                	jne    18e0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18c8:	89 04 24             	mov    %eax,(%esp)
    18cb:	e8 ed fe ff ff       	call   17bd <morecore>
    18d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18d7:	75 07                	jne    18e0 <malloc+0xcb>
        return 0;
    18d9:	b8 00 00 00 00       	mov    $0x0,%eax
    18de:	eb 13                	jmp    18f3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e9:	8b 00                	mov    (%eax),%eax
    18eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18ee:	e9 70 ff ff ff       	jmp    1863 <malloc+0x4e>
}
    18f3:	c9                   	leave  
    18f4:	c3                   	ret    

000018f5 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18f5:	55                   	push   %ebp
    18f6:	89 e5                	mov    %esp,%ebp
    18f8:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    18fb:	8b 55 08             	mov    0x8(%ebp),%edx
    18fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1901:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1904:	f0 87 02             	lock xchg %eax,(%edx)
    1907:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    190d:	c9                   	leave  
    190e:	c3                   	ret    

0000190f <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    190f:	55                   	push   %ebp
    1910:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1912:	8b 45 08             	mov    0x8(%ebp),%eax
    1915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    191b:	5d                   	pop    %ebp
    191c:	c3                   	ret    

0000191d <lock_acquire>:
void lock_acquire(lock_t *lock){
    191d:	55                   	push   %ebp
    191e:	89 e5                	mov    %esp,%ebp
    1920:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1923:	90                   	nop
    1924:	8b 45 08             	mov    0x8(%ebp),%eax
    1927:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    192e:	00 
    192f:	89 04 24             	mov    %eax,(%esp)
    1932:	e8 be ff ff ff       	call   18f5 <xchg>
    1937:	85 c0                	test   %eax,%eax
    1939:	75 e9                	jne    1924 <lock_acquire+0x7>
}
    193b:	c9                   	leave  
    193c:	c3                   	ret    

0000193d <lock_release>:
void lock_release(lock_t *lock){
    193d:	55                   	push   %ebp
    193e:	89 e5                	mov    %esp,%ebp
    1940:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1943:	8b 45 08             	mov    0x8(%ebp),%eax
    1946:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    194d:	00 
    194e:	89 04 24             	mov    %eax,(%esp)
    1951:	e8 9f ff ff ff       	call   18f5 <xchg>
}
    1956:	c9                   	leave  
    1957:	c3                   	ret    

00001958 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1958:	55                   	push   %ebp
    1959:	89 e5                	mov    %esp,%ebp
    195b:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    195e:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1965:	e8 ab fe ff ff       	call   1815 <malloc>
    196a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1970:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1973:	0f b6 05 c8 20 00 00 	movzbl 0x20c8,%eax
    197a:	84 c0                	test   %al,%al
    197c:	75 1c                	jne    199a <thread_create+0x42>
        init_q(thQ2);
    197e:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1983:	89 04 24             	mov    %eax,(%esp)
    1986:	e8 b2 01 00 00       	call   1b3d <init_q>
        inQ++;
    198b:	0f b6 05 c8 20 00 00 	movzbl 0x20c8,%eax
    1992:	83 c0 01             	add    $0x1,%eax
    1995:	a2 c8 20 00 00       	mov    %al,0x20c8
    }

    if((uint)stack % 4096){
    199a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199d:	25 ff 0f 00 00       	and    $0xfff,%eax
    19a2:	85 c0                	test   %eax,%eax
    19a4:	74 14                	je     19ba <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a9:	25 ff 0f 00 00       	and    $0xfff,%eax
    19ae:	89 c2                	mov    %eax,%edx
    19b0:	b8 00 10 00 00       	mov    $0x1000,%eax
    19b5:	29 d0                	sub    %edx,%eax
    19b7:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19be:	75 1e                	jne    19de <thread_create+0x86>

        printf(1,"malloc fail \n");
    19c0:	c7 44 24 04 7b 1c 00 	movl   $0x1c7b,0x4(%esp)
    19c7:	00 
    19c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19cf:	e8 55 fb ff ff       	call   1529 <printf>
        return 0;
    19d4:	b8 00 00 00 00       	mov    $0x0,%eax
    19d9:	e9 83 00 00 00       	jmp    1a61 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    19de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    19e1:	8b 55 08             	mov    0x8(%ebp),%edx
    19e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    19eb:	89 54 24 08          	mov    %edx,0x8(%esp)
    19ef:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    19f6:	00 
    19f7:	89 04 24             	mov    %eax,(%esp)
    19fa:	e8 1a fa ff ff       	call   1419 <clone>
    19ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1a02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a06:	79 1b                	jns    1a23 <thread_create+0xcb>
        printf(1,"clone fails\n");
    1a08:	c7 44 24 04 89 1c 00 	movl   $0x1c89,0x4(%esp)
    1a0f:	00 
    1a10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a17:	e8 0d fb ff ff       	call   1529 <printf>
        return 0;
    1a1c:	b8 00 00 00 00       	mov    $0x0,%eax
    1a21:	eb 3e                	jmp    1a61 <thread_create+0x109>
    }
    if(tid > 0){
    1a23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a27:	7e 19                	jle    1a42 <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1a29:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1a2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a31:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a35:	89 04 24             	mov    %eax,(%esp)
    1a38:	e8 22 01 00 00       	call   1b5f <add_q>
        return garbage_stack;
    1a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a40:	eb 1f                	jmp    1a61 <thread_create+0x109>
    }
    if(tid == 0){
    1a42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a46:	75 14                	jne    1a5c <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a48:	c7 44 24 04 96 1c 00 	movl   $0x1c96,0x4(%esp)
    1a4f:	00 
    1a50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a57:	e8 cd fa ff ff       	call   1529 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a61:	c9                   	leave  
    1a62:	c3                   	ret    

00001a63 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a63:	55                   	push   %ebp
    1a64:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a66:	a1 b8 20 00 00       	mov    0x20b8,%eax
    1a6b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1a71:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1a76:	a3 b8 20 00 00       	mov    %eax,0x20b8
    return (int)(rands % max);
    1a7b:	a1 b8 20 00 00       	mov    0x20b8,%eax
    1a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a83:	ba 00 00 00 00       	mov    $0x0,%edx
    1a88:	f7 f1                	div    %ecx
    1a8a:	89 d0                	mov    %edx,%eax
}
    1a8c:	5d                   	pop    %ebp
    1a8d:	c3                   	ret    

00001a8e <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1a8e:	55                   	push   %ebp
    1a8f:	89 e5                	mov    %esp,%ebp
    1a91:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1a94:	e8 60 f9 ff ff       	call   13f9 <getpid>
    1a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1a9c:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1aa1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1aa4:	89 54 24 04          	mov    %edx,0x4(%esp)
    1aa8:	89 04 24             	mov    %eax,(%esp)
    1aab:	e8 af 00 00 00       	call   1b5f <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1ab0:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1ab5:	89 04 24             	mov    %eax,(%esp)
    1ab8:	e8 1c 01 00 00       	call   1bd9 <pop_q>
    1abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1ac0:	a1 cc 20 00 00       	mov    0x20cc,%eax
    1ac5:	85 c0                	test   %eax,%eax
    1ac7:	75 1f                	jne    1ae8 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1ac9:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1ace:	89 04 24             	mov    %eax,(%esp)
    1ad1:	e8 03 01 00 00       	call   1bd9 <pop_q>
    1ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1ad9:	a1 cc 20 00 00       	mov    0x20cc,%eax
    1ade:	83 c0 01             	add    $0x1,%eax
    1ae1:	a3 cc 20 00 00       	mov    %eax,0x20cc
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1ae6:	eb 12                	jmp    1afa <thread_yield2+0x6c>
    1ae8:	eb 10                	jmp    1afa <thread_yield2+0x6c>
    1aea:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1aef:	89 04 24             	mov    %eax,(%esp)
    1af2:	e8 e2 00 00 00       	call   1bd9 <pop_q>
    1af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1afd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1b00:	74 e8                	je     1aea <thread_yield2+0x5c>
    1b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b06:	74 e2                	je     1aea <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0b:	89 04 24             	mov    %eax,(%esp)
    1b0e:	e8 1e f9 ff ff       	call   1431 <twakeup>
    tsleep();
    1b13:	e8 11 f9 ff ff       	call   1429 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1b18:	c9                   	leave  
    1b19:	c3                   	ret    

00001b1a <thread_yield_last>:

void thread_yield_last(){
    1b1a:	55                   	push   %ebp
    1b1b:	89 e5                	mov    %esp,%ebp
    1b1d:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1b20:	a1 d0 20 00 00       	mov    0x20d0,%eax
    1b25:	89 04 24             	mov    %eax,(%esp)
    1b28:	e8 ac 00 00 00       	call   1bd9 <pop_q>
    1b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b33:	89 04 24             	mov    %eax,(%esp)
    1b36:	e8 f6 f8 ff ff       	call   1431 <twakeup>
    1b3b:	c9                   	leave  
    1b3c:	c3                   	ret    

00001b3d <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b3d:	55                   	push   %ebp
    1b3e:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b40:	8b 45 08             	mov    0x8(%ebp),%eax
    1b43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b49:	8b 45 08             	mov    0x8(%ebp),%eax
    1b4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1b53:	8b 45 08             	mov    0x8(%ebp),%eax
    1b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1b5d:	5d                   	pop    %ebp
    1b5e:	c3                   	ret    

00001b5f <add_q>:

void add_q(struct queue *q, int v){
    1b5f:	55                   	push   %ebp
    1b60:	89 e5                	mov    %esp,%ebp
    1b62:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1b65:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1b6c:	e8 a4 fc ff ff       	call   1815 <malloc>
    1b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b81:	8b 55 0c             	mov    0xc(%ebp),%edx
    1b84:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1b86:	8b 45 08             	mov    0x8(%ebp),%eax
    1b89:	8b 40 04             	mov    0x4(%eax),%eax
    1b8c:	85 c0                	test   %eax,%eax
    1b8e:	75 0b                	jne    1b9b <add_q+0x3c>
        q->head = n;
    1b90:	8b 45 08             	mov    0x8(%ebp),%eax
    1b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b96:	89 50 04             	mov    %edx,0x4(%eax)
    1b99:	eb 0c                	jmp    1ba7 <add_q+0x48>
    }else{
        q->tail->next = n;
    1b9b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b9e:	8b 40 08             	mov    0x8(%eax),%eax
    1ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ba4:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1ba7:	8b 45 08             	mov    0x8(%ebp),%eax
    1baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bad:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1bb0:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb3:	8b 00                	mov    (%eax),%eax
    1bb5:	8d 50 01             	lea    0x1(%eax),%edx
    1bb8:	8b 45 08             	mov    0x8(%ebp),%eax
    1bbb:	89 10                	mov    %edx,(%eax)
}
    1bbd:	c9                   	leave  
    1bbe:	c3                   	ret    

00001bbf <empty_q>:

int empty_q(struct queue *q){
    1bbf:	55                   	push   %ebp
    1bc0:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1bc2:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc5:	8b 00                	mov    (%eax),%eax
    1bc7:	85 c0                	test   %eax,%eax
    1bc9:	75 07                	jne    1bd2 <empty_q+0x13>
        return 1;
    1bcb:	b8 01 00 00 00       	mov    $0x1,%eax
    1bd0:	eb 05                	jmp    1bd7 <empty_q+0x18>
    else
        return 0;
    1bd2:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1bd7:	5d                   	pop    %ebp
    1bd8:	c3                   	ret    

00001bd9 <pop_q>:
int pop_q(struct queue *q){
    1bd9:	55                   	push   %ebp
    1bda:	89 e5                	mov    %esp,%ebp
    1bdc:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1bdf:	8b 45 08             	mov    0x8(%ebp),%eax
    1be2:	89 04 24             	mov    %eax,(%esp)
    1be5:	e8 d5 ff ff ff       	call   1bbf <empty_q>
    1bea:	85 c0                	test   %eax,%eax
    1bec:	75 5d                	jne    1c4b <pop_q+0x72>
       val = q->head->value; 
    1bee:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf1:	8b 40 04             	mov    0x4(%eax),%eax
    1bf4:	8b 00                	mov    (%eax),%eax
    1bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1bf9:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfc:	8b 40 04             	mov    0x4(%eax),%eax
    1bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1c02:	8b 45 08             	mov    0x8(%ebp),%eax
    1c05:	8b 40 04             	mov    0x4(%eax),%eax
    1c08:	8b 50 04             	mov    0x4(%eax),%edx
    1c0b:	8b 45 08             	mov    0x8(%ebp),%eax
    1c0e:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c14:	89 04 24             	mov    %eax,(%esp)
    1c17:	e8 c0 fa ff ff       	call   16dc <free>
       q->size--;
    1c1c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c1f:	8b 00                	mov    (%eax),%eax
    1c21:	8d 50 ff             	lea    -0x1(%eax),%edx
    1c24:	8b 45 08             	mov    0x8(%ebp),%eax
    1c27:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1c29:	8b 45 08             	mov    0x8(%ebp),%eax
    1c2c:	8b 00                	mov    (%eax),%eax
    1c2e:	85 c0                	test   %eax,%eax
    1c30:	75 14                	jne    1c46 <pop_q+0x6d>
            q->head = 0;
    1c32:	8b 45 08             	mov    0x8(%ebp),%eax
    1c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c49:	eb 05                	jmp    1c50 <pop_q+0x77>
    }
    return -1;
    1c4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1c50:	c9                   	leave  
    1c51:	c3                   	ret    
