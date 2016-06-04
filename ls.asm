
_ls:     file format elf32-i386


Disassembly of section .text:

00001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 dd 03 00 00       	call   13ef <strlen>
    1012:	8b 55 08             	mov    0x8(%ebp),%edx
    1015:	01 d0                	add    %edx,%eax
    1017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    101a:	eb 04                	jmp    1020 <fmtname+0x20>
    101c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1020:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1023:	3b 45 08             	cmp    0x8(%ebp),%eax
    1026:	72 0a                	jb     1032 <fmtname+0x32>
    1028:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102b:	0f b6 00             	movzbl (%eax),%eax
    102e:	3c 2f                	cmp    $0x2f,%al
    1030:	75 ea                	jne    101c <fmtname+0x1c>
    ;
  p++;
    1032:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1039:	89 04 24             	mov    %eax,(%esp)
    103c:	e8 ae 03 00 00       	call   13ef <strlen>
    1041:	83 f8 0d             	cmp    $0xd,%eax
    1044:	76 05                	jbe    104b <fmtname+0x4b>
    return p;
    1046:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1049:	eb 5f                	jmp    10aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	89 04 24             	mov    %eax,(%esp)
    1051:	e8 99 03 00 00       	call   13ef <strlen>
    1056:	89 44 24 08          	mov    %eax,0x8(%esp)
    105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1061:	c7 04 24 80 23 00 00 	movl   $0x2380,(%esp)
    1068:	e8 11 05 00 00       	call   157e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1070:	89 04 24             	mov    %eax,(%esp)
    1073:	e8 77 03 00 00       	call   13ef <strlen>
    1078:	ba 0e 00 00 00       	mov    $0xe,%edx
    107d:	89 d3                	mov    %edx,%ebx
    107f:	29 c3                	sub    %eax,%ebx
    1081:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1084:	89 04 24             	mov    %eax,(%esp)
    1087:	e8 63 03 00 00       	call   13ef <strlen>
    108c:	05 80 23 00 00       	add    $0x2380,%eax
    1091:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1095:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
    109c:	00 
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 71 03 00 00       	call   1416 <memset>
  return buf;
    10a5:	b8 80 23 00 00       	mov    $0x2380,%eax
}
    10aa:	83 c4 24             	add    $0x24,%esp
    10ad:	5b                   	pop    %ebx
    10ae:	5d                   	pop    %ebp
    10af:	c3                   	ret    

000010b0 <ls>:

void
ls(char *path)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	57                   	push   %edi
    10b4:	56                   	push   %esi
    10b5:	53                   	push   %ebx
    10b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    10bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10c3:	00 
    10c4:	8b 45 08             	mov    0x8(%ebp),%eax
    10c7:	89 04 24             	mov    %eax,(%esp)
    10ca:	e8 34 05 00 00       	call   1603 <open>
    10cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    10d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    10d6:	79 20                	jns    10f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	89 44 24 08          	mov    %eax,0x8(%esp)
    10df:	c7 44 24 04 b7 1e 00 	movl   $0x1eb7,0x4(%esp)
    10e6:	00 
    10e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10ee:	e8 80 06 00 00       	call   1773 <printf>
    return;
    10f3:	e9 01 02 00 00       	jmp    12f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
    10f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    10fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1105:	89 04 24             	mov    %eax,(%esp)
    1108:	e8 0e 05 00 00       	call   161b <fstat>
    110d:	85 c0                	test   %eax,%eax
    110f:	79 2b                	jns    113c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	89 44 24 08          	mov    %eax,0x8(%esp)
    1118:	c7 44 24 04 cb 1e 00 	movl   $0x1ecb,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1127:	e8 47 06 00 00       	call   1773 <printf>
    close(fd);
    112c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    112f:	89 04 24             	mov    %eax,(%esp)
    1132:	e8 b4 04 00 00       	call   15eb <close>
    return;
    1137:	e9 bd 01 00 00       	jmp    12f9 <ls+0x249>
  }
  
  switch(st.type){
    113c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1143:	98                   	cwtl   
    1144:	83 f8 01             	cmp    $0x1,%eax
    1147:	74 53                	je     119c <ls+0xec>
    1149:	83 f8 02             	cmp    $0x2,%eax
    114c:	0f 85 9c 01 00 00    	jne    12ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    1152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    115e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1165:	0f bf d8             	movswl %ax,%ebx
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	89 04 24             	mov    %eax,(%esp)
    116e:	e8 8d fe ff ff       	call   1000 <fmtname>
    1173:	89 7c 24 14          	mov    %edi,0x14(%esp)
    1177:	89 74 24 10          	mov    %esi,0x10(%esp)
    117b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    117f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1183:	c7 44 24 04 df 1e 00 	movl   $0x1edf,0x4(%esp)
    118a:	00 
    118b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1192:	e8 dc 05 00 00       	call   1773 <printf>
    break;
    1197:	e9 52 01 00 00       	jmp    12ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
    119f:	89 04 24             	mov    %eax,(%esp)
    11a2:	e8 48 02 00 00       	call   13ef <strlen>
    11a7:	83 c0 10             	add    $0x10,%eax
    11aa:	3d 00 02 00 00       	cmp    $0x200,%eax
    11af:	76 19                	jbe    11ca <ls+0x11a>
      printf(1, "ls: path too long\n");
    11b1:	c7 44 24 04 ec 1e 00 	movl   $0x1eec,0x4(%esp)
    11b8:	00 
    11b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c0:	e8 ae 05 00 00       	call   1773 <printf>
      break;
    11c5:	e9 24 01 00 00       	jmp    12ee <ls+0x23e>
    }
    strcpy(buf, path);
    11ca:	8b 45 08             	mov    0x8(%ebp),%eax
    11cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 a1 01 00 00       	call   1380 <strcpy>
    p = buf+strlen(buf);
    11df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11e5:	89 04 24             	mov    %eax,(%esp)
    11e8:	e8 02 02 00 00       	call   13ef <strlen>
    11ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
    11f3:	01 d0                	add    %edx,%eax
    11f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
    11f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11fb:	8d 50 01             	lea    0x1(%eax),%edx
    11fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
    1201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    1204:	e9 be 00 00 00       	jmp    12c7 <ls+0x217>
      if(de.inum == 0)
    1209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
    1210:	66 85 c0             	test   %ax,%ax
    1213:	75 05                	jne    121a <ls+0x16a>
        continue;
    1215:	e9 ad 00 00 00       	jmp    12c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
    121a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
    1221:	00 
    1222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    1228:	83 c0 02             	add    $0x2,%eax
    122b:	89 44 24 04          	mov    %eax,0x4(%esp)
    122f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1232:	89 04 24             	mov    %eax,(%esp)
    1235:	e8 44 03 00 00       	call   157e <memmove>
      p[DIRSIZ] = 0;
    123a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    123d:	83 c0 0e             	add    $0xe,%eax
    1240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
    1243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 88 02 00 00       	call   14e3 <stat>
    125b:	85 c0                	test   %eax,%eax
    125d:	79 20                	jns    127f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
    125f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1265:	89 44 24 08          	mov    %eax,0x8(%esp)
    1269:	c7 44 24 04 cb 1e 00 	movl   $0x1ecb,0x4(%esp)
    1270:	00 
    1271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1278:	e8 f6 04 00 00       	call   1773 <printf>
        continue;
    127d:	eb 48                	jmp    12c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    127f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    128b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1292:	0f bf d8             	movswl %ax,%ebx
    1295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    129b:	89 04 24             	mov    %eax,(%esp)
    129e:	e8 5d fd ff ff       	call   1000 <fmtname>
    12a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
    12a7:	89 74 24 10          	mov    %esi,0x10(%esp)
    12ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    12af:	89 44 24 08          	mov    %eax,0x8(%esp)
    12b3:	c7 44 24 04 df 1e 00 	movl   $0x1edf,0x4(%esp)
    12ba:	00 
    12bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c2:	e8 ac 04 00 00       	call   1773 <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    12ce:	00 
    12cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    12d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12dc:	89 04 24             	mov    %eax,(%esp)
    12df:	e8 f7 02 00 00       	call   15db <read>
    12e4:	83 f8 10             	cmp    $0x10,%eax
    12e7:	0f 84 1c ff ff ff    	je     1209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
    12ed:	90                   	nop
  }
  close(fd);
    12ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12f1:	89 04 24             	mov    %eax,(%esp)
    12f4:	e8 f2 02 00 00       	call   15eb <close>
}
    12f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
    12ff:	5b                   	pop    %ebx
    1300:	5e                   	pop    %esi
    1301:	5f                   	pop    %edi
    1302:	5d                   	pop    %ebp
    1303:	c3                   	ret    

