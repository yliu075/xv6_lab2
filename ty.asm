
_ty:     file format elf32-i386


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
    
    //thread_create(ping, (void *)&arg);
    //thread_create(pong, (void *)&arg);
    
    void *tid = thread_create(ping, (void *)&arg);
    1011:	8d 44 24 18          	lea    0x18(%esp),%eax
    1015:	89 44 24 04          	mov    %eax,0x4(%esp)
    1019:	c7 04 24 11 11 00 00 	movl   $0x1111,(%esp)
    1020:	e8 cf 09 00 00       	call   19f4 <thread_create>
    1025:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    printf(1,"Thread Created 1\n");
    1029:	c7 44 24 04 09 1d 00 	movl   $0x1d09,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1038:	e8 88 05 00 00       	call   15c5 <printf>
    if(tid <= 0){
    103d:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1042:	75 19                	jne    105d <main+0x5d>
        printf(1,"wrong happen\n");
    1044:	c7 44 24 04 1b 1d 00 	movl   $0x1d1b,0x4(%esp)
    104b:	00 
    104c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1053:	e8 6d 05 00 00       	call   15c5 <printf>
        exit();
    1058:	e8 b8 03 00 00       	call   1415 <exit>
    } 
    tid = thread_create(pong, (void *)&arg);
    105d:	8d 44 24 18          	lea    0x18(%esp),%eax
    1061:	89 44 24 04          	mov    %eax,0x4(%esp)
    1065:	c7 04 24 5f 11 00 00 	movl   $0x115f,(%esp)
    106c:	e8 83 09 00 00       	call   19f4 <thread_create>
    1071:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    printf(1,"Thread Created 2\n");
    1075:	c7 44 24 04 29 1d 00 	movl   $0x1d29,0x4(%esp)
    107c:	00 
    107d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1084:	e8 3c 05 00 00       	call   15c5 <printf>
    if(tid <= 0){
    1089:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    108e:	75 19                	jne    10a9 <main+0xa9>
        printf(1,"wrong happen\n");
    1090:	c7 44 24 04 1b 1d 00 	movl   $0x1d1b,0x4(%esp)
    1097:	00 
    1098:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109f:	e8 21 05 00 00       	call   15c5 <printf>
        exit();
    10a4:	e8 6c 03 00 00       	call   1415 <exit>
    } 
    
    
    printf(1,"Going to Wait\n");
    10a9:	c7 44 24 04 3b 1d 00 	movl   $0x1d3b,0x4(%esp)
    10b0:	00 
    10b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b8:	e8 08 05 00 00       	call   15c5 <printf>
    wait();
    10bd:	e8 5b 03 00 00       	call   141d <wait>
    printf(1,"Waited 1\n");
    10c2:	c7 44 24 04 4a 1d 00 	movl   $0x1d4a,0x4(%esp)
    10c9:	00 
    10ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d1:	e8 ef 04 00 00       	call   15c5 <printf>
    thread_yield_last();
    10d6:	e8 f6 0a 00 00       	call   1bd1 <thread_yield_last>
    wait();
    10db:	e8 3d 03 00 00       	call   141d <wait>
    printf(1,"Waited 2\n");
    10e0:	c7 44 24 04 54 1d 00 	movl   $0x1d54,0x4(%esp)
    10e7:	00 
    10e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ef:	e8 d1 04 00 00       	call   15c5 <printf>
    
    exit();
    10f4:	e8 1c 03 00 00       	call   1415 <exit>

000010f9 <test_func>:
}

void test_func(void *arg_ptr){
    10f9:	55                   	push   %ebp
    10fa:	89 e5                	mov    %esp,%ebp
    10fc:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
    10ff:	a1 d8 21 00 00       	mov    0x21d8,%eax
    1104:	83 c0 01             	add    $0x1,%eax
    1107:	a3 d8 21 00 00       	mov    %eax,0x21d8
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
    110c:	e8 ac 03 00 00       	call   14bd <texit>

00001111 <ping>:
}

