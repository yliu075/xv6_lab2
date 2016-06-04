
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
    
    //thread_create(ping, (void *)&arg);
    //thread_create(pong, (void *)&arg);
    
    void *tid = thread_create(ping, (void *)&arg);
    1011:	8d 44 24 18          	lea    0x18(%esp),%eax
    1015:	89 44 24 04          	mov    %eax,0x4(%esp)
    1019:	c7 04 24 ad 10 00 00 	movl   $0x10ad,(%esp)
    1020:	e8 6b 09 00 00       	call   1990 <thread_create>
    1025:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    //printf(1,"Thread Created 1\n");
    if(tid <= 0){
    1029:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    102e:	75 19                	jne    1049 <main+0x49>
        printf(1,"wrong happen\n");
    1030:	c7 44 24 04 8a 1c 00 	movl   $0x1c8a,0x4(%esp)
    1037:	00 
    1038:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103f:	e8 1d 05 00 00       	call   1561 <printf>
        exit();
    1044:	e8 68 03 00 00       	call   13b1 <exit>
    } 
    tid = thread_create(pong, (void *)&arg);
    1049:	8d 44 24 18          	lea    0x18(%esp),%eax
    104d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1051:	c7 04 24 fb 10 00 00 	movl   $0x10fb,(%esp)
    1058:	e8 33 09 00 00       	call   1990 <thread_create>
    105d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    //printf(1,"Thread Created 2\n");
    if(tid <= 0){
    1061:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    1066:	75 19                	jne    1081 <main+0x81>
        printf(1,"wrong happen\n");
    1068:	c7 44 24 04 8a 1c 00 	movl   $0x1c8a,0x4(%esp)
    106f:	00 
    1070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1077:	e8 e5 04 00 00       	call   1561 <printf>
        exit();
    107c:	e8 30 03 00 00       	call   13b1 <exit>
    } 
    
    
    //printf(1,"Going to Wait\n");
    wait();
    1081:	e8 33 03 00 00       	call   13b9 <wait>
    //printf(1,"Waited 1st Thread\n");
    thread_yield_last();
    1086:	e8 c7 0a 00 00       	call   1b52 <thread_yield_last>
    wait();
    108b:	e8 29 03 00 00       	call   13b9 <wait>
    //printf(1,"Waited 2nd Thread\n");
    
    exit();
    1090:	e8 1c 03 00 00       	call   13b1 <exit>

00001095 <test_func>:
}

void test_func(void *arg_ptr){
    1095:	55                   	push   %ebp
    1096:	89 e5                	mov    %esp,%ebp
    1098:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
    109b:	a1 f8 20 00 00       	mov    0x20f8,%eax
    10a0:	83 c0 01             	add    $0x1,%eax
    10a3:	a3 f8 20 00 00       	mov    %eax,0x20f8
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
    10a8:	e8 ac 03 00 00       	call   1459 <texit>

000010ad <ping>:
}

void ping(void *arg_ptr){
    10ad:	55                   	push   %ebp
    10ae:	89 e5                	mov    %esp,%ebp
    10b0:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    10b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10bc:	8b 00                	mov    (%eax),%eax
    10be:	a3 f8 20 00 00       	mov    %eax,0x20f8
    int i = 0;
    10c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    10ca:	eb 24                	jmp    10f0 <ping+0x43>
    // while(1) {
        printf(1,"Ping %d \n",i);
    10cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10cf:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d3:	c7 44 24 04 98 1c 00 	movl   $0x1c98,0x4(%esp)
    10da:	00 
    10db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e2:	e8 7a 04 00 00       	call   1561 <printf>
        thread_yield2();
    10e7:	e8 da 09 00 00       	call   1ac6 <thread_yield2>

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    10ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10f0:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    10f4:	7e d6                	jle    10cc <ping+0x1f>
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
    10f6:	e8 5e 03 00 00       	call   1459 <texit>

000010fb <pong>:
}
void pong(void *arg_ptr){
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    n = *num; 
    1107:	8b 45 f0             	mov    -0x10(%ebp),%eax
    110a:	8b 00                	mov    (%eax),%eax
    110c:	a3 f8 20 00 00       	mov    %eax,0x20f8
    int i = 0;
    1111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; i < 15 ; i++) {
    1118:	eb 24                	jmp    113e <pong+0x43>
    // while(1) {
        printf(1,"Pong %d \n",i);
    111a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    111d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1121:	c7 44 24 04 a2 1c 00 	movl   $0x1ca2,0x4(%esp)
    1128:	00 
    1129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1130:	e8 2c 04 00 00       	call   1561 <printf>
        thread_yield2();
    1135:	e8 8c 09 00 00       	call   1ac6 <thread_yield2>
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 15 ; i++) {
    113a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    113e:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
    1142:	7e d6                	jle    111a <pong+0x1f>
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
    1144:	e8 10 03 00 00       	call   1459 <texit>

00001149 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1149:	55                   	push   %ebp
    114a:	89 e5                	mov    %esp,%ebp
    114c:	57                   	push   %edi
    114d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    114e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1151:	8b 55 10             	mov    0x10(%ebp),%edx
    1154:	8b 45 0c             	mov    0xc(%ebp),%eax
    1157:	89 cb                	mov    %ecx,%ebx
    1159:	89 df                	mov    %ebx,%edi
    115b:	89 d1                	mov    %edx,%ecx
    115d:	fc                   	cld    
    115e:	f3 aa                	rep stos %al,%es:(%edi)
    1160:	89 ca                	mov    %ecx,%edx
    1162:	89 fb                	mov    %edi,%ebx
    1164:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1167:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    116a:	5b                   	pop    %ebx
    116b:	5f                   	pop    %edi
    116c:	5d                   	pop    %ebp
    116d:	c3                   	ret    

0000116e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    117a:	90                   	nop
    117b:	8b 45 08             	mov    0x8(%ebp),%eax
    117e:	8d 50 01             	lea    0x1(%eax),%edx
    1181:	89 55 08             	mov    %edx,0x8(%ebp)
    1184:	8b 55 0c             	mov    0xc(%ebp),%edx
    1187:	8d 4a 01             	lea    0x1(%edx),%ecx
    118a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    118d:	0f b6 12             	movzbl (%edx),%edx
    1190:	88 10                	mov    %dl,(%eax)
    1192:	0f b6 00             	movzbl (%eax),%eax
    1195:	84 c0                	test   %al,%al
    1197:	75 e2                	jne    117b <strcpy+0xd>
    ;
  return os;
    1199:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    119c:	c9                   	leave  
    119d:	c3                   	ret    

0000119e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    119e:	55                   	push   %ebp
    119f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    11a1:	eb 08                	jmp    11ab <strcmp+0xd>
    p++, q++;
    11a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11ab:	8b 45 08             	mov    0x8(%ebp),%eax
    11ae:	0f b6 00             	movzbl (%eax),%eax
    11b1:	84 c0                	test   %al,%al
    11b3:	74 10                	je     11c5 <strcmp+0x27>
    11b5:	8b 45 08             	mov    0x8(%ebp),%eax
    11b8:	0f b6 10             	movzbl (%eax),%edx
    11bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	38 c2                	cmp    %al,%dl
    11c3:	74 de                	je     11a3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11c5:	8b 45 08             	mov    0x8(%ebp),%eax
    11c8:	0f b6 00             	movzbl (%eax),%eax
    11cb:	0f b6 d0             	movzbl %al,%edx
    11ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d1:	0f b6 00             	movzbl (%eax),%eax
    11d4:	0f b6 c0             	movzbl %al,%eax
    11d7:	29 c2                	sub    %eax,%edx
    11d9:	89 d0                	mov    %edx,%eax
}
    11db:	5d                   	pop    %ebp
    11dc:	c3                   	ret    

