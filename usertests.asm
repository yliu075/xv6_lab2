
_usertests:     file format elf32-i386


Disassembly of section .text:

00001000 <opentest>:

// simple file system tests

void
opentest(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
    1006:	a1 28 74 00 00       	mov    0x7428,%eax
    100b:	c7 44 24 04 22 55 00 	movl   $0x5522,0x4(%esp)
    1012:	00 
    1013:	89 04 24             	mov    %eax,(%esp)
    1016:	e8 ad 3d 00 00       	call   4dc8 <printf>
  fd = open("echo", 0);
    101b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1022:	00 
    1023:	c7 04 24 0c 55 00 00 	movl   $0x550c,(%esp)
    102a:	e8 29 3c 00 00       	call   4c58 <open>
    102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1036:	79 1a                	jns    1052 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
    1038:	a1 28 74 00 00       	mov    0x7428,%eax
    103d:	c7 44 24 04 2d 55 00 	movl   $0x552d,0x4(%esp)
    1044:	00 
    1045:	89 04 24             	mov    %eax,(%esp)
    1048:	e8 7b 3d 00 00       	call   4dc8 <printf>
    exit();
    104d:	e8 c6 3b 00 00       	call   4c18 <exit>
  }
  close(fd);
    1052:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 e3 3b 00 00       	call   4c40 <close>
  fd = open("doesnotexist", 0);
    105d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1064:	00 
    1065:	c7 04 24 40 55 00 00 	movl   $0x5540,(%esp)
    106c:	e8 e7 3b 00 00       	call   4c58 <open>
    1071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    1074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1078:	78 1a                	js     1094 <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
    107a:	a1 28 74 00 00       	mov    0x7428,%eax
    107f:	c7 44 24 04 4d 55 00 	movl   $0x554d,0x4(%esp)
    1086:	00 
    1087:	89 04 24             	mov    %eax,(%esp)
    108a:	e8 39 3d 00 00       	call   4dc8 <printf>
    exit();
    108f:	e8 84 3b 00 00       	call   4c18 <exit>
  }
  printf(stdout, "open test ok\n");
    1094:	a1 28 74 00 00       	mov    0x7428,%eax
    1099:	c7 44 24 04 6b 55 00 	movl   $0x556b,0x4(%esp)
    10a0:	00 
    10a1:	89 04 24             	mov    %eax,(%esp)
    10a4:	e8 1f 3d 00 00       	call   4dc8 <printf>
}
    10a9:	c9                   	leave  
    10aa:	c3                   	ret    

000010ab <writetest>:

void
writetest(void)
{
    10ab:	55                   	push   %ebp
    10ac:	89 e5                	mov    %esp,%ebp
    10ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    10b1:	a1 28 74 00 00       	mov    0x7428,%eax
    10b6:	c7 44 24 04 79 55 00 	movl   $0x5579,0x4(%esp)
    10bd:	00 
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 02 3d 00 00       	call   4dc8 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    10c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10cd:	00 
    10ce:	c7 04 24 8a 55 00 00 	movl   $0x558a,(%esp)
    10d5:	e8 7e 3b 00 00       	call   4c58 <open>
    10da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
    10dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10e1:	78 21                	js     1104 <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
    10e3:	a1 28 74 00 00       	mov    0x7428,%eax
    10e8:	c7 44 24 04 90 55 00 	movl   $0x5590,0x4(%esp)
    10ef:	00 
    10f0:	89 04 24             	mov    %eax,(%esp)
    10f3:	e8 d0 3c 00 00       	call   4dc8 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    10f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10ff:	e9 a0 00 00 00       	jmp    11a4 <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    1104:	a1 28 74 00 00       	mov    0x7428,%eax
    1109:	c7 44 24 04 ab 55 00 	movl   $0x55ab,0x4(%esp)
    1110:	00 
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	e8 af 3c 00 00       	call   4dc8 <printf>
    exit();
    1119:	e8 fa 3a 00 00       	call   4c18 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    111e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1125:	00 
    1126:	c7 44 24 04 c7 55 00 	movl   $0x55c7,0x4(%esp)
    112d:	00 
    112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1131:	89 04 24             	mov    %eax,(%esp)
    1134:	e8 ff 3a 00 00       	call   4c38 <write>
    1139:	83 f8 0a             	cmp    $0xa,%eax
    113c:	74 21                	je     115f <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
    113e:	a1 28 74 00 00       	mov    0x7428,%eax
    1143:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1146:	89 54 24 08          	mov    %edx,0x8(%esp)
    114a:	c7 44 24 04 d4 55 00 	movl   $0x55d4,0x4(%esp)
    1151:	00 
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 6e 3c 00 00       	call   4dc8 <printf>
      exit();
    115a:	e8 b9 3a 00 00       	call   4c18 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    115f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1166:	00 
    1167:	c7 44 24 04 f8 55 00 	movl   $0x55f8,0x4(%esp)
    116e:	00 
    116f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1172:	89 04 24             	mov    %eax,(%esp)
    1175:	e8 be 3a 00 00       	call   4c38 <write>
    117a:	83 f8 0a             	cmp    $0xa,%eax
    117d:	74 21                	je     11a0 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
    117f:	a1 28 74 00 00       	mov    0x7428,%eax
    1184:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1187:	89 54 24 08          	mov    %edx,0x8(%esp)
    118b:	c7 44 24 04 04 56 00 	movl   $0x5604,0x4(%esp)
    1192:	00 
    1193:	89 04 24             	mov    %eax,(%esp)
    1196:	e8 2d 3c 00 00       	call   4dc8 <printf>
      exit();
    119b:	e8 78 3a 00 00       	call   4c18 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    11a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11a4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    11a8:	0f 8e 70 ff ff ff    	jle    111e <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
    11ae:	a1 28 74 00 00       	mov    0x7428,%eax
    11b3:	c7 44 24 04 28 56 00 	movl   $0x5628,0x4(%esp)
    11ba:	00 
    11bb:	89 04 24             	mov    %eax,(%esp)
    11be:	e8 05 3c 00 00       	call   4dc8 <printf>
  close(fd);
    11c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11c6:	89 04 24             	mov    %eax,(%esp)
    11c9:	e8 72 3a 00 00       	call   4c40 <close>
  fd = open("small", O_RDONLY);
    11ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11d5:	00 
    11d6:	c7 04 24 8a 55 00 00 	movl   $0x558a,(%esp)
    11dd:	e8 76 3a 00 00       	call   4c58 <open>
    11e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
    11e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11e9:	78 3e                	js     1229 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
    11eb:	a1 28 74 00 00       	mov    0x7428,%eax
    11f0:	c7 44 24 04 33 56 00 	movl   $0x5633,0x4(%esp)
    11f7:	00 
    11f8:	89 04 24             	mov    %eax,(%esp)
    11fb:	e8 c8 3b 00 00       	call   4dc8 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    1200:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    1207:	00 
    1208:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    120f:	00 
    1210:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1213:	89 04 24             	mov    %eax,(%esp)
    1216:	e8 15 3a 00 00       	call   4c30 <read>
    121b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
    121e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
    1225:	75 4e                	jne    1275 <writetest+0x1ca>
    1227:	eb 1a                	jmp    1243 <writetest+0x198>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
    1229:	a1 28 74 00 00       	mov    0x7428,%eax
    122e:	c7 44 24 04 4c 56 00 	movl   $0x564c,0x4(%esp)
    1235:	00 
    1236:	89 04 24             	mov    %eax,(%esp)
    1239:	e8 8a 3b 00 00       	call   4dc8 <printf>
    exit();
    123e:	e8 d5 39 00 00       	call   4c18 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
    1243:	a1 28 74 00 00       	mov    0x7428,%eax
    1248:	c7 44 24 04 67 56 00 	movl   $0x5667,0x4(%esp)
    124f:	00 
    1250:	89 04 24             	mov    %eax,(%esp)
    1253:	e8 70 3b 00 00       	call   4dc8 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    1258:	8b 45 f0             	mov    -0x10(%ebp),%eax
    125b:	89 04 24             	mov    %eax,(%esp)
    125e:	e8 dd 39 00 00       	call   4c40 <close>

  if(unlink("small") < 0){
    1263:	c7 04 24 8a 55 00 00 	movl   $0x558a,(%esp)
    126a:	e8 f9 39 00 00       	call   4c68 <unlink>
    126f:	85 c0                	test   %eax,%eax
    1271:	79 36                	jns    12a9 <writetest+0x1fe>
    1273:	eb 1a                	jmp    128f <writetest+0x1e4>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
    1275:	a1 28 74 00 00       	mov    0x7428,%eax
    127a:	c7 44 24 04 7a 56 00 	movl   $0x567a,0x4(%esp)
    1281:	00 
    1282:	89 04 24             	mov    %eax,(%esp)
    1285:	e8 3e 3b 00 00       	call   4dc8 <printf>
    exit();
    128a:	e8 89 39 00 00       	call   4c18 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
    128f:	a1 28 74 00 00       	mov    0x7428,%eax
    1294:	c7 44 24 04 87 56 00 	movl   $0x5687,0x4(%esp)
    129b:	00 
    129c:	89 04 24             	mov    %eax,(%esp)
    129f:	e8 24 3b 00 00       	call   4dc8 <printf>
    exit();
    12a4:	e8 6f 39 00 00       	call   4c18 <exit>
  }
  printf(stdout, "small file test ok\n");
    12a9:	a1 28 74 00 00       	mov    0x7428,%eax
    12ae:	c7 44 24 04 9c 56 00 	movl   $0x569c,0x4(%esp)
    12b5:	00 
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 0a 3b 00 00       	call   4dc8 <printf>
}
    12be:	c9                   	leave  
    12bf:	c3                   	ret    

000012c0 <writetest1>:

void
writetest1(void)
{
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    12c6:	a1 28 74 00 00       	mov    0x7428,%eax
    12cb:	c7 44 24 04 b0 56 00 	movl   $0x56b0,0x4(%esp)
    12d2:	00 
    12d3:	89 04 24             	mov    %eax,(%esp)
    12d6:	e8 ed 3a 00 00       	call   4dc8 <printf>

  fd = open("big", O_CREATE|O_RDWR);
    12db:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12e2:	00 
    12e3:	c7 04 24 c0 56 00 00 	movl   $0x56c0,(%esp)
    12ea:	e8 69 39 00 00       	call   4c58 <open>
    12ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    12f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12f6:	79 1a                	jns    1312 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
    12f8:	a1 28 74 00 00       	mov    0x7428,%eax
    12fd:	c7 44 24 04 c4 56 00 	movl   $0x56c4,0x4(%esp)
    1304:	00 
    1305:	89 04 24             	mov    %eax,(%esp)
    1308:	e8 bb 3a 00 00       	call   4dc8 <printf>
    exit();
    130d:	e8 06 39 00 00       	call   4c18 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
    1312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1319:	eb 51                	jmp    136c <writetest1+0xac>
    ((int*)buf)[0] = i;
    131b:	b8 20 9c 00 00       	mov    $0x9c20,%eax
    1320:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1323:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
    1325:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    132c:	00 
    132d:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1334:	00 
    1335:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1338:	89 04 24             	mov    %eax,(%esp)
    133b:	e8 f8 38 00 00       	call   4c38 <write>
    1340:	3d 00 02 00 00       	cmp    $0x200,%eax
    1345:	74 21                	je     1368 <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
    1347:	a1 28 74 00 00       	mov    0x7428,%eax
    134c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    134f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1353:	c7 44 24 04 de 56 00 	movl   $0x56de,0x4(%esp)
    135a:	00 
    135b:	89 04 24             	mov    %eax,(%esp)
    135e:	e8 65 3a 00 00       	call   4dc8 <printf>
      exit();
    1363:	e8 b0 38 00 00       	call   4c18 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
    1368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136f:	3d 8b 00 00 00       	cmp    $0x8b,%eax
    1374:	76 a5                	jbe    131b <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    1376:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1379:	89 04 24             	mov    %eax,(%esp)
    137c:	e8 bf 38 00 00       	call   4c40 <close>

  fd = open("big", O_RDONLY);
    1381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1388:	00 
    1389:	c7 04 24 c0 56 00 00 	movl   $0x56c0,(%esp)
    1390:	e8 c3 38 00 00       	call   4c58 <open>
    1395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    1398:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    139c:	79 1a                	jns    13b8 <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
    139e:	a1 28 74 00 00       	mov    0x7428,%eax
    13a3:	c7 44 24 04 fc 56 00 	movl   $0x56fc,0x4(%esp)
    13aa:	00 
    13ab:	89 04 24             	mov    %eax,(%esp)
    13ae:	e8 15 3a 00 00       	call   4dc8 <printf>
    exit();
    13b3:	e8 60 38 00 00       	call   4c18 <exit>
  }

  n = 0;
    13b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
    13bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    13c6:	00 
    13c7:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    13ce:	00 
    13cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13d2:	89 04 24             	mov    %eax,(%esp)
    13d5:	e8 56 38 00 00       	call   4c30 <read>
    13da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
    13dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13e1:	75 4c                	jne    142f <writetest1+0x16f>
      if(n == MAXFILE - 1){
    13e3:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
    13ea:	75 21                	jne    140d <writetest1+0x14d>
        printf(stdout, "read only %d blocks from big", n);
    13ec:	a1 28 74 00 00       	mov    0x7428,%eax
    13f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    13f4:	89 54 24 08          	mov    %edx,0x8(%esp)
    13f8:	c7 44 24 04 15 57 00 	movl   $0x5715,0x4(%esp)
    13ff:	00 
    1400:	89 04 24             	mov    %eax,(%esp)
    1403:	e8 c0 39 00 00       	call   4dc8 <printf>
        exit();
    1408:	e8 0b 38 00 00       	call   4c18 <exit>
      }
      break;
    140d:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1411:	89 04 24             	mov    %eax,(%esp)
    1414:	e8 27 38 00 00       	call   4c40 <close>
  if(unlink("big") < 0){
    1419:	c7 04 24 c0 56 00 00 	movl   $0x56c0,(%esp)
    1420:	e8 43 38 00 00       	call   4c68 <unlink>
    1425:	85 c0                	test   %eax,%eax
    1427:	0f 89 87 00 00 00    	jns    14b4 <writetest1+0x1f4>
    142d:	eb 6b                	jmp    149a <writetest1+0x1da>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
    142f:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
    1436:	74 21                	je     1459 <writetest1+0x199>
      printf(stdout, "read failed %d\n", i);
    1438:	a1 28 74 00 00       	mov    0x7428,%eax
    143d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1440:	89 54 24 08          	mov    %edx,0x8(%esp)
    1444:	c7 44 24 04 32 57 00 	movl   $0x5732,0x4(%esp)
    144b:	00 
    144c:	89 04 24             	mov    %eax,(%esp)
    144f:	e8 74 39 00 00       	call   4dc8 <printf>
      exit();
    1454:	e8 bf 37 00 00       	call   4c18 <exit>
    }
    if(((int*)buf)[0] != n){
    1459:	b8 20 9c 00 00       	mov    $0x9c20,%eax
    145e:	8b 00                	mov    (%eax),%eax
    1460:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1463:	74 2c                	je     1491 <writetest1+0x1d1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
    1465:	b8 20 9c 00 00       	mov    $0x9c20,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
    146a:	8b 10                	mov    (%eax),%edx
    146c:	a1 28 74 00 00       	mov    0x7428,%eax
    1471:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1475:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1478:	89 54 24 08          	mov    %edx,0x8(%esp)
    147c:	c7 44 24 04 44 57 00 	movl   $0x5744,0x4(%esp)
    1483:	00 
    1484:	89 04 24             	mov    %eax,(%esp)
    1487:	e8 3c 39 00 00       	call   4dc8 <printf>
             n, ((int*)buf)[0]);
      exit();
    148c:	e8 87 37 00 00       	call   4c18 <exit>
    }
    n++;
    1491:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
    1495:	e9 25 ff ff ff       	jmp    13bf <writetest1+0xff>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
    149a:	a1 28 74 00 00       	mov    0x7428,%eax
    149f:	c7 44 24 04 64 57 00 	movl   $0x5764,0x4(%esp)
    14a6:	00 
    14a7:	89 04 24             	mov    %eax,(%esp)
    14aa:	e8 19 39 00 00       	call   4dc8 <printf>
    exit();
    14af:	e8 64 37 00 00       	call   4c18 <exit>
  }
  printf(stdout, "big files ok\n");
    14b4:	a1 28 74 00 00       	mov    0x7428,%eax
    14b9:	c7 44 24 04 77 57 00 	movl   $0x5777,0x4(%esp)
    14c0:	00 
    14c1:	89 04 24             	mov    %eax,(%esp)
    14c4:	e8 ff 38 00 00       	call   4dc8 <printf>
}
    14c9:	c9                   	leave  
    14ca:	c3                   	ret    

000014cb <createtest>:

void
createtest(void)
{
    14cb:	55                   	push   %ebp
    14cc:	89 e5                	mov    %esp,%ebp
    14ce:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
    14d1:	a1 28 74 00 00       	mov    0x7428,%eax
    14d6:	c7 44 24 04 88 57 00 	movl   $0x5788,0x4(%esp)
    14dd:	00 
    14de:	89 04 24             	mov    %eax,(%esp)
    14e1:	e8 e2 38 00 00       	call   4dc8 <printf>

  name[0] = 'a';
    14e6:	c6 05 20 bc 00 00 61 	movb   $0x61,0xbc20
  name[2] = '\0';
    14ed:	c6 05 22 bc 00 00 00 	movb   $0x0,0xbc22
  for(i = 0; i < 52; i++){
    14f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14fb:	eb 31                	jmp    152e <createtest+0x63>
    name[1] = '0' + i;
    14fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1500:	83 c0 30             	add    $0x30,%eax
    1503:	a2 21 bc 00 00       	mov    %al,0xbc21
    fd = open(name, O_CREATE|O_RDWR);
    1508:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    150f:	00 
    1510:	c7 04 24 20 bc 00 00 	movl   $0xbc20,(%esp)
    1517:	e8 3c 37 00 00       	call   4c58 <open>
    151c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
    151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1522:	89 04 24             	mov    %eax,(%esp)
    1525:	e8 16 37 00 00       	call   4c40 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    152a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    152e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
    1532:	7e c9                	jle    14fd <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
    1534:	c6 05 20 bc 00 00 61 	movb   $0x61,0xbc20
  name[2] = '\0';
    153b:	c6 05 22 bc 00 00 00 	movb   $0x0,0xbc22
  for(i = 0; i < 52; i++){
    1542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1549:	eb 1b                	jmp    1566 <createtest+0x9b>
    name[1] = '0' + i;
    154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154e:	83 c0 30             	add    $0x30,%eax
    1551:	a2 21 bc 00 00       	mov    %al,0xbc21
    unlink(name);
    1556:	c7 04 24 20 bc 00 00 	movl   $0xbc20,(%esp)
    155d:	e8 06 37 00 00       	call   4c68 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    1562:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1566:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
    156a:	7e df                	jle    154b <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
    156c:	a1 28 74 00 00       	mov    0x7428,%eax
    1571:	c7 44 24 04 b0 57 00 	movl   $0x57b0,0x4(%esp)
    1578:	00 
    1579:	89 04 24             	mov    %eax,(%esp)
    157c:	e8 47 38 00 00       	call   4dc8 <printf>
}
    1581:	c9                   	leave  
    1582:	c3                   	ret    

00001583 <dirtest>:

void dirtest(void)
{
    1583:	55                   	push   %ebp
    1584:	89 e5                	mov    %esp,%ebp
    1586:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
    1589:	a1 28 74 00 00       	mov    0x7428,%eax
    158e:	c7 44 24 04 d6 57 00 	movl   $0x57d6,0x4(%esp)
    1595:	00 
    1596:	89 04 24             	mov    %eax,(%esp)
    1599:	e8 2a 38 00 00       	call   4dc8 <printf>

  if(mkdir("dir0") < 0){
    159e:	c7 04 24 e2 57 00 00 	movl   $0x57e2,(%esp)
    15a5:	e8 d6 36 00 00       	call   4c80 <mkdir>
    15aa:	85 c0                	test   %eax,%eax
    15ac:	79 1a                	jns    15c8 <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
    15ae:	a1 28 74 00 00       	mov    0x7428,%eax
    15b3:	c7 44 24 04 e7 57 00 	movl   $0x57e7,0x4(%esp)
    15ba:	00 
    15bb:	89 04 24             	mov    %eax,(%esp)
    15be:	e8 05 38 00 00       	call   4dc8 <printf>
    exit();
    15c3:	e8 50 36 00 00       	call   4c18 <exit>
  }

  if(chdir("dir0") < 0){
    15c8:	c7 04 24 e2 57 00 00 	movl   $0x57e2,(%esp)
    15cf:	e8 b4 36 00 00       	call   4c88 <chdir>
    15d4:	85 c0                	test   %eax,%eax
    15d6:	79 1a                	jns    15f2 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
    15d8:	a1 28 74 00 00       	mov    0x7428,%eax
    15dd:	c7 44 24 04 f5 57 00 	movl   $0x57f5,0x4(%esp)
    15e4:	00 
    15e5:	89 04 24             	mov    %eax,(%esp)
    15e8:	e8 db 37 00 00       	call   4dc8 <printf>
    exit();
    15ed:	e8 26 36 00 00       	call   4c18 <exit>
  }

  if(chdir("..") < 0){
    15f2:	c7 04 24 08 58 00 00 	movl   $0x5808,(%esp)
    15f9:	e8 8a 36 00 00       	call   4c88 <chdir>
    15fe:	85 c0                	test   %eax,%eax
    1600:	79 1a                	jns    161c <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
    1602:	a1 28 74 00 00       	mov    0x7428,%eax
    1607:	c7 44 24 04 0b 58 00 	movl   $0x580b,0x4(%esp)
    160e:	00 
    160f:	89 04 24             	mov    %eax,(%esp)
    1612:	e8 b1 37 00 00       	call   4dc8 <printf>
    exit();
    1617:	e8 fc 35 00 00       	call   4c18 <exit>
  }

  if(unlink("dir0") < 0){
    161c:	c7 04 24 e2 57 00 00 	movl   $0x57e2,(%esp)
    1623:	e8 40 36 00 00       	call   4c68 <unlink>
    1628:	85 c0                	test   %eax,%eax
    162a:	79 1a                	jns    1646 <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
    162c:	a1 28 74 00 00       	mov    0x7428,%eax
    1631:	c7 44 24 04 1c 58 00 	movl   $0x581c,0x4(%esp)
    1638:	00 
    1639:	89 04 24             	mov    %eax,(%esp)
    163c:	e8 87 37 00 00       	call   4dc8 <printf>
    exit();
    1641:	e8 d2 35 00 00       	call   4c18 <exit>
  }
  printf(stdout, "mkdir test\n");
    1646:	a1 28 74 00 00       	mov    0x7428,%eax
    164b:	c7 44 24 04 d6 57 00 	movl   $0x57d6,0x4(%esp)
    1652:	00 
    1653:	89 04 24             	mov    %eax,(%esp)
    1656:	e8 6d 37 00 00       	call   4dc8 <printf>
}
    165b:	c9                   	leave  
    165c:	c3                   	ret    

0000165d <exectest>:

void
exectest(void)
{
    165d:	55                   	push   %ebp
    165e:	89 e5                	mov    %esp,%ebp
    1660:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
    1663:	a1 28 74 00 00       	mov    0x7428,%eax
    1668:	c7 44 24 04 30 58 00 	movl   $0x5830,0x4(%esp)
    166f:	00 
    1670:	89 04 24             	mov    %eax,(%esp)
    1673:	e8 50 37 00 00       	call   4dc8 <printf>
  if(exec("echo", echoargv) < 0){
    1678:	c7 44 24 04 14 74 00 	movl   $0x7414,0x4(%esp)
    167f:	00 
    1680:	c7 04 24 0c 55 00 00 	movl   $0x550c,(%esp)
    1687:	e8 c4 35 00 00       	call   4c50 <exec>
    168c:	85 c0                	test   %eax,%eax
    168e:	79 1a                	jns    16aa <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
    1690:	a1 28 74 00 00       	mov    0x7428,%eax
    1695:	c7 44 24 04 3b 58 00 	movl   $0x583b,0x4(%esp)
    169c:	00 
    169d:	89 04 24             	mov    %eax,(%esp)
    16a0:	e8 23 37 00 00       	call   4dc8 <printf>
    exit();
    16a5:	e8 6e 35 00 00       	call   4c18 <exit>
  }
}
    16aa:	c9                   	leave  
    16ab:	c3                   	ret    

000016ac <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    16ac:	55                   	push   %ebp
    16ad:	89 e5                	mov    %esp,%ebp
    16af:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    16b2:	8d 45 d8             	lea    -0x28(%ebp),%eax
    16b5:	89 04 24             	mov    %eax,(%esp)
    16b8:	e8 6b 35 00 00       	call   4c28 <pipe>
    16bd:	85 c0                	test   %eax,%eax
    16bf:	74 19                	je     16da <pipe1+0x2e>
    printf(1, "pipe() failed\n");
    16c1:	c7 44 24 04 4d 58 00 	movl   $0x584d,0x4(%esp)
    16c8:	00 
    16c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16d0:	e8 f3 36 00 00       	call   4dc8 <printf>
    exit();
    16d5:	e8 3e 35 00 00       	call   4c18 <exit>
  }
  pid = fork();
    16da:	e8 31 35 00 00       	call   4c10 <fork>
    16df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
    16e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
    16e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    16ed:	0f 85 88 00 00 00    	jne    177b <pipe1+0xcf>
    close(fds[0]);
    16f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
    16f6:	89 04 24             	mov    %eax,(%esp)
    16f9:	e8 42 35 00 00       	call   4c40 <close>
    for(n = 0; n < 5; n++){
    16fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1705:	eb 69                	jmp    1770 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
    1707:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    170e:	eb 18                	jmp    1728 <pipe1+0x7c>
        buf[i] = seq++;
    1710:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1713:	8d 50 01             	lea    0x1(%eax),%edx
    1716:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1719:	8b 55 f0             	mov    -0x10(%ebp),%edx
    171c:	81 c2 20 9c 00 00    	add    $0x9c20,%edx
    1722:	88 02                	mov    %al,(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    1724:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1728:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
    172f:	7e df                	jle    1710 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    1731:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1734:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    173b:	00 
    173c:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1743:	00 
    1744:	89 04 24             	mov    %eax,(%esp)
    1747:	e8 ec 34 00 00       	call   4c38 <write>
    174c:	3d 09 04 00 00       	cmp    $0x409,%eax
    1751:	74 19                	je     176c <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
    1753:	c7 44 24 04 5c 58 00 	movl   $0x585c,0x4(%esp)
    175a:	00 
    175b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1762:	e8 61 36 00 00       	call   4dc8 <printf>
        exit();
    1767:	e8 ac 34 00 00       	call   4c18 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    176c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1770:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
    1774:	7e 91                	jle    1707 <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
    1776:	e8 9d 34 00 00       	call   4c18 <exit>
  } else if(pid > 0){
    177b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    177f:	0f 8e f9 00 00 00    	jle    187e <pipe1+0x1d2>
    close(fds[1]);
    1785:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1788:	89 04 24             	mov    %eax,(%esp)
    178b:	e8 b0 34 00 00       	call   4c40 <close>
    total = 0;
    1790:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
    1797:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
    179e:	eb 68                	jmp    1808 <pipe1+0x15c>
      for(i = 0; i < n; i++){
    17a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    17a7:	eb 3d                	jmp    17e6 <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ac:	05 20 9c 00 00       	add    $0x9c20,%eax
    17b1:	0f b6 00             	movzbl (%eax),%eax
    17b4:	0f be c8             	movsbl %al,%ecx
    17b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ba:	8d 50 01             	lea    0x1(%eax),%edx
    17bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    17c0:	31 c8                	xor    %ecx,%eax
    17c2:	0f b6 c0             	movzbl %al,%eax
    17c5:	85 c0                	test   %eax,%eax
    17c7:	74 19                	je     17e2 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
    17c9:	c7 44 24 04 6a 58 00 	movl   $0x586a,0x4(%esp)
    17d0:	00 
    17d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17d8:	e8 eb 35 00 00       	call   4dc8 <printf>
    17dd:	e9 b5 00 00 00       	jmp    1897 <pipe1+0x1eb>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    17e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    17e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ec:	7c bb                	jl     17a9 <pipe1+0xfd>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    17ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17f1:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
    17f4:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
    17f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17fa:	3d 00 20 00 00       	cmp    $0x2000,%eax
    17ff:	76 07                	jbe    1808 <pipe1+0x15c>
        cc = sizeof(buf);
    1801:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    1808:	8b 45 d8             	mov    -0x28(%ebp),%eax
    180b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    180e:	89 54 24 08          	mov    %edx,0x8(%esp)
    1812:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1819:	00 
    181a:	89 04 24             	mov    %eax,(%esp)
    181d:	e8 0e 34 00 00       	call   4c30 <read>
    1822:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1825:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1829:	0f 8f 71 ff ff ff    	jg     17a0 <pipe1+0xf4>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
    182f:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
    1836:	74 20                	je     1858 <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    183b:	89 44 24 08          	mov    %eax,0x8(%esp)
    183f:	c7 44 24 04 78 58 00 	movl   $0x5878,0x4(%esp)
    1846:	00 
    1847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184e:	e8 75 35 00 00       	call   4dc8 <printf>
      exit();
    1853:	e8 c0 33 00 00       	call   4c18 <exit>
    }
    close(fds[0]);
    1858:	8b 45 d8             	mov    -0x28(%ebp),%eax
    185b:	89 04 24             	mov    %eax,(%esp)
    185e:	e8 dd 33 00 00       	call   4c40 <close>
    wait();
    1863:	e8 b8 33 00 00       	call   4c20 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    1868:	c7 44 24 04 9e 58 00 	movl   $0x589e,0x4(%esp)
    186f:	00 
    1870:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1877:	e8 4c 35 00 00       	call   4dc8 <printf>
    187c:	eb 19                	jmp    1897 <pipe1+0x1eb>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    187e:	c7 44 24 04 8f 58 00 	movl   $0x588f,0x4(%esp)
    1885:	00 
    1886:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    188d:	e8 36 35 00 00       	call   4dc8 <printf>
    exit();
    1892:	e8 81 33 00 00       	call   4c18 <exit>
  }
  printf(1, "pipe1 ok\n");
}
    1897:	c9                   	leave  
    1898:	c3                   	ret    

00001899 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    1899:	55                   	push   %ebp
    189a:	89 e5                	mov    %esp,%ebp
    189c:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    189f:	c7 44 24 04 a8 58 00 	movl   $0x58a8,0x4(%esp)
    18a6:	00 
    18a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18ae:	e8 15 35 00 00       	call   4dc8 <printf>
  pid1 = fork();
    18b3:	e8 58 33 00 00       	call   4c10 <fork>
    18b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
    18bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18bf:	75 02                	jne    18c3 <preempt+0x2a>
    for(;;)
      ;
    18c1:	eb fe                	jmp    18c1 <preempt+0x28>

  pid2 = fork();
    18c3:	e8 48 33 00 00       	call   4c10 <fork>
    18c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
    18cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18cf:	75 02                	jne    18d3 <preempt+0x3a>
    for(;;)
      ;
    18d1:	eb fe                	jmp    18d1 <preempt+0x38>

  pipe(pfds);
    18d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    18d6:	89 04 24             	mov    %eax,(%esp)
    18d9:	e8 4a 33 00 00       	call   4c28 <pipe>
  pid3 = fork();
    18de:	e8 2d 33 00 00       	call   4c10 <fork>
    18e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
    18e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18ea:	75 4c                	jne    1938 <preempt+0x9f>
    close(pfds[0]);
    18ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18ef:	89 04 24             	mov    %eax,(%esp)
    18f2:	e8 49 33 00 00       	call   4c40 <close>
    if(write(pfds[1], "x", 1) != 1)
    18f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1901:	00 
    1902:	c7 44 24 04 b2 58 00 	movl   $0x58b2,0x4(%esp)
    1909:	00 
    190a:	89 04 24             	mov    %eax,(%esp)
    190d:	e8 26 33 00 00       	call   4c38 <write>
    1912:	83 f8 01             	cmp    $0x1,%eax
    1915:	74 14                	je     192b <preempt+0x92>
      printf(1, "preempt write error");
    1917:	c7 44 24 04 b4 58 00 	movl   $0x58b4,0x4(%esp)
    191e:	00 
    191f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1926:	e8 9d 34 00 00       	call   4dc8 <printf>
    close(pfds[1]);
    192b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    192e:	89 04 24             	mov    %eax,(%esp)
    1931:	e8 0a 33 00 00       	call   4c40 <close>
    for(;;)
      ;
    1936:	eb fe                	jmp    1936 <preempt+0x9d>
  }

  close(pfds[1]);
    1938:	8b 45 e8             	mov    -0x18(%ebp),%eax
    193b:	89 04 24             	mov    %eax,(%esp)
    193e:	e8 fd 32 00 00       	call   4c40 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1946:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    194d:	00 
    194e:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1955:	00 
    1956:	89 04 24             	mov    %eax,(%esp)
    1959:	e8 d2 32 00 00       	call   4c30 <read>
    195e:	83 f8 01             	cmp    $0x1,%eax
    1961:	74 16                	je     1979 <preempt+0xe0>
    printf(1, "preempt read error");
    1963:	c7 44 24 04 c8 58 00 	movl   $0x58c8,0x4(%esp)
    196a:	00 
    196b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1972:	e8 51 34 00 00       	call   4dc8 <printf>
    1977:	eb 77                	jmp    19f0 <preempt+0x157>
    return;
  }
  close(pfds[0]);
    1979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    197c:	89 04 24             	mov    %eax,(%esp)
    197f:	e8 bc 32 00 00       	call   4c40 <close>
  printf(1, "kill... ");
    1984:	c7 44 24 04 db 58 00 	movl   $0x58db,0x4(%esp)
    198b:	00 
    198c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1993:	e8 30 34 00 00       	call   4dc8 <printf>
  kill(pid1);
    1998:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199b:	89 04 24             	mov    %eax,(%esp)
    199e:	e8 a5 32 00 00       	call   4c48 <kill>
  kill(pid2);
    19a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19a6:	89 04 24             	mov    %eax,(%esp)
    19a9:	e8 9a 32 00 00       	call   4c48 <kill>
  kill(pid3);
    19ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    19b1:	89 04 24             	mov    %eax,(%esp)
    19b4:	e8 8f 32 00 00       	call   4c48 <kill>
  printf(1, "wait... ");
    19b9:	c7 44 24 04 e4 58 00 	movl   $0x58e4,0x4(%esp)
    19c0:	00 
    19c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19c8:	e8 fb 33 00 00       	call   4dc8 <printf>
  wait();
    19cd:	e8 4e 32 00 00       	call   4c20 <wait>
  wait();
    19d2:	e8 49 32 00 00       	call   4c20 <wait>
  wait();
    19d7:	e8 44 32 00 00       	call   4c20 <wait>
  printf(1, "preempt ok\n");
    19dc:	c7 44 24 04 ed 58 00 	movl   $0x58ed,0x4(%esp)
    19e3:	00 
    19e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19eb:	e8 d8 33 00 00       	call   4dc8 <printf>
}
    19f0:	c9                   	leave  
    19f1:	c3                   	ret    