void ping(void *arg_ptr){
    1111:	55                   	push   %ebp
    1112:	89 e5                	mov    %esp,%ebp
    1114:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    1117:	8b 45 08             	mov    0x8(%ebp),%eax
    111a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    111d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1120:	8b 00                	mov    (%eax),%eax
    1122:	a3 d8 21 00 00       	mov    %eax,0x21d8
    int i = 0;
    1127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    112e:	eb 24                	jmp    1154 <ping+0x43>
    // while(1) {
        printf(1,"Ping %d \n",i);
    1130:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1133:	89 44 24 08          	mov    %eax,0x8(%esp)
    1137:	c7 44 24 04 5e 1d 00 	movl   $0x1d5e,0x4(%esp)
    113e:	00 
    113f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1146:	e8 7a 04 00 00       	call   15c5 <printf>
        thread_yield2();
    114b:	e8 f5 09 00 00       	call   1b45 <thread_yield2>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    1150:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1154:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    1158:	7e d6                	jle    1130 <ping+0x1f>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    115a:	e8 5e 03 00 00       	call   14bd <texit>

0000115f <pong>:
}
void pong(void *arg_ptr){
    115f:	55                   	push   %ebp
    1160:	89 e5                	mov    %esp,%ebp
    1162:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    1165:	8b 45 08             	mov    0x8(%ebp),%eax
    1168:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    116b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    116e:	8b 00                	mov    (%eax),%eax
    1170:	a3 d8 21 00 00       	mov    %eax,0x21d8
    int i = 0;
    1175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    117c:	eb 24                	jmp    11a2 <pong+0x43>
    // while(1) {
        printf(1,"Pong %d \n",i);
    117e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1181:	89 44 24 08          	mov    %eax,0x8(%esp)
    1185:	c7 44 24 04 68 1d 00 	movl   $0x1d68,0x4(%esp)
    118c:	00 
    118d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1194:	e8 2c 04 00 00       	call   15c5 <printf>
        thread_yield2();
    1199:	e8 a7 09 00 00       	call   1b45 <thread_yield2>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    119e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11a2:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    11a6:	7e d6                	jle    117e <pong+0x1f>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    11a8:	e8 10 03 00 00       	call   14bd <texit>

000011ad <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11ad:	55                   	push   %ebp
    11ae:	89 e5                	mov    %esp,%ebp
    11b0:	57                   	push   %edi
    11b1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11b5:	8b 55 10             	mov    0x10(%ebp),%edx
    11b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11bb:	89 cb                	mov    %ecx,%ebx
    11bd:	89 df                	mov    %ebx,%edi
    11bf:	89 d1                	mov    %edx,%ecx
    11c1:	fc                   	cld    
    11c2:	f3 aa                	rep stos %al,%es:(%edi)
    11c4:	89 ca                	mov    %ecx,%edx
    11c6:	89 fb                	mov    %edi,%ebx
    11c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11ce:	5b                   	pop    %ebx
    11cf:	5f                   	pop    %edi
    11d0:	5d                   	pop    %ebp
    11d1:	c3                   	ret    

000011d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11d2:	55                   	push   %ebp
    11d3:	89 e5                	mov    %esp,%ebp
    11d5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11d8:	8b 45 08             	mov    0x8(%ebp),%eax
    11db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    11de:	90                   	nop
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
    11e2:	8d 50 01             	lea    0x1(%eax),%edx
    11e5:	89 55 08             	mov    %edx,0x8(%ebp)
    11e8:	8b 55 0c             	mov    0xc(%ebp),%edx
    11eb:	8d 4a 01             	lea    0x1(%edx),%ecx
    11ee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    11f1:	0f b6 12             	movzbl (%edx),%edx
    11f4:	88 10                	mov    %dl,(%eax)
    11f6:	0f b6 00             	movzbl (%eax),%eax
    11f9:	84 c0                	test   %al,%al
    11fb:	75 e2                	jne    11df <strcpy+0xd>
    ;
  return os;
    11fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1200:	c9                   	leave  
    1201:	c3                   	ret    

00001202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1202:	55                   	push   %ebp
    1203:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1205:	eb 08                	jmp    120f <strcmp+0xd>
    p++, q++;
    1207:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    120b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	0f b6 00             	movzbl (%eax),%eax
    1215:	84 c0                	test   %al,%al
    1217:	74 10                	je     1229 <strcmp+0x27>
    1219:	8b 45 08             	mov    0x8(%ebp),%eax
    121c:	0f b6 10             	movzbl (%eax),%edx
    121f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1222:	0f b6 00             	movzbl (%eax),%eax
    1225:	38 c2                	cmp    %al,%dl
    1227:	74 de                	je     1207 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1229:	8b 45 08             	mov    0x8(%ebp),%eax
    122c:	0f b6 00             	movzbl (%eax),%eax
    122f:	0f b6 d0             	movzbl %al,%edx
    1232:	8b 45 0c             	mov    0xc(%ebp),%eax
    1235:	0f b6 00             	movzbl (%eax),%eax
    1238:	0f b6 c0             	movzbl %al,%eax
    123b:	29 c2                	sub    %eax,%edx
    123d:	89 d0                	mov    %edx,%eax
}
    123f:	5d                   	pop    %ebp
    1240:	c3                   	ret    

00001241 <strlen>:

uint
strlen(char *s)
{
    1241:	55                   	push   %ebp
    1242:	89 e5                	mov    %esp,%ebp
    1244:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1247:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    124e:	eb 04                	jmp    1254 <strlen+0x13>
    1250:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1254:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1257:	8b 45 08             	mov    0x8(%ebp),%eax
    125a:	01 d0                	add    %edx,%eax
    125c:	0f b6 00             	movzbl (%eax),%eax
    125f:	84 c0                	test   %al,%al
    1261:	75 ed                	jne    1250 <strlen+0xf>
    ;
  return n;
    1263:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1266:	c9                   	leave  
    1267:	c3                   	ret    

00001268 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1268:	55                   	push   %ebp
    1269:	89 e5                	mov    %esp,%ebp
    126b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    126e:	8b 45 10             	mov    0x10(%ebp),%eax
    1271:	89 44 24 08          	mov    %eax,0x8(%esp)
    1275:	8b 45 0c             	mov    0xc(%ebp),%eax
    1278:	89 44 24 04          	mov    %eax,0x4(%esp)
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
    127f:	89 04 24             	mov    %eax,(%esp)
    1282:	e8 26 ff ff ff       	call   11ad <stosb>
  return dst;
    1287:	8b 45 08             	mov    0x8(%ebp),%eax
}
    128a:	c9                   	leave  
    128b:	c3                   	ret    

0000128c <strchr>:

char*
strchr(const char *s, char c)
{
    128c:	55                   	push   %ebp
    128d:	89 e5                	mov    %esp,%ebp
    128f:	83 ec 04             	sub    $0x4,%esp
    1292:	8b 45 0c             	mov    0xc(%ebp),%eax
    1295:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1298:	eb 14                	jmp    12ae <strchr+0x22>
    if(*s == c)
    129a:	8b 45 08             	mov    0x8(%ebp),%eax
    129d:	0f b6 00             	movzbl (%eax),%eax
    12a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12a3:	75 05                	jne    12aa <strchr+0x1e>
      return (char*)s;
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	eb 13                	jmp    12bd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12ae:	8b 45 08             	mov    0x8(%ebp),%eax
    12b1:	0f b6 00             	movzbl (%eax),%eax
    12b4:	84 c0                	test   %al,%al
    12b6:	75 e2                	jne    129a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12bd:	c9                   	leave  
    12be:	c3                   	ret    

000012bf <gets>:

char*
gets(char *buf, int max)
{
    12bf:	55                   	push   %ebp
    12c0:	89 e5                	mov    %esp,%ebp
    12c2:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12cc:	eb 4c                	jmp    131a <gets+0x5b>
    cc = read(0, &c, 1);
    12ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12d5:	00 
    12d6:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    12dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    12e4:	e8 44 01 00 00       	call   142d <read>
    12e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    12ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12f0:	7f 02                	jg     12f4 <gets+0x35>
      break;
    12f2:	eb 31                	jmp    1325 <gets+0x66>
    buf[i++] = c;
    12f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f7:	8d 50 01             	lea    0x1(%eax),%edx
    12fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
    12fd:	89 c2                	mov    %eax,%edx
    12ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1302:	01 c2                	add    %eax,%edx
    1304:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1308:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    130a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    130e:	3c 0a                	cmp    $0xa,%al
    1310:	74 13                	je     1325 <gets+0x66>
    1312:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1316:	3c 0d                	cmp    $0xd,%al
    1318:	74 0b                	je     1325 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    131a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131d:	83 c0 01             	add    $0x1,%eax
    1320:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1323:	7c a9                	jl     12ce <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1325:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1328:	8b 45 08             	mov    0x8(%ebp),%eax
    132b:	01 d0                	add    %edx,%eax
    132d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1330:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1333:	c9                   	leave  
    1334:	c3                   	ret    

00001335 <stat>:

int
stat(char *n, struct stat *st)
{
    1335:	55                   	push   %ebp
    1336:	89 e5                	mov    %esp,%ebp
    1338:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    133b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1342:	00 
    1343:	8b 45 08             	mov    0x8(%ebp),%eax
    1346:	89 04 24             	mov    %eax,(%esp)
    1349:	e8 07 01 00 00       	call   1455 <open>
    134e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1355:	79 07                	jns    135e <stat+0x29>
    return -1;
    1357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    135c:	eb 23                	jmp    1381 <stat+0x4c>
  r = fstat(fd, st);
    135e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1361:	89 44 24 04          	mov    %eax,0x4(%esp)
    1365:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1368:	89 04 24             	mov    %eax,(%esp)
    136b:	e8 fd 00 00 00       	call   146d <fstat>
    1370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1373:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1376:	89 04 24             	mov    %eax,(%esp)
    1379:	e8 bf 00 00 00       	call   143d <close>
  return r;
    137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1381:	c9                   	leave  
    1382:	c3                   	ret    

00001383 <atoi>:

int
atoi(const char *s)
{
    1383:	55                   	push   %ebp
    1384:	89 e5                	mov    %esp,%ebp
    1386:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1390:	eb 25                	jmp    13b7 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1392:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1395:	89 d0                	mov    %edx,%eax
    1397:	c1 e0 02             	shl    $0x2,%eax
    139a:	01 d0                	add    %edx,%eax
    139c:	01 c0                	add    %eax,%eax
    139e:	89 c1                	mov    %eax,%ecx
    13a0:	8b 45 08             	mov    0x8(%ebp),%eax
    13a3:	8d 50 01             	lea    0x1(%eax),%edx
    13a6:	89 55 08             	mov    %edx,0x8(%ebp)
    13a9:	0f b6 00             	movzbl (%eax),%eax
    13ac:	0f be c0             	movsbl %al,%eax
    13af:	01 c8                	add    %ecx,%eax
    13b1:	83 e8 30             	sub    $0x30,%eax
    13b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13b7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ba:	0f b6 00             	movzbl (%eax),%eax
    13bd:	3c 2f                	cmp    $0x2f,%al
    13bf:	7e 0a                	jle    13cb <atoi+0x48>
    13c1:	8b 45 08             	mov    0x8(%ebp),%eax
    13c4:	0f b6 00             	movzbl (%eax),%eax
    13c7:	3c 39                	cmp    $0x39,%al
    13c9:	7e c7                	jle    1392 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13ce:	c9                   	leave  
    13cf:	c3                   	ret    

000013d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13d6:	8b 45 08             	mov    0x8(%ebp),%eax
    13d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    13df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13e2:	eb 17                	jmp    13fb <memmove+0x2b>
    *dst++ = *src++;
    13e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e7:	8d 50 01             	lea    0x1(%eax),%edx
    13ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13f0:	8d 4a 01             	lea    0x1(%edx),%ecx
    13f3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13f6:	0f b6 12             	movzbl (%edx),%edx
    13f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13fb:	8b 45 10             	mov    0x10(%ebp),%eax
    13fe:	8d 50 ff             	lea    -0x1(%eax),%edx
    1401:	89 55 10             	mov    %edx,0x10(%ebp)
    1404:	85 c0                	test   %eax,%eax
    1406:	7f dc                	jg     13e4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1408:	8b 45 08             	mov    0x8(%ebp),%eax
}
    140b:	c9                   	leave  
    140c:	c3                   	ret    

0000140d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    140d:	b8 01 00 00 00       	mov    $0x1,%eax
    1412:	cd 40                	int    $0x40
    1414:	c3                   	ret    

00001415 <exit>:
SYSCALL(exit)
    1415:	b8 02 00 00 00       	mov    $0x2,%eax
    141a:	cd 40                	int    $0x40
    141c:	c3                   	ret    

0000141d <wait>:
SYSCALL(wait)
    141d:	b8 03 00 00 00       	mov    $0x3,%eax
    1422:	cd 40                	int    $0x40
    1424:	c3                   	ret    

00001425 <pipe>:
SYSCALL(pipe)
    1425:	b8 04 00 00 00       	mov    $0x4,%eax
    142a:	cd 40                	int    $0x40
    142c:	c3                   	ret    

0000142d <read>:
SYSCALL(read)
    142d:	b8 05 00 00 00       	mov    $0x5,%eax
    1432:	cd 40                	int    $0x40
    1434:	c3                   	ret    

00001435 <write>:
SYSCALL(write)
    1435:	b8 10 00 00 00       	mov    $0x10,%eax
    143a:	cd 40                	int    $0x40
    143c:	c3                   	ret    

0000143d <close>:
SYSCALL(close)
    143d:	b8 15 00 00 00       	mov    $0x15,%eax
    1442:	cd 40                	int    $0x40
    1444:	c3                   	ret    

00001445 <kill>:
SYSCALL(kill)
    1445:	b8 06 00 00 00       	mov    $0x6,%eax
    144a:	cd 40                	int    $0x40
    144c:	c3                   	ret    

0000144d <exec>:
SYSCALL(exec)
    144d:	b8 07 00 00 00       	mov    $0x7,%eax
    1452:	cd 40                	int    $0x40
    1454:	c3                   	ret    

00001455 <open>:
SYSCALL(open)
    1455:	b8 0f 00 00 00       	mov    $0xf,%eax
    145a:	cd 40                	int    $0x40
    145c:	c3                   	ret    

0000145d <mknod>:
SYSCALL(mknod)
    145d:	b8 11 00 00 00       	mov    $0x11,%eax
    1462:	cd 40                	int    $0x40
    1464:	c3                   	ret    

00001465 <unlink>:
SYSCALL(unlink)
    1465:	b8 12 00 00 00       	mov    $0x12,%eax
    146a:	cd 40                	int    $0x40
    146c:	c3                   	ret    

0000146d <fstat>:
SYSCALL(fstat)
    146d:	b8 08 00 00 00       	mov    $0x8,%eax
    1472:	cd 40                	int    $0x40
    1474:	c3                   	ret    

00001475 <link>:
SYSCALL(link)
    1475:	b8 13 00 00 00       	mov    $0x13,%eax
    147a:	cd 40                	int    $0x40
    147c:	c3                   	ret    

0000147d <mkdir>:
SYSCALL(mkdir)
    147d:	b8 14 00 00 00       	mov    $0x14,%eax
    1482:	cd 40                	int    $0x40
    1484:	c3                   	ret    

00001485 <chdir>:
SYSCALL(chdir)
    1485:	b8 09 00 00 00       	mov    $0x9,%eax
    148a:	cd 40                	int    $0x40
    148c:	c3                   	ret    

0000148d <dup>:
SYSCALL(dup)
    148d:	b8 0a 00 00 00       	mov    $0xa,%eax
    1492:	cd 40                	int    $0x40
    1494:	c3                   	ret    

00001495 <getpid>:
SYSCALL(getpid)
    1495:	b8 0b 00 00 00       	mov    $0xb,%eax
    149a:	cd 40                	int    $0x40
    149c:	c3                   	ret    

0000149d <sbrk>:
SYSCALL(sbrk)
    149d:	b8 0c 00 00 00       	mov    $0xc,%eax
    14a2:	cd 40                	int    $0x40
    14a4:	c3                   	ret    

000014a5 <sleep>:
SYSCALL(sleep)
    14a5:	b8 0d 00 00 00       	mov    $0xd,%eax
    14aa:	cd 40                	int    $0x40
    14ac:	c3                   	ret    

000014ad <uptime>:
SYSCALL(uptime)
    14ad:	b8 0e 00 00 00       	mov    $0xe,%eax
    14b2:	cd 40                	int    $0x40
    14b4:	c3                   	ret    

000014b5 <clone>:
SYSCALL(clone)
    14b5:	b8 16 00 00 00       	mov    $0x16,%eax
    14ba:	cd 40                	int    $0x40
    14bc:	c3                   	ret    

000014bd <texit>:
SYSCALL(texit)
    14bd:	b8 17 00 00 00       	mov    $0x17,%eax
    14c2:	cd 40                	int    $0x40
    14c4:	c3                   	ret    

000014c5 <tsleep>:
SYSCALL(tsleep)
    14c5:	b8 18 00 00 00       	mov    $0x18,%eax
    14ca:	cd 40                	int    $0x40
    14cc:	c3                   	ret    

000014cd <twakeup>:
SYSCALL(twakeup)
    14cd:	b8 19 00 00 00       	mov    $0x19,%eax
    14d2:	cd 40                	int    $0x40
    14d4:	c3                   	ret    

000014d5 <thread_yield>:
SYSCALL(thread_yield)
    14d5:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14da:	cd 40                	int    $0x40
    14dc:	c3                   	ret    

000014dd <thread_yield3>:
    14dd:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14e2:	cd 40                	int    $0x40
    14e4:	c3                   	ret    

000014e5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14e5:	55                   	push   %ebp
    14e6:	89 e5                	mov    %esp,%ebp
    14e8:	83 ec 18             	sub    $0x18,%esp
    14eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    14ee:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14f8:	00 
    14f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1500:	8b 45 08             	mov    0x8(%ebp),%eax
    1503:	89 04 24             	mov    %eax,(%esp)
    1506:	e8 2a ff ff ff       	call   1435 <write>
}
    150b:	c9                   	leave  
    150c:	c3                   	ret    

0000150d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    150d:	55                   	push   %ebp
    150e:	89 e5                	mov    %esp,%ebp
    1510:	56                   	push   %esi
    1511:	53                   	push   %ebx
    1512:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1515:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    151c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1520:	74 17                	je     1539 <printint+0x2c>
    1522:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1526:	79 11                	jns    1539 <printint+0x2c>
    neg = 1;
    1528:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    152f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1532:	f7 d8                	neg    %eax
    1534:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1537:	eb 06                	jmp    153f <printint+0x32>
  } else {
    x = xx;
    1539:	8b 45 0c             	mov    0xc(%ebp),%eax
    153c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    153f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1546:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1549:	8d 41 01             	lea    0x1(%ecx),%eax
    154c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    154f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1552:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1555:	ba 00 00 00 00       	mov    $0x0,%edx
    155a:	f7 f3                	div    %ebx
    155c:	89 d0                	mov    %edx,%eax
    155e:	0f b6 80 dc 21 00 00 	movzbl 0x21dc(%eax),%eax
    1565:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1569:	8b 75 10             	mov    0x10(%ebp),%esi
    156c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    156f:	ba 00 00 00 00       	mov    $0x0,%edx
    1574:	f7 f6                	div    %esi
    1576:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1579:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    157d:	75 c7                	jne    1546 <printint+0x39>
  if(neg)
    157f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1583:	74 10                	je     1595 <printint+0x88>
    buf[i++] = '-';
    1585:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1588:	8d 50 01             	lea    0x1(%eax),%edx
    158b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    158e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1593:	eb 1f                	jmp    15b4 <printint+0xa7>
    1595:	eb 1d                	jmp    15b4 <printint+0xa7>
    putc(fd, buf[i]);
    1597:	8d 55 dc             	lea    -0x24(%ebp),%edx
    159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159d:	01 d0                	add    %edx,%eax
    159f:	0f b6 00             	movzbl (%eax),%eax
    15a2:	0f be c0             	movsbl %al,%eax
    15a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a9:	8b 45 08             	mov    0x8(%ebp),%eax
    15ac:	89 04 24             	mov    %eax,(%esp)
    15af:	e8 31 ff ff ff       	call   14e5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15b4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15bc:	79 d9                	jns    1597 <printint+0x8a>
    putc(fd, buf[i]);
}
    15be:	83 c4 30             	add    $0x30,%esp
    15c1:	5b                   	pop    %ebx
    15c2:	5e                   	pop    %esi
    15c3:	5d                   	pop    %ebp
    15c4:	c3                   	ret    

000015c5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15c5:	55                   	push   %ebp
    15c6:	89 e5                	mov    %esp,%ebp
    15c8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d2:	8d 45 0c             	lea    0xc(%ebp),%eax
    15d5:	83 c0 04             	add    $0x4,%eax
    15d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e2:	e9 7c 01 00 00       	jmp    1763 <printf+0x19e>
    c = fmt[i] & 0xff;
    15e7:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15ed:	01 d0                	add    %edx,%eax
    15ef:	0f b6 00             	movzbl (%eax),%eax
    15f2:	0f be c0             	movsbl %al,%eax
    15f5:	25 ff 00 00 00       	and    $0xff,%eax
    15fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    15fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1601:	75 2c                	jne    162f <printf+0x6a>
      if(c == '%'){
    1603:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1607:	75 0c                	jne    1615 <printf+0x50>
        state = '%';
    1609:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1610:	e9 4a 01 00 00       	jmp    175f <printf+0x19a>
      } else {
        putc(fd, c);
    1615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1618:	0f be c0             	movsbl %al,%eax
    161b:	89 44 24 04          	mov    %eax,0x4(%esp)
    161f:	8b 45 08             	mov    0x8(%ebp),%eax
    1622:	89 04 24             	mov    %eax,(%esp)
    1625:	e8 bb fe ff ff       	call   14e5 <putc>
    162a:	e9 30 01 00 00       	jmp    175f <printf+0x19a>
      }
    } else if(state == '%'){
    162f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1633:	0f 85 26 01 00 00    	jne    175f <printf+0x19a>
      if(c == 'd'){
    1639:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    163d:	75 2d                	jne    166c <printf+0xa7>
        printint(fd, *ap, 10, 1);
    163f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1642:	8b 00                	mov    (%eax),%eax
    1644:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    164b:	00 
    164c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1653:	00 
    1654:	89 44 24 04          	mov    %eax,0x4(%esp)
    1658:	8b 45 08             	mov    0x8(%ebp),%eax
    165b:	89 04 24             	mov    %eax,(%esp)
    165e:	e8 aa fe ff ff       	call   150d <printint>
        ap++;
    1663:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1667:	e9 ec 00 00 00       	jmp    1758 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    166c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1670:	74 06                	je     1678 <printf+0xb3>
    1672:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1676:	75 2d                	jne    16a5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1678:	8b 45 e8             	mov    -0x18(%ebp),%eax
    167b:	8b 00                	mov    (%eax),%eax
    167d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1684:	00 
    1685:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    168c:	00 
    168d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1691:	8b 45 08             	mov    0x8(%ebp),%eax
    1694:	89 04 24             	mov    %eax,(%esp)
    1697:	e8 71 fe ff ff       	call   150d <printint>
        ap++;
    169c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16a0:	e9 b3 00 00 00       	jmp    1758 <printf+0x193>
      } else if(c == 's'){
    16a5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16a9:	75 45                	jne    16f0 <printf+0x12b>
        s = (char*)*ap;
    16ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16ae:	8b 00                	mov    (%eax),%eax
    16b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16bb:	75 09                	jne    16c6 <printf+0x101>
          s = "(null)";
    16bd:	c7 45 f4 72 1d 00 00 	movl   $0x1d72,-0xc(%ebp)
        while(*s != 0){
    16c4:	eb 1e                	jmp    16e4 <printf+0x11f>
    16c6:	eb 1c                	jmp    16e4 <printf+0x11f>
          putc(fd, *s);
    16c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cb:	0f b6 00             	movzbl (%eax),%eax
    16ce:	0f be c0             	movsbl %al,%eax
    16d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    16d5:	8b 45 08             	mov    0x8(%ebp),%eax
    16d8:	89 04 24             	mov    %eax,(%esp)
    16db:	e8 05 fe ff ff       	call   14e5 <putc>
          s++;
    16e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e7:	0f b6 00             	movzbl (%eax),%eax
    16ea:	84 c0                	test   %al,%al
    16ec:	75 da                	jne    16c8 <printf+0x103>
    16ee:	eb 68                	jmp    1758 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16f0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16f4:	75 1d                	jne    1713 <printf+0x14e>
        putc(fd, *ap);
    16f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16f9:	8b 00                	mov    (%eax),%eax
    16fb:	0f be c0             	movsbl %al,%eax
    16fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1702:	8b 45 08             	mov    0x8(%ebp),%eax
    1705:	89 04 24             	mov    %eax,(%esp)
    1708:	e8 d8 fd ff ff       	call   14e5 <putc>
        ap++;
    170d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1711:	eb 45                	jmp    1758 <printf+0x193>
      } else if(c == '%'){
    1713:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1717:	75 17                	jne    1730 <printf+0x16b>
        putc(fd, c);
    1719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    171c:	0f be c0             	movsbl %al,%eax
    171f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1723:	8b 45 08             	mov    0x8(%ebp),%eax
    1726:	89 04 24             	mov    %eax,(%esp)
    1729:	e8 b7 fd ff ff       	call   14e5 <putc>
    172e:	eb 28                	jmp    1758 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1730:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1737:	00 
    1738:	8b 45 08             	mov    0x8(%ebp),%eax
    173b:	89 04 24             	mov    %eax,(%esp)
    173e:	e8 a2 fd ff ff       	call   14e5 <putc>
        putc(fd, c);
    1743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1746:	0f be c0             	movsbl %al,%eax
    1749:	89 44 24 04          	mov    %eax,0x4(%esp)
    174d:	8b 45 08             	mov    0x8(%ebp),%eax
    1750:	89 04 24             	mov    %eax,(%esp)
    1753:	e8 8d fd ff ff       	call   14e5 <putc>
      }
      state = 0;
    1758:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    175f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1763:	8b 55 0c             	mov    0xc(%ebp),%edx
    1766:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1769:	01 d0                	add    %edx,%eax
    176b:	0f b6 00             	movzbl (%eax),%eax
    176e:	84 c0                	test   %al,%al
    1770:	0f 85 71 fe ff ff    	jne    15e7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1776:	c9                   	leave  
    1777:	c3                   	ret    

00001778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1778:	55                   	push   %ebp
    1779:	89 e5                	mov    %esp,%ebp
    177b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    177e:	8b 45 08             	mov    0x8(%ebp),%eax
    1781:	83 e8 08             	sub    $0x8,%eax
    1784:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1787:	a1 08 22 00 00       	mov    0x2208,%eax
    178c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    178f:	eb 24                	jmp    17b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1791:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1794:	8b 00                	mov    (%eax),%eax
    1796:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1799:	77 12                	ja     17ad <free+0x35>
    179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17a1:	77 24                	ja     17c7 <free+0x4f>
    17a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a6:	8b 00                	mov    (%eax),%eax
    17a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17ab:	77 1a                	ja     17c7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b0:	8b 00                	mov    (%eax),%eax
    17b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17bb:	76 d4                	jbe    1791 <free+0x19>
    17bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c0:	8b 00                	mov    (%eax),%eax
    17c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c5:	76 ca                	jbe    1791 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ca:	8b 40 04             	mov    0x4(%eax),%eax
    17cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d7:	01 c2                	add    %eax,%edx
    17d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dc:	8b 00                	mov    (%eax),%eax
    17de:	39 c2                	cmp    %eax,%edx
    17e0:	75 24                	jne    1806 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e5:	8b 50 04             	mov    0x4(%eax),%edx
    17e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17eb:	8b 00                	mov    (%eax),%eax
    17ed:	8b 40 04             	mov    0x4(%eax),%eax
    17f0:	01 c2                	add    %eax,%edx
    17f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17fb:	8b 00                	mov    (%eax),%eax
    17fd:	8b 10                	mov    (%eax),%edx
    17ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1802:	89 10                	mov    %edx,(%eax)
    1804:	eb 0a                	jmp    1810 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1806:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1809:	8b 10                	mov    (%eax),%edx
    180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    180e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1810:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1813:	8b 40 04             	mov    0x4(%eax),%eax
    1816:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    181d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1820:	01 d0                	add    %edx,%eax
    1822:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1825:	75 20                	jne    1847 <free+0xcf>
    p->s.size += bp->s.size;
    1827:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182a:	8b 50 04             	mov    0x4(%eax),%edx
    182d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1830:	8b 40 04             	mov    0x4(%eax),%eax
    1833:	01 c2                	add    %eax,%edx
    1835:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1838:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    183b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    183e:	8b 10                	mov    (%eax),%edx
    1840:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1843:	89 10                	mov    %edx,(%eax)
    1845:	eb 08                	jmp    184f <free+0xd7>
  } else
    p->s.ptr = bp;
    1847:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    184d:	89 10                	mov    %edx,(%eax)
  freep = p;
    184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1852:	a3 08 22 00 00       	mov    %eax,0x2208
}
    1857:	c9                   	leave  
    1858:	c3                   	ret    