00001304 <main>:

int
main(int argc, char *argv[])
{
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	83 e4 f0             	and    $0xfffffff0,%esp
    130a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
    130d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1311:	7f 11                	jg     1324 <main+0x20>
    ls(".");
    1313:	c7 04 24 ff 1e 00 00 	movl   $0x1eff,(%esp)
    131a:	e8 91 fd ff ff       	call   10b0 <ls>
    exit();
    131f:	e8 9f 02 00 00       	call   15c3 <exit>
  }
  for(i=1; i<argc; i++)
    1324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    132b:	00 
    132c:	eb 1f                	jmp    134d <main+0x49>
    ls(argv[i]);
    132e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1339:	8b 45 0c             	mov    0xc(%ebp),%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	8b 00                	mov    (%eax),%eax
    1340:	89 04 24             	mov    %eax,(%esp)
    1343:	e8 68 fd ff ff       	call   10b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    1348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    134d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1351:	3b 45 08             	cmp    0x8(%ebp),%eax
    1354:	7c d8                	jl     132e <main+0x2a>
    ls(argv[i]);
  exit();
    1356:	e8 68 02 00 00       	call   15c3 <exit>

0000135b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    135b:	55                   	push   %ebp
    135c:	89 e5                	mov    %esp,%ebp
    135e:	57                   	push   %edi
    135f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1360:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1363:	8b 55 10             	mov    0x10(%ebp),%edx
    1366:	8b 45 0c             	mov    0xc(%ebp),%eax
    1369:	89 cb                	mov    %ecx,%ebx
    136b:	89 df                	mov    %ebx,%edi
    136d:	89 d1                	mov    %edx,%ecx
    136f:	fc                   	cld    
    1370:	f3 aa                	rep stos %al,%es:(%edi)
    1372:	89 ca                	mov    %ecx,%edx
    1374:	89 fb                	mov    %edi,%ebx
    1376:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    137c:	5b                   	pop    %ebx
    137d:	5f                   	pop    %edi
    137e:	5d                   	pop    %ebp
    137f:	c3                   	ret    

00001380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1380:	55                   	push   %ebp
    1381:	89 e5                	mov    %esp,%ebp
    1383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1386:	8b 45 08             	mov    0x8(%ebp),%eax
    1389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    138c:	90                   	nop
    138d:	8b 45 08             	mov    0x8(%ebp),%eax
    1390:	8d 50 01             	lea    0x1(%eax),%edx
    1393:	89 55 08             	mov    %edx,0x8(%ebp)
    1396:	8b 55 0c             	mov    0xc(%ebp),%edx
    1399:	8d 4a 01             	lea    0x1(%edx),%ecx
    139c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    139f:	0f b6 12             	movzbl (%edx),%edx
    13a2:	88 10                	mov    %dl,(%eax)
    13a4:	0f b6 00             	movzbl (%eax),%eax
    13a7:	84 c0                	test   %al,%al
    13a9:	75 e2                	jne    138d <strcpy+0xd>
    ;
  return os;
    13ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13ae:	c9                   	leave  
    13af:	c3                   	ret    

000013b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13b3:	eb 08                	jmp    13bd <strcmp+0xd>
    p++, q++;
    13b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	0f b6 00             	movzbl (%eax),%eax
    13c3:	84 c0                	test   %al,%al
    13c5:	74 10                	je     13d7 <strcmp+0x27>
    13c7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ca:	0f b6 10             	movzbl (%eax),%edx
    13cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d0:	0f b6 00             	movzbl (%eax),%eax
    13d3:	38 c2                	cmp    %al,%dl
    13d5:	74 de                	je     13b5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	0f b6 00             	movzbl (%eax),%eax
    13dd:	0f b6 d0             	movzbl %al,%edx
    13e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e3:	0f b6 00             	movzbl (%eax),%eax
    13e6:	0f b6 c0             	movzbl %al,%eax
    13e9:	29 c2                	sub    %eax,%edx
    13eb:	89 d0                	mov    %edx,%eax
}
    13ed:	5d                   	pop    %ebp
    13ee:	c3                   	ret    

000013ef <strlen>:

uint
strlen(char *s)
{
    13ef:	55                   	push   %ebp
    13f0:	89 e5                	mov    %esp,%ebp
    13f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13fc:	eb 04                	jmp    1402 <strlen+0x13>
    13fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1402:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1405:	8b 45 08             	mov    0x8(%ebp),%eax
    1408:	01 d0                	add    %edx,%eax
    140a:	0f b6 00             	movzbl (%eax),%eax
    140d:	84 c0                	test   %al,%al
    140f:	75 ed                	jne    13fe <strlen+0xf>
    ;
  return n;
    1411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1414:	c9                   	leave  
    1415:	c3                   	ret    

00001416 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1416:	55                   	push   %ebp
    1417:	89 e5                	mov    %esp,%ebp
    1419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    141c:	8b 45 10             	mov    0x10(%ebp),%eax
    141f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1423:	8b 45 0c             	mov    0xc(%ebp),%eax
    1426:	89 44 24 04          	mov    %eax,0x4(%esp)
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
    142d:	89 04 24             	mov    %eax,(%esp)
    1430:	e8 26 ff ff ff       	call   135b <stosb>
  return dst;
    1435:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1438:	c9                   	leave  
    1439:	c3                   	ret    

0000143a <strchr>:

char*
strchr(const char *s, char c)
{
    143a:	55                   	push   %ebp
    143b:	89 e5                	mov    %esp,%ebp
    143d:	83 ec 04             	sub    $0x4,%esp
    1440:	8b 45 0c             	mov    0xc(%ebp),%eax
    1443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1446:	eb 14                	jmp    145c <strchr+0x22>
    if(*s == c)
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1451:	75 05                	jne    1458 <strchr+0x1e>
      return (char*)s;
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	eb 13                	jmp    146b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    145c:	8b 45 08             	mov    0x8(%ebp),%eax
    145f:	0f b6 00             	movzbl (%eax),%eax
    1462:	84 c0                	test   %al,%al
    1464:	75 e2                	jne    1448 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1466:	b8 00 00 00 00       	mov    $0x0,%eax
}
    146b:	c9                   	leave  
    146c:	c3                   	ret    

0000146d <gets>:

char*
gets(char *buf, int max)
{
    146d:	55                   	push   %ebp
    146e:	89 e5                	mov    %esp,%ebp
    1470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    147a:	eb 4c                	jmp    14c8 <gets+0x5b>
    cc = read(0, &c, 1);
    147c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1483:	00 
    1484:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1487:	89 44 24 04          	mov    %eax,0x4(%esp)
    148b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1492:	e8 44 01 00 00       	call   15db <read>
    1497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    149a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    149e:	7f 02                	jg     14a2 <gets+0x35>
      break;
    14a0:	eb 31                	jmp    14d3 <gets+0x66>
    buf[i++] = c;
    14a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a5:	8d 50 01             	lea    0x1(%eax),%edx
    14a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14ab:	89 c2                	mov    %eax,%edx
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	01 c2                	add    %eax,%edx
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14bc:	3c 0a                	cmp    $0xa,%al
    14be:	74 13                	je     14d3 <gets+0x66>
    14c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14c4:	3c 0d                	cmp    $0xd,%al
    14c6:	74 0b                	je     14d3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cb:	83 c0 01             	add    $0x1,%eax
    14ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14d1:	7c a9                	jl     147c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14d6:	8b 45 08             	mov    0x8(%ebp),%eax
    14d9:	01 d0                	add    %edx,%eax
    14db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14de:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14e1:	c9                   	leave  
    14e2:	c3                   	ret    

000014e3 <stat>:

int
stat(char *n, struct stat *st)
{
    14e3:	55                   	push   %ebp
    14e4:	89 e5                	mov    %esp,%ebp
    14e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f0:	00 
    14f1:	8b 45 08             	mov    0x8(%ebp),%eax
    14f4:	89 04 24             	mov    %eax,(%esp)
    14f7:	e8 07 01 00 00       	call   1603 <open>
    14fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1503:	79 07                	jns    150c <stat+0x29>
    return -1;
    1505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    150a:	eb 23                	jmp    152f <stat+0x4c>
  r = fstat(fd, st);
    150c:	8b 45 0c             	mov    0xc(%ebp),%eax
    150f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1513:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 fd 00 00 00       	call   161b <fstat>
    151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1521:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1524:	89 04 24             	mov    %eax,(%esp)
    1527:	e8 bf 00 00 00       	call   15eb <close>
  return r;
    152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    152f:	c9                   	leave  
    1530:	c3                   	ret    

00001531 <atoi>:

int
atoi(const char *s)
{
    1531:	55                   	push   %ebp
    1532:	89 e5                	mov    %esp,%ebp
    1534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    153e:	eb 25                	jmp    1565 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1540:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1543:	89 d0                	mov    %edx,%eax
    1545:	c1 e0 02             	shl    $0x2,%eax
    1548:	01 d0                	add    %edx,%eax
    154a:	01 c0                	add    %eax,%eax
    154c:	89 c1                	mov    %eax,%ecx
    154e:	8b 45 08             	mov    0x8(%ebp),%eax
    1551:	8d 50 01             	lea    0x1(%eax),%edx
    1554:	89 55 08             	mov    %edx,0x8(%ebp)
    1557:	0f b6 00             	movzbl (%eax),%eax
    155a:	0f be c0             	movsbl %al,%eax
    155d:	01 c8                	add    %ecx,%eax
    155f:	83 e8 30             	sub    $0x30,%eax
    1562:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1565:	8b 45 08             	mov    0x8(%ebp),%eax
    1568:	0f b6 00             	movzbl (%eax),%eax
    156b:	3c 2f                	cmp    $0x2f,%al
    156d:	7e 0a                	jle    1579 <atoi+0x48>
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	0f b6 00             	movzbl (%eax),%eax
    1575:	3c 39                	cmp    $0x39,%al
    1577:	7e c7                	jle    1540 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    157c:	c9                   	leave  
    157d:	c3                   	ret    

0000157e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    157e:	55                   	push   %ebp
    157f:	89 e5                	mov    %esp,%ebp
    1581:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
    1587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    158a:	8b 45 0c             	mov    0xc(%ebp),%eax
    158d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1590:	eb 17                	jmp    15a9 <memmove+0x2b>
    *dst++ = *src++;
    1592:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1595:	8d 50 01             	lea    0x1(%eax),%edx
    1598:	89 55 fc             	mov    %edx,-0x4(%ebp)
    159b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    159e:	8d 4a 01             	lea    0x1(%edx),%ecx
    15a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    15a4:	0f b6 12             	movzbl (%edx),%edx
    15a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    15a9:	8b 45 10             	mov    0x10(%ebp),%eax
    15ac:	8d 50 ff             	lea    -0x1(%eax),%edx
    15af:	89 55 10             	mov    %edx,0x10(%ebp)
    15b2:	85 c0                	test   %eax,%eax
    15b4:	7f dc                	jg     1592 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b9:	c9                   	leave  
    15ba:	c3                   	ret    

000015bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15bb:	b8 01 00 00 00       	mov    $0x1,%eax
    15c0:	cd 40                	int    $0x40
    15c2:	c3                   	ret    

000015c3 <exit>:
SYSCALL(exit)
    15c3:	b8 02 00 00 00       	mov    $0x2,%eax
    15c8:	cd 40                	int    $0x40
    15ca:	c3                   	ret    

000015cb <wait>:
SYSCALL(wait)
    15cb:	b8 03 00 00 00       	mov    $0x3,%eax
    15d0:	cd 40                	int    $0x40
    15d2:	c3                   	ret    

000015d3 <pipe>:
SYSCALL(pipe)
    15d3:	b8 04 00 00 00       	mov    $0x4,%eax
    15d8:	cd 40                	int    $0x40
    15da:	c3                   	ret    

000015db <read>:
SYSCALL(read)
    15db:	b8 05 00 00 00       	mov    $0x5,%eax
    15e0:	cd 40                	int    $0x40
    15e2:	c3                   	ret    

000015e3 <write>:
SYSCALL(write)
    15e3:	b8 10 00 00 00       	mov    $0x10,%eax
    15e8:	cd 40                	int    $0x40
    15ea:	c3                   	ret    

000015eb <close>:
SYSCALL(close)
    15eb:	b8 15 00 00 00       	mov    $0x15,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <kill>:
SYSCALL(kill)
    15f3:	b8 06 00 00 00       	mov    $0x6,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <exec>:
SYSCALL(exec)
    15fb:	b8 07 00 00 00       	mov    $0x7,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <open>:
SYSCALL(open)
    1603:	b8 0f 00 00 00       	mov    $0xf,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <mknod>:
SYSCALL(mknod)
    160b:	b8 11 00 00 00       	mov    $0x11,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <unlink>:
SYSCALL(unlink)
    1613:	b8 12 00 00 00       	mov    $0x12,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <fstat>:
SYSCALL(fstat)
    161b:	b8 08 00 00 00       	mov    $0x8,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <link>:
SYSCALL(link)
    1623:	b8 13 00 00 00       	mov    $0x13,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <mkdir>:
SYSCALL(mkdir)
    162b:	b8 14 00 00 00       	mov    $0x14,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <chdir>:
SYSCALL(chdir)
    1633:	b8 09 00 00 00       	mov    $0x9,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <dup>:
SYSCALL(dup)
    163b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <getpid>:
SYSCALL(getpid)
    1643:	b8 0b 00 00 00       	mov    $0xb,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <sbrk>:
SYSCALL(sbrk)
    164b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <sleep>:
SYSCALL(sleep)
    1653:	b8 0d 00 00 00       	mov    $0xd,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <uptime>:
SYSCALL(uptime)
    165b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    

00001663 <clone>:
SYSCALL(clone)
    1663:	b8 16 00 00 00       	mov    $0x16,%eax
    1668:	cd 40                	int    $0x40
    166a:	c3                   	ret    

0000166b <texit>:
SYSCALL(texit)
    166b:	b8 17 00 00 00       	mov    $0x17,%eax
    1670:	cd 40                	int    $0x40
    1672:	c3                   	ret    

00001673 <tsleep>:
SYSCALL(tsleep)
    1673:	b8 18 00 00 00       	mov    $0x18,%eax
    1678:	cd 40                	int    $0x40
    167a:	c3                   	ret    

0000167b <twakeup>:
SYSCALL(twakeup)
    167b:	b8 19 00 00 00       	mov    $0x19,%eax
    1680:	cd 40                	int    $0x40
    1682:	c3                   	ret    

00001683 <thread_yield>:
SYSCALL(thread_yield)
    1683:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1688:	cd 40                	int    $0x40
    168a:	c3                   	ret    

0000168b <thread_yield3>:
    168b:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1690:	cd 40                	int    $0x40
    1692:	c3                   	ret    

00001693 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1693:	55                   	push   %ebp
    1694:	89 e5                	mov    %esp,%ebp
    1696:	83 ec 18             	sub    $0x18,%esp
    1699:	8b 45 0c             	mov    0xc(%ebp),%eax
    169c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    169f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    16a6:	00 
    16a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
    16aa:	89 44 24 04          	mov    %eax,0x4(%esp)
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	89 04 24             	mov    %eax,(%esp)
    16b4:	e8 2a ff ff ff       	call   15e3 <write>
}
    16b9:	c9                   	leave  
    16ba:	c3                   	ret    

000016bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16bb:	55                   	push   %ebp
    16bc:	89 e5                	mov    %esp,%ebp
    16be:	56                   	push   %esi
    16bf:	53                   	push   %ebx
    16c0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16ca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16ce:	74 17                	je     16e7 <printint+0x2c>
    16d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16d4:	79 11                	jns    16e7 <printint+0x2c>
    neg = 1;
    16d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16dd:	8b 45 0c             	mov    0xc(%ebp),%eax
    16e0:	f7 d8                	neg    %eax
    16e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16e5:	eb 06                	jmp    16ed <printint+0x32>
  } else {
    x = xx;
    16e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16f4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16f7:	8d 41 01             	lea    0x1(%ecx),%eax
    16fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1700:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1703:	ba 00 00 00 00       	mov    $0x0,%edx
    1708:	f7 f3                	div    %ebx
    170a:	89 d0                	mov    %edx,%eax
    170c:	0f b6 80 68 23 00 00 	movzbl 0x2368(%eax),%eax
    1713:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1717:	8b 75 10             	mov    0x10(%ebp),%esi
    171a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    171d:	ba 00 00 00 00       	mov    $0x0,%edx
    1722:	f7 f6                	div    %esi
    1724:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1727:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    172b:	75 c7                	jne    16f4 <printint+0x39>
  if(neg)
    172d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1731:	74 10                	je     1743 <printint+0x88>
    buf[i++] = '-';
    1733:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1736:	8d 50 01             	lea    0x1(%eax),%edx
    1739:	89 55 f4             	mov    %edx,-0xc(%ebp)
    173c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1741:	eb 1f                	jmp    1762 <printint+0xa7>
    1743:	eb 1d                	jmp    1762 <printint+0xa7>
    putc(fd, buf[i]);
    1745:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1748:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174b:	01 d0                	add    %edx,%eax
    174d:	0f b6 00             	movzbl (%eax),%eax
    1750:	0f be c0             	movsbl %al,%eax
    1753:	89 44 24 04          	mov    %eax,0x4(%esp)
    1757:	8b 45 08             	mov    0x8(%ebp),%eax
    175a:	89 04 24             	mov    %eax,(%esp)
    175d:	e8 31 ff ff ff       	call   1693 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1762:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1766:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    176a:	79 d9                	jns    1745 <printint+0x8a>
    putc(fd, buf[i]);
}
    176c:	83 c4 30             	add    $0x30,%esp
    176f:	5b                   	pop    %ebx
    1770:	5e                   	pop    %esi
    1771:	5d                   	pop    %ebp
    1772:	c3                   	ret    

00001773 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1773:	55                   	push   %ebp
    1774:	89 e5                	mov    %esp,%ebp
    1776:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1779:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1780:	8d 45 0c             	lea    0xc(%ebp),%eax
    1783:	83 c0 04             	add    $0x4,%eax
    1786:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1790:	e9 7c 01 00 00       	jmp    1911 <printf+0x19e>
    c = fmt[i] & 0xff;
    1795:	8b 55 0c             	mov    0xc(%ebp),%edx
    1798:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179b:	01 d0                	add    %edx,%eax
    179d:	0f b6 00             	movzbl (%eax),%eax
    17a0:	0f be c0             	movsbl %al,%eax
    17a3:	25 ff 00 00 00       	and    $0xff,%eax
    17a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    17ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17af:	75 2c                	jne    17dd <printf+0x6a>
      if(c == '%'){
    17b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17b5:	75 0c                	jne    17c3 <printf+0x50>
        state = '%';
    17b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17be:	e9 4a 01 00 00       	jmp    190d <printf+0x19a>
      } else {
        putc(fd, c);
    17c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17c6:	0f be c0             	movsbl %al,%eax
    17c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    17cd:	8b 45 08             	mov    0x8(%ebp),%eax
    17d0:	89 04 24             	mov    %eax,(%esp)
    17d3:	e8 bb fe ff ff       	call   1693 <putc>
    17d8:	e9 30 01 00 00       	jmp    190d <printf+0x19a>
      }
    } else if(state == '%'){
    17dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17e1:	0f 85 26 01 00 00    	jne    190d <printf+0x19a>
      if(c == 'd'){
    17e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17eb:	75 2d                	jne    181a <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17f0:	8b 00                	mov    (%eax),%eax
    17f2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17f9:	00 
    17fa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1801:	00 
    1802:	89 44 24 04          	mov    %eax,0x4(%esp)
    1806:	8b 45 08             	mov    0x8(%ebp),%eax
    1809:	89 04 24             	mov    %eax,(%esp)
    180c:	e8 aa fe ff ff       	call   16bb <printint>
        ap++;
    1811:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1815:	e9 ec 00 00 00       	jmp    1906 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    181a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    181e:	74 06                	je     1826 <printf+0xb3>
    1820:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1824:	75 2d                	jne    1853 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1826:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1829:	8b 00                	mov    (%eax),%eax
    182b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1832:	00 
    1833:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    183a:	00 
    183b:	89 44 24 04          	mov    %eax,0x4(%esp)
    183f:	8b 45 08             	mov    0x8(%ebp),%eax
    1842:	89 04 24             	mov    %eax,(%esp)
    1845:	e8 71 fe ff ff       	call   16bb <printint>
        ap++;
    184a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    184e:	e9 b3 00 00 00       	jmp    1906 <printf+0x193>
      } else if(c == 's'){
    1853:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1857:	75 45                	jne    189e <printf+0x12b>
        s = (char*)*ap;
    1859:	8b 45 e8             	mov    -0x18(%ebp),%eax
    185c:	8b 00                	mov    (%eax),%eax
    185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1861:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1869:	75 09                	jne    1874 <printf+0x101>
          s = "(null)";
    186b:	c7 45 f4 01 1f 00 00 	movl   $0x1f01,-0xc(%ebp)
        while(*s != 0){
    1872:	eb 1e                	jmp    1892 <printf+0x11f>
    1874:	eb 1c                	jmp    1892 <printf+0x11f>
          putc(fd, *s);
    1876:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1879:	0f b6 00             	movzbl (%eax),%eax
    187c:	0f be c0             	movsbl %al,%eax
    187f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1883:	8b 45 08             	mov    0x8(%ebp),%eax
    1886:	89 04 24             	mov    %eax,(%esp)
    1889:	e8 05 fe ff ff       	call   1693 <putc>
          s++;
    188e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1892:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1895:	0f b6 00             	movzbl (%eax),%eax
    1898:	84 c0                	test   %al,%al
    189a:	75 da                	jne    1876 <printf+0x103>
    189c:	eb 68                	jmp    1906 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    189e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    18a2:	75 1d                	jne    18c1 <printf+0x14e>
        putc(fd, *ap);
    18a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18a7:	8b 00                	mov    (%eax),%eax
    18a9:	0f be c0             	movsbl %al,%eax
    18ac:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b0:	8b 45 08             	mov    0x8(%ebp),%eax
    18b3:	89 04 24             	mov    %eax,(%esp)
    18b6:	e8 d8 fd ff ff       	call   1693 <putc>
        ap++;
    18bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18bf:	eb 45                	jmp    1906 <printf+0x193>
      } else if(c == '%'){
    18c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18c5:	75 17                	jne    18de <printf+0x16b>
        putc(fd, c);
    18c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18ca:	0f be c0             	movsbl %al,%eax
    18cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    18d1:	8b 45 08             	mov    0x8(%ebp),%eax
    18d4:	89 04 24             	mov    %eax,(%esp)
    18d7:	e8 b7 fd ff ff       	call   1693 <putc>
    18dc:	eb 28                	jmp    1906 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18de:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18e5:	00 
    18e6:	8b 45 08             	mov    0x8(%ebp),%eax
    18e9:	89 04 24             	mov    %eax,(%esp)
    18ec:	e8 a2 fd ff ff       	call   1693 <putc>
        putc(fd, c);
    18f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18f4:	0f be c0             	movsbl %al,%eax
    18f7:	89 44 24 04          	mov    %eax,0x4(%esp)
    18fb:	8b 45 08             	mov    0x8(%ebp),%eax
    18fe:	89 04 24             	mov    %eax,(%esp)
    1901:	e8 8d fd ff ff       	call   1693 <putc>
      }
      state = 0;
    1906:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    190d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1911:	8b 55 0c             	mov    0xc(%ebp),%edx
    1914:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1917:	01 d0                	add    %edx,%eax
    1919:	0f b6 00             	movzbl (%eax),%eax
    191c:	84 c0                	test   %al,%al
    191e:	0f 85 71 fe ff ff    	jne    1795 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1924:	c9                   	leave  
    1925:	c3                   	ret    

00001926 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1926:	55                   	push   %ebp
    1927:	89 e5                	mov    %esp,%ebp
    1929:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    192c:	8b 45 08             	mov    0x8(%ebp),%eax
    192f:	83 e8 08             	sub    $0x8,%eax
    1932:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1935:	a1 98 23 00 00       	mov    0x2398,%eax
    193a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    193d:	eb 24                	jmp    1963 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1942:	8b 00                	mov    (%eax),%eax
    1944:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1947:	77 12                	ja     195b <free+0x35>
    1949:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    194f:	77 24                	ja     1975 <free+0x4f>
    1951:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1954:	8b 00                	mov    (%eax),%eax
    1956:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1959:	77 1a                	ja     1975 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195e:	8b 00                	mov    (%eax),%eax
    1960:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1963:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1966:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1969:	76 d4                	jbe    193f <free+0x19>
    196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196e:	8b 00                	mov    (%eax),%eax
    1970:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1973:	76 ca                	jbe    193f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1975:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1978:	8b 40 04             	mov    0x4(%eax),%eax
    197b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1982:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1985:	01 c2                	add    %eax,%edx
    1987:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198a:	8b 00                	mov    (%eax),%eax
    198c:	39 c2                	cmp    %eax,%edx
    198e:	75 24                	jne    19b4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1990:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1993:	8b 50 04             	mov    0x4(%eax),%edx
    1996:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1999:	8b 00                	mov    (%eax),%eax
    199b:	8b 40 04             	mov    0x4(%eax),%eax
    199e:	01 c2                	add    %eax,%edx
    19a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19a3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    19a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a9:	8b 00                	mov    (%eax),%eax
    19ab:	8b 10                	mov    (%eax),%edx
    19ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b0:	89 10                	mov    %edx,(%eax)
    19b2:	eb 0a                	jmp    19be <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    19b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b7:	8b 10                	mov    (%eax),%edx
    19b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19bc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c1:	8b 40 04             	mov    0x4(%eax),%eax
    19c4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ce:	01 d0                	add    %edx,%eax
    19d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19d3:	75 20                	jne    19f5 <free+0xcf>
    p->s.size += bp->s.size;
    19d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d8:	8b 50 04             	mov    0x4(%eax),%edx
    19db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19de:	8b 40 04             	mov    0x4(%eax),%eax
    19e1:	01 c2                	add    %eax,%edx
    19e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ec:	8b 10                	mov    (%eax),%edx
    19ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f1:	89 10                	mov    %edx,(%eax)
    19f3:	eb 08                	jmp    19fd <free+0xd7>
  } else
    p->s.ptr = bp;
    19f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19fb:	89 10                	mov    %edx,(%eax)
  freep = p;
    19fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a00:	a3 98 23 00 00       	mov    %eax,0x2398
}
    1a05:	c9                   	leave  
    1a06:	c3                   	ret    

00001a07 <morecore>:

static Header*
morecore(uint nu)
{
    1a07:	55                   	push   %ebp
    1a08:	89 e5                	mov    %esp,%ebp
    1a0a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a0d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a14:	77 07                	ja     1a1d <morecore+0x16>
    nu = 4096;
    1a16:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a1d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a20:	c1 e0 03             	shl    $0x3,%eax
    1a23:	89 04 24             	mov    %eax,(%esp)
    1a26:	e8 20 fc ff ff       	call   164b <sbrk>
    1a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a2e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a32:	75 07                	jne    1a3b <morecore+0x34>
    return 0;
    1a34:	b8 00 00 00 00       	mov    $0x0,%eax
    1a39:	eb 22                	jmp    1a5d <morecore+0x56>
  hp = (Header*)p;
    1a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a44:	8b 55 08             	mov    0x8(%ebp),%edx
    1a47:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a4d:	83 c0 08             	add    $0x8,%eax
    1a50:	89 04 24             	mov    %eax,(%esp)
    1a53:	e8 ce fe ff ff       	call   1926 <free>
  return freep;
    1a58:	a1 98 23 00 00       	mov    0x2398,%eax
}
    1a5d:	c9                   	leave  
    1a5e:	c3                   	ret    

00001a5f <malloc>:

void*
malloc(uint nbytes)
{
    1a5f:	55                   	push   %ebp
    1a60:	89 e5                	mov    %esp,%ebp
    1a62:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a65:	8b 45 08             	mov    0x8(%ebp),%eax
    1a68:	83 c0 07             	add    $0x7,%eax
    1a6b:	c1 e8 03             	shr    $0x3,%eax
    1a6e:	83 c0 01             	add    $0x1,%eax
    1a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a74:	a1 98 23 00 00       	mov    0x2398,%eax
    1a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a80:	75 23                	jne    1aa5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a82:	c7 45 f0 90 23 00 00 	movl   $0x2390,-0x10(%ebp)
    1a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a8c:	a3 98 23 00 00       	mov    %eax,0x2398
    1a91:	a1 98 23 00 00       	mov    0x2398,%eax
    1a96:	a3 90 23 00 00       	mov    %eax,0x2390
    base.s.size = 0;
    1a9b:	c7 05 94 23 00 00 00 	movl   $0x0,0x2394
    1aa2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa8:	8b 00                	mov    (%eax),%eax
    1aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab0:	8b 40 04             	mov    0x4(%eax),%eax
    1ab3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ab6:	72 4d                	jb     1b05 <malloc+0xa6>
      if(p->s.size == nunits)
    1ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abb:	8b 40 04             	mov    0x4(%eax),%eax
    1abe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ac1:	75 0c                	jne    1acf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac6:	8b 10                	mov    (%eax),%edx
    1ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1acb:	89 10                	mov    %edx,(%eax)
    1acd:	eb 26                	jmp    1af5 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad2:	8b 40 04             	mov    0x4(%eax),%eax
    1ad5:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ad8:	89 c2                	mov    %eax,%edx
    1ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1add:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae3:	8b 40 04             	mov    0x4(%eax),%eax
    1ae6:	c1 e0 03             	shl    $0x3,%eax
    1ae9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1af2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1af8:	a3 98 23 00 00       	mov    %eax,0x2398
      return (void*)(p + 1);
    1afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b00:	83 c0 08             	add    $0x8,%eax
    1b03:	eb 38                	jmp    1b3d <malloc+0xde>
    }
    if(p == freep)
    1b05:	a1 98 23 00 00       	mov    0x2398,%eax
    1b0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b0d:	75 1b                	jne    1b2a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b12:	89 04 24             	mov    %eax,(%esp)
    1b15:	e8 ed fe ff ff       	call   1a07 <morecore>
    1b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b21:	75 07                	jne    1b2a <malloc+0xcb>
        return 0;
    1b23:	b8 00 00 00 00       	mov    $0x0,%eax
    1b28:	eb 13                	jmp    1b3d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b33:	8b 00                	mov    (%eax),%eax
    1b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b38:	e9 70 ff ff ff       	jmp    1aad <malloc+0x4e>
}
    1b3d:	c9                   	leave  
    1b3e:	c3                   	ret    

