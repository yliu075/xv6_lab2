
_sh:     file format elf32-i386


Disassembly of section .text:

00001000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100a:	75 05                	jne    1011 <runcmd+0x11>
    exit();
    100c:	e8 50 0f 00 00       	call   1f61 <exit>
  
  switch(cmd->type){
    1011:	8b 45 08             	mov    0x8(%ebp),%eax
    1014:	8b 00                	mov    (%eax),%eax
    1016:	83 f8 05             	cmp    $0x5,%eax
    1019:	77 09                	ja     1024 <runcmd+0x24>
    101b:	8b 04 85 68 28 00 00 	mov    0x2868(,%eax,4),%eax
    1022:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
    1024:	c7 04 24 3c 28 00 00 	movl   $0x283c,(%esp)
    102b:	e8 27 03 00 00       	call   1357 <panic>

  case EXEC:
    //printf(1,"sh EXEC\n");
    ecmd = (struct execcmd*)cmd;
    1030:	8b 45 08             	mov    0x8(%ebp),%eax
    1033:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1039:	8b 40 04             	mov    0x4(%eax),%eax
    103c:	85 c0                	test   %eax,%eax
    103e:	75 05                	jne    1045 <runcmd+0x45>
      exit();
    1040:	e8 1c 0f 00 00       	call   1f61 <exit>
    exec(ecmd->argv[0], ecmd->argv);
    1045:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1048:	8d 50 04             	lea    0x4(%eax),%edx
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	8b 40 04             	mov    0x4(%eax),%eax
    1051:	89 54 24 04          	mov    %edx,0x4(%esp)
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 3c 0f 00 00       	call   1f99 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1060:	8b 40 04             	mov    0x4(%eax),%eax
    1063:	89 44 24 08          	mov    %eax,0x8(%esp)
    1067:	c7 44 24 04 43 28 00 	movl   $0x2843,0x4(%esp)
    106e:	00 
    106f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1076:	e8 96 10 00 00       	call   2111 <printf>
    break;
    107b:	e9 86 01 00 00       	jmp    1206 <runcmd+0x206>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    1080:	8b 45 08             	mov    0x8(%ebp),%eax
    1083:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
    1086:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1089:	8b 40 14             	mov    0x14(%eax),%eax
    108c:	89 04 24             	mov    %eax,(%esp)
    108f:	e8 f5 0e 00 00       	call   1f89 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    1094:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1097:	8b 50 10             	mov    0x10(%eax),%edx
    109a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    109d:	8b 40 08             	mov    0x8(%eax),%eax
    10a0:	89 54 24 04          	mov    %edx,0x4(%esp)
    10a4:	89 04 24             	mov    %eax,(%esp)
    10a7:	e8 f5 0e 00 00       	call   1fa1 <open>
    10ac:	85 c0                	test   %eax,%eax
    10ae:	79 23                	jns    10d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
    10b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b3:	8b 40 08             	mov    0x8(%eax),%eax
    10b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ba:	c7 44 24 04 53 28 00 	movl   $0x2853,0x4(%esp)
    10c1:	00 
    10c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10c9:	e8 43 10 00 00       	call   2111 <printf>
      exit();
    10ce:	e8 8e 0e 00 00       	call   1f61 <exit>
    }
    runcmd(rcmd->cmd);
    10d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10d6:	8b 40 04             	mov    0x4(%eax),%eax
    10d9:	89 04 24             	mov    %eax,(%esp)
    10dc:	e8 1f ff ff ff       	call   1000 <runcmd>
    break;
    10e1:	e9 20 01 00 00       	jmp    1206 <runcmd+0x206>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    10e6:	8b 45 08             	mov    0x8(%ebp),%eax
    10e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
    10ec:	e8 8c 02 00 00       	call   137d <fork1>
    10f1:	85 c0                	test   %eax,%eax
    10f3:	75 0e                	jne    1103 <runcmd+0x103>
      runcmd(lcmd->left);
    10f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10f8:	8b 40 04             	mov    0x4(%eax),%eax
    10fb:	89 04 24             	mov    %eax,(%esp)
    10fe:	e8 fd fe ff ff       	call   1000 <runcmd>
    wait();
    1103:	e8 61 0e 00 00       	call   1f69 <wait>
    runcmd(lcmd->right);
    1108:	8b 45 ec             	mov    -0x14(%ebp),%eax
    110b:	8b 40 08             	mov    0x8(%eax),%eax
    110e:	89 04 24             	mov    %eax,(%esp)
    1111:	e8 ea fe ff ff       	call   1000 <runcmd>
    break;
    1116:	e9 eb 00 00 00       	jmp    1206 <runcmd+0x206>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
    1121:	8d 45 dc             	lea    -0x24(%ebp),%eax
    1124:	89 04 24             	mov    %eax,(%esp)
    1127:	e8 45 0e 00 00       	call   1f71 <pipe>
    112c:	85 c0                	test   %eax,%eax
    112e:	79 0c                	jns    113c <runcmd+0x13c>
      panic("pipe");
    1130:	c7 04 24 63 28 00 00 	movl   $0x2863,(%esp)
    1137:	e8 1b 02 00 00       	call   1357 <panic>
    if(fork1() == 0){
    113c:	e8 3c 02 00 00       	call   137d <fork1>
    1141:	85 c0                	test   %eax,%eax
    1143:	75 3b                	jne    1180 <runcmd+0x180>
      close(1);
    1145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    114c:	e8 38 0e 00 00       	call   1f89 <close>
      dup(p[1]);
    1151:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1154:	89 04 24             	mov    %eax,(%esp)
    1157:	e8 7d 0e 00 00       	call   1fd9 <dup>
      close(p[0]);
    115c:	8b 45 dc             	mov    -0x24(%ebp),%eax
    115f:	89 04 24             	mov    %eax,(%esp)
    1162:	e8 22 0e 00 00       	call   1f89 <close>
      close(p[1]);
    1167:	8b 45 e0             	mov    -0x20(%ebp),%eax
    116a:	89 04 24             	mov    %eax,(%esp)
    116d:	e8 17 0e 00 00       	call   1f89 <close>
      runcmd(pcmd->left);
    1172:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1175:	8b 40 04             	mov    0x4(%eax),%eax
    1178:	89 04 24             	mov    %eax,(%esp)
    117b:	e8 80 fe ff ff       	call   1000 <runcmd>
    }
    if(fork1() == 0){
    1180:	e8 f8 01 00 00       	call   137d <fork1>
    1185:	85 c0                	test   %eax,%eax
    1187:	75 3b                	jne    11c4 <runcmd+0x1c4>
      close(0);
    1189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1190:	e8 f4 0d 00 00       	call   1f89 <close>
      dup(p[0]);
    1195:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1198:	89 04 24             	mov    %eax,(%esp)
    119b:	e8 39 0e 00 00       	call   1fd9 <dup>
      close(p[0]);
    11a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11a3:	89 04 24             	mov    %eax,(%esp)
    11a6:	e8 de 0d 00 00       	call   1f89 <close>
      close(p[1]);
    11ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11ae:	89 04 24             	mov    %eax,(%esp)
    11b1:	e8 d3 0d 00 00       	call   1f89 <close>
      runcmd(pcmd->right);
    11b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11b9:	8b 40 08             	mov    0x8(%eax),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 3c fe ff ff       	call   1000 <runcmd>
    }
    close(p[0]);
    11c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11c7:	89 04 24             	mov    %eax,(%esp)
    11ca:	e8 ba 0d 00 00       	call   1f89 <close>
    close(p[1]);
    11cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11d2:	89 04 24             	mov    %eax,(%esp)
    11d5:	e8 af 0d 00 00       	call   1f89 <close>
    wait();
    11da:	e8 8a 0d 00 00       	call   1f69 <wait>
    wait();
    11df:	e8 85 0d 00 00       	call   1f69 <wait>
    break;
    11e4:	eb 20                	jmp    1206 <runcmd+0x206>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    11e6:	8b 45 08             	mov    0x8(%ebp),%eax
    11e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
    11ec:	e8 8c 01 00 00       	call   137d <fork1>
    11f1:	85 c0                	test   %eax,%eax
    11f3:	75 10                	jne    1205 <runcmd+0x205>
      runcmd(bcmd->cmd);
    11f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11f8:	8b 40 04             	mov    0x4(%eax),%eax
    11fb:	89 04 24             	mov    %eax,(%esp)
    11fe:	e8 fd fd ff ff       	call   1000 <runcmd>
    break;
    1203:	eb 00                	jmp    1205 <runcmd+0x205>
    1205:	90                   	nop
  }
  exit();
    1206:	e8 56 0d 00 00       	call   1f61 <exit>

0000120b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
    120b:	55                   	push   %ebp
    120c:	89 e5                	mov    %esp,%ebp
    120e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
    1211:	c7 44 24 04 80 28 00 	movl   $0x2880,0x4(%esp)
    1218:	00 
    1219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1220:	e8 ec 0e 00 00       	call   2111 <printf>
  memset(buf, 0, nbuf);
    1225:	8b 45 0c             	mov    0xc(%ebp),%eax
    1228:	89 44 24 08          	mov    %eax,0x8(%esp)
    122c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1233:	00 
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	89 04 24             	mov    %eax,(%esp)
    123a:	e8 75 0b 00 00       	call   1db4 <memset>
  gets(buf, nbuf);
    123f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1242:	89 44 24 04          	mov    %eax,0x4(%esp)
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
    1249:	89 04 24             	mov    %eax,(%esp)
    124c:	e8 ba 0b 00 00       	call   1e0b <gets>
  if(buf[0] == 0) // EOF
    1251:	8b 45 08             	mov    0x8(%ebp),%eax
    1254:	0f b6 00             	movzbl (%eax),%eax
    1257:	84 c0                	test   %al,%al
    1259:	75 07                	jne    1262 <getcmd+0x57>
    return -1;
    125b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1260:	eb 05                	jmp    1267 <getcmd+0x5c>
  return 0;
    1262:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1267:	c9                   	leave  
    1268:	c3                   	ret    

00001269 <main>:

int
main(void)
{
    1269:	55                   	push   %ebp
    126a:	89 e5                	mov    %esp,%ebp
    126c:	83 e4 f0             	and    $0xfffffff0,%esp
    126f:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
    1272:	eb 15                	jmp    1289 <main+0x20>
    if(fd >= 3){
    1274:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
    1279:	7e 0e                	jle    1289 <main+0x20>
      close(fd);
    127b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    127f:	89 04 24             	mov    %eax,(%esp)
    1282:	e8 02 0d 00 00       	call   1f89 <close>
      break;
    1287:	eb 1f                	jmp    12a8 <main+0x3f>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
    1289:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1290:	00 
    1291:	c7 04 24 83 28 00 00 	movl   $0x2883,(%esp)
    1298:	e8 04 0d 00 00       	call   1fa1 <open>
    129d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    12a1:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    12a6:	79 cc                	jns    1274 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    12a8:	e9 89 00 00 00       	jmp    1336 <main+0xcd>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    12ad:	0f b6 05 a0 2f 00 00 	movzbl 0x2fa0,%eax
    12b4:	3c 63                	cmp    $0x63,%al
    12b6:	75 5c                	jne    1314 <main+0xab>
    12b8:	0f b6 05 a1 2f 00 00 	movzbl 0x2fa1,%eax
    12bf:	3c 64                	cmp    $0x64,%al
    12c1:	75 51                	jne    1314 <main+0xab>
    12c3:	0f b6 05 a2 2f 00 00 	movzbl 0x2fa2,%eax
    12ca:	3c 20                	cmp    $0x20,%al
    12cc:	75 46                	jne    1314 <main+0xab>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    12ce:	c7 04 24 a0 2f 00 00 	movl   $0x2fa0,(%esp)
    12d5:	e8 b3 0a 00 00       	call   1d8d <strlen>
    12da:	83 e8 01             	sub    $0x1,%eax
    12dd:	c6 80 a0 2f 00 00 00 	movb   $0x0,0x2fa0(%eax)
      if(chdir(buf+3) < 0)
    12e4:	c7 04 24 a3 2f 00 00 	movl   $0x2fa3,(%esp)
    12eb:	e8 e1 0c 00 00       	call   1fd1 <chdir>
    12f0:	85 c0                	test   %eax,%eax
    12f2:	79 1e                	jns    1312 <main+0xa9>
        printf(2, "cannot cd %s\n", buf+3);
    12f4:	c7 44 24 08 a3 2f 00 	movl   $0x2fa3,0x8(%esp)
    12fb:	00 
    12fc:	c7 44 24 04 8b 28 00 	movl   $0x288b,0x4(%esp)
    1303:	00 
    1304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    130b:	e8 01 0e 00 00       	call   2111 <printf>
      continue;
    1310:	eb 24                	jmp    1336 <main+0xcd>
    1312:	eb 22                	jmp    1336 <main+0xcd>
    }
    if(fork1() == 0)
    1314:	e8 64 00 00 00       	call   137d <fork1>
    1319:	85 c0                	test   %eax,%eax
    131b:	75 14                	jne    1331 <main+0xc8>
      runcmd(parsecmd(buf));
    131d:	c7 04 24 a0 2f 00 00 	movl   $0x2fa0,(%esp)
    1324:	e8 c9 03 00 00       	call   16f2 <parsecmd>
    1329:	89 04 24             	mov    %eax,(%esp)
    132c:	e8 cf fc ff ff       	call   1000 <runcmd>
    wait();
    1331:	e8 33 0c 00 00       	call   1f69 <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1336:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
    133d:	00 
    133e:	c7 04 24 a0 2f 00 00 	movl   $0x2fa0,(%esp)
    1345:	e8 c1 fe ff ff       	call   120b <getcmd>
    134a:	85 c0                	test   %eax,%eax
    134c:	0f 89 5b ff ff ff    	jns    12ad <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
    1352:	e8 0a 0c 00 00       	call   1f61 <exit>

00001357 <panic>:
}