000019f2 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
    19f2:	55                   	push   %ebp
    19f3:	89 e5                	mov    %esp,%ebp
    19f5:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
    19f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    19ff:	eb 53                	jmp    1a54 <exitwait+0x62>
    pid = fork();
    1a01:	e8 0a 32 00 00       	call   4c10 <fork>
    1a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
    1a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a0d:	79 16                	jns    1a25 <exitwait+0x33>
      printf(1, "fork failed\n");
    1a0f:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    1a16:	00 
    1a17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a1e:	e8 a5 33 00 00       	call   4dc8 <printf>
      return;
    1a23:	eb 49                	jmp    1a6e <exitwait+0x7c>
    }
    if(pid){
    1a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a29:	74 20                	je     1a4b <exitwait+0x59>
      if(wait() != pid){
    1a2b:	e8 f0 31 00 00       	call   4c20 <wait>
    1a30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1a33:	74 1b                	je     1a50 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
    1a35:	c7 44 24 04 06 59 00 	movl   $0x5906,0x4(%esp)
    1a3c:	00 
    1a3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a44:	e8 7f 33 00 00       	call   4dc8 <printf>
        return;
    1a49:	eb 23                	jmp    1a6e <exitwait+0x7c>
      }
    } else {
      exit();
    1a4b:	e8 c8 31 00 00       	call   4c18 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    1a50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a54:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1a58:	7e a7                	jle    1a01 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
    1a5a:	c7 44 24 04 16 59 00 	movl   $0x5916,0x4(%esp)
    1a61:	00 
    1a62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a69:	e8 5a 33 00 00       	call   4dc8 <printf>
}
    1a6e:	c9                   	leave  
    1a6f:	c3                   	ret    

00001a70 <mem>:

void
mem(void)
{
    1a70:	55                   	push   %ebp
    1a71:	89 e5                	mov    %esp,%ebp
    1a73:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    1a76:	c7 44 24 04 23 59 00 	movl   $0x5923,0x4(%esp)
    1a7d:	00 
    1a7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a85:	e8 3e 33 00 00       	call   4dc8 <printf>
  ppid = getpid();
    1a8a:	e8 09 32 00 00       	call   4c98 <getpid>
    1a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
    1a92:	e8 79 31 00 00       	call   4c10 <fork>
    1a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1a9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a9e:	0f 85 aa 00 00 00    	jne    1b4e <mem+0xde>
    m1 = 0;
    1aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
    1aab:	eb 0e                	jmp    1abb <mem+0x4b>
      *(char**)m2 = m1;
    1aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1ab3:	89 10                	mov    %edx,(%eax)
      m1 = m2;
    1ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
    1abb:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    1ac2:	e8 ed 35 00 00       	call   50b4 <malloc>
    1ac7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1aca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1ace:	75 dd                	jne    1aad <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    1ad0:	eb 19                	jmp    1aeb <mem+0x7b>
      m2 = *(char**)m1;
    1ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad5:	8b 00                	mov    (%eax),%eax
    1ad7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
    1ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1add:	89 04 24             	mov    %eax,(%esp)
    1ae0:	e8 96 34 00 00       	call   4f7b <free>
      m1 = m2;
    1ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    1aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1aef:	75 e1                	jne    1ad2 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    1af1:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    1af8:	e8 b7 35 00 00       	call   50b4 <malloc>
    1afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
    1b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b04:	75 24                	jne    1b2a <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
    1b06:	c7 44 24 04 2d 59 00 	movl   $0x592d,0x4(%esp)
    1b0d:	00 
    1b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b15:	e8 ae 32 00 00       	call   4dc8 <printf>
      kill(ppid);
    1b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b1d:	89 04 24             	mov    %eax,(%esp)
    1b20:	e8 23 31 00 00       	call   4c48 <kill>
      exit();
    1b25:	e8 ee 30 00 00       	call   4c18 <exit>
    }
    free(m1);
    1b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2d:	89 04 24             	mov    %eax,(%esp)
    1b30:	e8 46 34 00 00       	call   4f7b <free>
    printf(1, "mem ok\n");
    1b35:	c7 44 24 04 47 59 00 	movl   $0x5947,0x4(%esp)
    1b3c:	00 
    1b3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b44:	e8 7f 32 00 00       	call   4dc8 <printf>
    exit();
    1b49:	e8 ca 30 00 00       	call   4c18 <exit>
  } else {
    wait();
    1b4e:	e8 cd 30 00 00       	call   4c20 <wait>
  }
}
    1b53:	c9                   	leave  
    1b54:	c3                   	ret    

00001b55 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    1b55:	55                   	push   %ebp
    1b56:	89 e5                	mov    %esp,%ebp
    1b58:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    1b5b:	c7 44 24 04 4f 59 00 	movl   $0x594f,0x4(%esp)
    1b62:	00 
    1b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b6a:	e8 59 32 00 00       	call   4dc8 <printf>

  unlink("sharedfd");
    1b6f:	c7 04 24 5e 59 00 00 	movl   $0x595e,(%esp)
    1b76:	e8 ed 30 00 00       	call   4c68 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1b7b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1b82:	00 
    1b83:	c7 04 24 5e 59 00 00 	movl   $0x595e,(%esp)
    1b8a:	e8 c9 30 00 00       	call   4c58 <open>
    1b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    1b92:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b96:	79 19                	jns    1bb1 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
    1b98:	c7 44 24 04 68 59 00 	movl   $0x5968,0x4(%esp)
    1b9f:	00 
    1ba0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba7:	e8 1c 32 00 00       	call   4dc8 <printf>
    return;
    1bac:	e9 a0 01 00 00       	jmp    1d51 <sharedfd+0x1fc>
  }
  pid = fork();
    1bb1:	e8 5a 30 00 00       	call   4c10 <fork>
    1bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1bb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1bbd:	75 07                	jne    1bc6 <sharedfd+0x71>
    1bbf:	b8 63 00 00 00       	mov    $0x63,%eax
    1bc4:	eb 05                	jmp    1bcb <sharedfd+0x76>
    1bc6:	b8 70 00 00 00       	mov    $0x70,%eax
    1bcb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1bd2:	00 
    1bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bd7:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1bda:	89 04 24             	mov    %eax,(%esp)
    1bdd:	e8 89 2e 00 00       	call   4a6b <memset>
  for(i = 0; i < 1000; i++){
    1be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1be9:	eb 39                	jmp    1c24 <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1beb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1bf2:	00 
    1bf3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1bfd:	89 04 24             	mov    %eax,(%esp)
    1c00:	e8 33 30 00 00       	call   4c38 <write>
    1c05:	83 f8 0a             	cmp    $0xa,%eax
    1c08:	74 16                	je     1c20 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
    1c0a:	c7 44 24 04 94 59 00 	movl   $0x5994,0x4(%esp)
    1c11:	00 
    1c12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c19:	e8 aa 31 00 00       	call   4dc8 <printf>
      break;
    1c1e:	eb 0d                	jmp    1c2d <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
    1c20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c24:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    1c2b:	7e be                	jle    1beb <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
    1c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1c31:	75 05                	jne    1c38 <sharedfd+0xe3>
    exit();
    1c33:	e8 e0 2f 00 00       	call   4c18 <exit>
  else
    wait();
    1c38:	e8 e3 2f 00 00       	call   4c20 <wait>
  close(fd);
    1c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1c40:	89 04 24             	mov    %eax,(%esp)
    1c43:	e8 f8 2f 00 00       	call   4c40 <close>
  fd = open("sharedfd", 0);
    1c48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c4f:	00 
    1c50:	c7 04 24 5e 59 00 00 	movl   $0x595e,(%esp)
    1c57:	e8 fc 2f 00 00       	call   4c58 <open>
    1c5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    1c5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c63:	79 19                	jns    1c7e <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1c65:	c7 44 24 04 b4 59 00 	movl   $0x59b4,0x4(%esp)
    1c6c:	00 
    1c6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c74:	e8 4f 31 00 00       	call   4dc8 <printf>
    return;
    1c79:	e9 d3 00 00 00       	jmp    1d51 <sharedfd+0x1fc>
  }
  nc = np = 0;
    1c7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1c8b:	eb 3b                	jmp    1cc8 <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
    1c8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c94:	eb 2a                	jmp    1cc0 <sharedfd+0x16b>
      if(buf[i] == 'c')
    1c96:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    1c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c9c:	01 d0                	add    %edx,%eax
    1c9e:	0f b6 00             	movzbl (%eax),%eax
    1ca1:	3c 63                	cmp    $0x63,%al
    1ca3:	75 04                	jne    1ca9 <sharedfd+0x154>
        nc++;
    1ca5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
    1ca9:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    1cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1caf:	01 d0                	add    %edx,%eax
    1cb1:	0f b6 00             	movzbl (%eax),%eax
    1cb4:	3c 70                	cmp    $0x70,%al
    1cb6:	75 04                	jne    1cbc <sharedfd+0x167>
        np++;
    1cb8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    1cbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cc3:	83 f8 09             	cmp    $0x9,%eax
    1cc6:	76 ce                	jbe    1c96 <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1cc8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1ccf:	00 
    1cd0:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
    1cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1cda:	89 04 24             	mov    %eax,(%esp)
    1cdd:	e8 4e 2f 00 00       	call   4c30 <read>
    1ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1ce5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1ce9:	7f a2                	jg     1c8d <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    1ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1cee:	89 04 24             	mov    %eax,(%esp)
    1cf1:	e8 4a 2f 00 00       	call   4c40 <close>
  unlink("sharedfd");
    1cf6:	c7 04 24 5e 59 00 00 	movl   $0x595e,(%esp)
    1cfd:	e8 66 2f 00 00       	call   4c68 <unlink>
  if(nc == 10000 && np == 10000){
    1d02:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1d09:	75 1f                	jne    1d2a <sharedfd+0x1d5>
    1d0b:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1d12:	75 16                	jne    1d2a <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
    1d14:	c7 44 24 04 df 59 00 	movl   $0x59df,0x4(%esp)
    1d1b:	00 
    1d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d23:	e8 a0 30 00 00       	call   4dc8 <printf>
    1d28:	eb 27                	jmp    1d51 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1d2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d34:	89 44 24 08          	mov    %eax,0x8(%esp)
    1d38:	c7 44 24 04 ec 59 00 	movl   $0x59ec,0x4(%esp)
    1d3f:	00 
    1d40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d47:	e8 7c 30 00 00       	call   4dc8 <printf>
    exit();
    1d4c:	e8 c7 2e 00 00       	call   4c18 <exit>
  }
}
    1d51:	c9                   	leave  
    1d52:	c3                   	ret    

00001d53 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    1d53:	55                   	push   %ebp
    1d54:	89 e5                	mov    %esp,%ebp
    1d56:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    1d59:	c7 44 24 04 01 5a 00 	movl   $0x5a01,0x4(%esp)
    1d60:	00 
    1d61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d68:	e8 5b 30 00 00       	call   4dc8 <printf>

  unlink("f1");
    1d6d:	c7 04 24 10 5a 00 00 	movl   $0x5a10,(%esp)
    1d74:	e8 ef 2e 00 00       	call   4c68 <unlink>
  unlink("f2");
    1d79:	c7 04 24 13 5a 00 00 	movl   $0x5a13,(%esp)
    1d80:	e8 e3 2e 00 00       	call   4c68 <unlink>

  pid = fork();
    1d85:	e8 86 2e 00 00       	call   4c10 <fork>
    1d8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    1d8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1d91:	79 19                	jns    1dac <twofiles+0x59>
    printf(1, "fork failed\n");
    1d93:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    1d9a:	00 
    1d9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1da2:	e8 21 30 00 00       	call   4dc8 <printf>
    exit();
    1da7:	e8 6c 2e 00 00       	call   4c18 <exit>
  }

  fname = pid ? "f1" : "f2";
    1dac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1db0:	74 07                	je     1db9 <twofiles+0x66>
    1db2:	b8 10 5a 00 00       	mov    $0x5a10,%eax
    1db7:	eb 05                	jmp    1dbe <twofiles+0x6b>
    1db9:	b8 13 5a 00 00       	mov    $0x5a13,%eax
    1dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
    1dc1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1dc8:	00 
    1dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1dcc:	89 04 24             	mov    %eax,(%esp)
    1dcf:	e8 84 2e 00 00       	call   4c58 <open>
    1dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
    1dd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1ddb:	79 19                	jns    1df6 <twofiles+0xa3>
    printf(1, "create failed\n");
    1ddd:	c7 44 24 04 16 5a 00 	movl   $0x5a16,0x4(%esp)
    1de4:	00 
    1de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dec:	e8 d7 2f 00 00       	call   4dc8 <printf>
    exit();
    1df1:	e8 22 2e 00 00       	call   4c18 <exit>
  }

  memset(buf, pid?'p':'c', 512);
    1df6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1dfa:	74 07                	je     1e03 <twofiles+0xb0>
    1dfc:	b8 70 00 00 00       	mov    $0x70,%eax
    1e01:	eb 05                	jmp    1e08 <twofiles+0xb5>
    1e03:	b8 63 00 00 00       	mov    $0x63,%eax
    1e08:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1e0f:	00 
    1e10:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e14:	c7 04 24 20 9c 00 00 	movl   $0x9c20,(%esp)
    1e1b:	e8 4b 2c 00 00       	call   4a6b <memset>
  for(i = 0; i < 12; i++){
    1e20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e27:	eb 4b                	jmp    1e74 <twofiles+0x121>
    if((n = write(fd, buf, 500)) != 500){
    1e29:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1e30:	00 
    1e31:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1e38:	00 
    1e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1e3c:	89 04 24             	mov    %eax,(%esp)
    1e3f:	e8 f4 2d 00 00       	call   4c38 <write>
    1e44:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1e47:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    1e4e:	74 20                	je     1e70 <twofiles+0x11d>
      printf(1, "write failed %d\n", n);
    1e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1e53:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e57:	c7 44 24 04 25 5a 00 	movl   $0x5a25,0x4(%esp)
    1e5e:	00 
    1e5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e66:	e8 5d 2f 00 00       	call   4dc8 <printf>
      exit();
    1e6b:	e8 a8 2d 00 00       	call   4c18 <exit>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    1e70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1e74:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1e78:	7e af                	jle    1e29 <twofiles+0xd6>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    1e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1e7d:	89 04 24             	mov    %eax,(%esp)
    1e80:	e8 bb 2d 00 00       	call   4c40 <close>
  if(pid)
    1e85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1e89:	74 11                	je     1e9c <twofiles+0x149>
    wait();
    1e8b:	e8 90 2d 00 00       	call   4c20 <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
    1e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e97:	e9 e7 00 00 00       	jmp    1f83 <twofiles+0x230>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
    1e9c:	e8 77 2d 00 00       	call   4c18 <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    1ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ea5:	74 07                	je     1eae <twofiles+0x15b>
    1ea7:	b8 10 5a 00 00       	mov    $0x5a10,%eax
    1eac:	eb 05                	jmp    1eb3 <twofiles+0x160>
    1eae:	b8 13 5a 00 00       	mov    $0x5a13,%eax
    1eb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1eba:	00 
    1ebb:	89 04 24             	mov    %eax,(%esp)
    1ebe:	e8 95 2d 00 00       	call   4c58 <open>
    1ec3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    1ec6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1ecd:	eb 58                	jmp    1f27 <twofiles+0x1d4>
      for(j = 0; j < n; j++){
    1ecf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1ed6:	eb 41                	jmp    1f19 <twofiles+0x1c6>
        if(buf[j] != (i?'p':'c')){
    1ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1edb:	05 20 9c 00 00       	add    $0x9c20,%eax
    1ee0:	0f b6 00             	movzbl (%eax),%eax
    1ee3:	0f be d0             	movsbl %al,%edx
    1ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1eea:	74 07                	je     1ef3 <twofiles+0x1a0>
    1eec:	b8 70 00 00 00       	mov    $0x70,%eax
    1ef1:	eb 05                	jmp    1ef8 <twofiles+0x1a5>
    1ef3:	b8 63 00 00 00       	mov    $0x63,%eax
    1ef8:	39 c2                	cmp    %eax,%edx
    1efa:	74 19                	je     1f15 <twofiles+0x1c2>
          printf(1, "wrong char\n");
    1efc:	c7 44 24 04 36 5a 00 	movl   $0x5a36,0x4(%esp)
    1f03:	00 
    1f04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f0b:	e8 b8 2e 00 00       	call   4dc8 <printf>
          exit();
    1f10:	e8 03 2d 00 00       	call   4c18 <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    1f15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1f1c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    1f1f:	7c b7                	jl     1ed8 <twofiles+0x185>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1f24:	01 45 ec             	add    %eax,-0x14(%ebp)
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f27:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1f2e:	00 
    1f2f:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    1f36:	00 
    1f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1f3a:	89 04 24             	mov    %eax,(%esp)
    1f3d:	e8 ee 2c 00 00       	call   4c30 <read>
    1f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1f45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1f49:	7f 84                	jg     1ecf <twofiles+0x17c>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1f4e:	89 04 24             	mov    %eax,(%esp)
    1f51:	e8 ea 2c 00 00       	call   4c40 <close>
    if(total != 12*500){
    1f56:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1f5d:	74 20                	je     1f7f <twofiles+0x22c>
      printf(1, "wrong length %d\n", total);
    1f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1f62:	89 44 24 08          	mov    %eax,0x8(%esp)
    1f66:	c7 44 24 04 42 5a 00 	movl   $0x5a42,0x4(%esp)
    1f6d:	00 
    1f6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f75:	e8 4e 2e 00 00       	call   4dc8 <printf>
      exit();
    1f7a:	e8 99 2c 00 00       	call   4c18 <exit>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    1f7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f83:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1f87:	0f 8e 14 ff ff ff    	jle    1ea1 <twofiles+0x14e>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    1f8d:	c7 04 24 10 5a 00 00 	movl   $0x5a10,(%esp)
    1f94:	e8 cf 2c 00 00       	call   4c68 <unlink>
  unlink("f2");
    1f99:	c7 04 24 13 5a 00 00 	movl   $0x5a13,(%esp)
    1fa0:	e8 c3 2c 00 00       	call   4c68 <unlink>

  printf(1, "twofiles ok\n");
    1fa5:	c7 44 24 04 53 5a 00 	movl   $0x5a53,0x4(%esp)
    1fac:	00 
    1fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fb4:	e8 0f 2e 00 00       	call   4dc8 <printf>
}
    1fb9:	c9                   	leave  
    1fba:	c3                   	ret    

00001fbb <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
    1fbb:	55                   	push   %ebp
    1fbc:	89 e5                	mov    %esp,%ebp
    1fbe:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
    1fc1:	c7 44 24 04 60 5a 00 	movl   $0x5a60,0x4(%esp)
    1fc8:	00 
    1fc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fd0:	e8 f3 2d 00 00       	call   4dc8 <printf>
  pid = fork();
    1fd5:	e8 36 2c 00 00       	call   4c10 <fork>
    1fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
    1fdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1fe1:	79 19                	jns    1ffc <createdelete+0x41>
    printf(1, "fork failed\n");
    1fe3:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    1fea:	00 
    1feb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ff2:	e8 d1 2d 00 00       	call   4dc8 <printf>
    exit();
    1ff7:	e8 1c 2c 00 00       	call   4c18 <exit>
  }

  name[0] = pid ? 'p' : 'c';
    1ffc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2000:	74 07                	je     2009 <createdelete+0x4e>
    2002:	b8 70 00 00 00       	mov    $0x70,%eax
    2007:	eb 05                	jmp    200e <createdelete+0x53>
    2009:	b8 63 00 00 00       	mov    $0x63,%eax
    200e:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
    2011:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
    2015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    201c:	e9 97 00 00 00       	jmp    20b8 <createdelete+0xfd>
    name[1] = '0' + i;
    2021:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2024:	83 c0 30             	add    $0x30,%eax
    2027:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    202a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2031:	00 
    2032:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2035:	89 04 24             	mov    %eax,(%esp)
    2038:	e8 1b 2c 00 00       	call   4c58 <open>
    203d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2040:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2044:	79 19                	jns    205f <createdelete+0xa4>
      printf(1, "create failed\n");
    2046:	c7 44 24 04 16 5a 00 	movl   $0x5a16,0x4(%esp)
    204d:	00 
    204e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2055:	e8 6e 2d 00 00       	call   4dc8 <printf>
      exit();
    205a:	e8 b9 2b 00 00       	call   4c18 <exit>
    }
    close(fd);
    205f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2062:	89 04 24             	mov    %eax,(%esp)
    2065:	e8 d6 2b 00 00       	call   4c40 <close>
    if(i > 0 && (i % 2 ) == 0){
    206a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    206e:	7e 44                	jle    20b4 <createdelete+0xf9>
    2070:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2073:	83 e0 01             	and    $0x1,%eax
    2076:	85 c0                	test   %eax,%eax
    2078:	75 3a                	jne    20b4 <createdelete+0xf9>
      name[1] = '0' + (i / 2);
    207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    207d:	89 c2                	mov    %eax,%edx
    207f:	c1 ea 1f             	shr    $0x1f,%edx
    2082:	01 d0                	add    %edx,%eax
    2084:	d1 f8                	sar    %eax
    2086:	83 c0 30             	add    $0x30,%eax
    2089:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    208c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    208f:	89 04 24             	mov    %eax,(%esp)
    2092:	e8 d1 2b 00 00       	call   4c68 <unlink>
    2097:	85 c0                	test   %eax,%eax
    2099:	79 19                	jns    20b4 <createdelete+0xf9>
        printf(1, "unlink failed\n");
    209b:	c7 44 24 04 73 5a 00 	movl   $0x5a73,0x4(%esp)
    20a2:	00 
    20a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20aa:	e8 19 2d 00 00       	call   4dc8 <printf>
        exit();
    20af:	e8 64 2b 00 00       	call   4c18 <exit>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
    20b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    20b8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    20bc:	0f 8e 5f ff ff ff    	jle    2021 <createdelete+0x66>
        exit();
      }
    }
  }

  if(pid==0)
    20c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    20c6:	75 05                	jne    20cd <createdelete+0x112>
    exit();
    20c8:	e8 4b 2b 00 00       	call   4c18 <exit>
  else
    wait();
    20cd:	e8 4e 2b 00 00       	call   4c20 <wait>

  for(i = 0; i < N; i++){
    20d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    20d9:	e9 34 01 00 00       	jmp    2212 <createdelete+0x257>
    name[0] = 'p';
    20de:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    20e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20e5:	83 c0 30             	add    $0x30,%eax
    20e8:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    20eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20f2:	00 
    20f3:	8d 45 cc             	lea    -0x34(%ebp),%eax
    20f6:	89 04 24             	mov    %eax,(%esp)
    20f9:	e8 5a 2b 00 00       	call   4c58 <open>
    20fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    2101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2105:	74 06                	je     210d <createdelete+0x152>
    2107:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    210b:	7e 26                	jle    2133 <createdelete+0x178>
    210d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2111:	79 20                	jns    2133 <createdelete+0x178>
      printf(1, "oops createdelete %s didn't exist\n", name);
    2113:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2116:	89 44 24 08          	mov    %eax,0x8(%esp)
    211a:	c7 44 24 04 84 5a 00 	movl   $0x5a84,0x4(%esp)
    2121:	00 
    2122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2129:	e8 9a 2c 00 00       	call   4dc8 <printf>
      exit();
    212e:	e8 e5 2a 00 00       	call   4c18 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    2133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2137:	7e 2c                	jle    2165 <createdelete+0x1aa>
    2139:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    213d:	7f 26                	jg     2165 <createdelete+0x1aa>
    213f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2143:	78 20                	js     2165 <createdelete+0x1aa>
      printf(1, "oops createdelete %s did exist\n", name);
    2145:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2148:	89 44 24 08          	mov    %eax,0x8(%esp)
    214c:	c7 44 24 04 a8 5a 00 	movl   $0x5aa8,0x4(%esp)
    2153:	00 
    2154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    215b:	e8 68 2c 00 00       	call   4dc8 <printf>
      exit();
    2160:	e8 b3 2a 00 00       	call   4c18 <exit>
    }
    if(fd >= 0)
    2165:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2169:	78 0b                	js     2176 <createdelete+0x1bb>
      close(fd);
    216b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    216e:	89 04 24             	mov    %eax,(%esp)
    2171:	e8 ca 2a 00 00       	call   4c40 <close>

    name[0] = 'c';
    2176:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    217d:	83 c0 30             	add    $0x30,%eax
    2180:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    2183:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    218a:	00 
    218b:	8d 45 cc             	lea    -0x34(%ebp),%eax
    218e:	89 04 24             	mov    %eax,(%esp)
    2191:	e8 c2 2a 00 00       	call   4c58 <open>
    2196:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    2199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    219d:	74 06                	je     21a5 <createdelete+0x1ea>
    219f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    21a3:	7e 26                	jle    21cb <createdelete+0x210>
    21a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    21a9:	79 20                	jns    21cb <createdelete+0x210>
      printf(1, "oops createdelete %s didn't exist\n", name);
    21ab:	8d 45 cc             	lea    -0x34(%ebp),%eax
    21ae:	89 44 24 08          	mov    %eax,0x8(%esp)
    21b2:	c7 44 24 04 84 5a 00 	movl   $0x5a84,0x4(%esp)
    21b9:	00 
    21ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c1:	e8 02 2c 00 00       	call   4dc8 <printf>
      exit();
    21c6:	e8 4d 2a 00 00       	call   4c18 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    21cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21cf:	7e 2c                	jle    21fd <createdelete+0x242>
    21d1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    21d5:	7f 26                	jg     21fd <createdelete+0x242>
    21d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    21db:	78 20                	js     21fd <createdelete+0x242>
      printf(1, "oops createdelete %s did exist\n", name);
    21dd:	8d 45 cc             	lea    -0x34(%ebp),%eax
    21e0:	89 44 24 08          	mov    %eax,0x8(%esp)
    21e4:	c7 44 24 04 a8 5a 00 	movl   $0x5aa8,0x4(%esp)
    21eb:	00 
    21ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21f3:	e8 d0 2b 00 00       	call   4dc8 <printf>
      exit();
    21f8:	e8 1b 2a 00 00       	call   4c18 <exit>
    }
    if(fd >= 0)
    21fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2201:	78 0b                	js     220e <createdelete+0x253>
      close(fd);
    2203:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2206:	89 04 24             	mov    %eax,(%esp)
    2209:	e8 32 2a 00 00       	call   4c40 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    220e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2212:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2216:	0f 8e c2 fe ff ff    	jle    20de <createdelete+0x123>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    221c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2223:	eb 2b                	jmp    2250 <createdelete+0x295>
    name[0] = 'p';
    2225:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    2229:	8b 45 f4             	mov    -0xc(%ebp),%eax
    222c:	83 c0 30             	add    $0x30,%eax
    222f:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    2232:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2235:	89 04 24             	mov    %eax,(%esp)
    2238:	e8 2b 2a 00 00       	call   4c68 <unlink>
    name[0] = 'c';
    223d:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    2241:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2244:	89 04 24             	mov    %eax,(%esp)
    2247:	e8 1c 2a 00 00       	call   4c68 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    224c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2250:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2254:	7e cf                	jle    2225 <createdelete+0x26a>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
    2256:	c7 44 24 04 c8 5a 00 	movl   $0x5ac8,0x4(%esp)
    225d:	00 
    225e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2265:	e8 5e 2b 00 00       	call   4dc8 <printf>
}
    226a:	c9                   	leave  
    226b:	c3                   	ret    