00001b3f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1b3f:	55                   	push   %ebp
    1b40:	89 e5                	mov    %esp,%ebp
    1b42:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1b45:	8b 55 08             	mov    0x8(%ebp),%edx
    1b48:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b4e:	f0 87 02             	lock xchg %eax,(%edx)
    1b51:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1b57:	c9                   	leave  
    1b58:	c3                   	ret    

00001b59 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    1b59:	55                   	push   %ebp
    1b5a:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    1b5c:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b65:	5d                   	pop    %ebp
    1b66:	c3                   	ret    

00001b67 <lock_acquire>:
void lock_acquire(lock_t *lock){
    1b67:	55                   	push   %ebp
    1b68:	89 e5                	mov    %esp,%ebp
    1b6a:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    1b6d:	90                   	nop
    1b6e:	8b 45 08             	mov    0x8(%ebp),%eax
    1b71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b78:	00 
    1b79:	89 04 24             	mov    %eax,(%esp)
    1b7c:	e8 be ff ff ff       	call   1b3f <xchg>
    1b81:	85 c0                	test   %eax,%eax
    1b83:	75 e9                	jne    1b6e <lock_acquire+0x7>
}
    1b85:	c9                   	leave  
    1b86:	c3                   	ret    

00001b87 <lock_release>:
void lock_release(lock_t *lock){
    1b87:	55                   	push   %ebp
    1b88:	89 e5                	mov    %esp,%ebp
    1b8a:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    1b8d:	8b 45 08             	mov    0x8(%ebp),%eax
    1b90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b97:	00 
    1b98:	89 04 24             	mov    %eax,(%esp)
    1b9b:	e8 9f ff ff ff       	call   1b3f <xchg>
}
    1ba0:	c9                   	leave  
    1ba1:	c3                   	ret    