00001859 <morecore>:

static Header*
morecore(uint nu)
{
    1859:	55                   	push   %ebp
    185a:	89 e5                	mov    %esp,%ebp
    185c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    185f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1866:	77 07                	ja     186f <morecore+0x16>
    nu = 4096;
    1868:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    186f:	8b 45 08             	mov    0x8(%ebp),%eax
    1872:	c1 e0 03             	shl    $0x3,%eax
    1875:	89 04 24             	mov    %eax,(%esp)
    1878:	e8 20 fc ff ff       	call   149d <sbrk>
    187d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1880:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1884:	75 07                	jne    188d <morecore+0x34>
    return 0;
    1886:	b8 00 00 00 00       	mov    $0x0,%eax
    188b:	eb 22                	jmp    18af <morecore+0x56>
  hp = (Header*)p;
    188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1893:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1896:	8b 55 08             	mov    0x8(%ebp),%edx
    1899:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189f:	83 c0 08             	add    $0x8,%eax
    18a2:	89 04 24             	mov    %eax,(%esp)
    18a5:	e8 ce fe ff ff       	call   1778 <free>
  return freep;
    18aa:	a1 08 22 00 00       	mov    0x2208,%eax
}
    18af:	c9                   	leave  
    18b0:	c3                   	ret    