0000226c <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    226c:	55                   	push   %ebp
    226d:	89 e5                	mov    %esp,%ebp
    226f:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    2272:	c7 44 24 04 d9 5a 00 	movl   $0x5ad9,0x4(%esp)
    2279:	00 
    227a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2281:	e8 42 2b 00 00       	call   4dc8 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    2286:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    228d:	00 
    228e:	c7 04 24 ea 5a 00 00 	movl   $0x5aea,(%esp)
    2295:	e8 be 29 00 00       	call   4c58 <open>
    229a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22a1:	79 19                	jns    22bc <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    22a3:	c7 44 24 04 f5 5a 00 	movl   $0x5af5,0x4(%esp)
    22aa:	00 
    22ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22b2:	e8 11 2b 00 00       	call   4dc8 <printf>
    exit();
    22b7:	e8 5c 29 00 00       	call   4c18 <exit>
  }
  write(fd, "hello", 5);
    22bc:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    22c3:	00 
    22c4:	c7 44 24 04 0f 5b 00 	movl   $0x5b0f,0x4(%esp)
    22cb:	00 
    22cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22cf:	89 04 24             	mov    %eax,(%esp)
    22d2:	e8 61 29 00 00       	call   4c38 <write>
  close(fd);
    22d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22da:	89 04 24             	mov    %eax,(%esp)
    22dd:	e8 5e 29 00 00       	call   4c40 <close>

  fd = open("unlinkread", O_RDWR);
    22e2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    22e9:	00 
    22ea:	c7 04 24 ea 5a 00 00 	movl   $0x5aea,(%esp)
    22f1:	e8 62 29 00 00       	call   4c58 <open>
    22f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22fd:	79 19                	jns    2318 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    22ff:	c7 44 24 04 15 5b 00 	movl   $0x5b15,0x4(%esp)
    2306:	00 
    2307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    230e:	e8 b5 2a 00 00       	call   4dc8 <printf>
    exit();
    2313:	e8 00 29 00 00       	call   4c18 <exit>
  }
  if(unlink("unlinkread") != 0){
    2318:	c7 04 24 ea 5a 00 00 	movl   $0x5aea,(%esp)
    231f:	e8 44 29 00 00       	call   4c68 <unlink>
    2324:	85 c0                	test   %eax,%eax
    2326:	74 19                	je     2341 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    2328:	c7 44 24 04 2d 5b 00 	movl   $0x5b2d,0x4(%esp)
    232f:	00 
    2330:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2337:	e8 8c 2a 00 00       	call   4dc8 <printf>
    exit();
    233c:	e8 d7 28 00 00       	call   4c18 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2341:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2348:	00 
    2349:	c7 04 24 ea 5a 00 00 	movl   $0x5aea,(%esp)
    2350:	e8 03 29 00 00       	call   4c58 <open>
    2355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    2358:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    235f:	00 
    2360:	c7 44 24 04 47 5b 00 	movl   $0x5b47,0x4(%esp)
    2367:	00 
    2368:	8b 45 f0             	mov    -0x10(%ebp),%eax
    236b:	89 04 24             	mov    %eax,(%esp)
    236e:	e8 c5 28 00 00       	call   4c38 <write>
  close(fd1);
    2373:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2376:	89 04 24             	mov    %eax,(%esp)
    2379:	e8 c2 28 00 00       	call   4c40 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    237e:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2385:	00 
    2386:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    238d:	00 
    238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2391:	89 04 24             	mov    %eax,(%esp)
    2394:	e8 97 28 00 00       	call   4c30 <read>
    2399:	83 f8 05             	cmp    $0x5,%eax
    239c:	74 19                	je     23b7 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    239e:	c7 44 24 04 4b 5b 00 	movl   $0x5b4b,0x4(%esp)
    23a5:	00 
    23a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23ad:	e8 16 2a 00 00       	call   4dc8 <printf>
    exit();
    23b2:	e8 61 28 00 00       	call   4c18 <exit>
  }
  if(buf[0] != 'h'){
    23b7:	0f b6 05 20 9c 00 00 	movzbl 0x9c20,%eax
    23be:	3c 68                	cmp    $0x68,%al
    23c0:	74 19                	je     23db <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    23c2:	c7 44 24 04 62 5b 00 	movl   $0x5b62,0x4(%esp)
    23c9:	00 
    23ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23d1:	e8 f2 29 00 00       	call   4dc8 <printf>
    exit();
    23d6:	e8 3d 28 00 00       	call   4c18 <exit>
  }
  if(write(fd, buf, 10) != 10){
    23db:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    23e2:	00 
    23e3:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    23ea:	00 
    23eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23ee:	89 04 24             	mov    %eax,(%esp)
    23f1:	e8 42 28 00 00       	call   4c38 <write>
    23f6:	83 f8 0a             	cmp    $0xa,%eax
    23f9:	74 19                	je     2414 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    23fb:	c7 44 24 04 79 5b 00 	movl   $0x5b79,0x4(%esp)
    2402:	00 
    2403:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240a:	e8 b9 29 00 00       	call   4dc8 <printf>
    exit();
    240f:	e8 04 28 00 00       	call   4c18 <exit>
  }
  close(fd);
    2414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2417:	89 04 24             	mov    %eax,(%esp)
    241a:	e8 21 28 00 00       	call   4c40 <close>
  unlink("unlinkread");
    241f:	c7 04 24 ea 5a 00 00 	movl   $0x5aea,(%esp)
    2426:	e8 3d 28 00 00       	call   4c68 <unlink>
  printf(1, "unlinkread ok\n");
    242b:	c7 44 24 04 92 5b 00 	movl   $0x5b92,0x4(%esp)
    2432:	00 
    2433:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    243a:	e8 89 29 00 00       	call   4dc8 <printf>
}
    243f:	c9                   	leave  
    2440:	c3                   	ret    

00002441 <linktest>:

void
linktest(void)
{
    2441:	55                   	push   %ebp
    2442:	89 e5                	mov    %esp,%ebp
    2444:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    2447:	c7 44 24 04 a1 5b 00 	movl   $0x5ba1,0x4(%esp)
    244e:	00 
    244f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2456:	e8 6d 29 00 00       	call   4dc8 <printf>

  unlink("lf1");
    245b:	c7 04 24 ab 5b 00 00 	movl   $0x5bab,(%esp)
    2462:	e8 01 28 00 00       	call   4c68 <unlink>
  unlink("lf2");
    2467:	c7 04 24 af 5b 00 00 	movl   $0x5baf,(%esp)
    246e:	e8 f5 27 00 00       	call   4c68 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    2473:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    247a:	00 
    247b:	c7 04 24 ab 5b 00 00 	movl   $0x5bab,(%esp)
    2482:	e8 d1 27 00 00       	call   4c58 <open>
    2487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    248a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    248e:	79 19                	jns    24a9 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    2490:	c7 44 24 04 b3 5b 00 	movl   $0x5bb3,0x4(%esp)
    2497:	00 
    2498:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    249f:	e8 24 29 00 00       	call   4dc8 <printf>
    exit();
    24a4:	e8 6f 27 00 00       	call   4c18 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    24a9:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    24b0:	00 
    24b1:	c7 44 24 04 0f 5b 00 	movl   $0x5b0f,0x4(%esp)
    24b8:	00 
    24b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24bc:	89 04 24             	mov    %eax,(%esp)
    24bf:	e8 74 27 00 00       	call   4c38 <write>
    24c4:	83 f8 05             	cmp    $0x5,%eax
    24c7:	74 19                	je     24e2 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    24c9:	c7 44 24 04 c6 5b 00 	movl   $0x5bc6,0x4(%esp)
    24d0:	00 
    24d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24d8:	e8 eb 28 00 00       	call   4dc8 <printf>
    exit();
    24dd:	e8 36 27 00 00       	call   4c18 <exit>
  }
  close(fd);
    24e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24e5:	89 04 24             	mov    %eax,(%esp)
    24e8:	e8 53 27 00 00       	call   4c40 <close>

  if(link("lf1", "lf2") < 0){
    24ed:	c7 44 24 04 af 5b 00 	movl   $0x5baf,0x4(%esp)
    24f4:	00 
    24f5:	c7 04 24 ab 5b 00 00 	movl   $0x5bab,(%esp)
    24fc:	e8 77 27 00 00       	call   4c78 <link>
    2501:	85 c0                	test   %eax,%eax
    2503:	79 19                	jns    251e <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    2505:	c7 44 24 04 d8 5b 00 	movl   $0x5bd8,0x4(%esp)
    250c:	00 
    250d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2514:	e8 af 28 00 00       	call   4dc8 <printf>
    exit();
    2519:	e8 fa 26 00 00       	call   4c18 <exit>
  }
  unlink("lf1");
    251e:	c7 04 24 ab 5b 00 00 	movl   $0x5bab,(%esp)
    2525:	e8 3e 27 00 00       	call   4c68 <unlink>

  if(open("lf1", 0) >= 0){
    252a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2531:	00 
    2532:	c7 04 24 ab 5b 00 00 	movl   $0x5bab,(%esp)
    2539:	e8 1a 27 00 00       	call   4c58 <open>
    253e:	85 c0                	test   %eax,%eax
    2540:	78 19                	js     255b <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    2542:	c7 44 24 04 f0 5b 00 	movl   $0x5bf0,0x4(%esp)
    2549:	00 
    254a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2551:	e8 72 28 00 00       	call   4dc8 <printf>
    exit();
    2556:	e8 bd 26 00 00       	call   4c18 <exit>
  }

  fd = open("lf2", 0);
    255b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2562:	00 
    2563:	c7 04 24 af 5b 00 00 	movl   $0x5baf,(%esp)
    256a:	e8 e9 26 00 00       	call   4c58 <open>
    256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2576:	79 19                	jns    2591 <linktest+0x150>
    printf(1, "open lf2 failed\n");
    2578:	c7 44 24 04 15 5c 00 	movl   $0x5c15,0x4(%esp)
    257f:	00 
    2580:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2587:	e8 3c 28 00 00       	call   4dc8 <printf>
    exit();
    258c:	e8 87 26 00 00       	call   4c18 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    2591:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2598:	00 
    2599:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    25a0:	00 
    25a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25a4:	89 04 24             	mov    %eax,(%esp)
    25a7:	e8 84 26 00 00       	call   4c30 <read>
    25ac:	83 f8 05             	cmp    $0x5,%eax
    25af:	74 19                	je     25ca <linktest+0x189>
    printf(1, "read lf2 failed\n");
    25b1:	c7 44 24 04 26 5c 00 	movl   $0x5c26,0x4(%esp)
    25b8:	00 
    25b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25c0:	e8 03 28 00 00       	call   4dc8 <printf>
    exit();
    25c5:	e8 4e 26 00 00       	call   4c18 <exit>
  }
  close(fd);
    25ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25cd:	89 04 24             	mov    %eax,(%esp)
    25d0:	e8 6b 26 00 00       	call   4c40 <close>

  if(link("lf2", "lf2") >= 0){
    25d5:	c7 44 24 04 af 5b 00 	movl   $0x5baf,0x4(%esp)
    25dc:	00 
    25dd:	c7 04 24 af 5b 00 00 	movl   $0x5baf,(%esp)
    25e4:	e8 8f 26 00 00       	call   4c78 <link>
    25e9:	85 c0                	test   %eax,%eax
    25eb:	78 19                	js     2606 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    25ed:	c7 44 24 04 37 5c 00 	movl   $0x5c37,0x4(%esp)
    25f4:	00 
    25f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25fc:	e8 c7 27 00 00       	call   4dc8 <printf>
    exit();
    2601:	e8 12 26 00 00       	call   4c18 <exit>
  }

  unlink("lf2");
    2606:	c7 04 24 af 5b 00 00 	movl   $0x5baf,(%esp)
    260d:	e8 56 26 00 00       	call   4c68 <unlink>
  if(link("lf2", "lf1") >= 0){
    2612:	c7 44 24 04 ab 5b 00 	movl   $0x5bab,0x4(%esp)
    2619:	00 
    261a:	c7 04 24 af 5b 00 00 	movl   $0x5baf,(%esp)
    2621:	e8 52 26 00 00       	call   4c78 <link>
    2626:	85 c0                	test   %eax,%eax
    2628:	78 19                	js     2643 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    262a:	c7 44 24 04 58 5c 00 	movl   $0x5c58,0x4(%esp)
    2631:	00 
    2632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2639:	e8 8a 27 00 00       	call   4dc8 <printf>
    exit();
    263e:	e8 d5 25 00 00       	call   4c18 <exit>
  }

  if(link(".", "lf1") >= 0){
    2643:	c7 44 24 04 ab 5b 00 	movl   $0x5bab,0x4(%esp)
    264a:	00 
    264b:	c7 04 24 7b 5c 00 00 	movl   $0x5c7b,(%esp)
    2652:	e8 21 26 00 00       	call   4c78 <link>
    2657:	85 c0                	test   %eax,%eax
    2659:	78 19                	js     2674 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    265b:	c7 44 24 04 7d 5c 00 	movl   $0x5c7d,0x4(%esp)
    2662:	00 
    2663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    266a:	e8 59 27 00 00       	call   4dc8 <printf>
    exit();
    266f:	e8 a4 25 00 00       	call   4c18 <exit>
  }

  printf(1, "linktest ok\n");
    2674:	c7 44 24 04 99 5c 00 	movl   $0x5c99,0x4(%esp)
    267b:	00 
    267c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2683:	e8 40 27 00 00       	call   4dc8 <printf>
}
    2688:	c9                   	leave  
    2689:	c3                   	ret    

0000268a <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    268a:	55                   	push   %ebp
    268b:	89 e5                	mov    %esp,%ebp
    268d:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    2690:	c7 44 24 04 a6 5c 00 	movl   $0x5ca6,0x4(%esp)
    2697:	00 
    2698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    269f:	e8 24 27 00 00       	call   4dc8 <printf>
  file[0] = 'C';
    26a4:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    26a8:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    26ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    26b3:	e9 f7 00 00 00       	jmp    27af <concreate+0x125>
    file[1] = '0' + i;
    26b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26bb:	83 c0 30             	add    $0x30,%eax
    26be:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    26c1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    26c4:	89 04 24             	mov    %eax,(%esp)
    26c7:	e8 9c 25 00 00       	call   4c68 <unlink>
    pid = fork();
    26cc:	e8 3f 25 00 00       	call   4c10 <fork>
    26d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    26d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26d8:	74 3a                	je     2714 <concreate+0x8a>
    26da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    26dd:	ba 56 55 55 55       	mov    $0x55555556,%edx
    26e2:	89 c8                	mov    %ecx,%eax
    26e4:	f7 ea                	imul   %edx
    26e6:	89 c8                	mov    %ecx,%eax
    26e8:	c1 f8 1f             	sar    $0x1f,%eax
    26eb:	29 c2                	sub    %eax,%edx
    26ed:	89 d0                	mov    %edx,%eax
    26ef:	01 c0                	add    %eax,%eax
    26f1:	01 d0                	add    %edx,%eax
    26f3:	29 c1                	sub    %eax,%ecx
    26f5:	89 ca                	mov    %ecx,%edx
    26f7:	83 fa 01             	cmp    $0x1,%edx
    26fa:	75 18                	jne    2714 <concreate+0x8a>
      link("C0", file);
    26fc:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    26ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    2703:	c7 04 24 b6 5c 00 00 	movl   $0x5cb6,(%esp)
    270a:	e8 69 25 00 00       	call   4c78 <link>
    270f:	e9 87 00 00 00       	jmp    279b <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    2714:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2718:	75 3a                	jne    2754 <concreate+0xca>
    271a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    271d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    2722:	89 c8                	mov    %ecx,%eax
    2724:	f7 ea                	imul   %edx
    2726:	d1 fa                	sar    %edx
    2728:	89 c8                	mov    %ecx,%eax
    272a:	c1 f8 1f             	sar    $0x1f,%eax
    272d:	29 c2                	sub    %eax,%edx
    272f:	89 d0                	mov    %edx,%eax
    2731:	c1 e0 02             	shl    $0x2,%eax
    2734:	01 d0                	add    %edx,%eax
    2736:	29 c1                	sub    %eax,%ecx
    2738:	89 ca                	mov    %ecx,%edx
    273a:	83 fa 01             	cmp    $0x1,%edx
    273d:	75 15                	jne    2754 <concreate+0xca>
      link("C0", file);
    273f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2742:	89 44 24 04          	mov    %eax,0x4(%esp)
    2746:	c7 04 24 b6 5c 00 00 	movl   $0x5cb6,(%esp)
    274d:	e8 26 25 00 00       	call   4c78 <link>
    2752:	eb 47                	jmp    279b <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    2754:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    275b:	00 
    275c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    275f:	89 04 24             	mov    %eax,(%esp)
    2762:	e8 f1 24 00 00       	call   4c58 <open>
    2767:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    276a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    276e:	79 20                	jns    2790 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    2770:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2773:	89 44 24 08          	mov    %eax,0x8(%esp)
    2777:	c7 44 24 04 b9 5c 00 	movl   $0x5cb9,0x4(%esp)
    277e:	00 
    277f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2786:	e8 3d 26 00 00       	call   4dc8 <printf>
        exit();
    278b:	e8 88 24 00 00       	call   4c18 <exit>
      }
      close(fd);
    2790:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2793:	89 04 24             	mov    %eax,(%esp)
    2796:	e8 a5 24 00 00       	call   4c40 <close>
    }
    if(pid == 0)
    279b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    279f:	75 05                	jne    27a6 <concreate+0x11c>
      exit();
    27a1:	e8 72 24 00 00       	call   4c18 <exit>
    else
      wait();
    27a6:	e8 75 24 00 00       	call   4c20 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    27ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    27af:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    27b3:	0f 8e ff fe ff ff    	jle    26b8 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    27b9:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    27c0:	00 
    27c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27c8:	00 
    27c9:	8d 45 bd             	lea    -0x43(%ebp),%eax
    27cc:	89 04 24             	mov    %eax,(%esp)
    27cf:	e8 97 22 00 00       	call   4a6b <memset>
  fd = open(".", 0);
    27d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27db:	00 
    27dc:	c7 04 24 7b 5c 00 00 	movl   $0x5c7b,(%esp)
    27e3:	e8 70 24 00 00       	call   4c58 <open>
    27e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    27eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    27f2:	e9 a1 00 00 00       	jmp    2898 <concreate+0x20e>
    if(de.inum == 0)
    27f7:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    27fb:	66 85 c0             	test   %ax,%ax
    27fe:	75 05                	jne    2805 <concreate+0x17b>
      continue;
    2800:	e9 93 00 00 00       	jmp    2898 <concreate+0x20e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2805:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    2809:	3c 43                	cmp    $0x43,%al
    280b:	0f 85 87 00 00 00    	jne    2898 <concreate+0x20e>
    2811:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    2815:	84 c0                	test   %al,%al
    2817:	75 7f                	jne    2898 <concreate+0x20e>
      i = de.name[1] - '0';
    2819:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    281d:	0f be c0             	movsbl %al,%eax
    2820:	83 e8 30             	sub    $0x30,%eax
    2823:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    2826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    282a:	78 08                	js     2834 <concreate+0x1aa>
    282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    282f:	83 f8 27             	cmp    $0x27,%eax
    2832:	76 23                	jbe    2857 <concreate+0x1cd>
        printf(1, "concreate weird file %s\n", de.name);
    2834:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2837:	83 c0 02             	add    $0x2,%eax
    283a:	89 44 24 08          	mov    %eax,0x8(%esp)
    283e:	c7 44 24 04 d5 5c 00 	movl   $0x5cd5,0x4(%esp)
    2845:	00 
    2846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    284d:	e8 76 25 00 00       	call   4dc8 <printf>
        exit();
    2852:	e8 c1 23 00 00       	call   4c18 <exit>
      }
      if(fa[i]){
    2857:	8d 55 bd             	lea    -0x43(%ebp),%edx
    285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    285d:	01 d0                	add    %edx,%eax
    285f:	0f b6 00             	movzbl (%eax),%eax
    2862:	84 c0                	test   %al,%al
    2864:	74 23                	je     2889 <concreate+0x1ff>
        printf(1, "concreate duplicate file %s\n", de.name);
    2866:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2869:	83 c0 02             	add    $0x2,%eax
    286c:	89 44 24 08          	mov    %eax,0x8(%esp)
    2870:	c7 44 24 04 ee 5c 00 	movl   $0x5cee,0x4(%esp)
    2877:	00 
    2878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    287f:	e8 44 25 00 00       	call   4dc8 <printf>
        exit();
    2884:	e8 8f 23 00 00       	call   4c18 <exit>
      }
      fa[i] = 1;
    2889:	8d 55 bd             	lea    -0x43(%ebp),%edx
    288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    288f:	01 d0                	add    %edx,%eax
    2891:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    2894:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    2898:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    289f:	00 
    28a0:	8d 45 ac             	lea    -0x54(%ebp),%eax
    28a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    28a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    28aa:	89 04 24             	mov    %eax,(%esp)
    28ad:	e8 7e 23 00 00       	call   4c30 <read>
    28b2:	85 c0                	test   %eax,%eax
    28b4:	0f 8f 3d ff ff ff    	jg     27f7 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    28ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
    28bd:	89 04 24             	mov    %eax,(%esp)
    28c0:	e8 7b 23 00 00       	call   4c40 <close>

  if(n != 40){
    28c5:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    28c9:	74 19                	je     28e4 <concreate+0x25a>
    printf(1, "concreate not enough files in directory listing\n");
    28cb:	c7 44 24 04 0c 5d 00 	movl   $0x5d0c,0x4(%esp)
    28d2:	00 
    28d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28da:	e8 e9 24 00 00       	call   4dc8 <printf>
    exit();
    28df:	e8 34 23 00 00       	call   4c18 <exit>
  }

  for(i = 0; i < 40; i++){
    28e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    28eb:	e9 2d 01 00 00       	jmp    2a1d <concreate+0x393>
    file[1] = '0' + i;
    28f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28f3:	83 c0 30             	add    $0x30,%eax
    28f6:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    28f9:	e8 12 23 00 00       	call   4c10 <fork>
    28fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    2901:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2905:	79 19                	jns    2920 <concreate+0x296>
      printf(1, "fork failed\n");
    2907:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    290e:	00 
    290f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2916:	e8 ad 24 00 00       	call   4dc8 <printf>
      exit();
    291b:	e8 f8 22 00 00       	call   4c18 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    2920:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2923:	ba 56 55 55 55       	mov    $0x55555556,%edx
    2928:	89 c8                	mov    %ecx,%eax
    292a:	f7 ea                	imul   %edx
    292c:	89 c8                	mov    %ecx,%eax
    292e:	c1 f8 1f             	sar    $0x1f,%eax
    2931:	29 c2                	sub    %eax,%edx
    2933:	89 d0                	mov    %edx,%eax
    2935:	01 c0                	add    %eax,%eax
    2937:	01 d0                	add    %edx,%eax
    2939:	29 c1                	sub    %eax,%ecx
    293b:	89 ca                	mov    %ecx,%edx
    293d:	85 d2                	test   %edx,%edx
    293f:	75 06                	jne    2947 <concreate+0x2bd>
    2941:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2945:	74 28                	je     296f <concreate+0x2e5>
       ((i % 3) == 1 && pid != 0)){
    2947:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    294a:	ba 56 55 55 55       	mov    $0x55555556,%edx
    294f:	89 c8                	mov    %ecx,%eax
    2951:	f7 ea                	imul   %edx
    2953:	89 c8                	mov    %ecx,%eax
    2955:	c1 f8 1f             	sar    $0x1f,%eax
    2958:	29 c2                	sub    %eax,%edx
    295a:	89 d0                	mov    %edx,%eax
    295c:	01 c0                	add    %eax,%eax
    295e:	01 d0                	add    %edx,%eax
    2960:	29 c1                	sub    %eax,%ecx
    2962:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    2964:	83 fa 01             	cmp    $0x1,%edx
    2967:	75 74                	jne    29dd <concreate+0x353>
       ((i % 3) == 1 && pid != 0)){
    2969:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    296d:	74 6e                	je     29dd <concreate+0x353>
      close(open(file, 0));
    296f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2976:	00 
    2977:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    297a:	89 04 24             	mov    %eax,(%esp)
    297d:	e8 d6 22 00 00       	call   4c58 <open>
    2982:	89 04 24             	mov    %eax,(%esp)
    2985:	e8 b6 22 00 00       	call   4c40 <close>
      close(open(file, 0));
    298a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2991:	00 
    2992:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2995:	89 04 24             	mov    %eax,(%esp)
    2998:	e8 bb 22 00 00       	call   4c58 <open>
    299d:	89 04 24             	mov    %eax,(%esp)
    29a0:	e8 9b 22 00 00       	call   4c40 <close>
      close(open(file, 0));
    29a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    29ac:	00 
    29ad:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29b0:	89 04 24             	mov    %eax,(%esp)
    29b3:	e8 a0 22 00 00       	call   4c58 <open>
    29b8:	89 04 24             	mov    %eax,(%esp)
    29bb:	e8 80 22 00 00       	call   4c40 <close>
      close(open(file, 0));
    29c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    29c7:	00 
    29c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29cb:	89 04 24             	mov    %eax,(%esp)
    29ce:	e8 85 22 00 00       	call   4c58 <open>
    29d3:	89 04 24             	mov    %eax,(%esp)
    29d6:	e8 65 22 00 00       	call   4c40 <close>
    29db:	eb 2c                	jmp    2a09 <concreate+0x37f>
    } else {
      unlink(file);
    29dd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29e0:	89 04 24             	mov    %eax,(%esp)
    29e3:	e8 80 22 00 00       	call   4c68 <unlink>
      unlink(file);
    29e8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29eb:	89 04 24             	mov    %eax,(%esp)
    29ee:	e8 75 22 00 00       	call   4c68 <unlink>
      unlink(file);
    29f3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29f6:	89 04 24             	mov    %eax,(%esp)
    29f9:	e8 6a 22 00 00       	call   4c68 <unlink>
      unlink(file);
    29fe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2a01:	89 04 24             	mov    %eax,(%esp)
    2a04:	e8 5f 22 00 00       	call   4c68 <unlink>
    }
    if(pid == 0)
    2a09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a0d:	75 05                	jne    2a14 <concreate+0x38a>
      exit();
    2a0f:	e8 04 22 00 00       	call   4c18 <exit>
    else
      wait();
    2a14:	e8 07 22 00 00       	call   4c20 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    2a19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2a1d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    2a21:	0f 8e c9 fe ff ff    	jle    28f0 <concreate+0x266>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    2a27:	c7 44 24 04 3d 5d 00 	movl   $0x5d3d,0x4(%esp)
    2a2e:	00 
    2a2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a36:	e8 8d 23 00 00       	call   4dc8 <printf>
}
    2a3b:	c9                   	leave  
    2a3c:	c3                   	ret    

00002a3d <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    2a3d:	55                   	push   %ebp
    2a3e:	89 e5                	mov    %esp,%ebp
    2a40:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    2a43:	c7 44 24 04 4b 5d 00 	movl   $0x5d4b,0x4(%esp)
    2a4a:	00 
    2a4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a52:	e8 71 23 00 00       	call   4dc8 <printf>

  unlink("x");
    2a57:	c7 04 24 b2 58 00 00 	movl   $0x58b2,(%esp)
    2a5e:	e8 05 22 00 00       	call   4c68 <unlink>
  pid = fork();
    2a63:	e8 a8 21 00 00       	call   4c10 <fork>
    2a68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    2a6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a6f:	79 19                	jns    2a8a <linkunlink+0x4d>
    printf(1, "fork failed\n");
    2a71:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    2a78:	00 
    2a79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a80:	e8 43 23 00 00       	call   4dc8 <printf>
    exit();
    2a85:	e8 8e 21 00 00       	call   4c18 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    2a8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a8e:	74 07                	je     2a97 <linkunlink+0x5a>
    2a90:	b8 01 00 00 00       	mov    $0x1,%eax
    2a95:	eb 05                	jmp    2a9c <linkunlink+0x5f>
    2a97:	b8 61 00 00 00       	mov    $0x61,%eax
    2a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    2a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2aa6:	e9 8e 00 00 00       	jmp    2b39 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    2aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2aae:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    2ab4:	05 39 30 00 00       	add    $0x3039,%eax
    2ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    2abc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    2abf:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2ac4:	89 c8                	mov    %ecx,%eax
    2ac6:	f7 e2                	mul    %edx
    2ac8:	d1 ea                	shr    %edx
    2aca:	89 d0                	mov    %edx,%eax
    2acc:	01 c0                	add    %eax,%eax
    2ace:	01 d0                	add    %edx,%eax
    2ad0:	29 c1                	sub    %eax,%ecx
    2ad2:	89 ca                	mov    %ecx,%edx
    2ad4:	85 d2                	test   %edx,%edx
    2ad6:	75 1e                	jne    2af6 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    2ad8:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2adf:	00 
    2ae0:	c7 04 24 b2 58 00 00 	movl   $0x58b2,(%esp)
    2ae7:	e8 6c 21 00 00       	call   4c58 <open>
    2aec:	89 04 24             	mov    %eax,(%esp)
    2aef:	e8 4c 21 00 00       	call   4c40 <close>
    2af4:	eb 3f                	jmp    2b35 <linkunlink+0xf8>
    } else if((x % 3) == 1){
    2af6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    2af9:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2afe:	89 c8                	mov    %ecx,%eax
    2b00:	f7 e2                	mul    %edx
    2b02:	d1 ea                	shr    %edx
    2b04:	89 d0                	mov    %edx,%eax
    2b06:	01 c0                	add    %eax,%eax
    2b08:	01 d0                	add    %edx,%eax
    2b0a:	29 c1                	sub    %eax,%ecx
    2b0c:	89 ca                	mov    %ecx,%edx
    2b0e:	83 fa 01             	cmp    $0x1,%edx
    2b11:	75 16                	jne    2b29 <linkunlink+0xec>
      link("cat", "x");
    2b13:	c7 44 24 04 b2 58 00 	movl   $0x58b2,0x4(%esp)
    2b1a:	00 
    2b1b:	c7 04 24 5c 5d 00 00 	movl   $0x5d5c,(%esp)
    2b22:	e8 51 21 00 00       	call   4c78 <link>
    2b27:	eb 0c                	jmp    2b35 <linkunlink+0xf8>
    } else {
      unlink("x");
    2b29:	c7 04 24 b2 58 00 00 	movl   $0x58b2,(%esp)
    2b30:	e8 33 21 00 00       	call   4c68 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    2b35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2b39:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    2b3d:	0f 8e 68 ff ff ff    	jle    2aab <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    2b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2b47:	74 07                	je     2b50 <linkunlink+0x113>
    wait();
    2b49:	e8 d2 20 00 00       	call   4c20 <wait>
    2b4e:	eb 05                	jmp    2b55 <linkunlink+0x118>
  else 
    exit();
    2b50:	e8 c3 20 00 00       	call   4c18 <exit>

  printf(1, "linkunlink ok\n");
    2b55:	c7 44 24 04 60 5d 00 	movl   $0x5d60,0x4(%esp)
    2b5c:	00 
    2b5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b64:	e8 5f 22 00 00       	call   4dc8 <printf>
}
    2b69:	c9                   	leave  
    2b6a:	c3                   	ret    