00001ba2 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    1ba2:	55                   	push   %ebp
    1ba3:	89 e5                	mov    %esp,%ebp
    1ba5:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    1ba8:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    1baf:	e8 ab fe ff ff       	call   1a5f <malloc>
    1bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    1bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    1bbd:	0f b6 05 9c 23 00 00 	movzbl 0x239c,%eax
    1bc4:	84 c0                	test   %al,%al
    1bc6:	75 1c                	jne    1be4 <thread_create+0x42>
        init_q(thQ2);
    1bc8:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1bcd:	89 04 24             	mov    %eax,(%esp)
    1bd0:	e8 cd 01 00 00       	call   1da2 <init_q>
        inQ++;
    1bd5:	0f b6 05 9c 23 00 00 	movzbl 0x239c,%eax
    1bdc:	83 c0 01             	add    $0x1,%eax
    1bdf:	a2 9c 23 00 00       	mov    %al,0x239c
    }

    if((uint)stack % 4096){
    1be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be7:	25 ff 0f 00 00       	and    $0xfff,%eax
    1bec:	85 c0                	test   %eax,%eax
    1bee:	74 14                	je     1c04 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    1bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bf3:	25 ff 0f 00 00       	and    $0xfff,%eax
    1bf8:	89 c2                	mov    %eax,%edx
    1bfa:	b8 00 10 00 00       	mov    $0x1000,%eax
    1bff:	29 d0                	sub    %edx,%eax
    1c01:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    1c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c08:	75 1e                	jne    1c28 <thread_create+0x86>

        printf(1,"malloc fail \n");
    1c0a:	c7 44 24 04 08 1f 00 	movl   $0x1f08,0x4(%esp)
    1c11:	00 
    1c12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c19:	e8 55 fb ff ff       	call   1773 <printf>
        return 0;
    1c1e:	b8 00 00 00 00       	mov    $0x0,%eax
    1c23:	e9 9e 00 00 00       	jmp    1cc6 <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    1c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1c2b:	8b 55 08             	mov    0x8(%ebp),%edx
    1c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    1c35:	89 54 24 08          	mov    %edx,0x8(%esp)
    1c39:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    1c40:	00 
    1c41:	89 04 24             	mov    %eax,(%esp)
    1c44:	e8 1a fa ff ff       	call   1663 <clone>
    1c49:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    1c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c4f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1c53:	c7 44 24 04 16 1f 00 	movl   $0x1f16,0x4(%esp)
    1c5a:	00 
    1c5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c62:	e8 0c fb ff ff       	call   1773 <printf>
    if(tid < 0){
    1c67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c6b:	79 1b                	jns    1c88 <thread_create+0xe6>
        printf(1,"clone fails\n");
    1c6d:	c7 44 24 04 2f 1f 00 	movl   $0x1f2f,0x4(%esp)
    1c74:	00 
    1c75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c7c:	e8 f2 fa ff ff       	call   1773 <printf>
        return 0;
    1c81:	b8 00 00 00 00       	mov    $0x0,%eax
    1c86:	eb 3e                	jmp    1cc6 <thread_create+0x124>
    }
    if(tid > 0){
    1c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c8c:	7e 19                	jle    1ca7 <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    1c8e:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1c96:	89 54 24 04          	mov    %edx,0x4(%esp)
    1c9a:	89 04 24             	mov    %eax,(%esp)
    1c9d:	e8 22 01 00 00       	call   1dc4 <add_q>
        return garbage_stack;
    1ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ca5:	eb 1f                	jmp    1cc6 <thread_create+0x124>
    }
    if(tid == 0){
    1ca7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cab:	75 14                	jne    1cc1 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    1cad:	c7 44 24 04 3c 1f 00 	movl   $0x1f3c,0x4(%esp)
    1cb4:	00 
    1cb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cbc:	e8 b2 fa ff ff       	call   1773 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    1cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1cc6:	c9                   	leave  
    1cc7:	c3                   	ret    

00001cc8 <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    1cc8:	55                   	push   %ebp
    1cc9:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    1ccb:	a1 7c 23 00 00       	mov    0x237c,%eax
    1cd0:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    1cd6:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    1cdb:	a3 7c 23 00 00       	mov    %eax,0x237c
    return (int)(rands % max);
    1ce0:	a1 7c 23 00 00       	mov    0x237c,%eax
    1ce5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1ce8:	ba 00 00 00 00       	mov    $0x0,%edx
    1ced:	f7 f1                	div    %ecx
    1cef:	89 d0                	mov    %edx,%eax
}
    1cf1:	5d                   	pop    %ebp
    1cf2:	c3                   	ret    

00001cf3 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    1cf3:	55                   	push   %ebp
    1cf4:	89 e5                	mov    %esp,%ebp
    1cf6:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    1cf9:	e8 45 f9 ff ff       	call   1643 <getpid>
    1cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    1d01:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1d06:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1d09:	89 54 24 04          	mov    %edx,0x4(%esp)
    1d0d:	89 04 24             	mov    %eax,(%esp)
    1d10:	e8 af 00 00 00       	call   1dc4 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    1d15:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1d1a:	89 04 24             	mov    %eax,(%esp)
    1d1d:	e8 1c 01 00 00       	call   1e3e <pop_q>
    1d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    1d25:	a1 a0 23 00 00       	mov    0x23a0,%eax
    1d2a:	85 c0                	test   %eax,%eax
    1d2c:	75 1f                	jne    1d4d <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    1d2e:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1d33:	89 04 24             	mov    %eax,(%esp)
    1d36:	e8 03 01 00 00       	call   1e3e <pop_q>
    1d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    1d3e:	a1 a0 23 00 00       	mov    0x23a0,%eax
    1d43:	83 c0 01             	add    $0x1,%eax
    1d46:	a3 a0 23 00 00       	mov    %eax,0x23a0
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    1d4b:	eb 12                	jmp    1d5f <thread_yield2+0x6c>
    1d4d:	eb 10                	jmp    1d5f <thread_yield2+0x6c>
    1d4f:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1d54:	89 04 24             	mov    %eax,(%esp)
    1d57:	e8 e2 00 00 00       	call   1e3e <pop_q>
    1d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1d65:	74 e8                	je     1d4f <thread_yield2+0x5c>
    1d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d6b:	74 e2                	je     1d4f <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    1d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d70:	89 04 24             	mov    %eax,(%esp)
    1d73:	e8 03 f9 ff ff       	call   167b <twakeup>
    tsleep();
    1d78:	e8 f6 f8 ff ff       	call   1673 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    1d7d:	c9                   	leave  
    1d7e:	c3                   	ret    

00001d7f <thread_yield_last>:

void thread_yield_last(){
    1d7f:	55                   	push   %ebp
    1d80:	89 e5                	mov    %esp,%ebp
    1d82:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    1d85:	a1 a4 23 00 00       	mov    0x23a4,%eax
    1d8a:	89 04 24             	mov    %eax,(%esp)
    1d8d:	e8 ac 00 00 00       	call   1e3e <pop_q>
    1d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    1d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d98:	89 04 24             	mov    %eax,(%esp)
    1d9b:	e8 db f8 ff ff       	call   167b <twakeup>
    1da0:	c9                   	leave  
    1da1:	c3                   	ret    

00001da2 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    1da2:	55                   	push   %ebp
    1da3:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    1da5:	8b 45 08             	mov    0x8(%ebp),%eax
    1da8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    1dae:	8b 45 08             	mov    0x8(%ebp),%eax
    1db1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    1db8:	8b 45 08             	mov    0x8(%ebp),%eax
    1dbb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    1dc2:	5d                   	pop    %ebp
    1dc3:	c3                   	ret    

00001dc4 <add_q>:

void add_q(struct queue *q, int v){
    1dc4:	55                   	push   %ebp
    1dc5:	89 e5                	mov    %esp,%ebp
    1dc7:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    1dca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1dd1:	e8 89 fc ff ff       	call   1a5f <malloc>
    1dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    1dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ddc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    1de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1de6:	8b 55 0c             	mov    0xc(%ebp),%edx
    1de9:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    1deb:	8b 45 08             	mov    0x8(%ebp),%eax
    1dee:	8b 40 04             	mov    0x4(%eax),%eax
    1df1:	85 c0                	test   %eax,%eax
    1df3:	75 0b                	jne    1e00 <add_q+0x3c>
        q->head = n;
    1df5:	8b 45 08             	mov    0x8(%ebp),%eax
    1df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1dfb:	89 50 04             	mov    %edx,0x4(%eax)
    1dfe:	eb 0c                	jmp    1e0c <add_q+0x48>
    }else{
        q->tail->next = n;
    1e00:	8b 45 08             	mov    0x8(%ebp),%eax
    1e03:	8b 40 08             	mov    0x8(%eax),%eax
    1e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e09:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    1e0c:	8b 45 08             	mov    0x8(%ebp),%eax
    1e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e12:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    1e15:	8b 45 08             	mov    0x8(%ebp),%eax
    1e18:	8b 00                	mov    (%eax),%eax
    1e1a:	8d 50 01             	lea    0x1(%eax),%edx
    1e1d:	8b 45 08             	mov    0x8(%ebp),%eax
    1e20:	89 10                	mov    %edx,(%eax)
}
    1e22:	c9                   	leave  
    1e23:	c3                   	ret    

00001e24 <empty_q>:

int empty_q(struct queue *q){
    1e24:	55                   	push   %ebp
    1e25:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    1e27:	8b 45 08             	mov    0x8(%ebp),%eax
    1e2a:	8b 00                	mov    (%eax),%eax
    1e2c:	85 c0                	test   %eax,%eax
    1e2e:	75 07                	jne    1e37 <empty_q+0x13>
        return 1;
    1e30:	b8 01 00 00 00       	mov    $0x1,%eax
    1e35:	eb 05                	jmp    1e3c <empty_q+0x18>
    else
        return 0;
    1e37:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    1e3c:	5d                   	pop    %ebp
    1e3d:	c3                   	ret    

00001e3e <pop_q>:
int pop_q(struct queue *q){
    1e3e:	55                   	push   %ebp
    1e3f:	89 e5                	mov    %esp,%ebp
    1e41:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    1e44:	8b 45 08             	mov    0x8(%ebp),%eax
    1e47:	89 04 24             	mov    %eax,(%esp)
    1e4a:	e8 d5 ff ff ff       	call   1e24 <empty_q>
    1e4f:	85 c0                	test   %eax,%eax
    1e51:	75 5d                	jne    1eb0 <pop_q+0x72>
       val = q->head->value; 
    1e53:	8b 45 08             	mov    0x8(%ebp),%eax
    1e56:	8b 40 04             	mov    0x4(%eax),%eax
    1e59:	8b 00                	mov    (%eax),%eax
    1e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    1e5e:	8b 45 08             	mov    0x8(%ebp),%eax
    1e61:	8b 40 04             	mov    0x4(%eax),%eax
    1e64:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    1e67:	8b 45 08             	mov    0x8(%ebp),%eax
    1e6a:	8b 40 04             	mov    0x4(%eax),%eax
    1e6d:	8b 50 04             	mov    0x4(%eax),%edx
    1e70:	8b 45 08             	mov    0x8(%ebp),%eax
    1e73:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    1e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e79:	89 04 24             	mov    %eax,(%esp)
    1e7c:	e8 a5 fa ff ff       	call   1926 <free>
       q->size--;
    1e81:	8b 45 08             	mov    0x8(%ebp),%eax
    1e84:	8b 00                	mov    (%eax),%eax
    1e86:	8d 50 ff             	lea    -0x1(%eax),%edx
    1e89:	8b 45 08             	mov    0x8(%ebp),%eax
    1e8c:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    1e8e:	8b 45 08             	mov    0x8(%ebp),%eax
    1e91:	8b 00                	mov    (%eax),%eax
    1e93:	85 c0                	test   %eax,%eax
    1e95:	75 14                	jne    1eab <pop_q+0x6d>
            q->head = 0;
    1e97:	8b 45 08             	mov    0x8(%ebp),%eax
    1e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    1ea1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ea4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    1eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eae:	eb 05                	jmp    1eb5 <pop_q+0x77>
    }
    return -1;
    1eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1eb5:	c9                   	leave  
    1eb6:	c3                   	ret    