000011dd <strlen>:

uint
strlen(char *s)
{
    11dd:	55                   	push   %ebp
    11de:	89 e5                	mov    %esp,%ebp
    11e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11ea:	eb 04                	jmp    11f0 <strlen+0x13>
    11ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11f3:	8b 45 08             	mov    0x8(%ebp),%eax
    11f6:	01 d0                	add    %edx,%eax
    11f8:	0f b6 00             	movzbl (%eax),%eax
    11fb:	84 c0                	test   %al,%al
    11fd:	75 ed                	jne    11ec <strlen+0xf>
    ;
  return n;
    11ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1202:	c9                   	leave  
    1203:	c3                   	ret    

00001204 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1204:	55                   	push   %ebp
    1205:	89 e5                	mov    %esp,%ebp
    1207:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    120a:	8b 45 10             	mov    0x10(%ebp),%eax
    120d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1211:	8b 45 0c             	mov    0xc(%ebp),%eax
    1214:	89 44 24 04          	mov    %eax,0x4(%esp)
    1218:	8b 45 08             	mov    0x8(%ebp),%eax
    121b:	89 04 24             	mov    %eax,(%esp)
    121e:	e8 26 ff ff ff       	call   1149 <stosb>
  return dst;
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1226:	c9                   	leave  
    1227:	c3                   	ret    

00001228 <strchr>:

char*
strchr(const char *s, char c)
{
    1228:	55                   	push   %ebp
    1229:	89 e5                	mov    %esp,%ebp
    122b:	83 ec 04             	sub    $0x4,%esp
    122e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1234:	eb 14                	jmp    124a <strchr+0x22>
    if(*s == c)
    1236:	8b 45 08             	mov    0x8(%ebp),%eax
    1239:	0f b6 00             	movzbl (%eax),%eax
    123c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    123f:	75 05                	jne    1246 <strchr+0x1e>
      return (char*)s;
    1241:	8b 45 08             	mov    0x8(%ebp),%eax
    1244:	eb 13                	jmp    1259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	0f b6 00             	movzbl (%eax),%eax
    1250:	84 c0                	test   %al,%al
    1252:	75 e2                	jne    1236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1254:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1259:	c9                   	leave  
    125a:	c3                   	ret    

0000125b <gets>:

char*
gets(char *buf, int max)
{
    125b:	55                   	push   %ebp
    125c:	89 e5                	mov    %esp,%ebp
    125e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1268:	eb 4c                	jmp    12b6 <gets+0x5b>
    cc = read(0, &c, 1);
    126a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1271:	00 
    1272:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1275:	89 44 24 04          	mov    %eax,0x4(%esp)
    1279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1280:	e8 44 01 00 00       	call   13c9 <read>
    1285:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    128c:	7f 02                	jg     1290 <gets+0x35>
      break;
    128e:	eb 31                	jmp    12c1 <gets+0x66>
    buf[i++] = c;
    1290:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1293:	8d 50 01             	lea    0x1(%eax),%edx
    1296:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1299:	89 c2                	mov    %eax,%edx
    129b:	8b 45 08             	mov    0x8(%ebp),%eax
    129e:	01 c2                	add    %eax,%edx
    12a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    12a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12aa:	3c 0a                	cmp    $0xa,%al
    12ac:	74 13                	je     12c1 <gets+0x66>
    12ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12b2:	3c 0d                	cmp    $0xd,%al
    12b4:	74 0b                	je     12c1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b9:	83 c0 01             	add    $0x1,%eax
    12bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12bf:	7c a9                	jl     126a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12c4:	8b 45 08             	mov    0x8(%ebp),%eax
    12c7:	01 d0                	add    %edx,%eax
    12c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12cf:	c9                   	leave  
    12d0:	c3                   	ret    

000012d1 <stat>:

int
stat(char *n, struct stat *st)
{
    12d1:	55                   	push   %ebp
    12d2:	89 e5                	mov    %esp,%ebp
    12d4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12de:	00 
    12df:	8b 45 08             	mov    0x8(%ebp),%eax
    12e2:	89 04 24             	mov    %eax,(%esp)
    12e5:	e8 07 01 00 00       	call   13f1 <open>
    12ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12f1:	79 07                	jns    12fa <stat+0x29>
    return -1;
    12f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12f8:	eb 23                	jmp    131d <stat+0x4c>
  r = fstat(fd, st);
    12fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    12fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1301:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1304:	89 04 24             	mov    %eax,(%esp)
    1307:	e8 fd 00 00 00       	call   1409 <fstat>
    130c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    130f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1312:	89 04 24             	mov    %eax,(%esp)
    1315:	e8 bf 00 00 00       	call   13d9 <close>
  return r;
    131a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    131d:	c9                   	leave  
    131e:	c3                   	ret    

0000131f <atoi>:

int
atoi(const char *s)
{
    131f:	55                   	push   %ebp
    1320:	89 e5                	mov    %esp,%ebp
    1322:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    132c:	eb 25                	jmp    1353 <atoi+0x34>
    n = n*10 + *s++ - '0';
    132e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1331:	89 d0                	mov    %edx,%eax
    1333:	c1 e0 02             	shl    $0x2,%eax
    1336:	01 d0                	add    %edx,%eax
    1338:	01 c0                	add    %eax,%eax
    133a:	89 c1                	mov    %eax,%ecx
    133c:	8b 45 08             	mov    0x8(%ebp),%eax
    133f:	8d 50 01             	lea    0x1(%eax),%edx
    1342:	89 55 08             	mov    %edx,0x8(%ebp)
    1345:	0f b6 00             	movzbl (%eax),%eax
    1348:	0f be c0             	movsbl %al,%eax
    134b:	01 c8                	add    %ecx,%eax
    134d:	83 e8 30             	sub    $0x30,%eax
    1350:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1353:	8b 45 08             	mov    0x8(%ebp),%eax
    1356:	0f b6 00             	movzbl (%eax),%eax
    1359:	3c 2f                	cmp    $0x2f,%al
    135b:	7e 0a                	jle    1367 <atoi+0x48>
    135d:	8b 45 08             	mov    0x8(%ebp),%eax
    1360:	0f b6 00             	movzbl (%eax),%eax
    1363:	3c 39                	cmp    $0x39,%al
    1365:	7e c7                	jle    132e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1367:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    136a:	c9                   	leave  
    136b:	c3                   	ret    

0000136c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    136c:	55                   	push   %ebp
    136d:	89 e5                	mov    %esp,%ebp
    136f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1372:	8b 45 08             	mov    0x8(%ebp),%eax
    1375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1378:	8b 45 0c             	mov    0xc(%ebp),%eax
    137b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    137e:	eb 17                	jmp    1397 <memmove+0x2b>
    *dst++ = *src++;
    1380:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1383:	8d 50 01             	lea    0x1(%eax),%edx
    1386:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1389:	8b 55 f8             	mov    -0x8(%ebp),%edx
    138c:	8d 4a 01             	lea    0x1(%edx),%ecx
    138f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1392:	0f b6 12             	movzbl (%edx),%edx
    1395:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1397:	8b 45 10             	mov    0x10(%ebp),%eax
    139a:	8d 50 ff             	lea    -0x1(%eax),%edx
    139d:	89 55 10             	mov    %edx,0x10(%ebp)
    13a0:	85 c0                	test   %eax,%eax
    13a2:	7f dc                	jg     1380 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    13a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13a7:	c9                   	leave  
    13a8:	c3                   	ret    

000013a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13a9:	b8 01 00 00 00       	mov    $0x1,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <exit>:
SYSCALL(exit)
    13b1:	b8 02 00 00 00       	mov    $0x2,%eax
    13b6:	cd 40                	int    $0x40
    13b8:	c3                   	ret    

000013b9 <wait>:
SYSCALL(wait)
    13b9:	b8 03 00 00 00       	mov    $0x3,%eax
    13be:	cd 40                	int    $0x40
    13c0:	c3                   	ret    

000013c1 <pipe>:
SYSCALL(pipe)
    13c1:	b8 04 00 00 00       	mov    $0x4,%eax
    13c6:	cd 40                	int    $0x40
    13c8:	c3                   	ret    

000013c9 <read>:
SYSCALL(read)
    13c9:	b8 05 00 00 00       	mov    $0x5,%eax
    13ce:	cd 40                	int    $0x40
    13d0:	c3                   	ret    

000013d1 <write>:
SYSCALL(write)
    13d1:	b8 10 00 00 00       	mov    $0x10,%eax
    13d6:	cd 40                	int    $0x40
    13d8:	c3                   	ret    

000013d9 <close>:
SYSCALL(close)
    13d9:	b8 15 00 00 00       	mov    $0x15,%eax
    13de:	cd 40                	int    $0x40
    13e0:	c3                   	ret    

000013e1 <kill>:
SYSCALL(kill)
    13e1:	b8 06 00 00 00       	mov    $0x6,%eax
    13e6:	cd 40                	int    $0x40
    13e8:	c3                   	ret    

000013e9 <exec>:
SYSCALL(exec)
    13e9:	b8 07 00 00 00       	mov    $0x7,%eax
    13ee:	cd 40                	int    $0x40
    13f0:	c3                   	ret    

000013f1 <open>:
SYSCALL(open)
    13f1:	b8 0f 00 00 00       	mov    $0xf,%eax
    13f6:	cd 40                	int    $0x40
    13f8:	c3                   	ret    

000013f9 <mknod>:
SYSCALL(mknod)
    13f9:	b8 11 00 00 00       	mov    $0x11,%eax
    13fe:	cd 40                	int    $0x40
    1400:	c3                   	ret    

00001401 <unlink>:
SYSCALL(unlink)
    1401:	b8 12 00 00 00       	mov    $0x12,%eax
    1406:	cd 40                	int    $0x40
    1408:	c3                   	ret    

00001409 <fstat>:
SYSCALL(fstat)
    1409:	b8 08 00 00 00       	mov    $0x8,%eax
    140e:	cd 40                	int    $0x40
    1410:	c3                   	ret    

00001411 <link>:
SYSCALL(link)
    1411:	b8 13 00 00 00       	mov    $0x13,%eax
    1416:	cd 40                	int    $0x40
    1418:	c3                   	ret    

00001419 <mkdir>:
SYSCALL(mkdir)
    1419:	b8 14 00 00 00       	mov    $0x14,%eax
    141e:	cd 40                	int    $0x40
    1420:	c3                   	ret    

00001421 <chdir>:
SYSCALL(chdir)
    1421:	b8 09 00 00 00       	mov    $0x9,%eax
    1426:	cd 40                	int    $0x40
    1428:	c3                   	ret    

00001429 <dup>:
SYSCALL(dup)
    1429:	b8 0a 00 00 00       	mov    $0xa,%eax
    142e:	cd 40                	int    $0x40
    1430:	c3                   	ret    

00001431 <getpid>:
SYSCALL(getpid)
    1431:	b8 0b 00 00 00       	mov    $0xb,%eax
    1436:	cd 40                	int    $0x40
    1438:	c3                   	ret    

00001439 <sbrk>:
SYSCALL(sbrk)
    1439:	b8 0c 00 00 00       	mov    $0xc,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <sleep>:
SYSCALL(sleep)
    1441:	b8 0d 00 00 00       	mov    $0xd,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <uptime>:
SYSCALL(uptime)
    1449:	b8 0e 00 00 00       	mov    $0xe,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <clone>:
SYSCALL(clone)
    1451:	b8 16 00 00 00       	mov    $0x16,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <texit>:
SYSCALL(texit)
    1459:	b8 17 00 00 00       	mov    $0x17,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <tsleep>:
SYSCALL(tsleep)
    1461:	b8 18 00 00 00       	mov    $0x18,%eax
    1466:	cd 40                	int    $0x40
    1468:	c3                   	ret    

00001469 <twakeup>:
SYSCALL(twakeup)
    1469:	b8 19 00 00 00       	mov    $0x19,%eax
    146e:	cd 40                	int    $0x40
    1470:	c3                   	ret    

00001471 <thread_yield>:
SYSCALL(thread_yield)
    1471:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1476:	cd 40                	int    $0x40
    1478:	c3                   	ret    

00001479 <thread_yield3>:
    1479:	b8 1a 00 00 00       	mov    $0x1a,%eax
    147e:	cd 40                	int    $0x40
    1480:	c3                   	ret    

00001481 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1481:	55                   	push   %ebp
    1482:	89 e5                	mov    %esp,%ebp
    1484:	83 ec 18             	sub    $0x18,%esp
    1487:	8b 45 0c             	mov    0xc(%ebp),%eax
    148a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    148d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1494:	00 
    1495:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1498:	89 44 24 04          	mov    %eax,0x4(%esp)
    149c:	8b 45 08             	mov    0x8(%ebp),%eax
    149f:	89 04 24             	mov    %eax,(%esp)
    14a2:	e8 2a ff ff ff       	call   13d1 <write>
}
    14a7:	c9                   	leave  
    14a8:	c3                   	ret    

000014a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14a9:	55                   	push   %ebp
    14aa:	89 e5                	mov    %esp,%ebp
    14ac:	56                   	push   %esi
    14ad:	53                   	push   %ebx
    14ae:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14b8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    14bc:	74 17                	je     14d5 <printint+0x2c>
    14be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14c2:	79 11                	jns    14d5 <printint+0x2c>
    neg = 1;
    14c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    14ce:	f7 d8                	neg    %eax
    14d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14d3:	eb 06                	jmp    14db <printint+0x32>
  } else {
    x = xx;
    14d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14e5:	8d 41 01             	lea    0x1(%ecx),%eax
    14e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14f1:	ba 00 00 00 00       	mov    $0x0,%edx
    14f6:	f7 f3                	div    %ebx
    14f8:	89 d0                	mov    %edx,%eax
    14fa:	0f b6 80 fc 20 00 00 	movzbl 0x20fc(%eax),%eax
    1501:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1505:	8b 75 10             	mov    0x10(%ebp),%esi
    1508:	8b 45 ec             	mov    -0x14(%ebp),%eax
    150b:	ba 00 00 00 00       	mov    $0x0,%edx
    1510:	f7 f6                	div    %esi
    1512:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1519:	75 c7                	jne    14e2 <printint+0x39>
  if(neg)
    151b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    151f:	74 10                	je     1531 <printint+0x88>
    buf[i++] = '-';
    1521:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1524:	8d 50 01             	lea    0x1(%eax),%edx
    1527:	89 55 f4             	mov    %edx,-0xc(%ebp)
    152a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    152f:	eb 1f                	jmp    1550 <printint+0xa7>
    1531:	eb 1d                	jmp    1550 <printint+0xa7>
    putc(fd, buf[i]);
    1533:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1539:	01 d0                	add    %edx,%eax
    153b:	0f b6 00             	movzbl (%eax),%eax
    153e:	0f be c0             	movsbl %al,%eax
    1541:	89 44 24 04          	mov    %eax,0x4(%esp)
    1545:	8b 45 08             	mov    0x8(%ebp),%eax
    1548:	89 04 24             	mov    %eax,(%esp)
    154b:	e8 31 ff ff ff       	call   1481 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1550:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1558:	79 d9                	jns    1533 <printint+0x8a>
    putc(fd, buf[i]);
}
    155a:	83 c4 30             	add    $0x30,%esp
    155d:	5b                   	pop    %ebx
    155e:	5e                   	pop    %esi
    155f:	5d                   	pop    %ebp
    1560:	c3                   	ret    

00001561 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1561:	55                   	push   %ebp
    1562:	89 e5                	mov    %esp,%ebp
    1564:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1567:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    156e:	8d 45 0c             	lea    0xc(%ebp),%eax
    1571:	83 c0 04             	add    $0x4,%eax
    1574:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    157e:	e9 7c 01 00 00       	jmp    16ff <printf+0x19e>
    c = fmt[i] & 0xff;
    1583:	8b 55 0c             	mov    0xc(%ebp),%edx
    1586:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1589:	01 d0                	add    %edx,%eax
    158b:	0f b6 00             	movzbl (%eax),%eax
    158e:	0f be c0             	movsbl %al,%eax
    1591:	25 ff 00 00 00       	and    $0xff,%eax
    1596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    159d:	75 2c                	jne    15cb <printf+0x6a>
      if(c == '%'){
    159f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a3:	75 0c                	jne    15b1 <printf+0x50>
        state = '%';
    15a5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15ac:	e9 4a 01 00 00       	jmp    16fb <printf+0x19a>
      } else {
        putc(fd, c);
    15b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b4:	0f be c0             	movsbl %al,%eax
    15b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bb:	8b 45 08             	mov    0x8(%ebp),%eax
    15be:	89 04 24             	mov    %eax,(%esp)
    15c1:	e8 bb fe ff ff       	call   1481 <putc>
    15c6:	e9 30 01 00 00       	jmp    16fb <printf+0x19a>
      }
    } else if(state == '%'){
    15cb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15cf:	0f 85 26 01 00 00    	jne    16fb <printf+0x19a>
      if(c == 'd'){
    15d5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15d9:	75 2d                	jne    1608 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15db:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15de:	8b 00                	mov    (%eax),%eax
    15e0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15e7:	00 
    15e8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15ef:	00 
    15f0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f4:	8b 45 08             	mov    0x8(%ebp),%eax
    15f7:	89 04 24             	mov    %eax,(%esp)
    15fa:	e8 aa fe ff ff       	call   14a9 <printint>
        ap++;
    15ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1603:	e9 ec 00 00 00       	jmp    16f4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1608:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    160c:	74 06                	je     1614 <printf+0xb3>
    160e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1612:	75 2d                	jne    1641 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1614:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1617:	8b 00                	mov    (%eax),%eax
    1619:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1620:	00 
    1621:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1628:	00 
    1629:	89 44 24 04          	mov    %eax,0x4(%esp)
    162d:	8b 45 08             	mov    0x8(%ebp),%eax
    1630:	89 04 24             	mov    %eax,(%esp)
    1633:	e8 71 fe ff ff       	call   14a9 <printint>
        ap++;
    1638:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    163c:	e9 b3 00 00 00       	jmp    16f4 <printf+0x193>
      } else if(c == 's'){
    1641:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1645:	75 45                	jne    168c <printf+0x12b>
        s = (char*)*ap;
    1647:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164a:	8b 00                	mov    (%eax),%eax
    164c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    164f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1657:	75 09                	jne    1662 <printf+0x101>
          s = "(null)";
    1659:	c7 45 f4 ac 1c 00 00 	movl   $0x1cac,-0xc(%ebp)
        while(*s != 0){
    1660:	eb 1e                	jmp    1680 <printf+0x11f>
    1662:	eb 1c                	jmp    1680 <printf+0x11f>
          putc(fd, *s);
    1664:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1667:	0f b6 00             	movzbl (%eax),%eax
    166a:	0f be c0             	movsbl %al,%eax
    166d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1671:	8b 45 08             	mov    0x8(%ebp),%eax
    1674:	89 04 24             	mov    %eax,(%esp)
    1677:	e8 05 fe ff ff       	call   1481 <putc>
          s++;
    167c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1680:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1683:	0f b6 00             	movzbl (%eax),%eax
    1686:	84 c0                	test   %al,%al
    1688:	75 da                	jne    1664 <printf+0x103>
    168a:	eb 68                	jmp    16f4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    168c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1690:	75 1d                	jne    16af <printf+0x14e>
        putc(fd, *ap);
    1692:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1695:	8b 00                	mov    (%eax),%eax
    1697:	0f be c0             	movsbl %al,%eax
    169a:	89 44 24 04          	mov    %eax,0x4(%esp)
    169e:	8b 45 08             	mov    0x8(%ebp),%eax
    16a1:	89 04 24             	mov    %eax,(%esp)
    16a4:	e8 d8 fd ff ff       	call   1481 <putc>
        ap++;
    16a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16ad:	eb 45                	jmp    16f4 <printf+0x193>
      } else if(c == '%'){
    16af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16b3:	75 17                	jne    16cc <printf+0x16b>
        putc(fd, c);
    16b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b8:	0f be c0             	movsbl %al,%eax
    16bb:	89 44 24 04          	mov    %eax,0x4(%esp)
    16bf:	8b 45 08             	mov    0x8(%ebp),%eax
    16c2:	89 04 24             	mov    %eax,(%esp)
    16c5:	e8 b7 fd ff ff       	call   1481 <putc>
    16ca:	eb 28                	jmp    16f4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16cc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16d3:	00 
    16d4:	8b 45 08             	mov    0x8(%ebp),%eax
    16d7:	89 04 24             	mov    %eax,(%esp)
    16da:	e8 a2 fd ff ff       	call   1481 <putc>
        putc(fd, c);
    16df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16e2:	0f be c0             	movsbl %al,%eax
    16e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    16e9:	8b 45 08             	mov    0x8(%ebp),%eax
    16ec:	89 04 24             	mov    %eax,(%esp)
    16ef:	e8 8d fd ff ff       	call   1481 <putc>
      }
      state = 0;
    16f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16fb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16ff:	8b 55 0c             	mov    0xc(%ebp),%edx
    1702:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1705:	01 d0                	add    %edx,%eax
    1707:	0f b6 00             	movzbl (%eax),%eax
    170a:	84 c0                	test   %al,%al
    170c:	0f 85 71 fe ff ff    	jne    1583 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1712:	c9                   	leave  
    1713:	c3                   	ret    

00001714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1714:	55                   	push   %ebp
    1715:	89 e5                	mov    %esp,%ebp
    1717:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    171a:	8b 45 08             	mov    0x8(%ebp),%eax
    171d:	83 e8 08             	sub    $0x8,%eax
    1720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1723:	a1 28 21 00 00       	mov    0x2128,%eax
    1728:	89 45 fc             	mov    %eax,-0x4(%ebp)
    172b:	eb 24                	jmp    1751 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    172d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1730:	8b 00                	mov    (%eax),%eax
    1732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1735:	77 12                	ja     1749 <free+0x35>
    1737:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    173d:	77 24                	ja     1763 <free+0x4f>
    173f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1742:	8b 00                	mov    (%eax),%eax
    1744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1747:	77 1a                	ja     1763 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1749:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174c:	8b 00                	mov    (%eax),%eax
    174e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1751:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1757:	76 d4                	jbe    172d <free+0x19>
    1759:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175c:	8b 00                	mov    (%eax),%eax
    175e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1761:	76 ca                	jbe    172d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1763:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1766:	8b 40 04             	mov    0x4(%eax),%eax
    1769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1770:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1773:	01 c2                	add    %eax,%edx
    1775:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1778:	8b 00                	mov    (%eax),%eax
    177a:	39 c2                	cmp    %eax,%edx
    177c:	75 24                	jne    17a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1781:	8b 50 04             	mov    0x4(%eax),%edx
    1784:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1787:	8b 00                	mov    (%eax),%eax
    1789:	8b 40 04             	mov    0x4(%eax),%eax
    178c:	01 c2                	add    %eax,%edx
    178e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1791:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1794:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1797:	8b 00                	mov    (%eax),%eax
    1799:	8b 10                	mov    (%eax),%edx
    179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179e:	89 10                	mov    %edx,(%eax)
    17a0:	eb 0a                	jmp    17ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a5:	8b 10                	mov    (%eax),%edx
    17a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17af:	8b 40 04             	mov    0x4(%eax),%eax
    17b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bc:	01 d0                	add    %edx,%eax
    17be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c1:	75 20                	jne    17e3 <free+0xcf>
    p->s.size += bp->s.size;
    17c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c6:	8b 50 04             	mov    0x4(%eax),%edx
    17c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17cc:	8b 40 04             	mov    0x4(%eax),%eax
    17cf:	01 c2                	add    %eax,%edx
    17d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17da:	8b 10                	mov    (%eax),%edx
    17dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17df:	89 10                	mov    %edx,(%eax)
    17e1:	eb 08                	jmp    17eb <free+0xd7>
  } else
    p->s.ptr = bp;
    17e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17e9:	89 10                	mov    %edx,(%eax)
  freep = p;
    17eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ee:	a3 28 21 00 00       	mov    %eax,0x2128
}
    17f3:	c9                   	leave  
    17f4:	c3                   	ret    

000017f5 <morecore>:

static Header*
morecore(uint nu)
{
    17f5:	55                   	push   %ebp
    17f6:	89 e5                	mov    %esp,%ebp
    17f8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1802:	77 07                	ja     180b <morecore+0x16>
    nu = 4096;
    1804:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    180b:	8b 45 08             	mov    0x8(%ebp),%eax
    180e:	c1 e0 03             	shl    $0x3,%eax
    1811:	89 04 24             	mov    %eax,(%esp)
    1814:	e8 20 fc ff ff       	call   1439 <sbrk>
    1819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    181c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1820:	75 07                	jne    1829 <morecore+0x34>
    return 0;
    1822:	b8 00 00 00 00       	mov    $0x0,%eax
    1827:	eb 22                	jmp    184b <morecore+0x56>
  hp = (Header*)p;
    1829:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1832:	8b 55 08             	mov    0x8(%ebp),%edx
    1835:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1838:	8b 45 f0             	mov    -0x10(%ebp),%eax
    183b:	83 c0 08             	add    $0x8,%eax
    183e:	89 04 24             	mov    %eax,(%esp)
    1841:	e8 ce fe ff ff       	call   1714 <free>
  return freep;
    1846:	a1 28 21 00 00       	mov    0x2128,%eax
}
    184b:	c9                   	leave  
    184c:	c3                   	ret    

0000184d <malloc>:

void*
malloc(uint nbytes)
{
    184d:	55                   	push   %ebp
    184e:	89 e5                	mov    %esp,%ebp
    1850:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1853:	8b 45 08             	mov    0x8(%ebp),%eax
    1856:	83 c0 07             	add    $0x7,%eax
    1859:	c1 e8 03             	shr    $0x3,%eax
    185c:	83 c0 01             	add    $0x1,%eax
    185f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1862:	a1 28 21 00 00       	mov    0x2128,%eax
    1867:	89 45 f0             	mov    %eax,-0x10(%ebp)
    186a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    186e:	75 23                	jne    1893 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1870:	c7 45 f0 20 21 00 00 	movl   $0x2120,-0x10(%ebp)
    1877:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187a:	a3 28 21 00 00       	mov    %eax,0x2128
    187f:	a1 28 21 00 00       	mov    0x2128,%eax
    1884:	a3 20 21 00 00       	mov    %eax,0x2120
    base.s.size = 0;
    1889:	c7 05 24 21 00 00 00 	movl   $0x0,0x2124
    1890:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1893:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1896:	8b 00                	mov    (%eax),%eax
    1898:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189e:	8b 40 04             	mov    0x4(%eax),%eax
    18a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18a4:	72 4d                	jb     18f3 <malloc+0xa6>
      if(p->s.size == nunits)
    18a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a9:	8b 40 04             	mov    0x4(%eax),%eax
    18ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18af:	75 0c                	jne    18bd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    18b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b4:	8b 10                	mov    (%eax),%edx
    18b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b9:	89 10                	mov    %edx,(%eax)
    18bb:	eb 26                	jmp    18e3 <malloc+0x96>
      else {
        p->s.size -= nunits;
    18bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c0:	8b 40 04             	mov    0x4(%eax),%eax
    18c3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18c6:	89 c2                	mov    %eax,%edx
    18c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d1:	8b 40 04             	mov    0x4(%eax),%eax
    18d4:	c1 e0 03             	shl    $0x3,%eax
    18d7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18e0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e6:	a3 28 21 00 00       	mov    %eax,0x2128
      return (void*)(p + 1);
    18eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ee:	83 c0 08             	add    $0x8,%eax
    18f1:	eb 38                	jmp    192b <malloc+0xde>
    }
    if(p == freep)
    18f3:	a1 28 21 00 00       	mov    0x2128,%eax
    18f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18fb:	75 1b                	jne    1918 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1900:	89 04 24             	mov    %eax,(%esp)
    1903:	e8 ed fe ff ff       	call   17f5 <morecore>
    1908:	89 45 f4             	mov    %eax,-0xc(%ebp)
    190b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    190f:	75 07                	jne    1918 <malloc+0xcb>
        return 0;
    1911:	b8 00 00 00 00       	mov    $0x0,%eax
    1916:	eb 13                	jmp    192b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1918:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1921:	8b 00                	mov    (%eax),%eax
    1923:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1926:	e9 70 ff ff ff       	jmp    189b <malloc+0x4e>
}
    192b:	c9                   	leave  
    192c:	c3                   	ret    

0000192d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    192d:	55                   	push   %ebp
    192e:	89 e5                	mov    %esp,%ebp
    1930:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1933:	8b 55 08             	mov    0x8(%ebp),%edx
    1936:	8b 45 0c             	mov    0xc(%ebp),%eax
    1939:	8b 4d 08             	mov    0x8(%ebp),%ecx
    193c:	f0 87 02             	lock xchg %eax,(%edx)
    193f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1942:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1945:	c9                   	leave  
    1946:	c3                   	ret    

00001947 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1947:	55                   	push   %ebp
    1948:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    194a:	8b 45 08             	mov    0x8(%ebp),%eax
    194d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1953:	5d                   	pop    %ebp
    1954:	c3                   	ret    

00001955 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1955:	55                   	push   %ebp
    1956:	89 e5                	mov    %esp,%ebp
    1958:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    195b:	90                   	nop
    195c:	8b 45 08             	mov    0x8(%ebp),%eax
    195f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1966:	00 
    1967:	89 04 24             	mov    %eax,(%esp)
    196a:	e8 be ff ff ff       	call   192d <xchg>
    196f:	85 c0                	test   %eax,%eax
    1971:	75 e9                	jne    195c <lock_acquire+0x7>
}
    1973:	c9                   	leave  
    1974:	c3                   	ret    

00001975 <lock_release>:
void lock_release(lock_t *lock){
    1975:	55                   	push   %ebp
    1976:	89 e5                	mov    %esp,%ebp
    1978:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    197b:	8b 45 08             	mov    0x8(%ebp),%eax
    197e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1985:	00 
    1986:	89 04 24             	mov    %eax,(%esp)
    1989:	e8 9f ff ff ff       	call   192d <xchg>
}
    198e:	c9                   	leave  
    198f:	c3                   	ret    

00001990 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1990:	55                   	push   %ebp
    1991:	89 e5                	mov    %esp,%ebp
    1993:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1996:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    199d:	e8 ab fe ff ff       	call   184d <malloc>
    19a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    19a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    19ab:	0f b6 05 2c 21 00 00 	movzbl 0x212c,%eax
    19b2:	84 c0                	test   %al,%al
    19b4:	75 1c                	jne    19d2 <thread_create+0x42>
        init_q(thQ2);
    19b6:	a1 48 22 00 00       	mov    0x2248,%eax
    19bb:	89 04 24             	mov    %eax,(%esp)
    19be:	e8 b2 01 00 00       	call   1b75 <init_q>
        inQ++;
    19c3:	0f b6 05 2c 21 00 00 	movzbl 0x212c,%eax
    19ca:	83 c0 01             	add    $0x1,%eax
    19cd:	a2 2c 21 00 00       	mov    %al,0x212c
    }

    if((uint)stack % 4096){
    19d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d5:	25 ff 0f 00 00       	and    $0xfff,%eax
    19da:	85 c0                	test   %eax,%eax
    19dc:	74 14                	je     19f2 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    19de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e1:	25 ff 0f 00 00       	and    $0xfff,%eax
    19e6:	89 c2                	mov    %eax,%edx
    19e8:	b8 00 10 00 00       	mov    $0x1000,%eax
    19ed:	29 d0                	sub    %edx,%eax
    19ef:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    19f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19f6:	75 1e                	jne    1a16 <thread_create+0x86>

        printf(1,"malloc fail \n");
    19f8:	c7 44 24 04 b3 1c 00 	movl   $0x1cb3,0x4(%esp)
    19ff:	00 
    1a00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a07:	e8 55 fb ff ff       	call   1561 <printf>
        return 0;
    1a0c:	b8 00 00 00 00       	mov    $0x0,%eax
    1a11:	e9 83 00 00 00       	jmp    1a99 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1a16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1a19:	8b 55 08             	mov    0x8(%ebp),%edx
    1a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1a23:	89 54 24 08          	mov    %edx,0x8(%esp)
    1a27:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1a2e:	00 
    1a2f:	89 04 24             	mov    %eax,(%esp)
    1a32:	e8 1a fa ff ff       	call   1451 <clone>
    1a37:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    1a3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a3e:	79 1b                	jns    1a5b <thread_create+0xcb>
        printf(1,"clone fails\n");
    1a40:	c7 44 24 04 c1 1c 00 	movl   $0x1cc1,0x4(%esp)
    1a47:	00 
    1a48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a4f:	e8 0d fb ff ff       	call   1561 <printf>
        return 0;
    1a54:	b8 00 00 00 00       	mov    $0x0,%eax
    1a59:	eb 3e                	jmp    1a99 <thread_create+0x109>
    }
    if(tid > 0){
    1a5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a5f:	7e 19                	jle    1a7a <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    1a61:	a1 48 22 00 00       	mov    0x2248,%eax
    1a66:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a69:	89 54 24 04          	mov    %edx,0x4(%esp)
    1a6d:	89 04 24             	mov    %eax,(%esp)
    1a70:	e8 22 01 00 00       	call   1b97 <add_q>
        return garbage_stack;
    1a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a78:	eb 1f                	jmp    1a99 <thread_create+0x109>
    }
    if(tid == 0){
    1a7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a7e:	75 14                	jne    1a94 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    1a80:	c7 44 24 04 ce 1c 00 	movl   $0x1cce,0x4(%esp)
    1a87:	00 
    1a88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a8f:	e8 cd fa ff ff       	call   1561 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a99:	c9                   	leave  
    1a9a:	c3                   	ret    

00001a9b <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1a9b:	55                   	push   %ebp
    1a9c:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1a9e:	a1 10 21 00 00       	mov    0x2110,%eax
    1aa3:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1aa9:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1aae:	a3 10 21 00 00       	mov    %eax,0x2110
    return (int)(rands % max);
    1ab3:	a1 10 21 00 00       	mov    0x2110,%eax
    1ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1abb:	ba 00 00 00 00       	mov    $0x0,%edx
    1ac0:	f7 f1                	div    %ecx
    1ac2:	89 d0                	mov    %edx,%eax
}
    1ac4:	5d                   	pop    %ebp
    1ac5:	c3                   	ret    