00002b6b <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    2b6b:	55                   	push   %ebp
    2b6c:	89 e5                	mov    %esp,%ebp
    2b6e:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    2b71:	c7 44 24 04 6f 5d 00 	movl   $0x5d6f,0x4(%esp)
    2b78:	00 
    2b79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b80:	e8 43 22 00 00       	call   4dc8 <printf>
  unlink("bd");
    2b85:	c7 04 24 7c 5d 00 00 	movl   $0x5d7c,(%esp)
    2b8c:	e8 d7 20 00 00       	call   4c68 <unlink>

  fd = open("bd", O_CREATE);
    2b91:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2b98:	00 
    2b99:	c7 04 24 7c 5d 00 00 	movl   $0x5d7c,(%esp)
    2ba0:	e8 b3 20 00 00       	call   4c58 <open>
    2ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    2ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2bac:	79 19                	jns    2bc7 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    2bae:	c7 44 24 04 7f 5d 00 	movl   $0x5d7f,0x4(%esp)
    2bb5:	00 
    2bb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bbd:	e8 06 22 00 00       	call   4dc8 <printf>
    exit();
    2bc2:	e8 51 20 00 00       	call   4c18 <exit>
  }
  close(fd);
    2bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2bca:	89 04 24             	mov    %eax,(%esp)
    2bcd:	e8 6e 20 00 00       	call   4c40 <close>

  for(i = 0; i < 500; i++){
    2bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2bd9:	eb 64                	jmp    2c3f <bigdir+0xd4>
    name[0] = 'x';
    2bdb:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    2bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2be2:	8d 50 3f             	lea    0x3f(%eax),%edx
    2be5:	85 c0                	test   %eax,%eax
    2be7:	0f 48 c2             	cmovs  %edx,%eax
    2bea:	c1 f8 06             	sar    $0x6,%eax
    2bed:	83 c0 30             	add    $0x30,%eax
    2bf0:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    2bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bf6:	99                   	cltd   
    2bf7:	c1 ea 1a             	shr    $0x1a,%edx
    2bfa:	01 d0                	add    %edx,%eax
    2bfc:	83 e0 3f             	and    $0x3f,%eax
    2bff:	29 d0                	sub    %edx,%eax
    2c01:	83 c0 30             	add    $0x30,%eax
    2c04:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    2c07:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    2c0b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2c12:	c7 04 24 7c 5d 00 00 	movl   $0x5d7c,(%esp)
    2c19:	e8 5a 20 00 00       	call   4c78 <link>
    2c1e:	85 c0                	test   %eax,%eax
    2c20:	74 19                	je     2c3b <bigdir+0xd0>
      printf(1, "bigdir link failed\n");
    2c22:	c7 44 24 04 95 5d 00 	movl   $0x5d95,0x4(%esp)
    2c29:	00 
    2c2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c31:	e8 92 21 00 00       	call   4dc8 <printf>
      exit();
    2c36:	e8 dd 1f 00 00       	call   4c18 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    2c3b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2c3f:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    2c46:	7e 93                	jle    2bdb <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    2c48:	c7 04 24 7c 5d 00 00 	movl   $0x5d7c,(%esp)
    2c4f:	e8 14 20 00 00       	call   4c68 <unlink>
  for(i = 0; i < 500; i++){
    2c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2c5b:	eb 5c                	jmp    2cb9 <bigdir+0x14e>
    name[0] = 'x';
    2c5d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    2c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c64:	8d 50 3f             	lea    0x3f(%eax),%edx
    2c67:	85 c0                	test   %eax,%eax
    2c69:	0f 48 c2             	cmovs  %edx,%eax
    2c6c:	c1 f8 06             	sar    $0x6,%eax
    2c6f:	83 c0 30             	add    $0x30,%eax
    2c72:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    2c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c78:	99                   	cltd   
    2c79:	c1 ea 1a             	shr    $0x1a,%edx
    2c7c:	01 d0                	add    %edx,%eax
    2c7e:	83 e0 3f             	and    $0x3f,%eax
    2c81:	29 d0                	sub    %edx,%eax
    2c83:	83 c0 30             	add    $0x30,%eax
    2c86:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    2c89:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    2c8d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2c90:	89 04 24             	mov    %eax,(%esp)
    2c93:	e8 d0 1f 00 00       	call   4c68 <unlink>
    2c98:	85 c0                	test   %eax,%eax
    2c9a:	74 19                	je     2cb5 <bigdir+0x14a>
      printf(1, "bigdir unlink failed");
    2c9c:	c7 44 24 04 a9 5d 00 	movl   $0x5da9,0x4(%esp)
    2ca3:	00 
    2ca4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cab:	e8 18 21 00 00       	call   4dc8 <printf>
      exit();
    2cb0:	e8 63 1f 00 00       	call   4c18 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    2cb5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2cb9:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    2cc0:	7e 9b                	jle    2c5d <bigdir+0xf2>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    2cc2:	c7 44 24 04 be 5d 00 	movl   $0x5dbe,0x4(%esp)
    2cc9:	00 
    2cca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cd1:	e8 f2 20 00 00       	call   4dc8 <printf>
}
    2cd6:	c9                   	leave  
    2cd7:	c3                   	ret    

00002cd8 <subdir>:

void
subdir(void)
{
    2cd8:	55                   	push   %ebp
    2cd9:	89 e5                	mov    %esp,%ebp
    2cdb:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    2cde:	c7 44 24 04 c9 5d 00 	movl   $0x5dc9,0x4(%esp)
    2ce5:	00 
    2ce6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ced:	e8 d6 20 00 00       	call   4dc8 <printf>

  unlink("ff");
    2cf2:	c7 04 24 d6 5d 00 00 	movl   $0x5dd6,(%esp)
    2cf9:	e8 6a 1f 00 00       	call   4c68 <unlink>
  if(mkdir("dd") != 0){
    2cfe:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    2d05:	e8 76 1f 00 00       	call   4c80 <mkdir>
    2d0a:	85 c0                	test   %eax,%eax
    2d0c:	74 19                	je     2d27 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    2d0e:	c7 44 24 04 dc 5d 00 	movl   $0x5ddc,0x4(%esp)
    2d15:	00 
    2d16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d1d:	e8 a6 20 00 00       	call   4dc8 <printf>
    exit();
    2d22:	e8 f1 1e 00 00       	call   4c18 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d27:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2d2e:	00 
    2d2f:	c7 04 24 f4 5d 00 00 	movl   $0x5df4,(%esp)
    2d36:	e8 1d 1f 00 00       	call   4c58 <open>
    2d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2d3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d42:	79 19                	jns    2d5d <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    2d44:	c7 44 24 04 fa 5d 00 	movl   $0x5dfa,0x4(%esp)
    2d4b:	00 
    2d4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d53:	e8 70 20 00 00       	call   4dc8 <printf>
    exit();
    2d58:	e8 bb 1e 00 00       	call   4c18 <exit>
  }
  write(fd, "ff", 2);
    2d5d:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2d64:	00 
    2d65:	c7 44 24 04 d6 5d 00 	movl   $0x5dd6,0x4(%esp)
    2d6c:	00 
    2d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d70:	89 04 24             	mov    %eax,(%esp)
    2d73:	e8 c0 1e 00 00       	call   4c38 <write>
  close(fd);
    2d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d7b:	89 04 24             	mov    %eax,(%esp)
    2d7e:	e8 bd 1e 00 00       	call   4c40 <close>
  
  if(unlink("dd") >= 0){
    2d83:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    2d8a:	e8 d9 1e 00 00       	call   4c68 <unlink>
    2d8f:	85 c0                	test   %eax,%eax
    2d91:	78 19                	js     2dac <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2d93:	c7 44 24 04 10 5e 00 	movl   $0x5e10,0x4(%esp)
    2d9a:	00 
    2d9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da2:	e8 21 20 00 00       	call   4dc8 <printf>
    exit();
    2da7:	e8 6c 1e 00 00       	call   4c18 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2dac:	c7 04 24 36 5e 00 00 	movl   $0x5e36,(%esp)
    2db3:	e8 c8 1e 00 00       	call   4c80 <mkdir>
    2db8:	85 c0                	test   %eax,%eax
    2dba:	74 19                	je     2dd5 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2dbc:	c7 44 24 04 3d 5e 00 	movl   $0x5e3d,0x4(%esp)
    2dc3:	00 
    2dc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dcb:	e8 f8 1f 00 00       	call   4dc8 <printf>
    exit();
    2dd0:	e8 43 1e 00 00       	call   4c18 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2dd5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2ddc:	00 
    2ddd:	c7 04 24 58 5e 00 00 	movl   $0x5e58,(%esp)
    2de4:	e8 6f 1e 00 00       	call   4c58 <open>
    2de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2df0:	79 19                	jns    2e0b <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    2df2:	c7 44 24 04 61 5e 00 	movl   $0x5e61,0x4(%esp)
    2df9:	00 
    2dfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e01:	e8 c2 1f 00 00       	call   4dc8 <printf>
    exit();
    2e06:	e8 0d 1e 00 00       	call   4c18 <exit>
  }
  write(fd, "FF", 2);
    2e0b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2e12:	00 
    2e13:	c7 44 24 04 79 5e 00 	movl   $0x5e79,0x4(%esp)
    2e1a:	00 
    2e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e1e:	89 04 24             	mov    %eax,(%esp)
    2e21:	e8 12 1e 00 00       	call   4c38 <write>
  close(fd);
    2e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e29:	89 04 24             	mov    %eax,(%esp)
    2e2c:	e8 0f 1e 00 00       	call   4c40 <close>

  fd = open("dd/dd/../ff", 0);
    2e31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e38:	00 
    2e39:	c7 04 24 7c 5e 00 00 	movl   $0x5e7c,(%esp)
    2e40:	e8 13 1e 00 00       	call   4c58 <open>
    2e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e4c:	79 19                	jns    2e67 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    2e4e:	c7 44 24 04 88 5e 00 	movl   $0x5e88,0x4(%esp)
    2e55:	00 
    2e56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e5d:	e8 66 1f 00 00       	call   4dc8 <printf>
    exit();
    2e62:	e8 b1 1d 00 00       	call   4c18 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2e67:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2e6e:	00 
    2e6f:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    2e76:	00 
    2e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e7a:	89 04 24             	mov    %eax,(%esp)
    2e7d:	e8 ae 1d 00 00       	call   4c30 <read>
    2e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2e85:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2e89:	75 0b                	jne    2e96 <subdir+0x1be>
    2e8b:	0f b6 05 20 9c 00 00 	movzbl 0x9c20,%eax
    2e92:	3c 66                	cmp    $0x66,%al
    2e94:	74 19                	je     2eaf <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    2e96:	c7 44 24 04 a1 5e 00 	movl   $0x5ea1,0x4(%esp)
    2e9d:	00 
    2e9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ea5:	e8 1e 1f 00 00       	call   4dc8 <printf>
    exit();
    2eaa:	e8 69 1d 00 00       	call   4c18 <exit>
  }
  close(fd);
    2eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2eb2:	89 04 24             	mov    %eax,(%esp)
    2eb5:	e8 86 1d 00 00       	call   4c40 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2eba:	c7 44 24 04 bc 5e 00 	movl   $0x5ebc,0x4(%esp)
    2ec1:	00 
    2ec2:	c7 04 24 58 5e 00 00 	movl   $0x5e58,(%esp)
    2ec9:	e8 aa 1d 00 00       	call   4c78 <link>
    2ece:	85 c0                	test   %eax,%eax
    2ed0:	74 19                	je     2eeb <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2ed2:	c7 44 24 04 c8 5e 00 	movl   $0x5ec8,0x4(%esp)
    2ed9:	00 
    2eda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ee1:	e8 e2 1e 00 00       	call   4dc8 <printf>
    exit();
    2ee6:	e8 2d 1d 00 00       	call   4c18 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2eeb:	c7 04 24 58 5e 00 00 	movl   $0x5e58,(%esp)
    2ef2:	e8 71 1d 00 00       	call   4c68 <unlink>
    2ef7:	85 c0                	test   %eax,%eax
    2ef9:	74 19                	je     2f14 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    2efb:	c7 44 24 04 e9 5e 00 	movl   $0x5ee9,0x4(%esp)
    2f02:	00 
    2f03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f0a:	e8 b9 1e 00 00       	call   4dc8 <printf>
    exit();
    2f0f:	e8 04 1d 00 00       	call   4c18 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2f14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f1b:	00 
    2f1c:	c7 04 24 58 5e 00 00 	movl   $0x5e58,(%esp)
    2f23:	e8 30 1d 00 00       	call   4c58 <open>
    2f28:	85 c0                	test   %eax,%eax
    2f2a:	78 19                	js     2f45 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2f2c:	c7 44 24 04 04 5f 00 	movl   $0x5f04,0x4(%esp)
    2f33:	00 
    2f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f3b:	e8 88 1e 00 00       	call   4dc8 <printf>
    exit();
    2f40:	e8 d3 1c 00 00       	call   4c18 <exit>
  }

  if(chdir("dd") != 0){
    2f45:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    2f4c:	e8 37 1d 00 00       	call   4c88 <chdir>
    2f51:	85 c0                	test   %eax,%eax
    2f53:	74 19                	je     2f6e <subdir+0x296>
    printf(1, "chdir dd failed\n");
    2f55:	c7 44 24 04 28 5f 00 	movl   $0x5f28,0x4(%esp)
    2f5c:	00 
    2f5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f64:	e8 5f 1e 00 00       	call   4dc8 <printf>
    exit();
    2f69:	e8 aa 1c 00 00       	call   4c18 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2f6e:	c7 04 24 39 5f 00 00 	movl   $0x5f39,(%esp)
    2f75:	e8 0e 1d 00 00       	call   4c88 <chdir>
    2f7a:	85 c0                	test   %eax,%eax
    2f7c:	74 19                	je     2f97 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    2f7e:	c7 44 24 04 45 5f 00 	movl   $0x5f45,0x4(%esp)
    2f85:	00 
    2f86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f8d:	e8 36 1e 00 00       	call   4dc8 <printf>
    exit();
    2f92:	e8 81 1c 00 00       	call   4c18 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2f97:	c7 04 24 5f 5f 00 00 	movl   $0x5f5f,(%esp)
    2f9e:	e8 e5 1c 00 00       	call   4c88 <chdir>
    2fa3:	85 c0                	test   %eax,%eax
    2fa5:	74 19                	je     2fc0 <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    2fa7:	c7 44 24 04 45 5f 00 	movl   $0x5f45,0x4(%esp)
    2fae:	00 
    2faf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fb6:	e8 0d 1e 00 00       	call   4dc8 <printf>
    exit();
    2fbb:	e8 58 1c 00 00       	call   4c18 <exit>
  }
  if(chdir("./..") != 0){
    2fc0:	c7 04 24 6e 5f 00 00 	movl   $0x5f6e,(%esp)
    2fc7:	e8 bc 1c 00 00       	call   4c88 <chdir>
    2fcc:	85 c0                	test   %eax,%eax
    2fce:	74 19                	je     2fe9 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    2fd0:	c7 44 24 04 73 5f 00 	movl   $0x5f73,0x4(%esp)
    2fd7:	00 
    2fd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fdf:	e8 e4 1d 00 00       	call   4dc8 <printf>
    exit();
    2fe4:	e8 2f 1c 00 00       	call   4c18 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2fe9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ff0:	00 
    2ff1:	c7 04 24 bc 5e 00 00 	movl   $0x5ebc,(%esp)
    2ff8:	e8 5b 1c 00 00       	call   4c58 <open>
    2ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3000:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3004:	79 19                	jns    301f <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    3006:	c7 44 24 04 86 5f 00 	movl   $0x5f86,0x4(%esp)
    300d:	00 
    300e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3015:	e8 ae 1d 00 00       	call   4dc8 <printf>
    exit();
    301a:	e8 f9 1b 00 00       	call   4c18 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    301f:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    3026:	00 
    3027:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    302e:	00 
    302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3032:	89 04 24             	mov    %eax,(%esp)
    3035:	e8 f6 1b 00 00       	call   4c30 <read>
    303a:	83 f8 02             	cmp    $0x2,%eax
    303d:	74 19                	je     3058 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    303f:	c7 44 24 04 9e 5f 00 	movl   $0x5f9e,0x4(%esp)
    3046:	00 
    3047:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    304e:	e8 75 1d 00 00       	call   4dc8 <printf>
    exit();
    3053:	e8 c0 1b 00 00       	call   4c18 <exit>
  }
  close(fd);
    3058:	8b 45 f4             	mov    -0xc(%ebp),%eax
    305b:	89 04 24             	mov    %eax,(%esp)
    305e:	e8 dd 1b 00 00       	call   4c40 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3063:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    306a:	00 
    306b:	c7 04 24 58 5e 00 00 	movl   $0x5e58,(%esp)
    3072:	e8 e1 1b 00 00       	call   4c58 <open>
    3077:	85 c0                	test   %eax,%eax
    3079:	78 19                	js     3094 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    307b:	c7 44 24 04 bc 5f 00 	movl   $0x5fbc,0x4(%esp)
    3082:	00 
    3083:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    308a:	e8 39 1d 00 00       	call   4dc8 <printf>
    exit();
    308f:	e8 84 1b 00 00       	call   4c18 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3094:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    309b:	00 
    309c:	c7 04 24 e1 5f 00 00 	movl   $0x5fe1,(%esp)
    30a3:	e8 b0 1b 00 00       	call   4c58 <open>
    30a8:	85 c0                	test   %eax,%eax
    30aa:	78 19                	js     30c5 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    30ac:	c7 44 24 04 ea 5f 00 	movl   $0x5fea,0x4(%esp)
    30b3:	00 
    30b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30bb:	e8 08 1d 00 00       	call   4dc8 <printf>
    exit();
    30c0:	e8 53 1b 00 00       	call   4c18 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    30c5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    30cc:	00 
    30cd:	c7 04 24 06 60 00 00 	movl   $0x6006,(%esp)
    30d4:	e8 7f 1b 00 00       	call   4c58 <open>
    30d9:	85 c0                	test   %eax,%eax
    30db:	78 19                	js     30f6 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    30dd:	c7 44 24 04 0f 60 00 	movl   $0x600f,0x4(%esp)
    30e4:	00 
    30e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30ec:	e8 d7 1c 00 00       	call   4dc8 <printf>
    exit();
    30f1:	e8 22 1b 00 00       	call   4c18 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    30f6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    30fd:	00 
    30fe:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    3105:	e8 4e 1b 00 00       	call   4c58 <open>
    310a:	85 c0                	test   %eax,%eax
    310c:	78 19                	js     3127 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    310e:	c7 44 24 04 2b 60 00 	movl   $0x602b,0x4(%esp)
    3115:	00 
    3116:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    311d:	e8 a6 1c 00 00       	call   4dc8 <printf>
    exit();
    3122:	e8 f1 1a 00 00       	call   4c18 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    3127:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    312e:	00 
    312f:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    3136:	e8 1d 1b 00 00       	call   4c58 <open>
    313b:	85 c0                	test   %eax,%eax
    313d:	78 19                	js     3158 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    313f:	c7 44 24 04 41 60 00 	movl   $0x6041,0x4(%esp)
    3146:	00 
    3147:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    314e:	e8 75 1c 00 00       	call   4dc8 <printf>
    exit();
    3153:	e8 c0 1a 00 00       	call   4c18 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    3158:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    315f:	00 
    3160:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    3167:	e8 ec 1a 00 00       	call   4c58 <open>
    316c:	85 c0                	test   %eax,%eax
    316e:	78 19                	js     3189 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    3170:	c7 44 24 04 5a 60 00 	movl   $0x605a,0x4(%esp)
    3177:	00 
    3178:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    317f:	e8 44 1c 00 00       	call   4dc8 <printf>
    exit();
    3184:	e8 8f 1a 00 00       	call   4c18 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3189:	c7 44 24 04 75 60 00 	movl   $0x6075,0x4(%esp)
    3190:	00 
    3191:	c7 04 24 e1 5f 00 00 	movl   $0x5fe1,(%esp)
    3198:	e8 db 1a 00 00       	call   4c78 <link>
    319d:	85 c0                	test   %eax,%eax
    319f:	75 19                	jne    31ba <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    31a1:	c7 44 24 04 80 60 00 	movl   $0x6080,0x4(%esp)
    31a8:	00 
    31a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31b0:	e8 13 1c 00 00       	call   4dc8 <printf>
    exit();
    31b5:	e8 5e 1a 00 00       	call   4c18 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    31ba:	c7 44 24 04 75 60 00 	movl   $0x6075,0x4(%esp)
    31c1:	00 
    31c2:	c7 04 24 06 60 00 00 	movl   $0x6006,(%esp)
    31c9:	e8 aa 1a 00 00       	call   4c78 <link>
    31ce:	85 c0                	test   %eax,%eax
    31d0:	75 19                	jne    31eb <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    31d2:	c7 44 24 04 a4 60 00 	movl   $0x60a4,0x4(%esp)
    31d9:	00 
    31da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31e1:	e8 e2 1b 00 00       	call   4dc8 <printf>
    exit();
    31e6:	e8 2d 1a 00 00       	call   4c18 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    31eb:	c7 44 24 04 bc 5e 00 	movl   $0x5ebc,0x4(%esp)
    31f2:	00 
    31f3:	c7 04 24 f4 5d 00 00 	movl   $0x5df4,(%esp)
    31fa:	e8 79 1a 00 00       	call   4c78 <link>
    31ff:	85 c0                	test   %eax,%eax
    3201:	75 19                	jne    321c <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    3203:	c7 44 24 04 c8 60 00 	movl   $0x60c8,0x4(%esp)
    320a:	00 
    320b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3212:	e8 b1 1b 00 00       	call   4dc8 <printf>
    exit();
    3217:	e8 fc 19 00 00       	call   4c18 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    321c:	c7 04 24 e1 5f 00 00 	movl   $0x5fe1,(%esp)
    3223:	e8 58 1a 00 00       	call   4c80 <mkdir>
    3228:	85 c0                	test   %eax,%eax
    322a:	75 19                	jne    3245 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    322c:	c7 44 24 04 ea 60 00 	movl   $0x60ea,0x4(%esp)
    3233:	00 
    3234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    323b:	e8 88 1b 00 00       	call   4dc8 <printf>
    exit();
    3240:	e8 d3 19 00 00       	call   4c18 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    3245:	c7 04 24 06 60 00 00 	movl   $0x6006,(%esp)
    324c:	e8 2f 1a 00 00       	call   4c80 <mkdir>
    3251:	85 c0                	test   %eax,%eax
    3253:	75 19                	jne    326e <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    3255:	c7 44 24 04 05 61 00 	movl   $0x6105,0x4(%esp)
    325c:	00 
    325d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3264:	e8 5f 1b 00 00       	call   4dc8 <printf>
    exit();
    3269:	e8 aa 19 00 00       	call   4c18 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    326e:	c7 04 24 bc 5e 00 00 	movl   $0x5ebc,(%esp)
    3275:	e8 06 1a 00 00       	call   4c80 <mkdir>
    327a:	85 c0                	test   %eax,%eax
    327c:	75 19                	jne    3297 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    327e:	c7 44 24 04 20 61 00 	movl   $0x6120,0x4(%esp)
    3285:	00 
    3286:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    328d:	e8 36 1b 00 00       	call   4dc8 <printf>
    exit();
    3292:	e8 81 19 00 00       	call   4c18 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    3297:	c7 04 24 06 60 00 00 	movl   $0x6006,(%esp)
    329e:	e8 c5 19 00 00       	call   4c68 <unlink>
    32a3:	85 c0                	test   %eax,%eax
    32a5:	75 19                	jne    32c0 <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    32a7:	c7 44 24 04 3d 61 00 	movl   $0x613d,0x4(%esp)
    32ae:	00 
    32af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32b6:	e8 0d 1b 00 00       	call   4dc8 <printf>
    exit();
    32bb:	e8 58 19 00 00       	call   4c18 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    32c0:	c7 04 24 e1 5f 00 00 	movl   $0x5fe1,(%esp)
    32c7:	e8 9c 19 00 00       	call   4c68 <unlink>
    32cc:	85 c0                	test   %eax,%eax
    32ce:	75 19                	jne    32e9 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    32d0:	c7 44 24 04 59 61 00 	movl   $0x6159,0x4(%esp)
    32d7:	00 
    32d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32df:	e8 e4 1a 00 00       	call   4dc8 <printf>
    exit();
    32e4:	e8 2f 19 00 00       	call   4c18 <exit>
  }
  if(chdir("dd/ff") == 0){
    32e9:	c7 04 24 f4 5d 00 00 	movl   $0x5df4,(%esp)
    32f0:	e8 93 19 00 00       	call   4c88 <chdir>
    32f5:	85 c0                	test   %eax,%eax
    32f7:	75 19                	jne    3312 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    32f9:	c7 44 24 04 75 61 00 	movl   $0x6175,0x4(%esp)
    3300:	00 
    3301:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3308:	e8 bb 1a 00 00       	call   4dc8 <printf>
    exit();
    330d:	e8 06 19 00 00       	call   4c18 <exit>
  }
  if(chdir("dd/xx") == 0){
    3312:	c7 04 24 8d 61 00 00 	movl   $0x618d,(%esp)
    3319:	e8 6a 19 00 00       	call   4c88 <chdir>
    331e:	85 c0                	test   %eax,%eax
    3320:	75 19                	jne    333b <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    3322:	c7 44 24 04 93 61 00 	movl   $0x6193,0x4(%esp)
    3329:	00 
    332a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3331:	e8 92 1a 00 00       	call   4dc8 <printf>
    exit();
    3336:	e8 dd 18 00 00       	call   4c18 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    333b:	c7 04 24 bc 5e 00 00 	movl   $0x5ebc,(%esp)
    3342:	e8 21 19 00 00       	call   4c68 <unlink>
    3347:	85 c0                	test   %eax,%eax
    3349:	74 19                	je     3364 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    334b:	c7 44 24 04 e9 5e 00 	movl   $0x5ee9,0x4(%esp)
    3352:	00 
    3353:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    335a:	e8 69 1a 00 00       	call   4dc8 <printf>
    exit();
    335f:	e8 b4 18 00 00       	call   4c18 <exit>
  }
  if(unlink("dd/ff") != 0){
    3364:	c7 04 24 f4 5d 00 00 	movl   $0x5df4,(%esp)
    336b:	e8 f8 18 00 00       	call   4c68 <unlink>
    3370:	85 c0                	test   %eax,%eax
    3372:	74 19                	je     338d <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    3374:	c7 44 24 04 ab 61 00 	movl   $0x61ab,0x4(%esp)
    337b:	00 
    337c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3383:	e8 40 1a 00 00       	call   4dc8 <printf>
    exit();
    3388:	e8 8b 18 00 00       	call   4c18 <exit>
  }
  if(unlink("dd") == 0){
    338d:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    3394:	e8 cf 18 00 00       	call   4c68 <unlink>
    3399:	85 c0                	test   %eax,%eax
    339b:	75 19                	jne    33b6 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    339d:	c7 44 24 04 c0 61 00 	movl   $0x61c0,0x4(%esp)
    33a4:	00 
    33a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33ac:	e8 17 1a 00 00       	call   4dc8 <printf>
    exit();
    33b1:	e8 62 18 00 00       	call   4c18 <exit>
  }
  if(unlink("dd/dd") < 0){
    33b6:	c7 04 24 e0 61 00 00 	movl   $0x61e0,(%esp)
    33bd:	e8 a6 18 00 00       	call   4c68 <unlink>
    33c2:	85 c0                	test   %eax,%eax
    33c4:	79 19                	jns    33df <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    33c6:	c7 44 24 04 e6 61 00 	movl   $0x61e6,0x4(%esp)
    33cd:	00 
    33ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33d5:	e8 ee 19 00 00       	call   4dc8 <printf>
    exit();
    33da:	e8 39 18 00 00       	call   4c18 <exit>
  }
  if(unlink("dd") < 0){
    33df:	c7 04 24 d9 5d 00 00 	movl   $0x5dd9,(%esp)
    33e6:	e8 7d 18 00 00       	call   4c68 <unlink>
    33eb:	85 c0                	test   %eax,%eax
    33ed:	79 19                	jns    3408 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    33ef:	c7 44 24 04 fb 61 00 	movl   $0x61fb,0x4(%esp)
    33f6:	00 
    33f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33fe:	e8 c5 19 00 00       	call   4dc8 <printf>
    exit();
    3403:	e8 10 18 00 00       	call   4c18 <exit>
  }

  printf(1, "subdir ok\n");
    3408:	c7 44 24 04 0d 62 00 	movl   $0x620d,0x4(%esp)
    340f:	00 
    3410:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3417:	e8 ac 19 00 00       	call   4dc8 <printf>
}
    341c:	c9                   	leave  
    341d:	c3                   	ret    