000018b1 <malloc>:

void*
malloc(uint nbytes)
{
    18b1:	55                   	push   %ebp
    18b2:	89 e5                	mov    %esp,%ebp
    18b4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18b7:	8b 45 08             	mov    0x8(%ebp),%eax
    18ba:	83 c0 07             	add    $0x7,%eax
    18bd:	c1 e8 03             	shr    $0x3,%eax
    18c0:	83 c0 01             	add    $0x1,%eax
    18c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18c6:	a1 08 22 00 00       	mov    0x2208,%eax
    18cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18d2:	75 23                	jne    18f7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18d4:	c7 45 f0 00 22 00 00 	movl   $0x2200,-0x10(%ebp)
    18db:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18de:	a3 08 22 00 00       	mov    %eax,0x2208
    18e3:	a1 08 22 00 00       	mov    0x2208,%eax
    18e8:	a3 00 22 00 00       	mov    %eax,0x2200
    base.s.size = 0;
    18ed:	c7 05 04 22 00 00 00 	movl   $0x0,0x2204
    18f4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18fa:	8b 00                	mov    (%eax),%eax
    18fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1902:	8b 40 04             	mov    0x4(%eax),%eax
    1905:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1908:	72 4d                	jb     1957 <malloc+0xa6>
      if(p->s.size == nunits)
    190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190d:	8b 40 04             	mov    0x4(%eax),%eax
    1910:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1913:	75 0c                	jne    1921 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1915:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1918:	8b 10                	mov    (%eax),%edx
    191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    191d:	89 10                	mov    %edx,(%eax)
    191f:	eb 26                	jmp    1947 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1921:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1924:	8b 40 04             	mov    0x4(%eax),%eax
    1927:	2b 45 ec             	sub    -0x14(%ebp),%eax
    192a:	89 c2                	mov    %eax,%edx
    192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1932:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1935:	8b 40 04             	mov    0x4(%eax),%eax
    1938:	c1 e0 03             	shl    $0x3,%eax
    193b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    193e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1941:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1944:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1947:	8b 45 f0             	mov    -0x10(%ebp),%eax
    194a:	a3 08 22 00 00       	mov    %eax,0x2208
      return (void*)(p + 1);
    194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1952:	83 c0 08             	add    $0x8,%eax
    1955:	eb 38                	jmp    198f <malloc+0xde>
    }
    if(p == freep)
    1957:	a1 08 22 00 00       	mov    0x2208,%eax
    195c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    195f:	75 1b                	jne    197c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1961:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1964:	89 04 24             	mov    %eax,(%esp)
    1967:	e8 ed fe ff ff       	call   1859 <morecore>
    196c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    196f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1973:	75 07                	jne    197c <malloc+0xcb>
        return 0;
    1975:	b8 00 00 00 00       	mov    $0x0,%eax
    197a:	eb 13                	jmp    198f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1982:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1985:	8b 00                	mov    (%eax),%eax
    1987:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    198a:	e9 70 ff ff ff       	jmp    18ff <malloc+0x4e>
}
    198f:	c9                   	leave  
    1990:	c3                   	ret    