00001ac6 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1ac6:	55                   	push   %ebp
    1ac7:	89 e5                	mov    %esp,%ebp
    1ac9:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1acc:	e8 60 f9 ff ff       	call   1431 <getpid>
    1ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1ad4:	a1 48 22 00 00       	mov    0x2248,%eax
    1ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1adc:	89 54 24 04          	mov    %edx,0x4(%esp)
    1ae0:	89 04 24             	mov    %eax,(%esp)
    1ae3:	e8 af 00 00 00       	call   1b97 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1ae8:	a1 48 22 00 00       	mov    0x2248,%eax
    1aed:	89 04 24             	mov    %eax,(%esp)
    1af0:	e8 1c 01 00 00       	call   1c11 <pop_q>
    1af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1af8:	a1 30 21 00 00       	mov    0x2130,%eax
    1afd:	85 c0                	test   %eax,%eax
    1aff:	75 1f                	jne    1b20 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1b01:	a1 48 22 00 00       	mov    0x2248,%eax
    1b06:	89 04 24             	mov    %eax,(%esp)
    1b09:	e8 03 01 00 00       	call   1c11 <pop_q>
    1b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1b11:	a1 30 21 00 00       	mov    0x2130,%eax
    1b16:	83 c0 01             	add    $0x1,%eax
    1b19:	a3 30 21 00 00       	mov    %eax,0x2130
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1b1e:	eb 12                	jmp    1b32 <thread_yield2+0x6c>
    1b20:	eb 10                	jmp    1b32 <thread_yield2+0x6c>
    1b22:	a1 48 22 00 00       	mov    0x2248,%eax
    1b27:	89 04 24             	mov    %eax,(%esp)
    1b2a:	e8 e2 00 00 00       	call   1c11 <pop_q>
    1b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1b38:	74 e8                	je     1b22 <thread_yield2+0x5c>
    1b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b3e:	74 e2                	je     1b22 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b43:	89 04 24             	mov    %eax,(%esp)
    1b46:	e8 1e f9 ff ff       	call   1469 <twakeup>
    tsleep();
    1b4b:	e8 11 f9 ff ff       	call   1461 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1b50:	c9                   	leave  
    1b51:	c3                   	ret    