0000341e <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    341e:	55                   	push   %ebp
    341f:	89 e5                	mov    %esp,%ebp
    3421:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    3424:	c7 44 24 04 18 62 00 	movl   $0x6218,0x4(%esp)
    342b:	00 
    342c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3433:	e8 90 19 00 00       	call   4dc8 <printf>

  unlink("bigwrite");
    3438:	c7 04 24 27 62 00 00 	movl   $0x6227,(%esp)
    343f:	e8 24 18 00 00       	call   4c68 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    3444:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    344b:	e9 b3 00 00 00       	jmp    3503 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    3450:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3457:	00 
    3458:	c7 04 24 27 62 00 00 	movl   $0x6227,(%esp)
    345f:	e8 f4 17 00 00       	call   4c58 <open>
    3464:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    3467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    346b:	79 19                	jns    3486 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    346d:	c7 44 24 04 30 62 00 	movl   $0x6230,0x4(%esp)
    3474:	00 
    3475:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    347c:	e8 47 19 00 00       	call   4dc8 <printf>
      exit();
    3481:	e8 92 17 00 00       	call   4c18 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    3486:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    348d:	eb 50                	jmp    34df <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3492:	89 44 24 08          	mov    %eax,0x8(%esp)
    3496:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    349d:	00 
    349e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    34a1:	89 04 24             	mov    %eax,(%esp)
    34a4:	e8 8f 17 00 00       	call   4c38 <write>
    34a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    34ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    34af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    34b2:	74 27                	je     34db <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    34b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    34b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
    34bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34be:	89 44 24 08          	mov    %eax,0x8(%esp)
    34c2:	c7 44 24 04 48 62 00 	movl   $0x6248,0x4(%esp)
    34c9:	00 
    34ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34d1:	e8 f2 18 00 00       	call   4dc8 <printf>
        exit();
    34d6:	e8 3d 17 00 00       	call   4c18 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    34db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    34df:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    34e3:	7e aa                	jle    348f <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    34e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    34e8:	89 04 24             	mov    %eax,(%esp)
    34eb:	e8 50 17 00 00       	call   4c40 <close>
    unlink("bigwrite");
    34f0:	c7 04 24 27 62 00 00 	movl   $0x6227,(%esp)
    34f7:	e8 6c 17 00 00       	call   4c68 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    34fc:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    3503:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    350a:	0f 8e 40 ff ff ff    	jle    3450 <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    3510:	c7 44 24 04 5a 62 00 	movl   $0x625a,0x4(%esp)
    3517:	00 
    3518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    351f:	e8 a4 18 00 00       	call   4dc8 <printf>
}
    3524:	c9                   	leave  
    3525:	c3                   	ret    

00003526 <bigfile>:

void
bigfile(void)
{
    3526:	55                   	push   %ebp
    3527:	89 e5                	mov    %esp,%ebp
    3529:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    352c:	c7 44 24 04 67 62 00 	movl   $0x6267,0x4(%esp)
    3533:	00 
    3534:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    353b:	e8 88 18 00 00       	call   4dc8 <printf>

  unlink("bigfile");
    3540:	c7 04 24 75 62 00 00 	movl   $0x6275,(%esp)
    3547:	e8 1c 17 00 00       	call   4c68 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    354c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3553:	00 
    3554:	c7 04 24 75 62 00 00 	movl   $0x6275,(%esp)
    355b:	e8 f8 16 00 00       	call   4c58 <open>
    3560:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3563:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3567:	79 19                	jns    3582 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    3569:	c7 44 24 04 7d 62 00 	movl   $0x627d,0x4(%esp)
    3570:	00 
    3571:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3578:	e8 4b 18 00 00       	call   4dc8 <printf>
    exit();
    357d:	e8 96 16 00 00       	call   4c18 <exit>
  }
  for(i = 0; i < 20; i++){
    3582:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3589:	eb 5a                	jmp    35e5 <bigfile+0xbf>
    memset(buf, i, 600);
    358b:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    3592:	00 
    3593:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3596:	89 44 24 04          	mov    %eax,0x4(%esp)
    359a:	c7 04 24 20 9c 00 00 	movl   $0x9c20,(%esp)
    35a1:	e8 c5 14 00 00       	call   4a6b <memset>
    if(write(fd, buf, 600) != 600){
    35a6:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    35ad:	00 
    35ae:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    35b5:	00 
    35b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35b9:	89 04 24             	mov    %eax,(%esp)
    35bc:	e8 77 16 00 00       	call   4c38 <write>
    35c1:	3d 58 02 00 00       	cmp    $0x258,%eax
    35c6:	74 19                	je     35e1 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    35c8:	c7 44 24 04 93 62 00 	movl   $0x6293,0x4(%esp)
    35cf:	00 
    35d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35d7:	e8 ec 17 00 00       	call   4dc8 <printf>
      exit();
    35dc:	e8 37 16 00 00       	call   4c18 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    35e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    35e5:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    35e9:	7e a0                	jle    358b <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    35eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35ee:	89 04 24             	mov    %eax,(%esp)
    35f1:	e8 4a 16 00 00       	call   4c40 <close>

  fd = open("bigfile", 0);
    35f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    35fd:	00 
    35fe:	c7 04 24 75 62 00 00 	movl   $0x6275,(%esp)
    3605:	e8 4e 16 00 00       	call   4c58 <open>
    360a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    360d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3611:	79 19                	jns    362c <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    3613:	c7 44 24 04 a9 62 00 	movl   $0x62a9,0x4(%esp)
    361a:	00 
    361b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3622:	e8 a1 17 00 00       	call   4dc8 <printf>
    exit();
    3627:	e8 ec 15 00 00       	call   4c18 <exit>
  }
  total = 0;
    362c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    3633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    363a:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    3641:	00 
    3642:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    3649:	00 
    364a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    364d:	89 04 24             	mov    %eax,(%esp)
    3650:	e8 db 15 00 00       	call   4c30 <read>
    3655:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    3658:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    365c:	79 19                	jns    3677 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    365e:	c7 44 24 04 be 62 00 	movl   $0x62be,0x4(%esp)
    3665:	00 
    3666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    366d:	e8 56 17 00 00       	call   4dc8 <printf>
      exit();
    3672:	e8 a1 15 00 00       	call   4c18 <exit>
    }
    if(cc == 0)
    3677:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    367b:	75 1b                	jne    3698 <bigfile+0x172>
      break;
    367d:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    367e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3681:	89 04 24             	mov    %eax,(%esp)
    3684:	e8 b7 15 00 00       	call   4c40 <close>
  if(total != 20*600){
    3689:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    3690:	0f 84 99 00 00 00    	je     372f <bigfile+0x209>
    3696:	eb 7e                	jmp    3716 <bigfile+0x1f0>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    3698:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    369f:	74 19                	je     36ba <bigfile+0x194>
      printf(1, "short read bigfile\n");
    36a1:	c7 44 24 04 d3 62 00 	movl   $0x62d3,0x4(%esp)
    36a8:	00 
    36a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36b0:	e8 13 17 00 00       	call   4dc8 <printf>
      exit();
    36b5:	e8 5e 15 00 00       	call   4c18 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    36ba:	0f b6 05 20 9c 00 00 	movzbl 0x9c20,%eax
    36c1:	0f be d0             	movsbl %al,%edx
    36c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36c7:	89 c1                	mov    %eax,%ecx
    36c9:	c1 e9 1f             	shr    $0x1f,%ecx
    36cc:	01 c8                	add    %ecx,%eax
    36ce:	d1 f8                	sar    %eax
    36d0:	39 c2                	cmp    %eax,%edx
    36d2:	75 1a                	jne    36ee <bigfile+0x1c8>
    36d4:	0f b6 05 4b 9d 00 00 	movzbl 0x9d4b,%eax
    36db:	0f be d0             	movsbl %al,%edx
    36de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36e1:	89 c1                	mov    %eax,%ecx
    36e3:	c1 e9 1f             	shr    $0x1f,%ecx
    36e6:	01 c8                	add    %ecx,%eax
    36e8:	d1 f8                	sar    %eax
    36ea:	39 c2                	cmp    %eax,%edx
    36ec:	74 19                	je     3707 <bigfile+0x1e1>
      printf(1, "read bigfile wrong data\n");
    36ee:	c7 44 24 04 e7 62 00 	movl   $0x62e7,0x4(%esp)
    36f5:	00 
    36f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36fd:	e8 c6 16 00 00       	call   4dc8 <printf>
      exit();
    3702:	e8 11 15 00 00       	call   4c18 <exit>
    }
    total += cc;
    3707:	8b 45 e8             	mov    -0x18(%ebp),%eax
    370a:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    370d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    3711:	e9 24 ff ff ff       	jmp    363a <bigfile+0x114>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    3716:	c7 44 24 04 00 63 00 	movl   $0x6300,0x4(%esp)
    371d:	00 
    371e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3725:	e8 9e 16 00 00       	call   4dc8 <printf>
    exit();
    372a:	e8 e9 14 00 00       	call   4c18 <exit>
  }
  unlink("bigfile");
    372f:	c7 04 24 75 62 00 00 	movl   $0x6275,(%esp)
    3736:	e8 2d 15 00 00       	call   4c68 <unlink>

  printf(1, "bigfile test ok\n");
    373b:	c7 44 24 04 1a 63 00 	movl   $0x631a,0x4(%esp)
    3742:	00 
    3743:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    374a:	e8 79 16 00 00       	call   4dc8 <printf>
}
    374f:	c9                   	leave  
    3750:	c3                   	ret    

00003751 <fourteen>:

void
fourteen(void)
{
    3751:	55                   	push   %ebp
    3752:	89 e5                	mov    %esp,%ebp
    3754:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    3757:	c7 44 24 04 2b 63 00 	movl   $0x632b,0x4(%esp)
    375e:	00 
    375f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3766:	e8 5d 16 00 00       	call   4dc8 <printf>

  if(mkdir("12345678901234") != 0){
    376b:	c7 04 24 3a 63 00 00 	movl   $0x633a,(%esp)
    3772:	e8 09 15 00 00       	call   4c80 <mkdir>
    3777:	85 c0                	test   %eax,%eax
    3779:	74 19                	je     3794 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    377b:	c7 44 24 04 49 63 00 	movl   $0x6349,0x4(%esp)
    3782:	00 
    3783:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    378a:	e8 39 16 00 00       	call   4dc8 <printf>
    exit();
    378f:	e8 84 14 00 00       	call   4c18 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    3794:	c7 04 24 68 63 00 00 	movl   $0x6368,(%esp)
    379b:	e8 e0 14 00 00       	call   4c80 <mkdir>
    37a0:	85 c0                	test   %eax,%eax
    37a2:	74 19                	je     37bd <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    37a4:	c7 44 24 04 88 63 00 	movl   $0x6388,0x4(%esp)
    37ab:	00 
    37ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37b3:	e8 10 16 00 00       	call   4dc8 <printf>
    exit();
    37b8:	e8 5b 14 00 00       	call   4c18 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    37bd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    37c4:	00 
    37c5:	c7 04 24 b8 63 00 00 	movl   $0x63b8,(%esp)
    37cc:	e8 87 14 00 00       	call   4c58 <open>
    37d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    37d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    37d8:	79 19                	jns    37f3 <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    37da:	c7 44 24 04 e8 63 00 	movl   $0x63e8,0x4(%esp)
    37e1:	00 
    37e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37e9:	e8 da 15 00 00       	call   4dc8 <printf>
    exit();
    37ee:	e8 25 14 00 00       	call   4c18 <exit>
  }
  close(fd);
    37f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37f6:	89 04 24             	mov    %eax,(%esp)
    37f9:	e8 42 14 00 00       	call   4c40 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    37fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3805:	00 
    3806:	c7 04 24 28 64 00 00 	movl   $0x6428,(%esp)
    380d:	e8 46 14 00 00       	call   4c58 <open>
    3812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3819:	79 19                	jns    3834 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    381b:	c7 44 24 04 58 64 00 	movl   $0x6458,0x4(%esp)
    3822:	00 
    3823:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    382a:	e8 99 15 00 00       	call   4dc8 <printf>
    exit();
    382f:	e8 e4 13 00 00       	call   4c18 <exit>
  }
  close(fd);
    3834:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3837:	89 04 24             	mov    %eax,(%esp)
    383a:	e8 01 14 00 00       	call   4c40 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    383f:	c7 04 24 92 64 00 00 	movl   $0x6492,(%esp)
    3846:	e8 35 14 00 00       	call   4c80 <mkdir>
    384b:	85 c0                	test   %eax,%eax
    384d:	75 19                	jne    3868 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    384f:	c7 44 24 04 b0 64 00 	movl   $0x64b0,0x4(%esp)
    3856:	00 
    3857:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    385e:	e8 65 15 00 00       	call   4dc8 <printf>
    exit();
    3863:	e8 b0 13 00 00       	call   4c18 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    3868:	c7 04 24 e0 64 00 00 	movl   $0x64e0,(%esp)
    386f:	e8 0c 14 00 00       	call   4c80 <mkdir>
    3874:	85 c0                	test   %eax,%eax
    3876:	75 19                	jne    3891 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    3878:	c7 44 24 04 00 65 00 	movl   $0x6500,0x4(%esp)
    387f:	00 
    3880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3887:	e8 3c 15 00 00       	call   4dc8 <printf>
    exit();
    388c:	e8 87 13 00 00       	call   4c18 <exit>
  }

  printf(1, "fourteen ok\n");
    3891:	c7 44 24 04 31 65 00 	movl   $0x6531,0x4(%esp)
    3898:	00 
    3899:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38a0:	e8 23 15 00 00       	call   4dc8 <printf>
}
    38a5:	c9                   	leave  
    38a6:	c3                   	ret    

000038a7 <rmdot>:

void
rmdot(void)
{
    38a7:	55                   	push   %ebp
    38a8:	89 e5                	mov    %esp,%ebp
    38aa:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    38ad:	c7 44 24 04 3e 65 00 	movl   $0x653e,0x4(%esp)
    38b4:	00 
    38b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38bc:	e8 07 15 00 00       	call   4dc8 <printf>
  if(mkdir("dots") != 0){
    38c1:	c7 04 24 4a 65 00 00 	movl   $0x654a,(%esp)
    38c8:	e8 b3 13 00 00       	call   4c80 <mkdir>
    38cd:	85 c0                	test   %eax,%eax
    38cf:	74 19                	je     38ea <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    38d1:	c7 44 24 04 4f 65 00 	movl   $0x654f,0x4(%esp)
    38d8:	00 
    38d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38e0:	e8 e3 14 00 00       	call   4dc8 <printf>
    exit();
    38e5:	e8 2e 13 00 00       	call   4c18 <exit>
  }
  if(chdir("dots") != 0){
    38ea:	c7 04 24 4a 65 00 00 	movl   $0x654a,(%esp)
    38f1:	e8 92 13 00 00       	call   4c88 <chdir>
    38f6:	85 c0                	test   %eax,%eax
    38f8:	74 19                	je     3913 <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    38fa:	c7 44 24 04 62 65 00 	movl   $0x6562,0x4(%esp)
    3901:	00 
    3902:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3909:	e8 ba 14 00 00       	call   4dc8 <printf>
    exit();
    390e:	e8 05 13 00 00       	call   4c18 <exit>
  }
  if(unlink(".") == 0){
    3913:	c7 04 24 7b 5c 00 00 	movl   $0x5c7b,(%esp)
    391a:	e8 49 13 00 00       	call   4c68 <unlink>
    391f:	85 c0                	test   %eax,%eax
    3921:	75 19                	jne    393c <rmdot+0x95>
    printf(1, "rm . worked!\n");
    3923:	c7 44 24 04 75 65 00 	movl   $0x6575,0x4(%esp)
    392a:	00 
    392b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3932:	e8 91 14 00 00       	call   4dc8 <printf>
    exit();
    3937:	e8 dc 12 00 00       	call   4c18 <exit>
  }
  if(unlink("..") == 0){
    393c:	c7 04 24 08 58 00 00 	movl   $0x5808,(%esp)
    3943:	e8 20 13 00 00       	call   4c68 <unlink>
    3948:	85 c0                	test   %eax,%eax
    394a:	75 19                	jne    3965 <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    394c:	c7 44 24 04 83 65 00 	movl   $0x6583,0x4(%esp)
    3953:	00 
    3954:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    395b:	e8 68 14 00 00       	call   4dc8 <printf>
    exit();
    3960:	e8 b3 12 00 00       	call   4c18 <exit>
  }
  if(chdir("/") != 0){
    3965:	c7 04 24 92 65 00 00 	movl   $0x6592,(%esp)
    396c:	e8 17 13 00 00       	call   4c88 <chdir>
    3971:	85 c0                	test   %eax,%eax
    3973:	74 19                	je     398e <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    3975:	c7 44 24 04 94 65 00 	movl   $0x6594,0x4(%esp)
    397c:	00 
    397d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3984:	e8 3f 14 00 00       	call   4dc8 <printf>
    exit();
    3989:	e8 8a 12 00 00       	call   4c18 <exit>
  }
  if(unlink("dots/.") == 0){
    398e:	c7 04 24 a4 65 00 00 	movl   $0x65a4,(%esp)
    3995:	e8 ce 12 00 00       	call   4c68 <unlink>
    399a:	85 c0                	test   %eax,%eax
    399c:	75 19                	jne    39b7 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    399e:	c7 44 24 04 ab 65 00 	movl   $0x65ab,0x4(%esp)
    39a5:	00 
    39a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39ad:	e8 16 14 00 00       	call   4dc8 <printf>
    exit();
    39b2:	e8 61 12 00 00       	call   4c18 <exit>
  }
  if(unlink("dots/..") == 0){
    39b7:	c7 04 24 c2 65 00 00 	movl   $0x65c2,(%esp)
    39be:	e8 a5 12 00 00       	call   4c68 <unlink>
    39c3:	85 c0                	test   %eax,%eax
    39c5:	75 19                	jne    39e0 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    39c7:	c7 44 24 04 ca 65 00 	movl   $0x65ca,0x4(%esp)
    39ce:	00 
    39cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39d6:	e8 ed 13 00 00       	call   4dc8 <printf>
    exit();
    39db:	e8 38 12 00 00       	call   4c18 <exit>
  }
  if(unlink("dots") != 0){
    39e0:	c7 04 24 4a 65 00 00 	movl   $0x654a,(%esp)
    39e7:	e8 7c 12 00 00       	call   4c68 <unlink>
    39ec:	85 c0                	test   %eax,%eax
    39ee:	74 19                	je     3a09 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    39f0:	c7 44 24 04 e2 65 00 	movl   $0x65e2,0x4(%esp)
    39f7:	00 
    39f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39ff:	e8 c4 13 00 00       	call   4dc8 <printf>
    exit();
    3a04:	e8 0f 12 00 00       	call   4c18 <exit>
  }
  printf(1, "rmdot ok\n");
    3a09:	c7 44 24 04 f7 65 00 	movl   $0x65f7,0x4(%esp)
    3a10:	00 
    3a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a18:	e8 ab 13 00 00       	call   4dc8 <printf>
}
    3a1d:	c9                   	leave  
    3a1e:	c3                   	ret    

00003a1f <dirfile>:

void
dirfile(void)
{
    3a1f:	55                   	push   %ebp
    3a20:	89 e5                	mov    %esp,%ebp
    3a22:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    3a25:	c7 44 24 04 01 66 00 	movl   $0x6601,0x4(%esp)
    3a2c:	00 
    3a2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a34:	e8 8f 13 00 00       	call   4dc8 <printf>

  fd = open("dirfile", O_CREATE);
    3a39:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3a40:	00 
    3a41:	c7 04 24 0e 66 00 00 	movl   $0x660e,(%esp)
    3a48:	e8 0b 12 00 00       	call   4c58 <open>
    3a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3a54:	79 19                	jns    3a6f <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    3a56:	c7 44 24 04 16 66 00 	movl   $0x6616,0x4(%esp)
    3a5d:	00 
    3a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a65:	e8 5e 13 00 00       	call   4dc8 <printf>
    exit();
    3a6a:	e8 a9 11 00 00       	call   4c18 <exit>
  }
  close(fd);
    3a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a72:	89 04 24             	mov    %eax,(%esp)
    3a75:	e8 c6 11 00 00       	call   4c40 <close>
  if(chdir("dirfile") == 0){
    3a7a:	c7 04 24 0e 66 00 00 	movl   $0x660e,(%esp)
    3a81:	e8 02 12 00 00       	call   4c88 <chdir>
    3a86:	85 c0                	test   %eax,%eax
    3a88:	75 19                	jne    3aa3 <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    3a8a:	c7 44 24 04 2d 66 00 	movl   $0x662d,0x4(%esp)
    3a91:	00 
    3a92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a99:	e8 2a 13 00 00       	call   4dc8 <printf>
    exit();
    3a9e:	e8 75 11 00 00       	call   4c18 <exit>
  }
  fd = open("dirfile/xx", 0);
    3aa3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3aaa:	00 
    3aab:	c7 04 24 47 66 00 00 	movl   $0x6647,(%esp)
    3ab2:	e8 a1 11 00 00       	call   4c58 <open>
    3ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3aba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3abe:	78 19                	js     3ad9 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    3ac0:	c7 44 24 04 52 66 00 	movl   $0x6652,0x4(%esp)
    3ac7:	00 
    3ac8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3acf:	e8 f4 12 00 00       	call   4dc8 <printf>
    exit();
    3ad4:	e8 3f 11 00 00       	call   4c18 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    3ad9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3ae0:	00 
    3ae1:	c7 04 24 47 66 00 00 	movl   $0x6647,(%esp)
    3ae8:	e8 6b 11 00 00       	call   4c58 <open>
    3aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3af0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3af4:	78 19                	js     3b0f <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    3af6:	c7 44 24 04 52 66 00 	movl   $0x6652,0x4(%esp)
    3afd:	00 
    3afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b05:	e8 be 12 00 00       	call   4dc8 <printf>
    exit();
    3b0a:	e8 09 11 00 00       	call   4c18 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    3b0f:	c7 04 24 47 66 00 00 	movl   $0x6647,(%esp)
    3b16:	e8 65 11 00 00       	call   4c80 <mkdir>
    3b1b:	85 c0                	test   %eax,%eax
    3b1d:	75 19                	jne    3b38 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    3b1f:	c7 44 24 04 70 66 00 	movl   $0x6670,0x4(%esp)
    3b26:	00 
    3b27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b2e:	e8 95 12 00 00       	call   4dc8 <printf>
    exit();
    3b33:	e8 e0 10 00 00       	call   4c18 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    3b38:	c7 04 24 47 66 00 00 	movl   $0x6647,(%esp)
    3b3f:	e8 24 11 00 00       	call   4c68 <unlink>
    3b44:	85 c0                	test   %eax,%eax
    3b46:	75 19                	jne    3b61 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3b48:	c7 44 24 04 8d 66 00 	movl   $0x668d,0x4(%esp)
    3b4f:	00 
    3b50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b57:	e8 6c 12 00 00       	call   4dc8 <printf>
    exit();
    3b5c:	e8 b7 10 00 00       	call   4c18 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    3b61:	c7 44 24 04 47 66 00 	movl   $0x6647,0x4(%esp)
    3b68:	00 
    3b69:	c7 04 24 ab 66 00 00 	movl   $0x66ab,(%esp)
    3b70:	e8 03 11 00 00       	call   4c78 <link>
    3b75:	85 c0                	test   %eax,%eax
    3b77:	75 19                	jne    3b92 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    3b79:	c7 44 24 04 b4 66 00 	movl   $0x66b4,0x4(%esp)
    3b80:	00 
    3b81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b88:	e8 3b 12 00 00       	call   4dc8 <printf>
    exit();
    3b8d:	e8 86 10 00 00       	call   4c18 <exit>
  }
  if(unlink("dirfile") != 0){
    3b92:	c7 04 24 0e 66 00 00 	movl   $0x660e,(%esp)
    3b99:	e8 ca 10 00 00       	call   4c68 <unlink>
    3b9e:	85 c0                	test   %eax,%eax
    3ba0:	74 19                	je     3bbb <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    3ba2:	c7 44 24 04 d3 66 00 	movl   $0x66d3,0x4(%esp)
    3ba9:	00 
    3baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3bb1:	e8 12 12 00 00       	call   4dc8 <printf>
    exit();
    3bb6:	e8 5d 10 00 00       	call   4c18 <exit>
  }

  fd = open(".", O_RDWR);
    3bbb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    3bc2:	00 
    3bc3:	c7 04 24 7b 5c 00 00 	movl   $0x5c7b,(%esp)
    3bca:	e8 89 10 00 00       	call   4c58 <open>
    3bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3bd6:	78 19                	js     3bf1 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    3bd8:	c7 44 24 04 ec 66 00 	movl   $0x66ec,0x4(%esp)
    3bdf:	00 
    3be0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3be7:	e8 dc 11 00 00       	call   4dc8 <printf>
    exit();
    3bec:	e8 27 10 00 00       	call   4c18 <exit>
  }
  fd = open(".", 0);
    3bf1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3bf8:	00 
    3bf9:	c7 04 24 7b 5c 00 00 	movl   $0x5c7b,(%esp)
    3c00:	e8 53 10 00 00       	call   4c58 <open>
    3c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    3c08:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c0f:	00 
    3c10:	c7 44 24 04 b2 58 00 	movl   $0x58b2,0x4(%esp)
    3c17:	00 
    3c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c1b:	89 04 24             	mov    %eax,(%esp)
    3c1e:	e8 15 10 00 00       	call   4c38 <write>
    3c23:	85 c0                	test   %eax,%eax
    3c25:	7e 19                	jle    3c40 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    3c27:	c7 44 24 04 0b 67 00 	movl   $0x670b,0x4(%esp)
    3c2e:	00 
    3c2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c36:	e8 8d 11 00 00       	call   4dc8 <printf>
    exit();
    3c3b:	e8 d8 0f 00 00       	call   4c18 <exit>
  }
  close(fd);
    3c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c43:	89 04 24             	mov    %eax,(%esp)
    3c46:	e8 f5 0f 00 00       	call   4c40 <close>

  printf(1, "dir vs file OK\n");
    3c4b:	c7 44 24 04 1f 67 00 	movl   $0x671f,0x4(%esp)
    3c52:	00 
    3c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c5a:	e8 69 11 00 00       	call   4dc8 <printf>
}
    3c5f:	c9                   	leave  
    3c60:	c3                   	ret    

00003c61 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    3c61:	55                   	push   %ebp
    3c62:	89 e5                	mov    %esp,%ebp
    3c64:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    3c67:	c7 44 24 04 2f 67 00 	movl   $0x672f,0x4(%esp)
    3c6e:	00 
    3c6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c76:	e8 4d 11 00 00       	call   4dc8 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    3c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3c82:	e9 d2 00 00 00       	jmp    3d59 <iref+0xf8>
    if(mkdir("irefd") != 0){
    3c87:	c7 04 24 40 67 00 00 	movl   $0x6740,(%esp)
    3c8e:	e8 ed 0f 00 00       	call   4c80 <mkdir>
    3c93:	85 c0                	test   %eax,%eax
    3c95:	74 19                	je     3cb0 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    3c97:	c7 44 24 04 46 67 00 	movl   $0x6746,0x4(%esp)
    3c9e:	00 
    3c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ca6:	e8 1d 11 00 00       	call   4dc8 <printf>
      exit();
    3cab:	e8 68 0f 00 00       	call   4c18 <exit>
    }
    if(chdir("irefd") != 0){
    3cb0:	c7 04 24 40 67 00 00 	movl   $0x6740,(%esp)
    3cb7:	e8 cc 0f 00 00       	call   4c88 <chdir>
    3cbc:	85 c0                	test   %eax,%eax
    3cbe:	74 19                	je     3cd9 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    3cc0:	c7 44 24 04 5a 67 00 	movl   $0x675a,0x4(%esp)
    3cc7:	00 
    3cc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ccf:	e8 f4 10 00 00       	call   4dc8 <printf>
      exit();
    3cd4:	e8 3f 0f 00 00       	call   4c18 <exit>
    }

    mkdir("");
    3cd9:	c7 04 24 6e 67 00 00 	movl   $0x676e,(%esp)
    3ce0:	e8 9b 0f 00 00       	call   4c80 <mkdir>
    link("README", "");
    3ce5:	c7 44 24 04 6e 67 00 	movl   $0x676e,0x4(%esp)
    3cec:	00 
    3ced:	c7 04 24 ab 66 00 00 	movl   $0x66ab,(%esp)
    3cf4:	e8 7f 0f 00 00       	call   4c78 <link>
    fd = open("", O_CREATE);
    3cf9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3d00:	00 
    3d01:	c7 04 24 6e 67 00 00 	movl   $0x676e,(%esp)
    3d08:	e8 4b 0f 00 00       	call   4c58 <open>
    3d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d14:	78 0b                	js     3d21 <iref+0xc0>
      close(fd);
    3d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3d19:	89 04 24             	mov    %eax,(%esp)
    3d1c:	e8 1f 0f 00 00       	call   4c40 <close>
    fd = open("xx", O_CREATE);
    3d21:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3d28:	00 
    3d29:	c7 04 24 6f 67 00 00 	movl   $0x676f,(%esp)
    3d30:	e8 23 0f 00 00       	call   4c58 <open>
    3d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3d38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d3c:	78 0b                	js     3d49 <iref+0xe8>
      close(fd);
    3d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3d41:	89 04 24             	mov    %eax,(%esp)
    3d44:	e8 f7 0e 00 00       	call   4c40 <close>
    unlink("xx");
    3d49:	c7 04 24 6f 67 00 00 	movl   $0x676f,(%esp)
    3d50:	e8 13 0f 00 00       	call   4c68 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    3d55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3d59:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3d5d:	0f 8e 24 ff ff ff    	jle    3c87 <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    3d63:	c7 04 24 92 65 00 00 	movl   $0x6592,(%esp)
    3d6a:	e8 19 0f 00 00       	call   4c88 <chdir>
  printf(1, "empty file name OK\n");
    3d6f:	c7 44 24 04 72 67 00 	movl   $0x6772,0x4(%esp)
    3d76:	00 
    3d77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d7e:	e8 45 10 00 00       	call   4dc8 <printf>
}
    3d83:	c9                   	leave  
    3d84:	c3                   	ret    

