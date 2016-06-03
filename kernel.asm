
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
8010002d:	b8 fb 34 10 80       	mov    $0x801034fb,%eax
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
8010003a:	c7 44 24 04 84 8b 10 	movl   $0x80108b84,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 4e 53 00 00       	call   8010539c <initlock>

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
801000bd:	e8 fb 52 00 00       	call   801053bd <acquire>

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
80100104:	e8 5e 53 00 00       	call   80105467 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 e5 4c 00 00       	call   80104e09 <sleep>
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
8010017c:	e8 e6 52 00 00       	call   80105467 <release>
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
80100198:	c7 04 24 8b 8b 10 80 	movl   $0x80108b8b,(%esp)
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
801001d3:	e8 19 26 00 00       	call   801027f1 <iderw>
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
801001ef:	c7 04 24 9c 8b 10 80 	movl   $0x80108b9c,(%esp)
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
80100210:	e8 dc 25 00 00       	call   801027f1 <iderw>
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
80100229:	c7 04 24 a3 8b 10 80 	movl   $0x80108ba3,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 7c 51 00 00       	call   801053bd <acquire>

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
8010029d:	e8 ab 4c 00 00       	call   80104f4d <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 b9 51 00 00       	call   80105467 <release>
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
801003bb:	e8 fd 4f 00 00       	call   801053bd <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 aa 8b 10 80 	movl   $0x80108baa,(%esp)
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
801004b0:	c7 45 ec b3 8b 10 80 	movl   $0x80108bb3,-0x14(%ebp)
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
80100533:	e8 2f 4f 00 00       	call   80105467 <release>
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
8010055f:	c7 04 24 ba 8b 10 80 	movl   $0x80108bba,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 c9 8b 10 80 	movl   $0x80108bc9,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 6a 4f 00 00       	call   801054fe <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 cb 8b 10 80 	movl   $0x80108bcb,(%esp)
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
801006b2:	e8 b9 50 00 00       	call   80105770 <memmove>
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
801006e1:	e8 bb 4f 00 00       	call   801056a1 <memset>
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
80100776:	e8 3d 6a 00 00       	call   801071b8 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 31 6a 00 00       	call   801071b8 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 25 6a 00 00       	call   801071b8 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 18 6a 00 00       	call   801071b8 <uartputc>
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
801007ba:	e8 fe 4b 00 00       	call   801053bd <acquire>
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
801007ea:	e8 04 48 00 00       	call   80104ff3 <procdump>
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
801008f3:	e8 55 46 00 00       	call   80104f4d <wakeup>
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
80100914:	e8 4e 4b 00 00       	call   80105467 <release>
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
80100927:	e8 cd 10 00 00       	call   801019f9 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100939:	e8 7f 4a 00 00       	call   801053bd <acquire>
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
80100959:	e8 09 4b 00 00       	call   80105467 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 42 0f 00 00       	call   801018ab <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100982:	e8 82 44 00 00       	call   80104e09 <sleep>

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
801009fe:	e8 64 4a 00 00       	call   80105467 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 9d 0e 00 00       	call   801018ab <ilock>

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
80100a26:	e8 ce 0f 00 00       	call   801019f9 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 86 49 00 00       	call   801053bd <acquire>
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
80100a6c:	e8 f6 49 00 00       	call   80105467 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 2f 0e 00 00       	call   801018ab <ilock>

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
80100a87:	c7 44 24 04 cf 8b 10 	movl   $0x80108bcf,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 01 49 00 00       	call   8010539c <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 d7 8b 10 	movl   $0x80108bd7,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100aaa:	e8 ed 48 00 00       	call   8010539c <initlock>

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
80100ad4:	e8 bf 30 00 00       	call   80103b98 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 c0 1e 00 00       	call   801029ad <ioapicenable>
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
  cprintf("exec starting\n");
80100af8:	c7 04 24 dd 8b 10 80 	movl   $0x80108bdd,(%esp)
80100aff:	e8 9c f8 ff ff       	call   801003a0 <cprintf>
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b04:	8b 45 08             	mov    0x8(%ebp),%eax
80100b07:	89 04 24             	mov    %eax,(%esp)
80100b0a:	e8 47 19 00 00       	call   80102456 <namei>
80100b0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b16:	75 0a                	jne    80100b22 <exec+0x33>
    return -1;
80100b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1d:	e9 36 04 00 00       	jmp    80100f58 <exec+0x469>
  ilock(ip);
80100b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b25:	89 04 24             	mov    %eax,(%esp)
80100b28:	e8 7e 0d 00 00       	call   801018ab <ilock>
  pgdir = 0;
80100b2d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b34:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3b:	00 
80100b3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b43:	00 
80100b44:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b51:	89 04 24             	mov    %eax,(%esp)
80100b54:	e8 5f 12 00 00       	call   80101db8 <readi>
80100b59:	83 f8 33             	cmp    $0x33,%eax
80100b5c:	77 05                	ja     80100b63 <exec+0x74>
    goto bad;
80100b5e:	e9 c2 03 00 00       	jmp    80100f25 <exec+0x436>
  if(elf.magic != ELF_MAGIC)
80100b63:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6e:	74 05                	je     80100b75 <exec+0x86>
    goto bad;
80100b70:	e9 b0 03 00 00       	jmp    80100f25 <exec+0x436>

  if((pgdir = setupkvm()) == 0)
80100b75:	e8 8f 77 00 00       	call   80108309 <setupkvm>
80100b7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b81:	75 05                	jne    80100b88 <exec+0x99>
    goto bad;
80100b83:	e9 9d 03 00 00       	jmp    80100f25 <exec+0x436>

  // Load program into memory.
  sz = 0;
80100b88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  if((sz = allocuvm(pgdir,sz,PGSIZE)) == 0) {
80100b8f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80100b96:	00 
80100b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ba1:	89 04 24             	mov    %eax,(%esp)
80100ba4:	e8 2e 7b 00 00       	call   801086d7 <allocuvm>
80100ba9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100bac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100bb0:	75 11                	jne    80100bc3 <exec+0xd4>
    cprintf("exec err\n");
80100bb2:	c7 04 24 ec 8b 10 80 	movl   $0x80108bec,(%esp)
80100bb9:	e8 e2 f7 ff ff       	call   801003a0 <cprintf>
    goto bad;
80100bbe:	e9 62 03 00 00       	jmp    80100f25 <exec+0x436>
  }
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bca:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bd3:	e9 cb 00 00 00       	jmp    80100ca3 <exec+0x1b4>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bdb:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100be2:	00 
80100be3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100be7:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bf1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bf4:	89 04 24             	mov    %eax,(%esp)
80100bf7:	e8 bc 11 00 00       	call   80101db8 <readi>
80100bfc:	83 f8 20             	cmp    $0x20,%eax
80100bff:	74 05                	je     80100c06 <exec+0x117>
      goto bad;
80100c01:	e9 1f 03 00 00       	jmp    80100f25 <exec+0x436>
    if(ph.type != ELF_PROG_LOAD)
80100c06:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c0c:	83 f8 01             	cmp    $0x1,%eax
80100c0f:	74 05                	je     80100c16 <exec+0x127>
      continue;
80100c11:	e9 80 00 00 00       	jmp    80100c96 <exec+0x1a7>
    if(ph.memsz < ph.filesz)
80100c16:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c1c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c22:	39 c2                	cmp    %eax,%edx
80100c24:	73 05                	jae    80100c2b <exec+0x13c>
      goto bad;
80100c26:	e9 fa 02 00 00       	jmp    80100f25 <exec+0x436>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c2b:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c31:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c37:	01 d0                	add    %edx,%eax
80100c39:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c40:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c47:	89 04 24             	mov    %eax,(%esp)
80100c4a:	e8 88 7a 00 00       	call   801086d7 <allocuvm>
80100c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c56:	75 05                	jne    80100c5d <exec+0x16e>
      goto bad;
80100c58:	e9 c8 02 00 00       	jmp    80100f25 <exec+0x436>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c5d:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c63:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c69:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c73:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c77:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c7a:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c85:	89 04 24             	mov    %eax,(%esp)
80100c88:	e8 5f 79 00 00       	call   801085ec <loaduvm>
80100c8d:	85 c0                	test   %eax,%eax
80100c8f:	79 05                	jns    80100c96 <exec+0x1a7>
      goto bad;
80100c91:	e9 8f 02 00 00       	jmp    80100f25 <exec+0x436>
  sz = 0;
  if((sz = allocuvm(pgdir,sz,PGSIZE)) == 0) {
    cprintf("exec err\n");
    goto bad;
  }
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c96:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c9d:	83 c0 20             	add    $0x20,%eax
80100ca0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca3:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100caa:	0f b7 c0             	movzwl %ax,%eax
80100cad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb0:	0f 8f 22 ff ff ff    	jg     80100bd8 <exec+0xe9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cb9:	89 04 24             	mov    %eax,(%esp)
80100cbc:	e8 6e 0e 00 00       	call   80101b2f <iunlockput>
  ip = 0;
80100cc1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ccb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cdb:	05 00 20 00 00       	add    $0x2000,%eax
80100ce0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ceb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 e1 79 00 00       	call   801086d7 <allocuvm>
80100cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cfd:	75 05                	jne    80100d04 <exec+0x215>
    goto bad;
80100cff:	e9 21 02 00 00       	jmp    80100f25 <exec+0x436>
  proc->pstack = (uint *)sz;
80100d04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100d0d:	89 50 7c             	mov    %edx,0x7c(%eax)

  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d13:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d18:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d1f:	89 04 24             	mov    %eax,(%esp)
80100d22:	e8 e0 7b 00 00       	call   80108907 <clearpteu>

  sp = sz;
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d34:	e9 9a 00 00 00       	jmp    80100dd3 <exec+0x2e4>
    if(argc >= MAXARG)
80100d39:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d3d:	76 05                	jbe    80100d44 <exec+0x255>
      goto bad;
80100d3f:	e9 e1 01 00 00       	jmp    80100f25 <exec+0x436>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d51:	01 d0                	add    %edx,%eax
80100d53:	8b 00                	mov    (%eax),%eax
80100d55:	89 04 24             	mov    %eax,(%esp)
80100d58:	e8 ae 4b 00 00       	call   8010590b <strlen>
80100d5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d60:	29 c2                	sub    %eax,%edx
80100d62:	89 d0                	mov    %edx,%eax
80100d64:	83 e8 01             	sub    $0x1,%eax
80100d67:	83 e0 fc             	and    $0xfffffffc,%eax
80100d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7a:	01 d0                	add    %edx,%eax
80100d7c:	8b 00                	mov    (%eax),%eax
80100d7e:	89 04 24             	mov    %eax,(%esp)
80100d81:	e8 85 4b 00 00       	call   8010590b <strlen>
80100d86:	83 c0 01             	add    $0x1,%eax
80100d89:	89 c2                	mov    %eax,%edx
80100d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d95:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d98:	01 c8                	add    %ecx,%eax
80100d9a:	8b 00                	mov    (%eax),%eax
80100d9c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100da0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100dae:	89 04 24             	mov    %eax,(%esp)
80100db1:	e8 22 7d 00 00       	call   80108ad8 <copyout>
80100db6:	85 c0                	test   %eax,%eax
80100db8:	79 05                	jns    80100dbf <exec+0x2d0>
      goto bad;
80100dba:	e9 66 01 00 00       	jmp    80100f25 <exec+0x436>
    ustack[3+argc] = sp;
80100dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc2:	8d 50 03             	lea    0x3(%eax),%edx
80100dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc8:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dcf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de0:	01 d0                	add    %edx,%eax
80100de2:	8b 00                	mov    (%eax),%eax
80100de4:	85 c0                	test   %eax,%eax
80100de6:	0f 85 4d ff ff ff    	jne    80100d39 <exec+0x24a>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100def:	83 c0 03             	add    $0x3,%eax
80100df2:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dfd:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e04:	ff ff ff 
  ustack[1] = argc;
80100e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e13:	83 c0 01             	add    $0x1,%eax
80100e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e20:	29 d0                	sub    %edx,%eax
80100e22:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2b:	83 c0 04             	add    $0x4,%eax
80100e2e:	c1 e0 02             	shl    $0x2,%eax
80100e31:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e37:	83 c0 04             	add    $0x4,%eax
80100e3a:	c1 e0 02             	shl    $0x2,%eax
80100e3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e41:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e47:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e55:	89 04 24             	mov    %eax,(%esp)
80100e58:	e8 7b 7c 00 00       	call   80108ad8 <copyout>
80100e5d:	85 c0                	test   %eax,%eax
80100e5f:	79 05                	jns    80100e66 <exec+0x377>
    goto bad;
80100e61:	e9 bf 00 00 00       	jmp    80100f25 <exec+0x436>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e66:	8b 45 08             	mov    0x8(%ebp),%eax
80100e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e72:	eb 17                	jmp    80100e8b <exec+0x39c>
    if(*s == '/')
80100e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e77:	0f b6 00             	movzbl (%eax),%eax
80100e7a:	3c 2f                	cmp    $0x2f,%al
80100e7c:	75 09                	jne    80100e87 <exec+0x398>
      last = s+1;
80100e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e81:	83 c0 01             	add    $0x1,%eax
80100e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8e:	0f b6 00             	movzbl (%eax),%eax
80100e91:	84 c0                	test   %al,%al
80100e93:	75 df                	jne    80100e74 <exec+0x385>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9b:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e9e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ea5:	00 
80100ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ead:	89 14 24             	mov    %edx,(%esp)
80100eb0:	e8 0c 4a 00 00       	call   801058c1 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebb:	8b 40 04             	mov    0x4(%eax),%eax
80100ebe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eca:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ecd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed6:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ed8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ee7:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef0:	8b 40 18             	mov    0x18(%eax),%eax
80100ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef6:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ef9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 f3 74 00 00       	call   801083fa <switchuvm>
  freevm(oldpgdir);
80100f07:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f0a:	89 04 24             	mov    %eax,(%esp)
80100f0d:	e8 5b 79 00 00       	call   8010886d <freevm>
  cprintf("exec no err\n");
80100f12:	c7 04 24 f6 8b 10 80 	movl   $0x80108bf6,(%esp)
80100f19:	e8 82 f4 ff ff       	call   801003a0 <cprintf>
  return 0;
80100f1e:	b8 00 00 00 00       	mov    $0x0,%eax
80100f23:	eb 33                	jmp    80100f58 <exec+0x469>

 bad:
  cprintf("exec bad\n");
80100f25:	c7 04 24 03 8c 10 80 	movl   $0x80108c03,(%esp)
80100f2c:	e8 6f f4 ff ff       	call   801003a0 <cprintf>
  if(pgdir)
80100f31:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f35:	74 0b                	je     80100f42 <exec+0x453>
    freevm(pgdir);
80100f37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f3a:	89 04 24             	mov    %eax,(%esp)
80100f3d:	e8 2b 79 00 00       	call   8010886d <freevm>
  if(ip)
80100f42:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f46:	74 0b                	je     80100f53 <exec+0x464>
    iunlockput(ip);
80100f48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f4b:	89 04 24             	mov    %eax,(%esp)
80100f4e:	e8 dc 0b 00 00       	call   80101b2f <iunlockput>
  return -1;
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    

80100f5a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f5a:	55                   	push   %ebp
80100f5b:	89 e5                	mov    %esp,%ebp
80100f5d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f60:	c7 44 24 04 0d 8c 10 	movl   $0x80108c0d,0x4(%esp)
80100f67:	80 
80100f68:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f6f:	e8 28 44 00 00       	call   8010539c <initlock>
}
80100f74:	c9                   	leave  
80100f75:	c3                   	ret    

80100f76 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f76:	55                   	push   %ebp
80100f77:	89 e5                	mov    %esp,%ebp
80100f79:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f7c:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f83:	e8 35 44 00 00       	call   801053bd <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f88:	c7 45 f4 d4 ee 10 80 	movl   $0x8010eed4,-0xc(%ebp)
80100f8f:	eb 29                	jmp    80100fba <filealloc+0x44>
    if(f->ref == 0){
80100f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f94:	8b 40 04             	mov    0x4(%eax),%eax
80100f97:	85 c0                	test   %eax,%eax
80100f99:	75 1b                	jne    80100fb6 <filealloc+0x40>
      f->ref = 1;
80100f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fa5:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fac:	e8 b6 44 00 00       	call   80105467 <release>
      return f;
80100fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb4:	eb 1e                	jmp    80100fd4 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb6:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fba:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80100fc1:	72 ce                	jb     80100f91 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fc3:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fca:	e8 98 44 00 00       	call   80105467 <release>
  return 0;
80100fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fd4:	c9                   	leave  
80100fd5:	c3                   	ret    

80100fd6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fd6:	55                   	push   %ebp
80100fd7:	89 e5                	mov    %esp,%ebp
80100fd9:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fdc:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fe3:	e8 d5 43 00 00       	call   801053bd <acquire>
  if(f->ref < 1)
80100fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80100feb:	8b 40 04             	mov    0x4(%eax),%eax
80100fee:	85 c0                	test   %eax,%eax
80100ff0:	7f 0c                	jg     80100ffe <filedup+0x28>
    panic("filedup");
80100ff2:	c7 04 24 14 8c 10 80 	movl   $0x80108c14,(%esp)
80100ff9:	e8 3c f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80101001:	8b 40 04             	mov    0x4(%eax),%eax
80101004:	8d 50 01             	lea    0x1(%eax),%edx
80101007:	8b 45 08             	mov    0x8(%ebp),%eax
8010100a:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010100d:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80101014:	e8 4e 44 00 00       	call   80105467 <release>
  return f;
80101019:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010101c:	c9                   	leave  
8010101d:	c3                   	ret    

8010101e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010101e:	55                   	push   %ebp
8010101f:	89 e5                	mov    %esp,%ebp
80101021:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101024:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010102b:	e8 8d 43 00 00       	call   801053bd <acquire>
  if(f->ref < 1)
80101030:	8b 45 08             	mov    0x8(%ebp),%eax
80101033:	8b 40 04             	mov    0x4(%eax),%eax
80101036:	85 c0                	test   %eax,%eax
80101038:	7f 0c                	jg     80101046 <fileclose+0x28>
    panic("fileclose");
8010103a:	c7 04 24 1c 8c 10 80 	movl   $0x80108c1c,(%esp)
80101041:	e8 f4 f4 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	8b 40 04             	mov    0x4(%eax),%eax
8010104c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104f:	8b 45 08             	mov    0x8(%ebp),%eax
80101052:	89 50 04             	mov    %edx,0x4(%eax)
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	8b 40 04             	mov    0x4(%eax),%eax
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7e 11                	jle    80101070 <fileclose+0x52>
    release(&ftable.lock);
8010105f:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80101066:	e8 fc 43 00 00       	call   80105467 <release>
8010106b:	e9 82 00 00 00       	jmp    801010f2 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101070:	8b 45 08             	mov    0x8(%ebp),%eax
80101073:	8b 10                	mov    (%eax),%edx
80101075:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101078:	8b 50 04             	mov    0x4(%eax),%edx
8010107b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010107e:	8b 50 08             	mov    0x8(%eax),%edx
80101081:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101084:	8b 50 0c             	mov    0xc(%eax),%edx
80101087:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010108a:	8b 50 10             	mov    0x10(%eax),%edx
8010108d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101090:	8b 40 14             	mov    0x14(%eax),%eax
80101093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010a9:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801010b0:	e8 b2 43 00 00       	call   80105467 <release>
  
  if(ff.type == FD_PIPE)
801010b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	75 18                	jne    801010d5 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010bd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010c1:	0f be d0             	movsbl %al,%edx
801010c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801010cb:	89 04 24             	mov    %eax,(%esp)
801010ce:	e8 75 2d 00 00       	call   80103e48 <pipeclose>
801010d3:	eb 1d                	jmp    801010f2 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d8:	83 f8 02             	cmp    $0x2,%eax
801010db:	75 15                	jne    801010f2 <fileclose+0xd4>
    begin_trans();
801010dd:	e8 39 22 00 00       	call   8010331b <begin_trans>
    iput(ff.ip);
801010e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010e5:	89 04 24             	mov    %eax,(%esp)
801010e8:	e8 71 09 00 00       	call   80101a5e <iput>
    commit_trans();
801010ed:	e8 72 22 00 00       	call   80103364 <commit_trans>
  }
}
801010f2:	c9                   	leave  
801010f3:	c3                   	ret    

801010f4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f4:	55                   	push   %ebp
801010f5:	89 e5                	mov    %esp,%ebp
801010f7:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 00                	mov    (%eax),%eax
801010ff:	83 f8 02             	cmp    $0x2,%eax
80101102:	75 38                	jne    8010113c <filestat+0x48>
    ilock(f->ip);
80101104:	8b 45 08             	mov    0x8(%ebp),%eax
80101107:	8b 40 10             	mov    0x10(%eax),%eax
8010110a:	89 04 24             	mov    %eax,(%esp)
8010110d:	e8 99 07 00 00       	call   801018ab <ilock>
    stati(f->ip, st);
80101112:	8b 45 08             	mov    0x8(%ebp),%eax
80101115:	8b 40 10             	mov    0x10(%eax),%eax
80101118:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010111f:	89 04 24             	mov    %eax,(%esp)
80101122:	e8 4c 0c 00 00       	call   80101d73 <stati>
    iunlock(f->ip);
80101127:	8b 45 08             	mov    0x8(%ebp),%eax
8010112a:	8b 40 10             	mov    0x10(%eax),%eax
8010112d:	89 04 24             	mov    %eax,(%esp)
80101130:	e8 c4 08 00 00       	call   801019f9 <iunlock>
    return 0;
80101135:	b8 00 00 00 00       	mov    $0x0,%eax
8010113a:	eb 05                	jmp    80101141 <filestat+0x4d>
  }
  return -1;
8010113c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101141:	c9                   	leave  
80101142:	c3                   	ret    

80101143 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101143:	55                   	push   %ebp
80101144:	89 e5                	mov    %esp,%ebp
80101146:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101150:	84 c0                	test   %al,%al
80101152:	75 0a                	jne    8010115e <fileread+0x1b>
    return -1;
80101154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101159:	e9 9f 00 00 00       	jmp    801011fd <fileread+0xba>
  if(f->type == FD_PIPE)
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	8b 00                	mov    (%eax),%eax
80101163:	83 f8 01             	cmp    $0x1,%eax
80101166:	75 1e                	jne    80101186 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101168:	8b 45 08             	mov    0x8(%ebp),%eax
8010116b:	8b 40 0c             	mov    0xc(%eax),%eax
8010116e:	8b 55 10             	mov    0x10(%ebp),%edx
80101171:	89 54 24 08          	mov    %edx,0x8(%esp)
80101175:	8b 55 0c             	mov    0xc(%ebp),%edx
80101178:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117c:	89 04 24             	mov    %eax,(%esp)
8010117f:	e8 45 2e 00 00       	call   80103fc9 <piperead>
80101184:	eb 77                	jmp    801011fd <fileread+0xba>
  if(f->type == FD_INODE){
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	8b 00                	mov    (%eax),%eax
8010118b:	83 f8 02             	cmp    $0x2,%eax
8010118e:	75 61                	jne    801011f1 <fileread+0xae>
    ilock(f->ip);
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 40 10             	mov    0x10(%eax),%eax
80101196:	89 04 24             	mov    %eax,(%esp)
80101199:	e8 0d 07 00 00       	call   801018ab <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010119e:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011a1:	8b 45 08             	mov    0x8(%ebp),%eax
801011a4:	8b 50 14             	mov    0x14(%eax),%edx
801011a7:	8b 45 08             	mov    0x8(%ebp),%eax
801011aa:	8b 40 10             	mov    0x10(%eax),%eax
801011ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011b1:	89 54 24 08          	mov    %edx,0x8(%esp)
801011b5:	8b 55 0c             	mov    0xc(%ebp),%edx
801011b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801011bc:	89 04 24             	mov    %eax,(%esp)
801011bf:	e8 f4 0b 00 00       	call   80101db8 <readi>
801011c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011cb:	7e 11                	jle    801011de <fileread+0x9b>
      f->off += r;
801011cd:	8b 45 08             	mov    0x8(%ebp),%eax
801011d0:	8b 50 14             	mov    0x14(%eax),%edx
801011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d6:	01 c2                	add    %eax,%edx
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	8b 40 10             	mov    0x10(%eax),%eax
801011e4:	89 04 24             	mov    %eax,(%esp)
801011e7:	e8 0d 08 00 00       	call   801019f9 <iunlock>
    return r;
801011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ef:	eb 0c                	jmp    801011fd <fileread+0xba>
  }
  panic("fileread");
801011f1:	c7 04 24 26 8c 10 80 	movl   $0x80108c26,(%esp)
801011f8:	e8 3d f3 ff ff       	call   8010053a <panic>
}
801011fd:	c9                   	leave  
801011fe:	c3                   	ret    

801011ff <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011ff:	55                   	push   %ebp
80101200:	89 e5                	mov    %esp,%ebp
80101202:	53                   	push   %ebx
80101203:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101206:	8b 45 08             	mov    0x8(%ebp),%eax
80101209:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010120d:	84 c0                	test   %al,%al
8010120f:	75 0a                	jne    8010121b <filewrite+0x1c>
    return -1;
80101211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101216:	e9 20 01 00 00       	jmp    8010133b <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 00                	mov    (%eax),%eax
80101220:	83 f8 01             	cmp    $0x1,%eax
80101223:	75 21                	jne    80101246 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101225:	8b 45 08             	mov    0x8(%ebp),%eax
80101228:	8b 40 0c             	mov    0xc(%eax),%eax
8010122b:	8b 55 10             	mov    0x10(%ebp),%edx
8010122e:	89 54 24 08          	mov    %edx,0x8(%esp)
80101232:	8b 55 0c             	mov    0xc(%ebp),%edx
80101235:	89 54 24 04          	mov    %edx,0x4(%esp)
80101239:	89 04 24             	mov    %eax,(%esp)
8010123c:	e8 99 2c 00 00       	call   80103eda <pipewrite>
80101241:	e9 f5 00 00 00       	jmp    8010133b <filewrite+0x13c>
  if(f->type == FD_INODE){
80101246:	8b 45 08             	mov    0x8(%ebp),%eax
80101249:	8b 00                	mov    (%eax),%eax
8010124b:	83 f8 02             	cmp    $0x2,%eax
8010124e:	0f 85 db 00 00 00    	jne    8010132f <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101254:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010125b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101262:	e9 a8 00 00 00       	jmp    8010130f <filewrite+0x110>
      int n1 = n - i;
80101267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010126a:	8b 55 10             	mov    0x10(%ebp),%edx
8010126d:	29 c2                	sub    %eax,%edx
8010126f:	89 d0                	mov    %edx,%eax
80101271:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101277:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010127a:	7e 06                	jle    80101282 <filewrite+0x83>
        n1 = max;
8010127c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010127f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101282:	e8 94 20 00 00       	call   8010331b <begin_trans>
      ilock(f->ip);
80101287:	8b 45 08             	mov    0x8(%ebp),%eax
8010128a:	8b 40 10             	mov    0x10(%eax),%eax
8010128d:	89 04 24             	mov    %eax,(%esp)
80101290:	e8 16 06 00 00       	call   801018ab <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101295:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 50 14             	mov    0x14(%eax),%edx
8010129e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801012a4:	01 c3                	add    %eax,%ebx
801012a6:	8b 45 08             	mov    0x8(%ebp),%eax
801012a9:	8b 40 10             	mov    0x10(%eax),%eax
801012ac:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012b0:	89 54 24 08          	mov    %edx,0x8(%esp)
801012b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012b8:	89 04 24             	mov    %eax,(%esp)
801012bb:	e8 5c 0c 00 00       	call   80101f1c <writei>
801012c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c7:	7e 11                	jle    801012da <filewrite+0xdb>
        f->off += r;
801012c9:	8b 45 08             	mov    0x8(%ebp),%eax
801012cc:	8b 50 14             	mov    0x14(%eax),%edx
801012cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d2:	01 c2                	add    %eax,%edx
801012d4:	8b 45 08             	mov    0x8(%ebp),%eax
801012d7:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012da:	8b 45 08             	mov    0x8(%ebp),%eax
801012dd:	8b 40 10             	mov    0x10(%eax),%eax
801012e0:	89 04 24             	mov    %eax,(%esp)
801012e3:	e8 11 07 00 00       	call   801019f9 <iunlock>
      commit_trans();
801012e8:	e8 77 20 00 00       	call   80103364 <commit_trans>

      if(r < 0)
801012ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012f1:	79 02                	jns    801012f5 <filewrite+0xf6>
        break;
801012f3:	eb 26                	jmp    8010131b <filewrite+0x11c>
      if(r != n1)
801012f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012fb:	74 0c                	je     80101309 <filewrite+0x10a>
        panic("short filewrite");
801012fd:	c7 04 24 2f 8c 10 80 	movl   $0x80108c2f,(%esp)
80101304:	e8 31 f2 ff ff       	call   8010053a <panic>
      i += r;
80101309:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010130f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101312:	3b 45 10             	cmp    0x10(%ebp),%eax
80101315:	0f 8c 4c ff ff ff    	jl     80101267 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101321:	75 05                	jne    80101328 <filewrite+0x129>
80101323:	8b 45 10             	mov    0x10(%ebp),%eax
80101326:	eb 05                	jmp    8010132d <filewrite+0x12e>
80101328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010132d:	eb 0c                	jmp    8010133b <filewrite+0x13c>
  }
  panic("filewrite");
8010132f:	c7 04 24 3f 8c 10 80 	movl   $0x80108c3f,(%esp)
80101336:	e8 ff f1 ff ff       	call   8010053a <panic>
}
8010133b:	83 c4 24             	add    $0x24,%esp
8010133e:	5b                   	pop    %ebx
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    

80101341 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101341:	55                   	push   %ebp
80101342:	89 e5                	mov    %esp,%ebp
80101344:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101347:	8b 45 08             	mov    0x8(%ebp),%eax
8010134a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101351:	00 
80101352:	89 04 24             	mov    %eax,(%esp)
80101355:	e8 4c ee ff ff       	call   801001a6 <bread>
8010135a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101360:	83 c0 18             	add    $0x18,%eax
80101363:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010136a:	00 
8010136b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010136f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101372:	89 04 24             	mov    %eax,(%esp)
80101375:	e8 f6 43 00 00       	call   80105770 <memmove>
  brelse(bp);
8010137a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137d:	89 04 24             	mov    %eax,(%esp)
80101380:	e8 92 ee ff ff       	call   80100217 <brelse>
}
80101385:	c9                   	leave  
80101386:	c3                   	ret    

80101387 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101387:	55                   	push   %ebp
80101388:	89 e5                	mov    %esp,%ebp
8010138a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010138d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101390:	8b 45 08             	mov    0x8(%ebp),%eax
80101393:	89 54 24 04          	mov    %edx,0x4(%esp)
80101397:	89 04 24             	mov    %eax,(%esp)
8010139a:	e8 07 ee ff ff       	call   801001a6 <bread>
8010139f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a5:	83 c0 18             	add    $0x18,%eax
801013a8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013af:	00 
801013b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013b7:	00 
801013b8:	89 04 24             	mov    %eax,(%esp)
801013bb:	e8 e1 42 00 00       	call   801056a1 <memset>
  log_write(bp);
801013c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c3:	89 04 24             	mov    %eax,(%esp)
801013c6:	e8 f1 1f 00 00       	call   801033bc <log_write>
  brelse(bp);
801013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ce:	89 04 24             	mov    %eax,(%esp)
801013d1:	e8 41 ee ff ff       	call   80100217 <brelse>
}
801013d6:	c9                   	leave  
801013d7:	c3                   	ret    

801013d8 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013d8:	55                   	push   %ebp
801013d9:	89 e5                	mov    %esp,%ebp
801013db:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013e5:	8b 45 08             	mov    0x8(%ebp),%eax
801013e8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801013ef:	89 04 24             	mov    %eax,(%esp)
801013f2:	e8 4a ff ff ff       	call   80101341 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013fe:	e9 07 01 00 00       	jmp    8010150a <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101406:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010140c:	85 c0                	test   %eax,%eax
8010140e:	0f 48 c2             	cmovs  %edx,%eax
80101411:	c1 f8 0c             	sar    $0xc,%eax
80101414:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101417:	c1 ea 03             	shr    $0x3,%edx
8010141a:	01 d0                	add    %edx,%eax
8010141c:	83 c0 03             	add    $0x3,%eax
8010141f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101423:	8b 45 08             	mov    0x8(%ebp),%eax
80101426:	89 04 24             	mov    %eax,(%esp)
80101429:	e8 78 ed ff ff       	call   801001a6 <bread>
8010142e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101438:	e9 9d 00 00 00       	jmp    801014da <balloc+0x102>
      m = 1 << (bi % 8);
8010143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101440:	99                   	cltd   
80101441:	c1 ea 1d             	shr    $0x1d,%edx
80101444:	01 d0                	add    %edx,%eax
80101446:	83 e0 07             	and    $0x7,%eax
80101449:	29 d0                	sub    %edx,%eax
8010144b:	ba 01 00 00 00       	mov    $0x1,%edx
80101450:	89 c1                	mov    %eax,%ecx
80101452:	d3 e2                	shl    %cl,%edx
80101454:	89 d0                	mov    %edx,%eax
80101456:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010145c:	8d 50 07             	lea    0x7(%eax),%edx
8010145f:	85 c0                	test   %eax,%eax
80101461:	0f 48 c2             	cmovs  %edx,%eax
80101464:	c1 f8 03             	sar    $0x3,%eax
80101467:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146a:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010146f:	0f b6 c0             	movzbl %al,%eax
80101472:	23 45 e8             	and    -0x18(%ebp),%eax
80101475:	85 c0                	test   %eax,%eax
80101477:	75 5d                	jne    801014d6 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147c:	8d 50 07             	lea    0x7(%eax),%edx
8010147f:	85 c0                	test   %eax,%eax
80101481:	0f 48 c2             	cmovs  %edx,%eax
80101484:	c1 f8 03             	sar    $0x3,%eax
80101487:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010148a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010148f:	89 d1                	mov    %edx,%ecx
80101491:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101494:	09 ca                	or     %ecx,%edx
80101496:	89 d1                	mov    %edx,%ecx
80101498:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010149b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a2:	89 04 24             	mov    %eax,(%esp)
801014a5:	e8 12 1f 00 00       	call   801033bc <log_write>
        brelse(bp);
801014aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ad:	89 04 24             	mov    %eax,(%esp)
801014b0:	e8 62 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bb:	01 c2                	add    %eax,%edx
801014bd:	8b 45 08             	mov    0x8(%ebp),%eax
801014c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014c4:	89 04 24             	mov    %eax,(%esp)
801014c7:	e8 bb fe ff ff       	call   80101387 <bzero>
        return b + bi;
801014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d2:	01 d0                	add    %edx,%eax
801014d4:	eb 4e                	jmp    80101524 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014d6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014da:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014e1:	7f 15                	jg     801014f8 <balloc+0x120>
801014e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e9:	01 d0                	add    %edx,%eax
801014eb:	89 c2                	mov    %eax,%edx
801014ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014f0:	39 c2                	cmp    %eax,%edx
801014f2:	0f 82 45 ff ff ff    	jb     8010143d <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014fb:	89 04 24             	mov    %eax,(%esp)
801014fe:	e8 14 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101503:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101510:	39 c2                	cmp    %eax,%edx
80101512:	0f 82 eb fe ff ff    	jb     80101403 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101518:	c7 04 24 49 8c 10 80 	movl   $0x80108c49,(%esp)
8010151f:	e8 16 f0 ff ff       	call   8010053a <panic>
}
80101524:	c9                   	leave  
80101525:	c3                   	ret    

80101526 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101526:	55                   	push   %ebp
80101527:	89 e5                	mov    %esp,%ebp
80101529:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
8010152c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010152f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101533:	8b 45 08             	mov    0x8(%ebp),%eax
80101536:	89 04 24             	mov    %eax,(%esp)
80101539:	e8 03 fe ff ff       	call   80101341 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010153e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101541:	c1 e8 0c             	shr    $0xc,%eax
80101544:	89 c2                	mov    %eax,%edx
80101546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101549:	c1 e8 03             	shr    $0x3,%eax
8010154c:	01 d0                	add    %edx,%eax
8010154e:	8d 50 03             	lea    0x3(%eax),%edx
80101551:	8b 45 08             	mov    0x8(%ebp),%eax
80101554:	89 54 24 04          	mov    %edx,0x4(%esp)
80101558:	89 04 24             	mov    %eax,(%esp)
8010155b:	e8 46 ec ff ff       	call   801001a6 <bread>
80101560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101563:	8b 45 0c             	mov    0xc(%ebp),%eax
80101566:	25 ff 0f 00 00       	and    $0xfff,%eax
8010156b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101571:	99                   	cltd   
80101572:	c1 ea 1d             	shr    $0x1d,%edx
80101575:	01 d0                	add    %edx,%eax
80101577:	83 e0 07             	and    $0x7,%eax
8010157a:	29 d0                	sub    %edx,%eax
8010157c:	ba 01 00 00 00       	mov    $0x1,%edx
80101581:	89 c1                	mov    %eax,%ecx
80101583:	d3 e2                	shl    %cl,%edx
80101585:	89 d0                	mov    %edx,%eax
80101587:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158d:	8d 50 07             	lea    0x7(%eax),%edx
80101590:	85 c0                	test   %eax,%eax
80101592:	0f 48 c2             	cmovs  %edx,%eax
80101595:	c1 f8 03             	sar    $0x3,%eax
80101598:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159b:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
801015a0:	0f b6 c0             	movzbl %al,%eax
801015a3:	23 45 ec             	and    -0x14(%ebp),%eax
801015a6:	85 c0                	test   %eax,%eax
801015a8:	75 0c                	jne    801015b6 <bfree+0x90>
    panic("freeing free block");
801015aa:	c7 04 24 5f 8c 10 80 	movl   $0x80108c5f,(%esp)
801015b1:	e8 84 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
801015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b9:	8d 50 07             	lea    0x7(%eax),%edx
801015bc:	85 c0                	test   %eax,%eax
801015be:	0f 48 c2             	cmovs  %edx,%eax
801015c1:	c1 f8 03             	sar    $0x3,%eax
801015c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c7:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015cc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015cf:	f7 d1                	not    %ecx
801015d1:	21 ca                	and    %ecx,%edx
801015d3:	89 d1                	mov    %edx,%ecx
801015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d8:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015df:	89 04 24             	mov    %eax,(%esp)
801015e2:	e8 d5 1d 00 00       	call   801033bc <log_write>
  brelse(bp);
801015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ea:	89 04 24             	mov    %eax,(%esp)
801015ed:	e8 25 ec ff ff       	call   80100217 <brelse>
}
801015f2:	c9                   	leave  
801015f3:	c3                   	ret    

801015f4 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015fa:	c7 44 24 04 72 8c 10 	movl   $0x80108c72,0x4(%esp)
80101601:	80 
80101602:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101609:	e8 8e 3d 00 00       	call   8010539c <initlock>
}
8010160e:	c9                   	leave  
8010160f:	c3                   	ret    

80101610 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	83 ec 38             	sub    $0x38,%esp
80101616:	8b 45 0c             	mov    0xc(%ebp),%eax
80101619:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
8010161d:	8b 45 08             	mov    0x8(%ebp),%eax
80101620:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101623:	89 54 24 04          	mov    %edx,0x4(%esp)
80101627:	89 04 24             	mov    %eax,(%esp)
8010162a:	e8 12 fd ff ff       	call   80101341 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
8010162f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101636:	e9 98 00 00 00       	jmp    801016d3 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
8010163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163e:	c1 e8 03             	shr    $0x3,%eax
80101641:	83 c0 02             	add    $0x2,%eax
80101644:	89 44 24 04          	mov    %eax,0x4(%esp)
80101648:	8b 45 08             	mov    0x8(%ebp),%eax
8010164b:	89 04 24             	mov    %eax,(%esp)
8010164e:	e8 53 eb ff ff       	call   801001a6 <bread>
80101653:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	8d 50 18             	lea    0x18(%eax),%edx
8010165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010165f:	83 e0 07             	and    $0x7,%eax
80101662:	c1 e0 06             	shl    $0x6,%eax
80101665:	01 d0                	add    %edx,%eax
80101667:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010166a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010166d:	0f b7 00             	movzwl (%eax),%eax
80101670:	66 85 c0             	test   %ax,%ax
80101673:	75 4f                	jne    801016c4 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101675:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010167c:	00 
8010167d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101684:	00 
80101685:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101688:	89 04 24             	mov    %eax,(%esp)
8010168b:	e8 11 40 00 00       	call   801056a1 <memset>
      dip->type = type;
80101690:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101693:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101697:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169d:	89 04 24             	mov    %eax,(%esp)
801016a0:	e8 17 1d 00 00       	call   801033bc <log_write>
      brelse(bp);
801016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a8:	89 04 24             	mov    %eax,(%esp)
801016ab:	e8 67 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801016b7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ba:	89 04 24             	mov    %eax,(%esp)
801016bd:	e8 e5 00 00 00       	call   801017a7 <iget>
801016c2:	eb 29                	jmp    801016ed <ialloc+0xdd>
    }
    brelse(bp);
801016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c7:	89 04 24             	mov    %eax,(%esp)
801016ca:	e8 48 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016d9:	39 c2                	cmp    %eax,%edx
801016db:	0f 82 5a ff ff ff    	jb     8010163b <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016e1:	c7 04 24 79 8c 10 80 	movl   $0x80108c79,(%esp)
801016e8:	e8 4d ee ff ff       	call   8010053a <panic>
}
801016ed:	c9                   	leave  
801016ee:	c3                   	ret    

801016ef <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016ef:	55                   	push   %ebp
801016f0:	89 e5                	mov    %esp,%ebp
801016f2:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016f5:	8b 45 08             	mov    0x8(%ebp),%eax
801016f8:	8b 40 04             	mov    0x4(%eax),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	8d 50 02             	lea    0x2(%eax),%edx
80101701:	8b 45 08             	mov    0x8(%ebp),%eax
80101704:	8b 00                	mov    (%eax),%eax
80101706:	89 54 24 04          	mov    %edx,0x4(%esp)
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 94 ea ff ff       	call   801001a6 <bread>
80101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101718:	8d 50 18             	lea    0x18(%eax),%edx
8010171b:	8b 45 08             	mov    0x8(%ebp),%eax
8010171e:	8b 40 04             	mov    0x4(%eax),%eax
80101721:	83 e0 07             	and    $0x7,%eax
80101724:	c1 e0 06             	shl    $0x6,%eax
80101727:	01 d0                	add    %edx,%eax
80101729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010172c:	8b 45 08             	mov    0x8(%ebp),%eax
8010172f:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101736:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101739:	8b 45 08             	mov    0x8(%ebp),%eax
8010173c:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101740:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101743:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101747:	8b 45 08             	mov    0x8(%ebp),%eax
8010174a:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101751:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101755:	8b 45 08             	mov    0x8(%ebp),%eax
80101758:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101763:	8b 45 08             	mov    0x8(%ebp),%eax
80101766:	8b 50 18             	mov    0x18(%eax),%edx
80101769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176c:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176f:	8b 45 08             	mov    0x8(%ebp),%eax
80101772:	8d 50 1c             	lea    0x1c(%eax),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	83 c0 0c             	add    $0xc,%eax
8010177b:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101782:	00 
80101783:	89 54 24 04          	mov    %edx,0x4(%esp)
80101787:	89 04 24             	mov    %eax,(%esp)
8010178a:	e8 e1 3f 00 00       	call   80105770 <memmove>
  log_write(bp);
8010178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101792:	89 04 24             	mov    %eax,(%esp)
80101795:	e8 22 1c 00 00       	call   801033bc <log_write>
  brelse(bp);
8010179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179d:	89 04 24             	mov    %eax,(%esp)
801017a0:	e8 72 ea ff ff       	call   80100217 <brelse>
}
801017a5:	c9                   	leave  
801017a6:	c3                   	ret    

801017a7 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017a7:	55                   	push   %ebp
801017a8:	89 e5                	mov    %esp,%ebp
801017aa:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017ad:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801017b4:	e8 04 3c 00 00       	call   801053bd <acquire>

  // Is the inode already cached?
  empty = 0;
801017b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c0:	c7 45 f4 d4 f8 10 80 	movl   $0x8010f8d4,-0xc(%ebp)
801017c7:	eb 59                	jmp    80101822 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cc:	8b 40 08             	mov    0x8(%eax),%eax
801017cf:	85 c0                	test   %eax,%eax
801017d1:	7e 35                	jle    80101808 <iget+0x61>
801017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d6:	8b 00                	mov    (%eax),%eax
801017d8:	3b 45 08             	cmp    0x8(%ebp),%eax
801017db:	75 2b                	jne    80101808 <iget+0x61>
801017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e0:	8b 40 04             	mov    0x4(%eax),%eax
801017e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017e6:	75 20                	jne    80101808 <iget+0x61>
      ip->ref++;
801017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017eb:	8b 40 08             	mov    0x8(%eax),%eax
801017ee:	8d 50 01             	lea    0x1(%eax),%edx
801017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f4:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017f7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801017fe:	e8 64 3c 00 00       	call   80105467 <release>
      return ip;
80101803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101806:	eb 6f                	jmp    80101877 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101808:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010180c:	75 10                	jne    8010181e <iget+0x77>
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101811:	8b 40 08             	mov    0x8(%eax),%eax
80101814:	85 c0                	test   %eax,%eax
80101816:	75 06                	jne    8010181e <iget+0x77>
      empty = ip;
80101818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010181e:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101822:	81 7d f4 74 08 11 80 	cmpl   $0x80110874,-0xc(%ebp)
80101829:	72 9e                	jb     801017c9 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010182b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010182f:	75 0c                	jne    8010183d <iget+0x96>
    panic("iget: no inodes");
80101831:	c7 04 24 8b 8c 10 80 	movl   $0x80108c8b,(%esp)
80101838:	e8 fd ec ff ff       	call   8010053a <panic>

  ip = empty;
8010183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101846:	8b 55 08             	mov    0x8(%ebp),%edx
80101849:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101851:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101857:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101861:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101868:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010186f:	e8 f3 3b 00 00       	call   80105467 <release>

  return ip;
80101874:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101877:	c9                   	leave  
80101878:	c3                   	ret    

80101879 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101879:	55                   	push   %ebp
8010187a:	89 e5                	mov    %esp,%ebp
8010187c:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010187f:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101886:	e8 32 3b 00 00       	call   801053bd <acquire>
  ip->ref++;
8010188b:	8b 45 08             	mov    0x8(%ebp),%eax
8010188e:	8b 40 08             	mov    0x8(%eax),%eax
80101891:	8d 50 01             	lea    0x1(%eax),%edx
80101894:	8b 45 08             	mov    0x8(%ebp),%eax
80101897:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010189a:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018a1:	e8 c1 3b 00 00       	call   80105467 <release>
  return ip;
801018a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    

801018ab <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018ab:	55                   	push   %ebp
801018ac:	89 e5                	mov    %esp,%ebp
801018ae:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018b5:	74 0a                	je     801018c1 <ilock+0x16>
801018b7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ba:	8b 40 08             	mov    0x8(%eax),%eax
801018bd:	85 c0                	test   %eax,%eax
801018bf:	7f 0c                	jg     801018cd <ilock+0x22>
    panic("ilock");
801018c1:	c7 04 24 9b 8c 10 80 	movl   $0x80108c9b,(%esp)
801018c8:	e8 6d ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018cd:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018d4:	e8 e4 3a 00 00       	call   801053bd <acquire>
  while(ip->flags & I_BUSY)
801018d9:	eb 13                	jmp    801018ee <ilock+0x43>
    sleep(ip, &icache.lock);
801018db:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
801018e2:	80 
801018e3:	8b 45 08             	mov    0x8(%ebp),%eax
801018e6:	89 04 24             	mov    %eax,(%esp)
801018e9:	e8 1b 35 00 00       	call   80104e09 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ee:	8b 45 08             	mov    0x8(%ebp),%eax
801018f1:	8b 40 0c             	mov    0xc(%eax),%eax
801018f4:	83 e0 01             	and    $0x1,%eax
801018f7:	85 c0                	test   %eax,%eax
801018f9:	75 e0                	jne    801018db <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018fb:	8b 45 08             	mov    0x8(%ebp),%eax
801018fe:	8b 40 0c             	mov    0xc(%eax),%eax
80101901:	83 c8 01             	or     $0x1,%eax
80101904:	89 c2                	mov    %eax,%edx
80101906:	8b 45 08             	mov    0x8(%ebp),%eax
80101909:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010190c:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101913:	e8 4f 3b 00 00       	call   80105467 <release>

  if(!(ip->flags & I_VALID)){
80101918:	8b 45 08             	mov    0x8(%ebp),%eax
8010191b:	8b 40 0c             	mov    0xc(%eax),%eax
8010191e:	83 e0 02             	and    $0x2,%eax
80101921:	85 c0                	test   %eax,%eax
80101923:	0f 85 ce 00 00 00    	jne    801019f7 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	8b 40 04             	mov    0x4(%eax),%eax
8010192f:	c1 e8 03             	shr    $0x3,%eax
80101932:	8d 50 02             	lea    0x2(%eax),%edx
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	8b 00                	mov    (%eax),%eax
8010193a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010193e:	89 04 24             	mov    %eax,(%esp)
80101941:	e8 60 e8 ff ff       	call   801001a6 <bread>
80101946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194c:	8d 50 18             	lea    0x18(%eax),%edx
8010194f:	8b 45 08             	mov    0x8(%ebp),%eax
80101952:	8b 40 04             	mov    0x4(%eax),%eax
80101955:	83 e0 07             	and    $0x7,%eax
80101958:	c1 e0 06             	shl    $0x6,%eax
8010195b:	01 d0                	add    %edx,%eax
8010195d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101963:	0f b7 10             	movzwl (%eax),%edx
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010196d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101970:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101974:	8b 45 08             	mov    0x8(%ebp),%eax
80101977:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101982:	8b 45 08             	mov    0x8(%ebp),%eax
80101985:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101990:	8b 45 08             	mov    0x8(%ebp),%eax
80101993:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199a:	8b 50 08             	mov    0x8(%eax),%edx
8010199d:	8b 45 08             	mov    0x8(%ebp),%eax
801019a0:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a6:	8d 50 0c             	lea    0xc(%eax),%edx
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	83 c0 1c             	add    $0x1c,%eax
801019af:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019b6:	00 
801019b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801019bb:	89 04 24             	mov    %eax,(%esp)
801019be:	e8 ad 3d 00 00       	call   80105770 <memmove>
    brelse(bp);
801019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c6:	89 04 24             	mov    %eax,(%esp)
801019c9:	e8 49 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019ce:	8b 45 08             	mov    0x8(%ebp),%eax
801019d1:	8b 40 0c             	mov    0xc(%eax),%eax
801019d4:	83 c8 02             	or     $0x2,%eax
801019d7:	89 c2                	mov    %eax,%edx
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019df:	8b 45 08             	mov    0x8(%ebp),%eax
801019e2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019e6:	66 85 c0             	test   %ax,%ax
801019e9:	75 0c                	jne    801019f7 <ilock+0x14c>
      panic("ilock: no type");
801019eb:	c7 04 24 a1 8c 10 80 	movl   $0x80108ca1,(%esp)
801019f2:	e8 43 eb ff ff       	call   8010053a <panic>
  }
}
801019f7:	c9                   	leave  
801019f8:	c3                   	ret    

801019f9 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019f9:	55                   	push   %ebp
801019fa:	89 e5                	mov    %esp,%ebp
801019fc:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a03:	74 17                	je     80101a1c <iunlock+0x23>
80101a05:	8b 45 08             	mov    0x8(%ebp),%eax
80101a08:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0b:	83 e0 01             	and    $0x1,%eax
80101a0e:	85 c0                	test   %eax,%eax
80101a10:	74 0a                	je     80101a1c <iunlock+0x23>
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	8b 40 08             	mov    0x8(%eax),%eax
80101a18:	85 c0                	test   %eax,%eax
80101a1a:	7f 0c                	jg     80101a28 <iunlock+0x2f>
    panic("iunlock");
80101a1c:	c7 04 24 b0 8c 10 80 	movl   $0x80108cb0,(%esp)
80101a23:	e8 12 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a28:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a2f:	e8 89 39 00 00       	call   801053bd <acquire>
  ip->flags &= ~I_BUSY;
80101a34:	8b 45 08             	mov    0x8(%ebp),%eax
80101a37:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3a:	83 e0 fe             	and    $0xfffffffe,%eax
80101a3d:	89 c2                	mov    %eax,%edx
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a45:	8b 45 08             	mov    0x8(%ebp),%eax
80101a48:	89 04 24             	mov    %eax,(%esp)
80101a4b:	e8 fd 34 00 00       	call   80104f4d <wakeup>
  release(&icache.lock);
80101a50:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a57:	e8 0b 3a 00 00       	call   80105467 <release>
}
80101a5c:	c9                   	leave  
80101a5d:	c3                   	ret    

80101a5e <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a5e:	55                   	push   %ebp
80101a5f:	89 e5                	mov    %esp,%ebp
80101a61:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a64:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a6b:	e8 4d 39 00 00       	call   801053bd <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 40 08             	mov    0x8(%eax),%eax
80101a76:	83 f8 01             	cmp    $0x1,%eax
80101a79:	0f 85 93 00 00 00    	jne    80101b12 <iput+0xb4>
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	8b 40 0c             	mov    0xc(%eax),%eax
80101a85:	83 e0 02             	and    $0x2,%eax
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	0f 84 82 00 00 00    	je     80101b12 <iput+0xb4>
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a97:	66 85 c0             	test   %ax,%ax
80101a9a:	75 76                	jne    80101b12 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa2:	83 e0 01             	and    $0x1,%eax
80101aa5:	85 c0                	test   %eax,%eax
80101aa7:	74 0c                	je     80101ab5 <iput+0x57>
      panic("iput busy");
80101aa9:	c7 04 24 b8 8c 10 80 	movl   $0x80108cb8,(%esp)
80101ab0:	e8 85 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	8b 40 0c             	mov    0xc(%eax),%eax
80101abb:	83 c8 01             	or     $0x1,%eax
80101abe:	89 c2                	mov    %eax,%edx
80101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac3:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ac6:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101acd:	e8 95 39 00 00       	call   80105467 <release>
    itrunc(ip);
80101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad5:	89 04 24             	mov    %eax,(%esp)
80101ad8:	e8 7d 01 00 00       	call   80101c5a <itrunc>
    ip->type = 0;
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	89 04 24             	mov    %eax,(%esp)
80101aec:	e8 fe fb ff ff       	call   801016ef <iupdate>
    acquire(&icache.lock);
80101af1:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101af8:	e8 c0 38 00 00       	call   801053bd <acquire>
    ip->flags = 0;
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	89 04 24             	mov    %eax,(%esp)
80101b0d:	e8 3b 34 00 00       	call   80104f4d <wakeup>
  }
  ip->ref--;
80101b12:	8b 45 08             	mov    0x8(%ebp),%eax
80101b15:	8b 40 08             	mov    0x8(%eax),%eax
80101b18:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b21:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101b28:	e8 3a 39 00 00       	call   80105467 <release>
}
80101b2d:	c9                   	leave  
80101b2e:	c3                   	ret    

80101b2f <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b2f:	55                   	push   %ebp
80101b30:	89 e5                	mov    %esp,%ebp
80101b32:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	89 04 24             	mov    %eax,(%esp)
80101b3b:	e8 b9 fe ff ff       	call   801019f9 <iunlock>
  iput(ip);
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	89 04 24             	mov    %eax,(%esp)
80101b46:	e8 13 ff ff ff       	call   80101a5e <iput>
}
80101b4b:	c9                   	leave  
80101b4c:	c3                   	ret    

80101b4d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b4d:	55                   	push   %ebp
80101b4e:	89 e5                	mov    %esp,%ebp
80101b50:	53                   	push   %ebx
80101b51:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b54:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b58:	77 3e                	ja     80101b98 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b60:	83 c2 04             	add    $0x4,%edx
80101b63:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b6e:	75 20                	jne    80101b90 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	8b 00                	mov    (%eax),%eax
80101b75:	89 04 24             	mov    %eax,(%esp)
80101b78:	e8 5b f8 ff ff       	call   801013d8 <balloc>
80101b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b80:	8b 45 08             	mov    0x8(%ebp),%eax
80101b83:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b86:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b8c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b93:	e9 bc 00 00 00       	jmp    80101c54 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b98:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b9c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ba0:	0f 87 a2 00 00 00    	ja     80101c48 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bb3:	75 19                	jne    80101bce <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	8b 00                	mov    (%eax),%eax
80101bba:	89 04 24             	mov    %eax,(%esp)
80101bbd:	e8 16 f8 ff ff       	call   801013d8 <balloc>
80101bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bcb:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	8b 00                	mov    (%eax),%eax
80101bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bd6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bda:	89 04 24             	mov    %eax,(%esp)
80101bdd:	e8 c4 e5 ff ff       	call   801001a6 <bread>
80101be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be8:	83 c0 18             	add    $0x18,%eax
80101beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bf1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bfb:	01 d0                	add    %edx,%eax
80101bfd:	8b 00                	mov    (%eax),%eax
80101bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c06:	75 30                	jne    80101c38 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c15:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c18:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1b:	8b 00                	mov    (%eax),%eax
80101c1d:	89 04 24             	mov    %eax,(%esp)
80101c20:	e8 b3 f7 ff ff       	call   801013d8 <balloc>
80101c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2b:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c30:	89 04 24             	mov    %eax,(%esp)
80101c33:	e8 84 17 00 00       	call   801033bc <log_write>
    }
    brelse(bp);
80101c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c3b:	89 04 24             	mov    %eax,(%esp)
80101c3e:	e8 d4 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c46:	eb 0c                	jmp    80101c54 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c48:	c7 04 24 c2 8c 10 80 	movl   $0x80108cc2,(%esp)
80101c4f:	e8 e6 e8 ff ff       	call   8010053a <panic>
}
80101c54:	83 c4 24             	add    $0x24,%esp
80101c57:	5b                   	pop    %ebx
80101c58:	5d                   	pop    %ebp
80101c59:	c3                   	ret    

80101c5a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c5a:	55                   	push   %ebp
80101c5b:	89 e5                	mov    %esp,%ebp
80101c5d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c67:	eb 44                	jmp    80101cad <itrunc+0x53>
    if(ip->addrs[i]){
80101c69:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6f:	83 c2 04             	add    $0x4,%edx
80101c72:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c76:	85 c0                	test   %eax,%eax
80101c78:	74 2f                	je     80101ca9 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c80:	83 c2 04             	add    $0x4,%edx
80101c83:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c87:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8a:	8b 00                	mov    (%eax),%eax
80101c8c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c90:	89 04 24             	mov    %eax,(%esp)
80101c93:	e8 8e f8 ff ff       	call   80101526 <bfree>
      ip->addrs[i] = 0;
80101c98:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c9e:	83 c2 04             	add    $0x4,%edx
80101ca1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ca8:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ca9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101cad:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cb1:	7e b6                	jle    80101c69 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cb9:	85 c0                	test   %eax,%eax
80101cbb:	0f 84 9b 00 00 00    	je     80101d5c <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc4:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cca:	8b 00                	mov    (%eax),%eax
80101ccc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cd0:	89 04 24             	mov    %eax,(%esp)
80101cd3:	e8 ce e4 ff ff       	call   801001a6 <bread>
80101cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cde:	83 c0 18             	add    $0x18,%eax
80101ce1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ce4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ceb:	eb 3b                	jmp    80101d28 <itrunc+0xce>
      if(a[j])
80101ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cf0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cfa:	01 d0                	add    %edx,%eax
80101cfc:	8b 00                	mov    (%eax),%eax
80101cfe:	85 c0                	test   %eax,%eax
80101d00:	74 22                	je     80101d24 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d0f:	01 d0                	add    %edx,%eax
80101d11:	8b 10                	mov    (%eax),%edx
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	8b 00                	mov    (%eax),%eax
80101d18:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d1c:	89 04 24             	mov    %eax,(%esp)
80101d1f:	e8 02 f8 ff ff       	call   80101526 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d24:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2b:	83 f8 7f             	cmp    $0x7f,%eax
80101d2e:	76 bd                	jbe    80101ced <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d33:	89 04 24             	mov    %eax,(%esp)
80101d36:	e8 dc e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3e:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d41:	8b 45 08             	mov    0x8(%ebp),%eax
80101d44:	8b 00                	mov    (%eax),%eax
80101d46:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d4a:	89 04 24             	mov    %eax,(%esp)
80101d4d:	e8 d4 f7 ff ff       	call   80101526 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	89 04 24             	mov    %eax,(%esp)
80101d6c:	e8 7e f9 ff ff       	call   801016ef <iupdate>
}
80101d71:	c9                   	leave  
80101d72:	c3                   	ret    

80101d73 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d73:	55                   	push   %ebp
80101d74:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d76:	8b 45 08             	mov    0x8(%ebp),%eax
80101d79:	8b 00                	mov    (%eax),%eax
80101d7b:	89 c2                	mov    %eax,%edx
80101d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d80:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 50 04             	mov    0x4(%eax),%edx
80101d89:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d92:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da6:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 50 18             	mov    0x18(%eax),%edx
80101db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db3:	89 50 10             	mov    %edx,0x10(%eax)
}
80101db6:	5d                   	pop    %ebp
80101db7:	c3                   	ret    

80101db8 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101db8:	55                   	push   %ebp
80101db9:	89 e5                	mov    %esp,%ebp
80101dbb:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101dc5:	66 83 f8 03          	cmp    $0x3,%ax
80101dc9:	75 60                	jne    80101e2b <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd2:	66 85 c0             	test   %ax,%ax
80101dd5:	78 20                	js     80101df7 <readi+0x3f>
80101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dda:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dde:	66 83 f8 09          	cmp    $0x9,%ax
80101de2:	7f 13                	jg     80101df7 <readi+0x3f>
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101deb:	98                   	cwtl   
80101dec:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101df3:	85 c0                	test   %eax,%eax
80101df5:	75 0a                	jne    80101e01 <readi+0x49>
      return -1;
80101df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dfc:	e9 19 01 00 00       	jmp    80101f1a <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e01:	8b 45 08             	mov    0x8(%ebp),%eax
80101e04:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e08:	98                   	cwtl   
80101e09:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101e10:	8b 55 14             	mov    0x14(%ebp),%edx
80101e13:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e17:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e1a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e21:	89 14 24             	mov    %edx,(%esp)
80101e24:	ff d0                	call   *%eax
80101e26:	e9 ef 00 00 00       	jmp    80101f1a <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2e:	8b 40 18             	mov    0x18(%eax),%eax
80101e31:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e34:	72 0d                	jb     80101e43 <readi+0x8b>
80101e36:	8b 45 14             	mov    0x14(%ebp),%eax
80101e39:	8b 55 10             	mov    0x10(%ebp),%edx
80101e3c:	01 d0                	add    %edx,%eax
80101e3e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e41:	73 0a                	jae    80101e4d <readi+0x95>
    return -1;
80101e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e48:	e9 cd 00 00 00       	jmp    80101f1a <readi+0x162>
  if(off + n > ip->size)
80101e4d:	8b 45 14             	mov    0x14(%ebp),%eax
80101e50:	8b 55 10             	mov    0x10(%ebp),%edx
80101e53:	01 c2                	add    %eax,%edx
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	8b 40 18             	mov    0x18(%eax),%eax
80101e5b:	39 c2                	cmp    %eax,%edx
80101e5d:	76 0c                	jbe    80101e6b <readi+0xb3>
    n = ip->size - off;
80101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e62:	8b 40 18             	mov    0x18(%eax),%eax
80101e65:	2b 45 10             	sub    0x10(%ebp),%eax
80101e68:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e72:	e9 94 00 00 00       	jmp    80101f0b <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e77:	8b 45 10             	mov    0x10(%ebp),%eax
80101e7a:	c1 e8 09             	shr    $0x9,%eax
80101e7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e81:	8b 45 08             	mov    0x8(%ebp),%eax
80101e84:	89 04 24             	mov    %eax,(%esp)
80101e87:	e8 c1 fc ff ff       	call   80101b4d <bmap>
80101e8c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8f:	8b 12                	mov    (%edx),%edx
80101e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e95:	89 14 24             	mov    %edx,(%esp)
80101e98:	e8 09 e3 ff ff       	call   801001a6 <bread>
80101e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ea3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ea8:	89 c2                	mov    %eax,%edx
80101eaa:	b8 00 02 00 00       	mov    $0x200,%eax
80101eaf:	29 d0                	sub    %edx,%eax
80101eb1:	89 c2                	mov    %eax,%edx
80101eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101eb9:	29 c1                	sub    %eax,%ecx
80101ebb:	89 c8                	mov    %ecx,%eax
80101ebd:	39 c2                	cmp    %eax,%edx
80101ebf:	0f 46 c2             	cmovbe %edx,%eax
80101ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ec5:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec8:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ecd:	8d 50 10             	lea    0x10(%eax),%edx
80101ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ed3:	01 d0                	add    %edx,%eax
80101ed5:	8d 50 08             	lea    0x8(%eax),%edx
80101ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101edb:	89 44 24 08          	mov    %eax,0x8(%esp)
80101edf:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 82 38 00 00       	call   80105770 <memmove>
    brelse(bp);
80101eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef1:	89 04 24             	mov    %eax,(%esp)
80101ef4:	e8 1e e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101efc:	01 45 f4             	add    %eax,-0xc(%ebp)
80101eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f02:	01 45 10             	add    %eax,0x10(%ebp)
80101f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f08:	01 45 0c             	add    %eax,0xc(%ebp)
80101f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f0e:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f11:	0f 82 60 ff ff ff    	jb     80101e77 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f17:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f1a:	c9                   	leave  
80101f1b:	c3                   	ret    

80101f1c <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f1c:	55                   	push   %ebp
80101f1d:	89 e5                	mov    %esp,%ebp
80101f1f:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f22:	8b 45 08             	mov    0x8(%ebp),%eax
80101f25:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f29:	66 83 f8 03          	cmp    $0x3,%ax
80101f2d:	75 60                	jne    80101f8f <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f32:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f36:	66 85 c0             	test   %ax,%ax
80101f39:	78 20                	js     80101f5b <writei+0x3f>
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f42:	66 83 f8 09          	cmp    $0x9,%ax
80101f46:	7f 13                	jg     80101f5b <writei+0x3f>
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4f:	98                   	cwtl   
80101f50:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f57:	85 c0                	test   %eax,%eax
80101f59:	75 0a                	jne    80101f65 <writei+0x49>
      return -1;
80101f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f60:	e9 44 01 00 00       	jmp    801020a9 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f65:	8b 45 08             	mov    0x8(%ebp),%eax
80101f68:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f6c:	98                   	cwtl   
80101f6d:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f74:	8b 55 14             	mov    0x14(%ebp),%edx
80101f77:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f82:	8b 55 08             	mov    0x8(%ebp),%edx
80101f85:	89 14 24             	mov    %edx,(%esp)
80101f88:	ff d0                	call   *%eax
80101f8a:	e9 1a 01 00 00       	jmp    801020a9 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f92:	8b 40 18             	mov    0x18(%eax),%eax
80101f95:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f98:	72 0d                	jb     80101fa7 <writei+0x8b>
80101f9a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f9d:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa0:	01 d0                	add    %edx,%eax
80101fa2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fa5:	73 0a                	jae    80101fb1 <writei+0x95>
    return -1;
80101fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fac:	e9 f8 00 00 00       	jmp    801020a9 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101fb1:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb4:	8b 55 10             	mov    0x10(%ebp),%edx
80101fb7:	01 d0                	add    %edx,%eax
80101fb9:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fbe:	76 0a                	jbe    80101fca <writei+0xae>
    return -1;
80101fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc5:	e9 df 00 00 00       	jmp    801020a9 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fd1:	e9 9f 00 00 00       	jmp    80102075 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd9:	c1 e8 09             	shr    $0x9,%eax
80101fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	89 04 24             	mov    %eax,(%esp)
80101fe6:	e8 62 fb ff ff       	call   80101b4d <bmap>
80101feb:	8b 55 08             	mov    0x8(%ebp),%edx
80101fee:	8b 12                	mov    (%edx),%edx
80101ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff4:	89 14 24             	mov    %edx,(%esp)
80101ff7:	e8 aa e1 ff ff       	call   801001a6 <bread>
80101ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fff:	8b 45 10             	mov    0x10(%ebp),%eax
80102002:	25 ff 01 00 00       	and    $0x1ff,%eax
80102007:	89 c2                	mov    %eax,%edx
80102009:	b8 00 02 00 00       	mov    $0x200,%eax
8010200e:	29 d0                	sub    %edx,%eax
80102010:	89 c2                	mov    %eax,%edx
80102012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102015:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102018:	29 c1                	sub    %eax,%ecx
8010201a:	89 c8                	mov    %ecx,%eax
8010201c:	39 c2                	cmp    %eax,%edx
8010201e:	0f 46 c2             	cmovbe %edx,%eax
80102021:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102024:	8b 45 10             	mov    0x10(%ebp),%eax
80102027:	25 ff 01 00 00       	and    $0x1ff,%eax
8010202c:	8d 50 10             	lea    0x10(%eax),%edx
8010202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102032:	01 d0                	add    %edx,%eax
80102034:	8d 50 08             	lea    0x8(%eax),%edx
80102037:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010203e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102041:	89 44 24 04          	mov    %eax,0x4(%esp)
80102045:	89 14 24             	mov    %edx,(%esp)
80102048:	e8 23 37 00 00       	call   80105770 <memmove>
    log_write(bp);
8010204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102050:	89 04 24             	mov    %eax,(%esp)
80102053:	e8 64 13 00 00       	call   801033bc <log_write>
    brelse(bp);
80102058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205b:	89 04 24             	mov    %eax,(%esp)
8010205e:	e8 b4 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102063:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102066:	01 45 f4             	add    %eax,-0xc(%ebp)
80102069:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206c:	01 45 10             	add    %eax,0x10(%ebp)
8010206f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102072:	01 45 0c             	add    %eax,0xc(%ebp)
80102075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102078:	3b 45 14             	cmp    0x14(%ebp),%eax
8010207b:	0f 82 55 ff ff ff    	jb     80101fd6 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102081:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102085:	74 1f                	je     801020a6 <writei+0x18a>
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	8b 40 18             	mov    0x18(%eax),%eax
8010208d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102090:	73 14                	jae    801020a6 <writei+0x18a>
    ip->size = off;
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	8b 55 10             	mov    0x10(%ebp),%edx
80102098:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010209b:	8b 45 08             	mov    0x8(%ebp),%eax
8010209e:	89 04 24             	mov    %eax,(%esp)
801020a1:	e8 49 f6 ff ff       	call   801016ef <iupdate>
  }
  return n;
801020a6:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020a9:	c9                   	leave  
801020aa:	c3                   	ret    

801020ab <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020ab:	55                   	push   %ebp
801020ac:	89 e5                	mov    %esp,%ebp
801020ae:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020b1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020b8:	00 
801020b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801020bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801020c0:	8b 45 08             	mov    0x8(%ebp),%eax
801020c3:	89 04 24             	mov    %eax,(%esp)
801020c6:	e8 48 37 00 00       	call   80105813 <strncmp>
}
801020cb:	c9                   	leave  
801020cc:	c3                   	ret    

801020cd <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020cd:	55                   	push   %ebp
801020ce:	89 e5                	mov    %esp,%ebp
801020d0:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020d3:	8b 45 08             	mov    0x8(%ebp),%eax
801020d6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020da:	66 83 f8 01          	cmp    $0x1,%ax
801020de:	74 0c                	je     801020ec <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020e0:	c7 04 24 d5 8c 10 80 	movl   $0x80108cd5,(%esp)
801020e7:	e8 4e e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020f3:	e9 88 00 00 00       	jmp    80102180 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020ff:	00 
80102100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102103:	89 44 24 08          	mov    %eax,0x8(%esp)
80102107:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010210a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010210e:	8b 45 08             	mov    0x8(%ebp),%eax
80102111:	89 04 24             	mov    %eax,(%esp)
80102114:	e8 9f fc ff ff       	call   80101db8 <readi>
80102119:	83 f8 10             	cmp    $0x10,%eax
8010211c:	74 0c                	je     8010212a <dirlookup+0x5d>
      panic("dirlink read");
8010211e:	c7 04 24 e7 8c 10 80 	movl   $0x80108ce7,(%esp)
80102125:	e8 10 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
8010212a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010212e:	66 85 c0             	test   %ax,%ax
80102131:	75 02                	jne    80102135 <dirlookup+0x68>
      continue;
80102133:	eb 47                	jmp    8010217c <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102135:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102138:	83 c0 02             	add    $0x2,%eax
8010213b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010213f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102142:	89 04 24             	mov    %eax,(%esp)
80102145:	e8 61 ff ff ff       	call   801020ab <namecmp>
8010214a:	85 c0                	test   %eax,%eax
8010214c:	75 2e                	jne    8010217c <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010214e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102152:	74 08                	je     8010215c <dirlookup+0x8f>
        *poff = off;
80102154:	8b 45 10             	mov    0x10(%ebp),%eax
80102157:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010215a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010215c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102160:	0f b7 c0             	movzwl %ax,%eax
80102163:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102166:	8b 45 08             	mov    0x8(%ebp),%eax
80102169:	8b 00                	mov    (%eax),%eax
8010216b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010216e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102172:	89 04 24             	mov    %eax,(%esp)
80102175:	e8 2d f6 ff ff       	call   801017a7 <iget>
8010217a:	eb 18                	jmp    80102194 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010217c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102180:	8b 45 08             	mov    0x8(%ebp),%eax
80102183:	8b 40 18             	mov    0x18(%eax),%eax
80102186:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102189:	0f 87 69 ff ff ff    	ja     801020f8 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010218f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102194:	c9                   	leave  
80102195:	c3                   	ret    

80102196 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102196:	55                   	push   %ebp
80102197:	89 e5                	mov    %esp,%ebp
80102199:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010219c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021a3:	00 
801021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801021a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801021ab:	8b 45 08             	mov    0x8(%ebp),%eax
801021ae:	89 04 24             	mov    %eax,(%esp)
801021b1:	e8 17 ff ff ff       	call   801020cd <dirlookup>
801021b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021bd:	74 15                	je     801021d4 <dirlink+0x3e>
    iput(ip);
801021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021c2:	89 04 24             	mov    %eax,(%esp)
801021c5:	e8 94 f8 ff ff       	call   80101a5e <iput>
    return -1;
801021ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021cf:	e9 b7 00 00 00       	jmp    8010228b <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021db:	eb 46                	jmp    80102223 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021e0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021e7:	00 
801021e8:	89 44 24 08          	mov    %eax,0x8(%esp)
801021ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f3:	8b 45 08             	mov    0x8(%ebp),%eax
801021f6:	89 04 24             	mov    %eax,(%esp)
801021f9:	e8 ba fb ff ff       	call   80101db8 <readi>
801021fe:	83 f8 10             	cmp    $0x10,%eax
80102201:	74 0c                	je     8010220f <dirlink+0x79>
      panic("dirlink read");
80102203:	c7 04 24 e7 8c 10 80 	movl   $0x80108ce7,(%esp)
8010220a:	e8 2b e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
8010220f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102213:	66 85 c0             	test   %ax,%ax
80102216:	75 02                	jne    8010221a <dirlink+0x84>
      break;
80102218:	eb 16                	jmp    80102230 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221d:	83 c0 10             	add    $0x10,%eax
80102220:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102223:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102226:	8b 45 08             	mov    0x8(%ebp),%eax
80102229:	8b 40 18             	mov    0x18(%eax),%eax
8010222c:	39 c2                	cmp    %eax,%edx
8010222e:	72 ad                	jb     801021dd <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102230:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102237:	00 
80102238:	8b 45 0c             	mov    0xc(%ebp),%eax
8010223b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010223f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102242:	83 c0 02             	add    $0x2,%eax
80102245:	89 04 24             	mov    %eax,(%esp)
80102248:	e8 1c 36 00 00       	call   80105869 <strncpy>
  de.inum = inum;
8010224d:	8b 45 10             	mov    0x10(%ebp),%eax
80102250:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102257:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010225e:	00 
8010225f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102263:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102266:	89 44 24 04          	mov    %eax,0x4(%esp)
8010226a:	8b 45 08             	mov    0x8(%ebp),%eax
8010226d:	89 04 24             	mov    %eax,(%esp)
80102270:	e8 a7 fc ff ff       	call   80101f1c <writei>
80102275:	83 f8 10             	cmp    $0x10,%eax
80102278:	74 0c                	je     80102286 <dirlink+0xf0>
    panic("dirlink");
8010227a:	c7 04 24 f4 8c 10 80 	movl   $0x80108cf4,(%esp)
80102281:	e8 b4 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102286:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010228b:	c9                   	leave  
8010228c:	c3                   	ret    

8010228d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010228d:	55                   	push   %ebp
8010228e:	89 e5                	mov    %esp,%ebp
80102290:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102293:	eb 04                	jmp    80102299 <skipelem+0xc>
    path++;
80102295:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
8010229c:	0f b6 00             	movzbl (%eax),%eax
8010229f:	3c 2f                	cmp    $0x2f,%al
801022a1:	74 f2                	je     80102295 <skipelem+0x8>
    path++;
  if(*path == 0)
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
801022a6:	0f b6 00             	movzbl (%eax),%eax
801022a9:	84 c0                	test   %al,%al
801022ab:	75 0a                	jne    801022b7 <skipelem+0x2a>
    return 0;
801022ad:	b8 00 00 00 00       	mov    $0x0,%eax
801022b2:	e9 86 00 00 00       	jmp    8010233d <skipelem+0xb0>
  s = path;
801022b7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022bd:	eb 04                	jmp    801022c3 <skipelem+0x36>
    path++;
801022bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	0f b6 00             	movzbl (%eax),%eax
801022c9:	3c 2f                	cmp    $0x2f,%al
801022cb:	74 0a                	je     801022d7 <skipelem+0x4a>
801022cd:	8b 45 08             	mov    0x8(%ebp),%eax
801022d0:	0f b6 00             	movzbl (%eax),%eax
801022d3:	84 c0                	test   %al,%al
801022d5:	75 e8                	jne    801022bf <skipelem+0x32>
    path++;
  len = path - s;
801022d7:	8b 55 08             	mov    0x8(%ebp),%edx
801022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022dd:	29 c2                	sub    %eax,%edx
801022df:	89 d0                	mov    %edx,%eax
801022e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022e4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022e8:	7e 1c                	jle    80102306 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022ea:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022f1:	00 
801022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801022fc:	89 04 24             	mov    %eax,(%esp)
801022ff:	e8 6c 34 00 00       	call   80105770 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102304:	eb 2a                	jmp    80102330 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102309:	89 44 24 08          	mov    %eax,0x8(%esp)
8010230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102310:	89 44 24 04          	mov    %eax,0x4(%esp)
80102314:	8b 45 0c             	mov    0xc(%ebp),%eax
80102317:	89 04 24             	mov    %eax,(%esp)
8010231a:	e8 51 34 00 00       	call   80105770 <memmove>
    name[len] = 0;
8010231f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102322:	8b 45 0c             	mov    0xc(%ebp),%eax
80102325:	01 d0                	add    %edx,%eax
80102327:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010232a:	eb 04                	jmp    80102330 <skipelem+0xa3>
    path++;
8010232c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102330:	8b 45 08             	mov    0x8(%ebp),%eax
80102333:	0f b6 00             	movzbl (%eax),%eax
80102336:	3c 2f                	cmp    $0x2f,%al
80102338:	74 f2                	je     8010232c <skipelem+0x9f>
    path++;
  return path;
8010233a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    

8010233f <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010233f:	55                   	push   %ebp
80102340:	89 e5                	mov    %esp,%ebp
80102342:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102345:	8b 45 08             	mov    0x8(%ebp),%eax
80102348:	0f b6 00             	movzbl (%eax),%eax
8010234b:	3c 2f                	cmp    $0x2f,%al
8010234d:	75 1c                	jne    8010236b <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010234f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102356:	00 
80102357:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010235e:	e8 44 f4 ff ff       	call   801017a7 <iget>
80102363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102366:	e9 af 00 00 00       	jmp    8010241a <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010236b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102371:	8b 40 68             	mov    0x68(%eax),%eax
80102374:	89 04 24             	mov    %eax,(%esp)
80102377:	e8 fd f4 ff ff       	call   80101879 <idup>
8010237c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010237f:	e9 96 00 00 00       	jmp    8010241a <namex+0xdb>
    ilock(ip);
80102384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102387:	89 04 24             	mov    %eax,(%esp)
8010238a:	e8 1c f5 ff ff       	call   801018ab <ilock>
    if(ip->type != T_DIR){
8010238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102392:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102396:	66 83 f8 01          	cmp    $0x1,%ax
8010239a:	74 15                	je     801023b1 <namex+0x72>
      iunlockput(ip);
8010239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239f:	89 04 24             	mov    %eax,(%esp)
801023a2:	e8 88 f7 ff ff       	call   80101b2f <iunlockput>
      return 0;
801023a7:	b8 00 00 00 00       	mov    $0x0,%eax
801023ac:	e9 a3 00 00 00       	jmp    80102454 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023b5:	74 1d                	je     801023d4 <namex+0x95>
801023b7:	8b 45 08             	mov    0x8(%ebp),%eax
801023ba:	0f b6 00             	movzbl (%eax),%eax
801023bd:	84 c0                	test   %al,%al
801023bf:	75 13                	jne    801023d4 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c4:	89 04 24             	mov    %eax,(%esp)
801023c7:	e8 2d f6 ff ff       	call   801019f9 <iunlock>
      return ip;
801023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cf:	e9 80 00 00 00       	jmp    80102454 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023db:	00 
801023dc:	8b 45 10             	mov    0x10(%ebp),%eax
801023df:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e6:	89 04 24             	mov    %eax,(%esp)
801023e9:	e8 df fc ff ff       	call   801020cd <dirlookup>
801023ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023f5:	75 12                	jne    80102409 <namex+0xca>
      iunlockput(ip);
801023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fa:	89 04 24             	mov    %eax,(%esp)
801023fd:	e8 2d f7 ff ff       	call   80101b2f <iunlockput>
      return 0;
80102402:	b8 00 00 00 00       	mov    $0x0,%eax
80102407:	eb 4b                	jmp    80102454 <namex+0x115>
    }
    iunlockput(ip);
80102409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240c:	89 04 24             	mov    %eax,(%esp)
8010240f:	e8 1b f7 ff ff       	call   80101b2f <iunlockput>
    ip = next;
80102414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010241a:	8b 45 10             	mov    0x10(%ebp),%eax
8010241d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	89 04 24             	mov    %eax,(%esp)
80102427:	e8 61 fe ff ff       	call   8010228d <skipelem>
8010242c:	89 45 08             	mov    %eax,0x8(%ebp)
8010242f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102433:	0f 85 4b ff ff ff    	jne    80102384 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010243d:	74 12                	je     80102451 <namex+0x112>
    iput(ip);
8010243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102442:	89 04 24             	mov    %eax,(%esp)
80102445:	e8 14 f6 ff ff       	call   80101a5e <iput>
    return 0;
8010244a:	b8 00 00 00 00       	mov    $0x0,%eax
8010244f:	eb 03                	jmp    80102454 <namex+0x115>
  }
  return ip;
80102451:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102454:	c9                   	leave  
80102455:	c3                   	ret    

80102456 <namei>:

struct inode*
namei(char *path)
{
80102456:	55                   	push   %ebp
80102457:	89 e5                	mov    %esp,%ebp
80102459:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010245c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010245f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102463:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010246a:	00 
8010246b:	8b 45 08             	mov    0x8(%ebp),%eax
8010246e:	89 04 24             	mov    %eax,(%esp)
80102471:	e8 c9 fe ff ff       	call   8010233f <namex>
}
80102476:	c9                   	leave  
80102477:	c3                   	ret    

80102478 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102478:	55                   	push   %ebp
80102479:	89 e5                	mov    %esp,%ebp
8010247b:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010247e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102481:	89 44 24 08          	mov    %eax,0x8(%esp)
80102485:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010248c:	00 
8010248d:	8b 45 08             	mov    0x8(%ebp),%eax
80102490:	89 04 24             	mov    %eax,(%esp)
80102493:	e8 a7 fe ff ff       	call   8010233f <namex>
}
80102498:	c9                   	leave  
80102499:	c3                   	ret    

8010249a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010249a:	55                   	push   %ebp
8010249b:	89 e5                	mov    %esp,%ebp
8010249d:	83 ec 14             	sub    $0x14,%esp
801024a0:	8b 45 08             	mov    0x8(%ebp),%eax
801024a3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024ab:	89 c2                	mov    %eax,%edx
801024ad:	ec                   	in     (%dx),%al
801024ae:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024b1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024b5:	c9                   	leave  
801024b6:	c3                   	ret    

801024b7 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024b7:	55                   	push   %ebp
801024b8:	89 e5                	mov    %esp,%ebp
801024ba:	57                   	push   %edi
801024bb:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024bc:	8b 55 08             	mov    0x8(%ebp),%edx
801024bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c2:	8b 45 10             	mov    0x10(%ebp),%eax
801024c5:	89 cb                	mov    %ecx,%ebx
801024c7:	89 df                	mov    %ebx,%edi
801024c9:	89 c1                	mov    %eax,%ecx
801024cb:	fc                   	cld    
801024cc:	f3 6d                	rep insl (%dx),%es:(%edi)
801024ce:	89 c8                	mov    %ecx,%eax
801024d0:	89 fb                	mov    %edi,%ebx
801024d2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024d5:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024d8:	5b                   	pop    %ebx
801024d9:	5f                   	pop    %edi
801024da:	5d                   	pop    %ebp
801024db:	c3                   	ret    

801024dc <outb>:

static inline void
outb(ushort port, uchar data)
{
801024dc:	55                   	push   %ebp
801024dd:	89 e5                	mov    %esp,%ebp
801024df:	83 ec 08             	sub    $0x8,%esp
801024e2:	8b 55 08             	mov    0x8(%ebp),%edx
801024e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801024e8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024ec:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ef:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024f3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024f7:	ee                   	out    %al,(%dx)
}
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	56                   	push   %esi
801024fe:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102505:	8b 45 10             	mov    0x10(%ebp),%eax
80102508:	89 cb                	mov    %ecx,%ebx
8010250a:	89 de                	mov    %ebx,%esi
8010250c:	89 c1                	mov    %eax,%ecx
8010250e:	fc                   	cld    
8010250f:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102511:	89 c8                	mov    %ecx,%eax
80102513:	89 f3                	mov    %esi,%ebx
80102515:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102518:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010251b:	5b                   	pop    %ebx
8010251c:	5e                   	pop    %esi
8010251d:	5d                   	pop    %ebp
8010251e:	c3                   	ret    

8010251f <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010251f:	55                   	push   %ebp
80102520:	89 e5                	mov    %esp,%ebp
80102522:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102525:	90                   	nop
80102526:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010252d:	e8 68 ff ff ff       	call   8010249a <inb>
80102532:	0f b6 c0             	movzbl %al,%eax
80102535:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102538:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010253b:	25 c0 00 00 00       	and    $0xc0,%eax
80102540:	83 f8 40             	cmp    $0x40,%eax
80102543:	75 e1                	jne    80102526 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102545:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102549:	74 11                	je     8010255c <idewait+0x3d>
8010254b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010254e:	83 e0 21             	and    $0x21,%eax
80102551:	85 c0                	test   %eax,%eax
80102553:	74 07                	je     8010255c <idewait+0x3d>
    return -1;
80102555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010255a:	eb 05                	jmp    80102561 <idewait+0x42>
  return 0;
8010255c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102561:	c9                   	leave  
80102562:	c3                   	ret    

80102563 <ideinit>:

void
ideinit(void)
{
80102563:	55                   	push   %ebp
80102564:	89 e5                	mov    %esp,%ebp
80102566:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102569:	c7 44 24 04 fc 8c 10 	movl   $0x80108cfc,0x4(%esp)
80102570:	80 
80102571:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102578:	e8 1f 2e 00 00       	call   8010539c <initlock>
  picenable(IRQ_IDE);
8010257d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102584:	e8 0f 16 00 00       	call   80103b98 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102589:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010258e:	83 e8 01             	sub    $0x1,%eax
80102591:	89 44 24 04          	mov    %eax,0x4(%esp)
80102595:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010259c:	e8 0c 04 00 00       	call   801029ad <ioapicenable>
  idewait(0);
801025a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025a8:	e8 72 ff ff ff       	call   8010251f <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025ad:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025b4:	00 
801025b5:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025bc:	e8 1b ff ff ff       	call   801024dc <outb>
  for(i=0; i<1000; i++){
801025c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025c8:	eb 20                	jmp    801025ea <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025ca:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025d1:	e8 c4 fe ff ff       	call   8010249a <inb>
801025d6:	84 c0                	test   %al,%al
801025d8:	74 0c                	je     801025e6 <ideinit+0x83>
      havedisk1 = 1;
801025da:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025e1:	00 00 00 
      break;
801025e4:	eb 0d                	jmp    801025f3 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ea:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025f1:	7e d7                	jle    801025ca <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025f3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025fa:	00 
801025fb:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102602:	e8 d5 fe ff ff       	call   801024dc <outb>
}
80102607:	c9                   	leave  
80102608:	c3                   	ret    

80102609 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102609:	55                   	push   %ebp
8010260a:	89 e5                	mov    %esp,%ebp
8010260c:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010260f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102613:	75 0c                	jne    80102621 <idestart+0x18>
    panic("idestart");
80102615:	c7 04 24 00 8d 10 80 	movl   $0x80108d00,(%esp)
8010261c:	e8 19 df ff ff       	call   8010053a <panic>

  idewait(0);
80102621:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102628:	e8 f2 fe ff ff       	call   8010251f <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010262d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102634:	00 
80102635:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010263c:	e8 9b fe ff ff       	call   801024dc <outb>
  outb(0x1f2, 1);  // number of sectors
80102641:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102648:	00 
80102649:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102650:	e8 87 fe ff ff       	call   801024dc <outb>
  outb(0x1f3, b->sector & 0xff);
80102655:	8b 45 08             	mov    0x8(%ebp),%eax
80102658:	8b 40 08             	mov    0x8(%eax),%eax
8010265b:	0f b6 c0             	movzbl %al,%eax
8010265e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102662:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102669:	e8 6e fe ff ff       	call   801024dc <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010266e:	8b 45 08             	mov    0x8(%ebp),%eax
80102671:	8b 40 08             	mov    0x8(%eax),%eax
80102674:	c1 e8 08             	shr    $0x8,%eax
80102677:	0f b6 c0             	movzbl %al,%eax
8010267a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010267e:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102685:	e8 52 fe ff ff       	call   801024dc <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
8010268d:	8b 40 08             	mov    0x8(%eax),%eax
80102690:	c1 e8 10             	shr    $0x10,%eax
80102693:	0f b6 c0             	movzbl %al,%eax
80102696:	89 44 24 04          	mov    %eax,0x4(%esp)
8010269a:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026a1:	e8 36 fe ff ff       	call   801024dc <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026a6:	8b 45 08             	mov    0x8(%ebp),%eax
801026a9:	8b 40 04             	mov    0x4(%eax),%eax
801026ac:	83 e0 01             	and    $0x1,%eax
801026af:	c1 e0 04             	shl    $0x4,%eax
801026b2:	89 c2                	mov    %eax,%edx
801026b4:	8b 45 08             	mov    0x8(%ebp),%eax
801026b7:	8b 40 08             	mov    0x8(%eax),%eax
801026ba:	c1 e8 18             	shr    $0x18,%eax
801026bd:	83 e0 0f             	and    $0xf,%eax
801026c0:	09 d0                	or     %edx,%eax
801026c2:	83 c8 e0             	or     $0xffffffe0,%eax
801026c5:	0f b6 c0             	movzbl %al,%eax
801026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cc:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026d3:	e8 04 fe ff ff       	call   801024dc <outb>
  if(b->flags & B_DIRTY){
801026d8:	8b 45 08             	mov    0x8(%ebp),%eax
801026db:	8b 00                	mov    (%eax),%eax
801026dd:	83 e0 04             	and    $0x4,%eax
801026e0:	85 c0                	test   %eax,%eax
801026e2:	74 34                	je     80102718 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026e4:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026eb:	00 
801026ec:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026f3:	e8 e4 fd ff ff       	call   801024dc <outb>
    outsl(0x1f0, b->data, 512/4);
801026f8:	8b 45 08             	mov    0x8(%ebp),%eax
801026fb:	83 c0 18             	add    $0x18,%eax
801026fe:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102705:	00 
80102706:	89 44 24 04          	mov    %eax,0x4(%esp)
8010270a:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102711:	e8 e4 fd ff ff       	call   801024fa <outsl>
80102716:	eb 14                	jmp    8010272c <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102718:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010271f:	00 
80102720:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102727:	e8 b0 fd ff ff       	call   801024dc <outb>
  }
}
8010272c:	c9                   	leave  
8010272d:	c3                   	ret    

8010272e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010272e:	55                   	push   %ebp
8010272f:	89 e5                	mov    %esp,%ebp
80102731:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102734:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010273b:	e8 7d 2c 00 00       	call   801053bd <acquire>
  if((b = idequeue) == 0){
80102740:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102745:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010274c:	75 11                	jne    8010275f <ideintr+0x31>
    release(&idelock);
8010274e:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102755:	e8 0d 2d 00 00       	call   80105467 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010275a:	e9 90 00 00 00       	jmp    801027ef <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102762:	8b 40 14             	mov    0x14(%eax),%eax
80102765:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276d:	8b 00                	mov    (%eax),%eax
8010276f:	83 e0 04             	and    $0x4,%eax
80102772:	85 c0                	test   %eax,%eax
80102774:	75 2e                	jne    801027a4 <ideintr+0x76>
80102776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010277d:	e8 9d fd ff ff       	call   8010251f <idewait>
80102782:	85 c0                	test   %eax,%eax
80102784:	78 1e                	js     801027a4 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102789:	83 c0 18             	add    $0x18,%eax
8010278c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102793:	00 
80102794:	89 44 24 04          	mov    %eax,0x4(%esp)
80102798:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010279f:	e8 13 fd ff ff       	call   801024b7 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a7:	8b 00                	mov    (%eax),%eax
801027a9:	83 c8 02             	or     $0x2,%eax
801027ac:	89 c2                	mov    %eax,%edx
801027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b1:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b6:	8b 00                	mov    (%eax),%eax
801027b8:	83 e0 fb             	and    $0xfffffffb,%eax
801027bb:	89 c2                	mov    %eax,%edx
801027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c0:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c5:	89 04 24             	mov    %eax,(%esp)
801027c8:	e8 80 27 00 00       	call   80104f4d <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027cd:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027d2:	85 c0                	test   %eax,%eax
801027d4:	74 0d                	je     801027e3 <ideintr+0xb5>
    idestart(idequeue);
801027d6:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027db:	89 04 24             	mov    %eax,(%esp)
801027de:	e8 26 fe ff ff       	call   80102609 <idestart>

  release(&idelock);
801027e3:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027ea:	e8 78 2c 00 00       	call   80105467 <release>
}
801027ef:	c9                   	leave  
801027f0:	c3                   	ret    

801027f1 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027f1:	55                   	push   %ebp
801027f2:	89 e5                	mov    %esp,%ebp
801027f4:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027f7:	8b 45 08             	mov    0x8(%ebp),%eax
801027fa:	8b 00                	mov    (%eax),%eax
801027fc:	83 e0 01             	and    $0x1,%eax
801027ff:	85 c0                	test   %eax,%eax
80102801:	75 0c                	jne    8010280f <iderw+0x1e>
    panic("iderw: buf not busy");
80102803:	c7 04 24 09 8d 10 80 	movl   $0x80108d09,(%esp)
8010280a:	e8 2b dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010280f:	8b 45 08             	mov    0x8(%ebp),%eax
80102812:	8b 00                	mov    (%eax),%eax
80102814:	83 e0 06             	and    $0x6,%eax
80102817:	83 f8 02             	cmp    $0x2,%eax
8010281a:	75 0c                	jne    80102828 <iderw+0x37>
    panic("iderw: nothing to do");
8010281c:	c7 04 24 1d 8d 10 80 	movl   $0x80108d1d,(%esp)
80102823:	e8 12 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
80102828:	8b 45 08             	mov    0x8(%ebp),%eax
8010282b:	8b 40 04             	mov    0x4(%eax),%eax
8010282e:	85 c0                	test   %eax,%eax
80102830:	74 15                	je     80102847 <iderw+0x56>
80102832:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102837:	85 c0                	test   %eax,%eax
80102839:	75 0c                	jne    80102847 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010283b:	c7 04 24 32 8d 10 80 	movl   $0x80108d32,(%esp)
80102842:	e8 f3 dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102847:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010284e:	e8 6a 2b 00 00       	call   801053bd <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102853:	8b 45 08             	mov    0x8(%ebp),%eax
80102856:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010285d:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102864:	eb 0b                	jmp    80102871 <iderw+0x80>
80102866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102869:	8b 00                	mov    (%eax),%eax
8010286b:	83 c0 14             	add    $0x14,%eax
8010286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102874:	8b 00                	mov    (%eax),%eax
80102876:	85 c0                	test   %eax,%eax
80102878:	75 ec                	jne    80102866 <iderw+0x75>
    ;
  *pp = b;
8010287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287d:	8b 55 08             	mov    0x8(%ebp),%edx
80102880:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102882:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102887:	3b 45 08             	cmp    0x8(%ebp),%eax
8010288a:	75 0d                	jne    80102899 <iderw+0xa8>
    idestart(b);
8010288c:	8b 45 08             	mov    0x8(%ebp),%eax
8010288f:	89 04 24             	mov    %eax,(%esp)
80102892:	e8 72 fd ff ff       	call   80102609 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102897:	eb 15                	jmp    801028ae <iderw+0xbd>
80102899:	eb 13                	jmp    801028ae <iderw+0xbd>
    sleep(b, &idelock);
8010289b:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
801028a2:	80 
801028a3:	8b 45 08             	mov    0x8(%ebp),%eax
801028a6:	89 04 24             	mov    %eax,(%esp)
801028a9:	e8 5b 25 00 00       	call   80104e09 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ae:	8b 45 08             	mov    0x8(%ebp),%eax
801028b1:	8b 00                	mov    (%eax),%eax
801028b3:	83 e0 06             	and    $0x6,%eax
801028b6:	83 f8 02             	cmp    $0x2,%eax
801028b9:	75 e0                	jne    8010289b <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
801028bb:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801028c2:	e8 a0 2b 00 00       	call   80105467 <release>
}
801028c7:	c9                   	leave  
801028c8:	c3                   	ret    

801028c9 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028c9:	55                   	push   %ebp
801028ca:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028cc:	a1 74 08 11 80       	mov    0x80110874,%eax
801028d1:	8b 55 08             	mov    0x8(%ebp),%edx
801028d4:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028d6:	a1 74 08 11 80       	mov    0x80110874,%eax
801028db:	8b 40 10             	mov    0x10(%eax),%eax
}
801028de:	5d                   	pop    %ebp
801028df:	c3                   	ret    

801028e0 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028e3:	a1 74 08 11 80       	mov    0x80110874,%eax
801028e8:	8b 55 08             	mov    0x8(%ebp),%edx
801028eb:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028ed:	a1 74 08 11 80       	mov    0x80110874,%eax
801028f2:	8b 55 0c             	mov    0xc(%ebp),%edx
801028f5:	89 50 10             	mov    %edx,0x10(%eax)
}
801028f8:	5d                   	pop    %ebp
801028f9:	c3                   	ret    

801028fa <ioapicinit>:

void
ioapicinit(void)
{
801028fa:	55                   	push   %ebp
801028fb:	89 e5                	mov    %esp,%ebp
801028fd:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102900:	a1 44 09 11 80       	mov    0x80110944,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	75 05                	jne    8010290e <ioapicinit+0x14>
    return;
80102909:	e9 9d 00 00 00       	jmp    801029ab <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
8010290e:	c7 05 74 08 11 80 00 	movl   $0xfec00000,0x80110874
80102915:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102918:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010291f:	e8 a5 ff ff ff       	call   801028c9 <ioapicread>
80102924:	c1 e8 10             	shr    $0x10,%eax
80102927:	25 ff 00 00 00       	and    $0xff,%eax
8010292c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
8010292f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102936:	e8 8e ff ff ff       	call   801028c9 <ioapicread>
8010293b:	c1 e8 18             	shr    $0x18,%eax
8010293e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102941:	0f b6 05 40 09 11 80 	movzbl 0x80110940,%eax
80102948:	0f b6 c0             	movzbl %al,%eax
8010294b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010294e:	74 0c                	je     8010295c <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102950:	c7 04 24 50 8d 10 80 	movl   $0x80108d50,(%esp)
80102957:	e8 44 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010295c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102963:	eb 3e                	jmp    801029a3 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102968:	83 c0 20             	add    $0x20,%eax
8010296b:	0d 00 00 01 00       	or     $0x10000,%eax
80102970:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102973:	83 c2 08             	add    $0x8,%edx
80102976:	01 d2                	add    %edx,%edx
80102978:	89 44 24 04          	mov    %eax,0x4(%esp)
8010297c:	89 14 24             	mov    %edx,(%esp)
8010297f:	e8 5c ff ff ff       	call   801028e0 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102987:	83 c0 08             	add    $0x8,%eax
8010298a:	01 c0                	add    %eax,%eax
8010298c:	83 c0 01             	add    $0x1,%eax
8010298f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102996:	00 
80102997:	89 04 24             	mov    %eax,(%esp)
8010299a:	e8 41 ff ff ff       	call   801028e0 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010299f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029a9:	7e ba                	jle    80102965 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029ab:	c9                   	leave  
801029ac:	c3                   	ret    

801029ad <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029ad:	55                   	push   %ebp
801029ae:	89 e5                	mov    %esp,%ebp
801029b0:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029b3:	a1 44 09 11 80       	mov    0x80110944,%eax
801029b8:	85 c0                	test   %eax,%eax
801029ba:	75 02                	jne    801029be <ioapicenable+0x11>
    return;
801029bc:	eb 37                	jmp    801029f5 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029be:	8b 45 08             	mov    0x8(%ebp),%eax
801029c1:	83 c0 20             	add    $0x20,%eax
801029c4:	8b 55 08             	mov    0x8(%ebp),%edx
801029c7:	83 c2 08             	add    $0x8,%edx
801029ca:	01 d2                	add    %edx,%edx
801029cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d0:	89 14 24             	mov    %edx,(%esp)
801029d3:	e8 08 ff ff ff       	call   801028e0 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029db:	c1 e0 18             	shl    $0x18,%eax
801029de:	8b 55 08             	mov    0x8(%ebp),%edx
801029e1:	83 c2 08             	add    $0x8,%edx
801029e4:	01 d2                	add    %edx,%edx
801029e6:	83 c2 01             	add    $0x1,%edx
801029e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ed:	89 14 24             	mov    %edx,(%esp)
801029f0:	e8 eb fe ff ff       	call   801028e0 <ioapicwrite>
}
801029f5:	c9                   	leave  
801029f6:	c3                   	ret    

801029f7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029f7:	55                   	push   %ebp
801029f8:	89 e5                	mov    %esp,%ebp
801029fa:	8b 45 08             	mov    0x8(%ebp),%eax
801029fd:	05 00 00 00 80       	add    $0x80000000,%eax
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    

80102a04 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a04:	55                   	push   %ebp
80102a05:	89 e5                	mov    %esp,%ebp
80102a07:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a0a:	c7 44 24 04 82 8d 10 	movl   $0x80108d82,0x4(%esp)
80102a11:	80 
80102a12:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102a19:	e8 7e 29 00 00       	call   8010539c <initlock>
  kmem.use_lock = 0;
80102a1e:	c7 05 b4 08 11 80 00 	movl   $0x0,0x801108b4
80102a25:	00 00 00 
  freerange(vstart, vend);
80102a28:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a32:	89 04 24             	mov    %eax,(%esp)
80102a35:	e8 26 00 00 00       	call   80102a60 <freerange>
}
80102a3a:	c9                   	leave  
80102a3b:	c3                   	ret    

80102a3c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a3c:	55                   	push   %ebp
80102a3d:	89 e5                	mov    %esp,%ebp
80102a3f:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a42:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a45:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a49:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4c:	89 04 24             	mov    %eax,(%esp)
80102a4f:	e8 0c 00 00 00       	call   80102a60 <freerange>
  kmem.use_lock = 1;
80102a54:	c7 05 b4 08 11 80 01 	movl   $0x1,0x801108b4
80102a5b:	00 00 00 
}
80102a5e:	c9                   	leave  
80102a5f:	c3                   	ret    

80102a60 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a66:	8b 45 08             	mov    0x8(%ebp),%eax
80102a69:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a76:	eb 12                	jmp    80102a8a <freerange+0x2a>
    kfree(p);
80102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7b:	89 04 24             	mov    %eax,(%esp)
80102a7e:	e8 16 00 00 00       	call   80102a99 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a83:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8d:	05 00 10 00 00       	add    $0x1000,%eax
80102a92:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a95:	76 e1                	jbe    80102a78 <freerange+0x18>
    kfree(p);
}
80102a97:	c9                   	leave  
80102a98:	c3                   	ret    

80102a99 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a99:	55                   	push   %ebp
80102a9a:	89 e5                	mov    %esp,%ebp
80102a9c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa2:	25 ff 0f 00 00       	and    $0xfff,%eax
80102aa7:	85 c0                	test   %eax,%eax
80102aa9:	75 1b                	jne    80102ac6 <kfree+0x2d>
80102aab:	81 7d 08 3c 39 11 80 	cmpl   $0x8011393c,0x8(%ebp)
80102ab2:	72 12                	jb     80102ac6 <kfree+0x2d>
80102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab7:	89 04 24             	mov    %eax,(%esp)
80102aba:	e8 38 ff ff ff       	call   801029f7 <v2p>
80102abf:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ac4:	76 0c                	jbe    80102ad2 <kfree+0x39>
    panic("kfree");
80102ac6:	c7 04 24 87 8d 10 80 	movl   $0x80108d87,(%esp)
80102acd:	e8 68 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ad2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ad9:	00 
80102ada:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ae1:	00 
80102ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae5:	89 04 24             	mov    %eax,(%esp)
80102ae8:	e8 b4 2b 00 00       	call   801056a1 <memset>

  if(kmem.use_lock)
80102aed:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102af2:	85 c0                	test   %eax,%eax
80102af4:	74 0c                	je     80102b02 <kfree+0x69>
    acquire(&kmem.lock);
80102af6:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102afd:	e8 bb 28 00 00       	call   801053bd <acquire>
  r = (struct run*)v;
80102b02:	8b 45 08             	mov    0x8(%ebp),%eax
80102b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b08:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b11:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b16:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102b1b:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b20:	85 c0                	test   %eax,%eax
80102b22:	74 0c                	je     80102b30 <kfree+0x97>
    release(&kmem.lock);
80102b24:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b2b:	e8 37 29 00 00       	call   80105467 <release>
}
80102b30:	c9                   	leave  
80102b31:	c3                   	ret    

80102b32 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b32:	55                   	push   %ebp
80102b33:	89 e5                	mov    %esp,%ebp
80102b35:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b38:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b3d:	85 c0                	test   %eax,%eax
80102b3f:	74 0c                	je     80102b4d <kalloc+0x1b>
    acquire(&kmem.lock);
80102b41:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b48:	e8 70 28 00 00       	call   801053bd <acquire>
  r = kmem.freelist;
80102b4d:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b59:	74 0a                	je     80102b65 <kalloc+0x33>
    kmem.freelist = r->next;
80102b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5e:	8b 00                	mov    (%eax),%eax
80102b60:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102b65:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b6a:	85 c0                	test   %eax,%eax
80102b6c:	74 0c                	je     80102b7a <kalloc+0x48>
    release(&kmem.lock);
80102b6e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b75:	e8 ed 28 00 00       	call   80105467 <release>
  return (char*)r;
80102b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    

80102b7f <kalloc2>:
////////////////////////////////////////////////////////
void*
kalloc2(void)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
80102b82:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b85:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b8a:	85 c0                	test   %eax,%eax
80102b8c:	74 0c                	je     80102b9a <kalloc2+0x1b>
    acquire(&kmem.lock);
80102b8e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b95:	e8 23 28 00 00       	call   801053bd <acquire>
  r = kmem.freelist;
80102b9a:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ba6:	74 0a                	je     80102bb2 <kalloc2+0x33>
    kmem.freelist = r->next;
80102ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bab:	8b 00                	mov    (%eax),%eax
80102bad:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102bb2:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	74 0c                	je     80102bc7 <kalloc2+0x48>
    release(&kmem.lock);
80102bbb:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102bc2:	e8 a0 28 00 00       	call   80105467 <release>
  return (char*)r;
80102bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bca:	c9                   	leave  
80102bcb:	c3                   	ret    

80102bcc <kfree2>:

void
kfree2(void *v)
{
80102bcc:	55                   	push   %ebp
80102bcd:	89 e5                	mov    %esp,%ebp
80102bcf:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || (char*)v < end || v2p(v) >= PHYSTOP)
80102bd2:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd5:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bda:	85 c0                	test   %eax,%eax
80102bdc:	75 1b                	jne    80102bf9 <kfree2+0x2d>
80102bde:	81 7d 08 3c 39 11 80 	cmpl   $0x8011393c,0x8(%ebp)
80102be5:	72 12                	jb     80102bf9 <kfree2+0x2d>
80102be7:	8b 45 08             	mov    0x8(%ebp),%eax
80102bea:	89 04 24             	mov    %eax,(%esp)
80102bed:	e8 05 fe ff ff       	call   801029f7 <v2p>
80102bf2:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bf7:	76 0c                	jbe    80102c05 <kfree2+0x39>
    panic("kfree");
80102bf9:	c7 04 24 87 8d 10 80 	movl   $0x80108d87,(%esp)
80102c00:	e8 35 d9 ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c05:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102c0c:	00 
80102c0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102c14:	00 
80102c15:	8b 45 08             	mov    0x8(%ebp),%eax
80102c18:	89 04 24             	mov    %eax,(%esp)
80102c1b:	e8 81 2a 00 00       	call   801056a1 <memset>

  if(kmem.use_lock)
80102c20:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102c25:	85 c0                	test   %eax,%eax
80102c27:	74 0c                	je     80102c35 <kfree2+0x69>
    acquire(&kmem.lock);
80102c29:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102c30:	e8 88 27 00 00       	call   801053bd <acquire>
  r = (struct run*)v;
80102c35:	8b 45 08             	mov    0x8(%ebp),%eax
80102c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c3b:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c44:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c49:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102c4e:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	74 0c                	je     80102c63 <kfree2+0x97>
    release(&kmem.lock);
80102c57:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102c5e:	e8 04 28 00 00       	call   80105467 <release>
80102c63:	c9                   	leave  
80102c64:	c3                   	ret    

80102c65 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c65:	55                   	push   %ebp
80102c66:	89 e5                	mov    %esp,%ebp
80102c68:	83 ec 14             	sub    $0x14,%esp
80102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c6e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c72:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c76:	89 c2                	mov    %eax,%edx
80102c78:	ec                   	in     (%dx),%al
80102c79:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c7c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c80:	c9                   	leave  
80102c81:	c3                   	ret    

80102c82 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c82:	55                   	push   %ebp
80102c83:	89 e5                	mov    %esp,%ebp
80102c85:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c88:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c8f:	e8 d1 ff ff ff       	call   80102c65 <inb>
80102c94:	0f b6 c0             	movzbl %al,%eax
80102c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9d:	83 e0 01             	and    $0x1,%eax
80102ca0:	85 c0                	test   %eax,%eax
80102ca2:	75 0a                	jne    80102cae <kbdgetc+0x2c>
    return -1;
80102ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ca9:	e9 25 01 00 00       	jmp    80102dd3 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102cae:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102cb5:	e8 ab ff ff ff       	call   80102c65 <inb>
80102cba:	0f b6 c0             	movzbl %al,%eax
80102cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cc0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cc7:	75 17                	jne    80102ce0 <kbdgetc+0x5e>
    shift |= E0ESC;
80102cc9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cce:	83 c8 40             	or     $0x40,%eax
80102cd1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102cd6:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdb:	e9 f3 00 00 00       	jmp    80102dd3 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce3:	25 80 00 00 00       	and    $0x80,%eax
80102ce8:	85 c0                	test   %eax,%eax
80102cea:	74 45                	je     80102d31 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cec:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cf1:	83 e0 40             	and    $0x40,%eax
80102cf4:	85 c0                	test   %eax,%eax
80102cf6:	75 08                	jne    80102d00 <kbdgetc+0x7e>
80102cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfb:	83 e0 7f             	and    $0x7f,%eax
80102cfe:	eb 03                	jmp    80102d03 <kbdgetc+0x81>
80102d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d09:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d0e:	0f b6 00             	movzbl (%eax),%eax
80102d11:	83 c8 40             	or     $0x40,%eax
80102d14:	0f b6 c0             	movzbl %al,%eax
80102d17:	f7 d0                	not    %eax
80102d19:	89 c2                	mov    %eax,%edx
80102d1b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d20:	21 d0                	and    %edx,%eax
80102d22:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d27:	b8 00 00 00 00       	mov    $0x0,%eax
80102d2c:	e9 a2 00 00 00       	jmp    80102dd3 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102d31:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d36:	83 e0 40             	and    $0x40,%eax
80102d39:	85 c0                	test   %eax,%eax
80102d3b:	74 14                	je     80102d51 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d3d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d44:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d49:	83 e0 bf             	and    $0xffffffbf,%eax
80102d4c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d54:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d59:	0f b6 00             	movzbl (%eax),%eax
80102d5c:	0f b6 d0             	movzbl %al,%edx
80102d5f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d64:	09 d0                	or     %edx,%eax
80102d66:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d6e:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d73:	0f b6 00             	movzbl (%eax),%eax
80102d76:	0f b6 d0             	movzbl %al,%edx
80102d79:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d7e:	31 d0                	xor    %edx,%eax
80102d80:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d85:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d8a:	83 e0 03             	and    $0x3,%eax
80102d8d:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d97:	01 d0                	add    %edx,%eax
80102d99:	0f b6 00             	movzbl (%eax),%eax
80102d9c:	0f b6 c0             	movzbl %al,%eax
80102d9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102da2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102da7:	83 e0 08             	and    $0x8,%eax
80102daa:	85 c0                	test   %eax,%eax
80102dac:	74 22                	je     80102dd0 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102dae:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102db2:	76 0c                	jbe    80102dc0 <kbdgetc+0x13e>
80102db4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102db8:	77 06                	ja     80102dc0 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102dba:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dbe:	eb 10                	jmp    80102dd0 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102dc0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102dc4:	76 0a                	jbe    80102dd0 <kbdgetc+0x14e>
80102dc6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dca:	77 04                	ja     80102dd0 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102dcc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dd3:	c9                   	leave  
80102dd4:	c3                   	ret    

80102dd5 <kbdintr>:

void
kbdintr(void)
{
80102dd5:	55                   	push   %ebp
80102dd6:	89 e5                	mov    %esp,%ebp
80102dd8:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ddb:	c7 04 24 82 2c 10 80 	movl   $0x80102c82,(%esp)
80102de2:	e8 c6 d9 ff ff       	call   801007ad <consoleintr>
}
80102de7:	c9                   	leave  
80102de8:	c3                   	ret    

80102de9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102de9:	55                   	push   %ebp
80102dea:	89 e5                	mov    %esp,%ebp
80102dec:	83 ec 08             	sub    $0x8,%esp
80102def:	8b 55 08             	mov    0x8(%ebp),%edx
80102df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102df5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102df9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e00:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e04:	ee                   	out    %al,(%dx)
}
80102e05:	c9                   	leave  
80102e06:	c3                   	ret    

80102e07 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e07:	55                   	push   %ebp
80102e08:	89 e5                	mov    %esp,%ebp
80102e0a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e0d:	9c                   	pushf  
80102e0e:	58                   	pop    %eax
80102e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e15:	c9                   	leave  
80102e16:	c3                   	ret    

80102e17 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e17:	55                   	push   %ebp
80102e18:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e1a:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e1f:	8b 55 08             	mov    0x8(%ebp),%edx
80102e22:	c1 e2 02             	shl    $0x2,%edx
80102e25:	01 c2                	add    %eax,%edx
80102e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e2a:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e2c:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e31:	83 c0 20             	add    $0x20,%eax
80102e34:	8b 00                	mov    (%eax),%eax
}
80102e36:	5d                   	pop    %ebp
80102e37:	c3                   	ret    

80102e38 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e38:	55                   	push   %ebp
80102e39:	89 e5                	mov    %esp,%ebp
80102e3b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102e3e:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e43:	85 c0                	test   %eax,%eax
80102e45:	75 05                	jne    80102e4c <lapicinit+0x14>
    return;
80102e47:	e9 43 01 00 00       	jmp    80102f8f <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e4c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e53:	00 
80102e54:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e5b:	e8 b7 ff ff ff       	call   80102e17 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e60:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e67:	00 
80102e68:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e6f:	e8 a3 ff ff ff       	call   80102e17 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e74:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e83:	e8 8f ff ff ff       	call   80102e17 <lapicw>
  lapicw(TICR, 10000000); 
80102e88:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e8f:	00 
80102e90:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e97:	e8 7b ff ff ff       	call   80102e17 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e9c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102ea3:	00 
80102ea4:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102eab:	e8 67 ff ff ff       	call   80102e17 <lapicw>
  lapicw(LINT1, MASKED);
80102eb0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eb7:	00 
80102eb8:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102ebf:	e8 53 ff ff ff       	call   80102e17 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ec4:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ec9:	83 c0 30             	add    $0x30,%eax
80102ecc:	8b 00                	mov    (%eax),%eax
80102ece:	c1 e8 10             	shr    $0x10,%eax
80102ed1:	0f b6 c0             	movzbl %al,%eax
80102ed4:	83 f8 03             	cmp    $0x3,%eax
80102ed7:	76 14                	jbe    80102eed <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102ed9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102ee0:	00 
80102ee1:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102ee8:	e8 2a ff ff ff       	call   80102e17 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102eed:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ef4:	00 
80102ef5:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102efc:	e8 16 ff ff ff       	call   80102e17 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f08:	00 
80102f09:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f10:	e8 02 ff ff ff       	call   80102e17 <lapicw>
  lapicw(ESR, 0);
80102f15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f1c:	00 
80102f1d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f24:	e8 ee fe ff ff       	call   80102e17 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f30:	00 
80102f31:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f38:	e8 da fe ff ff       	call   80102e17 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f44:	00 
80102f45:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f4c:	e8 c6 fe ff ff       	call   80102e17 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f51:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f58:	00 
80102f59:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f60:	e8 b2 fe ff ff       	call   80102e17 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f65:	90                   	nop
80102f66:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102f6b:	05 00 03 00 00       	add    $0x300,%eax
80102f70:	8b 00                	mov    (%eax),%eax
80102f72:	25 00 10 00 00       	and    $0x1000,%eax
80102f77:	85 c0                	test   %eax,%eax
80102f79:	75 eb                	jne    80102f66 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f82:	00 
80102f83:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f8a:	e8 88 fe ff ff       	call   80102e17 <lapicw>
}
80102f8f:	c9                   	leave  
80102f90:	c3                   	ret    

80102f91 <cpunum>:

int
cpunum(void)
{
80102f91:	55                   	push   %ebp
80102f92:	89 e5                	mov    %esp,%ebp
80102f94:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f97:	e8 6b fe ff ff       	call   80102e07 <readeflags>
80102f9c:	25 00 02 00 00       	and    $0x200,%eax
80102fa1:	85 c0                	test   %eax,%eax
80102fa3:	74 25                	je     80102fca <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102fa5:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102faa:	8d 50 01             	lea    0x1(%eax),%edx
80102fad:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102fb3:	85 c0                	test   %eax,%eax
80102fb5:	75 13                	jne    80102fca <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fb7:	8b 45 04             	mov    0x4(%ebp),%eax
80102fba:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fbe:	c7 04 24 90 8d 10 80 	movl   $0x80108d90,(%esp)
80102fc5:	e8 d6 d3 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102fca:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102fcf:	85 c0                	test   %eax,%eax
80102fd1:	74 0f                	je     80102fe2 <cpunum+0x51>
    return lapic[ID]>>24;
80102fd3:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102fd8:	83 c0 20             	add    $0x20,%eax
80102fdb:	8b 00                	mov    (%eax),%eax
80102fdd:	c1 e8 18             	shr    $0x18,%eax
80102fe0:	eb 05                	jmp    80102fe7 <cpunum+0x56>
  return 0;
80102fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fe7:	c9                   	leave  
80102fe8:	c3                   	ret    

80102fe9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fe9:	55                   	push   %ebp
80102fea:	89 e5                	mov    %esp,%ebp
80102fec:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102fef:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ff4:	85 c0                	test   %eax,%eax
80102ff6:	74 14                	je     8010300c <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ff8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fff:	00 
80103000:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103007:	e8 0b fe ff ff       	call   80102e17 <lapicw>
}
8010300c:	c9                   	leave  
8010300d:	c3                   	ret    

8010300e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010300e:	55                   	push   %ebp
8010300f:	89 e5                	mov    %esp,%ebp
}
80103011:	5d                   	pop    %ebp
80103012:	c3                   	ret    

80103013 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103013:	55                   	push   %ebp
80103014:	89 e5                	mov    %esp,%ebp
80103016:	83 ec 1c             	sub    $0x1c,%esp
80103019:	8b 45 08             	mov    0x8(%ebp),%eax
8010301c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
8010301f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103026:	00 
80103027:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010302e:	e8 b6 fd ff ff       	call   80102de9 <outb>
  outb(IO_RTC+1, 0x0A);
80103033:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010303a:	00 
8010303b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103042:	e8 a2 fd ff ff       	call   80102de9 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103047:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010304e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103051:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103056:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103059:	8d 50 02             	lea    0x2(%eax),%edx
8010305c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010305f:	c1 e8 04             	shr    $0x4,%eax
80103062:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103065:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103069:	c1 e0 18             	shl    $0x18,%eax
8010306c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103070:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103077:	e8 9b fd ff ff       	call   80102e17 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010307c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103083:	00 
80103084:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010308b:	e8 87 fd ff ff       	call   80102e17 <lapicw>
  microdelay(200);
80103090:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103097:	e8 72 ff ff ff       	call   8010300e <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010309c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801030a3:	00 
801030a4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030ab:	e8 67 fd ff ff       	call   80102e17 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030b0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801030b7:	e8 52 ff ff ff       	call   8010300e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030c3:	eb 40                	jmp    80103105 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
801030c5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030c9:	c1 e0 18             	shl    $0x18,%eax
801030cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801030d0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030d7:	e8 3b fd ff ff       	call   80102e17 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801030df:	c1 e8 0c             	shr    $0xc,%eax
801030e2:	80 cc 06             	or     $0x6,%ah
801030e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801030e9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030f0:	e8 22 fd ff ff       	call   80102e17 <lapicw>
    microdelay(200);
801030f5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030fc:	e8 0d ff ff ff       	call   8010300e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103101:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103105:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103109:	7e ba                	jle    801030c5 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010310b:	c9                   	leave  
8010310c:	c3                   	ret    

8010310d <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
8010310d:	55                   	push   %ebp
8010310e:	89 e5                	mov    %esp,%ebp
80103110:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103113:	c7 44 24 04 bc 8d 10 	movl   $0x80108dbc,0x4(%esp)
8010311a:	80 
8010311b:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103122:	e8 75 22 00 00       	call   8010539c <initlock>
  readsb(ROOTDEV, &sb);
80103127:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010312a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010312e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103135:	e8 07 e2 ff ff       	call   80101341 <readsb>
  log.start = sb.size - sb.nlog;
8010313a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103140:	29 c2                	sub    %eax,%edx
80103142:	89 d0                	mov    %edx,%eax
80103144:	a3 f4 08 11 80       	mov    %eax,0x801108f4
  log.size = sb.nlog;
80103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010314c:	a3 f8 08 11 80       	mov    %eax,0x801108f8
  log.dev = ROOTDEV;
80103151:	c7 05 00 09 11 80 01 	movl   $0x1,0x80110900
80103158:	00 00 00 
  recover_from_log();
8010315b:	e8 9a 01 00 00       	call   801032fa <recover_from_log>
}
80103160:	c9                   	leave  
80103161:	c3                   	ret    

80103162 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103162:	55                   	push   %ebp
80103163:	89 e5                	mov    %esp,%ebp
80103165:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010316f:	e9 8c 00 00 00       	jmp    80103200 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103174:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
8010317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317d:	01 d0                	add    %edx,%eax
8010317f:	83 c0 01             	add    $0x1,%eax
80103182:	89 c2                	mov    %eax,%edx
80103184:	a1 00 09 11 80       	mov    0x80110900,%eax
80103189:	89 54 24 04          	mov    %edx,0x4(%esp)
8010318d:	89 04 24             	mov    %eax,(%esp)
80103190:	e8 11 d0 ff ff       	call   801001a6 <bread>
80103195:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010319b:	83 c0 10             	add    $0x10,%eax
8010319e:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	a1 00 09 11 80       	mov    0x80110900,%eax
801031ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801031b0:	89 04 24             	mov    %eax,(%esp)
801031b3:	e8 ee cf ff ff       	call   801001a6 <bread>
801031b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031be:	8d 50 18             	lea    0x18(%eax),%edx
801031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c4:	83 c0 18             	add    $0x18,%eax
801031c7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801031ce:	00 
801031cf:	89 54 24 04          	mov    %edx,0x4(%esp)
801031d3:	89 04 24             	mov    %eax,(%esp)
801031d6:	e8 95 25 00 00       	call   80105770 <memmove>
    bwrite(dbuf);  // write dst to disk
801031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031de:	89 04 24             	mov    %eax,(%esp)
801031e1:	e8 f7 cf ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031e9:	89 04 24             	mov    %eax,(%esp)
801031ec:	e8 26 d0 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031f4:	89 04 24             	mov    %eax,(%esp)
801031f7:	e8 1b d0 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103200:	a1 04 09 11 80       	mov    0x80110904,%eax
80103205:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103208:	0f 8f 66 ff ff ff    	jg     80103174 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010320e:	c9                   	leave  
8010320f:	c3                   	ret    

80103210 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103216:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010321b:	89 c2                	mov    %eax,%edx
8010321d:	a1 00 09 11 80       	mov    0x80110900,%eax
80103222:	89 54 24 04          	mov    %edx,0x4(%esp)
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 78 cf ff ff       	call   801001a6 <bread>
8010322e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103231:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103234:	83 c0 18             	add    $0x18,%eax
80103237:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010323d:	8b 00                	mov    (%eax),%eax
8010323f:	a3 04 09 11 80       	mov    %eax,0x80110904
  for (i = 0; i < log.lh.n; i++) {
80103244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010324b:	eb 1b                	jmp    80103268 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010324d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103250:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103253:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103257:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010325a:	83 c2 10             	add    $0x10,%edx
8010325d:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103264:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103268:	a1 04 09 11 80       	mov    0x80110904,%eax
8010326d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103270:	7f db                	jg     8010324d <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103275:	89 04 24             	mov    %eax,(%esp)
80103278:	e8 9a cf ff ff       	call   80100217 <brelse>
}
8010327d:	c9                   	leave  
8010327e:	c3                   	ret    

8010327f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010327f:	55                   	push   %ebp
80103280:	89 e5                	mov    %esp,%ebp
80103282:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103285:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010328a:	89 c2                	mov    %eax,%edx
8010328c:	a1 00 09 11 80       	mov    0x80110900,%eax
80103291:	89 54 24 04          	mov    %edx,0x4(%esp)
80103295:	89 04 24             	mov    %eax,(%esp)
80103298:	e8 09 cf ff ff       	call   801001a6 <bread>
8010329d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801032a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032a3:	83 c0 18             	add    $0x18,%eax
801032a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801032a9:	8b 15 04 09 11 80    	mov    0x80110904,%edx
801032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032b2:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801032b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032bb:	eb 1b                	jmp    801032d8 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	83 c0 10             	add    $0x10,%eax
801032c3:	8b 0c 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%ecx
801032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032d0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032d8:	a1 04 09 11 80       	mov    0x80110904,%eax
801032dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032e0:	7f db                	jg     801032bd <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032e5:	89 04 24             	mov    %eax,(%esp)
801032e8:	e8 f0 ce ff ff       	call   801001dd <bwrite>
  brelse(buf);
801032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f0:	89 04 24             	mov    %eax,(%esp)
801032f3:	e8 1f cf ff ff       	call   80100217 <brelse>
}
801032f8:	c9                   	leave  
801032f9:	c3                   	ret    

801032fa <recover_from_log>:

static void
recover_from_log(void)
{
801032fa:	55                   	push   %ebp
801032fb:	89 e5                	mov    %esp,%ebp
801032fd:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103300:	e8 0b ff ff ff       	call   80103210 <read_head>
  install_trans(); // if committed, copy from log to disk
80103305:	e8 58 fe ff ff       	call   80103162 <install_trans>
  log.lh.n = 0;
8010330a:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103311:	00 00 00 
  write_head(); // clear the log
80103314:	e8 66 ff ff ff       	call   8010327f <write_head>
}
80103319:	c9                   	leave  
8010331a:	c3                   	ret    

8010331b <begin_trans>:

void
begin_trans(void)
{
8010331b:	55                   	push   %ebp
8010331c:	89 e5                	mov    %esp,%ebp
8010331e:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103321:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103328:	e8 90 20 00 00       	call   801053bd <acquire>
  while (log.busy) {
8010332d:	eb 14                	jmp    80103343 <begin_trans+0x28>
    sleep(&log, &log.lock);
8010332f:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
80103336:	80 
80103337:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010333e:	e8 c6 1a 00 00       	call   80104e09 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103343:	a1 fc 08 11 80       	mov    0x801108fc,%eax
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 e3                	jne    8010332f <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010334c:	c7 05 fc 08 11 80 01 	movl   $0x1,0x801108fc
80103353:	00 00 00 
  release(&log.lock);
80103356:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010335d:	e8 05 21 00 00       	call   80105467 <release>
}
80103362:	c9                   	leave  
80103363:	c3                   	ret    

80103364 <commit_trans>:

void
commit_trans(void)
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010336a:	a1 04 09 11 80       	mov    0x80110904,%eax
8010336f:	85 c0                	test   %eax,%eax
80103371:	7e 19                	jle    8010338c <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103373:	e8 07 ff ff ff       	call   8010327f <write_head>
    install_trans(); // Now install writes to home locations
80103378:	e8 e5 fd ff ff       	call   80103162 <install_trans>
    log.lh.n = 0; 
8010337d:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103384:	00 00 00 
    write_head();    // Erase the transaction from the log
80103387:	e8 f3 fe ff ff       	call   8010327f <write_head>
  }
  
  acquire(&log.lock);
8010338c:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103393:	e8 25 20 00 00       	call   801053bd <acquire>
  log.busy = 0;
80103398:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
8010339f:	00 00 00 
  wakeup(&log);
801033a2:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801033a9:	e8 9f 1b 00 00       	call   80104f4d <wakeup>
  release(&log.lock);
801033ae:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801033b5:	e8 ad 20 00 00       	call   80105467 <release>
}
801033ba:	c9                   	leave  
801033bb:	c3                   	ret    

801033bc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033bc:	55                   	push   %ebp
801033bd:	89 e5                	mov    %esp,%ebp
801033bf:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c2:	a1 04 09 11 80       	mov    0x80110904,%eax
801033c7:	83 f8 09             	cmp    $0x9,%eax
801033ca:	7f 12                	jg     801033de <log_write+0x22>
801033cc:	a1 04 09 11 80       	mov    0x80110904,%eax
801033d1:	8b 15 f8 08 11 80    	mov    0x801108f8,%edx
801033d7:	83 ea 01             	sub    $0x1,%edx
801033da:	39 d0                	cmp    %edx,%eax
801033dc:	7c 0c                	jl     801033ea <log_write+0x2e>
    panic("too big a transaction");
801033de:	c7 04 24 c0 8d 10 80 	movl   $0x80108dc0,(%esp)
801033e5:	e8 50 d1 ff ff       	call   8010053a <panic>
  if (!log.busy)
801033ea:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801033ef:	85 c0                	test   %eax,%eax
801033f1:	75 0c                	jne    801033ff <log_write+0x43>
    panic("write outside of trans");
801033f3:	c7 04 24 d6 8d 10 80 	movl   $0x80108dd6,(%esp)
801033fa:	e8 3b d1 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801033ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103406:	eb 1f                	jmp    80103427 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
80103408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010340b:	83 c0 10             	add    $0x10,%eax
8010340e:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
80103415:	89 c2                	mov    %eax,%edx
80103417:	8b 45 08             	mov    0x8(%ebp),%eax
8010341a:	8b 40 08             	mov    0x8(%eax),%eax
8010341d:	39 c2                	cmp    %eax,%edx
8010341f:	75 02                	jne    80103423 <log_write+0x67>
      break;
80103421:	eb 0e                	jmp    80103431 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103423:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103427:	a1 04 09 11 80       	mov    0x80110904,%eax
8010342c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010342f:	7f d7                	jg     80103408 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
80103431:	8b 45 08             	mov    0x8(%ebp),%eax
80103434:	8b 40 08             	mov    0x8(%eax),%eax
80103437:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010343a:	83 c2 10             	add    $0x10,%edx
8010343d:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103444:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
8010344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010344d:	01 d0                	add    %edx,%eax
8010344f:	83 c0 01             	add    $0x1,%eax
80103452:	89 c2                	mov    %eax,%edx
80103454:	8b 45 08             	mov    0x8(%ebp),%eax
80103457:	8b 40 04             	mov    0x4(%eax),%eax
8010345a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010345e:	89 04 24             	mov    %eax,(%esp)
80103461:	e8 40 cd ff ff       	call   801001a6 <bread>
80103466:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103469:	8b 45 08             	mov    0x8(%ebp),%eax
8010346c:	8d 50 18             	lea    0x18(%eax),%edx
8010346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103472:	83 c0 18             	add    $0x18,%eax
80103475:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010347c:	00 
8010347d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103481:	89 04 24             	mov    %eax,(%esp)
80103484:	e8 e7 22 00 00       	call   80105770 <memmove>
  bwrite(lbuf);
80103489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348c:	89 04 24             	mov    %eax,(%esp)
8010348f:	e8 49 cd ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103494:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103497:	89 04 24             	mov    %eax,(%esp)
8010349a:	e8 78 cd ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010349f:	a1 04 09 11 80       	mov    0x80110904,%eax
801034a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034a7:	75 0d                	jne    801034b6 <log_write+0xfa>
    log.lh.n++;
801034a9:	a1 04 09 11 80       	mov    0x80110904,%eax
801034ae:	83 c0 01             	add    $0x1,%eax
801034b1:	a3 04 09 11 80       	mov    %eax,0x80110904
  b->flags |= B_DIRTY; // XXX prevent eviction
801034b6:	8b 45 08             	mov    0x8(%ebp),%eax
801034b9:	8b 00                	mov    (%eax),%eax
801034bb:	83 c8 04             	or     $0x4,%eax
801034be:	89 c2                	mov    %eax,%edx
801034c0:	8b 45 08             	mov    0x8(%ebp),%eax
801034c3:	89 10                	mov    %edx,(%eax)
}
801034c5:	c9                   	leave  
801034c6:	c3                   	ret    

801034c7 <v2p>:
801034c7:	55                   	push   %ebp
801034c8:	89 e5                	mov    %esp,%ebp
801034ca:	8b 45 08             	mov    0x8(%ebp),%eax
801034cd:	05 00 00 00 80       	add    $0x80000000,%eax
801034d2:	5d                   	pop    %ebp
801034d3:	c3                   	ret    

801034d4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801034d4:	55                   	push   %ebp
801034d5:	89 e5                	mov    %esp,%ebp
801034d7:	8b 45 08             	mov    0x8(%ebp),%eax
801034da:	05 00 00 00 80       	add    $0x80000000,%eax
801034df:	5d                   	pop    %ebp
801034e0:	c3                   	ret    

801034e1 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801034e1:	55                   	push   %ebp
801034e2:	89 e5                	mov    %esp,%ebp
801034e4:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034e7:	8b 55 08             	mov    0x8(%ebp),%edx
801034ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801034ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
801034f0:	f0 87 02             	lock xchg %eax,(%edx)
801034f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801034f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801034f9:	c9                   	leave  
801034fa:	c3                   	ret    

801034fb <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801034fb:	55                   	push   %ebp
801034fc:	89 e5                	mov    %esp,%ebp
801034fe:	83 e4 f0             	and    $0xfffffff0,%esp
80103501:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103504:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010350b:	80 
8010350c:	c7 04 24 3c 39 11 80 	movl   $0x8011393c,(%esp)
80103513:	e8 ec f4 ff ff       	call   80102a04 <kinit1>
  kvmalloc();      // kernel page table
80103518:	e8 a9 4e 00 00       	call   801083c6 <kvmalloc>
  mpinit();        // collect info about this machine
8010351d:	e8 46 04 00 00       	call   80103968 <mpinit>
  lapicinit();
80103522:	e8 11 f9 ff ff       	call   80102e38 <lapicinit>
  seginit();       // set up segments
80103527:	e8 2d 48 00 00       	call   80107d59 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010352c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103532:	0f b6 00             	movzbl (%eax),%eax
80103535:	0f b6 c0             	movzbl %al,%eax
80103538:	89 44 24 04          	mov    %eax,0x4(%esp)
8010353c:	c7 04 24 ed 8d 10 80 	movl   $0x80108ded,(%esp)
80103543:	e8 58 ce ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103548:	e8 79 06 00 00       	call   80103bc6 <picinit>
  ioapicinit();    // another interrupt controller
8010354d:	e8 a8 f3 ff ff       	call   801028fa <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103552:	e8 2a d5 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103557:	e8 4c 3b 00 00       	call   801070a8 <uartinit>
  pinit();         // process table
8010355c:	e8 0b 0c 00 00       	call   8010416c <pinit>
  tvinit();        // trap vectors
80103561:	e8 f4 36 00 00       	call   80106c5a <tvinit>
  binit();         // buffer cache
80103566:	e8 c9 ca ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010356b:	e8 ea d9 ff ff       	call   80100f5a <fileinit>
  iinit();         // inode cache
80103570:	e8 7f e0 ff ff       	call   801015f4 <iinit>
  ideinit();       // disk
80103575:	e8 e9 ef ff ff       	call   80102563 <ideinit>
  if(!ismp)
8010357a:	a1 44 09 11 80       	mov    0x80110944,%eax
8010357f:	85 c0                	test   %eax,%eax
80103581:	75 05                	jne    80103588 <main+0x8d>
    timerinit();   // uniprocessor timer
80103583:	e8 1d 36 00 00       	call   80106ba5 <timerinit>
  startothers();   // start other processors
80103588:	e8 7f 00 00 00       	call   8010360c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010358d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103594:	8e 
80103595:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010359c:	e8 9b f4 ff ff       	call   80102a3c <kinit2>
  userinit();      // first user process
801035a1:	e8 e4 0c 00 00       	call   8010428a <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801035a6:	e8 1a 00 00 00       	call   801035c5 <mpmain>

801035ab <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801035ab:	55                   	push   %ebp
801035ac:	89 e5                	mov    %esp,%ebp
801035ae:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801035b1:	e8 27 4e 00 00       	call   801083dd <switchkvm>
  seginit();
801035b6:	e8 9e 47 00 00       	call   80107d59 <seginit>
  lapicinit();
801035bb:	e8 78 f8 ff ff       	call   80102e38 <lapicinit>
  mpmain();
801035c0:	e8 00 00 00 00       	call   801035c5 <mpmain>

801035c5 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801035c5:	55                   	push   %ebp
801035c6:	89 e5                	mov    %esp,%ebp
801035c8:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801035cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035d1:	0f b6 00             	movzbl (%eax),%eax
801035d4:	0f b6 c0             	movzbl %al,%eax
801035d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801035db:	c7 04 24 04 8e 10 80 	movl   $0x80108e04,(%esp)
801035e2:	e8 b9 cd ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801035e7:	e8 e2 37 00 00       	call   80106dce <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801035ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035f2:	05 a8 00 00 00       	add    $0xa8,%eax
801035f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801035fe:	00 
801035ff:	89 04 24             	mov    %eax,(%esp)
80103602:	e8 da fe ff ff       	call   801034e1 <xchg>
  scheduler();     // start running processes
80103607:	e8 29 16 00 00       	call   80104c35 <scheduler>

8010360c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010360c:	55                   	push   %ebp
8010360d:	89 e5                	mov    %esp,%ebp
8010360f:	53                   	push   %ebx
80103610:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103613:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
8010361a:	e8 b5 fe ff ff       	call   801034d4 <p2v>
8010361f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103622:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103627:	89 44 24 08          	mov    %eax,0x8(%esp)
8010362b:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103632:	80 
80103633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103636:	89 04 24             	mov    %eax,(%esp)
80103639:	e8 32 21 00 00       	call   80105770 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010363e:	c7 45 f4 60 09 11 80 	movl   $0x80110960,-0xc(%ebp)
80103645:	e9 85 00 00 00       	jmp    801036cf <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010364a:	e8 42 f9 ff ff       	call   80102f91 <cpunum>
8010364f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103655:	05 60 09 11 80       	add    $0x80110960,%eax
8010365a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010365d:	75 02                	jne    80103661 <startothers+0x55>
      continue;
8010365f:	eb 67                	jmp    801036c8 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103661:	e8 cc f4 ff ff       	call   80102b32 <kalloc>
80103666:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103669:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010366c:	83 e8 04             	sub    $0x4,%eax
8010366f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103672:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103678:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367d:	83 e8 08             	sub    $0x8,%eax
80103680:	c7 00 ab 35 10 80    	movl   $0x801035ab,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103689:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010368c:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103693:	e8 2f fe ff ff       	call   801034c7 <v2p>
80103698:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010369a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010369d:	89 04 24             	mov    %eax,(%esp)
801036a0:	e8 22 fe ff ff       	call   801034c7 <v2p>
801036a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036a8:	0f b6 12             	movzbl (%edx),%edx
801036ab:	0f b6 d2             	movzbl %dl,%edx
801036ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801036b2:	89 14 24             	mov    %edx,(%esp)
801036b5:	e8 59 f9 ff ff       	call   80103013 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801036ba:	90                   	nop
801036bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036be:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	74 f3                	je     801036bb <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801036c8:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801036cf:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801036d4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801036da:	05 60 09 11 80       	add    $0x80110960,%eax
801036df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036e2:	0f 87 62 ff ff ff    	ja     8010364a <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801036e8:	83 c4 24             	add    $0x24,%esp
801036eb:	5b                   	pop    %ebx
801036ec:	5d                   	pop    %ebp
801036ed:	c3                   	ret    

801036ee <p2v>:
801036ee:	55                   	push   %ebp
801036ef:	89 e5                	mov    %esp,%ebp
801036f1:	8b 45 08             	mov    0x8(%ebp),%eax
801036f4:	05 00 00 00 80       	add    $0x80000000,%eax
801036f9:	5d                   	pop    %ebp
801036fa:	c3                   	ret    

801036fb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801036fb:	55                   	push   %ebp
801036fc:	89 e5                	mov    %esp,%ebp
801036fe:	83 ec 14             	sub    $0x14,%esp
80103701:	8b 45 08             	mov    0x8(%ebp),%eax
80103704:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103708:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010370c:	89 c2                	mov    %eax,%edx
8010370e:	ec                   	in     (%dx),%al
8010370f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103712:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103716:	c9                   	leave  
80103717:	c3                   	ret    

80103718 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103718:	55                   	push   %ebp
80103719:	89 e5                	mov    %esp,%ebp
8010371b:	83 ec 08             	sub    $0x8,%esp
8010371e:	8b 55 08             	mov    0x8(%ebp),%edx
80103721:	8b 45 0c             	mov    0xc(%ebp),%eax
80103724:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103728:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010372b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010372f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103733:	ee                   	out    %al,(%dx)
}
80103734:	c9                   	leave  
80103735:	c3                   	ret    

80103736 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103736:	55                   	push   %ebp
80103737:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103739:	a1 64 c6 10 80       	mov    0x8010c664,%eax
8010373e:	89 c2                	mov    %eax,%edx
80103740:	b8 60 09 11 80       	mov    $0x80110960,%eax
80103745:	29 c2                	sub    %eax,%edx
80103747:	89 d0                	mov    %edx,%eax
80103749:	c1 f8 02             	sar    $0x2,%eax
8010374c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103752:	5d                   	pop    %ebp
80103753:	c3                   	ret    

80103754 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103754:	55                   	push   %ebp
80103755:	89 e5                	mov    %esp,%ebp
80103757:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010375a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103761:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103768:	eb 15                	jmp    8010377f <sum+0x2b>
    sum += addr[i];
8010376a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010376d:	8b 45 08             	mov    0x8(%ebp),%eax
80103770:	01 d0                	add    %edx,%eax
80103772:	0f b6 00             	movzbl (%eax),%eax
80103775:	0f b6 c0             	movzbl %al,%eax
80103778:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
8010377b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010377f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103782:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103785:	7c e3                	jl     8010376a <sum+0x16>
    sum += addr[i];
  return sum;
80103787:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010378a:	c9                   	leave  
8010378b:	c3                   	ret    

8010378c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010378c:	55                   	push   %ebp
8010378d:	89 e5                	mov    %esp,%ebp
8010378f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103792:	8b 45 08             	mov    0x8(%ebp),%eax
80103795:	89 04 24             	mov    %eax,(%esp)
80103798:	e8 51 ff ff ff       	call   801036ee <p2v>
8010379d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801037a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a6:	01 d0                	add    %edx,%eax
801037a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801037ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b1:	eb 3f                	jmp    801037f2 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037b3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037ba:	00 
801037bb:	c7 44 24 04 18 8e 10 	movl   $0x80108e18,0x4(%esp)
801037c2:	80 
801037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c6:	89 04 24             	mov    %eax,(%esp)
801037c9:	e8 4a 1f 00 00       	call   80105718 <memcmp>
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 1c                	jne    801037ee <mpsearch1+0x62>
801037d2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801037d9:	00 
801037da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037dd:	89 04 24             	mov    %eax,(%esp)
801037e0:	e8 6f ff ff ff       	call   80103754 <sum>
801037e5:	84 c0                	test   %al,%al
801037e7:	75 05                	jne    801037ee <mpsearch1+0x62>
      return (struct mp*)p;
801037e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ec:	eb 11                	jmp    801037ff <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801037ee:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037f8:	72 b9                	jb     801037b3 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801037fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037ff:	c9                   	leave  
80103800:	c3                   	ret    

80103801 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103801:	55                   	push   %ebp
80103802:	89 e5                	mov    %esp,%ebp
80103804:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103807:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103811:	83 c0 0f             	add    $0xf,%eax
80103814:	0f b6 00             	movzbl (%eax),%eax
80103817:	0f b6 c0             	movzbl %al,%eax
8010381a:	c1 e0 08             	shl    $0x8,%eax
8010381d:	89 c2                	mov    %eax,%edx
8010381f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103822:	83 c0 0e             	add    $0xe,%eax
80103825:	0f b6 00             	movzbl (%eax),%eax
80103828:	0f b6 c0             	movzbl %al,%eax
8010382b:	09 d0                	or     %edx,%eax
8010382d:	c1 e0 04             	shl    $0x4,%eax
80103830:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103833:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103837:	74 21                	je     8010385a <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103839:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103840:	00 
80103841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103844:	89 04 24             	mov    %eax,(%esp)
80103847:	e8 40 ff ff ff       	call   8010378c <mpsearch1>
8010384c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010384f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103853:	74 50                	je     801038a5 <mpsearch+0xa4>
      return mp;
80103855:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103858:	eb 5f                	jmp    801038b9 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010385d:	83 c0 14             	add    $0x14,%eax
80103860:	0f b6 00             	movzbl (%eax),%eax
80103863:	0f b6 c0             	movzbl %al,%eax
80103866:	c1 e0 08             	shl    $0x8,%eax
80103869:	89 c2                	mov    %eax,%edx
8010386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010386e:	83 c0 13             	add    $0x13,%eax
80103871:	0f b6 00             	movzbl (%eax),%eax
80103874:	0f b6 c0             	movzbl %al,%eax
80103877:	09 d0                	or     %edx,%eax
80103879:	c1 e0 0a             	shl    $0xa,%eax
8010387c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103882:	2d 00 04 00 00       	sub    $0x400,%eax
80103887:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010388e:	00 
8010388f:	89 04 24             	mov    %eax,(%esp)
80103892:	e8 f5 fe ff ff       	call   8010378c <mpsearch1>
80103897:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010389a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010389e:	74 05                	je     801038a5 <mpsearch+0xa4>
      return mp;
801038a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038a3:	eb 14                	jmp    801038b9 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801038a5:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801038ac:	00 
801038ad:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801038b4:	e8 d3 fe ff ff       	call   8010378c <mpsearch1>
}
801038b9:	c9                   	leave  
801038ba:	c3                   	ret    

801038bb <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801038bb:	55                   	push   %ebp
801038bc:	89 e5                	mov    %esp,%ebp
801038be:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038c1:	e8 3b ff ff ff       	call   80103801 <mpsearch>
801038c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801038cd:	74 0a                	je     801038d9 <mpconfig+0x1e>
801038cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038d2:	8b 40 04             	mov    0x4(%eax),%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 0a                	jne    801038e3 <mpconfig+0x28>
    return 0;
801038d9:	b8 00 00 00 00       	mov    $0x0,%eax
801038de:	e9 83 00 00 00       	jmp    80103966 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801038e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e6:	8b 40 04             	mov    0x4(%eax),%eax
801038e9:	89 04 24             	mov    %eax,(%esp)
801038ec:	e8 fd fd ff ff       	call   801036ee <p2v>
801038f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038f4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801038fb:	00 
801038fc:	c7 44 24 04 1d 8e 10 	movl   $0x80108e1d,0x4(%esp)
80103903:	80 
80103904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103907:	89 04 24             	mov    %eax,(%esp)
8010390a:	e8 09 1e 00 00       	call   80105718 <memcmp>
8010390f:	85 c0                	test   %eax,%eax
80103911:	74 07                	je     8010391a <mpconfig+0x5f>
    return 0;
80103913:	b8 00 00 00 00       	mov    $0x0,%eax
80103918:	eb 4c                	jmp    80103966 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
8010391a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391d:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103921:	3c 01                	cmp    $0x1,%al
80103923:	74 12                	je     80103937 <mpconfig+0x7c>
80103925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103928:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010392c:	3c 04                	cmp    $0x4,%al
8010392e:	74 07                	je     80103937 <mpconfig+0x7c>
    return 0;
80103930:	b8 00 00 00 00       	mov    $0x0,%eax
80103935:	eb 2f                	jmp    80103966 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103937:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010393a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010393e:	0f b7 c0             	movzwl %ax,%eax
80103941:	89 44 24 04          	mov    %eax,0x4(%esp)
80103945:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103948:	89 04 24             	mov    %eax,(%esp)
8010394b:	e8 04 fe ff ff       	call   80103754 <sum>
80103950:	84 c0                	test   %al,%al
80103952:	74 07                	je     8010395b <mpconfig+0xa0>
    return 0;
80103954:	b8 00 00 00 00       	mov    $0x0,%eax
80103959:	eb 0b                	jmp    80103966 <mpconfig+0xab>
  *pmp = mp;
8010395b:	8b 45 08             	mov    0x8(%ebp),%eax
8010395e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103961:	89 10                	mov    %edx,(%eax)
  return conf;
80103963:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103966:	c9                   	leave  
80103967:	c3                   	ret    

80103968 <mpinit>:

void
mpinit(void)
{
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010396e:	c7 05 64 c6 10 80 60 	movl   $0x80110960,0x8010c664
80103975:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103978:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010397b:	89 04 24             	mov    %eax,(%esp)
8010397e:	e8 38 ff ff ff       	call   801038bb <mpconfig>
80103983:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010398a:	75 05                	jne    80103991 <mpinit+0x29>
    return;
8010398c:	e9 9c 01 00 00       	jmp    80103b2d <mpinit+0x1c5>
  ismp = 1;
80103991:	c7 05 44 09 11 80 01 	movl   $0x1,0x80110944
80103998:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010399b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010399e:	8b 40 24             	mov    0x24(%eax),%eax
801039a1:	a3 bc 08 11 80       	mov    %eax,0x801108bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a9:	83 c0 2c             	add    $0x2c,%eax
801039ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801039b6:	0f b7 d0             	movzwl %ax,%edx
801039b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039bc:	01 d0                	add    %edx,%eax
801039be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801039c1:	e9 f4 00 00 00       	jmp    80103aba <mpinit+0x152>
    switch(*p){
801039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c9:	0f b6 00             	movzbl (%eax),%eax
801039cc:	0f b6 c0             	movzbl %al,%eax
801039cf:	83 f8 04             	cmp    $0x4,%eax
801039d2:	0f 87 bf 00 00 00    	ja     80103a97 <mpinit+0x12f>
801039d8:	8b 04 85 60 8e 10 80 	mov    -0x7fef71a0(,%eax,4),%eax
801039df:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039ea:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039ee:	0f b6 d0             	movzbl %al,%edx
801039f1:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801039f6:	39 c2                	cmp    %eax,%edx
801039f8:	74 2d                	je     80103a27 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039fd:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a01:	0f b6 d0             	movzbl %al,%edx
80103a04:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a09:	89 54 24 08          	mov    %edx,0x8(%esp)
80103a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a11:	c7 04 24 22 8e 10 80 	movl   $0x80108e22,(%esp)
80103a18:	e8 83 c9 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103a1d:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
80103a24:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a2a:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103a2e:	0f b6 c0             	movzbl %al,%eax
80103a31:	83 e0 02             	and    $0x2,%eax
80103a34:	85 c0                	test   %eax,%eax
80103a36:	74 15                	je     80103a4d <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103a38:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a3d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a43:	05 60 09 11 80       	add    $0x80110960,%eax
80103a48:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103a4d:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
80103a53:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a58:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103a5e:	81 c2 60 09 11 80    	add    $0x80110960,%edx
80103a64:	88 02                	mov    %al,(%edx)
      ncpu++;
80103a66:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103a6b:	83 c0 01             	add    $0x1,%eax
80103a6e:	a3 40 0f 11 80       	mov    %eax,0x80110f40
      p += sizeof(struct mpproc);
80103a73:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a77:	eb 41                	jmp    80103aba <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a82:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a86:	a2 40 09 11 80       	mov    %al,0x80110940
      p += sizeof(struct mpioapic);
80103a8b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a8f:	eb 29                	jmp    80103aba <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a91:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a95:	eb 23                	jmp    80103aba <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9a:	0f b6 00             	movzbl (%eax),%eax
80103a9d:	0f b6 c0             	movzbl %al,%eax
80103aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aa4:	c7 04 24 40 8e 10 80 	movl   $0x80108e40,(%esp)
80103aab:	e8 f0 c8 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103ab0:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
80103ab7:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ac0:	0f 82 00 ff ff ff    	jb     801039c6 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103ac6:	a1 44 09 11 80       	mov    0x80110944,%eax
80103acb:	85 c0                	test   %eax,%eax
80103acd:	75 1d                	jne    80103aec <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103acf:	c7 05 40 0f 11 80 01 	movl   $0x1,0x80110f40
80103ad6:	00 00 00 
    lapic = 0;
80103ad9:	c7 05 bc 08 11 80 00 	movl   $0x0,0x801108bc
80103ae0:	00 00 00 
    ioapicid = 0;
80103ae3:	c6 05 40 09 11 80 00 	movb   $0x0,0x80110940
    return;
80103aea:	eb 41                	jmp    80103b2d <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103aef:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103af3:	84 c0                	test   %al,%al
80103af5:	74 36                	je     80103b2d <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103af7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103afe:	00 
80103aff:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103b06:	e8 0d fc ff ff       	call   80103718 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b0b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103b12:	e8 e4 fb ff ff       	call   801036fb <inb>
80103b17:	83 c8 01             	or     $0x1,%eax
80103b1a:	0f b6 c0             	movzbl %al,%eax
80103b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b21:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103b28:	e8 eb fb ff ff       	call   80103718 <outb>
  }
}
80103b2d:	c9                   	leave  
80103b2e:	c3                   	ret    

80103b2f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b2f:	55                   	push   %ebp
80103b30:	89 e5                	mov    %esp,%ebp
80103b32:	83 ec 08             	sub    $0x8,%esp
80103b35:	8b 55 08             	mov    0x8(%ebp),%edx
80103b38:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b3b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b3f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b42:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b46:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b4a:	ee                   	out    %al,(%dx)
}
80103b4b:	c9                   	leave  
80103b4c:	c3                   	ret    

80103b4d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103b4d:	55                   	push   %ebp
80103b4e:	89 e5                	mov    %esp,%ebp
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	8b 45 08             	mov    0x8(%ebp),%eax
80103b56:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b5a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b5e:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103b64:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b68:	0f b6 c0             	movzbl %al,%eax
80103b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b6f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b76:	e8 b4 ff ff ff       	call   80103b2f <outb>
  outb(IO_PIC2+1, mask >> 8);
80103b7b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b7f:	66 c1 e8 08          	shr    $0x8,%ax
80103b83:	0f b6 c0             	movzbl %al,%eax
80103b86:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b8a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b91:	e8 99 ff ff ff       	call   80103b2f <outb>
}
80103b96:	c9                   	leave  
80103b97:	c3                   	ret    

80103b98 <picenable>:

void
picenable(int irq)
{
80103b98:	55                   	push   %ebp
80103b99:	89 e5                	mov    %esp,%ebp
80103b9b:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80103ba1:	ba 01 00 00 00       	mov    $0x1,%edx
80103ba6:	89 c1                	mov    %eax,%ecx
80103ba8:	d3 e2                	shl    %cl,%edx
80103baa:	89 d0                	mov    %edx,%eax
80103bac:	f7 d0                	not    %eax
80103bae:	89 c2                	mov    %eax,%edx
80103bb0:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103bb7:	21 d0                	and    %edx,%eax
80103bb9:	0f b7 c0             	movzwl %ax,%eax
80103bbc:	89 04 24             	mov    %eax,(%esp)
80103bbf:	e8 89 ff ff ff       	call   80103b4d <picsetmask>
}
80103bc4:	c9                   	leave  
80103bc5:	c3                   	ret    

80103bc6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103bc6:	55                   	push   %ebp
80103bc7:	89 e5                	mov    %esp,%ebp
80103bc9:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103bcc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103bd3:	00 
80103bd4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bdb:	e8 4f ff ff ff       	call   80103b2f <outb>
  outb(IO_PIC2+1, 0xFF);
80103be0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103be7:	00 
80103be8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bef:	e8 3b ff ff ff       	call   80103b2f <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103bf4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bfb:	00 
80103bfc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c03:	e8 27 ff ff ff       	call   80103b2f <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103c08:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103c0f:	00 
80103c10:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c17:	e8 13 ff ff ff       	call   80103b2f <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103c1c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103c23:	00 
80103c24:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c2b:	e8 ff fe ff ff       	call   80103b2f <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103c30:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c37:	00 
80103c38:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103c3f:	e8 eb fe ff ff       	call   80103b2f <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103c44:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103c4b:	00 
80103c4c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c53:	e8 d7 fe ff ff       	call   80103b2f <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103c58:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103c5f:	00 
80103c60:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c67:	e8 c3 fe ff ff       	call   80103b2f <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103c6c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103c73:	00 
80103c74:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c7b:	e8 af fe ff ff       	call   80103b2f <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103c80:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c87:	00 
80103c88:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c8f:	e8 9b fe ff ff       	call   80103b2f <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103c94:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c9b:	00 
80103c9c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ca3:	e8 87 fe ff ff       	call   80103b2f <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ca8:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103caf:	00 
80103cb0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103cb7:	e8 73 fe ff ff       	call   80103b2f <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103cbc:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103cc3:	00 
80103cc4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ccb:	e8 5f fe ff ff       	call   80103b2f <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103cd0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103cd7:	00 
80103cd8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103cdf:	e8 4b fe ff ff       	call   80103b2f <outb>

  if(irqmask != 0xFFFF)
80103ce4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103ceb:	66 83 f8 ff          	cmp    $0xffff,%ax
80103cef:	74 12                	je     80103d03 <picinit+0x13d>
    picsetmask(irqmask);
80103cf1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103cf8:	0f b7 c0             	movzwl %ax,%eax
80103cfb:	89 04 24             	mov    %eax,(%esp)
80103cfe:	e8 4a fe ff ff       	call   80103b4d <picsetmask>
}
80103d03:	c9                   	leave  
80103d04:	c3                   	ret    

80103d05 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d05:	55                   	push   %ebp
80103d06:	89 e5                	mov    %esp,%ebp
80103d08:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1e:	8b 10                	mov    (%eax),%edx
80103d20:	8b 45 08             	mov    0x8(%ebp),%eax
80103d23:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d25:	e8 4c d2 ff ff       	call   80100f76 <filealloc>
80103d2a:	8b 55 08             	mov    0x8(%ebp),%edx
80103d2d:	89 02                	mov    %eax,(%edx)
80103d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d32:	8b 00                	mov    (%eax),%eax
80103d34:	85 c0                	test   %eax,%eax
80103d36:	0f 84 c8 00 00 00    	je     80103e04 <pipealloc+0xff>
80103d3c:	e8 35 d2 ff ff       	call   80100f76 <filealloc>
80103d41:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d44:	89 02                	mov    %eax,(%edx)
80103d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d49:	8b 00                	mov    (%eax),%eax
80103d4b:	85 c0                	test   %eax,%eax
80103d4d:	0f 84 b1 00 00 00    	je     80103e04 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d53:	e8 da ed ff ff       	call   80102b32 <kalloc>
80103d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d5f:	75 05                	jne    80103d66 <pipealloc+0x61>
    goto bad;
80103d61:	e9 9e 00 00 00       	jmp    80103e04 <pipealloc+0xff>
  p->readopen = 1;
80103d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d69:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d70:	00 00 00 
  p->writeopen = 1;
80103d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d76:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d7d:	00 00 00 
  p->nwrite = 0;
80103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d83:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d8a:	00 00 00 
  p->nread = 0;
80103d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d90:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d97:	00 00 00 
  initlock(&p->lock, "pipe");
80103d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9d:	c7 44 24 04 74 8e 10 	movl   $0x80108e74,0x4(%esp)
80103da4:	80 
80103da5:	89 04 24             	mov    %eax,(%esp)
80103da8:	e8 ef 15 00 00       	call   8010539c <initlock>
  (*f0)->type = FD_PIPE;
80103dad:	8b 45 08             	mov    0x8(%ebp),%eax
80103db0:	8b 00                	mov    (%eax),%eax
80103db2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103db8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbb:	8b 00                	mov    (%eax),%eax
80103dbd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc4:	8b 00                	mov    (%eax),%eax
80103dc6:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103dca:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcd:	8b 00                	mov    (%eax),%eax
80103dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dd2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd8:	8b 00                	mov    (%eax),%eax
80103dda:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de3:	8b 00                	mov    (%eax),%eax
80103de5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dec:	8b 00                	mov    (%eax),%eax
80103dee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df5:	8b 00                	mov    (%eax),%eax
80103df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dfa:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103dfd:	b8 00 00 00 00       	mov    $0x0,%eax
80103e02:	eb 42                	jmp    80103e46 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e08:	74 0b                	je     80103e15 <pipealloc+0x110>
    kfree((char*)p);
80103e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0d:	89 04 24             	mov    %eax,(%esp)
80103e10:	e8 84 ec ff ff       	call   80102a99 <kfree>
  if(*f0)
80103e15:	8b 45 08             	mov    0x8(%ebp),%eax
80103e18:	8b 00                	mov    (%eax),%eax
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 0d                	je     80103e2b <pipealloc+0x126>
    fileclose(*f0);
80103e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e21:	8b 00                	mov    (%eax),%eax
80103e23:	89 04 24             	mov    %eax,(%esp)
80103e26:	e8 f3 d1 ff ff       	call   8010101e <fileclose>
  if(*f1)
80103e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e2e:	8b 00                	mov    (%eax),%eax
80103e30:	85 c0                	test   %eax,%eax
80103e32:	74 0d                	je     80103e41 <pipealloc+0x13c>
    fileclose(*f1);
80103e34:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e37:	8b 00                	mov    (%eax),%eax
80103e39:	89 04 24             	mov    %eax,(%esp)
80103e3c:	e8 dd d1 ff ff       	call   8010101e <fileclose>
  return -1;
80103e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e46:	c9                   	leave  
80103e47:	c3                   	ret    

80103e48 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e48:	55                   	push   %ebp
80103e49:	89 e5                	mov    %esp,%ebp
80103e4b:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e51:	89 04 24             	mov    %eax,(%esp)
80103e54:	e8 64 15 00 00       	call   801053bd <acquire>
  if(writable){
80103e59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e5d:	74 1f                	je     80103e7e <pipeclose+0x36>
    p->writeopen = 0;
80103e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e62:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e69:	00 00 00 
    wakeup(&p->nread);
80103e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6f:	05 34 02 00 00       	add    $0x234,%eax
80103e74:	89 04 24             	mov    %eax,(%esp)
80103e77:	e8 d1 10 00 00       	call   80104f4d <wakeup>
80103e7c:	eb 1d                	jmp    80103e9b <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e81:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e88:	00 00 00 
    wakeup(&p->nwrite);
80103e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8e:	05 38 02 00 00       	add    $0x238,%eax
80103e93:	89 04 24             	mov    %eax,(%esp)
80103e96:	e8 b2 10 00 00       	call   80104f4d <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ea4:	85 c0                	test   %eax,%eax
80103ea6:	75 25                	jne    80103ecd <pipeclose+0x85>
80103ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80103eab:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103eb1:	85 c0                	test   %eax,%eax
80103eb3:	75 18                	jne    80103ecd <pipeclose+0x85>
    release(&p->lock);
80103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb8:	89 04 24             	mov    %eax,(%esp)
80103ebb:	e8 a7 15 00 00       	call   80105467 <release>
    kfree((char*)p);
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	89 04 24             	mov    %eax,(%esp)
80103ec6:	e8 ce eb ff ff       	call   80102a99 <kfree>
80103ecb:	eb 0b                	jmp    80103ed8 <pipeclose+0x90>
  } else
    release(&p->lock);
80103ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed0:	89 04 24             	mov    %eax,(%esp)
80103ed3:	e8 8f 15 00 00       	call   80105467 <release>
}
80103ed8:	c9                   	leave  
80103ed9:	c3                   	ret    

80103eda <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103eda:	55                   	push   %ebp
80103edb:	89 e5                	mov    %esp,%ebp
80103edd:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee3:	89 04 24             	mov    %eax,(%esp)
80103ee6:	e8 d2 14 00 00       	call   801053bd <acquire>
  for(i = 0; i < n; i++){
80103eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ef2:	e9 a6 00 00 00       	jmp    80103f9d <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ef7:	eb 57                	jmp    80103f50 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80103efc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f02:	85 c0                	test   %eax,%eax
80103f04:	74 0d                	je     80103f13 <pipewrite+0x39>
80103f06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f0c:	8b 40 24             	mov    0x24(%eax),%eax
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	74 15                	je     80103f28 <pipewrite+0x4e>
        release(&p->lock);
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	89 04 24             	mov    %eax,(%esp)
80103f19:	e8 49 15 00 00       	call   80105467 <release>
        return -1;
80103f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f23:	e9 9f 00 00 00       	jmp    80103fc7 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103f28:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2b:	05 34 02 00 00       	add    $0x234,%eax
80103f30:	89 04 24             	mov    %eax,(%esp)
80103f33:	e8 15 10 00 00       	call   80104f4d <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f38:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f3e:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f44:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f48:	89 14 24             	mov    %edx,(%esp)
80103f4b:	e8 b9 0e 00 00       	call   80104e09 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f50:	8b 45 08             	mov    0x8(%ebp),%eax
80103f53:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f59:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f62:	05 00 02 00 00       	add    $0x200,%eax
80103f67:	39 c2                	cmp    %eax,%edx
80103f69:	74 8e                	je     80103ef9 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f74:	8d 48 01             	lea    0x1(%eax),%ecx
80103f77:	8b 55 08             	mov    0x8(%ebp),%edx
80103f7a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f80:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f85:	89 c1                	mov    %eax,%ecx
80103f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f8d:	01 d0                	add    %edx,%eax
80103f8f:	0f b6 10             	movzbl (%eax),%edx
80103f92:	8b 45 08             	mov    0x8(%ebp),%eax
80103f95:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa0:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fa3:	0f 8c 4e ff ff ff    	jl     80103ef7 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fac:	05 34 02 00 00       	add    $0x234,%eax
80103fb1:	89 04 24             	mov    %eax,(%esp)
80103fb4:	e8 94 0f 00 00       	call   80104f4d <wakeup>
  release(&p->lock);
80103fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbc:	89 04 24             	mov    %eax,(%esp)
80103fbf:	e8 a3 14 00 00       	call   80105467 <release>
  return n;
80103fc4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103fc7:	c9                   	leave  
80103fc8:	c3                   	ret    

80103fc9 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fc9:	55                   	push   %ebp
80103fca:	89 e5                	mov    %esp,%ebp
80103fcc:	53                   	push   %ebx
80103fcd:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 e2 13 00 00       	call   801053bd <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fdb:	eb 3a                	jmp    80104017 <piperead+0x4e>
    if(proc->killed){
80103fdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fe3:	8b 40 24             	mov    0x24(%eax),%eax
80103fe6:	85 c0                	test   %eax,%eax
80103fe8:	74 15                	je     80103fff <piperead+0x36>
      release(&p->lock);
80103fea:	8b 45 08             	mov    0x8(%ebp),%eax
80103fed:	89 04 24             	mov    %eax,(%esp)
80103ff0:	e8 72 14 00 00       	call   80105467 <release>
      return -1;
80103ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ffa:	e9 b5 00 00 00       	jmp    801040b4 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fff:	8b 45 08             	mov    0x8(%ebp),%eax
80104002:	8b 55 08             	mov    0x8(%ebp),%edx
80104005:	81 c2 34 02 00 00    	add    $0x234,%edx
8010400b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010400f:	89 14 24             	mov    %edx,(%esp)
80104012:	e8 f2 0d 00 00       	call   80104e09 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104017:	8b 45 08             	mov    0x8(%ebp),%eax
8010401a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104020:	8b 45 08             	mov    0x8(%ebp),%eax
80104023:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104029:	39 c2                	cmp    %eax,%edx
8010402b:	75 0d                	jne    8010403a <piperead+0x71>
8010402d:	8b 45 08             	mov    0x8(%ebp),%eax
80104030:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104036:	85 c0                	test   %eax,%eax
80104038:	75 a3                	jne    80103fdd <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010403a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104041:	eb 4b                	jmp    8010408e <piperead+0xc5>
    if(p->nread == p->nwrite)
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010404c:	8b 45 08             	mov    0x8(%ebp),%eax
8010404f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104055:	39 c2                	cmp    %eax,%edx
80104057:	75 02                	jne    8010405b <piperead+0x92>
      break;
80104059:	eb 3b                	jmp    80104096 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010405b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104061:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104064:	8b 45 08             	mov    0x8(%ebp),%eax
80104067:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010406d:	8d 48 01             	lea    0x1(%eax),%ecx
80104070:	8b 55 08             	mov    0x8(%ebp),%edx
80104073:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104079:	25 ff 01 00 00       	and    $0x1ff,%eax
8010407e:	89 c2                	mov    %eax,%edx
80104080:	8b 45 08             	mov    0x8(%ebp),%eax
80104083:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104088:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010408a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010408e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104091:	3b 45 10             	cmp    0x10(%ebp),%eax
80104094:	7c ad                	jl     80104043 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104096:	8b 45 08             	mov    0x8(%ebp),%eax
80104099:	05 38 02 00 00       	add    $0x238,%eax
8010409e:	89 04 24             	mov    %eax,(%esp)
801040a1:	e8 a7 0e 00 00       	call   80104f4d <wakeup>
  release(&p->lock);
801040a6:	8b 45 08             	mov    0x8(%ebp),%eax
801040a9:	89 04 24             	mov    %eax,(%esp)
801040ac:	e8 b6 13 00 00       	call   80105467 <release>
  return i;
801040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040b4:	83 c4 24             	add    $0x24,%esp
801040b7:	5b                   	pop    %ebx
801040b8:	5d                   	pop    %ebp
801040b9:	c3                   	ret    

801040ba <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801040ba:	55                   	push   %ebp
801040bb:	89 e5                	mov    %esp,%ebp
801040bd:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c0:	9c                   	pushf  
801040c1:	58                   	pop    %eax
801040c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801040c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040c8:	c9                   	leave  
801040c9:	c3                   	ret    

801040ca <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801040ca:	55                   	push   %ebp
801040cb:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040cd:	fb                   	sti    
}
801040ce:	5d                   	pop    %ebp
801040cf:	c3                   	ret    

801040d0 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801040d6:	8b 55 08             	mov    0x8(%ebp),%edx
801040d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
801040df:	f0 87 02             	lock xchg %eax,(%edx)
801040e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801040e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040e8:	c9                   	leave  
801040e9:	c3                   	ret    

801040ea <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
801040ea:	55                   	push   %ebp
801040eb:	89 e5                	mov    %esp,%ebp
801040ed:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
801040f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    d = dst;
801040f6:	8b 45 08             	mov    0x8(%ebp),%eax
801040f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(s < d && s + n > d){
801040fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801040ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104102:	73 3d                	jae    80104141 <memcop+0x57>
80104104:	8b 45 10             	mov    0x10(%ebp),%eax
80104107:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010410a:	01 d0                	add    %edx,%eax
8010410c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010410f:	76 30                	jbe    80104141 <memcop+0x57>
        s += n;
80104111:	8b 45 10             	mov    0x10(%ebp),%eax
80104114:	01 45 fc             	add    %eax,-0x4(%ebp)
        d += n;
80104117:	8b 45 10             	mov    0x10(%ebp),%eax
8010411a:	01 45 f8             	add    %eax,-0x8(%ebp)
        while(n-- > 0)
8010411d:	eb 13                	jmp    80104132 <memcop+0x48>
            *--d = *--s;
8010411f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104123:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104127:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010412a:	0f b6 10             	movzbl (%eax),%edx
8010412d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104130:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
80104132:	8b 45 10             	mov    0x10(%ebp),%eax
80104135:	8d 50 ff             	lea    -0x1(%eax),%edx
80104138:	89 55 10             	mov    %edx,0x10(%ebp)
8010413b:	85 c0                	test   %eax,%eax
8010413d:	75 e0                	jne    8010411f <memcop+0x35>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
8010413f:	eb 26                	jmp    80104167 <memcop+0x7d>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80104141:	eb 17                	jmp    8010415a <memcop+0x70>
            *d++ = *s++;
80104143:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104146:	8d 50 01             	lea    0x1(%eax),%edx
80104149:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010414c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010414f:	8d 4a 01             	lea    0x1(%edx),%ecx
80104152:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104155:	0f b6 12             	movzbl (%edx),%edx
80104158:	88 10                	mov    %dl,(%eax)
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
8010415a:	8b 45 10             	mov    0x10(%ebp),%eax
8010415d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104160:	89 55 10             	mov    %edx,0x10(%ebp)
80104163:	85 c0                	test   %eax,%eax
80104165:	75 dc                	jne    80104143 <memcop+0x59>
            *d++ = *s++;

    return dst;
80104167:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010416a:	c9                   	leave  
8010416b:	c3                   	ret    

8010416c <pinit>:


    void
pinit(void)
{
8010416c:	55                   	push   %ebp
8010416d:	89 e5                	mov    %esp,%ebp
8010416f:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
80104172:	c7 44 24 04 7c 8e 10 	movl   $0x80108e7c,0x4(%esp)
80104179:	80 
8010417a:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104181:	e8 16 12 00 00       	call   8010539c <initlock>
}
80104186:	c9                   	leave  
80104187:	c3                   	ret    

80104188 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
80104188:	55                   	push   %ebp
80104189:	89 e5                	mov    %esp,%ebp
8010418b:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
8010418e:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104195:	e8 23 12 00 00       	call   801053bd <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419a:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
801041a1:	eb 53                	jmp    801041f6 <allocproc+0x6e>
        if(p->state == UNUSED)
801041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a6:	8b 40 0c             	mov    0xc(%eax),%eax
801041a9:	85 c0                	test   %eax,%eax
801041ab:	75 42                	jne    801041ef <allocproc+0x67>
            goto found;
801041ad:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
801041ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b1:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
801041b8:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801041bd:	8d 50 01             	lea    0x1(%eax),%edx
801041c0:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801041c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041c9:	89 42 10             	mov    %eax,0x10(%edx)
    release(&ptable.lock);
801041cc:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801041d3:	e8 8f 12 00 00       	call   80105467 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
801041d8:	e8 55 e9 ff ff       	call   80102b32 <kalloc>
801041dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e0:	89 42 08             	mov    %eax,0x8(%edx)
801041e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e6:	8b 40 08             	mov    0x8(%eax),%eax
801041e9:	85 c0                	test   %eax,%eax
801041eb:	75 36                	jne    80104223 <allocproc+0x9b>
801041ed:	eb 23                	jmp    80104212 <allocproc+0x8a>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ef:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801041f6:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
801041fd:	72 a4                	jb     801041a3 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
801041ff:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104206:	e8 5c 12 00 00       	call   80105467 <release>
    return 0;
8010420b:	b8 00 00 00 00       	mov    $0x0,%eax
80104210:	eb 76                	jmp    80104288 <allocproc+0x100>
    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
80104212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104215:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
8010421c:	b8 00 00 00 00       	mov    $0x0,%eax
80104221:	eb 65                	jmp    80104288 <allocproc+0x100>
    }
    sp = p->kstack + KSTACKSIZE;
80104223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104226:	8b 40 08             	mov    0x8(%eax),%eax
80104229:	05 00 10 00 00       	add    $0x1000,%eax
8010422e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104231:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
80104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104238:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010423b:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
8010423e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
80104242:	ba 15 6c 10 80       	mov    $0x80106c15,%edx
80104247:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010424a:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
8010424c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
80104250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104253:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104256:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010425f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104266:	00 
80104267:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010426e:	00 
8010426f:	89 04 24             	mov    %eax,(%esp)
80104272:	e8 2a 14 00 00       	call   801056a1 <memset>
    p->context->eip = (uint)forkret;
80104277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010427d:	ba dd 4d 10 80       	mov    $0x80104ddd,%edx
80104282:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
80104285:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104288:	c9                   	leave  
80104289:	c3                   	ret    

8010428a <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
8010428a:	55                   	push   %ebp
8010428b:	89 e5                	mov    %esp,%ebp
8010428d:	83 ec 28             	sub    $0x28,%esp
    cprintf("userinit called\n");
80104290:	c7 04 24 83 8e 10 80 	movl   $0x80108e83,(%esp)
80104297:	e8 04 c1 ff ff       	call   801003a0 <cprintf>
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
8010429c:	e8 e7 fe ff ff       	call   80104188 <allocproc>
801042a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
801042a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a7:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
    if((p->pgdir = setupkvm()) == 0)
801042ac:	e8 58 40 00 00       	call   80108309 <setupkvm>
801042b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b4:	89 42 04             	mov    %eax,0x4(%edx)
801042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ba:	8b 40 04             	mov    0x4(%eax),%eax
801042bd:	85 c0                	test   %eax,%eax
801042bf:	75 0c                	jne    801042cd <userinit+0x43>
        panic("userinit: out of memory?");
801042c1:	c7 04 24 94 8e 10 80 	movl   $0x80108e94,(%esp)
801042c8:	e8 6d c2 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042cd:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d5:	8b 40 04             	mov    0x4(%eax),%eax
801042d8:	89 54 24 08          	mov    %edx,0x8(%esp)
801042dc:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801042e3:	80 
801042e4:	89 04 24             	mov    %eax,(%esp)
801042e7:	e8 75 42 00 00       	call   80108561 <inituvm>
    p->sz = PGSIZE;
801042ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ef:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801042f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f8:	8b 40 18             	mov    0x18(%eax),%eax
801042fb:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104302:	00 
80104303:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010430a:	00 
8010430b:	89 04 24             	mov    %eax,(%esp)
8010430e:	e8 8e 13 00 00       	call   801056a1 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104316:	8b 40 18             	mov    0x18(%eax),%eax
80104319:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010431f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104322:	8b 40 18             	mov    0x18(%eax),%eax
80104325:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
8010432b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432e:	8b 40 18             	mov    0x18(%eax),%eax
80104331:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104334:	8b 52 18             	mov    0x18(%edx),%edx
80104337:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010433b:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
8010433f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104342:	8b 40 18             	mov    0x18(%eax),%eax
80104345:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104348:	8b 52 18             	mov    0x18(%edx),%edx
8010434b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010434f:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104356:	8b 40 18             	mov    0x18(%eax),%eax
80104359:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104363:	8b 40 18             	mov    0x18(%eax),%eax
80104366:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
8010436d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104370:	8b 40 18             	mov    0x18(%eax),%eax
80104373:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
8010437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437d:	83 c0 6c             	add    $0x6c,%eax
80104380:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104387:	00 
80104388:	c7 44 24 04 ad 8e 10 	movl   $0x80108ead,0x4(%esp)
8010438f:	80 
80104390:	89 04 24             	mov    %eax,(%esp)
80104393:	e8 29 15 00 00       	call   801058c1 <safestrcpy>
    p->cwd = namei("/");
80104398:	c7 04 24 b6 8e 10 80 	movl   $0x80108eb6,(%esp)
8010439f:	e8 b2 e0 ff ff       	call   80102456 <namei>
801043a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a7:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
801043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    cprintf("userinit no err\n");
801043b4:	c7 04 24 b8 8e 10 80 	movl   $0x80108eb8,(%esp)
801043bb:	e8 e0 bf ff ff       	call   801003a0 <cprintf>
}
801043c0:	c9                   	leave  
801043c1:	c3                   	ret    

801043c2 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
801043c2:	55                   	push   %ebp
801043c3:	89 e5                	mov    %esp,%ebp
801043c5:	83 ec 28             	sub    $0x28,%esp
    cprintf("growproc called\n");
801043c8:	c7 04 24 c9 8e 10 80 	movl   $0x80108ec9,(%esp)
801043cf:	e8 cc bf ff ff       	call   801003a0 <cprintf>
    uint sz;

    sz = proc->sz;
801043d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043da:	8b 00                	mov    (%eax),%eax
801043dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
801043df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043e3:	7e 34                	jle    80104419 <growproc+0x57>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801043e5:	8b 55 08             	mov    0x8(%ebp),%edx
801043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043eb:	01 c2                	add    %eax,%edx
801043ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f3:	8b 40 04             	mov    0x4(%eax),%eax
801043f6:	89 54 24 08          	mov    %edx,0x8(%esp)
801043fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80104401:	89 04 24             	mov    %eax,(%esp)
80104404:	e8 ce 42 00 00       	call   801086d7 <allocuvm>
80104409:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010440c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104410:	75 41                	jne    80104453 <growproc+0x91>
            return -1;
80104412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104417:	eb 64                	jmp    8010447d <growproc+0xbb>
    } else if(n < 0){
80104419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010441d:	79 34                	jns    80104453 <growproc+0x91>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010441f:	8b 55 08             	mov    0x8(%ebp),%edx
80104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104425:	01 c2                	add    %eax,%edx
80104427:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442d:	8b 40 04             	mov    0x4(%eax),%eax
80104430:	89 54 24 08          	mov    %edx,0x8(%esp)
80104434:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104437:	89 54 24 04          	mov    %edx,0x4(%esp)
8010443b:	89 04 24             	mov    %eax,(%esp)
8010443e:	e8 6e 43 00 00       	call   801087b1 <deallocuvm>
80104443:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010444a:	75 07                	jne    80104453 <growproc+0x91>
            return -1;
8010444c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104451:	eb 2a                	jmp    8010447d <growproc+0xbb>
    }
    proc->sz = sz;
80104453:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104459:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010445c:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
8010445e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104464:	89 04 24             	mov    %eax,(%esp)
80104467:	e8 8e 3f 00 00       	call   801083fa <switchuvm>
    cprintf("growproc return 0\n");
8010446c:	c7 04 24 da 8e 10 80 	movl   $0x80108eda,(%esp)
80104473:	e8 28 bf ff ff       	call   801003a0 <cprintf>
    return 0;
80104478:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010447d:	c9                   	leave  
8010447e:	c3                   	ret    

8010447f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
8010447f:	55                   	push   %ebp
80104480:	89 e5                	mov    %esp,%ebp
80104482:	57                   	push   %edi
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
80104488:	e8 fb fc ff ff       	call   80104188 <allocproc>
8010448d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104490:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104494:	75 0a                	jne    801044a0 <fork+0x21>
        return -1;
80104496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449b:	e9 53 01 00 00       	jmp    801045f3 <fork+0x174>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801044a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044a6:	8b 10                	mov    (%eax),%edx
801044a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ae:	8b 40 04             	mov    0x4(%eax),%eax
801044b1:	89 54 24 04          	mov    %edx,0x4(%esp)
801044b5:	89 04 24             	mov    %eax,(%esp)
801044b8:	e8 90 44 00 00       	call   8010894d <copyuvm>
801044bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044c0:	89 42 04             	mov    %eax,0x4(%edx)
801044c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044c6:	8b 40 04             	mov    0x4(%eax),%eax
801044c9:	85 c0                	test   %eax,%eax
801044cb:	75 2c                	jne    801044f9 <fork+0x7a>
        kfree(np->kstack);
801044cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044d0:	8b 40 08             	mov    0x8(%eax),%eax
801044d3:	89 04 24             	mov    %eax,(%esp)
801044d6:	e8 be e5 ff ff       	call   80102a99 <kfree>
        np->kstack = 0;
801044db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
801044e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
801044ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f4:	e9 fa 00 00 00       	jmp    801045f3 <fork+0x174>
    }
    np->sz = proc->sz;
801044f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ff:	8b 10                	mov    (%eax),%edx
80104501:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104504:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104506:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010450d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104510:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104513:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104516:	8b 50 18             	mov    0x18(%eax),%edx
80104519:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010451f:	8b 40 18             	mov    0x18(%eax),%eax
80104522:	89 c3                	mov    %eax,%ebx
80104524:	b8 13 00 00 00       	mov    $0x13,%eax
80104529:	89 d7                	mov    %edx,%edi
8010452b:	89 de                	mov    %ebx,%esi
8010452d:	89 c1                	mov    %eax,%ecx
8010452f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
80104531:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104534:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010453b:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
8010453e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104541:	8b 40 18             	mov    0x18(%eax),%eax
80104544:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
8010454b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104552:	eb 3d                	jmp    80104591 <fork+0x112>
        if(proc->ofile[i])
80104554:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010455d:	83 c2 08             	add    $0x8,%edx
80104560:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104564:	85 c0                	test   %eax,%eax
80104566:	74 25                	je     8010458d <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
80104568:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010456e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104571:	83 c2 08             	add    $0x8,%edx
80104574:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104578:	89 04 24             	mov    %eax,(%esp)
8010457b:	e8 56 ca ff ff       	call   80100fd6 <filedup>
80104580:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104583:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104586:	83 c1 08             	add    $0x8,%ecx
80104589:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
8010458d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104591:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104595:	7e bd                	jle    80104554 <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459d:	8b 40 68             	mov    0x68(%eax),%eax
801045a0:	89 04 24             	mov    %eax,(%esp)
801045a3:	e8 d1 d2 ff ff       	call   80101879 <idup>
801045a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045ab:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
801045ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b1:	8b 40 10             	mov    0x10(%eax),%eax
801045b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    np->state = RUNNABLE;
801045b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045ba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801045c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c7:	8d 50 6c             	lea    0x6c(%eax),%edx
801045ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045cd:	83 c0 6c             	add    $0x6c,%eax
801045d0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045d7:	00 
801045d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801045dc:	89 04 24             	mov    %eax,(%esp)
801045df:	e8 dd 12 00 00       	call   801058c1 <safestrcpy>
    cprintf("fork no ERR\n");
801045e4:	c7 04 24 ed 8e 10 80 	movl   $0x80108eed,(%esp)
801045eb:	e8 b0 bd ff ff       	call   801003a0 <cprintf>
    return pid;
801045f0:	8b 45 dc             	mov    -0x24(%ebp),%eax

}
801045f3:	83 c4 2c             	add    $0x2c,%esp
801045f6:	5b                   	pop    %ebx
801045f7:	5e                   	pop    %esi
801045f8:	5f                   	pop    %edi
801045f9:	5d                   	pop    %ebp
801045fa:	c3                   	ret    

801045fb <init_q2>:


//////////////////////////////////////////////////////////////////////
uint initedQ = 0;
void init_q2(struct queue2 *q){
801045fb:	55                   	push   %ebp
801045fc:	89 e5                	mov    %esp,%ebp
    q->size = 0;
801045fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
80104607:	8b 45 08             	mov    0x8(%ebp),%eax
8010460a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
80104611:	8b 45 08             	mov    0x8(%ebp),%eax
80104614:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010461b:	5d                   	pop    %ebp
8010461c:	c3                   	ret    

8010461d <add_q2>:
void add_q2(struct queue2 *q, struct proc *v){
8010461d:	55                   	push   %ebp
8010461e:	89 e5                	mov    %esp,%ebp
80104620:	83 ec 18             	sub    $0x18,%esp
    //struct node2 * n = kalloc2();
    struct node2 * n = kalloc2();
80104623:	e8 57 e5 ff ff       	call   80102b7f <kalloc2>
80104628:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
8010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
80104635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104638:	8b 55 0c             	mov    0xc(%ebp),%edx
8010463b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
8010463d:	8b 45 08             	mov    0x8(%ebp),%eax
80104640:	8b 40 04             	mov    0x4(%eax),%eax
80104643:	85 c0                	test   %eax,%eax
80104645:	75 0b                	jne    80104652 <add_q2+0x35>
        q->head = n;
80104647:	8b 45 08             	mov    0x8(%ebp),%eax
8010464a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010464d:	89 50 04             	mov    %edx,0x4(%eax)
80104650:	eb 0c                	jmp    8010465e <add_q2+0x41>
    }else{
        q->tail->next = n;
80104652:	8b 45 08             	mov    0x8(%ebp),%eax
80104655:	8b 40 08             	mov    0x8(%eax),%eax
80104658:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010465b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
8010465e:	8b 45 08             	mov    0x8(%ebp),%eax
80104661:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104664:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
80104667:	8b 45 08             	mov    0x8(%ebp),%eax
8010466a:	8b 00                	mov    (%eax),%eax
8010466c:	8d 50 01             	lea    0x1(%eax),%edx
8010466f:	8b 45 08             	mov    0x8(%ebp),%eax
80104672:	89 10                	mov    %edx,(%eax)
}
80104674:	c9                   	leave  
80104675:	c3                   	ret    

80104676 <empty_q2>:
int empty_q2(struct queue2 *q){
80104676:	55                   	push   %ebp
80104677:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
80104679:	8b 45 08             	mov    0x8(%ebp),%eax
8010467c:	8b 00                	mov    (%eax),%eax
8010467e:	85 c0                	test   %eax,%eax
80104680:	75 07                	jne    80104689 <empty_q2+0x13>
        return 1;
80104682:	b8 01 00 00 00       	mov    $0x1,%eax
80104687:	eb 05                	jmp    8010468e <empty_q2+0x18>
    else
        return 0;
80104689:	b8 00 00 00 00       	mov    $0x0,%eax
} 
8010468e:	5d                   	pop    %ebp
8010468f:	c3                   	ret    

80104690 <pop_q2>:
struct proc* pop_q2(struct queue2 *q){
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	83 ec 28             	sub    $0x28,%esp
    struct proc *val;
    struct node2 *destroy;
    if(!empty_q2(q)){
80104696:	8b 45 08             	mov    0x8(%ebp),%eax
80104699:	89 04 24             	mov    %eax,(%esp)
8010469c:	e8 d5 ff ff ff       	call   80104676 <empty_q2>
801046a1:	85 c0                	test   %eax,%eax
801046a3:	75 5d                	jne    80104702 <pop_q2+0x72>
       val = q->head->value; 
801046a5:	8b 45 08             	mov    0x8(%ebp),%eax
801046a8:	8b 40 04             	mov    0x4(%eax),%eax
801046ab:	8b 00                	mov    (%eax),%eax
801046ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
801046b0:	8b 45 08             	mov    0x8(%ebp),%eax
801046b3:	8b 40 04             	mov    0x4(%eax),%eax
801046b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
801046b9:	8b 45 08             	mov    0x8(%ebp),%eax
801046bc:	8b 40 04             	mov    0x4(%eax),%eax
801046bf:	8b 50 04             	mov    0x4(%eax),%edx
801046c2:	8b 45 08             	mov    0x8(%ebp),%eax
801046c5:	89 50 04             	mov    %edx,0x4(%eax)
       kfree2(destroy);
801046c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046cb:	89 04 24             	mov    %eax,(%esp)
801046ce:	e8 f9 e4 ff ff       	call   80102bcc <kfree2>
       q->size--;
801046d3:	8b 45 08             	mov    0x8(%ebp),%eax
801046d6:	8b 00                	mov    (%eax),%eax
801046d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801046db:	8b 45 08             	mov    0x8(%ebp),%eax
801046de:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
801046e0:	8b 45 08             	mov    0x8(%ebp),%eax
801046e3:	8b 00                	mov    (%eax),%eax
801046e5:	85 c0                	test   %eax,%eax
801046e7:	75 14                	jne    801046fd <pop_q2+0x6d>
            q->head = 0;
801046e9:	8b 45 08             	mov    0x8(%ebp),%eax
801046ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
801046f3:	8b 45 08             	mov    0x8(%ebp),%eax
801046f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	eb 05                	jmp    80104707 <pop_q2+0x77>
    }
    return 0;
80104702:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104707:	c9                   	leave  
80104708:	c3                   	ret    

80104709 <clone>:
/////////////////////////////////////////////////////////////////////////


//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
80104709:	55                   	push   %ebp
8010470a:	89 e5                	mov    %esp,%ebp
8010470c:	57                   	push   %edi
8010470d:	56                   	push   %esi
8010470e:	53                   	push   %ebx
8010470f:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
80104715:	e8 6e fa ff ff       	call   80104188 <allocproc>
8010471a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010471d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104721:	75 0a                	jne    8010472d <clone+0x24>
        return -1;
80104723:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104728:	e9 f4 01 00 00       	jmp    80104921 <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
8010472d:	8b 45 08             	mov    0x8(%ebp),%eax
80104730:	25 ff 0f 00 00       	and    $0xfff,%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	75 0c                	jne    80104745 <clone+0x3c>
80104739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010473d:	74 06                	je     80104745 <clone+0x3c>
8010473f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104743:	75 0a                	jne    8010474f <clone+0x46>
        return -1;
80104745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010474a:	e9 d2 01 00 00       	jmp    80104921 <clone+0x218>

    np->pgdir = proc->pgdir;
8010474f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104755:	8b 50 04             	mov    0x4(%eax),%edx
80104758:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010475b:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
8010475e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104764:	8b 10                	mov    (%eax),%edx
80104766:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104769:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
8010476b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104772:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104775:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104778:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010477b:	8b 50 18             	mov    0x18(%eax),%edx
8010477e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104784:	8b 40 18             	mov    0x18(%eax),%eax
80104787:	89 c3                	mov    %eax,%ebx
80104789:	b8 13 00 00 00       	mov    $0x13,%eax
8010478e:	89 d7                	mov    %edx,%edi
80104790:	89 de                	mov    %ebx,%esi
80104792:	89 c1                	mov    %eax,%ecx
80104794:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
80104796:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104799:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801047a0:	00 00 00 
    pid = np->pid;
801047a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047a6:	8b 40 10             	mov    0x10(%eax),%eax
801047a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
801047ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
801047b5:	eb 09                	jmp    801047c0 <clone+0xb7>
        pp = pp->parent;
801047b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ba:	8b 40 14             	mov    0x14(%eax),%eax
801047bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
801047c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801047c9:	83 f8 01             	cmp    $0x1,%eax
801047cc:	74 e9                	je     801047b7 <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
801047ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801047d4:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
801047d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047de:	eb 3d                	jmp    8010481d <clone+0x114>
        if(proc->ofile[i])
801047e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047e9:	83 c2 08             	add    $0x8,%edx
801047ec:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047f0:	85 c0                	test   %eax,%eax
801047f2:	74 25                	je     80104819 <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
801047f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047fd:	83 c2 08             	add    $0x8,%edx
80104800:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104804:	89 04 24             	mov    %eax,(%esp)
80104807:	e8 ca c7 ff ff       	call   80100fd6 <filedup>
8010480c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010480f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104812:	83 c1 08             	add    $0x8,%ecx
80104815:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
80104819:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010481d:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104821:	7e bd                	jle    801047e0 <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104823:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104826:	8b 40 18             	mov    0x18(%eax),%eax
80104829:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
80104830:	8b 45 08             	mov    0x8(%ebp),%eax
80104833:	05 00 10 00 00       	add    $0x1000,%eax
80104838:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    }
    add_q2(thQ, np);
    */
//modify here <<<<<

    np->tf->ebp = sp;
8010483b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010483e:	8b 40 18             	mov    0x18(%eax),%eax
80104841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104844:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
80104847:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
8010484e:	ff ff ff 
    ustack[1] = arg;
80104851:	8b 45 14             	mov    0x14(%ebp),%eax
80104854:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
8010485a:	83 6d d4 08          	subl   $0x8,-0x2c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
8010485e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104861:	8b 40 04             	mov    0x4(%eax),%eax
80104864:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
8010486b:	00 
8010486c:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
80104872:	89 54 24 08          	mov    %edx,0x8(%esp)
80104876:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104879:	89 54 24 04          	mov    %edx,0x4(%esp)
8010487d:	89 04 24             	mov    %eax,(%esp)
80104880:	e8 53 42 00 00       	call   80108ad8 <copyout>
80104885:	85 c0                	test   %eax,%eax
80104887:	79 16                	jns    8010489f <clone+0x196>
        cprintf("push arg fails\n");
80104889:	c7 04 24 fa 8e 10 80 	movl   $0x80108efa,(%esp)
80104890:	e8 0b bb ff ff       	call   801003a0 <cprintf>
        return -1;
80104895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010489a:	e9 82 00 00 00       	jmp    80104921 <clone+0x218>
    }

    np->tf->eip = routine;
8010489f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048a2:	8b 40 18             	mov    0x18(%eax),%eax
801048a5:	8b 55 10             	mov    0x10(%ebp),%edx
801048a8:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
801048ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048ae:	8b 40 18             	mov    0x18(%eax),%eax
801048b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801048b4:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
801048b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bd:	8b 40 68             	mov    0x68(%eax),%eax
801048c0:	89 04 24             	mov    %eax,(%esp)
801048c3:	e8 b1 cf ff ff       	call   80101879 <idup>
801048c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
801048cb:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
801048ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048d1:	89 04 24             	mov    %eax,(%esp)
801048d4:	e8 21 3b 00 00       	call   801083fa <switchuvm>

     acquire(&ptable.lock);
801048d9:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801048e0:	e8 d8 0a 00 00       	call   801053bd <acquire>
    np->state = RUNNABLE;
801048e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    // if (!initedQ) {
    //     init_q2(thQ);
    //     initedQ ++;
    // }
    // add_q2(thQ, np);
     release(&ptable.lock);
801048ef:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801048f6:	e8 6c 0b 00 00       	call   80105467 <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801048fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104901:	8d 50 6c             	lea    0x6c(%eax),%edx
80104904:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104907:	83 c0 6c             	add    $0x6c,%eax
8010490a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104911:	00 
80104912:	89 54 24 04          	mov    %edx,0x4(%esp)
80104916:	89 04 24             	mov    %eax,(%esp)
80104919:	e8 a3 0f 00 00       	call   801058c1 <safestrcpy>


    return pid;
8010491e:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
80104921:	81 c4 bc 00 00 00    	add    $0xbc,%esp
80104927:	5b                   	pop    %ebx
80104928:	5e                   	pop    %esi
80104929:	5f                   	pop    %edi
8010492a:	5d                   	pop    %ebp
8010492b:	c3                   	ret    

8010492c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
8010492c:	55                   	push   %ebp
8010492d:	89 e5                	mov    %esp,%ebp
8010492f:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
80104932:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104939:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010493e:	39 c2                	cmp    %eax,%edx
80104940:	75 0c                	jne    8010494e <exit+0x22>
        panic("init exiting");
80104942:	c7 04 24 0a 8f 10 80 	movl   $0x80108f0a,(%esp)
80104949:	e8 ec bb ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010494e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104955:	eb 44                	jmp    8010499b <exit+0x6f>
        if(proc->ofile[fd]){
80104957:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104960:	83 c2 08             	add    $0x8,%edx
80104963:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104967:	85 c0                	test   %eax,%eax
80104969:	74 2c                	je     80104997 <exit+0x6b>
            fileclose(proc->ofile[fd]);
8010496b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104971:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104974:	83 c2 08             	add    $0x8,%edx
80104977:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010497b:	89 04 24             	mov    %eax,(%esp)
8010497e:	e8 9b c6 ff ff       	call   8010101e <fileclose>
            proc->ofile[fd] = 0;
80104983:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104989:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010498c:	83 c2 08             	add    $0x8,%edx
8010498f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104996:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104997:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010499b:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010499f:	7e b6                	jle    80104957 <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
801049a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a7:	8b 40 68             	mov    0x68(%eax),%eax
801049aa:	89 04 24             	mov    %eax,(%esp)
801049ad:	e8 ac d0 ff ff       	call   80101a5e <iput>
    proc->cwd = 0;
801049b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b8:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
801049bf:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801049c6:	e8 f2 09 00 00       	call   801053bd <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
801049cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d1:	8b 40 14             	mov    0x14(%eax),%eax
801049d4:	89 04 24             	mov    %eax,(%esp)
801049d7:	e8 c8 04 00 00       	call   80104ea4 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049dc:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
801049e3:	eb 3b                	jmp    80104a20 <exit+0xf4>
        if(p->parent == proc){
801049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e8:	8b 50 14             	mov    0x14(%eax),%edx
801049eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f1:	39 c2                	cmp    %eax,%edx
801049f3:	75 24                	jne    80104a19 <exit+0xed>
            p->parent = initproc;
801049f5:	8b 15 6c c6 10 80    	mov    0x8010c66c,%edx
801049fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049fe:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80104a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a04:	8b 40 0c             	mov    0xc(%eax),%eax
80104a07:	83 f8 05             	cmp    $0x5,%eax
80104a0a:	75 0d                	jne    80104a19 <exit+0xed>
                wakeup1(initproc);
80104a0c:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104a11:	89 04 24             	mov    %eax,(%esp)
80104a14:	e8 8b 04 00 00       	call   80104ea4 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a19:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a20:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104a27:	72 bc                	jb     801049e5 <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104a29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104a36:	e8 95 02 00 00       	call   80104cd0 <sched>
    panic("zombie exit");
80104a3b:	c7 04 24 17 8f 10 80 	movl   $0x80108f17,(%esp)
80104a42:	e8 f3 ba ff ff       	call   8010053a <panic>

80104a47 <texit>:
}
    void
texit(void)
{
80104a47:	55                   	push   %ebp
80104a48:	89 e5                	mov    %esp,%ebp
80104a4a:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
80104a4d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a54:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104a59:	39 c2                	cmp    %eax,%edx
80104a5b:	75 0c                	jne    80104a69 <texit+0x22>
        panic("init exiting");
80104a5d:	c7 04 24 0a 8f 10 80 	movl   $0x80108f0a,(%esp)
80104a64:	e8 d1 ba ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a70:	eb 44                	jmp    80104ab6 <texit+0x6f>
        if(proc->ofile[fd]){
80104a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a7b:	83 c2 08             	add    $0x8,%edx
80104a7e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a82:	85 c0                	test   %eax,%eax
80104a84:	74 2c                	je     80104ab2 <texit+0x6b>
            fileclose(proc->ofile[fd]);
80104a86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a8f:	83 c2 08             	add    $0x8,%edx
80104a92:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a96:	89 04 24             	mov    %eax,(%esp)
80104a99:	e8 80 c5 ff ff       	call   8010101e <fileclose>
            proc->ofile[fd] = 0;
80104a9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa7:	83 c2 08             	add    $0x8,%edx
80104aaa:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ab1:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104ab2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ab6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104aba:	7e b6                	jle    80104a72 <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
80104abc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac2:	8b 40 68             	mov    0x68(%eax),%eax
80104ac5:	89 04 24             	mov    %eax,(%esp)
80104ac8:	e8 91 cf ff ff       	call   80101a5e <iput>
    proc->cwd = 0;
80104acd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad3:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104ada:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104ae1:	e8 d7 08 00 00       	call   801053bd <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104ae6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aec:	8b 40 14             	mov    0x14(%eax),%eax
80104aef:	89 04 24             	mov    %eax,(%esp)
80104af2:	e8 ad 03 00 00       	call   80104ea4 <wakeup1>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104af7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afd:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104b04:	e8 c7 01 00 00       	call   80104cd0 <sched>
    panic("zombie exit");
80104b09:	c7 04 24 17 8f 10 80 	movl   $0x80108f17,(%esp)
80104b10:	e8 25 ba ff ff       	call   8010053a <panic>

80104b15 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80104b15:	55                   	push   %ebp
80104b16:	89 e5                	mov    %esp,%ebp
80104b18:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104b1b:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104b22:	e8 96 08 00 00       	call   801053bd <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104b27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b2e:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104b35:	e9 ab 00 00 00       	jmp    80104be5 <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
80104b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3d:	8b 50 14             	mov    0x14(%eax),%edx
80104b40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b46:	39 c2                	cmp    %eax,%edx
80104b48:	74 05                	je     80104b4f <wait+0x3a>
                continue;
80104b4a:	e9 8f 00 00 00       	jmp    80104bde <wait+0xc9>
            havekids = 1;
80104b4f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
80104b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b59:	8b 40 0c             	mov    0xc(%eax),%eax
80104b5c:	83 f8 05             	cmp    $0x5,%eax
80104b5f:	75 7d                	jne    80104bde <wait+0xc9>
                // Found one.
                pid = p->pid;
80104b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b64:	8b 40 10             	mov    0x10(%eax),%eax
80104b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
80104b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6d:	8b 40 08             	mov    0x8(%eax),%eax
80104b70:	89 04 24             	mov    %eax,(%esp)
80104b73:	e8 21 df ff ff       	call   80102a99 <kfree>
                p->kstack = 0;
80104b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
80104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b85:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b8b:	83 f8 01             	cmp    $0x1,%eax
80104b8e:	74 0e                	je     80104b9e <wait+0x89>
                    freevm(p->pgdir);
80104b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b93:	8b 40 04             	mov    0x4(%eax),%eax
80104b96:	89 04 24             	mov    %eax,(%esp)
80104b99:	e8 cf 3c 00 00       	call   8010886d <freevm>
                }
                p->state = UNUSED;
80104b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
80104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bab:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80104bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbf:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc6:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104bcd:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104bd4:	e8 8e 08 00 00       	call   80105467 <release>
                return pid;
80104bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bdc:	eb 55                	jmp    80104c33 <wait+0x11e>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bde:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104be5:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104bec:	0f 82 48 ff ff ff    	jb     80104b3a <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80104bf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bf6:	74 0d                	je     80104c05 <wait+0xf0>
80104bf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bfe:	8b 40 24             	mov    0x24(%eax),%eax
80104c01:	85 c0                	test   %eax,%eax
80104c03:	74 13                	je     80104c18 <wait+0x103>
            release(&ptable.lock);
80104c05:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104c0c:	e8 56 08 00 00       	call   80105467 <release>
            return -1;
80104c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c16:	eb 1b                	jmp    80104c33 <wait+0x11e>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1e:	c7 44 24 04 60 0f 11 	movl   $0x80110f60,0x4(%esp)
80104c25:	80 
80104c26:	89 04 24             	mov    %eax,(%esp)
80104c29:	e8 db 01 00 00       	call   80104e09 <sleep>
    }
80104c2e:	e9 f4 fe ff ff       	jmp    80104b27 <wait+0x12>
}
80104c33:	c9                   	leave  
80104c34:	c3                   	ret    

80104c35 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104c35:	55                   	push   %ebp
80104c36:	89 e5                	mov    %esp,%ebp
80104c38:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104c3b:	e8 8a f4 ff ff       	call   801040ca <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104c40:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104c47:	e8 71 07 00 00       	call   801053bd <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4c:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104c53:	eb 61                	jmp    80104cb6 <scheduler+0x81>
            if(p->state != RUNNABLE)
80104c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c58:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5b:	83 f8 03             	cmp    $0x3,%eax
80104c5e:	74 02                	je     80104c62 <scheduler+0x2d>
                continue;
80104c60:	eb 4d                	jmp    80104caf <scheduler+0x7a>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80104c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c65:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
80104c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6e:	89 04 24             	mov    %eax,(%esp)
80104c71:	e8 84 37 00 00       	call   801083fa <switchuvm>
            p->state = RUNNING;
80104c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c79:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c86:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c89:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c90:	83 c2 04             	add    $0x4,%edx
80104c93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c97:	89 14 24             	mov    %edx,(%esp)
80104c9a:	e8 93 0c 00 00       	call   80105932 <swtch>
            switchkvm();
80104c9f:	e8 39 37 00 00       	call   801083dd <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104ca4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cab:	00 00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104caf:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104cb6:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104cbd:	72 96                	jb     80104c55 <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104cbf:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104cc6:	e8 9c 07 00 00       	call   80105467 <release>

    }
80104ccb:	e9 6b ff ff ff       	jmp    80104c3b <scheduler+0x6>

80104cd0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104cd6:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104cdd:	e8 95 08 00 00       	call   80105577 <holding>
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	75 0c                	jne    80104cf2 <sched+0x22>
        panic("sched ptable.lock");
80104ce6:	c7 04 24 23 8f 10 80 	movl   $0x80108f23,(%esp)
80104ced:	e8 48 b8 ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104cf2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104cfe:	83 f8 01             	cmp    $0x1,%eax
80104d01:	74 35                	je     80104d38 <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104d03:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d09:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104d0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d15:	8b 40 10             	mov    0x10(%eax),%eax
80104d18:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d20:	c7 04 24 38 8f 10 80 	movl   $0x80108f38,(%esp)
80104d27:	e8 74 b6 ff ff       	call   801003a0 <cprintf>
        panic("sched locks");
80104d2c:	c7 04 24 57 8f 10 80 	movl   $0x80108f57,(%esp)
80104d33:	e8 02 b8 ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104d38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d41:	83 f8 04             	cmp    $0x4,%eax
80104d44:	75 0c                	jne    80104d52 <sched+0x82>
        panic("sched running");
80104d46:	c7 04 24 63 8f 10 80 	movl   $0x80108f63,(%esp)
80104d4d:	e8 e8 b7 ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104d52:	e8 63 f3 ff ff       	call   801040ba <readeflags>
80104d57:	25 00 02 00 00       	and    $0x200,%eax
80104d5c:	85 c0                	test   %eax,%eax
80104d5e:	74 0c                	je     80104d6c <sched+0x9c>
        panic("sched interruptible");
80104d60:	c7 04 24 71 8f 10 80 	movl   $0x80108f71,(%esp)
80104d67:	e8 ce b7 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104d6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d72:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104d7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d81:	8b 40 04             	mov    0x4(%eax),%eax
80104d84:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d8b:	83 c2 1c             	add    $0x1c,%edx
80104d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d92:	89 14 24             	mov    %edx,(%esp)
80104d95:	e8 98 0b 00 00       	call   80105932 <swtch>
    cpu->intena = intena;
80104d9a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104da3:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104da9:	c9                   	leave  
80104daa:	c3                   	ret    

80104dab <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104dab:	55                   	push   %ebp
80104dac:	89 e5                	mov    %esp,%ebp
80104dae:	83 ec 18             	sub    $0x18,%esp
    //cprintf("Yielded\n");
    acquire(&ptable.lock);  //DOC: yieldlock
80104db1:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104db8:	e8 00 06 00 00       	call   801053bd <acquire>
    proc->state = RUNNABLE;
80104dbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104dca:	e8 01 ff ff ff       	call   80104cd0 <sched>
    release(&ptable.lock);
80104dcf:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104dd6:	e8 8c 06 00 00       	call   80105467 <release>
}
80104ddb:	c9                   	leave  
80104ddc:	c3                   	ret    

80104ddd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104ddd:	55                   	push   %ebp
80104dde:	89 e5                	mov    %esp,%ebp
80104de0:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104de3:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104dea:	e8 78 06 00 00       	call   80105467 <release>

    if (first) {
80104def:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104df4:	85 c0                	test   %eax,%eax
80104df6:	74 0f                	je     80104e07 <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104df8:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104dff:	00 00 00 
        initlog();
80104e02:	e8 06 e3 ff ff       	call   8010310d <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104e07:	c9                   	leave  
80104e08:	c3                   	ret    

80104e09 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104e09:	55                   	push   %ebp
80104e0a:	89 e5                	mov    %esp,%ebp
80104e0c:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104e0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e15:	85 c0                	test   %eax,%eax
80104e17:	75 0c                	jne    80104e25 <sleep+0x1c>
        panic("sleep");
80104e19:	c7 04 24 85 8f 10 80 	movl   $0x80108f85,(%esp)
80104e20:	e8 15 b7 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e29:	75 0c                	jne    80104e37 <sleep+0x2e>
        panic("sleep without lk");
80104e2b:	c7 04 24 8b 8f 10 80 	movl   $0x80108f8b,(%esp)
80104e32:	e8 03 b7 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104e37:	81 7d 0c 60 0f 11 80 	cmpl   $0x80110f60,0xc(%ebp)
80104e3e:	74 17                	je     80104e57 <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104e40:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104e47:	e8 71 05 00 00       	call   801053bd <acquire>
        release(lk);
80104e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4f:	89 04 24             	mov    %eax,(%esp)
80104e52:	e8 10 06 00 00       	call   80105467 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104e57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e60:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104e63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e69:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104e70:	e8 5b fe ff ff       	call   80104cd0 <sched>

    // Tidy up.
    proc->chan = 0;
80104e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104e82:	81 7d 0c 60 0f 11 80 	cmpl   $0x80110f60,0xc(%ebp)
80104e89:	74 17                	je     80104ea2 <sleep+0x99>
        release(&ptable.lock);
80104e8b:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104e92:	e8 d0 05 00 00       	call   80105467 <release>
        acquire(lk);
80104e97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9a:	89 04 24             	mov    %eax,(%esp)
80104e9d:	e8 1b 05 00 00       	call   801053bd <acquire>
    }
}
80104ea2:	c9                   	leave  
80104ea3:	c3                   	ret    

80104ea4 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eaa:	c7 45 fc 94 0f 11 80 	movl   $0x80110f94,-0x4(%ebp)
80104eb1:	eb 27                	jmp    80104eda <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eb6:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb9:	83 f8 02             	cmp    $0x2,%eax
80104ebc:	75 15                	jne    80104ed3 <wakeup1+0x2f>
80104ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec1:	8b 40 20             	mov    0x20(%eax),%eax
80104ec4:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ec7:	75 0a                	jne    80104ed3 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ecc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed3:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104eda:	81 7d fc 94 30 11 80 	cmpl   $0x80113094,-0x4(%ebp)
80104ee1:	72 d0                	jb     80104eb3 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104ee3:	c9                   	leave  
80104ee4:	c3                   	ret    

80104ee5 <twakeup>:

void 
twakeup(int tid){
80104ee5:	55                   	push   %ebp
80104ee6:	89 e5                	mov    %esp,%ebp
80104ee8:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104eeb:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104ef2:	e8 c6 04 00 00       	call   801053bd <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ef7:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104efe:	eb 36                	jmp    80104f36 <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f03:	8b 40 0c             	mov    0xc(%eax),%eax
80104f06:	83 f8 02             	cmp    $0x2,%eax
80104f09:	75 24                	jne    80104f2f <twakeup+0x4a>
80104f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0e:	8b 40 10             	mov    0x10(%eax),%eax
80104f11:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f14:	75 19                	jne    80104f2f <twakeup+0x4a>
80104f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f19:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104f1f:	83 f8 01             	cmp    $0x1,%eax
80104f22:	75 0b                	jne    80104f2f <twakeup+0x4a>
            wakeup1(p);
80104f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f27:	89 04 24             	mov    %eax,(%esp)
80104f2a:	e8 75 ff ff ff       	call   80104ea4 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f2f:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104f36:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104f3d:	72 c1                	jb     80104f00 <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104f3f:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f46:	e8 1c 05 00 00       	call   80105467 <release>
}
80104f4b:	c9                   	leave  
80104f4c:	c3                   	ret    

80104f4d <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104f4d:	55                   	push   %ebp
80104f4e:	89 e5                	mov    %esp,%ebp
80104f50:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104f53:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f5a:	e8 5e 04 00 00       	call   801053bd <acquire>
    wakeup1(chan);
80104f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f62:	89 04 24             	mov    %eax,(%esp)
80104f65:	e8 3a ff ff ff       	call   80104ea4 <wakeup1>
    release(&ptable.lock);
80104f6a:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f71:	e8 f1 04 00 00       	call   80105467 <release>
}
80104f76:	c9                   	leave  
80104f77:	c3                   	ret    

80104f78 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104f78:	55                   	push   %ebp
80104f79:	89 e5                	mov    %esp,%ebp
80104f7b:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104f7e:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104f85:	e8 33 04 00 00       	call   801053bd <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8a:	c7 45 f4 94 0f 11 80 	movl   $0x80110f94,-0xc(%ebp)
80104f91:	eb 44                	jmp    80104fd7 <kill+0x5f>
        if(p->pid == pid){
80104f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f96:	8b 40 10             	mov    0x10(%eax),%eax
80104f99:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f9c:	75 32                	jne    80104fd0 <kill+0x58>
            p->killed = 1;
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fab:	8b 40 0c             	mov    0xc(%eax),%eax
80104fae:	83 f8 02             	cmp    $0x2,%eax
80104fb1:	75 0a                	jne    80104fbd <kill+0x45>
                p->state = RUNNABLE;
80104fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104fbd:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104fc4:	e8 9e 04 00 00       	call   80105467 <release>
            return 0;
80104fc9:	b8 00 00 00 00       	mov    $0x0,%eax
80104fce:	eb 21                	jmp    80104ff1 <kill+0x79>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fd0:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104fd7:	81 7d f4 94 30 11 80 	cmpl   $0x80113094,-0xc(%ebp)
80104fde:	72 b3                	jb     80104f93 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104fe0:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104fe7:	e8 7b 04 00 00       	call   80105467 <release>
    return -1;
80104fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff1:	c9                   	leave  
80104ff2:	c3                   	ret    

80104ff3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104ff3:	55                   	push   %ebp
80104ff4:	89 e5                	mov    %esp,%ebp
80104ff6:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff9:	c7 45 f0 94 0f 11 80 	movl   $0x80110f94,-0x10(%ebp)
80105000:	e9 d9 00 00 00       	jmp    801050de <procdump+0xeb>
        if(p->state == UNUSED)
80105005:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105008:	8b 40 0c             	mov    0xc(%eax),%eax
8010500b:	85 c0                	test   %eax,%eax
8010500d:	75 05                	jne    80105014 <procdump+0x21>
            continue;
8010500f:	e9 c3 00 00 00       	jmp    801050d7 <procdump+0xe4>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105014:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105017:	8b 40 0c             	mov    0xc(%eax),%eax
8010501a:	83 f8 05             	cmp    $0x5,%eax
8010501d:	77 23                	ja     80105042 <procdump+0x4f>
8010501f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105022:	8b 40 0c             	mov    0xc(%eax),%eax
80105025:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010502c:	85 c0                	test   %eax,%eax
8010502e:	74 12                	je     80105042 <procdump+0x4f>
            state = states[p->state];
80105030:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105033:	8b 40 0c             	mov    0xc(%eax),%eax
80105036:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010503d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105040:	eb 07                	jmp    80105049 <procdump+0x56>
        else
            state = "???";
80105042:	c7 45 ec 9c 8f 10 80 	movl   $0x80108f9c,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80105049:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010504f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105052:	8b 40 10             	mov    0x10(%eax),%eax
80105055:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105059:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010505c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105060:	89 44 24 04          	mov    %eax,0x4(%esp)
80105064:	c7 04 24 a0 8f 10 80 	movl   $0x80108fa0,(%esp)
8010506b:	e8 30 b3 ff ff       	call   801003a0 <cprintf>
        if(p->state == SLEEPING){
80105070:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105073:	8b 40 0c             	mov    0xc(%eax),%eax
80105076:	83 f8 02             	cmp    $0x2,%eax
80105079:	75 50                	jne    801050cb <procdump+0xd8>
            getcallerpcs((uint*)p->context->ebp+2, pc);
8010507b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105081:	8b 40 0c             	mov    0xc(%eax),%eax
80105084:	83 c0 08             	add    $0x8,%eax
80105087:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010508a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010508e:	89 04 24             	mov    %eax,(%esp)
80105091:	e8 68 04 00 00       	call   801054fe <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
80105096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010509d:	eb 1b                	jmp    801050ba <procdump+0xc7>
                cprintf(" %p", pc[i]);
8010509f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050aa:	c7 04 24 a9 8f 10 80 	movl   $0x80108fa9,(%esp)
801050b1:	e8 ea b2 ff ff       	call   801003a0 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
801050b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050ba:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050be:	7f 0b                	jg     801050cb <procdump+0xd8>
801050c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050c7:	85 c0                	test   %eax,%eax
801050c9:	75 d4                	jne    8010509f <procdump+0xac>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801050cb:	c7 04 24 ad 8f 10 80 	movl   $0x80108fad,(%esp)
801050d2:	e8 c9 b2 ff ff       	call   801003a0 <cprintf>
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050d7:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
801050de:	81 7d f0 94 30 11 80 	cmpl   $0x80113094,-0x10(%ebp)
801050e5:	0f 82 1a ff ff ff    	jb     80105005 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
801050eb:	c9                   	leave  
801050ec:	c3                   	ret    

801050ed <tsleep>:

void tsleep(void){
801050ed:	55                   	push   %ebp
801050ee:	89 e5                	mov    %esp,%ebp
801050f0:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
801050f3:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801050fa:	e8 be 02 00 00       	call   801053bd <acquire>
    sleep(proc, &ptable.lock);
801050ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105105:	c7 44 24 04 60 0f 11 	movl   $0x80110f60,0x4(%esp)
8010510c:	80 
8010510d:	89 04 24             	mov    %eax,(%esp)
80105110:	e8 f4 fc ff ff       	call   80104e09 <sleep>
    release(&ptable.lock);
80105115:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
8010511c:	e8 46 03 00 00       	call   80105467 <release>

}
80105121:	c9                   	leave  
80105122:	c3                   	ret    

80105123 <lock_acquire2>:
//     struct node2 * tail;
// };
// struct queue2 *thQ;


void lock_acquire2(struct spinlock *lock){
80105123:	55                   	push   %ebp
80105124:	89 e5                	mov    %esp,%ebp
80105126:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
80105129:	90                   	nop
8010512a:	8b 45 08             	mov    0x8(%ebp),%eax
8010512d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105134:	00 
80105135:	89 04 24             	mov    %eax,(%esp)
80105138:	e8 93 ef ff ff       	call   801040d0 <xchg>
8010513d:	85 c0                	test   %eax,%eax
8010513f:	75 e9                	jne    8010512a <lock_acquire2+0x7>
}
80105141:	c9                   	leave  
80105142:	c3                   	ret    

80105143 <lock_release2>:
void lock_release2(struct spinlock *lock){
80105143:	55                   	push   %ebp
80105144:	89 e5                	mov    %esp,%ebp
80105146:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
80105149:	8b 45 08             	mov    0x8(%ebp),%eax
8010514c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105153:	00 
80105154:	89 04 24             	mov    %eax,(%esp)
80105157:	e8 74 ef ff ff       	call   801040d0 <xchg>
}
8010515c:	c9                   	leave  
8010515d:	c3                   	ret    

8010515e <thread_yield>:
//////////////////////////////////

//////////////////////////////////
void thread_yield(void){
8010515e:	55                   	push   %ebp
8010515f:	89 e5                	mov    %esp,%ebp
80105161:	83 ec 38             	sub    $0x38,%esp
    cprintf("Curr %d%d%d\n", proc->isthread, proc->state, proc->pid);
80105164:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516a:	8b 48 10             	mov    0x10(%eax),%ecx
8010516d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105173:	8b 50 0c             	mov    0xc(%eax),%edx
80105176:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105182:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105186:	89 54 24 08          	mov    %edx,0x8(%esp)
8010518a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010518e:	c7 04 24 af 8f 10 80 	movl   $0x80108faf,(%esp)
80105195:	e8 06 b2 ff ff       	call   801003a0 <cprintf>
    //acquire(&ptable.lock);
    struct proc *p;
    struct proc *old;
    //struct proc *curr;
    int pid = proc->pid;
8010519a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a0:	8b 40 10             	mov    0x10(%eax),%eax
801051a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int intena;
    if (!initedQ) {
801051a6:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801051ab:	85 c0                	test   %eax,%eax
801051ad:	75 1a                	jne    801051c9 <thread_yield+0x6b>
        init_q2(thQ);
801051af:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
801051b4:	89 04 24             	mov    %eax,(%esp)
801051b7:	e8 3f f4 ff ff       	call   801045fb <init_q2>
        initedQ ++;
801051bc:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801051c1:	83 c0 01             	add    $0x1,%eax
801051c4:	a3 68 c6 10 80       	mov    %eax,0x8010c668
    //     //cprintf(" ACQUIRED\n");
    //     acq++;
    // }
    //else cprintf(" DID NOT ACQUIRE\n");
    
    if (!holding(&ptable.lock)) {
801051c9:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801051d0:	e8 a2 03 00 00       	call   80105577 <holding>
801051d5:	85 c0                	test   %eax,%eax
801051d7:	75 1a                	jne    801051f3 <thread_yield+0x95>
        //lock_acquire2(&ptable.lock);
        acquire(&ptable.lock); 
801051d9:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801051e0:	e8 d8 01 00 00       	call   801053bd <acquire>
        cprintf(" ACQUIRED\n");
801051e5:	c7 04 24 bc 8f 10 80 	movl   $0x80108fbc,(%esp)
801051ec:	e8 af b1 ff ff       	call   801003a0 <cprintf>
801051f1:	eb 0c                	jmp    801051ff <thread_yield+0xa1>
    }
    else cprintf(" DID NOT ACQUIRE\n");
801051f3:	c7 04 24 c7 8f 10 80 	movl   $0x80108fc7,(%esp)
801051fa:	e8 a1 b1 ff ff       	call   801003a0 <cprintf>
    cprintf("QUEUE SIZE_1 %d\n", thQ->size);
801051ff:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105204:	8b 00                	mov    (%eax),%eax
80105206:	89 44 24 04          	mov    %eax,0x4(%esp)
8010520a:	c7 04 24 d9 8f 10 80 	movl   $0x80108fd9,(%esp)
80105211:	e8 8a b1 ff ff       	call   801003a0 <cprintf>
                break;
            }
        }
    }
    */
    p = pop_q2(thQ);
80105216:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
8010521b:	89 04 24             	mov    %eax,(%esp)
8010521e:	e8 6d f4 ff ff       	call   80104690 <pop_q2>
80105223:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if ((p->pid) == (proc->pid)) {
80105226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105229:	8b 50 10             	mov    0x10(%eax),%edx
8010522c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105232:	8b 40 10             	mov    0x10(%eax),%eax
80105235:	39 c2                	cmp    %eax,%edx
80105237:	75 10                	jne    80105249 <thread_yield+0xeb>
        p = pop_q2(thQ);
80105239:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
8010523e:	89 04 24             	mov    %eax,(%esp)
80105241:	e8 4a f4 ff ff       	call   80104690 <pop_q2>
80105246:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    cprintf("Before %d going to %d%d%d\n",pid, p->isthread, p->state, p->pid);
80105249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524c:	8b 48 10             	mov    0x10(%eax),%ecx
8010524f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105252:	8b 50 0c             	mov    0xc(%eax),%edx
80105255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105258:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010525e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105262:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105266:	89 44 24 08          	mov    %eax,0x8(%esp)
8010526a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010526d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105271:	c7 04 24 ea 8f 10 80 	movl   $0x80108fea,(%esp)
80105278:	e8 23 b1 ff ff       	call   801003a0 <cprintf>
    cprintf("QUEUE SIZE_2 %d\n", thQ->size);
8010527d:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80105282:	8b 00                	mov    (%eax),%eax
80105284:	89 44 24 04          	mov    %eax,0x4(%esp)
80105288:	c7 04 24 05 90 10 80 	movl   $0x80109005,(%esp)
8010528f:	e8 0c b1 ff ff       	call   801003a0 <cprintf>
    proc->state = RUNNABLE;
80105294:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010529a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    add_q2(thQ, proc);
801052a1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052a8:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
801052ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801052b1:	89 04 24             	mov    %eax,(%esp)
801052b4:	e8 64 f3 ff ff       	call   8010461d <add_q2>
    old = proc;
801052b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    proc = p;
801052c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c5:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
    //switchuvm(p);
    p->state = RUNNING;
801052cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ce:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    intena = cpu->intena;
801052d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052db:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801052e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    swtch(&old->context, proc->context);
801052e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ea:	8b 40 1c             	mov    0x1c(%eax),%eax
801052ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052f0:	83 c2 1c             	add    $0x1c,%edx
801052f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801052f7:	89 14 24             	mov    %edx,(%esp)
801052fa:	e8 33 06 00 00       	call   80105932 <swtch>
    cpu->intena = intena;
801052ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105305:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105308:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
    //switchkvm();
    //proc = 0;
    //swtch(&old->context, p->context);
    //swtch(&old->context, cpu->scheduler);
    //swtch(&cpu->scheduler, proc->context);
    cprintf("After %d\n", pid);
8010530e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105311:	89 44 24 04          	mov    %eax,0x4(%esp)
80105315:	c7 04 24 16 90 10 80 	movl   $0x80109016,(%esp)
8010531c:	e8 7f b0 ff ff       	call   801003a0 <cprintf>
    
    if (holding(&ptable.lock)) {
80105321:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80105328:	e8 4a 02 00 00       	call   80105577 <holding>
8010532d:	85 c0                	test   %eax,%eax
8010532f:	74 1a                	je     8010534b <thread_yield+0x1ed>
        //lock_release2(&ptable.lock);
        release(&ptable.lock); 
80105331:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80105338:	e8 2a 01 00 00       	call   80105467 <release>
        cprintf("RELEASED\n");
8010533d:	c7 04 24 20 90 10 80 	movl   $0x80109020,(%esp)
80105344:	e8 57 b0 ff ff       	call   801003a0 <cprintf>
80105349:	eb 0c                	jmp    80105357 <thread_yield+0x1f9>
    }
    else cprintf("DID NOT RELEASE\n");
8010534b:	c7 04 24 2a 90 10 80 	movl   $0x8010902a,(%esp)
80105352:	e8 49 b0 ff ff       	call   801003a0 <cprintf>
    
    //release(&ptable.lock);
    
}
80105357:	c9                   	leave  
80105358:	c3                   	ret    

80105359 <thread_yield3>:

void thread_yield3(int tid) {
80105359:	55                   	push   %ebp
8010535a:	89 e5                	mov    %esp,%ebp
8010535c:	83 ec 08             	sub    $0x8,%esp
    //switchuvm(p);
    p->state = RUNNING;
    swtch(&old->context, proc->context);
    release(&ptable.lock);
    */
    yield();
8010535f:	e8 47 fa ff ff       	call   80104dab <yield>
80105364:	c9                   	leave  
80105365:	c3                   	ret    

80105366 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105366:	55                   	push   %ebp
80105367:	89 e5                	mov    %esp,%ebp
80105369:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010536c:	9c                   	pushf  
8010536d:	58                   	pop    %eax
8010536e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105371:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105374:	c9                   	leave  
80105375:	c3                   	ret    

80105376 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105376:	55                   	push   %ebp
80105377:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105379:	fa                   	cli    
}
8010537a:	5d                   	pop    %ebp
8010537b:	c3                   	ret    

8010537c <sti>:

static inline void
sti(void)
{
8010537c:	55                   	push   %ebp
8010537d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010537f:	fb                   	sti    
}
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    

80105382 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105382:	55                   	push   %ebp
80105383:	89 e5                	mov    %esp,%ebp
80105385:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105388:	8b 55 08             	mov    0x8(%ebp),%edx
8010538b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010538e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105391:	f0 87 02             	lock xchg %eax,(%edx)
80105394:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010539a:	c9                   	leave  
8010539b:	c3                   	ret    

8010539c <initlock>:
#include "spinlock.h"
//#include "semaphore.h"

void
initlock(struct spinlock *lk, char *name)
{
8010539c:	55                   	push   %ebp
8010539d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010539f:	8b 45 08             	mov    0x8(%ebp),%eax
801053a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801053a5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801053a8:	8b 45 08             	mov    0x8(%ebp),%eax
801053ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801053b1:	8b 45 08             	mov    0x8(%ebp),%eax
801053b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053bb:	5d                   	pop    %ebp
801053bc:	c3                   	ret    

801053bd <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801053bd:	55                   	push   %ebp
801053be:	89 e5                	mov    %esp,%ebp
801053c0:	53                   	push   %ebx
801053c1:	83 ec 24             	sub    $0x24,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801053c4:	e8 d8 01 00 00       	call   801055a1 <pushcli>
  if(holding(lk)) {
801053c9:	8b 45 08             	mov    0x8(%ebp),%eax
801053cc:	89 04 24             	mov    %eax,(%esp)
801053cf:	e8 a3 01 00 00       	call   80105577 <holding>
801053d4:	85 c0                	test   %eax,%eax
801053d6:	74 4f                	je     80105427 <acquire+0x6a>
    cprintf("PROC %d%d%d %s called acq ", proc->isthread, proc->state, proc->pid, proc->name);
801053d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053de:	8d 58 6c             	lea    0x6c(%eax),%ebx
801053e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e7:	8b 48 10             	mov    0x10(%eax),%ecx
801053ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f0:	8b 50 0c             	mov    0xc(%eax),%edx
801053f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801053ff:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80105403:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105407:	89 54 24 08          	mov    %edx,0x8(%esp)
8010540b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010540f:	c7 04 24 65 90 10 80 	movl   $0x80109065,(%esp)
80105416:	e8 85 af ff ff       	call   801003a0 <cprintf>
    panic("acquire in spinlock.c");
8010541b:	c7 04 24 80 90 10 80 	movl   $0x80109080,(%esp)
80105422:	e8 13 b1 ff ff       	call   8010053a <panic>
  }

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105427:	90                   	nop
80105428:	8b 45 08             	mov    0x8(%ebp),%eax
8010542b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105432:	00 
80105433:	89 04 24             	mov    %eax,(%esp)
80105436:	e8 47 ff ff ff       	call   80105382 <xchg>
8010543b:	85 c0                	test   %eax,%eax
8010543d:	75 e9                	jne    80105428 <acquire+0x6b>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010543f:	8b 45 08             	mov    0x8(%ebp),%eax
80105442:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105449:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010544c:	8b 45 08             	mov    0x8(%ebp),%eax
8010544f:	83 c0 0c             	add    $0xc,%eax
80105452:	89 44 24 04          	mov    %eax,0x4(%esp)
80105456:	8d 45 08             	lea    0x8(%ebp),%eax
80105459:	89 04 24             	mov    %eax,(%esp)
8010545c:	e8 9d 00 00 00       	call   801054fe <getcallerpcs>
}
80105461:	83 c4 24             	add    $0x24,%esp
80105464:	5b                   	pop    %ebx
80105465:	5d                   	pop    %ebp
80105466:	c3                   	ret    

80105467 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105467:	55                   	push   %ebp
80105468:	89 e5                	mov    %esp,%ebp
8010546a:	53                   	push   %ebx
8010546b:	83 ec 24             	sub    $0x24,%esp
  if(!holding(lk)) {
8010546e:	8b 45 08             	mov    0x8(%ebp),%eax
80105471:	89 04 24             	mov    %eax,(%esp)
80105474:	e8 fe 00 00 00       	call   80105577 <holding>
80105479:	85 c0                	test   %eax,%eax
8010547b:	75 4f                	jne    801054cc <release+0x65>
    cprintf("PROC %d%d%d %s called rel ", proc->isthread, proc->state, proc->pid, proc->name);
8010547d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105483:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105486:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010548c:	8b 48 10             	mov    0x10(%eax),%ecx
8010548f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105495:	8b 50 0c             	mov    0xc(%eax),%edx
80105498:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801054a4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801054a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801054ac:	89 54 24 08          	mov    %edx,0x8(%esp)
801054b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b4:	c7 04 24 96 90 10 80 	movl   $0x80109096,(%esp)
801054bb:	e8 e0 ae ff ff       	call   801003a0 <cprintf>
    panic("release in spinlock.c");
801054c0:	c7 04 24 b1 90 10 80 	movl   $0x801090b1,(%esp)
801054c7:	e8 6e b0 ff ff       	call   8010053a <panic>
  }

  lk->pcs[0] = 0;
801054cc:	8b 45 08             	mov    0x8(%ebp),%eax
801054cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801054d6:	8b 45 08             	mov    0x8(%ebp),%eax
801054d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801054e0:	8b 45 08             	mov    0x8(%ebp),%eax
801054e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054ea:	00 
801054eb:	89 04 24             	mov    %eax,(%esp)
801054ee:	e8 8f fe ff ff       	call   80105382 <xchg>

  popcli();
801054f3:	e8 ed 00 00 00       	call   801055e5 <popcli>
}
801054f8:	83 c4 24             	add    $0x24,%esp
801054fb:	5b                   	pop    %ebx
801054fc:	5d                   	pop    %ebp
801054fd:	c3                   	ret    

801054fe <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801054fe:	55                   	push   %ebp
801054ff:	89 e5                	mov    %esp,%ebp
80105501:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105504:	8b 45 08             	mov    0x8(%ebp),%eax
80105507:	83 e8 08             	sub    $0x8,%eax
8010550a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010550d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105514:	eb 38                	jmp    8010554e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105516:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010551a:	74 38                	je     80105554 <getcallerpcs+0x56>
8010551c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105523:	76 2f                	jbe    80105554 <getcallerpcs+0x56>
80105525:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105529:	74 29                	je     80105554 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010552b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010552e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105535:	8b 45 0c             	mov    0xc(%ebp),%eax
80105538:	01 c2                	add    %eax,%edx
8010553a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010553d:	8b 40 04             	mov    0x4(%eax),%eax
80105540:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105542:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105545:	8b 00                	mov    (%eax),%eax
80105547:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010554a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010554e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105552:	7e c2                	jle    80105516 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105554:	eb 19                	jmp    8010556f <getcallerpcs+0x71>
    pcs[i] = 0;
80105556:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105560:	8b 45 0c             	mov    0xc(%ebp),%eax
80105563:	01 d0                	add    %edx,%eax
80105565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010556b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010556f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105573:	7e e1                	jle    80105556 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105575:	c9                   	leave  
80105576:	c3                   	ret    

80105577 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105577:	55                   	push   %ebp
80105578:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010557a:	8b 45 08             	mov    0x8(%ebp),%eax
8010557d:	8b 00                	mov    (%eax),%eax
8010557f:	85 c0                	test   %eax,%eax
80105581:	74 17                	je     8010559a <holding+0x23>
80105583:	8b 45 08             	mov    0x8(%ebp),%eax
80105586:	8b 50 08             	mov    0x8(%eax),%edx
80105589:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010558f:	39 c2                	cmp    %eax,%edx
80105591:	75 07                	jne    8010559a <holding+0x23>
80105593:	b8 01 00 00 00       	mov    $0x1,%eax
80105598:	eb 05                	jmp    8010559f <holding+0x28>
8010559a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010559f:	5d                   	pop    %ebp
801055a0:	c3                   	ret    

801055a1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801055a1:	55                   	push   %ebp
801055a2:	89 e5                	mov    %esp,%ebp
801055a4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801055a7:	e8 ba fd ff ff       	call   80105366 <readeflags>
801055ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801055af:	e8 c2 fd ff ff       	call   80105376 <cli>
  if(cpu->ncli++ == 0)
801055b4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055bb:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801055c1:	8d 48 01             	lea    0x1(%eax),%ecx
801055c4:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801055ca:	85 c0                	test   %eax,%eax
801055cc:	75 15                	jne    801055e3 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801055ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055d7:	81 e2 00 02 00 00    	and    $0x200,%edx
801055dd:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801055e3:	c9                   	leave  
801055e4:	c3                   	ret    

801055e5 <popcli>:

void
popcli(void)
{
801055e5:	55                   	push   %ebp
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801055eb:	e8 76 fd ff ff       	call   80105366 <readeflags>
801055f0:	25 00 02 00 00       	and    $0x200,%eax
801055f5:	85 c0                	test   %eax,%eax
801055f7:	74 0c                	je     80105605 <popcli+0x20>
    panic("popcli - interruptible");
801055f9:	c7 04 24 c7 90 10 80 	movl   $0x801090c7,(%esp)
80105600:	e8 35 af ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105605:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010560b:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105611:	83 ea 01             	sub    $0x1,%edx
80105614:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010561a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105620:	85 c0                	test   %eax,%eax
80105622:	79 0c                	jns    80105630 <popcli+0x4b>
    panic("popcli");
80105624:	c7 04 24 de 90 10 80 	movl   $0x801090de,(%esp)
8010562b:	e8 0a af ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105630:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105636:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010563c:	85 c0                	test   %eax,%eax
8010563e:	75 15                	jne    80105655 <popcli+0x70>
80105640:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105646:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010564c:	85 c0                	test   %eax,%eax
8010564e:	74 05                	je     80105655 <popcli+0x70>
    sti();
80105650:	e8 27 fd ff ff       	call   8010537c <sti>
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    

80105657 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105657:	55                   	push   %ebp
80105658:	89 e5                	mov    %esp,%ebp
8010565a:	57                   	push   %edi
8010565b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010565c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010565f:	8b 55 10             	mov    0x10(%ebp),%edx
80105662:	8b 45 0c             	mov    0xc(%ebp),%eax
80105665:	89 cb                	mov    %ecx,%ebx
80105667:	89 df                	mov    %ebx,%edi
80105669:	89 d1                	mov    %edx,%ecx
8010566b:	fc                   	cld    
8010566c:	f3 aa                	rep stos %al,%es:(%edi)
8010566e:	89 ca                	mov    %ecx,%edx
80105670:	89 fb                	mov    %edi,%ebx
80105672:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105675:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105678:	5b                   	pop    %ebx
80105679:	5f                   	pop    %edi
8010567a:	5d                   	pop    %ebp
8010567b:	c3                   	ret    

8010567c <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010567c:	55                   	push   %ebp
8010567d:	89 e5                	mov    %esp,%ebp
8010567f:	57                   	push   %edi
80105680:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105681:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105684:	8b 55 10             	mov    0x10(%ebp),%edx
80105687:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568a:	89 cb                	mov    %ecx,%ebx
8010568c:	89 df                	mov    %ebx,%edi
8010568e:	89 d1                	mov    %edx,%ecx
80105690:	fc                   	cld    
80105691:	f3 ab                	rep stos %eax,%es:(%edi)
80105693:	89 ca                	mov    %ecx,%edx
80105695:	89 fb                	mov    %edi,%ebx
80105697:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010569a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010569d:	5b                   	pop    %ebx
8010569e:	5f                   	pop    %edi
8010569f:	5d                   	pop    %ebp
801056a0:	c3                   	ret    

801056a1 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801056a1:	55                   	push   %ebp
801056a2:	89 e5                	mov    %esp,%ebp
801056a4:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801056a7:	8b 45 08             	mov    0x8(%ebp),%eax
801056aa:	83 e0 03             	and    $0x3,%eax
801056ad:	85 c0                	test   %eax,%eax
801056af:	75 49                	jne    801056fa <memset+0x59>
801056b1:	8b 45 10             	mov    0x10(%ebp),%eax
801056b4:	83 e0 03             	and    $0x3,%eax
801056b7:	85 c0                	test   %eax,%eax
801056b9:	75 3f                	jne    801056fa <memset+0x59>
    c &= 0xFF;
801056bb:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801056c2:	8b 45 10             	mov    0x10(%ebp),%eax
801056c5:	c1 e8 02             	shr    $0x2,%eax
801056c8:	89 c2                	mov    %eax,%edx
801056ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cd:	c1 e0 18             	shl    $0x18,%eax
801056d0:	89 c1                	mov    %eax,%ecx
801056d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d5:	c1 e0 10             	shl    $0x10,%eax
801056d8:	09 c1                	or     %eax,%ecx
801056da:	8b 45 0c             	mov    0xc(%ebp),%eax
801056dd:	c1 e0 08             	shl    $0x8,%eax
801056e0:	09 c8                	or     %ecx,%eax
801056e2:	0b 45 0c             	or     0xc(%ebp),%eax
801056e5:	89 54 24 08          	mov    %edx,0x8(%esp)
801056e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ed:	8b 45 08             	mov    0x8(%ebp),%eax
801056f0:	89 04 24             	mov    %eax,(%esp)
801056f3:	e8 84 ff ff ff       	call   8010567c <stosl>
801056f8:	eb 19                	jmp    80105713 <memset+0x72>
  } else
    stosb(dst, c, n);
801056fa:	8b 45 10             	mov    0x10(%ebp),%eax
801056fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105701:	8b 45 0c             	mov    0xc(%ebp),%eax
80105704:	89 44 24 04          	mov    %eax,0x4(%esp)
80105708:	8b 45 08             	mov    0x8(%ebp),%eax
8010570b:	89 04 24             	mov    %eax,(%esp)
8010570e:	e8 44 ff ff ff       	call   80105657 <stosb>
  return dst;
80105713:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105716:	c9                   	leave  
80105717:	c3                   	ret    

80105718 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105718:	55                   	push   %ebp
80105719:	89 e5                	mov    %esp,%ebp
8010571b:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010571e:	8b 45 08             	mov    0x8(%ebp),%eax
80105721:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105724:	8b 45 0c             	mov    0xc(%ebp),%eax
80105727:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010572a:	eb 30                	jmp    8010575c <memcmp+0x44>
    if(*s1 != *s2)
8010572c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010572f:	0f b6 10             	movzbl (%eax),%edx
80105732:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105735:	0f b6 00             	movzbl (%eax),%eax
80105738:	38 c2                	cmp    %al,%dl
8010573a:	74 18                	je     80105754 <memcmp+0x3c>
      return *s1 - *s2;
8010573c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010573f:	0f b6 00             	movzbl (%eax),%eax
80105742:	0f b6 d0             	movzbl %al,%edx
80105745:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105748:	0f b6 00             	movzbl (%eax),%eax
8010574b:	0f b6 c0             	movzbl %al,%eax
8010574e:	29 c2                	sub    %eax,%edx
80105750:	89 d0                	mov    %edx,%eax
80105752:	eb 1a                	jmp    8010576e <memcmp+0x56>
    s1++, s2++;
80105754:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105758:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010575c:	8b 45 10             	mov    0x10(%ebp),%eax
8010575f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105762:	89 55 10             	mov    %edx,0x10(%ebp)
80105765:	85 c0                	test   %eax,%eax
80105767:	75 c3                	jne    8010572c <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105769:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    

80105770 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105776:	8b 45 0c             	mov    0xc(%ebp),%eax
80105779:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010577c:	8b 45 08             	mov    0x8(%ebp),%eax
8010577f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105782:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105785:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105788:	73 3d                	jae    801057c7 <memmove+0x57>
8010578a:	8b 45 10             	mov    0x10(%ebp),%eax
8010578d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105790:	01 d0                	add    %edx,%eax
80105792:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105795:	76 30                	jbe    801057c7 <memmove+0x57>
    s += n;
80105797:	8b 45 10             	mov    0x10(%ebp),%eax
8010579a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010579d:	8b 45 10             	mov    0x10(%ebp),%eax
801057a0:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801057a3:	eb 13                	jmp    801057b8 <memmove+0x48>
      *--d = *--s;
801057a5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801057a9:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801057ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057b0:	0f b6 10             	movzbl (%eax),%edx
801057b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057b6:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801057b8:	8b 45 10             	mov    0x10(%ebp),%eax
801057bb:	8d 50 ff             	lea    -0x1(%eax),%edx
801057be:	89 55 10             	mov    %edx,0x10(%ebp)
801057c1:	85 c0                	test   %eax,%eax
801057c3:	75 e0                	jne    801057a5 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801057c5:	eb 26                	jmp    801057ed <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801057c7:	eb 17                	jmp    801057e0 <memmove+0x70>
      *d++ = *s++;
801057c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057cc:	8d 50 01             	lea    0x1(%eax),%edx
801057cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
801057d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057d5:	8d 4a 01             	lea    0x1(%edx),%ecx
801057d8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801057db:	0f b6 12             	movzbl (%edx),%edx
801057de:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801057e0:	8b 45 10             	mov    0x10(%ebp),%eax
801057e3:	8d 50 ff             	lea    -0x1(%eax),%edx
801057e6:	89 55 10             	mov    %edx,0x10(%ebp)
801057e9:	85 c0                	test   %eax,%eax
801057eb:	75 dc                	jne    801057c9 <memmove+0x59>
      *d++ = *s++;

  return dst;
801057ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057f0:	c9                   	leave  
801057f1:	c3                   	ret    

801057f2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801057f2:	55                   	push   %ebp
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801057f8:	8b 45 10             	mov    0x10(%ebp),%eax
801057fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801057ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105802:	89 44 24 04          	mov    %eax,0x4(%esp)
80105806:	8b 45 08             	mov    0x8(%ebp),%eax
80105809:	89 04 24             	mov    %eax,(%esp)
8010580c:	e8 5f ff ff ff       	call   80105770 <memmove>
}
80105811:	c9                   	leave  
80105812:	c3                   	ret    

80105813 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105813:	55                   	push   %ebp
80105814:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105816:	eb 0c                	jmp    80105824 <strncmp+0x11>
    n--, p++, q++;
80105818:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010581c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105820:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105824:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105828:	74 1a                	je     80105844 <strncmp+0x31>
8010582a:	8b 45 08             	mov    0x8(%ebp),%eax
8010582d:	0f b6 00             	movzbl (%eax),%eax
80105830:	84 c0                	test   %al,%al
80105832:	74 10                	je     80105844 <strncmp+0x31>
80105834:	8b 45 08             	mov    0x8(%ebp),%eax
80105837:	0f b6 10             	movzbl (%eax),%edx
8010583a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583d:	0f b6 00             	movzbl (%eax),%eax
80105840:	38 c2                	cmp    %al,%dl
80105842:	74 d4                	je     80105818 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105844:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105848:	75 07                	jne    80105851 <strncmp+0x3e>
    return 0;
8010584a:	b8 00 00 00 00       	mov    $0x0,%eax
8010584f:	eb 16                	jmp    80105867 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105851:	8b 45 08             	mov    0x8(%ebp),%eax
80105854:	0f b6 00             	movzbl (%eax),%eax
80105857:	0f b6 d0             	movzbl %al,%edx
8010585a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585d:	0f b6 00             	movzbl (%eax),%eax
80105860:	0f b6 c0             	movzbl %al,%eax
80105863:	29 c2                	sub    %eax,%edx
80105865:	89 d0                	mov    %edx,%eax
}
80105867:	5d                   	pop    %ebp
80105868:	c3                   	ret    

80105869 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105869:	55                   	push   %ebp
8010586a:	89 e5                	mov    %esp,%ebp
8010586c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010586f:	8b 45 08             	mov    0x8(%ebp),%eax
80105872:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105875:	90                   	nop
80105876:	8b 45 10             	mov    0x10(%ebp),%eax
80105879:	8d 50 ff             	lea    -0x1(%eax),%edx
8010587c:	89 55 10             	mov    %edx,0x10(%ebp)
8010587f:	85 c0                	test   %eax,%eax
80105881:	7e 1e                	jle    801058a1 <strncpy+0x38>
80105883:	8b 45 08             	mov    0x8(%ebp),%eax
80105886:	8d 50 01             	lea    0x1(%eax),%edx
80105889:	89 55 08             	mov    %edx,0x8(%ebp)
8010588c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010588f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105892:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105895:	0f b6 12             	movzbl (%edx),%edx
80105898:	88 10                	mov    %dl,(%eax)
8010589a:	0f b6 00             	movzbl (%eax),%eax
8010589d:	84 c0                	test   %al,%al
8010589f:	75 d5                	jne    80105876 <strncpy+0xd>
    ;
  while(n-- > 0)
801058a1:	eb 0c                	jmp    801058af <strncpy+0x46>
    *s++ = 0;
801058a3:	8b 45 08             	mov    0x8(%ebp),%eax
801058a6:	8d 50 01             	lea    0x1(%eax),%edx
801058a9:	89 55 08             	mov    %edx,0x8(%ebp)
801058ac:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801058af:	8b 45 10             	mov    0x10(%ebp),%eax
801058b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801058b5:	89 55 10             	mov    %edx,0x10(%ebp)
801058b8:	85 c0                	test   %eax,%eax
801058ba:	7f e7                	jg     801058a3 <strncpy+0x3a>
    *s++ = 0;
  return os;
801058bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    

801058c1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801058c1:	55                   	push   %ebp
801058c2:	89 e5                	mov    %esp,%ebp
801058c4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801058c7:	8b 45 08             	mov    0x8(%ebp),%eax
801058ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801058cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058d1:	7f 05                	jg     801058d8 <safestrcpy+0x17>
    return os;
801058d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d6:	eb 31                	jmp    80105909 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801058d8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058e0:	7e 1e                	jle    80105900 <safestrcpy+0x3f>
801058e2:	8b 45 08             	mov    0x8(%ebp),%eax
801058e5:	8d 50 01             	lea    0x1(%eax),%edx
801058e8:	89 55 08             	mov    %edx,0x8(%ebp)
801058eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801058ee:	8d 4a 01             	lea    0x1(%edx),%ecx
801058f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801058f4:	0f b6 12             	movzbl (%edx),%edx
801058f7:	88 10                	mov    %dl,(%eax)
801058f9:	0f b6 00             	movzbl (%eax),%eax
801058fc:	84 c0                	test   %al,%al
801058fe:	75 d8                	jne    801058d8 <safestrcpy+0x17>
    ;
  *s = 0;
80105900:	8b 45 08             	mov    0x8(%ebp),%eax
80105903:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105906:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105909:	c9                   	leave  
8010590a:	c3                   	ret    

8010590b <strlen>:

int
strlen(const char *s)
{
8010590b:	55                   	push   %ebp
8010590c:	89 e5                	mov    %esp,%ebp
8010590e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105911:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105918:	eb 04                	jmp    8010591e <strlen+0x13>
8010591a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010591e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105921:	8b 45 08             	mov    0x8(%ebp),%eax
80105924:	01 d0                	add    %edx,%eax
80105926:	0f b6 00             	movzbl (%eax),%eax
80105929:	84 c0                	test   %al,%al
8010592b:	75 ed                	jne    8010591a <strlen+0xf>
    ;
  return n;
8010592d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105930:	c9                   	leave  
80105931:	c3                   	ret    

80105932 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105932:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105936:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010593a:	55                   	push   %ebp
  pushl %ebx
8010593b:	53                   	push   %ebx
  pushl %esi
8010593c:	56                   	push   %esi
  pushl %edi
8010593d:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010593e:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105940:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105942:	5f                   	pop    %edi
  popl %esi
80105943:	5e                   	pop    %esi
  popl %ebx
80105944:	5b                   	pop    %ebx
  popl %ebp
80105945:	5d                   	pop    %ebp
  ret
80105946:	c3                   	ret    

80105947 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105947:	55                   	push   %ebp
80105948:	89 e5                	mov    %esp,%ebp
8010594a:	83 ec 18             	sub    $0x18,%esp
  if(addr >= proc->sz || addr+4 > proc->sz || addr == 0) {
8010594d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105953:	8b 00                	mov    (%eax),%eax
80105955:	3b 45 08             	cmp    0x8(%ebp),%eax
80105958:	76 18                	jbe    80105972 <fetchint+0x2b>
8010595a:	8b 45 08             	mov    0x8(%ebp),%eax
8010595d:	8d 50 04             	lea    0x4(%eax),%edx
80105960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105966:	8b 00                	mov    (%eax),%eax
80105968:	39 c2                	cmp    %eax,%edx
8010596a:	77 06                	ja     80105972 <fetchint+0x2b>
8010596c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105970:	75 19                	jne    8010598b <fetchint+0x44>
    if (addr == 0) cprintf("fetchint NULL ptr\n");
80105972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105976:	75 0c                	jne    80105984 <fetchint+0x3d>
80105978:	c7 04 24 e5 90 10 80 	movl   $0x801090e5,(%esp)
8010597f:	e8 1c aa ff ff       	call   801003a0 <cprintf>
    return -1;
80105984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105989:	eb 0f                	jmp    8010599a <fetchint+0x53>
  }
  *ip = *(int*)(addr);
8010598b:	8b 45 08             	mov    0x8(%ebp),%eax
8010598e:	8b 10                	mov    (%eax),%edx
80105990:	8b 45 0c             	mov    0xc(%ebp),%eax
80105993:	89 10                	mov    %edx,(%eax)
  return 0;
80105995:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010599a:	c9                   	leave  
8010599b:	c3                   	ret    

8010599c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010599c:	55                   	push   %ebp
8010599d:	89 e5                	mov    %esp,%ebp
8010599f:	83 ec 28             	sub    $0x28,%esp
  char *s, *ep;

  if(addr >= proc->sz || addr == 0) {
801059a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059a8:	8b 00                	mov    (%eax),%eax
801059aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801059ad:	76 06                	jbe    801059b5 <fetchstr+0x19>
801059af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801059b3:	75 19                	jne    801059ce <fetchstr+0x32>
    if (addr == 0) cprintf("fetchstr NULL ptr\n");
801059b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801059b9:	75 0c                	jne    801059c7 <fetchstr+0x2b>
801059bb:	c7 04 24 f8 90 10 80 	movl   $0x801090f8,(%esp)
801059c2:	e8 d9 a9 ff ff       	call   801003a0 <cprintf>
    return -1;
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	eb 46                	jmp    80105a14 <fetchstr+0x78>
  }
  *pp = (char*)addr;
801059ce:	8b 55 08             	mov    0x8(%ebp),%edx
801059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d4:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801059d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059dc:	8b 00                	mov    (%eax),%eax
801059de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(s = *pp; s < ep; s++)
801059e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059e4:	8b 00                	mov    (%eax),%eax
801059e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e9:	eb 1c                	jmp    80105a07 <fetchstr+0x6b>
    if(*s == 0)
801059eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ee:	0f b6 00             	movzbl (%eax),%eax
801059f1:	84 c0                	test   %al,%al
801059f3:	75 0e                	jne    80105a03 <fetchstr+0x67>
      return s - *pp;
801059f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059fb:	8b 00                	mov    (%eax),%eax
801059fd:	29 c2                	sub    %eax,%edx
801059ff:	89 d0                	mov    %edx,%eax
80105a01:	eb 11                	jmp    80105a14 <fetchstr+0x78>
    if (addr == 0) cprintf("fetchstr NULL ptr\n");
    return -1;
  }
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105a03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105a0d:	72 dc                	jb     801059eb <fetchstr+0x4f>
    if(*s == 0)
      return s - *pp;
  return -1;
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a14:	c9                   	leave  
80105a15:	c3                   	ret    

80105a16 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a16:	55                   	push   %ebp
80105a17:	89 e5                	mov    %esp,%ebp
80105a19:	83 ec 18             	sub    $0x18,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105a1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a22:	8b 40 18             	mov    0x18(%eax),%eax
80105a25:	8b 50 44             	mov    0x44(%eax),%edx
80105a28:	8b 45 08             	mov    0x8(%ebp),%eax
80105a2b:	c1 e0 02             	shl    $0x2,%eax
80105a2e:	01 d0                	add    %edx,%eax
80105a30:	8d 50 04             	lea    0x4(%eax),%edx
80105a33:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a3a:	89 14 24             	mov    %edx,(%esp)
80105a3d:	e8 05 ff ff ff       	call   80105947 <fetchint>
}
80105a42:	c9                   	leave  
80105a43:	c3                   	ret    

80105a44 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105a4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a51:	8b 45 08             	mov    0x8(%ebp),%eax
80105a54:	89 04 24             	mov    %eax,(%esp)
80105a57:	e8 ba ff ff ff       	call   80105a16 <argint>
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	79 07                	jns    80105a67 <argptr+0x23>
    return -1;
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a65:	eb 57                	jmp    80105abe <argptr+0x7a>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz || (uint)i == 0) {
80105a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6a:	89 c2                	mov    %eax,%edx
80105a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a72:	8b 00                	mov    (%eax),%eax
80105a74:	39 c2                	cmp    %eax,%edx
80105a76:	73 1d                	jae    80105a95 <argptr+0x51>
80105a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7b:	89 c2                	mov    %eax,%edx
80105a7d:	8b 45 10             	mov    0x10(%ebp),%eax
80105a80:	01 c2                	add    %eax,%edx
80105a82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a88:	8b 00                	mov    (%eax),%eax
80105a8a:	39 c2                	cmp    %eax,%edx
80105a8c:	77 07                	ja     80105a95 <argptr+0x51>
80105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a91:	85 c0                	test   %eax,%eax
80105a93:	75 1a                	jne    80105aaf <argptr+0x6b>
    if ((uint)i == 0) cprintf("argptr NULL ptr\n");
80105a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	75 0c                	jne    80105aa8 <argptr+0x64>
80105a9c:	c7 04 24 0b 91 10 80 	movl   $0x8010910b,(%esp)
80105aa3:	e8 f8 a8 ff ff       	call   801003a0 <cprintf>
    return -1;
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aad:	eb 0f                	jmp    80105abe <argptr+0x7a>
  }
  *pp = (char*)i;
80105aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab2:	89 c2                	mov    %eax,%edx
80105ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ab7:	89 10                	mov    %edx,(%eax)
  return 0;
80105ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105abe:	c9                   	leave  
80105abf:	c3                   	ret    

80105ac0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105acd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad0:	89 04 24             	mov    %eax,(%esp)
80105ad3:	e8 3e ff ff ff       	call   80105a16 <argint>
80105ad8:	85 c0                	test   %eax,%eax
80105ada:	79 07                	jns    80105ae3 <argstr+0x23>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae1:	eb 12                	jmp    80105af5 <argstr+0x35>
  return fetchstr(addr, pp);
80105ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80105aed:	89 04 24             	mov    %eax,(%esp)
80105af0:	e8 a7 fe ff ff       	call   8010599c <fetchstr>
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    

80105af7 <syscall>:
[SYS_thread_yield3] sys_thread_yield3,
};

void
syscall(void)
{
80105af7:	55                   	push   %ebp
80105af8:	89 e5                	mov    %esp,%ebp
80105afa:	53                   	push   %ebx
80105afb:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105afe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b04:	8b 40 18             	mov    0x18(%eax),%eax
80105b07:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b11:	7e 30                	jle    80105b43 <syscall+0x4c>
80105b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b16:	83 f8 1a             	cmp    $0x1a,%eax
80105b19:	77 28                	ja     80105b43 <syscall+0x4c>
80105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b25:	85 c0                	test   %eax,%eax
80105b27:	74 1a                	je     80105b43 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105b29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b2f:	8b 58 18             	mov    0x18(%eax),%ebx
80105b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b35:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b3c:	ff d0                	call   *%eax
80105b3e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105b41:	eb 3d                	jmp    80105b80 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105b43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b49:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105b4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105b52:	8b 40 10             	mov    0x10(%eax),%eax
80105b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b58:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105b5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105b60:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b64:	c7 04 24 1c 91 10 80 	movl   $0x8010911c,(%esp)
80105b6b:	e8 30 a8 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105b70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b76:	8b 40 18             	mov    0x18(%eax),%eax
80105b79:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105b80:	83 c4 24             	add    $0x24,%esp
80105b83:	5b                   	pop    %ebx
80105b84:	5d                   	pop    %ebp
80105b85:	c3                   	ret    

80105b86 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105b86:	55                   	push   %ebp
80105b87:	89 e5                	mov    %esp,%ebp
80105b89:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105b8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b93:	8b 45 08             	mov    0x8(%ebp),%eax
80105b96:	89 04 24             	mov    %eax,(%esp)
80105b99:	e8 78 fe ff ff       	call   80105a16 <argint>
80105b9e:	85 c0                	test   %eax,%eax
80105ba0:	79 07                	jns    80105ba9 <argfd+0x23>
    return -1;
80105ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba7:	eb 50                	jmp    80105bf9 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	85 c0                	test   %eax,%eax
80105bae:	78 21                	js     80105bd1 <argfd+0x4b>
80105bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb3:	83 f8 0f             	cmp    $0xf,%eax
80105bb6:	7f 19                	jg     80105bd1 <argfd+0x4b>
80105bb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bc1:	83 c2 08             	add    $0x8,%edx
80105bc4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bcf:	75 07                	jne    80105bd8 <argfd+0x52>
    return -1;
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	eb 21                	jmp    80105bf9 <argfd+0x73>
  if(pfd)
80105bd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105bdc:	74 08                	je     80105be6 <argfd+0x60>
    *pfd = fd;
80105bde:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be4:	89 10                	mov    %edx,(%eax)
  if(pf)
80105be6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bea:	74 08                	je     80105bf4 <argfd+0x6e>
    *pf = f;
80105bec:	8b 45 10             	mov    0x10(%ebp),%eax
80105bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bf2:	89 10                	mov    %edx,(%eax)
  return 0;
80105bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bf9:	c9                   	leave  
80105bfa:	c3                   	ret    

80105bfb <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105bfb:	55                   	push   %ebp
80105bfc:	89 e5                	mov    %esp,%ebp
80105bfe:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c08:	eb 30                	jmp    80105c3a <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c10:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c13:	83 c2 08             	add    $0x8,%edx
80105c16:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	75 18                	jne    80105c36 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c24:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c27:	8d 4a 08             	lea    0x8(%edx),%ecx
80105c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80105c2d:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c34:	eb 0f                	jmp    80105c45 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c36:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c3a:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105c3e:	7e ca                	jle    80105c0a <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c45:	c9                   	leave  
80105c46:	c3                   	ret    

80105c47 <sys_dup>:

int
sys_dup(void)
{
80105c47:	55                   	push   %ebp
80105c48:	89 e5                	mov    %esp,%ebp
80105c4a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105c4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c5b:	00 
80105c5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c63:	e8 1e ff ff ff       	call   80105b86 <argfd>
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	79 07                	jns    80105c73 <sys_dup+0x2c>
    return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	eb 29                	jmp    80105c9c <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c76:	89 04 24             	mov    %eax,(%esp)
80105c79:	e8 7d ff ff ff       	call   80105bfb <fdalloc>
80105c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c85:	79 07                	jns    80105c8e <sys_dup+0x47>
    return -1;
80105c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8c:	eb 0e                	jmp    80105c9c <sys_dup+0x55>
  filedup(f);
80105c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c91:	89 04 24             	mov    %eax,(%esp)
80105c94:	e8 3d b3 ff ff       	call   80100fd6 <filedup>
  return fd;
80105c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105c9c:	c9                   	leave  
80105c9d:	c3                   	ret    

80105c9e <sys_read>:

int
sys_read(void)
{
80105c9e:	55                   	push   %ebp
80105c9f:	89 e5                	mov    %esp,%ebp
80105ca1:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cb2:	00 
80105cb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cba:	e8 c7 fe ff ff       	call   80105b86 <argfd>
80105cbf:	85 c0                	test   %eax,%eax
80105cc1:	78 35                	js     80105cf8 <sys_read+0x5a>
80105cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105cd1:	e8 40 fd ff ff       	call   80105a16 <argint>
80105cd6:	85 c0                	test   %eax,%eax
80105cd8:	78 1e                	js     80105cf8 <sys_read+0x5a>
80105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ce1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105cef:	e8 50 fd ff ff       	call   80105a44 <argptr>
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	79 07                	jns    80105cff <sys_read+0x61>
    return -1;
80105cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfd:	eb 19                	jmp    80105d18 <sys_read+0x7a>
  return fileread(f, p, n);
80105cff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d08:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d10:	89 04 24             	mov    %eax,(%esp)
80105d13:	e8 2b b4 ff ff       	call   80101143 <fileread>
}
80105d18:	c9                   	leave  
80105d19:	c3                   	ret    

80105d1a <sys_write>:

int
sys_write(void)
{
80105d1a:	55                   	push   %ebp
80105d1b:	89 e5                	mov    %esp,%ebp
80105d1d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d2e:	00 
80105d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d36:	e8 4b fe ff ff       	call   80105b86 <argfd>
80105d3b:	85 c0                	test   %eax,%eax
80105d3d:	78 35                	js     80105d74 <sys_write+0x5a>
80105d3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d46:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d4d:	e8 c4 fc ff ff       	call   80105a16 <argint>
80105d52:	85 c0                	test   %eax,%eax
80105d54:	78 1e                	js     80105d74 <sys_write+0x5a>
80105d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d59:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d60:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d6b:	e8 d4 fc ff ff       	call   80105a44 <argptr>
80105d70:	85 c0                	test   %eax,%eax
80105d72:	79 07                	jns    80105d7b <sys_write+0x61>
    return -1;
80105d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d79:	eb 19                	jmp    80105d94 <sys_write+0x7a>
  return filewrite(f, p, n);
80105d7b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d88:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d8c:	89 04 24             	mov    %eax,(%esp)
80105d8f:	e8 6b b4 ff ff       	call   801011ff <filewrite>
}
80105d94:	c9                   	leave  
80105d95:	c3                   	ret    

80105d96 <sys_close>:

int
sys_close(void)
{
80105d96:	55                   	push   %ebp
80105d97:	89 e5                	mov    %esp,%ebp
80105d99:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105d9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105daa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105db1:	e8 d0 fd ff ff       	call   80105b86 <argfd>
80105db6:	85 c0                	test   %eax,%eax
80105db8:	79 07                	jns    80105dc1 <sys_close+0x2b>
    return -1;
80105dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbf:	eb 24                	jmp    80105de5 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105dc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dca:	83 c2 08             	add    $0x8,%edx
80105dcd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dd4:	00 
  fileclose(f);
80105dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd8:	89 04 24             	mov    %eax,(%esp)
80105ddb:	e8 3e b2 ff ff       	call   8010101e <fileclose>
  return 0;
80105de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    

80105de7 <sys_fstat>:

int
sys_fstat(void)
{
80105de7:	55                   	push   %ebp
80105de8:	89 e5                	mov    %esp,%ebp
80105dea:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105df0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105df4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105dfb:	00 
80105dfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e03:	e8 7e fd ff ff       	call   80105b86 <argfd>
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	78 1f                	js     80105e2b <sys_fstat+0x44>
80105e0c:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105e13:	00 
80105e14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e17:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e22:	e8 1d fc ff ff       	call   80105a44 <argptr>
80105e27:	85 c0                	test   %eax,%eax
80105e29:	79 07                	jns    80105e32 <sys_fstat+0x4b>
    return -1;
80105e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e30:	eb 12                	jmp    80105e44 <sys_fstat+0x5d>
  return filestat(f, st);
80105e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e38:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e3c:	89 04 24             	mov    %eax,(%esp)
80105e3f:	e8 b0 b2 ff ff       	call   801010f4 <filestat>
}
80105e44:	c9                   	leave  
80105e45:	c3                   	ret    

80105e46 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e46:	55                   	push   %ebp
80105e47:	89 e5                	mov    %esp,%ebp
80105e49:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e4c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e5a:	e8 61 fc ff ff       	call   80105ac0 <argstr>
80105e5f:	85 c0                	test   %eax,%eax
80105e61:	78 17                	js     80105e7a <sys_link+0x34>
80105e63:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e71:	e8 4a fc ff ff       	call   80105ac0 <argstr>
80105e76:	85 c0                	test   %eax,%eax
80105e78:	79 0a                	jns    80105e84 <sys_link+0x3e>
    return -1;
80105e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7f:	e9 3d 01 00 00       	jmp    80105fc1 <sys_link+0x17b>
  if((ip = namei(old)) == 0)
80105e84:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105e87:	89 04 24             	mov    %eax,(%esp)
80105e8a:	e8 c7 c5 ff ff       	call   80102456 <namei>
80105e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e96:	75 0a                	jne    80105ea2 <sys_link+0x5c>
    return -1;
80105e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9d:	e9 1f 01 00 00       	jmp    80105fc1 <sys_link+0x17b>

  begin_trans();
80105ea2:	e8 74 d4 ff ff       	call   8010331b <begin_trans>

  ilock(ip);
80105ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eaa:	89 04 24             	mov    %eax,(%esp)
80105ead:	e8 f9 b9 ff ff       	call   801018ab <ilock>
  if(ip->type == T_DIR){
80105eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105eb9:	66 83 f8 01          	cmp    $0x1,%ax
80105ebd:	75 1a                	jne    80105ed9 <sys_link+0x93>
    iunlockput(ip);
80105ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec2:	89 04 24             	mov    %eax,(%esp)
80105ec5:	e8 65 bc ff ff       	call   80101b2f <iunlockput>
    commit_trans();
80105eca:	e8 95 d4 ff ff       	call   80103364 <commit_trans>
    return -1;
80105ecf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed4:	e9 e8 00 00 00       	jmp    80105fc1 <sys_link+0x17b>
  }

  ip->nlink++;
80105ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ee0:	8d 50 01             	lea    0x1(%eax),%edx
80105ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee6:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eed:	89 04 24             	mov    %eax,(%esp)
80105ef0:	e8 fa b7 ff ff       	call   801016ef <iupdate>
  iunlock(ip);
80105ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef8:	89 04 24             	mov    %eax,(%esp)
80105efb:	e8 f9 ba ff ff       	call   801019f9 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f03:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f06:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f0a:	89 04 24             	mov    %eax,(%esp)
80105f0d:	e8 66 c5 ff ff       	call   80102478 <nameiparent>
80105f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f19:	75 02                	jne    80105f1d <sys_link+0xd7>
    goto bad;
80105f1b:	eb 68                	jmp    80105f85 <sys_link+0x13f>
  ilock(dp);
80105f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f20:	89 04 24             	mov    %eax,(%esp)
80105f23:	e8 83 b9 ff ff       	call   801018ab <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2b:	8b 10                	mov    (%eax),%edx
80105f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f30:	8b 00                	mov    (%eax),%eax
80105f32:	39 c2                	cmp    %eax,%edx
80105f34:	75 20                	jne    80105f56 <sys_link+0x110>
80105f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f39:	8b 40 04             	mov    0x4(%eax),%eax
80105f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f40:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105f43:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4a:	89 04 24             	mov    %eax,(%esp)
80105f4d:	e8 44 c2 ff ff       	call   80102196 <dirlink>
80105f52:	85 c0                	test   %eax,%eax
80105f54:	79 0d                	jns    80105f63 <sys_link+0x11d>
    iunlockput(dp);
80105f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f59:	89 04 24             	mov    %eax,(%esp)
80105f5c:	e8 ce bb ff ff       	call   80101b2f <iunlockput>
    goto bad;
80105f61:	eb 22                	jmp    80105f85 <sys_link+0x13f>
  }
  iunlockput(dp);
80105f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f66:	89 04 24             	mov    %eax,(%esp)
80105f69:	e8 c1 bb ff ff       	call   80101b2f <iunlockput>
  iput(ip);
80105f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f71:	89 04 24             	mov    %eax,(%esp)
80105f74:	e8 e5 ba ff ff       	call   80101a5e <iput>

  commit_trans();
80105f79:	e8 e6 d3 ff ff       	call   80103364 <commit_trans>

  return 0;
80105f7e:	b8 00 00 00 00       	mov    $0x0,%eax
80105f83:	eb 3c                	jmp    80105fc1 <sys_link+0x17b>

bad:
  ilock(ip);
80105f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f88:	89 04 24             	mov    %eax,(%esp)
80105f8b:	e8 1b b9 ff ff       	call   801018ab <ilock>
  ip->nlink--;
80105f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f93:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f97:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa4:	89 04 24             	mov    %eax,(%esp)
80105fa7:	e8 43 b7 ff ff       	call   801016ef <iupdate>
  iunlockput(ip);
80105fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105faf:	89 04 24             	mov    %eax,(%esp)
80105fb2:	e8 78 bb ff ff       	call   80101b2f <iunlockput>
  commit_trans();
80105fb7:	e8 a8 d3 ff ff       	call   80103364 <commit_trans>
  return -1;
80105fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc1:	c9                   	leave  
80105fc2:	c3                   	ret    

80105fc3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105fc3:	55                   	push   %ebp
80105fc4:	89 e5                	mov    %esp,%ebp
80105fc6:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105fc9:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105fd0:	eb 4b                	jmp    8010601d <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd5:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105fdc:	00 
80105fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fe1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80105feb:	89 04 24             	mov    %eax,(%esp)
80105fee:	e8 c5 bd ff ff       	call   80101db8 <readi>
80105ff3:	83 f8 10             	cmp    $0x10,%eax
80105ff6:	74 0c                	je     80106004 <isdirempty+0x41>
      panic("isdirempty: readi");
80105ff8:	c7 04 24 38 91 10 80 	movl   $0x80109138,(%esp)
80105fff:	e8 36 a5 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80106004:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106008:	66 85 c0             	test   %ax,%ax
8010600b:	74 07                	je     80106014 <isdirempty+0x51>
      return 0;
8010600d:	b8 00 00 00 00       	mov    $0x0,%eax
80106012:	eb 1b                	jmp    8010602f <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106017:	83 c0 10             	add    $0x10,%eax
8010601a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010601d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106020:	8b 45 08             	mov    0x8(%ebp),%eax
80106023:	8b 40 18             	mov    0x18(%eax),%eax
80106026:	39 c2                	cmp    %eax,%edx
80106028:	72 a8                	jb     80105fd2 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010602a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010602f:	c9                   	leave  
80106030:	c3                   	ret    

80106031 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106031:	55                   	push   %ebp
80106032:	89 e5                	mov    %esp,%ebp
80106034:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106037:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010603a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010603e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106045:	e8 76 fa ff ff       	call   80105ac0 <argstr>
8010604a:	85 c0                	test   %eax,%eax
8010604c:	79 0a                	jns    80106058 <sys_unlink+0x27>
    return -1;
8010604e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106053:	e9 aa 01 00 00       	jmp    80106202 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80106058:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010605b:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010605e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106062:	89 04 24             	mov    %eax,(%esp)
80106065:	e8 0e c4 ff ff       	call   80102478 <nameiparent>
8010606a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106071:	75 0a                	jne    8010607d <sys_unlink+0x4c>
    return -1;
80106073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106078:	e9 85 01 00 00       	jmp    80106202 <sys_unlink+0x1d1>

  begin_trans();
8010607d:	e8 99 d2 ff ff       	call   8010331b <begin_trans>

  ilock(dp);
80106082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106085:	89 04 24             	mov    %eax,(%esp)
80106088:	e8 1e b8 ff ff       	call   801018ab <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010608d:	c7 44 24 04 4a 91 10 	movl   $0x8010914a,0x4(%esp)
80106094:	80 
80106095:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106098:	89 04 24             	mov    %eax,(%esp)
8010609b:	e8 0b c0 ff ff       	call   801020ab <namecmp>
801060a0:	85 c0                	test   %eax,%eax
801060a2:	0f 84 45 01 00 00    	je     801061ed <sys_unlink+0x1bc>
801060a8:	c7 44 24 04 4c 91 10 	movl   $0x8010914c,0x4(%esp)
801060af:	80 
801060b0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060b3:	89 04 24             	mov    %eax,(%esp)
801060b6:	e8 f0 bf ff ff       	call   801020ab <namecmp>
801060bb:	85 c0                	test   %eax,%eax
801060bd:	0f 84 2a 01 00 00    	je     801061ed <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801060c3:	8d 45 c8             	lea    -0x38(%ebp),%eax
801060c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801060ca:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d4:	89 04 24             	mov    %eax,(%esp)
801060d7:	e8 f1 bf ff ff       	call   801020cd <dirlookup>
801060dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060e3:	75 05                	jne    801060ea <sys_unlink+0xb9>
    goto bad;
801060e5:	e9 03 01 00 00       	jmp    801061ed <sys_unlink+0x1bc>
  ilock(ip);
801060ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ed:	89 04 24             	mov    %eax,(%esp)
801060f0:	e8 b6 b7 ff ff       	call   801018ab <ilock>

  if(ip->nlink < 1)
801060f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060fc:	66 85 c0             	test   %ax,%ax
801060ff:	7f 0c                	jg     8010610d <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80106101:	c7 04 24 4f 91 10 80 	movl   $0x8010914f,(%esp)
80106108:	e8 2d a4 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010610d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106110:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106114:	66 83 f8 01          	cmp    $0x1,%ax
80106118:	75 1f                	jne    80106139 <sys_unlink+0x108>
8010611a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611d:	89 04 24             	mov    %eax,(%esp)
80106120:	e8 9e fe ff ff       	call   80105fc3 <isdirempty>
80106125:	85 c0                	test   %eax,%eax
80106127:	75 10                	jne    80106139 <sys_unlink+0x108>
    iunlockput(ip);
80106129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612c:	89 04 24             	mov    %eax,(%esp)
8010612f:	e8 fb b9 ff ff       	call   80101b2f <iunlockput>
    goto bad;
80106134:	e9 b4 00 00 00       	jmp    801061ed <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80106139:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106140:	00 
80106141:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106148:	00 
80106149:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010614c:	89 04 24             	mov    %eax,(%esp)
8010614f:	e8 4d f5 ff ff       	call   801056a1 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106154:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106157:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010615e:	00 
8010615f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106163:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010616a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616d:	89 04 24             	mov    %eax,(%esp)
80106170:	e8 a7 bd ff ff       	call   80101f1c <writei>
80106175:	83 f8 10             	cmp    $0x10,%eax
80106178:	74 0c                	je     80106186 <sys_unlink+0x155>
    panic("unlink: writei");
8010617a:	c7 04 24 61 91 10 80 	movl   $0x80109161,(%esp)
80106181:	e8 b4 a3 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80106186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106189:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010618d:	66 83 f8 01          	cmp    $0x1,%ax
80106191:	75 1c                	jne    801061af <sys_unlink+0x17e>
    dp->nlink--;
80106193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106196:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010619a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010619d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801061a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a7:	89 04 24             	mov    %eax,(%esp)
801061aa:	e8 40 b5 ff ff       	call   801016ef <iupdate>
  }
  iunlockput(dp);
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	89 04 24             	mov    %eax,(%esp)
801061b5:	e8 75 b9 ff ff       	call   80101b2f <iunlockput>

  ip->nlink--;
801061ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061bd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801061c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801061c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801061cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ce:	89 04 24             	mov    %eax,(%esp)
801061d1:	e8 19 b5 ff ff       	call   801016ef <iupdate>
  iunlockput(ip);
801061d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d9:	89 04 24             	mov    %eax,(%esp)
801061dc:	e8 4e b9 ff ff       	call   80101b2f <iunlockput>

  commit_trans();
801061e1:	e8 7e d1 ff ff       	call   80103364 <commit_trans>

  return 0;
801061e6:	b8 00 00 00 00       	mov    $0x0,%eax
801061eb:	eb 15                	jmp    80106202 <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
801061ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f0:	89 04 24             	mov    %eax,(%esp)
801061f3:	e8 37 b9 ff ff       	call   80101b2f <iunlockput>
  commit_trans();
801061f8:	e8 67 d1 ff ff       	call   80103364 <commit_trans>
  return -1;
801061fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106202:	c9                   	leave  
80106203:	c3                   	ret    

80106204 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106204:	55                   	push   %ebp
80106205:	89 e5                	mov    %esp,%ebp
80106207:	83 ec 48             	sub    $0x48,%esp
8010620a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010620d:	8b 55 10             	mov    0x10(%ebp),%edx
80106210:	8b 45 14             	mov    0x14(%ebp),%eax
80106213:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106217:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010621b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010621f:	8d 45 de             	lea    -0x22(%ebp),%eax
80106222:	89 44 24 04          	mov    %eax,0x4(%esp)
80106226:	8b 45 08             	mov    0x8(%ebp),%eax
80106229:	89 04 24             	mov    %eax,(%esp)
8010622c:	e8 47 c2 ff ff       	call   80102478 <nameiparent>
80106231:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106238:	75 0a                	jne    80106244 <create+0x40>
    return 0;
8010623a:	b8 00 00 00 00       	mov    $0x0,%eax
8010623f:	e9 7e 01 00 00       	jmp    801063c2 <create+0x1be>
  ilock(dp);
80106244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106247:	89 04 24             	mov    %eax,(%esp)
8010624a:	e8 5c b6 ff ff       	call   801018ab <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010624f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106252:	89 44 24 08          	mov    %eax,0x8(%esp)
80106256:	8d 45 de             	lea    -0x22(%ebp),%eax
80106259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010625d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106260:	89 04 24             	mov    %eax,(%esp)
80106263:	e8 65 be ff ff       	call   801020cd <dirlookup>
80106268:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010626b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010626f:	74 47                	je     801062b8 <create+0xb4>
    iunlockput(dp);
80106271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106274:	89 04 24             	mov    %eax,(%esp)
80106277:	e8 b3 b8 ff ff       	call   80101b2f <iunlockput>
    ilock(ip);
8010627c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627f:	89 04 24             	mov    %eax,(%esp)
80106282:	e8 24 b6 ff ff       	call   801018ab <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106287:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010628c:	75 15                	jne    801062a3 <create+0x9f>
8010628e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106291:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106295:	66 83 f8 02          	cmp    $0x2,%ax
80106299:	75 08                	jne    801062a3 <create+0x9f>
      return ip;
8010629b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010629e:	e9 1f 01 00 00       	jmp    801063c2 <create+0x1be>
    iunlockput(ip);
801062a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a6:	89 04 24             	mov    %eax,(%esp)
801062a9:	e8 81 b8 ff ff       	call   80101b2f <iunlockput>
    return 0;
801062ae:	b8 00 00 00 00       	mov    $0x0,%eax
801062b3:	e9 0a 01 00 00       	jmp    801063c2 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801062b8:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801062bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062bf:	8b 00                	mov    (%eax),%eax
801062c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801062c5:	89 04 24             	mov    %eax,(%esp)
801062c8:	e8 43 b3 ff ff       	call   80101610 <ialloc>
801062cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d4:	75 0c                	jne    801062e2 <create+0xde>
    panic("create: ialloc");
801062d6:	c7 04 24 70 91 10 80 	movl   $0x80109170,(%esp)
801062dd:	e8 58 a2 ff ff       	call   8010053a <panic>

  ilock(ip);
801062e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e5:	89 04 24             	mov    %eax,(%esp)
801062e8:	e8 be b5 ff ff       	call   801018ab <ilock>
  ip->major = major;
801062ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f0:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801062f4:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801062f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fb:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801062ff:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106303:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106306:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010630c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630f:	89 04 24             	mov    %eax,(%esp)
80106312:	e8 d8 b3 ff ff       	call   801016ef <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106317:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010631c:	75 6a                	jne    80106388 <create+0x184>
    dp->nlink++;  // for ".."
8010631e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106321:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106325:	8d 50 01             	lea    0x1(%eax),%edx
80106328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632b:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010632f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106332:	89 04 24             	mov    %eax,(%esp)
80106335:	e8 b5 b3 ff ff       	call   801016ef <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010633a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633d:	8b 40 04             	mov    0x4(%eax),%eax
80106340:	89 44 24 08          	mov    %eax,0x8(%esp)
80106344:	c7 44 24 04 4a 91 10 	movl   $0x8010914a,0x4(%esp)
8010634b:	80 
8010634c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634f:	89 04 24             	mov    %eax,(%esp)
80106352:	e8 3f be ff ff       	call   80102196 <dirlink>
80106357:	85 c0                	test   %eax,%eax
80106359:	78 21                	js     8010637c <create+0x178>
8010635b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010635e:	8b 40 04             	mov    0x4(%eax),%eax
80106361:	89 44 24 08          	mov    %eax,0x8(%esp)
80106365:	c7 44 24 04 4c 91 10 	movl   $0x8010914c,0x4(%esp)
8010636c:	80 
8010636d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106370:	89 04 24             	mov    %eax,(%esp)
80106373:	e8 1e be ff ff       	call   80102196 <dirlink>
80106378:	85 c0                	test   %eax,%eax
8010637a:	79 0c                	jns    80106388 <create+0x184>
      panic("create dots");
8010637c:	c7 04 24 7f 91 10 80 	movl   $0x8010917f,(%esp)
80106383:	e8 b2 a1 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010638b:	8b 40 04             	mov    0x4(%eax),%eax
8010638e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106392:	8d 45 de             	lea    -0x22(%ebp),%eax
80106395:	89 44 24 04          	mov    %eax,0x4(%esp)
80106399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639c:	89 04 24             	mov    %eax,(%esp)
8010639f:	e8 f2 bd ff ff       	call   80102196 <dirlink>
801063a4:	85 c0                	test   %eax,%eax
801063a6:	79 0c                	jns    801063b4 <create+0x1b0>
    panic("create: dirlink");
801063a8:	c7 04 24 8b 91 10 80 	movl   $0x8010918b,(%esp)
801063af:	e8 86 a1 ff ff       	call   8010053a <panic>

  iunlockput(dp);
801063b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b7:	89 04 24             	mov    %eax,(%esp)
801063ba:	e8 70 b7 ff ff       	call   80101b2f <iunlockput>

  return ip;
801063bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801063c2:	c9                   	leave  
801063c3:	c3                   	ret    

801063c4 <sys_open>:

int
sys_open(void)
{
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801063ca:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801063d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063d8:	e8 e3 f6 ff ff       	call   80105ac0 <argstr>
801063dd:	85 c0                	test   %eax,%eax
801063df:	78 17                	js     801063f8 <sys_open+0x34>
801063e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801063e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801063ef:	e8 22 f6 ff ff       	call   80105a16 <argint>
801063f4:	85 c0                	test   %eax,%eax
801063f6:	79 0a                	jns    80106402 <sys_open+0x3e>
    return -1;
801063f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fd:	e9 48 01 00 00       	jmp    8010654a <sys_open+0x186>
  if(omode & O_CREATE){
80106402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106405:	25 00 02 00 00       	and    $0x200,%eax
8010640a:	85 c0                	test   %eax,%eax
8010640c:	74 40                	je     8010644e <sys_open+0x8a>
    begin_trans();
8010640e:	e8 08 cf ff ff       	call   8010331b <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106413:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106416:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010641d:	00 
8010641e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106425:	00 
80106426:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010642d:	00 
8010642e:	89 04 24             	mov    %eax,(%esp)
80106431:	e8 ce fd ff ff       	call   80106204 <create>
80106436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80106439:	e8 26 cf ff ff       	call   80103364 <commit_trans>
    if(ip == 0)
8010643e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106442:	75 5c                	jne    801064a0 <sys_open+0xdc>
      return -1;
80106444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106449:	e9 fc 00 00 00       	jmp    8010654a <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
8010644e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106451:	89 04 24             	mov    %eax,(%esp)
80106454:	e8 fd bf ff ff       	call   80102456 <namei>
80106459:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010645c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106460:	75 0a                	jne    8010646c <sys_open+0xa8>
      return -1;
80106462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106467:	e9 de 00 00 00       	jmp    8010654a <sys_open+0x186>
    ilock(ip);
8010646c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646f:	89 04 24             	mov    %eax,(%esp)
80106472:	e8 34 b4 ff ff       	call   801018ab <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010647a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010647e:	66 83 f8 01          	cmp    $0x1,%ax
80106482:	75 1c                	jne    801064a0 <sys_open+0xdc>
80106484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106487:	85 c0                	test   %eax,%eax
80106489:	74 15                	je     801064a0 <sys_open+0xdc>
      iunlockput(ip);
8010648b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648e:	89 04 24             	mov    %eax,(%esp)
80106491:	e8 99 b6 ff ff       	call   80101b2f <iunlockput>
      return -1;
80106496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649b:	e9 aa 00 00 00       	jmp    8010654a <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801064a0:	e8 d1 aa ff ff       	call   80100f76 <filealloc>
801064a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064ac:	74 14                	je     801064c2 <sys_open+0xfe>
801064ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b1:	89 04 24             	mov    %eax,(%esp)
801064b4:	e8 42 f7 ff ff       	call   80105bfb <fdalloc>
801064b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801064bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801064c0:	79 23                	jns    801064e5 <sys_open+0x121>
    if(f)
801064c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064c6:	74 0b                	je     801064d3 <sys_open+0x10f>
      fileclose(f);
801064c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064cb:	89 04 24             	mov    %eax,(%esp)
801064ce:	e8 4b ab ff ff       	call   8010101e <fileclose>
    iunlockput(ip);
801064d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d6:	89 04 24             	mov    %eax,(%esp)
801064d9:	e8 51 b6 ff ff       	call   80101b2f <iunlockput>
    return -1;
801064de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e3:	eb 65                	jmp    8010654a <sys_open+0x186>
  }
  iunlock(ip);
801064e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e8:	89 04 24             	mov    %eax,(%esp)
801064eb:	e8 09 b5 ff ff       	call   801019f9 <iunlock>

  f->type = FD_INODE;
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801064f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064ff:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106505:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010650c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010650f:	83 e0 01             	and    $0x1,%eax
80106512:	85 c0                	test   %eax,%eax
80106514:	0f 94 c0             	sete   %al
80106517:	89 c2                	mov    %eax,%edx
80106519:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010651c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010651f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106522:	83 e0 01             	and    $0x1,%eax
80106525:	85 c0                	test   %eax,%eax
80106527:	75 0a                	jne    80106533 <sys_open+0x16f>
80106529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010652c:	83 e0 02             	and    $0x2,%eax
8010652f:	85 c0                	test   %eax,%eax
80106531:	74 07                	je     8010653a <sys_open+0x176>
80106533:	b8 01 00 00 00       	mov    $0x1,%eax
80106538:	eb 05                	jmp    8010653f <sys_open+0x17b>
8010653a:	b8 00 00 00 00       	mov    $0x0,%eax
8010653f:	89 c2                	mov    %eax,%edx
80106541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106544:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106547:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010654a:	c9                   	leave  
8010654b:	c3                   	ret    

8010654c <sys_mkdir>:

int
sys_mkdir(void)
{
8010654c:	55                   	push   %ebp
8010654d:	89 e5                	mov    %esp,%ebp
8010654f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106552:	e8 c4 cd ff ff       	call   8010331b <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106557:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010655a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010655e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106565:	e8 56 f5 ff ff       	call   80105ac0 <argstr>
8010656a:	85 c0                	test   %eax,%eax
8010656c:	78 2c                	js     8010659a <sys_mkdir+0x4e>
8010656e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106571:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106578:	00 
80106579:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106580:	00 
80106581:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106588:	00 
80106589:	89 04 24             	mov    %eax,(%esp)
8010658c:	e8 73 fc ff ff       	call   80106204 <create>
80106591:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106598:	75 0c                	jne    801065a6 <sys_mkdir+0x5a>
    commit_trans();
8010659a:	e8 c5 cd ff ff       	call   80103364 <commit_trans>
    return -1;
8010659f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a4:	eb 15                	jmp    801065bb <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801065a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a9:	89 04 24             	mov    %eax,(%esp)
801065ac:	e8 7e b5 ff ff       	call   80101b2f <iunlockput>
  commit_trans();
801065b1:	e8 ae cd ff ff       	call   80103364 <commit_trans>
  return 0;
801065b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065bb:	c9                   	leave  
801065bc:	c3                   	ret    

801065bd <sys_mknod>:

int
sys_mknod(void)
{
801065bd:	55                   	push   %ebp
801065be:	89 e5                	mov    %esp,%ebp
801065c0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801065c3:	e8 53 cd ff ff       	call   8010331b <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801065c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801065cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065d6:	e8 e5 f4 ff ff       	call   80105ac0 <argstr>
801065db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065e2:	78 5e                	js     80106642 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801065e4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801065e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801065eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065f2:	e8 1f f4 ff ff       	call   80105a16 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801065f7:	85 c0                	test   %eax,%eax
801065f9:	78 47                	js     80106642 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801065fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106602:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106609:	e8 08 f4 ff ff       	call   80105a16 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010660e:	85 c0                	test   %eax,%eax
80106610:	78 30                	js     80106642 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106615:	0f bf c8             	movswl %ax,%ecx
80106618:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010661b:	0f bf d0             	movswl %ax,%edx
8010661e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106621:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106625:	89 54 24 08          	mov    %edx,0x8(%esp)
80106629:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106630:	00 
80106631:	89 04 24             	mov    %eax,(%esp)
80106634:	e8 cb fb ff ff       	call   80106204 <create>
80106639:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010663c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106640:	75 0c                	jne    8010664e <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106642:	e8 1d cd ff ff       	call   80103364 <commit_trans>
    return -1;
80106647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010664c:	eb 15                	jmp    80106663 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010664e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106651:	89 04 24             	mov    %eax,(%esp)
80106654:	e8 d6 b4 ff ff       	call   80101b2f <iunlockput>
  commit_trans();
80106659:	e8 06 cd ff ff       	call   80103364 <commit_trans>
  return 0;
8010665e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106663:	c9                   	leave  
80106664:	c3                   	ret    

80106665 <sys_chdir>:

int
sys_chdir(void)
{
80106665:	55                   	push   %ebp
80106666:	89 e5                	mov    %esp,%ebp
80106668:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010666b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010666e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106679:	e8 42 f4 ff ff       	call   80105ac0 <argstr>
8010667e:	85 c0                	test   %eax,%eax
80106680:	78 14                	js     80106696 <sys_chdir+0x31>
80106682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106685:	89 04 24             	mov    %eax,(%esp)
80106688:	e8 c9 bd ff ff       	call   80102456 <namei>
8010668d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106694:	75 07                	jne    8010669d <sys_chdir+0x38>
    return -1;
80106696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669b:	eb 57                	jmp    801066f4 <sys_chdir+0x8f>
  ilock(ip);
8010669d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a0:	89 04 24             	mov    %eax,(%esp)
801066a3:	e8 03 b2 ff ff       	call   801018ab <ilock>
  if(ip->type != T_DIR){
801066a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ab:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801066af:	66 83 f8 01          	cmp    $0x1,%ax
801066b3:	74 12                	je     801066c7 <sys_chdir+0x62>
    iunlockput(ip);
801066b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b8:	89 04 24             	mov    %eax,(%esp)
801066bb:	e8 6f b4 ff ff       	call   80101b2f <iunlockput>
    return -1;
801066c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c5:	eb 2d                	jmp    801066f4 <sys_chdir+0x8f>
  }
  iunlock(ip);
801066c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ca:	89 04 24             	mov    %eax,(%esp)
801066cd:	e8 27 b3 ff ff       	call   801019f9 <iunlock>
  iput(proc->cwd);
801066d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066d8:	8b 40 68             	mov    0x68(%eax),%eax
801066db:	89 04 24             	mov    %eax,(%esp)
801066de:	e8 7b b3 ff ff       	call   80101a5e <iput>
  proc->cwd = ip;
801066e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066ec:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801066ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    

801066f6 <sys_exec>:

int
sys_exec(void)
{
801066f6:	55                   	push   %ebp
801066f7:	89 e5                	mov    %esp,%ebp
801066f9:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801066ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106702:	89 44 24 04          	mov    %eax,0x4(%esp)
80106706:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010670d:	e8 ae f3 ff ff       	call   80105ac0 <argstr>
80106712:	85 c0                	test   %eax,%eax
80106714:	78 1a                	js     80106730 <sys_exec+0x3a>
80106716:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010671c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106720:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106727:	e8 ea f2 ff ff       	call   80105a16 <argint>
8010672c:	85 c0                	test   %eax,%eax
8010672e:	79 0a                	jns    8010673a <sys_exec+0x44>
    return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106735:	e9 c8 00 00 00       	jmp    80106802 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
8010673a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106741:	00 
80106742:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106749:	00 
8010674a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106750:	89 04 24             	mov    %eax,(%esp)
80106753:	e8 49 ef ff ff       	call   801056a1 <memset>
  for(i=0;; i++){
80106758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010675f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106762:	83 f8 1f             	cmp    $0x1f,%eax
80106765:	76 0a                	jbe    80106771 <sys_exec+0x7b>
      return -1;
80106767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676c:	e9 91 00 00 00       	jmp    80106802 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106774:	c1 e0 02             	shl    $0x2,%eax
80106777:	89 c2                	mov    %eax,%edx
80106779:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010677f:	01 c2                	add    %eax,%edx
80106781:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106787:	89 44 24 04          	mov    %eax,0x4(%esp)
8010678b:	89 14 24             	mov    %edx,(%esp)
8010678e:	e8 b4 f1 ff ff       	call   80105947 <fetchint>
80106793:	85 c0                	test   %eax,%eax
80106795:	79 07                	jns    8010679e <sys_exec+0xa8>
      return -1;
80106797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679c:	eb 64                	jmp    80106802 <sys_exec+0x10c>
    if(uarg == 0){
8010679e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801067a4:	85 c0                	test   %eax,%eax
801067a6:	75 26                	jne    801067ce <sys_exec+0xd8>
      argv[i] = 0;
801067a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ab:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801067b2:	00 00 00 00 
      break;
801067b6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801067b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067ba:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801067c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801067c4:	89 04 24             	mov    %eax,(%esp)
801067c7:	e8 23 a3 ff ff       	call   80100aef <exec>
801067cc:	eb 34                	jmp    80106802 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801067ce:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801067d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d7:	c1 e2 02             	shl    $0x2,%edx
801067da:	01 c2                	add    %eax,%edx
801067dc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801067e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801067e6:	89 04 24             	mov    %eax,(%esp)
801067e9:	e8 ae f1 ff ff       	call   8010599c <fetchstr>
801067ee:	85 c0                	test   %eax,%eax
801067f0:	79 07                	jns    801067f9 <sys_exec+0x103>
      return -1;
801067f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f7:	eb 09                	jmp    80106802 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801067f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801067fd:	e9 5d ff ff ff       	jmp    8010675f <sys_exec+0x69>
  return exec(path, argv);
}
80106802:	c9                   	leave  
80106803:	c3                   	ret    

80106804 <sys_pipe>:

int
sys_pipe(void)
{
80106804:	55                   	push   %ebp
80106805:	89 e5                	mov    %esp,%ebp
80106807:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010680a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106811:	00 
80106812:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106815:	89 44 24 04          	mov    %eax,0x4(%esp)
80106819:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106820:	e8 1f f2 ff ff       	call   80105a44 <argptr>
80106825:	85 c0                	test   %eax,%eax
80106827:	79 0a                	jns    80106833 <sys_pipe+0x2f>
    return -1;
80106829:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682e:	e9 9b 00 00 00       	jmp    801068ce <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106833:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106836:	89 44 24 04          	mov    %eax,0x4(%esp)
8010683a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010683d:	89 04 24             	mov    %eax,(%esp)
80106840:	e8 c0 d4 ff ff       	call   80103d05 <pipealloc>
80106845:	85 c0                	test   %eax,%eax
80106847:	79 07                	jns    80106850 <sys_pipe+0x4c>
    return -1;
80106849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684e:	eb 7e                	jmp    801068ce <sys_pipe+0xca>
  fd0 = -1;
80106850:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106857:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010685a:	89 04 24             	mov    %eax,(%esp)
8010685d:	e8 99 f3 ff ff       	call   80105bfb <fdalloc>
80106862:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106869:	78 14                	js     8010687f <sys_pipe+0x7b>
8010686b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010686e:	89 04 24             	mov    %eax,(%esp)
80106871:	e8 85 f3 ff ff       	call   80105bfb <fdalloc>
80106876:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010687d:	79 37                	jns    801068b6 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010687f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106883:	78 14                	js     80106899 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106885:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010688b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010688e:	83 c2 08             	add    $0x8,%edx
80106891:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106898:	00 
    fileclose(rf);
80106899:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010689c:	89 04 24             	mov    %eax,(%esp)
8010689f:	e8 7a a7 ff ff       	call   8010101e <fileclose>
    fileclose(wf);
801068a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068a7:	89 04 24             	mov    %eax,(%esp)
801068aa:	e8 6f a7 ff ff       	call   8010101e <fileclose>
    return -1;
801068af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b4:	eb 18                	jmp    801068ce <sys_pipe+0xca>
  }
  fd[0] = fd0;
801068b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801068b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068bc:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801068be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801068c1:	8d 50 04             	lea    0x4(%eax),%edx
801068c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068c7:	89 02                	mov    %eax,(%edx)
  return 0;
801068c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068ce:	c9                   	leave  
801068cf:	c3                   	ret    

801068d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 08             	sub    $0x8,%esp
  return fork();
801068d6:	e8 a4 db ff ff       	call   8010447f <fork>
}
801068db:	c9                   	leave  
801068dc:	c3                   	ret    

801068dd <sys_clone>:

int
sys_clone(){
801068dd:	55                   	push   %ebp
801068de:	89 e5                	mov    %esp,%ebp
801068e0:	53                   	push   %ebx
801068e1:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
801068e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801068f2:	e8 1f f1 ff ff       	call   80105a16 <argint>
801068f7:	85 c0                	test   %eax,%eax
801068f9:	78 4c                	js     80106947 <sys_clone+0x6a>
801068fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068fe:	85 c0                	test   %eax,%eax
80106900:	7e 45                	jle    80106947 <sys_clone+0x6a>
80106902:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106905:	89 44 24 04          	mov    %eax,0x4(%esp)
80106909:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106910:	e8 01 f1 ff ff       	call   80105a16 <argint>
80106915:	85 c0                	test   %eax,%eax
80106917:	78 2e                	js     80106947 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106919:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010691c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106920:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106927:	e8 ea f0 ff ff       	call   80105a16 <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
8010692c:	85 c0                	test   %eax,%eax
8010692e:	78 17                	js     80106947 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106930:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106933:	89 44 24 04          	mov    %eax,0x4(%esp)
80106937:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
8010693e:	e8 d3 f0 ff ff       	call   80105a16 <argint>
80106943:	85 c0                	test   %eax,%eax
80106945:	79 07                	jns    8010694e <sys_clone+0x71>
        return -1;
80106947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694c:	eb 20                	jmp    8010696e <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
8010694e:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80106951:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106954:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010695e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106962:	89 54 24 04          	mov    %edx,0x4(%esp)
80106966:	89 04 24             	mov    %eax,(%esp)
80106969:	e8 9b dd ff ff       	call   80104709 <clone>
}
8010696e:	83 c4 24             	add    $0x24,%esp
80106971:	5b                   	pop    %ebx
80106972:	5d                   	pop    %ebp
80106973:	c3                   	ret    

80106974 <sys_exit>:

int
sys_exit(void)
{
80106974:	55                   	push   %ebp
80106975:	89 e5                	mov    %esp,%ebp
80106977:	83 ec 08             	sub    $0x8,%esp
  exit();
8010697a:	e8 ad df ff ff       	call   8010492c <exit>
  return 0;  // not reached
8010697f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106984:	c9                   	leave  
80106985:	c3                   	ret    

80106986 <sys_texit>:

int
sys_texit(void)
{
80106986:	55                   	push   %ebp
80106987:	89 e5                	mov    %esp,%ebp
80106989:	83 ec 08             	sub    $0x8,%esp
    texit();
8010698c:	e8 b6 e0 ff ff       	call   80104a47 <texit>
    return 0;
80106991:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106996:	c9                   	leave  
80106997:	c3                   	ret    

80106998 <sys_wait>:

int
sys_wait(void)
{
80106998:	55                   	push   %ebp
80106999:	89 e5                	mov    %esp,%ebp
8010699b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010699e:	e8 72 e1 ff ff       	call   80104b15 <wait>
}
801069a3:	c9                   	leave  
801069a4:	c3                   	ret    

801069a5 <sys_kill>:

int
sys_kill(void)
{
801069a5:	55                   	push   %ebp
801069a6:	89 e5                	mov    %esp,%ebp
801069a8:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801069ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801069b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069b9:	e8 58 f0 ff ff       	call   80105a16 <argint>
801069be:	85 c0                	test   %eax,%eax
801069c0:	79 07                	jns    801069c9 <sys_kill+0x24>
    return -1;
801069c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c7:	eb 0b                	jmp    801069d4 <sys_kill+0x2f>
  return kill(pid);
801069c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cc:	89 04 24             	mov    %eax,(%esp)
801069cf:	e8 a4 e5 ff ff       	call   80104f78 <kill>
}
801069d4:	c9                   	leave  
801069d5:	c3                   	ret    

801069d6 <sys_getpid>:

int
sys_getpid(void)
{
801069d6:	55                   	push   %ebp
801069d7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801069d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069df:	8b 40 10             	mov    0x10(%eax),%eax
}
801069e2:	5d                   	pop    %ebp
801069e3:	c3                   	ret    

801069e4 <sys_sbrk>:

int
sys_sbrk(void)
{
801069e4:	55                   	push   %ebp
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801069ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069f8:	e8 19 f0 ff ff       	call   80105a16 <argint>
801069fd:	85 c0                	test   %eax,%eax
801069ff:	79 07                	jns    80106a08 <sys_sbrk+0x24>
    return -1;
80106a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a06:	eb 24                	jmp    80106a2c <sys_sbrk+0x48>
  addr = proc->sz;
80106a08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a0e:	8b 00                	mov    (%eax),%eax
80106a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a16:	89 04 24             	mov    %eax,(%esp)
80106a19:	e8 a4 d9 ff ff       	call   801043c2 <growproc>
80106a1e:	85 c0                	test   %eax,%eax
80106a20:	79 07                	jns    80106a29 <sys_sbrk+0x45>
    return -1;
80106a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a27:	eb 03                	jmp    80106a2c <sys_sbrk+0x48>
  return addr;
80106a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a2c:	c9                   	leave  
80106a2d:	c3                   	ret    

80106a2e <sys_sleep>:

int
sys_sleep(void)
{
80106a2e:	55                   	push   %ebp
80106a2f:	89 e5                	mov    %esp,%ebp
80106a31:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106a34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a37:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a42:	e8 cf ef ff ff       	call   80105a16 <argint>
80106a47:	85 c0                	test   %eax,%eax
80106a49:	79 07                	jns    80106a52 <sys_sleep+0x24>
    return -1;
80106a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a50:	eb 6c                	jmp    80106abe <sys_sleep+0x90>
  acquire(&tickslock);
80106a52:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106a59:	e8 5f e9 ff ff       	call   801053bd <acquire>
  ticks0 = ticks;
80106a5e:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106a66:	eb 34                	jmp    80106a9c <sys_sleep+0x6e>
    if(proc->killed){
80106a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6e:	8b 40 24             	mov    0x24(%eax),%eax
80106a71:	85 c0                	test   %eax,%eax
80106a73:	74 13                	je     80106a88 <sys_sleep+0x5a>
      release(&tickslock);
80106a75:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106a7c:	e8 e6 e9 ff ff       	call   80105467 <release>
      return -1;
80106a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a86:	eb 36                	jmp    80106abe <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106a88:	c7 44 24 04 a0 30 11 	movl   $0x801130a0,0x4(%esp)
80106a8f:	80 
80106a90:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80106a97:	e8 6d e3 ff ff       	call   80104e09 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106a9c:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106aa1:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106aa4:	89 c2                	mov    %eax,%edx
80106aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aa9:	39 c2                	cmp    %eax,%edx
80106aab:	72 bb                	jb     80106a68 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106aad:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106ab4:	e8 ae e9 ff ff       	call   80105467 <release>
  return 0;
80106ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106abe:	c9                   	leave  
80106abf:	c3                   	ret    

80106ac0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106ac6:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106acd:	e8 eb e8 ff ff       	call   801053bd <acquire>
  xticks = ticks;
80106ad2:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106ada:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106ae1:	e8 81 e9 ff ff       	call   80105467 <release>
  return xticks;
80106ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106ae9:	c9                   	leave  
80106aea:	c3                   	ret    

80106aeb <sys_tsleep>:

int
sys_tsleep(void)
{
80106aeb:	55                   	push   %ebp
80106aec:	89 e5                	mov    %esp,%ebp
80106aee:	83 ec 08             	sub    $0x8,%esp
    tsleep();
80106af1:	e8 f7 e5 ff ff       	call   801050ed <tsleep>
    return 0;
80106af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106afb:	c9                   	leave  
80106afc:	c3                   	ret    

80106afd <sys_twakeup>:

int 
sys_twakeup(void)
{
80106afd:	55                   	push   %ebp
80106afe:	89 e5                	mov    %esp,%ebp
80106b00:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
80106b03:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b06:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b11:	e8 00 ef ff ff       	call   80105a16 <argint>
80106b16:	85 c0                	test   %eax,%eax
80106b18:	79 07                	jns    80106b21 <sys_twakeup+0x24>
        return -1;
80106b1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1f:	eb 10                	jmp    80106b31 <sys_twakeup+0x34>
    }
        twakeup(tid);
80106b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b24:	89 04 24             	mov    %eax,(%esp)
80106b27:	e8 b9 e3 ff ff       	call   80104ee5 <twakeup>
        return 0;
80106b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b31:	c9                   	leave  
80106b32:	c3                   	ret    

80106b33 <sys_thread_yield>:

/////////////////////////////////////////
int
sys_thread_yield(void)
{
80106b33:	55                   	push   %ebp
80106b34:	89 e5                	mov    %esp,%ebp
80106b36:	83 ec 18             	sub    $0x18,%esp
  //cprintf("Yielded_1\n");
  //yield();
  thread_yield();
80106b39:	e8 20 e6 ff ff       	call   8010515e <thread_yield>
  cprintf("Yielded_2\n");
80106b3e:	c7 04 24 9b 91 10 80 	movl   $0x8010919b,(%esp)
80106b45:	e8 56 98 ff ff       	call   801003a0 <cprintf>
  return 0;
80106b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b4f:	c9                   	leave  
80106b50:	c3                   	ret    

80106b51 <sys_thread_yield3>:

int
sys_thread_yield3(void)
{
80106b51:	55                   	push   %ebp
80106b52:	89 e5                	mov    %esp,%ebp
80106b54:	83 ec 28             	sub    $0x28,%esp
  int tid;
    if(argint(0,&tid) < 0){
80106b57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b65:	e8 ac ee ff ff       	call   80105a16 <argint>
80106b6a:	85 c0                	test   %eax,%eax
80106b6c:	79 07                	jns    80106b75 <sys_thread_yield3+0x24>
        return -1;
80106b6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b73:	eb 10                	jmp    80106b85 <sys_thread_yield3+0x34>
    }
  thread_yield3(tid);
80106b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b78:	89 04 24             	mov    %eax,(%esp)
80106b7b:	e8 d9 e7 ff ff       	call   80105359 <thread_yield3>
  return 0;
80106b80:	b8 00 00 00 00       	mov    $0x0,%eax
80106b85:	c9                   	leave  
80106b86:	c3                   	ret    

80106b87 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106b87:	55                   	push   %ebp
80106b88:	89 e5                	mov    %esp,%ebp
80106b8a:	83 ec 08             	sub    $0x8,%esp
80106b8d:	8b 55 08             	mov    0x8(%ebp),%edx
80106b90:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b93:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b97:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b9a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b9e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ba2:	ee                   	out    %al,(%dx)
}
80106ba3:	c9                   	leave  
80106ba4:	c3                   	ret    

80106ba5 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106ba5:	55                   	push   %ebp
80106ba6:	89 e5                	mov    %esp,%ebp
80106ba8:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106bab:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106bb2:	00 
80106bb3:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106bba:	e8 c8 ff ff ff       	call   80106b87 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106bbf:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106bc6:	00 
80106bc7:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106bce:	e8 b4 ff ff ff       	call   80106b87 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106bd3:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106bda:	00 
80106bdb:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106be2:	e8 a0 ff ff ff       	call   80106b87 <outb>
  picenable(IRQ_TIMER);
80106be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bee:	e8 a5 cf ff ff       	call   80103b98 <picenable>
}
80106bf3:	c9                   	leave  
80106bf4:	c3                   	ret    

80106bf5 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106bf5:	1e                   	push   %ds
  pushl %es
80106bf6:	06                   	push   %es
  pushl %fs
80106bf7:	0f a0                	push   %fs
  pushl %gs
80106bf9:	0f a8                	push   %gs
  pushal
80106bfb:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106bfc:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c00:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c02:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106c04:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106c08:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106c0a:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c0c:	54                   	push   %esp
  call trap
80106c0d:	e8 d8 01 00 00       	call   80106dea <trap>
  addl $4, %esp
80106c12:	83 c4 04             	add    $0x4,%esp

80106c15 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c15:	61                   	popa   
  popl %gs
80106c16:	0f a9                	pop    %gs
  popl %fs
80106c18:	0f a1                	pop    %fs
  popl %es
80106c1a:	07                   	pop    %es
  popl %ds
80106c1b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c1c:	83 c4 08             	add    $0x8,%esp
  iret
80106c1f:	cf                   	iret   

80106c20 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c29:	83 e8 01             	sub    $0x1,%eax
80106c2c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c30:	8b 45 08             	mov    0x8(%ebp),%eax
80106c33:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c37:	8b 45 08             	mov    0x8(%ebp),%eax
80106c3a:	c1 e8 10             	shr    $0x10,%eax
80106c3d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106c41:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c44:	0f 01 18             	lidtl  (%eax)
}
80106c47:	c9                   	leave  
80106c48:	c3                   	ret    

80106c49 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106c49:	55                   	push   %ebp
80106c4a:	89 e5                	mov    %esp,%ebp
80106c4c:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c4f:	0f 20 d0             	mov    %cr2,%eax
80106c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106c58:	c9                   	leave  
80106c59:	c3                   	ret    

80106c5a <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c5a:	55                   	push   %ebp
80106c5b:	89 e5                	mov    %esp,%ebp
80106c5d:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c67:	e9 c3 00 00 00       	jmp    80106d2f <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c6f:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106c76:	89 c2                	mov    %eax,%edx
80106c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7b:	66 89 14 c5 e0 30 11 	mov    %dx,-0x7feecf20(,%eax,8)
80106c82:	80 
80106c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c86:	66 c7 04 c5 e2 30 11 	movw   $0x8,-0x7feecf1e(,%eax,8)
80106c8d:	80 08 00 
80106c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c93:	0f b6 14 c5 e4 30 11 	movzbl -0x7feecf1c(,%eax,8),%edx
80106c9a:	80 
80106c9b:	83 e2 e0             	and    $0xffffffe0,%edx
80106c9e:	88 14 c5 e4 30 11 80 	mov    %dl,-0x7feecf1c(,%eax,8)
80106ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ca8:	0f b6 14 c5 e4 30 11 	movzbl -0x7feecf1c(,%eax,8),%edx
80106caf:	80 
80106cb0:	83 e2 1f             	and    $0x1f,%edx
80106cb3:	88 14 c5 e4 30 11 80 	mov    %dl,-0x7feecf1c(,%eax,8)
80106cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cbd:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106cc4:	80 
80106cc5:	83 e2 f0             	and    $0xfffffff0,%edx
80106cc8:	83 ca 0e             	or     $0xe,%edx
80106ccb:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd5:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106cdc:	80 
80106cdd:	83 e2 ef             	and    $0xffffffef,%edx
80106ce0:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cea:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106cf1:	80 
80106cf2:	83 e2 9f             	and    $0xffffff9f,%edx
80106cf5:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cff:	0f b6 14 c5 e5 30 11 	movzbl -0x7feecf1b(,%eax,8),%edx
80106d06:	80 
80106d07:	83 ca 80             	or     $0xffffff80,%edx
80106d0a:	88 14 c5 e5 30 11 80 	mov    %dl,-0x7feecf1b(,%eax,8)
80106d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d14:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106d1b:	c1 e8 10             	shr    $0x10,%eax
80106d1e:	89 c2                	mov    %eax,%edx
80106d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d23:	66 89 14 c5 e6 30 11 	mov    %dx,-0x7feecf1a(,%eax,8)
80106d2a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106d2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d2f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106d36:	0f 8e 30 ff ff ff    	jle    80106c6c <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d3c:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106d41:	66 a3 e0 32 11 80    	mov    %ax,0x801132e0
80106d47:	66 c7 05 e2 32 11 80 	movw   $0x8,0x801132e2
80106d4e:	08 00 
80106d50:	0f b6 05 e4 32 11 80 	movzbl 0x801132e4,%eax
80106d57:	83 e0 e0             	and    $0xffffffe0,%eax
80106d5a:	a2 e4 32 11 80       	mov    %al,0x801132e4
80106d5f:	0f b6 05 e4 32 11 80 	movzbl 0x801132e4,%eax
80106d66:	83 e0 1f             	and    $0x1f,%eax
80106d69:	a2 e4 32 11 80       	mov    %al,0x801132e4
80106d6e:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106d75:	83 c8 0f             	or     $0xf,%eax
80106d78:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106d7d:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106d84:	83 e0 ef             	and    $0xffffffef,%eax
80106d87:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106d8c:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106d93:	83 c8 60             	or     $0x60,%eax
80106d96:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106d9b:	0f b6 05 e5 32 11 80 	movzbl 0x801132e5,%eax
80106da2:	83 c8 80             	or     $0xffffff80,%eax
80106da5:	a2 e5 32 11 80       	mov    %al,0x801132e5
80106daa:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106daf:	c1 e8 10             	shr    $0x10,%eax
80106db2:	66 a3 e6 32 11 80    	mov    %ax,0x801132e6
  
  initlock(&tickslock, "time");
80106db8:	c7 44 24 04 a8 91 10 	movl   $0x801091a8,0x4(%esp)
80106dbf:	80 
80106dc0:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106dc7:	e8 d0 e5 ff ff       	call   8010539c <initlock>
}
80106dcc:	c9                   	leave  
80106dcd:	c3                   	ret    

80106dce <idtinit>:

void
idtinit(void)
{
80106dce:	55                   	push   %ebp
80106dcf:	89 e5                	mov    %esp,%ebp
80106dd1:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106dd4:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106ddb:	00 
80106ddc:	c7 04 24 e0 30 11 80 	movl   $0x801130e0,(%esp)
80106de3:	e8 38 fe ff ff       	call   80106c20 <lidt>
}
80106de8:	c9                   	leave  
80106de9:	c3                   	ret    

80106dea <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106dea:	55                   	push   %ebp
80106deb:	89 e5                	mov    %esp,%ebp
80106ded:	57                   	push   %edi
80106dee:	56                   	push   %esi
80106def:	53                   	push   %ebx
80106df0:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106df3:	8b 45 08             	mov    0x8(%ebp),%eax
80106df6:	8b 40 30             	mov    0x30(%eax),%eax
80106df9:	83 f8 40             	cmp    $0x40,%eax
80106dfc:	75 3f                	jne    80106e3d <trap+0x53>
    if(proc->killed)
80106dfe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e04:	8b 40 24             	mov    0x24(%eax),%eax
80106e07:	85 c0                	test   %eax,%eax
80106e09:	74 05                	je     80106e10 <trap+0x26>
      exit();
80106e0b:	e8 1c db ff ff       	call   8010492c <exit>
    proc->tf = tf;
80106e10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e16:	8b 55 08             	mov    0x8(%ebp),%edx
80106e19:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106e1c:	e8 d6 ec ff ff       	call   80105af7 <syscall>
    if(proc->killed)
80106e21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e27:	8b 40 24             	mov    0x24(%eax),%eax
80106e2a:	85 c0                	test   %eax,%eax
80106e2c:	74 0a                	je     80106e38 <trap+0x4e>
      exit();
80106e2e:	e8 f9 da ff ff       	call   8010492c <exit>
    return;
80106e33:	e9 2d 02 00 00       	jmp    80107065 <trap+0x27b>
80106e38:	e9 28 02 00 00       	jmp    80107065 <trap+0x27b>
  }

  switch(tf->trapno){
80106e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e40:	8b 40 30             	mov    0x30(%eax),%eax
80106e43:	83 e8 20             	sub    $0x20,%eax
80106e46:	83 f8 1f             	cmp    $0x1f,%eax
80106e49:	0f 87 bc 00 00 00    	ja     80106f0b <trap+0x121>
80106e4f:	8b 04 85 50 92 10 80 	mov    -0x7fef6db0(,%eax,4),%eax
80106e56:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106e58:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e5e:	0f b6 00             	movzbl (%eax),%eax
80106e61:	84 c0                	test   %al,%al
80106e63:	75 31                	jne    80106e96 <trap+0xac>
      acquire(&tickslock);
80106e65:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106e6c:	e8 4c e5 ff ff       	call   801053bd <acquire>
      ticks++;
80106e71:	a1 e0 38 11 80       	mov    0x801138e0,%eax
80106e76:	83 c0 01             	add    $0x1,%eax
80106e79:	a3 e0 38 11 80       	mov    %eax,0x801138e0
      wakeup(&ticks);
80106e7e:	c7 04 24 e0 38 11 80 	movl   $0x801138e0,(%esp)
80106e85:	e8 c3 e0 ff ff       	call   80104f4d <wakeup>
      release(&tickslock);
80106e8a:	c7 04 24 a0 30 11 80 	movl   $0x801130a0,(%esp)
80106e91:	e8 d1 e5 ff ff       	call   80105467 <release>
    }
    lapiceoi();
80106e96:	e8 4e c1 ff ff       	call   80102fe9 <lapiceoi>
    break;
80106e9b:	e9 41 01 00 00       	jmp    80106fe1 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ea0:	e8 89 b8 ff ff       	call   8010272e <ideintr>
    lapiceoi();
80106ea5:	e8 3f c1 ff ff       	call   80102fe9 <lapiceoi>
    break;
80106eaa:	e9 32 01 00 00       	jmp    80106fe1 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106eaf:	e8 21 bf ff ff       	call   80102dd5 <kbdintr>
    lapiceoi();
80106eb4:	e8 30 c1 ff ff       	call   80102fe9 <lapiceoi>
    break;
80106eb9:	e9 23 01 00 00       	jmp    80106fe1 <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106ebe:	e8 97 03 00 00       	call   8010725a <uartintr>
    lapiceoi();
80106ec3:	e8 21 c1 ff ff       	call   80102fe9 <lapiceoi>
    break;
80106ec8:	e9 14 01 00 00       	jmp    80106fe1 <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed0:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106eda:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106edd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ee3:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ee6:	0f b6 c0             	movzbl %al,%eax
80106ee9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106eed:	89 54 24 08          	mov    %edx,0x8(%esp)
80106ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ef5:	c7 04 24 b0 91 10 80 	movl   $0x801091b0,(%esp)
80106efc:	e8 9f 94 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106f01:	e8 e3 c0 ff ff       	call   80102fe9 <lapiceoi>
    break;
80106f06:	e9 d6 00 00 00       	jmp    80106fe1 <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106f0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f11:	85 c0                	test   %eax,%eax
80106f13:	74 11                	je     80106f26 <trap+0x13c>
80106f15:	8b 45 08             	mov    0x8(%ebp),%eax
80106f18:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f1c:	0f b7 c0             	movzwl %ax,%eax
80106f1f:	83 e0 03             	and    $0x3,%eax
80106f22:	85 c0                	test   %eax,%eax
80106f24:	75 46                	jne    80106f6c <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f26:	e8 1e fd ff ff       	call   80106c49 <rcr2>
80106f2b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f2e:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106f31:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106f38:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f3b:	0f b6 ca             	movzbl %dl,%ecx
80106f3e:	8b 55 08             	mov    0x8(%ebp),%edx
80106f41:	8b 52 30             	mov    0x30(%edx),%edx
80106f44:	89 44 24 10          	mov    %eax,0x10(%esp)
80106f48:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106f4c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106f50:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f54:	c7 04 24 d4 91 10 80 	movl   $0x801091d4,(%esp)
80106f5b:	e8 40 94 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106f60:	c7 04 24 06 92 10 80 	movl   $0x80109206,(%esp)
80106f67:	e8 ce 95 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f6c:	e8 d8 fc ff ff       	call   80106c49 <rcr2>
80106f71:	89 c2                	mov    %eax,%edx
80106f73:	8b 45 08             	mov    0x8(%ebp),%eax
80106f76:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106f79:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f7f:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f82:	0f b6 f0             	movzbl %al,%esi
80106f85:	8b 45 08             	mov    0x8(%ebp),%eax
80106f88:	8b 58 34             	mov    0x34(%eax),%ebx
80106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8e:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106f91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f97:	83 c0 6c             	add    $0x6c,%eax
80106f9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106fa3:	8b 40 10             	mov    0x10(%eax),%eax
80106fa6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106faa:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106fae:	89 74 24 14          	mov    %esi,0x14(%esp)
80106fb2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106fb6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106fba:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106fbd:	89 74 24 08          	mov    %esi,0x8(%esp)
80106fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fc5:	c7 04 24 0c 92 10 80 	movl   $0x8010920c,(%esp)
80106fcc:	e8 cf 93 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106fd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106fde:	eb 01                	jmp    80106fe1 <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106fe0:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106fe1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	74 24                	je     8010700f <trap+0x225>
80106feb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ff1:	8b 40 24             	mov    0x24(%eax),%eax
80106ff4:	85 c0                	test   %eax,%eax
80106ff6:	74 17                	je     8010700f <trap+0x225>
80106ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fff:	0f b7 c0             	movzwl %ax,%eax
80107002:	83 e0 03             	and    $0x3,%eax
80107005:	83 f8 03             	cmp    $0x3,%eax
80107008:	75 05                	jne    8010700f <trap+0x225>
    exit();
8010700a:	e8 1d d9 ff ff       	call   8010492c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010700f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107015:	85 c0                	test   %eax,%eax
80107017:	74 1e                	je     80107037 <trap+0x24d>
80107019:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701f:	8b 40 0c             	mov    0xc(%eax),%eax
80107022:	83 f8 04             	cmp    $0x4,%eax
80107025:	75 10                	jne    80107037 <trap+0x24d>
80107027:	8b 45 08             	mov    0x8(%ebp),%eax
8010702a:	8b 40 30             	mov    0x30(%eax),%eax
8010702d:	83 f8 20             	cmp    $0x20,%eax
80107030:	75 05                	jne    80107037 <trap+0x24d>
    yield();
80107032:	e8 74 dd ff ff       	call   80104dab <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010703d:	85 c0                	test   %eax,%eax
8010703f:	74 24                	je     80107065 <trap+0x27b>
80107041:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107047:	8b 40 24             	mov    0x24(%eax),%eax
8010704a:	85 c0                	test   %eax,%eax
8010704c:	74 17                	je     80107065 <trap+0x27b>
8010704e:	8b 45 08             	mov    0x8(%ebp),%eax
80107051:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107055:	0f b7 c0             	movzwl %ax,%eax
80107058:	83 e0 03             	and    $0x3,%eax
8010705b:	83 f8 03             	cmp    $0x3,%eax
8010705e:	75 05                	jne    80107065 <trap+0x27b>
    exit();
80107060:	e8 c7 d8 ff ff       	call   8010492c <exit>
}
80107065:	83 c4 3c             	add    $0x3c,%esp
80107068:	5b                   	pop    %ebx
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    

8010706d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010706d:	55                   	push   %ebp
8010706e:	89 e5                	mov    %esp,%ebp
80107070:	83 ec 14             	sub    $0x14,%esp
80107073:	8b 45 08             	mov    0x8(%ebp),%eax
80107076:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010707a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010707e:	89 c2                	mov    %eax,%edx
80107080:	ec                   	in     (%dx),%al
80107081:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107084:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107088:	c9                   	leave  
80107089:	c3                   	ret    

8010708a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010708a:	55                   	push   %ebp
8010708b:	89 e5                	mov    %esp,%ebp
8010708d:	83 ec 08             	sub    $0x8,%esp
80107090:	8b 55 08             	mov    0x8(%ebp),%edx
80107093:	8b 45 0c             	mov    0xc(%ebp),%eax
80107096:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010709a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010709d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801070a1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801070a5:	ee                   	out    %al,(%dx)
}
801070a6:	c9                   	leave  
801070a7:	c3                   	ret    

801070a8 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801070a8:	55                   	push   %ebp
801070a9:	89 e5                	mov    %esp,%ebp
801070ab:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801070ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070b5:	00 
801070b6:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801070bd:	e8 c8 ff ff ff       	call   8010708a <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801070c2:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801070c9:	00 
801070ca:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801070d1:	e8 b4 ff ff ff       	call   8010708a <outb>
  outb(COM1+0, 115200/9600);
801070d6:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801070dd:	00 
801070de:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070e5:	e8 a0 ff ff ff       	call   8010708a <outb>
  outb(COM1+1, 0);
801070ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070f1:	00 
801070f2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801070f9:	e8 8c ff ff ff       	call   8010708a <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801070fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107105:	00 
80107106:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010710d:	e8 78 ff ff ff       	call   8010708a <outb>
  outb(COM1+4, 0);
80107112:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107119:	00 
8010711a:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107121:	e8 64 ff ff ff       	call   8010708a <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010712d:	00 
8010712e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107135:	e8 50 ff ff ff       	call   8010708a <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010713a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107141:	e8 27 ff ff ff       	call   8010706d <inb>
80107146:	3c ff                	cmp    $0xff,%al
80107148:	75 02                	jne    8010714c <uartinit+0xa4>
    return;
8010714a:	eb 6a                	jmp    801071b6 <uartinit+0x10e>
  uart = 1;
8010714c:	c7 05 70 c6 10 80 01 	movl   $0x1,0x8010c670
80107153:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107156:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010715d:	e8 0b ff ff ff       	call   8010706d <inb>
  inb(COM1+0);
80107162:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107169:	e8 ff fe ff ff       	call   8010706d <inb>
  picenable(IRQ_COM1);
8010716e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107175:	e8 1e ca ff ff       	call   80103b98 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010717a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107181:	00 
80107182:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107189:	e8 1f b8 ff ff       	call   801029ad <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010718e:	c7 45 f4 d0 92 10 80 	movl   $0x801092d0,-0xc(%ebp)
80107195:	eb 15                	jmp    801071ac <uartinit+0x104>
    uartputc(*p);
80107197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719a:	0f b6 00             	movzbl (%eax),%eax
8010719d:	0f be c0             	movsbl %al,%eax
801071a0:	89 04 24             	mov    %eax,(%esp)
801071a3:	e8 10 00 00 00       	call   801071b8 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801071a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071af:	0f b6 00             	movzbl (%eax),%eax
801071b2:	84 c0                	test   %al,%al
801071b4:	75 e1                	jne    80107197 <uartinit+0xef>
    uartputc(*p);
}
801071b6:	c9                   	leave  
801071b7:	c3                   	ret    

801071b8 <uartputc>:

void
uartputc(int c)
{
801071b8:	55                   	push   %ebp
801071b9:	89 e5                	mov    %esp,%ebp
801071bb:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801071be:	a1 70 c6 10 80       	mov    0x8010c670,%eax
801071c3:	85 c0                	test   %eax,%eax
801071c5:	75 02                	jne    801071c9 <uartputc+0x11>
    return;
801071c7:	eb 4b                	jmp    80107214 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801071d0:	eb 10                	jmp    801071e2 <uartputc+0x2a>
    microdelay(10);
801071d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801071d9:	e8 30 be ff ff       	call   8010300e <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801071de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801071e2:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801071e6:	7f 16                	jg     801071fe <uartputc+0x46>
801071e8:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801071ef:	e8 79 fe ff ff       	call   8010706d <inb>
801071f4:	0f b6 c0             	movzbl %al,%eax
801071f7:	83 e0 20             	and    $0x20,%eax
801071fa:	85 c0                	test   %eax,%eax
801071fc:	74 d4                	je     801071d2 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801071fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107201:	0f b6 c0             	movzbl %al,%eax
80107204:	89 44 24 04          	mov    %eax,0x4(%esp)
80107208:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010720f:	e8 76 fe ff ff       	call   8010708a <outb>
}
80107214:	c9                   	leave  
80107215:	c3                   	ret    

80107216 <uartgetc>:

static int
uartgetc(void)
{
80107216:	55                   	push   %ebp
80107217:	89 e5                	mov    %esp,%ebp
80107219:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010721c:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80107221:	85 c0                	test   %eax,%eax
80107223:	75 07                	jne    8010722c <uartgetc+0x16>
    return -1;
80107225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010722a:	eb 2c                	jmp    80107258 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010722c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107233:	e8 35 fe ff ff       	call   8010706d <inb>
80107238:	0f b6 c0             	movzbl %al,%eax
8010723b:	83 e0 01             	and    $0x1,%eax
8010723e:	85 c0                	test   %eax,%eax
80107240:	75 07                	jne    80107249 <uartgetc+0x33>
    return -1;
80107242:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107247:	eb 0f                	jmp    80107258 <uartgetc+0x42>
  return inb(COM1+0);
80107249:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107250:	e8 18 fe ff ff       	call   8010706d <inb>
80107255:	0f b6 c0             	movzbl %al,%eax
}
80107258:	c9                   	leave  
80107259:	c3                   	ret    

8010725a <uartintr>:

void
uartintr(void)
{
8010725a:	55                   	push   %ebp
8010725b:	89 e5                	mov    %esp,%ebp
8010725d:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107260:	c7 04 24 16 72 10 80 	movl   $0x80107216,(%esp)
80107267:	e8 41 95 ff ff       	call   801007ad <consoleintr>
}
8010726c:	c9                   	leave  
8010726d:	c3                   	ret    

8010726e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $0
80107270:	6a 00                	push   $0x0
  jmp alltraps
80107272:	e9 7e f9 ff ff       	jmp    80106bf5 <alltraps>

80107277 <vector1>:
.globl vector1
vector1:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $1
80107279:	6a 01                	push   $0x1
  jmp alltraps
8010727b:	e9 75 f9 ff ff       	jmp    80106bf5 <alltraps>

80107280 <vector2>:
.globl vector2
vector2:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $2
80107282:	6a 02                	push   $0x2
  jmp alltraps
80107284:	e9 6c f9 ff ff       	jmp    80106bf5 <alltraps>

80107289 <vector3>:
.globl vector3
vector3:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $3
8010728b:	6a 03                	push   $0x3
  jmp alltraps
8010728d:	e9 63 f9 ff ff       	jmp    80106bf5 <alltraps>

80107292 <vector4>:
.globl vector4
vector4:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $4
80107294:	6a 04                	push   $0x4
  jmp alltraps
80107296:	e9 5a f9 ff ff       	jmp    80106bf5 <alltraps>

8010729b <vector5>:
.globl vector5
vector5:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $5
8010729d:	6a 05                	push   $0x5
  jmp alltraps
8010729f:	e9 51 f9 ff ff       	jmp    80106bf5 <alltraps>

801072a4 <vector6>:
.globl vector6
vector6:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $6
801072a6:	6a 06                	push   $0x6
  jmp alltraps
801072a8:	e9 48 f9 ff ff       	jmp    80106bf5 <alltraps>

801072ad <vector7>:
.globl vector7
vector7:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $7
801072af:	6a 07                	push   $0x7
  jmp alltraps
801072b1:	e9 3f f9 ff ff       	jmp    80106bf5 <alltraps>

801072b6 <vector8>:
.globl vector8
vector8:
  pushl $8
801072b6:	6a 08                	push   $0x8
  jmp alltraps
801072b8:	e9 38 f9 ff ff       	jmp    80106bf5 <alltraps>

801072bd <vector9>:
.globl vector9
vector9:
  pushl $0
801072bd:	6a 00                	push   $0x0
  pushl $9
801072bf:	6a 09                	push   $0x9
  jmp alltraps
801072c1:	e9 2f f9 ff ff       	jmp    80106bf5 <alltraps>

801072c6 <vector10>:
.globl vector10
vector10:
  pushl $10
801072c6:	6a 0a                	push   $0xa
  jmp alltraps
801072c8:	e9 28 f9 ff ff       	jmp    80106bf5 <alltraps>

801072cd <vector11>:
.globl vector11
vector11:
  pushl $11
801072cd:	6a 0b                	push   $0xb
  jmp alltraps
801072cf:	e9 21 f9 ff ff       	jmp    80106bf5 <alltraps>

801072d4 <vector12>:
.globl vector12
vector12:
  pushl $12
801072d4:	6a 0c                	push   $0xc
  jmp alltraps
801072d6:	e9 1a f9 ff ff       	jmp    80106bf5 <alltraps>

801072db <vector13>:
.globl vector13
vector13:
  pushl $13
801072db:	6a 0d                	push   $0xd
  jmp alltraps
801072dd:	e9 13 f9 ff ff       	jmp    80106bf5 <alltraps>

801072e2 <vector14>:
.globl vector14
vector14:
  pushl $14
801072e2:	6a 0e                	push   $0xe
  jmp alltraps
801072e4:	e9 0c f9 ff ff       	jmp    80106bf5 <alltraps>

801072e9 <vector15>:
.globl vector15
vector15:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $15
801072eb:	6a 0f                	push   $0xf
  jmp alltraps
801072ed:	e9 03 f9 ff ff       	jmp    80106bf5 <alltraps>

801072f2 <vector16>:
.globl vector16
vector16:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $16
801072f4:	6a 10                	push   $0x10
  jmp alltraps
801072f6:	e9 fa f8 ff ff       	jmp    80106bf5 <alltraps>

801072fb <vector17>:
.globl vector17
vector17:
  pushl $17
801072fb:	6a 11                	push   $0x11
  jmp alltraps
801072fd:	e9 f3 f8 ff ff       	jmp    80106bf5 <alltraps>

80107302 <vector18>:
.globl vector18
vector18:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $18
80107304:	6a 12                	push   $0x12
  jmp alltraps
80107306:	e9 ea f8 ff ff       	jmp    80106bf5 <alltraps>

8010730b <vector19>:
.globl vector19
vector19:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $19
8010730d:	6a 13                	push   $0x13
  jmp alltraps
8010730f:	e9 e1 f8 ff ff       	jmp    80106bf5 <alltraps>

80107314 <vector20>:
.globl vector20
vector20:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $20
80107316:	6a 14                	push   $0x14
  jmp alltraps
80107318:	e9 d8 f8 ff ff       	jmp    80106bf5 <alltraps>

8010731d <vector21>:
.globl vector21
vector21:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $21
8010731f:	6a 15                	push   $0x15
  jmp alltraps
80107321:	e9 cf f8 ff ff       	jmp    80106bf5 <alltraps>

80107326 <vector22>:
.globl vector22
vector22:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $22
80107328:	6a 16                	push   $0x16
  jmp alltraps
8010732a:	e9 c6 f8 ff ff       	jmp    80106bf5 <alltraps>

8010732f <vector23>:
.globl vector23
vector23:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $23
80107331:	6a 17                	push   $0x17
  jmp alltraps
80107333:	e9 bd f8 ff ff       	jmp    80106bf5 <alltraps>

80107338 <vector24>:
.globl vector24
vector24:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $24
8010733a:	6a 18                	push   $0x18
  jmp alltraps
8010733c:	e9 b4 f8 ff ff       	jmp    80106bf5 <alltraps>

80107341 <vector25>:
.globl vector25
vector25:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $25
80107343:	6a 19                	push   $0x19
  jmp alltraps
80107345:	e9 ab f8 ff ff       	jmp    80106bf5 <alltraps>

8010734a <vector26>:
.globl vector26
vector26:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $26
8010734c:	6a 1a                	push   $0x1a
  jmp alltraps
8010734e:	e9 a2 f8 ff ff       	jmp    80106bf5 <alltraps>

80107353 <vector27>:
.globl vector27
vector27:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $27
80107355:	6a 1b                	push   $0x1b
  jmp alltraps
80107357:	e9 99 f8 ff ff       	jmp    80106bf5 <alltraps>

8010735c <vector28>:
.globl vector28
vector28:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $28
8010735e:	6a 1c                	push   $0x1c
  jmp alltraps
80107360:	e9 90 f8 ff ff       	jmp    80106bf5 <alltraps>

80107365 <vector29>:
.globl vector29
vector29:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $29
80107367:	6a 1d                	push   $0x1d
  jmp alltraps
80107369:	e9 87 f8 ff ff       	jmp    80106bf5 <alltraps>

8010736e <vector30>:
.globl vector30
vector30:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $30
80107370:	6a 1e                	push   $0x1e
  jmp alltraps
80107372:	e9 7e f8 ff ff       	jmp    80106bf5 <alltraps>

80107377 <vector31>:
.globl vector31
vector31:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $31
80107379:	6a 1f                	push   $0x1f
  jmp alltraps
8010737b:	e9 75 f8 ff ff       	jmp    80106bf5 <alltraps>

80107380 <vector32>:
.globl vector32
vector32:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $32
80107382:	6a 20                	push   $0x20
  jmp alltraps
80107384:	e9 6c f8 ff ff       	jmp    80106bf5 <alltraps>

80107389 <vector33>:
.globl vector33
vector33:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $33
8010738b:	6a 21                	push   $0x21
  jmp alltraps
8010738d:	e9 63 f8 ff ff       	jmp    80106bf5 <alltraps>

80107392 <vector34>:
.globl vector34
vector34:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $34
80107394:	6a 22                	push   $0x22
  jmp alltraps
80107396:	e9 5a f8 ff ff       	jmp    80106bf5 <alltraps>

8010739b <vector35>:
.globl vector35
vector35:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $35
8010739d:	6a 23                	push   $0x23
  jmp alltraps
8010739f:	e9 51 f8 ff ff       	jmp    80106bf5 <alltraps>

801073a4 <vector36>:
.globl vector36
vector36:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $36
801073a6:	6a 24                	push   $0x24
  jmp alltraps
801073a8:	e9 48 f8 ff ff       	jmp    80106bf5 <alltraps>

801073ad <vector37>:
.globl vector37
vector37:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $37
801073af:	6a 25                	push   $0x25
  jmp alltraps
801073b1:	e9 3f f8 ff ff       	jmp    80106bf5 <alltraps>

801073b6 <vector38>:
.globl vector38
vector38:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $38
801073b8:	6a 26                	push   $0x26
  jmp alltraps
801073ba:	e9 36 f8 ff ff       	jmp    80106bf5 <alltraps>

801073bf <vector39>:
.globl vector39
vector39:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $39
801073c1:	6a 27                	push   $0x27
  jmp alltraps
801073c3:	e9 2d f8 ff ff       	jmp    80106bf5 <alltraps>

801073c8 <vector40>:
.globl vector40
vector40:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $40
801073ca:	6a 28                	push   $0x28
  jmp alltraps
801073cc:	e9 24 f8 ff ff       	jmp    80106bf5 <alltraps>

801073d1 <vector41>:
.globl vector41
vector41:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $41
801073d3:	6a 29                	push   $0x29
  jmp alltraps
801073d5:	e9 1b f8 ff ff       	jmp    80106bf5 <alltraps>

801073da <vector42>:
.globl vector42
vector42:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $42
801073dc:	6a 2a                	push   $0x2a
  jmp alltraps
801073de:	e9 12 f8 ff ff       	jmp    80106bf5 <alltraps>

801073e3 <vector43>:
.globl vector43
vector43:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $43
801073e5:	6a 2b                	push   $0x2b
  jmp alltraps
801073e7:	e9 09 f8 ff ff       	jmp    80106bf5 <alltraps>

801073ec <vector44>:
.globl vector44
vector44:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $44
801073ee:	6a 2c                	push   $0x2c
  jmp alltraps
801073f0:	e9 00 f8 ff ff       	jmp    80106bf5 <alltraps>

801073f5 <vector45>:
.globl vector45
vector45:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $45
801073f7:	6a 2d                	push   $0x2d
  jmp alltraps
801073f9:	e9 f7 f7 ff ff       	jmp    80106bf5 <alltraps>

801073fe <vector46>:
.globl vector46
vector46:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $46
80107400:	6a 2e                	push   $0x2e
  jmp alltraps
80107402:	e9 ee f7 ff ff       	jmp    80106bf5 <alltraps>

80107407 <vector47>:
.globl vector47
vector47:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $47
80107409:	6a 2f                	push   $0x2f
  jmp alltraps
8010740b:	e9 e5 f7 ff ff       	jmp    80106bf5 <alltraps>

80107410 <vector48>:
.globl vector48
vector48:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $48
80107412:	6a 30                	push   $0x30
  jmp alltraps
80107414:	e9 dc f7 ff ff       	jmp    80106bf5 <alltraps>

80107419 <vector49>:
.globl vector49
vector49:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $49
8010741b:	6a 31                	push   $0x31
  jmp alltraps
8010741d:	e9 d3 f7 ff ff       	jmp    80106bf5 <alltraps>

80107422 <vector50>:
.globl vector50
vector50:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $50
80107424:	6a 32                	push   $0x32
  jmp alltraps
80107426:	e9 ca f7 ff ff       	jmp    80106bf5 <alltraps>

8010742b <vector51>:
.globl vector51
vector51:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $51
8010742d:	6a 33                	push   $0x33
  jmp alltraps
8010742f:	e9 c1 f7 ff ff       	jmp    80106bf5 <alltraps>

80107434 <vector52>:
.globl vector52
vector52:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $52
80107436:	6a 34                	push   $0x34
  jmp alltraps
80107438:	e9 b8 f7 ff ff       	jmp    80106bf5 <alltraps>

8010743d <vector53>:
.globl vector53
vector53:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $53
8010743f:	6a 35                	push   $0x35
  jmp alltraps
80107441:	e9 af f7 ff ff       	jmp    80106bf5 <alltraps>

80107446 <vector54>:
.globl vector54
vector54:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $54
80107448:	6a 36                	push   $0x36
  jmp alltraps
8010744a:	e9 a6 f7 ff ff       	jmp    80106bf5 <alltraps>

8010744f <vector55>:
.globl vector55
vector55:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $55
80107451:	6a 37                	push   $0x37
  jmp alltraps
80107453:	e9 9d f7 ff ff       	jmp    80106bf5 <alltraps>

80107458 <vector56>:
.globl vector56
vector56:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $56
8010745a:	6a 38                	push   $0x38
  jmp alltraps
8010745c:	e9 94 f7 ff ff       	jmp    80106bf5 <alltraps>

80107461 <vector57>:
.globl vector57
vector57:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $57
80107463:	6a 39                	push   $0x39
  jmp alltraps
80107465:	e9 8b f7 ff ff       	jmp    80106bf5 <alltraps>

8010746a <vector58>:
.globl vector58
vector58:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $58
8010746c:	6a 3a                	push   $0x3a
  jmp alltraps
8010746e:	e9 82 f7 ff ff       	jmp    80106bf5 <alltraps>

80107473 <vector59>:
.globl vector59
vector59:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $59
80107475:	6a 3b                	push   $0x3b
  jmp alltraps
80107477:	e9 79 f7 ff ff       	jmp    80106bf5 <alltraps>

8010747c <vector60>:
.globl vector60
vector60:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $60
8010747e:	6a 3c                	push   $0x3c
  jmp alltraps
80107480:	e9 70 f7 ff ff       	jmp    80106bf5 <alltraps>

80107485 <vector61>:
.globl vector61
vector61:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $61
80107487:	6a 3d                	push   $0x3d
  jmp alltraps
80107489:	e9 67 f7 ff ff       	jmp    80106bf5 <alltraps>

8010748e <vector62>:
.globl vector62
vector62:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $62
80107490:	6a 3e                	push   $0x3e
  jmp alltraps
80107492:	e9 5e f7 ff ff       	jmp    80106bf5 <alltraps>

80107497 <vector63>:
.globl vector63
vector63:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $63
80107499:	6a 3f                	push   $0x3f
  jmp alltraps
8010749b:	e9 55 f7 ff ff       	jmp    80106bf5 <alltraps>

801074a0 <vector64>:
.globl vector64
vector64:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $64
801074a2:	6a 40                	push   $0x40
  jmp alltraps
801074a4:	e9 4c f7 ff ff       	jmp    80106bf5 <alltraps>

801074a9 <vector65>:
.globl vector65
vector65:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $65
801074ab:	6a 41                	push   $0x41
  jmp alltraps
801074ad:	e9 43 f7 ff ff       	jmp    80106bf5 <alltraps>

801074b2 <vector66>:
.globl vector66
vector66:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $66
801074b4:	6a 42                	push   $0x42
  jmp alltraps
801074b6:	e9 3a f7 ff ff       	jmp    80106bf5 <alltraps>

801074bb <vector67>:
.globl vector67
vector67:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $67
801074bd:	6a 43                	push   $0x43
  jmp alltraps
801074bf:	e9 31 f7 ff ff       	jmp    80106bf5 <alltraps>

801074c4 <vector68>:
.globl vector68
vector68:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $68
801074c6:	6a 44                	push   $0x44
  jmp alltraps
801074c8:	e9 28 f7 ff ff       	jmp    80106bf5 <alltraps>

801074cd <vector69>:
.globl vector69
vector69:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $69
801074cf:	6a 45                	push   $0x45
  jmp alltraps
801074d1:	e9 1f f7 ff ff       	jmp    80106bf5 <alltraps>

801074d6 <vector70>:
.globl vector70
vector70:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $70
801074d8:	6a 46                	push   $0x46
  jmp alltraps
801074da:	e9 16 f7 ff ff       	jmp    80106bf5 <alltraps>

801074df <vector71>:
.globl vector71
vector71:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $71
801074e1:	6a 47                	push   $0x47
  jmp alltraps
801074e3:	e9 0d f7 ff ff       	jmp    80106bf5 <alltraps>

801074e8 <vector72>:
.globl vector72
vector72:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $72
801074ea:	6a 48                	push   $0x48
  jmp alltraps
801074ec:	e9 04 f7 ff ff       	jmp    80106bf5 <alltraps>

801074f1 <vector73>:
.globl vector73
vector73:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $73
801074f3:	6a 49                	push   $0x49
  jmp alltraps
801074f5:	e9 fb f6 ff ff       	jmp    80106bf5 <alltraps>

801074fa <vector74>:
.globl vector74
vector74:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $74
801074fc:	6a 4a                	push   $0x4a
  jmp alltraps
801074fe:	e9 f2 f6 ff ff       	jmp    80106bf5 <alltraps>

80107503 <vector75>:
.globl vector75
vector75:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $75
80107505:	6a 4b                	push   $0x4b
  jmp alltraps
80107507:	e9 e9 f6 ff ff       	jmp    80106bf5 <alltraps>

8010750c <vector76>:
.globl vector76
vector76:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $76
8010750e:	6a 4c                	push   $0x4c
  jmp alltraps
80107510:	e9 e0 f6 ff ff       	jmp    80106bf5 <alltraps>

80107515 <vector77>:
.globl vector77
vector77:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $77
80107517:	6a 4d                	push   $0x4d
  jmp alltraps
80107519:	e9 d7 f6 ff ff       	jmp    80106bf5 <alltraps>

8010751e <vector78>:
.globl vector78
vector78:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $78
80107520:	6a 4e                	push   $0x4e
  jmp alltraps
80107522:	e9 ce f6 ff ff       	jmp    80106bf5 <alltraps>

80107527 <vector79>:
.globl vector79
vector79:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $79
80107529:	6a 4f                	push   $0x4f
  jmp alltraps
8010752b:	e9 c5 f6 ff ff       	jmp    80106bf5 <alltraps>

80107530 <vector80>:
.globl vector80
vector80:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $80
80107532:	6a 50                	push   $0x50
  jmp alltraps
80107534:	e9 bc f6 ff ff       	jmp    80106bf5 <alltraps>

80107539 <vector81>:
.globl vector81
vector81:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $81
8010753b:	6a 51                	push   $0x51
  jmp alltraps
8010753d:	e9 b3 f6 ff ff       	jmp    80106bf5 <alltraps>

80107542 <vector82>:
.globl vector82
vector82:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $82
80107544:	6a 52                	push   $0x52
  jmp alltraps
80107546:	e9 aa f6 ff ff       	jmp    80106bf5 <alltraps>

8010754b <vector83>:
.globl vector83
vector83:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $83
8010754d:	6a 53                	push   $0x53
  jmp alltraps
8010754f:	e9 a1 f6 ff ff       	jmp    80106bf5 <alltraps>

80107554 <vector84>:
.globl vector84
vector84:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $84
80107556:	6a 54                	push   $0x54
  jmp alltraps
80107558:	e9 98 f6 ff ff       	jmp    80106bf5 <alltraps>

8010755d <vector85>:
.globl vector85
vector85:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $85
8010755f:	6a 55                	push   $0x55
  jmp alltraps
80107561:	e9 8f f6 ff ff       	jmp    80106bf5 <alltraps>

80107566 <vector86>:
.globl vector86
vector86:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $86
80107568:	6a 56                	push   $0x56
  jmp alltraps
8010756a:	e9 86 f6 ff ff       	jmp    80106bf5 <alltraps>

8010756f <vector87>:
.globl vector87
vector87:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $87
80107571:	6a 57                	push   $0x57
  jmp alltraps
80107573:	e9 7d f6 ff ff       	jmp    80106bf5 <alltraps>

80107578 <vector88>:
.globl vector88
vector88:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $88
8010757a:	6a 58                	push   $0x58
  jmp alltraps
8010757c:	e9 74 f6 ff ff       	jmp    80106bf5 <alltraps>

80107581 <vector89>:
.globl vector89
vector89:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $89
80107583:	6a 59                	push   $0x59
  jmp alltraps
80107585:	e9 6b f6 ff ff       	jmp    80106bf5 <alltraps>

8010758a <vector90>:
.globl vector90
vector90:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $90
8010758c:	6a 5a                	push   $0x5a
  jmp alltraps
8010758e:	e9 62 f6 ff ff       	jmp    80106bf5 <alltraps>

80107593 <vector91>:
.globl vector91
vector91:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $91
80107595:	6a 5b                	push   $0x5b
  jmp alltraps
80107597:	e9 59 f6 ff ff       	jmp    80106bf5 <alltraps>

8010759c <vector92>:
.globl vector92
vector92:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $92
8010759e:	6a 5c                	push   $0x5c
  jmp alltraps
801075a0:	e9 50 f6 ff ff       	jmp    80106bf5 <alltraps>

801075a5 <vector93>:
.globl vector93
vector93:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $93
801075a7:	6a 5d                	push   $0x5d
  jmp alltraps
801075a9:	e9 47 f6 ff ff       	jmp    80106bf5 <alltraps>

801075ae <vector94>:
.globl vector94
vector94:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $94
801075b0:	6a 5e                	push   $0x5e
  jmp alltraps
801075b2:	e9 3e f6 ff ff       	jmp    80106bf5 <alltraps>

801075b7 <vector95>:
.globl vector95
vector95:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $95
801075b9:	6a 5f                	push   $0x5f
  jmp alltraps
801075bb:	e9 35 f6 ff ff       	jmp    80106bf5 <alltraps>

801075c0 <vector96>:
.globl vector96
vector96:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $96
801075c2:	6a 60                	push   $0x60
  jmp alltraps
801075c4:	e9 2c f6 ff ff       	jmp    80106bf5 <alltraps>

801075c9 <vector97>:
.globl vector97
vector97:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $97
801075cb:	6a 61                	push   $0x61
  jmp alltraps
801075cd:	e9 23 f6 ff ff       	jmp    80106bf5 <alltraps>

801075d2 <vector98>:
.globl vector98
vector98:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $98
801075d4:	6a 62                	push   $0x62
  jmp alltraps
801075d6:	e9 1a f6 ff ff       	jmp    80106bf5 <alltraps>

801075db <vector99>:
.globl vector99
vector99:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $99
801075dd:	6a 63                	push   $0x63
  jmp alltraps
801075df:	e9 11 f6 ff ff       	jmp    80106bf5 <alltraps>

801075e4 <vector100>:
.globl vector100
vector100:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $100
801075e6:	6a 64                	push   $0x64
  jmp alltraps
801075e8:	e9 08 f6 ff ff       	jmp    80106bf5 <alltraps>

801075ed <vector101>:
.globl vector101
vector101:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $101
801075ef:	6a 65                	push   $0x65
  jmp alltraps
801075f1:	e9 ff f5 ff ff       	jmp    80106bf5 <alltraps>

801075f6 <vector102>:
.globl vector102
vector102:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $102
801075f8:	6a 66                	push   $0x66
  jmp alltraps
801075fa:	e9 f6 f5 ff ff       	jmp    80106bf5 <alltraps>

801075ff <vector103>:
.globl vector103
vector103:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $103
80107601:	6a 67                	push   $0x67
  jmp alltraps
80107603:	e9 ed f5 ff ff       	jmp    80106bf5 <alltraps>

80107608 <vector104>:
.globl vector104
vector104:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $104
8010760a:	6a 68                	push   $0x68
  jmp alltraps
8010760c:	e9 e4 f5 ff ff       	jmp    80106bf5 <alltraps>

80107611 <vector105>:
.globl vector105
vector105:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $105
80107613:	6a 69                	push   $0x69
  jmp alltraps
80107615:	e9 db f5 ff ff       	jmp    80106bf5 <alltraps>

8010761a <vector106>:
.globl vector106
vector106:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $106
8010761c:	6a 6a                	push   $0x6a
  jmp alltraps
8010761e:	e9 d2 f5 ff ff       	jmp    80106bf5 <alltraps>

80107623 <vector107>:
.globl vector107
vector107:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $107
80107625:	6a 6b                	push   $0x6b
  jmp alltraps
80107627:	e9 c9 f5 ff ff       	jmp    80106bf5 <alltraps>

8010762c <vector108>:
.globl vector108
vector108:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $108
8010762e:	6a 6c                	push   $0x6c
  jmp alltraps
80107630:	e9 c0 f5 ff ff       	jmp    80106bf5 <alltraps>

80107635 <vector109>:
.globl vector109
vector109:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $109
80107637:	6a 6d                	push   $0x6d
  jmp alltraps
80107639:	e9 b7 f5 ff ff       	jmp    80106bf5 <alltraps>

8010763e <vector110>:
.globl vector110
vector110:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $110
80107640:	6a 6e                	push   $0x6e
  jmp alltraps
80107642:	e9 ae f5 ff ff       	jmp    80106bf5 <alltraps>

80107647 <vector111>:
.globl vector111
vector111:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $111
80107649:	6a 6f                	push   $0x6f
  jmp alltraps
8010764b:	e9 a5 f5 ff ff       	jmp    80106bf5 <alltraps>

80107650 <vector112>:
.globl vector112
vector112:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $112
80107652:	6a 70                	push   $0x70
  jmp alltraps
80107654:	e9 9c f5 ff ff       	jmp    80106bf5 <alltraps>

80107659 <vector113>:
.globl vector113
vector113:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $113
8010765b:	6a 71                	push   $0x71
  jmp alltraps
8010765d:	e9 93 f5 ff ff       	jmp    80106bf5 <alltraps>

80107662 <vector114>:
.globl vector114
vector114:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $114
80107664:	6a 72                	push   $0x72
  jmp alltraps
80107666:	e9 8a f5 ff ff       	jmp    80106bf5 <alltraps>

8010766b <vector115>:
.globl vector115
vector115:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $115
8010766d:	6a 73                	push   $0x73
  jmp alltraps
8010766f:	e9 81 f5 ff ff       	jmp    80106bf5 <alltraps>

80107674 <vector116>:
.globl vector116
vector116:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $116
80107676:	6a 74                	push   $0x74
  jmp alltraps
80107678:	e9 78 f5 ff ff       	jmp    80106bf5 <alltraps>

8010767d <vector117>:
.globl vector117
vector117:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $117
8010767f:	6a 75                	push   $0x75
  jmp alltraps
80107681:	e9 6f f5 ff ff       	jmp    80106bf5 <alltraps>

80107686 <vector118>:
.globl vector118
vector118:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $118
80107688:	6a 76                	push   $0x76
  jmp alltraps
8010768a:	e9 66 f5 ff ff       	jmp    80106bf5 <alltraps>

8010768f <vector119>:
.globl vector119
vector119:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $119
80107691:	6a 77                	push   $0x77
  jmp alltraps
80107693:	e9 5d f5 ff ff       	jmp    80106bf5 <alltraps>

80107698 <vector120>:
.globl vector120
vector120:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $120
8010769a:	6a 78                	push   $0x78
  jmp alltraps
8010769c:	e9 54 f5 ff ff       	jmp    80106bf5 <alltraps>

801076a1 <vector121>:
.globl vector121
vector121:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $121
801076a3:	6a 79                	push   $0x79
  jmp alltraps
801076a5:	e9 4b f5 ff ff       	jmp    80106bf5 <alltraps>

801076aa <vector122>:
.globl vector122
vector122:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $122
801076ac:	6a 7a                	push   $0x7a
  jmp alltraps
801076ae:	e9 42 f5 ff ff       	jmp    80106bf5 <alltraps>

801076b3 <vector123>:
.globl vector123
vector123:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $123
801076b5:	6a 7b                	push   $0x7b
  jmp alltraps
801076b7:	e9 39 f5 ff ff       	jmp    80106bf5 <alltraps>

801076bc <vector124>:
.globl vector124
vector124:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $124
801076be:	6a 7c                	push   $0x7c
  jmp alltraps
801076c0:	e9 30 f5 ff ff       	jmp    80106bf5 <alltraps>

801076c5 <vector125>:
.globl vector125
vector125:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $125
801076c7:	6a 7d                	push   $0x7d
  jmp alltraps
801076c9:	e9 27 f5 ff ff       	jmp    80106bf5 <alltraps>

801076ce <vector126>:
.globl vector126
vector126:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $126
801076d0:	6a 7e                	push   $0x7e
  jmp alltraps
801076d2:	e9 1e f5 ff ff       	jmp    80106bf5 <alltraps>

801076d7 <vector127>:
.globl vector127
vector127:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $127
801076d9:	6a 7f                	push   $0x7f
  jmp alltraps
801076db:	e9 15 f5 ff ff       	jmp    80106bf5 <alltraps>

801076e0 <vector128>:
.globl vector128
vector128:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $128
801076e2:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801076e7:	e9 09 f5 ff ff       	jmp    80106bf5 <alltraps>

801076ec <vector129>:
.globl vector129
vector129:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $129
801076ee:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801076f3:	e9 fd f4 ff ff       	jmp    80106bf5 <alltraps>

801076f8 <vector130>:
.globl vector130
vector130:
  pushl $0
801076f8:	6a 00                	push   $0x0
  pushl $130
801076fa:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801076ff:	e9 f1 f4 ff ff       	jmp    80106bf5 <alltraps>

80107704 <vector131>:
.globl vector131
vector131:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $131
80107706:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010770b:	e9 e5 f4 ff ff       	jmp    80106bf5 <alltraps>

80107710 <vector132>:
.globl vector132
vector132:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $132
80107712:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107717:	e9 d9 f4 ff ff       	jmp    80106bf5 <alltraps>

8010771c <vector133>:
.globl vector133
vector133:
  pushl $0
8010771c:	6a 00                	push   $0x0
  pushl $133
8010771e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107723:	e9 cd f4 ff ff       	jmp    80106bf5 <alltraps>

80107728 <vector134>:
.globl vector134
vector134:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $134
8010772a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010772f:	e9 c1 f4 ff ff       	jmp    80106bf5 <alltraps>

80107734 <vector135>:
.globl vector135
vector135:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $135
80107736:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010773b:	e9 b5 f4 ff ff       	jmp    80106bf5 <alltraps>

80107740 <vector136>:
.globl vector136
vector136:
  pushl $0
80107740:	6a 00                	push   $0x0
  pushl $136
80107742:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107747:	e9 a9 f4 ff ff       	jmp    80106bf5 <alltraps>

8010774c <vector137>:
.globl vector137
vector137:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $137
8010774e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107753:	e9 9d f4 ff ff       	jmp    80106bf5 <alltraps>

80107758 <vector138>:
.globl vector138
vector138:
  pushl $0
80107758:	6a 00                	push   $0x0
  pushl $138
8010775a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010775f:	e9 91 f4 ff ff       	jmp    80106bf5 <alltraps>

80107764 <vector139>:
.globl vector139
vector139:
  pushl $0
80107764:	6a 00                	push   $0x0
  pushl $139
80107766:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010776b:	e9 85 f4 ff ff       	jmp    80106bf5 <alltraps>

80107770 <vector140>:
.globl vector140
vector140:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $140
80107772:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107777:	e9 79 f4 ff ff       	jmp    80106bf5 <alltraps>

8010777c <vector141>:
.globl vector141
vector141:
  pushl $0
8010777c:	6a 00                	push   $0x0
  pushl $141
8010777e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107783:	e9 6d f4 ff ff       	jmp    80106bf5 <alltraps>

80107788 <vector142>:
.globl vector142
vector142:
  pushl $0
80107788:	6a 00                	push   $0x0
  pushl $142
8010778a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010778f:	e9 61 f4 ff ff       	jmp    80106bf5 <alltraps>

80107794 <vector143>:
.globl vector143
vector143:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $143
80107796:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010779b:	e9 55 f4 ff ff       	jmp    80106bf5 <alltraps>

801077a0 <vector144>:
.globl vector144
vector144:
  pushl $0
801077a0:	6a 00                	push   $0x0
  pushl $144
801077a2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801077a7:	e9 49 f4 ff ff       	jmp    80106bf5 <alltraps>

801077ac <vector145>:
.globl vector145
vector145:
  pushl $0
801077ac:	6a 00                	push   $0x0
  pushl $145
801077ae:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801077b3:	e9 3d f4 ff ff       	jmp    80106bf5 <alltraps>

801077b8 <vector146>:
.globl vector146
vector146:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $146
801077ba:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801077bf:	e9 31 f4 ff ff       	jmp    80106bf5 <alltraps>

801077c4 <vector147>:
.globl vector147
vector147:
  pushl $0
801077c4:	6a 00                	push   $0x0
  pushl $147
801077c6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801077cb:	e9 25 f4 ff ff       	jmp    80106bf5 <alltraps>

801077d0 <vector148>:
.globl vector148
vector148:
  pushl $0
801077d0:	6a 00                	push   $0x0
  pushl $148
801077d2:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801077d7:	e9 19 f4 ff ff       	jmp    80106bf5 <alltraps>

801077dc <vector149>:
.globl vector149
vector149:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $149
801077de:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801077e3:	e9 0d f4 ff ff       	jmp    80106bf5 <alltraps>

801077e8 <vector150>:
.globl vector150
vector150:
  pushl $0
801077e8:	6a 00                	push   $0x0
  pushl $150
801077ea:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801077ef:	e9 01 f4 ff ff       	jmp    80106bf5 <alltraps>

801077f4 <vector151>:
.globl vector151
vector151:
  pushl $0
801077f4:	6a 00                	push   $0x0
  pushl $151
801077f6:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801077fb:	e9 f5 f3 ff ff       	jmp    80106bf5 <alltraps>

80107800 <vector152>:
.globl vector152
vector152:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $152
80107802:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107807:	e9 e9 f3 ff ff       	jmp    80106bf5 <alltraps>

8010780c <vector153>:
.globl vector153
vector153:
  pushl $0
8010780c:	6a 00                	push   $0x0
  pushl $153
8010780e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107813:	e9 dd f3 ff ff       	jmp    80106bf5 <alltraps>

80107818 <vector154>:
.globl vector154
vector154:
  pushl $0
80107818:	6a 00                	push   $0x0
  pushl $154
8010781a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010781f:	e9 d1 f3 ff ff       	jmp    80106bf5 <alltraps>

80107824 <vector155>:
.globl vector155
vector155:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $155
80107826:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010782b:	e9 c5 f3 ff ff       	jmp    80106bf5 <alltraps>

80107830 <vector156>:
.globl vector156
vector156:
  pushl $0
80107830:	6a 00                	push   $0x0
  pushl $156
80107832:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107837:	e9 b9 f3 ff ff       	jmp    80106bf5 <alltraps>

8010783c <vector157>:
.globl vector157
vector157:
  pushl $0
8010783c:	6a 00                	push   $0x0
  pushl $157
8010783e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107843:	e9 ad f3 ff ff       	jmp    80106bf5 <alltraps>

80107848 <vector158>:
.globl vector158
vector158:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $158
8010784a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010784f:	e9 a1 f3 ff ff       	jmp    80106bf5 <alltraps>

80107854 <vector159>:
.globl vector159
vector159:
  pushl $0
80107854:	6a 00                	push   $0x0
  pushl $159
80107856:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010785b:	e9 95 f3 ff ff       	jmp    80106bf5 <alltraps>

80107860 <vector160>:
.globl vector160
vector160:
  pushl $0
80107860:	6a 00                	push   $0x0
  pushl $160
80107862:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107867:	e9 89 f3 ff ff       	jmp    80106bf5 <alltraps>

8010786c <vector161>:
.globl vector161
vector161:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $161
8010786e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107873:	e9 7d f3 ff ff       	jmp    80106bf5 <alltraps>

80107878 <vector162>:
.globl vector162
vector162:
  pushl $0
80107878:	6a 00                	push   $0x0
  pushl $162
8010787a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010787f:	e9 71 f3 ff ff       	jmp    80106bf5 <alltraps>

80107884 <vector163>:
.globl vector163
vector163:
  pushl $0
80107884:	6a 00                	push   $0x0
  pushl $163
80107886:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010788b:	e9 65 f3 ff ff       	jmp    80106bf5 <alltraps>

80107890 <vector164>:
.globl vector164
vector164:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $164
80107892:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107897:	e9 59 f3 ff ff       	jmp    80106bf5 <alltraps>

8010789c <vector165>:
.globl vector165
vector165:
  pushl $0
8010789c:	6a 00                	push   $0x0
  pushl $165
8010789e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801078a3:	e9 4d f3 ff ff       	jmp    80106bf5 <alltraps>

801078a8 <vector166>:
.globl vector166
vector166:
  pushl $0
801078a8:	6a 00                	push   $0x0
  pushl $166
801078aa:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801078af:	e9 41 f3 ff ff       	jmp    80106bf5 <alltraps>

801078b4 <vector167>:
.globl vector167
vector167:
  pushl $0
801078b4:	6a 00                	push   $0x0
  pushl $167
801078b6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801078bb:	e9 35 f3 ff ff       	jmp    80106bf5 <alltraps>

801078c0 <vector168>:
.globl vector168
vector168:
  pushl $0
801078c0:	6a 00                	push   $0x0
  pushl $168
801078c2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801078c7:	e9 29 f3 ff ff       	jmp    80106bf5 <alltraps>

801078cc <vector169>:
.globl vector169
vector169:
  pushl $0
801078cc:	6a 00                	push   $0x0
  pushl $169
801078ce:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801078d3:	e9 1d f3 ff ff       	jmp    80106bf5 <alltraps>

801078d8 <vector170>:
.globl vector170
vector170:
  pushl $0
801078d8:	6a 00                	push   $0x0
  pushl $170
801078da:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801078df:	e9 11 f3 ff ff       	jmp    80106bf5 <alltraps>

801078e4 <vector171>:
.globl vector171
vector171:
  pushl $0
801078e4:	6a 00                	push   $0x0
  pushl $171
801078e6:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801078eb:	e9 05 f3 ff ff       	jmp    80106bf5 <alltraps>

801078f0 <vector172>:
.globl vector172
vector172:
  pushl $0
801078f0:	6a 00                	push   $0x0
  pushl $172
801078f2:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801078f7:	e9 f9 f2 ff ff       	jmp    80106bf5 <alltraps>

801078fc <vector173>:
.globl vector173
vector173:
  pushl $0
801078fc:	6a 00                	push   $0x0
  pushl $173
801078fe:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107903:	e9 ed f2 ff ff       	jmp    80106bf5 <alltraps>

80107908 <vector174>:
.globl vector174
vector174:
  pushl $0
80107908:	6a 00                	push   $0x0
  pushl $174
8010790a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010790f:	e9 e1 f2 ff ff       	jmp    80106bf5 <alltraps>

80107914 <vector175>:
.globl vector175
vector175:
  pushl $0
80107914:	6a 00                	push   $0x0
  pushl $175
80107916:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010791b:	e9 d5 f2 ff ff       	jmp    80106bf5 <alltraps>

80107920 <vector176>:
.globl vector176
vector176:
  pushl $0
80107920:	6a 00                	push   $0x0
  pushl $176
80107922:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107927:	e9 c9 f2 ff ff       	jmp    80106bf5 <alltraps>

8010792c <vector177>:
.globl vector177
vector177:
  pushl $0
8010792c:	6a 00                	push   $0x0
  pushl $177
8010792e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107933:	e9 bd f2 ff ff       	jmp    80106bf5 <alltraps>

80107938 <vector178>:
.globl vector178
vector178:
  pushl $0
80107938:	6a 00                	push   $0x0
  pushl $178
8010793a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010793f:	e9 b1 f2 ff ff       	jmp    80106bf5 <alltraps>

80107944 <vector179>:
.globl vector179
vector179:
  pushl $0
80107944:	6a 00                	push   $0x0
  pushl $179
80107946:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010794b:	e9 a5 f2 ff ff       	jmp    80106bf5 <alltraps>

80107950 <vector180>:
.globl vector180
vector180:
  pushl $0
80107950:	6a 00                	push   $0x0
  pushl $180
80107952:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107957:	e9 99 f2 ff ff       	jmp    80106bf5 <alltraps>

8010795c <vector181>:
.globl vector181
vector181:
  pushl $0
8010795c:	6a 00                	push   $0x0
  pushl $181
8010795e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107963:	e9 8d f2 ff ff       	jmp    80106bf5 <alltraps>

80107968 <vector182>:
.globl vector182
vector182:
  pushl $0
80107968:	6a 00                	push   $0x0
  pushl $182
8010796a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010796f:	e9 81 f2 ff ff       	jmp    80106bf5 <alltraps>

80107974 <vector183>:
.globl vector183
vector183:
  pushl $0
80107974:	6a 00                	push   $0x0
  pushl $183
80107976:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010797b:	e9 75 f2 ff ff       	jmp    80106bf5 <alltraps>

80107980 <vector184>:
.globl vector184
vector184:
  pushl $0
80107980:	6a 00                	push   $0x0
  pushl $184
80107982:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107987:	e9 69 f2 ff ff       	jmp    80106bf5 <alltraps>

8010798c <vector185>:
.globl vector185
vector185:
  pushl $0
8010798c:	6a 00                	push   $0x0
  pushl $185
8010798e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107993:	e9 5d f2 ff ff       	jmp    80106bf5 <alltraps>

80107998 <vector186>:
.globl vector186
vector186:
  pushl $0
80107998:	6a 00                	push   $0x0
  pushl $186
8010799a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010799f:	e9 51 f2 ff ff       	jmp    80106bf5 <alltraps>

801079a4 <vector187>:
.globl vector187
vector187:
  pushl $0
801079a4:	6a 00                	push   $0x0
  pushl $187
801079a6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801079ab:	e9 45 f2 ff ff       	jmp    80106bf5 <alltraps>

801079b0 <vector188>:
.globl vector188
vector188:
  pushl $0
801079b0:	6a 00                	push   $0x0
  pushl $188
801079b2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801079b7:	e9 39 f2 ff ff       	jmp    80106bf5 <alltraps>

801079bc <vector189>:
.globl vector189
vector189:
  pushl $0
801079bc:	6a 00                	push   $0x0
  pushl $189
801079be:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801079c3:	e9 2d f2 ff ff       	jmp    80106bf5 <alltraps>

801079c8 <vector190>:
.globl vector190
vector190:
  pushl $0
801079c8:	6a 00                	push   $0x0
  pushl $190
801079ca:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801079cf:	e9 21 f2 ff ff       	jmp    80106bf5 <alltraps>

801079d4 <vector191>:
.globl vector191
vector191:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $191
801079d6:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801079db:	e9 15 f2 ff ff       	jmp    80106bf5 <alltraps>

801079e0 <vector192>:
.globl vector192
vector192:
  pushl $0
801079e0:	6a 00                	push   $0x0
  pushl $192
801079e2:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801079e7:	e9 09 f2 ff ff       	jmp    80106bf5 <alltraps>

801079ec <vector193>:
.globl vector193
vector193:
  pushl $0
801079ec:	6a 00                	push   $0x0
  pushl $193
801079ee:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801079f3:	e9 fd f1 ff ff       	jmp    80106bf5 <alltraps>

801079f8 <vector194>:
.globl vector194
vector194:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $194
801079fa:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801079ff:	e9 f1 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a04 <vector195>:
.globl vector195
vector195:
  pushl $0
80107a04:	6a 00                	push   $0x0
  pushl $195
80107a06:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a0b:	e9 e5 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a10 <vector196>:
.globl vector196
vector196:
  pushl $0
80107a10:	6a 00                	push   $0x0
  pushl $196
80107a12:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a17:	e9 d9 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a1c <vector197>:
.globl vector197
vector197:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $197
80107a1e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107a23:	e9 cd f1 ff ff       	jmp    80106bf5 <alltraps>

80107a28 <vector198>:
.globl vector198
vector198:
  pushl $0
80107a28:	6a 00                	push   $0x0
  pushl $198
80107a2a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107a2f:	e9 c1 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a34 <vector199>:
.globl vector199
vector199:
  pushl $0
80107a34:	6a 00                	push   $0x0
  pushl $199
80107a36:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107a3b:	e9 b5 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a40 <vector200>:
.globl vector200
vector200:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $200
80107a42:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107a47:	e9 a9 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a4c <vector201>:
.globl vector201
vector201:
  pushl $0
80107a4c:	6a 00                	push   $0x0
  pushl $201
80107a4e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107a53:	e9 9d f1 ff ff       	jmp    80106bf5 <alltraps>

80107a58 <vector202>:
.globl vector202
vector202:
  pushl $0
80107a58:	6a 00                	push   $0x0
  pushl $202
80107a5a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107a5f:	e9 91 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a64 <vector203>:
.globl vector203
vector203:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $203
80107a66:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107a6b:	e9 85 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a70 <vector204>:
.globl vector204
vector204:
  pushl $0
80107a70:	6a 00                	push   $0x0
  pushl $204
80107a72:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a77:	e9 79 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a7c <vector205>:
.globl vector205
vector205:
  pushl $0
80107a7c:	6a 00                	push   $0x0
  pushl $205
80107a7e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a83:	e9 6d f1 ff ff       	jmp    80106bf5 <alltraps>

80107a88 <vector206>:
.globl vector206
vector206:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $206
80107a8a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a8f:	e9 61 f1 ff ff       	jmp    80106bf5 <alltraps>

80107a94 <vector207>:
.globl vector207
vector207:
  pushl $0
80107a94:	6a 00                	push   $0x0
  pushl $207
80107a96:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a9b:	e9 55 f1 ff ff       	jmp    80106bf5 <alltraps>

80107aa0 <vector208>:
.globl vector208
vector208:
  pushl $0
80107aa0:	6a 00                	push   $0x0
  pushl $208
80107aa2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107aa7:	e9 49 f1 ff ff       	jmp    80106bf5 <alltraps>

80107aac <vector209>:
.globl vector209
vector209:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $209
80107aae:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107ab3:	e9 3d f1 ff ff       	jmp    80106bf5 <alltraps>

80107ab8 <vector210>:
.globl vector210
vector210:
  pushl $0
80107ab8:	6a 00                	push   $0x0
  pushl $210
80107aba:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107abf:	e9 31 f1 ff ff       	jmp    80106bf5 <alltraps>

80107ac4 <vector211>:
.globl vector211
vector211:
  pushl $0
80107ac4:	6a 00                	push   $0x0
  pushl $211
80107ac6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107acb:	e9 25 f1 ff ff       	jmp    80106bf5 <alltraps>

80107ad0 <vector212>:
.globl vector212
vector212:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $212
80107ad2:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107ad7:	e9 19 f1 ff ff       	jmp    80106bf5 <alltraps>

80107adc <vector213>:
.globl vector213
vector213:
  pushl $0
80107adc:	6a 00                	push   $0x0
  pushl $213
80107ade:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ae3:	e9 0d f1 ff ff       	jmp    80106bf5 <alltraps>

80107ae8 <vector214>:
.globl vector214
vector214:
  pushl $0
80107ae8:	6a 00                	push   $0x0
  pushl $214
80107aea:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107aef:	e9 01 f1 ff ff       	jmp    80106bf5 <alltraps>

80107af4 <vector215>:
.globl vector215
vector215:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $215
80107af6:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107afb:	e9 f5 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b00 <vector216>:
.globl vector216
vector216:
  pushl $0
80107b00:	6a 00                	push   $0x0
  pushl $216
80107b02:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b07:	e9 e9 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b0c <vector217>:
.globl vector217
vector217:
  pushl $0
80107b0c:	6a 00                	push   $0x0
  pushl $217
80107b0e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b13:	e9 dd f0 ff ff       	jmp    80106bf5 <alltraps>

80107b18 <vector218>:
.globl vector218
vector218:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $218
80107b1a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107b1f:	e9 d1 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b24 <vector219>:
.globl vector219
vector219:
  pushl $0
80107b24:	6a 00                	push   $0x0
  pushl $219
80107b26:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107b2b:	e9 c5 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b30 <vector220>:
.globl vector220
vector220:
  pushl $0
80107b30:	6a 00                	push   $0x0
  pushl $220
80107b32:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107b37:	e9 b9 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b3c <vector221>:
.globl vector221
vector221:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $221
80107b3e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107b43:	e9 ad f0 ff ff       	jmp    80106bf5 <alltraps>

80107b48 <vector222>:
.globl vector222
vector222:
  pushl $0
80107b48:	6a 00                	push   $0x0
  pushl $222
80107b4a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107b4f:	e9 a1 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b54 <vector223>:
.globl vector223
vector223:
  pushl $0
80107b54:	6a 00                	push   $0x0
  pushl $223
80107b56:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107b5b:	e9 95 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b60 <vector224>:
.globl vector224
vector224:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $224
80107b62:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107b67:	e9 89 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b6c <vector225>:
.globl vector225
vector225:
  pushl $0
80107b6c:	6a 00                	push   $0x0
  pushl $225
80107b6e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b73:	e9 7d f0 ff ff       	jmp    80106bf5 <alltraps>

80107b78 <vector226>:
.globl vector226
vector226:
  pushl $0
80107b78:	6a 00                	push   $0x0
  pushl $226
80107b7a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b7f:	e9 71 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b84 <vector227>:
.globl vector227
vector227:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $227
80107b86:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b8b:	e9 65 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b90 <vector228>:
.globl vector228
vector228:
  pushl $0
80107b90:	6a 00                	push   $0x0
  pushl $228
80107b92:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b97:	e9 59 f0 ff ff       	jmp    80106bf5 <alltraps>

80107b9c <vector229>:
.globl vector229
vector229:
  pushl $0
80107b9c:	6a 00                	push   $0x0
  pushl $229
80107b9e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107ba3:	e9 4d f0 ff ff       	jmp    80106bf5 <alltraps>

80107ba8 <vector230>:
.globl vector230
vector230:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $230
80107baa:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107baf:	e9 41 f0 ff ff       	jmp    80106bf5 <alltraps>

80107bb4 <vector231>:
.globl vector231
vector231:
  pushl $0
80107bb4:	6a 00                	push   $0x0
  pushl $231
80107bb6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107bbb:	e9 35 f0 ff ff       	jmp    80106bf5 <alltraps>

80107bc0 <vector232>:
.globl vector232
vector232:
  pushl $0
80107bc0:	6a 00                	push   $0x0
  pushl $232
80107bc2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107bc7:	e9 29 f0 ff ff       	jmp    80106bf5 <alltraps>

80107bcc <vector233>:
.globl vector233
vector233:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $233
80107bce:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107bd3:	e9 1d f0 ff ff       	jmp    80106bf5 <alltraps>

80107bd8 <vector234>:
.globl vector234
vector234:
  pushl $0
80107bd8:	6a 00                	push   $0x0
  pushl $234
80107bda:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107bdf:	e9 11 f0 ff ff       	jmp    80106bf5 <alltraps>

80107be4 <vector235>:
.globl vector235
vector235:
  pushl $0
80107be4:	6a 00                	push   $0x0
  pushl $235
80107be6:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107beb:	e9 05 f0 ff ff       	jmp    80106bf5 <alltraps>

80107bf0 <vector236>:
.globl vector236
vector236:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $236
80107bf2:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107bf7:	e9 f9 ef ff ff       	jmp    80106bf5 <alltraps>

80107bfc <vector237>:
.globl vector237
vector237:
  pushl $0
80107bfc:	6a 00                	push   $0x0
  pushl $237
80107bfe:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c03:	e9 ed ef ff ff       	jmp    80106bf5 <alltraps>

80107c08 <vector238>:
.globl vector238
vector238:
  pushl $0
80107c08:	6a 00                	push   $0x0
  pushl $238
80107c0a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c0f:	e9 e1 ef ff ff       	jmp    80106bf5 <alltraps>

80107c14 <vector239>:
.globl vector239
vector239:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $239
80107c16:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107c1b:	e9 d5 ef ff ff       	jmp    80106bf5 <alltraps>

80107c20 <vector240>:
.globl vector240
vector240:
  pushl $0
80107c20:	6a 00                	push   $0x0
  pushl $240
80107c22:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107c27:	e9 c9 ef ff ff       	jmp    80106bf5 <alltraps>

80107c2c <vector241>:
.globl vector241
vector241:
  pushl $0
80107c2c:	6a 00                	push   $0x0
  pushl $241
80107c2e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107c33:	e9 bd ef ff ff       	jmp    80106bf5 <alltraps>

80107c38 <vector242>:
.globl vector242
vector242:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $242
80107c3a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107c3f:	e9 b1 ef ff ff       	jmp    80106bf5 <alltraps>

80107c44 <vector243>:
.globl vector243
vector243:
  pushl $0
80107c44:	6a 00                	push   $0x0
  pushl $243
80107c46:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107c4b:	e9 a5 ef ff ff       	jmp    80106bf5 <alltraps>

80107c50 <vector244>:
.globl vector244
vector244:
  pushl $0
80107c50:	6a 00                	push   $0x0
  pushl $244
80107c52:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107c57:	e9 99 ef ff ff       	jmp    80106bf5 <alltraps>

80107c5c <vector245>:
.globl vector245
vector245:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $245
80107c5e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107c63:	e9 8d ef ff ff       	jmp    80106bf5 <alltraps>

80107c68 <vector246>:
.globl vector246
vector246:
  pushl $0
80107c68:	6a 00                	push   $0x0
  pushl $246
80107c6a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c6f:	e9 81 ef ff ff       	jmp    80106bf5 <alltraps>

80107c74 <vector247>:
.globl vector247
vector247:
  pushl $0
80107c74:	6a 00                	push   $0x0
  pushl $247
80107c76:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c7b:	e9 75 ef ff ff       	jmp    80106bf5 <alltraps>

80107c80 <vector248>:
.globl vector248
vector248:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $248
80107c82:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c87:	e9 69 ef ff ff       	jmp    80106bf5 <alltraps>

80107c8c <vector249>:
.globl vector249
vector249:
  pushl $0
80107c8c:	6a 00                	push   $0x0
  pushl $249
80107c8e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c93:	e9 5d ef ff ff       	jmp    80106bf5 <alltraps>

80107c98 <vector250>:
.globl vector250
vector250:
  pushl $0
80107c98:	6a 00                	push   $0x0
  pushl $250
80107c9a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c9f:	e9 51 ef ff ff       	jmp    80106bf5 <alltraps>

80107ca4 <vector251>:
.globl vector251
vector251:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $251
80107ca6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107cab:	e9 45 ef ff ff       	jmp    80106bf5 <alltraps>

80107cb0 <vector252>:
.globl vector252
vector252:
  pushl $0
80107cb0:	6a 00                	push   $0x0
  pushl $252
80107cb2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107cb7:	e9 39 ef ff ff       	jmp    80106bf5 <alltraps>

80107cbc <vector253>:
.globl vector253
vector253:
  pushl $0
80107cbc:	6a 00                	push   $0x0
  pushl $253
80107cbe:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107cc3:	e9 2d ef ff ff       	jmp    80106bf5 <alltraps>

80107cc8 <vector254>:
.globl vector254
vector254:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $254
80107cca:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107ccf:	e9 21 ef ff ff       	jmp    80106bf5 <alltraps>

80107cd4 <vector255>:
.globl vector255
vector255:
  pushl $0
80107cd4:	6a 00                	push   $0x0
  pushl $255
80107cd6:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107cdb:	e9 15 ef ff ff       	jmp    80106bf5 <alltraps>

80107ce0 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce9:	83 e8 01             	sub    $0x1,%eax
80107cec:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80107cfa:	c1 e8 10             	shr    $0x10,%eax
80107cfd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107d01:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d04:	0f 01 10             	lgdtl  (%eax)
}
80107d07:	c9                   	leave  
80107d08:	c3                   	ret    

80107d09 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107d09:	55                   	push   %ebp
80107d0a:	89 e5                	mov    %esp,%ebp
80107d0c:	83 ec 04             	sub    $0x4,%esp
80107d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d12:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107d16:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d1a:	0f 00 d8             	ltr    %ax
}
80107d1d:	c9                   	leave  
80107d1e:	c3                   	ret    

80107d1f <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107d1f:	55                   	push   %ebp
80107d20:	89 e5                	mov    %esp,%ebp
80107d22:	83 ec 04             	sub    $0x4,%esp
80107d25:	8b 45 08             	mov    0x8(%ebp),%eax
80107d28:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107d2c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107d30:	8e e8                	mov    %eax,%gs
}
80107d32:	c9                   	leave  
80107d33:	c3                   	ret    

80107d34 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107d34:	55                   	push   %ebp
80107d35:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d37:	8b 45 08             	mov    0x8(%ebp),%eax
80107d3a:	0f 22 d8             	mov    %eax,%cr3
}
80107d3d:	5d                   	pop    %ebp
80107d3e:	c3                   	ret    

80107d3f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107d3f:	55                   	push   %ebp
80107d40:	89 e5                	mov    %esp,%ebp
80107d42:	8b 45 08             	mov    0x8(%ebp),%eax
80107d45:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4a:	5d                   	pop    %ebp
80107d4b:	c3                   	ret    

80107d4c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107d4c:	55                   	push   %ebp
80107d4d:	89 e5                	mov    %esp,%ebp
80107d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d52:	05 00 00 00 80       	add    $0x80000000,%eax
80107d57:	5d                   	pop    %ebp
80107d58:	c3                   	ret    

80107d59 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107d59:	55                   	push   %ebp
80107d5a:	89 e5                	mov    %esp,%ebp
80107d5c:	53                   	push   %ebx
80107d5d:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107d60:	e8 2c b2 ff ff       	call   80102f91 <cpunum>
80107d65:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107d6b:	05 60 09 11 80       	add    $0x80110960,%eax
80107d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d76:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d88:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d93:	83 e2 f0             	and    $0xfffffff0,%edx
80107d96:	83 ca 0a             	or     $0xa,%edx
80107d99:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107da3:	83 ca 10             	or     $0x10,%edx
80107da6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107db0:	83 e2 9f             	and    $0xffffff9f,%edx
80107db3:	88 50 7d             	mov    %dl,0x7d(%eax)
80107db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107dbd:	83 ca 80             	or     $0xffffff80,%edx
80107dc0:	88 50 7d             	mov    %dl,0x7d(%eax)
80107dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dca:	83 ca 0f             	or     $0xf,%edx
80107dcd:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dd7:	83 e2 ef             	and    $0xffffffef,%edx
80107dda:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107de4:	83 e2 df             	and    $0xffffffdf,%edx
80107de7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ded:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107df1:	83 ca 40             	or     $0x40,%edx
80107df4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dfe:	83 ca 80             	or     $0xffffff80,%edx
80107e01:	88 50 7e             	mov    %dl,0x7e(%eax)
80107e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e07:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107e15:	ff ff 
80107e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107e21:	00 00 
80107e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e26:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e30:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e37:	83 e2 f0             	and    $0xfffffff0,%edx
80107e3a:	83 ca 02             	or     $0x2,%edx
80107e3d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e46:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e4d:	83 ca 10             	or     $0x10,%edx
80107e50:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e59:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e60:	83 e2 9f             	and    $0xffffff9f,%edx
80107e63:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e73:	83 ca 80             	or     $0xffffff80,%edx
80107e76:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e86:	83 ca 0f             	or     $0xf,%edx
80107e89:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e92:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e99:	83 e2 ef             	and    $0xffffffef,%edx
80107e9c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107eac:	83 e2 df             	and    $0xffffffdf,%edx
80107eaf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ebf:	83 ca 40             	or     $0x40,%edx
80107ec2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ed2:	83 ca 80             	or     $0xffffff80,%edx
80107ed5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ede:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee8:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107eef:	ff ff 
80107ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef4:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107efb:	00 00 
80107efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f00:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f11:	83 e2 f0             	and    $0xfffffff0,%edx
80107f14:	83 ca 0a             	or     $0xa,%edx
80107f17:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f27:	83 ca 10             	or     $0x10,%edx
80107f2a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f33:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f3a:	83 ca 60             	or     $0x60,%edx
80107f3d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f46:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f4d:	83 ca 80             	or     $0xffffff80,%edx
80107f50:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f59:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f60:	83 ca 0f             	or     $0xf,%edx
80107f63:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f73:	83 e2 ef             	and    $0xffffffef,%edx
80107f76:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f86:	83 e2 df             	and    $0xffffffdf,%edx
80107f89:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f99:	83 ca 40             	or     $0x40,%edx
80107f9c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fac:	83 ca 80             	or     $0xffffff80,%edx
80107faf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb8:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc2:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107fc9:	ff ff 
80107fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fce:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107fd5:	00 00 
80107fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fda:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107feb:	83 e2 f0             	and    $0xfffffff0,%edx
80107fee:	83 ca 02             	or     $0x2,%edx
80107ff1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108001:	83 ca 10             	or     $0x10,%edx
80108004:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010800a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108014:	83 ca 60             	or     $0x60,%edx
80108017:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010801d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108020:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108027:	83 ca 80             	or     $0xffffff80,%edx
8010802a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108033:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010803a:	83 ca 0f             	or     $0xf,%edx
8010803d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010804d:	83 e2 ef             	and    $0xffffffef,%edx
80108050:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108059:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108060:	83 e2 df             	and    $0xffffffdf,%edx
80108063:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108073:	83 ca 40             	or     $0x40,%edx
80108076:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108086:	83 ca 80             	or     $0xffffff80,%edx
80108089:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010808f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108092:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	05 b4 00 00 00       	add    $0xb4,%eax
801080a1:	89 c3                	mov    %eax,%ebx
801080a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a6:	05 b4 00 00 00       	add    $0xb4,%eax
801080ab:	c1 e8 10             	shr    $0x10,%eax
801080ae:	89 c1                	mov    %eax,%ecx
801080b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b3:	05 b4 00 00 00       	add    $0xb4,%eax
801080b8:	c1 e8 18             	shr    $0x18,%eax
801080bb:	89 c2                	mov    %eax,%edx
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801080c7:	00 00 
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801080d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d6:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801080dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080df:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801080e6:	83 e1 f0             	and    $0xfffffff0,%ecx
801080e9:	83 c9 02             	or     $0x2,%ecx
801080ec:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801080f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f5:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801080fc:	83 c9 10             	or     $0x10,%ecx
801080ff:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108108:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010810f:	83 e1 9f             	and    $0xffffff9f,%ecx
80108112:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108122:	83 c9 80             	or     $0xffffff80,%ecx
80108125:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010812b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108135:	83 e1 f0             	and    $0xfffffff0,%ecx
80108138:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010813e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108141:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108148:	83 e1 ef             	and    $0xffffffef,%ecx
8010814b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108154:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010815b:	83 e1 df             	and    $0xffffffdf,%ecx
8010815e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108167:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010816e:	83 c9 40             	or     $0x40,%ecx
80108171:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108181:	83 c9 80             	or     $0xffffff80,%ecx
80108184:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010818a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108196:	83 c0 70             	add    $0x70,%eax
80108199:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801081a0:	00 
801081a1:	89 04 24             	mov    %eax,(%esp)
801081a4:	e8 37 fb ff ff       	call   80107ce0 <lgdt>
  loadgs(SEG_KCPU << 3);
801081a9:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801081b0:	e8 6a fb ff ff       	call   80107d1f <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801081be:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801081c5:	00 00 00 00 
}
801081c9:	83 c4 24             	add    $0x24,%esp
801081cc:	5b                   	pop    %ebx
801081cd:	5d                   	pop    %ebp
801081ce:	c3                   	ret    

801081cf <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801081cf:	55                   	push   %ebp
801081d0:	89 e5                	mov    %esp,%ebp
801081d2:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801081d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801081d8:	c1 e8 16             	shr    $0x16,%eax
801081db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081e2:	8b 45 08             	mov    0x8(%ebp),%eax
801081e5:	01 d0                	add    %edx,%eax
801081e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801081ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ed:	8b 00                	mov    (%eax),%eax
801081ef:	83 e0 01             	and    $0x1,%eax
801081f2:	85 c0                	test   %eax,%eax
801081f4:	74 17                	je     8010820d <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801081f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081f9:	8b 00                	mov    (%eax),%eax
801081fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108200:	89 04 24             	mov    %eax,(%esp)
80108203:	e8 44 fb ff ff       	call   80107d4c <p2v>
80108208:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010820b:	eb 4b                	jmp    80108258 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010820d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108211:	74 0e                	je     80108221 <walkpgdir+0x52>
80108213:	e8 1a a9 ff ff       	call   80102b32 <kalloc>
80108218:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010821b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010821f:	75 07                	jne    80108228 <walkpgdir+0x59>
      return 0;
80108221:	b8 00 00 00 00       	mov    $0x0,%eax
80108226:	eb 47                	jmp    8010826f <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108228:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010822f:	00 
80108230:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108237:	00 
80108238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823b:	89 04 24             	mov    %eax,(%esp)
8010823e:	e8 5e d4 ff ff       	call   801056a1 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108246:	89 04 24             	mov    %eax,(%esp)
80108249:	e8 f1 fa ff ff       	call   80107d3f <v2p>
8010824e:	83 c8 07             	or     $0x7,%eax
80108251:	89 c2                	mov    %eax,%edx
80108253:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108256:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010825b:	c1 e8 0c             	shr    $0xc,%eax
8010825e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108263:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010826a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826d:	01 d0                	add    %edx,%eax
}
8010826f:	c9                   	leave  
80108270:	c3                   	ret    

80108271 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108271:	55                   	push   %ebp
80108272:	89 e5                	mov    %esp,%ebp
80108274:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010827a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010827f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108282:	8b 55 0c             	mov    0xc(%ebp),%edx
80108285:	8b 45 10             	mov    0x10(%ebp),%eax
80108288:	01 d0                	add    %edx,%eax
8010828a:	83 e8 01             	sub    $0x1,%eax
8010828d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108292:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108295:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010829c:	00 
8010829d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801082a4:	8b 45 08             	mov    0x8(%ebp),%eax
801082a7:	89 04 24             	mov    %eax,(%esp)
801082aa:	e8 20 ff ff ff       	call   801081cf <walkpgdir>
801082af:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082b6:	75 07                	jne    801082bf <mappages+0x4e>
      return -1;
801082b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082bd:	eb 48                	jmp    80108307 <mappages+0x96>
    if(*pte & PTE_P)
801082bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082c2:	8b 00                	mov    (%eax),%eax
801082c4:	83 e0 01             	and    $0x1,%eax
801082c7:	85 c0                	test   %eax,%eax
801082c9:	74 0c                	je     801082d7 <mappages+0x66>
      panic("remap");
801082cb:	c7 04 24 d8 92 10 80 	movl   $0x801092d8,(%esp)
801082d2:	e8 63 82 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801082d7:	8b 45 18             	mov    0x18(%ebp),%eax
801082da:	0b 45 14             	or     0x14(%ebp),%eax
801082dd:	83 c8 01             	or     $0x1,%eax
801082e0:	89 c2                	mov    %eax,%edx
801082e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082e5:	89 10                	mov    %edx,(%eax)
    if(a == last)
801082e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801082ed:	75 08                	jne    801082f7 <mappages+0x86>
      break;
801082ef:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801082f0:	b8 00 00 00 00       	mov    $0x0,%eax
801082f5:	eb 10                	jmp    80108307 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801082f7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801082fe:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108305:	eb 8e                	jmp    80108295 <mappages+0x24>
  return 0;
}
80108307:	c9                   	leave  
80108308:	c3                   	ret    

80108309 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108309:	55                   	push   %ebp
8010830a:	89 e5                	mov    %esp,%ebp
8010830c:	53                   	push   %ebx
8010830d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108310:	e8 1d a8 ff ff       	call   80102b32 <kalloc>
80108315:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010831c:	75 0a                	jne    80108328 <setupkvm+0x1f>
    return 0;
8010831e:	b8 00 00 00 00       	mov    $0x0,%eax
80108323:	e9 98 00 00 00       	jmp    801083c0 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108328:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010832f:	00 
80108330:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108337:	00 
80108338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010833b:	89 04 24             	mov    %eax,(%esp)
8010833e:	e8 5e d3 ff ff       	call   801056a1 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108343:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
8010834a:	e8 fd f9 ff ff       	call   80107d4c <p2v>
8010834f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108354:	76 0c                	jbe    80108362 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108356:	c7 04 24 de 92 10 80 	movl   $0x801092de,(%esp)
8010835d:	e8 d8 81 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108362:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108369:	eb 49                	jmp    801083b4 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	8b 48 0c             	mov    0xc(%eax),%ecx
80108371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108374:	8b 50 04             	mov    0x4(%eax),%edx
80108377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837a:	8b 58 08             	mov    0x8(%eax),%ebx
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	8b 40 04             	mov    0x4(%eax),%eax
80108383:	29 c3                	sub    %eax,%ebx
80108385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108388:	8b 00                	mov    (%eax),%eax
8010838a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010838e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108392:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108396:	89 44 24 04          	mov    %eax,0x4(%esp)
8010839a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010839d:	89 04 24             	mov    %eax,(%esp)
801083a0:	e8 cc fe ff ff       	call   80108271 <mappages>
801083a5:	85 c0                	test   %eax,%eax
801083a7:	79 07                	jns    801083b0 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801083a9:	b8 00 00 00 00       	mov    $0x0,%eax
801083ae:	eb 10                	jmp    801083c0 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083b0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801083b4:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801083bb:	72 ae                	jb     8010836b <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801083bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801083c0:	83 c4 34             	add    $0x34,%esp
801083c3:	5b                   	pop    %ebx
801083c4:	5d                   	pop    %ebp
801083c5:	c3                   	ret    

801083c6 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801083c6:	55                   	push   %ebp
801083c7:	89 e5                	mov    %esp,%ebp
801083c9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801083cc:	e8 38 ff ff ff       	call   80108309 <setupkvm>
801083d1:	a3 38 39 11 80       	mov    %eax,0x80113938
  switchkvm();
801083d6:	e8 02 00 00 00       	call   801083dd <switchkvm>
}
801083db:	c9                   	leave  
801083dc:	c3                   	ret    

801083dd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801083dd:	55                   	push   %ebp
801083de:	89 e5                	mov    %esp,%ebp
801083e0:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801083e3:	a1 38 39 11 80       	mov    0x80113938,%eax
801083e8:	89 04 24             	mov    %eax,(%esp)
801083eb:	e8 4f f9 ff ff       	call   80107d3f <v2p>
801083f0:	89 04 24             	mov    %eax,(%esp)
801083f3:	e8 3c f9 ff ff       	call   80107d34 <lcr3>
}
801083f8:	c9                   	leave  
801083f9:	c3                   	ret    

801083fa <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801083fa:	55                   	push   %ebp
801083fb:	89 e5                	mov    %esp,%ebp
801083fd:	53                   	push   %ebx
801083fe:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108401:	e8 9b d1 ff ff       	call   801055a1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108406:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010840c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108413:	83 c2 08             	add    $0x8,%edx
80108416:	89 d3                	mov    %edx,%ebx
80108418:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010841f:	83 c2 08             	add    $0x8,%edx
80108422:	c1 ea 10             	shr    $0x10,%edx
80108425:	89 d1                	mov    %edx,%ecx
80108427:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010842e:	83 c2 08             	add    $0x8,%edx
80108431:	c1 ea 18             	shr    $0x18,%edx
80108434:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010843b:	67 00 
8010843d:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108444:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
8010844a:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108451:	83 e1 f0             	and    $0xfffffff0,%ecx
80108454:	83 c9 09             	or     $0x9,%ecx
80108457:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010845d:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108464:	83 c9 10             	or     $0x10,%ecx
80108467:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010846d:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108474:	83 e1 9f             	and    $0xffffff9f,%ecx
80108477:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010847d:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108484:	83 c9 80             	or     $0xffffff80,%ecx
80108487:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010848d:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108494:	83 e1 f0             	and    $0xfffffff0,%ecx
80108497:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010849d:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801084a4:	83 e1 ef             	and    $0xffffffef,%ecx
801084a7:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801084ad:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801084b4:	83 e1 df             	and    $0xffffffdf,%ecx
801084b7:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801084bd:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801084c4:	83 c9 40             	or     $0x40,%ecx
801084c7:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801084cd:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801084d4:	83 e1 7f             	and    $0x7f,%ecx
801084d7:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801084dd:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801084e3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084e9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801084f0:	83 e2 ef             	and    $0xffffffef,%edx
801084f3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801084f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084ff:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108505:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010850b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108512:	8b 52 08             	mov    0x8(%edx),%edx
80108515:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010851b:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010851e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108525:	e8 df f7 ff ff       	call   80107d09 <ltr>
  if(p->pgdir == 0)
8010852a:	8b 45 08             	mov    0x8(%ebp),%eax
8010852d:	8b 40 04             	mov    0x4(%eax),%eax
80108530:	85 c0                	test   %eax,%eax
80108532:	75 0c                	jne    80108540 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80108534:	c7 04 24 ef 92 10 80 	movl   $0x801092ef,(%esp)
8010853b:	e8 fa 7f ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108540:	8b 45 08             	mov    0x8(%ebp),%eax
80108543:	8b 40 04             	mov    0x4(%eax),%eax
80108546:	89 04 24             	mov    %eax,(%esp)
80108549:	e8 f1 f7 ff ff       	call   80107d3f <v2p>
8010854e:	89 04 24             	mov    %eax,(%esp)
80108551:	e8 de f7 ff ff       	call   80107d34 <lcr3>
  popcli();
80108556:	e8 8a d0 ff ff       	call   801055e5 <popcli>
}
8010855b:	83 c4 14             	add    $0x14,%esp
8010855e:	5b                   	pop    %ebx
8010855f:	5d                   	pop    %ebp
80108560:	c3                   	ret    

80108561 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108561:	55                   	push   %ebp
80108562:	89 e5                	mov    %esp,%ebp
80108564:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108567:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010856e:	76 0c                	jbe    8010857c <inituvm+0x1b>
    panic("inituvm: more than a page");
80108570:	c7 04 24 03 93 10 80 	movl   $0x80109303,(%esp)
80108577:	e8 be 7f ff ff       	call   8010053a <panic>
  mem = kalloc();
8010857c:	e8 b1 a5 ff ff       	call   80102b32 <kalloc>
80108581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108584:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010858b:	00 
8010858c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108593:	00 
80108594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108597:	89 04 24             	mov    %eax,(%esp)
8010859a:	e8 02 d1 ff ff       	call   801056a1 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a2:	89 04 24             	mov    %eax,(%esp)
801085a5:	e8 95 f7 ff ff       	call   80107d3f <v2p>
801085aa:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801085b1:	00 
801085b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
801085b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085bd:	00 
801085be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801085c5:	00 
801085c6:	8b 45 08             	mov    0x8(%ebp),%eax
801085c9:	89 04 24             	mov    %eax,(%esp)
801085cc:	e8 a0 fc ff ff       	call   80108271 <mappages>
  memmove(mem, init, sz);
801085d1:	8b 45 10             	mov    0x10(%ebp),%eax
801085d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801085d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801085db:	89 44 24 04          	mov    %eax,0x4(%esp)
801085df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e2:	89 04 24             	mov    %eax,(%esp)
801085e5:	e8 86 d1 ff ff       	call   80105770 <memmove>
}
801085ea:	c9                   	leave  
801085eb:	c3                   	ret    

801085ec <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801085ec:	55                   	push   %ebp
801085ed:	89 e5                	mov    %esp,%ebp
801085ef:	53                   	push   %ebx
801085f0:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801085f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801085f6:	25 ff 0f 00 00       	and    $0xfff,%eax
801085fb:	85 c0                	test   %eax,%eax
801085fd:	74 0c                	je     8010860b <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801085ff:	c7 04 24 20 93 10 80 	movl   $0x80109320,(%esp)
80108606:	e8 2f 7f ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010860b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108612:	e9 a9 00 00 00       	jmp    801086c0 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010861a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010861d:	01 d0                	add    %edx,%eax
8010861f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108626:	00 
80108627:	89 44 24 04          	mov    %eax,0x4(%esp)
8010862b:	8b 45 08             	mov    0x8(%ebp),%eax
8010862e:	89 04 24             	mov    %eax,(%esp)
80108631:	e8 99 fb ff ff       	call   801081cf <walkpgdir>
80108636:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108639:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010863d:	75 0c                	jne    8010864b <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010863f:	c7 04 24 43 93 10 80 	movl   $0x80109343,(%esp)
80108646:	e8 ef 7e ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010864b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010864e:	8b 00                	mov    (%eax),%eax
80108650:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108655:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865b:	8b 55 18             	mov    0x18(%ebp),%edx
8010865e:	29 c2                	sub    %eax,%edx
80108660:	89 d0                	mov    %edx,%eax
80108662:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108667:	77 0f                	ja     80108678 <loaduvm+0x8c>
      n = sz - i;
80108669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010866c:	8b 55 18             	mov    0x18(%ebp),%edx
8010866f:	29 c2                	sub    %eax,%edx
80108671:	89 d0                	mov    %edx,%eax
80108673:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108676:	eb 07                	jmp    8010867f <loaduvm+0x93>
    else
      n = PGSIZE;
80108678:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010867f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108682:	8b 55 14             	mov    0x14(%ebp),%edx
80108685:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108688:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010868b:	89 04 24             	mov    %eax,(%esp)
8010868e:	e8 b9 f6 ff ff       	call   80107d4c <p2v>
80108693:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108696:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010869a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010869e:	89 44 24 04          	mov    %eax,0x4(%esp)
801086a2:	8b 45 10             	mov    0x10(%ebp),%eax
801086a5:	89 04 24             	mov    %eax,(%esp)
801086a8:	e8 0b 97 ff ff       	call   80101db8 <readi>
801086ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801086b0:	74 07                	je     801086b9 <loaduvm+0xcd>
      return -1;
801086b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801086b7:	eb 18                	jmp    801086d1 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801086b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c3:	3b 45 18             	cmp    0x18(%ebp),%eax
801086c6:	0f 82 4b ff ff ff    	jb     80108617 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801086cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086d1:	83 c4 24             	add    $0x24,%esp
801086d4:	5b                   	pop    %ebx
801086d5:	5d                   	pop    %ebp
801086d6:	c3                   	ret    

801086d7 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801086d7:	55                   	push   %ebp
801086d8:	89 e5                	mov    %esp,%ebp
801086da:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801086dd:	8b 45 10             	mov    0x10(%ebp),%eax
801086e0:	85 c0                	test   %eax,%eax
801086e2:	79 0a                	jns    801086ee <allocuvm+0x17>
    return 0;
801086e4:	b8 00 00 00 00       	mov    $0x0,%eax
801086e9:	e9 c1 00 00 00       	jmp    801087af <allocuvm+0xd8>
  if(newsz < oldsz)
801086ee:	8b 45 10             	mov    0x10(%ebp),%eax
801086f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086f4:	73 08                	jae    801086fe <allocuvm+0x27>
    return oldsz;
801086f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801086f9:	e9 b1 00 00 00       	jmp    801087af <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801086fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80108701:	05 ff 0f 00 00       	add    $0xfff,%eax
80108706:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010870b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010870e:	e9 8d 00 00 00       	jmp    801087a0 <allocuvm+0xc9>
    mem = kalloc();
80108713:	e8 1a a4 ff ff       	call   80102b32 <kalloc>
80108718:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010871b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010871f:	75 2c                	jne    8010874d <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108721:	c7 04 24 61 93 10 80 	movl   $0x80109361,(%esp)
80108728:	e8 73 7c ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010872d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108730:	89 44 24 08          	mov    %eax,0x8(%esp)
80108734:	8b 45 10             	mov    0x10(%ebp),%eax
80108737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010873b:	8b 45 08             	mov    0x8(%ebp),%eax
8010873e:	89 04 24             	mov    %eax,(%esp)
80108741:	e8 6b 00 00 00       	call   801087b1 <deallocuvm>
      return 0;
80108746:	b8 00 00 00 00       	mov    $0x0,%eax
8010874b:	eb 62                	jmp    801087af <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
8010874d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108754:	00 
80108755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010875c:	00 
8010875d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108760:	89 04 24             	mov    %eax,(%esp)
80108763:	e8 39 cf ff ff       	call   801056a1 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010876b:	89 04 24             	mov    %eax,(%esp)
8010876e:	e8 cc f5 ff ff       	call   80107d3f <v2p>
80108773:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108776:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010877d:	00 
8010877e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108782:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108789:	00 
8010878a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010878e:	8b 45 08             	mov    0x8(%ebp),%eax
80108791:	89 04 24             	mov    %eax,(%esp)
80108794:	e8 d8 fa ff ff       	call   80108271 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108799:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a3:	3b 45 10             	cmp    0x10(%ebp),%eax
801087a6:	0f 82 67 ff ff ff    	jb     80108713 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801087ac:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087af:	c9                   	leave  
801087b0:	c3                   	ret    

801087b1 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087b1:	55                   	push   %ebp
801087b2:	89 e5                	mov    %esp,%ebp
801087b4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801087b7:	8b 45 10             	mov    0x10(%ebp),%eax
801087ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087bd:	72 08                	jb     801087c7 <deallocuvm+0x16>
    return oldsz;
801087bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801087c2:	e9 a4 00 00 00       	jmp    8010886b <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801087c7:	8b 45 10             	mov    0x10(%ebp),%eax
801087ca:	05 ff 0f 00 00       	add    $0xfff,%eax
801087cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801087d7:	e9 80 00 00 00       	jmp    8010885c <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801087dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087e6:	00 
801087e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801087eb:	8b 45 08             	mov    0x8(%ebp),%eax
801087ee:	89 04 24             	mov    %eax,(%esp)
801087f1:	e8 d9 f9 ff ff       	call   801081cf <walkpgdir>
801087f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801087f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087fd:	75 09                	jne    80108808 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801087ff:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108806:	eb 4d                	jmp    80108855 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108808:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880b:	8b 00                	mov    (%eax),%eax
8010880d:	83 e0 01             	and    $0x1,%eax
80108810:	85 c0                	test   %eax,%eax
80108812:	74 41                	je     80108855 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108814:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108817:	8b 00                	mov    (%eax),%eax
80108819:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010881e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108821:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108825:	75 0c                	jne    80108833 <deallocuvm+0x82>
        panic("kfree");
80108827:	c7 04 24 79 93 10 80 	movl   $0x80109379,(%esp)
8010882e:	e8 07 7d ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108833:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108836:	89 04 24             	mov    %eax,(%esp)
80108839:	e8 0e f5 ff ff       	call   80107d4c <p2v>
8010883e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108841:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108844:	89 04 24             	mov    %eax,(%esp)
80108847:	e8 4d a2 ff ff       	call   80102a99 <kfree>
      *pte = 0;
8010884c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010884f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108855:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108862:	0f 82 74 ff ff ff    	jb     801087dc <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108868:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010886b:	c9                   	leave  
8010886c:	c3                   	ret    

8010886d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010886d:	55                   	push   %ebp
8010886e:	89 e5                	mov    %esp,%ebp
80108870:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108873:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108877:	75 0c                	jne    80108885 <freevm+0x18>
    panic("freevm: no pgdir");
80108879:	c7 04 24 7f 93 10 80 	movl   $0x8010937f,(%esp)
80108880:	e8 b5 7c ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108885:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010888c:	00 
8010888d:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108894:	80 
80108895:	8b 45 08             	mov    0x8(%ebp),%eax
80108898:	89 04 24             	mov    %eax,(%esp)
8010889b:	e8 11 ff ff ff       	call   801087b1 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801088a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088a7:	eb 48                	jmp    801088f1 <freevm+0x84>
    if(pgdir[i] & PTE_P){
801088a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088b3:	8b 45 08             	mov    0x8(%ebp),%eax
801088b6:	01 d0                	add    %edx,%eax
801088b8:	8b 00                	mov    (%eax),%eax
801088ba:	83 e0 01             	and    $0x1,%eax
801088bd:	85 c0                	test   %eax,%eax
801088bf:	74 2c                	je     801088ed <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801088c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088cb:	8b 45 08             	mov    0x8(%ebp),%eax
801088ce:	01 d0                	add    %edx,%eax
801088d0:	8b 00                	mov    (%eax),%eax
801088d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088d7:	89 04 24             	mov    %eax,(%esp)
801088da:	e8 6d f4 ff ff       	call   80107d4c <p2v>
801088df:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801088e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e5:	89 04 24             	mov    %eax,(%esp)
801088e8:	e8 ac a1 ff ff       	call   80102a99 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801088ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801088f1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801088f8:	76 af                	jbe    801088a9 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801088fa:	8b 45 08             	mov    0x8(%ebp),%eax
801088fd:	89 04 24             	mov    %eax,(%esp)
80108900:	e8 94 a1 ff ff       	call   80102a99 <kfree>
}
80108905:	c9                   	leave  
80108906:	c3                   	ret    

80108907 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108907:	55                   	push   %ebp
80108908:	89 e5                	mov    %esp,%ebp
8010890a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010890d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108914:	00 
80108915:	8b 45 0c             	mov    0xc(%ebp),%eax
80108918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010891c:	8b 45 08             	mov    0x8(%ebp),%eax
8010891f:	89 04 24             	mov    %eax,(%esp)
80108922:	e8 a8 f8 ff ff       	call   801081cf <walkpgdir>
80108927:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010892a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010892e:	75 0c                	jne    8010893c <clearpteu+0x35>
    panic("clearpteu");
80108930:	c7 04 24 90 93 10 80 	movl   $0x80109390,(%esp)
80108937:	e8 fe 7b ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
8010893c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010893f:	8b 00                	mov    (%eax),%eax
80108941:	83 e0 fb             	and    $0xfffffffb,%eax
80108944:	89 c2                	mov    %eax,%edx
80108946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108949:	89 10                	mov    %edx,(%eax)
}
8010894b:	c9                   	leave  
8010894c:	c3                   	ret    

8010894d <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010894d:	55                   	push   %ebp
8010894e:	89 e5                	mov    %esp,%ebp
80108950:	53                   	push   %ebx
80108951:	83 ec 44             	sub    $0x44,%esp
  cprintf("copyuvm starts\n");
80108954:	c7 04 24 9a 93 10 80 	movl   $0x8010939a,(%esp)
8010895b:	e8 40 7a ff ff       	call   801003a0 <cprintf>
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108960:	e8 a4 f9 ff ff       	call   80108309 <setupkvm>
80108965:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010896c:	75 0a                	jne    80108978 <copyuvm+0x2b>
    return 0;
8010896e:	b8 00 00 00 00       	mov    $0x0,%eax
80108973:	e9 fd 00 00 00       	jmp    80108a75 <copyuvm+0x128>
  for(i = PGSIZE; i < sz; i += PGSIZE){
80108978:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
8010897f:	e9 d0 00 00 00       	jmp    80108a54 <copyuvm+0x107>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108987:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010898e:	00 
8010898f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108993:	8b 45 08             	mov    0x8(%ebp),%eax
80108996:	89 04 24             	mov    %eax,(%esp)
80108999:	e8 31 f8 ff ff       	call   801081cf <walkpgdir>
8010899e:	89 45 ec             	mov    %eax,-0x14(%ebp)
801089a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089a5:	75 0c                	jne    801089b3 <copyuvm+0x66>
      panic("copyuvm: pte should exist");
801089a7:	c7 04 24 aa 93 10 80 	movl   $0x801093aa,(%esp)
801089ae:	e8 87 7b ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801089b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089b6:	8b 00                	mov    (%eax),%eax
801089b8:	83 e0 01             	and    $0x1,%eax
801089bb:	85 c0                	test   %eax,%eax
801089bd:	75 0c                	jne    801089cb <copyuvm+0x7e>
      panic("copyuvm: page not present");
801089bf:	c7 04 24 c4 93 10 80 	movl   $0x801093c4,(%esp)
801089c6:	e8 6f 7b ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801089cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089ce:	8b 00                	mov    (%eax),%eax
801089d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801089d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089db:	8b 00                	mov    (%eax),%eax
801089dd:	25 ff 0f 00 00       	and    $0xfff,%eax
801089e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801089e5:	e8 48 a1 ff ff       	call   80102b32 <kalloc>
801089ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801089f1:	75 02                	jne    801089f5 <copyuvm+0xa8>
      goto bad;
801089f3:	eb 70                	jmp    80108a65 <copyuvm+0x118>
    memmove(mem, (char*)p2v(pa), PGSIZE);
801089f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089f8:	89 04 24             	mov    %eax,(%esp)
801089fb:	e8 4c f3 ff ff       	call   80107d4c <p2v>
80108a00:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a07:	00 
80108a08:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a0f:	89 04 24             	mov    %eax,(%esp)
80108a12:	e8 59 cd ff ff       	call   80105770 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108a17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108a1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a1d:	89 04 24             	mov    %eax,(%esp)
80108a20:	e8 1a f3 ff ff       	call   80107d3f <v2p>
80108a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108a28:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108a30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a37:	00 
80108a38:	89 54 24 04          	mov    %edx,0x4(%esp)
80108a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a3f:	89 04 24             	mov    %eax,(%esp)
80108a42:	e8 2a f8 ff ff       	call   80108271 <mappages>
80108a47:	85 c0                	test   %eax,%eax
80108a49:	79 02                	jns    80108a4d <copyuvm+0x100>
      goto bad;
80108a4b:	eb 18                	jmp    80108a65 <copyuvm+0x118>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
80108a4d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a57:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a5a:	0f 82 24 ff ff ff    	jb     80108984 <copyuvm+0x37>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a63:	eb 10                	jmp    80108a75 <copyuvm+0x128>

bad:
  freevm(d);
80108a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a68:	89 04 24             	mov    %eax,(%esp)
80108a6b:	e8 fd fd ff ff       	call   8010886d <freevm>
  return 0;
80108a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a75:	83 c4 44             	add    $0x44,%esp
80108a78:	5b                   	pop    %ebx
80108a79:	5d                   	pop    %ebp
80108a7a:	c3                   	ret    

80108a7b <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a7b:	55                   	push   %ebp
80108a7c:	89 e5                	mov    %esp,%ebp
80108a7e:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a88:	00 
80108a89:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a90:	8b 45 08             	mov    0x8(%ebp),%eax
80108a93:	89 04 24             	mov    %eax,(%esp)
80108a96:	e8 34 f7 ff ff       	call   801081cf <walkpgdir>
80108a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa1:	8b 00                	mov    (%eax),%eax
80108aa3:	83 e0 01             	and    $0x1,%eax
80108aa6:	85 c0                	test   %eax,%eax
80108aa8:	75 07                	jne    80108ab1 <uva2ka+0x36>
    return 0;
80108aaa:	b8 00 00 00 00       	mov    $0x0,%eax
80108aaf:	eb 25                	jmp    80108ad6 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab4:	8b 00                	mov    (%eax),%eax
80108ab6:	83 e0 04             	and    $0x4,%eax
80108ab9:	85 c0                	test   %eax,%eax
80108abb:	75 07                	jne    80108ac4 <uva2ka+0x49>
    return 0;
80108abd:	b8 00 00 00 00       	mov    $0x0,%eax
80108ac2:	eb 12                	jmp    80108ad6 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac7:	8b 00                	mov    (%eax),%eax
80108ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ace:	89 04 24             	mov    %eax,(%esp)
80108ad1:	e8 76 f2 ff ff       	call   80107d4c <p2v>
}
80108ad6:	c9                   	leave  
80108ad7:	c3                   	ret    

80108ad8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108ad8:	55                   	push   %ebp
80108ad9:	89 e5                	mov    %esp,%ebp
80108adb:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108ade:	8b 45 10             	mov    0x10(%ebp),%eax
80108ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108ae4:	e9 87 00 00 00       	jmp    80108b70 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108af1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108afb:	8b 45 08             	mov    0x8(%ebp),%eax
80108afe:	89 04 24             	mov    %eax,(%esp)
80108b01:	e8 75 ff ff ff       	call   80108a7b <uva2ka>
80108b06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108b09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108b0d:	75 07                	jne    80108b16 <copyout+0x3e>
      return -1;
80108b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b14:	eb 69                	jmp    80108b7f <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108b1c:	29 c2                	sub    %eax,%edx
80108b1e:	89 d0                	mov    %edx,%eax
80108b20:	05 00 10 00 00       	add    $0x1000,%eax
80108b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b2b:	3b 45 14             	cmp    0x14(%ebp),%eax
80108b2e:	76 06                	jbe    80108b36 <copyout+0x5e>
      n = len;
80108b30:	8b 45 14             	mov    0x14(%ebp),%eax
80108b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b39:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b3c:	29 c2                	sub    %eax,%edx
80108b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b41:	01 c2                	add    %eax,%edx
80108b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b46:	89 44 24 08          	mov    %eax,0x8(%esp)
80108b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b51:	89 14 24             	mov    %edx,(%esp)
80108b54:	e8 17 cc ff ff       	call   80105770 <memmove>
    len -= n;
80108b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b5c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b62:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b68:	05 00 10 00 00       	add    $0x1000,%eax
80108b6d:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b70:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108b74:	0f 85 6f ff ff ff    	jne    80108ae9 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b7f:	c9                   	leave  
80108b80:	c3                   	ret    