void
panic(char *s)
{
    1357:	55                   	push   %ebp
    1358:	89 e5                	mov    %esp,%ebp
    135a:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
    135d:	8b 45 08             	mov    0x8(%ebp),%eax
    1360:	89 44 24 08          	mov    %eax,0x8(%esp)
    1364:	c7 44 24 04 99 28 00 	movl   $0x2899,0x4(%esp)
    136b:	00 
    136c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1373:	e8 99 0d 00 00       	call   2111 <printf>
  exit();
    1378:	e8 e4 0b 00 00       	call   1f61 <exit>

0000137d <fork1>:
}

int
fork1(void)
{
    137d:	55                   	push   %ebp
    137e:	89 e5                	mov    %esp,%ebp
    1380:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
    1383:	e8 d1 0b 00 00       	call   1f59 <fork>
    1388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
    138b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    138f:	75 0c                	jne    139d <fork1+0x20>
    panic("fork");
    1391:	c7 04 24 9d 28 00 00 	movl   $0x289d,(%esp)
    1398:	e8 ba ff ff ff       	call   1357 <panic>
  return pid;
    139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13a0:	c9                   	leave  
    13a1:	c3                   	ret    

000013a2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    13a2:	55                   	push   %ebp
    13a3:	89 e5                	mov    %esp,%ebp
    13a5:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13a8:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
    13af:	e8 49 10 00 00       	call   23fd <malloc>
    13b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    13b7:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
    13be:	00 
    13bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13c6:	00 
    13c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ca:	89 04 24             	mov    %eax,(%esp)
    13cd:	e8 e2 09 00 00       	call   1db4 <memset>
  cmd->type = EXEC;
    13d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
    13db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13de:	c9                   	leave  
    13df:	c3                   	ret    

000013e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    13e0:	55                   	push   %ebp
    13e1:	89 e5                	mov    %esp,%ebp
    13e3:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13e6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    13ed:	e8 0b 10 00 00       	call   23fd <malloc>
    13f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    13f5:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
    13fc:	00 
    13fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1404:	00 
    1405:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1408:	89 04 24             	mov    %eax,(%esp)
    140b:	e8 a4 09 00 00       	call   1db4 <memset>
  cmd->type = REDIR;
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
    1419:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141c:	8b 55 08             	mov    0x8(%ebp),%edx
    141f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
    1422:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1425:	8b 55 0c             	mov    0xc(%ebp),%edx
    1428:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
    142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142e:	8b 55 10             	mov    0x10(%ebp),%edx
    1431:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
    1434:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1437:	8b 55 14             	mov    0x14(%ebp),%edx
    143a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
    143d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1440:	8b 55 18             	mov    0x18(%ebp),%edx
    1443:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
    1446:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1449:	c9                   	leave  
    144a:	c3                   	ret    

0000144b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    144b:	55                   	push   %ebp
    144c:	89 e5                	mov    %esp,%ebp
    144e:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1451:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    1458:	e8 a0 0f 00 00       	call   23fd <malloc>
    145d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    1460:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    1467:	00 
    1468:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    146f:	00 
    1470:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1473:	89 04 24             	mov    %eax,(%esp)
    1476:	e8 39 09 00 00       	call   1db4 <memset>
  cmd->type = PIPE;
    147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
    1484:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1487:	8b 55 08             	mov    0x8(%ebp),%edx
    148a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
    148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1490:	8b 55 0c             	mov    0xc(%ebp),%edx
    1493:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
    1496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1499:	c9                   	leave  
    149a:	c3                   	ret    

0000149b <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    149b:	55                   	push   %ebp
    149c:	89 e5                	mov    %esp,%ebp
    149e:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14a1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    14a8:	e8 50 0f 00 00       	call   23fd <malloc>
    14ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    14b0:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    14b7:	00 
    14b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14bf:	00 
    14c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c3:	89 04 24             	mov    %eax,(%esp)
    14c6:	e8 e9 08 00 00       	call   1db4 <memset>
  cmd->type = LIST;
    14cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
    14d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d7:	8b 55 08             	mov    0x8(%ebp),%edx
    14da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
    14dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e0:	8b 55 0c             	mov    0xc(%ebp),%edx
    14e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
    14e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    14e9:	c9                   	leave  
    14ea:	c3                   	ret    

000014eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    14eb:	55                   	push   %ebp
    14ec:	89 e5                	mov    %esp,%ebp
    14ee:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    14f8:	e8 00 0f 00 00       	call   23fd <malloc>
    14fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    1500:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
    1507:	00 
    1508:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    150f:	00 
    1510:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1513:	89 04 24             	mov    %eax,(%esp)
    1516:	e8 99 08 00 00       	call   1db4 <memset>
  cmd->type = BACK;
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
    1524:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1527:	8b 55 08             	mov    0x8(%ebp),%edx
    152a:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
    152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1530:	c9                   	leave  
    1531:	c3                   	ret    

00001532 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    1532:	55                   	push   %ebp
    1533:	89 e5                	mov    %esp,%ebp
    1535:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
    1538:	8b 45 08             	mov    0x8(%ebp),%eax
    153b:	8b 00                	mov    (%eax),%eax
    153d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
    1540:	eb 04                	jmp    1546 <gettoken+0x14>
    s++;
    1542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    1546:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1549:	3b 45 0c             	cmp    0xc(%ebp),%eax
    154c:	73 1d                	jae    156b <gettoken+0x39>
    154e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1551:	0f b6 00             	movzbl (%eax),%eax
    1554:	0f be c0             	movsbl %al,%eax
    1557:	89 44 24 04          	mov    %eax,0x4(%esp)
    155b:	c7 04 24 60 2f 00 00 	movl   $0x2f60,(%esp)
    1562:	e8 71 08 00 00       	call   1dd8 <strchr>
    1567:	85 c0                	test   %eax,%eax
    1569:	75 d7                	jne    1542 <gettoken+0x10>
    s++;
  if(q)
    156b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    156f:	74 08                	je     1579 <gettoken+0x47>
    *q = s;
    1571:	8b 45 10             	mov    0x10(%ebp),%eax
    1574:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1577:	89 10                	mov    %edx,(%eax)
  ret = *s;
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	0f b6 00             	movzbl (%eax),%eax
    157f:	0f be c0             	movsbl %al,%eax
    1582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
    1585:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1588:	0f b6 00             	movzbl (%eax),%eax
    158b:	0f be c0             	movsbl %al,%eax
    158e:	83 f8 29             	cmp    $0x29,%eax
    1591:	7f 14                	jg     15a7 <gettoken+0x75>
    1593:	83 f8 28             	cmp    $0x28,%eax
    1596:	7d 28                	jge    15c0 <gettoken+0x8e>
    1598:	85 c0                	test   %eax,%eax
    159a:	0f 84 94 00 00 00    	je     1634 <gettoken+0x102>
    15a0:	83 f8 26             	cmp    $0x26,%eax
    15a3:	74 1b                	je     15c0 <gettoken+0x8e>
    15a5:	eb 3c                	jmp    15e3 <gettoken+0xb1>
    15a7:	83 f8 3e             	cmp    $0x3e,%eax
    15aa:	74 1a                	je     15c6 <gettoken+0x94>
    15ac:	83 f8 3e             	cmp    $0x3e,%eax
    15af:	7f 0a                	jg     15bb <gettoken+0x89>
    15b1:	83 e8 3b             	sub    $0x3b,%eax
    15b4:	83 f8 01             	cmp    $0x1,%eax
    15b7:	77 2a                	ja     15e3 <gettoken+0xb1>
    15b9:	eb 05                	jmp    15c0 <gettoken+0x8e>
    15bb:	83 f8 7c             	cmp    $0x7c,%eax
    15be:	75 23                	jne    15e3 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    15c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
    15c4:	eb 6f                	jmp    1635 <gettoken+0x103>
  case '>':
    s++;
    15c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
    15ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15cd:	0f b6 00             	movzbl (%eax),%eax
    15d0:	3c 3e                	cmp    $0x3e,%al
    15d2:	75 0d                	jne    15e1 <gettoken+0xaf>
      ret = '+';
    15d4:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
    15db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
    15df:	eb 54                	jmp    1635 <gettoken+0x103>
    15e1:	eb 52                	jmp    1635 <gettoken+0x103>
  default:
    ret = 'a';
    15e3:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15ea:	eb 04                	jmp    15f0 <gettoken+0xbe>
      s++;
    15ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
    15f6:	73 3a                	jae    1632 <gettoken+0x100>
    15f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fb:	0f b6 00             	movzbl (%eax),%eax
    15fe:	0f be c0             	movsbl %al,%eax
    1601:	89 44 24 04          	mov    %eax,0x4(%esp)
    1605:	c7 04 24 60 2f 00 00 	movl   $0x2f60,(%esp)
    160c:	e8 c7 07 00 00       	call   1dd8 <strchr>
    1611:	85 c0                	test   %eax,%eax
    1613:	75 1d                	jne    1632 <gettoken+0x100>
    1615:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1618:	0f b6 00             	movzbl (%eax),%eax
    161b:	0f be c0             	movsbl %al,%eax
    161e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1622:	c7 04 24 66 2f 00 00 	movl   $0x2f66,(%esp)
    1629:	e8 aa 07 00 00       	call   1dd8 <strchr>
    162e:	85 c0                	test   %eax,%eax
    1630:	74 ba                	je     15ec <gettoken+0xba>
      s++;
    break;
    1632:	eb 01                	jmp    1635 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
    1634:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    1635:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1639:	74 0a                	je     1645 <gettoken+0x113>
    *eq = s;
    163b:	8b 45 14             	mov    0x14(%ebp),%eax
    163e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1641:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
    1643:	eb 06                	jmp    164b <gettoken+0x119>
    1645:	eb 04                	jmp    164b <gettoken+0x119>
    s++;
    1647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    164e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1651:	73 1d                	jae    1670 <gettoken+0x13e>
    1653:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1656:	0f b6 00             	movzbl (%eax),%eax
    1659:	0f be c0             	movsbl %al,%eax
    165c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1660:	c7 04 24 60 2f 00 00 	movl   $0x2f60,(%esp)
    1667:	e8 6c 07 00 00       	call   1dd8 <strchr>
    166c:	85 c0                	test   %eax,%eax
    166e:	75 d7                	jne    1647 <gettoken+0x115>
    s++;
  *ps = s;
    1670:	8b 45 08             	mov    0x8(%ebp),%eax
    1673:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1676:	89 10                	mov    %edx,(%eax)
  return ret;
    1678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    167b:	c9                   	leave  
    167c:	c3                   	ret    

0000167d <peek>:

int
peek(char **ps, char *es, char *toks)
{
    167d:	55                   	push   %ebp
    167e:	89 e5                	mov    %esp,%ebp
    1680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
    1683:	8b 45 08             	mov    0x8(%ebp),%eax
    1686:	8b 00                	mov    (%eax),%eax
    1688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
    168b:	eb 04                	jmp    1691 <peek+0x14>
    s++;
    168d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    1691:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1694:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1697:	73 1d                	jae    16b6 <peek+0x39>
    1699:	8b 45 f4             	mov    -0xc(%ebp),%eax
    169c:	0f b6 00             	movzbl (%eax),%eax
    169f:	0f be c0             	movsbl %al,%eax
    16a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    16a6:	c7 04 24 60 2f 00 00 	movl   $0x2f60,(%esp)
    16ad:	e8 26 07 00 00       	call   1dd8 <strchr>
    16b2:	85 c0                	test   %eax,%eax
    16b4:	75 d7                	jne    168d <peek+0x10>
    s++;
  *ps = s;
    16b6:	8b 45 08             	mov    0x8(%ebp),%eax
    16b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
    16be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c1:	0f b6 00             	movzbl (%eax),%eax
    16c4:	84 c0                	test   %al,%al
    16c6:	74 23                	je     16eb <peek+0x6e>
    16c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cb:	0f b6 00             	movzbl (%eax),%eax
    16ce:	0f be c0             	movsbl %al,%eax
    16d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    16d5:	8b 45 10             	mov    0x10(%ebp),%eax
    16d8:	89 04 24             	mov    %eax,(%esp)
    16db:	e8 f8 06 00 00       	call   1dd8 <strchr>
    16e0:	85 c0                	test   %eax,%eax
    16e2:	74 07                	je     16eb <peek+0x6e>
    16e4:	b8 01 00 00 00       	mov    $0x1,%eax
    16e9:	eb 05                	jmp    16f0 <peek+0x73>
    16eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    16f0:	c9                   	leave  
    16f1:	c3                   	ret    

000016f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    16f2:	55                   	push   %ebp
    16f3:	89 e5                	mov    %esp,%ebp
    16f5:	53                   	push   %ebx
    16f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    16f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16fc:	8b 45 08             	mov    0x8(%ebp),%eax
    16ff:	89 04 24             	mov    %eax,(%esp)
    1702:	e8 86 06 00 00       	call   1d8d <strlen>
    1707:	01 d8                	add    %ebx,%eax
    1709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
    170c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    170f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1713:	8d 45 08             	lea    0x8(%ebp),%eax
    1716:	89 04 24             	mov    %eax,(%esp)
    1719:	e8 60 00 00 00       	call   177e <parseline>
    171e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
    1721:	c7 44 24 08 a2 28 00 	movl   $0x28a2,0x8(%esp)
    1728:	00 
    1729:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1730:	8d 45 08             	lea    0x8(%ebp),%eax
    1733:	89 04 24             	mov    %eax,(%esp)
    1736:	e8 42 ff ff ff       	call   167d <peek>
  if(s != es){
    173b:	8b 45 08             	mov    0x8(%ebp),%eax
    173e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1741:	74 27                	je     176a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
    1743:	8b 45 08             	mov    0x8(%ebp),%eax
    1746:	89 44 24 08          	mov    %eax,0x8(%esp)
    174a:	c7 44 24 04 a3 28 00 	movl   $0x28a3,0x4(%esp)
    1751:	00 
    1752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1759:	e8 b3 09 00 00       	call   2111 <printf>
    panic("syntax");
    175e:	c7 04 24 b2 28 00 00 	movl   $0x28b2,(%esp)
    1765:	e8 ed fb ff ff       	call   1357 <panic>
  }
  nulterminate(cmd);
    176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176d:	89 04 24             	mov    %eax,(%esp)
    1770:	e8 a3 04 00 00       	call   1c18 <nulterminate>
  return cmd;
    1775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1778:	83 c4 24             	add    $0x24,%esp
    177b:	5b                   	pop    %ebx
    177c:	5d                   	pop    %ebp
    177d:	c3                   	ret    

0000177e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
    177e:	55                   	push   %ebp
    177f:	89 e5                	mov    %esp,%ebp
    1781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    1784:	8b 45 0c             	mov    0xc(%ebp),%eax
    1787:	89 44 24 04          	mov    %eax,0x4(%esp)
    178b:	8b 45 08             	mov    0x8(%ebp),%eax
    178e:	89 04 24             	mov    %eax,(%esp)
    1791:	e8 bc 00 00 00       	call   1852 <parsepipe>
    1796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
    1799:	eb 30                	jmp    17cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
    179b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    17a2:	00 
    17a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    17aa:	00 
    17ab:	8b 45 0c             	mov    0xc(%ebp),%eax
    17ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    17b2:	8b 45 08             	mov    0x8(%ebp),%eax
    17b5:	89 04 24             	mov    %eax,(%esp)
    17b8:	e8 75 fd ff ff       	call   1532 <gettoken>
    cmd = backcmd(cmd);
    17bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c0:	89 04 24             	mov    %eax,(%esp)
    17c3:	e8 23 fd ff ff       	call   14eb <backcmd>
    17c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    17cb:	c7 44 24 08 b9 28 00 	movl   $0x28b9,0x8(%esp)
    17d2:	00 
    17d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    17d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    17da:	8b 45 08             	mov    0x8(%ebp),%eax
    17dd:	89 04 24             	mov    %eax,(%esp)
    17e0:	e8 98 fe ff ff       	call   167d <peek>
    17e5:	85 c0                	test   %eax,%eax
    17e7:	75 b2                	jne    179b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    17e9:	c7 44 24 08 bb 28 00 	movl   $0x28bb,0x8(%esp)
    17f0:	00 
    17f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    17f4:	89 44 24 04          	mov    %eax,0x4(%esp)
    17f8:	8b 45 08             	mov    0x8(%ebp),%eax
    17fb:	89 04 24             	mov    %eax,(%esp)
    17fe:	e8 7a fe ff ff       	call   167d <peek>
    1803:	85 c0                	test   %eax,%eax
    1805:	74 46                	je     184d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
    1807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    180e:	00 
    180f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1816:	00 
    1817:	8b 45 0c             	mov    0xc(%ebp),%eax
    181a:	89 44 24 04          	mov    %eax,0x4(%esp)
    181e:	8b 45 08             	mov    0x8(%ebp),%eax
    1821:	89 04 24             	mov    %eax,(%esp)
    1824:	e8 09 fd ff ff       	call   1532 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    1829:	8b 45 0c             	mov    0xc(%ebp),%eax
    182c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1830:	8b 45 08             	mov    0x8(%ebp),%eax
    1833:	89 04 24             	mov    %eax,(%esp)
    1836:	e8 43 ff ff ff       	call   177e <parseline>
    183b:	89 44 24 04          	mov    %eax,0x4(%esp)
    183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1842:	89 04 24             	mov    %eax,(%esp)
    1845:	e8 51 fc ff ff       	call   149b <listcmd>
    184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1850:	c9                   	leave  
    1851:	c3                   	ret    

00001852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
    1852:	55                   	push   %ebp
    1853:	89 e5                	mov    %esp,%ebp
    1855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    1858:	8b 45 0c             	mov    0xc(%ebp),%eax
    185b:	89 44 24 04          	mov    %eax,0x4(%esp)
    185f:	8b 45 08             	mov    0x8(%ebp),%eax
    1862:	89 04 24             	mov    %eax,(%esp)
    1865:	e8 68 02 00 00       	call   1ad2 <parseexec>
    186a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
    186d:	c7 44 24 08 bd 28 00 	movl   $0x28bd,0x8(%esp)
    1874:	00 
    1875:	8b 45 0c             	mov    0xc(%ebp),%eax
    1878:	89 44 24 04          	mov    %eax,0x4(%esp)
    187c:	8b 45 08             	mov    0x8(%ebp),%eax
    187f:	89 04 24             	mov    %eax,(%esp)
    1882:	e8 f6 fd ff ff       	call   167d <peek>
    1887:	85 c0                	test   %eax,%eax
    1889:	74 46                	je     18d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
    188b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1892:	00 
    1893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    189a:	00 
    189b:	8b 45 0c             	mov    0xc(%ebp),%eax
    189e:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	89 04 24             	mov    %eax,(%esp)
    18a8:	e8 85 fc ff ff       	call   1532 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    18ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    18b0:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b4:	8b 45 08             	mov    0x8(%ebp),%eax
    18b7:	89 04 24             	mov    %eax,(%esp)
    18ba:	e8 93 ff ff ff       	call   1852 <parsepipe>
    18bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    18c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c6:	89 04 24             	mov    %eax,(%esp)
    18c9:	e8 7d fb ff ff       	call   144b <pipecmd>
    18ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    18d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    18d4:	c9                   	leave  
    18d5:	c3                   	ret    

000018d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    18d6:	55                   	push   %ebp
    18d7:	89 e5                	mov    %esp,%ebp
    18d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    18dc:	e9 f6 00 00 00       	jmp    19d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
    18e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18e8:	00 
    18e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    18f0:	00 
    18f1:	8b 45 10             	mov    0x10(%ebp),%eax
    18f4:	89 44 24 04          	mov    %eax,0x4(%esp)
    18f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    18fb:	89 04 24             	mov    %eax,(%esp)
    18fe:	e8 2f fc ff ff       	call   1532 <gettoken>
    1903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
    1906:	8d 45 ec             	lea    -0x14(%ebp),%eax
    1909:	89 44 24 0c          	mov    %eax,0xc(%esp)
    190d:	8d 45 f0             	lea    -0x10(%ebp),%eax
    1910:	89 44 24 08          	mov    %eax,0x8(%esp)
    1914:	8b 45 10             	mov    0x10(%ebp),%eax
    1917:	89 44 24 04          	mov    %eax,0x4(%esp)
    191b:	8b 45 0c             	mov    0xc(%ebp),%eax
    191e:	89 04 24             	mov    %eax,(%esp)
    1921:	e8 0c fc ff ff       	call   1532 <gettoken>
    1926:	83 f8 61             	cmp    $0x61,%eax
    1929:	74 0c                	je     1937 <parseredirs+0x61>
      panic("missing file for redirection");
    192b:	c7 04 24 bf 28 00 00 	movl   $0x28bf,(%esp)
    1932:	e8 20 fa ff ff       	call   1357 <panic>
    switch(tok){
    1937:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193a:	83 f8 3c             	cmp    $0x3c,%eax
    193d:	74 0f                	je     194e <parseredirs+0x78>
    193f:	83 f8 3e             	cmp    $0x3e,%eax
    1942:	74 38                	je     197c <parseredirs+0xa6>
    1944:	83 f8 2b             	cmp    $0x2b,%eax
    1947:	74 61                	je     19aa <parseredirs+0xd4>
    1949:	e9 89 00 00 00       	jmp    19d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    194e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1951:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    195b:	00 
    195c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1963:	00 
    1964:	89 54 24 08          	mov    %edx,0x8(%esp)
    1968:	89 44 24 04          	mov    %eax,0x4(%esp)
    196c:	8b 45 08             	mov    0x8(%ebp),%eax
    196f:	89 04 24             	mov    %eax,(%esp)
    1972:	e8 69 fa ff ff       	call   13e0 <redircmd>
    1977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    197a:	eb 5b                	jmp    19d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    197c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    1989:	00 
    198a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    1991:	00 
    1992:	89 54 24 08          	mov    %edx,0x8(%esp)
    1996:	89 44 24 04          	mov    %eax,0x4(%esp)
    199a:	8b 45 08             	mov    0x8(%ebp),%eax
    199d:	89 04 24             	mov    %eax,(%esp)
    19a0:	e8 3b fa ff ff       	call   13e0 <redircmd>
    19a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    19a8:	eb 2d                	jmp    19d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    19aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    19b7:	00 
    19b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    19bf:	00 
    19c0:	89 54 24 08          	mov    %edx,0x8(%esp)
    19c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    19c8:	8b 45 08             	mov    0x8(%ebp),%eax
    19cb:	89 04 24             	mov    %eax,(%esp)
    19ce:	e8 0d fa ff ff       	call   13e0 <redircmd>
    19d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    19d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    19d7:	c7 44 24 08 dc 28 00 	movl   $0x28dc,0x8(%esp)
    19de:	00 
    19df:	8b 45 10             	mov    0x10(%ebp),%eax
    19e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    19e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    19e9:	89 04 24             	mov    %eax,(%esp)
    19ec:	e8 8c fc ff ff       	call   167d <peek>
    19f1:	85 c0                	test   %eax,%eax
    19f3:	0f 85 e8 fe ff ff    	jne    18e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
    19f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    19fc:	c9                   	leave  
    19fd:	c3                   	ret    

000019fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
    19fe:	55                   	push   %ebp
    19ff:	89 e5                	mov    %esp,%ebp
    1a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    1a04:	c7 44 24 08 df 28 00 	movl   $0x28df,0x8(%esp)
    1a0b:	00 
    1a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a13:	8b 45 08             	mov    0x8(%ebp),%eax
    1a16:	89 04 24             	mov    %eax,(%esp)
    1a19:	e8 5f fc ff ff       	call   167d <peek>
    1a1e:	85 c0                	test   %eax,%eax
    1a20:	75 0c                	jne    1a2e <parseblock+0x30>
    panic("parseblock");
    1a22:	c7 04 24 e1 28 00 00 	movl   $0x28e1,(%esp)
    1a29:	e8 29 f9 ff ff       	call   1357 <panic>
  gettoken(ps, es, 0, 0);
    1a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a35:	00 
    1a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a3d:	00 
    1a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a41:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a45:	8b 45 08             	mov    0x8(%ebp),%eax
    1a48:	89 04 24             	mov    %eax,(%esp)
    1a4b:	e8 e2 fa ff ff       	call   1532 <gettoken>
  cmd = parseline(ps, es);
    1a50:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a53:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a57:	8b 45 08             	mov    0x8(%ebp),%eax
    1a5a:	89 04 24             	mov    %eax,(%esp)
    1a5d:	e8 1c fd ff ff       	call   177e <parseline>
    1a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
    1a65:	c7 44 24 08 ec 28 00 	movl   $0x28ec,0x8(%esp)
    1a6c:	00 
    1a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a70:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a74:	8b 45 08             	mov    0x8(%ebp),%eax
    1a77:	89 04 24             	mov    %eax,(%esp)
    1a7a:	e8 fe fb ff ff       	call   167d <peek>
    1a7f:	85 c0                	test   %eax,%eax
    1a81:	75 0c                	jne    1a8f <parseblock+0x91>
    panic("syntax - missing )");
    1a83:	c7 04 24 ee 28 00 00 	movl   $0x28ee,(%esp)
    1a8a:	e8 c8 f8 ff ff       	call   1357 <panic>
  gettoken(ps, es, 0, 0);
    1a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a96:	00 
    1a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a9e:	00 
    1a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
    1aa6:	8b 45 08             	mov    0x8(%ebp),%eax
    1aa9:	89 04 24             	mov    %eax,(%esp)
    1aac:	e8 81 fa ff ff       	call   1532 <gettoken>
  cmd = parseredirs(cmd, ps, es);
    1ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ab8:	8b 45 08             	mov    0x8(%ebp),%eax
    1abb:	89 44 24 04          	mov    %eax,0x4(%esp)
    1abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac2:	89 04 24             	mov    %eax,(%esp)
    1ac5:	e8 0c fe ff ff       	call   18d6 <parseredirs>
    1aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
    1acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1ad0:	c9                   	leave  
    1ad1:	c3                   	ret    

00001ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
    1ad2:	55                   	push   %ebp
    1ad3:	89 e5                	mov    %esp,%ebp
    1ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    1ad8:	c7 44 24 08 df 28 00 	movl   $0x28df,0x8(%esp)
    1adf:	00 
    1ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ae7:	8b 45 08             	mov    0x8(%ebp),%eax
    1aea:	89 04 24             	mov    %eax,(%esp)
    1aed:	e8 8b fb ff ff       	call   167d <peek>
    1af2:	85 c0                	test   %eax,%eax
    1af4:	74 17                	je     1b0d <parseexec+0x3b>
    return parseblock(ps, es);
    1af6:	8b 45 0c             	mov    0xc(%ebp),%eax
    1af9:	89 44 24 04          	mov    %eax,0x4(%esp)
    1afd:	8b 45 08             	mov    0x8(%ebp),%eax
    1b00:	89 04 24             	mov    %eax,(%esp)
    1b03:	e8 f6 fe ff ff       	call   19fe <parseblock>
    1b08:	e9 09 01 00 00       	jmp    1c16 <parseexec+0x144>

  ret = execcmd();
    1b0d:	e8 90 f8 ff ff       	call   13a2 <execcmd>
    1b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
    1b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
    1b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
    1b22:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b25:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b29:	8b 45 08             	mov    0x8(%ebp),%eax
    1b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b33:	89 04 24             	mov    %eax,(%esp)
    1b36:	e8 9b fd ff ff       	call   18d6 <parseredirs>
    1b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
    1b3e:	e9 8f 00 00 00       	jmp    1bd2 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b51:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b54:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b58:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5b:	89 04 24             	mov    %eax,(%esp)
    1b5e:	e8 cf f9 ff ff       	call   1532 <gettoken>
    1b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b6a:	75 05                	jne    1b71 <parseexec+0x9f>
      break;
    1b6c:	e9 83 00 00 00       	jmp    1bf4 <parseexec+0x122>
    if(tok != 'a')
    1b71:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
    1b75:	74 0c                	je     1b83 <parseexec+0xb1>
      panic("syntax");
    1b77:	c7 04 24 b2 28 00 00 	movl   $0x28b2,(%esp)
    1b7e:	e8 d4 f7 ff ff       	call   1357 <panic>
    cmd->argv[argc] = q;
    1b83:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    1b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b8c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
    1b90:	8b 55 e0             	mov    -0x20(%ebp),%edx
    1b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b99:	83 c1 08             	add    $0x8,%ecx
    1b9c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
    1ba0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
    1ba4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1ba8:	7e 0c                	jle    1bb6 <parseexec+0xe4>
      panic("too many args");
    1baa:	c7 04 24 01 29 00 00 	movl   $0x2901,(%esp)
    1bb1:	e8 a1 f7 ff ff       	call   1357 <panic>
    ret = parseredirs(ret, ps, es);
    1bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
    1bbd:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bc7:	89 04 24             	mov    %eax,(%esp)
    1bca:	e8 07 fd ff ff       	call   18d6 <parseredirs>
    1bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    1bd2:	c7 44 24 08 0f 29 00 	movl   $0x290f,0x8(%esp)
    1bd9:	00 
    1bda:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1be1:	8b 45 08             	mov    0x8(%ebp),%eax
    1be4:	89 04 24             	mov    %eax,(%esp)
    1be7:	e8 91 fa ff ff       	call   167d <peek>
    1bec:	85 c0                	test   %eax,%eax
    1bee:	0f 84 4f ff ff ff    	je     1b43 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
    1bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bfa:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
    1c01:	00 
  cmd->eargv[argc] = 0;
    1c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c08:	83 c2 08             	add    $0x8,%edx
    1c0b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
    1c12:	00 
  return ret;
    1c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1c16:	c9                   	leave  
    1c17:	c3                   	ret    

00001c18 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    1c18:	55                   	push   %ebp
    1c19:	89 e5                	mov    %esp,%ebp
    1c1b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1c22:	75 0a                	jne    1c2e <nulterminate+0x16>
    return 0;
    1c24:	b8 00 00 00 00       	mov    $0x0,%eax
    1c29:	e9 c9 00 00 00       	jmp    1cf7 <nulterminate+0xdf>
  
  switch(cmd->type){
    1c2e:	8b 45 08             	mov    0x8(%ebp),%eax
    1c31:	8b 00                	mov    (%eax),%eax
    1c33:	83 f8 05             	cmp    $0x5,%eax
    1c36:	0f 87 b8 00 00 00    	ja     1cf4 <nulterminate+0xdc>
    1c3c:	8b 04 85 14 29 00 00 	mov    0x2914(,%eax,4),%eax
    1c43:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    1c45:	8b 45 08             	mov    0x8(%ebp),%eax
    1c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
    1c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c52:	eb 14                	jmp    1c68 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
    1c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c5a:	83 c2 08             	add    $0x8,%edx
    1c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
    1c61:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c6e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1c72:	85 c0                	test   %eax,%eax
    1c74:	75 de                	jne    1c54 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
    1c76:	eb 7c                	jmp    1cf4 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    1c78:	8b 45 08             	mov    0x8(%ebp),%eax
    1c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
    1c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c81:	8b 40 04             	mov    0x4(%eax),%eax
    1c84:	89 04 24             	mov    %eax,(%esp)
    1c87:	e8 8c ff ff ff       	call   1c18 <nulterminate>
    *rcmd->efile = 0;
    1c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c8f:	8b 40 0c             	mov    0xc(%eax),%eax
    1c92:	c6 00 00             	movb   $0x0,(%eax)
    break;
    1c95:	eb 5d                	jmp    1cf4 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    1c97:	8b 45 08             	mov    0x8(%ebp),%eax
    1c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
    1c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ca0:	8b 40 04             	mov    0x4(%eax),%eax
    1ca3:	89 04 24             	mov    %eax,(%esp)
    1ca6:	e8 6d ff ff ff       	call   1c18 <nulterminate>
    nulterminate(pcmd->right);
    1cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1cae:	8b 40 08             	mov    0x8(%eax),%eax
    1cb1:	89 04 24             	mov    %eax,(%esp)
    1cb4:	e8 5f ff ff ff       	call   1c18 <nulterminate>
    break;
    1cb9:	eb 39                	jmp    1cf4 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    1cbb:	8b 45 08             	mov    0x8(%ebp),%eax
    1cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
    1cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1cc4:	8b 40 04             	mov    0x4(%eax),%eax
    1cc7:	89 04 24             	mov    %eax,(%esp)
    1cca:	e8 49 ff ff ff       	call   1c18 <nulterminate>
    nulterminate(lcmd->right);
    1ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1cd2:	8b 40 08             	mov    0x8(%eax),%eax
    1cd5:	89 04 24             	mov    %eax,(%esp)
    1cd8:	e8 3b ff ff ff       	call   1c18 <nulterminate>
    break;
    1cdd:	eb 15                	jmp    1cf4 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    1cdf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
    1ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1ce8:	8b 40 04             	mov    0x4(%eax),%eax
    1ceb:	89 04 24             	mov    %eax,(%esp)
    1cee:	e8 25 ff ff ff       	call   1c18 <nulterminate>
    break;
    1cf3:	90                   	nop
  }
  return cmd;
    1cf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1cf7:	c9                   	leave  
    1cf8:	c3                   	ret    

00001cf9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1cf9:	55                   	push   %ebp
    1cfa:	89 e5                	mov    %esp,%ebp
    1cfc:	57                   	push   %edi
    1cfd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1cfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1d01:	8b 55 10             	mov    0x10(%ebp),%edx
    1d04:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d07:	89 cb                	mov    %ecx,%ebx
    1d09:	89 df                	mov    %ebx,%edi
    1d0b:	89 d1                	mov    %edx,%ecx
    1d0d:	fc                   	cld    
    1d0e:	f3 aa                	rep stos %al,%es:(%edi)
    1d10:	89 ca                	mov    %ecx,%edx
    1d12:	89 fb                	mov    %edi,%ebx
    1d14:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1d17:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1d1a:	5b                   	pop    %ebx
    1d1b:	5f                   	pop    %edi
    1d1c:	5d                   	pop    %ebp
    1d1d:	c3                   	ret    

00001d1e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1d1e:	55                   	push   %ebp
    1d1f:	89 e5                	mov    %esp,%ebp
    1d21:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1d24:	8b 45 08             	mov    0x8(%ebp),%eax
    1d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1d2a:	90                   	nop
    1d2b:	8b 45 08             	mov    0x8(%ebp),%eax
    1d2e:	8d 50 01             	lea    0x1(%eax),%edx
    1d31:	89 55 08             	mov    %edx,0x8(%ebp)
    1d34:	8b 55 0c             	mov    0xc(%ebp),%edx
    1d37:	8d 4a 01             	lea    0x1(%edx),%ecx
    1d3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1d3d:	0f b6 12             	movzbl (%edx),%edx
    1d40:	88 10                	mov    %dl,(%eax)
    1d42:	0f b6 00             	movzbl (%eax),%eax
    1d45:	84 c0                	test   %al,%al
    1d47:	75 e2                	jne    1d2b <strcpy+0xd>
    ;
  return os;
    1d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1d4c:	c9                   	leave  
    1d4d:	c3                   	ret    

00001d4e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1d4e:	55                   	push   %ebp
    1d4f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1d51:	eb 08                	jmp    1d5b <strcmp+0xd>
    p++, q++;
    1d53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1d57:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1d5b:	8b 45 08             	mov    0x8(%ebp),%eax
    1d5e:	0f b6 00             	movzbl (%eax),%eax
    1d61:	84 c0                	test   %al,%al
    1d63:	74 10                	je     1d75 <strcmp+0x27>
    1d65:	8b 45 08             	mov    0x8(%ebp),%eax
    1d68:	0f b6 10             	movzbl (%eax),%edx
    1d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d6e:	0f b6 00             	movzbl (%eax),%eax
    1d71:	38 c2                	cmp    %al,%dl
    1d73:	74 de                	je     1d53 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1d75:	8b 45 08             	mov    0x8(%ebp),%eax
    1d78:	0f b6 00             	movzbl (%eax),%eax
    1d7b:	0f b6 d0             	movzbl %al,%edx
    1d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d81:	0f b6 00             	movzbl (%eax),%eax
    1d84:	0f b6 c0             	movzbl %al,%eax
    1d87:	29 c2                	sub    %eax,%edx
    1d89:	89 d0                	mov    %edx,%eax
}
    1d8b:	5d                   	pop    %ebp
    1d8c:	c3                   	ret    

00001d8d <strlen>:

uint
strlen(char *s)
{
    1d8d:	55                   	push   %ebp
    1d8e:	89 e5                	mov    %esp,%ebp
    1d90:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1d93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1d9a:	eb 04                	jmp    1da0 <strlen+0x13>
    1d9c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1da0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1da3:	8b 45 08             	mov    0x8(%ebp),%eax
    1da6:	01 d0                	add    %edx,%eax
    1da8:	0f b6 00             	movzbl (%eax),%eax
    1dab:	84 c0                	test   %al,%al
    1dad:	75 ed                	jne    1d9c <strlen+0xf>
    ;
  return n;
    1daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1db2:	c9                   	leave  
    1db3:	c3                   	ret    

00001db4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1db4:	55                   	push   %ebp
    1db5:	89 e5                	mov    %esp,%ebp
    1db7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1dba:	8b 45 10             	mov    0x10(%ebp),%eax
    1dbd:	89 44 24 08          	mov    %eax,0x8(%esp)
    1dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
    1dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
    1dc8:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcb:	89 04 24             	mov    %eax,(%esp)
    1dce:	e8 26 ff ff ff       	call   1cf9 <stosb>
  return dst;
    1dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1dd6:	c9                   	leave  
    1dd7:	c3                   	ret    

00001dd8 <strchr>:

char*
strchr(const char *s, char c)
{
    1dd8:	55                   	push   %ebp
    1dd9:	89 e5                	mov    %esp,%ebp
    1ddb:	83 ec 04             	sub    $0x4,%esp
    1dde:	8b 45 0c             	mov    0xc(%ebp),%eax
    1de1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1de4:	eb 14                	jmp    1dfa <strchr+0x22>
    if(*s == c)
    1de6:	8b 45 08             	mov    0x8(%ebp),%eax
    1de9:	0f b6 00             	movzbl (%eax),%eax
    1dec:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1def:	75 05                	jne    1df6 <strchr+0x1e>
      return (char*)s;
    1df1:	8b 45 08             	mov    0x8(%ebp),%eax
    1df4:	eb 13                	jmp    1e09 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1df6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1dfa:	8b 45 08             	mov    0x8(%ebp),%eax
    1dfd:	0f b6 00             	movzbl (%eax),%eax
    1e00:	84 c0                	test   %al,%al
    1e02:	75 e2                	jne    1de6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1e09:	c9                   	leave  
    1e0a:	c3                   	ret    

00001e0b <gets>:

char*
gets(char *buf, int max)
{
    1e0b:	55                   	push   %ebp
    1e0c:	89 e5                	mov    %esp,%ebp
    1e0e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1e11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e18:	eb 4c                	jmp    1e66 <gets+0x5b>
    cc = read(0, &c, 1);
    1e1a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1e21:	00 
    1e22:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1e25:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1e30:	e8 44 01 00 00       	call   1f79 <read>
    1e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1e38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e3c:	7f 02                	jg     1e40 <gets+0x35>
      break;
    1e3e:	eb 31                	jmp    1e71 <gets+0x66>
    buf[i++] = c;
    1e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e43:	8d 50 01             	lea    0x1(%eax),%edx
    1e46:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1e49:	89 c2                	mov    %eax,%edx
    1e4b:	8b 45 08             	mov    0x8(%ebp),%eax
    1e4e:	01 c2                	add    %eax,%edx
    1e50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1e54:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1e56:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1e5a:	3c 0a                	cmp    $0xa,%al
    1e5c:	74 13                	je     1e71 <gets+0x66>
    1e5e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1e62:	3c 0d                	cmp    $0xd,%al
    1e64:	74 0b                	je     1e71 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e69:	83 c0 01             	add    $0x1,%eax
    1e6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1e6f:	7c a9                	jl     1e1a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e74:	8b 45 08             	mov    0x8(%ebp),%eax
    1e77:	01 d0                	add    %edx,%eax
    1e79:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1e7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1e7f:	c9                   	leave  
    1e80:	c3                   	ret    

00001e81 <stat>:

int
stat(char *n, struct stat *st)
{
    1e81:	55                   	push   %ebp
    1e82:	89 e5                	mov    %esp,%ebp
    1e84:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1e87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e8e:	00 
    1e8f:	8b 45 08             	mov    0x8(%ebp),%eax
    1e92:	89 04 24             	mov    %eax,(%esp)
    1e95:	e8 07 01 00 00       	call   1fa1 <open>
    1e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ea1:	79 07                	jns    1eaa <stat+0x29>
    return -1;
    1ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1ea8:	eb 23                	jmp    1ecd <stat+0x4c>
  r = fstat(fd, st);
    1eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ead:	89 44 24 04          	mov    %eax,0x4(%esp)
    1eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eb4:	89 04 24             	mov    %eax,(%esp)
    1eb7:	e8 fd 00 00 00       	call   1fb9 <fstat>
    1ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ec2:	89 04 24             	mov    %eax,(%esp)
    1ec5:	e8 bf 00 00 00       	call   1f89 <close>
  return r;
    1eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1ecd:	c9                   	leave  
    1ece:	c3                   	ret    

00001ecf <atoi>:

int
atoi(const char *s)
{
    1ecf:	55                   	push   %ebp
    1ed0:	89 e5                	mov    %esp,%ebp
    1ed2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1ed5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1edc:	eb 25                	jmp    1f03 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1ede:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1ee1:	89 d0                	mov    %edx,%eax
    1ee3:	c1 e0 02             	shl    $0x2,%eax
    1ee6:	01 d0                	add    %edx,%eax
    1ee8:	01 c0                	add    %eax,%eax
    1eea:	89 c1                	mov    %eax,%ecx
    1eec:	8b 45 08             	mov    0x8(%ebp),%eax
    1eef:	8d 50 01             	lea    0x1(%eax),%edx
    1ef2:	89 55 08             	mov    %edx,0x8(%ebp)
    1ef5:	0f b6 00             	movzbl (%eax),%eax
    1ef8:	0f be c0             	movsbl %al,%eax
    1efb:	01 c8                	add    %ecx,%eax
    1efd:	83 e8 30             	sub    $0x30,%eax
    1f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1f03:	8b 45 08             	mov    0x8(%ebp),%eax
    1f06:	0f b6 00             	movzbl (%eax),%eax
    1f09:	3c 2f                	cmp    $0x2f,%al
    1f0b:	7e 0a                	jle    1f17 <atoi+0x48>
    1f0d:	8b 45 08             	mov    0x8(%ebp),%eax
    1f10:	0f b6 00             	movzbl (%eax),%eax
    1f13:	3c 39                	cmp    $0x39,%al
    1f15:	7e c7                	jle    1ede <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1f1a:	c9                   	leave  
    1f1b:	c3                   	ret    

00001f1c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1f1c:	55                   	push   %ebp
    1f1d:	89 e5                	mov    %esp,%ebp
    1f1f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1f22:	8b 45 08             	mov    0x8(%ebp),%eax
    1f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1f28:	8b 45 0c             	mov    0xc(%ebp),%eax
    1f2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1f2e:	eb 17                	jmp    1f47 <memmove+0x2b>
    *dst++ = *src++;
    1f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1f33:	8d 50 01             	lea    0x1(%eax),%edx
    1f36:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1f39:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1f3c:	8d 4a 01             	lea    0x1(%edx),%ecx
    1f3f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1f42:	0f b6 12             	movzbl (%edx),%edx
    1f45:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1f47:	8b 45 10             	mov    0x10(%ebp),%eax
    1f4a:	8d 50 ff             	lea    -0x1(%eax),%edx
    1f4d:	89 55 10             	mov    %edx,0x10(%ebp)
    1f50:	85 c0                	test   %eax,%eax
    1f52:	7f dc                	jg     1f30 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1f54:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1f57:	c9                   	leave  
    1f58:	c3                   	ret    

00001f59 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1f59:	b8 01 00 00 00       	mov    $0x1,%eax
    1f5e:	cd 40                	int    $0x40
    1f60:	c3                   	ret    

00001f61 <exit>:
SYSCALL(exit)
    1f61:	b8 02 00 00 00       	mov    $0x2,%eax
    1f66:	cd 40                	int    $0x40
    1f68:	c3                   	ret    

00001f69 <wait>:
SYSCALL(wait)
    1f69:	b8 03 00 00 00       	mov    $0x3,%eax
    1f6e:	cd 40                	int    $0x40
    1f70:	c3                   	ret    

00001f71 <pipe>:
SYSCALL(pipe)
    1f71:	b8 04 00 00 00       	mov    $0x4,%eax
    1f76:	cd 40                	int    $0x40
    1f78:	c3                   	ret    

00001f79 <read>:
SYSCALL(read)
    1f79:	b8 05 00 00 00       	mov    $0x5,%eax
    1f7e:	cd 40                	int    $0x40
    1f80:	c3                   	ret    

00001f81 <write>:
SYSCALL(write)
    1f81:	b8 10 00 00 00       	mov    $0x10,%eax
    1f86:	cd 40                	int    $0x40
    1f88:	c3                   	ret    

00001f89 <close>:
SYSCALL(close)
    1f89:	b8 15 00 00 00       	mov    $0x15,%eax
    1f8e:	cd 40                	int    $0x40
    1f90:	c3                   	ret    

00001f91 <kill>:
SYSCALL(kill)
    1f91:	b8 06 00 00 00       	mov    $0x6,%eax
    1f96:	cd 40                	int    $0x40
    1f98:	c3                   	ret    

00001f99 <exec>:
SYSCALL(exec)
    1f99:	b8 07 00 00 00       	mov    $0x7,%eax
    1f9e:	cd 40                	int    $0x40
    1fa0:	c3                   	ret    

00001fa1 <open>:
SYSCALL(open)
    1fa1:	b8 0f 00 00 00       	mov    $0xf,%eax
    1fa6:	cd 40                	int    $0x40
    1fa8:	c3                   	ret    

00001fa9 <mknod>:
SYSCALL(mknod)
    1fa9:	b8 11 00 00 00       	mov    $0x11,%eax
    1fae:	cd 40                	int    $0x40
    1fb0:	c3                   	ret    

00001fb1 <unlink>:
SYSCALL(unlink)
    1fb1:	b8 12 00 00 00       	mov    $0x12,%eax
    1fb6:	cd 40                	int    $0x40
    1fb8:	c3                   	ret    

00001fb9 <fstat>:
SYSCALL(fstat)
    1fb9:	b8 08 00 00 00       	mov    $0x8,%eax
    1fbe:	cd 40                	int    $0x40
    1fc0:	c3                   	ret    

00001fc1 <link>:
SYSCALL(link)
    1fc1:	b8 13 00 00 00       	mov    $0x13,%eax
    1fc6:	cd 40                	int    $0x40
    1fc8:	c3                   	ret    

00001fc9 <mkdir>:
SYSCALL(mkdir)
    1fc9:	b8 14 00 00 00       	mov    $0x14,%eax
    1fce:	cd 40                	int    $0x40
    1fd0:	c3                   	ret    

00001fd1 <chdir>:
SYSCALL(chdir)
    1fd1:	b8 09 00 00 00       	mov    $0x9,%eax
    1fd6:	cd 40                	int    $0x40
    1fd8:	c3                   	ret    

00001fd9 <dup>:
SYSCALL(dup)
    1fd9:	b8 0a 00 00 00       	mov    $0xa,%eax
    1fde:	cd 40                	int    $0x40
    1fe0:	c3                   	ret    

00001fe1 <getpid>:
SYSCALL(getpid)
    1fe1:	b8 0b 00 00 00       	mov    $0xb,%eax
    1fe6:	cd 40                	int    $0x40
    1fe8:	c3                   	ret    

00001fe9 <sbrk>:
SYSCALL(sbrk)
    1fe9:	b8 0c 00 00 00       	mov    $0xc,%eax
    1fee:	cd 40                	int    $0x40
    1ff0:	c3                   	ret    

00001ff1 <sleep>:
SYSCALL(sleep)
    1ff1:	b8 0d 00 00 00       	mov    $0xd,%eax
    1ff6:	cd 40                	int    $0x40
    1ff8:	c3                   	ret    

00001ff9 <uptime>:
SYSCALL(uptime)
    1ff9:	b8 0e 00 00 00       	mov    $0xe,%eax
    1ffe:	cd 40                	int    $0x40
    2000:	c3                   	ret    

00002001 <clone>:
SYSCALL(clone)
    2001:	b8 16 00 00 00       	mov    $0x16,%eax
    2006:	cd 40                	int    $0x40
    2008:	c3                   	ret    

00002009 <texit>:
SYSCALL(texit)
    2009:	b8 17 00 00 00       	mov    $0x17,%eax
    200e:	cd 40                	int    $0x40
    2010:	c3                   	ret    

00002011 <tsleep>:
SYSCALL(tsleep)
    2011:	b8 18 00 00 00       	mov    $0x18,%eax
    2016:	cd 40                	int    $0x40
    2018:	c3                   	ret    

00002019 <twakeup>:
SYSCALL(twakeup)
    2019:	b8 19 00 00 00       	mov    $0x19,%eax
    201e:	cd 40                	int    $0x40
    2020:	c3                   	ret    

00002021 <thread_yield>:
SYSCALL(thread_yield)
    2021:	b8 1a 00 00 00       	mov    $0x1a,%eax
    2026:	cd 40                	int    $0x40
    2028:	c3                   	ret    

00002029 <thread_yield3>:
    2029:	b8 1a 00 00 00       	mov    $0x1a,%eax
    202e:	cd 40                	int    $0x40
    2030:	c3                   	ret    

00002031 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    2031:	55                   	push   %ebp
    2032:	89 e5                	mov    %esp,%ebp
    2034:	83 ec 18             	sub    $0x18,%esp
    2037:	8b 45 0c             	mov    0xc(%ebp),%eax
    203a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    203d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2044:	00 
    2045:	8d 45 f4             	lea    -0xc(%ebp),%eax
    2048:	89 44 24 04          	mov    %eax,0x4(%esp)
    204c:	8b 45 08             	mov    0x8(%ebp),%eax
    204f:	89 04 24             	mov    %eax,(%esp)
    2052:	e8 2a ff ff ff       	call   1f81 <write>
}
    2057:	c9                   	leave  
    2058:	c3                   	ret    

00002059 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    2059:	55                   	push   %ebp
    205a:	89 e5                	mov    %esp,%ebp
    205c:	56                   	push   %esi
    205d:	53                   	push   %ebx
    205e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    2061:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    2068:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    206c:	74 17                	je     2085 <printint+0x2c>
    206e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    2072:	79 11                	jns    2085 <printint+0x2c>
    neg = 1;
    2074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    207b:	8b 45 0c             	mov    0xc(%ebp),%eax
    207e:	f7 d8                	neg    %eax
    2080:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2083:	eb 06                	jmp    208b <printint+0x32>
  } else {
    x = xx;
    2085:	8b 45 0c             	mov    0xc(%ebp),%eax
    2088:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    208b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    2092:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2095:	8d 41 01             	lea    0x1(%ecx),%eax
    2098:	89 45 f4             	mov    %eax,-0xc(%ebp)
    209b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    20a1:	ba 00 00 00 00       	mov    $0x0,%edx
    20a6:	f7 f3                	div    %ebx
    20a8:	89 d0                	mov    %edx,%eax
    20aa:	0f b6 80 6e 2f 00 00 	movzbl 0x2f6e(%eax),%eax
    20b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    20b5:	8b 75 10             	mov    0x10(%ebp),%esi
    20b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    20bb:	ba 00 00 00 00       	mov    $0x0,%edx
    20c0:	f7 f6                	div    %esi
    20c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    20c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    20c9:	75 c7                	jne    2092 <printint+0x39>
  if(neg)
    20cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    20cf:	74 10                	je     20e1 <printint+0x88>
    buf[i++] = '-';
    20d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20d4:	8d 50 01             	lea    0x1(%eax),%edx
    20d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    20da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    20df:	eb 1f                	jmp    2100 <printint+0xa7>
    20e1:	eb 1d                	jmp    2100 <printint+0xa7>
    putc(fd, buf[i]);
    20e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
    20e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20e9:	01 d0                	add    %edx,%eax
    20eb:	0f b6 00             	movzbl (%eax),%eax
    20ee:	0f be c0             	movsbl %al,%eax
    20f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    20f5:	8b 45 08             	mov    0x8(%ebp),%eax
    20f8:	89 04 24             	mov    %eax,(%esp)
    20fb:	e8 31 ff ff ff       	call   2031 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2100:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    2104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2108:	79 d9                	jns    20e3 <printint+0x8a>
    putc(fd, buf[i]);
}
    210a:	83 c4 30             	add    $0x30,%esp
    210d:	5b                   	pop    %ebx
    210e:	5e                   	pop    %esi
    210f:	5d                   	pop    %ebp
    2110:	c3                   	ret    

00002111 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2111:	55                   	push   %ebp
    2112:	89 e5                	mov    %esp,%ebp
    2114:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    2117:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    211e:	8d 45 0c             	lea    0xc(%ebp),%eax
    2121:	83 c0 04             	add    $0x4,%eax
    2124:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    2127:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    212e:	e9 7c 01 00 00       	jmp    22af <printf+0x19e>
    c = fmt[i] & 0xff;
    2133:	8b 55 0c             	mov    0xc(%ebp),%edx
    2136:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2139:	01 d0                	add    %edx,%eax
    213b:	0f b6 00             	movzbl (%eax),%eax
    213e:	0f be c0             	movsbl %al,%eax
    2141:	25 ff 00 00 00       	and    $0xff,%eax
    2146:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    2149:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    214d:	75 2c                	jne    217b <printf+0x6a>
      if(c == '%'){
    214f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    2153:	75 0c                	jne    2161 <printf+0x50>
        state = '%';
    2155:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    215c:	e9 4a 01 00 00       	jmp    22ab <printf+0x19a>
      } else {
        putc(fd, c);
    2161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2164:	0f be c0             	movsbl %al,%eax
    2167:	89 44 24 04          	mov    %eax,0x4(%esp)
    216b:	8b 45 08             	mov    0x8(%ebp),%eax
    216e:	89 04 24             	mov    %eax,(%esp)
    2171:	e8 bb fe ff ff       	call   2031 <putc>
    2176:	e9 30 01 00 00       	jmp    22ab <printf+0x19a>
      }
    } else if(state == '%'){
    217b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    217f:	0f 85 26 01 00 00    	jne    22ab <printf+0x19a>
      if(c == 'd'){
    2185:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    2189:	75 2d                	jne    21b8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    218b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    218e:	8b 00                	mov    (%eax),%eax
    2190:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    2197:	00 
    2198:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    219f:	00 
    21a0:	89 44 24 04          	mov    %eax,0x4(%esp)
    21a4:	8b 45 08             	mov    0x8(%ebp),%eax
    21a7:	89 04 24             	mov    %eax,(%esp)
    21aa:	e8 aa fe ff ff       	call   2059 <printint>
        ap++;
    21af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    21b3:	e9 ec 00 00 00       	jmp    22a4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    21b8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    21bc:	74 06                	je     21c4 <printf+0xb3>
    21be:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    21c2:	75 2d                	jne    21f1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    21c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    21c7:	8b 00                	mov    (%eax),%eax
    21c9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    21d0:	00 
    21d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    21d8:	00 
    21d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    21dd:	8b 45 08             	mov    0x8(%ebp),%eax
    21e0:	89 04 24             	mov    %eax,(%esp)
    21e3:	e8 71 fe ff ff       	call   2059 <printint>
        ap++;
    21e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    21ec:	e9 b3 00 00 00       	jmp    22a4 <printf+0x193>
      } else if(c == 's'){
    21f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    21f5:	75 45                	jne    223c <printf+0x12b>
        s = (char*)*ap;
    21f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    21fa:	8b 00                	mov    (%eax),%eax
    21fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    21ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    2203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2207:	75 09                	jne    2212 <printf+0x101>
          s = "(null)";
    2209:	c7 45 f4 2c 29 00 00 	movl   $0x292c,-0xc(%ebp)
        while(*s != 0){
    2210:	eb 1e                	jmp    2230 <printf+0x11f>
    2212:	eb 1c                	jmp    2230 <printf+0x11f>
          putc(fd, *s);
    2214:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2217:	0f b6 00             	movzbl (%eax),%eax
    221a:	0f be c0             	movsbl %al,%eax
    221d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2221:	8b 45 08             	mov    0x8(%ebp),%eax
    2224:	89 04 24             	mov    %eax,(%esp)
    2227:	e8 05 fe ff ff       	call   2031 <putc>
          s++;
    222c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    2230:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2233:	0f b6 00             	movzbl (%eax),%eax
    2236:	84 c0                	test   %al,%al
    2238:	75 da                	jne    2214 <printf+0x103>
    223a:	eb 68                	jmp    22a4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    223c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    2240:	75 1d                	jne    225f <printf+0x14e>
        putc(fd, *ap);
    2242:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2245:	8b 00                	mov    (%eax),%eax
    2247:	0f be c0             	movsbl %al,%eax
    224a:	89 44 24 04          	mov    %eax,0x4(%esp)
    224e:	8b 45 08             	mov    0x8(%ebp),%eax
    2251:	89 04 24             	mov    %eax,(%esp)
    2254:	e8 d8 fd ff ff       	call   2031 <putc>
        ap++;
    2259:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    225d:	eb 45                	jmp    22a4 <printf+0x193>
      } else if(c == '%'){
    225f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    2263:	75 17                	jne    227c <printf+0x16b>
        putc(fd, c);
    2265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2268:	0f be c0             	movsbl %al,%eax
    226b:	89 44 24 04          	mov    %eax,0x4(%esp)
    226f:	8b 45 08             	mov    0x8(%ebp),%eax
    2272:	89 04 24             	mov    %eax,(%esp)
    2275:	e8 b7 fd ff ff       	call   2031 <putc>
    227a:	eb 28                	jmp    22a4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    227c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    2283:	00 
    2284:	8b 45 08             	mov    0x8(%ebp),%eax
    2287:	89 04 24             	mov    %eax,(%esp)
    228a:	e8 a2 fd ff ff       	call   2031 <putc>
        putc(fd, c);
    228f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2292:	0f be c0             	movsbl %al,%eax
    2295:	89 44 24 04          	mov    %eax,0x4(%esp)
    2299:	8b 45 08             	mov    0x8(%ebp),%eax
    229c:	89 04 24             	mov    %eax,(%esp)
    229f:	e8 8d fd ff ff       	call   2031 <putc>
      }
      state = 0;
    22a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    22ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    22af:	8b 55 0c             	mov    0xc(%ebp),%edx
    22b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22b5:	01 d0                	add    %edx,%eax
    22b7:	0f b6 00             	movzbl (%eax),%eax
    22ba:	84 c0                	test   %al,%al
    22bc:	0f 85 71 fe ff ff    	jne    2133 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    22c2:	c9                   	leave  
    22c3:	c3                   	ret    

000022c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    22c4:	55                   	push   %ebp
    22c5:	89 e5                	mov    %esp,%ebp
    22c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    22ca:	8b 45 08             	mov    0x8(%ebp),%eax
    22cd:	83 e8 08             	sub    $0x8,%eax
    22d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    22d3:	a1 0c 30 00 00       	mov    0x300c,%eax
    22d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    22db:	eb 24                	jmp    2301 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    22dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22e0:	8b 00                	mov    (%eax),%eax
    22e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    22e5:	77 12                	ja     22f9 <free+0x35>
    22e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    22ed:	77 24                	ja     2313 <free+0x4f>
    22ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22f2:	8b 00                	mov    (%eax),%eax
    22f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    22f7:	77 1a                	ja     2313 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    22f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22fc:	8b 00                	mov    (%eax),%eax
    22fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    2301:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2304:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    2307:	76 d4                	jbe    22dd <free+0x19>
    2309:	8b 45 fc             	mov    -0x4(%ebp),%eax
    230c:	8b 00                	mov    (%eax),%eax
    230e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2311:	76 ca                	jbe    22dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    2313:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2316:	8b 40 04             	mov    0x4(%eax),%eax
    2319:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    2320:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2323:	01 c2                	add    %eax,%edx
    2325:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2328:	8b 00                	mov    (%eax),%eax
    232a:	39 c2                	cmp    %eax,%edx
    232c:	75 24                	jne    2352 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    232e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2331:	8b 50 04             	mov    0x4(%eax),%edx
    2334:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2337:	8b 00                	mov    (%eax),%eax
    2339:	8b 40 04             	mov    0x4(%eax),%eax
    233c:	01 c2                	add    %eax,%edx
    233e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2341:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    2344:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2347:	8b 00                	mov    (%eax),%eax
    2349:	8b 10                	mov    (%eax),%edx
    234b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    234e:	89 10                	mov    %edx,(%eax)
    2350:	eb 0a                	jmp    235c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    2352:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2355:	8b 10                	mov    (%eax),%edx
    2357:	8b 45 f8             	mov    -0x8(%ebp),%eax
    235a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    235c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    235f:	8b 40 04             	mov    0x4(%eax),%eax
    2362:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    2369:	8b 45 fc             	mov    -0x4(%ebp),%eax
    236c:	01 d0                	add    %edx,%eax
    236e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2371:	75 20                	jne    2393 <free+0xcf>
    p->s.size += bp->s.size;
    2373:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2376:	8b 50 04             	mov    0x4(%eax),%edx
    2379:	8b 45 f8             	mov    -0x8(%ebp),%eax
    237c:	8b 40 04             	mov    0x4(%eax),%eax
    237f:	01 c2                	add    %eax,%edx
    2381:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2384:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    2387:	8b 45 f8             	mov    -0x8(%ebp),%eax
    238a:	8b 10                	mov    (%eax),%edx
    238c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    238f:	89 10                	mov    %edx,(%eax)
    2391:	eb 08                	jmp    239b <free+0xd7>
  } else
    p->s.ptr = bp;
    2393:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2396:	8b 55 f8             	mov    -0x8(%ebp),%edx
    2399:	89 10                	mov    %edx,(%eax)
  freep = p;
    239b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    239e:	a3 0c 30 00 00       	mov    %eax,0x300c
}
    23a3:	c9                   	leave  
    23a4:	c3                   	ret    

000023a5 <morecore>:

static Header*
morecore(uint nu)
{
    23a5:	55                   	push   %ebp
    23a6:	89 e5                	mov    %esp,%ebp
    23a8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    23ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    23b2:	77 07                	ja     23bb <morecore+0x16>
    nu = 4096;
    23b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    23bb:	8b 45 08             	mov    0x8(%ebp),%eax
    23be:	c1 e0 03             	shl    $0x3,%eax
    23c1:	89 04 24             	mov    %eax,(%esp)
    23c4:	e8 20 fc ff ff       	call   1fe9 <sbrk>
    23c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    23cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    23d0:	75 07                	jne    23d9 <morecore+0x34>
    return 0;
    23d2:	b8 00 00 00 00       	mov    $0x0,%eax
    23d7:	eb 22                	jmp    23fb <morecore+0x56>
  hp = (Header*)p;
    23d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    23df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23e2:	8b 55 08             	mov    0x8(%ebp),%edx
    23e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    23e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23eb:	83 c0 08             	add    $0x8,%eax
    23ee:	89 04 24             	mov    %eax,(%esp)
    23f1:	e8 ce fe ff ff       	call   22c4 <free>
  return freep;
    23f6:	a1 0c 30 00 00       	mov    0x300c,%eax
}
    23fb:	c9                   	leave  
    23fc:	c3                   	ret    

000023fd <malloc>:

void*
malloc(uint nbytes)
{
    23fd:	55                   	push   %ebp
    23fe:	89 e5                	mov    %esp,%ebp
    2400:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2403:	8b 45 08             	mov    0x8(%ebp),%eax
    2406:	83 c0 07             	add    $0x7,%eax
    2409:	c1 e8 03             	shr    $0x3,%eax
    240c:	83 c0 01             	add    $0x1,%eax
    240f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    2412:	a1 0c 30 00 00       	mov    0x300c,%eax
    2417:	89 45 f0             	mov    %eax,-0x10(%ebp)
    241a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    241e:	75 23                	jne    2443 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    2420:	c7 45 f0 04 30 00 00 	movl   $0x3004,-0x10(%ebp)
    2427:	8b 45 f0             	mov    -0x10(%ebp),%eax
    242a:	a3 0c 30 00 00       	mov    %eax,0x300c
    242f:	a1 0c 30 00 00       	mov    0x300c,%eax
    2434:	a3 04 30 00 00       	mov    %eax,0x3004
    base.s.size = 0;
    2439:	c7 05 08 30 00 00 00 	movl   $0x0,0x3008
    2440:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2443:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2446:	8b 00                	mov    (%eax),%eax
    2448:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    244e:	8b 40 04             	mov    0x4(%eax),%eax
    2451:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    2454:	72 4d                	jb     24a3 <malloc+0xa6>
      if(p->s.size == nunits)
    2456:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2459:	8b 40 04             	mov    0x4(%eax),%eax
    245c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    245f:	75 0c                	jne    246d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    2461:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2464:	8b 10                	mov    (%eax),%edx
    2466:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2469:	89 10                	mov    %edx,(%eax)
    246b:	eb 26                	jmp    2493 <malloc+0x96>
      else {
        p->s.size -= nunits;
    246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2470:	8b 40 04             	mov    0x4(%eax),%eax
    2473:	2b 45 ec             	sub    -0x14(%ebp),%eax
    2476:	89 c2                	mov    %eax,%edx
    2478:	8b 45 f4             	mov    -0xc(%ebp),%eax
    247b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2481:	8b 40 04             	mov    0x4(%eax),%eax
    2484:	c1 e0 03             	shl    $0x3,%eax
    2487:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    248d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    2490:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    2493:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2496:	a3 0c 30 00 00       	mov    %eax,0x300c
      return (void*)(p + 1);
    249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    249e:	83 c0 08             	add    $0x8,%eax
    24a1:	eb 38                	jmp    24db <malloc+0xde>
    }
    if(p == freep)
    24a3:	a1 0c 30 00 00       	mov    0x300c,%eax
    24a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    24ab:	75 1b                	jne    24c8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    24ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24b0:	89 04 24             	mov    %eax,(%esp)
    24b3:	e8 ed fe ff ff       	call   23a5 <morecore>
    24b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    24bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    24bf:	75 07                	jne    24c8 <malloc+0xcb>
        return 0;
    24c1:	b8 00 00 00 00       	mov    $0x0,%eax
    24c6:	eb 13                	jmp    24db <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    24c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    24ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24d1:	8b 00                	mov    (%eax),%eax
    24d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    24d6:	e9 70 ff ff ff       	jmp    244b <malloc+0x4e>
}
    24db:	c9                   	leave  
    24dc:	c3                   	ret    

000024dd <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    24dd:	55                   	push   %ebp
    24de:	89 e5                	mov    %esp,%ebp
    24e0:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    24e3:	8b 55 08             	mov    0x8(%ebp),%edx
    24e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    24e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    24ec:	f0 87 02             	lock xchg %eax,(%edx)
    24ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    24f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    24f5:	c9                   	leave  
    24f6:	c3                   	ret    

000024f7 <lock_init>:
#include "proc.h"
#include "queue.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    24f7:	55                   	push   %ebp
    24f8:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    24fa:	8b 45 08             	mov    0x8(%ebp),%eax
    24fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    2503:	5d                   	pop    %ebp
    2504:	c3                   	ret    

00002505 <lock_acquire>:
void lock_acquire(lock_t *lock){
    2505:	55                   	push   %ebp
    2506:	89 e5                	mov    %esp,%ebp
    2508:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    250b:	90                   	nop
    250c:	8b 45 08             	mov    0x8(%ebp),%eax
    250f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2516:	00 
    2517:	89 04 24             	mov    %eax,(%esp)
    251a:	e8 be ff ff ff       	call   24dd <xchg>
    251f:	85 c0                	test   %eax,%eax
    2521:	75 e9                	jne    250c <lock_acquire+0x7>
}
    2523:	c9                   	leave  
    2524:	c3                   	ret    

00002525 <lock_release>:
void lock_release(lock_t *lock){
    2525:	55                   	push   %ebp
    2526:	89 e5                	mov    %esp,%ebp
    2528:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    252b:	8b 45 08             	mov    0x8(%ebp),%eax
    252e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2535:	00 
    2536:	89 04 24             	mov    %eax,(%esp)
    2539:	e8 9f ff ff ff       	call   24dd <xchg>
}
    253e:	c9                   	leave  
    253f:	c3                   	ret    

00002540 <thread_create>:

struct queue *thQ2;
unsigned char inQ = 0;

void *thread_create(void(*start_routine)(void*), void *arg){
    2540:	55                   	push   %ebp
    2541:	89 e5                	mov    %esp,%ebp
    2543:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    2546:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    254d:	e8 ab fe ff ff       	call   23fd <malloc>
    2552:	89 45 f4             	mov    %eax,-0xc(%ebp)
    void *garbage_stack = stack; 
    2555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2558:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);
    if (inQ == 0) {
    255b:	0f b6 05 10 30 00 00 	movzbl 0x3010,%eax
    2562:	84 c0                	test   %al,%al
    2564:	75 1c                	jne    2582 <thread_create+0x42>
        init_q(thQ2);
    2566:	a1 18 30 00 00       	mov    0x3018,%eax
    256b:	89 04 24             	mov    %eax,(%esp)
    256e:	e8 b2 01 00 00       	call   2725 <init_q>
        inQ++;
    2573:	0f b6 05 10 30 00 00 	movzbl 0x3010,%eax
    257a:	83 c0 01             	add    $0x1,%eax
    257d:	a2 10 30 00 00       	mov    %al,0x3010
    }

    if((uint)stack % 4096){
    2582:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2585:	25 ff 0f 00 00       	and    $0xfff,%eax
    258a:	85 c0                	test   %eax,%eax
    258c:	74 14                	je     25a2 <thread_create+0x62>
        stack = stack + (4096 - (uint)stack % 4096);
    258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2591:	25 ff 0f 00 00       	and    $0xfff,%eax
    2596:	89 c2                	mov    %eax,%edx
    2598:	b8 00 10 00 00       	mov    $0x1000,%eax
    259d:	29 d0                	sub    %edx,%eax
    259f:	01 45 f4             	add    %eax,-0xc(%ebp)
    }
    if (stack == 0){
    25a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    25a6:	75 1e                	jne    25c6 <thread_create+0x86>

        printf(1,"malloc fail \n");
    25a8:	c7 44 24 04 33 29 00 	movl   $0x2933,0x4(%esp)
    25af:	00 
    25b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25b7:	e8 55 fb ff ff       	call   2111 <printf>
        return 0;
    25bc:	b8 00 00 00 00       	mov    $0x0,%eax
    25c1:	e9 83 00 00 00       	jmp    2649 <thread_create+0x109>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    25c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    25c9:	8b 55 08             	mov    0x8(%ebp),%edx
    25cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    25d3:	89 54 24 08          	mov    %edx,0x8(%esp)
    25d7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    25de:	00 
    25df:	89 04 24             	mov    %eax,(%esp)
    25e2:	e8 1a fa ff ff       	call   2001 <clone>
    25e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //printf(1,"clone returned tid = %d\n",tid);
    if(tid < 0){
    25ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    25ee:	79 1b                	jns    260b <thread_create+0xcb>
        printf(1,"clone fails\n");
    25f0:	c7 44 24 04 41 29 00 	movl   $0x2941,0x4(%esp)
    25f7:	00 
    25f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25ff:	e8 0d fb ff ff       	call   2111 <printf>
        return 0;
    2604:	b8 00 00 00 00       	mov    $0x0,%eax
    2609:	eb 3e                	jmp    2649 <thread_create+0x109>
    }
    if(tid > 0){
    260b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    260f:	7e 19                	jle    262a <thread_create+0xea>
        //store threads on thread table
        add_q(thQ2, tid);
    2611:	a1 18 30 00 00       	mov    0x3018,%eax
    2616:	8b 55 ec             	mov    -0x14(%ebp),%edx
    2619:	89 54 24 04          	mov    %edx,0x4(%esp)
    261d:	89 04 24             	mov    %eax,(%esp)
    2620:	e8 22 01 00 00       	call   2747 <add_q>
        return garbage_stack;
    2625:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2628:	eb 1f                	jmp    2649 <thread_create+0x109>
    }
    if(tid == 0){
    262a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    262e:	75 14                	jne    2644 <thread_create+0x104>
        printf(1,"tid = 0 return \n");
    2630:	c7 44 24 04 4e 29 00 	movl   $0x294e,0x4(%esp)
    2637:	00 
    2638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    263f:	e8 cd fa ff ff       	call   2111 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    2644:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2649:	c9                   	leave  
    264a:	c3                   	ret    

0000264b <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    264b:	55                   	push   %ebp
    264c:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    264e:	a1 80 2f 00 00       	mov    0x2f80,%eax
    2653:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    2659:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    265e:	a3 80 2f 00 00       	mov    %eax,0x2f80
    return (int)(rands % max);
    2663:	a1 80 2f 00 00       	mov    0x2f80,%eax
    2668:	8b 4d 08             	mov    0x8(%ebp),%ecx
    266b:	ba 00 00 00 00       	mov    $0x0,%edx
    2670:	f7 f1                	div    %ecx
    2672:	89 d0                	mov    %edx,%eax
}
    2674:	5d                   	pop    %ebp
    2675:	c3                   	ret    

00002676 <thread_yield2>:

////////////////////////////////////////////////////////
void thread_yield2(){
    2676:	55                   	push   %ebp
    2677:	89 e5                	mov    %esp,%ebp
    2679:	83 ec 28             	sub    $0x28,%esp
    static int popp = 0;
    

    int tid2 = getpid();
    267c:	e8 60 f9 ff ff       	call   1fe1 <getpid>
    2681:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"thQ2 Size1 %d PID: %d \n", thQ2->size, tid2);
    add_q(thQ2, tid2);
    2684:	a1 18 30 00 00       	mov    0x3018,%eax
    2689:	8b 55 f0             	mov    -0x10(%ebp),%edx
    268c:	89 54 24 04          	mov    %edx,0x4(%esp)
    2690:	89 04 24             	mov    %eax,(%esp)
    2693:	e8 af 00 00 00       	call   2747 <add_q>
    //printf(1,"thQ2 Size2 %d \n", thQ2->size);
    int tidNext = pop_q(thQ2);
    2698:	a1 18 30 00 00       	mov    0x3018,%eax
    269d:	89 04 24             	mov    %eax,(%esp)
    26a0:	e8 1c 01 00 00       	call   27c1 <pop_q>
    26a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (popp == 0) {
    26a8:	a1 14 30 00 00       	mov    0x3014,%eax
    26ad:	85 c0                	test   %eax,%eax
    26af:	75 1f                	jne    26d0 <thread_yield2+0x5a>
        tidNext = pop_q(thQ2);
    26b1:	a1 18 30 00 00       	mov    0x3018,%eax
    26b6:	89 04 24             	mov    %eax,(%esp)
    26b9:	e8 03 01 00 00       	call   27c1 <pop_q>
    26be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        popp++;
    26c1:	a1 14 30 00 00       	mov    0x3014,%eax
    26c6:	83 c0 01             	add    $0x1,%eax
    26c9:	a3 14 30 00 00       	mov    %eax,0x3014
    }
    while ((tid2 == tidNext) || (tidNext == 0)) tidNext = pop_q(thQ2);
    26ce:	eb 12                	jmp    26e2 <thread_yield2+0x6c>
    26d0:	eb 10                	jmp    26e2 <thread_yield2+0x6c>
    26d2:	a1 18 30 00 00       	mov    0x3018,%eax
    26d7:	89 04 24             	mov    %eax,(%esp)
    26da:	e8 e2 00 00 00       	call   27c1 <pop_q>
    26df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    26e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    26e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    26e8:	74 e8                	je     26d2 <thread_yield2+0x5c>
    26ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    26ee:	74 e2                	je     26d2 <thread_yield2+0x5c>
    //printf(1,"thQ2 Size3 %d TID: %d \n", thQ2->size, tidNext);
    //if ()
    twakeup(tidNext);
    26f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26f3:	89 04 24             	mov    %eax,(%esp)
    26f6:	e8 1e f9 ff ff       	call   2019 <twakeup>
    tsleep();
    26fb:	e8 11 f9 ff ff       	call   2011 <tsleep>
    //thread_yield3(tidNext);
    
    //add_q(thQ2, tid2);
    //proc->state = RUNNABLE;
    //thread_yield3(0);
}
    2700:	c9                   	leave  
    2701:	c3                   	ret    

00002702 <thread_yield_last>:

void thread_yield_last(){
    2702:	55                   	push   %ebp
    2703:	89 e5                	mov    %esp,%ebp
    2705:	83 ec 28             	sub    $0x28,%esp
    int tidNext = pop_q(thQ2);
    2708:	a1 18 30 00 00       	mov    0x3018,%eax
    270d:	89 04 24             	mov    %eax,(%esp)
    2710:	e8 ac 00 00 00       	call   27c1 <pop_q>
    2715:	89 45 f4             	mov    %eax,-0xc(%ebp)
    twakeup(tidNext);
    2718:	8b 45 f4             	mov    -0xc(%ebp),%eax
    271b:	89 04 24             	mov    %eax,(%esp)
    271e:	e8 f6 f8 ff ff       	call   2019 <twakeup>
    2723:	c9                   	leave  
    2724:	c3                   	ret    

00002725 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"


void init_q(struct queue *q){
    2725:	55                   	push   %ebp
    2726:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    2728:	8b 45 08             	mov    0x8(%ebp),%eax
    272b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    2731:	8b 45 08             	mov    0x8(%ebp),%eax
    2734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    273b:	8b 45 08             	mov    0x8(%ebp),%eax
    273e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    2745:	5d                   	pop    %ebp
    2746:	c3                   	ret    

00002747 <add_q>:

void add_q(struct queue *q, int v){
    2747:	55                   	push   %ebp
    2748:	89 e5                	mov    %esp,%ebp
    274a:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    274d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    2754:	e8 a4 fc ff ff       	call   23fd <malloc>
    2759:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    275f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    2766:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2769:	8b 55 0c             	mov    0xc(%ebp),%edx
    276c:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    276e:	8b 45 08             	mov    0x8(%ebp),%eax
    2771:	8b 40 04             	mov    0x4(%eax),%eax
    2774:	85 c0                	test   %eax,%eax
    2776:	75 0b                	jne    2783 <add_q+0x3c>
        q->head = n;
    2778:	8b 45 08             	mov    0x8(%ebp),%eax
    277b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    277e:	89 50 04             	mov    %edx,0x4(%eax)
    2781:	eb 0c                	jmp    278f <add_q+0x48>
    }else{
        q->tail->next = n;
    2783:	8b 45 08             	mov    0x8(%ebp),%eax
    2786:	8b 40 08             	mov    0x8(%eax),%eax
    2789:	8b 55 f4             	mov    -0xc(%ebp),%edx
    278c:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    278f:	8b 45 08             	mov    0x8(%ebp),%eax
    2792:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2795:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    2798:	8b 45 08             	mov    0x8(%ebp),%eax
    279b:	8b 00                	mov    (%eax),%eax
    279d:	8d 50 01             	lea    0x1(%eax),%edx
    27a0:	8b 45 08             	mov    0x8(%ebp),%eax
    27a3:	89 10                	mov    %edx,(%eax)
}
    27a5:	c9                   	leave  
    27a6:	c3                   	ret    

000027a7 <empty_q>:

int empty_q(struct queue *q){
    27a7:	55                   	push   %ebp
    27a8:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    27aa:	8b 45 08             	mov    0x8(%ebp),%eax
    27ad:	8b 00                	mov    (%eax),%eax
    27af:	85 c0                	test   %eax,%eax
    27b1:	75 07                	jne    27ba <empty_q+0x13>
        return 1;
    27b3:	b8 01 00 00 00       	mov    $0x1,%eax
    27b8:	eb 05                	jmp    27bf <empty_q+0x18>
    else
        return 0;
    27ba:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    27bf:	5d                   	pop    %ebp
    27c0:	c3                   	ret    

000027c1 <pop_q>:
int pop_q(struct queue *q){
    27c1:	55                   	push   %ebp
    27c2:	89 e5                	mov    %esp,%ebp
    27c4:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    27c7:	8b 45 08             	mov    0x8(%ebp),%eax
    27ca:	89 04 24             	mov    %eax,(%esp)
    27cd:	e8 d5 ff ff ff       	call   27a7 <empty_q>
    27d2:	85 c0                	test   %eax,%eax
    27d4:	75 5d                	jne    2833 <pop_q+0x72>
       val = q->head->value; 
    27d6:	8b 45 08             	mov    0x8(%ebp),%eax
    27d9:	8b 40 04             	mov    0x4(%eax),%eax
    27dc:	8b 00                	mov    (%eax),%eax
    27de:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
    27e1:	8b 45 08             	mov    0x8(%ebp),%eax
    27e4:	8b 40 04             	mov    0x4(%eax),%eax
    27e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
    27ea:	8b 45 08             	mov    0x8(%ebp),%eax
    27ed:	8b 40 04             	mov    0x4(%eax),%eax
    27f0:	8b 50 04             	mov    0x4(%eax),%edx
    27f3:	8b 45 08             	mov    0x8(%ebp),%eax
    27f6:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    27f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    27fc:	89 04 24             	mov    %eax,(%esp)
    27ff:	e8 c0 fa ff ff       	call   22c4 <free>
       q->size--;
    2804:	8b 45 08             	mov    0x8(%ebp),%eax
    2807:	8b 00                	mov    (%eax),%eax
    2809:	8d 50 ff             	lea    -0x1(%eax),%edx
    280c:	8b 45 08             	mov    0x8(%ebp),%eax
    280f:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    2811:	8b 45 08             	mov    0x8(%ebp),%eax
    2814:	8b 00                	mov    (%eax),%eax
    2816:	85 c0                	test   %eax,%eax
    2818:	75 14                	jne    282e <pop_q+0x6d>
            q->head = 0;
    281a:	8b 45 08             	mov    0x8(%ebp),%eax
    281d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    2824:	8b 45 08             	mov    0x8(%ebp),%eax
    2827:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2831:	eb 05                	jmp    2838 <pop_q+0x77>
    }
    return -1;
    2833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    2838:	c9                   	leave  
    2839:	c3                   	ret    