00003d85 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3d85:	55                   	push   %ebp
    3d86:	89 e5                	mov    %esp,%ebp
    3d88:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3d8b:	c7 44 24 04 86 67 00 	movl   $0x6786,0x4(%esp)
    3d92:	00 
    3d93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d9a:	e8 29 10 00 00       	call   4dc8 <printf>

  for(n=0; n<1000; n++){
    3d9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3da6:	eb 1f                	jmp    3dc7 <forktest+0x42>
    pid = fork();
    3da8:	e8 63 0e 00 00       	call   4c10 <fork>
    3dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3db0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3db4:	79 02                	jns    3db8 <forktest+0x33>
      break;
    3db6:	eb 18                	jmp    3dd0 <forktest+0x4b>
    if(pid == 0)
    3db8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3dbc:	75 05                	jne    3dc3 <forktest+0x3e>
      exit();
    3dbe:	e8 55 0e 00 00       	call   4c18 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3dc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3dc7:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3dce:	7e d8                	jle    3da8 <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3dd0:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3dd7:	75 19                	jne    3df2 <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
    3dd9:	c7 44 24 04 94 67 00 	movl   $0x6794,0x4(%esp)
    3de0:	00 
    3de1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3de8:	e8 db 0f 00 00       	call   4dc8 <printf>
    exit();
    3ded:	e8 26 0e 00 00       	call   4c18 <exit>
  }
  
  for(; n > 0; n--){
    3df2:	eb 26                	jmp    3e1a <forktest+0x95>
    if(wait() < 0){
    3df4:	e8 27 0e 00 00       	call   4c20 <wait>
    3df9:	85 c0                	test   %eax,%eax
    3dfb:	79 19                	jns    3e16 <forktest+0x91>
      printf(1, "wait stopped early\n");
    3dfd:	c7 44 24 04 b6 67 00 	movl   $0x67b6,0x4(%esp)
    3e04:	00 
    3e05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e0c:	e8 b7 0f 00 00       	call   4dc8 <printf>
      exit();
    3e11:	e8 02 0e 00 00       	call   4c18 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    3e16:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    3e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e1e:	7f d4                	jg     3df4 <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    3e20:	e8 fb 0d 00 00       	call   4c20 <wait>
    3e25:	83 f8 ff             	cmp    $0xffffffff,%eax
    3e28:	74 19                	je     3e43 <forktest+0xbe>
    printf(1, "wait got too many\n");
    3e2a:	c7 44 24 04 ca 67 00 	movl   $0x67ca,0x4(%esp)
    3e31:	00 
    3e32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e39:	e8 8a 0f 00 00       	call   4dc8 <printf>
    exit();
    3e3e:	e8 d5 0d 00 00       	call   4c18 <exit>
  }
  
  printf(1, "fork test OK\n");
    3e43:	c7 44 24 04 dd 67 00 	movl   $0x67dd,0x4(%esp)
    3e4a:	00 
    3e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e52:	e8 71 0f 00 00       	call   4dc8 <printf>
}
    3e57:	c9                   	leave  
    3e58:	c3                   	ret    

00003e59 <sbrktest>:

void
sbrktest(void)
{
    3e59:	55                   	push   %ebp
    3e5a:	89 e5                	mov    %esp,%ebp
    3e5c:	53                   	push   %ebx
    3e5d:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3e63:	a1 28 74 00 00       	mov    0x7428,%eax
    3e68:	c7 44 24 04 eb 67 00 	movl   $0x67eb,0x4(%esp)
    3e6f:	00 
    3e70:	89 04 24             	mov    %eax,(%esp)
    3e73:	e8 50 0f 00 00       	call   4dc8 <printf>
  oldbrk = sbrk(0);
    3e78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e7f:	e8 1c 0e 00 00       	call   4ca0 <sbrk>
    3e84:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3e87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e8e:	e8 0d 0e 00 00       	call   4ca0 <sbrk>
    3e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    3e96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3e9d:	eb 59                	jmp    3ef8 <sbrktest+0x9f>
    b = sbrk(1);
    3e9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ea6:	e8 f5 0d 00 00       	call   4ca0 <sbrk>
    3eab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3eb1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3eb4:	74 2f                	je     3ee5 <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3eb6:	a1 28 74 00 00       	mov    0x7428,%eax
    3ebb:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3ebe:	89 54 24 10          	mov    %edx,0x10(%esp)
    3ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3ec5:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3ecc:	89 54 24 08          	mov    %edx,0x8(%esp)
    3ed0:	c7 44 24 04 f6 67 00 	movl   $0x67f6,0x4(%esp)
    3ed7:	00 
    3ed8:	89 04 24             	mov    %eax,(%esp)
    3edb:	e8 e8 0e 00 00       	call   4dc8 <printf>
      exit();
    3ee0:	e8 33 0d 00 00       	call   4c18 <exit>
    }
    *b = 1;
    3ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ee8:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3eee:	83 c0 01             	add    $0x1,%eax
    3ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3ef4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3ef8:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3eff:	7e 9e                	jle    3e9f <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    3f01:	e8 0a 0d 00 00       	call   4c10 <fork>
    3f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    3f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3f0d:	79 1a                	jns    3f29 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    3f0f:	a1 28 74 00 00       	mov    0x7428,%eax
    3f14:	c7 44 24 04 11 68 00 	movl   $0x6811,0x4(%esp)
    3f1b:	00 
    3f1c:	89 04 24             	mov    %eax,(%esp)
    3f1f:	e8 a4 0e 00 00       	call   4dc8 <printf>
    exit();
    3f24:	e8 ef 0c 00 00       	call   4c18 <exit>
  }
  c = sbrk(1);
    3f29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f30:	e8 6b 0d 00 00       	call   4ca0 <sbrk>
    3f35:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    3f38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f3f:	e8 5c 0d 00 00       	call   4ca0 <sbrk>
    3f44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    3f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f4a:	83 c0 01             	add    $0x1,%eax
    3f4d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3f50:	74 1a                	je     3f6c <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    3f52:	a1 28 74 00 00       	mov    0x7428,%eax
    3f57:	c7 44 24 04 28 68 00 	movl   $0x6828,0x4(%esp)
    3f5e:	00 
    3f5f:	89 04 24             	mov    %eax,(%esp)
    3f62:	e8 61 0e 00 00       	call   4dc8 <printf>
    exit();
    3f67:	e8 ac 0c 00 00       	call   4c18 <exit>
  }
  if(pid == 0)
    3f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3f70:	75 05                	jne    3f77 <sbrktest+0x11e>
    exit();
    3f72:	e8 a1 0c 00 00       	call   4c18 <exit>
  wait();
    3f77:	e8 a4 0c 00 00       	call   4c20 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3f7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3f83:	e8 18 0d 00 00       	call   4ca0 <sbrk>
    3f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f8e:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3f93:	29 c2                	sub    %eax,%edx
    3f95:	89 d0                	mov    %edx,%eax
    3f97:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3f9d:	89 04 24             	mov    %eax,(%esp)
    3fa0:	e8 fb 0c 00 00       	call   4ca0 <sbrk>
    3fa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    3fa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3fab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3fae:	74 1a                	je     3fca <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3fb0:	a1 28 74 00 00       	mov    0x7428,%eax
    3fb5:	c7 44 24 04 44 68 00 	movl   $0x6844,0x4(%esp)
    3fbc:	00 
    3fbd:	89 04 24             	mov    %eax,(%esp)
    3fc0:	e8 03 0e 00 00       	call   4dc8 <printf>
    exit();
    3fc5:	e8 4e 0c 00 00       	call   4c18 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3fca:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3fd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3fd4:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3fd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3fde:	e8 bd 0c 00 00       	call   4ca0 <sbrk>
    3fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3fe6:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3fed:	e8 ae 0c 00 00       	call   4ca0 <sbrk>
    3ff2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3ff5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3ff9:	75 1a                	jne    4015 <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
    3ffb:	a1 28 74 00 00       	mov    0x7428,%eax
    4000:	c7 44 24 04 82 68 00 	movl   $0x6882,0x4(%esp)
    4007:	00 
    4008:	89 04 24             	mov    %eax,(%esp)
    400b:	e8 b8 0d 00 00       	call   4dc8 <printf>
    exit();
    4010:	e8 03 0c 00 00       	call   4c18 <exit>
  }
  c = sbrk(0);
    4015:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    401c:	e8 7f 0c 00 00       	call   4ca0 <sbrk>
    4021:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    4024:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4027:	2d 00 10 00 00       	sub    $0x1000,%eax
    402c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    402f:	74 28                	je     4059 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    4031:	a1 28 74 00 00       	mov    0x7428,%eax
    4036:	8b 55 e0             	mov    -0x20(%ebp),%edx
    4039:	89 54 24 0c          	mov    %edx,0xc(%esp)
    403d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4040:	89 54 24 08          	mov    %edx,0x8(%esp)
    4044:	c7 44 24 04 a0 68 00 	movl   $0x68a0,0x4(%esp)
    404b:	00 
    404c:	89 04 24             	mov    %eax,(%esp)
    404f:	e8 74 0d 00 00       	call   4dc8 <printf>
    exit();
    4054:	e8 bf 0b 00 00       	call   4c18 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    4059:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4060:	e8 3b 0c 00 00       	call   4ca0 <sbrk>
    4065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    4068:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    406f:	e8 2c 0c 00 00       	call   4ca0 <sbrk>
    4074:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    4077:	8b 45 e0             	mov    -0x20(%ebp),%eax
    407a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    407d:	75 19                	jne    4098 <sbrktest+0x23f>
    407f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4086:	e8 15 0c 00 00       	call   4ca0 <sbrk>
    408b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    408e:	81 c2 00 10 00 00    	add    $0x1000,%edx
    4094:	39 d0                	cmp    %edx,%eax
    4096:	74 28                	je     40c0 <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    4098:	a1 28 74 00 00       	mov    0x7428,%eax
    409d:	8b 55 e0             	mov    -0x20(%ebp),%edx
    40a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
    40a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    40a7:	89 54 24 08          	mov    %edx,0x8(%esp)
    40ab:	c7 44 24 04 d8 68 00 	movl   $0x68d8,0x4(%esp)
    40b2:	00 
    40b3:	89 04 24             	mov    %eax,(%esp)
    40b6:	e8 0d 0d 00 00       	call   4dc8 <printf>
    exit();
    40bb:	e8 58 0b 00 00       	call   4c18 <exit>
  }
  if(*lastaddr == 99){
    40c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    40c3:	0f b6 00             	movzbl (%eax),%eax
    40c6:	3c 63                	cmp    $0x63,%al
    40c8:	75 1a                	jne    40e4 <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    40ca:	a1 28 74 00 00       	mov    0x7428,%eax
    40cf:	c7 44 24 04 00 69 00 	movl   $0x6900,0x4(%esp)
    40d6:	00 
    40d7:	89 04 24             	mov    %eax,(%esp)
    40da:	e8 e9 0c 00 00       	call   4dc8 <printf>
    exit();
    40df:	e8 34 0b 00 00       	call   4c18 <exit>
  }

  a = sbrk(0);
    40e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    40eb:	e8 b0 0b 00 00       	call   4ca0 <sbrk>
    40f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    40f3:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    40f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    40fd:	e8 9e 0b 00 00       	call   4ca0 <sbrk>
    4102:	29 c3                	sub    %eax,%ebx
    4104:	89 d8                	mov    %ebx,%eax
    4106:	89 04 24             	mov    %eax,(%esp)
    4109:	e8 92 0b 00 00       	call   4ca0 <sbrk>
    410e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    4111:	8b 45 e0             	mov    -0x20(%ebp),%eax
    4114:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    4117:	74 28                	je     4141 <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    4119:	a1 28 74 00 00       	mov    0x7428,%eax
    411e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    4121:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4125:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4128:	89 54 24 08          	mov    %edx,0x8(%esp)
    412c:	c7 44 24 04 30 69 00 	movl   $0x6930,0x4(%esp)
    4133:	00 
    4134:	89 04 24             	mov    %eax,(%esp)
    4137:	e8 8c 0c 00 00       	call   4dc8 <printf>
    exit();
    413c:	e8 d7 0a 00 00       	call   4c18 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4141:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    4148:	eb 7b                	jmp    41c5 <sbrktest+0x36c>
    ppid = getpid();
    414a:	e8 49 0b 00 00       	call   4c98 <getpid>
    414f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    4152:	e8 b9 0a 00 00       	call   4c10 <fork>
    4157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    415a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    415e:	79 1a                	jns    417a <sbrktest+0x321>
      printf(stdout, "fork failed\n");
    4160:	a1 28 74 00 00       	mov    0x7428,%eax
    4165:	c7 44 24 04 f9 58 00 	movl   $0x58f9,0x4(%esp)
    416c:	00 
    416d:	89 04 24             	mov    %eax,(%esp)
    4170:	e8 53 0c 00 00       	call   4dc8 <printf>
      exit();
    4175:	e8 9e 0a 00 00       	call   4c18 <exit>
    }
    if(pid == 0){
    417a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    417e:	75 39                	jne    41b9 <sbrktest+0x360>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    4180:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4183:	0f b6 00             	movzbl (%eax),%eax
    4186:	0f be d0             	movsbl %al,%edx
    4189:	a1 28 74 00 00       	mov    0x7428,%eax
    418e:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4192:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4195:	89 54 24 08          	mov    %edx,0x8(%esp)
    4199:	c7 44 24 04 51 69 00 	movl   $0x6951,0x4(%esp)
    41a0:	00 
    41a1:	89 04 24             	mov    %eax,(%esp)
    41a4:	e8 1f 0c 00 00       	call   4dc8 <printf>
      kill(ppid);
    41a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
    41ac:	89 04 24             	mov    %eax,(%esp)
    41af:	e8 94 0a 00 00       	call   4c48 <kill>
      exit();
    41b4:	e8 5f 0a 00 00       	call   4c18 <exit>
    }
    wait();
    41b9:	e8 62 0a 00 00       	call   4c20 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    41be:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    41c5:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    41cc:	0f 86 78 ff ff ff    	jbe    414a <sbrktest+0x2f1>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    41d2:	8d 45 c8             	lea    -0x38(%ebp),%eax
    41d5:	89 04 24             	mov    %eax,(%esp)
    41d8:	e8 4b 0a 00 00       	call   4c28 <pipe>
    41dd:	85 c0                	test   %eax,%eax
    41df:	74 19                	je     41fa <sbrktest+0x3a1>
    printf(1, "pipe() failed\n");
    41e1:	c7 44 24 04 4d 58 00 	movl   $0x584d,0x4(%esp)
    41e8:	00 
    41e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    41f0:	e8 d3 0b 00 00       	call   4dc8 <printf>
    exit();
    41f5:	e8 1e 0a 00 00       	call   4c18 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    41fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4201:	e9 87 00 00 00       	jmp    428d <sbrktest+0x434>
    if((pids[i] = fork()) == 0){
    4206:	e8 05 0a 00 00       	call   4c10 <fork>
    420b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    420e:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    4212:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4215:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    4219:	85 c0                	test   %eax,%eax
    421b:	75 46                	jne    4263 <sbrktest+0x40a>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    421d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4224:	e8 77 0a 00 00       	call   4ca0 <sbrk>
    4229:	ba 00 00 40 06       	mov    $0x6400000,%edx
    422e:	29 c2                	sub    %eax,%edx
    4230:	89 d0                	mov    %edx,%eax
    4232:	89 04 24             	mov    %eax,(%esp)
    4235:	e8 66 0a 00 00       	call   4ca0 <sbrk>
      write(fds[1], "x", 1);
    423a:	8b 45 cc             	mov    -0x34(%ebp),%eax
    423d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4244:	00 
    4245:	c7 44 24 04 b2 58 00 	movl   $0x58b2,0x4(%esp)
    424c:	00 
    424d:	89 04 24             	mov    %eax,(%esp)
    4250:	e8 e3 09 00 00       	call   4c38 <write>
      // sit around until killed
      for(;;) sleep(1000);
    4255:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    425c:	e8 47 0a 00 00       	call   4ca8 <sleep>
    4261:	eb f2                	jmp    4255 <sbrktest+0x3fc>
    }
    if(pids[i] != -1)
    4263:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4266:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    426a:	83 f8 ff             	cmp    $0xffffffff,%eax
    426d:	74 1a                	je     4289 <sbrktest+0x430>
      read(fds[0], &scratch, 1);
    426f:	8b 45 c8             	mov    -0x38(%ebp),%eax
    4272:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4279:	00 
    427a:	8d 55 9f             	lea    -0x61(%ebp),%edx
    427d:	89 54 24 04          	mov    %edx,0x4(%esp)
    4281:	89 04 24             	mov    %eax,(%esp)
    4284:	e8 a7 09 00 00       	call   4c30 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4289:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    428d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4290:	83 f8 09             	cmp    $0x9,%eax
    4293:	0f 86 6d ff ff ff    	jbe    4206 <sbrktest+0x3ad>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    4299:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    42a0:	e8 fb 09 00 00       	call   4ca0 <sbrk>
    42a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    42af:	eb 26                	jmp    42d7 <sbrktest+0x47e>
    if(pids[i] == -1)
    42b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42b4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    42b8:	83 f8 ff             	cmp    $0xffffffff,%eax
    42bb:	75 02                	jne    42bf <sbrktest+0x466>
      continue;
    42bd:	eb 14                	jmp    42d3 <sbrktest+0x47a>
    kill(pids[i]);
    42bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42c2:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    42c6:	89 04 24             	mov    %eax,(%esp)
    42c9:	e8 7a 09 00 00       	call   4c48 <kill>
    wait();
    42ce:	e8 4d 09 00 00       	call   4c20 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    42d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42da:	83 f8 09             	cmp    $0x9,%eax
    42dd:	76 d2                	jbe    42b1 <sbrktest+0x458>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    42df:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    42e3:	75 1a                	jne    42ff <sbrktest+0x4a6>
    printf(stdout, "failed sbrk leaked memory\n");
    42e5:	a1 28 74 00 00       	mov    0x7428,%eax
    42ea:	c7 44 24 04 6a 69 00 	movl   $0x696a,0x4(%esp)
    42f1:	00 
    42f2:	89 04 24             	mov    %eax,(%esp)
    42f5:	e8 ce 0a 00 00       	call   4dc8 <printf>
    exit();
    42fa:	e8 19 09 00 00       	call   4c18 <exit>
  }

  if(sbrk(0) > oldbrk)
    42ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4306:	e8 95 09 00 00       	call   4ca0 <sbrk>
    430b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    430e:	76 1b                	jbe    432b <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    4310:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    4313:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    431a:	e8 81 09 00 00       	call   4ca0 <sbrk>
    431f:	29 c3                	sub    %eax,%ebx
    4321:	89 d8                	mov    %ebx,%eax
    4323:	89 04 24             	mov    %eax,(%esp)
    4326:	e8 75 09 00 00       	call   4ca0 <sbrk>

  printf(stdout, "sbrk test OK\n");
    432b:	a1 28 74 00 00       	mov    0x7428,%eax
    4330:	c7 44 24 04 85 69 00 	movl   $0x6985,0x4(%esp)
    4337:	00 
    4338:	89 04 24             	mov    %eax,(%esp)
    433b:	e8 88 0a 00 00       	call   4dc8 <printf>
}
    4340:	81 c4 84 00 00 00    	add    $0x84,%esp
    4346:	5b                   	pop    %ebx
    4347:	5d                   	pop    %ebp
    4348:	c3                   	ret    

00004349 <validateint>:

void
validateint(int *p)
{
    4349:	55                   	push   %ebp
    434a:	89 e5                	mov    %esp,%ebp
    434c:	53                   	push   %ebx
    434d:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    4350:	b8 0d 00 00 00       	mov    $0xd,%eax
    4355:	8b 55 08             	mov    0x8(%ebp),%edx
    4358:	89 d1                	mov    %edx,%ecx
    435a:	89 e3                	mov    %esp,%ebx
    435c:	89 cc                	mov    %ecx,%esp
    435e:	cd 40                	int    $0x40
    4360:	89 dc                	mov    %ebx,%esp
    4362:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    4365:	83 c4 10             	add    $0x10,%esp
    4368:	5b                   	pop    %ebx
    4369:	5d                   	pop    %ebp
    436a:	c3                   	ret    

0000436b <validatetest>:

void
validatetest(void)
{
    436b:	55                   	push   %ebp
    436c:	89 e5                	mov    %esp,%ebp
    436e:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    4371:	a1 28 74 00 00       	mov    0x7428,%eax
    4376:	c7 44 24 04 93 69 00 	movl   $0x6993,0x4(%esp)
    437d:	00 
    437e:	89 04 24             	mov    %eax,(%esp)
    4381:	e8 42 0a 00 00       	call   4dc8 <printf>
  hi = 1100*1024;
    4386:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    438d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4394:	eb 7f                	jmp    4415 <validatetest+0xaa>
    if((pid = fork()) == 0){
    4396:	e8 75 08 00 00       	call   4c10 <fork>
    439b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    439e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    43a2:	75 10                	jne    43b4 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    43a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a7:	89 04 24             	mov    %eax,(%esp)
    43aa:	e8 9a ff ff ff       	call   4349 <validateint>
      exit();
    43af:	e8 64 08 00 00       	call   4c18 <exit>
    }
    sleep(0);
    43b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    43bb:	e8 e8 08 00 00       	call   4ca8 <sleep>
    sleep(0);
    43c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    43c7:	e8 dc 08 00 00       	call   4ca8 <sleep>
    kill(pid);
    43cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43cf:	89 04 24             	mov    %eax,(%esp)
    43d2:	e8 71 08 00 00       	call   4c48 <kill>
    wait();
    43d7:	e8 44 08 00 00       	call   4c20 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    43dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43df:	89 44 24 04          	mov    %eax,0x4(%esp)
    43e3:	c7 04 24 a2 69 00 00 	movl   $0x69a2,(%esp)
    43ea:	e8 89 08 00 00       	call   4c78 <link>
    43ef:	83 f8 ff             	cmp    $0xffffffff,%eax
    43f2:	74 1a                	je     440e <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    43f4:	a1 28 74 00 00       	mov    0x7428,%eax
    43f9:	c7 44 24 04 ad 69 00 	movl   $0x69ad,0x4(%esp)
    4400:	00 
    4401:	89 04 24             	mov    %eax,(%esp)
    4404:	e8 bf 09 00 00       	call   4dc8 <printf>
      exit();
    4409:	e8 0a 08 00 00       	call   4c18 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    440e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    4415:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4418:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    441b:	0f 83 75 ff ff ff    	jae    4396 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    4421:	a1 28 74 00 00       	mov    0x7428,%eax
    4426:	c7 44 24 04 c6 69 00 	movl   $0x69c6,0x4(%esp)
    442d:	00 
    442e:	89 04 24             	mov    %eax,(%esp)
    4431:	e8 92 09 00 00       	call   4dc8 <printf>
}
    4436:	c9                   	leave  
    4437:	c3                   	ret    

00004438 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    4438:	55                   	push   %ebp
    4439:	89 e5                	mov    %esp,%ebp
    443b:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    443e:	a1 28 74 00 00       	mov    0x7428,%eax
    4443:	c7 44 24 04 d3 69 00 	movl   $0x69d3,0x4(%esp)
    444a:	00 
    444b:	89 04 24             	mov    %eax,(%esp)
    444e:	e8 75 09 00 00       	call   4dc8 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    4453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    445a:	eb 2d                	jmp    4489 <bsstest+0x51>
    if(uninit[i] != '\0'){
    445c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    445f:	05 00 75 00 00       	add    $0x7500,%eax
    4464:	0f b6 00             	movzbl (%eax),%eax
    4467:	84 c0                	test   %al,%al
    4469:	74 1a                	je     4485 <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    446b:	a1 28 74 00 00       	mov    0x7428,%eax
    4470:	c7 44 24 04 dd 69 00 	movl   $0x69dd,0x4(%esp)
    4477:	00 
    4478:	89 04 24             	mov    %eax,(%esp)
    447b:	e8 48 09 00 00       	call   4dc8 <printf>
      exit();
    4480:	e8 93 07 00 00       	call   4c18 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    4485:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4489:	8b 45 f4             	mov    -0xc(%ebp),%eax
    448c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    4491:	76 c9                	jbe    445c <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    4493:	a1 28 74 00 00       	mov    0x7428,%eax
    4498:	c7 44 24 04 ee 69 00 	movl   $0x69ee,0x4(%esp)
    449f:	00 
    44a0:	89 04 24             	mov    %eax,(%esp)
    44a3:	e8 20 09 00 00       	call   4dc8 <printf>
}
    44a8:	c9                   	leave  
    44a9:	c3                   	ret    

000044aa <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    44aa:	55                   	push   %ebp
    44ab:	89 e5                	mov    %esp,%ebp
    44ad:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    44b0:	c7 04 24 fb 69 00 00 	movl   $0x69fb,(%esp)
    44b7:	e8 ac 07 00 00       	call   4c68 <unlink>
  pid = fork();
    44bc:	e8 4f 07 00 00       	call   4c10 <fork>
    44c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    44c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    44c8:	0f 85 90 00 00 00    	jne    455e <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    44ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    44d5:	eb 12                	jmp    44e9 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    44d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44da:	c7 04 85 60 74 00 00 	movl   $0x6a08,0x7460(,%eax,4)
    44e1:	08 6a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    44e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    44e9:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    44ed:	7e e8                	jle    44d7 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    44ef:	c7 05 dc 74 00 00 00 	movl   $0x0,0x74dc
    44f6:	00 00 00 
    printf(stdout, "bigarg test\n");
    44f9:	a1 28 74 00 00       	mov    0x7428,%eax
    44fe:	c7 44 24 04 e5 6a 00 	movl   $0x6ae5,0x4(%esp)
    4505:	00 
    4506:	89 04 24             	mov    %eax,(%esp)
    4509:	e8 ba 08 00 00       	call   4dc8 <printf>
    exec("echo", args);
    450e:	c7 44 24 04 60 74 00 	movl   $0x7460,0x4(%esp)
    4515:	00 
    4516:	c7 04 24 0c 55 00 00 	movl   $0x550c,(%esp)
    451d:	e8 2e 07 00 00       	call   4c50 <exec>
    printf(stdout, "bigarg test ok\n");
    4522:	a1 28 74 00 00       	mov    0x7428,%eax
    4527:	c7 44 24 04 f2 6a 00 	movl   $0x6af2,0x4(%esp)
    452e:	00 
    452f:	89 04 24             	mov    %eax,(%esp)
    4532:	e8 91 08 00 00       	call   4dc8 <printf>
    fd = open("bigarg-ok", O_CREATE);
    4537:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    453e:	00 
    453f:	c7 04 24 fb 69 00 00 	movl   $0x69fb,(%esp)
    4546:	e8 0d 07 00 00       	call   4c58 <open>
    454b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    454e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4551:	89 04 24             	mov    %eax,(%esp)
    4554:	e8 e7 06 00 00       	call   4c40 <close>
    exit();
    4559:	e8 ba 06 00 00       	call   4c18 <exit>
  } else if(pid < 0){
    455e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4562:	79 1a                	jns    457e <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    4564:	a1 28 74 00 00       	mov    0x7428,%eax
    4569:	c7 44 24 04 02 6b 00 	movl   $0x6b02,0x4(%esp)
    4570:	00 
    4571:	89 04 24             	mov    %eax,(%esp)
    4574:	e8 4f 08 00 00       	call   4dc8 <printf>
    exit();
    4579:	e8 9a 06 00 00       	call   4c18 <exit>
  }
  wait();
    457e:	e8 9d 06 00 00       	call   4c20 <wait>
  fd = open("bigarg-ok", 0);
    4583:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    458a:	00 
    458b:	c7 04 24 fb 69 00 00 	movl   $0x69fb,(%esp)
    4592:	e8 c1 06 00 00       	call   4c58 <open>
    4597:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    459a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    459e:	79 1a                	jns    45ba <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    45a0:	a1 28 74 00 00       	mov    0x7428,%eax
    45a5:	c7 44 24 04 1b 6b 00 	movl   $0x6b1b,0x4(%esp)
    45ac:	00 
    45ad:	89 04 24             	mov    %eax,(%esp)
    45b0:	e8 13 08 00 00       	call   4dc8 <printf>
    exit();
    45b5:	e8 5e 06 00 00       	call   4c18 <exit>
  }
  close(fd);
    45ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
    45bd:	89 04 24             	mov    %eax,(%esp)
    45c0:	e8 7b 06 00 00       	call   4c40 <close>
  unlink("bigarg-ok");
    45c5:	c7 04 24 fb 69 00 00 	movl   $0x69fb,(%esp)
    45cc:	e8 97 06 00 00       	call   4c68 <unlink>
}
    45d1:	c9                   	leave  
    45d2:	c3                   	ret    

