
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 80 d6 10 80       	mov    $0x8010d680,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 cb 34 10 80       	mov    $0x801034cb,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 e4 8b 10 	movl   $0x80108be4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 bd 53 00 00       	call   8010540b <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 6a 53 00 00       	call   8010542c <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 cd 53 00 00       	call   801054d6 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 79 4c 00 00       	call   80104d9d <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 eb 10 80       	mov    0x8010ebb0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 55 53 00 00       	call   801054d6 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 eb 8b 10 80 	movl   $0x80108beb,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 e9 25 00 00       	call   801027c1 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 fc 8b 10 80 	movl   $0x80108bfc,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 ac 25 00 00       	call   801027c1 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 03 8c 10 80 	movl   $0x80108c03,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 eb 51 00 00       	call   8010542c <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 3f 4c 00 00       	call   80104ee1 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 28 52 00 00       	call   801054d6 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bb:	e8 6c 50 00 00       	call   8010542c <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 0a 8c 10 80 	movl   $0x80108c0a,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 13 8c 10 80 	movl   $0x80108c13,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100533:	e8 9e 4f 00 00       	call   801054d6 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 1a 8c 10 80 	movl   $0x80108c1a,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 29 8c 10 80 	movl   $0x80108c29,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 d9 4f 00 00       	call   8010556d <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 2b 8c 10 80 	movl   $0x80108c2b,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 28 51 00 00       	call   801057df <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 2a 50 00 00       	call   80105710 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 ac 6a 00 00       	call   80107227 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 a0 6a 00 00       	call   80107227 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 94 6a 00 00       	call   80107227 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 87 6a 00 00       	call   80107227 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801007ba:	e8 6d 4c 00 00       	call   8010542c <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 98 47 00 00       	call   80104f87 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100816:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100840:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
8010087c:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 7c ee 10 80    	mov    %edx,0x8010ee7c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 f4 ed 10 80    	mov    %al,-0x7fef120c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008d5:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008e7:	a3 78 ee 10 80       	mov    %eax,0x8010ee78
          wakeup(&input.r);
801008ec:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
801008f3:	e8 e9 45 00 00       	call   80104ee1 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100914:	e8 bd 4b 00 00       	call   801054d6 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 9d 10 00 00       	call   801019c9 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100939:	e8 ee 4a 00 00       	call   8010542c <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100959:	e8 78 4b 00 00       	call   801054d6 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 12 0f 00 00       	call   8010187b <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100982:	e8 16 44 00 00       	call   80104d9d <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
8010098d:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 74 ee 10 80    	mov    %edx,0x8010ee74
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801009fe:	e8 d3 4a 00 00       	call   801054d6 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 6d 0e 00 00       	call   8010187b <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 9e 0f 00 00       	call   801019c9 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 f5 49 00 00       	call   8010542c <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6c:	e8 65 4a 00 00       	call   801054d6 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 ff 0d 00 00       	call   8010187b <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 2f 8c 10 	movl   $0x80108c2f,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 70 49 00 00       	call   8010540b <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 37 8c 10 	movl   $0x80108c37,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100aaa:	e8 5c 49 00 00       	call   8010540b <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 4c f8 10 80 1a 	movl   $0x80100a1a,0x8010f84c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 48 f8 10 80 1b 	movl   $0x8010091b,0x8010f848
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 8f 30 00 00       	call   80103b68 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 90 1e 00 00       	call   8010297d <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100af8:	8b 45 08             	mov    0x8(%ebp),%eax
80100afb:	89 04 24             	mov    %eax,(%esp)
80100afe:	e8 23 19 00 00       	call   80102426 <namei>
80100b03:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0a:	75 0a                	jne    80100b16 <exec+0x27>
    return -1;
80100b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b11:	e9 12 04 00 00       	jmp    80100f28 <exec+0x439>
  ilock(ip);
80100b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b19:	89 04 24             	mov    %eax,(%esp)
80100b1c:	e8 5a 0d 00 00       	call   8010187b <ilock>
  pgdir = 0;
80100b21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b28:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b2f:	00 
80100b30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b37:	00 
80100b38:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b42:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b45:	89 04 24             	mov    %eax,(%esp)
80100b48:	e8 3b 12 00 00       	call   80101d88 <readi>
80100b4d:	83 f8 33             	cmp    $0x33,%eax
80100b50:	77 05                	ja     80100b57 <exec+0x68>
    goto bad;
80100b52:	e9 aa 03 00 00       	jmp    80100f01 <exec+0x412>
  if(elf.magic != ELF_MAGIC)
80100b57:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b5d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b62:	74 05                	je     80100b69 <exec+0x7a>
    goto bad;
80100b64:	e9 98 03 00 00       	jmp    80100f01 <exec+0x412>

  if((pgdir = setupkvm()) == 0)
80100b69:	e8 0a 78 00 00       	call   80108378 <setupkvm>
80100b6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b75:	75 05                	jne    80100b7c <exec+0x8d>
    goto bad;
80100b77:	e9 85 03 00 00       	jmp    80100f01 <exec+0x412>

  // Load program into memory.
  sz = 0;
80100b7c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  if((sz = allocuvm(pgdir,sz,PGSIZE)) == 0) {
80100b83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80100b8a:	00 
80100b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100b95:	89 04 24             	mov    %eax,(%esp)
80100b98:	e8 a9 7b 00 00       	call   80108746 <allocuvm>
80100b9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ba0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ba4:	75 05                	jne    80100bab <exec+0xbc>
    //cprintf("exec err\n");
    goto bad;
80100ba6:	e9 56 03 00 00       	jmp    80100f01 <exec+0x412>
  }
  //cprintf("exec sz = %p\n",sz);
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bb2:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bbb:	e9 cb 00 00 00       	jmp    80100c8b <exec+0x19c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bc3:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bca:	00 
80100bcb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bcf:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bdc:	89 04 24             	mov    %eax,(%esp)
80100bdf:	e8 a4 11 00 00       	call   80101d88 <readi>
80100be4:	83 f8 20             	cmp    $0x20,%eax
80100be7:	74 05                	je     80100bee <exec+0xff>
      goto bad;
80100be9:	e9 13 03 00 00       	jmp    80100f01 <exec+0x412>
    if(ph.type != ELF_PROG_LOAD)
80100bee:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bf4:	83 f8 01             	cmp    $0x1,%eax
80100bf7:	74 05                	je     80100bfe <exec+0x10f>
      continue;
80100bf9:	e9 80 00 00 00       	jmp    80100c7e <exec+0x18f>
    if(ph.memsz < ph.filesz)
80100bfe:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c04:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c0a:	39 c2                	cmp    %eax,%edx
80100c0c:	73 05                	jae    80100c13 <exec+0x124>
      goto bad;
80100c0e:	e9 ee 02 00 00       	jmp    80100f01 <exec+0x412>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c13:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c19:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c1f:	01 d0                	add    %edx,%eax
80100c21:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c28:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c2f:	89 04 24             	mov    %eax,(%esp)
80100c32:	e8 0f 7b 00 00       	call   80108746 <allocuvm>
80100c37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c3e:	75 05                	jne    80100c45 <exec+0x156>
      goto bad;
80100c40:	e9 bc 02 00 00       	jmp    80100f01 <exec+0x412>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c45:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c4b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c51:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c57:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c5f:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c62:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c66:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c6d:	89 04 24             	mov    %eax,(%esp)
80100c70:	e8 e6 79 00 00       	call   8010865b <loaduvm>
80100c75:	85 c0                	test   %eax,%eax
80100c77:	79 05                	jns    80100c7e <exec+0x18f>
      goto bad;
80100c79:	e9 83 02 00 00       	jmp    80100f01 <exec+0x412>
  if((sz = allocuvm(pgdir,sz,PGSIZE)) == 0) {
    //cprintf("exec err\n");
    goto bad;
  }
  //cprintf("exec sz = %p\n",sz);
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c7e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c85:	83 c0 20             	add    $0x20,%eax
80100c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c8b:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c92:	0f b7 c0             	movzwl %ax,%eax
80100c95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c98:	0f 8f 22 ff ff ff    	jg     80100bc0 <exec+0xd1>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ca1:	89 04 24             	mov    %eax,(%esp)
80100ca4:	e8 56 0e 00 00       	call   80101aff <iunlockput>
  ip = 0;
80100ca9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc3:	05 00 20 00 00       	add    $0x2000,%eax
80100cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cd6:	89 04 24             	mov    %eax,(%esp)
80100cd9:	e8 68 7a 00 00       	call   80108746 <allocuvm>
80100cde:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ce1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ce5:	75 05                	jne    80100cec <exec+0x1fd>
    goto bad;
80100ce7:	e9 15 02 00 00       	jmp    80100f01 <exec+0x412>
  proc->pstack = (uint *)sz;
80100cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100cf5:	89 50 7c             	mov    %edx,0x7c(%eax)

  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d07:	89 04 24             	mov    %eax,(%esp)
80100d0a:	e8 67 7c 00 00       	call   80108976 <clearpteu>

  sp = sz;
80100d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d12:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d1c:	e9 9a 00 00 00       	jmp    80100dbb <exec+0x2cc>
    if(argc >= MAXARG)
80100d21:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d25:	76 05                	jbe    80100d2c <exec+0x23d>
      goto bad;
80100d27:	e9 d5 01 00 00       	jmp    80100f01 <exec+0x412>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d39:	01 d0                	add    %edx,%eax
80100d3b:	8b 00                	mov    (%eax),%eax
80100d3d:	89 04 24             	mov    %eax,(%esp)
80100d40:	e8 35 4c 00 00       	call   8010597a <strlen>
80100d45:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d48:	29 c2                	sub    %eax,%edx
80100d4a:	89 d0                	mov    %edx,%eax
80100d4c:	83 e8 01             	sub    $0x1,%eax
80100d4f:	83 e0 fc             	and    $0xfffffffc,%eax
80100d52:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d62:	01 d0                	add    %edx,%eax
80100d64:	8b 00                	mov    (%eax),%eax
80100d66:	89 04 24             	mov    %eax,(%esp)
80100d69:	e8 0c 4c 00 00       	call   8010597a <strlen>
80100d6e:	83 c0 01             	add    $0x1,%eax
80100d71:	89 c2                	mov    %eax,%edx
80100d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d76:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d80:	01 c8                	add    %ecx,%eax
80100d82:	8b 00                	mov    (%eax),%eax
80100d84:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d88:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d96:	89 04 24             	mov    %eax,(%esp)
80100d99:	e8 9d 7d 00 00       	call   80108b3b <copyout>
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	79 05                	jns    80100da7 <exec+0x2b8>
      goto bad;
80100da2:	e9 5a 01 00 00       	jmp    80100f01 <exec+0x412>
    ustack[3+argc] = sp;
80100da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daa:	8d 50 03             	lea    0x3(%eax),%edx
80100dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db0:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc8:	01 d0                	add    %edx,%eax
80100dca:	8b 00                	mov    (%eax),%eax
80100dcc:	85 c0                	test   %eax,%eax
80100dce:	0f 85 4d ff ff ff    	jne    80100d21 <exec+0x232>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd7:	83 c0 03             	add    $0x3,%eax
80100dda:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100de1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100de5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dec:	ff ff ff 
  ustack[1] = argc;
80100def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfb:	83 c0 01             	add    $0x1,%eax
80100dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e08:	29 d0                	sub    %edx,%eax
80100e0a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e13:	83 c0 04             	add    $0x4,%eax
80100e16:	c1 e0 02             	shl    $0x2,%eax
80100e19:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1f:	83 c0 04             	add    $0x4,%eax
80100e22:	c1 e0 02             	shl    $0x2,%eax
80100e25:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e29:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e2f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e36:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e3d:	89 04 24             	mov    %eax,(%esp)
80100e40:	e8 f6 7c 00 00       	call   80108b3b <copyout>
80100e45:	85 c0                	test   %eax,%eax
80100e47:	79 05                	jns    80100e4e <exec+0x35f>
    goto bad;
80100e49:	e9 b3 00 00 00       	jmp    80100f01 <exec+0x412>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e5a:	eb 17                	jmp    80100e73 <exec+0x384>
    if(*s == '/')
80100e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5f:	0f b6 00             	movzbl (%eax),%eax
80100e62:	3c 2f                	cmp    $0x2f,%al
80100e64:	75 09                	jne    80100e6f <exec+0x380>
      last = s+1;
80100e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e69:	83 c0 01             	add    $0x1,%eax
80100e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e76:	0f b6 00             	movzbl (%eax),%eax
80100e79:	84 c0                	test   %al,%al
80100e7b:	75 df                	jne    80100e5c <exec+0x36d>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e83:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e86:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e8d:	00 
80100e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e95:	89 14 24             	mov    %edx,(%esp)
80100e98:	e8 93 4a 00 00       	call   80105930 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	8b 40 04             	mov    0x4(%eax),%eax
80100ea6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ea9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb2:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ebe:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ec0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec6:	8b 40 18             	mov    0x18(%eax),%eax
80100ec9:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ecf:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed8:	8b 40 18             	mov    0x18(%eax),%eax
80100edb:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ede:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee7:	89 04 24             	mov    %eax,(%esp)
80100eea:	e8 7a 75 00 00       	call   80108469 <switchuvm>
  freevm(oldpgdir);
80100eef:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 e2 79 00 00       	call   801088dc <freevm>
  //cprintf("exec no err\n");
  return 0;
80100efa:	b8 00 00 00 00       	mov    $0x0,%eax
80100eff:	eb 27                	jmp    80100f28 <exec+0x439>

 bad:
  //cprintf("exec bad\n");
  if(pgdir)
80100f01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f05:	74 0b                	je     80100f12 <exec+0x423>
    freevm(pgdir);
80100f07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f0a:	89 04 24             	mov    %eax,(%esp)
80100f0d:	e8 ca 79 00 00       	call   801088dc <freevm>
  if(ip)
80100f12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f16:	74 0b                	je     80100f23 <exec+0x434>
    iunlockput(ip);
80100f18:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f1b:	89 04 24             	mov    %eax,(%esp)
80100f1e:	e8 dc 0b 00 00       	call   80101aff <iunlockput>
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    

80100f2a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f2a:	55                   	push   %ebp
80100f2b:	89 e5                	mov    %esp,%ebp
80100f2d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f30:	c7 44 24 04 3d 8c 10 	movl   $0x80108c3d,0x4(%esp)
80100f37:	80 
80100f38:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f3f:	e8 c7 44 00 00       	call   8010540b <initlock>
}
80100f44:	c9                   	leave  
80100f45:	c3                   	ret    

80100f46 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f46:	55                   	push   %ebp
80100f47:	89 e5                	mov    %esp,%ebp
80100f49:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f4c:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f53:	e8 d4 44 00 00       	call   8010542c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f58:	c7 45 f4 d4 ee 10 80 	movl   $0x8010eed4,-0xc(%ebp)
80100f5f:	eb 29                	jmp    80100f8a <filealloc+0x44>
    if(f->ref == 0){
80100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f64:	8b 40 04             	mov    0x4(%eax),%eax
80100f67:	85 c0                	test   %eax,%eax
80100f69:	75 1b                	jne    80100f86 <filealloc+0x40>
      f->ref = 1;
80100f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f75:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f7c:	e8 55 45 00 00       	call   801054d6 <release>
      return f;
80100f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f84:	eb 1e                	jmp    80100fa4 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f86:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f8a:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80100f91:	72 ce                	jb     80100f61 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f93:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f9a:	e8 37 45 00 00       	call   801054d6 <release>
  return 0;
80100f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fa4:	c9                   	leave  
80100fa5:	c3                   	ret    

80100fa6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fa6:	55                   	push   %ebp
80100fa7:	89 e5                	mov    %esp,%ebp
80100fa9:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fac:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fb3:	e8 74 44 00 00       	call   8010542c <acquire>
  if(f->ref < 1)
80100fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbb:	8b 40 04             	mov    0x4(%eax),%eax
80100fbe:	85 c0                	test   %eax,%eax
80100fc0:	7f 0c                	jg     80100fce <filedup+0x28>
    panic("filedup");
80100fc2:	c7 04 24 44 8c 10 80 	movl   $0x80108c44,(%esp)
80100fc9:	e8 6c f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fce:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd1:	8b 40 04             	mov    0x4(%eax),%eax
80100fd4:	8d 50 01             	lea    0x1(%eax),%edx
80100fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100fda:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fdd:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fe4:	e8 ed 44 00 00       	call   801054d6 <release>
  return f;
80100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    

80100fee <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fee:	55                   	push   %ebp
80100fef:	89 e5                	mov    %esp,%ebp
80100ff1:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ff4:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100ffb:	e8 2c 44 00 00       	call   8010542c <acquire>
  if(f->ref < 1)
80101000:	8b 45 08             	mov    0x8(%ebp),%eax
80101003:	8b 40 04             	mov    0x4(%eax),%eax
80101006:	85 c0                	test   %eax,%eax
80101008:	7f 0c                	jg     80101016 <fileclose+0x28>
    panic("fileclose");
8010100a:	c7 04 24 4c 8c 10 80 	movl   $0x80108c4c,(%esp)
80101011:	e8 24 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010101f:	8b 45 08             	mov    0x8(%ebp),%eax
80101022:	89 50 04             	mov    %edx,0x4(%eax)
80101025:	8b 45 08             	mov    0x8(%ebp),%eax
80101028:	8b 40 04             	mov    0x4(%eax),%eax
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7e 11                	jle    80101040 <fileclose+0x52>
    release(&ftable.lock);
8010102f:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80101036:	e8 9b 44 00 00       	call   801054d6 <release>
8010103b:	e9 82 00 00 00       	jmp    801010c2 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101040:	8b 45 08             	mov    0x8(%ebp),%eax
80101043:	8b 10                	mov    (%eax),%edx
80101045:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101048:	8b 50 04             	mov    0x4(%eax),%edx
8010104b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010104e:	8b 50 08             	mov    0x8(%eax),%edx
80101051:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101054:	8b 50 0c             	mov    0xc(%eax),%edx
80101057:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010105a:	8b 50 10             	mov    0x10(%eax),%edx
8010105d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101060:	8b 40 14             	mov    0x14(%eax),%eax
80101063:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101066:	8b 45 08             	mov    0x8(%ebp),%eax
80101069:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101070:	8b 45 08             	mov    0x8(%ebp),%eax
80101073:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101079:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80101080:	e8 51 44 00 00       	call   801054d6 <release>
  
  if(ff.type == FD_PIPE)
80101085:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101088:	83 f8 01             	cmp    $0x1,%eax
8010108b:	75 18                	jne    801010a5 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010108d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101091:	0f be d0             	movsbl %al,%edx
80101094:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101097:	89 54 24 04          	mov    %edx,0x4(%esp)
8010109b:	89 04 24             	mov    %eax,(%esp)
8010109e:	e8 75 2d 00 00       	call   80103e18 <pipeclose>
801010a3:	eb 1d                	jmp    801010c2 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a8:	83 f8 02             	cmp    $0x2,%eax
801010ab:	75 15                	jne    801010c2 <fileclose+0xd4>
    begin_trans();
801010ad:	e8 39 22 00 00       	call   801032eb <begin_trans>
    iput(ff.ip);
801010b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010b5:	89 04 24             	mov    %eax,(%esp)
801010b8:	e8 71 09 00 00       	call   80101a2e <iput>
    commit_trans();
801010bd:	e8 72 22 00 00       	call   80103334 <commit_trans>
  }
}
801010c2:	c9                   	leave  
801010c3:	c3                   	ret    

801010c4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c4:	55                   	push   %ebp
801010c5:	89 e5                	mov    %esp,%ebp
801010c7:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	8b 00                	mov    (%eax),%eax
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 38                	jne    8010110c <filestat+0x48>
    ilock(f->ip);
801010d4:	8b 45 08             	mov    0x8(%ebp),%eax
801010d7:	8b 40 10             	mov    0x10(%eax),%eax
801010da:	89 04 24             	mov    %eax,(%esp)
801010dd:	e8 99 07 00 00       	call   8010187b <ilock>
    stati(f->ip, st);
801010e2:	8b 45 08             	mov    0x8(%ebp),%eax
801010e5:	8b 40 10             	mov    0x10(%eax),%eax
801010e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801010eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801010ef:	89 04 24             	mov    %eax,(%esp)
801010f2:	e8 4c 0c 00 00       	call   80101d43 <stati>
    iunlock(f->ip);
801010f7:	8b 45 08             	mov    0x8(%ebp),%eax
801010fa:	8b 40 10             	mov    0x10(%eax),%eax
801010fd:	89 04 24             	mov    %eax,(%esp)
80101100:	e8 c4 08 00 00       	call   801019c9 <iunlock>
    return 0;
80101105:	b8 00 00 00 00       	mov    $0x0,%eax
8010110a:	eb 05                	jmp    80101111 <filestat+0x4d>
  }
  return -1;
8010110c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101111:	c9                   	leave  
80101112:	c3                   	ret    

80101113 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101113:	55                   	push   %ebp
80101114:	89 e5                	mov    %esp,%ebp
80101116:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101119:	8b 45 08             	mov    0x8(%ebp),%eax
8010111c:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101120:	84 c0                	test   %al,%al
80101122:	75 0a                	jne    8010112e <fileread+0x1b>
    return -1;
80101124:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101129:	e9 9f 00 00 00       	jmp    801011cd <fileread+0xba>
  if(f->type == FD_PIPE)
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 00                	mov    (%eax),%eax
80101133:	83 f8 01             	cmp    $0x1,%eax
80101136:	75 1e                	jne    80101156 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101138:	8b 45 08             	mov    0x8(%ebp),%eax
8010113b:	8b 40 0c             	mov    0xc(%eax),%eax
8010113e:	8b 55 10             	mov    0x10(%ebp),%edx
80101141:	89 54 24 08          	mov    %edx,0x8(%esp)
80101145:	8b 55 0c             	mov    0xc(%ebp),%edx
80101148:	89 54 24 04          	mov    %edx,0x4(%esp)
8010114c:	89 04 24             	mov    %eax,(%esp)
8010114f:	e8 45 2e 00 00       	call   80103f99 <piperead>
80101154:	eb 77                	jmp    801011cd <fileread+0xba>
  if(f->type == FD_INODE){
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 00                	mov    (%eax),%eax
8010115b:	83 f8 02             	cmp    $0x2,%eax
8010115e:	75 61                	jne    801011c1 <fileread+0xae>
    ilock(f->ip);
80101160:	8b 45 08             	mov    0x8(%ebp),%eax
80101163:	8b 40 10             	mov    0x10(%eax),%eax
80101166:	89 04 24             	mov    %eax,(%esp)
80101169:	e8 0d 07 00 00       	call   8010187b <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116e:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101171:	8b 45 08             	mov    0x8(%ebp),%eax
80101174:	8b 50 14             	mov    0x14(%eax),%edx
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	8b 40 10             	mov    0x10(%eax),%eax
8010117d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101181:	89 54 24 08          	mov    %edx,0x8(%esp)
80101185:	8b 55 0c             	mov    0xc(%ebp),%edx
80101188:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118c:	89 04 24             	mov    %eax,(%esp)
8010118f:	e8 f4 0b 00 00       	call   80101d88 <readi>
80101194:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010119b:	7e 11                	jle    801011ae <fileread+0x9b>
      f->off += r;
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 50 14             	mov    0x14(%eax),%edx
801011a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a6:	01 c2                	add    %eax,%edx
801011a8:	8b 45 08             	mov    0x8(%ebp),%eax
801011ab:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011ae:	8b 45 08             	mov    0x8(%ebp),%eax
801011b1:	8b 40 10             	mov    0x10(%eax),%eax
801011b4:	89 04 24             	mov    %eax,(%esp)
801011b7:	e8 0d 08 00 00       	call   801019c9 <iunlock>
    return r;
801011bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011bf:	eb 0c                	jmp    801011cd <fileread+0xba>
  }
  panic("fileread");
801011c1:	c7 04 24 56 8c 10 80 	movl   $0x80108c56,(%esp)
801011c8:	e8 6d f3 ff ff       	call   8010053a <panic>
}
801011cd:	c9                   	leave  
801011ce:	c3                   	ret    

801011cf <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011cf:	55                   	push   %ebp
801011d0:	89 e5                	mov    %esp,%ebp
801011d2:	53                   	push   %ebx
801011d3:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011d6:	8b 45 08             	mov    0x8(%ebp),%eax
801011d9:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011dd:	84 c0                	test   %al,%al
801011df:	75 0a                	jne    801011eb <filewrite+0x1c>
    return -1;
801011e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011e6:	e9 20 01 00 00       	jmp    8010130b <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	8b 00                	mov    (%eax),%eax
801011f0:	83 f8 01             	cmp    $0x1,%eax
801011f3:	75 21                	jne    80101216 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011f5:	8b 45 08             	mov    0x8(%ebp),%eax
801011f8:	8b 40 0c             	mov    0xc(%eax),%eax
801011fb:	8b 55 10             	mov    0x10(%ebp),%edx
801011fe:	89 54 24 08          	mov    %edx,0x8(%esp)
80101202:	8b 55 0c             	mov    0xc(%ebp),%edx
80101205:	89 54 24 04          	mov    %edx,0x4(%esp)
80101209:	89 04 24             	mov    %eax,(%esp)
8010120c:	e8 99 2c 00 00       	call   80103eaa <pipewrite>
80101211:	e9 f5 00 00 00       	jmp    8010130b <filewrite+0x13c>
  if(f->type == FD_INODE){
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	8b 00                	mov    (%eax),%eax
8010121b:	83 f8 02             	cmp    $0x2,%eax
8010121e:	0f 85 db 00 00 00    	jne    801012ff <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101224:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010122b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101232:	e9 a8 00 00 00       	jmp    801012df <filewrite+0x110>
      int n1 = n - i;
80101237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010123a:	8b 55 10             	mov    0x10(%ebp),%edx
8010123d:	29 c2                	sub    %eax,%edx
8010123f:	89 d0                	mov    %edx,%eax
80101241:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101244:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101247:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010124a:	7e 06                	jle    80101252 <filewrite+0x83>
        n1 = max;
8010124c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010124f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101252:	e8 94 20 00 00       	call   801032eb <begin_trans>
      ilock(f->ip);
80101257:	8b 45 08             	mov    0x8(%ebp),%eax
8010125a:	8b 40 10             	mov    0x10(%eax),%eax
8010125d:	89 04 24             	mov    %eax,(%esp)
80101260:	e8 16 06 00 00       	call   8010187b <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101265:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101268:	8b 45 08             	mov    0x8(%ebp),%eax
8010126b:	8b 50 14             	mov    0x14(%eax),%edx
8010126e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101271:	8b 45 0c             	mov    0xc(%ebp),%eax
80101274:	01 c3                	add    %eax,%ebx
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	8b 40 10             	mov    0x10(%eax),%eax
8010127c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101280:	89 54 24 08          	mov    %edx,0x8(%esp)
80101284:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 5c 0c 00 00       	call   80101eec <writei>
80101290:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101297:	7e 11                	jle    801012aa <filewrite+0xdb>
        f->off += r;
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 50 14             	mov    0x14(%eax),%edx
8010129f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a2:	01 c2                	add    %eax,%edx
801012a4:	8b 45 08             	mov    0x8(%ebp),%eax
801012a7:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012aa:	8b 45 08             	mov    0x8(%ebp),%eax
801012ad:	8b 40 10             	mov    0x10(%eax),%eax
801012b0:	89 04 24             	mov    %eax,(%esp)
801012b3:	e8 11 07 00 00       	call   801019c9 <iunlock>
      commit_trans();
801012b8:	e8 77 20 00 00       	call   80103334 <commit_trans>

      if(r < 0)
801012bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c1:	79 02                	jns    801012c5 <filewrite+0xf6>
        break;
801012c3:	eb 26                	jmp    801012eb <filewrite+0x11c>
      if(r != n1)
801012c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012cb:	74 0c                	je     801012d9 <filewrite+0x10a>
        panic("short filewrite");
801012cd:	c7 04 24 5f 8c 10 80 	movl   $0x80108c5f,(%esp)
801012d4:	e8 61 f2 ff ff       	call   8010053a <panic>
      i += r;
801012d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012dc:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e2:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e5:	0f 8c 4c ff ff ff    	jl     80101237 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ee:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f1:	75 05                	jne    801012f8 <filewrite+0x129>
801012f3:	8b 45 10             	mov    0x10(%ebp),%eax
801012f6:	eb 05                	jmp    801012fd <filewrite+0x12e>
801012f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012fd:	eb 0c                	jmp    8010130b <filewrite+0x13c>
  }
  panic("filewrite");
801012ff:	c7 04 24 6f 8c 10 80 	movl   $0x80108c6f,(%esp)
80101306:	e8 2f f2 ff ff       	call   8010053a <panic>
}
8010130b:	83 c4 24             	add    $0x24,%esp
8010130e:	5b                   	pop    %ebx
8010130f:	5d                   	pop    %ebp
80101310:	c3                   	ret    

80101311 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101311:	55                   	push   %ebp
80101312:	89 e5                	mov    %esp,%ebp
80101314:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101321:	00 
80101322:	89 04 24             	mov    %eax,(%esp)
80101325:	e8 7c ee ff ff       	call   801001a6 <bread>
8010132a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101330:	83 c0 18             	add    $0x18,%eax
80101333:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010133a:	00 
8010133b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010133f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101342:	89 04 24             	mov    %eax,(%esp)
80101345:	e8 95 44 00 00       	call   801057df <memmove>
  brelse(bp);
8010134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134d:	89 04 24             	mov    %eax,(%esp)
80101350:	e8 c2 ee ff ff       	call   80100217 <brelse>
}
80101355:	c9                   	leave  
80101356:	c3                   	ret    

80101357 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101357:	55                   	push   %ebp
80101358:	89 e5                	mov    %esp,%ebp
8010135a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010135d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101360:	8b 45 08             	mov    0x8(%ebp),%eax
80101363:	89 54 24 04          	mov    %edx,0x4(%esp)
80101367:	89 04 24             	mov    %eax,(%esp)
8010136a:	e8 37 ee ff ff       	call   801001a6 <bread>
8010136f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101375:	83 c0 18             	add    $0x18,%eax
80101378:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010137f:	00 
80101380:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101387:	00 
80101388:	89 04 24             	mov    %eax,(%esp)
8010138b:	e8 80 43 00 00       	call   80105710 <memset>
  log_write(bp);
80101390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101393:	89 04 24             	mov    %eax,(%esp)
80101396:	e8 f1 1f 00 00       	call   8010338c <log_write>
  brelse(bp);
8010139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139e:	89 04 24             	mov    %eax,(%esp)
801013a1:	e8 71 ee ff ff       	call   80100217 <brelse>
}
801013a6:	c9                   	leave  
801013a7:	c3                   	ret    

801013a8 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013a8:	55                   	push   %ebp
801013a9:	89 e5                	mov    %esp,%ebp
801013ab:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013b5:	8b 45 08             	mov    0x8(%ebp),%eax
801013b8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bf:	89 04 24             	mov    %eax,(%esp)
801013c2:	e8 4a ff ff ff       	call   80101311 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013ce:	e9 07 01 00 00       	jmp    801014da <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013dc:	85 c0                	test   %eax,%eax
801013de:	0f 48 c2             	cmovs  %edx,%eax
801013e1:	c1 f8 0c             	sar    $0xc,%eax
801013e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013e7:	c1 ea 03             	shr    $0x3,%edx
801013ea:	01 d0                	add    %edx,%eax
801013ec:	83 c0 03             	add    $0x3,%eax
801013ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f3:	8b 45 08             	mov    0x8(%ebp),%eax
801013f6:	89 04 24             	mov    %eax,(%esp)
801013f9:	e8 a8 ed ff ff       	call   801001a6 <bread>
801013fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101401:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101408:	e9 9d 00 00 00       	jmp    801014aa <balloc+0x102>
      m = 1 << (bi % 8);
8010140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101410:	99                   	cltd   
80101411:	c1 ea 1d             	shr    $0x1d,%edx
80101414:	01 d0                	add    %edx,%eax
80101416:	83 e0 07             	and    $0x7,%eax
80101419:	29 d0                	sub    %edx,%eax
8010141b:	ba 01 00 00 00       	mov    $0x1,%edx
80101420:	89 c1                	mov    %eax,%ecx
80101422:	d3 e2                	shl    %cl,%edx
80101424:	89 d0                	mov    %edx,%eax
80101426:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142c:	8d 50 07             	lea    0x7(%eax),%edx
8010142f:	85 c0                	test   %eax,%eax
80101431:	0f 48 c2             	cmovs  %edx,%eax
80101434:	c1 f8 03             	sar    $0x3,%eax
80101437:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143a:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010143f:	0f b6 c0             	movzbl %al,%eax
80101442:	23 45 e8             	and    -0x18(%ebp),%eax
80101445:	85 c0                	test   %eax,%eax
80101447:	75 5d                	jne    801014a6 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144c:	8d 50 07             	lea    0x7(%eax),%edx
8010144f:	85 c0                	test   %eax,%eax
80101451:	0f 48 c2             	cmovs  %edx,%eax
80101454:	c1 f8 03             	sar    $0x3,%eax
80101457:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010145f:	89 d1                	mov    %edx,%ecx
80101461:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101464:	09 ca                	or     %ecx,%edx
80101466:	89 d1                	mov    %edx,%ecx
80101468:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010146f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101472:	89 04 24             	mov    %eax,(%esp)
80101475:	e8 12 1f 00 00       	call   8010338c <log_write>
        brelse(bp);
8010147a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010147d:	89 04 24             	mov    %eax,(%esp)
80101480:	e8 92 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101485:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101488:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148b:	01 c2                	add    %eax,%edx
8010148d:	8b 45 08             	mov    0x8(%ebp),%eax
80101490:	89 54 24 04          	mov    %edx,0x4(%esp)
80101494:	89 04 24             	mov    %eax,(%esp)
80101497:	e8 bb fe ff ff       	call   80101357 <bzero>
        return b + bi;
8010149c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a2:	01 d0                	add    %edx,%eax
801014a4:	eb 4e                	jmp    801014f4 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014aa:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b1:	7f 15                	jg     801014c8 <balloc+0x120>
801014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b9:	01 d0                	add    %edx,%eax
801014bb:	89 c2                	mov    %eax,%edx
801014bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c0:	39 c2                	cmp    %eax,%edx
801014c2:	0f 82 45 ff ff ff    	jb     8010140d <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014cb:	89 04 24             	mov    %eax,(%esp)
801014ce:	e8 44 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014d3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e0:	39 c2                	cmp    %eax,%edx
801014e2:	0f 82 eb fe ff ff    	jb     801013d3 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014e8:	c7 04 24 79 8c 10 80 	movl   $0x80108c79,(%esp)
801014ef:	e8 46 f0 ff ff       	call   8010053a <panic>
}
801014f4:	c9                   	leave  
801014f5:	c3                   	ret    

801014f6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014f6:	55                   	push   %ebp
801014f7:	89 e5                	mov    %esp,%ebp
801014f9:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80101503:	8b 45 08             	mov    0x8(%ebp),%eax
80101506:	89 04 24             	mov    %eax,(%esp)
80101509:	e8 03 fe ff ff       	call   80101311 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010150e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101511:	c1 e8 0c             	shr    $0xc,%eax
80101514:	89 c2                	mov    %eax,%edx
80101516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101519:	c1 e8 03             	shr    $0x3,%eax
8010151c:	01 d0                	add    %edx,%eax
8010151e:	8d 50 03             	lea    0x3(%eax),%edx
80101521:	8b 45 08             	mov    0x8(%ebp),%eax
80101524:	89 54 24 04          	mov    %edx,0x4(%esp)
80101528:	89 04 24             	mov    %eax,(%esp)
8010152b:	e8 76 ec ff ff       	call   801001a6 <bread>
80101530:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101533:	8b 45 0c             	mov    0xc(%ebp),%eax
80101536:	25 ff 0f 00 00       	and    $0xfff,%eax
8010153b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101541:	99                   	cltd   
80101542:	c1 ea 1d             	shr    $0x1d,%edx
80101545:	01 d0                	add    %edx,%eax
80101547:	83 e0 07             	and    $0x7,%eax
8010154a:	29 d0                	sub    %edx,%eax
8010154c:	ba 01 00 00 00       	mov    $0x1,%edx
80101551:	89 c1                	mov    %eax,%ecx
80101553:	d3 e2                	shl    %cl,%edx
80101555:	89 d0                	mov    %edx,%eax
80101557:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155d:	8d 50 07             	lea    0x7(%eax),%edx
80101560:	85 c0                	test   %eax,%eax
80101562:	0f 48 c2             	cmovs  %edx,%eax
80101565:	c1 f8 03             	sar    $0x3,%eax
80101568:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156b:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101570:	0f b6 c0             	movzbl %al,%eax
80101573:	23 45 ec             	and    -0x14(%ebp),%eax
80101576:	85 c0                	test   %eax,%eax
80101578:	75 0c                	jne    80101586 <bfree+0x90>
    panic("freeing free block");
8010157a:	c7 04 24 8f 8c 10 80 	movl   $0x80108c8f,(%esp)
80101581:	e8 b4 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101586:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101589:	8d 50 07             	lea    0x7(%eax),%edx
8010158c:	85 c0                	test   %eax,%eax
8010158e:	0f 48 c2             	cmovs  %edx,%eax
80101591:	c1 f8 03             	sar    $0x3,%eax
80101594:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101597:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010159c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010159f:	f7 d1                	not    %ecx
801015a1:	21 ca                	and    %ecx,%edx
801015a3:	89 d1                	mov    %edx,%ecx
801015a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a8:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015af:	89 04 24             	mov    %eax,(%esp)
801015b2:	e8 d5 1d 00 00       	call   8010338c <log_write>
  brelse(bp);
801015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ba:	89 04 24             	mov    %eax,(%esp)
801015bd:	e8 55 ec ff ff       	call   80100217 <brelse>
}
801015c2:	c9                   	leave  
801015c3:	c3                   	ret    

801015c4 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015c4:	55                   	push   %ebp
801015c5:	89 e5                	mov    %esp,%ebp
801015c7:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015ca:	c7 44 24 04 a2 8c 10 	movl   $0x80108ca2,0x4(%esp)
801015d1:	80 
801015d2:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801015d9:	e8 2d 3e 00 00       	call   8010540b <initlock>
}
801015de:	c9                   	leave  
801015df:	c3                   	ret    

801015e0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	83 ec 38             	sub    $0x38,%esp
801015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e9:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015ed:	8b 45 08             	mov    0x8(%ebp),%eax
801015f0:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801015f7:	89 04 24             	mov    %eax,(%esp)
801015fa:	e8 12 fd ff ff       	call   80101311 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101606:	e9 98 00 00 00       	jmp    801016a3 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
8010160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010160e:	c1 e8 03             	shr    $0x3,%eax
80101611:	83 c0 02             	add    $0x2,%eax
80101614:	89 44 24 04          	mov    %eax,0x4(%esp)
80101618:	8b 45 08             	mov    0x8(%ebp),%eax
8010161b:	89 04 24             	mov    %eax,(%esp)
8010161e:	e8 83 eb ff ff       	call   801001a6 <bread>
80101623:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101629:	8d 50 18             	lea    0x18(%eax),%edx
8010162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	01 d0                	add    %edx,%eax
80101637:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010163a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163d:	0f b7 00             	movzwl (%eax),%eax
80101640:	66 85 c0             	test   %ax,%ax
80101643:	75 4f                	jne    80101694 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101645:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010164c:	00 
8010164d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101654:	00 
80101655:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101658:	89 04 24             	mov    %eax,(%esp)
8010165b:	e8 b0 40 00 00       	call   80105710 <memset>
      dip->type = type;
80101660:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101663:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101667:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166d:	89 04 24             	mov    %eax,(%esp)
80101670:	e8 17 1d 00 00       	call   8010338c <log_write>
      brelse(bp);
80101675:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101678:	89 04 24             	mov    %eax,(%esp)
8010167b:	e8 97 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101683:	89 44 24 04          	mov    %eax,0x4(%esp)
80101687:	8b 45 08             	mov    0x8(%ebp),%eax
8010168a:	89 04 24             	mov    %eax,(%esp)
8010168d:	e8 e5 00 00 00       	call   80101777 <iget>
80101692:	eb 29                	jmp    801016bd <ialloc+0xdd>
    }
    brelse(bp);
80101694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101697:	89 04 24             	mov    %eax,(%esp)
8010169a:	e8 78 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010169f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016a9:	39 c2                	cmp    %eax,%edx
801016ab:	0f 82 5a ff ff ff    	jb     8010160b <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016b1:	c7 04 24 a9 8c 10 80 	movl   $0x80108ca9,(%esp)
801016b8:	e8 7d ee ff ff       	call   8010053a <panic>
}
801016bd:	c9                   	leave  
801016be:	c3                   	ret    

801016bf <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016bf:	55                   	push   %ebp
801016c0:	89 e5                	mov    %esp,%ebp
801016c2:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016c5:	8b 45 08             	mov    0x8(%ebp),%eax
801016c8:	8b 40 04             	mov    0x4(%eax),%eax
801016cb:	c1 e8 03             	shr    $0x3,%eax
801016ce:	8d 50 02             	lea    0x2(%eax),%edx
801016d1:	8b 45 08             	mov    0x8(%ebp),%eax
801016d4:	8b 00                	mov    (%eax),%eax
801016d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801016da:	89 04 24             	mov    %eax,(%esp)
801016dd:	e8 c4 ea ff ff       	call   801001a6 <bread>
801016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016e8:	8d 50 18             	lea    0x18(%eax),%edx
801016eb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ee:	8b 40 04             	mov    0x4(%eax),%eax
801016f1:	83 e0 07             	and    $0x7,%eax
801016f4:	c1 e0 06             	shl    $0x6,%eax
801016f7:	01 d0                	add    %edx,%eax
801016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101706:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101709:	8b 45 08             	mov    0x8(%ebp),%eax
8010170c:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101717:	8b 45 08             	mov    0x8(%ebp),%eax
8010171a:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101721:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101725:	8b 45 08             	mov    0x8(%ebp),%eax
80101728:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101733:	8b 45 08             	mov    0x8(%ebp),%eax
80101736:	8b 50 18             	mov    0x18(%eax),%edx
80101739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173c:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173f:	8b 45 08             	mov    0x8(%ebp),%eax
80101742:	8d 50 1c             	lea    0x1c(%eax),%edx
80101745:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101748:	83 c0 0c             	add    $0xc,%eax
8010174b:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101752:	00 
80101753:	89 54 24 04          	mov    %edx,0x4(%esp)
80101757:	89 04 24             	mov    %eax,(%esp)
8010175a:	e8 80 40 00 00       	call   801057df <memmove>
  log_write(bp);
8010175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101762:	89 04 24             	mov    %eax,(%esp)
80101765:	e8 22 1c 00 00       	call   8010338c <log_write>
  brelse(bp);
8010176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176d:	89 04 24             	mov    %eax,(%esp)
80101770:	e8 a2 ea ff ff       	call   80100217 <brelse>
}
80101775:	c9                   	leave  
80101776:	c3                   	ret    

80101777 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101777:	55                   	push   %ebp
80101778:	89 e5                	mov    %esp,%ebp
8010177a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010177d:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101784:	e8 a3 3c 00 00       	call   8010542c <acquire>

  // Is the inode already cached?
  empty = 0;
80101789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101790:	c7 45 f4 d4 f8 10 80 	movl   $0x8010f8d4,-0xc(%ebp)
80101797:	eb 59                	jmp    801017f2 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179c:	8b 40 08             	mov    0x8(%eax),%eax
8010179f:	85 c0                	test   %eax,%eax
801017a1:	7e 35                	jle    801017d8 <iget+0x61>
801017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a6:	8b 00                	mov    (%eax),%eax
801017a8:	3b 45 08             	cmp    0x8(%ebp),%eax
801017ab:	75 2b                	jne    801017d8 <iget+0x61>
801017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b0:	8b 40 04             	mov    0x4(%eax),%eax
801017b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017b6:	75 20                	jne    801017d8 <iget+0x61>
      ip->ref++;
801017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017bb:	8b 40 08             	mov    0x8(%eax),%eax
801017be:	8d 50 01             	lea    0x1(%eax),%edx
801017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c4:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017c7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801017ce:	e8 03 3d 00 00       	call   801054d6 <release>
      return ip;
801017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d6:	eb 6f                	jmp    80101847 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017dc:	75 10                	jne    801017ee <iget+0x77>
801017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e1:	8b 40 08             	mov    0x8(%eax),%eax
801017e4:	85 c0                	test   %eax,%eax
801017e6:	75 06                	jne    801017ee <iget+0x77>
      empty = ip;
801017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ee:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017f2:	81 7d f4 74 08 11 80 	cmpl   $0x80110874,-0xc(%ebp)
801017f9:	72 9e                	jb     80101799 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ff:	75 0c                	jne    8010180d <iget+0x96>
    panic("iget: no inodes");
80101801:	c7 04 24 bb 8c 10 80 	movl   $0x80108cbb,(%esp)
80101808:	e8 2d ed ff ff       	call   8010053a <panic>

  ip = empty;
8010180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101816:	8b 55 08             	mov    0x8(%ebp),%edx
80101819:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101821:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101827:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101831:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101838:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010183f:	e8 92 3c 00 00       	call   801054d6 <release>

  return ip;
80101844:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101847:	c9                   	leave  
80101848:	c3                   	ret    

80101849 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101849:	55                   	push   %ebp
8010184a:	89 e5                	mov    %esp,%ebp
8010184c:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010184f:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101856:	e8 d1 3b 00 00       	call   8010542c <acquire>
  ip->ref++;
8010185b:	8b 45 08             	mov    0x8(%ebp),%eax
8010185e:	8b 40 08             	mov    0x8(%eax),%eax
80101861:	8d 50 01             	lea    0x1(%eax),%edx
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
80101867:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010186a:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101871:	e8 60 3c 00 00       	call   801054d6 <release>
  return ip;
80101876:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101879:	c9                   	leave  
8010187a:	c3                   	ret    

8010187b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010187b:	55                   	push   %ebp
8010187c:	89 e5                	mov    %esp,%ebp
8010187e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101881:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101885:	74 0a                	je     80101891 <ilock+0x16>
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	8b 40 08             	mov    0x8(%eax),%eax
8010188d:	85 c0                	test   %eax,%eax
8010188f:	7f 0c                	jg     8010189d <ilock+0x22>
    panic("ilock");
80101891:	c7 04 24 cb 8c 10 80 	movl   $0x80108ccb,(%esp)
80101898:	e8 9d ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010189d:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018a4:	e8 83 3b 00 00       	call   8010542c <acquire>
  while(ip->flags & I_BUSY)
801018a9:	eb 13                	jmp    801018be <ilock+0x43>
    sleep(ip, &icache.lock);
801018ab:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
801018b2:	80 
801018b3:	8b 45 08             	mov    0x8(%ebp),%eax
801018b6:	89 04 24             	mov    %eax,(%esp)
801018b9:	e8 df 34 00 00       	call   80104d9d <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018be:	8b 45 08             	mov    0x8(%ebp),%eax
801018c1:	8b 40 0c             	mov    0xc(%eax),%eax
801018c4:	83 e0 01             	and    $0x1,%eax
801018c7:	85 c0                	test   %eax,%eax
801018c9:	75 e0                	jne    801018ab <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018cb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ce:	8b 40 0c             	mov    0xc(%eax),%eax
801018d1:	83 c8 01             	or     $0x1,%eax
801018d4:	89 c2                	mov    %eax,%edx
801018d6:	8b 45 08             	mov    0x8(%ebp),%eax
801018d9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018dc:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018e3:	e8 ee 3b 00 00       	call   801054d6 <release>

  if(!(ip->flags & I_VALID)){
801018e8:	8b 45 08             	mov    0x8(%ebp),%eax
801018eb:	8b 40 0c             	mov    0xc(%eax),%eax
801018ee:	83 e0 02             	and    $0x2,%eax
801018f1:	85 c0                	test   %eax,%eax
801018f3:	0f 85 ce 00 00 00    	jne    801019c7 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018f9:	8b 45 08             	mov    0x8(%ebp),%eax
801018fc:	8b 40 04             	mov    0x4(%eax),%eax
801018ff:	c1 e8 03             	shr    $0x3,%eax
80101902:	8d 50 02             	lea    0x2(%eax),%edx
80101905:	8b 45 08             	mov    0x8(%ebp),%eax
80101908:	8b 00                	mov    (%eax),%eax
8010190a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010190e:	89 04 24             	mov    %eax,(%esp)
80101911:	e8 90 e8 ff ff       	call   801001a6 <bread>
80101916:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191c:	8d 50 18             	lea    0x18(%eax),%edx
8010191f:	8b 45 08             	mov    0x8(%ebp),%eax
80101922:	8b 40 04             	mov    0x4(%eax),%eax
80101925:	83 e0 07             	and    $0x7,%eax
80101928:	c1 e0 06             	shl    $0x6,%eax
8010192b:	01 d0                	add    %edx,%eax
8010192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101933:	0f b7 10             	movzwl (%eax),%edx
80101936:	8b 45 08             	mov    0x8(%ebp),%eax
80101939:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101940:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101944:	8b 45 08             	mov    0x8(%ebp),%eax
80101947:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101960:	8b 45 08             	mov    0x8(%ebp),%eax
80101963:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196a:	8b 50 08             	mov    0x8(%eax),%edx
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101976:	8d 50 0c             	lea    0xc(%eax),%edx
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	83 c0 1c             	add    $0x1c,%eax
8010197f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101986:	00 
80101987:	89 54 24 04          	mov    %edx,0x4(%esp)
8010198b:	89 04 24             	mov    %eax,(%esp)
8010198e:	e8 4c 3e 00 00       	call   801057df <memmove>
    brelse(bp);
80101993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101996:	89 04 24             	mov    %eax,(%esp)
80101999:	e8 79 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 40 0c             	mov    0xc(%eax),%eax
801019a4:	83 c8 02             	or     $0x2,%eax
801019a7:	89 c2                	mov    %eax,%edx
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019af:	8b 45 08             	mov    0x8(%ebp),%eax
801019b2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019b6:	66 85 c0             	test   %ax,%ax
801019b9:	75 0c                	jne    801019c7 <ilock+0x14c>
      panic("ilock: no type");
801019bb:	c7 04 24 d1 8c 10 80 	movl   $0x80108cd1,(%esp)
801019c2:	e8 73 eb ff ff       	call   8010053a <panic>
  }
}
801019c7:	c9                   	leave  
801019c8:	c3                   	ret    

801019c9 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019c9:	55                   	push   %ebp
801019ca:	89 e5                	mov    %esp,%ebp
801019cc:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019d3:	74 17                	je     801019ec <iunlock+0x23>
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	8b 40 0c             	mov    0xc(%eax),%eax
801019db:	83 e0 01             	and    $0x1,%eax
801019de:	85 c0                	test   %eax,%eax
801019e0:	74 0a                	je     801019ec <iunlock+0x23>
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	8b 40 08             	mov    0x8(%eax),%eax
801019e8:	85 c0                	test   %eax,%eax
801019ea:	7f 0c                	jg     801019f8 <iunlock+0x2f>
    panic("iunlock");
801019ec:	c7 04 24 e0 8c 10 80 	movl   $0x80108ce0,(%esp)
801019f3:	e8 42 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019f8:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ff:	e8 28 3a 00 00       	call   8010542c <acquire>
  ip->flags &= ~I_BUSY;
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0a:	83 e0 fe             	and    $0xfffffffe,%eax
80101a0d:	89 c2                	mov    %eax,%edx
80101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a12:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	89 04 24             	mov    %eax,(%esp)
80101a1b:	e8 c1 34 00 00       	call   80104ee1 <wakeup>
  release(&icache.lock);
80101a20:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a27:	e8 aa 3a 00 00       	call   801054d6 <release>
}
80101a2c:	c9                   	leave  
80101a2d:	c3                   	ret    

80101a2e <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a2e:	55                   	push   %ebp
80101a2f:	89 e5                	mov    %esp,%ebp
80101a31:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a34:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a3b:	e8 ec 39 00 00       	call   8010542c <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	8b 40 08             	mov    0x8(%eax),%eax
80101a46:	83 f8 01             	cmp    $0x1,%eax
80101a49:	0f 85 93 00 00 00    	jne    80101ae2 <iput+0xb4>
80101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a52:	8b 40 0c             	mov    0xc(%eax),%eax
80101a55:	83 e0 02             	and    $0x2,%eax
80101a58:	85 c0                	test   %eax,%eax
80101a5a:	0f 84 82 00 00 00    	je     80101ae2 <iput+0xb4>
80101a60:	8b 45 08             	mov    0x8(%ebp),%eax
80101a63:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a67:	66 85 c0             	test   %ax,%ax
80101a6a:	75 76                	jne    80101ae2 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a72:	83 e0 01             	and    $0x1,%eax
80101a75:	85 c0                	test   %eax,%eax
80101a77:	74 0c                	je     80101a85 <iput+0x57>
      panic("iput busy");
80101a79:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
80101a80:	e8 b5 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a85:	8b 45 08             	mov    0x8(%ebp),%eax
80101a88:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8b:	83 c8 01             	or     $0x1,%eax
80101a8e:	89 c2                	mov    %eax,%edx
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a96:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a9d:	e8 34 3a 00 00       	call   801054d6 <release>
    itrunc(ip);
80101aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa5:	89 04 24             	mov    %eax,(%esp)
80101aa8:	e8 7d 01 00 00       	call   80101c2a <itrunc>
    ip->type = 0;
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab9:	89 04 24             	mov    %eax,(%esp)
80101abc:	e8 fe fb ff ff       	call   801016bf <iupdate>
    acquire(&icache.lock);
80101ac1:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101ac8:	e8 5f 39 00 00       	call   8010542c <acquire>
    ip->flags = 0;
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	89 04 24             	mov    %eax,(%esp)
80101add:	e8 ff 33 00 00       	call   80104ee1 <wakeup>
  }
  ip->ref--;
80101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae5:	8b 40 08             	mov    0x8(%eax),%eax
80101ae8:	8d 50 ff             	lea    -0x1(%eax),%edx
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af1:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101af8:	e8 d9 39 00 00       	call   801054d6 <release>
}
80101afd:	c9                   	leave  
80101afe:	c3                   	ret    

80101aff <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aff:	55                   	push   %ebp
80101b00:	89 e5                	mov    %esp,%ebp
80101b02:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b05:	8b 45 08             	mov    0x8(%ebp),%eax
80101b08:	89 04 24             	mov    %eax,(%esp)
80101b0b:	e8 b9 fe ff ff       	call   801019c9 <iunlock>
  iput(ip);
80101b10:	8b 45 08             	mov    0x8(%ebp),%eax
80101b13:	89 04 24             	mov    %eax,(%esp)
80101b16:	e8 13 ff ff ff       	call   80101a2e <iput>
}
80101b1b:	c9                   	leave  
80101b1c:	c3                   	ret    

80101b1d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b1d:	55                   	push   %ebp
80101b1e:	89 e5                	mov    %esp,%ebp
80101b20:	53                   	push   %ebx
80101b21:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b24:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b28:	77 3e                	ja     80101b68 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b30:	83 c2 04             	add    $0x4,%edx
80101b33:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b3e:	75 20                	jne    80101b60 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	8b 00                	mov    (%eax),%eax
80101b45:	89 04 24             	mov    %eax,(%esp)
80101b48:	e8 5b f8 ff ff       	call   801013a8 <balloc>
80101b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b56:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b5c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b63:	e9 bc 00 00 00       	jmp    80101c24 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b68:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b6c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b70:	0f 87 a2 00 00 00    	ja     80101c18 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b76:	8b 45 08             	mov    0x8(%ebp),%eax
80101b79:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b83:	75 19                	jne    80101b9e <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	8b 00                	mov    (%eax),%eax
80101b8a:	89 04 24             	mov    %eax,(%esp)
80101b8d:	e8 16 f8 ff ff       	call   801013a8 <balloc>
80101b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b9b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba1:	8b 00                	mov    (%eax),%eax
80101ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ba6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101baa:	89 04 24             	mov    %eax,(%esp)
80101bad:	e8 f4 e5 ff ff       	call   801001a6 <bread>
80101bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bb8:	83 c0 18             	add    $0x18,%eax
80101bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bcb:	01 d0                	add    %edx,%eax
80101bcd:	8b 00                	mov    (%eax),%eax
80101bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bd6:	75 30                	jne    80101c08 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bdb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101be5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 00                	mov    (%eax),%eax
80101bed:	89 04 24             	mov    %eax,(%esp)
80101bf0:	e8 b3 f7 ff ff       	call   801013a8 <balloc>
80101bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bfb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c00:	89 04 24             	mov    %eax,(%esp)
80101c03:	e8 84 17 00 00       	call   8010338c <log_write>
    }
    brelse(bp);
80101c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c0b:	89 04 24             	mov    %eax,(%esp)
80101c0e:	e8 04 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c16:	eb 0c                	jmp    80101c24 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c18:	c7 04 24 f2 8c 10 80 	movl   $0x80108cf2,(%esp)
80101c1f:	e8 16 e9 ff ff       	call   8010053a <panic>
}
80101c24:	83 c4 24             	add    $0x24,%esp
80101c27:	5b                   	pop    %ebx
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    

80101c2a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c2a:	55                   	push   %ebp
80101c2b:	89 e5                	mov    %esp,%ebp
80101c2d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c37:	eb 44                	jmp    80101c7d <itrunc+0x53>
    if(ip->addrs[i]){
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3f:	83 c2 04             	add    $0x4,%edx
80101c42:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c46:	85 c0                	test   %eax,%eax
80101c48:	74 2f                	je     80101c79 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c50:	83 c2 04             	add    $0x4,%edx
80101c53:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	8b 00                	mov    (%eax),%eax
80101c5c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c60:	89 04 24             	mov    %eax,(%esp)
80101c63:	e8 8e f8 ff ff       	call   801014f6 <bfree>
      ip->addrs[i] = 0;
80101c68:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6e:	83 c2 04             	add    $0x4,%edx
80101c71:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c78:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c7d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c81:	7e b6                	jle    80101c39 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c83:	8b 45 08             	mov    0x8(%ebp),%eax
80101c86:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c89:	85 c0                	test   %eax,%eax
80101c8b:	0f 84 9b 00 00 00    	je     80101d2c <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c91:	8b 45 08             	mov    0x8(%ebp),%eax
80101c94:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c97:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9a:	8b 00                	mov    (%eax),%eax
80101c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ca0:	89 04 24             	mov    %eax,(%esp)
80101ca3:	e8 fe e4 ff ff       	call   801001a6 <bread>
80101ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cae:	83 c0 18             	add    $0x18,%eax
80101cb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cbb:	eb 3b                	jmp    80101cf8 <itrunc+0xce>
      if(a[j])
80101cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cca:	01 d0                	add    %edx,%eax
80101ccc:	8b 00                	mov    (%eax),%eax
80101cce:	85 c0                	test   %eax,%eax
80101cd0:	74 22                	je     80101cf4 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cdf:	01 d0                	add    %edx,%eax
80101ce1:	8b 10                	mov    (%eax),%edx
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cec:	89 04 24             	mov    %eax,(%esp)
80101cef:	e8 02 f8 ff ff       	call   801014f6 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cf4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfb:	83 f8 7f             	cmp    $0x7f,%eax
80101cfe:	76 bd                	jbe    80101cbd <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d03:	89 04 24             	mov    %eax,(%esp)
80101d06:	e8 0c e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0e:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d11:	8b 45 08             	mov    0x8(%ebp),%eax
80101d14:	8b 00                	mov    (%eax),%eax
80101d16:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d1a:	89 04 24             	mov    %eax,(%esp)
80101d1d:	e8 d4 f7 ff ff       	call   801014f6 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d22:	8b 45 08             	mov    0x8(%ebp),%eax
80101d25:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	89 04 24             	mov    %eax,(%esp)
80101d3c:	e8 7e f9 ff ff       	call   801016bf <iupdate>
}
80101d41:	c9                   	leave  
80101d42:	c3                   	ret    

80101d43 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d43:	55                   	push   %ebp
80101d44:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d46:	8b 45 08             	mov    0x8(%ebp),%eax
80101d49:	8b 00                	mov    (%eax),%eax
80101d4b:	89 c2                	mov    %eax,%edx
80101d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d50:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d53:	8b 45 08             	mov    0x8(%ebp),%eax
80101d56:	8b 50 04             	mov    0x4(%eax),%edx
80101d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d62:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d69:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d76:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7d:	8b 50 18             	mov    0x18(%eax),%edx
80101d80:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d83:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d86:	5d                   	pop    %ebp
80101d87:	c3                   	ret    

80101d88 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d88:	55                   	push   %ebp
80101d89:	89 e5                	mov    %esp,%ebp
80101d8b:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d91:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d95:	66 83 f8 03          	cmp    $0x3,%ax
80101d99:	75 60                	jne    80101dfb <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da2:	66 85 c0             	test   %ax,%ax
80101da5:	78 20                	js     80101dc7 <readi+0x3f>
80101da7:	8b 45 08             	mov    0x8(%ebp),%eax
80101daa:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dae:	66 83 f8 09          	cmp    $0x9,%ax
80101db2:	7f 13                	jg     80101dc7 <readi+0x3f>
80101db4:	8b 45 08             	mov    0x8(%ebp),%eax
80101db7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dbb:	98                   	cwtl   
80101dbc:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	75 0a                	jne    80101dd1 <readi+0x49>
      return -1;
80101dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dcc:	e9 19 01 00 00       	jmp    80101eea <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd8:	98                   	cwtl   
80101dd9:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101de0:	8b 55 14             	mov    0x14(%ebp),%edx
80101de3:	89 54 24 08          	mov    %edx,0x8(%esp)
80101de7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dea:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dee:	8b 55 08             	mov    0x8(%ebp),%edx
80101df1:	89 14 24             	mov    %edx,(%esp)
80101df4:	ff d0                	call   *%eax
80101df6:	e9 ef 00 00 00       	jmp    80101eea <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfe:	8b 40 18             	mov    0x18(%eax),%eax
80101e01:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e04:	72 0d                	jb     80101e13 <readi+0x8b>
80101e06:	8b 45 14             	mov    0x14(%ebp),%eax
80101e09:	8b 55 10             	mov    0x10(%ebp),%edx
80101e0c:	01 d0                	add    %edx,%eax
80101e0e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e11:	73 0a                	jae    80101e1d <readi+0x95>
    return -1;
80101e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e18:	e9 cd 00 00 00       	jmp    80101eea <readi+0x162>
  if(off + n > ip->size)
80101e1d:	8b 45 14             	mov    0x14(%ebp),%eax
80101e20:	8b 55 10             	mov    0x10(%ebp),%edx
80101e23:	01 c2                	add    %eax,%edx
80101e25:	8b 45 08             	mov    0x8(%ebp),%eax
80101e28:	8b 40 18             	mov    0x18(%eax),%eax
80101e2b:	39 c2                	cmp    %eax,%edx
80101e2d:	76 0c                	jbe    80101e3b <readi+0xb3>
    n = ip->size - off;
80101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e32:	8b 40 18             	mov    0x18(%eax),%eax
80101e35:	2b 45 10             	sub    0x10(%ebp),%eax
80101e38:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e42:	e9 94 00 00 00       	jmp    80101edb <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	c1 e8 09             	shr    $0x9,%eax
80101e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	89 04 24             	mov    %eax,(%esp)
80101e57:	e8 c1 fc ff ff       	call   80101b1d <bmap>
80101e5c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e5f:	8b 12                	mov    (%edx),%edx
80101e61:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e65:	89 14 24             	mov    %edx,(%esp)
80101e68:	e8 39 e3 ff ff       	call   801001a6 <bread>
80101e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e70:	8b 45 10             	mov    0x10(%ebp),%eax
80101e73:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e78:	89 c2                	mov    %eax,%edx
80101e7a:	b8 00 02 00 00       	mov    $0x200,%eax
80101e7f:	29 d0                	sub    %edx,%eax
80101e81:	89 c2                	mov    %eax,%edx
80101e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e86:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e89:	29 c1                	sub    %eax,%ecx
80101e8b:	89 c8                	mov    %ecx,%eax
80101e8d:	39 c2                	cmp    %eax,%edx
80101e8f:	0f 46 c2             	cmovbe %edx,%eax
80101e92:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e95:	8b 45 10             	mov    0x10(%ebp),%eax
80101e98:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e9d:	8d 50 10             	lea    0x10(%eax),%edx
80101ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea3:	01 d0                	add    %edx,%eax
80101ea5:	8d 50 08             	lea    0x8(%eax),%edx
80101ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eab:	89 44 24 08          	mov    %eax,0x8(%esp)
80101eaf:	89 54 24 04          	mov    %edx,0x4(%esp)
80101eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 21 39 00 00       	call   801057df <memmove>
    brelse(bp);
80101ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec1:	89 04 24             	mov    %eax,(%esp)
80101ec4:	e8 4e e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ecc:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed2:	01 45 10             	add    %eax,0x10(%ebp)
80101ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed8:	01 45 0c             	add    %eax,0xc(%ebp)
80101edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ede:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ee1:	0f 82 60 ff ff ff    	jb     80101e47 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ee7:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eea:	c9                   	leave  
80101eeb:	c3                   	ret    

80101eec <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eec:	55                   	push   %ebp
80101eed:	89 e5                	mov    %esp,%ebp
80101eef:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ef9:	66 83 f8 03          	cmp    $0x3,%ax
80101efd:	75 60                	jne    80101f5f <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101eff:	8b 45 08             	mov    0x8(%ebp),%eax
80101f02:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f06:	66 85 c0             	test   %ax,%ax
80101f09:	78 20                	js     80101f2b <writei+0x3f>
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f12:	66 83 f8 09          	cmp    $0x9,%ax
80101f16:	7f 13                	jg     80101f2b <writei+0x3f>
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f1f:	98                   	cwtl   
80101f20:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f27:	85 c0                	test   %eax,%eax
80101f29:	75 0a                	jne    80101f35 <writei+0x49>
      return -1;
80101f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f30:	e9 44 01 00 00       	jmp    80102079 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f35:	8b 45 08             	mov    0x8(%ebp),%eax
80101f38:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f3c:	98                   	cwtl   
80101f3d:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f44:	8b 55 14             	mov    0x14(%ebp),%edx
80101f47:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f4e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f52:	8b 55 08             	mov    0x8(%ebp),%edx
80101f55:	89 14 24             	mov    %edx,(%esp)
80101f58:	ff d0                	call   *%eax
80101f5a:	e9 1a 01 00 00       	jmp    80102079 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f62:	8b 40 18             	mov    0x18(%eax),%eax
80101f65:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f68:	72 0d                	jb     80101f77 <writei+0x8b>
80101f6a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6d:	8b 55 10             	mov    0x10(%ebp),%edx
80101f70:	01 d0                	add    %edx,%eax
80101f72:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f75:	73 0a                	jae    80101f81 <writei+0x95>
    return -1;
80101f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f7c:	e9 f8 00 00 00       	jmp    80102079 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f81:	8b 45 14             	mov    0x14(%ebp),%eax
80101f84:	8b 55 10             	mov    0x10(%ebp),%edx
80101f87:	01 d0                	add    %edx,%eax
80101f89:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f8e:	76 0a                	jbe    80101f9a <writei+0xae>
    return -1;
80101f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f95:	e9 df 00 00 00       	jmp    80102079 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fa1:	e9 9f 00 00 00       	jmp    80102045 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa9:	c1 e8 09             	shr    $0x9,%eax
80101fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb3:	89 04 24             	mov    %eax,(%esp)
80101fb6:	e8 62 fb ff ff       	call   80101b1d <bmap>
80101fbb:	8b 55 08             	mov    0x8(%ebp),%edx
80101fbe:	8b 12                	mov    (%edx),%edx
80101fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fc4:	89 14 24             	mov    %edx,(%esp)
80101fc7:	e8 da e1 ff ff       	call   801001a6 <bread>
80101fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fcf:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fd7:	89 c2                	mov    %eax,%edx
80101fd9:	b8 00 02 00 00       	mov    $0x200,%eax
80101fde:	29 d0                	sub    %edx,%eax
80101fe0:	89 c2                	mov    %eax,%edx
80101fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fe5:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fe8:	29 c1                	sub    %eax,%ecx
80101fea:	89 c8                	mov    %ecx,%eax
80101fec:	39 c2                	cmp    %eax,%edx
80101fee:	0f 46 c2             	cmovbe %edx,%eax
80101ff1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101ff4:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ffc:	8d 50 10             	lea    0x10(%eax),%edx
80101fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102002:	01 d0                	add    %edx,%eax
80102004:	8d 50 08             	lea    0x8(%eax),%edx
80102007:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010200e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102011:	89 44 24 04          	mov    %eax,0x4(%esp)
80102015:	89 14 24             	mov    %edx,(%esp)
80102018:	e8 c2 37 00 00       	call   801057df <memmove>
    log_write(bp);
8010201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102020:	89 04 24             	mov    %eax,(%esp)
80102023:	e8 64 13 00 00       	call   8010338c <log_write>
    brelse(bp);
80102028:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202b:	89 04 24             	mov    %eax,(%esp)
8010202e:	e8 e4 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102033:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102036:	01 45 f4             	add    %eax,-0xc(%ebp)
80102039:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203c:	01 45 10             	add    %eax,0x10(%ebp)
8010203f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102042:	01 45 0c             	add    %eax,0xc(%ebp)
80102045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102048:	3b 45 14             	cmp    0x14(%ebp),%eax
8010204b:	0f 82 55 ff ff ff    	jb     80101fa6 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102051:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102055:	74 1f                	je     80102076 <writei+0x18a>
80102057:	8b 45 08             	mov    0x8(%ebp),%eax
8010205a:	8b 40 18             	mov    0x18(%eax),%eax
8010205d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102060:	73 14                	jae    80102076 <writei+0x18a>
    ip->size = off;
80102062:	8b 45 08             	mov    0x8(%ebp),%eax
80102065:	8b 55 10             	mov    0x10(%ebp),%edx
80102068:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010206b:	8b 45 08             	mov    0x8(%ebp),%eax
8010206e:	89 04 24             	mov    %eax,(%esp)
80102071:	e8 49 f6 ff ff       	call   801016bf <iupdate>
  }
  return n;
80102076:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102079:	c9                   	leave  
8010207a:	c3                   	ret    

8010207b <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010207b:	55                   	push   %ebp
8010207c:	89 e5                	mov    %esp,%ebp
8010207e:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102081:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102088:	00 
80102089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102090:	8b 45 08             	mov    0x8(%ebp),%eax
80102093:	89 04 24             	mov    %eax,(%esp)
80102096:	e8 e7 37 00 00       	call   80105882 <strncmp>
}
8010209b:	c9                   	leave  
8010209c:	c3                   	ret    

8010209d <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010209d:	55                   	push   %ebp
8010209e:	89 e5                	mov    %esp,%ebp
801020a0:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020a3:	8b 45 08             	mov    0x8(%ebp),%eax
801020a6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020aa:	66 83 f8 01          	cmp    $0x1,%ax
801020ae:	74 0c                	je     801020bc <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020b0:	c7 04 24 05 8d 10 80 	movl   $0x80108d05,(%esp)
801020b7:	e8 7e e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020c3:	e9 88 00 00 00       	jmp    80102150 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020cf:	00 
801020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801020d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020da:	89 44 24 04          	mov    %eax,0x4(%esp)
801020de:	8b 45 08             	mov    0x8(%ebp),%eax
801020e1:	89 04 24             	mov    %eax,(%esp)
801020e4:	e8 9f fc ff ff       	call   80101d88 <readi>
801020e9:	83 f8 10             	cmp    $0x10,%eax
801020ec:	74 0c                	je     801020fa <dirlookup+0x5d>
      panic("dirlink read");
801020ee:	c7 04 24 17 8d 10 80 	movl   $0x80108d17,(%esp)
801020f5:	e8 40 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020fa:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020fe:	66 85 c0             	test   %ax,%ax
80102101:	75 02                	jne    80102105 <dirlookup+0x68>
      continue;
80102103:	eb 47                	jmp    8010214c <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102105:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102108:	83 c0 02             	add    $0x2,%eax
8010210b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010210f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102112:	89 04 24             	mov    %eax,(%esp)
80102115:	e8 61 ff ff ff       	call   8010207b <namecmp>
8010211a:	85 c0                	test   %eax,%eax
8010211c:	75 2e                	jne    8010214c <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010211e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102122:	74 08                	je     8010212c <dirlookup+0x8f>
        *poff = off;
80102124:	8b 45 10             	mov    0x10(%ebp),%eax
80102127:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010212a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010212c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102130:	0f b7 c0             	movzwl %ax,%eax
80102133:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102136:	8b 45 08             	mov    0x8(%ebp),%eax
80102139:	8b 00                	mov    (%eax),%eax
8010213b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010213e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102142:	89 04 24             	mov    %eax,(%esp)
80102145:	e8 2d f6 ff ff       	call   80101777 <iget>
8010214a:	eb 18                	jmp    80102164 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010214c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 40 18             	mov    0x18(%eax),%eax
80102156:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102159:	0f 87 69 ff ff ff    	ja     801020c8 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010215f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102164:	c9                   	leave  
80102165:	c3                   	ret    

80102166 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102166:	55                   	push   %ebp
80102167:	89 e5                	mov    %esp,%ebp
80102169:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010216c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102173:	00 
80102174:	8b 45 0c             	mov    0xc(%ebp),%eax
80102177:	89 44 24 04          	mov    %eax,0x4(%esp)
8010217b:	8b 45 08             	mov    0x8(%ebp),%eax
8010217e:	89 04 24             	mov    %eax,(%esp)
80102181:	e8 17 ff ff ff       	call   8010209d <dirlookup>
80102186:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102189:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010218d:	74 15                	je     801021a4 <dirlink+0x3e>
    iput(ip);
8010218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102192:	89 04 24             	mov    %eax,(%esp)
80102195:	e8 94 f8 ff ff       	call   80101a2e <iput>
    return -1;
8010219a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010219f:	e9 b7 00 00 00       	jmp    8010225b <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ab:	eb 46                	jmp    801021f3 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021b7:	00 
801021b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801021bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c3:	8b 45 08             	mov    0x8(%ebp),%eax
801021c6:	89 04 24             	mov    %eax,(%esp)
801021c9:	e8 ba fb ff ff       	call   80101d88 <readi>
801021ce:	83 f8 10             	cmp    $0x10,%eax
801021d1:	74 0c                	je     801021df <dirlink+0x79>
      panic("dirlink read");
801021d3:	c7 04 24 17 8d 10 80 	movl   $0x80108d17,(%esp)
801021da:	e8 5b e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021df:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e3:	66 85 c0             	test   %ax,%ax
801021e6:	75 02                	jne    801021ea <dirlink+0x84>
      break;
801021e8:	eb 16                	jmp    80102200 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ed:	83 c0 10             	add    $0x10,%eax
801021f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021f6:	8b 45 08             	mov    0x8(%ebp),%eax
801021f9:	8b 40 18             	mov    0x18(%eax),%eax
801021fc:	39 c2                	cmp    %eax,%edx
801021fe:	72 ad                	jb     801021ad <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102200:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102207:	00 
80102208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010220b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102212:	83 c0 02             	add    $0x2,%eax
80102215:	89 04 24             	mov    %eax,(%esp)
80102218:	e8 bb 36 00 00       	call   801058d8 <strncpy>
  de.inum = inum;
8010221d:	8b 45 10             	mov    0x10(%ebp),%eax
80102220:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102227:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010222e:	00 
8010222f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102233:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102236:	89 44 24 04          	mov    %eax,0x4(%esp)
8010223a:	8b 45 08             	mov    0x8(%ebp),%eax
8010223d:	89 04 24             	mov    %eax,(%esp)
80102240:	e8 a7 fc ff ff       	call   80101eec <writei>
80102245:	83 f8 10             	cmp    $0x10,%eax
80102248:	74 0c                	je     80102256 <dirlink+0xf0>
    panic("dirlink");
8010224a:	c7 04 24 24 8d 10 80 	movl   $0x80108d24,(%esp)
80102251:	e8 e4 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102256:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010225b:	c9                   	leave  
8010225c:	c3                   	ret    

8010225d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010225d:	55                   	push   %ebp
8010225e:	89 e5                	mov    %esp,%ebp
80102260:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102263:	eb 04                	jmp    80102269 <skipelem+0xc>
    path++;
80102265:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102269:	8b 45 08             	mov    0x8(%ebp),%eax
8010226c:	0f b6 00             	movzbl (%eax),%eax
8010226f:	3c 2f                	cmp    $0x2f,%al
80102271:	74 f2                	je     80102265 <skipelem+0x8>
    path++;
  if(*path == 0)
80102273:	8b 45 08             	mov    0x8(%ebp),%eax
80102276:	0f b6 00             	movzbl (%eax),%eax
80102279:	84 c0                	test   %al,%al
8010227b:	75 0a                	jne    80102287 <skipelem+0x2a>
    return 0;
8010227d:	b8 00 00 00 00       	mov    $0x0,%eax
80102282:	e9 86 00 00 00       	jmp    8010230d <skipelem+0xb0>
  s = path;
80102287:	8b 45 08             	mov    0x8(%ebp),%eax
8010228a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010228d:	eb 04                	jmp    80102293 <skipelem+0x36>
    path++;
8010228f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
80102296:	0f b6 00             	movzbl (%eax),%eax
80102299:	3c 2f                	cmp    $0x2f,%al
8010229b:	74 0a                	je     801022a7 <skipelem+0x4a>
8010229d:	8b 45 08             	mov    0x8(%ebp),%eax
801022a0:	0f b6 00             	movzbl (%eax),%eax
801022a3:	84 c0                	test   %al,%al
801022a5:	75 e8                	jne    8010228f <skipelem+0x32>
    path++;
  len = path - s;
801022a7:	8b 55 08             	mov    0x8(%ebp),%edx
801022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ad:	29 c2                	sub    %eax,%edx
801022af:	89 d0                	mov    %edx,%eax
801022b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022b4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022b8:	7e 1c                	jle    801022d6 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022ba:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022c1:	00 
801022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801022cc:	89 04 24             	mov    %eax,(%esp)
801022cf:	e8 0b 35 00 00       	call   801057df <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022d4:	eb 2a                	jmp    80102300 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e7:	89 04 24             	mov    %eax,(%esp)
801022ea:	e8 f0 34 00 00       	call   801057df <memmove>
    name[len] = 0;
801022ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f5:	01 d0                	add    %edx,%eax
801022f7:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022fa:	eb 04                	jmp    80102300 <skipelem+0xa3>
    path++;
801022fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102300:	8b 45 08             	mov    0x8(%ebp),%eax
80102303:	0f b6 00             	movzbl (%eax),%eax
80102306:	3c 2f                	cmp    $0x2f,%al
80102308:	74 f2                	je     801022fc <skipelem+0x9f>
    path++;
  return path;
8010230a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010230d:	c9                   	leave  
8010230e:	c3                   	ret    

8010230f <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010230f:	55                   	push   %ebp
80102310:	89 e5                	mov    %esp,%ebp
80102312:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102315:	8b 45 08             	mov    0x8(%ebp),%eax
80102318:	0f b6 00             	movzbl (%eax),%eax
8010231b:	3c 2f                	cmp    $0x2f,%al
8010231d:	75 1c                	jne    8010233b <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010232e:	e8 44 f4 ff ff       	call   80101777 <iget>
80102333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102336:	e9 af 00 00 00       	jmp    801023ea <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010233b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102341:	8b 40 68             	mov    0x68(%eax),%eax
80102344:	89 04 24             	mov    %eax,(%esp)
80102347:	e8 fd f4 ff ff       	call   80101849 <idup>
8010234c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010234f:	e9 96 00 00 00       	jmp    801023ea <namex+0xdb>
    ilock(ip);
80102354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102357:	89 04 24             	mov    %eax,(%esp)
8010235a:	e8 1c f5 ff ff       	call   8010187b <ilock>
    if(ip->type != T_DIR){
8010235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102362:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102366:	66 83 f8 01          	cmp    $0x1,%ax
8010236a:	74 15                	je     80102381 <namex+0x72>
      iunlockput(ip);
8010236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236f:	89 04 24             	mov    %eax,(%esp)
80102372:	e8 88 f7 ff ff       	call   80101aff <iunlockput>
      return 0;
80102377:	b8 00 00 00 00       	mov    $0x0,%eax
8010237c:	e9 a3 00 00 00       	jmp    80102424 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102381:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102385:	74 1d                	je     801023a4 <namex+0x95>
80102387:	8b 45 08             	mov    0x8(%ebp),%eax
8010238a:	0f b6 00             	movzbl (%eax),%eax
8010238d:	84 c0                	test   %al,%al
8010238f:	75 13                	jne    801023a4 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102394:	89 04 24             	mov    %eax,(%esp)
80102397:	e8 2d f6 ff ff       	call   801019c9 <iunlock>
      return ip;
8010239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239f:	e9 80 00 00 00       	jmp    80102424 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023ab:	00 
801023ac:	8b 45 10             	mov    0x10(%ebp),%eax
801023af:	89 44 24 04          	mov    %eax,0x4(%esp)
801023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b6:	89 04 24             	mov    %eax,(%esp)
801023b9:	e8 df fc ff ff       	call   8010209d <dirlookup>
801023be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023c5:	75 12                	jne    801023d9 <namex+0xca>
      iunlockput(ip);
801023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ca:	89 04 24             	mov    %eax,(%esp)
801023cd:	e8 2d f7 ff ff       	call   80101aff <iunlockput>
      return 0;
801023d2:	b8 00 00 00 00       	mov    $0x0,%eax
801023d7:	eb 4b                	jmp    80102424 <namex+0x115>
    }
    iunlockput(ip);
801023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023dc:	89 04 24             	mov    %eax,(%esp)
801023df:	e8 1b f7 ff ff       	call   80101aff <iunlockput>
    ip = next;
801023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ea:	8b 45 10             	mov    0x10(%ebp),%eax
801023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801023f1:	8b 45 08             	mov    0x8(%ebp),%eax
801023f4:	89 04 24             	mov    %eax,(%esp)
801023f7:	e8 61 fe ff ff       	call   8010225d <skipelem>
801023fc:	89 45 08             	mov    %eax,0x8(%ebp)
801023ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102403:	0f 85 4b ff ff ff    	jne    80102354 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010240d:	74 12                	je     80102421 <namex+0x112>
    iput(ip);
8010240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102412:	89 04 24             	mov    %eax,(%esp)
80102415:	e8 14 f6 ff ff       	call   80101a2e <iput>
    return 0;
8010241a:	b8 00 00 00 00       	mov    $0x0,%eax
8010241f:	eb 03                	jmp    80102424 <namex+0x115>
  }
  return ip;
80102421:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102424:	c9                   	leave  
80102425:	c3                   	ret    

80102426 <namei>:

struct inode*
namei(char *path)
{
80102426:	55                   	push   %ebp
80102427:	89 e5                	mov    %esp,%ebp
80102429:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010242c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010242f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102433:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010243a:	00 
8010243b:	8b 45 08             	mov    0x8(%ebp),%eax
8010243e:	89 04 24             	mov    %eax,(%esp)
80102441:	e8 c9 fe ff ff       	call   8010230f <namex>
}
80102446:	c9                   	leave  
80102447:	c3                   	ret    

80102448 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102448:	55                   	push   %ebp
80102449:	89 e5                	mov    %esp,%ebp
8010244b:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010244e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102451:	89 44 24 08          	mov    %eax,0x8(%esp)
80102455:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010245c:	00 
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
80102460:	89 04 24             	mov    %eax,(%esp)
80102463:	e8 a7 fe ff ff       	call   8010230f <namex>
}
80102468:	c9                   	leave  
80102469:	c3                   	ret    

8010246a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010246a:	55                   	push   %ebp
8010246b:	89 e5                	mov    %esp,%ebp
8010246d:	83 ec 14             	sub    $0x14,%esp
80102470:	8b 45 08             	mov    0x8(%ebp),%eax
80102473:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102477:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010247b:	89 c2                	mov    %eax,%edx
8010247d:	ec                   	in     (%dx),%al
8010247e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102481:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102485:	c9                   	leave  
80102486:	c3                   	ret    

80102487 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102487:	55                   	push   %ebp
80102488:	89 e5                	mov    %esp,%ebp
8010248a:	57                   	push   %edi
8010248b:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010248c:	8b 55 08             	mov    0x8(%ebp),%edx
8010248f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102492:	8b 45 10             	mov    0x10(%ebp),%eax
80102495:	89 cb                	mov    %ecx,%ebx
80102497:	89 df                	mov    %ebx,%edi
80102499:	89 c1                	mov    %eax,%ecx
8010249b:	fc                   	cld    
8010249c:	f3 6d                	rep insl (%dx),%es:(%edi)
8010249e:	89 c8                	mov    %ecx,%eax
801024a0:	89 fb                	mov    %edi,%ebx
801024a2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024a5:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024a8:	5b                   	pop    %ebx
801024a9:	5f                   	pop    %edi
801024aa:	5d                   	pop    %ebp
801024ab:	c3                   	ret    

801024ac <outb>:

static inline void
outb(ushort port, uchar data)
{
801024ac:	55                   	push   %ebp
801024ad:	89 e5                	mov    %esp,%ebp
801024af:	83 ec 08             	sub    $0x8,%esp
801024b2:	8b 55 08             	mov    0x8(%ebp),%edx
801024b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801024b8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024bc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024bf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024c3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024c7:	ee                   	out    %al,(%dx)
}
801024c8:	c9                   	leave  
801024c9:	c3                   	ret    

801024ca <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024ca:	55                   	push   %ebp
801024cb:	89 e5                	mov    %esp,%ebp
801024cd:	56                   	push   %esi
801024ce:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024cf:	8b 55 08             	mov    0x8(%ebp),%edx
801024d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024d5:	8b 45 10             	mov    0x10(%ebp),%eax
801024d8:	89 cb                	mov    %ecx,%ebx
801024da:	89 de                	mov    %ebx,%esi
801024dc:	89 c1                	mov    %eax,%ecx
801024de:	fc                   	cld    
801024df:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024e1:	89 c8                	mov    %ecx,%eax
801024e3:	89 f3                	mov    %esi,%ebx
801024e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024e8:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024eb:	5b                   	pop    %ebx
801024ec:	5e                   	pop    %esi
801024ed:	5d                   	pop    %ebp
801024ee:	c3                   	ret    

801024ef <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024ef:	55                   	push   %ebp
801024f0:	89 e5                	mov    %esp,%ebp
801024f2:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024f5:	90                   	nop
801024f6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024fd:	e8 68 ff ff ff       	call   8010246a <inb>
80102502:	0f b6 c0             	movzbl %al,%eax
80102505:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102508:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010250b:	25 c0 00 00 00       	and    $0xc0,%eax
80102510:	83 f8 40             	cmp    $0x40,%eax
80102513:	75 e1                	jne    801024f6 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102519:	74 11                	je     8010252c <idewait+0x3d>
8010251b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010251e:	83 e0 21             	and    $0x21,%eax
80102521:	85 c0                	test   %eax,%eax
80102523:	74 07                	je     8010252c <idewait+0x3d>
    return -1;
80102525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010252a:	eb 05                	jmp    80102531 <idewait+0x42>
  return 0;
8010252c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102531:	c9                   	leave  
80102532:	c3                   	ret    

80102533 <ideinit>:

void
ideinit(void)
{
80102533:	55                   	push   %ebp
80102534:	89 e5                	mov    %esp,%ebp
80102536:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102539:	c7 44 24 04 2c 8d 10 	movl   $0x80108d2c,0x4(%esp)
80102540:	80 
80102541:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102548:	e8 be 2e 00 00       	call   8010540b <initlock>
  picenable(IRQ_IDE);
8010254d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102554:	e8 0f 16 00 00       	call   80103b68 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102559:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010255e:	83 e8 01             	sub    $0x1,%eax
80102561:	89 44 24 04          	mov    %eax,0x4(%esp)
80102565:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010256c:	e8 0c 04 00 00       	call   8010297d <ioapicenable>
  idewait(0);
80102571:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102578:	e8 72 ff ff ff       	call   801024ef <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010257d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102584:	00 
80102585:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010258c:	e8 1b ff ff ff       	call   801024ac <outb>
  for(i=0; i<1000; i++){
80102591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102598:	eb 20                	jmp    801025ba <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010259a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025a1:	e8 c4 fe ff ff       	call   8010246a <inb>
801025a6:	84 c0                	test   %al,%al
801025a8:	74 0c                	je     801025b6 <ideinit+0x83>
      havedisk1 = 1;
801025aa:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025b1:	00 00 00 
      break;
801025b4:	eb 0d                	jmp    801025c3 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ba:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025c1:	7e d7                	jle    8010259a <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025c3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025ca:	00 
801025cb:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025d2:	e8 d5 fe ff ff       	call   801024ac <outb>
}
801025d7:	c9                   	leave  
801025d8:	c3                   	ret    

801025d9 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025d9:	55                   	push   %ebp
801025da:	89 e5                	mov    %esp,%ebp
801025dc:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025e3:	75 0c                	jne    801025f1 <idestart+0x18>
    panic("idestart");
801025e5:	c7 04 24 30 8d 10 80 	movl   $0x80108d30,(%esp)
801025ec:	e8 49 df ff ff       	call   8010053a <panic>

  idewait(0);
801025f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025f8:	e8 f2 fe ff ff       	call   801024ef <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102604:	00 
80102605:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010260c:	e8 9b fe ff ff       	call   801024ac <outb>
  outb(0x1f2, 1);  // number of sectors
80102611:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102618:	00 
80102619:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102620:	e8 87 fe ff ff       	call   801024ac <outb>
  outb(0x1f3, b->sector & 0xff);
80102625:	8b 45 08             	mov    0x8(%ebp),%eax
80102628:	8b 40 08             	mov    0x8(%eax),%eax
8010262b:	0f b6 c0             	movzbl %al,%eax
8010262e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102632:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102639:	e8 6e fe ff ff       	call   801024ac <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010263e:	8b 45 08             	mov    0x8(%ebp),%eax
80102641:	8b 40 08             	mov    0x8(%eax),%eax
80102644:	c1 e8 08             	shr    $0x8,%eax
80102647:	0f b6 c0             	movzbl %al,%eax
8010264a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010264e:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102655:	e8 52 fe ff ff       	call   801024ac <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010265a:	8b 45 08             	mov    0x8(%ebp),%eax
8010265d:	8b 40 08             	mov    0x8(%eax),%eax
80102660:	c1 e8 10             	shr    $0x10,%eax
80102663:	0f b6 c0             	movzbl %al,%eax
80102666:	89 44 24 04          	mov    %eax,0x4(%esp)
8010266a:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102671:	e8 36 fe ff ff       	call   801024ac <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102676:	8b 45 08             	mov    0x8(%ebp),%eax
80102679:	8b 40 04             	mov    0x4(%eax),%eax
8010267c:	83 e0 01             	and    $0x1,%eax
8010267f:	c1 e0 04             	shl    $0x4,%eax
80102682:	89 c2                	mov    %eax,%edx
80102684:	8b 45 08             	mov    0x8(%ebp),%eax
80102687:	8b 40 08             	mov    0x8(%eax),%eax
8010268a:	c1 e8 18             	shr    $0x18,%eax
8010268d:	83 e0 0f             	and    $0xf,%eax
80102690:	09 d0                	or     %edx,%eax
80102692:	83 c8 e0             	or     $0xffffffe0,%eax
80102695:	0f b6 c0             	movzbl %al,%eax
80102698:	89 44 24 04          	mov    %eax,0x4(%esp)
8010269c:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026a3:	e8 04 fe ff ff       	call   801024ac <outb>
  if(b->flags & B_DIRTY){
801026a8:	8b 45 08             	mov    0x8(%ebp),%eax
801026ab:	8b 00                	mov    (%eax),%eax
801026ad:	83 e0 04             	and    $0x4,%eax
801026b0:	85 c0                	test   %eax,%eax
801026b2:	74 34                	je     801026e8 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026b4:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026bb:	00 
801026bc:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026c3:	e8 e4 fd ff ff       	call   801024ac <outb>
    outsl(0x1f0, b->data, 512/4);
801026c8:	8b 45 08             	mov    0x8(%ebp),%eax
801026cb:	83 c0 18             	add    $0x18,%eax
801026ce:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026d5:	00 
801026d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801026da:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026e1:	e8 e4 fd ff ff       	call   801024ca <outsl>
801026e6:	eb 14                	jmp    801026fc <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026e8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026ef:	00 
801026f0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026f7:	e8 b0 fd ff ff       	call   801024ac <outb>
  }
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    

801026fe <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026fe:	55                   	push   %ebp
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102704:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010270b:	e8 1c 2d 00 00       	call   8010542c <acquire>
  if((b = idequeue) == 0){
80102710:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102715:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010271c:	75 11                	jne    8010272f <ideintr+0x31>
    release(&idelock);
8010271e:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102725:	e8 ac 2d 00 00       	call   801054d6 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010272a:	e9 90 00 00 00       	jmp    801027bf <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102732:	8b 40 14             	mov    0x14(%eax),%eax
80102735:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273d:	8b 00                	mov    (%eax),%eax
8010273f:	83 e0 04             	and    $0x4,%eax
80102742:	85 c0                	test   %eax,%eax
80102744:	75 2e                	jne    80102774 <ideintr+0x76>
80102746:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010274d:	e8 9d fd ff ff       	call   801024ef <idewait>
80102752:	85 c0                	test   %eax,%eax
80102754:	78 1e                	js     80102774 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102759:	83 c0 18             	add    $0x18,%eax
8010275c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102763:	00 
80102764:	89 44 24 04          	mov    %eax,0x4(%esp)
80102768:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010276f:	e8 13 fd ff ff       	call   80102487 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102777:	8b 00                	mov    (%eax),%eax
80102779:	83 c8 02             	or     $0x2,%eax
8010277c:	89 c2                	mov    %eax,%edx
8010277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102781:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102786:	8b 00                	mov    (%eax),%eax
80102788:	83 e0 fb             	and    $0xfffffffb,%eax
8010278b:	89 c2                	mov    %eax,%edx
8010278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102790:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102795:	89 04 24             	mov    %eax,(%esp)
80102798:	e8 44 27 00 00       	call   80104ee1 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010279d:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027a2:	85 c0                	test   %eax,%eax
801027a4:	74 0d                	je     801027b3 <ideintr+0xb5>
    idestart(idequeue);
801027a6:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027ab:	89 04 24             	mov    %eax,(%esp)
801027ae:	e8 26 fe ff ff       	call   801025d9 <idestart>

  release(&idelock);
801027b3:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027ba:	e8 17 2d 00 00       	call   801054d6 <release>
}
801027bf:	c9                   	leave  
801027c0:	c3                   	ret    

801027c1 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027c1:	55                   	push   %ebp
801027c2:	89 e5                	mov    %esp,%ebp
801027c4:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027c7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ca:	8b 00                	mov    (%eax),%eax
801027cc:	83 e0 01             	and    $0x1,%eax
801027cf:	85 c0                	test   %eax,%eax
801027d1:	75 0c                	jne    801027df <iderw+0x1e>
    panic("iderw: buf not busy");
801027d3:	c7 04 24 39 8d 10 80 	movl   $0x80108d39,(%esp)
801027da:	e8 5b dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027df:	8b 45 08             	mov    0x8(%ebp),%eax
801027e2:	8b 00                	mov    (%eax),%eax
801027e4:	83 e0 06             	and    $0x6,%eax
801027e7:	83 f8 02             	cmp    $0x2,%eax
801027ea:	75 0c                	jne    801027f8 <iderw+0x37>
    panic("iderw: nothing to do");
801027ec:	c7 04 24 4d 8d 10 80 	movl   $0x80108d4d,(%esp)
801027f3:	e8 42 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027f8:	8b 45 08             	mov    0x8(%ebp),%eax
801027fb:	8b 40 04             	mov    0x4(%eax),%eax
801027fe:	85 c0                	test   %eax,%eax
80102800:	74 15                	je     80102817 <iderw+0x56>
80102802:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102807:	85 c0                	test   %eax,%eax
80102809:	75 0c                	jne    80102817 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010280b:	c7 04 24 62 8d 10 80 	movl   $0x80108d62,(%esp)
80102812:	e8 23 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102817:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010281e:	e8 09 2c 00 00       	call   8010542c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102823:	8b 45 08             	mov    0x8(%ebp),%eax
80102826:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010282d:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102834:	eb 0b                	jmp    80102841 <iderw+0x80>
80102836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102839:	8b 00                	mov    (%eax),%eax
8010283b:	83 c0 14             	add    $0x14,%eax
8010283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102844:	8b 00                	mov    (%eax),%eax
80102846:	85 c0                	test   %eax,%eax
80102848:	75 ec                	jne    80102836 <iderw+0x75>
    ;
  *pp = b;
8010284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284d:	8b 55 08             	mov    0x8(%ebp),%edx
80102850:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102852:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102857:	3b 45 08             	cmp    0x8(%ebp),%eax
8010285a:	75 0d                	jne    80102869 <iderw+0xa8>
    idestart(b);
8010285c:	8b 45 08             	mov    0x8(%ebp),%eax
8010285f:	89 04 24             	mov    %eax,(%esp)
80102862:	e8 72 fd ff ff       	call   801025d9 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102867:	eb 15                	jmp    8010287e <iderw+0xbd>
80102869:	eb 13                	jmp    8010287e <iderw+0xbd>
    sleep(b, &idelock);
8010286b:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102872:	80 
80102873:	8b 45 08             	mov    0x8(%ebp),%eax
80102876:	89 04 24             	mov    %eax,(%esp)
80102879:	e8 1f 25 00 00       	call   80104d9d <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010287e:	8b 45 08             	mov    0x8(%ebp),%eax
80102881:	8b 00                	mov    (%eax),%eax
80102883:	83 e0 06             	and    $0x6,%eax
80102886:	83 f8 02             	cmp    $0x2,%eax
80102889:	75 e0                	jne    8010286b <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010288b:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102892:	e8 3f 2c 00 00       	call   801054d6 <release>
}
80102897:	c9                   	leave  
80102898:	c3                   	ret    

80102899 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102899:	55                   	push   %ebp
8010289a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010289c:	a1 74 08 11 80       	mov    0x80110874,%eax
801028a1:	8b 55 08             	mov    0x8(%ebp),%edx
801028a4:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028a6:	a1 74 08 11 80       	mov    0x80110874,%eax
801028ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801028ae:	5d                   	pop    %ebp
801028af:	c3                   	ret    

801028b0 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028b3:	a1 74 08 11 80       	mov    0x80110874,%eax
801028b8:	8b 55 08             	mov    0x8(%ebp),%edx
801028bb:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028bd:	a1 74 08 11 80       	mov    0x80110874,%eax
801028c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801028c5:	89 50 10             	mov    %edx,0x10(%eax)
}
801028c8:	5d                   	pop    %ebp
801028c9:	c3                   	ret    

801028ca <ioapicinit>:

void
ioapicinit(void)
{
801028ca:	55                   	push   %ebp
801028cb:	89 e5                	mov    %esp,%ebp
801028cd:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028d0:	a1 44 09 11 80       	mov    0x80110944,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	75 05                	jne    801028de <ioapicinit+0x14>
    return;
801028d9:	e9 9d 00 00 00       	jmp    8010297b <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028de:	c7 05 74 08 11 80 00 	movl   $0xfec00000,0x80110874
801028e5:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028ef:	e8 a5 ff ff ff       	call   80102899 <ioapicread>
801028f4:	c1 e8 10             	shr    $0x10,%eax
801028f7:	25 ff 00 00 00       	and    $0xff,%eax
801028fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102906:	e8 8e ff ff ff       	call   80102899 <ioapicread>
8010290b:	c1 e8 18             	shr    $0x18,%eax
8010290e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102911:	0f b6 05 40 09 11 80 	movzbl 0x80110940,%eax
80102918:	0f b6 c0             	movzbl %al,%eax
8010291b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010291e:	74 0c                	je     8010292c <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102920:	c7 04 24 80 8d 10 80 	movl   $0x80108d80,(%esp)
80102927:	e8 74 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010292c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102933:	eb 3e                	jmp    80102973 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102938:	83 c0 20             	add    $0x20,%eax
8010293b:	0d 00 00 01 00       	or     $0x10000,%eax
80102940:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102943:	83 c2 08             	add    $0x8,%edx
80102946:	01 d2                	add    %edx,%edx
80102948:	89 44 24 04          	mov    %eax,0x4(%esp)
8010294c:	89 14 24             	mov    %edx,(%esp)
8010294f:	e8 5c ff ff ff       	call   801028b0 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102957:	83 c0 08             	add    $0x8,%eax
8010295a:	01 c0                	add    %eax,%eax
8010295c:	83 c0 01             	add    $0x1,%eax
8010295f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102966:	00 
80102967:	89 04 24             	mov    %eax,(%esp)
8010296a:	e8 41 ff ff ff       	call   801028b0 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010296f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102979:	7e ba                	jle    80102935 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010297b:	c9                   	leave  
8010297c:	c3                   	ret    

8010297d <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010297d:	55                   	push   %ebp
8010297e:	89 e5                	mov    %esp,%ebp
80102980:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102983:	a1 44 09 11 80       	mov    0x80110944,%eax
80102988:	85 c0                	test   %eax,%eax
8010298a:	75 02                	jne    8010298e <ioapicenable+0x11>
    return;
8010298c:	eb 37                	jmp    801029c5 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010298e:	8b 45 08             	mov    0x8(%ebp),%eax
80102991:	83 c0 20             	add    $0x20,%eax
80102994:	8b 55 08             	mov    0x8(%ebp),%edx
80102997:	83 c2 08             	add    $0x8,%edx
8010299a:	01 d2                	add    %edx,%edx
8010299c:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a0:	89 14 24             	mov    %edx,(%esp)
801029a3:	e8 08 ff ff ff       	call   801028b0 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ab:	c1 e0 18             	shl    $0x18,%eax
801029ae:	8b 55 08             	mov    0x8(%ebp),%edx
801029b1:	83 c2 08             	add    $0x8,%edx
801029b4:	01 d2                	add    %edx,%edx
801029b6:	83 c2 01             	add    $0x1,%edx
801029b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801029bd:	89 14 24             	mov    %edx,(%esp)
801029c0:	e8 eb fe ff ff       	call   801028b0 <ioapicwrite>
}
801029c5:	c9                   	leave  
801029c6:	c3                   	ret    

801029c7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029c7:	55                   	push   %ebp
801029c8:	89 e5                	mov    %esp,%ebp
801029ca:	8b 45 08             	mov    0x8(%ebp),%eax
801029cd:	05 00 00 00 80       	add    $0x80000000,%eax
801029d2:	5d                   	pop    %ebp
801029d3:	c3                   	ret    

801029d4 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029d4:	55                   	push   %ebp
801029d5:	89 e5                	mov    %esp,%ebp
801029d7:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029da:	c7 44 24 04 b2 8d 10 	movl   $0x80108db2,0x4(%esp)
801029e1:	80 
801029e2:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029e9:	e8 1d 2a 00 00       	call   8010540b <initlock>
  kmem.use_lock = 0;
801029ee:	c7 05 b4 08 11 80 00 	movl   $0x0,0x801108b4
801029f5:	00 00 00 
  freerange(vstart, vend);
801029f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102a02:	89 04 24             	mov    %eax,(%esp)
80102a05:	e8 26 00 00 00       	call   80102a30 <freerange>
}
80102a0a:	c9                   	leave  
80102a0b:	c3                   	ret    

80102a0c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a0c:	55                   	push   %ebp
80102a0d:	89 e5                	mov    %esp,%ebp
80102a0f:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a12:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a19:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1c:	89 04 24             	mov    %eax,(%esp)
80102a1f:	e8 0c 00 00 00       	call   80102a30 <freerange>
  kmem.use_lock = 1;
80102a24:	c7 05 b4 08 11 80 01 	movl   $0x1,0x801108b4
80102a2b:	00 00 00 
}
80102a2e:	c9                   	leave  
80102a2f:	c3                   	ret    

80102a30 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a36:	8b 45 08             	mov    0x8(%ebp),%eax
80102a39:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a46:	eb 12                	jmp    80102a5a <freerange+0x2a>
    kfree(p);
80102a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4b:	89 04 24             	mov    %eax,(%esp)
80102a4e:	e8 16 00 00 00       	call   80102a69 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a53:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5d:	05 00 10 00 00       	add    $0x1000,%eax
80102a62:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a65:	76 e1                	jbe    80102a48 <freerange+0x18>
    kfree(p);
}
80102a67:	c9                   	leave  
80102a68:	c3                   	ret    

80102a69 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a69:	55                   	push   %ebp
80102a6a:	89 e5                	mov    %esp,%ebp
80102a6c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a72:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a77:	85 c0                	test   %eax,%eax
80102a79:	75 1b                	jne    80102a96 <kfree+0x2d>
80102a7b:	81 7d 08 3c 39 11 80 	cmpl   $0x8011393c,0x8(%ebp)
80102a82:	72 12                	jb     80102a96 <kfree+0x2d>
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
80102a87:	89 04 24             	mov    %eax,(%esp)
80102a8a:	e8 38 ff ff ff       	call   801029c7 <v2p>
80102a8f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a94:	76 0c                	jbe    80102aa2 <kfree+0x39>
    panic("kfree");
80102a96:	c7 04 24 b7 8d 10 80 	movl   $0x80108db7,(%esp)
80102a9d:	e8 98 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102aa2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aa9:	00 
80102aaa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ab1:	00 
80102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab5:	89 04 24             	mov    %eax,(%esp)
80102ab8:	e8 53 2c 00 00       	call   80105710 <memset>

  if(kmem.use_lock)
80102abd:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102ac2:	85 c0                	test   %eax,%eax
80102ac4:	74 0c                	je     80102ad2 <kfree+0x69>
    acquire(&kmem.lock);
80102ac6:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102acd:	e8 5a 29 00 00       	call   8010542c <acquire>
  r = (struct run*)v;
80102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ad8:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae1:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae6:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102aeb:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102af0:	85 c0                	test   %eax,%eax
80102af2:	74 0c                	je     80102b00 <kfree+0x97>
    release(&kmem.lock);
80102af4:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102afb:	e8 d6 29 00 00       	call   801054d6 <release>
}
80102b00:	c9                   	leave  
80102b01:	c3                   	ret    

80102b02 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b02:	55                   	push   %ebp
80102b03:	89 e5                	mov    %esp,%ebp
80102b05:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b08:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b0d:	85 c0                	test   %eax,%eax
80102b0f:	74 0c                	je     80102b1d <kalloc+0x1b>
    acquire(&kmem.lock);
80102b11:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b18:	e8 0f 29 00 00       	call   8010542c <acquire>
  r = kmem.freelist;
80102b1d:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b29:	74 0a                	je     80102b35 <kalloc+0x33>
    kmem.freelist = r->next;
80102b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2e:	8b 00                	mov    (%eax),%eax
80102b30:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102b35:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b3a:	85 c0                	test   %eax,%eax
80102b3c:	74 0c                	je     80102b4a <kalloc+0x48>
    release(&kmem.lock);
80102b3e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b45:	e8 8c 29 00 00       	call   801054d6 <release>
  return (char*)r;
80102b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b4d:	c9                   	leave  
80102b4e:	c3                   	ret    

80102b4f <kalloc2>:
////////////////////////////////////////////////////////
void*
kalloc2(void)
{
80102b4f:	55                   	push   %ebp
80102b50:	89 e5                	mov    %esp,%ebp
80102b52:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b55:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b5a:	85 c0                	test   %eax,%eax
80102b5c:	74 0c                	je     80102b6a <kalloc2+0x1b>
    acquire(&kmem.lock);
80102b5e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b65:	e8 c2 28 00 00       	call   8010542c <acquire>
  r = kmem.freelist;
80102b6a:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b76:	74 0a                	je     80102b82 <kalloc2+0x33>
    kmem.freelist = r->next;
80102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7b:	8b 00                	mov    (%eax),%eax
80102b7d:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102b82:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b87:	85 c0                	test   %eax,%eax
80102b89:	74 0c                	je     80102b97 <kalloc2+0x48>
    release(&kmem.lock);
80102b8b:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b92:	e8 3f 29 00 00       	call   801054d6 <release>
  return (char*)r;
80102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b9a:	c9                   	leave  
80102b9b:	c3                   	ret    

80102b9c <kfree2>:

void
kfree2(void *v)
{
80102b9c:	55                   	push   %ebp
80102b9d:	89 e5                	mov    %esp,%ebp
80102b9f:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || (char*)v < end || v2p(v) >= PHYSTOP)
80102ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba5:	25 ff 0f 00 00       	and    $0xfff,%eax
80102baa:	85 c0                	test   %eax,%eax
80102bac:	75 1b                	jne    80102bc9 <kfree2+0x2d>
80102bae:	81 7d 08 3c 39 11 80 	cmpl   $0x8011393c,0x8(%ebp)
80102bb5:	72 12                	jb     80102bc9 <kfree2+0x2d>
80102bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80102bba:	89 04 24             	mov    %eax,(%esp)
80102bbd:	e8 05 fe ff ff       	call   801029c7 <v2p>
80102bc2:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bc7:	76 0c                	jbe    80102bd5 <kfree2+0x39>
    panic("kfree");
80102bc9:	c7 04 24 b7 8d 10 80 	movl   $0x80108db7,(%esp)
80102bd0:	e8 65 d9 ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bd5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102bdc:	00 
80102bdd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102be4:	00 
80102be5:	8b 45 08             	mov    0x8(%ebp),%eax
80102be8:	89 04 24             	mov    %eax,(%esp)
80102beb:	e8 20 2b 00 00       	call   80105710 <memset>

  if(kmem.use_lock)
80102bf0:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	74 0c                	je     80102c05 <kfree2+0x69>
    acquire(&kmem.lock);
80102bf9:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102c00:	e8 27 28 00 00       	call   8010542c <acquire>
  r = (struct run*)v;
80102c05:	8b 45 08             	mov    0x8(%ebp),%eax
80102c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c0b:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c14:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c19:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102c1e:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102c23:	85 c0                	test   %eax,%eax
80102c25:	74 0c                	je     80102c33 <kfree2+0x97>
    release(&kmem.lock);
80102c27:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102c2e:	e8 a3 28 00 00       	call   801054d6 <release>
80102c33:	c9                   	leave  
80102c34:	c3                   	ret    

80102c35 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c35:	55                   	push   %ebp
80102c36:	89 e5                	mov    %esp,%ebp
80102c38:	83 ec 14             	sub    $0x14,%esp
80102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c3e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c42:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c46:	89 c2                	mov    %eax,%edx
80102c48:	ec                   	in     (%dx),%al
80102c49:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c4c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c50:	c9                   	leave  
80102c51:	c3                   	ret    

80102c52 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c52:	55                   	push   %ebp
80102c53:	89 e5                	mov    %esp,%ebp
80102c55:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c58:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c5f:	e8 d1 ff ff ff       	call   80102c35 <inb>
80102c64:	0f b6 c0             	movzbl %al,%eax
80102c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	83 e0 01             	and    $0x1,%eax
80102c70:	85 c0                	test   %eax,%eax
80102c72:	75 0a                	jne    80102c7e <kbdgetc+0x2c>
    return -1;
80102c74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c79:	e9 25 01 00 00       	jmp    80102da3 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c7e:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c85:	e8 ab ff ff ff       	call   80102c35 <inb>
80102c8a:	0f b6 c0             	movzbl %al,%eax
80102c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c90:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c97:	75 17                	jne    80102cb0 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c99:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c9e:	83 c8 40             	or     $0x40,%eax
80102ca1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ca6:	b8 00 00 00 00       	mov    $0x0,%eax
80102cab:	e9 f3 00 00 00       	jmp    80102da3 <kbdgetc+0x151>
  } else if(data & 0x80){
80102cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb3:	25 80 00 00 00       	and    $0x80,%eax
80102cb8:	85 c0                	test   %eax,%eax
80102cba:	74 45                	je     80102d01 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cbc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cc1:	83 e0 40             	and    $0x40,%eax
80102cc4:	85 c0                	test   %eax,%eax
80102cc6:	75 08                	jne    80102cd0 <kbdgetc+0x7e>
80102cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ccb:	83 e0 7f             	and    $0x7f,%eax
80102cce:	eb 03                	jmp    80102cd3 <kbdgetc+0x81>
80102cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd9:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102cde:	0f b6 00             	movzbl (%eax),%eax
80102ce1:	83 c8 40             	or     $0x40,%eax
80102ce4:	0f b6 c0             	movzbl %al,%eax
80102ce7:	f7 d0                	not    %eax
80102ce9:	89 c2                	mov    %eax,%edx
80102ceb:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cf0:	21 d0                	and    %edx,%eax
80102cf2:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102cf7:	b8 00 00 00 00       	mov    $0x0,%eax
80102cfc:	e9 a2 00 00 00       	jmp    80102da3 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102d01:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d06:	83 e0 40             	and    $0x40,%eax
80102d09:	85 c0                	test   %eax,%eax
80102d0b:	74 14                	je     80102d21 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d0d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d14:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d19:	83 e0 bf             	and    $0xffffffbf,%eax
80102d1c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d24:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d29:	0f b6 00             	movzbl (%eax),%eax
80102d2c:	0f b6 d0             	movzbl %al,%edx
80102d2f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d34:	09 d0                	or     %edx,%eax
80102d36:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d3e:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d43:	0f b6 00             	movzbl (%eax),%eax
80102d46:	0f b6 d0             	movzbl %al,%edx
80102d49:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d4e:	31 d0                	xor    %edx,%eax
80102d50:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d55:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d5a:	83 e0 03             	and    $0x3,%eax
80102d5d:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d67:	01 d0                	add    %edx,%eax
80102d69:	0f b6 00             	movzbl (%eax),%eax
80102d6c:	0f b6 c0             	movzbl %al,%eax
80102d6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d72:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d77:	83 e0 08             	and    $0x8,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	74 22                	je     80102da0 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d7e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d82:	76 0c                	jbe    80102d90 <kbdgetc+0x13e>
80102d84:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d88:	77 06                	ja     80102d90 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d8a:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d8e:	eb 10                	jmp    80102da0 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d90:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d94:	76 0a                	jbe    80102da0 <kbdgetc+0x14e>
80102d96:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d9a:	77 04                	ja     80102da0 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d9c:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102da3:	c9                   	leave  
80102da4:	c3                   	ret    

80102da5 <kbdintr>:

void
kbdintr(void)
{
80102da5:	55                   	push   %ebp
80102da6:	89 e5                	mov    %esp,%ebp
80102da8:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102dab:	c7 04 24 52 2c 10 80 	movl   $0x80102c52,(%esp)
80102db2:	e8 f6 d9 ff ff       	call   801007ad <consoleintr>
}
80102db7:	c9                   	leave  
80102db8:	c3                   	ret    

80102db9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102db9:	55                   	push   %ebp
80102dba:	89 e5                	mov    %esp,%ebp
80102dbc:	83 ec 08             	sub    $0x8,%esp
80102dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dc9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd4:	ee                   	out    %al,(%dx)
}
80102dd5:	c9                   	leave  
80102dd6:	c3                   	ret    

80102dd7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102dd7:	55                   	push   %ebp
80102dd8:	89 e5                	mov    %esp,%ebp
80102dda:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ddd:	9c                   	pushf  
80102dde:	58                   	pop    %eax
80102ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de5:	c9                   	leave  
80102de6:	c3                   	ret    

80102de7 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102de7:	55                   	push   %ebp
80102de8:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dea:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102def:	8b 55 08             	mov    0x8(%ebp),%edx
80102df2:	c1 e2 02             	shl    $0x2,%edx
80102df5:	01 c2                	add    %eax,%edx
80102df7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfa:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dfc:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e01:	83 c0 20             	add    $0x20,%eax
80102e04:	8b 00                	mov    (%eax),%eax
}
80102e06:	5d                   	pop    %ebp
80102e07:	c3                   	ret    

80102e08 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e08:	55                   	push   %ebp
80102e09:	89 e5                	mov    %esp,%ebp
80102e0b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102e0e:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e13:	85 c0                	test   %eax,%eax
80102e15:	75 05                	jne    80102e1c <lapicinit+0x14>
    return;
80102e17:	e9 43 01 00 00       	jmp    80102f5f <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e1c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e23:	00 
80102e24:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e2b:	e8 b7 ff ff ff       	call   80102de7 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e30:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e37:	00 
80102e38:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e3f:	e8 a3 ff ff ff       	call   80102de7 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e44:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e4b:	00 
80102e4c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e53:	e8 8f ff ff ff       	call   80102de7 <lapicw>
  lapicw(TICR, 10000000); 
80102e58:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e5f:	00 
80102e60:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e67:	e8 7b ff ff ff       	call   80102de7 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e6c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e73:	00 
80102e74:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e7b:	e8 67 ff ff ff       	call   80102de7 <lapicw>
  lapicw(LINT1, MASKED);
80102e80:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e87:	00 
80102e88:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e8f:	e8 53 ff ff ff       	call   80102de7 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e94:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e99:	83 c0 30             	add    $0x30,%eax
80102e9c:	8b 00                	mov    (%eax),%eax
80102e9e:	c1 e8 10             	shr    $0x10,%eax
80102ea1:	0f b6 c0             	movzbl %al,%eax
80102ea4:	83 f8 03             	cmp    $0x3,%eax
80102ea7:	76 14                	jbe    80102ebd <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102ea9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eb0:	00 
80102eb1:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102eb8:	e8 2a ff ff ff       	call   80102de7 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ebd:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ec4:	00 
80102ec5:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ecc:	e8 16 ff ff ff       	call   80102de7 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ed1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ed8:	00 
80102ed9:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ee0:	e8 02 ff ff ff       	call   80102de7 <lapicw>
  lapicw(ESR, 0);
80102ee5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eec:	00 
80102eed:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ef4:	e8 ee fe ff ff       	call   80102de7 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ef9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f00:	00 
80102f01:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f08:	e8 da fe ff ff       	call   80102de7 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f14:	00 
80102f15:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f1c:	e8 c6 fe ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f21:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f28:	00 
80102f29:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f30:	e8 b2 fe ff ff       	call   80102de7 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f35:	90                   	nop
80102f36:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102f3b:	05 00 03 00 00       	add    $0x300,%eax
80102f40:	8b 00                	mov    (%eax),%eax
80102f42:	25 00 10 00 00       	and    $0x1000,%eax
80102f47:	85 c0                	test   %eax,%eax
80102f49:	75 eb                	jne    80102f36 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f52:	00 
80102f53:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f5a:	e8 88 fe ff ff       	call   80102de7 <lapicw>
}
80102f5f:	c9                   	leave  
80102f60:	c3                   	ret    

80102f61 <cpunum>:

int
cpunum(void)
{
80102f61:	55                   	push   %ebp
80102f62:	89 e5                	mov    %esp,%ebp
80102f64:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f67:	e8 6b fe ff ff       	call   80102dd7 <readeflags>
80102f6c:	25 00 02 00 00       	and    $0x200,%eax
80102f71:	85 c0                	test   %eax,%eax
80102f73:	74 25                	je     80102f9a <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102f75:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f7a:	8d 50 01             	lea    0x1(%eax),%edx
80102f7d:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f83:	85 c0                	test   %eax,%eax
80102f85:	75 13                	jne    80102f9a <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f87:	8b 45 04             	mov    0x4(%ebp),%eax
80102f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f8e:	c7 04 24 c0 8d 10 80 	movl   $0x80108dc0,(%esp)
80102f95:	e8 06 d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f9a:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	74 0f                	je     80102fb2 <cpunum+0x51>
    return lapic[ID]>>24;
80102fa3:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102fa8:	83 c0 20             	add    $0x20,%eax
80102fab:	8b 00                	mov    (%eax),%eax
80102fad:	c1 e8 18             	shr    $0x18,%eax
80102fb0:	eb 05                	jmp    80102fb7 <cpunum+0x56>
  return 0;
80102fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fb7:	c9                   	leave  
80102fb8:	c3                   	ret    

80102fb9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fb9:	55                   	push   %ebp
80102fba:	89 e5                	mov    %esp,%ebp
80102fbc:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102fbf:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102fc4:	85 c0                	test   %eax,%eax
80102fc6:	74 14                	je     80102fdc <lapiceoi+0x23>
    lapicw(EOI, 0);
80102fc8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fcf:	00 
80102fd0:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fd7:	e8 0b fe ff ff       	call   80102de7 <lapicw>
}
80102fdc:	c9                   	leave  
80102fdd:	c3                   	ret    

80102fde <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fde:	55                   	push   %ebp
80102fdf:	89 e5                	mov    %esp,%ebp
}
80102fe1:	5d                   	pop    %ebp
80102fe2:	c3                   	ret    

80102fe3 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fe3:	55                   	push   %ebp
80102fe4:	89 e5                	mov    %esp,%ebp
80102fe6:	83 ec 1c             	sub    $0x1c,%esp
80102fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80102fec:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102fef:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ff6:	00 
80102ff7:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102ffe:	e8 b6 fd ff ff       	call   80102db9 <outb>
  outb(IO_RTC+1, 0x0A);
80103003:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010300a:	00 
8010300b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103012:	e8 a2 fd ff ff       	call   80102db9 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103017:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010301e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103021:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103026:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103029:	8d 50 02             	lea    0x2(%eax),%edx
8010302c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010302f:	c1 e8 04             	shr    $0x4,%eax
80103032:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103035:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103039:	c1 e0 18             	shl    $0x18,%eax
8010303c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103040:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103047:	e8 9b fd ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010304c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103053:	00 
80103054:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010305b:	e8 87 fd ff ff       	call   80102de7 <lapicw>
  microdelay(200);
80103060:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103067:	e8 72 ff ff ff       	call   80102fde <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010306c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103073:	00 
80103074:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010307b:	e8 67 fd ff ff       	call   80102de7 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103080:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103087:	e8 52 ff ff ff       	call   80102fde <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010308c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103093:	eb 40                	jmp    801030d5 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103095:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103099:	c1 e0 18             	shl    $0x18,%eax
8010309c:	89 44 24 04          	mov    %eax,0x4(%esp)
801030a0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030a7:	e8 3b fd ff ff       	call   80102de7 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801030af:	c1 e8 0c             	shr    $0xc,%eax
801030b2:	80 cc 06             	or     $0x6,%ah
801030b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801030b9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030c0:	e8 22 fd ff ff       	call   80102de7 <lapicw>
    microdelay(200);
801030c5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030cc:	e8 0d ff ff ff       	call   80102fde <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030d5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030d9:	7e ba                	jle    80103095 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030db:	c9                   	leave  
801030dc:	c3                   	ret    

801030dd <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
801030dd:	55                   	push   %ebp
801030de:	89 e5                	mov    %esp,%ebp
801030e0:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801030e3:	c7 44 24 04 ec 8d 10 	movl   $0x80108dec,0x4(%esp)
801030ea:	80 
801030eb:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801030f2:	e8 14 23 00 00       	call   8010540b <initlock>
  readsb(ROOTDEV, &sb);
801030f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801030fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801030fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103105:	e8 07 e2 ff ff       	call   80101311 <readsb>
  log.start = sb.size - sb.nlog;
8010310a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103110:	29 c2                	sub    %eax,%edx
80103112:	89 d0                	mov    %edx,%eax
80103114:	a3 f4 08 11 80       	mov    %eax,0x801108f4
  log.size = sb.nlog;
80103119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010311c:	a3 f8 08 11 80       	mov    %eax,0x801108f8
  log.dev = ROOTDEV;
80103121:	c7 05 00 09 11 80 01 	movl   $0x1,0x80110900
80103128:	00 00 00 
  recover_from_log();
8010312b:	e8 9a 01 00 00       	call   801032ca <recover_from_log>
}
80103130:	c9                   	leave  
80103131:	c3                   	ret    

80103132 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103132:	55                   	push   %ebp
80103133:	89 e5                	mov    %esp,%ebp
80103135:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103138:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010313f:	e9 8c 00 00 00       	jmp    801031d0 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103144:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
8010314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010314d:	01 d0                	add    %edx,%eax
8010314f:	83 c0 01             	add    $0x1,%eax
80103152:	89 c2                	mov    %eax,%edx
80103154:	a1 00 09 11 80       	mov    0x80110900,%eax
80103159:	89 54 24 04          	mov    %edx,0x4(%esp)
8010315d:	89 04 24             	mov    %eax,(%esp)
80103160:	e8 41 d0 ff ff       	call   801001a6 <bread>
80103165:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010316b:	83 c0 10             	add    $0x10,%eax
8010316e:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
80103175:	89 c2                	mov    %eax,%edx
80103177:	a1 00 09 11 80       	mov    0x80110900,%eax
8010317c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103180:	89 04 24             	mov    %eax,(%esp)
80103183:	e8 1e d0 ff ff       	call   801001a6 <bread>
80103188:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010318e:	8d 50 18             	lea    0x18(%eax),%edx
80103191:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103194:	83 c0 18             	add    $0x18,%eax
80103197:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010319e:	00 
8010319f:	89 54 24 04          	mov    %edx,0x4(%esp)
801031a3:	89 04 24             	mov    %eax,(%esp)
801031a6:	e8 34 26 00 00       	call   801057df <memmove>
    bwrite(dbuf);  // write dst to disk
801031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ae:	89 04 24             	mov    %eax,(%esp)
801031b1:	e8 27 d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031b9:	89 04 24             	mov    %eax,(%esp)
801031bc:	e8 56 d0 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c4:	89 04 24             	mov    %eax,(%esp)
801031c7:	e8 4b d0 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031d0:	a1 04 09 11 80       	mov    0x80110904,%eax
801031d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031d8:	0f 8f 66 ff ff ff    	jg     80103144 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801031de:	c9                   	leave  
801031df:	c3                   	ret    

801031e0 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031e6:	a1 f4 08 11 80       	mov    0x801108f4,%eax
801031eb:	89 c2                	mov    %eax,%edx
801031ed:	a1 00 09 11 80       	mov    0x80110900,%eax
801031f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801031f6:	89 04 24             	mov    %eax,(%esp)
801031f9:	e8 a8 cf ff ff       	call   801001a6 <bread>
801031fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103201:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103204:	83 c0 18             	add    $0x18,%eax
80103207:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010320a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010320d:	8b 00                	mov    (%eax),%eax
8010320f:	a3 04 09 11 80       	mov    %eax,0x80110904
  for (i = 0; i < log.lh.n; i++) {
80103214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010321b:	eb 1b                	jmp    80103238 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010321d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103220:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103223:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103227:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010322a:	83 c2 10             	add    $0x10,%edx
8010322d:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103234:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103238:	a1 04 09 11 80       	mov    0x80110904,%eax
8010323d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103240:	7f db                	jg     8010321d <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103242:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103245:	89 04 24             	mov    %eax,(%esp)
80103248:	e8 ca cf ff ff       	call   80100217 <brelse>
}
8010324d:	c9                   	leave  
8010324e:	c3                   	ret    

8010324f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010324f:	55                   	push   %ebp
80103250:	89 e5                	mov    %esp,%ebp
80103252:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103255:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010325a:	89 c2                	mov    %eax,%edx
8010325c:	a1 00 09 11 80       	mov    0x80110900,%eax
80103261:	89 54 24 04          	mov    %edx,0x4(%esp)
80103265:	89 04 24             	mov    %eax,(%esp)
80103268:	e8 39 cf ff ff       	call   801001a6 <bread>
8010326d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103273:	83 c0 18             	add    $0x18,%eax
80103276:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103279:	8b 15 04 09 11 80    	mov    0x80110904,%edx
8010327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103282:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010328b:	eb 1b                	jmp    801032a8 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
8010328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103290:	83 c0 10             	add    $0x10,%eax
80103293:	8b 0c 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%ecx
8010329a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010329d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032a0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032a8:	a1 04 09 11 80       	mov    0x80110904,%eax
801032ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032b0:	7f db                	jg     8010328d <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801032b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032b5:	89 04 24             	mov    %eax,(%esp)
801032b8:	e8 20 cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
801032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032c0:	89 04 24             	mov    %eax,(%esp)
801032c3:	e8 4f cf ff ff       	call   80100217 <brelse>
}
801032c8:	c9                   	leave  
801032c9:	c3                   	ret    

801032ca <recover_from_log>:

static void
recover_from_log(void)
{
801032ca:	55                   	push   %ebp
801032cb:	89 e5                	mov    %esp,%ebp
801032cd:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801032d0:	e8 0b ff ff ff       	call   801031e0 <read_head>
  install_trans(); // if committed, copy from log to disk
801032d5:	e8 58 fe ff ff       	call   80103132 <install_trans>
  log.lh.n = 0;
801032da:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
801032e1:	00 00 00 
  write_head(); // clear the log
801032e4:	e8 66 ff ff ff       	call   8010324f <write_head>
}
801032e9:	c9                   	leave  
801032ea:	c3                   	ret    

801032eb <begin_trans>:

void
begin_trans(void)
{
801032eb:	55                   	push   %ebp
801032ec:	89 e5                	mov    %esp,%ebp
801032ee:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801032f1:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801032f8:	e8 2f 21 00 00       	call   8010542c <acquire>
  while (log.busy) {
801032fd:	eb 14                	jmp    80103313 <begin_trans+0x28>
    sleep(&log, &log.lock);
801032ff:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
80103306:	80 
80103307:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010330e:	e8 8a 1a 00 00       	call   80104d9d <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103313:	a1 fc 08 11 80       	mov    0x801108fc,%eax
80103318:	85 c0                	test   %eax,%eax
8010331a:	75 e3                	jne    801032ff <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010331c:	c7 05 fc 08 11 80 01 	movl   $0x1,0x801108fc
80103323:	00 00 00 
  release(&log.lock);
80103326:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010332d:	e8 a4 21 00 00       	call   801054d6 <release>
}
80103332:	c9                   	leave  
80103333:	c3                   	ret    

80103334 <commit_trans>:

void
commit_trans(void)
{
80103334:	55                   	push   %ebp
80103335:	89 e5                	mov    %esp,%ebp
80103337:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010333a:	a1 04 09 11 80       	mov    0x80110904,%eax
8010333f:	85 c0                	test   %eax,%eax
80103341:	7e 19                	jle    8010335c <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103343:	e8 07 ff ff ff       	call   8010324f <write_head>
    install_trans(); // Now install writes to home locations
80103348:	e8 e5 fd ff ff       	call   80103132 <install_trans>
    log.lh.n = 0; 
8010334d:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103354:	00 00 00 
    write_head();    // Erase the transaction from the log
80103357:	e8 f3 fe ff ff       	call   8010324f <write_head>
  }
  
  acquire(&log.lock);
8010335c:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103363:	e8 c4 20 00 00       	call   8010542c <acquire>
  log.busy = 0;
80103368:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
8010336f:	00 00 00 
  wakeup(&log);
80103372:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103379:	e8 63 1b 00 00       	call   80104ee1 <wakeup>
  release(&log.lock);
8010337e:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103385:	e8 4c 21 00 00       	call   801054d6 <release>
}
8010338a:	c9                   	leave  
8010338b:	c3                   	ret    

8010338c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010338c:	55                   	push   %ebp
8010338d:	89 e5                	mov    %esp,%ebp
8010338f:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103392:	a1 04 09 11 80       	mov    0x80110904,%eax
80103397:	83 f8 09             	cmp    $0x9,%eax
8010339a:	7f 12                	jg     801033ae <log_write+0x22>
8010339c:	a1 04 09 11 80       	mov    0x80110904,%eax
801033a1:	8b 15 f8 08 11 80    	mov    0x801108f8,%edx
801033a7:	83 ea 01             	sub    $0x1,%edx
801033aa:	39 d0                	cmp    %edx,%eax
801033ac:	7c 0c                	jl     801033ba <log_write+0x2e>
    panic("too big a transaction");
801033ae:	c7 04 24 f0 8d 10 80 	movl   $0x80108df0,(%esp)
801033b5:	e8 80 d1 ff ff       	call   8010053a <panic>
  if (!log.busy)
801033ba:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801033bf:	85 c0                	test   %eax,%eax
801033c1:	75 0c                	jne    801033cf <log_write+0x43>
    panic("write outside of trans");
801033c3:	c7 04 24 06 8e 10 80 	movl   $0x80108e06,(%esp)
801033ca:	e8 6b d1 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801033cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d6:	eb 1f                	jmp    801033f7 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033db:	83 c0 10             	add    $0x10,%eax
801033de:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
801033e5:	89 c2                	mov    %eax,%edx
801033e7:	8b 45 08             	mov    0x8(%ebp),%eax
801033ea:	8b 40 08             	mov    0x8(%eax),%eax
801033ed:	39 c2                	cmp    %eax,%edx
801033ef:	75 02                	jne    801033f3 <log_write+0x67>
      break;
801033f1:	eb 0e                	jmp    80103401 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801033f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f7:	a1 04 09 11 80       	mov    0x80110904,%eax
801033fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033ff:	7f d7                	jg     801033d8 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
80103401:	8b 45 08             	mov    0x8(%ebp),%eax
80103404:	8b 40 08             	mov    0x8(%eax),%eax
80103407:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010340a:	83 c2 10             	add    $0x10,%edx
8010340d:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103414:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
8010341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010341d:	01 d0                	add    %edx,%eax
8010341f:	83 c0 01             	add    $0x1,%eax
80103422:	89 c2                	mov    %eax,%edx
80103424:	8b 45 08             	mov    0x8(%ebp),%eax
80103427:	8b 40 04             	mov    0x4(%eax),%eax
8010342a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010342e:	89 04 24             	mov    %eax,(%esp)
80103431:	e8 70 cd ff ff       	call   801001a6 <bread>
80103436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103439:	8b 45 08             	mov    0x8(%ebp),%eax
8010343c:	8d 50 18             	lea    0x18(%eax),%edx
8010343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103442:	83 c0 18             	add    $0x18,%eax
80103445:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010344c:	00 
8010344d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103451:	89 04 24             	mov    %eax,(%esp)
80103454:	e8 86 23 00 00       	call   801057df <memmove>
  bwrite(lbuf);
80103459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010345c:	89 04 24             	mov    %eax,(%esp)
8010345f:	e8 79 cd ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103464:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103467:	89 04 24             	mov    %eax,(%esp)
8010346a:	e8 a8 cd ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010346f:	a1 04 09 11 80       	mov    0x80110904,%eax
80103474:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103477:	75 0d                	jne    80103486 <log_write+0xfa>
    log.lh.n++;
80103479:	a1 04 09 11 80       	mov    0x80110904,%eax
8010347e:	83 c0 01             	add    $0x1,%eax
80103481:	a3 04 09 11 80       	mov    %eax,0x80110904
  b->flags |= B_DIRTY; // XXX prevent eviction
80103486:	8b 45 08             	mov    0x8(%ebp),%eax
80103489:	8b 00                	mov    (%eax),%eax
8010348b:	83 c8 04             	or     $0x4,%eax
8010348e:	89 c2                	mov    %eax,%edx
80103490:	8b 45 08             	mov    0x8(%ebp),%eax
80103493:	89 10                	mov    %edx,(%eax)
}
80103495:	c9                   	leave  
80103496:	c3                   	ret    

80103497 <v2p>:
80103497:	55                   	push   %ebp
80103498:	89 e5                	mov    %esp,%ebp
8010349a:	8b 45 08             	mov    0x8(%ebp),%eax
8010349d:	05 00 00 00 80       	add    $0x80000000,%eax
801034a2:	5d                   	pop    %ebp
801034a3:	c3                   	ret    

801034a4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801034a4:	55                   	push   %ebp
801034a5:	89 e5                	mov    %esp,%ebp
801034a7:	8b 45 08             	mov    0x8(%ebp),%eax
801034aa:	05 00 00 00 80       	add    $0x80000000,%eax
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    

801034b1 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801034b1:	55                   	push   %ebp
801034b2:	89 e5                	mov    %esp,%ebp
801034b4:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034b7:	8b 55 08             	mov    0x8(%ebp),%edx
801034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801034bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801034c0:	f0 87 02             	lock xchg %eax,(%edx)
801034c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801034c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801034c9:	c9                   	leave  
801034ca:	c3                   	ret    

801034cb <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801034cb:	55                   	push   %ebp
801034cc:	89 e5                	mov    %esp,%ebp
801034ce:	83 e4 f0             	and    $0xfffffff0,%esp
801034d1:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034d4:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801034db:	80 
801034dc:	c7 04 24 3c 39 11 80 	movl   $0x8011393c,(%esp)
801034e3:	e8 ec f4 ff ff       	call   801029d4 <kinit1>
  kvmalloc();      // kernel page table
801034e8:	e8 48 4f 00 00       	call   80108435 <kvmalloc>
  mpinit();        // collect info about this machine
801034ed:	e8 46 04 00 00       	call   80103938 <mpinit>
  lapicinit();
801034f2:	e8 11 f9 ff ff       	call   80102e08 <lapicinit>
  seginit();       // set up segments
801034f7:	e8 cc 48 00 00       	call   80107dc8 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801034fc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103502:	0f b6 00             	movzbl (%eax),%eax
80103505:	0f b6 c0             	movzbl %al,%eax
80103508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010350c:	c7 04 24 1d 8e 10 80 	movl   $0x80108e1d,(%esp)
80103513:	e8 88 ce ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103518:	e8 79 06 00 00       	call   80103b96 <picinit>
  ioapicinit();    // another interrupt controller
8010351d:	e8 a8 f3 ff ff       	call   801028ca <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103522:	e8 5a d5 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103527:	e8 eb 3b 00 00       	call   80107117 <uartinit>
  pinit();         // process table
8010352c:	e8 0b 0c 00 00       	call   8010413c <pinit>
  tvinit();        // trap vectors
80103531:	e8 93 37 00 00       	call   80106cc9 <tvinit>
  binit();         // buffer cache
80103536:	e8 f9 ca ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010353b:	e8 ea d9 ff ff       	call   80100f2a <fileinit>
  iinit();         // inode cache
80103540:	e8 7f e0 ff ff       	call   801015c4 <iinit>
  ideinit();       // disk
80103545:	e8 e9 ef ff ff       	call   80102533 <ideinit>
  if(!ismp)
8010354a:	a1 44 09 11 80       	mov    0x80110944,%eax
8010354f:	85 c0                	test   %eax,%eax
80103551:	75 05                	jne    80103558 <main+0x8d>
    timerinit();   // uniprocessor timer
80103553:	e8 bc 36 00 00       	call   80106c14 <timerinit>
  startothers();   // start other processors
80103558:	e8 7f 00 00 00       	call   801035dc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010355d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103564:	8e 
80103565:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010356c:	e8 9b f4 ff ff       	call   80102a0c <kinit2>
  userinit();      // first user process
80103571:	e8 e4 0c 00 00       	call   8010425a <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103576:	e8 1a 00 00 00       	call   80103595 <mpmain>

8010357b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010357b:	55                   	push   %ebp
8010357c:	89 e5                	mov    %esp,%ebp
8010357e:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103581:	e8 c6 4e 00 00       	call   8010844c <switchkvm>
  seginit();
80103586:	e8 3d 48 00 00       	call   80107dc8 <seginit>
  lapicinit();
8010358b:	e8 78 f8 ff ff       	call   80102e08 <lapicinit>
  mpmain();
80103590:	e8 00 00 00 00       	call   80103595 <mpmain>

80103595 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103595:	55                   	push   %ebp
80103596:	89 e5                	mov    %esp,%ebp
80103598:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010359b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035a1:	0f b6 00             	movzbl (%eax),%eax
801035a4:	0f b6 c0             	movzbl %al,%eax
801035a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801035ab:	c7 04 24 34 8e 10 80 	movl   $0x80108e34,(%esp)
801035b2:	e8 e9 cd ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801035b7:	e8 81 38 00 00       	call   80106e3d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801035bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035c2:	05 a8 00 00 00       	add    $0xa8,%eax
801035c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801035ce:	00 
801035cf:	89 04 24             	mov    %eax,(%esp)
801035d2:	e8 da fe ff ff       	call   801034b1 <xchg>
  scheduler();     // start running processes
801035d7:	e8 ed 15 00 00       	call   80104bc9 <scheduler>

801035dc <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801035dc:	55                   	push   %ebp
801035dd:	89 e5                	mov    %esp,%ebp
801035df:	53                   	push   %ebx
801035e0:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801035e3:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801035ea:	e8 b5 fe ff ff       	call   801034a4 <p2v>
801035ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035f2:	b8 8a 00 00 00       	mov    $0x8a,%eax
801035f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801035fb:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103602:	80 
80103603:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103606:	89 04 24             	mov    %eax,(%esp)
80103609:	e8 d1 21 00 00       	call   801057df <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010360e:	c7 45 f4 60 09 11 80 	movl   $0x80110960,-0xc(%ebp)
80103615:	e9 85 00 00 00       	jmp    8010369f <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010361a:	e8 42 f9 ff ff       	call   80102f61 <cpunum>
8010361f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103625:	05 60 09 11 80       	add    $0x80110960,%eax
8010362a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010362d:	75 02                	jne    80103631 <startothers+0x55>
      continue;
8010362f:	eb 67                	jmp    80103698 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103631:	e8 cc f4 ff ff       	call   80102b02 <kalloc>
80103636:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103639:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010363c:	83 e8 04             	sub    $0x4,%eax
8010363f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103642:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103648:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010364a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010364d:	83 e8 08             	sub    $0x8,%eax
80103650:	c7 00 7b 35 10 80    	movl   $0x8010357b,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103659:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010365c:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103663:	e8 2f fe ff ff       	call   80103497 <v2p>
80103668:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010366a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010366d:	89 04 24             	mov    %eax,(%esp)
80103670:	e8 22 fe ff ff       	call   80103497 <v2p>
80103675:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103678:	0f b6 12             	movzbl (%edx),%edx
8010367b:	0f b6 d2             	movzbl %dl,%edx
8010367e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103682:	89 14 24             	mov    %edx,(%esp)
80103685:	e8 59 f9 ff ff       	call   80102fe3 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010368a:	90                   	nop
8010368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010368e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	74 f3                	je     8010368b <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103698:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
8010369f:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801036a4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801036aa:	05 60 09 11 80       	add    $0x80110960,%eax
801036af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036b2:	0f 87 62 ff ff ff    	ja     8010361a <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801036b8:	83 c4 24             	add    $0x24,%esp
801036bb:	5b                   	pop    %ebx
801036bc:	5d                   	pop    %ebp
801036bd:	c3                   	ret    

801036be <p2v>:
801036be:	55                   	push   %ebp
801036bf:	89 e5                	mov    %esp,%ebp
801036c1:	8b 45 08             	mov    0x8(%ebp),%eax
801036c4:	05 00 00 00 80       	add    $0x80000000,%eax
801036c9:	5d                   	pop    %ebp
801036ca:	c3                   	ret    

801036cb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801036cb:	55                   	push   %ebp
801036cc:	89 e5                	mov    %esp,%ebp
801036ce:	83 ec 14             	sub    $0x14,%esp
801036d1:	8b 45 08             	mov    0x8(%ebp),%eax
801036d4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801036dc:	89 c2                	mov    %eax,%edx
801036de:	ec                   	in     (%dx),%al
801036df:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801036e2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801036e6:	c9                   	leave  
801036e7:	c3                   	ret    

801036e8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801036e8:	55                   	push   %ebp
801036e9:	89 e5                	mov    %esp,%ebp
801036eb:	83 ec 08             	sub    $0x8,%esp
801036ee:	8b 55 08             	mov    0x8(%ebp),%edx
801036f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801036f4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801036f8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036fb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801036ff:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103703:	ee                   	out    %al,(%dx)
}
80103704:	c9                   	leave  
80103705:	c3                   	ret    

80103706 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103706:	55                   	push   %ebp
80103707:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103709:	a1 64 c6 10 80       	mov    0x8010c664,%eax
8010370e:	89 c2                	mov    %eax,%edx
80103710:	b8 60 09 11 80       	mov    $0x80110960,%eax
80103715:	29 c2                	sub    %eax,%edx
80103717:	89 d0                	mov    %edx,%eax
80103719:	c1 f8 02             	sar    $0x2,%eax
8010371c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103722:	5d                   	pop    %ebp
80103723:	c3                   	ret    

80103724 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010372a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103731:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103738:	eb 15                	jmp    8010374f <sum+0x2b>
    sum += addr[i];
8010373a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010373d:	8b 45 08             	mov    0x8(%ebp),%eax
80103740:	01 d0                	add    %edx,%eax
80103742:	0f b6 00             	movzbl (%eax),%eax
80103745:	0f b6 c0             	movzbl %al,%eax
80103748:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
8010374b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010374f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103752:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103755:	7c e3                	jl     8010373a <sum+0x16>
    sum += addr[i];
  return sum;
80103757:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010375a:	c9                   	leave  
8010375b:	c3                   	ret    

8010375c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010375c:	55                   	push   %ebp
8010375d:	89 e5                	mov    %esp,%ebp
8010375f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103762:	8b 45 08             	mov    0x8(%ebp),%eax
80103765:	89 04 24             	mov    %eax,(%esp)
80103768:	e8 51 ff ff ff       	call   801036be <p2v>
8010376d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103770:	8b 55 0c             	mov    0xc(%ebp),%edx
80103773:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103776:	01 d0                	add    %edx,%eax
80103778:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010377e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103781:	eb 3f                	jmp    801037c2 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103783:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010378a:	00 
8010378b:	c7 44 24 04 48 8e 10 	movl   $0x80108e48,0x4(%esp)
80103792:	80 
80103793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103796:	89 04 24             	mov    %eax,(%esp)
80103799:	e8 e9 1f 00 00       	call   80105787 <memcmp>
8010379e:	85 c0                	test   %eax,%eax
801037a0:	75 1c                	jne    801037be <mpsearch1+0x62>
801037a2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801037a9:	00 
801037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ad:	89 04 24             	mov    %eax,(%esp)
801037b0:	e8 6f ff ff ff       	call   80103724 <sum>
801037b5:	84 c0                	test   %al,%al
801037b7:	75 05                	jne    801037be <mpsearch1+0x62>
      return (struct mp*)p;
801037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bc:	eb 11                	jmp    801037cf <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801037be:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801037c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037c8:	72 b9                	jb     80103783 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801037ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037cf:	c9                   	leave  
801037d0:	c3                   	ret    

801037d1 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801037d1:	55                   	push   %ebp
801037d2:	89 e5                	mov    %esp,%ebp
801037d4:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801037d7:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037e1:	83 c0 0f             	add    $0xf,%eax
801037e4:	0f b6 00             	movzbl (%eax),%eax
801037e7:	0f b6 c0             	movzbl %al,%eax
801037ea:	c1 e0 08             	shl    $0x8,%eax
801037ed:	89 c2                	mov    %eax,%edx
801037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f2:	83 c0 0e             	add    $0xe,%eax
801037f5:	0f b6 00             	movzbl (%eax),%eax
801037f8:	0f b6 c0             	movzbl %al,%eax
801037fb:	09 d0                	or     %edx,%eax
801037fd:	c1 e0 04             	shl    $0x4,%eax
80103800:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103807:	74 21                	je     8010382a <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103809:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103810:	00 
80103811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103814:	89 04 24             	mov    %eax,(%esp)
80103817:	e8 40 ff ff ff       	call   8010375c <mpsearch1>
8010381c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010381f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103823:	74 50                	je     80103875 <mpsearch+0xa4>
      return mp;
80103825:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103828:	eb 5f                	jmp    80103889 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010382d:	83 c0 14             	add    $0x14,%eax
80103830:	0f b6 00             	movzbl (%eax),%eax
80103833:	0f b6 c0             	movzbl %al,%eax
80103836:	c1 e0 08             	shl    $0x8,%eax
80103839:	89 c2                	mov    %eax,%edx
8010383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383e:	83 c0 13             	add    $0x13,%eax
80103841:	0f b6 00             	movzbl (%eax),%eax
80103844:	0f b6 c0             	movzbl %al,%eax
80103847:	09 d0                	or     %edx,%eax
80103849:	c1 e0 0a             	shl    $0xa,%eax
8010384c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010384f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103852:	2d 00 04 00 00       	sub    $0x400,%eax
80103857:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010385e:	00 
8010385f:	89 04 24             	mov    %eax,(%esp)
80103862:	e8 f5 fe ff ff       	call   8010375c <mpsearch1>
80103867:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010386a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010386e:	74 05                	je     80103875 <mpsearch+0xa4>
      return mp;
80103870:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103873:	eb 14                	jmp    80103889 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103875:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010387c:	00 
8010387d:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103884:	e8 d3 fe ff ff       	call   8010375c <mpsearch1>
}
80103889:	c9                   	leave  
8010388a:	c3                   	ret    

8010388b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010388b:	55                   	push   %ebp
8010388c:	89 e5                	mov    %esp,%ebp
8010388e:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103891:	e8 3b ff ff ff       	call   801037d1 <mpsearch>
80103896:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010389d:	74 0a                	je     801038a9 <mpconfig+0x1e>
8010389f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038a2:	8b 40 04             	mov    0x4(%eax),%eax
801038a5:	85 c0                	test   %eax,%eax
801038a7:	75 0a                	jne    801038b3 <mpconfig+0x28>
    return 0;
801038a9:	b8 00 00 00 00       	mov    $0x0,%eax
801038ae:	e9 83 00 00 00       	jmp    80103936 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801038b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b6:	8b 40 04             	mov    0x4(%eax),%eax
801038b9:	89 04 24             	mov    %eax,(%esp)
801038bc:	e8 fd fd ff ff       	call   801036be <p2v>
801038c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038c4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801038cb:	00 
801038cc:	c7 44 24 04 4d 8e 10 	movl   $0x80108e4d,0x4(%esp)
801038d3:	80 
801038d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d7:	89 04 24             	mov    %eax,(%esp)
801038da:	e8 a8 1e 00 00       	call   80105787 <memcmp>
801038df:	85 c0                	test   %eax,%eax
801038e1:	74 07                	je     801038ea <mpconfig+0x5f>
    return 0;
801038e3:	b8 00 00 00 00       	mov    $0x0,%eax
801038e8:	eb 4c                	jmp    80103936 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801038ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ed:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038f1:	3c 01                	cmp    $0x1,%al
801038f3:	74 12                	je     80103907 <mpconfig+0x7c>
801038f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038fc:	3c 04                	cmp    $0x4,%al
801038fe:	74 07                	je     80103907 <mpconfig+0x7c>
    return 0;
80103900:	b8 00 00 00 00       	mov    $0x0,%eax
80103905:	eb 2f                	jmp    80103936 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010390e:	0f b7 c0             	movzwl %ax,%eax
80103911:	89 44 24 04          	mov    %eax,0x4(%esp)
80103915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103918:	89 04 24             	mov    %eax,(%esp)
8010391b:	e8 04 fe ff ff       	call   80103724 <sum>
80103920:	84 c0                	test   %al,%al
80103922:	74 07                	je     8010392b <mpconfig+0xa0>
    return 0;
80103924:	b8 00 00 00 00       	mov    $0x0,%eax
80103929:	eb 0b                	jmp    80103936 <mpconfig+0xab>
  *pmp = mp;
8010392b:	8b 45 08             	mov    0x8(%ebp),%eax
8010392e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103931:	89 10                	mov    %edx,(%eax)
  return conf;
80103933:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103936:	c9                   	leave  
80103937:	c3                   	ret    

80103938 <mpinit>:

void
mpinit(void)
{
80103938:	55                   	push   %ebp
80103939:	89 e5                	mov    %esp,%ebp
8010393b:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010393e:	c7 05 64 c6 10 80 60 	movl   $0x80110960,0x8010c664
80103945:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103948:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010394b:	89 04 24             	mov    %eax,(%esp)
8010394e:	e8 38 ff ff ff       	call   8010388b <mpconfig>
80103953:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103956:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010395a:	75 05                	jne    80103961 <mpinit+0x29>
    return;
8010395c:	e9 9c 01 00 00       	jmp    80103afd <mpinit+0x1c5>
  ismp = 1;
80103961:	c7 05 44 09 11 80 01 	movl   $0x1,0x80110944
80103968:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010396b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396e:	8b 40 24             	mov    0x24(%eax),%eax
80103971:	a3 bc 08 11 80       	mov    %eax,0x801108bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103976:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103979:	83 c0 2c             	add    $0x2c,%eax
8010397c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010397f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103982:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103986:	0f b7 d0             	movzwl %ax,%edx
80103989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398c:	01 d0                	add    %edx,%eax
8010398e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103991:	e9 f4 00 00 00       	jmp    80103a8a <mpinit+0x152>
    switch(*p){
80103996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103999:	0f b6 00             	movzbl (%eax),%eax
8010399c:	0f b6 c0             	movzbl %al,%eax
8010399f:	83 f8 04             	cmp    $0x4,%eax
801039a2:	0f 87 bf 00 00 00    	ja     80103a67 <mpinit+0x12f>
801039a8:	8b 04 85 90 8e 10 80 	mov    -0x7fef7170(,%eax,4),%eax
801039af:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039ba:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039be:	0f b6 d0             	movzbl %al,%edx
801039c1:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801039c6:	39 c2                	cmp    %eax,%edx
801039c8:	74 2d                	je     801039f7 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039cd:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039d1:	0f b6 d0             	movzbl %al,%edx
801039d4:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801039d9:	89 54 24 08          	mov    %edx,0x8(%esp)
801039dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801039e1:	c7 04 24 52 8e 10 80 	movl   $0x80108e52,(%esp)
801039e8:	e8 b3 c9 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801039ed:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
801039f4:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801039f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039fa:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801039fe:	0f b6 c0             	movzbl %al,%eax
80103a01:	83 e0 02             	and    $0x2,%eax
80103a04:	85 c0                	test   %eax,%eax
80103a06:	74 15                	je     80103a1d <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103a08:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a0d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a13:	05 60 09 11 80       	add    $0x80110960,%eax
80103a18:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103a1d:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
80103a23:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a28:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103a2e:	81 c2 60 09 11 80    	add    $0x80110960,%edx
80103a34:	88 02                	mov    %al,(%edx)
      ncpu++;
80103a36:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a3b:	83 c0 01             	add    $0x1,%eax
80103a3e:	a3 40 0f 11 80       	mov    %eax,0x80110f40
      p += sizeof(struct mpproc);
80103a43:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a47:	eb 41                	jmp    80103a8a <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a52:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a56:	a2 40 09 11 80       	mov    %al,0x80110940
      p += sizeof(struct mpioapic);
80103a5b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a5f:	eb 29                	jmp    80103a8a <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a61:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a65:	eb 23                	jmp    80103a8a <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6a:	0f b6 00             	movzbl (%eax),%eax
80103a6d:	0f b6 c0             	movzbl %al,%eax
80103a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a74:	c7 04 24 70 8e 10 80 	movl   $0x80108e70,(%esp)
80103a7b:	e8 20 c9 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103a80:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
80103a87:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a90:	0f 82 00 ff ff ff    	jb     80103996 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103a96:	a1 44 09 11 80       	mov    0x80110944,%eax
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	75 1d                	jne    80103abc <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103a9f:	c7 05 40 0f 11 80 01 	movl   $0x1,0x80110f40
80103aa6:	00 00 00 
    lapic = 0;
80103aa9:	c7 05 bc 08 11 80 00 	movl   $0x0,0x801108bc
80103ab0:	00 00 00 
    ioapicid = 0;
80103ab3:	c6 05 40 09 11 80 00 	movb   $0x0,0x80110940
    return;
80103aba:	eb 41                	jmp    80103afd <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103abc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103abf:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ac3:	84 c0                	test   %al,%al
80103ac5:	74 36                	je     80103afd <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ac7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103ace:	00 
80103acf:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103ad6:	e8 0d fc ff ff       	call   801036e8 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103adb:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ae2:	e8 e4 fb ff ff       	call   801036cb <inb>
80103ae7:	83 c8 01             	or     $0x1,%eax
80103aea:	0f b6 c0             	movzbl %al,%eax
80103aed:	89 44 24 04          	mov    %eax,0x4(%esp)
80103af1:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103af8:	e8 eb fb ff ff       	call   801036e8 <outb>
  }
}
80103afd:	c9                   	leave  
80103afe:	c3                   	ret    

80103aff <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103aff:	55                   	push   %ebp
80103b00:	89 e5                	mov    %esp,%ebp
80103b02:	83 ec 08             	sub    $0x8,%esp
80103b05:	8b 55 08             	mov    0x8(%ebp),%edx
80103b08:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b0b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b0f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b12:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b16:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b1a:	ee                   	out    %al,(%dx)
}
80103b1b:	c9                   	leave  
80103b1c:	c3                   	ret    

80103b1d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103b1d:	55                   	push   %ebp
80103b1e:	89 e5                	mov    %esp,%ebp
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	8b 45 08             	mov    0x8(%ebp),%eax
80103b26:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b2e:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103b34:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b38:	0f b6 c0             	movzbl %al,%eax
80103b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b3f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b46:	e8 b4 ff ff ff       	call   80103aff <outb>
  outb(IO_PIC2+1, mask >> 8);
80103b4b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b4f:	66 c1 e8 08          	shr    $0x8,%ax
80103b53:	0f b6 c0             	movzbl %al,%eax
80103b56:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b5a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b61:	e8 99 ff ff ff       	call   80103aff <outb>
}
80103b66:	c9                   	leave  
80103b67:	c3                   	ret    

80103b68 <picenable>:

void
picenable(int irq)
{
80103b68:	55                   	push   %ebp
80103b69:	89 e5                	mov    %esp,%ebp
80103b6b:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103b71:	ba 01 00 00 00       	mov    $0x1,%edx
80103b76:	89 c1                	mov    %eax,%ecx
80103b78:	d3 e2                	shl    %cl,%edx
80103b7a:	89 d0                	mov    %edx,%eax
80103b7c:	f7 d0                	not    %eax
80103b7e:	89 c2                	mov    %eax,%edx
80103b80:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103b87:	21 d0                	and    %edx,%eax
80103b89:	0f b7 c0             	movzwl %ax,%eax
80103b8c:	89 04 24             	mov    %eax,(%esp)
80103b8f:	e8 89 ff ff ff       	call   80103b1d <picsetmask>
}
80103b94:	c9                   	leave  
80103b95:	c3                   	ret    

80103b96 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103b96:	55                   	push   %ebp
80103b97:	89 e5                	mov    %esp,%ebp
80103b99:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103b9c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ba3:	00 
80103ba4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bab:	e8 4f ff ff ff       	call   80103aff <outb>
  outb(IO_PIC2+1, 0xFF);
80103bb0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103bb7:	00 
80103bb8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bbf:	e8 3b ff ff ff       	call   80103aff <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103bc4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bcb:	00 
80103bcc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bd3:	e8 27 ff ff ff       	call   80103aff <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103bd8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103bdf:	00 
80103be0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103be7:	e8 13 ff ff ff       	call   80103aff <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103bec:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103bf3:	00 
80103bf4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bfb:	e8 ff fe ff ff       	call   80103aff <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103c00:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c07:	00 
80103c08:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c0f:	e8 eb fe ff ff       	call   80103aff <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103c14:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103c1b:	00 
80103c1c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c23:	e8 d7 fe ff ff       	call   80103aff <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103c28:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103c2f:	00 
80103c30:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c37:	e8 c3 fe ff ff       	call   80103aff <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103c3c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103c43:	00 
80103c44:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c4b:	e8 af fe ff ff       	call   80103aff <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103c50:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c57:	00 
80103c58:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c5f:	e8 9b fe ff ff       	call   80103aff <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103c64:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c6b:	00 
80103c6c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c73:	e8 87 fe ff ff       	call   80103aff <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c78:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c7f:	00 
80103c80:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c87:	e8 73 fe ff ff       	call   80103aff <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103c8c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c93:	00 
80103c94:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c9b:	e8 5f fe ff ff       	call   80103aff <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103ca0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103ca7:	00 
80103ca8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103caf:	e8 4b fe ff ff       	call   80103aff <outb>

  if(irqmask != 0xFFFF)
80103cb4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103cbb:	66 83 f8 ff          	cmp    $0xffff,%ax
80103cbf:	74 12                	je     80103cd3 <picinit+0x13d>
    picsetmask(irqmask);
80103cc1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103cc8:	0f b7 c0             	movzwl %ax,%eax
80103ccb:	89 04 24             	mov    %eax,(%esp)
80103cce:	e8 4a fe ff ff       	call   80103b1d <picsetmask>
}
80103cd3:	c9                   	leave  
80103cd4:	c3                   	ret    

80103cd5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103cd5:	55                   	push   %ebp
80103cd6:	89 e5                	mov    %esp,%ebp
80103cd8:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cee:	8b 10                	mov    (%eax),%edx
80103cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf3:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103cf5:	e8 4c d2 ff ff       	call   80100f46 <filealloc>
80103cfa:	8b 55 08             	mov    0x8(%ebp),%edx
80103cfd:	89 02                	mov    %eax,(%edx)
80103cff:	8b 45 08             	mov    0x8(%ebp),%eax
80103d02:	8b 00                	mov    (%eax),%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	0f 84 c8 00 00 00    	je     80103dd4 <pipealloc+0xff>
80103d0c:	e8 35 d2 ff ff       	call   80100f46 <filealloc>
80103d11:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d14:	89 02                	mov    %eax,(%edx)
80103d16:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d19:	8b 00                	mov    (%eax),%eax
80103d1b:	85 c0                	test   %eax,%eax
80103d1d:	0f 84 b1 00 00 00    	je     80103dd4 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d23:	e8 da ed ff ff       	call   80102b02 <kalloc>
80103d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d2f:	75 05                	jne    80103d36 <pipealloc+0x61>
    goto bad;
80103d31:	e9 9e 00 00 00       	jmp    80103dd4 <pipealloc+0xff>
  p->readopen = 1;
80103d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d39:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d40:	00 00 00 
  p->writeopen = 1;
80103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d46:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d4d:	00 00 00 
  p->nwrite = 0;
80103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d53:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d5a:	00 00 00 
  p->nread = 0;
80103d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d60:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d67:	00 00 00 
  initlock(&p->lock, "pipe");
80103d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d6d:	c7 44 24 04 a4 8e 10 	movl   $0x80108ea4,0x4(%esp)
80103d74:	80 
80103d75:	89 04 24             	mov    %eax,(%esp)
80103d78:	e8 8e 16 00 00       	call   8010540b <initlock>
  (*f0)->type = FD_PIPE;
80103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d80:	8b 00                	mov    (%eax),%eax
80103d82:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d88:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8b:	8b 00                	mov    (%eax),%eax
80103d8d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d91:	8b 45 08             	mov    0x8(%ebp),%eax
80103d94:	8b 00                	mov    (%eax),%eax
80103d96:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	8b 00                	mov    (%eax),%eax
80103d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103da5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da8:	8b 00                	mov    (%eax),%eax
80103daa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db3:	8b 00                	mov    (%eax),%eax
80103db5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103db9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dbc:	8b 00                	mov    (%eax),%eax
80103dbe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dc5:	8b 00                	mov    (%eax),%eax
80103dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dca:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103dcd:	b8 00 00 00 00       	mov    $0x0,%eax
80103dd2:	eb 42                	jmp    80103e16 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dd8:	74 0b                	je     80103de5 <pipealloc+0x110>
    kfree((char*)p);
80103dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 84 ec ff ff       	call   80102a69 <kfree>
  if(*f0)
80103de5:	8b 45 08             	mov    0x8(%ebp),%eax
80103de8:	8b 00                	mov    (%eax),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 0d                	je     80103dfb <pipealloc+0x126>
    fileclose(*f0);
80103dee:	8b 45 08             	mov    0x8(%ebp),%eax
80103df1:	8b 00                	mov    (%eax),%eax
80103df3:	89 04 24             	mov    %eax,(%esp)
80103df6:	e8 f3 d1 ff ff       	call   80100fee <fileclose>
  if(*f1)
80103dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dfe:	8b 00                	mov    (%eax),%eax
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 0d                	je     80103e11 <pipealloc+0x13c>
    fileclose(*f1);
80103e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e07:	8b 00                	mov    (%eax),%eax
80103e09:	89 04 24             	mov    %eax,(%esp)
80103e0c:	e8 dd d1 ff ff       	call   80100fee <fileclose>
  return -1;
80103e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e16:	c9                   	leave  
80103e17:	c3                   	ret    

80103e18 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e21:	89 04 24             	mov    %eax,(%esp)
80103e24:	e8 03 16 00 00       	call   8010542c <acquire>
  if(writable){
80103e29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e2d:	74 1f                	je     80103e4e <pipeclose+0x36>
    p->writeopen = 0;
80103e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e32:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e39:	00 00 00 
    wakeup(&p->nread);
80103e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3f:	05 34 02 00 00       	add    $0x234,%eax
80103e44:	89 04 24             	mov    %eax,(%esp)
80103e47:	e8 95 10 00 00       	call   80104ee1 <wakeup>
80103e4c:	eb 1d                	jmp    80103e6b <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e51:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e58:	00 00 00 
    wakeup(&p->nwrite);
80103e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5e:	05 38 02 00 00       	add    $0x238,%eax
80103e63:	89 04 24             	mov    %eax,(%esp)
80103e66:	e8 76 10 00 00       	call   80104ee1 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	75 25                	jne    80103e9d <pipeclose+0x85>
80103e78:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e81:	85 c0                	test   %eax,%eax
80103e83:	75 18                	jne    80103e9d <pipeclose+0x85>
    release(&p->lock);
80103e85:	8b 45 08             	mov    0x8(%ebp),%eax
80103e88:	89 04 24             	mov    %eax,(%esp)
80103e8b:	e8 46 16 00 00       	call   801054d6 <release>
    kfree((char*)p);
80103e90:	8b 45 08             	mov    0x8(%ebp),%eax
80103e93:	89 04 24             	mov    %eax,(%esp)
80103e96:	e8 ce eb ff ff       	call   80102a69 <kfree>
80103e9b:	eb 0b                	jmp    80103ea8 <pipeclose+0x90>
  } else
    release(&p->lock);
80103e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea0:	89 04 24             	mov    %eax,(%esp)
80103ea3:	e8 2e 16 00 00       	call   801054d6 <release>
}
80103ea8:	c9                   	leave  
80103ea9:	c3                   	ret    

80103eaa <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103eaa:	55                   	push   %ebp
80103eab:	89 e5                	mov    %esp,%ebp
80103ead:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb3:	89 04 24             	mov    %eax,(%esp)
80103eb6:	e8 71 15 00 00       	call   8010542c <acquire>
  for(i = 0; i < n; i++){
80103ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ec2:	e9 a6 00 00 00       	jmp    80103f6d <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ec7:	eb 57                	jmp    80103f20 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103ec9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	74 0d                	je     80103ee3 <pipewrite+0x39>
80103ed6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103edc:	8b 40 24             	mov    0x24(%eax),%eax
80103edf:	85 c0                	test   %eax,%eax
80103ee1:	74 15                	je     80103ef8 <pipewrite+0x4e>
        release(&p->lock);
80103ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee6:	89 04 24             	mov    %eax,(%esp)
80103ee9:	e8 e8 15 00 00       	call   801054d6 <release>
        return -1;
80103eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ef3:	e9 9f 00 00 00       	jmp    80103f97 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80103efb:	05 34 02 00 00       	add    $0x234,%eax
80103f00:	89 04 24             	mov    %eax,(%esp)
80103f03:	e8 d9 0f 00 00       	call   80104ee1 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f08:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f0e:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f14:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f18:	89 14 24             	mov    %edx,(%esp)
80103f1b:	e8 7d 0e 00 00       	call   80104d9d <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f20:	8b 45 08             	mov    0x8(%ebp),%eax
80103f23:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f29:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f32:	05 00 02 00 00       	add    $0x200,%eax
80103f37:	39 c2                	cmp    %eax,%edx
80103f39:	74 8e                	je     80103ec9 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f44:	8d 48 01             	lea    0x1(%eax),%ecx
80103f47:	8b 55 08             	mov    0x8(%ebp),%edx
80103f4a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f50:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f55:	89 c1                	mov    %eax,%ecx
80103f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f5d:	01 d0                	add    %edx,%eax
80103f5f:	0f b6 10             	movzbl (%eax),%edx
80103f62:	8b 45 08             	mov    0x8(%ebp),%eax
80103f65:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f70:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f73:	0f 8c 4e ff ff ff    	jl     80103ec7 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f79:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7c:	05 34 02 00 00       	add    $0x234,%eax
80103f81:	89 04 24             	mov    %eax,(%esp)
80103f84:	e8 58 0f 00 00       	call   80104ee1 <wakeup>
  release(&p->lock);
80103f89:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8c:	89 04 24             	mov    %eax,(%esp)
80103f8f:	e8 42 15 00 00       	call   801054d6 <release>
  return n;
80103f94:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f97:	c9                   	leave  
80103f98:	c3                   	ret    

80103f99 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f99:	55                   	push   %ebp
80103f9a:	89 e5                	mov    %esp,%ebp
80103f9c:	53                   	push   %ebx
80103f9d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa3:	89 04 24             	mov    %eax,(%esp)
80103fa6:	e8 81 14 00 00       	call   8010542c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fab:	eb 3a                	jmp    80103fe7 <piperead+0x4e>
    if(proc->killed){
80103fad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fb3:	8b 40 24             	mov    0x24(%eax),%eax
80103fb6:	85 c0                	test   %eax,%eax
80103fb8:	74 15                	je     80103fcf <piperead+0x36>
      release(&p->lock);
80103fba:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbd:	89 04 24             	mov    %eax,(%esp)
80103fc0:	e8 11 15 00 00       	call   801054d6 <release>
      return -1;
80103fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fca:	e9 b5 00 00 00       	jmp    80104084 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	8b 55 08             	mov    0x8(%ebp),%edx
80103fd5:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fdf:	89 14 24             	mov    %edx,(%esp)
80103fe2:	e8 b6 0d 00 00       	call   80104d9d <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fea:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ff9:	39 c2                	cmp    %eax,%edx
80103ffb:	75 0d                	jne    8010400a <piperead+0x71>
80103ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80104000:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104006:	85 c0                	test   %eax,%eax
80104008:	75 a3                	jne    80103fad <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010400a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104011:	eb 4b                	jmp    8010405e <piperead+0xc5>
    if(p->nread == p->nwrite)
80104013:	8b 45 08             	mov    0x8(%ebp),%eax
80104016:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010401c:	8b 45 08             	mov    0x8(%ebp),%eax
8010401f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104025:	39 c2                	cmp    %eax,%edx
80104027:	75 02                	jne    8010402b <piperead+0x92>
      break;
80104029:	eb 3b                	jmp    80104066 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010402b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010402e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104031:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104034:	8b 45 08             	mov    0x8(%ebp),%eax
80104037:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010403d:	8d 48 01             	lea    0x1(%eax),%ecx
80104040:	8b 55 08             	mov    0x8(%ebp),%edx
80104043:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104049:	25 ff 01 00 00       	and    $0x1ff,%eax
8010404e:	89 c2                	mov    %eax,%edx
80104050:	8b 45 08             	mov    0x8(%ebp),%eax
80104053:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104058:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010405a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010405e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104061:	3b 45 10             	cmp    0x10(%ebp),%eax
80104064:	7c ad                	jl     80104013 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104066:	8b 45 08             	mov    0x8(%ebp),%eax
80104069:	05 38 02 00 00       	add    $0x238,%eax
8010406e:	89 04 24             	mov    %eax,(%esp)
80104071:	e8 6b 0e 00 00       	call   80104ee1 <wakeup>
  release(&p->lock);
80104076:	8b 45 08             	mov    0x8(%ebp),%eax
80104079:	89 04 24             	mov    %eax,(%esp)
8010407c:	e8 55 14 00 00       	call   801054d6 <release>
  return i;
80104081:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104084:	83 c4 24             	add    $0x24,%esp
80104087:	5b                   	pop    %ebx
80104088:	5d                   	pop    %ebp
80104089:	c3                   	ret    

8010408a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010408a:	55                   	push   %ebp
8010408b:	89 e5                	mov    %esp,%ebp
8010408d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104090:	9c                   	pushf  
80104091:	58                   	pop    %eax
80104092:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104095:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104098:	c9                   	leave  
80104099:	c3                   	ret    

8010409a <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010409a:	55                   	push   %ebp
8010409b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010409d:	fb                   	sti    
}
8010409e:	5d                   	pop    %ebp
8010409f:	c3                   	ret    

801040a0 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801040a6:	8b 55 08             	mov    0x8(%ebp),%edx
801040a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
801040af:	f0 87 02             	lock xchg %eax,(%edx)
801040b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801040b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040b8:	c9                   	leave  
801040b9:	c3                   	ret    

801040ba <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
801040ba:	55                   	push   %ebp
801040bb:	89 e5                	mov    %esp,%ebp
801040bd:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
801040c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    d = dst;
801040c6:	8b 45 08             	mov    0x8(%ebp),%eax
801040c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(s < d && s + n > d){
801040cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801040cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801040d2:	73 3d                	jae    80104111 <memcop+0x57>
801040d4:	8b 45 10             	mov    0x10(%ebp),%eax
801040d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801040da:	01 d0                	add    %edx,%eax
801040dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801040df:	76 30                	jbe    80104111 <memcop+0x57>
        s += n;
801040e1:	8b 45 10             	mov    0x10(%ebp),%eax
801040e4:	01 45 fc             	add    %eax,-0x4(%ebp)
        d += n;
801040e7:	8b 45 10             	mov    0x10(%ebp),%eax
801040ea:	01 45 f8             	add    %eax,-0x8(%ebp)
        while(n-- > 0)
801040ed:	eb 13                	jmp    80104102 <memcop+0x48>
            *--d = *--s;
801040ef:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801040f3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801040f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801040fa:	0f b6 10             	movzbl (%eax),%edx
801040fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104100:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
80104102:	8b 45 10             	mov    0x10(%ebp),%eax
80104105:	8d 50 ff             	lea    -0x1(%eax),%edx
80104108:	89 55 10             	mov    %edx,0x10(%ebp)
8010410b:	85 c0                	test   %eax,%eax
8010410d:	75 e0                	jne    801040ef <memcop+0x35>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
8010410f:	eb 26                	jmp    80104137 <memcop+0x7d>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80104111:	eb 17                	jmp    8010412a <memcop+0x70>
            *d++ = *s++;
80104113:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104116:	8d 50 01             	lea    0x1(%eax),%edx
80104119:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010411c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010411f:	8d 4a 01             	lea    0x1(%edx),%ecx
80104122:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104125:	0f b6 12             	movzbl (%edx),%edx
80104128:	88 10                	mov    %dl,(%eax)
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
8010412a:	8b 45 10             	mov    0x10(%ebp),%eax
8010412d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104130:	89 55 10             	mov    %edx,0x10(%ebp)
80104133:	85 c0                	test   %eax,%eax
80104135:	75 dc                	jne    80104113 <memcop+0x59>
            *d++ = *s++;

    return dst;
80104137:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010413a:	c9                   	leave  
8010413b:	c3                   	ret    

8010413c <pinit>:


    void
pinit(void)
{
8010413c:	55                   	push   %ebp
8010413d:	89 e5                	mov    %esp,%ebp
8010413f:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
80104142:	c7 44 24 04 ac 8e 10 	movl   $0x80108eac,0x4(%esp)
80104149:	80 
8010414a:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104151:	e8 b5 12 00 00       	call   8010540b <initlock>
}
80104156:	c9                   	leave  
80104157:	c3                   	ret    

80104158 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
80104158:	55                   	push   %ebp
80104159:	89 e5                	mov    %esp,%ebp
8010415b:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
8010415e:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104165:	e8 c2 12 00 00       	call   8010542c <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416a:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104171:	eb 53                	jmp    801041c6 <allocproc+0x6e>
        if(p->state == UNUSED)
80104173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104176:	8b 40 0c             	mov    0xc(%eax),%eax
80104179:	85 c0                	test   %eax,%eax
8010417b:	75 42                	jne    801041bf <allocproc+0x67>
            goto found;
8010417d:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
8010417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104181:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
80104188:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010418d:	8d 50 01             	lea    0x1(%eax),%edx
80104190:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104196:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104199:	89 42 10             	mov    %eax,0x10(%edx)
    release(&ptable.lock);
8010419c:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801041a3:	e8 2e 13 00 00       	call   801054d6 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
801041a8:	e8 55 e9 ff ff       	call   80102b02 <kalloc>
801041ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b0:	89 42 08             	mov    %eax,0x8(%edx)
801041b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b6:	8b 40 08             	mov    0x8(%eax),%eax
801041b9:	85 c0                	test   %eax,%eax
801041bb:	75 36                	jne    801041f3 <allocproc+0x9b>
801041bd:	eb 23                	jmp    801041e2 <allocproc+0x8a>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041bf:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801041c6:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
801041cd:	72 a4                	jb     80104173 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
801041cf:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801041d6:	e8 fb 12 00 00       	call   801054d6 <release>
    return 0;
801041db:	b8 00 00 00 00       	mov    $0x0,%eax
801041e0:	eb 76                	jmp    80104258 <allocproc+0x100>
    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
801041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
801041ec:	b8 00 00 00 00       	mov    $0x0,%eax
801041f1:	eb 65                	jmp    80104258 <allocproc+0x100>
    }
    sp = p->kstack + KSTACKSIZE;
801041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f6:	8b 40 08             	mov    0x8(%eax),%eax
801041f9:	05 00 10 00 00       	add    $0x1000,%eax
801041fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104201:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
80104205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104208:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010420b:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
8010420e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
80104212:	ba 84 6c 10 80       	mov    $0x80106c84,%edx
80104217:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010421a:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
8010421c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
80104220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104223:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104226:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010422f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104236:	00 
80104237:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010423e:	00 
8010423f:	89 04 24             	mov    %eax,(%esp)
80104242:	e8 c9 14 00 00       	call   80105710 <memset>
    p->context->eip = (uint)forkret;
80104247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010424d:	ba 71 4d 10 80       	mov    $0x80104d71,%edx
80104252:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
80104255:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104258:	c9                   	leave  
80104259:	c3                   	ret    

8010425a <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
8010425a:	55                   	push   %ebp
8010425b:	89 e5                	mov    %esp,%ebp
8010425d:	83 ec 28             	sub    $0x28,%esp
    //cprintf("userinit called\n");
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80104260:	e8 f3 fe ff ff       	call   80104158 <allocproc>
80104265:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
80104268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426b:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
    if((p->pgdir = setupkvm()) == 0)
80104270:	e8 03 41 00 00       	call   80108378 <setupkvm>
80104275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104278:	89 42 04             	mov    %eax,0x4(%edx)
8010427b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427e:	8b 40 04             	mov    0x4(%eax),%eax
80104281:	85 c0                	test   %eax,%eax
80104283:	75 0c                	jne    80104291 <userinit+0x37>
        panic("userinit: out of memory?");
80104285:	c7 04 24 b3 8e 10 80 	movl   $0x80108eb3,(%esp)
8010428c:	e8 a9 c2 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104291:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104299:	8b 40 04             	mov    0x4(%eax),%eax
8010429c:	89 54 24 08          	mov    %edx,0x8(%esp)
801042a0:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801042a7:	80 
801042a8:	89 04 24             	mov    %eax,(%esp)
801042ab:	e8 20 43 00 00       	call   801085d0 <inituvm>
    p->sz = PGSIZE;
801042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b3:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bc:	8b 40 18             	mov    0x18(%eax),%eax
801042bf:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042c6:	00 
801042c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042ce:	00 
801042cf:	89 04 24             	mov    %eax,(%esp)
801042d2:	e8 39 14 00 00       	call   80105710 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042da:	8b 40 18             	mov    0x18(%eax),%eax
801042dd:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e6:	8b 40 18             	mov    0x18(%eax),%eax
801042e9:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f2:	8b 40 18             	mov    0x18(%eax),%eax
801042f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042f8:	8b 52 18             	mov    0x18(%edx),%edx
801042fb:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042ff:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104306:	8b 40 18             	mov    0x18(%eax),%eax
80104309:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010430c:	8b 52 18             	mov    0x18(%edx),%edx
8010430f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104313:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80104317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010431a:	8b 40 18             	mov    0x18(%eax),%eax
8010431d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104327:	8b 40 18             	mov    0x18(%eax),%eax
8010432a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104331:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104334:	8b 40 18             	mov    0x18(%eax),%eax
80104337:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
8010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104341:	83 c0 6c             	add    $0x6c,%eax
80104344:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010434b:	00 
8010434c:	c7 44 24 04 cc 8e 10 	movl   $0x80108ecc,0x4(%esp)
80104353:	80 
80104354:	89 04 24             	mov    %eax,(%esp)
80104357:	e8 d4 15 00 00       	call   80105930 <safestrcpy>
    p->cwd = namei("/");
8010435c:	c7 04 24 d5 8e 10 80 	movl   $0x80108ed5,(%esp)
80104363:	e8 be e0 ff ff       	call   80102426 <namei>
80104368:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010436b:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
8010436e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104371:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    //cprintf("userinit no err\n");
}
80104378:	c9                   	leave  
80104379:	c3                   	ret    

8010437a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
8010437a:	55                   	push   %ebp
8010437b:	89 e5                	mov    %esp,%ebp
8010437d:	83 ec 28             	sub    $0x28,%esp
    //cprintf("growproc called\n");
    uint sz;

    sz = proc->sz;
80104380:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104386:	8b 00                	mov    (%eax),%eax
80104388:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
8010438b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010438f:	7e 34                	jle    801043c5 <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104391:	8b 55 08             	mov    0x8(%ebp),%edx
80104394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104397:	01 c2                	add    %eax,%edx
80104399:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010439f:	8b 40 04             	mov    0x4(%eax),%eax
801043a2:	89 54 24 08          	mov    %edx,0x8(%esp)
801043a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801043ad:	89 04 24             	mov    %eax,(%esp)
801043b0:	e8 91 43 00 00       	call   80108746 <allocuvm>
801043b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043bc:	75 41                	jne    801043ff <growproc+0x85>
            return -1;
801043be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c3:	eb 58                	jmp    8010441d <growproc+0xa3>
    } else if(n < 0){
801043c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043c9:	79 34                	jns    801043ff <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801043cb:	8b 55 08             	mov    0x8(%ebp),%edx
801043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d1:	01 c2                	add    %eax,%edx
801043d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d9:	8b 40 04             	mov    0x4(%eax),%eax
801043dc:	89 54 24 08          	mov    %edx,0x8(%esp)
801043e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801043e7:	89 04 24             	mov    %eax,(%esp)
801043ea:	e8 31 44 00 00       	call   80108820 <deallocuvm>
801043ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043f6:	75 07                	jne    801043ff <growproc+0x85>
            return -1;
801043f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043fd:	eb 1e                	jmp    8010441d <growproc+0xa3>
    }
    proc->sz = sz;
801043ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104408:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
8010440a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104410:	89 04 24             	mov    %eax,(%esp)
80104413:	e8 51 40 00 00       	call   80108469 <switchuvm>
    //cprintf("growproc return 0\n");
    return 0;
80104418:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010441d:	c9                   	leave  
8010441e:	c3                   	ret    

8010441f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
8010441f:	55                   	push   %ebp
80104420:	89 e5                	mov    %esp,%ebp
80104422:	57                   	push   %edi
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
80104428:	e8 2b fd ff ff       	call   80104158 <allocproc>
8010442d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104430:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104434:	75 0a                	jne    80104440 <fork+0x21>
        return -1;
80104436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443b:	e9 47 01 00 00       	jmp    80104587 <fork+0x168>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104440:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104446:	8b 10                	mov    (%eax),%edx
80104448:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010444e:	8b 40 04             	mov    0x4(%eax),%eax
80104451:	89 54 24 04          	mov    %edx,0x4(%esp)
80104455:	89 04 24             	mov    %eax,(%esp)
80104458:	e8 5f 45 00 00       	call   801089bc <copyuvm>
8010445d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104460:	89 42 04             	mov    %eax,0x4(%edx)
80104463:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104466:	8b 40 04             	mov    0x4(%eax),%eax
80104469:	85 c0                	test   %eax,%eax
8010446b:	75 2c                	jne    80104499 <fork+0x7a>
        kfree(np->kstack);
8010446d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104470:	8b 40 08             	mov    0x8(%eax),%eax
80104473:	89 04 24             	mov    %eax,(%esp)
80104476:	e8 ee e5 ff ff       	call   80102a69 <kfree>
        np->kstack = 0;
8010447b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010447e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
80104485:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104488:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
8010448f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104494:	e9 ee 00 00 00       	jmp    80104587 <fork+0x168>
    }
    np->sz = proc->sz;
80104499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449f:	8b 10                	mov    (%eax),%edx
801044a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044a4:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801044a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044b0:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
801044b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044b6:	8b 50 18             	mov    0x18(%eax),%edx
801044b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044bf:	8b 40 18             	mov    0x18(%eax),%eax
801044c2:	89 c3                	mov    %eax,%ebx
801044c4:	b8 13 00 00 00       	mov    $0x13,%eax
801044c9:	89 d7                	mov    %edx,%edi
801044cb:	89 de                	mov    %ebx,%esi
801044cd:	89 c1                	mov    %eax,%ecx
801044cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
801044d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044d4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801044db:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801044de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e1:	8b 40 18             	mov    0x18(%eax),%eax
801044e4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
801044eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801044f2:	eb 3d                	jmp    80104531 <fork+0x112>
        if(proc->ofile[i])
801044f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044fd:	83 c2 08             	add    $0x8,%edx
80104500:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104504:	85 c0                	test   %eax,%eax
80104506:	74 25                	je     8010452d <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
80104508:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104511:	83 c2 08             	add    $0x8,%edx
80104514:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104518:	89 04 24             	mov    %eax,(%esp)
8010451b:	e8 86 ca ff ff       	call   80100fa6 <filedup>
80104520:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104526:	83 c1 08             	add    $0x8,%ecx
80104529:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
8010452d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104531:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104535:	7e bd                	jle    801044f4 <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104537:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010453d:	8b 40 68             	mov    0x68(%eax),%eax
80104540:	89 04 24             	mov    %eax,(%esp)
80104543:	e8 01 d3 ff ff       	call   80101849 <idup>
80104548:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010454b:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
8010454e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104551:	8b 40 10             	mov    0x10(%eax),%eax
80104554:	89 45 dc             	mov    %eax,-0x24(%ebp)
    np->state = RUNNABLE;
80104557:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010455a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104561:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104567:	8d 50 6c             	lea    0x6c(%eax),%edx
8010456a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010456d:	83 c0 6c             	add    $0x6c,%eax
80104570:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104577:	00 
80104578:	89 54 24 04          	mov    %edx,0x4(%esp)
8010457c:	89 04 24             	mov    %eax,(%esp)
8010457f:	e8 ac 13 00 00       	call   80105930 <safestrcpy>
    //cprintf("fork no ERR\n");
    return pid;
80104584:	8b 45 dc             	mov    -0x24(%ebp),%eax

}
80104587:	83 c4 2c             	add    $0x2c,%esp
8010458a:	5b                   	pop    %ebx
8010458b:	5e                   	pop    %esi
8010458c:	5f                   	pop    %edi
8010458d:	5d                   	pop    %ebp
8010458e:	c3                   	ret    

8010458f <init_q2>:


//////////////////////////////////////////////////////////////////////
uint initedQ = 0;
void init_q2(struct queue2 *q){
8010458f:	55                   	push   %ebp
80104590:	89 e5                	mov    %esp,%ebp
    q->size = 0;
80104592:	8b 45 08             	mov    0x8(%ebp),%eax
80104595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
8010459b:	8b 45 08             	mov    0x8(%ebp),%eax
8010459e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
801045a5:	8b 45 08             	mov    0x8(%ebp),%eax
801045a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045af:	5d                   	pop    %ebp
801045b0:	c3                   	ret    

801045b1 <add_q2>:
void add_q2(struct queue2 *q, struct proc *v){
801045b1:	55                   	push   %ebp
801045b2:	89 e5                	mov    %esp,%ebp
801045b4:	83 ec 18             	sub    $0x18,%esp
    //struct node2 * n = kalloc2();
    struct node2 * n = kalloc2();
801045b7:	e8 93 e5 ff ff       	call   80102b4f <kalloc2>
801045bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
801045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
801045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801045cf:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
801045d1:	8b 45 08             	mov    0x8(%ebp),%eax
801045d4:	8b 40 04             	mov    0x4(%eax),%eax
801045d7:	85 c0                	test   %eax,%eax
801045d9:	75 0b                	jne    801045e6 <add_q2+0x35>
        q->head = n;
801045db:	8b 45 08             	mov    0x8(%ebp),%eax
801045de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e1:	89 50 04             	mov    %edx,0x4(%eax)
801045e4:	eb 0c                	jmp    801045f2 <add_q2+0x41>
    }else{
        q->tail->next = n;
801045e6:	8b 45 08             	mov    0x8(%ebp),%eax
801045e9:	8b 40 08             	mov    0x8(%eax),%eax
801045ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ef:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
801045f2:	8b 45 08             	mov    0x8(%ebp),%eax
801045f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f8:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
801045fb:	8b 45 08             	mov    0x8(%ebp),%eax
801045fe:	8b 00                	mov    (%eax),%eax
80104600:	8d 50 01             	lea    0x1(%eax),%edx
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
80104606:	89 10                	mov    %edx,(%eax)
}
80104608:	c9                   	leave  
80104609:	c3                   	ret    

8010460a <empty_q2>:
int empty_q2(struct queue2 *q){
8010460a:	55                   	push   %ebp
8010460b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
8010460d:	8b 45 08             	mov    0x8(%ebp),%eax
80104610:	8b 00                	mov    (%eax),%eax
80104612:	85 c0                	test   %eax,%eax
80104614:	75 07                	jne    8010461d <empty_q2+0x13>
        return 1;
80104616:	b8 01 00 00 00       	mov    $0x1,%eax
8010461b:	eb 05                	jmp    80104622 <empty_q2+0x18>
    else
        return 0;
8010461d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    

80104624 <pop_q2>:
struct proc* pop_q2(struct queue2 *q){
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	83 ec 28             	sub    $0x28,%esp
    struct proc *val;
    struct node2 *destroy;
    if(!empty_q2(q)){
8010462a:	8b 45 08             	mov    0x8(%ebp),%eax
8010462d:	89 04 24             	mov    %eax,(%esp)
80104630:	e8 d5 ff ff ff       	call   8010460a <empty_q2>
80104635:	85 c0                	test   %eax,%eax
80104637:	75 5d                	jne    80104696 <pop_q2+0x72>
       val = q->head->value; 
80104639:	8b 45 08             	mov    0x8(%ebp),%eax
8010463c:	8b 40 04             	mov    0x4(%eax),%eax
8010463f:	8b 00                	mov    (%eax),%eax
80104641:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
80104644:	8b 45 08             	mov    0x8(%ebp),%eax
80104647:	8b 40 04             	mov    0x4(%eax),%eax
8010464a:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
8010464d:	8b 45 08             	mov    0x8(%ebp),%eax
80104650:	8b 40 04             	mov    0x4(%eax),%eax
80104653:	8b 50 04             	mov    0x4(%eax),%edx
80104656:	8b 45 08             	mov    0x8(%ebp),%eax
80104659:	89 50 04             	mov    %edx,0x4(%eax)
       kfree2(destroy);
8010465c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010465f:	89 04 24             	mov    %eax,(%esp)
80104662:	e8 35 e5 ff ff       	call   80102b9c <kfree2>
       q->size--;
80104667:	8b 45 08             	mov    0x8(%ebp),%eax
8010466a:	8b 00                	mov    (%eax),%eax
8010466c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010466f:	8b 45 08             	mov    0x8(%ebp),%eax
80104672:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
80104674:	8b 45 08             	mov    0x8(%ebp),%eax
80104677:	8b 00                	mov    (%eax),%eax
80104679:	85 c0                	test   %eax,%eax
8010467b:	75 14                	jne    80104691 <pop_q2+0x6d>
            q->head = 0;
8010467d:	8b 45 08             	mov    0x8(%ebp),%eax
80104680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
80104687:	8b 45 08             	mov    0x8(%ebp),%eax
8010468a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	eb 05                	jmp    8010469b <pop_q2+0x77>
    }
    return 0;
80104696:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010469b:	c9                   	leave  
8010469c:	c3                   	ret    

8010469d <clone>:
/////////////////////////////////////////////////////////////////////////


//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
8010469d:	55                   	push   %ebp
8010469e:	89 e5                	mov    %esp,%ebp
801046a0:	57                   	push   %edi
801046a1:	56                   	push   %esi
801046a2:	53                   	push   %ebx
801046a3:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
801046a9:	e8 aa fa ff ff       	call   80104158 <allocproc>
801046ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
801046b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801046b5:	75 0a                	jne    801046c1 <clone+0x24>
        return -1;
801046b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046bc:	e9 f4 01 00 00       	jmp    801048b5 <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
801046c1:	8b 45 08             	mov    0x8(%ebp),%eax
801046c4:	25 ff 0f 00 00       	and    $0xfff,%eax
801046c9:	85 c0                	test   %eax,%eax
801046cb:	75 0c                	jne    801046d9 <clone+0x3c>
801046cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046d1:	74 06                	je     801046d9 <clone+0x3c>
801046d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801046d7:	75 0a                	jne    801046e3 <clone+0x46>
        return -1;
801046d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046de:	e9 d2 01 00 00       	jmp    801048b5 <clone+0x218>

    np->pgdir = proc->pgdir;
801046e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e9:	8b 50 04             	mov    0x4(%eax),%edx
801046ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ef:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
801046f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f8:	8b 10                	mov    (%eax),%edx
801046fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046fd:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801046ff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104706:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104709:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
8010470c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010470f:	8b 50 18             	mov    0x18(%eax),%edx
80104712:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104718:	8b 40 18             	mov    0x18(%eax),%eax
8010471b:	89 c3                	mov    %eax,%ebx
8010471d:	b8 13 00 00 00       	mov    $0x13,%eax
80104722:	89 d7                	mov    %edx,%edi
80104724:	89 de                	mov    %ebx,%esi
80104726:	89 c1                	mov    %eax,%ecx
80104728:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
8010472a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010472d:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104734:	00 00 00 
    pid = np->pid;
80104737:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010473a:	8b 40 10             	mov    0x10(%eax),%eax
8010473d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
80104740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104746:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
80104749:	eb 09                	jmp    80104754 <clone+0xb7>
        pp = pp->parent;
8010474b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474e:	8b 40 14             	mov    0x14(%eax),%eax
80104751:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
80104754:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104757:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010475d:	83 f8 01             	cmp    $0x1,%eax
80104760:	74 e9                	je     8010474b <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
80104762:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104768:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
8010476b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104772:	eb 3d                	jmp    801047b1 <clone+0x114>
        if(proc->ofile[i])
80104774:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010477d:	83 c2 08             	add    $0x8,%edx
80104780:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104784:	85 c0                	test   %eax,%eax
80104786:	74 25                	je     801047ad <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
80104788:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104791:	83 c2 08             	add    $0x8,%edx
80104794:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104798:	89 04 24             	mov    %eax,(%esp)
8010479b:	e8 06 c8 ff ff       	call   80100fa6 <filedup>
801047a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047a6:	83 c1 08             	add    $0x8,%ecx
801047a9:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
801047ad:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047b1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047b5:	7e bd                	jle    80104774 <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801047b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047ba:	8b 40 18             	mov    0x18(%eax),%eax
801047bd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
801047c4:	8b 45 08             	mov    0x8(%ebp),%eax
801047c7:	05 00 10 00 00       	add    $0x1000,%eax
801047cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    }
    add_q2(thQ, np);
    */
//modify here <<<<<

    np->tf->ebp = sp;
801047cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047d2:	8b 40 18             	mov    0x18(%eax),%eax
801047d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801047d8:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
801047db:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
801047e2:	ff ff ff 
    ustack[1] = arg;
801047e5:	8b 45 14             	mov    0x14(%ebp),%eax
801047e8:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
801047ee:	83 6d d4 08          	subl   $0x8,-0x2c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
801047f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047f5:	8b 40 04             	mov    0x4(%eax),%eax
801047f8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
801047ff:	00 
80104800:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
80104806:	89 54 24 08          	mov    %edx,0x8(%esp)
8010480a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010480d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104811:	89 04 24             	mov    %eax,(%esp)
80104814:	e8 22 43 00 00       	call   80108b3b <copyout>
80104819:	85 c0                	test   %eax,%eax
8010481b:	79 16                	jns    80104833 <clone+0x196>
        cprintf("push arg fails\n");
8010481d:	c7 04 24 d7 8e 10 80 	movl   $0x80108ed7,(%esp)
80104824:	e8 77 bb ff ff       	call   801003a0 <cprintf>
        return -1;
80104829:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482e:	e9 82 00 00 00       	jmp    801048b5 <clone+0x218>
    }

    np->tf->eip = routine;
80104833:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104836:	8b 40 18             	mov    0x18(%eax),%eax
80104839:	8b 55 10             	mov    0x10(%ebp),%edx
8010483c:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
8010483f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104842:	8b 40 18             	mov    0x18(%eax),%eax
80104845:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104848:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
8010484b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104851:	8b 40 68             	mov    0x68(%eax),%eax
80104854:	89 04 24             	mov    %eax,(%esp)
80104857:	e8 ed cf ff ff       	call   80101849 <idup>
8010485c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010485f:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
80104862:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104865:	89 04 24             	mov    %eax,(%esp)
80104868:	e8 fc 3b 00 00       	call   80108469 <switchuvm>

     acquire(&ptable.lock);
8010486d:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104874:	e8 b3 0b 00 00       	call   8010542c <acquire>
    np->state = RUNNABLE;
80104879:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010487c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    // if (!initedQ) {
    //     init_q2(thQ);
    //     initedQ ++;
    // }
    // add_q2(thQ, np);
     release(&ptable.lock);
80104883:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
8010488a:	e8 47 0c 00 00       	call   801054d6 <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
8010488f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104895:	8d 50 6c             	lea    0x6c(%eax),%edx
80104898:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010489b:	83 c0 6c             	add    $0x6c,%eax
8010489e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801048a5:	00 
801048a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801048aa:	89 04 24             	mov    %eax,(%esp)
801048ad:	e8 7e 10 00 00       	call   80105930 <safestrcpy>


    return pid;
801048b2:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
801048b5:	81 c4 bc 00 00 00    	add    $0xbc,%esp
801048bb:	5b                   	pop    %ebx
801048bc:	5e                   	pop    %esi
801048bd:	5f                   	pop    %edi
801048be:	5d                   	pop    %ebp
801048bf:	c3                   	ret    

801048c0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
801048c6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048cd:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801048d2:	39 c2                	cmp    %eax,%edx
801048d4:	75 0c                	jne    801048e2 <exit+0x22>
        panic("init exiting");
801048d6:	c7 04 24 e7 8e 10 80 	movl   $0x80108ee7,(%esp)
801048dd:	e8 58 bc ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801048e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048e9:	eb 44                	jmp    8010492f <exit+0x6f>
        if(proc->ofile[fd]){
801048eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048f4:	83 c2 08             	add    $0x8,%edx
801048f7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048fb:	85 c0                	test   %eax,%eax
801048fd:	74 2c                	je     8010492b <exit+0x6b>
            fileclose(proc->ofile[fd]);
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104908:	83 c2 08             	add    $0x8,%edx
8010490b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010490f:	89 04 24             	mov    %eax,(%esp)
80104912:	e8 d7 c6 ff ff       	call   80100fee <fileclose>
            proc->ofile[fd] = 0;
80104917:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104920:	83 c2 08             	add    $0x8,%edx
80104923:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010492a:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010492b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010492f:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104933:	7e b6                	jle    801048eb <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
80104935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493b:	8b 40 68             	mov    0x68(%eax),%eax
8010493e:	89 04 24             	mov    %eax,(%esp)
80104941:	e8 e8 d0 ff ff       	call   80101a2e <iput>
    proc->cwd = 0;
80104946:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104953:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
8010495a:	e8 cd 0a 00 00       	call   8010542c <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
8010495f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104965:	8b 40 14             	mov    0x14(%eax),%eax
80104968:	89 04 24             	mov    %eax,(%esp)
8010496b:	e8 c8 04 00 00       	call   80104e38 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104970:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104977:	eb 3b                	jmp    801049b4 <exit+0xf4>
        if(p->parent == proc){
80104979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497c:	8b 50 14             	mov    0x14(%eax),%edx
8010497f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104985:	39 c2                	cmp    %eax,%edx
80104987:	75 24                	jne    801049ad <exit+0xed>
            p->parent = initproc;
80104989:	8b 15 6c c6 10 80    	mov    0x8010c66c,%edx
8010498f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104992:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80104995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104998:	8b 40 0c             	mov    0xc(%eax),%eax
8010499b:	83 f8 05             	cmp    $0x5,%eax
8010499e:	75 0d                	jne    801049ad <exit+0xed>
                wakeup1(initproc);
801049a0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801049a5:	89 04 24             	mov    %eax,(%esp)
801049a8:	e8 8b 04 00 00       	call   80104e38 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ad:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801049b4:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
801049bb:	72 bc                	jb     80104979 <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
801049bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c3:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
801049ca:	e8 95 02 00 00       	call   80104c64 <sched>
    panic("zombie exit");
801049cf:	c7 04 24 f4 8e 10 80 	movl   $0x80108ef4,(%esp)
801049d6:	e8 5f bb ff ff       	call   8010053a <panic>

801049db <texit>:
}
    void
texit(void)
{
801049db:	55                   	push   %ebp
801049dc:	89 e5                	mov    %esp,%ebp
801049de:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
801049e1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049e8:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801049ed:	39 c2                	cmp    %eax,%edx
801049ef:	75 0c                	jne    801049fd <texit+0x22>
        panic("init exiting");
801049f1:	c7 04 24 e7 8e 10 80 	movl   $0x80108ee7,(%esp)
801049f8:	e8 3d bb ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801049fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a04:	eb 44                	jmp    80104a4a <texit+0x6f>
        if(proc->ofile[fd]){
80104a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a0f:	83 c2 08             	add    $0x8,%edx
80104a12:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a16:	85 c0                	test   %eax,%eax
80104a18:	74 2c                	je     80104a46 <texit+0x6b>
            fileclose(proc->ofile[fd]);
80104a1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a23:	83 c2 08             	add    $0x8,%edx
80104a26:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a2a:	89 04 24             	mov    %eax,(%esp)
80104a2d:	e8 bc c5 ff ff       	call   80100fee <fileclose>
            proc->ofile[fd] = 0;
80104a32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a3b:	83 c2 08             	add    $0x8,%edx
80104a3e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a45:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104a46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104a4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a4e:	7e b6                	jle    80104a06 <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
80104a50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a56:	8b 40 68             	mov    0x68(%eax),%eax
80104a59:	89 04 24             	mov    %eax,(%esp)
80104a5c:	e8 cd cf ff ff       	call   80101a2e <iput>
    proc->cwd = 0;
80104a61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a67:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104a6e:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104a75:	e8 b2 09 00 00       	call   8010542c <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104a7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a80:	8b 40 14             	mov    0x14(%eax),%eax
80104a83:	89 04 24             	mov    %eax,(%esp)
80104a86:	e8 ad 03 00 00       	call   80104e38 <wakeup1>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a91:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104a98:	e8 c7 01 00 00       	call   80104c64 <sched>
    panic("zombie exit");
80104a9d:	c7 04 24 f4 8e 10 80 	movl   $0x80108ef4,(%esp)
80104aa4:	e8 91 ba ff ff       	call   8010053a <panic>

80104aa9 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80104aa9:	55                   	push   %ebp
80104aaa:	89 e5                	mov    %esp,%ebp
80104aac:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104aaf:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104ab6:	e8 71 09 00 00       	call   8010542c <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104abb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac2:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104ac9:	e9 ab 00 00 00       	jmp    80104b79 <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
80104ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad1:	8b 50 14             	mov    0x14(%eax),%edx
80104ad4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ada:	39 c2                	cmp    %eax,%edx
80104adc:	74 05                	je     80104ae3 <wait+0x3a>
                continue;
80104ade:	e9 8f 00 00 00       	jmp    80104b72 <wait+0xc9>
            havekids = 1;
80104ae3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
80104aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aed:	8b 40 0c             	mov    0xc(%eax),%eax
80104af0:	83 f8 05             	cmp    $0x5,%eax
80104af3:	75 7d                	jne    80104b72 <wait+0xc9>
                // Found one.
                pid = p->pid;
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	8b 40 10             	mov    0x10(%eax),%eax
80104afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
80104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b01:	8b 40 08             	mov    0x8(%eax),%eax
80104b04:	89 04 24             	mov    %eax,(%esp)
80104b07:	e8 5d df ff ff       	call   80102a69 <kfree>
                p->kstack = 0;
80104b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
80104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b19:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b1f:	83 f8 01             	cmp    $0x1,%eax
80104b22:	74 0e                	je     80104b32 <wait+0x89>
                    freevm(p->pgdir);
80104b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b27:	8b 40 04             	mov    0x4(%eax),%eax
80104b2a:	89 04 24             	mov    %eax,(%esp)
80104b2d:	e8 aa 3d 00 00       	call   801088dc <freevm>
                }
                p->state = UNUSED;
80104b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
80104b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80104b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b49:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b53:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104b61:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104b68:	e8 69 09 00 00       	call   801054d6 <release>
                return pid;
80104b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b70:	eb 55                	jmp    80104bc7 <wait+0x11e>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b72:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104b79:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104b80:	0f 82 48 ff ff ff    	jb     80104ace <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80104b86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b8a:	74 0d                	je     80104b99 <wait+0xf0>
80104b8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b92:	8b 40 24             	mov    0x24(%eax),%eax
80104b95:	85 c0                	test   %eax,%eax
80104b97:	74 13                	je     80104bac <wait+0x103>
            release(&ptable.lock);
80104b99:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104ba0:	e8 31 09 00 00       	call   801054d6 <release>
            return -1;
80104ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104baa:	eb 1b                	jmp    80104bc7 <wait+0x11e>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104bac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb2:	c7 44 24 04 60 0f 11 	movl   $0x80110f60,0x4(%esp)
80104bb9:	80 
80104bba:	89 04 24             	mov    %eax,(%esp)
80104bbd:	e8 db 01 00 00       	call   80104d9d <sleep>
    }
80104bc2:	e9 f4 fe ff ff       	jmp    80104abb <wait+0x12>
}
80104bc7:	c9                   	leave  
80104bc8:	c3                   	ret    

80104bc9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104bc9:	55                   	push   %ebp
80104bca:	89 e5                	mov    %esp,%ebp
80104bcc:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104bcf:	e8 c6 f4 ff ff       	call   8010409a <sti>
        //cprintf("scheduler Next PROC\n");
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104bd4:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104bdb:	e8 4c 08 00 00       	call   8010542c <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be0:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104be7:	eb 61                	jmp    80104c4a <scheduler+0x81>
            if(p->state != RUNNABLE)
80104be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bec:	8b 40 0c             	mov    0xc(%eax),%eax
80104bef:	83 f8 03             	cmp    $0x3,%eax
80104bf2:	74 02                	je     80104bf6 <scheduler+0x2d>
                continue;
80104bf4:	eb 4d                	jmp    80104c43 <scheduler+0x7a>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80104bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf9:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
80104bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c02:	89 04 24             	mov    %eax,(%esp)
80104c05:	e8 5f 38 00 00       	call   80108469 <switchuvm>
            p->state = RUNNING;
80104c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0d:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104c14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1a:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c1d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c24:	83 c2 04             	add    $0x4,%edx
80104c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c2b:	89 14 24             	mov    %edx,(%esp)
80104c2e:	e8 6e 0d 00 00       	call   801059a1 <swtch>
            switchkvm();
80104c33:	e8 14 38 00 00       	call   8010844c <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104c38:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c3f:	00 00 00 00 
        // Enable interrupts on this processor.
        sti();
        //cprintf("scheduler Next PROC\n");
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c43:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104c4a:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104c51:	72 96                	jb     80104be9 <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104c53:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104c5a:	e8 77 08 00 00       	call   801054d6 <release>

    }
80104c5f:	e9 6b ff ff ff       	jmp    80104bcf <scheduler+0x6>

80104c64 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104c64:	55                   	push   %ebp
80104c65:	89 e5                	mov    %esp,%ebp
80104c67:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104c6a:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104c71:	e8 70 09 00 00       	call   801055e6 <holding>
80104c76:	85 c0                	test   %eax,%eax
80104c78:	75 0c                	jne    80104c86 <sched+0x22>
        panic("sched ptable.lock");
80104c7a:	c7 04 24 00 8f 10 80 	movl   $0x80108f00,(%esp)
80104c81:	e8 b4 b8 ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104c86:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c8c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c92:	83 f8 01             	cmp    $0x1,%eax
80104c95:	74 35                	je     80104ccc <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104c97:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c9d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104ca3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca9:	8b 40 10             	mov    0x10(%eax),%eax
80104cac:	89 54 24 08          	mov    %edx,0x8(%esp)
80104cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb4:	c7 04 24 14 8f 10 80 	movl   $0x80108f14,(%esp)
80104cbb:	e8 e0 b6 ff ff       	call   801003a0 <cprintf>
        panic("sched locks");
80104cc0:	c7 04 24 33 8f 10 80 	movl   $0x80108f33,(%esp)
80104cc7:	e8 6e b8 ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104ccc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd2:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd5:	83 f8 04             	cmp    $0x4,%eax
80104cd8:	75 0c                	jne    80104ce6 <sched+0x82>
        panic("sched running");
80104cda:	c7 04 24 3f 8f 10 80 	movl   $0x80108f3f,(%esp)
80104ce1:	e8 54 b8 ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104ce6:	e8 9f f3 ff ff       	call   8010408a <readeflags>
80104ceb:	25 00 02 00 00       	and    $0x200,%eax
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	74 0c                	je     80104d00 <sched+0x9c>
        panic("sched interruptible");
80104cf4:	c7 04 24 4d 8f 10 80 	movl   $0x80108f4d,(%esp)
80104cfb:	e8 3a b8 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104d00:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d06:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104d0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d15:	8b 40 04             	mov    0x4(%eax),%eax
80104d18:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d1f:	83 c2 1c             	add    $0x1c,%edx
80104d22:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d26:	89 14 24             	mov    %edx,(%esp)
80104d29:	e8 73 0c 00 00       	call   801059a1 <swtch>
    cpu->intena = intena;
80104d2e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d37:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d3d:	c9                   	leave  
80104d3e:	c3                   	ret    

80104d3f <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104d3f:	55                   	push   %ebp
80104d40:	89 e5                	mov    %esp,%ebp
80104d42:	83 ec 18             	sub    $0x18,%esp
    //cprintf("Yielded\n");
    acquire(&ptable.lock);  //DOC: yieldlock
80104d45:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104d4c:	e8 db 06 00 00       	call   8010542c <acquire>
    proc->state = RUNNABLE;
80104d51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104d5e:	e8 01 ff ff ff       	call   80104c64 <sched>
    release(&ptable.lock);
80104d63:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104d6a:	e8 67 07 00 00       	call   801054d6 <release>
}
80104d6f:	c9                   	leave  
80104d70:	c3                   	ret    

80104d71 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104d71:	55                   	push   %ebp
80104d72:	89 e5                	mov    %esp,%ebp
80104d74:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104d77:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104d7e:	e8 53 07 00 00       	call   801054d6 <release>

    if (first) {
80104d83:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104d88:	85 c0                	test   %eax,%eax
80104d8a:	74 0f                	je     80104d9b <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104d8c:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104d93:	00 00 00 
        initlog();
80104d96:	e8 42 e3 ff ff       	call   801030dd <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104d9b:	c9                   	leave  
80104d9c:	c3                   	ret    

80104d9d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104d9d:	55                   	push   %ebp
80104d9e:	89 e5                	mov    %esp,%ebp
80104da0:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104da3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da9:	85 c0                	test   %eax,%eax
80104dab:	75 0c                	jne    80104db9 <sleep+0x1c>
        panic("sleep");
80104dad:	c7 04 24 61 8f 10 80 	movl   $0x80108f61,(%esp)
80104db4:	e8 81 b7 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104dbd:	75 0c                	jne    80104dcb <sleep+0x2e>
        panic("sleep without lk");
80104dbf:	c7 04 24 67 8f 10 80 	movl   $0x80108f67,(%esp)
80104dc6:	e8 6f b7 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104dcb:	81 7d 0c 60 0f 11 80 	cmpl   $0x80110f60,0xc(%ebp)
80104dd2:	74 17                	je     80104deb <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104dd4:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104ddb:	e8 4c 06 00 00       	call   8010542c <acquire>
        release(lk);
80104de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104de3:	89 04 24             	mov    %eax,(%esp)
80104de6:	e8 eb 06 00 00       	call   801054d6 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104deb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df1:	8b 55 08             	mov    0x8(%ebp),%edx
80104df4:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104df7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dfd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104e04:	e8 5b fe ff ff       	call   80104c64 <sched>

    // Tidy up.
    proc->chan = 0;
80104e09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104e16:	81 7d 0c 60 0f 11 80 	cmpl   $0x80110f60,0xc(%ebp)
80104e1d:	74 17                	je     80104e36 <sleep+0x99>
        release(&ptable.lock);
80104e1f:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104e26:	e8 ab 06 00 00       	call   801054d6 <release>
        acquire(lk);
80104e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e2e:	89 04 24             	mov    %eax,(%esp)
80104e31:	e8 f6 05 00 00       	call   8010542c <acquire>
    }
}
80104e36:	c9                   	leave  
80104e37:	c3                   	ret    

80104e38 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104e38:	55                   	push   %ebp
80104e39:	89 e5                	mov    %esp,%ebp
80104e3b:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e3e:	c7 45 fc 94 0f 11 80 	movl   $0x80110f94,-0x4(%ebp)
80104e45:	eb 27                	jmp    80104e6e <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e4d:	83 f8 02             	cmp    $0x2,%eax
80104e50:	75 15                	jne    80104e67 <wakeup1+0x2f>
80104e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e55:	8b 40 20             	mov    0x20(%eax),%eax
80104e58:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e5b:	75 0a                	jne    80104e67 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e67:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104e6e:	81 7d fc 94 30 11 80 	cmpl   $0x80113094,-0x4(%ebp)
80104e75:	72 d0                	jb     80104e47 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104e77:	c9                   	leave  
80104e78:	c3                   	ret    

80104e79 <twakeup>:

void 
twakeup(int tid){
80104e79:	55                   	push   %ebp
80104e7a:	89 e5                	mov    %esp,%ebp
80104e7c:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104e7f:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104e86:	e8 a1 05 00 00       	call   8010542c <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e8b:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104e92:	eb 36                	jmp    80104eca <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e97:	8b 40 0c             	mov    0xc(%eax),%eax
80104e9a:	83 f8 02             	cmp    $0x2,%eax
80104e9d:	75 24                	jne    80104ec3 <twakeup+0x4a>
80104e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea2:	8b 40 10             	mov    0x10(%eax),%eax
80104ea5:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ea8:	75 19                	jne    80104ec3 <twakeup+0x4a>
80104eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ead:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104eb3:	83 f8 01             	cmp    $0x1,%eax
80104eb6:	75 0b                	jne    80104ec3 <twakeup+0x4a>
            wakeup1(p);
80104eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ebb:	89 04 24             	mov    %eax,(%esp)
80104ebe:	e8 75 ff ff ff       	call   80104e38 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ec3:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104eca:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104ed1:	72 c1                	jb     80104e94 <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104ed3:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104eda:	e8 f7 05 00 00       	call   801054d6 <release>
}
80104edf:	c9                   	leave  
80104ee0:	c3                   	ret    

80104ee1 <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104ee1:	55                   	push   %ebp
80104ee2:	89 e5                	mov    %esp,%ebp
80104ee4:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104ee7:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104eee:	e8 39 05 00 00       	call   8010542c <acquire>
    wakeup1(chan);
80104ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef6:	89 04 24             	mov    %eax,(%esp)
80104ef9:	e8 3a ff ff ff       	call   80104e38 <wakeup1>
    release(&ptable.lock);
80104efe:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f05:	e8 cc 05 00 00       	call   801054d6 <release>
}
80104f0a:	c9                   	leave  
80104f0b:	c3                   	ret    

80104f0c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104f0c:	55                   	push   %ebp
80104f0d:	89 e5                	mov    %esp,%ebp
80104f0f:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104f12:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f19:	e8 0e 05 00 00       	call   8010542c <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f1e:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104f25:	eb 44                	jmp    80104f6b <kill+0x5f>
        if(p->pid == pid){
80104f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2a:	8b 40 10             	mov    0x10(%eax),%eax
80104f2d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f30:	75 32                	jne    80104f64 <kill+0x58>
            p->killed = 1;
80104f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f35:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104f42:	83 f8 02             	cmp    $0x2,%eax
80104f45:	75 0a                	jne    80104f51 <kill+0x45>
                p->state = RUNNABLE;
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104f51:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f58:	e8 79 05 00 00       	call   801054d6 <release>
            return 0;
80104f5d:	b8 00 00 00 00       	mov    $0x0,%eax
80104f62:	eb 21                	jmp    80104f85 <kill+0x79>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f64:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104f6b:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104f72:	72 b3                	jb     80104f27 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104f74:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f7b:	e8 56 05 00 00       	call   801054d6 <release>
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    

80104f87 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104f87:	55                   	push   %ebp
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8d:	c7 45 f0 94 0f 11 80 	movl   $0x80110f94,-0x10(%ebp)
80104f94:	e9 d9 00 00 00       	jmp    80105072 <procdump+0xeb>
        if(p->state == UNUSED)
80104f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	75 05                	jne    80104fa8 <procdump+0x21>
            continue;
80104fa3:	e9 c3 00 00 00       	jmp    8010506b <procdump+0xe4>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fab:	8b 40 0c             	mov    0xc(%eax),%eax
80104fae:	83 f8 05             	cmp    $0x5,%eax
80104fb1:	77 23                	ja     80104fd6 <procdump+0x4f>
80104fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb6:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb9:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	74 12                	je     80104fd6 <procdump+0x4f>
            state = states[p->state];
80104fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc7:	8b 40 0c             	mov    0xc(%eax),%eax
80104fca:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104fd4:	eb 07                	jmp    80104fdd <procdump+0x56>
        else
            state = "???";
80104fd6:	c7 45 ec 78 8f 10 80 	movl   $0x80108f78,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe0:	8d 50 6c             	lea    0x6c(%eax),%edx
80104fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe6:	8b 40 10             	mov    0x10(%eax),%eax
80104fe9:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104fed:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ff0:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff8:	c7 04 24 7c 8f 10 80 	movl   $0x80108f7c,(%esp)
80104fff:	e8 9c b3 ff ff       	call   801003a0 <cprintf>
        if(p->state == SLEEPING){
80105004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105007:	8b 40 0c             	mov    0xc(%eax),%eax
8010500a:	83 f8 02             	cmp    $0x2,%eax
8010500d:	75 50                	jne    8010505f <procdump+0xd8>
            getcallerpcs((uint*)p->context->ebp+2, pc);
8010500f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105012:	8b 40 1c             	mov    0x1c(%eax),%eax
80105015:	8b 40 0c             	mov    0xc(%eax),%eax
80105018:	83 c0 08             	add    $0x8,%eax
8010501b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010501e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105022:	89 04 24             	mov    %eax,(%esp)
80105025:	e8 43 05 00 00       	call   8010556d <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
8010502a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105031:	eb 1b                	jmp    8010504e <procdump+0xc7>
                cprintf(" %p", pc[i]);
80105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105036:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010503a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010503e:	c7 04 24 85 8f 10 80 	movl   $0x80108f85,(%esp)
80105045:	e8 56 b3 ff ff       	call   801003a0 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
8010504a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010504e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105052:	7f 0b                	jg     8010505f <procdump+0xd8>
80105054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105057:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010505b:	85 c0                	test   %eax,%eax
8010505d:	75 d4                	jne    80105033 <procdump+0xac>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
8010505f:	c7 04 24 89 8f 10 80 	movl   $0x80108f89,(%esp)
80105066:	e8 35 b3 ff ff       	call   801003a0 <cprintf>
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010506b:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80105072:	81 7d f0 94 30 11 80 	cmpl   $0x80113094,-0x10(%ebp)
80105079:	0f 82 1a ff ff ff    	jb     80104f99 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
8010507f:	c9                   	leave  
80105080:	c3                   	ret    

80105081 <tsleep>:

void tsleep(void){
80105081:	55                   	push   %ebp
80105082:	89 e5                	mov    %esp,%ebp
80105084:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
80105087:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
8010508e:	e8 99 03 00 00       	call   8010542c <acquire>
    sleep(proc, &ptable.lock);
80105093:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105099:	c7 44 24 04 60 0f 11 	movl   $0x80110f60,0x4(%esp)
801050a0:	80 
801050a1:	89 04 24             	mov    %eax,(%esp)
801050a4:	e8 f4 fc ff ff       	call   80104d9d <sleep>
    release(&ptable.lock);
801050a9:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801050b0:	e8 21 04 00 00       	call   801054d6 <release>

}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    

801050b7 <lock_acquire2>:
//     struct node2 * tail;
// };
// struct queue2 *thQ;


void lock_acquire2(struct spinlock *lock){
801050b7:	55                   	push   %ebp
801050b8:	89 e5                	mov    %esp,%ebp
801050ba:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
801050bd:	90                   	nop
801050be:	8b 45 08             	mov    0x8(%ebp),%eax
801050c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801050c8:	00 
801050c9:	89 04 24             	mov    %eax,(%esp)
801050cc:	e8 cf ef ff ff       	call   801040a0 <xchg>
801050d1:	85 c0                	test   %eax,%eax
801050d3:	75 e9                	jne    801050be <lock_acquire2+0x7>
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    

801050d7 <lock_release2>:
void lock_release2(struct spinlock *lock){
801050d7:	55                   	push   %ebp
801050d8:	89 e5                	mov    %esp,%ebp
801050da:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
801050dd:	8b 45 08             	mov    0x8(%ebp),%eax
801050e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050e7:	00 
801050e8:	89 04 24             	mov    %eax,(%esp)
801050eb:	e8 b0 ef ff ff       	call   801040a0 <xchg>
}
801050f0:	c9                   	leave  
801050f1:	c3                   	ret    

801050f2 <thread_yield>:
//////////////////////////////////

//////////////////////////////////
void thread_yield(void){
801050f2:	55                   	push   %ebp
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	83 ec 38             	sub    $0x38,%esp
    cprintf("Curr %d%d%d\n", proc->isthread, proc->state, proc->pid);
801050f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050fe:	8b 48 10             	mov    0x10(%eax),%ecx
80105101:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105107:	8b 50 0c             	mov    0xc(%eax),%edx
8010510a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105110:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105116:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010511a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010511e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105122:	c7 04 24 8b 8f 10 80 	movl   $0x80108f8b,(%esp)
80105129:	e8 72 b2 ff ff       	call   801003a0 <cprintf>
    //acquire(&ptable.lock);
    struct proc *p;
    struct proc *old;
    //struct proc *curr;
    int pid = proc->pid;
8010512e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105134:	8b 40 10             	mov    0x10(%eax),%eax
80105137:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int intena;
    if (!initedQ) {
8010513a:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010513f:	85 c0                	test   %eax,%eax
80105141:	75 1a                	jne    8010515d <thread_yield+0x6b>
        init_q2(thQ);
80105143:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105148:	89 04 24             	mov    %eax,(%esp)
8010514b:	e8 3f f4 ff ff       	call   8010458f <init_q2>
        initedQ ++;
80105150:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80105155:	83 c0 01             	add    $0x1,%eax
80105158:	a3 68 c6 10 80       	mov    %eax,0x8010c668
    //     //cprintf(" ACQUIRED\n");
    //     acq++;
    // }
    //else cprintf(" DID NOT ACQUIRE\n");
    
    if (!holding(&ptable.lock)) {
8010515d:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80105164:	e8 7d 04 00 00       	call   801055e6 <holding>
80105169:	85 c0                	test   %eax,%eax
8010516b:	75 1a                	jne    80105187 <thread_yield+0x95>
        //lock_acquire2(&ptable.lock);
        acquire(&ptable.lock); 
8010516d:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80105174:	e8 b3 02 00 00       	call   8010542c <acquire>
        cprintf(" ACQUIRED\n");
80105179:	c7 04 24 98 8f 10 80 	movl   $0x80108f98,(%esp)
80105180:	e8 1b b2 ff ff       	call   801003a0 <cprintf>
80105185:	eb 0c                	jmp    80105193 <thread_yield+0xa1>
    }
    else cprintf(" DID NOT ACQUIRE\n");
80105187:	c7 04 24 a3 8f 10 80 	movl   $0x80108fa3,(%esp)
8010518e:	e8 0d b2 ff ff       	call   801003a0 <cprintf>
    cprintf("QUEUE SIZE_1 %d\n", thQ->size);
80105193:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105198:	8b 00                	mov    (%eax),%eax
8010519a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519e:	c7 04 24 b5 8f 10 80 	movl   $0x80108fb5,(%esp)
801051a5:	e8 f6 b1 ff ff       	call   801003a0 <cprintf>
                break;
            }
        }
    }
    */
    p = pop_q2(thQ);
801051aa:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
801051af:	89 04 24             	mov    %eax,(%esp)
801051b2:	e8 6d f4 ff ff       	call   80104624 <pop_q2>
801051b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if ((p->pid) == (proc->pid)) {
801051ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bd:	8b 50 10             	mov    0x10(%eax),%edx
801051c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c6:	8b 40 10             	mov    0x10(%eax),%eax
801051c9:	39 c2                	cmp    %eax,%edx
801051cb:	75 10                	jne    801051dd <thread_yield+0xeb>
        p = pop_q2(thQ);
801051cd:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
801051d2:	89 04 24             	mov    %eax,(%esp)
801051d5:	e8 4a f4 ff ff       	call   80104624 <pop_q2>
801051da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    cprintf("Before %d going to %d%d%d\n",pid, p->isthread, p->state, p->pid);
801051dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e0:	8b 48 10             	mov    0x10(%eax),%ecx
801051e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e6:	8b 50 0c             	mov    0xc(%eax),%edx
801051e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ec:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801051f2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801051f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
801051fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801051fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105201:	89 44 24 04          	mov    %eax,0x4(%esp)
80105205:	c7 04 24 c6 8f 10 80 	movl   $0x80108fc6,(%esp)
8010520c:	e8 8f b1 ff ff       	call   801003a0 <cprintf>
    cprintf("QUEUE SIZE_2 %d\n", thQ->size);
80105211:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105216:	8b 00                	mov    (%eax),%eax
80105218:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521c:	c7 04 24 e1 8f 10 80 	movl   $0x80108fe1,(%esp)
80105223:	e8 78 b1 ff ff       	call   801003a0 <cprintf>
    proc->state = RUNNABLE;
80105228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    add_q2(thQ, proc);
80105235:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010523c:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105241:	89 54 24 04          	mov    %edx,0x4(%esp)
80105245:	89 04 24             	mov    %eax,(%esp)
80105248:	e8 64 f3 ff ff       	call   801045b1 <add_q2>
    old = proc;
8010524d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105253:	89 45 ec             	mov    %eax,-0x14(%ebp)
    proc = p;
80105256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105259:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
    //switchuvm(p);
    p->state = RUNNING;
8010525f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105262:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    intena = cpu->intena;
80105269:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010526f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105275:	89 45 e8             	mov    %eax,-0x18(%ebp)
    swtch(&old->context, proc->context);
80105278:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105281:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105284:	83 c2 1c             	add    $0x1c,%edx
80105287:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528b:	89 14 24             	mov    %edx,(%esp)
8010528e:	e8 0e 07 00 00       	call   801059a1 <swtch>
    cpu->intena = intena;
80105293:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105299:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010529c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
    //switchkvm();
    //proc = 0;
    //swtch(&old->context, p->context);
    //swtch(&old->context, cpu->scheduler);
    //swtch(&cpu->scheduler, proc->context);
    cprintf("After %d\n", pid);
801052a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801052a9:	c7 04 24 f2 8f 10 80 	movl   $0x80108ff2,(%esp)
801052b0:	e8 eb b0 ff ff       	call   801003a0 <cprintf>
    
    if (holding(&ptable.lock)) {
801052b5:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801052bc:	e8 25 03 00 00       	call   801055e6 <holding>
801052c1:	85 c0                	test   %eax,%eax
801052c3:	74 1a                	je     801052df <thread_yield+0x1ed>
        //lock_release2(&ptable.lock);
        release(&ptable.lock); 
801052c5:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801052cc:	e8 05 02 00 00       	call   801054d6 <release>
        cprintf("RELEASED\n");
801052d1:	c7 04 24 fc 8f 10 80 	movl   $0x80108ffc,(%esp)
801052d8:	e8 c3 b0 ff ff       	call   801003a0 <cprintf>
801052dd:	eb 0c                	jmp    801052eb <thread_yield+0x1f9>
    }
    else cprintf("DID NOT RELEASE\n");
801052df:	c7 04 24 06 90 10 80 	movl   $0x80109006,(%esp)
801052e6:	e8 b5 b0 ff ff       	call   801003a0 <cprintf>
    
    //release(&ptable.lock);
    
}
801052eb:	c9                   	leave  
801052ec:	c3                   	ret    

801052ed <tsched>:

    void
tsched(void)
{
801052ed:	55                   	push   %ebp
801052ee:	89 e5                	mov    %esp,%ebp
801052f0:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
801052f3:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801052fa:	e8 e7 02 00 00       	call   801055e6 <holding>
801052ff:	85 c0                	test   %eax,%eax
80105301:	75 0c                	jne    8010530f <tsched+0x22>
        panic("tsched ptable.lock");
80105303:	c7 04 24 17 90 10 80 	movl   $0x80109017,(%esp)
8010530a:	e8 2b b2 ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
8010530f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105315:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010531b:	83 f8 01             	cmp    $0x1,%eax
8010531e:	74 35                	je     80105355 <tsched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80105320:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105326:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010532c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105332:	8b 40 10             	mov    0x10(%eax),%eax
80105335:	89 54 24 08          	mov    %edx,0x8(%esp)
80105339:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533d:	c7 04 24 14 8f 10 80 	movl   $0x80108f14,(%esp)
80105344:	e8 57 b0 ff ff       	call   801003a0 <cprintf>
        panic("sched locks");
80105349:	c7 04 24 33 8f 10 80 	movl   $0x80108f33,(%esp)
80105350:	e8 e5 b1 ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80105355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535b:	8b 40 0c             	mov    0xc(%eax),%eax
8010535e:	83 f8 04             	cmp    $0x4,%eax
80105361:	75 0c                	jne    8010536f <tsched+0x82>
        panic("tsched running");
80105363:	c7 04 24 2a 90 10 80 	movl   $0x8010902a,(%esp)
8010536a:	e8 cb b1 ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
8010536f:	e8 16 ed ff ff       	call   8010408a <readeflags>
80105374:	25 00 02 00 00       	and    $0x200,%eax
80105379:	85 c0                	test   %eax,%eax
8010537b:	74 0c                	je     80105389 <tsched+0x9c>
        panic("tsched interruptible");
8010537d:	c7 04 24 39 90 10 80 	movl   $0x80109039,(%esp)
80105384:	e8 b1 b1 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80105389:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010538f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105395:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80105398:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010539e:	8b 40 04             	mov    0x4(%eax),%eax
801053a1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053a8:	83 c2 1c             	add    $0x1c,%edx
801053ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801053af:	89 14 24             	mov    %edx,(%esp)
801053b2:	e8 ea 05 00 00       	call   801059a1 <swtch>
    cpu->intena = intena;
801053b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053c0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801053c6:	c9                   	leave  
801053c7:	c3                   	ret    

801053c8 <thread_yield3>:

void thread_yield3(int tid) {
801053c8:	55                   	push   %ebp
801053c9:	89 e5                	mov    %esp,%ebp
801053cb:	83 ec 08             	sub    $0x8,%esp
    //switchuvm(p);
    p->state = RUNNING;
    swtch(&old->context, proc->context);
    release(&ptable.lock);
    */
    yield();
801053ce:	e8 6c f9 ff ff       	call   80104d3f <yield>
801053d3:	c9                   	leave  
801053d4:	c3                   	ret    

801053d5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801053d5:	55                   	push   %ebp
801053d6:	89 e5                	mov    %esp,%ebp
801053d8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801053db:	9c                   	pushf  
801053dc:	58                   	pop    %eax
801053dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801053e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053e3:	c9                   	leave  
801053e4:	c3                   	ret    

801053e5 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801053e5:	55                   	push   %ebp
801053e6:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801053e8:	fa                   	cli    
}
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    

801053eb <sti>:

static inline void
sti(void)
{
801053eb:	55                   	push   %ebp
801053ec:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801053ee:	fb                   	sti    
}
801053ef:	5d                   	pop    %ebp
801053f0:	c3                   	ret    

801053f1 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801053f1:	55                   	push   %ebp
801053f2:	89 e5                	mov    %esp,%ebp
801053f4:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801053f7:	8b 55 08             	mov    0x8(%ebp),%edx
801053fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801053fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105400:	f0 87 02             	lock xchg %eax,(%edx)
80105403:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105409:	c9                   	leave  
8010540a:	c3                   	ret    

8010540b <initlock>:
#include "spinlock.h"
//#include "semaphore.h"

void
initlock(struct spinlock *lk, char *name)
{
8010540b:	55                   	push   %ebp
8010540c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010540e:	8b 45 08             	mov    0x8(%ebp),%eax
80105411:	8b 55 0c             	mov    0xc(%ebp),%edx
80105414:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105417:	8b 45 08             	mov    0x8(%ebp),%eax
8010541a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105420:	8b 45 08             	mov    0x8(%ebp),%eax
80105423:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    

8010542c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010542c:	55                   	push   %ebp
8010542d:	89 e5                	mov    %esp,%ebp
8010542f:	53                   	push   %ebx
80105430:	83 ec 24             	sub    $0x24,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105433:	e8 d8 01 00 00       	call   80105610 <pushcli>
  if(holding(lk)) {
80105438:	8b 45 08             	mov    0x8(%ebp),%eax
8010543b:	89 04 24             	mov    %eax,(%esp)
8010543e:	e8 a3 01 00 00       	call   801055e6 <holding>
80105443:	85 c0                	test   %eax,%eax
80105445:	74 4f                	je     80105496 <acquire+0x6a>
    cprintf("PROC %d%d%d %s called acq ", proc->isthread, proc->state, proc->pid, proc->name);
80105447:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010544d:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105450:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105456:	8b 48 10             	mov    0x10(%eax),%ecx
80105459:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010545f:	8b 50 0c             	mov    0xc(%eax),%edx
80105462:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105468:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010546e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80105472:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105476:	89 54 24 08          	mov    %edx,0x8(%esp)
8010547a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547e:	c7 04 24 78 90 10 80 	movl   $0x80109078,(%esp)
80105485:	e8 16 af ff ff       	call   801003a0 <cprintf>
    panic("acquire in spinlock.c");
8010548a:	c7 04 24 93 90 10 80 	movl   $0x80109093,(%esp)
80105491:	e8 a4 b0 ff ff       	call   8010053a <panic>
  }

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105496:	90                   	nop
80105497:	8b 45 08             	mov    0x8(%ebp),%eax
8010549a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801054a1:	00 
801054a2:	89 04 24             	mov    %eax,(%esp)
801054a5:	e8 47 ff ff ff       	call   801053f1 <xchg>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	75 e9                	jne    80105497 <acquire+0x6b>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801054ae:	8b 45 08             	mov    0x8(%ebp),%eax
801054b1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801054b8:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801054bb:	8b 45 08             	mov    0x8(%ebp),%eax
801054be:	83 c0 0c             	add    $0xc,%eax
801054c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801054c5:	8d 45 08             	lea    0x8(%ebp),%eax
801054c8:	89 04 24             	mov    %eax,(%esp)
801054cb:	e8 9d 00 00 00       	call   8010556d <getcallerpcs>
}
801054d0:	83 c4 24             	add    $0x24,%esp
801054d3:	5b                   	pop    %ebx
801054d4:	5d                   	pop    %ebp
801054d5:	c3                   	ret    

801054d6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801054d6:	55                   	push   %ebp
801054d7:	89 e5                	mov    %esp,%ebp
801054d9:	53                   	push   %ebx
801054da:	83 ec 24             	sub    $0x24,%esp
  if(!holding(lk)) {
801054dd:	8b 45 08             	mov    0x8(%ebp),%eax
801054e0:	89 04 24             	mov    %eax,(%esp)
801054e3:	e8 fe 00 00 00       	call   801055e6 <holding>
801054e8:	85 c0                	test   %eax,%eax
801054ea:	75 4f                	jne    8010553b <release+0x65>
    cprintf("PROC %d%d%d %s called rel ", proc->isthread, proc->state, proc->pid, proc->name);
801054ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f2:	8d 58 6c             	lea    0x6c(%eax),%ebx
801054f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054fb:	8b 48 10             	mov    0x10(%eax),%ecx
801054fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105504:	8b 50 0c             	mov    0xc(%eax),%edx
80105507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105513:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80105517:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010551b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010551f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105523:	c7 04 24 a9 90 10 80 	movl   $0x801090a9,(%esp)
8010552a:	e8 71 ae ff ff       	call   801003a0 <cprintf>
    panic("release in spinlock.c");
8010552f:	c7 04 24 c4 90 10 80 	movl   $0x801090c4,(%esp)
80105536:	e8 ff af ff ff       	call   8010053a <panic>
  }

  lk->pcs[0] = 0;
8010553b:	8b 45 08             	mov    0x8(%ebp),%eax
8010553e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105545:	8b 45 08             	mov    0x8(%ebp),%eax
80105548:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010554f:	8b 45 08             	mov    0x8(%ebp),%eax
80105552:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105559:	00 
8010555a:	89 04 24             	mov    %eax,(%esp)
8010555d:	e8 8f fe ff ff       	call   801053f1 <xchg>

  popcli();
80105562:	e8 ed 00 00 00       	call   80105654 <popcli>
}
80105567:	83 c4 24             	add    $0x24,%esp
8010556a:	5b                   	pop    %ebx
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    

8010556d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010556d:	55                   	push   %ebp
8010556e:	89 e5                	mov    %esp,%ebp
80105570:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105573:	8b 45 08             	mov    0x8(%ebp),%eax
80105576:	83 e8 08             	sub    $0x8,%eax
80105579:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010557c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105583:	eb 38                	jmp    801055bd <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105585:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105589:	74 38                	je     801055c3 <getcallerpcs+0x56>
8010558b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105592:	76 2f                	jbe    801055c3 <getcallerpcs+0x56>
80105594:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105598:	74 29                	je     801055c3 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010559a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010559d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801055a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a7:	01 c2                	add    %eax,%edx
801055a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ac:	8b 40 04             	mov    0x4(%eax),%eax
801055af:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801055b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b4:	8b 00                	mov    (%eax),%eax
801055b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801055b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801055bd:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801055c1:	7e c2                	jle    80105585 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801055c3:	eb 19                	jmp    801055de <getcallerpcs+0x71>
    pcs[i] = 0;
801055c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801055cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d2:	01 d0                	add    %edx,%eax
801055d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801055da:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801055de:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801055e2:	7e e1                	jle    801055c5 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801055e4:	c9                   	leave  
801055e5:	c3                   	ret    

801055e6 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801055e6:	55                   	push   %ebp
801055e7:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801055e9:	8b 45 08             	mov    0x8(%ebp),%eax
801055ec:	8b 00                	mov    (%eax),%eax
801055ee:	85 c0                	test   %eax,%eax
801055f0:	74 17                	je     80105609 <holding+0x23>
801055f2:	8b 45 08             	mov    0x8(%ebp),%eax
801055f5:	8b 50 08             	mov    0x8(%eax),%edx
801055f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055fe:	39 c2                	cmp    %eax,%edx
80105600:	75 07                	jne    80105609 <holding+0x23>
80105602:	b8 01 00 00 00       	mov    $0x1,%eax
80105607:	eb 05                	jmp    8010560e <holding+0x28>
80105609:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010560e:	5d                   	pop    %ebp
8010560f:	c3                   	ret    

80105610 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105616:	e8 ba fd ff ff       	call   801053d5 <readeflags>
8010561b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010561e:	e8 c2 fd ff ff       	call   801053e5 <cli>
  if(cpu->ncli++ == 0)
80105623:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010562a:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105630:	8d 48 01             	lea    0x1(%eax),%ecx
80105633:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105639:	85 c0                	test   %eax,%eax
8010563b:	75 15                	jne    80105652 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010563d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105643:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105646:	81 e2 00 02 00 00    	and    $0x200,%edx
8010564c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105652:	c9                   	leave  
80105653:	c3                   	ret    

80105654 <popcli>:

void
popcli(void)
{
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010565a:	e8 76 fd ff ff       	call   801053d5 <readeflags>
8010565f:	25 00 02 00 00       	and    $0x200,%eax
80105664:	85 c0                	test   %eax,%eax
80105666:	74 0c                	je     80105674 <popcli+0x20>
    panic("popcli - interruptible");
80105668:	c7 04 24 da 90 10 80 	movl   $0x801090da,(%esp)
8010566f:	e8 c6 ae ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105674:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010567a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105680:	83 ea 01             	sub    $0x1,%edx
80105683:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105689:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010568f:	85 c0                	test   %eax,%eax
80105691:	79 0c                	jns    8010569f <popcli+0x4b>
    panic("popcli");
80105693:	c7 04 24 f1 90 10 80 	movl   $0x801090f1,(%esp)
8010569a:	e8 9b ae ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010569f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056a5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801056ab:	85 c0                	test   %eax,%eax
801056ad:	75 15                	jne    801056c4 <popcli+0x70>
801056af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056b5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801056bb:	85 c0                	test   %eax,%eax
801056bd:	74 05                	je     801056c4 <popcli+0x70>
    sti();
801056bf:	e8 27 fd ff ff       	call   801053eb <sti>
}
801056c4:	c9                   	leave  
801056c5:	c3                   	ret    

801056c6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801056c6:	55                   	push   %ebp
801056c7:	89 e5                	mov    %esp,%ebp
801056c9:	57                   	push   %edi
801056ca:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801056cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056ce:	8b 55 10             	mov    0x10(%ebp),%edx
801056d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d4:	89 cb                	mov    %ecx,%ebx
801056d6:	89 df                	mov    %ebx,%edi
801056d8:	89 d1                	mov    %edx,%ecx
801056da:	fc                   	cld    
801056db:	f3 aa                	rep stos %al,%es:(%edi)
801056dd:	89 ca                	mov    %ecx,%edx
801056df:	89 fb                	mov    %edi,%ebx
801056e1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801056e4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801056e7:	5b                   	pop    %ebx
801056e8:	5f                   	pop    %edi
801056e9:	5d                   	pop    %ebp
801056ea:	c3                   	ret    

801056eb <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801056eb:	55                   	push   %ebp
801056ec:	89 e5                	mov    %esp,%ebp
801056ee:	57                   	push   %edi
801056ef:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801056f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056f3:	8b 55 10             	mov    0x10(%ebp),%edx
801056f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f9:	89 cb                	mov    %ecx,%ebx
801056fb:	89 df                	mov    %ebx,%edi
801056fd:	89 d1                	mov    %edx,%ecx
801056ff:	fc                   	cld    
80105700:	f3 ab                	rep stos %eax,%es:(%edi)
80105702:	89 ca                	mov    %ecx,%edx
80105704:	89 fb                	mov    %edi,%ebx
80105706:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105709:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010570c:	5b                   	pop    %ebx
8010570d:	5f                   	pop    %edi
8010570e:	5d                   	pop    %ebp
8010570f:	c3                   	ret    

80105710 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105716:	8b 45 08             	mov    0x8(%ebp),%eax
80105719:	83 e0 03             	and    $0x3,%eax
8010571c:	85 c0                	test   %eax,%eax
8010571e:	75 49                	jne    80105769 <memset+0x59>
80105720:	8b 45 10             	mov    0x10(%ebp),%eax
80105723:	83 e0 03             	and    $0x3,%eax
80105726:	85 c0                	test   %eax,%eax
80105728:	75 3f                	jne    80105769 <memset+0x59>
    c &= 0xFF;
8010572a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105731:	8b 45 10             	mov    0x10(%ebp),%eax
80105734:	c1 e8 02             	shr    $0x2,%eax
80105737:	89 c2                	mov    %eax,%edx
80105739:	8b 45 0c             	mov    0xc(%ebp),%eax
8010573c:	c1 e0 18             	shl    $0x18,%eax
8010573f:	89 c1                	mov    %eax,%ecx
80105741:	8b 45 0c             	mov    0xc(%ebp),%eax
80105744:	c1 e0 10             	shl    $0x10,%eax
80105747:	09 c1                	or     %eax,%ecx
80105749:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574c:	c1 e0 08             	shl    $0x8,%eax
8010574f:	09 c8                	or     %ecx,%eax
80105751:	0b 45 0c             	or     0xc(%ebp),%eax
80105754:	89 54 24 08          	mov    %edx,0x8(%esp)
80105758:	89 44 24 04          	mov    %eax,0x4(%esp)
8010575c:	8b 45 08             	mov    0x8(%ebp),%eax
8010575f:	89 04 24             	mov    %eax,(%esp)
80105762:	e8 84 ff ff ff       	call   801056eb <stosl>
80105767:	eb 19                	jmp    80105782 <memset+0x72>
  } else
    stosb(dst, c, n);
80105769:	8b 45 10             	mov    0x10(%ebp),%eax
8010576c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105770:	8b 45 0c             	mov    0xc(%ebp),%eax
80105773:	89 44 24 04          	mov    %eax,0x4(%esp)
80105777:	8b 45 08             	mov    0x8(%ebp),%eax
8010577a:	89 04 24             	mov    %eax,(%esp)
8010577d:	e8 44 ff ff ff       	call   801056c6 <stosb>
  return dst;
80105782:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    

80105787 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105787:	55                   	push   %ebp
80105788:	89 e5                	mov    %esp,%ebp
8010578a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010578d:	8b 45 08             	mov    0x8(%ebp),%eax
80105790:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105793:	8b 45 0c             	mov    0xc(%ebp),%eax
80105796:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105799:	eb 30                	jmp    801057cb <memcmp+0x44>
    if(*s1 != *s2)
8010579b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010579e:	0f b6 10             	movzbl (%eax),%edx
801057a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057a4:	0f b6 00             	movzbl (%eax),%eax
801057a7:	38 c2                	cmp    %al,%dl
801057a9:	74 18                	je     801057c3 <memcmp+0x3c>
      return *s1 - *s2;
801057ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057ae:	0f b6 00             	movzbl (%eax),%eax
801057b1:	0f b6 d0             	movzbl %al,%edx
801057b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057b7:	0f b6 00             	movzbl (%eax),%eax
801057ba:	0f b6 c0             	movzbl %al,%eax
801057bd:	29 c2                	sub    %eax,%edx
801057bf:	89 d0                	mov    %edx,%eax
801057c1:	eb 1a                	jmp    801057dd <memcmp+0x56>
    s1++, s2++;
801057c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057c7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801057cb:	8b 45 10             	mov    0x10(%ebp),%eax
801057ce:	8d 50 ff             	lea    -0x1(%eax),%edx
801057d1:	89 55 10             	mov    %edx,0x10(%ebp)
801057d4:	85 c0                	test   %eax,%eax
801057d6:	75 c3                	jne    8010579b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801057d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057dd:	c9                   	leave  
801057de:	c3                   	ret    

801057df <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801057df:	55                   	push   %ebp
801057e0:	89 e5                	mov    %esp,%ebp
801057e2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801057e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801057eb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801057f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801057f7:	73 3d                	jae    80105836 <memmove+0x57>
801057f9:	8b 45 10             	mov    0x10(%ebp),%eax
801057fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057ff:	01 d0                	add    %edx,%eax
80105801:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105804:	76 30                	jbe    80105836 <memmove+0x57>
    s += n;
80105806:	8b 45 10             	mov    0x10(%ebp),%eax
80105809:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010580c:	8b 45 10             	mov    0x10(%ebp),%eax
8010580f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105812:	eb 13                	jmp    80105827 <memmove+0x48>
      *--d = *--s;
80105814:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105818:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010581c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010581f:	0f b6 10             	movzbl (%eax),%edx
80105822:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105825:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105827:	8b 45 10             	mov    0x10(%ebp),%eax
8010582a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010582d:	89 55 10             	mov    %edx,0x10(%ebp)
80105830:	85 c0                	test   %eax,%eax
80105832:	75 e0                	jne    80105814 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105834:	eb 26                	jmp    8010585c <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105836:	eb 17                	jmp    8010584f <memmove+0x70>
      *d++ = *s++;
80105838:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010583b:	8d 50 01             	lea    0x1(%eax),%edx
8010583e:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105841:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105844:	8d 4a 01             	lea    0x1(%edx),%ecx
80105847:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010584a:	0f b6 12             	movzbl (%edx),%edx
8010584d:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010584f:	8b 45 10             	mov    0x10(%ebp),%eax
80105852:	8d 50 ff             	lea    -0x1(%eax),%edx
80105855:	89 55 10             	mov    %edx,0x10(%ebp)
80105858:	85 c0                	test   %eax,%eax
8010585a:	75 dc                	jne    80105838 <memmove+0x59>
      *d++ = *s++;

  return dst;
8010585c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010585f:	c9                   	leave  
80105860:	c3                   	ret    

80105861 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105861:	55                   	push   %ebp
80105862:	89 e5                	mov    %esp,%ebp
80105864:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105867:	8b 45 10             	mov    0x10(%ebp),%eax
8010586a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010586e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105871:	89 44 24 04          	mov    %eax,0x4(%esp)
80105875:	8b 45 08             	mov    0x8(%ebp),%eax
80105878:	89 04 24             	mov    %eax,(%esp)
8010587b:	e8 5f ff ff ff       	call   801057df <memmove>
}
80105880:	c9                   	leave  
80105881:	c3                   	ret    

80105882 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105882:	55                   	push   %ebp
80105883:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105885:	eb 0c                	jmp    80105893 <strncmp+0x11>
    n--, p++, q++;
80105887:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010588b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010588f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105893:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105897:	74 1a                	je     801058b3 <strncmp+0x31>
80105899:	8b 45 08             	mov    0x8(%ebp),%eax
8010589c:	0f b6 00             	movzbl (%eax),%eax
8010589f:	84 c0                	test   %al,%al
801058a1:	74 10                	je     801058b3 <strncmp+0x31>
801058a3:	8b 45 08             	mov    0x8(%ebp),%eax
801058a6:	0f b6 10             	movzbl (%eax),%edx
801058a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ac:	0f b6 00             	movzbl (%eax),%eax
801058af:	38 c2                	cmp    %al,%dl
801058b1:	74 d4                	je     80105887 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801058b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058b7:	75 07                	jne    801058c0 <strncmp+0x3e>
    return 0;
801058b9:	b8 00 00 00 00       	mov    $0x0,%eax
801058be:	eb 16                	jmp    801058d6 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801058c0:	8b 45 08             	mov    0x8(%ebp),%eax
801058c3:	0f b6 00             	movzbl (%eax),%eax
801058c6:	0f b6 d0             	movzbl %al,%edx
801058c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058cc:	0f b6 00             	movzbl (%eax),%eax
801058cf:	0f b6 c0             	movzbl %al,%eax
801058d2:	29 c2                	sub    %eax,%edx
801058d4:	89 d0                	mov    %edx,%eax
}
801058d6:	5d                   	pop    %ebp
801058d7:	c3                   	ret    

801058d8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801058d8:	55                   	push   %ebp
801058d9:	89 e5                	mov    %esp,%ebp
801058db:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801058de:	8b 45 08             	mov    0x8(%ebp),%eax
801058e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801058e4:	90                   	nop
801058e5:	8b 45 10             	mov    0x10(%ebp),%eax
801058e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801058eb:	89 55 10             	mov    %edx,0x10(%ebp)
801058ee:	85 c0                	test   %eax,%eax
801058f0:	7e 1e                	jle    80105910 <strncpy+0x38>
801058f2:	8b 45 08             	mov    0x8(%ebp),%eax
801058f5:	8d 50 01             	lea    0x1(%eax),%edx
801058f8:	89 55 08             	mov    %edx,0x8(%ebp)
801058fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801058fe:	8d 4a 01             	lea    0x1(%edx),%ecx
80105901:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105904:	0f b6 12             	movzbl (%edx),%edx
80105907:	88 10                	mov    %dl,(%eax)
80105909:	0f b6 00             	movzbl (%eax),%eax
8010590c:	84 c0                	test   %al,%al
8010590e:	75 d5                	jne    801058e5 <strncpy+0xd>
    ;
  while(n-- > 0)
80105910:	eb 0c                	jmp    8010591e <strncpy+0x46>
    *s++ = 0;
80105912:	8b 45 08             	mov    0x8(%ebp),%eax
80105915:	8d 50 01             	lea    0x1(%eax),%edx
80105918:	89 55 08             	mov    %edx,0x8(%ebp)
8010591b:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010591e:	8b 45 10             	mov    0x10(%ebp),%eax
80105921:	8d 50 ff             	lea    -0x1(%eax),%edx
80105924:	89 55 10             	mov    %edx,0x10(%ebp)
80105927:	85 c0                	test   %eax,%eax
80105929:	7f e7                	jg     80105912 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010592b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010592e:	c9                   	leave  
8010592f:	c3                   	ret    

80105930 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105936:	8b 45 08             	mov    0x8(%ebp),%eax
80105939:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010593c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105940:	7f 05                	jg     80105947 <safestrcpy+0x17>
    return os;
80105942:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105945:	eb 31                	jmp    80105978 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105947:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010594b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010594f:	7e 1e                	jle    8010596f <safestrcpy+0x3f>
80105951:	8b 45 08             	mov    0x8(%ebp),%eax
80105954:	8d 50 01             	lea    0x1(%eax),%edx
80105957:	89 55 08             	mov    %edx,0x8(%ebp)
8010595a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010595d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105960:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105963:	0f b6 12             	movzbl (%edx),%edx
80105966:	88 10                	mov    %dl,(%eax)
80105968:	0f b6 00             	movzbl (%eax),%eax
8010596b:	84 c0                	test   %al,%al
8010596d:	75 d8                	jne    80105947 <safestrcpy+0x17>
    ;
  *s = 0;
8010596f:	8b 45 08             	mov    0x8(%ebp),%eax
80105972:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105975:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105978:	c9                   	leave  
80105979:	c3                   	ret    

8010597a <strlen>:

int
strlen(const char *s)
{
8010597a:	55                   	push   %ebp
8010597b:	89 e5                	mov    %esp,%ebp
8010597d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105980:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105987:	eb 04                	jmp    8010598d <strlen+0x13>
80105989:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010598d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105990:	8b 45 08             	mov    0x8(%ebp),%eax
80105993:	01 d0                	add    %edx,%eax
80105995:	0f b6 00             	movzbl (%eax),%eax
80105998:	84 c0                	test   %al,%al
8010599a:	75 ed                	jne    80105989 <strlen+0xf>
    ;
  return n;
8010599c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010599f:	c9                   	leave  
801059a0:	c3                   	ret    

801059a1 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801059a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801059a5:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801059a9:	55                   	push   %ebp
  pushl %ebx
801059aa:	53                   	push   %ebx
  pushl %esi
801059ab:	56                   	push   %esi
  pushl %edi
801059ac:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801059ad:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801059af:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801059b1:	5f                   	pop    %edi
  popl %esi
801059b2:	5e                   	pop    %esi
  popl %ebx
801059b3:	5b                   	pop    %ebx
  popl %ebp
801059b4:	5d                   	pop    %ebp
  ret
801059b5:	c3                   	ret    

801059b6 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801059b6:	55                   	push   %ebp
801059b7:	89 e5                	mov    %esp,%ebp
801059b9:	83 ec 18             	sub    $0x18,%esp
  if(addr >= proc->sz || addr+4 > proc->sz || addr == 0) {
801059bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059c2:	8b 00                	mov    (%eax),%eax
801059c4:	3b 45 08             	cmp    0x8(%ebp),%eax
801059c7:	76 18                	jbe    801059e1 <fetchint+0x2b>
801059c9:	8b 45 08             	mov    0x8(%ebp),%eax
801059cc:	8d 50 04             	lea    0x4(%eax),%edx
801059cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059d5:	8b 00                	mov    (%eax),%eax
801059d7:	39 c2                	cmp    %eax,%edx
801059d9:	77 06                	ja     801059e1 <fetchint+0x2b>
801059db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801059df:	75 19                	jne    801059fa <fetchint+0x44>
    if (addr == 0) cprintf("fetchint NULL ptr\n");
801059e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801059e5:	75 0c                	jne    801059f3 <fetchint+0x3d>
801059e7:	c7 04 24 f8 90 10 80 	movl   $0x801090f8,(%esp)
801059ee:	e8 ad a9 ff ff       	call   801003a0 <cprintf>
    return -1;
801059f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f8:	eb 0f                	jmp    80105a09 <fetchint+0x53>
  }
  *ip = *(int*)(addr);
801059fa:	8b 45 08             	mov    0x8(%ebp),%eax
801059fd:	8b 10                	mov    (%eax),%edx
801059ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a02:	89 10                	mov    %edx,(%eax)
  return 0;
80105a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a09:	c9                   	leave  
80105a0a:	c3                   	ret    

80105a0b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a0b:	55                   	push   %ebp
80105a0c:	89 e5                	mov    %esp,%ebp
80105a0e:	83 ec 28             	sub    $0x28,%esp
  char *s, *ep;

  if(addr >= proc->sz || addr == 0) {
80105a11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a17:	8b 00                	mov    (%eax),%eax
80105a19:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a1c:	76 06                	jbe    80105a24 <fetchstr+0x19>
80105a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105a22:	75 19                	jne    80105a3d <fetchstr+0x32>
    if (addr == 0) cprintf("fetchstr NULL ptr\n");
80105a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105a28:	75 0c                	jne    80105a36 <fetchstr+0x2b>
80105a2a:	c7 04 24 0b 91 10 80 	movl   $0x8010910b,(%esp)
80105a31:	e8 6a a9 ff ff       	call   801003a0 <cprintf>
    return -1;
80105a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3b:	eb 46                	jmp    80105a83 <fetchstr+0x78>
  }
  *pp = (char*)addr;
80105a3d:	8b 55 08             	mov    0x8(%ebp),%edx
80105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a43:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105a45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a4b:	8b 00                	mov    (%eax),%eax
80105a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(s = *pp; s < ep; s++)
80105a50:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a53:	8b 00                	mov    (%eax),%eax
80105a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a58:	eb 1c                	jmp    80105a76 <fetchstr+0x6b>
    if(*s == 0)
80105a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5d:	0f b6 00             	movzbl (%eax),%eax
80105a60:	84 c0                	test   %al,%al
80105a62:	75 0e                	jne    80105a72 <fetchstr+0x67>
      return s - *pp;
80105a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a6a:	8b 00                	mov    (%eax),%eax
80105a6c:	29 c2                	sub    %eax,%edx
80105a6e:	89 d0                	mov    %edx,%eax
80105a70:	eb 11                	jmp    80105a83 <fetchstr+0x78>
    if (addr == 0) cprintf("fetchstr NULL ptr\n");
    return -1;
  }
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105a72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a79:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105a7c:	72 dc                	jb     80105a5a <fetchstr+0x4f>
    if(*s == 0)
      return s - *pp;
  return -1;
80105a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a83:	c9                   	leave  
80105a84:	c3                   	ret    

80105a85 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a85:	55                   	push   %ebp
80105a86:	89 e5                	mov    %esp,%ebp
80105a88:	83 ec 18             	sub    $0x18,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a91:	8b 40 18             	mov    0x18(%eax),%eax
80105a94:	8b 50 44             	mov    0x44(%eax),%edx
80105a97:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9a:	c1 e0 02             	shl    $0x2,%eax
80105a9d:	01 d0                	add    %edx,%eax
80105a9f:	8d 50 04             	lea    0x4(%eax),%edx
80105aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa9:	89 14 24             	mov    %edx,(%esp)
80105aac:	e8 05 ff ff ff       	call   801059b6 <fetchint>
}
80105ab1:	c9                   	leave  
80105ab2:	c3                   	ret    

80105ab3 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ab3:	55                   	push   %ebp
80105ab4:	89 e5                	mov    %esp,%ebp
80105ab6:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac3:	89 04 24             	mov    %eax,(%esp)
80105ac6:	e8 ba ff ff ff       	call   80105a85 <argint>
80105acb:	85 c0                	test   %eax,%eax
80105acd:	79 07                	jns    80105ad6 <argptr+0x23>
    return -1;
80105acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad4:	eb 57                	jmp    80105b2d <argptr+0x7a>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz || (uint)i == 0) {
80105ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad9:	89 c2                	mov    %eax,%edx
80105adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae1:	8b 00                	mov    (%eax),%eax
80105ae3:	39 c2                	cmp    %eax,%edx
80105ae5:	73 1d                	jae    80105b04 <argptr+0x51>
80105ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aea:	89 c2                	mov    %eax,%edx
80105aec:	8b 45 10             	mov    0x10(%ebp),%eax
80105aef:	01 c2                	add    %eax,%edx
80105af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105af7:	8b 00                	mov    (%eax),%eax
80105af9:	39 c2                	cmp    %eax,%edx
80105afb:	77 07                	ja     80105b04 <argptr+0x51>
80105afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b00:	85 c0                	test   %eax,%eax
80105b02:	75 1a                	jne    80105b1e <argptr+0x6b>
    if ((uint)i == 0) cprintf("argptr NULL ptr\n");
80105b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b07:	85 c0                	test   %eax,%eax
80105b09:	75 0c                	jne    80105b17 <argptr+0x64>
80105b0b:	c7 04 24 1e 91 10 80 	movl   $0x8010911e,(%esp)
80105b12:	e8 89 a8 ff ff       	call   801003a0 <cprintf>
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb 0f                	jmp    80105b2d <argptr+0x7a>
  }
  *pp = (char*)i;
80105b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b21:	89 c2                	mov    %eax,%edx
80105b23:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b26:	89 10                	mov    %edx,(%eax)
  return 0;
80105b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    

80105b2f <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b2f:	55                   	push   %ebp
80105b30:	89 e5                	mov    %esp,%ebp
80105b32:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b38:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b3f:	89 04 24             	mov    %eax,(%esp)
80105b42:	e8 3e ff ff ff       	call   80105a85 <argint>
80105b47:	85 c0                	test   %eax,%eax
80105b49:	79 07                	jns    80105b52 <argstr+0x23>
    return -1;
80105b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b50:	eb 12                	jmp    80105b64 <argstr+0x35>
  return fetchstr(addr, pp);
80105b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b55:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b58:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b5c:	89 04 24             	mov    %eax,(%esp)
80105b5f:	e8 a7 fe ff ff       	call   80105a0b <fetchstr>
}
80105b64:	c9                   	leave  
80105b65:	c3                   	ret    

80105b66 <syscall>:
[SYS_thread_yield3] sys_thread_yield3,
};

void
syscall(void)
{
80105b66:	55                   	push   %ebp
80105b67:	89 e5                	mov    %esp,%ebp
80105b69:	53                   	push   %ebx
80105b6a:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105b6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b73:	8b 40 18             	mov    0x18(%eax),%eax
80105b76:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b80:	7e 30                	jle    80105bb2 <syscall+0x4c>
80105b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b85:	83 f8 1a             	cmp    $0x1a,%eax
80105b88:	77 28                	ja     80105bb2 <syscall+0x4c>
80105b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b94:	85 c0                	test   %eax,%eax
80105b96:	74 1a                	je     80105bb2 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105b98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b9e:	8b 58 18             	mov    0x18(%eax),%ebx
80105ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba4:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bab:	ff d0                	call   *%eax
80105bad:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105bb0:	eb 3d                	jmp    80105bef <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105bb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb8:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105bbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105bc1:	8b 40 10             	mov    0x10(%eax),%eax
80105bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bc7:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105bcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bd3:	c7 04 24 2f 91 10 80 	movl   $0x8010912f,(%esp)
80105bda:	e8 c1 a7 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105bdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105be5:	8b 40 18             	mov    0x18(%eax),%eax
80105be8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105bef:	83 c4 24             	add    $0x24,%esp
80105bf2:	5b                   	pop    %ebx
80105bf3:	5d                   	pop    %ebp
80105bf4:	c3                   	ret    

80105bf5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105bf5:	55                   	push   %ebp
80105bf6:	89 e5                	mov    %esp,%ebp
80105bf8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c02:	8b 45 08             	mov    0x8(%ebp),%eax
80105c05:	89 04 24             	mov    %eax,(%esp)
80105c08:	e8 78 fe ff ff       	call   80105a85 <argint>
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	79 07                	jns    80105c18 <argfd+0x23>
    return -1;
80105c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c16:	eb 50                	jmp    80105c68 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	78 21                	js     80105c40 <argfd+0x4b>
80105c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c22:	83 f8 0f             	cmp    $0xf,%eax
80105c25:	7f 19                	jg     80105c40 <argfd+0x4b>
80105c27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c30:	83 c2 08             	add    $0x8,%edx
80105c33:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c3e:	75 07                	jne    80105c47 <argfd+0x52>
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c45:	eb 21                	jmp    80105c68 <argfd+0x73>
  if(pfd)
80105c47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c4b:	74 08                	je     80105c55 <argfd+0x60>
    *pfd = fd;
80105c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c50:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c53:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c59:	74 08                	je     80105c63 <argfd+0x6e>
    *pf = f;
80105c5b:	8b 45 10             	mov    0x10(%ebp),%eax
80105c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c61:	89 10                	mov    %edx,(%eax)
  return 0;
80105c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c68:	c9                   	leave  
80105c69:	c3                   	ret    

80105c6a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105c6a:	55                   	push   %ebp
80105c6b:	89 e5                	mov    %esp,%ebp
80105c6d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c77:	eb 30                	jmp    80105ca9 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c82:	83 c2 08             	add    $0x8,%edx
80105c85:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	75 18                	jne    80105ca5 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c96:	8d 4a 08             	lea    0x8(%edx),%ecx
80105c99:	8b 55 08             	mov    0x8(%ebp),%edx
80105c9c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca3:	eb 0f                	jmp    80105cb4 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ca5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ca9:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105cad:	7e ca                	jle    80105c79 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb4:	c9                   	leave  
80105cb5:	c3                   	ret    

80105cb6 <sys_dup>:

int
sys_dup(void)
{
80105cb6:	55                   	push   %ebp
80105cb7:	89 e5                	mov    %esp,%ebp
80105cb9:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105cbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cbf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cc3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cca:	00 
80105ccb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cd2:	e8 1e ff ff ff       	call   80105bf5 <argfd>
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	79 07                	jns    80105ce2 <sys_dup+0x2c>
    return -1;
80105cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce0:	eb 29                	jmp    80105d0b <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce5:	89 04 24             	mov    %eax,(%esp)
80105ce8:	e8 7d ff ff ff       	call   80105c6a <fdalloc>
80105ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cf4:	79 07                	jns    80105cfd <sys_dup+0x47>
    return -1;
80105cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfb:	eb 0e                	jmp    80105d0b <sys_dup+0x55>
  filedup(f);
80105cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d00:	89 04 24             	mov    %eax,(%esp)
80105d03:	e8 9e b2 ff ff       	call   80100fa6 <filedup>
  return fd;
80105d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d0b:	c9                   	leave  
80105d0c:	c3                   	ret    

80105d0d <sys_read>:

int
sys_read(void)
{
80105d0d:	55                   	push   %ebp
80105d0e:	89 e5                	mov    %esp,%ebp
80105d10:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d13:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d16:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d21:	00 
80105d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d29:	e8 c7 fe ff ff       	call   80105bf5 <argfd>
80105d2e:	85 c0                	test   %eax,%eax
80105d30:	78 35                	js     80105d67 <sys_read+0x5a>
80105d32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d35:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d39:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d40:	e8 40 fd ff ff       	call   80105a85 <argint>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	78 1e                	js     80105d67 <sys_read+0x5a>
80105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d50:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d5e:	e8 50 fd ff ff       	call   80105ab3 <argptr>
80105d63:	85 c0                	test   %eax,%eax
80105d65:	79 07                	jns    80105d6e <sys_read+0x61>
    return -1;
80105d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6c:	eb 19                	jmp    80105d87 <sys_read+0x7a>
  return fileread(f, p, n);
80105d6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d71:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d7f:	89 04 24             	mov    %eax,(%esp)
80105d82:	e8 8c b3 ff ff       	call   80101113 <fileread>
}
80105d87:	c9                   	leave  
80105d88:	c3                   	ret    

80105d89 <sys_write>:

int
sys_write(void)
{
80105d89:	55                   	push   %ebp
80105d8a:	89 e5                	mov    %esp,%ebp
80105d8c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d92:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d9d:	00 
80105d9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105da5:	e8 4b fe ff ff       	call   80105bf5 <argfd>
80105daa:	85 c0                	test   %eax,%eax
80105dac:	78 35                	js     80105de3 <sys_write+0x5a>
80105dae:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105dbc:	e8 c4 fc ff ff       	call   80105a85 <argint>
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	78 1e                	js     80105de3 <sys_write+0x5a>
80105dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dcc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dda:	e8 d4 fc ff ff       	call   80105ab3 <argptr>
80105ddf:	85 c0                	test   %eax,%eax
80105de1:	79 07                	jns    80105dea <sys_write+0x61>
    return -1;
80105de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de8:	eb 19                	jmp    80105e03 <sys_write+0x7a>
  return filewrite(f, p, n);
80105dea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ded:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105df7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105dfb:	89 04 24             	mov    %eax,(%esp)
80105dfe:	e8 cc b3 ff ff       	call   801011cf <filewrite>
}
80105e03:	c9                   	leave  
80105e04:	c3                   	ret    

80105e05 <sys_close>:

int
sys_close(void)
{
80105e05:	55                   	push   %ebp
80105e06:	89 e5                	mov    %esp,%ebp
80105e08:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105e0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e0e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e15:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e20:	e8 d0 fd ff ff       	call   80105bf5 <argfd>
80105e25:	85 c0                	test   %eax,%eax
80105e27:	79 07                	jns    80105e30 <sys_close+0x2b>
    return -1;
80105e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2e:	eb 24                	jmp    80105e54 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e39:	83 c2 08             	add    $0x8,%edx
80105e3c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e43:	00 
  fileclose(f);
80105e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e47:	89 04 24             	mov    %eax,(%esp)
80105e4a:	e8 9f b1 ff ff       	call   80100fee <fileclose>
  return 0;
80105e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e54:	c9                   	leave  
80105e55:	c3                   	ret    

80105e56 <sys_fstat>:

int
sys_fstat(void)
{
80105e56:	55                   	push   %ebp
80105e57:	89 e5                	mov    %esp,%ebp
80105e59:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e6a:	00 
80105e6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e72:	e8 7e fd ff ff       	call   80105bf5 <argfd>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	78 1f                	js     80105e9a <sys_fstat+0x44>
80105e7b:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105e82:	00 
80105e83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e86:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e91:	e8 1d fc ff ff       	call   80105ab3 <argptr>
80105e96:	85 c0                	test   %eax,%eax
80105e98:	79 07                	jns    80105ea1 <sys_fstat+0x4b>
    return -1;
80105e9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9f:	eb 12                	jmp    80105eb3 <sys_fstat+0x5d>
  return filestat(f, st);
80105ea1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105eab:	89 04 24             	mov    %eax,(%esp)
80105eae:	e8 11 b2 ff ff       	call   801010c4 <filestat>
}
80105eb3:	c9                   	leave  
80105eb4:	c3                   	ret    

80105eb5 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105eb5:	55                   	push   %ebp
80105eb6:	89 e5                	mov    %esp,%ebp
80105eb8:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ebb:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ec9:	e8 61 fc ff ff       	call   80105b2f <argstr>
80105ece:	85 c0                	test   %eax,%eax
80105ed0:	78 17                	js     80105ee9 <sys_link+0x34>
80105ed2:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ee0:	e8 4a fc ff ff       	call   80105b2f <argstr>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	79 0a                	jns    80105ef3 <sys_link+0x3e>
    return -1;
80105ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eee:	e9 3d 01 00 00       	jmp    80106030 <sys_link+0x17b>
  if((ip = namei(old)) == 0)
80105ef3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ef6:	89 04 24             	mov    %eax,(%esp)
80105ef9:	e8 28 c5 ff ff       	call   80102426 <namei>
80105efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f05:	75 0a                	jne    80105f11 <sys_link+0x5c>
    return -1;
80105f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0c:	e9 1f 01 00 00       	jmp    80106030 <sys_link+0x17b>

  begin_trans();
80105f11:	e8 d5 d3 ff ff       	call   801032eb <begin_trans>

  ilock(ip);
80105f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f19:	89 04 24             	mov    %eax,(%esp)
80105f1c:	e8 5a b9 ff ff       	call   8010187b <ilock>
  if(ip->type == T_DIR){
80105f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f24:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f28:	66 83 f8 01          	cmp    $0x1,%ax
80105f2c:	75 1a                	jne    80105f48 <sys_link+0x93>
    iunlockput(ip);
80105f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f31:	89 04 24             	mov    %eax,(%esp)
80105f34:	e8 c6 bb ff ff       	call   80101aff <iunlockput>
    commit_trans();
80105f39:	e8 f6 d3 ff ff       	call   80103334 <commit_trans>
    return -1;
80105f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f43:	e9 e8 00 00 00       	jmp    80106030 <sys_link+0x17b>
  }

  ip->nlink++;
80105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f4f:	8d 50 01             	lea    0x1(%eax),%edx
80105f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f55:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5c:	89 04 24             	mov    %eax,(%esp)
80105f5f:	e8 5b b7 ff ff       	call   801016bf <iupdate>
  iunlock(ip);
80105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f67:	89 04 24             	mov    %eax,(%esp)
80105f6a:	e8 5a ba ff ff       	call   801019c9 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105f6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f72:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f75:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f79:	89 04 24             	mov    %eax,(%esp)
80105f7c:	e8 c7 c4 ff ff       	call   80102448 <nameiparent>
80105f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f88:	75 02                	jne    80105f8c <sys_link+0xd7>
    goto bad;
80105f8a:	eb 68                	jmp    80105ff4 <sys_link+0x13f>
  ilock(dp);
80105f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8f:	89 04 24             	mov    %eax,(%esp)
80105f92:	e8 e4 b8 ff ff       	call   8010187b <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9a:	8b 10                	mov    (%eax),%edx
80105f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9f:	8b 00                	mov    (%eax),%eax
80105fa1:	39 c2                	cmp    %eax,%edx
80105fa3:	75 20                	jne    80105fc5 <sys_link+0x110>
80105fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa8:	8b 40 04             	mov    0x4(%eax),%eax
80105fab:	89 44 24 08          	mov    %eax,0x8(%esp)
80105faf:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb9:	89 04 24             	mov    %eax,(%esp)
80105fbc:	e8 a5 c1 ff ff       	call   80102166 <dirlink>
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	79 0d                	jns    80105fd2 <sys_link+0x11d>
    iunlockput(dp);
80105fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc8:	89 04 24             	mov    %eax,(%esp)
80105fcb:	e8 2f bb ff ff       	call   80101aff <iunlockput>
    goto bad;
80105fd0:	eb 22                	jmp    80105ff4 <sys_link+0x13f>
  }
  iunlockput(dp);
80105fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd5:	89 04 24             	mov    %eax,(%esp)
80105fd8:	e8 22 bb ff ff       	call   80101aff <iunlockput>
  iput(ip);
80105fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe0:	89 04 24             	mov    %eax,(%esp)
80105fe3:	e8 46 ba ff ff       	call   80101a2e <iput>

  commit_trans();
80105fe8:	e8 47 d3 ff ff       	call   80103334 <commit_trans>

  return 0;
80105fed:	b8 00 00 00 00       	mov    $0x0,%eax
80105ff2:	eb 3c                	jmp    80106030 <sys_link+0x17b>

bad:
  ilock(ip);
80105ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff7:	89 04 24             	mov    %eax,(%esp)
80105ffa:	e8 7c b8 ff ff       	call   8010187b <ilock>
  ip->nlink--;
80105fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106002:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106006:	8d 50 ff             	lea    -0x1(%eax),%edx
80106009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106013:	89 04 24             	mov    %eax,(%esp)
80106016:	e8 a4 b6 ff ff       	call   801016bf <iupdate>
  iunlockput(ip);
8010601b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601e:	89 04 24             	mov    %eax,(%esp)
80106021:	e8 d9 ba ff ff       	call   80101aff <iunlockput>
  commit_trans();
80106026:	e8 09 d3 ff ff       	call   80103334 <commit_trans>
  return -1;
8010602b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106030:	c9                   	leave  
80106031:	c3                   	ret    

80106032 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106032:	55                   	push   %ebp
80106033:	89 e5                	mov    %esp,%ebp
80106035:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106038:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010603f:	eb 4b                	jmp    8010608c <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106044:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010604b:	00 
8010604c:	89 44 24 08          	mov    %eax,0x8(%esp)
80106050:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106053:	89 44 24 04          	mov    %eax,0x4(%esp)
80106057:	8b 45 08             	mov    0x8(%ebp),%eax
8010605a:	89 04 24             	mov    %eax,(%esp)
8010605d:	e8 26 bd ff ff       	call   80101d88 <readi>
80106062:	83 f8 10             	cmp    $0x10,%eax
80106065:	74 0c                	je     80106073 <isdirempty+0x41>
      panic("isdirempty: readi");
80106067:	c7 04 24 4b 91 10 80 	movl   $0x8010914b,(%esp)
8010606e:	e8 c7 a4 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80106073:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106077:	66 85 c0             	test   %ax,%ax
8010607a:	74 07                	je     80106083 <isdirempty+0x51>
      return 0;
8010607c:	b8 00 00 00 00       	mov    $0x0,%eax
80106081:	eb 1b                	jmp    8010609e <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	83 c0 10             	add    $0x10,%eax
80106089:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010608c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010608f:	8b 45 08             	mov    0x8(%ebp),%eax
80106092:	8b 40 18             	mov    0x18(%eax),%eax
80106095:	39 c2                	cmp    %eax,%edx
80106097:	72 a8                	jb     80106041 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106099:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010609e:	c9                   	leave  
8010609f:	c3                   	ret    

801060a0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801060a6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801060a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801060ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b4:	e8 76 fa ff ff       	call   80105b2f <argstr>
801060b9:	85 c0                	test   %eax,%eax
801060bb:	79 0a                	jns    801060c7 <sys_unlink+0x27>
    return -1;
801060bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c2:	e9 aa 01 00 00       	jmp    80106271 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
801060c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
801060ca:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801060cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801060d1:	89 04 24             	mov    %eax,(%esp)
801060d4:	e8 6f c3 ff ff       	call   80102448 <nameiparent>
801060d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060e0:	75 0a                	jne    801060ec <sys_unlink+0x4c>
    return -1;
801060e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e7:	e9 85 01 00 00       	jmp    80106271 <sys_unlink+0x1d1>

  begin_trans();
801060ec:	e8 fa d1 ff ff       	call   801032eb <begin_trans>

  ilock(dp);
801060f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f4:	89 04 24             	mov    %eax,(%esp)
801060f7:	e8 7f b7 ff ff       	call   8010187b <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060fc:	c7 44 24 04 5d 91 10 	movl   $0x8010915d,0x4(%esp)
80106103:	80 
80106104:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106107:	89 04 24             	mov    %eax,(%esp)
8010610a:	e8 6c bf ff ff       	call   8010207b <namecmp>
8010610f:	85 c0                	test   %eax,%eax
80106111:	0f 84 45 01 00 00    	je     8010625c <sys_unlink+0x1bc>
80106117:	c7 44 24 04 5f 91 10 	movl   $0x8010915f,0x4(%esp)
8010611e:	80 
8010611f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106122:	89 04 24             	mov    %eax,(%esp)
80106125:	e8 51 bf ff ff       	call   8010207b <namecmp>
8010612a:	85 c0                	test   %eax,%eax
8010612c:	0f 84 2a 01 00 00    	je     8010625c <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106132:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106135:	89 44 24 08          	mov    %eax,0x8(%esp)
80106139:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010613c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106143:	89 04 24             	mov    %eax,(%esp)
80106146:	e8 52 bf ff ff       	call   8010209d <dirlookup>
8010614b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010614e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106152:	75 05                	jne    80106159 <sys_unlink+0xb9>
    goto bad;
80106154:	e9 03 01 00 00       	jmp    8010625c <sys_unlink+0x1bc>
  ilock(ip);
80106159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615c:	89 04 24             	mov    %eax,(%esp)
8010615f:	e8 17 b7 ff ff       	call   8010187b <ilock>

  if(ip->nlink < 1)
80106164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106167:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010616b:	66 85 c0             	test   %ax,%ax
8010616e:	7f 0c                	jg     8010617c <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80106170:	c7 04 24 62 91 10 80 	movl   $0x80109162,(%esp)
80106177:	e8 be a3 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010617c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106183:	66 83 f8 01          	cmp    $0x1,%ax
80106187:	75 1f                	jne    801061a8 <sys_unlink+0x108>
80106189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618c:	89 04 24             	mov    %eax,(%esp)
8010618f:	e8 9e fe ff ff       	call   80106032 <isdirempty>
80106194:	85 c0                	test   %eax,%eax
80106196:	75 10                	jne    801061a8 <sys_unlink+0x108>
    iunlockput(ip);
80106198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619b:	89 04 24             	mov    %eax,(%esp)
8010619e:	e8 5c b9 ff ff       	call   80101aff <iunlockput>
    goto bad;
801061a3:	e9 b4 00 00 00       	jmp    8010625c <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
801061a8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801061af:	00 
801061b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061b7:	00 
801061b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061bb:	89 04 24             	mov    %eax,(%esp)
801061be:	e8 4d f5 ff ff       	call   80105710 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801061c6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801061cd:	00 
801061ce:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801061d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061dc:	89 04 24             	mov    %eax,(%esp)
801061df:	e8 08 bd ff ff       	call   80101eec <writei>
801061e4:	83 f8 10             	cmp    $0x10,%eax
801061e7:	74 0c                	je     801061f5 <sys_unlink+0x155>
    panic("unlink: writei");
801061e9:	c7 04 24 74 91 10 80 	movl   $0x80109174,(%esp)
801061f0:	e8 45 a3 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
801061f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061fc:	66 83 f8 01          	cmp    $0x1,%ax
80106200:	75 1c                	jne    8010621e <sys_unlink+0x17e>
    dp->nlink--;
80106202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106205:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106209:	8d 50 ff             	lea    -0x1(%eax),%edx
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106216:	89 04 24             	mov    %eax,(%esp)
80106219:	e8 a1 b4 ff ff       	call   801016bf <iupdate>
  }
  iunlockput(dp);
8010621e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106221:	89 04 24             	mov    %eax,(%esp)
80106224:	e8 d6 b8 ff ff       	call   80101aff <iunlockput>

  ip->nlink--;
80106229:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106230:	8d 50 ff             	lea    -0x1(%eax),%edx
80106233:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106236:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010623a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010623d:	89 04 24             	mov    %eax,(%esp)
80106240:	e8 7a b4 ff ff       	call   801016bf <iupdate>
  iunlockput(ip);
80106245:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106248:	89 04 24             	mov    %eax,(%esp)
8010624b:	e8 af b8 ff ff       	call   80101aff <iunlockput>

  commit_trans();
80106250:	e8 df d0 ff ff       	call   80103334 <commit_trans>

  return 0;
80106255:	b8 00 00 00 00       	mov    $0x0,%eax
8010625a:	eb 15                	jmp    80106271 <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
8010625c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625f:	89 04 24             	mov    %eax,(%esp)
80106262:	e8 98 b8 ff ff       	call   80101aff <iunlockput>
  commit_trans();
80106267:	e8 c8 d0 ff ff       	call   80103334 <commit_trans>
  return -1;
8010626c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106271:	c9                   	leave  
80106272:	c3                   	ret    

80106273 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106273:	55                   	push   %ebp
80106274:	89 e5                	mov    %esp,%ebp
80106276:	83 ec 48             	sub    $0x48,%esp
80106279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010627c:	8b 55 10             	mov    0x10(%ebp),%edx
8010627f:	8b 45 14             	mov    0x14(%ebp),%eax
80106282:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106286:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010628a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010628e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106291:	89 44 24 04          	mov    %eax,0x4(%esp)
80106295:	8b 45 08             	mov    0x8(%ebp),%eax
80106298:	89 04 24             	mov    %eax,(%esp)
8010629b:	e8 a8 c1 ff ff       	call   80102448 <nameiparent>
801062a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062a7:	75 0a                	jne    801062b3 <create+0x40>
    return 0;
801062a9:	b8 00 00 00 00       	mov    $0x0,%eax
801062ae:	e9 7e 01 00 00       	jmp    80106431 <create+0x1be>
  ilock(dp);
801062b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b6:	89 04 24             	mov    %eax,(%esp)
801062b9:	e8 bd b5 ff ff       	call   8010187b <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801062be:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062c1:	89 44 24 08          	mov    %eax,0x8(%esp)
801062c5:	8d 45 de             	lea    -0x22(%ebp),%eax
801062c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801062cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062cf:	89 04 24             	mov    %eax,(%esp)
801062d2:	e8 c6 bd ff ff       	call   8010209d <dirlookup>
801062d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062de:	74 47                	je     80106327 <create+0xb4>
    iunlockput(dp);
801062e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e3:	89 04 24             	mov    %eax,(%esp)
801062e6:	e8 14 b8 ff ff       	call   80101aff <iunlockput>
    ilock(ip);
801062eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ee:	89 04 24             	mov    %eax,(%esp)
801062f1:	e8 85 b5 ff ff       	call   8010187b <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801062f6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801062fb:	75 15                	jne    80106312 <create+0x9f>
801062fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106300:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106304:	66 83 f8 02          	cmp    $0x2,%ax
80106308:	75 08                	jne    80106312 <create+0x9f>
      return ip;
8010630a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630d:	e9 1f 01 00 00       	jmp    80106431 <create+0x1be>
    iunlockput(ip);
80106312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106315:	89 04 24             	mov    %eax,(%esp)
80106318:	e8 e2 b7 ff ff       	call   80101aff <iunlockput>
    return 0;
8010631d:	b8 00 00 00 00       	mov    $0x0,%eax
80106322:	e9 0a 01 00 00       	jmp    80106431 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106327:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010632b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632e:	8b 00                	mov    (%eax),%eax
80106330:	89 54 24 04          	mov    %edx,0x4(%esp)
80106334:	89 04 24             	mov    %eax,(%esp)
80106337:	e8 a4 b2 ff ff       	call   801015e0 <ialloc>
8010633c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010633f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106343:	75 0c                	jne    80106351 <create+0xde>
    panic("create: ialloc");
80106345:	c7 04 24 83 91 10 80 	movl   $0x80109183,(%esp)
8010634c:	e8 e9 a1 ff ff       	call   8010053a <panic>

  ilock(ip);
80106351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106354:	89 04 24             	mov    %eax,(%esp)
80106357:	e8 1f b5 ff ff       	call   8010187b <ilock>
  ip->major = major;
8010635c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635f:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106363:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106367:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636a:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010636e:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106372:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106375:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010637b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637e:	89 04 24             	mov    %eax,(%esp)
80106381:	e8 39 b3 ff ff       	call   801016bf <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106386:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010638b:	75 6a                	jne    801063f7 <create+0x184>
    dp->nlink++;  // for ".."
8010638d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106390:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106394:	8d 50 01             	lea    0x1(%eax),%edx
80106397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010639e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a1:	89 04 24             	mov    %eax,(%esp)
801063a4:	e8 16 b3 ff ff       	call   801016bf <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801063a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ac:	8b 40 04             	mov    0x4(%eax),%eax
801063af:	89 44 24 08          	mov    %eax,0x8(%esp)
801063b3:	c7 44 24 04 5d 91 10 	movl   $0x8010915d,0x4(%esp)
801063ba:	80 
801063bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063be:	89 04 24             	mov    %eax,(%esp)
801063c1:	e8 a0 bd ff ff       	call   80102166 <dirlink>
801063c6:	85 c0                	test   %eax,%eax
801063c8:	78 21                	js     801063eb <create+0x178>
801063ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063cd:	8b 40 04             	mov    0x4(%eax),%eax
801063d0:	89 44 24 08          	mov    %eax,0x8(%esp)
801063d4:	c7 44 24 04 5f 91 10 	movl   $0x8010915f,0x4(%esp)
801063db:	80 
801063dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063df:	89 04 24             	mov    %eax,(%esp)
801063e2:	e8 7f bd ff ff       	call   80102166 <dirlink>
801063e7:	85 c0                	test   %eax,%eax
801063e9:	79 0c                	jns    801063f7 <create+0x184>
      panic("create dots");
801063eb:	c7 04 24 92 91 10 80 	movl   $0x80109192,(%esp)
801063f2:	e8 43 a1 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801063f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fa:	8b 40 04             	mov    0x4(%eax),%eax
801063fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80106401:	8d 45 de             	lea    -0x22(%ebp),%eax
80106404:	89 44 24 04          	mov    %eax,0x4(%esp)
80106408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640b:	89 04 24             	mov    %eax,(%esp)
8010640e:	e8 53 bd ff ff       	call   80102166 <dirlink>
80106413:	85 c0                	test   %eax,%eax
80106415:	79 0c                	jns    80106423 <create+0x1b0>
    panic("create: dirlink");
80106417:	c7 04 24 9e 91 10 80 	movl   $0x8010919e,(%esp)
8010641e:	e8 17 a1 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106426:	89 04 24             	mov    %eax,(%esp)
80106429:	e8 d1 b6 ff ff       	call   80101aff <iunlockput>

  return ip;
8010642e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106431:	c9                   	leave  
80106432:	c3                   	ret    

80106433 <sys_open>:

int
sys_open(void)
{
80106433:	55                   	push   %ebp
80106434:	89 e5                	mov    %esp,%ebp
80106436:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106439:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010643c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106440:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106447:	e8 e3 f6 ff ff       	call   80105b2f <argstr>
8010644c:	85 c0                	test   %eax,%eax
8010644e:	78 17                	js     80106467 <sys_open+0x34>
80106450:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106453:	89 44 24 04          	mov    %eax,0x4(%esp)
80106457:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010645e:	e8 22 f6 ff ff       	call   80105a85 <argint>
80106463:	85 c0                	test   %eax,%eax
80106465:	79 0a                	jns    80106471 <sys_open+0x3e>
    return -1;
80106467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646c:	e9 48 01 00 00       	jmp    801065b9 <sys_open+0x186>
  if(omode & O_CREATE){
80106471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106474:	25 00 02 00 00       	and    $0x200,%eax
80106479:	85 c0                	test   %eax,%eax
8010647b:	74 40                	je     801064bd <sys_open+0x8a>
    begin_trans();
8010647d:	e8 69 ce ff ff       	call   801032eb <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106482:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106485:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010648c:	00 
8010648d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106494:	00 
80106495:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010649c:	00 
8010649d:	89 04 24             	mov    %eax,(%esp)
801064a0:	e8 ce fd ff ff       	call   80106273 <create>
801064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801064a8:	e8 87 ce ff ff       	call   80103334 <commit_trans>
    if(ip == 0)
801064ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b1:	75 5c                	jne    8010650f <sys_open+0xdc>
      return -1;
801064b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b8:	e9 fc 00 00 00       	jmp    801065b9 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
801064bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064c0:	89 04 24             	mov    %eax,(%esp)
801064c3:	e8 5e bf ff ff       	call   80102426 <namei>
801064c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064cf:	75 0a                	jne    801064db <sys_open+0xa8>
      return -1;
801064d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d6:	e9 de 00 00 00       	jmp    801065b9 <sys_open+0x186>
    ilock(ip);
801064db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064de:	89 04 24             	mov    %eax,(%esp)
801064e1:	e8 95 b3 ff ff       	call   8010187b <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064ed:	66 83 f8 01          	cmp    $0x1,%ax
801064f1:	75 1c                	jne    8010650f <sys_open+0xdc>
801064f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064f6:	85 c0                	test   %eax,%eax
801064f8:	74 15                	je     8010650f <sys_open+0xdc>
      iunlockput(ip);
801064fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064fd:	89 04 24             	mov    %eax,(%esp)
80106500:	e8 fa b5 ff ff       	call   80101aff <iunlockput>
      return -1;
80106505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650a:	e9 aa 00 00 00       	jmp    801065b9 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010650f:	e8 32 aa ff ff       	call   80100f46 <filealloc>
80106514:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010651b:	74 14                	je     80106531 <sys_open+0xfe>
8010651d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106520:	89 04 24             	mov    %eax,(%esp)
80106523:	e8 42 f7 ff ff       	call   80105c6a <fdalloc>
80106528:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010652b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010652f:	79 23                	jns    80106554 <sys_open+0x121>
    if(f)
80106531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106535:	74 0b                	je     80106542 <sys_open+0x10f>
      fileclose(f);
80106537:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653a:	89 04 24             	mov    %eax,(%esp)
8010653d:	e8 ac aa ff ff       	call   80100fee <fileclose>
    iunlockput(ip);
80106542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106545:	89 04 24             	mov    %eax,(%esp)
80106548:	e8 b2 b5 ff ff       	call   80101aff <iunlockput>
    return -1;
8010654d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106552:	eb 65                	jmp    801065b9 <sys_open+0x186>
  }
  iunlock(ip);
80106554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106557:	89 04 24             	mov    %eax,(%esp)
8010655a:	e8 6a b4 ff ff       	call   801019c9 <iunlock>

  f->type = FD_INODE;
8010655f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106562:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106568:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010656b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010656e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106571:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106574:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010657b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010657e:	83 e0 01             	and    $0x1,%eax
80106581:	85 c0                	test   %eax,%eax
80106583:	0f 94 c0             	sete   %al
80106586:	89 c2                	mov    %eax,%edx
80106588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010658b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010658e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106591:	83 e0 01             	and    $0x1,%eax
80106594:	85 c0                	test   %eax,%eax
80106596:	75 0a                	jne    801065a2 <sys_open+0x16f>
80106598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010659b:	83 e0 02             	and    $0x2,%eax
8010659e:	85 c0                	test   %eax,%eax
801065a0:	74 07                	je     801065a9 <sys_open+0x176>
801065a2:	b8 01 00 00 00       	mov    $0x1,%eax
801065a7:	eb 05                	jmp    801065ae <sys_open+0x17b>
801065a9:	b8 00 00 00 00       	mov    $0x0,%eax
801065ae:	89 c2                	mov    %eax,%edx
801065b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801065b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801065b9:	c9                   	leave  
801065ba:	c3                   	ret    

801065bb <sys_mkdir>:

int
sys_mkdir(void)
{
801065bb:	55                   	push   %ebp
801065bc:	89 e5                	mov    %esp,%ebp
801065be:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801065c1:	e8 25 cd ff ff       	call   801032eb <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801065cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065d4:	e8 56 f5 ff ff       	call   80105b2f <argstr>
801065d9:	85 c0                	test   %eax,%eax
801065db:	78 2c                	js     80106609 <sys_mkdir+0x4e>
801065dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801065e7:	00 
801065e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801065ef:	00 
801065f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801065f7:	00 
801065f8:	89 04 24             	mov    %eax,(%esp)
801065fb:	e8 73 fc ff ff       	call   80106273 <create>
80106600:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106607:	75 0c                	jne    80106615 <sys_mkdir+0x5a>
    commit_trans();
80106609:	e8 26 cd ff ff       	call   80103334 <commit_trans>
    return -1;
8010660e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106613:	eb 15                	jmp    8010662a <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106618:	89 04 24             	mov    %eax,(%esp)
8010661b:	e8 df b4 ff ff       	call   80101aff <iunlockput>
  commit_trans();
80106620:	e8 0f cd ff ff       	call   80103334 <commit_trans>
  return 0;
80106625:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010662a:	c9                   	leave  
8010662b:	c3                   	ret    

8010662c <sys_mknod>:

int
sys_mknod(void)
{
8010662c:	55                   	push   %ebp
8010662d:	89 e5                	mov    %esp,%ebp
8010662f:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106632:	e8 b4 cc ff ff       	call   801032eb <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106637:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010663a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106645:	e8 e5 f4 ff ff       	call   80105b2f <argstr>
8010664a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010664d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106651:	78 5e                	js     801066b1 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106653:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106656:	89 44 24 04          	mov    %eax,0x4(%esp)
8010665a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106661:	e8 1f f4 ff ff       	call   80105a85 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106666:	85 c0                	test   %eax,%eax
80106668:	78 47                	js     801066b1 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010666a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010666d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106671:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106678:	e8 08 f4 ff ff       	call   80105a85 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010667d:	85 c0                	test   %eax,%eax
8010667f:	78 30                	js     801066b1 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106684:	0f bf c8             	movswl %ax,%ecx
80106687:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010668a:	0f bf d0             	movswl %ax,%edx
8010668d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106690:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106694:	89 54 24 08          	mov    %edx,0x8(%esp)
80106698:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010669f:	00 
801066a0:	89 04 24             	mov    %eax,(%esp)
801066a3:	e8 cb fb ff ff       	call   80106273 <create>
801066a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066af:	75 0c                	jne    801066bd <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
801066b1:	e8 7e cc ff ff       	call   80103334 <commit_trans>
    return -1;
801066b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066bb:	eb 15                	jmp    801066d2 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801066bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c0:	89 04 24             	mov    %eax,(%esp)
801066c3:	e8 37 b4 ff ff       	call   80101aff <iunlockput>
  commit_trans();
801066c8:	e8 67 cc ff ff       	call   80103334 <commit_trans>
  return 0;
801066cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066d2:	c9                   	leave  
801066d3:	c3                   	ret    

801066d4 <sys_chdir>:

int
sys_chdir(void)
{
801066d4:	55                   	push   %ebp
801066d5:	89 e5                	mov    %esp,%ebp
801066d7:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801066da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801066e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066e8:	e8 42 f4 ff ff       	call   80105b2f <argstr>
801066ed:	85 c0                	test   %eax,%eax
801066ef:	78 14                	js     80106705 <sys_chdir+0x31>
801066f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f4:	89 04 24             	mov    %eax,(%esp)
801066f7:	e8 2a bd ff ff       	call   80102426 <namei>
801066fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106703:	75 07                	jne    8010670c <sys_chdir+0x38>
    return -1;
80106705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010670a:	eb 57                	jmp    80106763 <sys_chdir+0x8f>
  ilock(ip);
8010670c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670f:	89 04 24             	mov    %eax,(%esp)
80106712:	e8 64 b1 ff ff       	call   8010187b <ilock>
  if(ip->type != T_DIR){
80106717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010671e:	66 83 f8 01          	cmp    $0x1,%ax
80106722:	74 12                	je     80106736 <sys_chdir+0x62>
    iunlockput(ip);
80106724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106727:	89 04 24             	mov    %eax,(%esp)
8010672a:	e8 d0 b3 ff ff       	call   80101aff <iunlockput>
    return -1;
8010672f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106734:	eb 2d                	jmp    80106763 <sys_chdir+0x8f>
  }
  iunlock(ip);
80106736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106739:	89 04 24             	mov    %eax,(%esp)
8010673c:	e8 88 b2 ff ff       	call   801019c9 <iunlock>
  iput(proc->cwd);
80106741:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106747:	8b 40 68             	mov    0x68(%eax),%eax
8010674a:	89 04 24             	mov    %eax,(%esp)
8010674d:	e8 dc b2 ff ff       	call   80101a2e <iput>
  proc->cwd = ip;
80106752:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106758:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010675b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010675e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106763:	c9                   	leave  
80106764:	c3                   	ret    

80106765 <sys_exec>:

int
sys_exec(void)
{
80106765:	55                   	push   %ebp
80106766:	89 e5                	mov    %esp,%ebp
80106768:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010676e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106771:	89 44 24 04          	mov    %eax,0x4(%esp)
80106775:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010677c:	e8 ae f3 ff ff       	call   80105b2f <argstr>
80106781:	85 c0                	test   %eax,%eax
80106783:	78 1a                	js     8010679f <sys_exec+0x3a>
80106785:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010678b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010678f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106796:	e8 ea f2 ff ff       	call   80105a85 <argint>
8010679b:	85 c0                	test   %eax,%eax
8010679d:	79 0a                	jns    801067a9 <sys_exec+0x44>
    return -1;
8010679f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a4:	e9 c8 00 00 00       	jmp    80106871 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801067a9:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801067b0:	00 
801067b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067b8:	00 
801067b9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801067bf:	89 04 24             	mov    %eax,(%esp)
801067c2:	e8 49 ef ff ff       	call   80105710 <memset>
  for(i=0;; i++){
801067c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801067ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d1:	83 f8 1f             	cmp    $0x1f,%eax
801067d4:	76 0a                	jbe    801067e0 <sys_exec+0x7b>
      return -1;
801067d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067db:	e9 91 00 00 00       	jmp    80106871 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e3:	c1 e0 02             	shl    $0x2,%eax
801067e6:	89 c2                	mov    %eax,%edx
801067e8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801067ee:	01 c2                	add    %eax,%edx
801067f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801067f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801067fa:	89 14 24             	mov    %edx,(%esp)
801067fd:	e8 b4 f1 ff ff       	call   801059b6 <fetchint>
80106802:	85 c0                	test   %eax,%eax
80106804:	79 07                	jns    8010680d <sys_exec+0xa8>
      return -1;
80106806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010680b:	eb 64                	jmp    80106871 <sys_exec+0x10c>
    if(uarg == 0){
8010680d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106813:	85 c0                	test   %eax,%eax
80106815:	75 26                	jne    8010683d <sys_exec+0xd8>
      argv[i] = 0;
80106817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106821:	00 00 00 00 
      break;
80106825:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106826:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106829:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010682f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106833:	89 04 24             	mov    %eax,(%esp)
80106836:	e8 b4 a2 ff ff       	call   80100aef <exec>
8010683b:	eb 34                	jmp    80106871 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010683d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106843:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106846:	c1 e2 02             	shl    $0x2,%edx
80106849:	01 c2                	add    %eax,%edx
8010684b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106851:	89 54 24 04          	mov    %edx,0x4(%esp)
80106855:	89 04 24             	mov    %eax,(%esp)
80106858:	e8 ae f1 ff ff       	call   80105a0b <fetchstr>
8010685d:	85 c0                	test   %eax,%eax
8010685f:	79 07                	jns    80106868 <sys_exec+0x103>
      return -1;
80106861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106866:	eb 09                	jmp    80106871 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106868:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010686c:	e9 5d ff ff ff       	jmp    801067ce <sys_exec+0x69>
  return exec(path, argv);
}
80106871:	c9                   	leave  
80106872:	c3                   	ret    

80106873 <sys_pipe>:

int
sys_pipe(void)
{
80106873:	55                   	push   %ebp
80106874:	89 e5                	mov    %esp,%ebp
80106876:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106879:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106880:	00 
80106881:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106884:	89 44 24 04          	mov    %eax,0x4(%esp)
80106888:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010688f:	e8 1f f2 ff ff       	call   80105ab3 <argptr>
80106894:	85 c0                	test   %eax,%eax
80106896:	79 0a                	jns    801068a2 <sys_pipe+0x2f>
    return -1;
80106898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689d:	e9 9b 00 00 00       	jmp    8010693d <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801068a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068ac:	89 04 24             	mov    %eax,(%esp)
801068af:	e8 21 d4 ff ff       	call   80103cd5 <pipealloc>
801068b4:	85 c0                	test   %eax,%eax
801068b6:	79 07                	jns    801068bf <sys_pipe+0x4c>
    return -1;
801068b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068bd:	eb 7e                	jmp    8010693d <sys_pipe+0xca>
  fd0 = -1;
801068bf:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068c9:	89 04 24             	mov    %eax,(%esp)
801068cc:	e8 99 f3 ff ff       	call   80105c6a <fdalloc>
801068d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068d8:	78 14                	js     801068ee <sys_pipe+0x7b>
801068da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068dd:	89 04 24             	mov    %eax,(%esp)
801068e0:	e8 85 f3 ff ff       	call   80105c6a <fdalloc>
801068e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068ec:	79 37                	jns    80106925 <sys_pipe+0xb2>
    if(fd0 >= 0)
801068ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068f2:	78 14                	js     80106908 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801068f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068fd:	83 c2 08             	add    $0x8,%edx
80106900:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106907:	00 
    fileclose(rf);
80106908:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010690b:	89 04 24             	mov    %eax,(%esp)
8010690e:	e8 db a6 ff ff       	call   80100fee <fileclose>
    fileclose(wf);
80106913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106916:	89 04 24             	mov    %eax,(%esp)
80106919:	e8 d0 a6 ff ff       	call   80100fee <fileclose>
    return -1;
8010691e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106923:	eb 18                	jmp    8010693d <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106925:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106928:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010692b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010692d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106930:	8d 50 04             	lea    0x4(%eax),%edx
80106933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106936:	89 02                	mov    %eax,(%edx)
  return 0;
80106938:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010693d:	c9                   	leave  
8010693e:	c3                   	ret    

8010693f <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010693f:	55                   	push   %ebp
80106940:	89 e5                	mov    %esp,%ebp
80106942:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106945:	e8 d5 da ff ff       	call   8010441f <fork>
}
8010694a:	c9                   	leave  
8010694b:	c3                   	ret    

8010694c <sys_clone>:

int
sys_clone(){
8010694c:	55                   	push   %ebp
8010694d:	89 e5                	mov    %esp,%ebp
8010694f:	53                   	push   %ebx
80106950:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106953:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106956:	89 44 24 04          	mov    %eax,0x4(%esp)
8010695a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106961:	e8 1f f1 ff ff       	call   80105a85 <argint>
80106966:	85 c0                	test   %eax,%eax
80106968:	78 4c                	js     801069b6 <sys_clone+0x6a>
8010696a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010696d:	85 c0                	test   %eax,%eax
8010696f:	7e 45                	jle    801069b6 <sys_clone+0x6a>
80106971:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106974:	89 44 24 04          	mov    %eax,0x4(%esp)
80106978:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010697f:	e8 01 f1 ff ff       	call   80105a85 <argint>
80106984:	85 c0                	test   %eax,%eax
80106986:	78 2e                	js     801069b6 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106988:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010698b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010698f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106996:	e8 ea f0 ff ff       	call   80105a85 <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
8010699b:	85 c0                	test   %eax,%eax
8010699d:	78 17                	js     801069b6 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
8010699f:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801069a6:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
801069ad:	e8 d3 f0 ff ff       	call   80105a85 <argint>
801069b2:	85 c0                	test   %eax,%eax
801069b4:	79 07                	jns    801069bd <sys_clone+0x71>
        return -1;
801069b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bb:	eb 20                	jmp    801069dd <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
801069bd:	8b 5d e8             	mov    -0x18(%ebp),%ebx
801069c0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801069c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801069cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801069d5:	89 04 24             	mov    %eax,(%esp)
801069d8:	e8 c0 dc ff ff       	call   8010469d <clone>
}
801069dd:	83 c4 24             	add    $0x24,%esp
801069e0:	5b                   	pop    %ebx
801069e1:	5d                   	pop    %ebp
801069e2:	c3                   	ret    

801069e3 <sys_exit>:

int
sys_exit(void)
{
801069e3:	55                   	push   %ebp
801069e4:	89 e5                	mov    %esp,%ebp
801069e6:	83 ec 08             	sub    $0x8,%esp
  exit();
801069e9:	e8 d2 de ff ff       	call   801048c0 <exit>
  return 0;  // not reached
801069ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f3:	c9                   	leave  
801069f4:	c3                   	ret    

801069f5 <sys_texit>:

int
sys_texit(void)
{
801069f5:	55                   	push   %ebp
801069f6:	89 e5                	mov    %esp,%ebp
801069f8:	83 ec 08             	sub    $0x8,%esp
    texit();
801069fb:	e8 db df ff ff       	call   801049db <texit>
    return 0;
80106a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a05:	c9                   	leave  
80106a06:	c3                   	ret    

80106a07 <sys_wait>:

int
sys_wait(void)
{
80106a07:	55                   	push   %ebp
80106a08:	89 e5                	mov    %esp,%ebp
80106a0a:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a0d:	e8 97 e0 ff ff       	call   80104aa9 <wait>
}
80106a12:	c9                   	leave  
80106a13:	c3                   	ret    

80106a14 <sys_kill>:

int
sys_kill(void)
{
80106a14:	55                   	push   %ebp
80106a15:	89 e5                	mov    %esp,%ebp
80106a17:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a28:	e8 58 f0 ff ff       	call   80105a85 <argint>
80106a2d:	85 c0                	test   %eax,%eax
80106a2f:	79 07                	jns    80106a38 <sys_kill+0x24>
    return -1;
80106a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a36:	eb 0b                	jmp    80106a43 <sys_kill+0x2f>
  return kill(pid);
80106a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a3b:	89 04 24             	mov    %eax,(%esp)
80106a3e:	e8 c9 e4 ff ff       	call   80104f0c <kill>
}
80106a43:	c9                   	leave  
80106a44:	c3                   	ret    

80106a45 <sys_getpid>:

int
sys_getpid(void)
{
80106a45:	55                   	push   %ebp
80106a46:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106a48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a4e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106a51:	5d                   	pop    %ebp
80106a52:	c3                   	ret    

80106a53 <sys_sbrk>:

int
sys_sbrk(void)
{
80106a53:	55                   	push   %ebp
80106a54:	89 e5                	mov    %esp,%ebp
80106a56:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a67:	e8 19 f0 ff ff       	call   80105a85 <argint>
80106a6c:	85 c0                	test   %eax,%eax
80106a6e:	79 07                	jns    80106a77 <sys_sbrk+0x24>
    return -1;
80106a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a75:	eb 24                	jmp    80106a9b <sys_sbrk+0x48>
  addr = proc->sz;
80106a77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a7d:	8b 00                	mov    (%eax),%eax
80106a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a85:	89 04 24             	mov    %eax,(%esp)
80106a88:	e8 ed d8 ff ff       	call   8010437a <growproc>
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	79 07                	jns    80106a98 <sys_sbrk+0x45>
    return -1;
80106a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a96:	eb 03                	jmp    80106a9b <sys_sbrk+0x48>
  return addr;
80106a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a9b:	c9                   	leave  
80106a9c:	c3                   	ret    

80106a9d <sys_sleep>:

int
sys_sleep(void)
{
80106a9d:	55                   	push   %ebp
80106a9e:	89 e5                	mov    %esp,%ebp
80106aa0:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106aa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ab1:	e8 cf ef ff ff       	call   80105a85 <argint>
80106ab6:	85 c0                	test   %eax,%eax
80106ab8:	79 07                	jns    80106ac1 <sys_sleep+0x24>
    return -1;
80106aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106abf:	eb 6c                	jmp    80106b2d <sys_sleep+0x90>
  acquire(&tickslock);
80106ac1:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106ac8:	e8 5f e9 ff ff       	call   8010542c <acquire>
  ticks0 = ticks;
80106acd:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106ad5:	eb 34                	jmp    80106b0b <sys_sleep+0x6e>
    if(proc->killed){
80106ad7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106add:	8b 40 24             	mov    0x24(%eax),%eax
80106ae0:	85 c0                	test   %eax,%eax
80106ae2:	74 13                	je     80106af7 <sys_sleep+0x5a>
      release(&tickslock);
80106ae4:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106aeb:	e8 e6 e9 ff ff       	call   801054d6 <release>
      return -1;
80106af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af5:	eb 36                	jmp    80106b2d <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106af7:	c7 44 24 04 a0 30 11 	movl   $0x801130a0,0x4(%esp)
80106afe:	80 
80106aff:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80106b06:	e8 92 e2 ff ff       	call   80104d9d <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b0b:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106b10:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106b13:	89 c2                	mov    %eax,%edx
80106b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b18:	39 c2                	cmp    %eax,%edx
80106b1a:	72 bb                	jb     80106ad7 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106b1c:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106b23:	e8 ae e9 ff ff       	call   801054d6 <release>
  return 0;
80106b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b2d:	c9                   	leave  
80106b2e:	c3                   	ret    

80106b2f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106b2f:	55                   	push   %ebp
80106b30:	89 e5                	mov    %esp,%ebp
80106b32:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106b35:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106b3c:	e8 eb e8 ff ff       	call   8010542c <acquire>
  xticks = ticks;
80106b41:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106b49:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106b50:	e8 81 e9 ff ff       	call   801054d6 <release>
  return xticks;
80106b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b58:	c9                   	leave  
80106b59:	c3                   	ret    

80106b5a <sys_tsleep>:

int
sys_tsleep(void)
{
80106b5a:	55                   	push   %ebp
80106b5b:	89 e5                	mov    %esp,%ebp
80106b5d:	83 ec 08             	sub    $0x8,%esp
    tsleep();
80106b60:	e8 1c e5 ff ff       	call   80105081 <tsleep>
    return 0;
80106b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    

80106b6c <sys_twakeup>:

int 
sys_twakeup(void)
{
80106b6c:	55                   	push   %ebp
80106b6d:	89 e5                	mov    %esp,%ebp
80106b6f:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
80106b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b75:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b80:	e8 00 ef ff ff       	call   80105a85 <argint>
80106b85:	85 c0                	test   %eax,%eax
80106b87:	79 07                	jns    80106b90 <sys_twakeup+0x24>
        return -1;
80106b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b8e:	eb 10                	jmp    80106ba0 <sys_twakeup+0x34>
    }
        twakeup(tid);
80106b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b93:	89 04 24             	mov    %eax,(%esp)
80106b96:	e8 de e2 ff ff       	call   80104e79 <twakeup>
        return 0;
80106b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ba0:	c9                   	leave  
80106ba1:	c3                   	ret    

80106ba2 <sys_thread_yield>:

/////////////////////////////////////////
int
sys_thread_yield(void)
{
80106ba2:	55                   	push   %ebp
80106ba3:	89 e5                	mov    %esp,%ebp
80106ba5:	83 ec 18             	sub    $0x18,%esp
  //cprintf("Yielded_1\n");
  //yield();
  thread_yield();
80106ba8:	e8 45 e5 ff ff       	call   801050f2 <thread_yield>
  cprintf("Yielded_2\n");
80106bad:	c7 04 24 ae 91 10 80 	movl   $0x801091ae,(%esp)
80106bb4:	e8 e7 97 ff ff       	call   801003a0 <cprintf>
  return 0;
80106bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bbe:	c9                   	leave  
80106bbf:	c3                   	ret    

80106bc0 <sys_thread_yield3>:

int
sys_thread_yield3(void)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	83 ec 28             	sub    $0x28,%esp
  int tid;
    if(argint(0,&tid) < 0){
80106bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bcd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bd4:	e8 ac ee ff ff       	call   80105a85 <argint>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	79 07                	jns    80106be4 <sys_thread_yield3+0x24>
        return -1;
80106bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be2:	eb 10                	jmp    80106bf4 <sys_thread_yield3+0x34>
    }
  thread_yield3(tid);
80106be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be7:	89 04 24             	mov    %eax,(%esp)
80106bea:	e8 d9 e7 ff ff       	call   801053c8 <thread_yield3>
  return 0;
80106bef:	b8 00 00 00 00       	mov    $0x0,%eax
80106bf4:	c9                   	leave  
80106bf5:	c3                   	ret    

80106bf6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106bf6:	55                   	push   %ebp
80106bf7:	89 e5                	mov    %esp,%ebp
80106bf9:	83 ec 08             	sub    $0x8,%esp
80106bfc:	8b 55 08             	mov    0x8(%ebp),%edx
80106bff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c02:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106c06:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c09:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c0d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c11:	ee                   	out    %al,(%dx)
}
80106c12:	c9                   	leave  
80106c13:	c3                   	ret    

80106c14 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106c1a:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106c21:	00 
80106c22:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106c29:	e8 c8 ff ff ff       	call   80106bf6 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106c2e:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106c35:	00 
80106c36:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106c3d:	e8 b4 ff ff ff       	call   80106bf6 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106c42:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106c49:	00 
80106c4a:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106c51:	e8 a0 ff ff ff       	call   80106bf6 <outb>
  picenable(IRQ_TIMER);
80106c56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c5d:	e8 06 cf ff ff       	call   80103b68 <picenable>
}
80106c62:	c9                   	leave  
80106c63:	c3                   	ret    

80106c64 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c64:	1e                   	push   %ds
  pushl %es
80106c65:	06                   	push   %es
  pushl %fs
80106c66:	0f a0                	push   %fs
  pushl %gs
80106c68:	0f a8                	push   %gs
  pushal
80106c6a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106c6b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c6f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c71:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106c73:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106c77:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106c79:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c7b:	54                   	push   %esp
  call trap
80106c7c:	e8 d8 01 00 00       	call   80106e59 <trap>
  addl $4, %esp
80106c81:	83 c4 04             	add    $0x4,%esp

80106c84 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c84:	61                   	popa   
  popl %gs
80106c85:	0f a9                	pop    %gs
  popl %fs
80106c87:	0f a1                	pop    %fs
  popl %es
80106c89:	07                   	pop    %es
  popl %ds
80106c8a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c8b:	83 c4 08             	add    $0x8,%esp
  iret
80106c8e:	cf                   	iret   

80106c8f <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106c8f:	55                   	push   %ebp
80106c90:	89 e5                	mov    %esp,%ebp
80106c92:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106c95:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c98:	83 e8 01             	sub    $0x1,%eax
80106c9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca9:	c1 e8 10             	shr    $0x10,%eax
80106cac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106cb0:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106cb3:	0f 01 18             	lidtl  (%eax)
}
80106cb6:	c9                   	leave  
80106cb7:	c3                   	ret    

80106cb8 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106cb8:	55                   	push   %ebp
80106cb9:	89 e5                	mov    %esp,%ebp
80106cbb:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106cbe:	0f 20 d0             	mov    %cr2,%eax
80106cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cc7:	c9                   	leave  
80106cc8:	c3                   	ret    

80106cc9 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106cc9:	55                   	push   %ebp
80106cca:	89 e5                	mov    %esp,%ebp
80106ccc:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106cd6:	e9 c3 00 00 00       	jmp    80106d9e <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cde:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106ce5:	89 c2                	mov    %eax,%edx
80106ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cea:	66 89 14 c5 e0 30 11 	mov    %dx,-0x7feecf20(,%eax,8)
80106cf1:	80 
80106cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf5:	66 c7 04 c5 e2 30 11 	movw   $0x8,-0x7feecf1e(,%eax,8)
80106cfc:	80 08 00 
80106cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d02:	0f b6 14 c5 e4 30 11 	movzbl -0x7feecf1c(,%eax,8),%edx
80106d09:	80 
80106d0a:	83 e2 e0             	and    $0xffffffe0,%edx
80106d0d:	88 14 c5 e4 30 11 80 	mov    %dl,-0x7feecf1c(,%eax,8)
80106d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d17:	0f b6 14 c5 e4 30 11 	movzbl -0x7feecf1c(,%eax,8),%edx
80106d1e:	80 
80106d1f:	83 e2 1f             	and    $0x1f,%edx
80106d22:	88 14 c5 e4 30 11 80 	mov    %dl,-0x7feecf1c(,%eax,8)
80106d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d2c:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106d33:	80 
80106d34:	83 e2 f0             	and    $0xfffffff0,%edx
80106d37:	83 ca 0e             	or     $0xe,%edx
80106d3a:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d44:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106d4b:	80 
80106d4c:	83 e2 ef             	and    $0xffffffef,%edx
80106d4f:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d59:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106d60:	80 
80106d61:	83 e2 9f             	and    $0xffffff9f,%edx
80106d64:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6e:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106d75:	80 
80106d76:	83 ca 80             	or     $0xffffff80,%edx
80106d79:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d83:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106d8a:	c1 e8 10             	shr    $0x10,%eax
80106d8d:	89 c2                	mov    %eax,%edx
80106d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d92:	66 89 14 c5 e6 30 11 	mov    %dx,-0x7feecf1a(,%eax,8)
80106d99:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106d9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d9e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106da5:	0f 8e 30 ff ff ff    	jle    80106cdb <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106dab:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106db0:	66 a3 e0 32 11 80    	mov    %ax,0x801132e0
80106db6:	66 c7 05 e2 32 11 80 	movw   $0x8,0x801132e2
80106dbd:	08 00 
80106dbf:	0f b6 05 e4 32 11 80 	movzbl 0x801132e4,%eax
80106dc6:	83 e0 e0             	and    $0xffffffe0,%eax
80106dc9:	a2 e4 32 11 80       	mov    %al,0x801132e4
80106dce:	0f b6 05 e4 32 11 80 	movzbl 0x801132e4,%eax
80106dd5:	83 e0 1f             	and    $0x1f,%eax
80106dd8:	a2 e4 32 11 80       	mov    %al,0x801132e4
80106ddd:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106de4:	83 c8 0f             	or     $0xf,%eax
80106de7:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106dec:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106df3:	83 e0 ef             	and    $0xffffffef,%eax
80106df6:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106dfb:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106e02:	83 c8 60             	or     $0x60,%eax
80106e05:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106e0a:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106e11:	83 c8 80             	or     $0xffffff80,%eax
80106e14:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106e19:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106e1e:	c1 e8 10             	shr    $0x10,%eax
80106e21:	66 a3 e6 32 11 80    	mov    %ax,0x801132e6
  
  initlock(&tickslock, "time");
80106e27:	c7 44 24 04 bc 91 10 	movl   $0x801091bc,0x4(%esp)
80106e2e:	80 
80106e2f:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106e36:	e8 d0 e5 ff ff       	call   8010540b <initlock>
}
80106e3b:	c9                   	leave  
80106e3c:	c3                   	ret    

80106e3d <idtinit>:

void
idtinit(void)
{
80106e3d:	55                   	push   %ebp
80106e3e:	89 e5                	mov    %esp,%ebp
80106e40:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106e43:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106e4a:	00 
80106e4b:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
80106e52:	e8 38 fe ff ff       	call   80106c8f <lidt>
}
80106e57:	c9                   	leave  
80106e58:	c3                   	ret    

80106e59 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106e59:	55                   	push   %ebp
80106e5a:	89 e5                	mov    %esp,%ebp
80106e5c:	57                   	push   %edi
80106e5d:	56                   	push   %esi
80106e5e:	53                   	push   %ebx
80106e5f:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106e62:	8b 45 08             	mov    0x8(%ebp),%eax
80106e65:	8b 40 30             	mov    0x30(%eax),%eax
80106e68:	83 f8 40             	cmp    $0x40,%eax
80106e6b:	75 3f                	jne    80106eac <trap+0x53>
    if(proc->killed)
80106e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e73:	8b 40 24             	mov    0x24(%eax),%eax
80106e76:	85 c0                	test   %eax,%eax
80106e78:	74 05                	je     80106e7f <trap+0x26>
      exit();
80106e7a:	e8 41 da ff ff       	call   801048c0 <exit>
    proc->tf = tf;
80106e7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e85:	8b 55 08             	mov    0x8(%ebp),%edx
80106e88:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106e8b:	e8 d6 ec ff ff       	call   80105b66 <syscall>
    if(proc->killed)
80106e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e96:	8b 40 24             	mov    0x24(%eax),%eax
80106e99:	85 c0                	test   %eax,%eax
80106e9b:	74 0a                	je     80106ea7 <trap+0x4e>
      exit();
80106e9d:	e8 1e da ff ff       	call   801048c0 <exit>
    return;
80106ea2:	e9 2d 02 00 00       	jmp    801070d4 <trap+0x27b>
80106ea7:	e9 28 02 00 00       	jmp    801070d4 <trap+0x27b>
  }

  switch(tf->trapno){
80106eac:	8b 45 08             	mov    0x8(%ebp),%eax
80106eaf:	8b 40 30             	mov    0x30(%eax),%eax
80106eb2:	83 e8 20             	sub    $0x20,%eax
80106eb5:	83 f8 1f             	cmp    $0x1f,%eax
80106eb8:	0f 87 bc 00 00 00    	ja     80106f7a <trap+0x121>
80106ebe:	8b 04 85 64 92 10 80 	mov    -0x7fef6d9c(,%eax,4),%eax
80106ec5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106ec7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ecd:	0f b6 00             	movzbl (%eax),%eax
80106ed0:	84 c0                	test   %al,%al
80106ed2:	75 31                	jne    80106f05 <trap+0xac>
      acquire(&tickslock);
80106ed4:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106edb:	e8 4c e5 ff ff       	call   8010542c <acquire>
      ticks++;
80106ee0:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106ee5:	83 c0 01             	add    $0x1,%eax
80106ee8:	a3 e0 38 11 80       	mov    %eax,0x801138e0
      wakeup(&ticks);
80106eed:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80106ef4:	e8 e8 df ff ff       	call   80104ee1 <wakeup>
      release(&tickslock);
80106ef9:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106f00:	e8 d1 e5 ff ff       	call   801054d6 <release>
    }
    lapiceoi();
80106f05:	e8 af c0 ff ff       	call   80102fb9 <lapiceoi>
    break;
80106f0a:	e9 41 01 00 00       	jmp    80107050 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106f0f:	e8 ea b7 ff ff       	call   801026fe <ideintr>
    lapiceoi();
80106f14:	e8 a0 c0 ff ff       	call   80102fb9 <lapiceoi>
    break;
80106f19:	e9 32 01 00 00       	jmp    80107050 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106f1e:	e8 82 be ff ff       	call   80102da5 <kbdintr>
    lapiceoi();
80106f23:	e8 91 c0 ff ff       	call   80102fb9 <lapiceoi>
    break;
80106f28:	e9 23 01 00 00       	jmp    80107050 <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106f2d:	e8 97 03 00 00       	call   801072c9 <uartintr>
    lapiceoi();
80106f32:	e8 82 c0 ff ff       	call   80102fb9 <lapiceoi>
    break;
80106f37:	e9 14 01 00 00       	jmp    80107050 <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3f:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106f42:	8b 45 08             	mov    0x8(%ebp),%eax
80106f45:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f49:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106f4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f52:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f55:	0f b6 c0             	movzbl %al,%eax
80106f58:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106f5c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106f60:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f64:	c7 04 24 c4 91 10 80 	movl   $0x801091c4,(%esp)
80106f6b:	e8 30 94 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106f70:	e8 44 c0 ff ff       	call   80102fb9 <lapiceoi>
    break;
80106f75:	e9 d6 00 00 00       	jmp    80107050 <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106f7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f80:	85 c0                	test   %eax,%eax
80106f82:	74 11                	je     80106f95 <trap+0x13c>
80106f84:	8b 45 08             	mov    0x8(%ebp),%eax
80106f87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f8b:	0f b7 c0             	movzwl %ax,%eax
80106f8e:	83 e0 03             	and    $0x3,%eax
80106f91:	85 c0                	test   %eax,%eax
80106f93:	75 46                	jne    80106fdb <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f95:	e8 1e fd ff ff       	call   80106cb8 <rcr2>
80106f9a:	8b 55 08             	mov    0x8(%ebp),%edx
80106f9d:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106fa0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106fa7:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106faa:	0f b6 ca             	movzbl %dl,%ecx
80106fad:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb0:	8b 52 30             	mov    0x30(%edx),%edx
80106fb3:	89 44 24 10          	mov    %eax,0x10(%esp)
80106fb7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106fbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106fbf:	89 54 24 04          	mov    %edx,0x4(%esp)
80106fc3:	c7 04 24 e8 91 10 80 	movl   $0x801091e8,(%esp)
80106fca:	e8 d1 93 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106fcf:	c7 04 24 1a 92 10 80 	movl   $0x8010921a,(%esp)
80106fd6:	e8 5f 95 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106fdb:	e8 d8 fc ff ff       	call   80106cb8 <rcr2>
80106fe0:	89 c2                	mov    %eax,%edx
80106fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe5:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106fe8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fee:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ff1:	0f b6 f0             	movzbl %al,%esi
80106ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff7:	8b 58 34             	mov    0x34(%eax),%ebx
80106ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffd:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107000:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107006:	83 c0 6c             	add    $0x6c,%eax
80107009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010700c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107012:	8b 40 10             	mov    0x10(%eax),%eax
80107015:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107019:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010701d:	89 74 24 14          	mov    %esi,0x14(%esp)
80107021:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107025:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107029:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010702c:	89 74 24 08          	mov    %esi,0x8(%esp)
80107030:	89 44 24 04          	mov    %eax,0x4(%esp)
80107034:	c7 04 24 20 92 10 80 	movl   $0x80109220,(%esp)
8010703b:	e8 60 93 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107040:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107046:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010704d:	eb 01                	jmp    80107050 <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010704f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107050:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107056:	85 c0                	test   %eax,%eax
80107058:	74 24                	je     8010707e <trap+0x225>
8010705a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107060:	8b 40 24             	mov    0x24(%eax),%eax
80107063:	85 c0                	test   %eax,%eax
80107065:	74 17                	je     8010707e <trap+0x225>
80107067:	8b 45 08             	mov    0x8(%ebp),%eax
8010706a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010706e:	0f b7 c0             	movzwl %ax,%eax
80107071:	83 e0 03             	and    $0x3,%eax
80107074:	83 f8 03             	cmp    $0x3,%eax
80107077:	75 05                	jne    8010707e <trap+0x225>
    exit();
80107079:	e8 42 d8 ff ff       	call   801048c0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010707e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107084:	85 c0                	test   %eax,%eax
80107086:	74 1e                	je     801070a6 <trap+0x24d>
80107088:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010708e:	8b 40 0c             	mov    0xc(%eax),%eax
80107091:	83 f8 04             	cmp    $0x4,%eax
80107094:	75 10                	jne    801070a6 <trap+0x24d>
80107096:	8b 45 08             	mov    0x8(%ebp),%eax
80107099:	8b 40 30             	mov    0x30(%eax),%eax
8010709c:	83 f8 20             	cmp    $0x20,%eax
8010709f:	75 05                	jne    801070a6 <trap+0x24d>
    yield();
801070a1:	e8 99 dc ff ff       	call   80104d3f <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801070a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070ac:	85 c0                	test   %eax,%eax
801070ae:	74 24                	je     801070d4 <trap+0x27b>
801070b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070b6:	8b 40 24             	mov    0x24(%eax),%eax
801070b9:	85 c0                	test   %eax,%eax
801070bb:	74 17                	je     801070d4 <trap+0x27b>
801070bd:	8b 45 08             	mov    0x8(%ebp),%eax
801070c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070c4:	0f b7 c0             	movzwl %ax,%eax
801070c7:	83 e0 03             	and    $0x3,%eax
801070ca:	83 f8 03             	cmp    $0x3,%eax
801070cd:	75 05                	jne    801070d4 <trap+0x27b>
    exit();
801070cf:	e8 ec d7 ff ff       	call   801048c0 <exit>
}
801070d4:	83 c4 3c             	add    $0x3c,%esp
801070d7:	5b                   	pop    %ebx
801070d8:	5e                   	pop    %esi
801070d9:	5f                   	pop    %edi
801070da:	5d                   	pop    %ebp
801070db:	c3                   	ret    

801070dc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801070dc:	55                   	push   %ebp
801070dd:	89 e5                	mov    %esp,%ebp
801070df:	83 ec 14             	sub    $0x14,%esp
801070e2:	8b 45 08             	mov    0x8(%ebp),%eax
801070e5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801070e9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801070ed:	89 c2                	mov    %eax,%edx
801070ef:	ec                   	in     (%dx),%al
801070f0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801070f3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801070f7:	c9                   	leave  
801070f8:	c3                   	ret    

801070f9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801070f9:	55                   	push   %ebp
801070fa:	89 e5                	mov    %esp,%ebp
801070fc:	83 ec 08             	sub    $0x8,%esp
801070ff:	8b 55 08             	mov    0x8(%ebp),%edx
80107102:	8b 45 0c             	mov    0xc(%ebp),%eax
80107105:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107109:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010710c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107110:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107114:	ee                   	out    %al,(%dx)
}
80107115:	c9                   	leave  
80107116:	c3                   	ret    

80107117 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107117:	55                   	push   %ebp
80107118:	89 e5                	mov    %esp,%ebp
8010711a:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010711d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107124:	00 
80107125:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010712c:	e8 c8 ff ff ff       	call   801070f9 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107131:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107138:	00 
80107139:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107140:	e8 b4 ff ff ff       	call   801070f9 <outb>
  outb(COM1+0, 115200/9600);
80107145:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010714c:	00 
8010714d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107154:	e8 a0 ff ff ff       	call   801070f9 <outb>
  outb(COM1+1, 0);
80107159:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107160:	00 
80107161:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107168:	e8 8c ff ff ff       	call   801070f9 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010716d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107174:	00 
80107175:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010717c:	e8 78 ff ff ff       	call   801070f9 <outb>
  outb(COM1+4, 0);
80107181:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107188:	00 
80107189:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107190:	e8 64 ff ff ff       	call   801070f9 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107195:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010719c:	00 
8010719d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801071a4:	e8 50 ff ff ff       	call   801070f9 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801071a9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801071b0:	e8 27 ff ff ff       	call   801070dc <inb>
801071b5:	3c ff                	cmp    $0xff,%al
801071b7:	75 02                	jne    801071bb <uartinit+0xa4>
    return;
801071b9:	eb 6a                	jmp    80107225 <uartinit+0x10e>
  uart = 1;
801071bb:	c7 05 70 c6 10 80 01 	movl   $0x1,0x8010c670
801071c2:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801071c5:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801071cc:	e8 0b ff ff ff       	call   801070dc <inb>
  inb(COM1+0);
801071d1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801071d8:	e8 ff fe ff ff       	call   801070dc <inb>
  picenable(IRQ_COM1);
801071dd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801071e4:	e8 7f c9 ff ff       	call   80103b68 <picenable>
  ioapicenable(IRQ_COM1, 0);
801071e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801071f0:	00 
801071f1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801071f8:	e8 80 b7 ff ff       	call   8010297d <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801071fd:	c7 45 f4 e4 92 10 80 	movl   $0x801092e4,-0xc(%ebp)
80107204:	eb 15                	jmp    8010721b <uartinit+0x104>
    uartputc(*p);
80107206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107209:	0f b6 00             	movzbl (%eax),%eax
8010720c:	0f be c0             	movsbl %al,%eax
8010720f:	89 04 24             	mov    %eax,(%esp)
80107212:	e8 10 00 00 00       	call   80107227 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107217:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010721b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721e:	0f b6 00             	movzbl (%eax),%eax
80107221:	84 c0                	test   %al,%al
80107223:	75 e1                	jne    80107206 <uartinit+0xef>
    uartputc(*p);
}
80107225:	c9                   	leave  
80107226:	c3                   	ret    

80107227 <uartputc>:

void
uartputc(int c)
{
80107227:	55                   	push   %ebp
80107228:	89 e5                	mov    %esp,%ebp
8010722a:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010722d:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80107232:	85 c0                	test   %eax,%eax
80107234:	75 02                	jne    80107238 <uartputc+0x11>
    return;
80107236:	eb 4b                	jmp    80107283 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010723f:	eb 10                	jmp    80107251 <uartputc+0x2a>
    microdelay(10);
80107241:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107248:	e8 91 bd ff ff       	call   80102fde <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010724d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107251:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107255:	7f 16                	jg     8010726d <uartputc+0x46>
80107257:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010725e:	e8 79 fe ff ff       	call   801070dc <inb>
80107263:	0f b6 c0             	movzbl %al,%eax
80107266:	83 e0 20             	and    $0x20,%eax
80107269:	85 c0                	test   %eax,%eax
8010726b:	74 d4                	je     80107241 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010726d:	8b 45 08             	mov    0x8(%ebp),%eax
80107270:	0f b6 c0             	movzbl %al,%eax
80107273:	89 44 24 04          	mov    %eax,0x4(%esp)
80107277:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010727e:	e8 76 fe ff ff       	call   801070f9 <outb>
}
80107283:	c9                   	leave  
80107284:	c3                   	ret    

80107285 <uartgetc>:

static int
uartgetc(void)
{
80107285:	55                   	push   %ebp
80107286:	89 e5                	mov    %esp,%ebp
80107288:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010728b:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80107290:	85 c0                	test   %eax,%eax
80107292:	75 07                	jne    8010729b <uartgetc+0x16>
    return -1;
80107294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107299:	eb 2c                	jmp    801072c7 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010729b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801072a2:	e8 35 fe ff ff       	call   801070dc <inb>
801072a7:	0f b6 c0             	movzbl %al,%eax
801072aa:	83 e0 01             	and    $0x1,%eax
801072ad:	85 c0                	test   %eax,%eax
801072af:	75 07                	jne    801072b8 <uartgetc+0x33>
    return -1;
801072b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072b6:	eb 0f                	jmp    801072c7 <uartgetc+0x42>
  return inb(COM1+0);
801072b8:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072bf:	e8 18 fe ff ff       	call   801070dc <inb>
801072c4:	0f b6 c0             	movzbl %al,%eax
}
801072c7:	c9                   	leave  
801072c8:	c3                   	ret    

801072c9 <uartintr>:

void
uartintr(void)
{
801072c9:	55                   	push   %ebp
801072ca:	89 e5                	mov    %esp,%ebp
801072cc:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801072cf:	c7 04 24 85 72 10 80 	movl   $0x80107285,(%esp)
801072d6:	e8 d2 94 ff ff       	call   801007ad <consoleintr>
}
801072db:	c9                   	leave  
801072dc:	c3                   	ret    

801072dd <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $0
801072df:	6a 00                	push   $0x0
  jmp alltraps
801072e1:	e9 7e f9 ff ff       	jmp    80106c64 <alltraps>

801072e6 <vector1>:
.globl vector1
vector1:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $1
801072e8:	6a 01                	push   $0x1
  jmp alltraps
801072ea:	e9 75 f9 ff ff       	jmp    80106c64 <alltraps>

801072ef <vector2>:
.globl vector2
vector2:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $2
801072f1:	6a 02                	push   $0x2
  jmp alltraps
801072f3:	e9 6c f9 ff ff       	jmp    80106c64 <alltraps>

801072f8 <vector3>:
.globl vector3
vector3:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $3
801072fa:	6a 03                	push   $0x3
  jmp alltraps
801072fc:	e9 63 f9 ff ff       	jmp    80106c64 <alltraps>

80107301 <vector4>:
.globl vector4
vector4:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $4
80107303:	6a 04                	push   $0x4
  jmp alltraps
80107305:	e9 5a f9 ff ff       	jmp    80106c64 <alltraps>

8010730a <vector5>:
.globl vector5
vector5:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $5
8010730c:	6a 05                	push   $0x5
  jmp alltraps
8010730e:	e9 51 f9 ff ff       	jmp    80106c64 <alltraps>

80107313 <vector6>:
.globl vector6
vector6:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $6
80107315:	6a 06                	push   $0x6
  jmp alltraps
80107317:	e9 48 f9 ff ff       	jmp    80106c64 <alltraps>

8010731c <vector7>:
.globl vector7
vector7:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $7
8010731e:	6a 07                	push   $0x7
  jmp alltraps
80107320:	e9 3f f9 ff ff       	jmp    80106c64 <alltraps>

80107325 <vector8>:
.globl vector8
vector8:
  pushl $8
80107325:	6a 08                	push   $0x8
  jmp alltraps
80107327:	e9 38 f9 ff ff       	jmp    80106c64 <alltraps>

8010732c <vector9>:
.globl vector9
vector9:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $9
8010732e:	6a 09                	push   $0x9
  jmp alltraps
80107330:	e9 2f f9 ff ff       	jmp    80106c64 <alltraps>

80107335 <vector10>:
.globl vector10
vector10:
  pushl $10
80107335:	6a 0a                	push   $0xa
  jmp alltraps
80107337:	e9 28 f9 ff ff       	jmp    80106c64 <alltraps>

8010733c <vector11>:
.globl vector11
vector11:
  pushl $11
8010733c:	6a 0b                	push   $0xb
  jmp alltraps
8010733e:	e9 21 f9 ff ff       	jmp    80106c64 <alltraps>

80107343 <vector12>:
.globl vector12
vector12:
  pushl $12
80107343:	6a 0c                	push   $0xc
  jmp alltraps
80107345:	e9 1a f9 ff ff       	jmp    80106c64 <alltraps>

8010734a <vector13>:
.globl vector13
vector13:
  pushl $13
8010734a:	6a 0d                	push   $0xd
  jmp alltraps
8010734c:	e9 13 f9 ff ff       	jmp    80106c64 <alltraps>

80107351 <vector14>:
.globl vector14
vector14:
  pushl $14
80107351:	6a 0e                	push   $0xe
  jmp alltraps
80107353:	e9 0c f9 ff ff       	jmp    80106c64 <alltraps>

80107358 <vector15>:
.globl vector15
vector15:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $15
8010735a:	6a 0f                	push   $0xf
  jmp alltraps
8010735c:	e9 03 f9 ff ff       	jmp    80106c64 <alltraps>

80107361 <vector16>:
.globl vector16
vector16:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $16
80107363:	6a 10                	push   $0x10
  jmp alltraps
80107365:	e9 fa f8 ff ff       	jmp    80106c64 <alltraps>

8010736a <vector17>:
.globl vector17
vector17:
  pushl $17
8010736a:	6a 11                	push   $0x11
  jmp alltraps
8010736c:	e9 f3 f8 ff ff       	jmp    80106c64 <alltraps>

80107371 <vector18>:
.globl vector18
vector18:
  pushl $0
80107371:	6a 00                	push   $0x0
  pushl $18
80107373:	6a 12                	push   $0x12
  jmp alltraps
80107375:	e9 ea f8 ff ff       	jmp    80106c64 <alltraps>

8010737a <vector19>:
.globl vector19
vector19:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $19
8010737c:	6a 13                	push   $0x13
  jmp alltraps
8010737e:	e9 e1 f8 ff ff       	jmp    80106c64 <alltraps>

80107383 <vector20>:
.globl vector20
vector20:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $20
80107385:	6a 14                	push   $0x14
  jmp alltraps
80107387:	e9 d8 f8 ff ff       	jmp    80106c64 <alltraps>

8010738c <vector21>:
.globl vector21
vector21:
  pushl $0
8010738c:	6a 00                	push   $0x0
  pushl $21
8010738e:	6a 15                	push   $0x15
  jmp alltraps
80107390:	e9 cf f8 ff ff       	jmp    80106c64 <alltraps>

80107395 <vector22>:
.globl vector22
vector22:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $22
80107397:	6a 16                	push   $0x16
  jmp alltraps
80107399:	e9 c6 f8 ff ff       	jmp    80106c64 <alltraps>

8010739e <vector23>:
.globl vector23
vector23:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $23
801073a0:	6a 17                	push   $0x17
  jmp alltraps
801073a2:	e9 bd f8 ff ff       	jmp    80106c64 <alltraps>

801073a7 <vector24>:
.globl vector24
vector24:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $24
801073a9:	6a 18                	push   $0x18
  jmp alltraps
801073ab:	e9 b4 f8 ff ff       	jmp    80106c64 <alltraps>

801073b0 <vector25>:
.globl vector25
vector25:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $25
801073b2:	6a 19                	push   $0x19
  jmp alltraps
801073b4:	e9 ab f8 ff ff       	jmp    80106c64 <alltraps>

801073b9 <vector26>:
.globl vector26
vector26:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $26
801073bb:	6a 1a                	push   $0x1a
  jmp alltraps
801073bd:	e9 a2 f8 ff ff       	jmp    80106c64 <alltraps>

801073c2 <vector27>:
.globl vector27
vector27:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $27
801073c4:	6a 1b                	push   $0x1b
  jmp alltraps
801073c6:	e9 99 f8 ff ff       	jmp    80106c64 <alltraps>

801073cb <vector28>:
.globl vector28
vector28:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $28
801073cd:	6a 1c                	push   $0x1c
  jmp alltraps
801073cf:	e9 90 f8 ff ff       	jmp    80106c64 <alltraps>

801073d4 <vector29>:
.globl vector29
vector29:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $29
801073d6:	6a 1d                	push   $0x1d
  jmp alltraps
801073d8:	e9 87 f8 ff ff       	jmp    80106c64 <alltraps>

801073dd <vector30>:
.globl vector30
vector30:
  pushl $0
801073dd:	6a 00                	push   $0x0
  pushl $30
801073df:	6a 1e                	push   $0x1e
  jmp alltraps
801073e1:	e9 7e f8 ff ff       	jmp    80106c64 <alltraps>

801073e6 <vector31>:
.globl vector31
vector31:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $31
801073e8:	6a 1f                	push   $0x1f
  jmp alltraps
801073ea:	e9 75 f8 ff ff       	jmp    80106c64 <alltraps>

801073ef <vector32>:
.globl vector32
vector32:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $32
801073f1:	6a 20                	push   $0x20
  jmp alltraps
801073f3:	e9 6c f8 ff ff       	jmp    80106c64 <alltraps>

801073f8 <vector33>:
.globl vector33
vector33:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $33
801073fa:	6a 21                	push   $0x21
  jmp alltraps
801073fc:	e9 63 f8 ff ff       	jmp    80106c64 <alltraps>

80107401 <vector34>:
.globl vector34
vector34:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $34
80107403:	6a 22                	push   $0x22
  jmp alltraps
80107405:	e9 5a f8 ff ff       	jmp    80106c64 <alltraps>

8010740a <vector35>:
.globl vector35
vector35:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $35
8010740c:	6a 23                	push   $0x23
  jmp alltraps
8010740e:	e9 51 f8 ff ff       	jmp    80106c64 <alltraps>

80107413 <vector36>:
.globl vector36
vector36:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $36
80107415:	6a 24                	push   $0x24
  jmp alltraps
80107417:	e9 48 f8 ff ff       	jmp    80106c64 <alltraps>

8010741c <vector37>:
.globl vector37
vector37:
  pushl $0
8010741c:	6a 00                	push   $0x0
  pushl $37
8010741e:	6a 25                	push   $0x25
  jmp alltraps
80107420:	e9 3f f8 ff ff       	jmp    80106c64 <alltraps>

80107425 <vector38>:
.globl vector38
vector38:
  pushl $0
80107425:	6a 00                	push   $0x0
  pushl $38
80107427:	6a 26                	push   $0x26
  jmp alltraps
80107429:	e9 36 f8 ff ff       	jmp    80106c64 <alltraps>

8010742e <vector39>:
.globl vector39
vector39:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $39
80107430:	6a 27                	push   $0x27
  jmp alltraps
80107432:	e9 2d f8 ff ff       	jmp    80106c64 <alltraps>

80107437 <vector40>:
.globl vector40
vector40:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $40
80107439:	6a 28                	push   $0x28
  jmp alltraps
8010743b:	e9 24 f8 ff ff       	jmp    80106c64 <alltraps>

80107440 <vector41>:
.globl vector41
vector41:
  pushl $0
80107440:	6a 00                	push   $0x0
  pushl $41
80107442:	6a 29                	push   $0x29
  jmp alltraps
80107444:	e9 1b f8 ff ff       	jmp    80106c64 <alltraps>

80107449 <vector42>:
.globl vector42
vector42:
  pushl $0
80107449:	6a 00                	push   $0x0
  pushl $42
8010744b:	6a 2a                	push   $0x2a
  jmp alltraps
8010744d:	e9 12 f8 ff ff       	jmp    80106c64 <alltraps>

80107452 <vector43>:
.globl vector43
vector43:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $43
80107454:	6a 2b                	push   $0x2b
  jmp alltraps
80107456:	e9 09 f8 ff ff       	jmp    80106c64 <alltraps>

8010745b <vector44>:
.globl vector44
vector44:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $44
8010745d:	6a 2c                	push   $0x2c
  jmp alltraps
8010745f:	e9 00 f8 ff ff       	jmp    80106c64 <alltraps>

80107464 <vector45>:
.globl vector45
vector45:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $45
80107466:	6a 2d                	push   $0x2d
  jmp alltraps
80107468:	e9 f7 f7 ff ff       	jmp    80106c64 <alltraps>

8010746d <vector46>:
.globl vector46
vector46:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $46
8010746f:	6a 2e                	push   $0x2e
  jmp alltraps
80107471:	e9 ee f7 ff ff       	jmp    80106c64 <alltraps>

80107476 <vector47>:
.globl vector47
vector47:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $47
80107478:	6a 2f                	push   $0x2f
  jmp alltraps
8010747a:	e9 e5 f7 ff ff       	jmp    80106c64 <alltraps>

8010747f <vector48>:
.globl vector48
vector48:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $48
80107481:	6a 30                	push   $0x30
  jmp alltraps
80107483:	e9 dc f7 ff ff       	jmp    80106c64 <alltraps>

80107488 <vector49>:
.globl vector49
vector49:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $49
8010748a:	6a 31                	push   $0x31
  jmp alltraps
8010748c:	e9 d3 f7 ff ff       	jmp    80106c64 <alltraps>

80107491 <vector50>:
.globl vector50
vector50:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $50
80107493:	6a 32                	push   $0x32
  jmp alltraps
80107495:	e9 ca f7 ff ff       	jmp    80106c64 <alltraps>

8010749a <vector51>:
.globl vector51
vector51:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $51
8010749c:	6a 33                	push   $0x33
  jmp alltraps
8010749e:	e9 c1 f7 ff ff       	jmp    80106c64 <alltraps>

801074a3 <vector52>:
.globl vector52
vector52:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $52
801074a5:	6a 34                	push   $0x34
  jmp alltraps
801074a7:	e9 b8 f7 ff ff       	jmp    80106c64 <alltraps>

801074ac <vector53>:
.globl vector53
vector53:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $53
801074ae:	6a 35                	push   $0x35
  jmp alltraps
801074b0:	e9 af f7 ff ff       	jmp    80106c64 <alltraps>

801074b5 <vector54>:
.globl vector54
vector54:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $54
801074b7:	6a 36                	push   $0x36
  jmp alltraps
801074b9:	e9 a6 f7 ff ff       	jmp    80106c64 <alltraps>

801074be <vector55>:
.globl vector55
vector55:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $55
801074c0:	6a 37                	push   $0x37
  jmp alltraps
801074c2:	e9 9d f7 ff ff       	jmp    80106c64 <alltraps>

801074c7 <vector56>:
.globl vector56
vector56:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $56
801074c9:	6a 38                	push   $0x38
  jmp alltraps
801074cb:	e9 94 f7 ff ff       	jmp    80106c64 <alltraps>

801074d0 <vector57>:
.globl vector57
vector57:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $57
801074d2:	6a 39                	push   $0x39
  jmp alltraps
801074d4:	e9 8b f7 ff ff       	jmp    80106c64 <alltraps>

801074d9 <vector58>:
.globl vector58
vector58:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $58
801074db:	6a 3a                	push   $0x3a
  jmp alltraps
801074dd:	e9 82 f7 ff ff       	jmp    80106c64 <alltraps>

801074e2 <vector59>:
.globl vector59
vector59:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $59
801074e4:	6a 3b                	push   $0x3b
  jmp alltraps
801074e6:	e9 79 f7 ff ff       	jmp    80106c64 <alltraps>

801074eb <vector60>:
.globl vector60
vector60:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $60
801074ed:	6a 3c                	push   $0x3c
  jmp alltraps
801074ef:	e9 70 f7 ff ff       	jmp    80106c64 <alltraps>

801074f4 <vector61>:
.globl vector61
vector61:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $61
801074f6:	6a 3d                	push   $0x3d
  jmp alltraps
801074f8:	e9 67 f7 ff ff       	jmp    80106c64 <alltraps>

801074fd <vector62>:
.globl vector62
vector62:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $62
801074ff:	6a 3e                	push   $0x3e
  jmp alltraps
80107501:	e9 5e f7 ff ff       	jmp    80106c64 <alltraps>

80107506 <vector63>:
.globl vector63
vector63:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $63
80107508:	6a 3f                	push   $0x3f
  jmp alltraps
8010750a:	e9 55 f7 ff ff       	jmp    80106c64 <alltraps>

8010750f <vector64>:
.globl vector64
vector64:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $64
80107511:	6a 40                	push   $0x40
  jmp alltraps
80107513:	e9 4c f7 ff ff       	jmp    80106c64 <alltraps>

80107518 <vector65>:
.globl vector65
vector65:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $65
8010751a:	6a 41                	push   $0x41
  jmp alltraps
8010751c:	e9 43 f7 ff ff       	jmp    80106c64 <alltraps>

80107521 <vector66>:
.globl vector66
vector66:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $66
80107523:	6a 42                	push   $0x42
  jmp alltraps
80107525:	e9 3a f7 ff ff       	jmp    80106c64 <alltraps>

8010752a <vector67>:
.globl vector67
vector67:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $67
8010752c:	6a 43                	push   $0x43
  jmp alltraps
8010752e:	e9 31 f7 ff ff       	jmp    80106c64 <alltraps>

80107533 <vector68>:
.globl vector68
vector68:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $68
80107535:	6a 44                	push   $0x44
  jmp alltraps
80107537:	e9 28 f7 ff ff       	jmp    80106c64 <alltraps>

8010753c <vector69>:
.globl vector69
vector69:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $69
8010753e:	6a 45                	push   $0x45
  jmp alltraps
80107540:	e9 1f f7 ff ff       	jmp    80106c64 <alltraps>

80107545 <vector70>:
.globl vector70
vector70:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $70
80107547:	6a 46                	push   $0x46
  jmp alltraps
80107549:	e9 16 f7 ff ff       	jmp    80106c64 <alltraps>

8010754e <vector71>:
.globl vector71
vector71:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $71
80107550:	6a 47                	push   $0x47
  jmp alltraps
80107552:	e9 0d f7 ff ff       	jmp    80106c64 <alltraps>

80107557 <vector72>:
.globl vector72
vector72:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $72
80107559:	6a 48                	push   $0x48
  jmp alltraps
8010755b:	e9 04 f7 ff ff       	jmp    80106c64 <alltraps>

80107560 <vector73>:
.globl vector73
vector73:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $73
80107562:	6a 49                	push   $0x49
  jmp alltraps
80107564:	e9 fb f6 ff ff       	jmp    80106c64 <alltraps>

80107569 <vector74>:
.globl vector74
vector74:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $74
8010756b:	6a 4a                	push   $0x4a
  jmp alltraps
8010756d:	e9 f2 f6 ff ff       	jmp    80106c64 <alltraps>

80107572 <vector75>:
.globl vector75
vector75:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $75
80107574:	6a 4b                	push   $0x4b
  jmp alltraps
80107576:	e9 e9 f6 ff ff       	jmp    80106c64 <alltraps>

8010757b <vector76>:
.globl vector76
vector76:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $76
8010757d:	6a 4c                	push   $0x4c
  jmp alltraps
8010757f:	e9 e0 f6 ff ff       	jmp    80106c64 <alltraps>

80107584 <vector77>:
.globl vector77
vector77:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $77
80107586:	6a 4d                	push   $0x4d
  jmp alltraps
80107588:	e9 d7 f6 ff ff       	jmp    80106c64 <alltraps>

8010758d <vector78>:
.globl vector78
vector78:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $78
8010758f:	6a 4e                	push   $0x4e
  jmp alltraps
80107591:	e9 ce f6 ff ff       	jmp    80106c64 <alltraps>

80107596 <vector79>:
.globl vector79
vector79:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $79
80107598:	6a 4f                	push   $0x4f
  jmp alltraps
8010759a:	e9 c5 f6 ff ff       	jmp    80106c64 <alltraps>

8010759f <vector80>:
.globl vector80
vector80:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $80
801075a1:	6a 50                	push   $0x50
  jmp alltraps
801075a3:	e9 bc f6 ff ff       	jmp    80106c64 <alltraps>

801075a8 <vector81>:
.globl vector81
vector81:
  pushl $0
801075a8:	6a 00                	push   $0x0
  pushl $81
801075aa:	6a 51                	push   $0x51
  jmp alltraps
801075ac:	e9 b3 f6 ff ff       	jmp    80106c64 <alltraps>

801075b1 <vector82>:
.globl vector82
vector82:
  pushl $0
801075b1:	6a 00                	push   $0x0
  pushl $82
801075b3:	6a 52                	push   $0x52
  jmp alltraps
801075b5:	e9 aa f6 ff ff       	jmp    80106c64 <alltraps>

801075ba <vector83>:
.globl vector83
vector83:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $83
801075bc:	6a 53                	push   $0x53
  jmp alltraps
801075be:	e9 a1 f6 ff ff       	jmp    80106c64 <alltraps>

801075c3 <vector84>:
.globl vector84
vector84:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $84
801075c5:	6a 54                	push   $0x54
  jmp alltraps
801075c7:	e9 98 f6 ff ff       	jmp    80106c64 <alltraps>

801075cc <vector85>:
.globl vector85
vector85:
  pushl $0
801075cc:	6a 00                	push   $0x0
  pushl $85
801075ce:	6a 55                	push   $0x55
  jmp alltraps
801075d0:	e9 8f f6 ff ff       	jmp    80106c64 <alltraps>

801075d5 <vector86>:
.globl vector86
vector86:
  pushl $0
801075d5:	6a 00                	push   $0x0
  pushl $86
801075d7:	6a 56                	push   $0x56
  jmp alltraps
801075d9:	e9 86 f6 ff ff       	jmp    80106c64 <alltraps>

801075de <vector87>:
.globl vector87
vector87:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $87
801075e0:	6a 57                	push   $0x57
  jmp alltraps
801075e2:	e9 7d f6 ff ff       	jmp    80106c64 <alltraps>

801075e7 <vector88>:
.globl vector88
vector88:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $88
801075e9:	6a 58                	push   $0x58
  jmp alltraps
801075eb:	e9 74 f6 ff ff       	jmp    80106c64 <alltraps>

801075f0 <vector89>:
.globl vector89
vector89:
  pushl $0
801075f0:	6a 00                	push   $0x0
  pushl $89
801075f2:	6a 59                	push   $0x59
  jmp alltraps
801075f4:	e9 6b f6 ff ff       	jmp    80106c64 <alltraps>

801075f9 <vector90>:
.globl vector90
vector90:
  pushl $0
801075f9:	6a 00                	push   $0x0
  pushl $90
801075fb:	6a 5a                	push   $0x5a
  jmp alltraps
801075fd:	e9 62 f6 ff ff       	jmp    80106c64 <alltraps>

80107602 <vector91>:
.globl vector91
vector91:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $91
80107604:	6a 5b                	push   $0x5b
  jmp alltraps
80107606:	e9 59 f6 ff ff       	jmp    80106c64 <alltraps>

8010760b <vector92>:
.globl vector92
vector92:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $92
8010760d:	6a 5c                	push   $0x5c
  jmp alltraps
8010760f:	e9 50 f6 ff ff       	jmp    80106c64 <alltraps>

80107614 <vector93>:
.globl vector93
vector93:
  pushl $0
80107614:	6a 00                	push   $0x0
  pushl $93
80107616:	6a 5d                	push   $0x5d
  jmp alltraps
80107618:	e9 47 f6 ff ff       	jmp    80106c64 <alltraps>

8010761d <vector94>:
.globl vector94
vector94:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $94
8010761f:	6a 5e                	push   $0x5e
  jmp alltraps
80107621:	e9 3e f6 ff ff       	jmp    80106c64 <alltraps>

80107626 <vector95>:
.globl vector95
vector95:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $95
80107628:	6a 5f                	push   $0x5f
  jmp alltraps
8010762a:	e9 35 f6 ff ff       	jmp    80106c64 <alltraps>

8010762f <vector96>:
.globl vector96
vector96:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $96
80107631:	6a 60                	push   $0x60
  jmp alltraps
80107633:	e9 2c f6 ff ff       	jmp    80106c64 <alltraps>

80107638 <vector97>:
.globl vector97
vector97:
  pushl $0
80107638:	6a 00                	push   $0x0
  pushl $97
8010763a:	6a 61                	push   $0x61
  jmp alltraps
8010763c:	e9 23 f6 ff ff       	jmp    80106c64 <alltraps>

80107641 <vector98>:
.globl vector98
vector98:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $98
80107643:	6a 62                	push   $0x62
  jmp alltraps
80107645:	e9 1a f6 ff ff       	jmp    80106c64 <alltraps>

8010764a <vector99>:
.globl vector99
vector99:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $99
8010764c:	6a 63                	push   $0x63
  jmp alltraps
8010764e:	e9 11 f6 ff ff       	jmp    80106c64 <alltraps>

80107653 <vector100>:
.globl vector100
vector100:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $100
80107655:	6a 64                	push   $0x64
  jmp alltraps
80107657:	e9 08 f6 ff ff       	jmp    80106c64 <alltraps>

8010765c <vector101>:
.globl vector101
vector101:
  pushl $0
8010765c:	6a 00                	push   $0x0
  pushl $101
8010765e:	6a 65                	push   $0x65
  jmp alltraps
80107660:	e9 ff f5 ff ff       	jmp    80106c64 <alltraps>

80107665 <vector102>:
.globl vector102
vector102:
  pushl $0
80107665:	6a 00                	push   $0x0
  pushl $102
80107667:	6a 66                	push   $0x66
  jmp alltraps
80107669:	e9 f6 f5 ff ff       	jmp    80106c64 <alltraps>

8010766e <vector103>:
.globl vector103
vector103:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $103
80107670:	6a 67                	push   $0x67
  jmp alltraps
80107672:	e9 ed f5 ff ff       	jmp    80106c64 <alltraps>

80107677 <vector104>:
.globl vector104
vector104:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $104
80107679:	6a 68                	push   $0x68
  jmp alltraps
8010767b:	e9 e4 f5 ff ff       	jmp    80106c64 <alltraps>

80107680 <vector105>:
.globl vector105
vector105:
  pushl $0
80107680:	6a 00                	push   $0x0
  pushl $105
80107682:	6a 69                	push   $0x69
  jmp alltraps
80107684:	e9 db f5 ff ff       	jmp    80106c64 <alltraps>

80107689 <vector106>:
.globl vector106
vector106:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $106
8010768b:	6a 6a                	push   $0x6a
  jmp alltraps
8010768d:	e9 d2 f5 ff ff       	jmp    80106c64 <alltraps>

80107692 <vector107>:
.globl vector107
vector107:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $107
80107694:	6a 6b                	push   $0x6b
  jmp alltraps
80107696:	e9 c9 f5 ff ff       	jmp    80106c64 <alltraps>

8010769b <vector108>:
.globl vector108
vector108:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $108
8010769d:	6a 6c                	push   $0x6c
  jmp alltraps
8010769f:	e9 c0 f5 ff ff       	jmp    80106c64 <alltraps>

801076a4 <vector109>:
.globl vector109
vector109:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $109
801076a6:	6a 6d                	push   $0x6d
  jmp alltraps
801076a8:	e9 b7 f5 ff ff       	jmp    80106c64 <alltraps>

801076ad <vector110>:
.globl vector110
vector110:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $110
801076af:	6a 6e                	push   $0x6e
  jmp alltraps
801076b1:	e9 ae f5 ff ff       	jmp    80106c64 <alltraps>

801076b6 <vector111>:
.globl vector111
vector111:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $111
801076b8:	6a 6f                	push   $0x6f
  jmp alltraps
801076ba:	e9 a5 f5 ff ff       	jmp    80106c64 <alltraps>

801076bf <vector112>:
.globl vector112
vector112:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $112
801076c1:	6a 70                	push   $0x70
  jmp alltraps
801076c3:	e9 9c f5 ff ff       	jmp    80106c64 <alltraps>

801076c8 <vector113>:
.globl vector113
vector113:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $113
801076ca:	6a 71                	push   $0x71
  jmp alltraps
801076cc:	e9 93 f5 ff ff       	jmp    80106c64 <alltraps>

801076d1 <vector114>:
.globl vector114
vector114:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $114
801076d3:	6a 72                	push   $0x72
  jmp alltraps
801076d5:	e9 8a f5 ff ff       	jmp    80106c64 <alltraps>

801076da <vector115>:
.globl vector115
vector115:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $115
801076dc:	6a 73                	push   $0x73
  jmp alltraps
801076de:	e9 81 f5 ff ff       	jmp    80106c64 <alltraps>

801076e3 <vector116>:
.globl vector116
vector116:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $116
801076e5:	6a 74                	push   $0x74
  jmp alltraps
801076e7:	e9 78 f5 ff ff       	jmp    80106c64 <alltraps>

801076ec <vector117>:
.globl vector117
vector117:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $117
801076ee:	6a 75                	push   $0x75
  jmp alltraps
801076f0:	e9 6f f5 ff ff       	jmp    80106c64 <alltraps>

801076f5 <vector118>:
.globl vector118
vector118:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $118
801076f7:	6a 76                	push   $0x76
  jmp alltraps
801076f9:	e9 66 f5 ff ff       	jmp    80106c64 <alltraps>

801076fe <vector119>:
.globl vector119
vector119:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $119
80107700:	6a 77                	push   $0x77
  jmp alltraps
80107702:	e9 5d f5 ff ff       	jmp    80106c64 <alltraps>

80107707 <vector120>:
.globl vector120
vector120:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $120
80107709:	6a 78                	push   $0x78
  jmp alltraps
8010770b:	e9 54 f5 ff ff       	jmp    80106c64 <alltraps>

80107710 <vector121>:
.globl vector121
vector121:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $121
80107712:	6a 79                	push   $0x79
  jmp alltraps
80107714:	e9 4b f5 ff ff       	jmp    80106c64 <alltraps>

80107719 <vector122>:
.globl vector122
vector122:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $122
8010771b:	6a 7a                	push   $0x7a
  jmp alltraps
8010771d:	e9 42 f5 ff ff       	jmp    80106c64 <alltraps>

80107722 <vector123>:
.globl vector123
vector123:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $123
80107724:	6a 7b                	push   $0x7b
  jmp alltraps
80107726:	e9 39 f5 ff ff       	jmp    80106c64 <alltraps>

8010772b <vector124>:
.globl vector124
vector124:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $124
8010772d:	6a 7c                	push   $0x7c
  jmp alltraps
8010772f:	e9 30 f5 ff ff       	jmp    80106c64 <alltraps>

80107734 <vector125>:
.globl vector125
vector125:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $125
80107736:	6a 7d                	push   $0x7d
  jmp alltraps
80107738:	e9 27 f5 ff ff       	jmp    80106c64 <alltraps>

8010773d <vector126>:
.globl vector126
vector126:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $126
8010773f:	6a 7e                	push   $0x7e
  jmp alltraps
80107741:	e9 1e f5 ff ff       	jmp    80106c64 <alltraps>

80107746 <vector127>:
.globl vector127
vector127:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $127
80107748:	6a 7f                	push   $0x7f
  jmp alltraps
8010774a:	e9 15 f5 ff ff       	jmp    80106c64 <alltraps>

8010774f <vector128>:
.globl vector128
vector128:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $128
80107751:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107756:	e9 09 f5 ff ff       	jmp    80106c64 <alltraps>

8010775b <vector129>:
.globl vector129
vector129:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $129
8010775d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107762:	e9 fd f4 ff ff       	jmp    80106c64 <alltraps>

80107767 <vector130>:
.globl vector130
vector130:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $130
80107769:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010776e:	e9 f1 f4 ff ff       	jmp    80106c64 <alltraps>

80107773 <vector131>:
.globl vector131
vector131:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $131
80107775:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010777a:	e9 e5 f4 ff ff       	jmp    80106c64 <alltraps>

8010777f <vector132>:
.globl vector132
vector132:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $132
80107781:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107786:	e9 d9 f4 ff ff       	jmp    80106c64 <alltraps>

8010778b <vector133>:
.globl vector133
vector133:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $133
8010778d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107792:	e9 cd f4 ff ff       	jmp    80106c64 <alltraps>

80107797 <vector134>:
.globl vector134
vector134:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $134
80107799:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010779e:	e9 c1 f4 ff ff       	jmp    80106c64 <alltraps>

801077a3 <vector135>:
.globl vector135
vector135:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $135
801077a5:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801077aa:	e9 b5 f4 ff ff       	jmp    80106c64 <alltraps>

801077af <vector136>:
.globl vector136
vector136:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $136
801077b1:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801077b6:	e9 a9 f4 ff ff       	jmp    80106c64 <alltraps>

801077bb <vector137>:
.globl vector137
vector137:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $137
801077bd:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801077c2:	e9 9d f4 ff ff       	jmp    80106c64 <alltraps>

801077c7 <vector138>:
.globl vector138
vector138:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $138
801077c9:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801077ce:	e9 91 f4 ff ff       	jmp    80106c64 <alltraps>

801077d3 <vector139>:
.globl vector139
vector139:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $139
801077d5:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801077da:	e9 85 f4 ff ff       	jmp    80106c64 <alltraps>

801077df <vector140>:
.globl vector140
vector140:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $140
801077e1:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801077e6:	e9 79 f4 ff ff       	jmp    80106c64 <alltraps>

801077eb <vector141>:
.globl vector141
vector141:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $141
801077ed:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801077f2:	e9 6d f4 ff ff       	jmp    80106c64 <alltraps>

801077f7 <vector142>:
.globl vector142
vector142:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $142
801077f9:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801077fe:	e9 61 f4 ff ff       	jmp    80106c64 <alltraps>

80107803 <vector143>:
.globl vector143
vector143:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $143
80107805:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010780a:	e9 55 f4 ff ff       	jmp    80106c64 <alltraps>

8010780f <vector144>:
.globl vector144
vector144:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $144
80107811:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107816:	e9 49 f4 ff ff       	jmp    80106c64 <alltraps>

8010781b <vector145>:
.globl vector145
vector145:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $145
8010781d:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107822:	e9 3d f4 ff ff       	jmp    80106c64 <alltraps>

80107827 <vector146>:
.globl vector146
vector146:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $146
80107829:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010782e:	e9 31 f4 ff ff       	jmp    80106c64 <alltraps>

80107833 <vector147>:
.globl vector147
vector147:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $147
80107835:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010783a:	e9 25 f4 ff ff       	jmp    80106c64 <alltraps>

8010783f <vector148>:
.globl vector148
vector148:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $148
80107841:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107846:	e9 19 f4 ff ff       	jmp    80106c64 <alltraps>

8010784b <vector149>:
.globl vector149
vector149:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $149
8010784d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107852:	e9 0d f4 ff ff       	jmp    80106c64 <alltraps>

80107857 <vector150>:
.globl vector150
vector150:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $150
80107859:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010785e:	e9 01 f4 ff ff       	jmp    80106c64 <alltraps>

80107863 <vector151>:
.globl vector151
vector151:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $151
80107865:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010786a:	e9 f5 f3 ff ff       	jmp    80106c64 <alltraps>

8010786f <vector152>:
.globl vector152
vector152:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $152
80107871:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107876:	e9 e9 f3 ff ff       	jmp    80106c64 <alltraps>

8010787b <vector153>:
.globl vector153
vector153:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $153
8010787d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107882:	e9 dd f3 ff ff       	jmp    80106c64 <alltraps>

80107887 <vector154>:
.globl vector154
vector154:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $154
80107889:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010788e:	e9 d1 f3 ff ff       	jmp    80106c64 <alltraps>

80107893 <vector155>:
.globl vector155
vector155:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $155
80107895:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010789a:	e9 c5 f3 ff ff       	jmp    80106c64 <alltraps>

8010789f <vector156>:
.globl vector156
vector156:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $156
801078a1:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801078a6:	e9 b9 f3 ff ff       	jmp    80106c64 <alltraps>

801078ab <vector157>:
.globl vector157
vector157:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $157
801078ad:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801078b2:	e9 ad f3 ff ff       	jmp    80106c64 <alltraps>

801078b7 <vector158>:
.globl vector158
vector158:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $158
801078b9:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801078be:	e9 a1 f3 ff ff       	jmp    80106c64 <alltraps>

801078c3 <vector159>:
.globl vector159
vector159:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $159
801078c5:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801078ca:	e9 95 f3 ff ff       	jmp    80106c64 <alltraps>

801078cf <vector160>:
.globl vector160
vector160:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $160
801078d1:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801078d6:	e9 89 f3 ff ff       	jmp    80106c64 <alltraps>

801078db <vector161>:
.globl vector161
vector161:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $161
801078dd:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801078e2:	e9 7d f3 ff ff       	jmp    80106c64 <alltraps>

801078e7 <vector162>:
.globl vector162
vector162:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $162
801078e9:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801078ee:	e9 71 f3 ff ff       	jmp    80106c64 <alltraps>

801078f3 <vector163>:
.globl vector163
vector163:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $163
801078f5:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801078fa:	e9 65 f3 ff ff       	jmp    80106c64 <alltraps>

801078ff <vector164>:
.globl vector164
vector164:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $164
80107901:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107906:	e9 59 f3 ff ff       	jmp    80106c64 <alltraps>

8010790b <vector165>:
.globl vector165
vector165:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $165
8010790d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107912:	e9 4d f3 ff ff       	jmp    80106c64 <alltraps>

80107917 <vector166>:
.globl vector166
vector166:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $166
80107919:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010791e:	e9 41 f3 ff ff       	jmp    80106c64 <alltraps>

80107923 <vector167>:
.globl vector167
vector167:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $167
80107925:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010792a:	e9 35 f3 ff ff       	jmp    80106c64 <alltraps>

8010792f <vector168>:
.globl vector168
vector168:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $168
80107931:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107936:	e9 29 f3 ff ff       	jmp    80106c64 <alltraps>

8010793b <vector169>:
.globl vector169
vector169:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $169
8010793d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107942:	e9 1d f3 ff ff       	jmp    80106c64 <alltraps>

80107947 <vector170>:
.globl vector170
vector170:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $170
80107949:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010794e:	e9 11 f3 ff ff       	jmp    80106c64 <alltraps>

80107953 <vector171>:
.globl vector171
vector171:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $171
80107955:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010795a:	e9 05 f3 ff ff       	jmp    80106c64 <alltraps>

8010795f <vector172>:
.globl vector172
vector172:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $172
80107961:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107966:	e9 f9 f2 ff ff       	jmp    80106c64 <alltraps>

8010796b <vector173>:
.globl vector173
vector173:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $173
8010796d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107972:	e9 ed f2 ff ff       	jmp    80106c64 <alltraps>

80107977 <vector174>:
.globl vector174
vector174:
  pushl $0
80107977:	6a 00                	push   $0x0
  pushl $174
80107979:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010797e:	e9 e1 f2 ff ff       	jmp    80106c64 <alltraps>

80107983 <vector175>:
.globl vector175
vector175:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $175
80107985:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010798a:	e9 d5 f2 ff ff       	jmp    80106c64 <alltraps>

8010798f <vector176>:
.globl vector176
vector176:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $176
80107991:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107996:	e9 c9 f2 ff ff       	jmp    80106c64 <alltraps>

8010799b <vector177>:
.globl vector177
vector177:
  pushl $0
8010799b:	6a 00                	push   $0x0
  pushl $177
8010799d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801079a2:	e9 bd f2 ff ff       	jmp    80106c64 <alltraps>

801079a7 <vector178>:
.globl vector178
vector178:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $178
801079a9:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801079ae:	e9 b1 f2 ff ff       	jmp    80106c64 <alltraps>

801079b3 <vector179>:
.globl vector179
vector179:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $179
801079b5:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801079ba:	e9 a5 f2 ff ff       	jmp    80106c64 <alltraps>

801079bf <vector180>:
.globl vector180
vector180:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $180
801079c1:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801079c6:	e9 99 f2 ff ff       	jmp    80106c64 <alltraps>

801079cb <vector181>:
.globl vector181
vector181:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $181
801079cd:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801079d2:	e9 8d f2 ff ff       	jmp    80106c64 <alltraps>

801079d7 <vector182>:
.globl vector182
vector182:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $182
801079d9:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801079de:	e9 81 f2 ff ff       	jmp    80106c64 <alltraps>

801079e3 <vector183>:
.globl vector183
vector183:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $183
801079e5:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801079ea:	e9 75 f2 ff ff       	jmp    80106c64 <alltraps>

801079ef <vector184>:
.globl vector184
vector184:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $184
801079f1:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801079f6:	e9 69 f2 ff ff       	jmp    80106c64 <alltraps>

801079fb <vector185>:
.globl vector185
vector185:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $185
801079fd:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107a02:	e9 5d f2 ff ff       	jmp    80106c64 <alltraps>

80107a07 <vector186>:
.globl vector186
vector186:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $186
80107a09:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107a0e:	e9 51 f2 ff ff       	jmp    80106c64 <alltraps>

80107a13 <vector187>:
.globl vector187
vector187:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $187
80107a15:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107a1a:	e9 45 f2 ff ff       	jmp    80106c64 <alltraps>

80107a1f <vector188>:
.globl vector188
vector188:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $188
80107a21:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107a26:	e9 39 f2 ff ff       	jmp    80106c64 <alltraps>

80107a2b <vector189>:
.globl vector189
vector189:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $189
80107a2d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107a32:	e9 2d f2 ff ff       	jmp    80106c64 <alltraps>

80107a37 <vector190>:
.globl vector190
vector190:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $190
80107a39:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107a3e:	e9 21 f2 ff ff       	jmp    80106c64 <alltraps>

80107a43 <vector191>:
.globl vector191
vector191:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $191
80107a45:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107a4a:	e9 15 f2 ff ff       	jmp    80106c64 <alltraps>

80107a4f <vector192>:
.globl vector192
vector192:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $192
80107a51:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107a56:	e9 09 f2 ff ff       	jmp    80106c64 <alltraps>

80107a5b <vector193>:
.globl vector193
vector193:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $193
80107a5d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107a62:	e9 fd f1 ff ff       	jmp    80106c64 <alltraps>

80107a67 <vector194>:
.globl vector194
vector194:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $194
80107a69:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107a6e:	e9 f1 f1 ff ff       	jmp    80106c64 <alltraps>

80107a73 <vector195>:
.globl vector195
vector195:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $195
80107a75:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a7a:	e9 e5 f1 ff ff       	jmp    80106c64 <alltraps>

80107a7f <vector196>:
.globl vector196
vector196:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $196
80107a81:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a86:	e9 d9 f1 ff ff       	jmp    80106c64 <alltraps>

80107a8b <vector197>:
.globl vector197
vector197:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $197
80107a8d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107a92:	e9 cd f1 ff ff       	jmp    80106c64 <alltraps>

80107a97 <vector198>:
.globl vector198
vector198:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $198
80107a99:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107a9e:	e9 c1 f1 ff ff       	jmp    80106c64 <alltraps>

80107aa3 <vector199>:
.globl vector199
vector199:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $199
80107aa5:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107aaa:	e9 b5 f1 ff ff       	jmp    80106c64 <alltraps>

80107aaf <vector200>:
.globl vector200
vector200:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $200
80107ab1:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107ab6:	e9 a9 f1 ff ff       	jmp    80106c64 <alltraps>

80107abb <vector201>:
.globl vector201
vector201:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $201
80107abd:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107ac2:	e9 9d f1 ff ff       	jmp    80106c64 <alltraps>

80107ac7 <vector202>:
.globl vector202
vector202:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $202
80107ac9:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107ace:	e9 91 f1 ff ff       	jmp    80106c64 <alltraps>

80107ad3 <vector203>:
.globl vector203
vector203:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $203
80107ad5:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107ada:	e9 85 f1 ff ff       	jmp    80106c64 <alltraps>

80107adf <vector204>:
.globl vector204
vector204:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $204
80107ae1:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107ae6:	e9 79 f1 ff ff       	jmp    80106c64 <alltraps>

80107aeb <vector205>:
.globl vector205
vector205:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $205
80107aed:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107af2:	e9 6d f1 ff ff       	jmp    80106c64 <alltraps>

80107af7 <vector206>:
.globl vector206
vector206:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $206
80107af9:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107afe:	e9 61 f1 ff ff       	jmp    80106c64 <alltraps>

80107b03 <vector207>:
.globl vector207
vector207:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $207
80107b05:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107b0a:	e9 55 f1 ff ff       	jmp    80106c64 <alltraps>

80107b0f <vector208>:
.globl vector208
vector208:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $208
80107b11:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b16:	e9 49 f1 ff ff       	jmp    80106c64 <alltraps>

80107b1b <vector209>:
.globl vector209
vector209:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $209
80107b1d:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107b22:	e9 3d f1 ff ff       	jmp    80106c64 <alltraps>

80107b27 <vector210>:
.globl vector210
vector210:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $210
80107b29:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107b2e:	e9 31 f1 ff ff       	jmp    80106c64 <alltraps>

80107b33 <vector211>:
.globl vector211
vector211:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $211
80107b35:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107b3a:	e9 25 f1 ff ff       	jmp    80106c64 <alltraps>

80107b3f <vector212>:
.globl vector212
vector212:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $212
80107b41:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107b46:	e9 19 f1 ff ff       	jmp    80106c64 <alltraps>

80107b4b <vector213>:
.globl vector213
vector213:
  pushl $0
80107b4b:	6a 00                	push   $0x0
  pushl $213
80107b4d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107b52:	e9 0d f1 ff ff       	jmp    80106c64 <alltraps>

80107b57 <vector214>:
.globl vector214
vector214:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $214
80107b59:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107b5e:	e9 01 f1 ff ff       	jmp    80106c64 <alltraps>

80107b63 <vector215>:
.globl vector215
vector215:
  pushl $0
80107b63:	6a 00                	push   $0x0
  pushl $215
80107b65:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107b6a:	e9 f5 f0 ff ff       	jmp    80106c64 <alltraps>

80107b6f <vector216>:
.globl vector216
vector216:
  pushl $0
80107b6f:	6a 00                	push   $0x0
  pushl $216
80107b71:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b76:	e9 e9 f0 ff ff       	jmp    80106c64 <alltraps>

80107b7b <vector217>:
.globl vector217
vector217:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $217
80107b7d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b82:	e9 dd f0 ff ff       	jmp    80106c64 <alltraps>

80107b87 <vector218>:
.globl vector218
vector218:
  pushl $0
80107b87:	6a 00                	push   $0x0
  pushl $218
80107b89:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107b8e:	e9 d1 f0 ff ff       	jmp    80106c64 <alltraps>

80107b93 <vector219>:
.globl vector219
vector219:
  pushl $0
80107b93:	6a 00                	push   $0x0
  pushl $219
80107b95:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107b9a:	e9 c5 f0 ff ff       	jmp    80106c64 <alltraps>

80107b9f <vector220>:
.globl vector220
vector220:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $220
80107ba1:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ba6:	e9 b9 f0 ff ff       	jmp    80106c64 <alltraps>

80107bab <vector221>:
.globl vector221
vector221:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $221
80107bad:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107bb2:	e9 ad f0 ff ff       	jmp    80106c64 <alltraps>

80107bb7 <vector222>:
.globl vector222
vector222:
  pushl $0
80107bb7:	6a 00                	push   $0x0
  pushl $222
80107bb9:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107bbe:	e9 a1 f0 ff ff       	jmp    80106c64 <alltraps>

80107bc3 <vector223>:
.globl vector223
vector223:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $223
80107bc5:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107bca:	e9 95 f0 ff ff       	jmp    80106c64 <alltraps>

80107bcf <vector224>:
.globl vector224
vector224:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $224
80107bd1:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107bd6:	e9 89 f0 ff ff       	jmp    80106c64 <alltraps>

80107bdb <vector225>:
.globl vector225
vector225:
  pushl $0
80107bdb:	6a 00                	push   $0x0
  pushl $225
80107bdd:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107be2:	e9 7d f0 ff ff       	jmp    80106c64 <alltraps>

80107be7 <vector226>:
.globl vector226
vector226:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $226
80107be9:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107bee:	e9 71 f0 ff ff       	jmp    80106c64 <alltraps>

80107bf3 <vector227>:
.globl vector227
vector227:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $227
80107bf5:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107bfa:	e9 65 f0 ff ff       	jmp    80106c64 <alltraps>

80107bff <vector228>:
.globl vector228
vector228:
  pushl $0
80107bff:	6a 00                	push   $0x0
  pushl $228
80107c01:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107c06:	e9 59 f0 ff ff       	jmp    80106c64 <alltraps>

80107c0b <vector229>:
.globl vector229
vector229:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $229
80107c0d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107c12:	e9 4d f0 ff ff       	jmp    80106c64 <alltraps>

80107c17 <vector230>:
.globl vector230
vector230:
  pushl $0
80107c17:	6a 00                	push   $0x0
  pushl $230
80107c19:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107c1e:	e9 41 f0 ff ff       	jmp    80106c64 <alltraps>

80107c23 <vector231>:
.globl vector231
vector231:
  pushl $0
80107c23:	6a 00                	push   $0x0
  pushl $231
80107c25:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107c2a:	e9 35 f0 ff ff       	jmp    80106c64 <alltraps>

80107c2f <vector232>:
.globl vector232
vector232:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $232
80107c31:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107c36:	e9 29 f0 ff ff       	jmp    80106c64 <alltraps>

80107c3b <vector233>:
.globl vector233
vector233:
  pushl $0
80107c3b:	6a 00                	push   $0x0
  pushl $233
80107c3d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107c42:	e9 1d f0 ff ff       	jmp    80106c64 <alltraps>

80107c47 <vector234>:
.globl vector234
vector234:
  pushl $0
80107c47:	6a 00                	push   $0x0
  pushl $234
80107c49:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107c4e:	e9 11 f0 ff ff       	jmp    80106c64 <alltraps>

80107c53 <vector235>:
.globl vector235
vector235:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $235
80107c55:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107c5a:	e9 05 f0 ff ff       	jmp    80106c64 <alltraps>

80107c5f <vector236>:
.globl vector236
vector236:
  pushl $0
80107c5f:	6a 00                	push   $0x0
  pushl $236
80107c61:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107c66:	e9 f9 ef ff ff       	jmp    80106c64 <alltraps>

80107c6b <vector237>:
.globl vector237
vector237:
  pushl $0
80107c6b:	6a 00                	push   $0x0
  pushl $237
80107c6d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c72:	e9 ed ef ff ff       	jmp    80106c64 <alltraps>

80107c77 <vector238>:
.globl vector238
vector238:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $238
80107c79:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c7e:	e9 e1 ef ff ff       	jmp    80106c64 <alltraps>

80107c83 <vector239>:
.globl vector239
vector239:
  pushl $0
80107c83:	6a 00                	push   $0x0
  pushl $239
80107c85:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107c8a:	e9 d5 ef ff ff       	jmp    80106c64 <alltraps>

80107c8f <vector240>:
.globl vector240
vector240:
  pushl $0
80107c8f:	6a 00                	push   $0x0
  pushl $240
80107c91:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107c96:	e9 c9 ef ff ff       	jmp    80106c64 <alltraps>

80107c9b <vector241>:
.globl vector241
vector241:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $241
80107c9d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ca2:	e9 bd ef ff ff       	jmp    80106c64 <alltraps>

80107ca7 <vector242>:
.globl vector242
vector242:
  pushl $0
80107ca7:	6a 00                	push   $0x0
  pushl $242
80107ca9:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107cae:	e9 b1 ef ff ff       	jmp    80106c64 <alltraps>

80107cb3 <vector243>:
.globl vector243
vector243:
  pushl $0
80107cb3:	6a 00                	push   $0x0
  pushl $243
80107cb5:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107cba:	e9 a5 ef ff ff       	jmp    80106c64 <alltraps>

80107cbf <vector244>:
.globl vector244
vector244:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $244
80107cc1:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107cc6:	e9 99 ef ff ff       	jmp    80106c64 <alltraps>

80107ccb <vector245>:
.globl vector245
vector245:
  pushl $0
80107ccb:	6a 00                	push   $0x0
  pushl $245
80107ccd:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107cd2:	e9 8d ef ff ff       	jmp    80106c64 <alltraps>

80107cd7 <vector246>:
.globl vector246
vector246:
  pushl $0
80107cd7:	6a 00                	push   $0x0
  pushl $246
80107cd9:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107cde:	e9 81 ef ff ff       	jmp    80106c64 <alltraps>

80107ce3 <vector247>:
.globl vector247
vector247:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $247
80107ce5:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107cea:	e9 75 ef ff ff       	jmp    80106c64 <alltraps>

80107cef <vector248>:
.globl vector248
vector248:
  pushl $0
80107cef:	6a 00                	push   $0x0
  pushl $248
80107cf1:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107cf6:	e9 69 ef ff ff       	jmp    80106c64 <alltraps>

80107cfb <vector249>:
.globl vector249
vector249:
  pushl $0
80107cfb:	6a 00                	push   $0x0
  pushl $249
80107cfd:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107d02:	e9 5d ef ff ff       	jmp    80106c64 <alltraps>

80107d07 <vector250>:
.globl vector250
vector250:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $250
80107d09:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107d0e:	e9 51 ef ff ff       	jmp    80106c64 <alltraps>

80107d13 <vector251>:
.globl vector251
vector251:
  pushl $0
80107d13:	6a 00                	push   $0x0
  pushl $251
80107d15:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107d1a:	e9 45 ef ff ff       	jmp    80106c64 <alltraps>

80107d1f <vector252>:
.globl vector252
vector252:
  pushl $0
80107d1f:	6a 00                	push   $0x0
  pushl $252
80107d21:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107d26:	e9 39 ef ff ff       	jmp    80106c64 <alltraps>

80107d2b <vector253>:
.globl vector253
vector253:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $253
80107d2d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107d32:	e9 2d ef ff ff       	jmp    80106c64 <alltraps>

80107d37 <vector254>:
.globl vector254
vector254:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $254
80107d39:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107d3e:	e9 21 ef ff ff       	jmp    80106c64 <alltraps>

80107d43 <vector255>:
.globl vector255
vector255:
  pushl $0
80107d43:	6a 00                	push   $0x0
  pushl $255
80107d45:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107d4a:	e9 15 ef ff ff       	jmp    80106c64 <alltraps>

80107d4f <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107d4f:	55                   	push   %ebp
80107d50:	89 e5                	mov    %esp,%ebp
80107d52:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d58:	83 e8 01             	sub    $0x1,%eax
80107d5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d62:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107d66:	8b 45 08             	mov    0x8(%ebp),%eax
80107d69:	c1 e8 10             	shr    $0x10,%eax
80107d6c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107d70:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d73:	0f 01 10             	lgdtl  (%eax)
}
80107d76:	c9                   	leave  
80107d77:	c3                   	ret    

80107d78 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107d78:	55                   	push   %ebp
80107d79:	89 e5                	mov    %esp,%ebp
80107d7b:	83 ec 04             	sub    $0x4,%esp
80107d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80107d81:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107d85:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d89:	0f 00 d8             	ltr    %ax
}
80107d8c:	c9                   	leave  
80107d8d:	c3                   	ret    

80107d8e <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107d8e:	55                   	push   %ebp
80107d8f:	89 e5                	mov    %esp,%ebp
80107d91:	83 ec 04             	sub    $0x4,%esp
80107d94:	8b 45 08             	mov    0x8(%ebp),%eax
80107d97:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107d9b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d9f:	8e e8                	mov    %eax,%gs
}
80107da1:	c9                   	leave  
80107da2:	c3                   	ret    

80107da3 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107da3:	55                   	push   %ebp
80107da4:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107da6:	8b 45 08             	mov    0x8(%ebp),%eax
80107da9:	0f 22 d8             	mov    %eax,%cr3
}
80107dac:	5d                   	pop    %ebp
80107dad:	c3                   	ret    

80107dae <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107dae:	55                   	push   %ebp
80107daf:	89 e5                	mov    %esp,%ebp
80107db1:	8b 45 08             	mov    0x8(%ebp),%eax
80107db4:	05 00 00 00 80       	add    $0x80000000,%eax
80107db9:	5d                   	pop    %ebp
80107dba:	c3                   	ret    

80107dbb <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107dbb:	55                   	push   %ebp
80107dbc:	89 e5                	mov    %esp,%ebp
80107dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80107dc1:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc6:	5d                   	pop    %ebp
80107dc7:	c3                   	ret    

80107dc8 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107dc8:	55                   	push   %ebp
80107dc9:	89 e5                	mov    %esp,%ebp
80107dcb:	53                   	push   %ebx
80107dcc:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107dcf:	e8 8d b1 ff ff       	call   80102f61 <cpunum>
80107dd4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107dda:	05 60 09 11 80       	add    $0x80110960,%eax
80107ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de5:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dee:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df7:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfe:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e02:	83 e2 f0             	and    $0xfffffff0,%edx
80107e05:	83 ca 0a             	or     $0xa,%edx
80107e08:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e12:	83 ca 10             	or     $0x10,%edx
80107e15:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e1f:	83 e2 9f             	and    $0xffffff9f,%edx
80107e22:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e2c:	83 ca 80             	or     $0xffffff80,%edx
80107e2f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e35:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e39:	83 ca 0f             	or     $0xf,%edx
80107e3c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e46:	83 e2 ef             	and    $0xffffffef,%edx
80107e49:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e53:	83 e2 df             	and    $0xffffffdf,%edx
80107e56:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e60:	83 ca 40             	or     $0x40,%edx
80107e63:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e69:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107e6d:	83 ca 80             	or     $0xffffff80,%edx
80107e70:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e76:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107e84:	ff ff 
80107e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e89:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107e90:	00 00 
80107e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e95:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ea6:	83 e2 f0             	and    $0xfffffff0,%edx
80107ea9:	83 ca 02             	or     $0x2,%edx
80107eac:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ebc:	83 ca 10             	or     $0x10,%edx
80107ebf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ecf:	83 e2 9f             	and    $0xffffff9f,%edx
80107ed2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ee2:	83 ca 80             	or     $0xffffff80,%edx
80107ee5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eee:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ef5:	83 ca 0f             	or     $0xf,%edx
80107ef8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f01:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f08:	83 e2 ef             	and    $0xffffffef,%edx
80107f0b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f14:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f1b:	83 e2 df             	and    $0xffffffdf,%edx
80107f1e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f27:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f2e:	83 ca 40             	or     $0x40,%edx
80107f31:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f41:	83 ca 80             	or     $0xffffff80,%edx
80107f44:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f57:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107f5e:	ff ff 
80107f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f63:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107f6a:	00 00 
80107f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f79:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f80:	83 e2 f0             	and    $0xfffffff0,%edx
80107f83:	83 ca 0a             	or     $0xa,%edx
80107f86:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f96:	83 ca 10             	or     $0x10,%edx
80107f99:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fa9:	83 ca 60             	or     $0x60,%edx
80107fac:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fbc:	83 ca 80             	or     $0xffffff80,%edx
80107fbf:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fcf:	83 ca 0f             	or     $0xf,%edx
80107fd2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fe2:	83 e2 ef             	and    $0xffffffef,%edx
80107fe5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fee:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ff5:	83 e2 df             	and    $0xffffffdf,%edx
80107ff8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108001:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108008:	83 ca 40             	or     $0x40,%edx
8010800b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010801b:	83 ca 80             	or     $0xffffff80,%edx
8010801e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108027:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010802e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108031:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108038:	ff ff 
8010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108044:	00 00 
80108046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108049:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010805a:	83 e2 f0             	and    $0xfffffff0,%edx
8010805d:	83 ca 02             	or     $0x2,%edx
80108060:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108070:	83 ca 10             	or     $0x10,%edx
80108073:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108083:	83 ca 60             	or     $0x60,%edx
80108086:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010808c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108096:	83 ca 80             	or     $0xffffff80,%edx
80108099:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010809f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080a9:	83 ca 0f             	or     $0xf,%edx
801080ac:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080bc:	83 e2 ef             	and    $0xffffffef,%edx
801080bf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080cf:	83 e2 df             	and    $0xffffffdf,%edx
801080d2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080db:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080e2:	83 ca 40             	or     $0x40,%edx
801080e5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801080f5:	83 ca 80             	or     $0xffffff80,%edx
801080f8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801080fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108101:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	05 b4 00 00 00       	add    $0xb4,%eax
80108110:	89 c3                	mov    %eax,%ebx
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	05 b4 00 00 00       	add    $0xb4,%eax
8010811a:	c1 e8 10             	shr    $0x10,%eax
8010811d:	89 c1                	mov    %eax,%ecx
8010811f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108122:	05 b4 00 00 00       	add    $0xb4,%eax
80108127:	c1 e8 18             	shr    $0x18,%eax
8010812a:	89 c2                	mov    %eax,%edx
8010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108136:	00 00 
80108138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108145:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010814b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814e:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108155:	83 e1 f0             	and    $0xfffffff0,%ecx
80108158:	83 c9 02             	or     $0x2,%ecx
8010815b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108164:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010816b:	83 c9 10             	or     $0x10,%ecx
8010816e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108177:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010817e:	83 e1 9f             	and    $0xffffff9f,%ecx
80108181:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818a:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108191:	83 c9 80             	or     $0xffffff80,%ecx
80108194:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010819a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801081a4:	83 e1 f0             	and    $0xfffffff0,%ecx
801081a7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801081ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b0:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801081b7:	83 e1 ef             	and    $0xffffffef,%ecx
801081ba:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801081c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c3:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801081ca:	83 e1 df             	and    $0xffffffdf,%ecx
801081cd:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801081d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801081dd:	83 c9 40             	or     $0x40,%ecx
801081e0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801081e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e9:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801081f0:	83 c9 80             	or     $0xffffff80,%ecx
801081f3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801081f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fc:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	83 c0 70             	add    $0x70,%eax
80108208:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010820f:	00 
80108210:	89 04 24             	mov    %eax,(%esp)
80108213:	e8 37 fb ff ff       	call   80107d4f <lgdt>
  loadgs(SEG_KCPU << 3);
80108218:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010821f:	e8 6a fb ff ff       	call   80107d8e <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108227:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010822d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108234:	00 00 00 00 
}
80108238:	83 c4 24             	add    $0x24,%esp
8010823b:	5b                   	pop    %ebx
8010823c:	5d                   	pop    %ebp
8010823d:	c3                   	ret    

8010823e <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010823e:	55                   	push   %ebp
8010823f:	89 e5                	mov    %esp,%ebp
80108241:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108244:	8b 45 0c             	mov    0xc(%ebp),%eax
80108247:	c1 e8 16             	shr    $0x16,%eax
8010824a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108251:	8b 45 08             	mov    0x8(%ebp),%eax
80108254:	01 d0                	add    %edx,%eax
80108256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010825c:	8b 00                	mov    (%eax),%eax
8010825e:	83 e0 01             	and    $0x1,%eax
80108261:	85 c0                	test   %eax,%eax
80108263:	74 17                	je     8010827c <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108268:	8b 00                	mov    (%eax),%eax
8010826a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010826f:	89 04 24             	mov    %eax,(%esp)
80108272:	e8 44 fb ff ff       	call   80107dbb <p2v>
80108277:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010827a:	eb 4b                	jmp    801082c7 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010827c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108280:	74 0e                	je     80108290 <walkpgdir+0x52>
80108282:	e8 7b a8 ff ff       	call   80102b02 <kalloc>
80108287:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010828a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010828e:	75 07                	jne    80108297 <walkpgdir+0x59>
      return 0;
80108290:	b8 00 00 00 00       	mov    $0x0,%eax
80108295:	eb 47                	jmp    801082de <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108297:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010829e:	00 
8010829f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801082a6:	00 
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	89 04 24             	mov    %eax,(%esp)
801082ad:	e8 5e d4 ff ff       	call   80105710 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801082b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b5:	89 04 24             	mov    %eax,(%esp)
801082b8:	e8 f1 fa ff ff       	call   80107dae <v2p>
801082bd:	83 c8 07             	or     $0x7,%eax
801082c0:	89 c2                	mov    %eax,%edx
801082c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c5:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801082c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ca:	c1 e8 0c             	shr    $0xc,%eax
801082cd:	25 ff 03 00 00       	and    $0x3ff,%eax
801082d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082dc:	01 d0                	add    %edx,%eax
}
801082de:	c9                   	leave  
801082df:	c3                   	ret    

801082e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	83 ec 28             	sub    $0x28,%esp
  //cprintf("mappages starting\n");
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801082e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801082e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801082f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801082f4:	8b 45 10             	mov    0x10(%ebp),%eax
801082f7:	01 d0                	add    %edx,%eax
801082f9:	83 e8 01             	sub    $0x1,%eax
801082fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108304:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010830b:	00 
8010830c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108313:	8b 45 08             	mov    0x8(%ebp),%eax
80108316:	89 04 24             	mov    %eax,(%esp)
80108319:	e8 20 ff ff ff       	call   8010823e <walkpgdir>
8010831e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108321:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108325:	75 07                	jne    8010832e <mappages+0x4e>
      return -1;
80108327:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010832c:	eb 48                	jmp    80108376 <mappages+0x96>
    if(*pte & PTE_P)
8010832e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108331:	8b 00                	mov    (%eax),%eax
80108333:	83 e0 01             	and    $0x1,%eax
80108336:	85 c0                	test   %eax,%eax
80108338:	74 0c                	je     80108346 <mappages+0x66>
      panic("remap");
8010833a:	c7 04 24 ec 92 10 80 	movl   $0x801092ec,(%esp)
80108341:	e8 f4 81 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80108346:	8b 45 18             	mov    0x18(%ebp),%eax
80108349:	0b 45 14             	or     0x14(%ebp),%eax
8010834c:	83 c8 01             	or     $0x1,%eax
8010834f:	89 c2                	mov    %eax,%edx
80108351:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108354:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108359:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010835c:	75 08                	jne    80108366 <mappages+0x86>
      break;
8010835e:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  //cprintf("mappages no ERR\n");
  return 0;
8010835f:	b8 00 00 00 00       	mov    $0x0,%eax
80108364:	eb 10                	jmp    80108376 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108366:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010836d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108374:	eb 8e                	jmp    80108304 <mappages+0x24>
  //cprintf("mappages no ERR\n");
  return 0;
}
80108376:	c9                   	leave  
80108377:	c3                   	ret    

80108378 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108378:	55                   	push   %ebp
80108379:	89 e5                	mov    %esp,%ebp
8010837b:	53                   	push   %ebx
8010837c:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010837f:	e8 7e a7 ff ff       	call   80102b02 <kalloc>
80108384:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010838b:	75 0a                	jne    80108397 <setupkvm+0x1f>
    return 0;
8010838d:	b8 00 00 00 00       	mov    $0x0,%eax
80108392:	e9 98 00 00 00       	jmp    8010842f <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108397:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010839e:	00 
8010839f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083a6:	00 
801083a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083aa:	89 04 24             	mov    %eax,(%esp)
801083ad:	e8 5e d3 ff ff       	call   80105710 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801083b2:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801083b9:	e8 fd f9 ff ff       	call   80107dbb <p2v>
801083be:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801083c3:	76 0c                	jbe    801083d1 <setupkvm+0x59>
    panic("PHYSTOP too high");
801083c5:	c7 04 24 f2 92 10 80 	movl   $0x801092f2,(%esp)
801083cc:	e8 69 81 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083d1:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801083d8:	eb 49                	jmp    80108423 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801083da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083dd:	8b 48 0c             	mov    0xc(%eax),%ecx
801083e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e3:	8b 50 04             	mov    0x4(%eax),%edx
801083e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e9:	8b 58 08             	mov    0x8(%eax),%ebx
801083ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ef:	8b 40 04             	mov    0x4(%eax),%eax
801083f2:	29 c3                	sub    %eax,%ebx
801083f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f7:	8b 00                	mov    (%eax),%eax
801083f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801083fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108401:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108405:	89 44 24 04          	mov    %eax,0x4(%esp)
80108409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010840c:	89 04 24             	mov    %eax,(%esp)
8010840f:	e8 cc fe ff ff       	call   801082e0 <mappages>
80108414:	85 c0                	test   %eax,%eax
80108416:	79 07                	jns    8010841f <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108418:	b8 00 00 00 00       	mov    $0x0,%eax
8010841d:	eb 10                	jmp    8010842f <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010841f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108423:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010842a:	72 ae                	jb     801083da <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010842c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010842f:	83 c4 34             	add    $0x34,%esp
80108432:	5b                   	pop    %ebx
80108433:	5d                   	pop    %ebp
80108434:	c3                   	ret    

80108435 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108435:	55                   	push   %ebp
80108436:	89 e5                	mov    %esp,%ebp
80108438:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010843b:	e8 38 ff ff ff       	call   80108378 <setupkvm>
80108440:	a3 38 39 11 80       	mov    %eax,0x80113938
  switchkvm();
80108445:	e8 02 00 00 00       	call   8010844c <switchkvm>
}
8010844a:	c9                   	leave  
8010844b:	c3                   	ret    

8010844c <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010844c:	55                   	push   %ebp
8010844d:	89 e5                	mov    %esp,%ebp
8010844f:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108452:	a1 38 39 11 80       	mov    0x80113938,%eax
80108457:	89 04 24             	mov    %eax,(%esp)
8010845a:	e8 4f f9 ff ff       	call   80107dae <v2p>
8010845f:	89 04 24             	mov    %eax,(%esp)
80108462:	e8 3c f9 ff ff       	call   80107da3 <lcr3>
}
80108467:	c9                   	leave  
80108468:	c3                   	ret    

80108469 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108469:	55                   	push   %ebp
8010846a:	89 e5                	mov    %esp,%ebp
8010846c:	53                   	push   %ebx
8010846d:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108470:	e8 9b d1 ff ff       	call   80105610 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108475:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010847b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108482:	83 c2 08             	add    $0x8,%edx
80108485:	89 d3                	mov    %edx,%ebx
80108487:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010848e:	83 c2 08             	add    $0x8,%edx
80108491:	c1 ea 10             	shr    $0x10,%edx
80108494:	89 d1                	mov    %edx,%ecx
80108496:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010849d:	83 c2 08             	add    $0x8,%edx
801084a0:	c1 ea 18             	shr    $0x18,%edx
801084a3:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801084aa:	67 00 
801084ac:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801084b3:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801084b9:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801084c0:	83 e1 f0             	and    $0xfffffff0,%ecx
801084c3:	83 c9 09             	or     $0x9,%ecx
801084c6:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801084cc:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801084d3:	83 c9 10             	or     $0x10,%ecx
801084d6:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801084dc:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801084e3:	83 e1 9f             	and    $0xffffff9f,%ecx
801084e6:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801084ec:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801084f3:	83 c9 80             	or     $0xffffff80,%ecx
801084f6:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801084fc:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108503:	83 e1 f0             	and    $0xfffffff0,%ecx
80108506:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010850c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108513:	83 e1 ef             	and    $0xffffffef,%ecx
80108516:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010851c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108523:	83 e1 df             	and    $0xffffffdf,%ecx
80108526:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010852c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108533:	83 c9 40             	or     $0x40,%ecx
80108536:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010853c:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108543:	83 e1 7f             	and    $0x7f,%ecx
80108546:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010854c:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108558:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010855f:	83 e2 ef             	and    $0xffffffef,%edx
80108562:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108568:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010856e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108574:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010857a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108581:	8b 52 08             	mov    0x8(%edx),%edx
80108584:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010858a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010858d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108594:	e8 df f7 ff ff       	call   80107d78 <ltr>
  if(p->pgdir == 0)
80108599:	8b 45 08             	mov    0x8(%ebp),%eax
8010859c:	8b 40 04             	mov    0x4(%eax),%eax
8010859f:	85 c0                	test   %eax,%eax
801085a1:	75 0c                	jne    801085af <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801085a3:	c7 04 24 03 93 10 80 	movl   $0x80109303,(%esp)
801085aa:	e8 8b 7f ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801085af:	8b 45 08             	mov    0x8(%ebp),%eax
801085b2:	8b 40 04             	mov    0x4(%eax),%eax
801085b5:	89 04 24             	mov    %eax,(%esp)
801085b8:	e8 f1 f7 ff ff       	call   80107dae <v2p>
801085bd:	89 04 24             	mov    %eax,(%esp)
801085c0:	e8 de f7 ff ff       	call   80107da3 <lcr3>
  popcli();
801085c5:	e8 8a d0 ff ff       	call   80105654 <popcli>
}
801085ca:	83 c4 14             	add    $0x14,%esp
801085cd:	5b                   	pop    %ebx
801085ce:	5d                   	pop    %ebp
801085cf:	c3                   	ret    

801085d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801085d0:	55                   	push   %ebp
801085d1:	89 e5                	mov    %esp,%ebp
801085d3:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801085d6:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801085dd:	76 0c                	jbe    801085eb <inituvm+0x1b>
    panic("inituvm: more than a page");
801085df:	c7 04 24 17 93 10 80 	movl   $0x80109317,(%esp)
801085e6:	e8 4f 7f ff ff       	call   8010053a <panic>
  mem = kalloc();
801085eb:	e8 12 a5 ff ff       	call   80102b02 <kalloc>
801085f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801085f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085fa:	00 
801085fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108602:	00 
80108603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108606:	89 04 24             	mov    %eax,(%esp)
80108609:	e8 02 d1 ff ff       	call   80105710 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010860e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108611:	89 04 24             	mov    %eax,(%esp)
80108614:	e8 95 f7 ff ff       	call   80107dae <v2p>
80108619:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108620:	00 
80108621:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108625:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010862c:	00 
8010862d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108634:	00 
80108635:	8b 45 08             	mov    0x8(%ebp),%eax
80108638:	89 04 24             	mov    %eax,(%esp)
8010863b:	e8 a0 fc ff ff       	call   801082e0 <mappages>
  memmove(mem, init, sz);
80108640:	8b 45 10             	mov    0x10(%ebp),%eax
80108643:	89 44 24 08          	mov    %eax,0x8(%esp)
80108647:	8b 45 0c             	mov    0xc(%ebp),%eax
8010864a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010864e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108651:	89 04 24             	mov    %eax,(%esp)
80108654:	e8 86 d1 ff ff       	call   801057df <memmove>
}
80108659:	c9                   	leave  
8010865a:	c3                   	ret    

8010865b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010865b:	55                   	push   %ebp
8010865c:	89 e5                	mov    %esp,%ebp
8010865e:	53                   	push   %ebx
8010865f:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108662:	8b 45 0c             	mov    0xc(%ebp),%eax
80108665:	25 ff 0f 00 00       	and    $0xfff,%eax
8010866a:	85 c0                	test   %eax,%eax
8010866c:	74 0c                	je     8010867a <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010866e:	c7 04 24 34 93 10 80 	movl   $0x80109334,(%esp)
80108675:	e8 c0 7e ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010867a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108681:	e9 a9 00 00 00       	jmp    8010872f <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108689:	8b 55 0c             	mov    0xc(%ebp),%edx
8010868c:	01 d0                	add    %edx,%eax
8010868e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108695:	00 
80108696:	89 44 24 04          	mov    %eax,0x4(%esp)
8010869a:	8b 45 08             	mov    0x8(%ebp),%eax
8010869d:	89 04 24             	mov    %eax,(%esp)
801086a0:	e8 99 fb ff ff       	call   8010823e <walkpgdir>
801086a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801086a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086ac:	75 0c                	jne    801086ba <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801086ae:	c7 04 24 57 93 10 80 	movl   $0x80109357,(%esp)
801086b5:	e8 80 7e ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801086ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086bd:	8b 00                	mov    (%eax),%eax
801086bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801086c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ca:	8b 55 18             	mov    0x18(%ebp),%edx
801086cd:	29 c2                	sub    %eax,%edx
801086cf:	89 d0                	mov    %edx,%eax
801086d1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801086d6:	77 0f                	ja     801086e7 <loaduvm+0x8c>
      n = sz - i;
801086d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086db:	8b 55 18             	mov    0x18(%ebp),%edx
801086de:	29 c2                	sub    %eax,%edx
801086e0:	89 d0                	mov    %edx,%eax
801086e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801086e5:	eb 07                	jmp    801086ee <loaduvm+0x93>
    else
      n = PGSIZE;
801086e7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801086ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f1:	8b 55 14             	mov    0x14(%ebp),%edx
801086f4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801086f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086fa:	89 04 24             	mov    %eax,(%esp)
801086fd:	e8 b9 f6 ff ff       	call   80107dbb <p2v>
80108702:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108705:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108709:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010870d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108711:	8b 45 10             	mov    0x10(%ebp),%eax
80108714:	89 04 24             	mov    %eax,(%esp)
80108717:	e8 6c 96 ff ff       	call   80101d88 <readi>
8010871c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010871f:	74 07                	je     80108728 <loaduvm+0xcd>
      return -1;
80108721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108726:	eb 18                	jmp    80108740 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108728:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010872f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108732:	3b 45 18             	cmp    0x18(%ebp),%eax
80108735:	0f 82 4b ff ff ff    	jb     80108686 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010873b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108740:	83 c4 24             	add    $0x24,%esp
80108743:	5b                   	pop    %ebx
80108744:	5d                   	pop    %ebp
80108745:	c3                   	ret    

80108746 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108746:	55                   	push   %ebp
80108747:	89 e5                	mov    %esp,%ebp
80108749:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010874c:	8b 45 10             	mov    0x10(%ebp),%eax
8010874f:	85 c0                	test   %eax,%eax
80108751:	79 0a                	jns    8010875d <allocuvm+0x17>
    return 0;
80108753:	b8 00 00 00 00       	mov    $0x0,%eax
80108758:	e9 c1 00 00 00       	jmp    8010881e <allocuvm+0xd8>
  if(newsz < oldsz)
8010875d:	8b 45 10             	mov    0x10(%ebp),%eax
80108760:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108763:	73 08                	jae    8010876d <allocuvm+0x27>
    return oldsz;
80108765:	8b 45 0c             	mov    0xc(%ebp),%eax
80108768:	e9 b1 00 00 00       	jmp    8010881e <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010876d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108770:	05 ff 0f 00 00       	add    $0xfff,%eax
80108775:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010877a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010877d:	e9 8d 00 00 00       	jmp    8010880f <allocuvm+0xc9>
    mem = kalloc();
80108782:	e8 7b a3 ff ff       	call   80102b02 <kalloc>
80108787:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010878a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010878e:	75 2c                	jne    801087bc <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108790:	c7 04 24 75 93 10 80 	movl   $0x80109375,(%esp)
80108797:	e8 04 7c ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010879c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010879f:	89 44 24 08          	mov    %eax,0x8(%esp)
801087a3:	8b 45 10             	mov    0x10(%ebp),%eax
801087a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801087aa:	8b 45 08             	mov    0x8(%ebp),%eax
801087ad:	89 04 24             	mov    %eax,(%esp)
801087b0:	e8 6b 00 00 00       	call   80108820 <deallocuvm>
      return 0;
801087b5:	b8 00 00 00 00       	mov    $0x0,%eax
801087ba:	eb 62                	jmp    8010881e <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801087bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087c3:	00 
801087c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087cb:	00 
801087cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087cf:	89 04 24             	mov    %eax,(%esp)
801087d2:	e8 39 cf ff ff       	call   80105710 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087da:	89 04 24             	mov    %eax,(%esp)
801087dd:	e8 cc f5 ff ff       	call   80107dae <v2p>
801087e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801087e5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801087ec:	00 
801087ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
801087f1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087f8:	00 
801087f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801087fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108800:	89 04 24             	mov    %eax,(%esp)
80108803:	e8 d8 fa ff ff       	call   801082e0 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108808:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010880f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108812:	3b 45 10             	cmp    0x10(%ebp),%eax
80108815:	0f 82 67 ff ff ff    	jb     80108782 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010881b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010881e:	c9                   	leave  
8010881f:	c3                   	ret    

80108820 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108826:	8b 45 10             	mov    0x10(%ebp),%eax
80108829:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010882c:	72 08                	jb     80108836 <deallocuvm+0x16>
    return oldsz;
8010882e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108831:	e9 a4 00 00 00       	jmp    801088da <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108836:	8b 45 10             	mov    0x10(%ebp),%eax
80108839:	05 ff 0f 00 00       	add    $0xfff,%eax
8010883e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108846:	e9 80 00 00 00       	jmp    801088cb <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010884b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108855:	00 
80108856:	89 44 24 04          	mov    %eax,0x4(%esp)
8010885a:	8b 45 08             	mov    0x8(%ebp),%eax
8010885d:	89 04 24             	mov    %eax,(%esp)
80108860:	e8 d9 f9 ff ff       	call   8010823e <walkpgdir>
80108865:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010886c:	75 09                	jne    80108877 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010886e:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108875:	eb 4d                	jmp    801088c4 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108877:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010887a:	8b 00                	mov    (%eax),%eax
8010887c:	83 e0 01             	and    $0x1,%eax
8010887f:	85 c0                	test   %eax,%eax
80108881:	74 41                	je     801088c4 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108883:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108886:	8b 00                	mov    (%eax),%eax
80108888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010888d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108890:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108894:	75 0c                	jne    801088a2 <deallocuvm+0x82>
        panic("kfree");
80108896:	c7 04 24 8d 93 10 80 	movl   $0x8010938d,(%esp)
8010889d:	e8 98 7c ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
801088a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a5:	89 04 24             	mov    %eax,(%esp)
801088a8:	e8 0e f5 ff ff       	call   80107dbb <p2v>
801088ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801088b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801088b3:	89 04 24             	mov    %eax,(%esp)
801088b6:	e8 ae a1 ff ff       	call   80102a69 <kfree>
      *pte = 0;
801088bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801088c4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088d1:	0f 82 74 ff ff ff    	jb     8010884b <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801088d7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801088da:	c9                   	leave  
801088db:	c3                   	ret    

801088dc <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801088dc:	55                   	push   %ebp
801088dd:	89 e5                	mov    %esp,%ebp
801088df:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801088e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801088e6:	75 0c                	jne    801088f4 <freevm+0x18>
    panic("freevm: no pgdir");
801088e8:	c7 04 24 93 93 10 80 	movl   $0x80109393,(%esp)
801088ef:	e8 46 7c ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801088f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088fb:	00 
801088fc:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108903:	80 
80108904:	8b 45 08             	mov    0x8(%ebp),%eax
80108907:	89 04 24             	mov    %eax,(%esp)
8010890a:	e8 11 ff ff ff       	call   80108820 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010890f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108916:	eb 48                	jmp    80108960 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108922:	8b 45 08             	mov    0x8(%ebp),%eax
80108925:	01 d0                	add    %edx,%eax
80108927:	8b 00                	mov    (%eax),%eax
80108929:	83 e0 01             	and    $0x1,%eax
8010892c:	85 c0                	test   %eax,%eax
8010892e:	74 2c                	je     8010895c <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108933:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010893a:	8b 45 08             	mov    0x8(%ebp),%eax
8010893d:	01 d0                	add    %edx,%eax
8010893f:	8b 00                	mov    (%eax),%eax
80108941:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108946:	89 04 24             	mov    %eax,(%esp)
80108949:	e8 6d f4 ff ff       	call   80107dbb <p2v>
8010894e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108951:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108954:	89 04 24             	mov    %eax,(%esp)
80108957:	e8 0d a1 ff ff       	call   80102a69 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010895c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108960:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108967:	76 af                	jbe    80108918 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108969:	8b 45 08             	mov    0x8(%ebp),%eax
8010896c:	89 04 24             	mov    %eax,(%esp)
8010896f:	e8 f5 a0 ff ff       	call   80102a69 <kfree>
}
80108974:	c9                   	leave  
80108975:	c3                   	ret    

80108976 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108976:	55                   	push   %ebp
80108977:	89 e5                	mov    %esp,%ebp
80108979:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010897c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108983:	00 
80108984:	8b 45 0c             	mov    0xc(%ebp),%eax
80108987:	89 44 24 04          	mov    %eax,0x4(%esp)
8010898b:	8b 45 08             	mov    0x8(%ebp),%eax
8010898e:	89 04 24             	mov    %eax,(%esp)
80108991:	e8 a8 f8 ff ff       	call   8010823e <walkpgdir>
80108996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010899d:	75 0c                	jne    801089ab <clearpteu+0x35>
    panic("clearpteu");
8010899f:	c7 04 24 a4 93 10 80 	movl   $0x801093a4,(%esp)
801089a6:	e8 8f 7b ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801089ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ae:	8b 00                	mov    (%eax),%eax
801089b0:	83 e0 fb             	and    $0xfffffffb,%eax
801089b3:	89 c2                	mov    %eax,%edx
801089b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b8:	89 10                	mov    %edx,(%eax)
}
801089ba:	c9                   	leave  
801089bb:	c3                   	ret    

801089bc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801089bc:	55                   	push   %ebp
801089bd:	89 e5                	mov    %esp,%ebp
801089bf:	53                   	push   %ebx
801089c0:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801089c3:	e8 b0 f9 ff ff       	call   80108378 <setupkvm>
801089c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089cf:	75 0a                	jne    801089db <copyuvm+0x1f>
    return 0;
801089d1:	b8 00 00 00 00       	mov    $0x0,%eax
801089d6:	e9 fd 00 00 00       	jmp    80108ad8 <copyuvm+0x11c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
801089db:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
801089e2:	e9 d0 00 00 00       	jmp    80108ab7 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801089e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089f1:	00 
801089f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801089f6:	8b 45 08             	mov    0x8(%ebp),%eax
801089f9:	89 04 24             	mov    %eax,(%esp)
801089fc:	e8 3d f8 ff ff       	call   8010823e <walkpgdir>
80108a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a08:	75 0c                	jne    80108a16 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108a0a:	c7 04 24 ae 93 10 80 	movl   $0x801093ae,(%esp)
80108a11:	e8 24 7b ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a19:	8b 00                	mov    (%eax),%eax
80108a1b:	83 e0 01             	and    $0x1,%eax
80108a1e:	85 c0                	test   %eax,%eax
80108a20:	75 0c                	jne    80108a2e <copyuvm+0x72>
      panic("copyuvm: page not present");
80108a22:	c7 04 24 c8 93 10 80 	movl   $0x801093c8,(%esp)
80108a29:	e8 0c 7b ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a31:	8b 00                	mov    (%eax),%eax
80108a33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a3e:	8b 00                	mov    (%eax),%eax
80108a40:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108a48:	e8 b5 a0 ff ff       	call   80102b02 <kalloc>
80108a4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108a54:	75 02                	jne    80108a58 <copyuvm+0x9c>
      goto bad;
80108a56:	eb 70                	jmp    80108ac8 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a5b:	89 04 24             	mov    %eax,(%esp)
80108a5e:	e8 58 f3 ff ff       	call   80107dbb <p2v>
80108a63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a6a:	00 
80108a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a72:	89 04 24             	mov    %eax,(%esp)
80108a75:	e8 65 cd ff ff       	call   801057df <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a80:	89 04 24             	mov    %eax,(%esp)
80108a83:	e8 26 f3 ff ff       	call   80107dae <v2p>
80108a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108a8b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108a8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108a93:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a9a:	00 
80108a9b:	89 54 24 04          	mov    %edx,0x4(%esp)
80108a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aa2:	89 04 24             	mov    %eax,(%esp)
80108aa5:	e8 36 f8 ff ff       	call   801082e0 <mappages>
80108aaa:	85 c0                	test   %eax,%eax
80108aac:	79 02                	jns    80108ab0 <copyuvm+0xf4>
      goto bad;
80108aae:	eb 18                	jmp    80108ac8 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
80108ab0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aba:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108abd:	0f 82 24 ff ff ff    	jb     801089e7 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ac6:	eb 10                	jmp    80108ad8 <copyuvm+0x11c>

bad:
  freevm(d);
80108ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108acb:	89 04 24             	mov    %eax,(%esp)
80108ace:	e8 09 fe ff ff       	call   801088dc <freevm>
  return 0;
80108ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ad8:	83 c4 44             	add    $0x44,%esp
80108adb:	5b                   	pop    %ebx
80108adc:	5d                   	pop    %ebp
80108add:	c3                   	ret    

80108ade <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108ade:	55                   	push   %ebp
80108adf:	89 e5                	mov    %esp,%ebp
80108ae1:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ae4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108aeb:	00 
80108aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aef:	89 44 24 04          	mov    %eax,0x4(%esp)
80108af3:	8b 45 08             	mov    0x8(%ebp),%eax
80108af6:	89 04 24             	mov    %eax,(%esp)
80108af9:	e8 40 f7 ff ff       	call   8010823e <walkpgdir>
80108afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b04:	8b 00                	mov    (%eax),%eax
80108b06:	83 e0 01             	and    $0x1,%eax
80108b09:	85 c0                	test   %eax,%eax
80108b0b:	75 07                	jne    80108b14 <uva2ka+0x36>
    return 0;
80108b0d:	b8 00 00 00 00       	mov    $0x0,%eax
80108b12:	eb 25                	jmp    80108b39 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b17:	8b 00                	mov    (%eax),%eax
80108b19:	83 e0 04             	and    $0x4,%eax
80108b1c:	85 c0                	test   %eax,%eax
80108b1e:	75 07                	jne    80108b27 <uva2ka+0x49>
    return 0;
80108b20:	b8 00 00 00 00       	mov    $0x0,%eax
80108b25:	eb 12                	jmp    80108b39 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2a:	8b 00                	mov    (%eax),%eax
80108b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b31:	89 04 24             	mov    %eax,(%esp)
80108b34:	e8 82 f2 ff ff       	call   80107dbb <p2v>
}
80108b39:	c9                   	leave  
80108b3a:	c3                   	ret    

80108b3b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108b3b:	55                   	push   %ebp
80108b3c:	89 e5                	mov    %esp,%ebp
80108b3e:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108b41:	8b 45 10             	mov    0x10(%ebp),%eax
80108b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108b47:	e9 87 00 00 00       	jmp    80108bd3 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80108b61:	89 04 24             	mov    %eax,(%esp)
80108b64:	e8 75 ff ff ff       	call   80108ade <uva2ka>
80108b69:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108b6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108b70:	75 07                	jne    80108b79 <copyout+0x3e>
      return -1;
80108b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b77:	eb 69                	jmp    80108be2 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108b7f:	29 c2                	sub    %eax,%edx
80108b81:	89 d0                	mov    %edx,%eax
80108b83:	05 00 10 00 00       	add    $0x1000,%eax
80108b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b8e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108b91:	76 06                	jbe    80108b99 <copyout+0x5e>
      n = len;
80108b93:	8b 45 14             	mov    0x14(%ebp),%eax
80108b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b9f:	29 c2                	sub    %eax,%edx
80108ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ba4:	01 c2                	add    %eax,%edx
80108ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ba9:	89 44 24 08          	mov    %eax,0x8(%esp)
80108bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bb4:	89 14 24             	mov    %edx,(%esp)
80108bb7:	e8 23 cc ff ff       	call   801057df <memmove>
    len -= n;
80108bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bbf:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc5:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bcb:	05 00 10 00 00       	add    $0x1000,%eax
80108bd0:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108bd3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108bd7:	0f 85 6f ff ff ff    	jne    80108b4c <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108be2:	c9                   	leave  
80108be3:	c3                   	ret    
