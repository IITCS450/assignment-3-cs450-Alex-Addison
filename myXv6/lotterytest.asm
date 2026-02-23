
_lotterytest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

static volatile int sink = 0;

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  int nchildren = 4;
  10:	bb 04 00 00 00       	mov    $0x4,%ebx
{
  15:	51                   	push   %ecx
  16:	81 ec e8 00 00 00    	sub    $0xe8,%esp
  1c:	8b 39                	mov    (%ecx),%edi
  1e:	8b 71 04             	mov    0x4(%ecx),%esi
  int duration = 5;
  21:	c7 85 10 ff ff ff 05 	movl   $0x5,-0xf0(%ebp)
  28:	00 00 00 
  const int MAXCHILD = 16;

  if(argc >= 2) nchildren = atoi(argv[1]);
  2b:	83 ff 01             	cmp    $0x1,%edi
  2e:	0f 8f f1 00 00 00    	jg     125 <main+0x125>
  if(argc >= 3) duration = atoi(argv[2]);
  if(nchildren < 1) nchildren = 1;
  34:	b8 10 00 00 00       	mov    $0x10,%eax
  39:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  3f:	39 c3                	cmp    %eax,%ebx
  41:	0f 4f d8             	cmovg  %eax,%ebx
  44:	b8 01 00 00 00       	mov    $0x1,%eax
  49:	85 db                	test   %ebx,%ebx
  4b:	0f 4e d8             	cmovle %eax,%ebx
  int ticks_per_sec = 100;
  int duration_ticks = duration * ticks_per_sec;

  int pipes[MAXCHILD][2];
  int i;
  for(i = 0; i < nchildren; i++){
  4e:	8d bc dd 68 ff ff ff 	lea    -0x98(%ebp,%ebx,8),%edi
  55:	8d 76 00             	lea    0x0(%esi),%esi
    if(pipe(pipes[i]) < 0){
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	56                   	push   %esi
  5c:	e8 c2 04 00 00       	call   523 <pipe>
  61:	83 c4 10             	add    $0x10,%esp
  64:	85 c0                	test   %eax,%eax
  66:	0f 88 a6 00 00 00    	js     112 <main+0x112>
  for(i = 0; i < nchildren; i++){
  6c:	83 c6 08             	add    $0x8,%esi
  6f:	39 fe                	cmp    %edi,%esi
  71:	75 e5                	jne    58 <main+0x58>
      printf(2, "pipe failed\n");
      exit();
    }
  }

  for(i = 0; i < nchildren; i++){
  73:	31 ff                	xor    %edi,%edi
  75:	8d 76 00             	lea    0x0(%esi),%esi
    int pid = fork();
  78:	e8 8e 04 00 00       	call   50b <fork>
    if(pid == 0){
  7d:	89 fe                	mov    %edi,%esi
      // child
      close(pipes[i][0]); // close read end
      // child i gets i+1 tickets
      settickets(i+1);
  7f:	8d 7f 01             	lea    0x1(%edi),%edi
    if(pid == 0){
  82:	85 c0                	test   %eax,%eax
  84:	0f 84 89 01 00 00    	je     213 <main+0x213>
      // write final count to parent
      write(pipes[i][1], &count, sizeof(count));
      close(pipes[i][1]);
      exit();
    }
    close(pipes[i][1]);
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	ff b4 fd 64 ff ff ff 	pushl  -0x9c(%ebp,%edi,8)
  94:	e8 a2 04 00 00       	call   53b <close>
  for(i = 0; i < nchildren; i++){
  99:	83 c4 10             	add    $0x10,%esp
  9c:	39 df                	cmp    %ebx,%edi
  9e:	75 d8                	jne    78 <main+0x78>
  }

  // parent reads results from each child
  unsigned counts[MAXCHILD];
  unsigned total = 0;
  a0:	c7 85 14 ff ff ff 00 	movl   $0x0,-0xec(%ebp)
  a7:	00 00 00 
  for(i = 0; i < nchildren; i++){
  aa:	31 f6                	xor    %esi,%esi
  ac:	8d bd 24 ff ff ff    	lea    -0xdc(%ebp),%edi
  b2:	eb 2c                	jmp    e0 <main+0xe0>
    unsigned v = 0;
    int r = read(pipes[i][0], &v, sizeof(v));
    if(r != sizeof(v)) v = 0;
  b4:	c7 85 24 ff ff ff 00 	movl   $0x0,-0xdc(%ebp)
  bb:	00 00 00 
  be:	31 c0                	xor    %eax,%eax
    counts[i] = v;
    total += v;
    close(pipes[i][0]);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	ff b4 f5 68 ff ff ff 	pushl  -0x98(%ebp,%esi,8)
    counts[i] = v;
  ca:	89 84 b5 28 ff ff ff 	mov    %eax,-0xd8(%ebp,%esi,4)
  for(i = 0; i < nchildren; i++){
  d1:	83 c6 01             	add    $0x1,%esi
    close(pipes[i][0]);
  d4:	e8 62 04 00 00       	call   53b <close>
  for(i = 0; i < nchildren; i++){
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	39 f3                	cmp    %esi,%ebx
  de:	74 77                	je     157 <main+0x157>
    unsigned v = 0;
  e0:	c7 85 24 ff ff ff 00 	movl   $0x0,-0xdc(%ebp)
  e7:	00 00 00 
    int r = read(pipes[i][0], &v, sizeof(v));
  ea:	83 ec 04             	sub    $0x4,%esp
  ed:	6a 04                	push   $0x4
  ef:	57                   	push   %edi
  f0:	ff b4 f5 68 ff ff ff 	pushl  -0x98(%ebp,%esi,8)
  f7:	e8 2f 04 00 00       	call   52b <read>
    if(r != sizeof(v)) v = 0;
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	83 f8 04             	cmp    $0x4,%eax
 102:	75 b0                	jne    b4 <main+0xb4>
    counts[i] = v;
 104:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
    total += v;
 10a:	01 85 14 ff ff ff    	add    %eax,-0xec(%ebp)
 110:	eb ae                	jmp    c0 <main+0xc0>
      printf(2, "pipe failed\n");
 112:	50                   	push   %eax
 113:	50                   	push   %eax
 114:	68 98 09 00 00       	push   $0x998
 119:	6a 02                	push   $0x2
 11b:	e8 50 05 00 00       	call   670 <printf>
      exit();
 120:	e8 ee 03 00 00       	call   513 <exit>
  if(argc >= 2) nchildren = atoi(argv[1]);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 76 04             	pushl  0x4(%esi)
 12b:	e8 70 03 00 00       	call   4a0 <atoi>
  if(argc >= 3) duration = atoi(argv[2]);
 130:	83 c4 10             	add    $0x10,%esp
  if(argc >= 2) nchildren = atoi(argv[1]);
 133:	89 c3                	mov    %eax,%ebx
  if(argc >= 3) duration = atoi(argv[2]);
 135:	83 ff 02             	cmp    $0x2,%edi
 138:	0f 84 f6 fe ff ff    	je     34 <main+0x34>
 13e:	83 ec 0c             	sub    $0xc,%esp
 141:	ff 76 08             	pushl  0x8(%esi)
 144:	e8 57 03 00 00       	call   4a0 <atoi>
 149:	83 c4 10             	add    $0x10,%esp
 14c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
 152:	e9 dd fe ff ff       	jmp    34 <main+0x34>
  }

  // reap children
  for(i = 0; i < nchildren; i++) wait();
 157:	31 ff                	xor    %edi,%edi
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	e8 b6 03 00 00       	call   51b <wait>
 165:	83 c7 01             	add    $0x1,%edi
 168:	39 fb                	cmp    %edi,%ebx
 16a:	75 f4                	jne    160 <main+0x160>

  printf(1, "Lottery test results: %d children, %d seconds\n", nchildren, duration);
 16c:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  printf(1, "Child\tTickets\tCount\tShare(%%)\n");
  for(i = 0; i < nchildren; i++){
 172:	31 ff                	xor    %edi,%edi
  printf(1, "Lottery test results: %d children, %d seconds\n", nchildren, duration);
 174:	53                   	push   %ebx
 175:	68 d0 09 00 00       	push   $0x9d0
 17a:	6a 01                	push   $0x1
 17c:	e8 ef 04 00 00       	call   670 <printf>
  printf(1, "Child\tTickets\tCount\tShare(%%)\n");
 181:	5a                   	pop    %edx
 182:	59                   	pop    %ecx
 183:	68 00 0a 00 00       	push   $0xa00
 188:	6a 01                	push   $0x1
 18a:	e8 e1 04 00 00       	call   670 <printf>
    int t = i+1;
    // share in tenths of percent to avoid floats
    int share_x10 = (total > 0) ? (counts[i] * 1000 / total) : 0;
    int share_whole = share_x10 / 10;
 18f:	89 9d 10 ff ff ff    	mov    %ebx,-0xf0(%ebp)
  printf(1, "Child\tTickets\tCount\tShare(%%)\n");
 195:	83 c4 10             	add    $0x10,%esp
 198:	eb 45                	jmp    1df <main+0x1df>
    int share_x10 = (total > 0) ? (counts[i] * 1000 / total) : 0;
 19a:	69 c3 e8 03 00 00    	imul   $0x3e8,%ebx,%eax
 1a0:	31 d2                	xor    %edx,%edx
 1a2:	f7 f1                	div    %ecx
 1a4:	89 c1                	mov    %eax,%ecx
    int share_whole = share_x10 / 10;
 1a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
 1ab:	f7 e9                	imul   %ecx
 1ad:	89 d0                	mov    %edx,%eax
 1af:	89 ca                	mov    %ecx,%edx
 1b1:	c1 fa 1f             	sar    $0x1f,%edx
 1b4:	c1 f8 02             	sar    $0x2,%eax
 1b7:	29 d0                	sub    %edx,%eax
    int share_dec = share_x10 % 10;
 1b9:	8d 14 80             	lea    (%eax,%eax,4),%edx
 1bc:	01 d2                	add    %edx,%edx
 1be:	29 d1                	sub    %edx,%ecx
    printf(1, "%d\t%d\t%d\t%d.%d%%\n", i, t, counts[i], share_whole, share_dec);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	51                   	push   %ecx
 1c4:	50                   	push   %eax
 1c5:	53                   	push   %ebx
 1c6:	57                   	push   %edi
 1c7:	56                   	push   %esi
 1c8:	68 a5 09 00 00       	push   $0x9a5
 1cd:	6a 01                	push   $0x1
 1cf:	e8 9c 04 00 00       	call   670 <printf>
  for(i = 0; i < nchildren; i++){
 1d4:	83 c4 20             	add    $0x20,%esp
 1d7:	3b bd 10 ff ff ff    	cmp    -0xf0(%ebp),%edi
 1dd:	74 1c                	je     1fb <main+0x1fb>
    int share_x10 = (total > 0) ? (counts[i] * 1000 / total) : 0;
 1df:	8b 8d 14 ff ff ff    	mov    -0xec(%ebp),%ecx
 1e5:	89 fe                	mov    %edi,%esi
    int t = i+1;
 1e7:	83 c7 01             	add    $0x1,%edi
    int share_x10 = (total > 0) ? (counts[i] * 1000 / total) : 0;
 1ea:	8b 9c bd 24 ff ff ff 	mov    -0xdc(%ebp,%edi,4),%ebx
 1f1:	85 c9                	test   %ecx,%ecx
 1f3:	75 a5                	jne    19a <main+0x19a>
 1f5:	31 c9                	xor    %ecx,%ecx
 1f7:	31 c0                	xor    %eax,%eax
 1f9:	eb c5                	jmp    1c0 <main+0x1c0>
  }
  printf(1, "Total work-units: %d\n", total);
 1fb:	50                   	push   %eax
 1fc:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
 202:	68 b7 09 00 00       	push   $0x9b7
 207:	6a 01                	push   $0x1
 209:	e8 62 04 00 00       	call   670 <printf>
  exit();
 20e:	e8 00 03 00 00       	call   513 <exit>
      close(pipes[i][0]); // close read end
 213:	83 ec 0c             	sub    $0xc,%esp
  int duration_ticks = duration * ticks_per_sec;
 216:	6b 85 10 ff ff ff 64 	imul   $0x64,-0xf0(%ebp),%eax
      close(pipes[i][0]); // close read end
 21d:	ff b4 f5 68 ff ff ff 	pushl  -0x98(%ebp,%esi,8)
  int duration_ticks = duration * ticks_per_sec;
 224:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
      close(pipes[i][0]); // close read end
 22a:	e8 0c 03 00 00       	call   53b <close>
      settickets(i+1);
 22f:	89 3c 24             	mov    %edi,(%esp)
 232:	e8 7c 03 00 00       	call   5b3 <settickets>
      int start = uptime();
 237:	e8 6f 03 00 00       	call   5ab <uptime>
 23c:	8b bd 14 ff ff ff    	mov    -0xec(%ebp),%edi
      while(uptime() - start < duration_ticks){
 242:	83 c4 10             	add    $0x10,%esp
      int start = uptime();
 245:	89 c3                	mov    %eax,%ebx
      while(uptime() - start < duration_ticks){
 247:	31 c0                	xor    %eax,%eax
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      unsigned count = 0;
 250:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
      while(uptime() - start < duration_ticks){
 256:	e8 50 03 00 00       	call   5ab <uptime>
 25b:	29 d8                	sub    %ebx,%eax
 25d:	39 f8                	cmp    %edi,%eax
 25f:	7d 2a                	jge    28b <main+0x28b>
        for(j = 0; j < 10000; j++) sink += j;
 261:	31 c0                	xor    %eax,%eax
 263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 267:	90                   	nop
 268:	8b 15 38 0d 00 00    	mov    0xd38,%edx
 26e:	01 c2                	add    %eax,%edx
 270:	83 c0 01             	add    $0x1,%eax
 273:	89 15 38 0d 00 00    	mov    %edx,0xd38
 279:	3d 10 27 00 00       	cmp    $0x2710,%eax
 27e:	75 e8                	jne    268 <main+0x268>
        count++;
 280:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
 286:	83 c0 01             	add    $0x1,%eax
 289:	eb c5                	jmp    250 <main+0x250>
      write(pipes[i][1], &count, sizeof(count));
 28b:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
 291:	53                   	push   %ebx
 292:	6a 04                	push   $0x4
 294:	50                   	push   %eax
 295:	ff b4 f5 6c ff ff ff 	pushl  -0x94(%ebp,%esi,8)
 29c:	e8 92 02 00 00       	call   533 <write>
      close(pipes[i][1]);
 2a1:	5f                   	pop    %edi
 2a2:	ff b4 f5 6c ff ff ff 	pushl  -0x94(%ebp,%esi,8)
 2a9:	e8 8d 02 00 00       	call   53b <close>
      exit();
 2ae:	e8 60 02 00 00       	call   513 <exit>
 2b3:	66 90                	xchg   %ax,%ax
 2b5:	66 90                	xchg   %ax,%ax
 2b7:	66 90                	xchg   %ax,%ax
 2b9:	66 90                	xchg   %ax,%ax
 2bb:	66 90                	xchg   %ax,%ax
 2bd:	66 90                	xchg   %ax,%ax
 2bf:	90                   	nop

000002c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c1:	31 c0                	xor    %eax,%eax
{
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	53                   	push   %ebx
 2c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2d7:	83 c0 01             	add    $0x1,%eax
 2da:	84 d2                	test   %dl,%dl
 2dc:	75 f2                	jne    2d0 <strcpy+0x10>
    ;
  return os;
}
 2de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e1:	89 c8                	mov    %ecx,%eax
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    
 2e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 55 08             	mov    0x8(%ebp),%edx
 2f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2fa:	0f b6 02             	movzbl (%edx),%eax
 2fd:	84 c0                	test   %al,%al
 2ff:	75 17                	jne    318 <strcmp+0x28>
 301:	eb 3a                	jmp    33d <strcmp+0x4d>
 303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 307:	90                   	nop
 308:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 30c:	83 c2 01             	add    $0x1,%edx
 30f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 312:	84 c0                	test   %al,%al
 314:	74 1a                	je     330 <strcmp+0x40>
    p++, q++;
 316:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 318:	0f b6 19             	movzbl (%ecx),%ebx
 31b:	38 c3                	cmp    %al,%bl
 31d:	74 e9                	je     308 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 31f:	29 d8                	sub    %ebx,%eax
}
 321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 324:	c9                   	leave  
 325:	c3                   	ret    
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 330:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 334:	31 c0                	xor    %eax,%eax
 336:	29 d8                	sub    %ebx,%eax
}
 338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 33b:	c9                   	leave  
 33c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 33d:	0f b6 19             	movzbl (%ecx),%ebx
 340:	31 c0                	xor    %eax,%eax
 342:	eb db                	jmp    31f <strcmp+0x2f>
 344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 34f:	90                   	nop

00000350 <strlen>:

uint
strlen(const char *s)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 356:	80 3a 00             	cmpb   $0x0,(%edx)
 359:	74 15                	je     370 <strlen+0x20>
 35b:	31 c0                	xor    %eax,%eax
 35d:	8d 76 00             	lea    0x0(%esi),%esi
 360:	83 c0 01             	add    $0x1,%eax
 363:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 367:	89 c1                	mov    %eax,%ecx
 369:	75 f5                	jne    360 <strlen+0x10>
    ;
  return n;
}
 36b:	89 c8                	mov    %ecx,%eax
 36d:	5d                   	pop    %ebp
 36e:	c3                   	ret    
 36f:	90                   	nop
  for(n = 0; s[n]; n++)
 370:	31 c9                	xor    %ecx,%ecx
}
 372:	5d                   	pop    %ebp
 373:	89 c8                	mov    %ecx,%eax
 375:	c3                   	ret    
 376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 387:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	89 d7                	mov    %edx,%edi
 38f:	fc                   	cld    
 390:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 392:	8b 7d fc             	mov    -0x4(%ebp),%edi
 395:	89 d0                	mov    %edx,%eax
 397:	c9                   	leave  
 398:	c3                   	ret    
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003a0 <strchr>:

char*
strchr(const char *s, char c)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3aa:	0f b6 10             	movzbl (%eax),%edx
 3ad:	84 d2                	test   %dl,%dl
 3af:	75 12                	jne    3c3 <strchr+0x23>
 3b1:	eb 1d                	jmp    3d0 <strchr+0x30>
 3b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b7:	90                   	nop
 3b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3bc:	83 c0 01             	add    $0x1,%eax
 3bf:	84 d2                	test   %dl,%dl
 3c1:	74 0d                	je     3d0 <strchr+0x30>
    if(*s == c)
 3c3:	38 d1                	cmp    %dl,%cl
 3c5:	75 f1                	jne    3b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3d0:	31 c0                	xor    %eax,%eax
}
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
 3d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop

000003e0 <gets>:

char*
gets(char *buf, int max)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3e5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 3e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3e9:	31 db                	xor    %ebx,%ebx
{
 3eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3ee:	eb 27                	jmp    417 <gets+0x37>
    cc = read(0, &c, 1);
 3f0:	83 ec 04             	sub    $0x4,%esp
 3f3:	6a 01                	push   $0x1
 3f5:	57                   	push   %edi
 3f6:	6a 00                	push   $0x0
 3f8:	e8 2e 01 00 00       	call   52b <read>
    if(cc < 1)
 3fd:	83 c4 10             	add    $0x10,%esp
 400:	85 c0                	test   %eax,%eax
 402:	7e 1d                	jle    421 <gets+0x41>
      break;
    buf[i++] = c;
 404:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 408:	8b 55 08             	mov    0x8(%ebp),%edx
 40b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 40f:	3c 0a                	cmp    $0xa,%al
 411:	74 1d                	je     430 <gets+0x50>
 413:	3c 0d                	cmp    $0xd,%al
 415:	74 19                	je     430 <gets+0x50>
  for(i=0; i+1 < max; ){
 417:	89 de                	mov    %ebx,%esi
 419:	83 c3 01             	add    $0x1,%ebx
 41c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 41f:	7c cf                	jl     3f0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 428:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42b:	5b                   	pop    %ebx
 42c:	5e                   	pop    %esi
 42d:	5f                   	pop    %edi
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    
  buf[i] = '\0';
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	89 de                	mov    %ebx,%esi
 435:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 439:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5f                   	pop    %edi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 455:	83 ec 08             	sub    $0x8,%esp
 458:	6a 00                	push   $0x0
 45a:	ff 75 08             	pushl  0x8(%ebp)
 45d:	e8 f1 00 00 00       	call   553 <open>
  if(fd < 0)
 462:	83 c4 10             	add    $0x10,%esp
 465:	85 c0                	test   %eax,%eax
 467:	78 27                	js     490 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	ff 75 0c             	pushl  0xc(%ebp)
 46f:	89 c3                	mov    %eax,%ebx
 471:	50                   	push   %eax
 472:	e8 f4 00 00 00       	call   56b <fstat>
  close(fd);
 477:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 47a:	89 c6                	mov    %eax,%esi
  close(fd);
 47c:	e8 ba 00 00 00       	call   53b <close>
  return r;
 481:	83 c4 10             	add    $0x10,%esp
}
 484:	8d 65 f8             	lea    -0x8(%ebp),%esp
 487:	89 f0                	mov    %esi,%eax
 489:	5b                   	pop    %ebx
 48a:	5e                   	pop    %esi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 490:	be ff ff ff ff       	mov    $0xffffffff,%esi
 495:	eb ed                	jmp    484 <stat+0x34>
 497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49e:	66 90                	xchg   %ax,%ax

000004a0 <atoi>:

int
atoi(const char *s)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	53                   	push   %ebx
 4a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a7:	0f be 02             	movsbl (%edx),%eax
 4aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4ad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4b5:	77 1e                	ja     4d5 <atoi+0x35>
 4b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4be:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4c0:	83 c2 01             	add    $0x1,%edx
 4c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ca:	0f be 02             	movsbl (%edx),%eax
 4cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4d0:	80 fb 09             	cmp    $0x9,%bl
 4d3:	76 eb                	jbe    4c0 <atoi+0x20>
  return n;
}
 4d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d8:	89 c8                	mov    %ecx,%eax
 4da:	c9                   	leave  
 4db:	c3                   	ret    
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	8b 45 10             	mov    0x10(%ebp),%eax
 4e7:	8b 55 08             	mov    0x8(%ebp),%edx
 4ea:	56                   	push   %esi
 4eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ee:	85 c0                	test   %eax,%eax
 4f0:	7e 13                	jle    505 <memmove+0x25>
 4f2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4f4:	89 d7                	mov    %edx,%edi
 4f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 500:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 501:	39 f8                	cmp    %edi,%eax
 503:	75 fb                	jne    500 <memmove+0x20>
  return vdst;
}
 505:	5e                   	pop    %esi
 506:	89 d0                	mov    %edx,%eax
 508:	5f                   	pop    %edi
 509:	5d                   	pop    %ebp
 50a:	c3                   	ret    

0000050b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 50b:	b8 01 00 00 00       	mov    $0x1,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <exit>:
SYSCALL(exit)
 513:	b8 02 00 00 00       	mov    $0x2,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <wait>:
SYSCALL(wait)
 51b:	b8 03 00 00 00       	mov    $0x3,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <pipe>:
SYSCALL(pipe)
 523:	b8 04 00 00 00       	mov    $0x4,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <read>:
SYSCALL(read)
 52b:	b8 05 00 00 00       	mov    $0x5,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <write>:
SYSCALL(write)
 533:	b8 10 00 00 00       	mov    $0x10,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <close>:
SYSCALL(close)
 53b:	b8 15 00 00 00       	mov    $0x15,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <kill>:
SYSCALL(kill)
 543:	b8 06 00 00 00       	mov    $0x6,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <exec>:
SYSCALL(exec)
 54b:	b8 07 00 00 00       	mov    $0x7,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <open>:
SYSCALL(open)
 553:	b8 0f 00 00 00       	mov    $0xf,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <mknod>:
SYSCALL(mknod)
 55b:	b8 11 00 00 00       	mov    $0x11,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <unlink>:
SYSCALL(unlink)
 563:	b8 12 00 00 00       	mov    $0x12,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <fstat>:
SYSCALL(fstat)
 56b:	b8 08 00 00 00       	mov    $0x8,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <link>:
SYSCALL(link)
 573:	b8 13 00 00 00       	mov    $0x13,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <mkdir>:
SYSCALL(mkdir)
 57b:	b8 14 00 00 00       	mov    $0x14,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <chdir>:
SYSCALL(chdir)
 583:	b8 09 00 00 00       	mov    $0x9,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <dup>:
SYSCALL(dup)
 58b:	b8 0a 00 00 00       	mov    $0xa,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <getpid>:
SYSCALL(getpid)
 593:	b8 0b 00 00 00       	mov    $0xb,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <sbrk>:
SYSCALL(sbrk)
 59b:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <sleep>:
SYSCALL(sleep)
 5a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <uptime>:
SYSCALL(uptime)
 5ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <settickets>:
SYSCALL(settickets)
 5b3:	b8 16 00 00 00       	mov    $0x16,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    
 5bb:	66 90                	xchg   %ax,%ax
 5bd:	66 90                	xchg   %ax,%ax
 5bf:	90                   	nop

000005c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 3c             	sub    $0x3c,%esp
 5c9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5cc:	89 d1                	mov    %edx,%ecx
{
 5ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5d1:	85 d2                	test   %edx,%edx
 5d3:	0f 89 7f 00 00 00    	jns    658 <printint+0x98>
 5d9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5dd:	74 79                	je     658 <printint+0x98>
    neg = 1;
 5df:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5e6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5e8:	31 db                	xor    %ebx,%ebx
 5ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5f0:	89 c8                	mov    %ecx,%eax
 5f2:	31 d2                	xor    %edx,%edx
 5f4:	89 cf                	mov    %ecx,%edi
 5f6:	f7 75 c4             	divl   -0x3c(%ebp)
 5f9:	0f b6 92 80 0a 00 00 	movzbl 0xa80(%edx),%edx
 600:	89 45 c0             	mov    %eax,-0x40(%ebp)
 603:	89 d8                	mov    %ebx,%eax
 605:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 608:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 60b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 60e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 611:	76 dd                	jbe    5f0 <printint+0x30>
  if(neg)
 613:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 616:	85 c9                	test   %ecx,%ecx
 618:	74 0c                	je     626 <printint+0x66>
    buf[i++] = '-';
 61a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 61f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 621:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 626:	8b 7d b8             	mov    -0x48(%ebp),%edi
 629:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 62d:	eb 07                	jmp    636 <printint+0x76>
 62f:	90                   	nop
    putc(fd, buf[i]);
 630:	0f b6 13             	movzbl (%ebx),%edx
 633:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 636:	83 ec 04             	sub    $0x4,%esp
 639:	88 55 d7             	mov    %dl,-0x29(%ebp)
 63c:	6a 01                	push   $0x1
 63e:	56                   	push   %esi
 63f:	57                   	push   %edi
 640:	e8 ee fe ff ff       	call   533 <write>
  while(--i >= 0)
 645:	83 c4 10             	add    $0x10,%esp
 648:	39 de                	cmp    %ebx,%esi
 64a:	75 e4                	jne    630 <printint+0x70>
}
 64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret    
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 658:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 65f:	eb 87                	jmp    5e8 <printint+0x28>
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop

00000670 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 67c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 13             	movzbl (%ebx),%edx
 682:	84 d2                	test   %dl,%dl
 684:	74 6a                	je     6f0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 686:	8d 45 10             	lea    0x10(%ebp),%eax
 689:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 68c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 68f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 691:	89 45 d0             	mov    %eax,-0x30(%ebp)
 694:	eb 36                	jmp    6cc <printf+0x5c>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
 6a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6a3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 6a8:	83 f8 25             	cmp    $0x25,%eax
 6ab:	74 15                	je     6c2 <printf+0x52>
  write(fd, &c, 1);
 6ad:	83 ec 04             	sub    $0x4,%esp
 6b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6b3:	6a 01                	push   $0x1
 6b5:	57                   	push   %edi
 6b6:	56                   	push   %esi
 6b7:	e8 77 fe ff ff       	call   533 <write>
 6bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 6bf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6c2:	0f b6 13             	movzbl (%ebx),%edx
 6c5:	83 c3 01             	add    $0x1,%ebx
 6c8:	84 d2                	test   %dl,%dl
 6ca:	74 24                	je     6f0 <printf+0x80>
    c = fmt[i] & 0xff;
 6cc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 6cf:	85 c9                	test   %ecx,%ecx
 6d1:	74 cd                	je     6a0 <printf+0x30>
      }
    } else if(state == '%'){
 6d3:	83 f9 25             	cmp    $0x25,%ecx
 6d6:	75 ea                	jne    6c2 <printf+0x52>
      if(c == 'd'){
 6d8:	83 f8 25             	cmp    $0x25,%eax
 6db:	0f 84 07 01 00 00    	je     7e8 <printf+0x178>
 6e1:	83 e8 63             	sub    $0x63,%eax
 6e4:	83 f8 15             	cmp    $0x15,%eax
 6e7:	77 17                	ja     700 <printf+0x90>
 6e9:	ff 24 85 28 0a 00 00 	jmp    *0xa28(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
 6f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 706:	6a 01                	push   $0x1
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 70e:	e8 20 fe ff ff       	call   533 <write>
        putc(fd, c);
 713:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 717:	83 c4 0c             	add    $0xc,%esp
 71a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 71d:	6a 01                	push   $0x1
 71f:	57                   	push   %edi
 720:	56                   	push   %esi
 721:	e8 0d fe ff ff       	call   533 <write>
        putc(fd, c);
 726:	83 c4 10             	add    $0x10,%esp
      state = 0;
 729:	31 c9                	xor    %ecx,%ecx
 72b:	eb 95                	jmp    6c2 <printf+0x52>
 72d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 10 00 00 00       	mov    $0x10,%ecx
 738:	6a 00                	push   $0x0
 73a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	89 f0                	mov    %esi,%eax
 741:	e8 7a fe ff ff       	call   5c0 <printint>
        ap++;
 746:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 74a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74d:	31 c9                	xor    %ecx,%ecx
 74f:	e9 6e ff ff ff       	jmp    6c2 <printf+0x52>
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 758:	8b 45 d0             	mov    -0x30(%ebp),%eax
 75b:	8b 10                	mov    (%eax),%edx
        ap++;
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 763:	85 d2                	test   %edx,%edx
 765:	0f 84 8d 00 00 00    	je     7f8 <printf+0x188>
        while(*s != 0){
 76b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 76e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 770:	84 c0                	test   %al,%al
 772:	0f 84 4a ff ff ff    	je     6c2 <printf+0x52>
 778:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 77b:	89 d3                	mov    %edx,%ebx
 77d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
          s++;
 783:	83 c3 01             	add    $0x1,%ebx
 786:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	57                   	push   %edi
 78c:	56                   	push   %esi
 78d:	e8 a1 fd ff ff       	call   533 <write>
        while(*s != 0){
 792:	0f b6 03             	movzbl (%ebx),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x110>
      state = 0;
 79c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 79f:	31 c9                	xor    %ecx,%ecx
 7a1:	e9 1c ff ff ff       	jmp    6c2 <printf+0x52>
 7a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	e9 7b ff ff ff       	jmp    73a <printf+0xca>
 7bf:	90                   	nop
        putc(fd, *ap);
 7c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 7c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7c6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
 7ca:	57                   	push   %edi
 7cb:	56                   	push   %esi
        putc(fd, *ap);
 7cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7cf:	e8 5f fd ff ff       	call   533 <write>
        ap++;
 7d4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7db:	31 c9                	xor    %ecx,%ecx
 7dd:	e9 e0 fe ff ff       	jmp    6c2 <printf+0x52>
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 7e8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 7eb:	83 ec 04             	sub    $0x4,%esp
 7ee:	e9 2a ff ff ff       	jmp    71d <printf+0xad>
 7f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7f7:	90                   	nop
          s = "(null)";
 7f8:	ba 1f 0a 00 00       	mov    $0xa1f,%edx
        while(*s != 0){
 7fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 800:	b8 28 00 00 00       	mov    $0x28,%eax
 805:	89 d3                	mov    %edx,%ebx
 807:	e9 74 ff ff ff       	jmp    780 <printf+0x110>
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 3c 0d 00 00       	mov    0xd3c,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 828:	89 c2                	mov    %eax,%edx
 82a:	8b 00                	mov    (%eax),%eax
 82c:	39 ca                	cmp    %ecx,%edx
 82e:	73 30                	jae    860 <free+0x50>
 830:	39 c1                	cmp    %eax,%ecx
 832:	72 04                	jb     838 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	39 c2                	cmp    %eax,%edx
 836:	72 f0                	jb     828 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 838:	8b 73 fc             	mov    -0x4(%ebx),%esi
 83b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83e:	39 f8                	cmp    %edi,%eax
 840:	74 30                	je     872 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 845:	8b 42 04             	mov    0x4(%edx),%eax
 848:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 84b:	39 f1                	cmp    %esi,%ecx
 84d:	74 3a                	je     889 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 84f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 851:	5b                   	pop    %ebx
  freep = p;
 852:	89 15 3c 0d 00 00    	mov    %edx,0xd3c
}
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 c2                	cmp    %eax,%edx
 862:	72 c4                	jb     828 <free+0x18>
 864:	39 c1                	cmp    %eax,%ecx
 866:	73 c0                	jae    828 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 868:	8b 73 fc             	mov    -0x4(%ebx),%esi
 86b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 86e:	39 f8                	cmp    %edi,%eax
 870:	75 d0                	jne    842 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 872:	03 70 04             	add    0x4(%eax),%esi
 875:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 878:	8b 02                	mov    (%edx),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 87f:	8b 42 04             	mov    0x4(%edx),%eax
 882:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 885:	39 f1                	cmp    %esi,%ecx
 887:	75 c6                	jne    84f <free+0x3f>
    p->s.size += bp->s.size;
 889:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 88c:	89 15 3c 0d 00 00    	mov    %edx,0xd3c
    p->s.size += bp->s.size;
 892:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 895:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 898:	89 0a                	mov    %ecx,(%edx)
}
 89a:	5b                   	pop    %ebx
 89b:	5e                   	pop    %esi
 89c:	5f                   	pop    %edi
 89d:	5d                   	pop    %ebp
 89e:	c3                   	ret    
 89f:	90                   	nop

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 3d 3c 0d 00 00    	mov    0xd3c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 70 07             	lea    0x7(%eax),%esi
 8b5:	c1 ee 03             	shr    $0x3,%esi
 8b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8bb:	85 ff                	test   %edi,%edi
 8bd:	0f 84 9d 00 00 00    	je     960 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8c5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c8:	39 f1                	cmp    %esi,%ecx
 8ca:	73 6a                	jae    936 <malloc+0x96>
 8cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d1:	39 de                	cmp    %ebx,%esi
 8d3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8e0:	eb 17                	jmp    8f9 <malloc+0x59>
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ea:	8b 48 04             	mov    0x4(%eax),%ecx
 8ed:	39 f1                	cmp    %esi,%ecx
 8ef:	73 4f                	jae    940 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	8b 3d 3c 0d 00 00    	mov    0xd3c,%edi
 8f7:	89 c2                	mov    %eax,%edx
 8f9:	39 d7                	cmp    %edx,%edi
 8fb:	75 eb                	jne    8e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8fd:	83 ec 0c             	sub    $0xc,%esp
 900:	ff 75 e4             	pushl  -0x1c(%ebp)
 903:	e8 93 fc ff ff       	call   59b <sbrk>
  if(p == (char*)-1)
 908:	83 c4 10             	add    $0x10,%esp
 90b:	83 f8 ff             	cmp    $0xffffffff,%eax
 90e:	74 1c                	je     92c <malloc+0x8c>
  hp->s.size = nu;
 910:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 913:	83 ec 0c             	sub    $0xc,%esp
 916:	83 c0 08             	add    $0x8,%eax
 919:	50                   	push   %eax
 91a:	e8 f1 fe ff ff       	call   810 <free>
  return freep;
 91f:	8b 15 3c 0d 00 00    	mov    0xd3c,%edx
      if((p = morecore(nunits)) == 0)
 925:	83 c4 10             	add    $0x10,%esp
 928:	85 d2                	test   %edx,%edx
 92a:	75 bc                	jne    8e8 <malloc+0x48>
        return 0;
  }
}
 92c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 92f:	31 c0                	xor    %eax,%eax
}
 931:	5b                   	pop    %ebx
 932:	5e                   	pop    %esi
 933:	5f                   	pop    %edi
 934:	5d                   	pop    %ebp
 935:	c3                   	ret    
    if(p->s.size >= nunits){
 936:	89 d0                	mov    %edx,%eax
 938:	89 fa                	mov    %edi,%edx
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 940:	39 ce                	cmp    %ecx,%esi
 942:	74 4c                	je     990 <malloc+0xf0>
        p->s.size -= nunits;
 944:	29 f1                	sub    %esi,%ecx
 946:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 949:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 94c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 94f:	89 15 3c 0d 00 00    	mov    %edx,0xd3c
}
 955:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 958:	83 c0 08             	add    $0x8,%eax
}
 95b:	5b                   	pop    %ebx
 95c:	5e                   	pop    %esi
 95d:	5f                   	pop    %edi
 95e:	5d                   	pop    %ebp
 95f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 3c 0d 00 00 40 	movl   $0xd40,0xd3c
 967:	0d 00 00 
    base.s.size = 0;
 96a:	bf 40 0d 00 00       	mov    $0xd40,%edi
    base.s.ptr = freep = prevp = &base;
 96f:	c7 05 40 0d 00 00 40 	movl   $0xd40,0xd40
 976:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 979:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 97b:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
 982:	00 00 00 
    if(p->s.size >= nunits){
 985:	e9 42 ff ff ff       	jmp    8cc <malloc+0x2c>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb b9                	jmp    94f <malloc+0xaf>