00001b52 <thread_yield_last>:

void thread_yield_last(){
    1b52:	55                   	push   %ebp
    1b53:	89 e5                	mov    %esp,%ebp
    1b55:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1b58:	a1 48 22 00 00       	mov    0x2248,%eax
    1b5d:	89 04 24             	mov    %eax,(%esp)
    1b60:	e8 ac 00 00 00       	call   1c11 <pop_q>
    1b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6b:	89 04 24             	mov    %eax,(%esp)
    1b6e:	e8 f6 f8 ff ff       	call   1469 <twakeup>
    1b73:	c9                   	leave  
    1b74:	c3                   	ret    

00001b75 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1b75:	55                   	push   %ebp
    1b76:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1b78:	8b 45 08             	mov    0x8(%ebp),%eax
    1b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1b81:	8b 45 08             	mov    0x8(%ebp),%eax
    1b84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1b8b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1b95:	5d                   	pop    %ebp
    1b96:	c3                   	ret    

00001b97 <add_q>:

void add_q(struct queue *q, int v){
    1b97:	55                   	push   %ebp
    1b98:	89 e5                	mov    %esp,%ebp
    1b9a:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1b9d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1ba4:	e8 a4 fc ff ff       	call   184d <malloc>
    1ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
    1bbc:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1bbe:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc1:	8b 40 04             	mov    0x4(%eax),%eax
    1bc4:	85 c0                	test   %eax,%eax
    1bc6:	75 0b                	jne    1bd3 <add_q+0x3c>
        q->head = n;
    1bc8:	8b 45 08             	mov    0x8(%ebp),%eax
    1bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bce:	89 50 04             	mov    %edx,0x4(%eax)
    1bd1:	eb 0c                	jmp    1bdf <add_q+0x48>
    }else{
        q->tail->next = n;
    1bd3:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd6:	8b 40 08             	mov    0x8(%eax),%eax
    1bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bdc:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1bdf:	8b 45 08             	mov    0x8(%ebp),%eax
    1be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1be5:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1be8:	8b 45 08             	mov    0x8(%ebp),%eax
    1beb:	8b 00                	mov    (%eax),%eax
    1bed:	8d 50 01             	lea    0x1(%eax),%edx
    1bf0:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf3:	89 10                	mov    %edx,(%eax)
}
    1bf5:	c9                   	leave  
    1bf6:	c3                   	ret    

00001bf7 <empty_q>:

int empty_q(struct queue *q){
    1bf7:	55                   	push   %ebp
    1bf8:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1bfa:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfd:	8b 00                	mov    (%eax),%eax
    1bff:	85 c0                	test   %eax,%eax
    1c01:	75 07                	jne    1c0a <empty_q+0x13>
        return 1;
    1c03:	b8 01 00 00 00       	mov    $0x1,%eax
    1c08:	eb 05                	jmp    1c0f <empty_q+0x18>
    else
        return 0;
    1c0a:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1c0f:	5d                   	pop    %ebp
    1c10:	c3                   	ret    

00001c11 <pop_q>:
int pop_q(struct queue *q){
    1c11:	55                   	push   %ebp
    1c12:	89 e5                	mov    %esp,%ebp
    1c14:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1c17:	8b 45 08             	mov    0x8(%ebp),%eax
    1c1a:	89 04 24             	mov    %eax,(%esp)
    1c1d:	e8 d5 ff ff ff       	call   1bf7 <empty_q>
    1c22:	85 c0                	test   %eax,%eax
    1c24:	75 5d                	jne    1c83 <pop_q+0x72>
       val = q->head->value; 
    1c26:	8b 45 08             	mov    0x8(%ebp),%eax
    1c29:	8b 40 04             	mov    0x4(%eax),%eax
    1c2c:	8b 00                	mov    (%eax),%eax
    1c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1c31:	8b 45 08             	mov    0x8(%ebp),%eax
    1c34:	8b 40 04             	mov    0x4(%eax),%eax
    1c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1c3a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c3d:	8b 40 04             	mov    0x4(%eax),%eax
    1c40:	8b 50 04             	mov    0x4(%eax),%edx
    1c43:	8b 45 08             	mov    0x8(%ebp),%eax
    1c46:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c4c:	89 04 24             	mov    %eax,(%esp)
    1c4f:	e8 c0 fa ff ff       	call   1714 <free>
       q->size--;
    1c54:	8b 45 08             	mov    0x8(%ebp),%eax
    1c57:	8b 00                	mov    (%eax),%eax
    1c59:	8d 50 ff             	lea    -0x1(%eax),%edx
    1c5c:	8b 45 08             	mov    0x8(%ebp),%eax
    1c5f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1c61:	8b 45 08             	mov    0x8(%ebp),%eax
    1c64:	8b 00                	mov    (%eax),%eax
    1c66:	85 c0                	test   %eax,%eax
    1c68:	75 14                	jne    1c7e <pop_q+0x6d>
            q->head = 0;
    1c6a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1c74:	8b 45 08             	mov    0x8(%ebp),%eax
    1c77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c81:	eb 05                	jmp    1c88 <pop_q+0x77>
    }
    return -1;
    1c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1c88:	c9                   	leave  
    1c89:	c3                   	ret    