00001991 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1991:	55                   	push   %ebp
    1992:	89 e5                	mov    %esp,%ebp
    1994:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1997:	8b 55 08             	mov    0x8(%ebp),%edx
    199a:	8b 45 0c             	mov    0xc(%ebp),%eax
    199d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19a0:	f0 87 02             	lock xchg %eax,(%edx)
    19a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    19a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    19a9:	c9                   	leave  
    19aa:	c3                   	ret    

000019ab <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    19ab:	55                   	push   %ebp
    19ac:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    19ae:	8b 45 08             	mov    0x8(%ebp),%eax
    19b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    19b7:	5d                   	pop    %ebp
    19b8:	c3                   	ret    

000019b9 <lock_acquire>:
void lock_acquire(lock_t *lock){
    19b9:	55                   	push   %ebp
    19ba:	89 e5                	mov    %esp,%ebp
    19bc:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    19bf:	90                   	nop
    19c0:	8b 45 08             	mov    0x8(%ebp),%eax
    19c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    19ca:	00 
    19cb:	89 04 24             	mov    %eax,(%esp)
    19ce:	e8 be ff ff ff       	call   1991 <xchg>
    19d3:	85 c0                	test   %eax,%eax
    19d5:	75 e9                	jne    19c0 <lock_acquire+0x7>
}
    19d7:	c9                   	leave  
    19d8:	c3                   	ret    