000045d3 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    45d3:	55                   	push   %ebp
    45d4:	89 e5                	mov    %esp,%ebp
    45d6:	53                   	push   %ebx
    45d7:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    45da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    45e1:	c7 44 24 04 30 6b 00 	movl   $0x6b30,0x4(%esp)
    45e8:	00 
    45e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    45f0:	e8 d3 07 00 00       	call   4dc8 <printf>

  for(nfiles = 0; ; nfiles++){
    45f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    45fc:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    4600:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4603:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4608:	89 c8                	mov    %ecx,%eax
    460a:	f7 ea                	imul   %edx
    460c:	c1 fa 06             	sar    $0x6,%edx
    460f:	89 c8                	mov    %ecx,%eax
    4611:	c1 f8 1f             	sar    $0x1f,%eax
    4614:	29 c2                	sub    %eax,%edx
    4616:	89 d0                	mov    %edx,%eax
    4618:	83 c0 30             	add    $0x30,%eax
    461b:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    461e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    4621:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4626:	89 d8                	mov    %ebx,%eax
    4628:	f7 ea                	imul   %edx
    462a:	c1 fa 06             	sar    $0x6,%edx
    462d:	89 d8                	mov    %ebx,%eax
    462f:	c1 f8 1f             	sar    $0x1f,%eax
    4632:	89 d1                	mov    %edx,%ecx
    4634:	29 c1                	sub    %eax,%ecx
    4636:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    463c:	29 c3                	sub    %eax,%ebx
    463e:	89 d9                	mov    %ebx,%ecx
    4640:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4645:	89 c8                	mov    %ecx,%eax
    4647:	f7 ea                	imul   %edx
    4649:	c1 fa 05             	sar    $0x5,%edx
    464c:	89 c8                	mov    %ecx,%eax
    464e:	c1 f8 1f             	sar    $0x1f,%eax
    4651:	29 c2                	sub    %eax,%edx
    4653:	89 d0                	mov    %edx,%eax
    4655:	83 c0 30             	add    $0x30,%eax
    4658:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    465b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    465e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4663:	89 d8                	mov    %ebx,%eax
    4665:	f7 ea                	imul   %edx
    4667:	c1 fa 05             	sar    $0x5,%edx
    466a:	89 d8                	mov    %ebx,%eax
    466c:	c1 f8 1f             	sar    $0x1f,%eax
    466f:	89 d1                	mov    %edx,%ecx
    4671:	29 c1                	sub    %eax,%ecx
    4673:	6b c1 64             	imul   $0x64,%ecx,%eax
    4676:	29 c3                	sub    %eax,%ebx
    4678:	89 d9                	mov    %ebx,%ecx
    467a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    467f:	89 c8                	mov    %ecx,%eax
    4681:	f7 ea                	imul   %edx
    4683:	c1 fa 02             	sar    $0x2,%edx
    4686:	89 c8                	mov    %ecx,%eax
    4688:	c1 f8 1f             	sar    $0x1f,%eax
    468b:	29 c2                	sub    %eax,%edx
    468d:	89 d0                	mov    %edx,%eax
    468f:	83 c0 30             	add    $0x30,%eax
    4692:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    4695:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4698:	ba 67 66 66 66       	mov    $0x66666667,%edx
    469d:	89 c8                	mov    %ecx,%eax
    469f:	f7 ea                	imul   %edx
    46a1:	c1 fa 02             	sar    $0x2,%edx
    46a4:	89 c8                	mov    %ecx,%eax
    46a6:	c1 f8 1f             	sar    $0x1f,%eax
    46a9:	29 c2                	sub    %eax,%edx
    46ab:	89 d0                	mov    %edx,%eax
    46ad:	c1 e0 02             	shl    $0x2,%eax
    46b0:	01 d0                	add    %edx,%eax
    46b2:	01 c0                	add    %eax,%eax
    46b4:	29 c1                	sub    %eax,%ecx
    46b6:	89 ca                	mov    %ecx,%edx
    46b8:	89 d0                	mov    %edx,%eax
    46ba:	83 c0 30             	add    $0x30,%eax
    46bd:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    46c0:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    46c4:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    46c7:	89 44 24 08          	mov    %eax,0x8(%esp)
    46cb:	c7 44 24 04 3d 6b 00 	movl   $0x6b3d,0x4(%esp)
    46d2:	00 
    46d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    46da:	e8 e9 06 00 00       	call   4dc8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    46df:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    46e6:	00 
    46e7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    46ea:	89 04 24             	mov    %eax,(%esp)
    46ed:	e8 66 05 00 00       	call   4c58 <open>
    46f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    46f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    46f9:	79 1d                	jns    4718 <fsfull+0x145>
      printf(1, "open %s failed\n", name);
    46fb:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    46fe:	89 44 24 08          	mov    %eax,0x8(%esp)
    4702:	c7 44 24 04 49 6b 00 	movl   $0x6b49,0x4(%esp)
    4709:	00 
    470a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4711:	e8 b2 06 00 00       	call   4dc8 <printf>
      break;
    4716:	eb 74                	jmp    478c <fsfull+0x1b9>
    }
    int total = 0;
    4718:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    471f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    4726:	00 
    4727:	c7 44 24 04 20 9c 00 	movl   $0x9c20,0x4(%esp)
    472e:	00 
    472f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4732:	89 04 24             	mov    %eax,(%esp)
    4735:	e8 fe 04 00 00       	call   4c38 <write>
    473a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    473d:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    4744:	7f 2f                	jg     4775 <fsfull+0x1a2>
        break;
    4746:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    4747:	8b 45 ec             	mov    -0x14(%ebp),%eax
    474a:	89 44 24 08          	mov    %eax,0x8(%esp)
    474e:	c7 44 24 04 59 6b 00 	movl   $0x6b59,0x4(%esp)
    4755:	00 
    4756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    475d:	e8 66 06 00 00       	call   4dc8 <printf>
    close(fd);
    4762:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4765:	89 04 24             	mov    %eax,(%esp)
    4768:	e8 d3 04 00 00       	call   4c40 <close>
    if(total == 0)
    476d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4771:	75 10                	jne    4783 <fsfull+0x1b0>
    4773:	eb 0c                	jmp    4781 <fsfull+0x1ae>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    4775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4778:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    477b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    477f:	eb 9e                	jmp    471f <fsfull+0x14c>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    4781:	eb 09                	jmp    478c <fsfull+0x1b9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    4783:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    4787:	e9 70 fe ff ff       	jmp    45fc <fsfull+0x29>

  while(nfiles >= 0){
    478c:	e9 d7 00 00 00       	jmp    4868 <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    4791:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    4795:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4798:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    479d:	89 c8                	mov    %ecx,%eax
    479f:	f7 ea                	imul   %edx
    47a1:	c1 fa 06             	sar    $0x6,%edx
    47a4:	89 c8                	mov    %ecx,%eax
    47a6:	c1 f8 1f             	sar    $0x1f,%eax
    47a9:	29 c2                	sub    %eax,%edx
    47ab:	89 d0                	mov    %edx,%eax
    47ad:	83 c0 30             	add    $0x30,%eax
    47b0:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    47b3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    47b6:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    47bb:	89 d8                	mov    %ebx,%eax
    47bd:	f7 ea                	imul   %edx
    47bf:	c1 fa 06             	sar    $0x6,%edx
    47c2:	89 d8                	mov    %ebx,%eax
    47c4:	c1 f8 1f             	sar    $0x1f,%eax
    47c7:	89 d1                	mov    %edx,%ecx
    47c9:	29 c1                	sub    %eax,%ecx
    47cb:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    47d1:	29 c3                	sub    %eax,%ebx
    47d3:	89 d9                	mov    %ebx,%ecx
    47d5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    47da:	89 c8                	mov    %ecx,%eax
    47dc:	f7 ea                	imul   %edx
    47de:	c1 fa 05             	sar    $0x5,%edx
    47e1:	89 c8                	mov    %ecx,%eax
    47e3:	c1 f8 1f             	sar    $0x1f,%eax
    47e6:	29 c2                	sub    %eax,%edx
    47e8:	89 d0                	mov    %edx,%eax
    47ea:	83 c0 30             	add    $0x30,%eax
    47ed:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    47f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    47f3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    47f8:	89 d8                	mov    %ebx,%eax
    47fa:	f7 ea                	imul   %edx
    47fc:	c1 fa 05             	sar    $0x5,%edx
    47ff:	89 d8                	mov    %ebx,%eax
    4801:	c1 f8 1f             	sar    $0x1f,%eax
    4804:	89 d1                	mov    %edx,%ecx
    4806:	29 c1                	sub    %eax,%ecx
    4808:	6b c1 64             	imul   $0x64,%ecx,%eax
    480b:	29 c3                	sub    %eax,%ebx
    480d:	89 d9                	mov    %ebx,%ecx
    480f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4814:	89 c8                	mov    %ecx,%eax
    4816:	f7 ea                	imul   %edx
    4818:	c1 fa 02             	sar    $0x2,%edx
    481b:	89 c8                	mov    %ecx,%eax
    481d:	c1 f8 1f             	sar    $0x1f,%eax
    4820:	29 c2                	sub    %eax,%edx
    4822:	89 d0                	mov    %edx,%eax
    4824:	83 c0 30             	add    $0x30,%eax
    4827:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    482a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    482d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4832:	89 c8                	mov    %ecx,%eax
    4834:	f7 ea                	imul   %edx
    4836:	c1 fa 02             	sar    $0x2,%edx
    4839:	89 c8                	mov    %ecx,%eax
    483b:	c1 f8 1f             	sar    $0x1f,%eax
    483e:	29 c2                	sub    %eax,%edx
    4840:	89 d0                	mov    %edx,%eax
    4842:	c1 e0 02             	shl    $0x2,%eax
    4845:	01 d0                	add    %edx,%eax
    4847:	01 c0                	add    %eax,%eax
    4849:	29 c1                	sub    %eax,%ecx
    484b:	89 ca                	mov    %ecx,%edx
    484d:	89 d0                	mov    %edx,%eax
    484f:	83 c0 30             	add    $0x30,%eax
    4852:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    4855:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    4859:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    485c:	89 04 24             	mov    %eax,(%esp)
    485f:	e8 04 04 00 00       	call   4c68 <unlink>
    nfiles--;
    4864:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    4868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    486c:	0f 89 1f ff ff ff    	jns    4791 <fsfull+0x1be>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    4872:	c7 44 24 04 69 6b 00 	movl   $0x6b69,0x4(%esp)
    4879:	00 
    487a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4881:	e8 42 05 00 00       	call   4dc8 <printf>
}
    4886:	83 c4 74             	add    $0x74,%esp
    4889:	5b                   	pop    %ebx
    488a:	5d                   	pop    %ebp
    488b:	c3                   	ret    

0000488c <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    488c:	55                   	push   %ebp
    488d:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    488f:	a1 2c 74 00 00       	mov    0x742c,%eax
    4894:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    489a:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    489f:	a3 2c 74 00 00       	mov    %eax,0x742c
  return randstate;
    48a4:	a1 2c 74 00 00       	mov    0x742c,%eax
}
    48a9:	5d                   	pop    %ebp
    48aa:	c3                   	ret    

000048ab <main>:

int
main(int argc, char *argv[])
{
    48ab:	55                   	push   %ebp
    48ac:	89 e5                	mov    %esp,%ebp
    48ae:	83 e4 f0             	and    $0xfffffff0,%esp
    48b1:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    48b4:	c7 44 24 04 7f 6b 00 	movl   $0x6b7f,0x4(%esp)
    48bb:	00 
    48bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    48c3:	e8 00 05 00 00       	call   4dc8 <printf>

  if(open("usertests.ran", 0) >= 0){
    48c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    48cf:	00 
    48d0:	c7 04 24 93 6b 00 00 	movl   $0x6b93,(%esp)
    48d7:	e8 7c 03 00 00       	call   4c58 <open>
    48dc:	85 c0                	test   %eax,%eax
    48de:	78 19                	js     48f9 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    48e0:	c7 44 24 04 a4 6b 00 	movl   $0x6ba4,0x4(%esp)
    48e7:	00 
    48e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    48ef:	e8 d4 04 00 00       	call   4dc8 <printf>
    exit();
    48f4:	e8 1f 03 00 00       	call   4c18 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    48f9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    4900:	00 
    4901:	c7 04 24 93 6b 00 00 	movl   $0x6b93,(%esp)
    4908:	e8 4b 03 00 00       	call   4c58 <open>
    490d:	89 04 24             	mov    %eax,(%esp)
    4910:	e8 2b 03 00 00       	call   4c40 <close>

  bigargtest();
    4915:	e8 90 fb ff ff       	call   44aa <bigargtest>
  bigwrite();
    491a:	e8 ff ea ff ff       	call   341e <bigwrite>
  bigargtest();
    491f:	e8 86 fb ff ff       	call   44aa <bigargtest>
  bsstest();
    4924:	e8 0f fb ff ff       	call   4438 <bsstest>
  sbrktest();
    4929:	e8 2b f5 ff ff       	call   3e59 <sbrktest>
  validatetest();
    492e:	e8 38 fa ff ff       	call   436b <validatetest>

  opentest();
    4933:	e8 c8 c6 ff ff       	call   1000 <opentest>
  writetest();
    4938:	e8 6e c7 ff ff       	call   10ab <writetest>
  writetest1();
    493d:	e8 7e c9 ff ff       	call   12c0 <writetest1>
  createtest();
    4942:	e8 84 cb ff ff       	call   14cb <createtest>

  mem();
    4947:	e8 24 d1 ff ff       	call   1a70 <mem>
  pipe1();
    494c:	e8 5b cd ff ff       	call   16ac <pipe1>
  preempt();
    4951:	e8 43 cf ff ff       	call   1899 <preempt>
  exitwait();
    4956:	e8 97 d0 ff ff       	call   19f2 <exitwait>

  rmdot();
    495b:	e8 47 ef ff ff       	call   38a7 <rmdot>
  fourteen();
    4960:	e8 ec ed ff ff       	call   3751 <fourteen>
  bigfile();
    4965:	e8 bc eb ff ff       	call   3526 <bigfile>
  subdir();
    496a:	e8 69 e3 ff ff       	call   2cd8 <subdir>
  concreate();
    496f:	e8 16 dd ff ff       	call   268a <concreate>
  linkunlink();
    4974:	e8 c4 e0 ff ff       	call   2a3d <linkunlink>
  linktest();
    4979:	e8 c3 da ff ff       	call   2441 <linktest>
  unlinkread();
    497e:	e8 e9 d8 ff ff       	call   226c <unlinkread>
  createdelete();
    4983:	e8 33 d6 ff ff       	call   1fbb <createdelete>
  twofiles();
    4988:	e8 c6 d3 ff ff       	call   1d53 <twofiles>
  sharedfd();
    498d:	e8 c3 d1 ff ff       	call   1b55 <sharedfd>
  dirfile();
    4992:	e8 88 f0 ff ff       	call   3a1f <dirfile>
  iref();
    4997:	e8 c5 f2 ff ff       	call   3c61 <iref>
  forktest();
    499c:	e8 e4 f3 ff ff       	call   3d85 <forktest>
  bigdir(); // slow
    49a1:	e8 c5 e1 ff ff       	call   2b6b <bigdir>

  exectest();
    49a6:	e8 b2 cc ff ff       	call   165d <exectest>

  exit();
    49ab:	e8 68 02 00 00       	call   4c18 <exit>

000049b0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    49b0:	55                   	push   %ebp
    49b1:	89 e5                	mov    %esp,%ebp
    49b3:	57                   	push   %edi
    49b4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    49b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    49b8:	8b 55 10             	mov    0x10(%ebp),%edx
    49bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    49be:	89 cb                	mov    %ecx,%ebx
    49c0:	89 df                	mov    %ebx,%edi
    49c2:	89 d1                	mov    %edx,%ecx
    49c4:	fc                   	cld    
    49c5:	f3 aa                	rep stos %al,%es:(%edi)
    49c7:	89 ca                	mov    %ecx,%edx
    49c9:	89 fb                	mov    %edi,%ebx
    49cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
    49ce:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    49d1:	5b                   	pop    %ebx
    49d2:	5f                   	pop    %edi
    49d3:	5d                   	pop    %ebp
    49d4:	c3                   	ret    

000049d5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    49d5:	55                   	push   %ebp
    49d6:	89 e5                	mov    %esp,%ebp
    49d8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    49db:	8b 45 08             	mov    0x8(%ebp),%eax
    49de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    49e1:	90                   	nop
    49e2:	8b 45 08             	mov    0x8(%ebp),%eax
    49e5:	8d 50 01             	lea    0x1(%eax),%edx
    49e8:	89 55 08             	mov    %edx,0x8(%ebp)
    49eb:	8b 55 0c             	mov    0xc(%ebp),%edx
    49ee:	8d 4a 01             	lea    0x1(%edx),%ecx
    49f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    49f4:	0f b6 12             	movzbl (%edx),%edx
    49f7:	88 10                	mov    %dl,(%eax)
    49f9:	0f b6 00             	movzbl (%eax),%eax
    49fc:	84 c0                	test   %al,%al
    49fe:	75 e2                	jne    49e2 <strcpy+0xd>
    ;
  return os;
    4a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4a03:	c9                   	leave  
    4a04:	c3                   	ret    

00004a05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a05:	55                   	push   %ebp
    4a06:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    4a08:	eb 08                	jmp    4a12 <strcmp+0xd>
    p++, q++;
    4a0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4a0e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    4a12:	8b 45 08             	mov    0x8(%ebp),%eax
    4a15:	0f b6 00             	movzbl (%eax),%eax
    4a18:	84 c0                	test   %al,%al
    4a1a:	74 10                	je     4a2c <strcmp+0x27>
    4a1c:	8b 45 08             	mov    0x8(%ebp),%eax
    4a1f:	0f b6 10             	movzbl (%eax),%edx
    4a22:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a25:	0f b6 00             	movzbl (%eax),%eax
    4a28:	38 c2                	cmp    %al,%dl
    4a2a:	74 de                	je     4a0a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    4a2c:	8b 45 08             	mov    0x8(%ebp),%eax
    4a2f:	0f b6 00             	movzbl (%eax),%eax
    4a32:	0f b6 d0             	movzbl %al,%edx
    4a35:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a38:	0f b6 00             	movzbl (%eax),%eax
    4a3b:	0f b6 c0             	movzbl %al,%eax
    4a3e:	29 c2                	sub    %eax,%edx
    4a40:	89 d0                	mov    %edx,%eax
}
    4a42:	5d                   	pop    %ebp
    4a43:	c3                   	ret    

00004a44 <strlen>:

uint
strlen(char *s)
{
    4a44:	55                   	push   %ebp
    4a45:	89 e5                	mov    %esp,%ebp
    4a47:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    4a4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    4a51:	eb 04                	jmp    4a57 <strlen+0x13>
    4a53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    4a57:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4a5a:	8b 45 08             	mov    0x8(%ebp),%eax
    4a5d:	01 d0                	add    %edx,%eax
    4a5f:	0f b6 00             	movzbl (%eax),%eax
    4a62:	84 c0                	test   %al,%al
    4a64:	75 ed                	jne    4a53 <strlen+0xf>
    ;
  return n;
    4a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4a69:	c9                   	leave  
    4a6a:	c3                   	ret    

00004a6b <memset>:

void*
memset(void *dst, int c, uint n)
{
    4a6b:	55                   	push   %ebp
    4a6c:	89 e5                	mov    %esp,%ebp
    4a6e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    4a71:	8b 45 10             	mov    0x10(%ebp),%eax
    4a74:	89 44 24 08          	mov    %eax,0x8(%esp)
    4a78:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
    4a7f:	8b 45 08             	mov    0x8(%ebp),%eax
    4a82:	89 04 24             	mov    %eax,(%esp)
    4a85:	e8 26 ff ff ff       	call   49b0 <stosb>
  return dst;
    4a8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4a8d:	c9                   	leave  
    4a8e:	c3                   	ret    

00004a8f <strchr>:

char*
strchr(const char *s, char c)
{
    4a8f:	55                   	push   %ebp
    4a90:	89 e5                	mov    %esp,%ebp
    4a92:	83 ec 04             	sub    $0x4,%esp
    4a95:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a98:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    4a9b:	eb 14                	jmp    4ab1 <strchr+0x22>
    if(*s == c)
    4a9d:	8b 45 08             	mov    0x8(%ebp),%eax
    4aa0:	0f b6 00             	movzbl (%eax),%eax
    4aa3:	3a 45 fc             	cmp    -0x4(%ebp),%al
    4aa6:	75 05                	jne    4aad <strchr+0x1e>
      return (char*)s;
    4aa8:	8b 45 08             	mov    0x8(%ebp),%eax
    4aab:	eb 13                	jmp    4ac0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    4aad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4ab1:	8b 45 08             	mov    0x8(%ebp),%eax
    4ab4:	0f b6 00             	movzbl (%eax),%eax
    4ab7:	84 c0                	test   %al,%al
    4ab9:	75 e2                	jne    4a9d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    4abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4ac0:	c9                   	leave  
    4ac1:	c3                   	ret    

00004ac2 <gets>:

char*
gets(char *buf, int max)
{
    4ac2:	55                   	push   %ebp
    4ac3:	89 e5                	mov    %esp,%ebp
    4ac5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4acf:	eb 4c                	jmp    4b1d <gets+0x5b>
    cc = read(0, &c, 1);
    4ad1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4ad8:	00 
    4ad9:	8d 45 ef             	lea    -0x11(%ebp),%eax
    4adc:	89 44 24 04          	mov    %eax,0x4(%esp)
    4ae0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4ae7:	e8 44 01 00 00       	call   4c30 <read>
    4aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    4aef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4af3:	7f 02                	jg     4af7 <gets+0x35>
      break;
    4af5:	eb 31                	jmp    4b28 <gets+0x66>
    buf[i++] = c;
    4af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4afa:	8d 50 01             	lea    0x1(%eax),%edx
    4afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4b00:	89 c2                	mov    %eax,%edx
    4b02:	8b 45 08             	mov    0x8(%ebp),%eax
    4b05:	01 c2                	add    %eax,%edx
    4b07:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4b0b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    4b0d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4b11:	3c 0a                	cmp    $0xa,%al
    4b13:	74 13                	je     4b28 <gets+0x66>
    4b15:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4b19:	3c 0d                	cmp    $0xd,%al
    4b1b:	74 0b                	je     4b28 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b20:	83 c0 01             	add    $0x1,%eax
    4b23:	3b 45 0c             	cmp    0xc(%ebp),%eax
    4b26:	7c a9                	jl     4ad1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    4b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4b2b:	8b 45 08             	mov    0x8(%ebp),%eax
    4b2e:	01 d0                	add    %edx,%eax
    4b30:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    4b33:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4b36:	c9                   	leave  
    4b37:	c3                   	ret    

00004b38 <stat>:

int
stat(char *n, struct stat *st)
{
    4b38:	55                   	push   %ebp
    4b39:	89 e5                	mov    %esp,%ebp
    4b3b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4b3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4b45:	00 
    4b46:	8b 45 08             	mov    0x8(%ebp),%eax
    4b49:	89 04 24             	mov    %eax,(%esp)
    4b4c:	e8 07 01 00 00       	call   4c58 <open>
    4b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    4b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4b58:	79 07                	jns    4b61 <stat+0x29>
    return -1;
    4b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    4b5f:	eb 23                	jmp    4b84 <stat+0x4c>
  r = fstat(fd, st);
    4b61:	8b 45 0c             	mov    0xc(%ebp),%eax
    4b64:	89 44 24 04          	mov    %eax,0x4(%esp)
    4b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b6b:	89 04 24             	mov    %eax,(%esp)
    4b6e:	e8 fd 00 00 00       	call   4c70 <fstat>
    4b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    4b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b79:	89 04 24             	mov    %eax,(%esp)
    4b7c:	e8 bf 00 00 00       	call   4c40 <close>
  return r;
    4b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    4b84:	c9                   	leave  
    4b85:	c3                   	ret    

00004b86 <atoi>:

int
atoi(const char *s)
{
    4b86:	55                   	push   %ebp
    4b87:	89 e5                	mov    %esp,%ebp
    4b89:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    4b8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4b93:	eb 25                	jmp    4bba <atoi+0x34>
    n = n*10 + *s++ - '0';
    4b95:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4b98:	89 d0                	mov    %edx,%eax
    4b9a:	c1 e0 02             	shl    $0x2,%eax
    4b9d:	01 d0                	add    %edx,%eax
    4b9f:	01 c0                	add    %eax,%eax
    4ba1:	89 c1                	mov    %eax,%ecx
    4ba3:	8b 45 08             	mov    0x8(%ebp),%eax
    4ba6:	8d 50 01             	lea    0x1(%eax),%edx
    4ba9:	89 55 08             	mov    %edx,0x8(%ebp)
    4bac:	0f b6 00             	movzbl (%eax),%eax
    4baf:	0f be c0             	movsbl %al,%eax
    4bb2:	01 c8                	add    %ecx,%eax
    4bb4:	83 e8 30             	sub    $0x30,%eax
    4bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4bba:	8b 45 08             	mov    0x8(%ebp),%eax
    4bbd:	0f b6 00             	movzbl (%eax),%eax
    4bc0:	3c 2f                	cmp    $0x2f,%al
    4bc2:	7e 0a                	jle    4bce <atoi+0x48>
    4bc4:	8b 45 08             	mov    0x8(%ebp),%eax
    4bc7:	0f b6 00             	movzbl (%eax),%eax
    4bca:	3c 39                	cmp    $0x39,%al
    4bcc:	7e c7                	jle    4b95 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    4bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4bd1:	c9                   	leave  
    4bd2:	c3                   	ret    

00004bd3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    4bd3:	55                   	push   %ebp
    4bd4:	89 e5                	mov    %esp,%ebp
    4bd6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    4bd9:	8b 45 08             	mov    0x8(%ebp),%eax
    4bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    4bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
    4be2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    4be5:	eb 17                	jmp    4bfe <memmove+0x2b>
    *dst++ = *src++;
    4be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4bea:	8d 50 01             	lea    0x1(%eax),%edx
    4bed:	89 55 fc             	mov    %edx,-0x4(%ebp)
    4bf0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4bf3:	8d 4a 01             	lea    0x1(%edx),%ecx
    4bf6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    4bf9:	0f b6 12             	movzbl (%edx),%edx
    4bfc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4bfe:	8b 45 10             	mov    0x10(%ebp),%eax
    4c01:	8d 50 ff             	lea    -0x1(%eax),%edx
    4c04:	89 55 10             	mov    %edx,0x10(%ebp)
    4c07:	85 c0                	test   %eax,%eax
    4c09:	7f dc                	jg     4be7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    4c0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4c0e:	c9                   	leave  
    4c0f:	c3                   	ret    

00004c10 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4c10:	b8 01 00 00 00       	mov    $0x1,%eax
    4c15:	cd 40                	int    $0x40
    4c17:	c3                   	ret    

00004c18 <exit>:
SYSCALL(exit)
    4c18:	b8 02 00 00 00       	mov    $0x2,%eax
    4c1d:	cd 40                	int    $0x40
    4c1f:	c3                   	ret    

00004c20 <wait>:
SYSCALL(wait)
    4c20:	b8 03 00 00 00       	mov    $0x3,%eax
    4c25:	cd 40                	int    $0x40
    4c27:	c3                   	ret    

00004c28 <pipe>:
SYSCALL(pipe)
    4c28:	b8 04 00 00 00       	mov    $0x4,%eax
    4c2d:	cd 40                	int    $0x40
    4c2f:	c3                   	ret    

00004c30 <read>:
SYSCALL(read)
    4c30:	b8 05 00 00 00       	mov    $0x5,%eax
    4c35:	cd 40                	int    $0x40
    4c37:	c3                   	ret    

00004c38 <write>:
SYSCALL(write)
    4c38:	b8 10 00 00 00       	mov    $0x10,%eax
    4c3d:	cd 40                	int    $0x40
    4c3f:	c3                   	ret    

00004c40 <close>:
SYSCALL(close)
    4c40:	b8 15 00 00 00       	mov    $0x15,%eax
    4c45:	cd 40                	int    $0x40
    4c47:	c3                   	ret    

00004c48 <kill>:
SYSCALL(kill)
    4c48:	b8 06 00 00 00       	mov    $0x6,%eax
    4c4d:	cd 40                	int    $0x40
    4c4f:	c3                   	ret    

00004c50 <exec>:
SYSCALL(exec)
    4c50:	b8 07 00 00 00       	mov    $0x7,%eax
    4c55:	cd 40                	int    $0x40
    4c57:	c3                   	ret    

00004c58 <open>:
SYSCALL(open)
    4c58:	b8 0f 00 00 00       	mov    $0xf,%eax
    4c5d:	cd 40                	int    $0x40
    4c5f:	c3                   	ret    

00004c60 <mknod>:
SYSCALL(mknod)
    4c60:	b8 11 00 00 00       	mov    $0x11,%eax
    4c65:	cd 40                	int    $0x40
    4c67:	c3                   	ret    

00004c68 <unlink>:
SYSCALL(unlink)
    4c68:	b8 12 00 00 00       	mov    $0x12,%eax
    4c6d:	cd 40                	int    $0x40
    4c6f:	c3                   	ret    

00004c70 <fstat>:
SYSCALL(fstat)
    4c70:	b8 08 00 00 00       	mov    $0x8,%eax
    4c75:	cd 40                	int    $0x40
    4c77:	c3                   	ret    

00004c78 <link>:
SYSCALL(link)
    4c78:	b8 13 00 00 00       	mov    $0x13,%eax
    4c7d:	cd 40                	int    $0x40
    4c7f:	c3                   	ret    

00004c80 <mkdir>:
SYSCALL(mkdir)
    4c80:	b8 14 00 00 00       	mov    $0x14,%eax
    4c85:	cd 40                	int    $0x40
    4c87:	c3                   	ret    

00004c88 <chdir>:
SYSCALL(chdir)
    4c88:	b8 09 00 00 00       	mov    $0x9,%eax
    4c8d:	cd 40                	int    $0x40
    4c8f:	c3                   	ret    

00004c90 <dup>:
SYSCALL(dup)
    4c90:	b8 0a 00 00 00       	mov    $0xa,%eax
    4c95:	cd 40                	int    $0x40
    4c97:	c3                   	ret    

00004c98 <getpid>:
SYSCALL(getpid)
    4c98:	b8 0b 00 00 00       	mov    $0xb,%eax
    4c9d:	cd 40                	int    $0x40
    4c9f:	c3                   	ret    

00004ca0 <sbrk>:
SYSCALL(sbrk)
    4ca0:	b8 0c 00 00 00       	mov    $0xc,%eax
    4ca5:	cd 40                	int    $0x40
    4ca7:	c3                   	ret    

00004ca8 <sleep>:
SYSCALL(sleep)
    4ca8:	b8 0d 00 00 00       	mov    $0xd,%eax
    4cad:	cd 40                	int    $0x40
    4caf:	c3                   	ret    

00004cb0 <uptime>:
SYSCALL(uptime)
    4cb0:	b8 0e 00 00 00       	mov    $0xe,%eax
    4cb5:	cd 40                	int    $0x40
    4cb7:	c3                   	ret    

00004cb8 <clone>:
SYSCALL(clone)
    4cb8:	b8 16 00 00 00       	mov    $0x16,%eax
    4cbd:	cd 40                	int    $0x40
    4cbf:	c3                   	ret    

00004cc0 <texit>:
SYSCALL(texit)
    4cc0:	b8 17 00 00 00       	mov    $0x17,%eax
    4cc5:	cd 40                	int    $0x40
    4cc7:	c3                   	ret    

00004cc8 <tsleep>:
SYSCALL(tsleep)
    4cc8:	b8 18 00 00 00       	mov    $0x18,%eax
    4ccd:	cd 40                	int    $0x40
    4ccf:	c3                   	ret    

00004cd0 <twakeup>:
SYSCALL(twakeup)
    4cd0:	b8 19 00 00 00       	mov    $0x19,%eax
    4cd5:	cd 40                	int    $0x40
    4cd7:	c3                   	ret    

00004cd8 <thread_yield>:
SYSCALL(thread_yield)
    4cd8:	b8 1a 00 00 00       	mov    $0x1a,%eax
    4cdd:	cd 40                	int    $0x40
    4cdf:	c3                   	ret    

00004ce0 <thread_yield3>:
    4ce0:	b8 1a 00 00 00       	mov    $0x1a,%eax
    4ce5:	cd 40                	int    $0x40
    4ce7:	c3                   	ret    

00004ce8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4ce8:	55                   	push   %ebp
    4ce9:	89 e5                	mov    %esp,%ebp
    4ceb:	83 ec 18             	sub    $0x18,%esp
    4cee:	8b 45 0c             	mov    0xc(%ebp),%eax
    4cf1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    4cf4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4cfb:	00 
    4cfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    4cff:	89 44 24 04          	mov    %eax,0x4(%esp)
    4d03:	8b 45 08             	mov    0x8(%ebp),%eax
    4d06:	89 04 24             	mov    %eax,(%esp)
    4d09:	e8 2a ff ff ff       	call   4c38 <write>
}
    4d0e:	c9                   	leave  
    4d0f:	c3                   	ret    

00004d10 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4d10:	55                   	push   %ebp
    4d11:	89 e5                	mov    %esp,%ebp
    4d13:	56                   	push   %esi
    4d14:	53                   	push   %ebx
    4d15:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    4d18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    4d1f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    4d23:	74 17                	je     4d3c <printint+0x2c>
    4d25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    4d29:	79 11                	jns    4d3c <printint+0x2c>
    neg = 1;
    4d2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    4d32:	8b 45 0c             	mov    0xc(%ebp),%eax
    4d35:	f7 d8                	neg    %eax
    4d37:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4d3a:	eb 06                	jmp    4d42 <printint+0x32>
  } else {
    x = xx;
    4d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
    4d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    4d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    4d49:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4d4c:	8d 41 01             	lea    0x1(%ecx),%eax
    4d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4d58:	ba 00 00 00 00       	mov    $0x0,%edx
    4d5d:	f7 f3                	div    %ebx
    4d5f:	89 d0                	mov    %edx,%eax
    4d61:	0f b6 80 30 74 00 00 	movzbl 0x7430(%eax),%eax
    4d68:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    4d6c:	8b 75 10             	mov    0x10(%ebp),%esi
    4d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4d72:	ba 00 00 00 00       	mov    $0x0,%edx
    4d77:	f7 f6                	div    %esi
    4d79:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4d7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4d80:	75 c7                	jne    4d49 <printint+0x39>
  if(neg)
    4d82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4d86:	74 10                	je     4d98 <printint+0x88>
    buf[i++] = '-';
    4d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4d8b:	8d 50 01             	lea    0x1(%eax),%edx
    4d8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4d91:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4d96:	eb 1f                	jmp    4db7 <printint+0xa7>
    4d98:	eb 1d                	jmp    4db7 <printint+0xa7>
    putc(fd, buf[i]);
    4d9a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4da0:	01 d0                	add    %edx,%eax
    4da2:	0f b6 00             	movzbl (%eax),%eax
    4da5:	0f be c0             	movsbl %al,%eax
    4da8:	89 44 24 04          	mov    %eax,0x4(%esp)
    4dac:	8b 45 08             	mov    0x8(%ebp),%eax
    4daf:	89 04 24             	mov    %eax,(%esp)
    4db2:	e8 31 ff ff ff       	call   4ce8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4db7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4dbf:	79 d9                	jns    4d9a <printint+0x8a>
    putc(fd, buf[i]);
}
    4dc1:	83 c4 30             	add    $0x30,%esp
    4dc4:	5b                   	pop    %ebx
    4dc5:	5e                   	pop    %esi
    4dc6:	5d                   	pop    %ebp
    4dc7:	c3                   	ret    

00004dc8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4dc8:	55                   	push   %ebp
    4dc9:	89 e5                	mov    %esp,%ebp
    4dcb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4dce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4dd5:	8d 45 0c             	lea    0xc(%ebp),%eax
    4dd8:	83 c0 04             	add    $0x4,%eax
    4ddb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4dde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4de5:	e9 7c 01 00 00       	jmp    4f66 <printf+0x19e>
    c = fmt[i] & 0xff;
    4dea:	8b 55 0c             	mov    0xc(%ebp),%edx
    4ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4df0:	01 d0                	add    %edx,%eax
    4df2:	0f b6 00             	movzbl (%eax),%eax
    4df5:	0f be c0             	movsbl %al,%eax
    4df8:	25 ff 00 00 00       	and    $0xff,%eax
    4dfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4e00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4e04:	75 2c                	jne    4e32 <printf+0x6a>
      if(c == '%'){
    4e06:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4e0a:	75 0c                	jne    4e18 <printf+0x50>
        state = '%';
    4e0c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4e13:	e9 4a 01 00 00       	jmp    4f62 <printf+0x19a>
      } else {
        putc(fd, c);
    4e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4e1b:	0f be c0             	movsbl %al,%eax
    4e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e22:	8b 45 08             	mov    0x8(%ebp),%eax
    4e25:	89 04 24             	mov    %eax,(%esp)
    4e28:	e8 bb fe ff ff       	call   4ce8 <putc>
    4e2d:	e9 30 01 00 00       	jmp    4f62 <printf+0x19a>
      }
    } else if(state == '%'){
    4e32:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    4e36:	0f 85 26 01 00 00    	jne    4f62 <printf+0x19a>
      if(c == 'd'){
    4e3c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    4e40:	75 2d                	jne    4e6f <printf+0xa7>
        printint(fd, *ap, 10, 1);
    4e42:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4e45:	8b 00                	mov    (%eax),%eax
    4e47:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    4e4e:	00 
    4e4f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    4e56:	00 
    4e57:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e5b:	8b 45 08             	mov    0x8(%ebp),%eax
    4e5e:	89 04 24             	mov    %eax,(%esp)
    4e61:	e8 aa fe ff ff       	call   4d10 <printint>
        ap++;
    4e66:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4e6a:	e9 ec 00 00 00       	jmp    4f5b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    4e6f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4e73:	74 06                	je     4e7b <printf+0xb3>
    4e75:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4e79:	75 2d                	jne    4ea8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    4e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4e7e:	8b 00                	mov    (%eax),%eax
    4e80:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4e87:	00 
    4e88:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4e8f:	00 
    4e90:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e94:	8b 45 08             	mov    0x8(%ebp),%eax
    4e97:	89 04 24             	mov    %eax,(%esp)
    4e9a:	e8 71 fe ff ff       	call   4d10 <printint>
        ap++;
    4e9f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4ea3:	e9 b3 00 00 00       	jmp    4f5b <printf+0x193>
      } else if(c == 's'){
    4ea8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    4eac:	75 45                	jne    4ef3 <printf+0x12b>
        s = (char*)*ap;
    4eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4eb1:	8b 00                	mov    (%eax),%eax
    4eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4eb6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4ebe:	75 09                	jne    4ec9 <printf+0x101>
          s = "(null)";
    4ec0:	c7 45 f4 ce 6b 00 00 	movl   $0x6bce,-0xc(%ebp)
        while(*s != 0){
    4ec7:	eb 1e                	jmp    4ee7 <printf+0x11f>
    4ec9:	eb 1c                	jmp    4ee7 <printf+0x11f>
          putc(fd, *s);
    4ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ece:	0f b6 00             	movzbl (%eax),%eax
    4ed1:	0f be c0             	movsbl %al,%eax
    4ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
    4ed8:	8b 45 08             	mov    0x8(%ebp),%eax
    4edb:	89 04 24             	mov    %eax,(%esp)
    4ede:	e8 05 fe ff ff       	call   4ce8 <putc>
          s++;
    4ee3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4eea:	0f b6 00             	movzbl (%eax),%eax
    4eed:	84 c0                	test   %al,%al
    4eef:	75 da                	jne    4ecb <printf+0x103>
    4ef1:	eb 68                	jmp    4f5b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4ef3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4ef7:	75 1d                	jne    4f16 <printf+0x14e>
        putc(fd, *ap);
    4ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4efc:	8b 00                	mov    (%eax),%eax
    4efe:	0f be c0             	movsbl %al,%eax
    4f01:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f05:	8b 45 08             	mov    0x8(%ebp),%eax
    4f08:	89 04 24             	mov    %eax,(%esp)
    4f0b:	e8 d8 fd ff ff       	call   4ce8 <putc>
        ap++;
    4f10:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4f14:	eb 45                	jmp    4f5b <printf+0x193>
      } else if(c == '%'){
    4f16:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4f1a:	75 17                	jne    4f33 <printf+0x16b>
        putc(fd, c);
    4f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4f1f:	0f be c0             	movsbl %al,%eax
    4f22:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f26:	8b 45 08             	mov    0x8(%ebp),%eax
    4f29:	89 04 24             	mov    %eax,(%esp)
    4f2c:	e8 b7 fd ff ff       	call   4ce8 <putc>
    4f31:	eb 28                	jmp    4f5b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4f33:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    4f3a:	00 
    4f3b:	8b 45 08             	mov    0x8(%ebp),%eax
    4f3e:	89 04 24             	mov    %eax,(%esp)
    4f41:	e8 a2 fd ff ff       	call   4ce8 <putc>
        putc(fd, c);
    4f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4f49:	0f be c0             	movsbl %al,%eax
    4f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f50:	8b 45 08             	mov    0x8(%ebp),%eax
    4f53:	89 04 24             	mov    %eax,(%esp)
    4f56:	e8 8d fd ff ff       	call   4ce8 <putc>
      }
      state = 0;
    4f5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4f62:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4f66:	8b 55 0c             	mov    0xc(%ebp),%edx
    4f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4f6c:	01 d0                	add    %edx,%eax
    4f6e:	0f b6 00             	movzbl (%eax),%eax
    4f71:	84 c0                	test   %al,%al
    4f73:	0f 85 71 fe ff ff    	jne    4dea <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4f79:	c9                   	leave  
    4f7a:	c3                   	ret    

00004f7b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4f7b:	55                   	push   %ebp
    4f7c:	89 e5                	mov    %esp,%ebp
    4f7e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4f81:	8b 45 08             	mov    0x8(%ebp),%eax
    4f84:	83 e8 08             	sub    $0x8,%eax
    4f87:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f8a:	a1 e8 74 00 00       	mov    0x74e8,%eax
    4f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4f92:	eb 24                	jmp    4fb8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4f97:	8b 00                	mov    (%eax),%eax
    4f99:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4f9c:	77 12                	ja     4fb0 <free+0x35>
    4f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fa1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4fa4:	77 24                	ja     4fca <free+0x4f>
    4fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fa9:	8b 00                	mov    (%eax),%eax
    4fab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4fae:	77 1a                	ja     4fca <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fb3:	8b 00                	mov    (%eax),%eax
    4fb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4fb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fbb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4fbe:	76 d4                	jbe    4f94 <free+0x19>
    4fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fc3:	8b 00                	mov    (%eax),%eax
    4fc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4fc8:	76 ca                	jbe    4f94 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fcd:	8b 40 04             	mov    0x4(%eax),%eax
    4fd0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fda:	01 c2                	add    %eax,%edx
    4fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fdf:	8b 00                	mov    (%eax),%eax
    4fe1:	39 c2                	cmp    %eax,%edx
    4fe3:	75 24                	jne    5009 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fe8:	8b 50 04             	mov    0x4(%eax),%edx
    4feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fee:	8b 00                	mov    (%eax),%eax
    4ff0:	8b 40 04             	mov    0x4(%eax),%eax
    4ff3:	01 c2                	add    %eax,%edx
    4ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4ff8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4ffe:	8b 00                	mov    (%eax),%eax
    5000:	8b 10                	mov    (%eax),%edx
    5002:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5005:	89 10                	mov    %edx,(%eax)
    5007:	eb 0a                	jmp    5013 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    5009:	8b 45 fc             	mov    -0x4(%ebp),%eax
    500c:	8b 10                	mov    (%eax),%edx
    500e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5011:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    5013:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5016:	8b 40 04             	mov    0x4(%eax),%eax
    5019:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    5020:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5023:	01 d0                	add    %edx,%eax
    5025:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    5028:	75 20                	jne    504a <free+0xcf>
    p->s.size += bp->s.size;
    502a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    502d:	8b 50 04             	mov    0x4(%eax),%edx
    5030:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5033:	8b 40 04             	mov    0x4(%eax),%eax
    5036:	01 c2                	add    %eax,%edx
    5038:	8b 45 fc             	mov    -0x4(%ebp),%eax
    503b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    503e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5041:	8b 10                	mov    (%eax),%edx
    5043:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5046:	89 10                	mov    %edx,(%eax)
    5048:	eb 08                	jmp    5052 <free+0xd7>
  } else
    p->s.ptr = bp;
    504a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    504d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    5050:	89 10                	mov    %edx,(%eax)
  freep = p;
    5052:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5055:	a3 e8 74 00 00       	mov    %eax,0x74e8
}
    505a:	c9                   	leave  
    505b:	c3                   	ret    

0000505c <morecore>:

static Header*
morecore(uint nu)
{
    505c:	55                   	push   %ebp
    505d:	89 e5                	mov    %esp,%ebp
    505f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    5062:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    5069:	77 07                	ja     5072 <morecore+0x16>
    nu = 4096;
    506b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    5072:	8b 45 08             	mov    0x8(%ebp),%eax
    5075:	c1 e0 03             	shl    $0x3,%eax
    5078:	89 04 24             	mov    %eax,(%esp)
    507b:	e8 20 fc ff ff       	call   4ca0 <sbrk>
    5080:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    5083:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    5087:	75 07                	jne    5090 <morecore+0x34>
    return 0;
    5089:	b8 00 00 00 00       	mov    $0x0,%eax
    508e:	eb 22                	jmp    50b2 <morecore+0x56>
  hp = (Header*)p;
    5090:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5093:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    5096:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5099:	8b 55 08             	mov    0x8(%ebp),%edx
    509c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    509f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    50a2:	83 c0 08             	add    $0x8,%eax
    50a5:	89 04 24             	mov    %eax,(%esp)
    50a8:	e8 ce fe ff ff       	call   4f7b <free>
  return freep;
    50ad:	a1 e8 74 00 00       	mov    0x74e8,%eax
}
    50b2:	c9                   	leave  
    50b3:	c3                   	ret    

000050b4 <malloc>:

void*
malloc(uint nbytes)
{
    50b4:	55                   	push   %ebp
    50b5:	89 e5                	mov    %esp,%ebp
    50b7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    50ba:	8b 45 08             	mov    0x8(%ebp),%eax
    50bd:	83 c0 07             	add    $0x7,%eax
    50c0:	c1 e8 03             	shr    $0x3,%eax
    50c3:	83 c0 01             	add    $0x1,%eax
    50c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    50c9:	a1 e8 74 00 00       	mov    0x74e8,%eax
    50ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    50d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    50d5:	75 23                	jne    50fa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    50d7:	c7 45 f0 e0 74 00 00 	movl   $0x74e0,-0x10(%ebp)
    50de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    50e1:	a3 e8 74 00 00       	mov    %eax,0x74e8
    50e6:	a1 e8 74 00 00       	mov    0x74e8,%eax
    50eb:	a3 e0 74 00 00       	mov    %eax,0x74e0
    base.s.size = 0;
    50f0:	c7 05 e4 74 00 00 00 	movl   $0x0,0x74e4
    50f7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    50fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    50fd:	8b 00                	mov    (%eax),%eax
    50ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    5102:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5105:	8b 40 04             	mov    0x4(%eax),%eax
    5108:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    510b:	72 4d                	jb     515a <malloc+0xa6>
      if(p->s.size == nunits)
    510d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5110:	8b 40 04             	mov    0x4(%eax),%eax
    5113:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    5116:	75 0c                	jne    5124 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    5118:	8b 45 f4             	mov    -0xc(%ebp),%eax
    511b:	8b 10                	mov    (%eax),%edx
    511d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5120:	89 10                	mov    %edx,(%eax)
    5122:	eb 26                	jmp    514a <malloc+0x96>
      else {
        p->s.size -= nunits;
    5124:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5127:	8b 40 04             	mov    0x4(%eax),%eax
    512a:	2b 45 ec             	sub    -0x14(%ebp),%eax
    512d:	89 c2                	mov    %eax,%edx
    512f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5132:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    5135:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5138:	8b 40 04             	mov    0x4(%eax),%eax
    513b:	c1 e0 03             	shl    $0x3,%eax
    513e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    5141:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5144:	8b 55 ec             	mov    -0x14(%ebp),%edx
    5147:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    514a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    514d:	a3 e8 74 00 00       	mov    %eax,0x74e8
      return (void*)(p + 1);
    5152:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5155:	83 c0 08             	add    $0x8,%eax
    5158:	eb 38                	jmp    5192 <malloc+0xde>
    }
    if(p == freep)
    515a:	a1 e8 74 00 00       	mov    0x74e8,%eax
    515f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    5162:	75 1b                	jne    517f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    5164:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5167:	89 04 24             	mov    %eax,(%esp)
    516a:	e8 ed fe ff ff       	call   505c <morecore>
    516f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    5172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    5176:	75 07                	jne    517f <malloc+0xcb>
        return 0;
    5178:	b8 00 00 00 00       	mov    $0x0,%eax
    517d:	eb 13                	jmp    5192 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    517f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5182:	89 45 f0             	mov    %eax,-0x10(%ebp)
    5185:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5188:	8b 00                	mov    (%eax),%eax
    518a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    518d:	e9 70 ff ff ff       	jmp    5102 <malloc+0x4e>
}
    5192:	c9                   	leave  
    5193:	c3                   	ret    

00005194 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    5194:	55                   	push   %ebp
    5195:	89 e5                	mov    %esp,%ebp
    5197:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    519a:	8b 55 08             	mov    0x8(%ebp),%edx
    519d:	8b 45 0c             	mov    0xc(%ebp),%eax
    51a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    51a3:	f0 87 02             	lock xchg %eax,(%edx)
    51a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    51a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    51ac:	c9                   	leave  
    51ad:	c3                   	ret    

000051ae <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    51ae:	55                   	push   %ebp
    51af:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    51b1:	8b 45 08             	mov    0x8(%ebp),%eax
    51b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    51ba:	5d                   	pop    %ebp
    51bb:	c3                   	ret    

000051bc <lock_acquire>:
void lock_acquire(lock_t *lock){
    51bc:	55                   	push   %ebp
    51bd:	89 e5                	mov    %esp,%ebp
    51bf:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    51c2:	90                   	nop
    51c3:	8b 45 08             	mov    0x8(%ebp),%eax
    51c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    51cd:	00 
    51ce:	89 04 24             	mov    %eax,(%esp)
    51d1:	e8 be ff ff ff       	call   5194 <xchg>
    51d6:	85 c0                	test   %eax,%eax
    51d8:	75 e9                	jne    51c3 <lock_acquire+0x7>
}
    51da:	c9                   	leave  
    51db:	c3                   	ret    

000051dc <lock_release>:
void lock_release(lock_t *lock){
    51dc:	55                   	push   %ebp
    51dd:	89 e5                	mov    %esp,%ebp
    51df:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    51e2:	8b 45 08             	mov    0x8(%ebp),%eax
    51e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    51ec:	00 
    51ed:	89 04 24             	mov    %eax,(%esp)
    51f0:	e8 9f ff ff ff       	call   5194 <xchg>
}
    51f5:	c9                   	leave  
    51f6:	c3                   	ret    

000051f7 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    51f7:	55                   	push   %ebp
    51f8:	89 e5                	mov    %esp,%ebp
    51fa:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    51fd:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    5204:	e8 ab fe ff ff       	call   50b4 <malloc>
    5209:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    520c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    520f:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    5212:	0f b6 05 ec 74 00 00 	movzbl 0x74ec,%eax
    5219:	84 c0                	test   %al,%al
    521b:	75 1c                	jne    5239 <thread_create+0x42>
        init_q(thQ2);
    521d:	a1 24 bc 00 00       	mov    0xbc24,%eax
    5222:	89 04 24             	mov    %eax,(%esp)
    5225:	e8 cd 01 00 00       	call   53f7 <init_q>
        inQ++;
    522a:	0f b6 05 ec 74 00 00 	movzbl 0x74ec,%eax
    5231:	83 c0 01             	add    $0x1,%eax
    5234:	a2 ec 74 00 00       	mov    %al,0x74ec
    }

    if((uint)stack % 4096){
    5239:	8b 45 f4             	mov    -0xc(%ebp),%eax
    523c:	25 ff 0f 00 00       	and    $0xfff,%eax
    5241:	85 c0                	test   %eax,%eax
    5243:	74 14                	je     5259 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    5245:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5248:	25 ff 0f 00 00       	and    $0xfff,%eax
    524d:	89 c2                	mov    %eax,%edx
    524f:	b8 00 10 00 00       	mov    $0x1000,%eax
    5254:	29 d0                	sub    %edx,%eax
    5256:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    5259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    525d:	75 1e                	jne    527d <thread_create+0x86>

        printf(1,"malloc fail \n");
    525f:	c7 44 24 04 d5 6b 00 	movl   $0x6bd5,0x4(%esp)
    5266:	00 
    5267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    526e:	e8 55 fb ff ff       	call   4dc8 <printf>
        return 0;
    5273:	b8 00 00 00 00       	mov    $0x0,%eax
    5278:	e9 9e 00 00 00       	jmp    531b <thread_create+0x124>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    527d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    5280:	8b 55 08             	mov    0x8(%ebp),%edx
    5283:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5286:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    528a:	89 54 24 08          	mov    %edx,0x8(%esp)
    528e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    5295:	00 
    5296:	89 04 24             	mov    %eax,(%esp)
    5299:	e8 1a fa ff ff       	call   4cb8 <clone>
    529e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1,"clone returned tid = %d\n",tid);
    52a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    52a4:	89 44 24 08          	mov    %eax,0x8(%esp)
    52a8:	c7 44 24 04 e3 6b 00 	movl   $0x6be3,0x4(%esp)
    52af:	00 
    52b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    52b7:	e8 0c fb ff ff       	call   4dc8 <printf>
    if(tid < 0){
    52bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    52c0:	79 1b                	jns    52dd <thread_create+0xe6>
        printf(1,"clone fails\n");
    52c2:	c7 44 24 04 fc 6b 00 	movl   $0x6bfc,0x4(%esp)
    52c9:	00 
    52ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    52d1:	e8 f2 fa ff ff       	call   4dc8 <printf>
        return 0;
    52d6:	b8 00 00 00 00       	mov    $0x0,%eax
    52db:	eb 3e                	jmp    531b <thread_create+0x124>
    }
    if(tid > 0){
    52dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    52e1:	7e 19                	jle    52fc <thread_create+0x105>
        //store threads on thread table
        add_q(thQ2, tid);
    52e3:	a1 24 bc 00 00       	mov    0xbc24,%eax
    52e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    52eb:	89 54 24 04          	mov    %edx,0x4(%esp)
    52ef:	89 04 24             	mov    %eax,(%esp)
    52f2:	e8 22 01 00 00       	call   5419 <add_q>
        return garbage_stack;
    52f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    52fa:	eb 1f                	jmp    531b <thread_create+0x124>
    }
    if(tid == 0){
    52fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    5300:	75 14                	jne    5316 <thread_create+0x11f>
        printf(1,"tid = 0 return \n");
    5302:	c7 44 24 04 09 6c 00 	movl   $0x6c09,0x4(%esp)
    5309:	00 
    530a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    5311:	e8 b2 fa ff ff       	call   4dc8 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    5316:	b8 00 00 00 00       	mov    $0x0,%eax
}
    531b:	c9                   	leave  
    531c:	c3                   	ret    

0000531d <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    531d:	55                   	push   %ebp
    531e:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    5320:	a1 44 74 00 00       	mov    0x7444,%eax
    5325:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    532b:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    5330:	a3 44 74 00 00       	mov    %eax,0x7444
    return (int)(rands % max);
    5335:	a1 44 74 00 00       	mov    0x7444,%eax
    533a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    533d:	ba 00 00 00 00       	mov    $0x0,%edx
    5342:	f7 f1                	div    %ecx
    5344:	89 d0                	mov    %edx,%eax
}
    5346:	5d                   	pop    %ebp
    5347:	c3                   	ret    

00005348 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    5348:	55                   	push   %ebp
    5349:	89 e5                	mov    %esp,%ebp
    534b:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    534e:	e8 45 f9 ff ff       	call   4c98 <getpid>
    5353:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    5356:	a1 24 bc 00 00       	mov    0xbc24,%eax
    535b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    535e:	89 54 24 04          	mov    %edx,0x4(%esp)
    5362:	89 04 24             	mov    %eax,(%esp)
    5365:	e8 af 00 00 00       	call   5419 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    536a:	a1 24 bc 00 00       	mov    0xbc24,%eax
    536f:	89 04 24             	mov    %eax,(%esp)
    5372:	e8 1c 01 00 00       	call   5493 <pop_q>
    5377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    537a:	a1 f0 74 00 00       	mov    0x74f0,%eax
    537f:	85 c0                	test   %eax,%eax
    5381:	75 1f                	jne    53a2 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    5383:	a1 24 bc 00 00       	mov    0xbc24,%eax
    5388:	89 04 24             	mov    %eax,(%esp)
    538b:	e8 03 01 00 00       	call   5493 <pop_q>
    5390:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    5393:	a1 f0 74 00 00       	mov    0x74f0,%eax
    5398:	83 c0 01             	add    $0x1,%eax
    539b:	a3 f0 74 00 00       	mov    %eax,0x74f0
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    53a0:	eb 12                	jmp    53b4 <thread_yield2+0x6c>
    53a2:	eb 10                	jmp    53b4 <thread_yield2+0x6c>
    53a4:	a1 24 bc 00 00       	mov    0xbc24,%eax
    53a9:	89 04 24             	mov    %eax,(%esp)
    53ac:	e8 e2 00 00 00       	call   5493 <pop_q>
    53b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    53b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    53b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    53ba:	74 e8                	je     53a4 <thread_yield2+0x5c>
    53bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    53c0:	74 e2                	je     53a4 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    53c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    53c5:	89 04 24             	mov    %eax,(%esp)
    53c8:	e8 03 f9 ff ff       	call   4cd0 <twakeup>
    tsleep();
    53cd:	e8 f6 f8 ff ff       	call   4cc8 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    53d2:	c9                   	leave  
    53d3:	c3                   	ret    

000053d4 <thread_yield_last>:

void thread_yield_last(){
    53d4:	55                   	push   %ebp
    53d5:	89 e5                	mov    %esp,%ebp
    53d7:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    53da:	a1 24 bc 00 00       	mov    0xbc24,%eax
    53df:	89 04 24             	mov    %eax,(%esp)
    53e2:	e8 ac 00 00 00       	call   5493 <pop_q>
    53e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    53ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    53ed:	89 04 24             	mov    %eax,(%esp)
    53f0:	e8 db f8 ff ff       	call   4cd0 <twakeup>
    53f5:	c9                   	leave  
    53f6:	c3                   	ret    

000053f7 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    53f7:	55                   	push   %ebp
    53f8:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    53fa:	8b 45 08             	mov    0x8(%ebp),%eax
    53fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    5403:	8b 45 08             	mov    0x8(%ebp),%eax
    5406:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    540d:	8b 45 08             	mov    0x8(%ebp),%eax
    5410:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    5417:	5d                   	pop    %ebp
    5418:	c3                   	ret    

00005419 <add_q>:

void add_q(struct queue *q, int v){
    5419:	55                   	push   %ebp
    541a:	89 e5                	mov    %esp,%ebp
    541c:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    541f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    5426:	e8 89 fc ff ff       	call   50b4 <malloc>
    542b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    542e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    5438:	8b 45 f4             	mov    -0xc(%ebp),%eax
    543b:	8b 55 0c             	mov    0xc(%ebp),%edx
    543e:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    5440:	8b 45 08             	mov    0x8(%ebp),%eax
    5443:	8b 40 04             	mov    0x4(%eax),%eax
    5446:	85 c0                	test   %eax,%eax
    5448:	75 0b                	jne    5455 <add_q+0x3c>
        q->head = n;
    544a:	8b 45 08             	mov    0x8(%ebp),%eax
    544d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    5450:	89 50 04             	mov    %edx,0x4(%eax)
    5453:	eb 0c                	jmp    5461 <add_q+0x48>
    }else{
        q->tail->next = n;
    5455:	8b 45 08             	mov    0x8(%ebp),%eax
    5458:	8b 40 08             	mov    0x8(%eax),%eax
    545b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    545e:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    5461:	8b 45 08             	mov    0x8(%ebp),%eax
    5464:	8b 55 f4             	mov    -0xc(%ebp),%edx
    5467:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    546a:	8b 45 08             	mov    0x8(%ebp),%eax
    546d:	8b 00                	mov    (%eax),%eax
    546f:	8d 50 01             	lea    0x1(%eax),%edx
    5472:	8b 45 08             	mov    0x8(%ebp),%eax
    5475:	89 10                	mov    %edx,(%eax)
}
    5477:	c9                   	leave  
    5478:	c3                   	ret    

00005479 <empty_q>:

int empty_q(struct queue *q){
    5479:	55                   	push   %ebp
    547a:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    547c:	8b 45 08             	mov    0x8(%ebp),%eax
    547f:	8b 00                	mov    (%eax),%eax
    5481:	85 c0                	test   %eax,%eax
    5483:	75 07                	jne    548c <empty_q+0x13>
        return 1;
    5485:	b8 01 00 00 00       	mov    $0x1,%eax
    548a:	eb 05                	jmp    5491 <empty_q+0x18>
    else
        return 0;
    548c:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    5491:	5d                   	pop    %ebp
    5492:	c3                   	ret    

00005493 <pop_q>:
int pop_q(struct queue *q){
    5493:	55                   	push   %ebp
    5494:	89 e5                	mov    %esp,%ebp
    5496:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    5499:	8b 45 08             	mov    0x8(%ebp),%eax
    549c:	89 04 24             	mov    %eax,(%esp)
    549f:	e8 d5 ff ff ff       	call   5479 <empty_q>
    54a4:	85 c0                	test   %eax,%eax
    54a6:	75 5d                	jne    5505 <pop_q+0x72>
       val = q->head->value; 
    54a8:	8b 45 08             	mov    0x8(%ebp),%eax
    54ab:	8b 40 04             	mov    0x4(%eax),%eax
    54ae:	8b 00                	mov    (%eax),%eax
    54b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    54b3:	8b 45 08             	mov    0x8(%ebp),%eax
    54b6:	8b 40 04             	mov    0x4(%eax),%eax
    54b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    54bc:	8b 45 08             	mov    0x8(%ebp),%eax
    54bf:	8b 40 04             	mov    0x4(%eax),%eax
    54c2:	8b 50 04             	mov    0x4(%eax),%edx
    54c5:	8b 45 08             	mov    0x8(%ebp),%eax
    54c8:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    54cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    54ce:	89 04 24             	mov    %eax,(%esp)
    54d1:	e8 a5 fa ff ff       	call   4f7b <free>
       q->size--;
    54d6:	8b 45 08             	mov    0x8(%ebp),%eax
    54d9:	8b 00                	mov    (%eax),%eax
    54db:	8d 50 ff             	lea    -0x1(%eax),%edx
    54de:	8b 45 08             	mov    0x8(%ebp),%eax
    54e1:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    54e3:	8b 45 08             	mov    0x8(%ebp),%eax
    54e6:	8b 00                	mov    (%eax),%eax
    54e8:	85 c0                	test   %eax,%eax
    54ea:	75 14                	jne    5500 <pop_q+0x6d>
            q->head = 0;
    54ec:	8b 45 08             	mov    0x8(%ebp),%eax
    54ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    54f6:	8b 45 08             	mov    0x8(%ebp),%eax
    54f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    5500:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5503:	eb 05                	jmp    550a <pop_q+0x77>
    }
    return -1;
    5505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    550a:	c9                   	leave  
    550b:	c3                   	ret    