000019d9 <lock_release>:
void lock_release(lock_t *lock){
    19d9:	55                   	push   %ebp
    19da:	89 e5                	mov    %esp,%ebp
    19dc:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    19df:	8b 45 08             	mov    0x8(%ebp),%eax
    19e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19e9:	00 
    19ea:	89 04 24             	mov    %eax,(%esp)
    19ed:	e8 9f ff ff ff       	call   1991 <xchg>
}
    19f2:	c9                   	leave  
    19f3:	c3                   	ret    

000019f4 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    19f4:	55                   	push   %ebp
    19f5:	89 e5                	mov    %esp,%ebp
    19f7:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    19fa:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1a01:	e8 ab fe ff ff       	call   18b1 <malloc>
    1a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1a0f:	0f b6 05 0c 22 00 00 	movzbl 0x220c,%eax
    1a16:	84 c0                	test   %al,%al
    1a18:	75 1c                	jne    1a36 <thread_create+0x42>
        init_q(thQ2);
    1a1a:	a1 28 23 00 00       	mov    0x2328,%eax
    1a1f:	89 04 24             	mov    %eax,(%esp)
    1a22:	e8 cd 01 00 00       	call   1bf4 <init_q>
        inQ++;
    1a27:	0f b6 05 0c 22 00 00 	movzbl 0x220c,%eax
    1a2e:	83 c0 01             	add    $0x1,%eax
    1a31:	a2 0c 22 00 00       	mov    %al,0x220c
    }

    if((uint)stack % 4096){
    1a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a39:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a3e:	85 c0                	test   %eax,%eax
    1a40:	74 14                	je     1a56 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a45:	25 ff 0f 00 00       	and    $0xfff,%eax
    1a4a:	89 c2                	mov    %eax,%edx
    1a4c:	b8 00 10 00 00       	mov    $0x1000,%eax
    1a51:	29 d0                	sub    %edx,%eax
    1a53:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a5a:	75 1e                	jne    1a7a <thread_create+0x86>

        printf(1,"malloc fail \n");
    1a5c:	c7 44 24 04 79 1d 00 	movl   $0x1d79,0x4(%esp)
    1a63:	00 
    1a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a6b:	e8 55 fb ff ff       	call   15c5 <printf>
        return 0;
    1a70:	b8 00 00 00 00       	mov    $0x0,%eax
    1a75:	e9 9e 00 00 00       	jmp    1b18 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1a7d:	8b 55 08             	mov    0x8(%ebp),%edx
    1a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1a87:	89 54 24 08          	mov    %edx,0x8(%esp)
    1a8b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a92:	00 
    1a93:	89 04 24             	mov    %eax,(%esp)
    1a96:	e8 1a fa ff ff       	call   14b5 <clone>
    1a9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aa1:	89 44 24 08          	mov    %eax,0x8(%esp)
    1aa5:	c7 44 24 04 87 1d 00 	movl   $0x1d87,0x4(%esp)
    1aac:	00 
    1aad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ab4:	e8 0c fb ff ff       	call   15c5 <printf>
    if(tid < 0){
    1ab9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1abd:	79 1b                	jns    1ada <thread_create+0xe6>
        printf(1,"clone fails\n");
    1abf:	c7 44 24 04 a0 1d 00 	movl   $0x1da0,0x4(%esp)
    1ac6:	00 
    1ac7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ace:	e8 f2 fa ff ff       	call   15c5 <printf>
        return 0;
    1ad3:	b8 00 00 00 00       	mov    $0x0,%eax
    1ad8:	eb 3e                	jmp    1b18 <thread_create+0x124>
    }
    if(tid > 0){
    1ada:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ade:	7e 19                	jle    1af9 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1ae0:	a1 28 23 00 00       	mov    0x2328,%eax
    1ae5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
    1aec:	89 04 24             	mov    %eax,(%esp)
    1aef:	e8 22 01 00 00       	call   1c16 <add_q>
        return garbage_stack;
    1af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1af7:	eb 1f                	jmp    1b18 <thread_create+0x124>
    }
    if(tid == 0){
    1af9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1afd:	75 14                	jne    1b13 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1aff:	c7 44 24 04 ad 1d 00 	movl   $0x1dad,0x4(%esp)
    1b06:	00 
    1b07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b0e:	e8 b2 fa ff ff       	call   15c5 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1b18:	c9                   	leave  
    1b19:	c3                   	ret    

00001b1a <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1b1a:	55                   	push   %ebp
    1b1b:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1b1d:	a1 f0 21 00 00       	mov    0x21f0,%eax
    1b22:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1b28:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1b2d:	a3 f0 21 00 00       	mov    %eax,0x21f0
    return (int)(rands % max);
    1b32:	a1 f0 21 00 00       	mov    0x21f0,%eax
    1b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b3a:	ba 00 00 00 00       	mov    $0x0,%edx
    1b3f:	f7 f1                	div    %ecx
    1b41:	89 d0                	mov    %edx,%eax
}
    1b43:	5d                   	pop    %ebp
    1b44:	c3                   	ret    

00001b45 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1b45:	55                   	push   %ebp
    1b46:	89 e5                	mov    %esp,%ebp
    1b48:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1b4b:	e8 45 f9 ff ff       	call   1495 <getpid>
    1b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1b53:	a1 28 23 00 00       	mov    0x2328,%eax
    1b58:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1b5b:	89 54 24 04          	mov    %edx,0x4(%esp)
    1b5f:	89 04 24             	mov    %eax,(%esp)
    1b62:	e8 af 00 00 00       	call   1c16 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1b67:	a1 28 23 00 00       	mov    0x2328,%eax
    1b6c:	89 04 24             	mov    %eax,(%esp)
    1b6f:	e8 1c 01 00 00       	call   1c90 <pop_q>
    1b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1b77:	a1 10 22 00 00       	mov    0x2210,%eax
    1b7c:	85 c0                	test   %eax,%eax
    1b7e:	75 1f                	jne    1b9f <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1b80:	a1 28 23 00 00       	mov    0x2328,%eax
    1b85:	89 04 24             	mov    %eax,(%esp)
    1b88:	e8 03 01 00 00       	call   1c90 <pop_q>
    1b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1b90:	a1 10 22 00 00       	mov    0x2210,%eax
    1b95:	83 c0 01             	add    $0x1,%eax
    1b98:	a3 10 22 00 00       	mov    %eax,0x2210
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1b9d:	eb 12                	jmp    1bb1 <thread_yield2+0x6c>
    1b9f:	eb 10                	jmp    1bb1 <thread_yield2+0x6c>
    1ba1:	a1 28 23 00 00       	mov    0x2328,%eax
    1ba6:	89 04 24             	mov    %eax,(%esp)
    1ba9:	e8 e2 00 00 00       	call   1c90 <pop_q>
    1bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1bb7:	74 e8                	je     1ba1 <thread_yield2+0x5c>
    1bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bbd:	74 e2                	je     1ba1 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc2:	89 04 24             	mov    %eax,(%esp)
    1bc5:	e8 03 f9 ff ff       	call   14cd <twakeup>
    tsleep();
    1bca:	e8 f6 f8 ff ff       	call   14c5 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1bcf:	c9                   	leave  
    1bd0:	c3                   	ret    

00001bd1 <thread_yield_last>:

void thread_yield_last(){
    1bd1:	55                   	push   %ebp
    1bd2:	89 e5                	mov    %esp,%ebp
    1bd4:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1bd7:	a1 28 23 00 00       	mov    0x2328,%eax
    1bdc:	89 04 24             	mov    %eax,(%esp)
    1bdf:	e8 ac 00 00 00       	call   1c90 <pop_q>
    1be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bea:	89 04 24             	mov    %eax,(%esp)
    1bed:	e8 db f8 ff ff       	call   14cd <twakeup>
    1bf2:	c9                   	leave  
    1bf3:	c3                   	ret    

00001bf4 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1bf4:	55                   	push   %ebp
    1bf5:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1bf7:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1c00:	8b 45 08             	mov    0x8(%ebp),%eax
    1c03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1c0a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1c14:	5d                   	pop    %ebp
    1c15:	c3                   	ret    

00001c16 <add_q>:

void add_q(struct queue *q, int v){
    1c16:	55                   	push   %ebp
    1c17:	89 e5                	mov    %esp,%ebp
    1c19:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1c1c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1c23:	e8 89 fc ff ff       	call   18b1 <malloc>
    1c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c38:	8b 55 0c             	mov    0xc(%ebp),%edx
    1c3b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1c3d:	8b 45 08             	mov    0x8(%ebp),%eax
    1c40:	8b 40 04             	mov    0x4(%eax),%eax
    1c43:	85 c0                	test   %eax,%eax
    1c45:	75 0b                	jne    1c52 <add_q+0x3c>
        q->head = n;
    1c47:	8b 45 08             	mov    0x8(%ebp),%eax
    1c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c4d:	89 50 04             	mov    %edx,0x4(%eax)
    1c50:	eb 0c                	jmp    1c5e <add_q+0x48>
    }else{
        q->tail->next = n;
    1c52:	8b 45 08             	mov    0x8(%ebp),%eax
    1c55:	8b 40 08             	mov    0x8(%eax),%eax
    1c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c5b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1c5e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c64:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1c67:	8b 45 08             	mov    0x8(%ebp),%eax
    1c6a:	8b 00                	mov    (%eax),%eax
    1c6c:	8d 50 01             	lea    0x1(%eax),%edx
    1c6f:	8b 45 08             	mov    0x8(%ebp),%eax
    1c72:	89 10                	mov    %edx,(%eax)
}
    1c74:	c9                   	leave  
    1c75:	c3                   	ret    

00001c76 <empty_q>:

int empty_q(struct queue *q){
    1c76:	55                   	push   %ebp
    1c77:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1c79:	8b 45 08             	mov    0x8(%ebp),%eax
    1c7c:	8b 00                	mov    (%eax),%eax
    1c7e:	85 c0                	test   %eax,%eax
    1c80:	75 07                	jne    1c89 <empty_q+0x13>
        return 1;
    1c82:	b8 01 00 00 00       	mov    $0x1,%eax
    1c87:	eb 05                	jmp    1c8e <empty_q+0x18>
    else
        return 0;
    1c89:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1c8e:	5d                   	pop    %ebp
    1c8f:	c3                   	ret    

00001c90 <pop_q>:
int pop_q(struct queue *q){
    1c90:	55                   	push   %ebp
    1c91:	89 e5                	mov    %esp,%ebp
    1c93:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1c96:	8b 45 08             	mov    0x8(%ebp),%eax
    1c99:	89 04 24             	mov    %eax,(%esp)
    1c9c:	e8 d5 ff ff ff       	call   1c76 <empty_q>
    1ca1:	85 c0                	test   %eax,%eax
    1ca3:	75 5d                	jne    1d02 <pop_q+0x72>
       val = q->head->value; 
    1ca5:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca8:	8b 40 04             	mov    0x4(%eax),%eax
    1cab:	8b 00                	mov    (%eax),%eax
    1cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1cb0:	8b 45 08             	mov    0x8(%ebp),%eax
    1cb3:	8b 40 04             	mov    0x4(%eax),%eax
    1cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1cb9:	8b 45 08             	mov    0x8(%ebp),%eax
    1cbc:	8b 40 04             	mov    0x4(%eax),%eax
    1cbf:	8b 50 04             	mov    0x4(%eax),%edx
    1cc2:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc5:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ccb:	89 04 24             	mov    %eax,(%esp)
    1cce:	e8 a5 fa ff ff       	call   1778 <free>
       q->size--;
    1cd3:	8b 45 08             	mov    0x8(%ebp),%eax
    1cd6:	8b 00                	mov    (%eax),%eax
    1cd8:	8d 50 ff             	lea    -0x1(%eax),%edx
    1cdb:	8b 45 08             	mov    0x8(%ebp),%eax
    1cde:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1ce0:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce3:	8b 00                	mov    (%eax),%eax
    1ce5:	85 c0                	test   %eax,%eax
    1ce7:	75 14                	jne    1cfd <pop_q+0x6d>
            q->head = 0;
    1ce9:	8b 45 08             	mov    0x8(%ebp),%eax
    1cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1cf3:	8b 45 08             	mov    0x8(%ebp),%eax
    1cf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d00:	eb 05                	jmp    1d07 <pop_q+0x77>
    }
    return -1;
    1d02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1d07:	c9                   	leave  
    1d08:	c3                   	ret    
