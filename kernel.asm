
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
8010002d:	b8 a3 34 10 80       	mov    $0x801034a3,%eax
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
8010003a:	c7 44 24 04 a4 89 10 	movl   $0x801089a4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 9b 52 00 00       	call   801052e9 <initlock>

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
801000bd:	e8 48 52 00 00       	call   8010530a <acquire>

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
80100104:	e8 63 52 00 00       	call   8010536c <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 29 4b 00 00       	call   80104c4d <sleep>
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
8010017c:	e8 eb 51 00 00       	call   8010536c <release>
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
80100198:	c7 04 24 ab 89 10 80 	movl   $0x801089ab,(%esp)
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
801001d3:	e8 c1 25 00 00       	call   80102799 <iderw>
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
801001ef:	c7 04 24 bc 89 10 80 	movl   $0x801089bc,(%esp)
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
80100210:	e8 84 25 00 00       	call   80102799 <iderw>
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
80100229:	c7 04 24 c3 89 10 80 	movl   $0x801089c3,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 c9 50 00 00       	call   8010530a <acquire>

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
8010029d:	e8 ef 4a 00 00       	call   80104d91 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 be 50 00 00       	call   8010536c <release>
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
801003bb:	e8 4a 4f 00 00       	call   8010530a <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 ca 89 10 80 	movl   $0x801089ca,(%esp)
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
801004b0:	c7 45 ec d3 89 10 80 	movl   $0x801089d3,-0x14(%ebp)
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
80100533:	e8 34 4e 00 00       	call   8010536c <release>
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
8010055f:	c7 04 24 da 89 10 80 	movl   $0x801089da,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 e9 89 10 80 	movl   $0x801089e9,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 27 4e 00 00       	call   801053bb <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 eb 89 10 80 	movl   $0x801089eb,(%esp)
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
801006b2:	e8 76 4f 00 00       	call   8010562d <memmove>
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
801006e1:	e8 78 4e 00 00       	call   8010555e <memset>
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
80100776:	e8 6b 68 00 00       	call   80106fe6 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 5f 68 00 00       	call   80106fe6 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 53 68 00 00       	call   80106fe6 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 46 68 00 00       	call   80106fe6 <uartputc>
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
801007ba:	e8 4b 4b 00 00       	call   8010530a <acquire>
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
801007ea:	e8 48 46 00 00       	call   80104e37 <procdump>
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
801008f3:	e8 99 44 00 00       	call   80104d91 <wakeup>
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
80100914:	e8 53 4a 00 00       	call   8010536c <release>
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
80100927:	e8 75 10 00 00       	call   801019a1 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100939:	e8 cc 49 00 00       	call   8010530a <acquire>
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
80100959:	e8 0e 4a 00 00       	call   8010536c <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 ea 0e 00 00       	call   80101853 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100982:	e8 c6 42 00 00       	call   80104c4d <sleep>

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
801009fe:	e8 69 49 00 00       	call   8010536c <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 45 0e 00 00       	call   80101853 <ilock>

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
80100a26:	e8 76 0f 00 00       	call   801019a1 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 d3 48 00 00       	call   8010530a <acquire>
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
80100a6c:	e8 fb 48 00 00       	call   8010536c <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 d7 0d 00 00       	call   80101853 <ilock>

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
80100a87:	c7 44 24 04 ef 89 10 	movl   $0x801089ef,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 4e 48 00 00       	call   801052e9 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 f7 89 10 	movl   $0x801089f7,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100aaa:	e8 3a 48 00 00       	call   801052e9 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 2c f8 10 80 1a 	movl   $0x80100a1a,0x8010f82c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 28 f8 10 80 1b 	movl   $0x8010091b,0x8010f828
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 67 30 00 00       	call   80103b40 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 68 1e 00 00       	call   80102955 <ioapicenable>
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
80100afe:	e8 fb 18 00 00       	call   801023fe <namei>
80100b03:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0a:	75 0a                	jne    80100b16 <exec+0x27>
    return -1;
80100b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b11:	e9 ea 03 00 00       	jmp    80100f00 <exec+0x411>
  ilock(ip);
80100b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b19:	89 04 24             	mov    %eax,(%esp)
80100b1c:	e8 32 0d 00 00       	call   80101853 <ilock>
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
80100b48:	e8 13 12 00 00       	call   80101d60 <readi>
80100b4d:	83 f8 33             	cmp    $0x33,%eax
80100b50:	77 05                	ja     80100b57 <exec+0x68>
    goto bad;
80100b52:	e9 82 03 00 00       	jmp    80100ed9 <exec+0x3ea>
  if(elf.magic != ELF_MAGIC)
80100b57:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b5d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b62:	74 05                	je     80100b69 <exec+0x7a>
    goto bad;
80100b64:	e9 70 03 00 00       	jmp    80100ed9 <exec+0x3ea>

  if((pgdir = setupkvm()) == 0)
80100b69:	e8 c9 75 00 00       	call   80108137 <setupkvm>
80100b6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b75:	75 05                	jne    80100b7c <exec+0x8d>
    goto bad;
80100b77:	e9 5d 03 00 00       	jmp    80100ed9 <exec+0x3ea>

  // Load program into memory.
  sz = 0;
80100b7c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b8a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b90:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b93:	e9 cb 00 00 00       	jmp    80100c63 <exec+0x174>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100b9b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100ba2:	00 
80100ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ba7:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bad:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bb4:	89 04 24             	mov    %eax,(%esp)
80100bb7:	e8 a4 11 00 00       	call   80101d60 <readi>
80100bbc:	83 f8 20             	cmp    $0x20,%eax
80100bbf:	74 05                	je     80100bc6 <exec+0xd7>
      goto bad;
80100bc1:	e9 13 03 00 00       	jmp    80100ed9 <exec+0x3ea>
    if(ph.type != ELF_PROG_LOAD)
80100bc6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bcc:	83 f8 01             	cmp    $0x1,%eax
80100bcf:	74 05                	je     80100bd6 <exec+0xe7>
      continue;
80100bd1:	e9 80 00 00 00       	jmp    80100c56 <exec+0x167>
    if(ph.memsz < ph.filesz)
80100bd6:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bdc:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be2:	39 c2                	cmp    %eax,%edx
80100be4:	73 05                	jae    80100beb <exec+0xfc>
      goto bad;
80100be6:	e9 ee 02 00 00       	jmp    80100ed9 <exec+0x3ea>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100beb:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bf1:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bf7:	01 d0                	add    %edx,%eax
80100bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c07:	89 04 24             	mov    %eax,(%esp)
80100c0a:	e8 f6 78 00 00       	call   80108505 <allocuvm>
80100c0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c16:	75 05                	jne    80100c1d <exec+0x12e>
      goto bad;
80100c18:	e9 bc 02 00 00       	jmp    80100ed9 <exec+0x3ea>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c1d:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c29:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c2f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c33:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c37:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c3a:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c45:	89 04 24             	mov    %eax,(%esp)
80100c48:	e8 cd 77 00 00       	call   8010841a <loaduvm>
80100c4d:	85 c0                	test   %eax,%eax
80100c4f:	79 05                	jns    80100c56 <exec+0x167>
      goto bad;
80100c51:	e9 83 02 00 00       	jmp    80100ed9 <exec+0x3ea>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c56:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5d:	83 c0 20             	add    $0x20,%eax
80100c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c63:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c6a:	0f b7 c0             	movzwl %ax,%eax
80100c6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c70:	0f 8f 22 ff ff ff    	jg     80100b98 <exec+0xa9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c76:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c79:	89 04 24             	mov    %eax,(%esp)
80100c7c:	e8 56 0e 00 00       	call   80101ad7 <iunlockput>
  ip = 0;
80100c81:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c8b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 00 20 00 00       	add    $0x2000,%eax
80100ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cae:	89 04 24             	mov    %eax,(%esp)
80100cb1:	e8 4f 78 00 00       	call   80108505 <allocuvm>
80100cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cbd:	75 05                	jne    80100cc4 <exec+0x1d5>
    goto bad;
80100cbf:	e9 15 02 00 00       	jmp    80100ed9 <exec+0x3ea>
  proc->pstack = (uint *)sz;
80100cc4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cca:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ccd:	89 50 7c             	mov    %edx,0x7c(%eax)

  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd3:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cdf:	89 04 24             	mov    %eax,(%esp)
80100ce2:	e8 4e 7a 00 00       	call   80108735 <clearpteu>

  sp = sz;
80100ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cea:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ced:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf4:	e9 9a 00 00 00       	jmp    80100d93 <exec+0x2a4>
    if(argc >= MAXARG)
80100cf9:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cfd:	76 05                	jbe    80100d04 <exec+0x215>
      goto bad;
80100cff:	e9 d5 01 00 00       	jmp    80100ed9 <exec+0x3ea>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d11:	01 d0                	add    %edx,%eax
80100d13:	8b 00                	mov    (%eax),%eax
80100d15:	89 04 24             	mov    %eax,(%esp)
80100d18:	e8 ab 4a 00 00       	call   801057c8 <strlen>
80100d1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d20:	29 c2                	sub    %eax,%edx
80100d22:	89 d0                	mov    %edx,%eax
80100d24:	83 e8 01             	sub    $0x1,%eax
80100d27:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d37:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3a:	01 d0                	add    %edx,%eax
80100d3c:	8b 00                	mov    (%eax),%eax
80100d3e:	89 04 24             	mov    %eax,(%esp)
80100d41:	e8 82 4a 00 00       	call   801057c8 <strlen>
80100d46:	83 c0 01             	add    $0x1,%eax
80100d49:	89 c2                	mov    %eax,%edx
80100d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d58:	01 c8                	add    %ecx,%eax
80100d5a:	8b 00                	mov    (%eax),%eax
80100d5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d60:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d67:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d6e:	89 04 24             	mov    %eax,(%esp)
80100d71:	e8 84 7b 00 00       	call   801088fa <copyout>
80100d76:	85 c0                	test   %eax,%eax
80100d78:	79 05                	jns    80100d7f <exec+0x290>
      goto bad;
80100d7a:	e9 5a 01 00 00       	jmp    80100ed9 <exec+0x3ea>
    ustack[3+argc] = sp;
80100d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d82:	8d 50 03             	lea    0x3(%eax),%edx
80100d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d88:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da0:	01 d0                	add    %edx,%eax
80100da2:	8b 00                	mov    (%eax),%eax
80100da4:	85 c0                	test   %eax,%eax
80100da6:	0f 85 4d ff ff ff    	jne    80100cf9 <exec+0x20a>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daf:	83 c0 03             	add    $0x3,%eax
80100db2:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100db9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dbd:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc4:	ff ff ff 
  ustack[1] = argc;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	83 c0 01             	add    $0x1,%eax
80100dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	83 c0 04             	add    $0x4,%eax
80100dee:	c1 e0 02             	shl    $0x2,%eax
80100df1:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	83 c0 04             	add    $0x4,%eax
80100dfa:	c1 e0 02             	shl    $0x2,%eax
80100dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e01:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e07:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e15:	89 04 24             	mov    %eax,(%esp)
80100e18:	e8 dd 7a 00 00       	call   801088fa <copyout>
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	79 05                	jns    80100e26 <exec+0x337>
    goto bad;
80100e21:	e9 b3 00 00 00       	jmp    80100ed9 <exec+0x3ea>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e26:	8b 45 08             	mov    0x8(%ebp),%eax
80100e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e32:	eb 17                	jmp    80100e4b <exec+0x35c>
    if(*s == '/')
80100e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e37:	0f b6 00             	movzbl (%eax),%eax
80100e3a:	3c 2f                	cmp    $0x2f,%al
80100e3c:	75 09                	jne    80100e47 <exec+0x358>
      last = s+1;
80100e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e41:	83 c0 01             	add    $0x1,%eax
80100e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4e:	0f b6 00             	movzbl (%eax),%eax
80100e51:	84 c0                	test   %al,%al
80100e53:	75 df                	jne    80100e34 <exec+0x345>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5b:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e5e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e65:	00 
80100e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e69:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e6d:	89 14 24             	mov    %edx,(%esp)
80100e70:	e8 09 49 00 00       	call   8010577e <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7b:	8b 40 04             	mov    0x4(%eax),%eax
80100e7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e8a:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e93:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e96:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9e:	8b 40 18             	mov    0x18(%eax),%eax
80100ea1:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea7:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb0:	8b 40 18             	mov    0x18(%eax),%eax
80100eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb6:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebf:	89 04 24             	mov    %eax,(%esp)
80100ec2:	e8 61 73 00 00       	call   80108228 <switchuvm>
  freevm(oldpgdir);
80100ec7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eca:	89 04 24             	mov    %eax,(%esp)
80100ecd:	e8 c9 77 00 00       	call   8010869b <freevm>
  return 0;
80100ed2:	b8 00 00 00 00       	mov    $0x0,%eax
80100ed7:	eb 27                	jmp    80100f00 <exec+0x411>

 bad:
  if(pgdir)
80100ed9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100edd:	74 0b                	je     80100eea <exec+0x3fb>
    freevm(pgdir);
80100edf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 b1 77 00 00       	call   8010869b <freevm>
  if(ip)
80100eea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100eee:	74 0b                	je     80100efb <exec+0x40c>
    iunlockput(ip);
80100ef0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef3:	89 04 24             	mov    %eax,(%esp)
80100ef6:	e8 dc 0b 00 00       	call   80101ad7 <iunlockput>
  return -1;
80100efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f00:	c9                   	leave  
80100f01:	c3                   	ret    

80100f02 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f02:	55                   	push   %ebp
80100f03:	89 e5                	mov    %esp,%ebp
80100f05:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f08:	c7 44 24 04 fd 89 10 	movl   $0x801089fd,0x4(%esp)
80100f0f:	80 
80100f10:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f17:	e8 cd 43 00 00       	call   801052e9 <initlock>
}
80100f1c:	c9                   	leave  
80100f1d:	c3                   	ret    

80100f1e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f1e:	55                   	push   %ebp
80100f1f:	89 e5                	mov    %esp,%ebp
80100f21:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f24:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f2b:	e8 da 43 00 00       	call   8010530a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f30:	c7 45 f4 b4 ee 10 80 	movl   $0x8010eeb4,-0xc(%ebp)
80100f37:	eb 29                	jmp    80100f62 <filealloc+0x44>
    if(f->ref == 0){
80100f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3c:	8b 40 04             	mov    0x4(%eax),%eax
80100f3f:	85 c0                	test   %eax,%eax
80100f41:	75 1b                	jne    80100f5e <filealloc+0x40>
      f->ref = 1;
80100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f46:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f4d:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f54:	e8 13 44 00 00       	call   8010536c <release>
      return f;
80100f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5c:	eb 1e                	jmp    80100f7c <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f62:	81 7d f4 14 f8 10 80 	cmpl   $0x8010f814,-0xc(%ebp)
80100f69:	72 ce                	jb     80100f39 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f6b:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f72:	e8 f5 43 00 00       	call   8010536c <release>
  return 0;
80100f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f7c:	c9                   	leave  
80100f7d:	c3                   	ret    

80100f7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f7e:	55                   	push   %ebp
80100f7f:	89 e5                	mov    %esp,%ebp
80100f81:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f84:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f8b:	e8 7a 43 00 00       	call   8010530a <acquire>
  if(f->ref < 1)
80100f90:	8b 45 08             	mov    0x8(%ebp),%eax
80100f93:	8b 40 04             	mov    0x4(%eax),%eax
80100f96:	85 c0                	test   %eax,%eax
80100f98:	7f 0c                	jg     80100fa6 <filedup+0x28>
    panic("filedup");
80100f9a:	c7 04 24 04 8a 10 80 	movl   $0x80108a04,(%esp)
80100fa1:	e8 94 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa9:	8b 40 04             	mov    0x4(%eax),%eax
80100fac:	8d 50 01             	lea    0x1(%eax),%edx
80100faf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb2:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb5:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fbc:	e8 ab 43 00 00       	call   8010536c <release>
  return f;
80100fc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fc4:	c9                   	leave  
80100fc5:	c3                   	ret    

80100fc6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc6:	55                   	push   %ebp
80100fc7:	89 e5                	mov    %esp,%ebp
80100fc9:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fcc:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fd3:	e8 32 43 00 00       	call   8010530a <acquire>
  if(f->ref < 1)
80100fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdb:	8b 40 04             	mov    0x4(%eax),%eax
80100fde:	85 c0                	test   %eax,%eax
80100fe0:	7f 0c                	jg     80100fee <fileclose+0x28>
    panic("fileclose");
80100fe2:	c7 04 24 0c 8a 10 80 	movl   $0x80108a0c,(%esp)
80100fe9:	e8 4c f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100fee:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff1:	8b 40 04             	mov    0x4(%eax),%eax
80100ff4:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	89 50 04             	mov    %edx,0x4(%eax)
80100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80101000:	8b 40 04             	mov    0x4(%eax),%eax
80101003:	85 c0                	test   %eax,%eax
80101005:	7e 11                	jle    80101018 <fileclose+0x52>
    release(&ftable.lock);
80101007:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
8010100e:	e8 59 43 00 00       	call   8010536c <release>
80101013:	e9 82 00 00 00       	jmp    8010109a <fileclose+0xd4>
    return;
  }
  ff = *f;
80101018:	8b 45 08             	mov    0x8(%ebp),%eax
8010101b:	8b 10                	mov    (%eax),%edx
8010101d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101020:	8b 50 04             	mov    0x4(%eax),%edx
80101023:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101026:	8b 50 08             	mov    0x8(%eax),%edx
80101029:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010102c:	8b 50 0c             	mov    0xc(%eax),%edx
8010102f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101032:	8b 50 10             	mov    0x10(%eax),%edx
80101035:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101038:	8b 40 14             	mov    0x14(%eax),%eax
8010103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010103e:	8b 45 08             	mov    0x8(%ebp),%eax
80101041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101051:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80101058:	e8 0f 43 00 00       	call   8010536c <release>
  
  if(ff.type == FD_PIPE)
8010105d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101060:	83 f8 01             	cmp    $0x1,%eax
80101063:	75 18                	jne    8010107d <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101069:	0f be d0             	movsbl %al,%edx
8010106c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010106f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101073:	89 04 24             	mov    %eax,(%esp)
80101076:	e8 75 2d 00 00       	call   80103df0 <pipeclose>
8010107b:	eb 1d                	jmp    8010109a <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010107d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101080:	83 f8 02             	cmp    $0x2,%eax
80101083:	75 15                	jne    8010109a <fileclose+0xd4>
    begin_trans();
80101085:	e8 39 22 00 00       	call   801032c3 <begin_trans>
    iput(ff.ip);
8010108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010108d:	89 04 24             	mov    %eax,(%esp)
80101090:	e8 71 09 00 00       	call   80101a06 <iput>
    commit_trans();
80101095:	e8 72 22 00 00       	call   8010330c <commit_trans>
  }
}
8010109a:	c9                   	leave  
8010109b:	c3                   	ret    

8010109c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010109c:	55                   	push   %ebp
8010109d:	89 e5                	mov    %esp,%ebp
8010109f:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010a2:	8b 45 08             	mov    0x8(%ebp),%eax
801010a5:	8b 00                	mov    (%eax),%eax
801010a7:	83 f8 02             	cmp    $0x2,%eax
801010aa:	75 38                	jne    801010e4 <filestat+0x48>
    ilock(f->ip);
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 40 10             	mov    0x10(%eax),%eax
801010b2:	89 04 24             	mov    %eax,(%esp)
801010b5:	e8 99 07 00 00       	call   80101853 <ilock>
    stati(f->ip, st);
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	8b 40 10             	mov    0x10(%eax),%eax
801010c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801010c3:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c7:	89 04 24             	mov    %eax,(%esp)
801010ca:	e8 4c 0c 00 00       	call   80101d1b <stati>
    iunlock(f->ip);
801010cf:	8b 45 08             	mov    0x8(%ebp),%eax
801010d2:	8b 40 10             	mov    0x10(%eax),%eax
801010d5:	89 04 24             	mov    %eax,(%esp)
801010d8:	e8 c4 08 00 00       	call   801019a1 <iunlock>
    return 0;
801010dd:	b8 00 00 00 00       	mov    $0x0,%eax
801010e2:	eb 05                	jmp    801010e9 <filestat+0x4d>
  }
  return -1;
801010e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e9:	c9                   	leave  
801010ea:	c3                   	ret    

801010eb <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010eb:	55                   	push   %ebp
801010ec:	89 e5                	mov    %esp,%ebp
801010ee:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010f1:	8b 45 08             	mov    0x8(%ebp),%eax
801010f4:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010f8:	84 c0                	test   %al,%al
801010fa:	75 0a                	jne    80101106 <fileread+0x1b>
    return -1;
801010fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101101:	e9 9f 00 00 00       	jmp    801011a5 <fileread+0xba>
  if(f->type == FD_PIPE)
80101106:	8b 45 08             	mov    0x8(%ebp),%eax
80101109:	8b 00                	mov    (%eax),%eax
8010110b:	83 f8 01             	cmp    $0x1,%eax
8010110e:	75 1e                	jne    8010112e <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 40 0c             	mov    0xc(%eax),%eax
80101116:	8b 55 10             	mov    0x10(%ebp),%edx
80101119:	89 54 24 08          	mov    %edx,0x8(%esp)
8010111d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101120:	89 54 24 04          	mov    %edx,0x4(%esp)
80101124:	89 04 24             	mov    %eax,(%esp)
80101127:	e8 45 2e 00 00       	call   80103f71 <piperead>
8010112c:	eb 77                	jmp    801011a5 <fileread+0xba>
  if(f->type == FD_INODE){
8010112e:	8b 45 08             	mov    0x8(%ebp),%eax
80101131:	8b 00                	mov    (%eax),%eax
80101133:	83 f8 02             	cmp    $0x2,%eax
80101136:	75 61                	jne    80101199 <fileread+0xae>
    ilock(f->ip);
80101138:	8b 45 08             	mov    0x8(%ebp),%eax
8010113b:	8b 40 10             	mov    0x10(%eax),%eax
8010113e:	89 04 24             	mov    %eax,(%esp)
80101141:	e8 0d 07 00 00       	call   80101853 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101146:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	8b 50 14             	mov    0x14(%eax),%edx
8010114f:	8b 45 08             	mov    0x8(%ebp),%eax
80101152:	8b 40 10             	mov    0x10(%eax),%eax
80101155:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101159:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101160:	89 54 24 04          	mov    %edx,0x4(%esp)
80101164:	89 04 24             	mov    %eax,(%esp)
80101167:	e8 f4 0b 00 00       	call   80101d60 <readi>
8010116c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101173:	7e 11                	jle    80101186 <fileread+0x9b>
      f->off += r;
80101175:	8b 45 08             	mov    0x8(%ebp),%eax
80101178:	8b 50 14             	mov    0x14(%eax),%edx
8010117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010117e:	01 c2                	add    %eax,%edx
80101180:	8b 45 08             	mov    0x8(%ebp),%eax
80101183:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	8b 40 10             	mov    0x10(%eax),%eax
8010118c:	89 04 24             	mov    %eax,(%esp)
8010118f:	e8 0d 08 00 00       	call   801019a1 <iunlock>
    return r;
80101194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101197:	eb 0c                	jmp    801011a5 <fileread+0xba>
  }
  panic("fileread");
80101199:	c7 04 24 16 8a 10 80 	movl   $0x80108a16,(%esp)
801011a0:	e8 95 f3 ff ff       	call   8010053a <panic>
}
801011a5:	c9                   	leave  
801011a6:	c3                   	ret    

801011a7 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a7:	55                   	push   %ebp
801011a8:	89 e5                	mov    %esp,%ebp
801011aa:	53                   	push   %ebx
801011ab:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011ae:	8b 45 08             	mov    0x8(%ebp),%eax
801011b1:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011b5:	84 c0                	test   %al,%al
801011b7:	75 0a                	jne    801011c3 <filewrite+0x1c>
    return -1;
801011b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011be:	e9 20 01 00 00       	jmp    801012e3 <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
801011c6:	8b 00                	mov    (%eax),%eax
801011c8:	83 f8 01             	cmp    $0x1,%eax
801011cb:	75 21                	jne    801011ee <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011cd:	8b 45 08             	mov    0x8(%ebp),%eax
801011d0:	8b 40 0c             	mov    0xc(%eax),%eax
801011d3:	8b 55 10             	mov    0x10(%ebp),%edx
801011d6:	89 54 24 08          	mov    %edx,0x8(%esp)
801011da:	8b 55 0c             	mov    0xc(%ebp),%edx
801011dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e1:	89 04 24             	mov    %eax,(%esp)
801011e4:	e8 99 2c 00 00       	call   80103e82 <pipewrite>
801011e9:	e9 f5 00 00 00       	jmp    801012e3 <filewrite+0x13c>
  if(f->type == FD_INODE){
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 00                	mov    (%eax),%eax
801011f3:	83 f8 02             	cmp    $0x2,%eax
801011f6:	0f 85 db 00 00 00    	jne    801012d7 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011fc:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101203:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010120a:	e9 a8 00 00 00       	jmp    801012b7 <filewrite+0x110>
      int n1 = n - i;
8010120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101212:	8b 55 10             	mov    0x10(%ebp),%edx
80101215:	29 c2                	sub    %eax,%edx
80101217:	89 d0                	mov    %edx,%eax
80101219:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010121f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101222:	7e 06                	jle    8010122a <filewrite+0x83>
        n1 = max;
80101224:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101227:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010122a:	e8 94 20 00 00       	call   801032c3 <begin_trans>
      ilock(f->ip);
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 40 10             	mov    0x10(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 16 06 00 00       	call   80101853 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010123d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 50 14             	mov    0x14(%eax),%edx
80101246:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101249:	8b 45 0c             	mov    0xc(%ebp),%eax
8010124c:	01 c3                	add    %eax,%ebx
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 40 10             	mov    0x10(%eax),%eax
80101254:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101258:	89 54 24 08          	mov    %edx,0x8(%esp)
8010125c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101260:	89 04 24             	mov    %eax,(%esp)
80101263:	e8 5c 0c 00 00       	call   80101ec4 <writei>
80101268:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010126b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126f:	7e 11                	jle    80101282 <filewrite+0xdb>
        f->off += r;
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 50 14             	mov    0x14(%eax),%edx
80101277:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010127a:	01 c2                	add    %eax,%edx
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 40 10             	mov    0x10(%eax),%eax
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 11 07 00 00       	call   801019a1 <iunlock>
      commit_trans();
80101290:	e8 77 20 00 00       	call   8010330c <commit_trans>

      if(r < 0)
80101295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101299:	79 02                	jns    8010129d <filewrite+0xf6>
        break;
8010129b:	eb 26                	jmp    801012c3 <filewrite+0x11c>
      if(r != n1)
8010129d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012a3:	74 0c                	je     801012b1 <filewrite+0x10a>
        panic("short filewrite");
801012a5:	c7 04 24 1f 8a 10 80 	movl   $0x80108a1f,(%esp)
801012ac:	e8 89 f2 ff ff       	call   8010053a <panic>
      i += r;
801012b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ba:	3b 45 10             	cmp    0x10(%ebp),%eax
801012bd:	0f 8c 4c ff ff ff    	jl     8010120f <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c6:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c9:	75 05                	jne    801012d0 <filewrite+0x129>
801012cb:	8b 45 10             	mov    0x10(%ebp),%eax
801012ce:	eb 05                	jmp    801012d5 <filewrite+0x12e>
801012d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d5:	eb 0c                	jmp    801012e3 <filewrite+0x13c>
  }
  panic("filewrite");
801012d7:	c7 04 24 2f 8a 10 80 	movl   $0x80108a2f,(%esp)
801012de:	e8 57 f2 ff ff       	call   8010053a <panic>
}
801012e3:	83 c4 24             	add    $0x24,%esp
801012e6:	5b                   	pop    %ebx
801012e7:	5d                   	pop    %ebp
801012e8:	c3                   	ret    

801012e9 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012e9:	55                   	push   %ebp
801012ea:	89 e5                	mov    %esp,%ebp
801012ec:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012f9:	00 
801012fa:	89 04 24             	mov    %eax,(%esp)
801012fd:	e8 a4 ee ff ff       	call   801001a6 <bread>
80101302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101308:	83 c0 18             	add    $0x18,%eax
8010130b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101312:	00 
80101313:	89 44 24 04          	mov    %eax,0x4(%esp)
80101317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131a:	89 04 24             	mov    %eax,(%esp)
8010131d:	e8 0b 43 00 00       	call   8010562d <memmove>
  brelse(bp);
80101322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101325:	89 04 24             	mov    %eax,(%esp)
80101328:	e8 ea ee ff ff       	call   80100217 <brelse>
}
8010132d:	c9                   	leave  
8010132e:	c3                   	ret    

8010132f <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010132f:	55                   	push   %ebp
80101330:	89 e5                	mov    %esp,%ebp
80101332:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101335:	8b 55 0c             	mov    0xc(%ebp),%edx
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010133f:	89 04 24             	mov    %eax,(%esp)
80101342:	e8 5f ee ff ff       	call   801001a6 <bread>
80101347:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134d:	83 c0 18             	add    $0x18,%eax
80101350:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101357:	00 
80101358:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010135f:	00 
80101360:	89 04 24             	mov    %eax,(%esp)
80101363:	e8 f6 41 00 00       	call   8010555e <memset>
  log_write(bp);
80101368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136b:	89 04 24             	mov    %eax,(%esp)
8010136e:	e8 f1 1f 00 00       	call   80103364 <log_write>
  brelse(bp);
80101373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 99 ee ff ff       	call   80100217 <brelse>
}
8010137e:	c9                   	leave  
8010137f:	c3                   	ret    

80101380 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101386:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101393:	89 54 24 04          	mov    %edx,0x4(%esp)
80101397:	89 04 24             	mov    %eax,(%esp)
8010139a:	e8 4a ff ff ff       	call   801012e9 <readsb>
  for(b = 0; b < sb.size; b += BPB){
8010139f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013a6:	e9 07 01 00 00       	jmp    801014b2 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013b4:	85 c0                	test   %eax,%eax
801013b6:	0f 48 c2             	cmovs  %edx,%eax
801013b9:	c1 f8 0c             	sar    $0xc,%eax
801013bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013bf:	c1 ea 03             	shr    $0x3,%edx
801013c2:	01 d0                	add    %edx,%eax
801013c4:	83 c0 03             	add    $0x3,%eax
801013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801013cb:	8b 45 08             	mov    0x8(%ebp),%eax
801013ce:	89 04 24             	mov    %eax,(%esp)
801013d1:	e8 d0 ed ff ff       	call   801001a6 <bread>
801013d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013e0:	e9 9d 00 00 00       	jmp    80101482 <balloc+0x102>
      m = 1 << (bi % 8);
801013e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013e8:	99                   	cltd   
801013e9:	c1 ea 1d             	shr    $0x1d,%edx
801013ec:	01 d0                	add    %edx,%eax
801013ee:	83 e0 07             	and    $0x7,%eax
801013f1:	29 d0                	sub    %edx,%eax
801013f3:	ba 01 00 00 00       	mov    $0x1,%edx
801013f8:	89 c1                	mov    %eax,%ecx
801013fa:	d3 e2                	shl    %cl,%edx
801013fc:	89 d0                	mov    %edx,%eax
801013fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101404:	8d 50 07             	lea    0x7(%eax),%edx
80101407:	85 c0                	test   %eax,%eax
80101409:	0f 48 c2             	cmovs  %edx,%eax
8010140c:	c1 f8 03             	sar    $0x3,%eax
8010140f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101412:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101417:	0f b6 c0             	movzbl %al,%eax
8010141a:	23 45 e8             	and    -0x18(%ebp),%eax
8010141d:	85 c0                	test   %eax,%eax
8010141f:	75 5d                	jne    8010147e <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101421:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101424:	8d 50 07             	lea    0x7(%eax),%edx
80101427:	85 c0                	test   %eax,%eax
80101429:	0f 48 c2             	cmovs  %edx,%eax
8010142c:	c1 f8 03             	sar    $0x3,%eax
8010142f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101432:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101437:	89 d1                	mov    %edx,%ecx
80101439:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010143c:	09 ca                	or     %ecx,%edx
8010143e:	89 d1                	mov    %edx,%ecx
80101440:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101443:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101447:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010144a:	89 04 24             	mov    %eax,(%esp)
8010144d:	e8 12 1f 00 00       	call   80103364 <log_write>
        brelse(bp);
80101452:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 ba ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
8010145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101460:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101463:	01 c2                	add    %eax,%edx
80101465:	8b 45 08             	mov    0x8(%ebp),%eax
80101468:	89 54 24 04          	mov    %edx,0x4(%esp)
8010146c:	89 04 24             	mov    %eax,(%esp)
8010146f:	e8 bb fe ff ff       	call   8010132f <bzero>
        return b + bi;
80101474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147a:	01 d0                	add    %edx,%eax
8010147c:	eb 4e                	jmp    801014cc <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010147e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101482:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101489:	7f 15                	jg     801014a0 <balloc+0x120>
8010148b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101491:	01 d0                	add    %edx,%eax
80101493:	89 c2                	mov    %eax,%edx
80101495:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101498:	39 c2                	cmp    %eax,%edx
8010149a:	0f 82 45 ff ff ff    	jb     801013e5 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a3:	89 04 24             	mov    %eax,(%esp)
801014a6:	e8 6c ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014ab:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014b8:	39 c2                	cmp    %eax,%edx
801014ba:	0f 82 eb fe ff ff    	jb     801013ab <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014c0:	c7 04 24 39 8a 10 80 	movl   $0x80108a39,(%esp)
801014c7:	e8 6e f0 ff ff       	call   8010053a <panic>
}
801014cc:	c9                   	leave  
801014cd:	c3                   	ret    

801014ce <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014ce:	55                   	push   %ebp
801014cf:	89 e5                	mov    %esp,%ebp
801014d1:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014d4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801014db:	8b 45 08             	mov    0x8(%ebp),%eax
801014de:	89 04 24             	mov    %eax,(%esp)
801014e1:	e8 03 fe ff ff       	call   801012e9 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801014e9:	c1 e8 0c             	shr    $0xc,%eax
801014ec:	89 c2                	mov    %eax,%edx
801014ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014f1:	c1 e8 03             	shr    $0x3,%eax
801014f4:	01 d0                	add    %edx,%eax
801014f6:	8d 50 03             	lea    0x3(%eax),%edx
801014f9:	8b 45 08             	mov    0x8(%ebp),%eax
801014fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101500:	89 04 24             	mov    %eax,(%esp)
80101503:	e8 9e ec ff ff       	call   801001a6 <bread>
80101508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010150b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010150e:	25 ff 0f 00 00       	and    $0xfff,%eax
80101513:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101516:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101519:	99                   	cltd   
8010151a:	c1 ea 1d             	shr    $0x1d,%edx
8010151d:	01 d0                	add    %edx,%eax
8010151f:	83 e0 07             	and    $0x7,%eax
80101522:	29 d0                	sub    %edx,%eax
80101524:	ba 01 00 00 00       	mov    $0x1,%edx
80101529:	89 c1                	mov    %eax,%ecx
8010152b:	d3 e2                	shl    %cl,%edx
8010152d:	89 d0                	mov    %edx,%eax
8010152f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101535:	8d 50 07             	lea    0x7(%eax),%edx
80101538:	85 c0                	test   %eax,%eax
8010153a:	0f 48 c2             	cmovs  %edx,%eax
8010153d:	c1 f8 03             	sar    $0x3,%eax
80101540:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101543:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101548:	0f b6 c0             	movzbl %al,%eax
8010154b:	23 45 ec             	and    -0x14(%ebp),%eax
8010154e:	85 c0                	test   %eax,%eax
80101550:	75 0c                	jne    8010155e <bfree+0x90>
    panic("freeing free block");
80101552:	c7 04 24 4f 8a 10 80 	movl   $0x80108a4f,(%esp)
80101559:	e8 dc ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
8010155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101561:	8d 50 07             	lea    0x7(%eax),%edx
80101564:	85 c0                	test   %eax,%eax
80101566:	0f 48 c2             	cmovs  %edx,%eax
80101569:	c1 f8 03             	sar    $0x3,%eax
8010156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156f:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101574:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101577:	f7 d1                	not    %ecx
80101579:	21 ca                	and    %ecx,%edx
8010157b:	89 d1                	mov    %edx,%ecx
8010157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101580:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101587:	89 04 24             	mov    %eax,(%esp)
8010158a:	e8 d5 1d 00 00       	call   80103364 <log_write>
  brelse(bp);
8010158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101592:	89 04 24             	mov    %eax,(%esp)
80101595:	e8 7d ec ff ff       	call   80100217 <brelse>
}
8010159a:	c9                   	leave  
8010159b:	c3                   	ret    

8010159c <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
8010159c:	55                   	push   %ebp
8010159d:	89 e5                	mov    %esp,%ebp
8010159f:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015a2:	c7 44 24 04 62 8a 10 	movl   $0x80108a62,0x4(%esp)
801015a9:	80 
801015aa:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801015b1:	e8 33 3d 00 00       	call   801052e9 <initlock>
}
801015b6:	c9                   	leave  
801015b7:	c3                   	ret    

801015b8 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015b8:	55                   	push   %ebp
801015b9:	89 e5                	mov    %esp,%ebp
801015bb:	83 ec 38             	sub    $0x38,%esp
801015be:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c1:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015c5:	8b 45 08             	mov    0x8(%ebp),%eax
801015c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801015cf:	89 04 24             	mov    %eax,(%esp)
801015d2:	e8 12 fd ff ff       	call   801012e9 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015de:	e9 98 00 00 00       	jmp    8010167b <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e6:	c1 e8 03             	shr    $0x3,%eax
801015e9:	83 c0 02             	add    $0x2,%eax
801015ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801015f0:	8b 45 08             	mov    0x8(%ebp),%eax
801015f3:	89 04 24             	mov    %eax,(%esp)
801015f6:	e8 ab eb ff ff       	call   801001a6 <bread>
801015fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101601:	8d 50 18             	lea    0x18(%eax),%edx
80101604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101607:	83 e0 07             	and    $0x7,%eax
8010160a:	c1 e0 06             	shl    $0x6,%eax
8010160d:	01 d0                	add    %edx,%eax
8010160f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101612:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101615:	0f b7 00             	movzwl (%eax),%eax
80101618:	66 85 c0             	test   %ax,%ax
8010161b:	75 4f                	jne    8010166c <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010161d:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101624:	00 
80101625:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010162c:	00 
8010162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101630:	89 04 24             	mov    %eax,(%esp)
80101633:	e8 26 3f 00 00       	call   8010555e <memset>
      dip->type = type;
80101638:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163b:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010163f:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101645:	89 04 24             	mov    %eax,(%esp)
80101648:	e8 17 1d 00 00       	call   80103364 <log_write>
      brelse(bp);
8010164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101650:	89 04 24             	mov    %eax,(%esp)
80101653:	e8 bf eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010165b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010165f:	8b 45 08             	mov    0x8(%ebp),%eax
80101662:	89 04 24             	mov    %eax,(%esp)
80101665:	e8 e5 00 00 00       	call   8010174f <iget>
8010166a:	eb 29                	jmp    80101695 <ialloc+0xdd>
    }
    brelse(bp);
8010166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166f:	89 04 24             	mov    %eax,(%esp)
80101672:	e8 a0 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101677:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010167b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010167e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101681:	39 c2                	cmp    %eax,%edx
80101683:	0f 82 5a ff ff ff    	jb     801015e3 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101689:	c7 04 24 69 8a 10 80 	movl   $0x80108a69,(%esp)
80101690:	e8 a5 ee ff ff       	call   8010053a <panic>
}
80101695:	c9                   	leave  
80101696:	c3                   	ret    

80101697 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101697:	55                   	push   %ebp
80101698:	89 e5                	mov    %esp,%ebp
8010169a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010169d:	8b 45 08             	mov    0x8(%ebp),%eax
801016a0:	8b 40 04             	mov    0x4(%eax),%eax
801016a3:	c1 e8 03             	shr    $0x3,%eax
801016a6:	8d 50 02             	lea    0x2(%eax),%edx
801016a9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ac:	8b 00                	mov    (%eax),%eax
801016ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801016b2:	89 04 24             	mov    %eax,(%esp)
801016b5:	e8 ec ea ff ff       	call   801001a6 <bread>
801016ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c0:	8d 50 18             	lea    0x18(%eax),%edx
801016c3:	8b 45 08             	mov    0x8(%ebp),%eax
801016c6:	8b 40 04             	mov    0x4(%eax),%eax
801016c9:	83 e0 07             	and    $0x7,%eax
801016cc:	c1 e0 06             	shl    $0x6,%eax
801016cf:	01 d0                	add    %edx,%eax
801016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016d4:	8b 45 08             	mov    0x8(%ebp),%eax
801016d7:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016de:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e1:	8b 45 08             	mov    0x8(%ebp),%eax
801016e4:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016eb:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801016f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f9:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101704:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101707:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 45 08             	mov    0x8(%ebp),%eax
8010170e:	8b 50 18             	mov    0x18(%eax),%edx
80101711:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101714:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	8b 45 08             	mov    0x8(%ebp),%eax
8010171a:	8d 50 1c             	lea    0x1c(%eax),%edx
8010171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101720:	83 c0 0c             	add    $0xc,%eax
80101723:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010172a:	00 
8010172b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010172f:	89 04 24             	mov    %eax,(%esp)
80101732:	e8 f6 3e 00 00       	call   8010562d <memmove>
  log_write(bp);
80101737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 22 1c 00 00       	call   80103364 <log_write>
  brelse(bp);
80101742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101745:	89 04 24             	mov    %eax,(%esp)
80101748:	e8 ca ea ff ff       	call   80100217 <brelse>
}
8010174d:	c9                   	leave  
8010174e:	c3                   	ret    

8010174f <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010174f:	55                   	push   %ebp
80101750:	89 e5                	mov    %esp,%ebp
80101752:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101755:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010175c:	e8 a9 3b 00 00       	call   8010530a <acquire>

  // Is the inode already cached?
  empty = 0;
80101761:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101768:	c7 45 f4 b4 f8 10 80 	movl   $0x8010f8b4,-0xc(%ebp)
8010176f:	eb 59                	jmp    801017ca <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101774:	8b 40 08             	mov    0x8(%eax),%eax
80101777:	85 c0                	test   %eax,%eax
80101779:	7e 35                	jle    801017b0 <iget+0x61>
8010177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177e:	8b 00                	mov    (%eax),%eax
80101780:	3b 45 08             	cmp    0x8(%ebp),%eax
80101783:	75 2b                	jne    801017b0 <iget+0x61>
80101785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101788:	8b 40 04             	mov    0x4(%eax),%eax
8010178b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010178e:	75 20                	jne    801017b0 <iget+0x61>
      ip->ref++;
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	8b 40 08             	mov    0x8(%eax),%eax
80101796:	8d 50 01             	lea    0x1(%eax),%edx
80101799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010179f:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801017a6:	e8 c1 3b 00 00       	call   8010536c <release>
      return ip;
801017ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ae:	eb 6f                	jmp    8010181f <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017b4:	75 10                	jne    801017c6 <iget+0x77>
801017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b9:	8b 40 08             	mov    0x8(%eax),%eax
801017bc:	85 c0                	test   %eax,%eax
801017be:	75 06                	jne    801017c6 <iget+0x77>
      empty = ip;
801017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c6:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017ca:	81 7d f4 54 08 11 80 	cmpl   $0x80110854,-0xc(%ebp)
801017d1:	72 9e                	jb     80101771 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017d7:	75 0c                	jne    801017e5 <iget+0x96>
    panic("iget: no inodes");
801017d9:	c7 04 24 7b 8a 10 80 	movl   $0x80108a7b,(%esp)
801017e0:	e8 55 ed ff ff       	call   8010053a <panic>

  ip = empty;
801017e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ee:	8b 55 08             	mov    0x8(%ebp),%edx
801017f1:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801017f9:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101809:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101810:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101817:	e8 50 3b 00 00       	call   8010536c <release>

  return ip;
8010181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010181f:	c9                   	leave  
80101820:	c3                   	ret    

80101821 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101821:	55                   	push   %ebp
80101822:	89 e5                	mov    %esp,%ebp
80101824:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101827:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010182e:	e8 d7 3a 00 00       	call   8010530a <acquire>
  ip->ref++;
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	8b 40 08             	mov    0x8(%eax),%eax
80101839:	8d 50 01             	lea    0x1(%eax),%edx
8010183c:	8b 45 08             	mov    0x8(%ebp),%eax
8010183f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101842:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101849:	e8 1e 3b 00 00       	call   8010536c <release>
  return ip;
8010184e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101851:	c9                   	leave  
80101852:	c3                   	ret    

80101853 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101853:	55                   	push   %ebp
80101854:	89 e5                	mov    %esp,%ebp
80101856:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101859:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010185d:	74 0a                	je     80101869 <ilock+0x16>
8010185f:	8b 45 08             	mov    0x8(%ebp),%eax
80101862:	8b 40 08             	mov    0x8(%eax),%eax
80101865:	85 c0                	test   %eax,%eax
80101867:	7f 0c                	jg     80101875 <ilock+0x22>
    panic("ilock");
80101869:	c7 04 24 8b 8a 10 80 	movl   $0x80108a8b,(%esp)
80101870:	e8 c5 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101875:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010187c:	e8 89 3a 00 00       	call   8010530a <acquire>
  while(ip->flags & I_BUSY)
80101881:	eb 13                	jmp    80101896 <ilock+0x43>
    sleep(ip, &icache.lock);
80101883:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
8010188a:	80 
8010188b:	8b 45 08             	mov    0x8(%ebp),%eax
8010188e:	89 04 24             	mov    %eax,(%esp)
80101891:	e8 b7 33 00 00       	call   80104c4d <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101896:	8b 45 08             	mov    0x8(%ebp),%eax
80101899:	8b 40 0c             	mov    0xc(%eax),%eax
8010189c:	83 e0 01             	and    $0x1,%eax
8010189f:	85 c0                	test   %eax,%eax
801018a1:	75 e0                	jne    80101883 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018a3:	8b 45 08             	mov    0x8(%ebp),%eax
801018a6:	8b 40 0c             	mov    0xc(%eax),%eax
801018a9:	83 c8 01             	or     $0x1,%eax
801018ac:	89 c2                	mov    %eax,%edx
801018ae:	8b 45 08             	mov    0x8(%ebp),%eax
801018b1:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018b4:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801018bb:	e8 ac 3a 00 00       	call   8010536c <release>

  if(!(ip->flags & I_VALID)){
801018c0:	8b 45 08             	mov    0x8(%ebp),%eax
801018c3:	8b 40 0c             	mov    0xc(%eax),%eax
801018c6:	83 e0 02             	and    $0x2,%eax
801018c9:	85 c0                	test   %eax,%eax
801018cb:	0f 85 ce 00 00 00    	jne    8010199f <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018d1:	8b 45 08             	mov    0x8(%ebp),%eax
801018d4:	8b 40 04             	mov    0x4(%eax),%eax
801018d7:	c1 e8 03             	shr    $0x3,%eax
801018da:	8d 50 02             	lea    0x2(%eax),%edx
801018dd:	8b 45 08             	mov    0x8(%ebp),%eax
801018e0:	8b 00                	mov    (%eax),%eax
801018e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801018e6:	89 04 24             	mov    %eax,(%esp)
801018e9:	e8 b8 e8 ff ff       	call   801001a6 <bread>
801018ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f4:	8d 50 18             	lea    0x18(%eax),%edx
801018f7:	8b 45 08             	mov    0x8(%ebp),%eax
801018fa:	8b 40 04             	mov    0x4(%eax),%eax
801018fd:	83 e0 07             	and    $0x7,%eax
80101900:	c1 e0 06             	shl    $0x6,%eax
80101903:	01 d0                	add    %edx,%eax
80101905:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010190b:	0f b7 10             	movzwl (%eax),%edx
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101918:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010191c:	8b 45 08             	mov    0x8(%ebp),%eax
8010191f:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101926:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010192a:	8b 45 08             	mov    0x8(%ebp),%eax
8010192d:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101931:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101934:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101938:	8b 45 08             	mov    0x8(%ebp),%eax
8010193b:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101942:	8b 50 08             	mov    0x8(%eax),%edx
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194e:	8d 50 0c             	lea    0xc(%eax),%edx
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	83 c0 1c             	add    $0x1c,%eax
80101957:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010195e:	00 
8010195f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101963:	89 04 24             	mov    %eax,(%esp)
80101966:	e8 c2 3c 00 00       	call   8010562d <memmove>
    brelse(bp);
8010196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196e:	89 04 24             	mov    %eax,(%esp)
80101971:	e8 a1 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101976:	8b 45 08             	mov    0x8(%ebp),%eax
80101979:	8b 40 0c             	mov    0xc(%eax),%eax
8010197c:	83 c8 02             	or     $0x2,%eax
8010197f:	89 c2                	mov    %eax,%edx
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101987:	8b 45 08             	mov    0x8(%ebp),%eax
8010198a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010198e:	66 85 c0             	test   %ax,%ax
80101991:	75 0c                	jne    8010199f <ilock+0x14c>
      panic("ilock: no type");
80101993:	c7 04 24 91 8a 10 80 	movl   $0x80108a91,(%esp)
8010199a:	e8 9b eb ff ff       	call   8010053a <panic>
  }
}
8010199f:	c9                   	leave  
801019a0:	c3                   	ret    

801019a1 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019a1:	55                   	push   %ebp
801019a2:	89 e5                	mov    %esp,%ebp
801019a4:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019ab:	74 17                	je     801019c4 <iunlock+0x23>
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 0c             	mov    0xc(%eax),%eax
801019b3:	83 e0 01             	and    $0x1,%eax
801019b6:	85 c0                	test   %eax,%eax
801019b8:	74 0a                	je     801019c4 <iunlock+0x23>
801019ba:	8b 45 08             	mov    0x8(%ebp),%eax
801019bd:	8b 40 08             	mov    0x8(%eax),%eax
801019c0:	85 c0                	test   %eax,%eax
801019c2:	7f 0c                	jg     801019d0 <iunlock+0x2f>
    panic("iunlock");
801019c4:	c7 04 24 a0 8a 10 80 	movl   $0x80108aa0,(%esp)
801019cb:	e8 6a eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019d0:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019d7:	e8 2e 39 00 00       	call   8010530a <acquire>
  ip->flags &= ~I_BUSY;
801019dc:	8b 45 08             	mov    0x8(%ebp),%eax
801019df:	8b 40 0c             	mov    0xc(%eax),%eax
801019e2:	83 e0 fe             	and    $0xfffffffe,%eax
801019e5:	89 c2                	mov    %eax,%edx
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	89 04 24             	mov    %eax,(%esp)
801019f3:	e8 99 33 00 00       	call   80104d91 <wakeup>
  release(&icache.lock);
801019f8:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019ff:	e8 68 39 00 00       	call   8010536c <release>
}
80101a04:	c9                   	leave  
80101a05:	c3                   	ret    

80101a06 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a06:	55                   	push   %ebp
80101a07:	89 e5                	mov    %esp,%ebp
80101a09:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a0c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a13:	e8 f2 38 00 00       	call   8010530a <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a18:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1b:	8b 40 08             	mov    0x8(%eax),%eax
80101a1e:	83 f8 01             	cmp    $0x1,%eax
80101a21:	0f 85 93 00 00 00    	jne    80101aba <iput+0xb4>
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a2d:	83 e0 02             	and    $0x2,%eax
80101a30:	85 c0                	test   %eax,%eax
80101a32:	0f 84 82 00 00 00    	je     80101aba <iput+0xb4>
80101a38:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a3f:	66 85 c0             	test   %ax,%ax
80101a42:	75 76                	jne    80101aba <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a44:	8b 45 08             	mov    0x8(%ebp),%eax
80101a47:	8b 40 0c             	mov    0xc(%eax),%eax
80101a4a:	83 e0 01             	and    $0x1,%eax
80101a4d:	85 c0                	test   %eax,%eax
80101a4f:	74 0c                	je     80101a5d <iput+0x57>
      panic("iput busy");
80101a51:	c7 04 24 a8 8a 10 80 	movl   $0x80108aa8,(%esp)
80101a58:	e8 dd ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 c8 01             	or     $0x1,%eax
80101a66:	89 c2                	mov    %eax,%edx
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a6e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a75:	e8 f2 38 00 00       	call   8010536c <release>
    itrunc(ip);
80101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7d:	89 04 24             	mov    %eax,(%esp)
80101a80:	e8 7d 01 00 00       	call   80101c02 <itrunc>
    ip->type = 0;
80101a85:	8b 45 08             	mov    0x8(%ebp),%eax
80101a88:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a91:	89 04 24             	mov    %eax,(%esp)
80101a94:	e8 fe fb ff ff       	call   80101697 <iupdate>
    acquire(&icache.lock);
80101a99:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101aa0:	e8 65 38 00 00       	call   8010530a <acquire>
    ip->flags = 0;
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 d7 32 00 00       	call   80104d91 <wakeup>
  }
  ip->ref--;
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	8b 40 08             	mov    0x8(%eax),%eax
80101ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ac9:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101ad0:	e8 97 38 00 00       	call   8010536c <release>
}
80101ad5:	c9                   	leave  
80101ad6:	c3                   	ret    

80101ad7 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ad7:	55                   	push   %ebp
80101ad8:	89 e5                	mov    %esp,%ebp
80101ada:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	89 04 24             	mov    %eax,(%esp)
80101ae3:	e8 b9 fe ff ff       	call   801019a1 <iunlock>
  iput(ip);
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	89 04 24             	mov    %eax,(%esp)
80101aee:	e8 13 ff ff ff       	call   80101a06 <iput>
}
80101af3:	c9                   	leave  
80101af4:	c3                   	ret    

80101af5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101af5:	55                   	push   %ebp
80101af6:	89 e5                	mov    %esp,%ebp
80101af8:	53                   	push   %ebx
80101af9:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101afc:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b00:	77 3e                	ja     80101b40 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b08:	83 c2 04             	add    $0x4,%edx
80101b0b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b16:	75 20                	jne    80101b38 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b18:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1b:	8b 00                	mov    (%eax),%eax
80101b1d:	89 04 24             	mov    %eax,(%esp)
80101b20:	e8 5b f8 ff ff       	call   80101380 <balloc>
80101b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b2e:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b34:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b3b:	e9 bc 00 00 00       	jmp    80101bfc <bmap+0x107>
  }
  bn -= NDIRECT;
80101b40:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b44:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b48:	0f 87 a2 00 00 00    	ja     80101bf0 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b5b:	75 19                	jne    80101b76 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b60:	8b 00                	mov    (%eax),%eax
80101b62:	89 04 24             	mov    %eax,(%esp)
80101b65:	e8 16 f8 ff ff       	call   80101380 <balloc>
80101b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b73:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b76:	8b 45 08             	mov    0x8(%ebp),%eax
80101b79:	8b 00                	mov    (%eax),%eax
80101b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b82:	89 04 24             	mov    %eax,(%esp)
80101b85:	e8 1c e6 ff ff       	call   801001a6 <bread>
80101b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b90:	83 c0 18             	add    $0x18,%eax
80101b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ba3:	01 d0                	add    %edx,%eax
80101ba5:	8b 00                	mov    (%eax),%eax
80101ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bae:	75 30                	jne    80101be0 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bbd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc3:	8b 00                	mov    (%eax),%eax
80101bc5:	89 04 24             	mov    %eax,(%esp)
80101bc8:	e8 b3 f7 ff ff       	call   80101380 <balloc>
80101bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bd3:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 84 17 00 00       	call   80103364 <log_write>
    }
    brelse(bp);
80101be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be3:	89 04 24             	mov    %eax,(%esp)
80101be6:	e8 2c e6 ff ff       	call   80100217 <brelse>
    return addr;
80101beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bee:	eb 0c                	jmp    80101bfc <bmap+0x107>
  }

  panic("bmap: out of range");
80101bf0:	c7 04 24 b2 8a 10 80 	movl   $0x80108ab2,(%esp)
80101bf7:	e8 3e e9 ff ff       	call   8010053a <panic>
}
80101bfc:	83 c4 24             	add    $0x24,%esp
80101bff:	5b                   	pop    %ebx
80101c00:	5d                   	pop    %ebp
80101c01:	c3                   	ret    

80101c02 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c02:	55                   	push   %ebp
80101c03:	89 e5                	mov    %esp,%ebp
80101c05:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c0f:	eb 44                	jmp    80101c55 <itrunc+0x53>
    if(ip->addrs[i]){
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c17:	83 c2 04             	add    $0x4,%edx
80101c1a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	74 2f                	je     80101c51 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c22:	8b 45 08             	mov    0x8(%ebp),%eax
80101c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c28:	83 c2 04             	add    $0x4,%edx
80101c2b:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	8b 00                	mov    (%eax),%eax
80101c34:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c38:	89 04 24             	mov    %eax,(%esp)
80101c3b:	e8 8e f8 ff ff       	call   801014ce <bfree>
      ip->addrs[i] = 0;
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c46:	83 c2 04             	add    $0x4,%edx
80101c49:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c50:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c55:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c59:	7e b6                	jle    80101c11 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	0f 84 9b 00 00 00    	je     80101d04 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c69:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6c:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	8b 00                	mov    (%eax),%eax
80101c74:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c78:	89 04 24             	mov    %eax,(%esp)
80101c7b:	e8 26 e5 ff ff       	call   801001a6 <bread>
80101c80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c86:	83 c0 18             	add    $0x18,%eax
80101c89:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c93:	eb 3b                	jmp    80101cd0 <itrunc+0xce>
      if(a[j])
80101c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ca2:	01 d0                	add    %edx,%eax
80101ca4:	8b 00                	mov    (%eax),%eax
80101ca6:	85 c0                	test   %eax,%eax
80101ca8:	74 22                	je     80101ccc <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cb7:	01 d0                	add    %edx,%eax
80101cb9:	8b 10                	mov    (%eax),%edx
80101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbe:	8b 00                	mov    (%eax),%eax
80101cc0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc4:	89 04 24             	mov    %eax,(%esp)
80101cc7:	e8 02 f8 ff ff       	call   801014ce <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ccc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd3:	83 f8 7f             	cmp    $0x7f,%eax
80101cd6:	76 bd                	jbe    80101c95 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cdb:	89 04 24             	mov    %eax,(%esp)
80101cde:	e8 34 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 00                	mov    (%eax),%eax
80101cee:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cf2:	89 04 24             	mov    %eax,(%esp)
80101cf5:	e8 d4 f7 ff ff       	call   801014ce <bfree>
    ip->addrs[NDIRECT] = 0;
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d04:	8b 45 08             	mov    0x8(%ebp),%eax
80101d07:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d11:	89 04 24             	mov    %eax,(%esp)
80101d14:	e8 7e f9 ff ff       	call   80101697 <iupdate>
}
80101d19:	c9                   	leave  
80101d1a:	c3                   	ret    

80101d1b <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d1b:	55                   	push   %ebp
80101d1c:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d21:	8b 00                	mov    (%eax),%eax
80101d23:	89 c2                	mov    %eax,%edx
80101d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d28:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	8b 50 04             	mov    0x4(%eax),%edx
80101d31:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d34:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d41:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4e:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	8b 50 18             	mov    0x18(%eax),%edx
80101d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d5e:	5d                   	pop    %ebp
80101d5f:	c3                   	ret    

80101d60 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d6d:	66 83 f8 03          	cmp    $0x3,%ax
80101d71:	75 60                	jne    80101dd3 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d7a:	66 85 c0             	test   %ax,%ax
80101d7d:	78 20                	js     80101d9f <readi+0x3f>
80101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d82:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d86:	66 83 f8 09          	cmp    $0x9,%ax
80101d8a:	7f 13                	jg     80101d9f <readi+0x3f>
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d93:	98                   	cwtl   
80101d94:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101d9b:	85 c0                	test   %eax,%eax
80101d9d:	75 0a                	jne    80101da9 <readi+0x49>
      return -1;
80101d9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da4:	e9 19 01 00 00       	jmp    80101ec2 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101da9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dac:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db0:	98                   	cwtl   
80101db1:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101db8:	8b 55 14             	mov    0x14(%ebp),%edx
80101dbb:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dc6:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc9:	89 14 24             	mov    %edx,(%esp)
80101dcc:	ff d0                	call   *%eax
80101dce:	e9 ef 00 00 00       	jmp    80101ec2 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 40 18             	mov    0x18(%eax),%eax
80101dd9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ddc:	72 0d                	jb     80101deb <readi+0x8b>
80101dde:	8b 45 14             	mov    0x14(%ebp),%eax
80101de1:	8b 55 10             	mov    0x10(%ebp),%edx
80101de4:	01 d0                	add    %edx,%eax
80101de6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de9:	73 0a                	jae    80101df5 <readi+0x95>
    return -1;
80101deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df0:	e9 cd 00 00 00       	jmp    80101ec2 <readi+0x162>
  if(off + n > ip->size)
80101df5:	8b 45 14             	mov    0x14(%ebp),%eax
80101df8:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfb:	01 c2                	add    %eax,%edx
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 40 18             	mov    0x18(%eax),%eax
80101e03:	39 c2                	cmp    %eax,%edx
80101e05:	76 0c                	jbe    80101e13 <readi+0xb3>
    n = ip->size - off;
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	8b 40 18             	mov    0x18(%eax),%eax
80101e0d:	2b 45 10             	sub    0x10(%ebp),%eax
80101e10:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e1a:	e9 94 00 00 00       	jmp    80101eb3 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e1f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e22:	c1 e8 09             	shr    $0x9,%eax
80101e25:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e29:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2c:	89 04 24             	mov    %eax,(%esp)
80101e2f:	e8 c1 fc ff ff       	call   80101af5 <bmap>
80101e34:	8b 55 08             	mov    0x8(%ebp),%edx
80101e37:	8b 12                	mov    (%edx),%edx
80101e39:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3d:	89 14 24             	mov    %edx,(%esp)
80101e40:	e8 61 e3 ff ff       	call   801001a6 <bread>
80101e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e48:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e50:	89 c2                	mov    %eax,%edx
80101e52:	b8 00 02 00 00       	mov    $0x200,%eax
80101e57:	29 d0                	sub    %edx,%eax
80101e59:	89 c2                	mov    %eax,%edx
80101e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e61:	29 c1                	sub    %eax,%ecx
80101e63:	89 c8                	mov    %ecx,%eax
80101e65:	39 c2                	cmp    %eax,%edx
80101e67:	0f 46 c2             	cmovbe %edx,%eax
80101e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e6d:	8b 45 10             	mov    0x10(%ebp),%eax
80101e70:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e75:	8d 50 10             	lea    0x10(%eax),%edx
80101e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e7b:	01 d0                	add    %edx,%eax
80101e7d:	8d 50 08             	lea    0x8(%eax),%edx
80101e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e83:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e87:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8e:	89 04 24             	mov    %eax,(%esp)
80101e91:	e8 97 37 00 00       	call   8010562d <memmove>
    brelse(bp);
80101e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e99:	89 04 24             	mov    %eax,(%esp)
80101e9c:	e8 76 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea4:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eaa:	01 45 10             	add    %eax,0x10(%ebp)
80101ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb0:	01 45 0c             	add    %eax,0xc(%ebp)
80101eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb6:	3b 45 14             	cmp    0x14(%ebp),%eax
80101eb9:	0f 82 60 ff ff ff    	jb     80101e1f <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ebf:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ec2:	c9                   	leave  
80101ec3:	c3                   	ret    

80101ec4 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ec4:	55                   	push   %ebp
80101ec5:	89 e5                	mov    %esp,%ebp
80101ec7:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101eca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ed1:	66 83 f8 03          	cmp    $0x3,%ax
80101ed5:	75 60                	jne    80101f37 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ede:	66 85 c0             	test   %ax,%ax
80101ee1:	78 20                	js     80101f03 <writei+0x3f>
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eea:	66 83 f8 09          	cmp    $0x9,%ax
80101eee:	7f 13                	jg     80101f03 <writei+0x3f>
80101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef7:	98                   	cwtl   
80101ef8:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101eff:	85 c0                	test   %eax,%eax
80101f01:	75 0a                	jne    80101f0d <writei+0x49>
      return -1;
80101f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f08:	e9 44 01 00 00       	jmp    80102051 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f14:	98                   	cwtl   
80101f15:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101f1c:	8b 55 14             	mov    0x14(%ebp),%edx
80101f1f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f23:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f26:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f2a:	8b 55 08             	mov    0x8(%ebp),%edx
80101f2d:	89 14 24             	mov    %edx,(%esp)
80101f30:	ff d0                	call   *%eax
80101f32:	e9 1a 01 00 00       	jmp    80102051 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f37:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3a:	8b 40 18             	mov    0x18(%eax),%eax
80101f3d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f40:	72 0d                	jb     80101f4f <writei+0x8b>
80101f42:	8b 45 14             	mov    0x14(%ebp),%eax
80101f45:	8b 55 10             	mov    0x10(%ebp),%edx
80101f48:	01 d0                	add    %edx,%eax
80101f4a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f4d:	73 0a                	jae    80101f59 <writei+0x95>
    return -1;
80101f4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f54:	e9 f8 00 00 00       	jmp    80102051 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f59:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5c:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5f:	01 d0                	add    %edx,%eax
80101f61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f66:	76 0a                	jbe    80101f72 <writei+0xae>
    return -1;
80101f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6d:	e9 df 00 00 00       	jmp    80102051 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f79:	e9 9f 00 00 00       	jmp    8010201d <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f7e:	8b 45 10             	mov    0x10(%ebp),%eax
80101f81:	c1 e8 09             	shr    $0x9,%eax
80101f84:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	89 04 24             	mov    %eax,(%esp)
80101f8e:	e8 62 fb ff ff       	call   80101af5 <bmap>
80101f93:	8b 55 08             	mov    0x8(%ebp),%edx
80101f96:	8b 12                	mov    (%edx),%edx
80101f98:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9c:	89 14 24             	mov    %edx,(%esp)
80101f9f:	e8 02 e2 ff ff       	call   801001a6 <bread>
80101fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa7:	8b 45 10             	mov    0x10(%ebp),%eax
80101faa:	25 ff 01 00 00       	and    $0x1ff,%eax
80101faf:	89 c2                	mov    %eax,%edx
80101fb1:	b8 00 02 00 00       	mov    $0x200,%eax
80101fb6:	29 d0                	sub    %edx,%eax
80101fb8:	89 c2                	mov    %eax,%edx
80101fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fbd:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fc0:	29 c1                	sub    %eax,%ecx
80101fc2:	89 c8                	mov    %ecx,%eax
80101fc4:	39 c2                	cmp    %eax,%edx
80101fc6:	0f 46 c2             	cmovbe %edx,%eax
80101fc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fcc:	8b 45 10             	mov    0x10(%ebp),%eax
80101fcf:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fd4:	8d 50 10             	lea    0x10(%eax),%edx
80101fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fda:	01 d0                	add    %edx,%eax
80101fdc:	8d 50 08             	lea    0x8(%eax),%edx
80101fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fe2:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fed:	89 14 24             	mov    %edx,(%esp)
80101ff0:	e8 38 36 00 00       	call   8010562d <memmove>
    log_write(bp);
80101ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff8:	89 04 24             	mov    %eax,(%esp)
80101ffb:	e8 64 13 00 00       	call   80103364 <log_write>
    brelse(bp);
80102000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102003:	89 04 24             	mov    %eax,(%esp)
80102006:	e8 0c e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010200b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102011:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102014:	01 45 10             	add    %eax,0x10(%ebp)
80102017:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201a:	01 45 0c             	add    %eax,0xc(%ebp)
8010201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102020:	3b 45 14             	cmp    0x14(%ebp),%eax
80102023:	0f 82 55 ff ff ff    	jb     80101f7e <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102029:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010202d:	74 1f                	je     8010204e <writei+0x18a>
8010202f:	8b 45 08             	mov    0x8(%ebp),%eax
80102032:	8b 40 18             	mov    0x18(%eax),%eax
80102035:	3b 45 10             	cmp    0x10(%ebp),%eax
80102038:	73 14                	jae    8010204e <writei+0x18a>
    ip->size = off;
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	8b 55 10             	mov    0x10(%ebp),%edx
80102040:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102043:	8b 45 08             	mov    0x8(%ebp),%eax
80102046:	89 04 24             	mov    %eax,(%esp)
80102049:	e8 49 f6 ff ff       	call   80101697 <iupdate>
  }
  return n;
8010204e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102051:	c9                   	leave  
80102052:	c3                   	ret    

80102053 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102053:	55                   	push   %ebp
80102054:	89 e5                	mov    %esp,%ebp
80102056:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102059:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102060:	00 
80102061:	8b 45 0c             	mov    0xc(%ebp),%eax
80102064:	89 44 24 04          	mov    %eax,0x4(%esp)
80102068:	8b 45 08             	mov    0x8(%ebp),%eax
8010206b:	89 04 24             	mov    %eax,(%esp)
8010206e:	e8 5d 36 00 00       	call   801056d0 <strncmp>
}
80102073:	c9                   	leave  
80102074:	c3                   	ret    

80102075 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102075:	55                   	push   %ebp
80102076:	89 e5                	mov    %esp,%ebp
80102078:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010207b:	8b 45 08             	mov    0x8(%ebp),%eax
8010207e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102082:	66 83 f8 01          	cmp    $0x1,%ax
80102086:	74 0c                	je     80102094 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102088:	c7 04 24 c5 8a 10 80 	movl   $0x80108ac5,(%esp)
8010208f:	e8 a6 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102094:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010209b:	e9 88 00 00 00       	jmp    80102128 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020a7:	00 
801020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801020af:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b6:	8b 45 08             	mov    0x8(%ebp),%eax
801020b9:	89 04 24             	mov    %eax,(%esp)
801020bc:	e8 9f fc ff ff       	call   80101d60 <readi>
801020c1:	83 f8 10             	cmp    $0x10,%eax
801020c4:	74 0c                	je     801020d2 <dirlookup+0x5d>
      panic("dirlink read");
801020c6:	c7 04 24 d7 8a 10 80 	movl   $0x80108ad7,(%esp)
801020cd:	e8 68 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020d2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020d6:	66 85 c0             	test   %ax,%ax
801020d9:	75 02                	jne    801020dd <dirlookup+0x68>
      continue;
801020db:	eb 47                	jmp    80102124 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020e0:	83 c0 02             	add    $0x2,%eax
801020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801020e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801020ea:	89 04 24             	mov    %eax,(%esp)
801020ed:	e8 61 ff ff ff       	call   80102053 <namecmp>
801020f2:	85 c0                	test   %eax,%eax
801020f4:	75 2e                	jne    80102124 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
801020f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801020fa:	74 08                	je     80102104 <dirlookup+0x8f>
        *poff = off;
801020fc:	8b 45 10             	mov    0x10(%ebp),%eax
801020ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102102:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102104:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102108:	0f b7 c0             	movzwl %ax,%eax
8010210b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010210e:	8b 45 08             	mov    0x8(%ebp),%eax
80102111:	8b 00                	mov    (%eax),%eax
80102113:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102116:	89 54 24 04          	mov    %edx,0x4(%esp)
8010211a:	89 04 24             	mov    %eax,(%esp)
8010211d:	e8 2d f6 ff ff       	call   8010174f <iget>
80102122:	eb 18                	jmp    8010213c <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102124:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8b 40 18             	mov    0x18(%eax),%eax
8010212e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102131:	0f 87 69 ff ff ff    	ja     801020a0 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102137:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010213c:	c9                   	leave  
8010213d:	c3                   	ret    

8010213e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010213e:	55                   	push   %ebp
8010213f:	89 e5                	mov    %esp,%ebp
80102141:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102144:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010214b:	00 
8010214c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010214f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102153:	8b 45 08             	mov    0x8(%ebp),%eax
80102156:	89 04 24             	mov    %eax,(%esp)
80102159:	e8 17 ff ff ff       	call   80102075 <dirlookup>
8010215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102165:	74 15                	je     8010217c <dirlink+0x3e>
    iput(ip);
80102167:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010216a:	89 04 24             	mov    %eax,(%esp)
8010216d:	e8 94 f8 ff ff       	call   80101a06 <iput>
    return -1;
80102172:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102177:	e9 b7 00 00 00       	jmp    80102233 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010217c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102183:	eb 46                	jmp    801021cb <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102188:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010218f:	00 
80102190:	89 44 24 08          	mov    %eax,0x8(%esp)
80102194:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102197:	89 44 24 04          	mov    %eax,0x4(%esp)
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
8010219e:	89 04 24             	mov    %eax,(%esp)
801021a1:	e8 ba fb ff ff       	call   80101d60 <readi>
801021a6:	83 f8 10             	cmp    $0x10,%eax
801021a9:	74 0c                	je     801021b7 <dirlink+0x79>
      panic("dirlink read");
801021ab:	c7 04 24 d7 8a 10 80 	movl   $0x80108ad7,(%esp)
801021b2:	e8 83 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021b7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021bb:	66 85 c0             	test   %ax,%ax
801021be:	75 02                	jne    801021c2 <dirlink+0x84>
      break;
801021c0:	eb 16                	jmp    801021d8 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021c5:	83 c0 10             	add    $0x10,%eax
801021c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021ce:	8b 45 08             	mov    0x8(%ebp),%eax
801021d1:	8b 40 18             	mov    0x18(%eax),%eax
801021d4:	39 c2                	cmp    %eax,%edx
801021d6:	72 ad                	jb     80102185 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021d8:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021df:	00 
801021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ea:	83 c0 02             	add    $0x2,%eax
801021ed:	89 04 24             	mov    %eax,(%esp)
801021f0:	e8 31 35 00 00       	call   80105726 <strncpy>
  de.inum = inum;
801021f5:	8b 45 10             	mov    0x10(%ebp),%eax
801021f8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ff:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102206:	00 
80102207:	89 44 24 08          	mov    %eax,0x8(%esp)
8010220b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010220e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102212:	8b 45 08             	mov    0x8(%ebp),%eax
80102215:	89 04 24             	mov    %eax,(%esp)
80102218:	e8 a7 fc ff ff       	call   80101ec4 <writei>
8010221d:	83 f8 10             	cmp    $0x10,%eax
80102220:	74 0c                	je     8010222e <dirlink+0xf0>
    panic("dirlink");
80102222:	c7 04 24 e4 8a 10 80 	movl   $0x80108ae4,(%esp)
80102229:	e8 0c e3 ff ff       	call   8010053a <panic>
  
  return 0;
8010222e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102233:	c9                   	leave  
80102234:	c3                   	ret    

80102235 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102235:	55                   	push   %ebp
80102236:	89 e5                	mov    %esp,%ebp
80102238:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010223b:	eb 04                	jmp    80102241 <skipelem+0xc>
    path++;
8010223d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102241:	8b 45 08             	mov    0x8(%ebp),%eax
80102244:	0f b6 00             	movzbl (%eax),%eax
80102247:	3c 2f                	cmp    $0x2f,%al
80102249:	74 f2                	je     8010223d <skipelem+0x8>
    path++;
  if(*path == 0)
8010224b:	8b 45 08             	mov    0x8(%ebp),%eax
8010224e:	0f b6 00             	movzbl (%eax),%eax
80102251:	84 c0                	test   %al,%al
80102253:	75 0a                	jne    8010225f <skipelem+0x2a>
    return 0;
80102255:	b8 00 00 00 00       	mov    $0x0,%eax
8010225a:	e9 86 00 00 00       	jmp    801022e5 <skipelem+0xb0>
  s = path;
8010225f:	8b 45 08             	mov    0x8(%ebp),%eax
80102262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102265:	eb 04                	jmp    8010226b <skipelem+0x36>
    path++;
80102267:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010226b:	8b 45 08             	mov    0x8(%ebp),%eax
8010226e:	0f b6 00             	movzbl (%eax),%eax
80102271:	3c 2f                	cmp    $0x2f,%al
80102273:	74 0a                	je     8010227f <skipelem+0x4a>
80102275:	8b 45 08             	mov    0x8(%ebp),%eax
80102278:	0f b6 00             	movzbl (%eax),%eax
8010227b:	84 c0                	test   %al,%al
8010227d:	75 e8                	jne    80102267 <skipelem+0x32>
    path++;
  len = path - s;
8010227f:	8b 55 08             	mov    0x8(%ebp),%edx
80102282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102285:	29 c2                	sub    %eax,%edx
80102287:	89 d0                	mov    %edx,%eax
80102289:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010228c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102290:	7e 1c                	jle    801022ae <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102292:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102299:	00 
8010229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229d:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801022a4:	89 04 24             	mov    %eax,(%esp)
801022a7:	e8 81 33 00 00       	call   8010562d <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ac:	eb 2a                	jmp    801022d8 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801022bf:	89 04 24             	mov    %eax,(%esp)
801022c2:	e8 66 33 00 00       	call   8010562d <memmove>
    name[len] = 0;
801022c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801022cd:	01 d0                	add    %edx,%eax
801022cf:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022d2:	eb 04                	jmp    801022d8 <skipelem+0xa3>
    path++;
801022d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022d8:	8b 45 08             	mov    0x8(%ebp),%eax
801022db:	0f b6 00             	movzbl (%eax),%eax
801022de:	3c 2f                	cmp    $0x2f,%al
801022e0:	74 f2                	je     801022d4 <skipelem+0x9f>
    path++;
  return path;
801022e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022e5:	c9                   	leave  
801022e6:	c3                   	ret    

801022e7 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022e7:	55                   	push   %ebp
801022e8:	89 e5                	mov    %esp,%ebp
801022ea:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022ed:	8b 45 08             	mov    0x8(%ebp),%eax
801022f0:	0f b6 00             	movzbl (%eax),%eax
801022f3:	3c 2f                	cmp    $0x2f,%al
801022f5:	75 1c                	jne    80102313 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801022f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022fe:	00 
801022ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102306:	e8 44 f4 ff ff       	call   8010174f <iget>
8010230b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010230e:	e9 af 00 00 00       	jmp    801023c2 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102313:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102319:	8b 40 68             	mov    0x68(%eax),%eax
8010231c:	89 04 24             	mov    %eax,(%esp)
8010231f:	e8 fd f4 ff ff       	call   80101821 <idup>
80102324:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102327:	e9 96 00 00 00       	jmp    801023c2 <namex+0xdb>
    ilock(ip);
8010232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232f:	89 04 24             	mov    %eax,(%esp)
80102332:	e8 1c f5 ff ff       	call   80101853 <ilock>
    if(ip->type != T_DIR){
80102337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010233e:	66 83 f8 01          	cmp    $0x1,%ax
80102342:	74 15                	je     80102359 <namex+0x72>
      iunlockput(ip);
80102344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102347:	89 04 24             	mov    %eax,(%esp)
8010234a:	e8 88 f7 ff ff       	call   80101ad7 <iunlockput>
      return 0;
8010234f:	b8 00 00 00 00       	mov    $0x0,%eax
80102354:	e9 a3 00 00 00       	jmp    801023fc <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102359:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010235d:	74 1d                	je     8010237c <namex+0x95>
8010235f:	8b 45 08             	mov    0x8(%ebp),%eax
80102362:	0f b6 00             	movzbl (%eax),%eax
80102365:	84 c0                	test   %al,%al
80102367:	75 13                	jne    8010237c <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236c:	89 04 24             	mov    %eax,(%esp)
8010236f:	e8 2d f6 ff ff       	call   801019a1 <iunlock>
      return ip;
80102374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102377:	e9 80 00 00 00       	jmp    801023fc <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010237c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102383:	00 
80102384:	8b 45 10             	mov    0x10(%ebp),%eax
80102387:	89 44 24 04          	mov    %eax,0x4(%esp)
8010238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238e:	89 04 24             	mov    %eax,(%esp)
80102391:	e8 df fc ff ff       	call   80102075 <dirlookup>
80102396:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010239d:	75 12                	jne    801023b1 <namex+0xca>
      iunlockput(ip);
8010239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a2:	89 04 24             	mov    %eax,(%esp)
801023a5:	e8 2d f7 ff ff       	call   80101ad7 <iunlockput>
      return 0;
801023aa:	b8 00 00 00 00       	mov    $0x0,%eax
801023af:	eb 4b                	jmp    801023fc <namex+0x115>
    }
    iunlockput(ip);
801023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b4:	89 04 24             	mov    %eax,(%esp)
801023b7:	e8 1b f7 ff ff       	call   80101ad7 <iunlockput>
    ip = next;
801023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023c2:	8b 45 10             	mov    0x10(%ebp),%eax
801023c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
801023cc:	89 04 24             	mov    %eax,(%esp)
801023cf:	e8 61 fe ff ff       	call   80102235 <skipelem>
801023d4:	89 45 08             	mov    %eax,0x8(%ebp)
801023d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023db:	0f 85 4b ff ff ff    	jne    8010232c <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023e5:	74 12                	je     801023f9 <namex+0x112>
    iput(ip);
801023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ea:	89 04 24             	mov    %eax,(%esp)
801023ed:	e8 14 f6 ff ff       	call   80101a06 <iput>
    return 0;
801023f2:	b8 00 00 00 00       	mov    $0x0,%eax
801023f7:	eb 03                	jmp    801023fc <namex+0x115>
  }
  return ip;
801023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023fc:	c9                   	leave  
801023fd:	c3                   	ret    

801023fe <namei>:

struct inode*
namei(char *path)
{
801023fe:	55                   	push   %ebp
801023ff:	89 e5                	mov    %esp,%ebp
80102401:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102404:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102407:	89 44 24 08          	mov    %eax,0x8(%esp)
8010240b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102412:	00 
80102413:	8b 45 08             	mov    0x8(%ebp),%eax
80102416:	89 04 24             	mov    %eax,(%esp)
80102419:	e8 c9 fe ff ff       	call   801022e7 <namex>
}
8010241e:	c9                   	leave  
8010241f:	c3                   	ret    

80102420 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102426:	8b 45 0c             	mov    0xc(%ebp),%eax
80102429:	89 44 24 08          	mov    %eax,0x8(%esp)
8010242d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102434:	00 
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	89 04 24             	mov    %eax,(%esp)
8010243b:	e8 a7 fe ff ff       	call   801022e7 <namex>
}
80102440:	c9                   	leave  
80102441:	c3                   	ret    

80102442 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102442:	55                   	push   %ebp
80102443:	89 e5                	mov    %esp,%ebp
80102445:	83 ec 14             	sub    $0x14,%esp
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
8010244b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010244f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102453:	89 c2                	mov    %eax,%edx
80102455:	ec                   	in     (%dx),%al
80102456:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102459:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010245d:	c9                   	leave  
8010245e:	c3                   	ret    

8010245f <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010245f:	55                   	push   %ebp
80102460:	89 e5                	mov    %esp,%ebp
80102462:	57                   	push   %edi
80102463:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102464:	8b 55 08             	mov    0x8(%ebp),%edx
80102467:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010246a:	8b 45 10             	mov    0x10(%ebp),%eax
8010246d:	89 cb                	mov    %ecx,%ebx
8010246f:	89 df                	mov    %ebx,%edi
80102471:	89 c1                	mov    %eax,%ecx
80102473:	fc                   	cld    
80102474:	f3 6d                	rep insl (%dx),%es:(%edi)
80102476:	89 c8                	mov    %ecx,%eax
80102478:	89 fb                	mov    %edi,%ebx
8010247a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010247d:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102480:	5b                   	pop    %ebx
80102481:	5f                   	pop    %edi
80102482:	5d                   	pop    %ebp
80102483:	c3                   	ret    

80102484 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	83 ec 08             	sub    $0x8,%esp
8010248a:	8b 55 08             	mov    0x8(%ebp),%edx
8010248d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102490:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102494:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102497:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010249b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010249f:	ee                   	out    %al,(%dx)
}
801024a0:	c9                   	leave  
801024a1:	c3                   	ret    

801024a2 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024a2:	55                   	push   %ebp
801024a3:	89 e5                	mov    %esp,%ebp
801024a5:	56                   	push   %esi
801024a6:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024a7:	8b 55 08             	mov    0x8(%ebp),%edx
801024aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024ad:	8b 45 10             	mov    0x10(%ebp),%eax
801024b0:	89 cb                	mov    %ecx,%ebx
801024b2:	89 de                	mov    %ebx,%esi
801024b4:	89 c1                	mov    %eax,%ecx
801024b6:	fc                   	cld    
801024b7:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024b9:	89 c8                	mov    %ecx,%eax
801024bb:	89 f3                	mov    %esi,%ebx
801024bd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024c0:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024c3:	5b                   	pop    %ebx
801024c4:	5e                   	pop    %esi
801024c5:	5d                   	pop    %ebp
801024c6:	c3                   	ret    

801024c7 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024c7:	55                   	push   %ebp
801024c8:	89 e5                	mov    %esp,%ebp
801024ca:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024cd:	90                   	nop
801024ce:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024d5:	e8 68 ff ff ff       	call   80102442 <inb>
801024da:	0f b6 c0             	movzbl %al,%eax
801024dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024e3:	25 c0 00 00 00       	and    $0xc0,%eax
801024e8:	83 f8 40             	cmp    $0x40,%eax
801024eb:	75 e1                	jne    801024ce <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024f1:	74 11                	je     80102504 <idewait+0x3d>
801024f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024f6:	83 e0 21             	and    $0x21,%eax
801024f9:	85 c0                	test   %eax,%eax
801024fb:	74 07                	je     80102504 <idewait+0x3d>
    return -1;
801024fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102502:	eb 05                	jmp    80102509 <idewait+0x42>
  return 0;
80102504:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102509:	c9                   	leave  
8010250a:	c3                   	ret    

8010250b <ideinit>:

void
ideinit(void)
{
8010250b:	55                   	push   %ebp
8010250c:	89 e5                	mov    %esp,%ebp
8010250e:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102511:	c7 44 24 04 ec 8a 10 	movl   $0x80108aec,0x4(%esp)
80102518:	80 
80102519:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102520:	e8 c4 2d 00 00       	call   801052e9 <initlock>
  picenable(IRQ_IDE);
80102525:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010252c:	e8 0f 16 00 00       	call   80103b40 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102531:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80102536:	83 e8 01             	sub    $0x1,%eax
80102539:	89 44 24 04          	mov    %eax,0x4(%esp)
8010253d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102544:	e8 0c 04 00 00       	call   80102955 <ioapicenable>
  idewait(0);
80102549:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102550:	e8 72 ff ff ff       	call   801024c7 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102555:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010255c:	00 
8010255d:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102564:	e8 1b ff ff ff       	call   80102484 <outb>
  for(i=0; i<1000; i++){
80102569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102570:	eb 20                	jmp    80102592 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102572:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102579:	e8 c4 fe ff ff       	call   80102442 <inb>
8010257e:	84 c0                	test   %al,%al
80102580:	74 0c                	je     8010258e <ideinit+0x83>
      havedisk1 = 1;
80102582:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102589:	00 00 00 
      break;
8010258c:	eb 0d                	jmp    8010259b <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010258e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102592:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102599:	7e d7                	jle    80102572 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010259b:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025a2:	00 
801025a3:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025aa:	e8 d5 fe ff ff       	call   80102484 <outb>
}
801025af:	c9                   	leave  
801025b0:	c3                   	ret    

801025b1 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025b1:	55                   	push   %ebp
801025b2:	89 e5                	mov    %esp,%ebp
801025b4:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025bb:	75 0c                	jne    801025c9 <idestart+0x18>
    panic("idestart");
801025bd:	c7 04 24 f0 8a 10 80 	movl   $0x80108af0,(%esp)
801025c4:	e8 71 df ff ff       	call   8010053a <panic>

  idewait(0);
801025c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025d0:	e8 f2 fe ff ff       	call   801024c7 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025dc:	00 
801025dd:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025e4:	e8 9b fe ff ff       	call   80102484 <outb>
  outb(0x1f2, 1);  // number of sectors
801025e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025f0:	00 
801025f1:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801025f8:	e8 87 fe ff ff       	call   80102484 <outb>
  outb(0x1f3, b->sector & 0xff);
801025fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102600:	8b 40 08             	mov    0x8(%eax),%eax
80102603:	0f b6 c0             	movzbl %al,%eax
80102606:	89 44 24 04          	mov    %eax,0x4(%esp)
8010260a:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102611:	e8 6e fe ff ff       	call   80102484 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102616:	8b 45 08             	mov    0x8(%ebp),%eax
80102619:	8b 40 08             	mov    0x8(%eax),%eax
8010261c:	c1 e8 08             	shr    $0x8,%eax
8010261f:	0f b6 c0             	movzbl %al,%eax
80102622:	89 44 24 04          	mov    %eax,0x4(%esp)
80102626:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010262d:	e8 52 fe ff ff       	call   80102484 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102632:	8b 45 08             	mov    0x8(%ebp),%eax
80102635:	8b 40 08             	mov    0x8(%eax),%eax
80102638:	c1 e8 10             	shr    $0x10,%eax
8010263b:	0f b6 c0             	movzbl %al,%eax
8010263e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102642:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102649:	e8 36 fe ff ff       	call   80102484 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010264e:	8b 45 08             	mov    0x8(%ebp),%eax
80102651:	8b 40 04             	mov    0x4(%eax),%eax
80102654:	83 e0 01             	and    $0x1,%eax
80102657:	c1 e0 04             	shl    $0x4,%eax
8010265a:	89 c2                	mov    %eax,%edx
8010265c:	8b 45 08             	mov    0x8(%ebp),%eax
8010265f:	8b 40 08             	mov    0x8(%eax),%eax
80102662:	c1 e8 18             	shr    $0x18,%eax
80102665:	83 e0 0f             	and    $0xf,%eax
80102668:	09 d0                	or     %edx,%eax
8010266a:	83 c8 e0             	or     $0xffffffe0,%eax
8010266d:	0f b6 c0             	movzbl %al,%eax
80102670:	89 44 24 04          	mov    %eax,0x4(%esp)
80102674:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010267b:	e8 04 fe ff ff       	call   80102484 <outb>
  if(b->flags & B_DIRTY){
80102680:	8b 45 08             	mov    0x8(%ebp),%eax
80102683:	8b 00                	mov    (%eax),%eax
80102685:	83 e0 04             	and    $0x4,%eax
80102688:	85 c0                	test   %eax,%eax
8010268a:	74 34                	je     801026c0 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
8010268c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102693:	00 
80102694:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010269b:	e8 e4 fd ff ff       	call   80102484 <outb>
    outsl(0x1f0, b->data, 512/4);
801026a0:	8b 45 08             	mov    0x8(%ebp),%eax
801026a3:	83 c0 18             	add    $0x18,%eax
801026a6:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026ad:	00 
801026ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801026b2:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026b9:	e8 e4 fd ff ff       	call   801024a2 <outsl>
801026be:	eb 14                	jmp    801026d4 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026c0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026c7:	00 
801026c8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026cf:	e8 b0 fd ff ff       	call   80102484 <outb>
  }
}
801026d4:	c9                   	leave  
801026d5:	c3                   	ret    

801026d6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026d6:	55                   	push   %ebp
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026dc:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026e3:	e8 22 2c 00 00       	call   8010530a <acquire>
  if((b = idequeue) == 0){
801026e8:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801026ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026f4:	75 11                	jne    80102707 <ideintr+0x31>
    release(&idelock);
801026f6:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026fd:	e8 6a 2c 00 00       	call   8010536c <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102702:	e9 90 00 00 00       	jmp    80102797 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010270a:	8b 40 14             	mov    0x14(%eax),%eax
8010270d:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102715:	8b 00                	mov    (%eax),%eax
80102717:	83 e0 04             	and    $0x4,%eax
8010271a:	85 c0                	test   %eax,%eax
8010271c:	75 2e                	jne    8010274c <ideintr+0x76>
8010271e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102725:	e8 9d fd ff ff       	call   801024c7 <idewait>
8010272a:	85 c0                	test   %eax,%eax
8010272c:	78 1e                	js     8010274c <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102731:	83 c0 18             	add    $0x18,%eax
80102734:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010273b:	00 
8010273c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102740:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102747:	e8 13 fd ff ff       	call   8010245f <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274f:	8b 00                	mov    (%eax),%eax
80102751:	83 c8 02             	or     $0x2,%eax
80102754:	89 c2                	mov    %eax,%edx
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102759:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275e:	8b 00                	mov    (%eax),%eax
80102760:	83 e0 fb             	and    $0xfffffffb,%eax
80102763:	89 c2                	mov    %eax,%edx
80102765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102768:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276d:	89 04 24             	mov    %eax,(%esp)
80102770:	e8 1c 26 00 00       	call   80104d91 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102775:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010277a:	85 c0                	test   %eax,%eax
8010277c:	74 0d                	je     8010278b <ideintr+0xb5>
    idestart(idequeue);
8010277e:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102783:	89 04 24             	mov    %eax,(%esp)
80102786:	e8 26 fe ff ff       	call   801025b1 <idestart>

  release(&idelock);
8010278b:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102792:	e8 d5 2b 00 00       	call   8010536c <release>
}
80102797:	c9                   	leave  
80102798:	c3                   	ret    

80102799 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102799:	55                   	push   %ebp
8010279a:	89 e5                	mov    %esp,%ebp
8010279c:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010279f:	8b 45 08             	mov    0x8(%ebp),%eax
801027a2:	8b 00                	mov    (%eax),%eax
801027a4:	83 e0 01             	and    $0x1,%eax
801027a7:	85 c0                	test   %eax,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x1e>
    panic("iderw: buf not busy");
801027ab:	c7 04 24 f9 8a 10 80 	movl   $0x80108af9,(%esp)
801027b2:	e8 83 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 00                	mov    (%eax),%eax
801027bc:	83 e0 06             	and    $0x6,%eax
801027bf:	83 f8 02             	cmp    $0x2,%eax
801027c2:	75 0c                	jne    801027d0 <iderw+0x37>
    panic("iderw: nothing to do");
801027c4:	c7 04 24 0d 8b 10 80 	movl   $0x80108b0d,(%esp)
801027cb:	e8 6a dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027d0:	8b 45 08             	mov    0x8(%ebp),%eax
801027d3:	8b 40 04             	mov    0x4(%eax),%eax
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 15                	je     801027ef <iderw+0x56>
801027da:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801027df:	85 c0                	test   %eax,%eax
801027e1:	75 0c                	jne    801027ef <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027e3:	c7 04 24 22 8b 10 80 	movl   $0x80108b22,(%esp)
801027ea:	e8 4b dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027ef:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027f6:	e8 0f 2b 00 00       	call   8010530a <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102805:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
8010280c:	eb 0b                	jmp    80102819 <iderw+0x80>
8010280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102811:	8b 00                	mov    (%eax),%eax
80102813:	83 c0 14             	add    $0x14,%eax
80102816:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010281c:	8b 00                	mov    (%eax),%eax
8010281e:	85 c0                	test   %eax,%eax
80102820:	75 ec                	jne    8010280e <iderw+0x75>
    ;
  *pp = b;
80102822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102825:	8b 55 08             	mov    0x8(%ebp),%edx
80102828:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010282a:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010282f:	3b 45 08             	cmp    0x8(%ebp),%eax
80102832:	75 0d                	jne    80102841 <iderw+0xa8>
    idestart(b);
80102834:	8b 45 08             	mov    0x8(%ebp),%eax
80102837:	89 04 24             	mov    %eax,(%esp)
8010283a:	e8 72 fd ff ff       	call   801025b1 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010283f:	eb 15                	jmp    80102856 <iderw+0xbd>
80102841:	eb 13                	jmp    80102856 <iderw+0xbd>
    sleep(b, &idelock);
80102843:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
8010284a:	80 
8010284b:	8b 45 08             	mov    0x8(%ebp),%eax
8010284e:	89 04 24             	mov    %eax,(%esp)
80102851:	e8 f7 23 00 00       	call   80104c4d <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102856:	8b 45 08             	mov    0x8(%ebp),%eax
80102859:	8b 00                	mov    (%eax),%eax
8010285b:	83 e0 06             	and    $0x6,%eax
8010285e:	83 f8 02             	cmp    $0x2,%eax
80102861:	75 e0                	jne    80102843 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102863:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010286a:	e8 fd 2a 00 00       	call   8010536c <release>
}
8010286f:	c9                   	leave  
80102870:	c3                   	ret    

80102871 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102871:	55                   	push   %ebp
80102872:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102874:	a1 54 08 11 80       	mov    0x80110854,%eax
80102879:	8b 55 08             	mov    0x8(%ebp),%edx
8010287c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010287e:	a1 54 08 11 80       	mov    0x80110854,%eax
80102883:	8b 40 10             	mov    0x10(%eax),%eax
}
80102886:	5d                   	pop    %ebp
80102887:	c3                   	ret    

80102888 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288b:	a1 54 08 11 80       	mov    0x80110854,%eax
80102890:	8b 55 08             	mov    0x8(%ebp),%edx
80102893:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102895:	a1 54 08 11 80       	mov    0x80110854,%eax
8010289a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010289d:	89 50 10             	mov    %edx,0x10(%eax)
}
801028a0:	5d                   	pop    %ebp
801028a1:	c3                   	ret    

801028a2 <ioapicinit>:

void
ioapicinit(void)
{
801028a2:	55                   	push   %ebp
801028a3:	89 e5                	mov    %esp,%ebp
801028a5:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028a8:	a1 24 09 11 80       	mov    0x80110924,%eax
801028ad:	85 c0                	test   %eax,%eax
801028af:	75 05                	jne    801028b6 <ioapicinit+0x14>
    return;
801028b1:	e9 9d 00 00 00       	jmp    80102953 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028b6:	c7 05 54 08 11 80 00 	movl   $0xfec00000,0x80110854
801028bd:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028c7:	e8 a5 ff ff ff       	call   80102871 <ioapicread>
801028cc:	c1 e8 10             	shr    $0x10,%eax
801028cf:	25 ff 00 00 00       	and    $0xff,%eax
801028d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028de:	e8 8e ff ff ff       	call   80102871 <ioapicread>
801028e3:	c1 e8 18             	shr    $0x18,%eax
801028e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028e9:	0f b6 05 20 09 11 80 	movzbl 0x80110920,%eax
801028f0:	0f b6 c0             	movzbl %al,%eax
801028f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028f6:	74 0c                	je     80102904 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028f8:	c7 04 24 40 8b 10 80 	movl   $0x80108b40,(%esp)
801028ff:	e8 9c da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102904:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010290b:	eb 3e                	jmp    8010294b <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	83 c0 20             	add    $0x20,%eax
80102913:	0d 00 00 01 00       	or     $0x10000,%eax
80102918:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010291b:	83 c2 08             	add    $0x8,%edx
8010291e:	01 d2                	add    %edx,%edx
80102920:	89 44 24 04          	mov    %eax,0x4(%esp)
80102924:	89 14 24             	mov    %edx,(%esp)
80102927:	e8 5c ff ff ff       	call   80102888 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292f:	83 c0 08             	add    $0x8,%eax
80102932:	01 c0                	add    %eax,%eax
80102934:	83 c0 01             	add    $0x1,%eax
80102937:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010293e:	00 
8010293f:	89 04 24             	mov    %eax,(%esp)
80102942:	e8 41 ff ff ff       	call   80102888 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102947:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102951:	7e ba                	jle    8010290d <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102953:	c9                   	leave  
80102954:	c3                   	ret    

80102955 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102955:	55                   	push   %ebp
80102956:	89 e5                	mov    %esp,%ebp
80102958:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010295b:	a1 24 09 11 80       	mov    0x80110924,%eax
80102960:	85 c0                	test   %eax,%eax
80102962:	75 02                	jne    80102966 <ioapicenable+0x11>
    return;
80102964:	eb 37                	jmp    8010299d <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102966:	8b 45 08             	mov    0x8(%ebp),%eax
80102969:	83 c0 20             	add    $0x20,%eax
8010296c:	8b 55 08             	mov    0x8(%ebp),%edx
8010296f:	83 c2 08             	add    $0x8,%edx
80102972:	01 d2                	add    %edx,%edx
80102974:	89 44 24 04          	mov    %eax,0x4(%esp)
80102978:	89 14 24             	mov    %edx,(%esp)
8010297b:	e8 08 ff ff ff       	call   80102888 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102980:	8b 45 0c             	mov    0xc(%ebp),%eax
80102983:	c1 e0 18             	shl    $0x18,%eax
80102986:	8b 55 08             	mov    0x8(%ebp),%edx
80102989:	83 c2 08             	add    $0x8,%edx
8010298c:	01 d2                	add    %edx,%edx
8010298e:	83 c2 01             	add    $0x1,%edx
80102991:	89 44 24 04          	mov    %eax,0x4(%esp)
80102995:	89 14 24             	mov    %edx,(%esp)
80102998:	e8 eb fe ff ff       	call   80102888 <ioapicwrite>
}
8010299d:	c9                   	leave  
8010299e:	c3                   	ret    

8010299f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010299f:	55                   	push   %ebp
801029a0:	89 e5                	mov    %esp,%ebp
801029a2:	8b 45 08             	mov    0x8(%ebp),%eax
801029a5:	05 00 00 00 80       	add    $0x80000000,%eax
801029aa:	5d                   	pop    %ebp
801029ab:	c3                   	ret    

801029ac <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029ac:	55                   	push   %ebp
801029ad:	89 e5                	mov    %esp,%ebp
801029af:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029b2:	c7 44 24 04 72 8b 10 	movl   $0x80108b72,0x4(%esp)
801029b9:	80 
801029ba:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
801029c1:	e8 23 29 00 00       	call   801052e9 <initlock>
  kmem.use_lock = 0;
801029c6:	c7 05 94 08 11 80 00 	movl   $0x0,0x80110894
801029cd:	00 00 00 
  freerange(vstart, vend);
801029d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d7:	8b 45 08             	mov    0x8(%ebp),%eax
801029da:	89 04 24             	mov    %eax,(%esp)
801029dd:	e8 26 00 00 00       	call   80102a08 <freerange>
}
801029e2:	c9                   	leave  
801029e3:	c3                   	ret    

801029e4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8b 45 08             	mov    0x8(%ebp),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 0c 00 00 00       	call   80102a08 <freerange>
  kmem.use_lock = 1;
801029fc:	c7 05 94 08 11 80 01 	movl   $0x1,0x80110894
80102a03:	00 00 00 
}
80102a06:	c9                   	leave  
80102a07:	c3                   	ret    

80102a08 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a08:	55                   	push   %ebp
80102a09:	89 e5                	mov    %esp,%ebp
80102a0b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a11:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a1e:	eb 12                	jmp    80102a32 <freerange+0x2a>
    kfree(p);
80102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a23:	89 04 24             	mov    %eax,(%esp)
80102a26:	e8 16 00 00 00       	call   80102a41 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a35:	05 00 10 00 00       	add    $0x1000,%eax
80102a3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a3d:	76 e1                	jbe    80102a20 <freerange+0x18>
    kfree(p);
}
80102a3f:	c9                   	leave  
80102a40:	c3                   	ret    

80102a41 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a41:	55                   	push   %ebp
80102a42:	89 e5                	mov    %esp,%ebp
80102a44:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a47:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4a:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a4f:	85 c0                	test   %eax,%eax
80102a51:	75 1b                	jne    80102a6e <kfree+0x2d>
80102a53:	81 7d 08 1c 39 11 80 	cmpl   $0x8011391c,0x8(%ebp)
80102a5a:	72 12                	jb     80102a6e <kfree+0x2d>
80102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5f:	89 04 24             	mov    %eax,(%esp)
80102a62:	e8 38 ff ff ff       	call   8010299f <v2p>
80102a67:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a6c:	76 0c                	jbe    80102a7a <kfree+0x39>
    panic("kfree");
80102a6e:	c7 04 24 77 8b 10 80 	movl   $0x80108b77,(%esp)
80102a75:	e8 c0 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a7a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a81:	00 
80102a82:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a89:	00 
80102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8d:	89 04 24             	mov    %eax,(%esp)
80102a90:	e8 c9 2a 00 00       	call   8010555e <memset>

  if(kmem.use_lock)
80102a95:	a1 94 08 11 80       	mov    0x80110894,%eax
80102a9a:	85 c0                	test   %eax,%eax
80102a9c:	74 0c                	je     80102aaa <kfree+0x69>
    acquire(&kmem.lock);
80102a9e:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102aa5:	e8 60 28 00 00       	call   8010530a <acquire>
  r = (struct run*)v;
80102aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80102aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ab0:	8b 15 98 08 11 80    	mov    0x80110898,%edx
80102ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab9:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102abe:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102ac3:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 0c                	je     80102ad8 <kfree+0x97>
    release(&kmem.lock);
80102acc:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102ad3:	e8 94 28 00 00       	call   8010536c <release>
}
80102ad8:	c9                   	leave  
80102ad9:	c3                   	ret    

80102ada <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102ae0:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	74 0c                	je     80102af5 <kalloc+0x1b>
    acquire(&kmem.lock);
80102ae9:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102af0:	e8 15 28 00 00       	call   8010530a <acquire>
  r = kmem.freelist;
80102af5:	a1 98 08 11 80       	mov    0x80110898,%eax
80102afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b01:	74 0a                	je     80102b0d <kalloc+0x33>
    kmem.freelist = r->next;
80102b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b06:	8b 00                	mov    (%eax),%eax
80102b08:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102b0d:	a1 94 08 11 80       	mov    0x80110894,%eax
80102b12:	85 c0                	test   %eax,%eax
80102b14:	74 0c                	je     80102b22 <kalloc+0x48>
    release(&kmem.lock);
80102b16:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b1d:	e8 4a 28 00 00       	call   8010536c <release>
  return (char*)r;
80102b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b25:	c9                   	leave  
80102b26:	c3                   	ret    

80102b27 <kalloc2>:
////////////////////////////////////////////////////////
void*
kalloc2(void)
{
80102b27:	55                   	push   %ebp
80102b28:	89 e5                	mov    %esp,%ebp
80102b2a:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b2d:	a1 94 08 11 80       	mov    0x80110894,%eax
80102b32:	85 c0                	test   %eax,%eax
80102b34:	74 0c                	je     80102b42 <kalloc2+0x1b>
    acquire(&kmem.lock);
80102b36:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b3d:	e8 c8 27 00 00       	call   8010530a <acquire>
  r = kmem.freelist;
80102b42:	a1 98 08 11 80       	mov    0x80110898,%eax
80102b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b4e:	74 0a                	je     80102b5a <kalloc2+0x33>
    kmem.freelist = r->next;
80102b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b53:	8b 00                	mov    (%eax),%eax
80102b55:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102b5a:	a1 94 08 11 80       	mov    0x80110894,%eax
80102b5f:	85 c0                	test   %eax,%eax
80102b61:	74 0c                	je     80102b6f <kalloc2+0x48>
    release(&kmem.lock);
80102b63:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b6a:	e8 fd 27 00 00       	call   8010536c <release>
  return (char*)r;
80102b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b72:	c9                   	leave  
80102b73:	c3                   	ret    

80102b74 <kfree2>:

void
kfree2(void *v)
{
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || (char*)v < end || v2p(v) >= PHYSTOP)
80102b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7d:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	75 1b                	jne    80102ba1 <kfree2+0x2d>
80102b86:	81 7d 08 1c 39 11 80 	cmpl   $0x8011391c,0x8(%ebp)
80102b8d:	72 12                	jb     80102ba1 <kfree2+0x2d>
80102b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b92:	89 04 24             	mov    %eax,(%esp)
80102b95:	e8 05 fe ff ff       	call   8010299f <v2p>
80102b9a:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b9f:	76 0c                	jbe    80102bad <kfree2+0x39>
    panic("kfree");
80102ba1:	c7 04 24 77 8b 10 80 	movl   $0x80108b77,(%esp)
80102ba8:	e8 8d d9 ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102bb4:	00 
80102bb5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102bbc:	00 
80102bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc0:	89 04 24             	mov    %eax,(%esp)
80102bc3:	e8 96 29 00 00       	call   8010555e <memset>

  if(kmem.use_lock)
80102bc8:	a1 94 08 11 80       	mov    0x80110894,%eax
80102bcd:	85 c0                	test   %eax,%eax
80102bcf:	74 0c                	je     80102bdd <kfree2+0x69>
    acquire(&kmem.lock);
80102bd1:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102bd8:	e8 2d 27 00 00       	call   8010530a <acquire>
  r = (struct run*)v;
80102bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80102be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102be3:	8b 15 98 08 11 80    	mov    0x80110898,%edx
80102be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bec:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf1:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102bf6:	a1 94 08 11 80       	mov    0x80110894,%eax
80102bfb:	85 c0                	test   %eax,%eax
80102bfd:	74 0c                	je     80102c0b <kfree2+0x97>
    release(&kmem.lock);
80102bff:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102c06:	e8 61 27 00 00       	call   8010536c <release>
80102c0b:	c9                   	leave  
80102c0c:	c3                   	ret    

80102c0d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c0d:	55                   	push   %ebp
80102c0e:	89 e5                	mov    %esp,%ebp
80102c10:	83 ec 14             	sub    $0x14,%esp
80102c13:	8b 45 08             	mov    0x8(%ebp),%eax
80102c16:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c1e:	89 c2                	mov    %eax,%edx
80102c20:	ec                   	in     (%dx),%al
80102c21:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c24:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c28:	c9                   	leave  
80102c29:	c3                   	ret    

80102c2a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c2a:	55                   	push   %ebp
80102c2b:	89 e5                	mov    %esp,%ebp
80102c2d:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c30:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c37:	e8 d1 ff ff ff       	call   80102c0d <inb>
80102c3c:	0f b6 c0             	movzbl %al,%eax
80102c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c45:	83 e0 01             	and    $0x1,%eax
80102c48:	85 c0                	test   %eax,%eax
80102c4a:	75 0a                	jne    80102c56 <kbdgetc+0x2c>
    return -1;
80102c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c51:	e9 25 01 00 00       	jmp    80102d7b <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c56:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c5d:	e8 ab ff ff ff       	call   80102c0d <inb>
80102c62:	0f b6 c0             	movzbl %al,%eax
80102c65:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c68:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c6f:	75 17                	jne    80102c88 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c71:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c76:	83 c8 40             	or     $0x40,%eax
80102c79:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c7e:	b8 00 00 00 00       	mov    $0x0,%eax
80102c83:	e9 f3 00 00 00       	jmp    80102d7b <kbdgetc+0x151>
  } else if(data & 0x80){
80102c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c8b:	25 80 00 00 00       	and    $0x80,%eax
80102c90:	85 c0                	test   %eax,%eax
80102c92:	74 45                	je     80102cd9 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c94:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c99:	83 e0 40             	and    $0x40,%eax
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	75 08                	jne    80102ca8 <kbdgetc+0x7e>
80102ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca3:	83 e0 7f             	and    $0x7f,%eax
80102ca6:	eb 03                	jmp    80102cab <kbdgetc+0x81>
80102ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb1:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102cb6:	0f b6 00             	movzbl (%eax),%eax
80102cb9:	83 c8 40             	or     $0x40,%eax
80102cbc:	0f b6 c0             	movzbl %al,%eax
80102cbf:	f7 d0                	not    %eax
80102cc1:	89 c2                	mov    %eax,%edx
80102cc3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cc8:	21 d0                	and    %edx,%eax
80102cca:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ccf:	b8 00 00 00 00       	mov    $0x0,%eax
80102cd4:	e9 a2 00 00 00       	jmp    80102d7b <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102cd9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cde:	83 e0 40             	and    $0x40,%eax
80102ce1:	85 c0                	test   %eax,%eax
80102ce3:	74 14                	je     80102cf9 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ce5:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cec:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cf1:	83 e0 bf             	and    $0xffffffbf,%eax
80102cf4:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfc:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d01:	0f b6 00             	movzbl (%eax),%eax
80102d04:	0f b6 d0             	movzbl %al,%edx
80102d07:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d0c:	09 d0                	or     %edx,%eax
80102d0e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d16:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d1b:	0f b6 00             	movzbl (%eax),%eax
80102d1e:	0f b6 d0             	movzbl %al,%edx
80102d21:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d26:	31 d0                	xor    %edx,%eax
80102d28:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d2d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d32:	83 e0 03             	and    $0x3,%eax
80102d35:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d3f:	01 d0                	add    %edx,%eax
80102d41:	0f b6 00             	movzbl (%eax),%eax
80102d44:	0f b6 c0             	movzbl %al,%eax
80102d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d4a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d4f:	83 e0 08             	and    $0x8,%eax
80102d52:	85 c0                	test   %eax,%eax
80102d54:	74 22                	je     80102d78 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d56:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d5a:	76 0c                	jbe    80102d68 <kbdgetc+0x13e>
80102d5c:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d60:	77 06                	ja     80102d68 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d62:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d66:	eb 10                	jmp    80102d78 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d68:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d6c:	76 0a                	jbe    80102d78 <kbdgetc+0x14e>
80102d6e:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d72:	77 04                	ja     80102d78 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d74:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d7b:	c9                   	leave  
80102d7c:	c3                   	ret    

80102d7d <kbdintr>:

void
kbdintr(void)
{
80102d7d:	55                   	push   %ebp
80102d7e:	89 e5                	mov    %esp,%ebp
80102d80:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d83:	c7 04 24 2a 2c 10 80 	movl   $0x80102c2a,(%esp)
80102d8a:	e8 1e da ff ff       	call   801007ad <consoleintr>
}
80102d8f:	c9                   	leave  
80102d90:	c3                   	ret    

80102d91 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d91:	55                   	push   %ebp
80102d92:	89 e5                	mov    %esp,%ebp
80102d94:	83 ec 08             	sub    $0x8,%esp
80102d97:	8b 55 08             	mov    0x8(%ebp),%edx
80102d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d9d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102da1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102da8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dac:	ee                   	out    %al,(%dx)
}
80102dad:	c9                   	leave  
80102dae:	c3                   	ret    

80102daf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102daf:	55                   	push   %ebp
80102db0:	89 e5                	mov    %esp,%ebp
80102db2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102db5:	9c                   	pushf  
80102db6:	58                   	pop    %eax
80102db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102dbd:	c9                   	leave  
80102dbe:	c3                   	ret    

80102dbf <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102dbf:	55                   	push   %ebp
80102dc0:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dc2:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102dc7:	8b 55 08             	mov    0x8(%ebp),%edx
80102dca:	c1 e2 02             	shl    $0x2,%edx
80102dcd:	01 c2                	add    %eax,%edx
80102dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dd2:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dd4:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102dd9:	83 c0 20             	add    $0x20,%eax
80102ddc:	8b 00                	mov    (%eax),%eax
}
80102dde:	5d                   	pop    %ebp
80102ddf:	c3                   	ret    

80102de0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102de6:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102deb:	85 c0                	test   %eax,%eax
80102ded:	75 05                	jne    80102df4 <lapicinit+0x14>
    return;
80102def:	e9 43 01 00 00       	jmp    80102f37 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102df4:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dfb:	00 
80102dfc:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e03:	e8 b7 ff ff ff       	call   80102dbf <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e08:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e0f:	00 
80102e10:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e17:	e8 a3 ff ff ff       	call   80102dbf <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e1c:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e23:	00 
80102e24:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e2b:	e8 8f ff ff ff       	call   80102dbf <lapicw>
  lapicw(TICR, 10000000); 
80102e30:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e37:	00 
80102e38:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e3f:	e8 7b ff ff ff       	call   80102dbf <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e44:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e4b:	00 
80102e4c:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e53:	e8 67 ff ff ff       	call   80102dbf <lapicw>
  lapicw(LINT1, MASKED);
80102e58:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e5f:	00 
80102e60:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e67:	e8 53 ff ff ff       	call   80102dbf <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e6c:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e71:	83 c0 30             	add    $0x30,%eax
80102e74:	8b 00                	mov    (%eax),%eax
80102e76:	c1 e8 10             	shr    $0x10,%eax
80102e79:	0f b6 c0             	movzbl %al,%eax
80102e7c:	83 f8 03             	cmp    $0x3,%eax
80102e7f:	76 14                	jbe    80102e95 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e81:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e88:	00 
80102e89:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e90:	e8 2a ff ff ff       	call   80102dbf <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e95:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e9c:	00 
80102e9d:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ea4:	e8 16 ff ff ff       	call   80102dbf <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ea9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb0:	00 
80102eb1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eb8:	e8 02 ff ff ff       	call   80102dbf <lapicw>
  lapicw(ESR, 0);
80102ebd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec4:	00 
80102ec5:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ecc:	e8 ee fe ff ff       	call   80102dbf <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ed1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ed8:	00 
80102ed9:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ee0:	e8 da fe ff ff       	call   80102dbf <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eec:	00 
80102eed:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ef4:	e8 c6 fe ff ff       	call   80102dbf <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ef9:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f00:	00 
80102f01:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f08:	e8 b2 fe ff ff       	call   80102dbf <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f0d:	90                   	nop
80102f0e:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102f13:	05 00 03 00 00       	add    $0x300,%eax
80102f18:	8b 00                	mov    (%eax),%eax
80102f1a:	25 00 10 00 00       	and    $0x1000,%eax
80102f1f:	85 c0                	test   %eax,%eax
80102f21:	75 eb                	jne    80102f0e <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f2a:	00 
80102f2b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f32:	e8 88 fe ff ff       	call   80102dbf <lapicw>
}
80102f37:	c9                   	leave  
80102f38:	c3                   	ret    

80102f39 <cpunum>:

int
cpunum(void)
{
80102f39:	55                   	push   %ebp
80102f3a:	89 e5                	mov    %esp,%ebp
80102f3c:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f3f:	e8 6b fe ff ff       	call   80102daf <readeflags>
80102f44:	25 00 02 00 00       	and    $0x200,%eax
80102f49:	85 c0                	test   %eax,%eax
80102f4b:	74 25                	je     80102f72 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102f4d:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f52:	8d 50 01             	lea    0x1(%eax),%edx
80102f55:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f5b:	85 c0                	test   %eax,%eax
80102f5d:	75 13                	jne    80102f72 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f5f:	8b 45 04             	mov    0x4(%ebp),%eax
80102f62:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f66:	c7 04 24 80 8b 10 80 	movl   $0x80108b80,(%esp)
80102f6d:	e8 2e d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f72:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102f77:	85 c0                	test   %eax,%eax
80102f79:	74 0f                	je     80102f8a <cpunum+0x51>
    return lapic[ID]>>24;
80102f7b:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102f80:	83 c0 20             	add    $0x20,%eax
80102f83:	8b 00                	mov    (%eax),%eax
80102f85:	c1 e8 18             	shr    $0x18,%eax
80102f88:	eb 05                	jmp    80102f8f <cpunum+0x56>
  return 0;
80102f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f8f:	c9                   	leave  
80102f90:	c3                   	ret    

80102f91 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f91:	55                   	push   %ebp
80102f92:	89 e5                	mov    %esp,%ebp
80102f94:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f97:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102f9c:	85 c0                	test   %eax,%eax
80102f9e:	74 14                	je     80102fb4 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102fa0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fa7:	00 
80102fa8:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102faf:	e8 0b fe ff ff       	call   80102dbf <lapicw>
}
80102fb4:	c9                   	leave  
80102fb5:	c3                   	ret    

80102fb6 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fb6:	55                   	push   %ebp
80102fb7:	89 e5                	mov    %esp,%ebp
}
80102fb9:	5d                   	pop    %ebp
80102fba:	c3                   	ret    

80102fbb <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fbb:	55                   	push   %ebp
80102fbc:	89 e5                	mov    %esp,%ebp
80102fbe:	83 ec 1c             	sub    $0x1c,%esp
80102fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80102fc4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102fc7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102fce:	00 
80102fcf:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fd6:	e8 b6 fd ff ff       	call   80102d91 <outb>
  outb(IO_RTC+1, 0x0A);
80102fdb:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fe2:	00 
80102fe3:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fea:	e8 a2 fd ff ff       	call   80102d91 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fef:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102ff9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103001:	8d 50 02             	lea    0x2(%eax),%edx
80103004:	8b 45 0c             	mov    0xc(%ebp),%eax
80103007:	c1 e8 04             	shr    $0x4,%eax
8010300a:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010300d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103011:	c1 e0 18             	shl    $0x18,%eax
80103014:	89 44 24 04          	mov    %eax,0x4(%esp)
80103018:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010301f:	e8 9b fd ff ff       	call   80102dbf <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103024:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010302b:	00 
8010302c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103033:	e8 87 fd ff ff       	call   80102dbf <lapicw>
  microdelay(200);
80103038:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010303f:	e8 72 ff ff ff       	call   80102fb6 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103044:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010304b:	00 
8010304c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103053:	e8 67 fd ff ff       	call   80102dbf <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103058:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010305f:	e8 52 ff ff ff       	call   80102fb6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010306b:	eb 40                	jmp    801030ad <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010306d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103071:	c1 e0 18             	shl    $0x18,%eax
80103074:	89 44 24 04          	mov    %eax,0x4(%esp)
80103078:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010307f:	e8 3b fd ff ff       	call   80102dbf <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103084:	8b 45 0c             	mov    0xc(%ebp),%eax
80103087:	c1 e8 0c             	shr    $0xc,%eax
8010308a:	80 cc 06             	or     $0x6,%ah
8010308d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103091:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103098:	e8 22 fd ff ff       	call   80102dbf <lapicw>
    microdelay(200);
8010309d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030a4:	e8 0d ff ff ff       	call   80102fb6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030ad:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030b1:	7e ba                	jle    8010306d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030b3:	c9                   	leave  
801030b4:	c3                   	ret    

801030b5 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
801030b5:	55                   	push   %ebp
801030b6:	89 e5                	mov    %esp,%ebp
801030b8:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801030bb:	c7 44 24 04 ac 8b 10 	movl   $0x80108bac,0x4(%esp)
801030c2:	80 
801030c3:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801030ca:	e8 1a 22 00 00       	call   801052e9 <initlock>
  readsb(ROOTDEV, &sb);
801030cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801030d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801030d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801030dd:	e8 07 e2 ff ff       	call   801012e9 <readsb>
  log.start = sb.size - sb.nlog;
801030e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
801030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030e8:	29 c2                	sub    %eax,%edx
801030ea:	89 d0                	mov    %edx,%eax
801030ec:	a3 d4 08 11 80       	mov    %eax,0x801108d4
  log.size = sb.nlog;
801030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f4:	a3 d8 08 11 80       	mov    %eax,0x801108d8
  log.dev = ROOTDEV;
801030f9:	c7 05 e0 08 11 80 01 	movl   $0x1,0x801108e0
80103100:	00 00 00 
  recover_from_log();
80103103:	e8 9a 01 00 00       	call   801032a2 <recover_from_log>
}
80103108:	c9                   	leave  
80103109:	c3                   	ret    

8010310a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010310a:	55                   	push   %ebp
8010310b:	89 e5                	mov    %esp,%ebp
8010310d:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103110:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103117:	e9 8c 00 00 00       	jmp    801031a8 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010311c:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
80103122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103125:	01 d0                	add    %edx,%eax
80103127:	83 c0 01             	add    $0x1,%eax
8010312a:	89 c2                	mov    %eax,%edx
8010312c:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103131:	89 54 24 04          	mov    %edx,0x4(%esp)
80103135:	89 04 24             	mov    %eax,(%esp)
80103138:	e8 69 d0 ff ff       	call   801001a6 <bread>
8010313d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103143:	83 c0 10             	add    $0x10,%eax
80103146:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
8010314d:	89 c2                	mov    %eax,%edx
8010314f:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103154:	89 54 24 04          	mov    %edx,0x4(%esp)
80103158:	89 04 24             	mov    %eax,(%esp)
8010315b:	e8 46 d0 ff ff       	call   801001a6 <bread>
80103160:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103163:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103166:	8d 50 18             	lea    0x18(%eax),%edx
80103169:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316c:	83 c0 18             	add    $0x18,%eax
8010316f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103176:	00 
80103177:	89 54 24 04          	mov    %edx,0x4(%esp)
8010317b:	89 04 24             	mov    %eax,(%esp)
8010317e:	e8 aa 24 00 00       	call   8010562d <memmove>
    bwrite(dbuf);  // write dst to disk
80103183:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103186:	89 04 24             	mov    %eax,(%esp)
80103189:	e8 4f d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103191:	89 04 24             	mov    %eax,(%esp)
80103194:	e8 7e d0 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103199:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010319c:	89 04 24             	mov    %eax,(%esp)
8010319f:	e8 73 d0 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031a8:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801031ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031b0:	0f 8f 66 ff ff ff    	jg     8010311c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801031b6:	c9                   	leave  
801031b7:	c3                   	ret    

801031b8 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801031b8:	55                   	push   %ebp
801031b9:	89 e5                	mov    %esp,%ebp
801031bb:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031be:	a1 d4 08 11 80       	mov    0x801108d4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	a1 e0 08 11 80       	mov    0x801108e0,%eax
801031ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801031ce:	89 04 24             	mov    %eax,(%esp)
801031d1:	e8 d0 cf ff ff       	call   801001a6 <bread>
801031d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031dc:	83 c0 18             	add    $0x18,%eax
801031df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801031e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031e5:	8b 00                	mov    (%eax),%eax
801031e7:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  for (i = 0; i < log.lh.n; i++) {
801031ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031f3:	eb 1b                	jmp    80103210 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
801031f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031fb:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801031ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103202:	83 c2 10             	add    $0x10,%edx
80103205:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010320c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103210:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103215:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103218:	7f db                	jg     801031f5 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010321a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010321d:	89 04 24             	mov    %eax,(%esp)
80103220:	e8 f2 cf ff ff       	call   80100217 <brelse>
}
80103225:	c9                   	leave  
80103226:	c3                   	ret    

80103227 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103227:	55                   	push   %ebp
80103228:	89 e5                	mov    %esp,%ebp
8010322a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010322d:	a1 d4 08 11 80       	mov    0x801108d4,%eax
80103232:	89 c2                	mov    %eax,%edx
80103234:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103239:	89 54 24 04          	mov    %edx,0x4(%esp)
8010323d:	89 04 24             	mov    %eax,(%esp)
80103240:	e8 61 cf ff ff       	call   801001a6 <bread>
80103245:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103248:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010324b:	83 c0 18             	add    $0x18,%eax
8010324e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103251:	8b 15 e4 08 11 80    	mov    0x801108e4,%edx
80103257:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010325a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010325c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103263:	eb 1b                	jmp    80103280 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103268:	83 c0 10             	add    $0x10,%eax
8010326b:	8b 0c 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%ecx
80103272:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103278:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010327c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103280:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103285:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103288:	7f db                	jg     80103265 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010328a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010328d:	89 04 24             	mov    %eax,(%esp)
80103290:	e8 48 cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103295:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103298:	89 04 24             	mov    %eax,(%esp)
8010329b:	e8 77 cf ff ff       	call   80100217 <brelse>
}
801032a0:	c9                   	leave  
801032a1:	c3                   	ret    

801032a2 <recover_from_log>:

static void
recover_from_log(void)
{
801032a2:	55                   	push   %ebp
801032a3:	89 e5                	mov    %esp,%ebp
801032a5:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801032a8:	e8 0b ff ff ff       	call   801031b8 <read_head>
  install_trans(); // if committed, copy from log to disk
801032ad:	e8 58 fe ff ff       	call   8010310a <install_trans>
  log.lh.n = 0;
801032b2:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
801032b9:	00 00 00 
  write_head(); // clear the log
801032bc:	e8 66 ff ff ff       	call   80103227 <write_head>
}
801032c1:	c9                   	leave  
801032c2:	c3                   	ret    

801032c3 <begin_trans>:

void
begin_trans(void)
{
801032c3:	55                   	push   %ebp
801032c4:	89 e5                	mov    %esp,%ebp
801032c6:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801032c9:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801032d0:	e8 35 20 00 00       	call   8010530a <acquire>
  while (log.busy) {
801032d5:	eb 14                	jmp    801032eb <begin_trans+0x28>
    sleep(&log, &log.lock);
801032d7:	c7 44 24 04 a0 08 11 	movl   $0x801108a0,0x4(%esp)
801032de:	80 
801032df:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801032e6:	e8 62 19 00 00       	call   80104c4d <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801032eb:	a1 dc 08 11 80       	mov    0x801108dc,%eax
801032f0:	85 c0                	test   %eax,%eax
801032f2:	75 e3                	jne    801032d7 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
801032f4:	c7 05 dc 08 11 80 01 	movl   $0x1,0x801108dc
801032fb:	00 00 00 
  release(&log.lock);
801032fe:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103305:	e8 62 20 00 00       	call   8010536c <release>
}
8010330a:	c9                   	leave  
8010330b:	c3                   	ret    

8010330c <commit_trans>:

void
commit_trans(void)
{
8010330c:	55                   	push   %ebp
8010330d:	89 e5                	mov    %esp,%ebp
8010330f:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103312:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103317:	85 c0                	test   %eax,%eax
80103319:	7e 19                	jle    80103334 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010331b:	e8 07 ff ff ff       	call   80103227 <write_head>
    install_trans(); // Now install writes to home locations
80103320:	e8 e5 fd ff ff       	call   8010310a <install_trans>
    log.lh.n = 0; 
80103325:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
8010332c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010332f:	e8 f3 fe ff ff       	call   80103227 <write_head>
  }
  
  acquire(&log.lock);
80103334:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010333b:	e8 ca 1f 00 00       	call   8010530a <acquire>
  log.busy = 0;
80103340:	c7 05 dc 08 11 80 00 	movl   $0x0,0x801108dc
80103347:	00 00 00 
  wakeup(&log);
8010334a:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103351:	e8 3b 1a 00 00       	call   80104d91 <wakeup>
  release(&log.lock);
80103356:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010335d:	e8 0a 20 00 00       	call   8010536c <release>
}
80103362:	c9                   	leave  
80103363:	c3                   	ret    

80103364 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010336a:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010336f:	83 f8 09             	cmp    $0x9,%eax
80103372:	7f 12                	jg     80103386 <log_write+0x22>
80103374:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103379:	8b 15 d8 08 11 80    	mov    0x801108d8,%edx
8010337f:	83 ea 01             	sub    $0x1,%edx
80103382:	39 d0                	cmp    %edx,%eax
80103384:	7c 0c                	jl     80103392 <log_write+0x2e>
    panic("too big a transaction");
80103386:	c7 04 24 b0 8b 10 80 	movl   $0x80108bb0,(%esp)
8010338d:	e8 a8 d1 ff ff       	call   8010053a <panic>
  if (!log.busy)
80103392:	a1 dc 08 11 80       	mov    0x801108dc,%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	75 0c                	jne    801033a7 <log_write+0x43>
    panic("write outside of trans");
8010339b:	c7 04 24 c6 8b 10 80 	movl   $0x80108bc6,(%esp)
801033a2:	e8 93 d1 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801033a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033ae:	eb 1f                	jmp    801033cf <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b3:	83 c0 10             	add    $0x10,%eax
801033b6:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
801033bd:	89 c2                	mov    %eax,%edx
801033bf:	8b 45 08             	mov    0x8(%ebp),%eax
801033c2:	8b 40 08             	mov    0x8(%eax),%eax
801033c5:	39 c2                	cmp    %eax,%edx
801033c7:	75 02                	jne    801033cb <log_write+0x67>
      break;
801033c9:	eb 0e                	jmp    801033d9 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801033cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033cf:	a1 e4 08 11 80       	mov    0x801108e4,%eax
801033d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033d7:	7f d7                	jg     801033b0 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
801033d9:	8b 45 08             	mov    0x8(%ebp),%eax
801033dc:	8b 40 08             	mov    0x8(%eax),%eax
801033df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e2:	83 c2 10             	add    $0x10,%edx
801033e5:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801033ec:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
801033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033f5:	01 d0                	add    %edx,%eax
801033f7:	83 c0 01             	add    $0x1,%eax
801033fa:	89 c2                	mov    %eax,%edx
801033fc:	8b 45 08             	mov    0x8(%ebp),%eax
801033ff:	8b 40 04             	mov    0x4(%eax),%eax
80103402:	89 54 24 04          	mov    %edx,0x4(%esp)
80103406:	89 04 24             	mov    %eax,(%esp)
80103409:	e8 98 cd ff ff       	call   801001a6 <bread>
8010340e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103411:	8b 45 08             	mov    0x8(%ebp),%eax
80103414:	8d 50 18             	lea    0x18(%eax),%edx
80103417:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010341a:	83 c0 18             	add    $0x18,%eax
8010341d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103424:	00 
80103425:	89 54 24 04          	mov    %edx,0x4(%esp)
80103429:	89 04 24             	mov    %eax,(%esp)
8010342c:	e8 fc 21 00 00       	call   8010562d <memmove>
  bwrite(lbuf);
80103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103434:	89 04 24             	mov    %eax,(%esp)
80103437:	e8 a1 cd ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
8010343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010343f:	89 04 24             	mov    %eax,(%esp)
80103442:	e8 d0 cd ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103447:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010344c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010344f:	75 0d                	jne    8010345e <log_write+0xfa>
    log.lh.n++;
80103451:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103456:	83 c0 01             	add    $0x1,%eax
80103459:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  b->flags |= B_DIRTY; // XXX prevent eviction
8010345e:	8b 45 08             	mov    0x8(%ebp),%eax
80103461:	8b 00                	mov    (%eax),%eax
80103463:	83 c8 04             	or     $0x4,%eax
80103466:	89 c2                	mov    %eax,%edx
80103468:	8b 45 08             	mov    0x8(%ebp),%eax
8010346b:	89 10                	mov    %edx,(%eax)
}
8010346d:	c9                   	leave  
8010346e:	c3                   	ret    

8010346f <v2p>:
8010346f:	55                   	push   %ebp
80103470:	89 e5                	mov    %esp,%ebp
80103472:	8b 45 08             	mov    0x8(%ebp),%eax
80103475:	05 00 00 00 80       	add    $0x80000000,%eax
8010347a:	5d                   	pop    %ebp
8010347b:	c3                   	ret    

8010347c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010347c:	55                   	push   %ebp
8010347d:	89 e5                	mov    %esp,%ebp
8010347f:	8b 45 08             	mov    0x8(%ebp),%eax
80103482:	05 00 00 00 80       	add    $0x80000000,%eax
80103487:	5d                   	pop    %ebp
80103488:	c3                   	ret    

80103489 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103489:	55                   	push   %ebp
8010348a:	89 e5                	mov    %esp,%ebp
8010348c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010348f:	8b 55 08             	mov    0x8(%ebp),%edx
80103492:	8b 45 0c             	mov    0xc(%ebp),%eax
80103495:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103498:	f0 87 02             	lock xchg %eax,(%edx)
8010349b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010349e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801034a1:	c9                   	leave  
801034a2:	c3                   	ret    

801034a3 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801034a3:	55                   	push   %ebp
801034a4:	89 e5                	mov    %esp,%ebp
801034a6:	83 e4 f0             	and    $0xfffffff0,%esp
801034a9:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034ac:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801034b3:	80 
801034b4:	c7 04 24 1c 39 11 80 	movl   $0x8011391c,(%esp)
801034bb:	e8 ec f4 ff ff       	call   801029ac <kinit1>
  kvmalloc();      // kernel page table
801034c0:	e8 2f 4d 00 00       	call   801081f4 <kvmalloc>
  mpinit();        // collect info about this machine
801034c5:	e8 46 04 00 00       	call   80103910 <mpinit>
  lapicinit();
801034ca:	e8 11 f9 ff ff       	call   80102de0 <lapicinit>
  seginit();       // set up segments
801034cf:	e8 b3 46 00 00       	call   80107b87 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801034d4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034da:	0f b6 00             	movzbl (%eax),%eax
801034dd:	0f b6 c0             	movzbl %al,%eax
801034e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801034e4:	c7 04 24 dd 8b 10 80 	movl   $0x80108bdd,(%esp)
801034eb:	e8 b0 ce ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
801034f0:	e8 79 06 00 00       	call   80103b6e <picinit>
  ioapicinit();    // another interrupt controller
801034f5:	e8 a8 f3 ff ff       	call   801028a2 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801034fa:	e8 82 d5 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
801034ff:	e8 d2 39 00 00       	call   80106ed6 <uartinit>
  pinit();         // process table
80103504:	e8 f1 0b 00 00       	call   801040fa <pinit>
  tvinit();        // trap vectors
80103509:	e8 7a 35 00 00       	call   80106a88 <tvinit>
  binit();         // buffer cache
8010350e:	e8 21 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103513:	e8 ea d9 ff ff       	call   80100f02 <fileinit>
  iinit();         // inode cache
80103518:	e8 7f e0 ff ff       	call   8010159c <iinit>
  ideinit();       // disk
8010351d:	e8 e9 ef ff ff       	call   8010250b <ideinit>
  if(!ismp)
80103522:	a1 24 09 11 80       	mov    0x80110924,%eax
80103527:	85 c0                	test   %eax,%eax
80103529:	75 05                	jne    80103530 <main+0x8d>
    timerinit();   // uniprocessor timer
8010352b:	e8 a3 34 00 00       	call   801069d3 <timerinit>
  startothers();   // start other processors
80103530:	e8 7f 00 00 00       	call   801035b4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103535:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010353c:	8e 
8010353d:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103544:	e8 9b f4 ff ff       	call   801029e4 <kinit2>
  userinit();      // first user process
80103549:	e8 ca 0c 00 00       	call   80104218 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010354e:	e8 1a 00 00 00       	call   8010356d <mpmain>

80103553 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103553:	55                   	push   %ebp
80103554:	89 e5                	mov    %esp,%ebp
80103556:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103559:	e8 ad 4c 00 00       	call   8010820b <switchkvm>
  seginit();
8010355e:	e8 24 46 00 00       	call   80107b87 <seginit>
  lapicinit();
80103563:	e8 78 f8 ff ff       	call   80102de0 <lapicinit>
  mpmain();
80103568:	e8 00 00 00 00       	call   8010356d <mpmain>

8010356d <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010356d:	55                   	push   %ebp
8010356e:	89 e5                	mov    %esp,%ebp
80103570:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103573:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103579:	0f b6 00             	movzbl (%eax),%eax
8010357c:	0f b6 c0             	movzbl %al,%eax
8010357f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103583:	c7 04 24 f4 8b 10 80 	movl   $0x80108bf4,(%esp)
8010358a:	e8 11 ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
8010358f:	e8 68 36 00 00       	call   80106bfc <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103594:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010359a:	05 a8 00 00 00       	add    $0xa8,%eax
8010359f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801035a6:	00 
801035a7:	89 04 24             	mov    %eax,(%esp)
801035aa:	e8 da fe ff ff       	call   80103489 <xchg>
  scheduler();     // start running processes
801035af:	e8 c5 14 00 00       	call   80104a79 <scheduler>

801035b4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	53                   	push   %ebx
801035b8:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801035bb:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801035c2:	e8 b5 fe ff ff       	call   8010347c <p2v>
801035c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035ca:	b8 8a 00 00 00       	mov    $0x8a,%eax
801035cf:	89 44 24 08          	mov    %eax,0x8(%esp)
801035d3:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
801035da:	80 
801035db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035de:	89 04 24             	mov    %eax,(%esp)
801035e1:	e8 47 20 00 00       	call   8010562d <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801035e6:	c7 45 f4 40 09 11 80 	movl   $0x80110940,-0xc(%ebp)
801035ed:	e9 85 00 00 00       	jmp    80103677 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
801035f2:	e8 42 f9 ff ff       	call   80102f39 <cpunum>
801035f7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035fd:	05 40 09 11 80       	add    $0x80110940,%eax
80103602:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103605:	75 02                	jne    80103609 <startothers+0x55>
      continue;
80103607:	eb 67                	jmp    80103670 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103609:	e8 cc f4 ff ff       	call   80102ada <kalloc>
8010360e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103614:	83 e8 04             	sub    $0x4,%eax
80103617:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010361a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103620:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103625:	83 e8 08             	sub    $0x8,%eax
80103628:	c7 00 53 35 10 80    	movl   $0x80103553,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103631:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103634:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
8010363b:	e8 2f fe ff ff       	call   8010346f <v2p>
80103640:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103645:	89 04 24             	mov    %eax,(%esp)
80103648:	e8 22 fe ff ff       	call   8010346f <v2p>
8010364d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103650:	0f b6 12             	movzbl (%edx),%edx
80103653:	0f b6 d2             	movzbl %dl,%edx
80103656:	89 44 24 04          	mov    %eax,0x4(%esp)
8010365a:	89 14 24             	mov    %edx,(%esp)
8010365d:	e8 59 f9 ff ff       	call   80102fbb <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103662:	90                   	nop
80103663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103666:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	74 f3                	je     80103663 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103670:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103677:	a1 20 0f 11 80       	mov    0x80110f20,%eax
8010367c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103682:	05 40 09 11 80       	add    $0x80110940,%eax
80103687:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010368a:	0f 87 62 ff ff ff    	ja     801035f2 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103690:	83 c4 24             	add    $0x24,%esp
80103693:	5b                   	pop    %ebx
80103694:	5d                   	pop    %ebp
80103695:	c3                   	ret    

80103696 <p2v>:
80103696:	55                   	push   %ebp
80103697:	89 e5                	mov    %esp,%ebp
80103699:	8b 45 08             	mov    0x8(%ebp),%eax
8010369c:	05 00 00 00 80       	add    $0x80000000,%eax
801036a1:	5d                   	pop    %ebp
801036a2:	c3                   	ret    

801036a3 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801036a3:	55                   	push   %ebp
801036a4:	89 e5                	mov    %esp,%ebp
801036a6:	83 ec 14             	sub    $0x14,%esp
801036a9:	8b 45 08             	mov    0x8(%ebp),%eax
801036ac:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036b0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801036b4:	89 c2                	mov    %eax,%edx
801036b6:	ec                   	in     (%dx),%al
801036b7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801036ba:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801036be:	c9                   	leave  
801036bf:	c3                   	ret    

801036c0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 08             	sub    $0x8,%esp
801036c6:	8b 55 08             	mov    0x8(%ebp),%edx
801036c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801036cc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801036d0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036d3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801036d7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801036db:	ee                   	out    %al,(%dx)
}
801036dc:	c9                   	leave  
801036dd:	c3                   	ret    

801036de <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801036de:	55                   	push   %ebp
801036df:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801036e1:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801036e6:	89 c2                	mov    %eax,%edx
801036e8:	b8 40 09 11 80       	mov    $0x80110940,%eax
801036ed:	29 c2                	sub    %eax,%edx
801036ef:	89 d0                	mov    %edx,%eax
801036f1:	c1 f8 02             	sar    $0x2,%eax
801036f4:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    

801036fc <sum>:

static uchar
sum(uchar *addr, int len)
{
801036fc:	55                   	push   %ebp
801036fd:	89 e5                	mov    %esp,%ebp
801036ff:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103702:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103709:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103710:	eb 15                	jmp    80103727 <sum+0x2b>
    sum += addr[i];
80103712:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103715:	8b 45 08             	mov    0x8(%ebp),%eax
80103718:	01 d0                	add    %edx,%eax
8010371a:	0f b6 00             	movzbl (%eax),%eax
8010371d:	0f b6 c0             	movzbl %al,%eax
80103720:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103723:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103727:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010372a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010372d:	7c e3                	jl     80103712 <sum+0x16>
    sum += addr[i];
  return sum;
8010372f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103732:	c9                   	leave  
80103733:	c3                   	ret    

80103734 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103734:	55                   	push   %ebp
80103735:	89 e5                	mov    %esp,%ebp
80103737:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010373a:	8b 45 08             	mov    0x8(%ebp),%eax
8010373d:	89 04 24             	mov    %eax,(%esp)
80103740:	e8 51 ff ff ff       	call   80103696 <p2v>
80103745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103748:	8b 55 0c             	mov    0xc(%ebp),%edx
8010374b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010374e:	01 d0                	add    %edx,%eax
80103750:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103753:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103756:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103759:	eb 3f                	jmp    8010379a <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010375b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103762:	00 
80103763:	c7 44 24 04 08 8c 10 	movl   $0x80108c08,0x4(%esp)
8010376a:	80 
8010376b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376e:	89 04 24             	mov    %eax,(%esp)
80103771:	e8 5f 1e 00 00       	call   801055d5 <memcmp>
80103776:	85 c0                	test   %eax,%eax
80103778:	75 1c                	jne    80103796 <mpsearch1+0x62>
8010377a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103781:	00 
80103782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103785:	89 04 24             	mov    %eax,(%esp)
80103788:	e8 6f ff ff ff       	call   801036fc <sum>
8010378d:	84 c0                	test   %al,%al
8010378f:	75 05                	jne    80103796 <mpsearch1+0x62>
      return (struct mp*)p;
80103791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103794:	eb 11                	jmp    801037a7 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103796:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010379d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037a0:	72 b9                	jb     8010375b <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801037a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037a7:	c9                   	leave  
801037a8:	c3                   	ret    

801037a9 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801037a9:	55                   	push   %ebp
801037aa:	89 e5                	mov    %esp,%ebp
801037ac:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801037af:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037b9:	83 c0 0f             	add    $0xf,%eax
801037bc:	0f b6 00             	movzbl (%eax),%eax
801037bf:	0f b6 c0             	movzbl %al,%eax
801037c2:	c1 e0 08             	shl    $0x8,%eax
801037c5:	89 c2                	mov    %eax,%edx
801037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ca:	83 c0 0e             	add    $0xe,%eax
801037cd:	0f b6 00             	movzbl (%eax),%eax
801037d0:	0f b6 c0             	movzbl %al,%eax
801037d3:	09 d0                	or     %edx,%eax
801037d5:	c1 e0 04             	shl    $0x4,%eax
801037d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801037db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801037df:	74 21                	je     80103802 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
801037e1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037e8:	00 
801037e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ec:	89 04 24             	mov    %eax,(%esp)
801037ef:	e8 40 ff ff ff       	call   80103734 <mpsearch1>
801037f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037fb:	74 50                	je     8010384d <mpsearch+0xa4>
      return mp;
801037fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103800:	eb 5f                	jmp    80103861 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103805:	83 c0 14             	add    $0x14,%eax
80103808:	0f b6 00             	movzbl (%eax),%eax
8010380b:	0f b6 c0             	movzbl %al,%eax
8010380e:	c1 e0 08             	shl    $0x8,%eax
80103811:	89 c2                	mov    %eax,%edx
80103813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103816:	83 c0 13             	add    $0x13,%eax
80103819:	0f b6 00             	movzbl (%eax),%eax
8010381c:	0f b6 c0             	movzbl %al,%eax
8010381f:	09 d0                	or     %edx,%eax
80103821:	c1 e0 0a             	shl    $0xa,%eax
80103824:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103827:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382a:	2d 00 04 00 00       	sub    $0x400,%eax
8010382f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103836:	00 
80103837:	89 04 24             	mov    %eax,(%esp)
8010383a:	e8 f5 fe ff ff       	call   80103734 <mpsearch1>
8010383f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103842:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103846:	74 05                	je     8010384d <mpsearch+0xa4>
      return mp;
80103848:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010384b:	eb 14                	jmp    80103861 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
8010384d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103854:	00 
80103855:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010385c:	e8 d3 fe ff ff       	call   80103734 <mpsearch1>
}
80103861:	c9                   	leave  
80103862:	c3                   	ret    

80103863 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103863:	55                   	push   %ebp
80103864:	89 e5                	mov    %esp,%ebp
80103866:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103869:	e8 3b ff ff ff       	call   801037a9 <mpsearch>
8010386e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103875:	74 0a                	je     80103881 <mpconfig+0x1e>
80103877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387a:	8b 40 04             	mov    0x4(%eax),%eax
8010387d:	85 c0                	test   %eax,%eax
8010387f:	75 0a                	jne    8010388b <mpconfig+0x28>
    return 0;
80103881:	b8 00 00 00 00       	mov    $0x0,%eax
80103886:	e9 83 00 00 00       	jmp    8010390e <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388e:	8b 40 04             	mov    0x4(%eax),%eax
80103891:	89 04 24             	mov    %eax,(%esp)
80103894:	e8 fd fd ff ff       	call   80103696 <p2v>
80103899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010389c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801038a3:	00 
801038a4:	c7 44 24 04 0d 8c 10 	movl   $0x80108c0d,0x4(%esp)
801038ab:	80 
801038ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038af:	89 04 24             	mov    %eax,(%esp)
801038b2:	e8 1e 1d 00 00       	call   801055d5 <memcmp>
801038b7:	85 c0                	test   %eax,%eax
801038b9:	74 07                	je     801038c2 <mpconfig+0x5f>
    return 0;
801038bb:	b8 00 00 00 00       	mov    $0x0,%eax
801038c0:	eb 4c                	jmp    8010390e <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801038c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c5:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038c9:	3c 01                	cmp    $0x1,%al
801038cb:	74 12                	je     801038df <mpconfig+0x7c>
801038cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d0:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038d4:	3c 04                	cmp    $0x4,%al
801038d6:	74 07                	je     801038df <mpconfig+0x7c>
    return 0;
801038d8:	b8 00 00 00 00       	mov    $0x0,%eax
801038dd:	eb 2f                	jmp    8010390e <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
801038df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038e6:	0f b7 c0             	movzwl %ax,%eax
801038e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f0:	89 04 24             	mov    %eax,(%esp)
801038f3:	e8 04 fe ff ff       	call   801036fc <sum>
801038f8:	84 c0                	test   %al,%al
801038fa:	74 07                	je     80103903 <mpconfig+0xa0>
    return 0;
801038fc:	b8 00 00 00 00       	mov    $0x0,%eax
80103901:	eb 0b                	jmp    8010390e <mpconfig+0xab>
  *pmp = mp;
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103909:	89 10                	mov    %edx,(%eax)
  return conf;
8010390b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010390e:	c9                   	leave  
8010390f:	c3                   	ret    

80103910 <mpinit>:

void
mpinit(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103916:	c7 05 64 c6 10 80 40 	movl   $0x80110940,0x8010c664
8010391d:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103920:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103923:	89 04 24             	mov    %eax,(%esp)
80103926:	e8 38 ff ff ff       	call   80103863 <mpconfig>
8010392b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010392e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103932:	75 05                	jne    80103939 <mpinit+0x29>
    return;
80103934:	e9 9c 01 00 00       	jmp    80103ad5 <mpinit+0x1c5>
  ismp = 1;
80103939:	c7 05 24 09 11 80 01 	movl   $0x1,0x80110924
80103940:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103946:	8b 40 24             	mov    0x24(%eax),%eax
80103949:	a3 9c 08 11 80       	mov    %eax,0x8011089c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103951:	83 c0 2c             	add    $0x2c,%eax
80103954:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010395a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010395e:	0f b7 d0             	movzwl %ax,%edx
80103961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103964:	01 d0                	add    %edx,%eax
80103966:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103969:	e9 f4 00 00 00       	jmp    80103a62 <mpinit+0x152>
    switch(*p){
8010396e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103971:	0f b6 00             	movzbl (%eax),%eax
80103974:	0f b6 c0             	movzbl %al,%eax
80103977:	83 f8 04             	cmp    $0x4,%eax
8010397a:	0f 87 bf 00 00 00    	ja     80103a3f <mpinit+0x12f>
80103980:	8b 04 85 50 8c 10 80 	mov    -0x7fef73b0(,%eax,4),%eax
80103987:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103992:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103996:	0f b6 d0             	movzbl %al,%edx
80103999:	a1 20 0f 11 80       	mov    0x80110f20,%eax
8010399e:	39 c2                	cmp    %eax,%edx
801039a0:	74 2d                	je     801039cf <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039a5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039a9:	0f b6 d0             	movzbl %al,%edx
801039ac:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801039b1:	89 54 24 08          	mov    %edx,0x8(%esp)
801039b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801039b9:	c7 04 24 12 8c 10 80 	movl   $0x80108c12,(%esp)
801039c0:	e8 db c9 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801039c5:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
801039cc:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801039cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039d2:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801039d6:	0f b6 c0             	movzbl %al,%eax
801039d9:	83 e0 02             	and    $0x2,%eax
801039dc:	85 c0                	test   %eax,%eax
801039de:	74 15                	je     801039f5 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
801039e0:	a1 20 0f 11 80       	mov    0x80110f20,%eax
801039e5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039eb:	05 40 09 11 80       	add    $0x80110940,%eax
801039f0:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
801039f5:	8b 15 20 0f 11 80    	mov    0x80110f20,%edx
801039fb:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103a00:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103a06:	81 c2 40 09 11 80    	add    $0x80110940,%edx
80103a0c:	88 02                	mov    %al,(%edx)
      ncpu++;
80103a0e:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80103a13:	83 c0 01             	add    $0x1,%eax
80103a16:	a3 20 0f 11 80       	mov    %eax,0x80110f20
      p += sizeof(struct mpproc);
80103a1b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a1f:	eb 41                	jmp    80103a62 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a2a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a2e:	a2 20 09 11 80       	mov    %al,0x80110920
      p += sizeof(struct mpioapic);
80103a33:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a37:	eb 29                	jmp    80103a62 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a39:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a3d:	eb 23                	jmp    80103a62 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a42:	0f b6 00             	movzbl (%eax),%eax
80103a45:	0f b6 c0             	movzbl %al,%eax
80103a48:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a4c:	c7 04 24 30 8c 10 80 	movl   $0x80108c30,(%esp)
80103a53:	e8 48 c9 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103a58:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
80103a5f:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a68:	0f 82 00 ff ff ff    	jb     8010396e <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103a6e:	a1 24 09 11 80       	mov    0x80110924,%eax
80103a73:	85 c0                	test   %eax,%eax
80103a75:	75 1d                	jne    80103a94 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103a77:	c7 05 20 0f 11 80 01 	movl   $0x1,0x80110f20
80103a7e:	00 00 00 
    lapic = 0;
80103a81:	c7 05 9c 08 11 80 00 	movl   $0x0,0x8011089c
80103a88:	00 00 00 
    ioapicid = 0;
80103a8b:	c6 05 20 09 11 80 00 	movb   $0x0,0x80110920
    return;
80103a92:	eb 41                	jmp    80103ad5 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a97:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a9b:	84 c0                	test   %al,%al
80103a9d:	74 36                	je     80103ad5 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a9f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103aa6:	00 
80103aa7:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103aae:	e8 0d fc ff ff       	call   801036c0 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ab3:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103aba:	e8 e4 fb ff ff       	call   801036a3 <inb>
80103abf:	83 c8 01             	or     $0x1,%eax
80103ac2:	0f b6 c0             	movzbl %al,%eax
80103ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ac9:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103ad0:	e8 eb fb ff ff       	call   801036c0 <outb>
  }
}
80103ad5:	c9                   	leave  
80103ad6:	c3                   	ret    

80103ad7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103ad7:	55                   	push   %ebp
80103ad8:	89 e5                	mov    %esp,%ebp
80103ada:	83 ec 08             	sub    $0x8,%esp
80103add:	8b 55 08             	mov    0x8(%ebp),%edx
80103ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ae3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ae7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103aea:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103aee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103af2:	ee                   	out    %al,(%dx)
}
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    

80103af5 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103af5:	55                   	push   %ebp
80103af6:	89 e5                	mov    %esp,%ebp
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	8b 45 08             	mov    0x8(%ebp),%eax
80103afe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b02:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b06:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103b0c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b10:	0f b6 c0             	movzbl %al,%eax
80103b13:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b17:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b1e:	e8 b4 ff ff ff       	call   80103ad7 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103b23:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b27:	66 c1 e8 08          	shr    $0x8,%ax
80103b2b:	0f b6 c0             	movzbl %al,%eax
80103b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b32:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b39:	e8 99 ff ff ff       	call   80103ad7 <outb>
}
80103b3e:	c9                   	leave  
80103b3f:	c3                   	ret    

80103b40 <picenable>:

void
picenable(int irq)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103b46:	8b 45 08             	mov    0x8(%ebp),%eax
80103b49:	ba 01 00 00 00       	mov    $0x1,%edx
80103b4e:	89 c1                	mov    %eax,%ecx
80103b50:	d3 e2                	shl    %cl,%edx
80103b52:	89 d0                	mov    %edx,%eax
80103b54:	f7 d0                	not    %eax
80103b56:	89 c2                	mov    %eax,%edx
80103b58:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103b5f:	21 d0                	and    %edx,%eax
80103b61:	0f b7 c0             	movzwl %ax,%eax
80103b64:	89 04 24             	mov    %eax,(%esp)
80103b67:	e8 89 ff ff ff       	call   80103af5 <picsetmask>
}
80103b6c:	c9                   	leave  
80103b6d:	c3                   	ret    

80103b6e <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103b6e:	55                   	push   %ebp
80103b6f:	89 e5                	mov    %esp,%ebp
80103b71:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103b74:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b7b:	00 
80103b7c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b83:	e8 4f ff ff ff       	call   80103ad7 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b88:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b8f:	00 
80103b90:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b97:	e8 3b ff ff ff       	call   80103ad7 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b9c:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ba3:	00 
80103ba4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bab:	e8 27 ff ff ff       	call   80103ad7 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103bb0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103bb7:	00 
80103bb8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bbf:	e8 13 ff ff ff       	call   80103ad7 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103bc4:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103bcb:	00 
80103bcc:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103bd3:	e8 ff fe ff ff       	call   80103ad7 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103bd8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bdf:	00 
80103be0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103be7:	e8 eb fe ff ff       	call   80103ad7 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103bec:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bf3:	00 
80103bf4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bfb:	e8 d7 fe ff ff       	call   80103ad7 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103c00:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103c07:	00 
80103c08:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c0f:	e8 c3 fe ff ff       	call   80103ad7 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103c14:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103c1b:	00 
80103c1c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c23:	e8 af fe ff ff       	call   80103ad7 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103c28:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103c2f:	00 
80103c30:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103c37:	e8 9b fe ff ff       	call   80103ad7 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103c3c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c43:	00 
80103c44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c4b:	e8 87 fe ff ff       	call   80103ad7 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c50:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c57:	00 
80103c58:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c5f:	e8 73 fe ff ff       	call   80103ad7 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103c64:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c6b:	00 
80103c6c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c73:	e8 5f fe ff ff       	call   80103ad7 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103c78:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c7f:	00 
80103c80:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c87:	e8 4b fe ff ff       	call   80103ad7 <outb>

  if(irqmask != 0xFFFF)
80103c8c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103c93:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c97:	74 12                	je     80103cab <picinit+0x13d>
    picsetmask(irqmask);
80103c99:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103ca0:	0f b7 c0             	movzwl %ax,%eax
80103ca3:	89 04 24             	mov    %eax,(%esp)
80103ca6:	e8 4a fe ff ff       	call   80103af5 <picsetmask>
}
80103cab:	c9                   	leave  
80103cac:	c3                   	ret    

80103cad <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103cad:	55                   	push   %ebp
80103cae:	89 e5                	mov    %esp,%ebp
80103cb0:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cba:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc6:	8b 10                	mov    (%eax),%edx
80103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccb:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ccd:	e8 4c d2 ff ff       	call   80100f1e <filealloc>
80103cd2:	8b 55 08             	mov    0x8(%ebp),%edx
80103cd5:	89 02                	mov    %eax,(%edx)
80103cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cda:	8b 00                	mov    (%eax),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	0f 84 c8 00 00 00    	je     80103dac <pipealloc+0xff>
80103ce4:	e8 35 d2 ff ff       	call   80100f1e <filealloc>
80103ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cec:	89 02                	mov    %eax,(%edx)
80103cee:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf1:	8b 00                	mov    (%eax),%eax
80103cf3:	85 c0                	test   %eax,%eax
80103cf5:	0f 84 b1 00 00 00    	je     80103dac <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103cfb:	e8 da ed ff ff       	call   80102ada <kalloc>
80103d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d07:	75 05                	jne    80103d0e <pipealloc+0x61>
    goto bad;
80103d09:	e9 9e 00 00 00       	jmp    80103dac <pipealloc+0xff>
  p->readopen = 1;
80103d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d11:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d18:	00 00 00 
  p->writeopen = 1;
80103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d25:	00 00 00 
  p->nwrite = 0;
80103d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d32:	00 00 00 
  p->nread = 0;
80103d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d38:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d3f:	00 00 00 
  initlock(&p->lock, "pipe");
80103d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d45:	c7 44 24 04 64 8c 10 	movl   $0x80108c64,0x4(%esp)
80103d4c:	80 
80103d4d:	89 04 24             	mov    %eax,(%esp)
80103d50:	e8 94 15 00 00       	call   801052e9 <initlock>
  (*f0)->type = FD_PIPE;
80103d55:	8b 45 08             	mov    0x8(%ebp),%eax
80103d58:	8b 00                	mov    (%eax),%eax
80103d5a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d60:	8b 45 08             	mov    0x8(%ebp),%eax
80103d63:	8b 00                	mov    (%eax),%eax
80103d65:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d69:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6c:	8b 00                	mov    (%eax),%eax
80103d6e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d72:	8b 45 08             	mov    0x8(%ebp),%eax
80103d75:	8b 00                	mov    (%eax),%eax
80103d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d7a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d80:	8b 00                	mov    (%eax),%eax
80103d82:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d88:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d8b:	8b 00                	mov    (%eax),%eax
80103d8d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d94:	8b 00                	mov    (%eax),%eax
80103d96:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9d:	8b 00                	mov    (%eax),%eax
80103d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da2:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103da5:	b8 00 00 00 00       	mov    $0x0,%eax
80103daa:	eb 42                	jmp    80103dee <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103db0:	74 0b                	je     80103dbd <pipealloc+0x110>
    kfree((char*)p);
80103db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db5:	89 04 24             	mov    %eax,(%esp)
80103db8:	e8 84 ec ff ff       	call   80102a41 <kfree>
  if(*f0)
80103dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc0:	8b 00                	mov    (%eax),%eax
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	74 0d                	je     80103dd3 <pipealloc+0x126>
    fileclose(*f0);
80103dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc9:	8b 00                	mov    (%eax),%eax
80103dcb:	89 04 24             	mov    %eax,(%esp)
80103dce:	e8 f3 d1 ff ff       	call   80100fc6 <fileclose>
  if(*f1)
80103dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd6:	8b 00                	mov    (%eax),%eax
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	74 0d                	je     80103de9 <pipealloc+0x13c>
    fileclose(*f1);
80103ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ddf:	8b 00                	mov    (%eax),%eax
80103de1:	89 04 24             	mov    %eax,(%esp)
80103de4:	e8 dd d1 ff ff       	call   80100fc6 <fileclose>
  return -1;
80103de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dee:	c9                   	leave  
80103def:	c3                   	ret    

80103df0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103df6:	8b 45 08             	mov    0x8(%ebp),%eax
80103df9:	89 04 24             	mov    %eax,(%esp)
80103dfc:	e8 09 15 00 00       	call   8010530a <acquire>
  if(writable){
80103e01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e05:	74 1f                	je     80103e26 <pipeclose+0x36>
    p->writeopen = 0;
80103e07:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e11:	00 00 00 
    wakeup(&p->nread);
80103e14:	8b 45 08             	mov    0x8(%ebp),%eax
80103e17:	05 34 02 00 00       	add    $0x234,%eax
80103e1c:	89 04 24             	mov    %eax,(%esp)
80103e1f:	e8 6d 0f 00 00       	call   80104d91 <wakeup>
80103e24:	eb 1d                	jmp    80103e43 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e26:	8b 45 08             	mov    0x8(%ebp),%eax
80103e29:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e30:	00 00 00 
    wakeup(&p->nwrite);
80103e33:	8b 45 08             	mov    0x8(%ebp),%eax
80103e36:	05 38 02 00 00       	add    $0x238,%eax
80103e3b:	89 04 24             	mov    %eax,(%esp)
80103e3e:	e8 4e 0f 00 00       	call   80104d91 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e43:	8b 45 08             	mov    0x8(%ebp),%eax
80103e46:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e4c:	85 c0                	test   %eax,%eax
80103e4e:	75 25                	jne    80103e75 <pipeclose+0x85>
80103e50:	8b 45 08             	mov    0x8(%ebp),%eax
80103e53:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e59:	85 c0                	test   %eax,%eax
80103e5b:	75 18                	jne    80103e75 <pipeclose+0x85>
    release(&p->lock);
80103e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e60:	89 04 24             	mov    %eax,(%esp)
80103e63:	e8 04 15 00 00       	call   8010536c <release>
    kfree((char*)p);
80103e68:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6b:	89 04 24             	mov    %eax,(%esp)
80103e6e:	e8 ce eb ff ff       	call   80102a41 <kfree>
80103e73:	eb 0b                	jmp    80103e80 <pipeclose+0x90>
  } else
    release(&p->lock);
80103e75:	8b 45 08             	mov    0x8(%ebp),%eax
80103e78:	89 04 24             	mov    %eax,(%esp)
80103e7b:	e8 ec 14 00 00       	call   8010536c <release>
}
80103e80:	c9                   	leave  
80103e81:	c3                   	ret    

80103e82 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e82:	55                   	push   %ebp
80103e83:	89 e5                	mov    %esp,%ebp
80103e85:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	89 04 24             	mov    %eax,(%esp)
80103e8e:	e8 77 14 00 00       	call   8010530a <acquire>
  for(i = 0; i < n; i++){
80103e93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e9a:	e9 a6 00 00 00       	jmp    80103f45 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e9f:	eb 57                	jmp    80103ef8 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103eaa:	85 c0                	test   %eax,%eax
80103eac:	74 0d                	je     80103ebb <pipewrite+0x39>
80103eae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb4:	8b 40 24             	mov    0x24(%eax),%eax
80103eb7:	85 c0                	test   %eax,%eax
80103eb9:	74 15                	je     80103ed0 <pipewrite+0x4e>
        release(&p->lock);
80103ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebe:	89 04 24             	mov    %eax,(%esp)
80103ec1:	e8 a6 14 00 00       	call   8010536c <release>
        return -1;
80103ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ecb:	e9 9f 00 00 00       	jmp    80103f6f <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed3:	05 34 02 00 00       	add    $0x234,%eax
80103ed8:	89 04 24             	mov    %eax,(%esp)
80103edb:	e8 b1 0e 00 00       	call   80104d91 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee3:	8b 55 08             	mov    0x8(%ebp),%edx
80103ee6:	81 c2 38 02 00 00    	add    $0x238,%edx
80103eec:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ef0:	89 14 24             	mov    %edx,(%esp)
80103ef3:	e8 55 0d 00 00       	call   80104c4d <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80103efb:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f01:	8b 45 08             	mov    0x8(%ebp),%eax
80103f04:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f0a:	05 00 02 00 00       	add    $0x200,%eax
80103f0f:	39 c2                	cmp    %eax,%edx
80103f11:	74 8e                	je     80103ea1 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f1c:	8d 48 01             	lea    0x1(%eax),%ecx
80103f1f:	8b 55 08             	mov    0x8(%ebp),%edx
80103f22:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f28:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f2d:	89 c1                	mov    %eax,%ecx
80103f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f32:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f35:	01 d0                	add    %edx,%eax
80103f37:	0f b6 10             	movzbl (%eax),%edx
80103f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3d:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f48:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f4b:	0f 8c 4e ff ff ff    	jl     80103e9f <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f51:	8b 45 08             	mov    0x8(%ebp),%eax
80103f54:	05 34 02 00 00       	add    $0x234,%eax
80103f59:	89 04 24             	mov    %eax,(%esp)
80103f5c:	e8 30 0e 00 00       	call   80104d91 <wakeup>
  release(&p->lock);
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	89 04 24             	mov    %eax,(%esp)
80103f67:	e8 00 14 00 00       	call   8010536c <release>
  return n;
80103f6c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f6f:	c9                   	leave  
80103f70:	c3                   	ret    

80103f71 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f71:	55                   	push   %ebp
80103f72:	89 e5                	mov    %esp,%ebp
80103f74:	53                   	push   %ebx
80103f75:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f78:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7b:	89 04 24             	mov    %eax,(%esp)
80103f7e:	e8 87 13 00 00       	call   8010530a <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f83:	eb 3a                	jmp    80103fbf <piperead+0x4e>
    if(proc->killed){
80103f85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f8b:	8b 40 24             	mov    0x24(%eax),%eax
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	74 15                	je     80103fa7 <piperead+0x36>
      release(&p->lock);
80103f92:	8b 45 08             	mov    0x8(%ebp),%eax
80103f95:	89 04 24             	mov    %eax,(%esp)
80103f98:	e8 cf 13 00 00       	call   8010536c <release>
      return -1;
80103f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fa2:	e9 b5 00 00 00       	jmp    8010405c <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80103faa:	8b 55 08             	mov    0x8(%ebp),%edx
80103fad:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fb7:	89 14 24             	mov    %edx,(%esp)
80103fba:	e8 8e 0c 00 00       	call   80104c4d <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fd1:	39 c2                	cmp    %eax,%edx
80103fd3:	75 0d                	jne    80103fe2 <piperead+0x71>
80103fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	75 a3                	jne    80103f85 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fe2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fe9:	eb 4b                	jmp    80104036 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103feb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fee:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ffd:	39 c2                	cmp    %eax,%edx
80103fff:	75 02                	jne    80104003 <piperead+0x92>
      break;
80104001:	eb 3b                	jmp    8010403e <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104003:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104006:	8b 45 0c             	mov    0xc(%ebp),%eax
80104009:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010400c:	8b 45 08             	mov    0x8(%ebp),%eax
8010400f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104015:	8d 48 01             	lea    0x1(%eax),%ecx
80104018:	8b 55 08             	mov    0x8(%ebp),%edx
8010401b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104021:	25 ff 01 00 00       	and    $0x1ff,%eax
80104026:	89 c2                	mov    %eax,%edx
80104028:	8b 45 08             	mov    0x8(%ebp),%eax
8010402b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104030:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104032:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104039:	3b 45 10             	cmp    0x10(%ebp),%eax
8010403c:	7c ad                	jl     80103feb <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010403e:	8b 45 08             	mov    0x8(%ebp),%eax
80104041:	05 38 02 00 00       	add    $0x238,%eax
80104046:	89 04 24             	mov    %eax,(%esp)
80104049:	e8 43 0d 00 00       	call   80104d91 <wakeup>
  release(&p->lock);
8010404e:	8b 45 08             	mov    0x8(%ebp),%eax
80104051:	89 04 24             	mov    %eax,(%esp)
80104054:	e8 13 13 00 00       	call   8010536c <release>
  return i;
80104059:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010405c:	83 c4 24             	add    $0x24,%esp
8010405f:	5b                   	pop    %ebx
80104060:	5d                   	pop    %ebp
80104061:	c3                   	ret    

80104062 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104062:	55                   	push   %ebp
80104063:	89 e5                	mov    %esp,%ebp
80104065:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104068:	9c                   	pushf  
80104069:	58                   	pop    %eax
8010406a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010406d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104070:	c9                   	leave  
80104071:	c3                   	ret    

80104072 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104072:	55                   	push   %ebp
80104073:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104075:	fb                   	sti    
}
80104076:	5d                   	pop    %ebp
80104077:	c3                   	ret    

80104078 <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
80104078:	55                   	push   %ebp
80104079:	89 e5                	mov    %esp,%ebp
8010407b:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
8010407e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104081:	89 45 fc             	mov    %eax,-0x4(%ebp)
    d = dst;
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(s < d && s + n > d){
8010408a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010408d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104090:	73 3d                	jae    801040cf <memcop+0x57>
80104092:	8b 45 10             	mov    0x10(%ebp),%eax
80104095:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104098:	01 d0                	add    %edx,%eax
8010409a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010409d:	76 30                	jbe    801040cf <memcop+0x57>
        s += n;
8010409f:	8b 45 10             	mov    0x10(%ebp),%eax
801040a2:	01 45 fc             	add    %eax,-0x4(%ebp)
        d += n;
801040a5:	8b 45 10             	mov    0x10(%ebp),%eax
801040a8:	01 45 f8             	add    %eax,-0x8(%ebp)
        while(n-- > 0)
801040ab:	eb 13                	jmp    801040c0 <memcop+0x48>
            *--d = *--s;
801040ad:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801040b1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801040b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801040b8:	0f b6 10             	movzbl (%eax),%edx
801040bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801040be:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
801040c0:	8b 45 10             	mov    0x10(%ebp),%eax
801040c3:	8d 50 ff             	lea    -0x1(%eax),%edx
801040c6:	89 55 10             	mov    %edx,0x10(%ebp)
801040c9:	85 c0                	test   %eax,%eax
801040cb:	75 e0                	jne    801040ad <memcop+0x35>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
801040cd:	eb 26                	jmp    801040f5 <memcop+0x7d>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
801040cf:	eb 17                	jmp    801040e8 <memcop+0x70>
            *d++ = *s++;
801040d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801040d4:	8d 50 01             	lea    0x1(%eax),%edx
801040d7:	89 55 f8             	mov    %edx,-0x8(%ebp)
801040da:	8b 55 fc             	mov    -0x4(%ebp),%edx
801040dd:	8d 4a 01             	lea    0x1(%edx),%ecx
801040e0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801040e3:	0f b6 12             	movzbl (%edx),%edx
801040e6:	88 10                	mov    %dl,(%eax)
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
801040e8:	8b 45 10             	mov    0x10(%ebp),%eax
801040eb:	8d 50 ff             	lea    -0x1(%eax),%edx
801040ee:	89 55 10             	mov    %edx,0x10(%ebp)
801040f1:	85 c0                	test   %eax,%eax
801040f3:	75 dc                	jne    801040d1 <memcop+0x59>
            *d++ = *s++;

    return dst;
801040f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801040f8:	c9                   	leave  
801040f9:	c3                   	ret    

801040fa <pinit>:


    void
pinit(void)
{
801040fa:	55                   	push   %ebp
801040fb:	89 e5                	mov    %esp,%ebp
801040fd:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
80104100:	c7 44 24 04 6c 8c 10 	movl   $0x80108c6c,0x4(%esp)
80104107:	80 
80104108:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010410f:	e8 d5 11 00 00       	call   801052e9 <initlock>
}
80104114:	c9                   	leave  
80104115:	c3                   	ret    

80104116 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
80104116:	55                   	push   %ebp
80104117:	89 e5                	mov    %esp,%ebp
80104119:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
8010411c:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104123:	e8 e2 11 00 00       	call   8010530a <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104128:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
8010412f:	eb 53                	jmp    80104184 <allocproc+0x6e>
        if(p->state == UNUSED)
80104131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104134:	8b 40 0c             	mov    0xc(%eax),%eax
80104137:	85 c0                	test   %eax,%eax
80104139:	75 42                	jne    8010417d <allocproc+0x67>
            goto found;
8010413b:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
8010413c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
80104146:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010414b:	8d 50 01             	lea    0x1(%eax),%edx
8010414e:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104154:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104157:	89 42 10             	mov    %eax,0x10(%edx)
    release(&ptable.lock);
8010415a:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104161:	e8 06 12 00 00       	call   8010536c <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80104166:	e8 6f e9 ff ff       	call   80102ada <kalloc>
8010416b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010416e:	89 42 08             	mov    %eax,0x8(%edx)
80104171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104174:	8b 40 08             	mov    0x8(%eax),%eax
80104177:	85 c0                	test   %eax,%eax
80104179:	75 36                	jne    801041b1 <allocproc+0x9b>
8010417b:	eb 23                	jmp    801041a0 <allocproc+0x8a>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104184:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
8010418b:	72 a4                	jb     80104131 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
8010418d:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104194:	e8 d3 11 00 00       	call   8010536c <release>
    return 0;
80104199:	b8 00 00 00 00       	mov    $0x0,%eax
8010419e:	eb 76                	jmp    80104216 <allocproc+0x100>
    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
801041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
801041aa:	b8 00 00 00 00       	mov    $0x0,%eax
801041af:	eb 65                	jmp    80104216 <allocproc+0x100>
    }
    sp = p->kstack + KSTACKSIZE;
801041b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b4:	8b 40 08             	mov    0x8(%eax),%eax
801041b7:	05 00 10 00 00       	add    $0x1000,%eax
801041bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801041bf:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
801041c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041c9:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
801041cc:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
801041d0:	ba 43 6a 10 80       	mov    $0x80106a43,%edx
801041d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041d8:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
801041da:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
801041de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041e4:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
801041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ea:	8b 40 1c             	mov    0x1c(%eax),%eax
801041ed:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801041f4:	00 
801041f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041fc:	00 
801041fd:	89 04 24             	mov    %eax,(%esp)
80104200:	e8 59 13 00 00       	call   8010555e <memset>
    p->context->eip = (uint)forkret;
80104205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104208:	8b 40 1c             	mov    0x1c(%eax),%eax
8010420b:	ba 21 4c 10 80       	mov    $0x80104c21,%edx
80104210:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
80104213:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104216:	c9                   	leave  
80104217:	c3                   	ret    

80104218 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
80104218:	55                   	push   %ebp
80104219:	89 e5                	mov    %esp,%ebp
8010421b:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
8010421e:	e8 f3 fe ff ff       	call   80104116 <allocproc>
80104223:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
80104226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104229:	a3 68 c6 10 80       	mov    %eax,0x8010c668
    if((p->pgdir = setupkvm()) == 0)
8010422e:	e8 04 3f 00 00       	call   80108137 <setupkvm>
80104233:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104236:	89 42 04             	mov    %eax,0x4(%edx)
80104239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423c:	8b 40 04             	mov    0x4(%eax),%eax
8010423f:	85 c0                	test   %eax,%eax
80104241:	75 0c                	jne    8010424f <userinit+0x37>
        panic("userinit: out of memory?");
80104243:	c7 04 24 73 8c 10 80 	movl   $0x80108c73,(%esp)
8010424a:	e8 eb c2 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010424f:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104257:	8b 40 04             	mov    0x4(%eax),%eax
8010425a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010425e:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
80104265:	80 
80104266:	89 04 24             	mov    %eax,(%esp)
80104269:	e8 21 41 00 00       	call   8010838f <inituvm>
    p->sz = PGSIZE;
8010426e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104271:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
80104277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427a:	8b 40 18             	mov    0x18(%eax),%eax
8010427d:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104284:	00 
80104285:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010428c:	00 
8010428d:	89 04 24             	mov    %eax,(%esp)
80104290:	e8 c9 12 00 00       	call   8010555e <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104298:	8b 40 18             	mov    0x18(%eax),%eax
8010429b:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	8b 40 18             	mov    0x18(%eax),%eax
801042a7:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801042ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b0:	8b 40 18             	mov    0x18(%eax),%eax
801042b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b6:	8b 52 18             	mov    0x18(%edx),%edx
801042b9:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042bd:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c4:	8b 40 18             	mov    0x18(%eax),%eax
801042c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ca:	8b 52 18             	mov    0x18(%edx),%edx
801042cd:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042d1:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d8:	8b 40 18             	mov    0x18(%eax),%eax
801042db:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801042e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e5:	8b 40 18             	mov    0x18(%eax),%eax
801042e8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
801042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f2:	8b 40 18             	mov    0x18(%eax),%eax
801042f5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
801042fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ff:	83 c0 6c             	add    $0x6c,%eax
80104302:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104309:	00 
8010430a:	c7 44 24 04 8c 8c 10 	movl   $0x80108c8c,0x4(%esp)
80104311:	80 
80104312:	89 04 24             	mov    %eax,(%esp)
80104315:	e8 64 14 00 00       	call   8010577e <safestrcpy>
    p->cwd = namei("/");
8010431a:	c7 04 24 95 8c 10 80 	movl   $0x80108c95,(%esp)
80104321:	e8 d8 e0 ff ff       	call   801023fe <namei>
80104326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104329:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
8010432c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104336:	c9                   	leave  
80104337:	c3                   	ret    

80104338 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
80104338:	55                   	push   %ebp
80104339:	89 e5                	mov    %esp,%ebp
8010433b:	83 ec 28             	sub    $0x28,%esp
    uint sz;

    sz = proc->sz;
8010433e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104344:	8b 00                	mov    (%eax),%eax
80104346:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
80104349:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010434d:	7e 34                	jle    80104383 <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010434f:	8b 55 08             	mov    0x8(%ebp),%edx
80104352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104355:	01 c2                	add    %eax,%edx
80104357:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010435d:	8b 40 04             	mov    0x4(%eax),%eax
80104360:	89 54 24 08          	mov    %edx,0x8(%esp)
80104364:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104367:	89 54 24 04          	mov    %edx,0x4(%esp)
8010436b:	89 04 24             	mov    %eax,(%esp)
8010436e:	e8 92 41 00 00       	call   80108505 <allocuvm>
80104373:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010437a:	75 41                	jne    801043bd <growproc+0x85>
            return -1;
8010437c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104381:	eb 58                	jmp    801043db <growproc+0xa3>
    } else if(n < 0){
80104383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104387:	79 34                	jns    801043bd <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104389:	8b 55 08             	mov    0x8(%ebp),%edx
8010438c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438f:	01 c2                	add    %eax,%edx
80104391:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104397:	8b 40 04             	mov    0x4(%eax),%eax
8010439a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010439e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801043a5:	89 04 24             	mov    %eax,(%esp)
801043a8:	e8 32 42 00 00       	call   801085df <deallocuvm>
801043ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043b4:	75 07                	jne    801043bd <growproc+0x85>
            return -1;
801043b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043bb:	eb 1e                	jmp    801043db <growproc+0xa3>
    }
    proc->sz = sz;
801043bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043c6:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
801043c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ce:	89 04 24             	mov    %eax,(%esp)
801043d1:	e8 52 3e 00 00       	call   80108228 <switchuvm>
    return 0;
801043d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043db:	c9                   	leave  
801043dc:	c3                   	ret    

801043dd <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
801043dd:	55                   	push   %ebp
801043de:	89 e5                	mov    %esp,%ebp
801043e0:	57                   	push   %edi
801043e1:	56                   	push   %esi
801043e2:	53                   	push   %ebx
801043e3:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
801043e6:	e8 2b fd ff ff       	call   80104116 <allocproc>
801043eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801043ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801043f2:	75 0a                	jne    801043fe <fork+0x21>
        return -1;
801043f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043f9:	e9 47 01 00 00       	jmp    80104545 <fork+0x168>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801043fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104404:	8b 10                	mov    (%eax),%edx
80104406:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440c:	8b 40 04             	mov    0x4(%eax),%eax
8010440f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104413:	89 04 24             	mov    %eax,(%esp)
80104416:	e8 60 43 00 00       	call   8010877b <copyuvm>
8010441b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010441e:	89 42 04             	mov    %eax,0x4(%edx)
80104421:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104424:	8b 40 04             	mov    0x4(%eax),%eax
80104427:	85 c0                	test   %eax,%eax
80104429:	75 2c                	jne    80104457 <fork+0x7a>
        kfree(np->kstack);
8010442b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010442e:	8b 40 08             	mov    0x8(%eax),%eax
80104431:	89 04 24             	mov    %eax,(%esp)
80104434:	e8 08 e6 ff ff       	call   80102a41 <kfree>
        np->kstack = 0;
80104439:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010443c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
80104443:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104446:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
8010444d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104452:	e9 ee 00 00 00       	jmp    80104545 <fork+0x168>
    }
    np->sz = proc->sz;
80104457:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010445d:	8b 10                	mov    (%eax),%edx
8010445f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104462:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104464:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010446b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010446e:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104471:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104474:	8b 50 18             	mov    0x18(%eax),%edx
80104477:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010447d:	8b 40 18             	mov    0x18(%eax),%eax
80104480:	89 c3                	mov    %eax,%ebx
80104482:	b8 13 00 00 00       	mov    $0x13,%eax
80104487:	89 d7                	mov    %edx,%edi
80104489:	89 de                	mov    %ebx,%esi
8010448b:	89 c1                	mov    %eax,%ecx
8010448d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
8010448f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104492:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104499:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
8010449c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010449f:	8b 40 18             	mov    0x18(%eax),%eax
801044a2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
801044a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801044b0:	eb 3d                	jmp    801044ef <fork+0x112>
        if(proc->ofile[i])
801044b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044bb:	83 c2 08             	add    $0x8,%edx
801044be:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044c2:	85 c0                	test   %eax,%eax
801044c4:	74 25                	je     801044eb <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
801044c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044cf:	83 c2 08             	add    $0x8,%edx
801044d2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044d6:	89 04 24             	mov    %eax,(%esp)
801044d9:	e8 a0 ca ff ff       	call   80100f7e <filedup>
801044de:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801044e4:	83 c1 08             	add    $0x8,%ecx
801044e7:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
801044eb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801044ef:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801044f3:	7e bd                	jle    801044b2 <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
801044f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fb:	8b 40 68             	mov    0x68(%eax),%eax
801044fe:	89 04 24             	mov    %eax,(%esp)
80104501:	e8 1b d3 ff ff       	call   80101821 <idup>
80104506:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104509:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
8010450c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010450f:	8b 40 10             	mov    0x10(%eax),%eax
80104512:	89 45 dc             	mov    %eax,-0x24(%ebp)
    np->state = RUNNABLE;
80104515:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104518:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
8010451f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104525:	8d 50 6c             	lea    0x6c(%eax),%edx
80104528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010452b:	83 c0 6c             	add    $0x6c,%eax
8010452e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104535:	00 
80104536:	89 54 24 04          	mov    %edx,0x4(%esp)
8010453a:	89 04 24             	mov    %eax,(%esp)
8010453d:	e8 3c 12 00 00       	call   8010577e <safestrcpy>
    return pid;
80104542:	8b 45 dc             	mov    -0x24(%ebp),%eax

}
80104545:	83 c4 2c             	add    $0x2c,%esp
80104548:	5b                   	pop    %ebx
80104549:	5e                   	pop    %esi
8010454a:	5f                   	pop    %edi
8010454b:	5d                   	pop    %ebp
8010454c:	c3                   	ret    

8010454d <clone>:

//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
8010454d:	55                   	push   %ebp
8010454e:	89 e5                	mov    %esp,%ebp
80104550:	57                   	push   %edi
80104551:	56                   	push   %esi
80104552:	53                   	push   %ebx
80104553:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
80104559:	e8 b8 fb ff ff       	call   80104116 <allocproc>
8010455e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104561:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104565:	75 0a                	jne    80104571 <clone+0x24>
        return -1;
80104567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010456c:	e9 f4 01 00 00       	jmp    80104765 <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
80104571:	8b 45 08             	mov    0x8(%ebp),%eax
80104574:	25 ff 0f 00 00       	and    $0xfff,%eax
80104579:	85 c0                	test   %eax,%eax
8010457b:	75 0c                	jne    80104589 <clone+0x3c>
8010457d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104581:	74 06                	je     80104589 <clone+0x3c>
80104583:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104587:	75 0a                	jne    80104593 <clone+0x46>
        return -1;
80104589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458e:	e9 d2 01 00 00       	jmp    80104765 <clone+0x218>

    np->pgdir = proc->pgdir;
80104593:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104599:	8b 50 04             	mov    0x4(%eax),%edx
8010459c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010459f:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
801045a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a8:	8b 10                	mov    (%eax),%edx
801045aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ad:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801045af:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801045b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045b9:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
801045bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045bf:	8b 50 18             	mov    0x18(%eax),%edx
801045c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c8:	8b 40 18             	mov    0x18(%eax),%eax
801045cb:	89 c3                	mov    %eax,%ebx
801045cd:	b8 13 00 00 00       	mov    $0x13,%eax
801045d2:	89 d7                	mov    %edx,%edi
801045d4:	89 de                	mov    %ebx,%esi
801045d6:	89 c1                	mov    %eax,%ecx
801045d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
801045da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045dd:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801045e4:	00 00 00 
    pid = np->pid;
801045e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ea:	8b 40 10             	mov    0x10(%eax),%eax
801045ed:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
801045f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
801045f9:	eb 09                	jmp    80104604 <clone+0xb7>
        pp = pp->parent;
801045fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045fe:	8b 40 14             	mov    0x14(%eax),%eax
80104601:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
80104604:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104607:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010460d:	83 f8 01             	cmp    $0x1,%eax
80104610:	74 e9                	je     801045fb <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
80104612:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104615:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104618:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
8010461b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104622:	eb 3d                	jmp    80104661 <clone+0x114>
        if(proc->ofile[i])
80104624:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010462d:	83 c2 08             	add    $0x8,%edx
80104630:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104634:	85 c0                	test   %eax,%eax
80104636:	74 25                	je     8010465d <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
80104638:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104641:	83 c2 08             	add    $0x8,%edx
80104644:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104648:	89 04 24             	mov    %eax,(%esp)
8010464b:	e8 2e c9 ff ff       	call   80100f7e <filedup>
80104650:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104653:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104656:	83 c1 08             	add    $0x8,%ecx
80104659:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
8010465d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104661:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104665:	7e bd                	jle    80104624 <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104667:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010466a:	8b 40 18             	mov    0x18(%eax),%eax
8010466d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
80104674:	8b 45 08             	mov    0x8(%ebp),%eax
80104677:	05 00 10 00 00       	add    $0x1000,%eax
8010467c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
//


//modify here <<<<<

    np->tf->ebp = sp;
8010467f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104682:	8b 40 18             	mov    0x18(%eax),%eax
80104685:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104688:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
8010468b:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
80104692:	ff ff ff 
    ustack[1] = arg;
80104695:	8b 45 14             	mov    0x14(%ebp),%eax
80104698:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
8010469e:	83 6d d4 08          	subl   $0x8,-0x2c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
801046a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046a5:	8b 40 04             	mov    0x4(%eax),%eax
801046a8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
801046af:	00 
801046b0:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
801046b6:	89 54 24 08          	mov    %edx,0x8(%esp)
801046ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801046bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801046c1:	89 04 24             	mov    %eax,(%esp)
801046c4:	e8 31 42 00 00       	call   801088fa <copyout>
801046c9:	85 c0                	test   %eax,%eax
801046cb:	79 16                	jns    801046e3 <clone+0x196>
        cprintf("push arg fails\n");
801046cd:	c7 04 24 97 8c 10 80 	movl   $0x80108c97,(%esp)
801046d4:	e8 c7 bc ff ff       	call   801003a0 <cprintf>
        return -1;
801046d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046de:	e9 82 00 00 00       	jmp    80104765 <clone+0x218>
    }

    np->tf->eip = routine;
801046e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046e6:	8b 40 18             	mov    0x18(%eax),%eax
801046e9:	8b 55 10             	mov    0x10(%ebp),%edx
801046ec:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
801046ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046f2:	8b 40 18             	mov    0x18(%eax),%eax
801046f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801046f8:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
801046fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104701:	8b 40 68             	mov    0x68(%eax),%eax
80104704:	89 04 24             	mov    %eax,(%esp)
80104707:	e8 15 d1 ff ff       	call   80101821 <idup>
8010470c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010470f:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
80104712:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104715:	89 04 24             	mov    %eax,(%esp)
80104718:	e8 0b 3b 00 00       	call   80108228 <switchuvm>

     acquire(&ptable.lock);
8010471d:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104724:	e8 e1 0b 00 00       	call   8010530a <acquire>
    np->state = RUNNABLE;
80104729:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010472c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
     release(&ptable.lock);
80104733:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010473a:	e8 2d 0c 00 00       	call   8010536c <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
8010473f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104745:	8d 50 6c             	lea    0x6c(%eax),%edx
80104748:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010474b:	83 c0 6c             	add    $0x6c,%eax
8010474e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104755:	00 
80104756:	89 54 24 04          	mov    %edx,0x4(%esp)
8010475a:	89 04 24             	mov    %eax,(%esp)
8010475d:	e8 1c 10 00 00       	call   8010577e <safestrcpy>


    return pid;
80104762:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
80104765:	81 c4 bc 00 00 00    	add    $0xbc,%esp
8010476b:	5b                   	pop    %ebx
8010476c:	5e                   	pop    %esi
8010476d:	5f                   	pop    %edi
8010476e:	5d                   	pop    %ebp
8010476f:	c3                   	ret    

80104770 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
80104776:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010477d:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104782:	39 c2                	cmp    %eax,%edx
80104784:	75 0c                	jne    80104792 <exit+0x22>
        panic("init exiting");
80104786:	c7 04 24 a7 8c 10 80 	movl   $0x80108ca7,(%esp)
8010478d:	e8 a8 bd ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104792:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104799:	eb 44                	jmp    801047df <exit+0x6f>
        if(proc->ofile[fd]){
8010479b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047a4:	83 c2 08             	add    $0x8,%edx
801047a7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 2c                	je     801047db <exit+0x6b>
            fileclose(proc->ofile[fd]);
801047af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047b8:	83 c2 08             	add    $0x8,%edx
801047bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047bf:	89 04 24             	mov    %eax,(%esp)
801047c2:	e8 ff c7 ff ff       	call   80100fc6 <fileclose>
            proc->ofile[fd] = 0;
801047c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047d0:	83 c2 08             	add    $0x8,%edx
801047d3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801047da:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801047db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801047df:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801047e3:	7e b6                	jle    8010479b <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
801047e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047eb:	8b 40 68             	mov    0x68(%eax),%eax
801047ee:	89 04 24             	mov    %eax,(%esp)
801047f1:	e8 10 d2 ff ff       	call   80101a06 <iput>
    proc->cwd = 0;
801047f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fc:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104803:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010480a:	e8 fb 0a 00 00       	call   8010530a <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
8010480f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104815:	8b 40 14             	mov    0x14(%eax),%eax
80104818:	89 04 24             	mov    %eax,(%esp)
8010481b:	e8 c8 04 00 00       	call   80104ce8 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104820:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104827:	eb 3b                	jmp    80104864 <exit+0xf4>
        if(p->parent == proc){
80104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482c:	8b 50 14             	mov    0x14(%eax),%edx
8010482f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104835:	39 c2                	cmp    %eax,%edx
80104837:	75 24                	jne    8010485d <exit+0xed>
            p->parent = initproc;
80104839:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
8010483f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104842:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80104845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104848:	8b 40 0c             	mov    0xc(%eax),%eax
8010484b:	83 f8 05             	cmp    $0x5,%eax
8010484e:	75 0d                	jne    8010485d <exit+0xed>
                wakeup1(initproc);
80104850:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104855:	89 04 24             	mov    %eax,(%esp)
80104858:	e8 8b 04 00 00       	call   80104ce8 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010485d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104864:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
8010486b:	72 bc                	jb     80104829 <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
8010486d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104873:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
8010487a:	e8 95 02 00 00       	call   80104b14 <sched>
    panic("zombie exit");
8010487f:	c7 04 24 b4 8c 10 80 	movl   $0x80108cb4,(%esp)
80104886:	e8 af bc ff ff       	call   8010053a <panic>

8010488b <texit>:
}
    void
texit(void)
{
8010488b:	55                   	push   %ebp
8010488c:	89 e5                	mov    %esp,%ebp
8010488e:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
80104891:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104898:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010489d:	39 c2                	cmp    %eax,%edx
8010489f:	75 0c                	jne    801048ad <texit+0x22>
        panic("init exiting");
801048a1:	c7 04 24 a7 8c 10 80 	movl   $0x80108ca7,(%esp)
801048a8:	e8 8d bc ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801048ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801048b4:	eb 44                	jmp    801048fa <texit+0x6f>
        if(proc->ofile[fd]){
801048b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048bf:	83 c2 08             	add    $0x8,%edx
801048c2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048c6:	85 c0                	test   %eax,%eax
801048c8:	74 2c                	je     801048f6 <texit+0x6b>
            fileclose(proc->ofile[fd]);
801048ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048d3:	83 c2 08             	add    $0x8,%edx
801048d6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048da:	89 04 24             	mov    %eax,(%esp)
801048dd:	e8 e4 c6 ff ff       	call   80100fc6 <fileclose>
            proc->ofile[fd] = 0;
801048e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048eb:	83 c2 08             	add    $0x8,%edx
801048ee:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048f5:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801048f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801048fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048fe:	7e b6                	jle    801048b6 <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
80104900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104906:	8b 40 68             	mov    0x68(%eax),%eax
80104909:	89 04 24             	mov    %eax,(%esp)
8010490c:	e8 f5 d0 ff ff       	call   80101a06 <iput>
    proc->cwd = 0;
80104911:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104917:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
8010491e:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104925:	e8 e0 09 00 00       	call   8010530a <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
8010492a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104930:	8b 40 14             	mov    0x14(%eax),%eax
80104933:	89 04 24             	mov    %eax,(%esp)
80104936:	e8 ad 03 00 00       	call   80104ce8 <wakeup1>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
8010493b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104941:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104948:	e8 c7 01 00 00       	call   80104b14 <sched>
    panic("zombie exit");
8010494d:	c7 04 24 b4 8c 10 80 	movl   $0x80108cb4,(%esp)
80104954:	e8 e1 bb ff ff       	call   8010053a <panic>

80104959 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80104959:	55                   	push   %ebp
8010495a:	89 e5                	mov    %esp,%ebp
8010495c:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
8010495f:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104966:	e8 9f 09 00 00       	call   8010530a <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
8010496b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104972:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104979:	e9 ab 00 00 00       	jmp    80104a29 <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
8010497e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104981:	8b 50 14             	mov    0x14(%eax),%edx
80104984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498a:	39 c2                	cmp    %eax,%edx
8010498c:	74 05                	je     80104993 <wait+0x3a>
                continue;
8010498e:	e9 8f 00 00 00       	jmp    80104a22 <wait+0xc9>
            havekids = 1;
80104993:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
8010499a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010499d:	8b 40 0c             	mov    0xc(%eax),%eax
801049a0:	83 f8 05             	cmp    $0x5,%eax
801049a3:	75 7d                	jne    80104a22 <wait+0xc9>
                // Found one.
                pid = p->pid;
801049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a8:	8b 40 10             	mov    0x10(%eax),%eax
801049ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
801049ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b1:	8b 40 08             	mov    0x8(%eax),%eax
801049b4:	89 04 24             	mov    %eax,(%esp)
801049b7:	e8 85 e0 ff ff       	call   80102a41 <kfree>
                p->kstack = 0;
801049bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
801049c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801049cf:	83 f8 01             	cmp    $0x1,%eax
801049d2:	74 0e                	je     801049e2 <wait+0x89>
                    freevm(p->pgdir);
801049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d7:	8b 40 04             	mov    0x4(%eax),%eax
801049da:	89 04 24             	mov    %eax,(%esp)
801049dd:	e8 b9 3c 00 00       	call   8010869b <freevm>
                }
                p->state = UNUSED;
801049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
801049ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ef:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
801049f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a03:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104a11:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104a18:	e8 4f 09 00 00       	call   8010536c <release>
                return pid;
80104a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a20:	eb 55                	jmp    80104a77 <wait+0x11e>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a22:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a29:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
80104a30:	0f 82 48 ff ff ff    	jb     8010497e <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80104a36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a3a:	74 0d                	je     80104a49 <wait+0xf0>
80104a3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a42:	8b 40 24             	mov    0x24(%eax),%eax
80104a45:	85 c0                	test   %eax,%eax
80104a47:	74 13                	je     80104a5c <wait+0x103>
            release(&ptable.lock);
80104a49:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104a50:	e8 17 09 00 00       	call   8010536c <release>
            return -1;
80104a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a5a:	eb 1b                	jmp    80104a77 <wait+0x11e>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a62:	c7 44 24 04 40 0f 11 	movl   $0x80110f40,0x4(%esp)
80104a69:	80 
80104a6a:	89 04 24             	mov    %eax,(%esp)
80104a6d:	e8 db 01 00 00       	call   80104c4d <sleep>
    }
80104a72:	e9 f4 fe ff ff       	jmp    8010496b <wait+0x12>
}
80104a77:	c9                   	leave  
80104a78:	c3                   	ret    

80104a79 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104a79:	55                   	push   %ebp
80104a7a:	89 e5                	mov    %esp,%ebp
80104a7c:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104a7f:	e8 ee f5 ff ff       	call   80104072 <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104a84:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104a8b:	e8 7a 08 00 00       	call   8010530a <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a90:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104a97:	eb 61                	jmp    80104afa <scheduler+0x81>
            if(p->state != RUNNABLE)
80104a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9f:	83 f8 03             	cmp    $0x3,%eax
80104aa2:	74 02                	je     80104aa6 <scheduler+0x2d>
                continue;
80104aa4:	eb 4d                	jmp    80104af3 <scheduler+0x7a>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa9:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
80104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab2:	89 04 24             	mov    %eax,(%esp)
80104ab5:	e8 6e 37 00 00       	call   80108228 <switchuvm>
            p->state = RUNNING;
80104aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abd:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104ac4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aca:	8b 40 1c             	mov    0x1c(%eax),%eax
80104acd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ad4:	83 c2 04             	add    $0x4,%edx
80104ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104adb:	89 14 24             	mov    %edx,(%esp)
80104ade:	e8 0c 0d 00 00       	call   801057ef <swtch>
            switchkvm();
80104ae3:	e8 23 37 00 00       	call   8010820b <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104ae8:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104aef:	00 00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104af3:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104afa:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
80104b01:	72 96                	jb     80104a99 <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104b03:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104b0a:	e8 5d 08 00 00       	call   8010536c <release>

    }
80104b0f:	e9 6b ff ff ff       	jmp    80104a7f <scheduler+0x6>

80104b14 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104b1a:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104b21:	e8 0e 09 00 00       	call   80105434 <holding>
80104b26:	85 c0                	test   %eax,%eax
80104b28:	75 0c                	jne    80104b36 <sched+0x22>
        panic("sched ptable.lock");
80104b2a:	c7 04 24 c0 8c 10 80 	movl   $0x80108cc0,(%esp)
80104b31:	e8 04 ba ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104b36:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b3c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b42:	83 f8 01             	cmp    $0x1,%eax
80104b45:	74 35                	je     80104b7c <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104b47:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b4d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104b53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b59:	8b 40 10             	mov    0x10(%eax),%eax
80104b5c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b60:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b64:	c7 04 24 d4 8c 10 80 	movl   $0x80108cd4,(%esp)
80104b6b:	e8 30 b8 ff ff       	call   801003a0 <cprintf>
        panic("sched locks");
80104b70:	c7 04 24 f3 8c 10 80 	movl   $0x80108cf3,(%esp)
80104b77:	e8 be b9 ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104b7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b82:	8b 40 0c             	mov    0xc(%eax),%eax
80104b85:	83 f8 04             	cmp    $0x4,%eax
80104b88:	75 0c                	jne    80104b96 <sched+0x82>
        panic("sched running");
80104b8a:	c7 04 24 ff 8c 10 80 	movl   $0x80108cff,(%esp)
80104b91:	e8 a4 b9 ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104b96:	e8 c7 f4 ff ff       	call   80104062 <readeflags>
80104b9b:	25 00 02 00 00       	and    $0x200,%eax
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	74 0c                	je     80104bb0 <sched+0x9c>
        panic("sched interruptible");
80104ba4:	c7 04 24 0d 8d 10 80 	movl   $0x80108d0d,(%esp)
80104bab:	e8 8a b9 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104bb0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bb6:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104bbf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bc5:	8b 40 04             	mov    0x4(%eax),%eax
80104bc8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bcf:	83 c2 1c             	add    $0x1c,%edx
80104bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd6:	89 14 24             	mov    %edx,(%esp)
80104bd9:	e8 11 0c 00 00       	call   801057ef <swtch>
    cpu->intena = intena;
80104bde:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104be7:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104bed:	c9                   	leave  
80104bee:	c3                   	ret    

80104bef <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104bef:	55                   	push   %ebp
80104bf0:	89 e5                	mov    %esp,%ebp
80104bf2:	83 ec 18             	sub    $0x18,%esp
    //cprintf("Yielded\n");
    acquire(&ptable.lock);  //DOC: yieldlock
80104bf5:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104bfc:	e8 09 07 00 00       	call   8010530a <acquire>
    proc->state = RUNNABLE;
80104c01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c07:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104c0e:	e8 01 ff ff ff       	call   80104b14 <sched>
    release(&ptable.lock);
80104c13:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104c1a:	e8 4d 07 00 00       	call   8010536c <release>
}
80104c1f:	c9                   	leave  
80104c20:	c3                   	ret    

80104c21 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104c21:	55                   	push   %ebp
80104c22:	89 e5                	mov    %esp,%ebp
80104c24:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104c27:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104c2e:	e8 39 07 00 00       	call   8010536c <release>

    if (first) {
80104c33:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104c38:	85 c0                	test   %eax,%eax
80104c3a:	74 0f                	je     80104c4b <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104c3c:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104c43:	00 00 00 
        initlog();
80104c46:	e8 6a e4 ff ff       	call   801030b5 <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104c4b:	c9                   	leave  
80104c4c:	c3                   	ret    

80104c4d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104c4d:	55                   	push   %ebp
80104c4e:	89 e5                	mov    %esp,%ebp
80104c50:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104c53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	75 0c                	jne    80104c69 <sleep+0x1c>
        panic("sleep");
80104c5d:	c7 04 24 21 8d 10 80 	movl   $0x80108d21,(%esp)
80104c64:	e8 d1 b8 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104c69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c6d:	75 0c                	jne    80104c7b <sleep+0x2e>
        panic("sleep without lk");
80104c6f:	c7 04 24 27 8d 10 80 	movl   $0x80108d27,(%esp)
80104c76:	e8 bf b8 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104c7b:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
80104c82:	74 17                	je     80104c9b <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104c84:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104c8b:	e8 7a 06 00 00       	call   8010530a <acquire>
        release(lk);
80104c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c93:	89 04 24             	mov    %eax,(%esp)
80104c96:	e8 d1 06 00 00       	call   8010536c <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104c9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca1:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca4:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104ca7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cad:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104cb4:	e8 5b fe ff ff       	call   80104b14 <sched>

    // Tidy up.
    proc->chan = 0;
80104cb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cbf:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104cc6:	81 7d 0c 40 0f 11 80 	cmpl   $0x80110f40,0xc(%ebp)
80104ccd:	74 17                	je     80104ce6 <sleep+0x99>
        release(&ptable.lock);
80104ccf:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104cd6:	e8 91 06 00 00       	call   8010536c <release>
        acquire(lk);
80104cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cde:	89 04 24             	mov    %eax,(%esp)
80104ce1:	e8 24 06 00 00       	call   8010530a <acquire>
    }
}
80104ce6:	c9                   	leave  
80104ce7:	c3                   	ret    

80104ce8 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104ce8:	55                   	push   %ebp
80104ce9:	89 e5                	mov    %esp,%ebp
80104ceb:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cee:	c7 45 fc 74 0f 11 80 	movl   $0x80110f74,-0x4(%ebp)
80104cf5:	eb 27                	jmp    80104d1e <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cfa:	8b 40 0c             	mov    0xc(%eax),%eax
80104cfd:	83 f8 02             	cmp    $0x2,%eax
80104d00:	75 15                	jne    80104d17 <wakeup1+0x2f>
80104d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d05:	8b 40 20             	mov    0x20(%eax),%eax
80104d08:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d0b:	75 0a                	jne    80104d17 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d10:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d17:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104d1e:	81 7d fc 74 30 11 80 	cmpl   $0x80113074,-0x4(%ebp)
80104d25:	72 d0                	jb     80104cf7 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104d27:	c9                   	leave  
80104d28:	c3                   	ret    

80104d29 <twakeup>:

void 
twakeup(int tid){
80104d29:	55                   	push   %ebp
80104d2a:	89 e5                	mov    %esp,%ebp
80104d2c:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104d2f:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104d36:	e8 cf 05 00 00       	call   8010530a <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d3b:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104d42:	eb 36                	jmp    80104d7a <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d47:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4a:	83 f8 02             	cmp    $0x2,%eax
80104d4d:	75 24                	jne    80104d73 <twakeup+0x4a>
80104d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d52:	8b 40 10             	mov    0x10(%eax),%eax
80104d55:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d58:	75 19                	jne    80104d73 <twakeup+0x4a>
80104d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104d63:	83 f8 01             	cmp    $0x1,%eax
80104d66:	75 0b                	jne    80104d73 <twakeup+0x4a>
            wakeup1(p);
80104d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6b:	89 04 24             	mov    %eax,(%esp)
80104d6e:	e8 75 ff ff ff       	call   80104ce8 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d73:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104d7a:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
80104d81:	72 c1                	jb     80104d44 <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104d83:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104d8a:	e8 dd 05 00 00       	call   8010536c <release>
}
80104d8f:	c9                   	leave  
80104d90:	c3                   	ret    

80104d91 <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104d91:	55                   	push   %ebp
80104d92:	89 e5                	mov    %esp,%ebp
80104d94:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104d97:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104d9e:	e8 67 05 00 00       	call   8010530a <acquire>
    wakeup1(chan);
80104da3:	8b 45 08             	mov    0x8(%ebp),%eax
80104da6:	89 04 24             	mov    %eax,(%esp)
80104da9:	e8 3a ff ff ff       	call   80104ce8 <wakeup1>
    release(&ptable.lock);
80104dae:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104db5:	e8 b2 05 00 00       	call   8010536c <release>
}
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    

80104dbc <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104dbc:	55                   	push   %ebp
80104dbd:	89 e5                	mov    %esp,%ebp
80104dbf:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104dc2:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104dc9:	e8 3c 05 00 00       	call   8010530a <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dce:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80104dd5:	eb 44                	jmp    80104e1b <kill+0x5f>
        if(p->pid == pid){
80104dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dda:	8b 40 10             	mov    0x10(%eax),%eax
80104ddd:	3b 45 08             	cmp    0x8(%ebp),%eax
80104de0:	75 32                	jne    80104e14 <kill+0x58>
            p->killed = 1;
80104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104def:	8b 40 0c             	mov    0xc(%eax),%eax
80104df2:	83 f8 02             	cmp    $0x2,%eax
80104df5:	75 0a                	jne    80104e01 <kill+0x45>
                p->state = RUNNABLE;
80104df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104e01:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104e08:	e8 5f 05 00 00       	call   8010536c <release>
            return 0;
80104e0d:	b8 00 00 00 00       	mov    $0x0,%eax
80104e12:	eb 21                	jmp    80104e35 <kill+0x79>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e14:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104e1b:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
80104e22:	72 b3                	jb     80104dd7 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104e24:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104e2b:	e8 3c 05 00 00       	call   8010536c <release>
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    

80104e37 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104e37:	55                   	push   %ebp
80104e38:	89 e5                	mov    %esp,%ebp
80104e3a:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e3d:	c7 45 f0 74 0f 11 80 	movl   $0x80110f74,-0x10(%ebp)
80104e44:	e9 d9 00 00 00       	jmp    80104f22 <procdump+0xeb>
        if(p->state == UNUSED)
80104e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4c:	8b 40 0c             	mov    0xc(%eax),%eax
80104e4f:	85 c0                	test   %eax,%eax
80104e51:	75 05                	jne    80104e58 <procdump+0x21>
            continue;
80104e53:	e9 c3 00 00 00       	jmp    80104f1b <procdump+0xe4>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e5e:	83 f8 05             	cmp    $0x5,%eax
80104e61:	77 23                	ja     80104e86 <procdump+0x4f>
80104e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e66:	8b 40 0c             	mov    0xc(%eax),%eax
80104e69:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104e70:	85 c0                	test   %eax,%eax
80104e72:	74 12                	je     80104e86 <procdump+0x4f>
            state = states[p->state];
80104e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e77:	8b 40 0c             	mov    0xc(%eax),%eax
80104e7a:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e84:	eb 07                	jmp    80104e8d <procdump+0x56>
        else
            state = "???";
80104e86:	c7 45 ec 38 8d 10 80 	movl   $0x80108d38,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80104e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e90:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e96:	8b 40 10             	mov    0x10(%eax),%eax
80104e99:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104e9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ea0:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea8:	c7 04 24 3c 8d 10 80 	movl   $0x80108d3c,(%esp)
80104eaf:	e8 ec b4 ff ff       	call   801003a0 <cprintf>
        if(p->state == SLEEPING){
80104eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb7:	8b 40 0c             	mov    0xc(%eax),%eax
80104eba:	83 f8 02             	cmp    $0x2,%eax
80104ebd:	75 50                	jne    80104f0f <procdump+0xd8>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80104ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ec2:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ec5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec8:	83 c0 08             	add    $0x8,%eax
80104ecb:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104ece:	89 54 24 04          	mov    %edx,0x4(%esp)
80104ed2:	89 04 24             	mov    %eax,(%esp)
80104ed5:	e8 e1 04 00 00       	call   801053bb <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
80104eda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ee1:	eb 1b                	jmp    80104efe <procdump+0xc7>
                cprintf(" %p", pc[i]);
80104ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eea:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eee:	c7 04 24 45 8d 10 80 	movl   $0x80108d45,(%esp)
80104ef5:	e8 a6 b4 ff ff       	call   801003a0 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80104efa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104efe:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104f02:	7f 0b                	jg     80104f0f <procdump+0xd8>
80104f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f07:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	75 d4                	jne    80104ee3 <procdump+0xac>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104f0f:	c7 04 24 49 8d 10 80 	movl   $0x80108d49,(%esp)
80104f16:	e8 85 b4 ff ff       	call   801003a0 <cprintf>
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f1b:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104f22:	81 7d f0 74 30 11 80 	cmpl   $0x80113074,-0x10(%ebp)
80104f29:	0f 82 1a ff ff ff    	jb     80104e49 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104f2f:	c9                   	leave  
80104f30:	c3                   	ret    

80104f31 <tsleep>:

void tsleep(void){
80104f31:	55                   	push   %ebp
80104f32:	89 e5                	mov    %esp,%ebp
80104f34:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
80104f37:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104f3e:	e8 c7 03 00 00       	call   8010530a <acquire>
    sleep(proc, &ptable.lock);
80104f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f49:	c7 44 24 04 40 0f 11 	movl   $0x80110f40,0x4(%esp)
80104f50:	80 
80104f51:	89 04 24             	mov    %eax,(%esp)
80104f54:	e8 f4 fc ff ff       	call   80104c4d <sleep>
    release(&ptable.lock);
80104f59:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
80104f60:	e8 07 04 00 00       	call   8010536c <release>

}
80104f65:	c9                   	leave  
80104f66:	c3                   	ret    

80104f67 <init_q2>:
struct queue2{
    int size;
    struct node2 * head;
    struct node2 * tail;
};
void init_q2(struct queue2 *q){
80104f67:	55                   	push   %ebp
80104f68:	89 e5                	mov    %esp,%ebp
    q->size = 0;
80104f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
80104f73:	8b 45 08             	mov    0x8(%ebp),%eax
80104f76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
80104f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f87:	5d                   	pop    %ebp
80104f88:	c3                   	ret    

80104f89 <add_q2>:
void add_q2(struct queue2 *q, struct proc *v){
80104f89:	55                   	push   %ebp
80104f8a:	89 e5                	mov    %esp,%ebp
80104f8c:	83 ec 18             	sub    $0x18,%esp
    struct node2 * n = kalloc2();
80104f8f:	e8 93 db ff ff       	call   80102b27 <kalloc2>
80104f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
80104f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
80104fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fa7:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
80104fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fac:	8b 40 04             	mov    0x4(%eax),%eax
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	75 0b                	jne    80104fbe <add_q2+0x35>
        q->head = n;
80104fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb9:	89 50 04             	mov    %edx,0x4(%eax)
80104fbc:	eb 0c                	jmp    80104fca <add_q2+0x41>
    }else{
        q->tail->next = n;
80104fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc1:	8b 40 08             	mov    0x8(%eax),%eax
80104fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc7:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
80104fca:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd0:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
80104fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd6:	8b 00                	mov    (%eax),%eax
80104fd8:	8d 50 01             	lea    0x1(%eax),%edx
80104fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fde:	89 10                	mov    %edx,(%eax)
}
80104fe0:	c9                   	leave  
80104fe1:	c3                   	ret    

80104fe2 <empty_q2>:
int empty_q2(struct queue2 *q){
80104fe2:	55                   	push   %ebp
80104fe3:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
80104fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe8:	8b 00                	mov    (%eax),%eax
80104fea:	85 c0                	test   %eax,%eax
80104fec:	75 07                	jne    80104ff5 <empty_q2+0x13>
        return 1;
80104fee:	b8 01 00 00 00       	mov    $0x1,%eax
80104ff3:	eb 05                	jmp    80104ffa <empty_q2+0x18>
    else
        return 0;
80104ff5:	b8 00 00 00 00       	mov    $0x0,%eax
} 
80104ffa:	5d                   	pop    %ebp
80104ffb:	c3                   	ret    

80104ffc <pop_q2>:
struct proc* pop_q2(struct queue2 *q){
80104ffc:	55                   	push   %ebp
80104ffd:	89 e5                	mov    %esp,%ebp
80104fff:	83 ec 28             	sub    $0x28,%esp
    struct proc *val;
    struct node2 *destroy;
    if(!empty_q2(q)){
80105002:	8b 45 08             	mov    0x8(%ebp),%eax
80105005:	89 04 24             	mov    %eax,(%esp)
80105008:	e8 d5 ff ff ff       	call   80104fe2 <empty_q2>
8010500d:	85 c0                	test   %eax,%eax
8010500f:	75 5d                	jne    8010506e <pop_q2+0x72>
       val = q->head->value; 
80105011:	8b 45 08             	mov    0x8(%ebp),%eax
80105014:	8b 40 04             	mov    0x4(%eax),%eax
80105017:	8b 00                	mov    (%eax),%eax
80105019:	89 45 f4             	mov    %eax,-0xc(%ebp)
       destroy = q->head;
8010501c:	8b 45 08             	mov    0x8(%ebp),%eax
8010501f:	8b 40 04             	mov    0x4(%eax),%eax
80105022:	89 45 f0             	mov    %eax,-0x10(%ebp)
       q->head = q->head->next;
80105025:	8b 45 08             	mov    0x8(%ebp),%eax
80105028:	8b 40 04             	mov    0x4(%eax),%eax
8010502b:	8b 50 04             	mov    0x4(%eax),%edx
8010502e:	8b 45 08             	mov    0x8(%ebp),%eax
80105031:	89 50 04             	mov    %edx,0x4(%eax)
       kfree2(destroy);
80105034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105037:	89 04 24             	mov    %eax,(%esp)
8010503a:	e8 35 db ff ff       	call   80102b74 <kfree2>
       q->size--;
8010503f:	8b 45 08             	mov    0x8(%ebp),%eax
80105042:	8b 00                	mov    (%eax),%eax
80105044:	8d 50 ff             	lea    -0x1(%eax),%edx
80105047:	8b 45 08             	mov    0x8(%ebp),%eax
8010504a:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
8010504c:	8b 45 08             	mov    0x8(%ebp),%eax
8010504f:	8b 00                	mov    (%eax),%eax
80105051:	85 c0                	test   %eax,%eax
80105053:	75 14                	jne    80105069 <pop_q2+0x6d>
            q->head = 0;
80105055:	8b 45 08             	mov    0x8(%ebp),%eax
80105058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
8010505f:	8b 45 08             	mov    0x8(%ebp),%eax
80105062:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
80105069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506c:	eb 05                	jmp    80105073 <pop_q2+0x77>
    }
    return 0;
8010506e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105073:	c9                   	leave  
80105074:	c3                   	ret    

80105075 <thread_yield>:
void thread_yield(void){
80105075:	55                   	push   %ebp
80105076:	89 e5                	mov    %esp,%ebp
80105078:	53                   	push   %ebx
80105079:	83 ec 34             	sub    $0x34,%esp
    
    static struct queue2 *thQ;
    struct proc *p;
    struct proc *old;
    //struct proc *curr;
    int pid = proc->pid;
8010507c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105082:	8b 40 10             	mov    0x10(%eax),%eax
80105085:	89 45 f0             	mov    %eax,-0x10(%ebp)
    static int acq = 0;
    cprintf("ACQ: %d", acq);
80105088:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010508d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105091:	c7 04 24 4b 8d 10 80 	movl   $0x80108d4b,(%esp)
80105098:	e8 03 b3 ff ff       	call   801003a0 <cprintf>
    if (acq == 0) {
8010509d:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801050a2:	85 c0                	test   %eax,%eax
801050a4:	75 1a                	jne    801050c0 <thread_yield+0x4b>
        init_q2(thQ);
801050a6:	a1 70 c6 10 80       	mov    0x8010c670,%eax
801050ab:	89 04 24             	mov    %eax,(%esp)
801050ae:	e8 b4 fe ff ff       	call   80104f67 <init_q2>
        //acquire(&ptable.lock); 
        acq++;
801050b3:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801050b8:	83 c0 01             	add    $0x1,%eax
801050bb:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
    }
    if (!holding(&ptable.lock)) {
801050c0:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801050c7:	e8 68 03 00 00       	call   80105434 <holding>
801050cc:	85 c0                	test   %eax,%eax
801050ce:	75 18                	jne    801050e8 <thread_yield+0x73>
        acquire(&ptable.lock); 
801050d0:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
801050d7:	e8 2e 02 00 00       	call   8010530a <acquire>
        cprintf(" ACQUIRED\n");
801050dc:	c7 04 24 53 8d 10 80 	movl   $0x80108d53,(%esp)
801050e3:	e8 b8 b2 ff ff       	call   801003a0 <cprintf>
    }
    cprintf("Curr %d%d%d\n", proc->isthread, proc->state, proc->pid);
801050e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050ee:	8b 48 10             	mov    0x10(%eax),%ecx
801050f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f7:	8b 50 0c             	mov    0xc(%eax),%edx
801050fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105100:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105106:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010510a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010510e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105112:	c7 04 24 5e 8d 10 80 	movl   $0x80108d5e,(%esp)
80105119:	e8 82 b2 ff ff       	call   801003a0 <cprintf>
    if(empty_q2(thQ)) {
8010511e:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80105123:	89 04 24             	mov    %eax,(%esp)
80105126:	e8 b7 fe ff ff       	call   80104fe2 <empty_q2>
8010512b:	85 c0                	test   %eax,%eax
8010512d:	74 75                	je     801051a4 <thread_yield+0x12f>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010512f:	c7 45 f4 74 0f 11 80 	movl   $0x80110f74,-0xc(%ebp)
80105136:	eb 63                	jmp    8010519b <thread_yield+0x126>
            cprintf(" %d%d%d", p->isthread, p->state, p->pid);
80105138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513b:	8b 48 10             	mov    0x10(%eax),%ecx
8010513e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105141:	8b 50 0c             	mov    0xc(%eax),%edx
80105144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105147:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010514d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105151:	89 54 24 08          	mov    %edx,0x8(%esp)
80105155:	89 44 24 04          	mov    %eax,0x4(%esp)
80105159:	c7 04 24 6b 8d 10 80 	movl   $0x80108d6b,(%esp)
80105160:	e8 3b b2 ff ff       	call   801003a0 <cprintf>
            if ((p->state == RUNNABLE) && (p->isthread == 1)) {
80105165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105168:	8b 40 0c             	mov    0xc(%eax),%eax
8010516b:	83 f8 03             	cmp    $0x3,%eax
8010516e:	75 24                	jne    80105194 <thread_yield+0x11f>
80105170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105173:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105179:	83 f8 01             	cmp    $0x1,%eax
8010517c:	75 16                	jne    80105194 <thread_yield+0x11f>
                add_q2(thQ, p);
8010517e:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80105183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105186:	89 54 24 04          	mov    %edx,0x4(%esp)
8010518a:	89 04 24             	mov    %eax,(%esp)
8010518d:	e8 f7 fd ff ff       	call   80104f89 <add_q2>
                break;
80105192:	eb 10                	jmp    801051a4 <thread_yield+0x12f>
        acquire(&ptable.lock); 
        cprintf(" ACQUIRED\n");
    }
    cprintf("Curr %d%d%d\n", proc->isthread, proc->state, proc->pid);
    if(empty_q2(thQ)) {
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105194:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010519b:	81 7d f4 74 30 11 80 	cmpl   $0x80113074,-0xc(%ebp)
801051a2:	72 94                	jb     80105138 <thread_yield+0xc3>
                add_q2(thQ, p);
                break;
            }
        }
    }
    p = pop_q2(thQ);
801051a4:	a1 70 c6 10 80       	mov    0x8010c670,%eax
801051a9:	89 04 24             	mov    %eax,(%esp)
801051ac:	e8 4b fe ff ff       	call   80104ffc <pop_q2>
801051b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("\nBefore %d %d %d %d\n%d\n",pid, p->isthread, p->state, p->pid,p);
801051b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b7:	8b 48 10             	mov    0x10(%eax),%ecx
801051ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bd:	8b 50 0c             	mov    0xc(%eax),%edx
801051c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801051c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801051cc:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801051d0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801051d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
801051d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801051dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051df:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e3:	c7 04 24 73 8d 10 80 	movl   $0x80108d73,(%esp)
801051ea:	e8 b1 b1 ff ff       	call   801003a0 <cprintf>
    proc->state = RUNNABLE;
801051ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    old = proc;
801051fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105202:	89 45 ec             	mov    %eax,-0x14(%ebp)
    add_q2(thQ, old);
80105205:	a1 70 c6 10 80       	mov    0x8010c670,%eax
8010520a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010520d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105211:	89 04 24             	mov    %eax,(%esp)
80105214:	e8 70 fd ff ff       	call   80104f89 <add_q2>
    p->state = RUNNING;
80105219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    proc = p;
80105223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105226:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
    cprintf("HERE?\n");
8010522c:	c7 04 24 8b 8d 10 80 	movl   $0x80108d8b,(%esp)
80105233:	e8 68 b1 ff ff       	call   801003a0 <cprintf>
    swtch(&old->context, proc->context);
80105238:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010523e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105241:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105244:	83 c2 1c             	add    $0x1c,%edx
80105247:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524b:	89 14 24             	mov    %edx,(%esp)
8010524e:	e8 9c 05 00 00       	call   801057ef <swtch>
    //swtch(&old->context, p->context);
    //swtch(&old->context, cpu->scheduler);
    swtch(&cpu->scheduler, proc->context);
80105253:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105259:	8b 40 1c             	mov    0x1c(%eax),%eax
8010525c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105263:	83 c2 04             	add    $0x4,%edx
80105266:	89 44 24 04          	mov    %eax,0x4(%esp)
8010526a:	89 14 24             	mov    %edx,(%esp)
8010526d:	e8 7d 05 00 00       	call   801057ef <swtch>
    cprintf("After %d\n", pid);
80105272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105275:	89 44 24 04          	mov    %eax,0x4(%esp)
80105279:	c7 04 24 92 8d 10 80 	movl   $0x80108d92,(%esp)
80105280:	e8 1b b1 ff ff       	call   801003a0 <cprintf>
    if (holding(&ptable.lock)) {
80105285:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010528c:	e8 a3 01 00 00       	call   80105434 <holding>
80105291:	85 c0                	test   %eax,%eax
80105293:	74 18                	je     801052ad <thread_yield+0x238>
        release(&ptable.lock); 
80105295:	c7 04 24 40 0f 11 80 	movl   $0x80110f40,(%esp)
8010529c:	e8 cb 00 00 00       	call   8010536c <release>
        cprintf("RELEASED\n");
801052a1:	c7 04 24 9c 8d 10 80 	movl   $0x80108d9c,(%esp)
801052a8:	e8 f3 b0 ff ff       	call   801003a0 <cprintf>
    }
    //release(&ptable.lock);
    
}
801052ad:	83 c4 34             	add    $0x34,%esp
801052b0:	5b                   	pop    %ebx
801052b1:	5d                   	pop    %ebp
801052b2:	c3                   	ret    

801052b3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801052b3:	55                   	push   %ebp
801052b4:	89 e5                	mov    %esp,%ebp
801052b6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801052b9:	9c                   	pushf  
801052ba:	58                   	pop    %eax
801052bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801052be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052c1:	c9                   	leave  
801052c2:	c3                   	ret    

801052c3 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801052c3:	55                   	push   %ebp
801052c4:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801052c6:	fa                   	cli    
}
801052c7:	5d                   	pop    %ebp
801052c8:	c3                   	ret    

801052c9 <sti>:

static inline void
sti(void)
{
801052c9:	55                   	push   %ebp
801052ca:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801052cc:	fb                   	sti    
}
801052cd:	5d                   	pop    %ebp
801052ce:	c3                   	ret    

801052cf <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801052cf:	55                   	push   %ebp
801052d0:	89 e5                	mov    %esp,%ebp
801052d2:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801052d5:	8b 55 08             	mov    0x8(%ebp),%edx
801052d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052de:	f0 87 02             	lock xchg %eax,(%edx)
801052e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801052e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052e7:	c9                   	leave  
801052e8:	c3                   	ret    

801052e9 <initlock>:
#include "spinlock.h"
//#include "semaphore.h"

void
initlock(struct spinlock *lk, char *name)
{
801052e9:	55                   	push   %ebp
801052ea:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052ec:	8b 45 08             	mov    0x8(%ebp),%eax
801052ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801052f2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052f5:	8b 45 08             	mov    0x8(%ebp),%eax
801052f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105301:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105308:	5d                   	pop    %ebp
80105309:	c3                   	ret    

8010530a <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010530a:	55                   	push   %ebp
8010530b:	89 e5                	mov    %esp,%ebp
8010530d:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105310:	e8 49 01 00 00       	call   8010545e <pushcli>
  if(holding(lk))
80105315:	8b 45 08             	mov    0x8(%ebp),%eax
80105318:	89 04 24             	mov    %eax,(%esp)
8010531b:	e8 14 01 00 00       	call   80105434 <holding>
80105320:	85 c0                	test   %eax,%eax
80105322:	74 0c                	je     80105330 <acquire+0x26>
    panic("acquire in spinlock.c");
80105324:	c7 04 24 d0 8d 10 80 	movl   $0x80108dd0,(%esp)
8010532b:	e8 0a b2 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105330:	90                   	nop
80105331:	8b 45 08             	mov    0x8(%ebp),%eax
80105334:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010533b:	00 
8010533c:	89 04 24             	mov    %eax,(%esp)
8010533f:	e8 8b ff ff ff       	call   801052cf <xchg>
80105344:	85 c0                	test   %eax,%eax
80105346:	75 e9                	jne    80105331 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105348:	8b 45 08             	mov    0x8(%ebp),%eax
8010534b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105352:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105355:	8b 45 08             	mov    0x8(%ebp),%eax
80105358:	83 c0 0c             	add    $0xc,%eax
8010535b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535f:	8d 45 08             	lea    0x8(%ebp),%eax
80105362:	89 04 24             	mov    %eax,(%esp)
80105365:	e8 51 00 00 00       	call   801053bb <getcallerpcs>
}
8010536a:	c9                   	leave  
8010536b:	c3                   	ret    

8010536c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010536c:	55                   	push   %ebp
8010536d:	89 e5                	mov    %esp,%ebp
8010536f:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
80105375:	89 04 24             	mov    %eax,(%esp)
80105378:	e8 b7 00 00 00       	call   80105434 <holding>
8010537d:	85 c0                	test   %eax,%eax
8010537f:	75 0c                	jne    8010538d <release+0x21>
    panic("release in spinlock.c");
80105381:	c7 04 24 e6 8d 10 80 	movl   $0x80108de6,(%esp)
80105388:	e8 ad b1 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
8010538d:	8b 45 08             	mov    0x8(%ebp),%eax
80105390:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105397:	8b 45 08             	mov    0x8(%ebp),%eax
8010539a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801053a1:	8b 45 08             	mov    0x8(%ebp),%eax
801053a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801053ab:	00 
801053ac:	89 04 24             	mov    %eax,(%esp)
801053af:	e8 1b ff ff ff       	call   801052cf <xchg>

  popcli();
801053b4:	e8 e9 00 00 00       	call   801054a2 <popcli>
}
801053b9:	c9                   	leave  
801053ba:	c3                   	ret    

801053bb <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801053bb:	55                   	push   %ebp
801053bc:	89 e5                	mov    %esp,%ebp
801053be:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801053c1:	8b 45 08             	mov    0x8(%ebp),%eax
801053c4:	83 e8 08             	sub    $0x8,%eax
801053c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801053ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801053d1:	eb 38                	jmp    8010540b <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801053d7:	74 38                	je     80105411 <getcallerpcs+0x56>
801053d9:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801053e0:	76 2f                	jbe    80105411 <getcallerpcs+0x56>
801053e2:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053e6:	74 29                	je     80105411 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f5:	01 c2                	add    %eax,%edx
801053f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fa:	8b 40 04             	mov    0x4(%eax),%eax
801053fd:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105402:	8b 00                	mov    (%eax),%eax
80105404:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105407:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010540b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010540f:	7e c2                	jle    801053d3 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105411:	eb 19                	jmp    8010542c <getcallerpcs+0x71>
    pcs[i] = 0;
80105413:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105416:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010541d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105420:	01 d0                	add    %edx,%eax
80105422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105428:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010542c:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105430:	7e e1                	jle    80105413 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105432:	c9                   	leave  
80105433:	c3                   	ret    

80105434 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105437:	8b 45 08             	mov    0x8(%ebp),%eax
8010543a:	8b 00                	mov    (%eax),%eax
8010543c:	85 c0                	test   %eax,%eax
8010543e:	74 17                	je     80105457 <holding+0x23>
80105440:	8b 45 08             	mov    0x8(%ebp),%eax
80105443:	8b 50 08             	mov    0x8(%eax),%edx
80105446:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010544c:	39 c2                	cmp    %eax,%edx
8010544e:	75 07                	jne    80105457 <holding+0x23>
80105450:	b8 01 00 00 00       	mov    $0x1,%eax
80105455:	eb 05                	jmp    8010545c <holding+0x28>
80105457:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    

8010545e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010545e:	55                   	push   %ebp
8010545f:	89 e5                	mov    %esp,%ebp
80105461:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105464:	e8 4a fe ff ff       	call   801052b3 <readeflags>
80105469:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010546c:	e8 52 fe ff ff       	call   801052c3 <cli>
  if(cpu->ncli++ == 0)
80105471:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105478:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010547e:	8d 48 01             	lea    0x1(%eax),%ecx
80105481:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105487:	85 c0                	test   %eax,%eax
80105489:	75 15                	jne    801054a0 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010548b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105491:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105494:	81 e2 00 02 00 00    	and    $0x200,%edx
8010549a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801054a0:	c9                   	leave  
801054a1:	c3                   	ret    

801054a2 <popcli>:

void
popcli(void)
{
801054a2:	55                   	push   %ebp
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801054a8:	e8 06 fe ff ff       	call   801052b3 <readeflags>
801054ad:	25 00 02 00 00       	and    $0x200,%eax
801054b2:	85 c0                	test   %eax,%eax
801054b4:	74 0c                	je     801054c2 <popcli+0x20>
    panic("popcli - interruptible");
801054b6:	c7 04 24 fc 8d 10 80 	movl   $0x80108dfc,(%esp)
801054bd:	e8 78 b0 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
801054c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054c8:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054ce:	83 ea 01             	sub    $0x1,%edx
801054d1:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801054d7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054dd:	85 c0                	test   %eax,%eax
801054df:	79 0c                	jns    801054ed <popcli+0x4b>
    panic("popcli");
801054e1:	c7 04 24 13 8e 10 80 	movl   $0x80108e13,(%esp)
801054e8:	e8 4d b0 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054f3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054f9:	85 c0                	test   %eax,%eax
801054fb:	75 15                	jne    80105512 <popcli+0x70>
801054fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105503:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105509:	85 c0                	test   %eax,%eax
8010550b:	74 05                	je     80105512 <popcli+0x70>
    sti();
8010550d:	e8 b7 fd ff ff       	call   801052c9 <sti>
}
80105512:	c9                   	leave  
80105513:	c3                   	ret    

80105514 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105519:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010551c:	8b 55 10             	mov    0x10(%ebp),%edx
8010551f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105522:	89 cb                	mov    %ecx,%ebx
80105524:	89 df                	mov    %ebx,%edi
80105526:	89 d1                	mov    %edx,%ecx
80105528:	fc                   	cld    
80105529:	f3 aa                	rep stos %al,%es:(%edi)
8010552b:	89 ca                	mov    %ecx,%edx
8010552d:	89 fb                	mov    %edi,%ebx
8010552f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105532:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105535:	5b                   	pop    %ebx
80105536:	5f                   	pop    %edi
80105537:	5d                   	pop    %ebp
80105538:	c3                   	ret    

80105539 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105539:	55                   	push   %ebp
8010553a:	89 e5                	mov    %esp,%ebp
8010553c:	57                   	push   %edi
8010553d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010553e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105541:	8b 55 10             	mov    0x10(%ebp),%edx
80105544:	8b 45 0c             	mov    0xc(%ebp),%eax
80105547:	89 cb                	mov    %ecx,%ebx
80105549:	89 df                	mov    %ebx,%edi
8010554b:	89 d1                	mov    %edx,%ecx
8010554d:	fc                   	cld    
8010554e:	f3 ab                	rep stos %eax,%es:(%edi)
80105550:	89 ca                	mov    %ecx,%edx
80105552:	89 fb                	mov    %edi,%ebx
80105554:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105557:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010555a:	5b                   	pop    %ebx
8010555b:	5f                   	pop    %edi
8010555c:	5d                   	pop    %ebp
8010555d:	c3                   	ret    

8010555e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
80105561:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105564:	8b 45 08             	mov    0x8(%ebp),%eax
80105567:	83 e0 03             	and    $0x3,%eax
8010556a:	85 c0                	test   %eax,%eax
8010556c:	75 49                	jne    801055b7 <memset+0x59>
8010556e:	8b 45 10             	mov    0x10(%ebp),%eax
80105571:	83 e0 03             	and    $0x3,%eax
80105574:	85 c0                	test   %eax,%eax
80105576:	75 3f                	jne    801055b7 <memset+0x59>
    c &= 0xFF;
80105578:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010557f:	8b 45 10             	mov    0x10(%ebp),%eax
80105582:	c1 e8 02             	shr    $0x2,%eax
80105585:	89 c2                	mov    %eax,%edx
80105587:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558a:	c1 e0 18             	shl    $0x18,%eax
8010558d:	89 c1                	mov    %eax,%ecx
8010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105592:	c1 e0 10             	shl    $0x10,%eax
80105595:	09 c1                	or     %eax,%ecx
80105597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559a:	c1 e0 08             	shl    $0x8,%eax
8010559d:	09 c8                	or     %ecx,%eax
8010559f:	0b 45 0c             	or     0xc(%ebp),%eax
801055a2:	89 54 24 08          	mov    %edx,0x8(%esp)
801055a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801055aa:	8b 45 08             	mov    0x8(%ebp),%eax
801055ad:	89 04 24             	mov    %eax,(%esp)
801055b0:	e8 84 ff ff ff       	call   80105539 <stosl>
801055b5:	eb 19                	jmp    801055d0 <memset+0x72>
  } else
    stosb(dst, c, n);
801055b7:	8b 45 10             	mov    0x10(%ebp),%eax
801055ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801055be:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055c5:	8b 45 08             	mov    0x8(%ebp),%eax
801055c8:	89 04 24             	mov    %eax,(%esp)
801055cb:	e8 44 ff ff ff       	call   80105514 <stosb>
  return dst;
801055d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055d3:	c9                   	leave  
801055d4:	c3                   	ret    

801055d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801055d5:	55                   	push   %ebp
801055d6:	89 e5                	mov    %esp,%ebp
801055d8:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801055db:	8b 45 08             	mov    0x8(%ebp),%eax
801055de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801055e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055e7:	eb 30                	jmp    80105619 <memcmp+0x44>
    if(*s1 != *s2)
801055e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ec:	0f b6 10             	movzbl (%eax),%edx
801055ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055f2:	0f b6 00             	movzbl (%eax),%eax
801055f5:	38 c2                	cmp    %al,%dl
801055f7:	74 18                	je     80105611 <memcmp+0x3c>
      return *s1 - *s2;
801055f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055fc:	0f b6 00             	movzbl (%eax),%eax
801055ff:	0f b6 d0             	movzbl %al,%edx
80105602:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105605:	0f b6 00             	movzbl (%eax),%eax
80105608:	0f b6 c0             	movzbl %al,%eax
8010560b:	29 c2                	sub    %eax,%edx
8010560d:	89 d0                	mov    %edx,%eax
8010560f:	eb 1a                	jmp    8010562b <memcmp+0x56>
    s1++, s2++;
80105611:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105615:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105619:	8b 45 10             	mov    0x10(%ebp),%eax
8010561c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010561f:	89 55 10             	mov    %edx,0x10(%ebp)
80105622:	85 c0                	test   %eax,%eax
80105624:	75 c3                	jne    801055e9 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105626:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010562b:	c9                   	leave  
8010562c:	c3                   	ret    

8010562d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010562d:	55                   	push   %ebp
8010562e:	89 e5                	mov    %esp,%ebp
80105630:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105633:	8b 45 0c             	mov    0xc(%ebp),%eax
80105636:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105639:	8b 45 08             	mov    0x8(%ebp),%eax
8010563c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010563f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105645:	73 3d                	jae    80105684 <memmove+0x57>
80105647:	8b 45 10             	mov    0x10(%ebp),%eax
8010564a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010564d:	01 d0                	add    %edx,%eax
8010564f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105652:	76 30                	jbe    80105684 <memmove+0x57>
    s += n;
80105654:	8b 45 10             	mov    0x10(%ebp),%eax
80105657:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010565a:	8b 45 10             	mov    0x10(%ebp),%eax
8010565d:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105660:	eb 13                	jmp    80105675 <memmove+0x48>
      *--d = *--s;
80105662:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105666:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010566a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010566d:	0f b6 10             	movzbl (%eax),%edx
80105670:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105673:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105675:	8b 45 10             	mov    0x10(%ebp),%eax
80105678:	8d 50 ff             	lea    -0x1(%eax),%edx
8010567b:	89 55 10             	mov    %edx,0x10(%ebp)
8010567e:	85 c0                	test   %eax,%eax
80105680:	75 e0                	jne    80105662 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105682:	eb 26                	jmp    801056aa <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105684:	eb 17                	jmp    8010569d <memmove+0x70>
      *d++ = *s++;
80105686:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105689:	8d 50 01             	lea    0x1(%eax),%edx
8010568c:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010568f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105692:	8d 4a 01             	lea    0x1(%edx),%ecx
80105695:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105698:	0f b6 12             	movzbl (%edx),%edx
8010569b:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010569d:	8b 45 10             	mov    0x10(%ebp),%eax
801056a0:	8d 50 ff             	lea    -0x1(%eax),%edx
801056a3:	89 55 10             	mov    %edx,0x10(%ebp)
801056a6:	85 c0                	test   %eax,%eax
801056a8:	75 dc                	jne    80105686 <memmove+0x59>
      *d++ = *s++;

  return dst;
801056aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
801056ad:	c9                   	leave  
801056ae:	c3                   	ret    

801056af <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801056af:	55                   	push   %ebp
801056b0:	89 e5                	mov    %esp,%ebp
801056b2:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801056b5:	8b 45 10             	mov    0x10(%ebp),%eax
801056b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801056bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c3:	8b 45 08             	mov    0x8(%ebp),%eax
801056c6:	89 04 24             	mov    %eax,(%esp)
801056c9:	e8 5f ff ff ff       	call   8010562d <memmove>
}
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    

801056d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801056d3:	eb 0c                	jmp    801056e1 <strncmp+0x11>
    n--, p++, q++;
801056d5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801056dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801056e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056e5:	74 1a                	je     80105701 <strncmp+0x31>
801056e7:	8b 45 08             	mov    0x8(%ebp),%eax
801056ea:	0f b6 00             	movzbl (%eax),%eax
801056ed:	84 c0                	test   %al,%al
801056ef:	74 10                	je     80105701 <strncmp+0x31>
801056f1:	8b 45 08             	mov    0x8(%ebp),%eax
801056f4:	0f b6 10             	movzbl (%eax),%edx
801056f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fa:	0f b6 00             	movzbl (%eax),%eax
801056fd:	38 c2                	cmp    %al,%dl
801056ff:	74 d4                	je     801056d5 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105701:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105705:	75 07                	jne    8010570e <strncmp+0x3e>
    return 0;
80105707:	b8 00 00 00 00       	mov    $0x0,%eax
8010570c:	eb 16                	jmp    80105724 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010570e:	8b 45 08             	mov    0x8(%ebp),%eax
80105711:	0f b6 00             	movzbl (%eax),%eax
80105714:	0f b6 d0             	movzbl %al,%edx
80105717:	8b 45 0c             	mov    0xc(%ebp),%eax
8010571a:	0f b6 00             	movzbl (%eax),%eax
8010571d:	0f b6 c0             	movzbl %al,%eax
80105720:	29 c2                	sub    %eax,%edx
80105722:	89 d0                	mov    %edx,%eax
}
80105724:	5d                   	pop    %ebp
80105725:	c3                   	ret    

80105726 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105726:	55                   	push   %ebp
80105727:	89 e5                	mov    %esp,%ebp
80105729:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010572c:	8b 45 08             	mov    0x8(%ebp),%eax
8010572f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105732:	90                   	nop
80105733:	8b 45 10             	mov    0x10(%ebp),%eax
80105736:	8d 50 ff             	lea    -0x1(%eax),%edx
80105739:	89 55 10             	mov    %edx,0x10(%ebp)
8010573c:	85 c0                	test   %eax,%eax
8010573e:	7e 1e                	jle    8010575e <strncpy+0x38>
80105740:	8b 45 08             	mov    0x8(%ebp),%eax
80105743:	8d 50 01             	lea    0x1(%eax),%edx
80105746:	89 55 08             	mov    %edx,0x8(%ebp)
80105749:	8b 55 0c             	mov    0xc(%ebp),%edx
8010574c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010574f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105752:	0f b6 12             	movzbl (%edx),%edx
80105755:	88 10                	mov    %dl,(%eax)
80105757:	0f b6 00             	movzbl (%eax),%eax
8010575a:	84 c0                	test   %al,%al
8010575c:	75 d5                	jne    80105733 <strncpy+0xd>
    ;
  while(n-- > 0)
8010575e:	eb 0c                	jmp    8010576c <strncpy+0x46>
    *s++ = 0;
80105760:	8b 45 08             	mov    0x8(%ebp),%eax
80105763:	8d 50 01             	lea    0x1(%eax),%edx
80105766:	89 55 08             	mov    %edx,0x8(%ebp)
80105769:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010576c:	8b 45 10             	mov    0x10(%ebp),%eax
8010576f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105772:	89 55 10             	mov    %edx,0x10(%ebp)
80105775:	85 c0                	test   %eax,%eax
80105777:	7f e7                	jg     80105760 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105779:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010577c:	c9                   	leave  
8010577d:	c3                   	ret    

8010577e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010577e:	55                   	push   %ebp
8010577f:	89 e5                	mov    %esp,%ebp
80105781:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105784:	8b 45 08             	mov    0x8(%ebp),%eax
80105787:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010578a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010578e:	7f 05                	jg     80105795 <safestrcpy+0x17>
    return os;
80105790:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105793:	eb 31                	jmp    801057c6 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105795:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105799:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010579d:	7e 1e                	jle    801057bd <safestrcpy+0x3f>
8010579f:	8b 45 08             	mov    0x8(%ebp),%eax
801057a2:	8d 50 01             	lea    0x1(%eax),%edx
801057a5:	89 55 08             	mov    %edx,0x8(%ebp)
801057a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801057ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801057ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801057b1:	0f b6 12             	movzbl (%edx),%edx
801057b4:	88 10                	mov    %dl,(%eax)
801057b6:	0f b6 00             	movzbl (%eax),%eax
801057b9:	84 c0                	test   %al,%al
801057bb:	75 d8                	jne    80105795 <safestrcpy+0x17>
    ;
  *s = 0;
801057bd:	8b 45 08             	mov    0x8(%ebp),%eax
801057c0:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801057c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057c6:	c9                   	leave  
801057c7:	c3                   	ret    

801057c8 <strlen>:

int
strlen(const char *s)
{
801057c8:	55                   	push   %ebp
801057c9:	89 e5                	mov    %esp,%ebp
801057cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801057ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057d5:	eb 04                	jmp    801057db <strlen+0x13>
801057d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057db:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057de:	8b 45 08             	mov    0x8(%ebp),%eax
801057e1:	01 d0                	add    %edx,%eax
801057e3:	0f b6 00             	movzbl (%eax),%eax
801057e6:	84 c0                	test   %al,%al
801057e8:	75 ed                	jne    801057d7 <strlen+0xf>
    ;
  return n;
801057ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057ed:	c9                   	leave  
801057ee:	c3                   	ret    

801057ef <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057ef:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057f3:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057f7:	55                   	push   %ebp
  pushl %ebx
801057f8:	53                   	push   %ebx
  pushl %esi
801057f9:	56                   	push   %esi
  pushl %edi
801057fa:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057fb:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057fd:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057ff:	5f                   	pop    %edi
  popl %esi
80105800:	5e                   	pop    %esi
  popl %ebx
80105801:	5b                   	pop    %ebx
  popl %ebp
80105802:	5d                   	pop    %ebp
  ret
80105803:	c3                   	ret    

80105804 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105807:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580d:	8b 00                	mov    (%eax),%eax
8010580f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105812:	76 12                	jbe    80105826 <fetchint+0x22>
80105814:	8b 45 08             	mov    0x8(%ebp),%eax
80105817:	8d 50 04             	lea    0x4(%eax),%edx
8010581a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105820:	8b 00                	mov    (%eax),%eax
80105822:	39 c2                	cmp    %eax,%edx
80105824:	76 07                	jbe    8010582d <fetchint+0x29>
    return -1;
80105826:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582b:	eb 0f                	jmp    8010583c <fetchint+0x38>
  *ip = *(int*)(addr);
8010582d:	8b 45 08             	mov    0x8(%ebp),%eax
80105830:	8b 10                	mov    (%eax),%edx
80105832:	8b 45 0c             	mov    0xc(%ebp),%eax
80105835:	89 10                	mov    %edx,(%eax)
  return 0;
80105837:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010583c:	5d                   	pop    %ebp
8010583d:	c3                   	ret    

8010583e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010583e:	55                   	push   %ebp
8010583f:	89 e5                	mov    %esp,%ebp
80105841:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105844:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010584a:	8b 00                	mov    (%eax),%eax
8010584c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010584f:	77 07                	ja     80105858 <fetchstr+0x1a>
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105856:	eb 46                	jmp    8010589e <fetchstr+0x60>
  *pp = (char*)addr;
80105858:	8b 55 08             	mov    0x8(%ebp),%edx
8010585b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585e:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105860:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105866:	8b 00                	mov    (%eax),%eax
80105868:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010586b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586e:	8b 00                	mov    (%eax),%eax
80105870:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105873:	eb 1c                	jmp    80105891 <fetchstr+0x53>
    if(*s == 0)
80105875:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105878:	0f b6 00             	movzbl (%eax),%eax
8010587b:	84 c0                	test   %al,%al
8010587d:	75 0e                	jne    8010588d <fetchstr+0x4f>
      return s - *pp;
8010587f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105882:	8b 45 0c             	mov    0xc(%ebp),%eax
80105885:	8b 00                	mov    (%eax),%eax
80105887:	29 c2                	sub    %eax,%edx
80105889:	89 d0                	mov    %edx,%eax
8010588b:	eb 11                	jmp    8010589e <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010588d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105891:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105894:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105897:	72 dc                	jb     80105875 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    

801058a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801058a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ac:	8b 40 18             	mov    0x18(%eax),%eax
801058af:	8b 50 44             	mov    0x44(%eax),%edx
801058b2:	8b 45 08             	mov    0x8(%ebp),%eax
801058b5:	c1 e0 02             	shl    $0x2,%eax
801058b8:	01 d0                	add    %edx,%eax
801058ba:	8d 50 04             	lea    0x4(%eax),%edx
801058bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801058c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c4:	89 14 24             	mov    %edx,(%esp)
801058c7:	e8 38 ff ff ff       	call   80105804 <fetchint>
}
801058cc:	c9                   	leave  
801058cd:	c3                   	ret    

801058ce <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801058ce:	55                   	push   %ebp
801058cf:	89 e5                	mov    %esp,%ebp
801058d1:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801058d4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801058db:	8b 45 08             	mov    0x8(%ebp),%eax
801058de:	89 04 24             	mov    %eax,(%esp)
801058e1:	e8 ba ff ff ff       	call   801058a0 <argint>
801058e6:	85 c0                	test   %eax,%eax
801058e8:	79 07                	jns    801058f1 <argptr+0x23>
    return -1;
801058ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ef:	eb 3d                	jmp    8010592e <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058f4:	89 c2                	mov    %eax,%edx
801058f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058fc:	8b 00                	mov    (%eax),%eax
801058fe:	39 c2                	cmp    %eax,%edx
80105900:	73 16                	jae    80105918 <argptr+0x4a>
80105902:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105905:	89 c2                	mov    %eax,%edx
80105907:	8b 45 10             	mov    0x10(%ebp),%eax
8010590a:	01 c2                	add    %eax,%edx
8010590c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105912:	8b 00                	mov    (%eax),%eax
80105914:	39 c2                	cmp    %eax,%edx
80105916:	76 07                	jbe    8010591f <argptr+0x51>
    return -1;
80105918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591d:	eb 0f                	jmp    8010592e <argptr+0x60>
  *pp = (char*)i;
8010591f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105922:	89 c2                	mov    %eax,%edx
80105924:	8b 45 0c             	mov    0xc(%ebp),%eax
80105927:	89 10                	mov    %edx,(%eax)
  return 0;
80105929:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010592e:	c9                   	leave  
8010592f:	c3                   	ret    

80105930 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105936:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105939:	89 44 24 04          	mov    %eax,0x4(%esp)
8010593d:	8b 45 08             	mov    0x8(%ebp),%eax
80105940:	89 04 24             	mov    %eax,(%esp)
80105943:	e8 58 ff ff ff       	call   801058a0 <argint>
80105948:	85 c0                	test   %eax,%eax
8010594a:	79 07                	jns    80105953 <argstr+0x23>
    return -1;
8010594c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105951:	eb 12                	jmp    80105965 <argstr+0x35>
  return fetchstr(addr, pp);
80105953:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105956:	8b 55 0c             	mov    0xc(%ebp),%edx
80105959:	89 54 24 04          	mov    %edx,0x4(%esp)
8010595d:	89 04 24             	mov    %eax,(%esp)
80105960:	e8 d9 fe ff ff       	call   8010583e <fetchstr>
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    

80105967 <syscall>:
[SYS_thread_yield] sys_thread_yield,
};

void
syscall(void)
{
80105967:	55                   	push   %ebp
80105968:	89 e5                	mov    %esp,%ebp
8010596a:	53                   	push   %ebx
8010596b:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010596e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105974:	8b 40 18             	mov    0x18(%eax),%eax
80105977:	8b 40 1c             	mov    0x1c(%eax),%eax
8010597a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010597d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105981:	7e 30                	jle    801059b3 <syscall+0x4c>
80105983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105986:	83 f8 1a             	cmp    $0x1a,%eax
80105989:	77 28                	ja     801059b3 <syscall+0x4c>
8010598b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105995:	85 c0                	test   %eax,%eax
80105997:	74 1a                	je     801059b3 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105999:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010599f:	8b 58 18             	mov    0x18(%eax),%ebx
801059a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a5:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801059ac:	ff d0                	call   *%eax
801059ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
801059b1:	eb 3d                	jmp    801059f0 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801059b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b9:	8d 48 6c             	lea    0x6c(%eax),%ecx
801059bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801059c2:	8b 40 10             	mov    0x10(%eax),%eax
801059c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
801059cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801059d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801059d4:	c7 04 24 1a 8e 10 80 	movl   $0x80108e1a,(%esp)
801059db:	e8 c0 a9 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801059e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e6:	8b 40 18             	mov    0x18(%eax),%eax
801059e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059f0:	83 c4 24             	add    $0x24,%esp
801059f3:	5b                   	pop    %ebx
801059f4:	5d                   	pop    %ebp
801059f5:	c3                   	ret    

801059f6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059f6:	55                   	push   %ebp
801059f7:	89 e5                	mov    %esp,%ebp
801059f9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a03:	8b 45 08             	mov    0x8(%ebp),%eax
80105a06:	89 04 24             	mov    %eax,(%esp)
80105a09:	e8 92 fe ff ff       	call   801058a0 <argint>
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	79 07                	jns    80105a19 <argfd+0x23>
    return -1;
80105a12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a17:	eb 50                	jmp    80105a69 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	78 21                	js     80105a41 <argfd+0x4b>
80105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a23:	83 f8 0f             	cmp    $0xf,%eax
80105a26:	7f 19                	jg     80105a41 <argfd+0x4b>
80105a28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a31:	83 c2 08             	add    $0x8,%edx
80105a34:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a3f:	75 07                	jne    80105a48 <argfd+0x52>
    return -1;
80105a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a46:	eb 21                	jmp    80105a69 <argfd+0x73>
  if(pfd)
80105a48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a4c:	74 08                	je     80105a56 <argfd+0x60>
    *pfd = fd;
80105a4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a51:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a54:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a5a:	74 08                	je     80105a64 <argfd+0x6e>
    *pf = f;
80105a5c:	8b 45 10             	mov    0x10(%ebp),%eax
80105a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a62:	89 10                	mov    %edx,(%eax)
  return 0;
80105a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a69:	c9                   	leave  
80105a6a:	c3                   	ret    

80105a6b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a6b:	55                   	push   %ebp
80105a6c:	89 e5                	mov    %esp,%ebp
80105a6e:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a78:	eb 30                	jmp    80105aaa <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105a7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a80:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a83:	83 c2 08             	add    $0x8,%edx
80105a86:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	75 18                	jne    80105aa6 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a94:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a97:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a9a:	8b 55 08             	mov    0x8(%ebp),%edx
80105a9d:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aa4:	eb 0f                	jmp    80105ab5 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105aa6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105aaa:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105aae:	7e ca                	jle    80105a7a <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    

80105ab7 <sys_dup>:

int
sys_dup(void)
{
80105ab7:	55                   	push   %ebp
80105ab8:	89 e5                	mov    %esp,%ebp
80105aba:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ac0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ac4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105acb:	00 
80105acc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ad3:	e8 1e ff ff ff       	call   801059f6 <argfd>
80105ad8:	85 c0                	test   %eax,%eax
80105ada:	79 07                	jns    80105ae3 <sys_dup+0x2c>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae1:	eb 29                	jmp    80105b0c <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae6:	89 04 24             	mov    %eax,(%esp)
80105ae9:	e8 7d ff ff ff       	call   80105a6b <fdalloc>
80105aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105af5:	79 07                	jns    80105afe <sys_dup+0x47>
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afc:	eb 0e                	jmp    80105b0c <sys_dup+0x55>
  filedup(f);
80105afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b01:	89 04 24             	mov    %eax,(%esp)
80105b04:	e8 75 b4 ff ff       	call   80100f7e <filedup>
  return fd;
80105b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b0c:	c9                   	leave  
80105b0d:	c3                   	ret    

80105b0e <sys_read>:

int
sys_read(void)
{
80105b0e:	55                   	push   %ebp
80105b0f:	89 e5                	mov    %esp,%ebp
80105b11:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b17:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b22:	00 
80105b23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b2a:	e8 c7 fe ff ff       	call   801059f6 <argfd>
80105b2f:	85 c0                	test   %eax,%eax
80105b31:	78 35                	js     80105b68 <sys_read+0x5a>
80105b33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b3a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105b41:	e8 5a fd ff ff       	call   801058a0 <argint>
80105b46:	85 c0                	test   %eax,%eax
80105b48:	78 1e                	js     80105b68 <sys_read+0x5a>
80105b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b51:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b5f:	e8 6a fd ff ff       	call   801058ce <argptr>
80105b64:	85 c0                	test   %eax,%eax
80105b66:	79 07                	jns    80105b6f <sys_read+0x61>
    return -1;
80105b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6d:	eb 19                	jmp    80105b88 <sys_read+0x7a>
  return fileread(f, p, n);
80105b6f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b72:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105b7c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b80:	89 04 24             	mov    %eax,(%esp)
80105b83:	e8 63 b5 ff ff       	call   801010eb <fileread>
}
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    

80105b8a <sys_write>:

int
sys_write(void)
{
80105b8a:	55                   	push   %ebp
80105b8b:	89 e5                	mov    %esp,%ebp
80105b8d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b93:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b9e:	00 
80105b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ba6:	e8 4b fe ff ff       	call   801059f6 <argfd>
80105bab:	85 c0                	test   %eax,%eax
80105bad:	78 35                	js     80105be4 <sys_write+0x5a>
80105baf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105bbd:	e8 de fc ff ff       	call   801058a0 <argint>
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	78 1e                	js     80105be4 <sys_write+0x5a>
80105bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bdb:	e8 ee fc ff ff       	call   801058ce <argptr>
80105be0:	85 c0                	test   %eax,%eax
80105be2:	79 07                	jns    80105beb <sys_write+0x61>
    return -1;
80105be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be9:	eb 19                	jmp    80105c04 <sys_write+0x7a>
  return filewrite(f, p, n);
80105beb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bee:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bf8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bfc:	89 04 24             	mov    %eax,(%esp)
80105bff:	e8 a3 b5 ff ff       	call   801011a7 <filewrite>
}
80105c04:	c9                   	leave  
80105c05:	c3                   	ret    

80105c06 <sys_close>:

int
sys_close(void)
{
80105c06:	55                   	push   %ebp
80105c07:	89 e5                	mov    %esp,%ebp
80105c09:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c13:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c16:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c21:	e8 d0 fd ff ff       	call   801059f6 <argfd>
80105c26:	85 c0                	test   %eax,%eax
80105c28:	79 07                	jns    80105c31 <sys_close+0x2b>
    return -1;
80105c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2f:	eb 24                	jmp    80105c55 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105c31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c3a:	83 c2 08             	add    $0x8,%edx
80105c3d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c44:	00 
  fileclose(f);
80105c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c48:	89 04 24             	mov    %eax,(%esp)
80105c4b:	e8 76 b3 ff ff       	call   80100fc6 <fileclose>
  return 0;
80105c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    

80105c57 <sys_fstat>:

int
sys_fstat(void)
{
80105c57:	55                   	push   %ebp
80105c58:	89 e5                	mov    %esp,%ebp
80105c5a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c60:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c6b:	00 
80105c6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c73:	e8 7e fd ff ff       	call   801059f6 <argfd>
80105c78:	85 c0                	test   %eax,%eax
80105c7a:	78 1f                	js     80105c9b <sys_fstat+0x44>
80105c7c:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105c83:	00 
80105c84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c92:	e8 37 fc ff ff       	call   801058ce <argptr>
80105c97:	85 c0                	test   %eax,%eax
80105c99:	79 07                	jns    80105ca2 <sys_fstat+0x4b>
    return -1;
80105c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca0:	eb 12                	jmp    80105cb4 <sys_fstat+0x5d>
  return filestat(f, st);
80105ca2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105cac:	89 04 24             	mov    %eax,(%esp)
80105caf:	e8 e8 b3 ff ff       	call   8010109c <filestat>
}
80105cb4:	c9                   	leave  
80105cb5:	c3                   	ret    

80105cb6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105cb6:	55                   	push   %ebp
80105cb7:	89 e5                	mov    %esp,%ebp
80105cb9:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105cbc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cca:	e8 61 fc ff ff       	call   80105930 <argstr>
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	78 17                	js     80105cea <sys_link+0x34>
80105cd3:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ce1:	e8 4a fc ff ff       	call   80105930 <argstr>
80105ce6:	85 c0                	test   %eax,%eax
80105ce8:	79 0a                	jns    80105cf4 <sys_link+0x3e>
    return -1;
80105cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cef:	e9 3d 01 00 00       	jmp    80105e31 <sys_link+0x17b>
  if((ip = namei(old)) == 0)
80105cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105cf7:	89 04 24             	mov    %eax,(%esp)
80105cfa:	e8 ff c6 ff ff       	call   801023fe <namei>
80105cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d06:	75 0a                	jne    80105d12 <sys_link+0x5c>
    return -1;
80105d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0d:	e9 1f 01 00 00       	jmp    80105e31 <sys_link+0x17b>

  begin_trans();
80105d12:	e8 ac d5 ff ff       	call   801032c3 <begin_trans>

  ilock(ip);
80105d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1a:	89 04 24             	mov    %eax,(%esp)
80105d1d:	e8 31 bb ff ff       	call   80101853 <ilock>
  if(ip->type == T_DIR){
80105d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d25:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d29:	66 83 f8 01          	cmp    $0x1,%ax
80105d2d:	75 1a                	jne    80105d49 <sys_link+0x93>
    iunlockput(ip);
80105d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d32:	89 04 24             	mov    %eax,(%esp)
80105d35:	e8 9d bd ff ff       	call   80101ad7 <iunlockput>
    commit_trans();
80105d3a:	e8 cd d5 ff ff       	call   8010330c <commit_trans>
    return -1;
80105d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d44:	e9 e8 00 00 00       	jmp    80105e31 <sys_link+0x17b>
  }

  ip->nlink++;
80105d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d50:	8d 50 01             	lea    0x1(%eax),%edx
80105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d56:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5d:	89 04 24             	mov    %eax,(%esp)
80105d60:	e8 32 b9 ff ff       	call   80101697 <iupdate>
  iunlock(ip);
80105d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d68:	89 04 24             	mov    %eax,(%esp)
80105d6b:	e8 31 bc ff ff       	call   801019a1 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105d70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d73:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d76:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d7a:	89 04 24             	mov    %eax,(%esp)
80105d7d:	e8 9e c6 ff ff       	call   80102420 <nameiparent>
80105d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d89:	75 02                	jne    80105d8d <sys_link+0xd7>
    goto bad;
80105d8b:	eb 68                	jmp    80105df5 <sys_link+0x13f>
  ilock(dp);
80105d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d90:	89 04 24             	mov    %eax,(%esp)
80105d93:	e8 bb ba ff ff       	call   80101853 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9b:	8b 10                	mov    (%eax),%edx
80105d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da0:	8b 00                	mov    (%eax),%eax
80105da2:	39 c2                	cmp    %eax,%edx
80105da4:	75 20                	jne    80105dc6 <sys_link+0x110>
80105da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da9:	8b 40 04             	mov    0x4(%eax),%eax
80105dac:	89 44 24 08          	mov    %eax,0x8(%esp)
80105db0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105db3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	89 04 24             	mov    %eax,(%esp)
80105dbd:	e8 7c c3 ff ff       	call   8010213e <dirlink>
80105dc2:	85 c0                	test   %eax,%eax
80105dc4:	79 0d                	jns    80105dd3 <sys_link+0x11d>
    iunlockput(dp);
80105dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc9:	89 04 24             	mov    %eax,(%esp)
80105dcc:	e8 06 bd ff ff       	call   80101ad7 <iunlockput>
    goto bad;
80105dd1:	eb 22                	jmp    80105df5 <sys_link+0x13f>
  }
  iunlockput(dp);
80105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd6:	89 04 24             	mov    %eax,(%esp)
80105dd9:	e8 f9 bc ff ff       	call   80101ad7 <iunlockput>
  iput(ip);
80105dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de1:	89 04 24             	mov    %eax,(%esp)
80105de4:	e8 1d bc ff ff       	call   80101a06 <iput>

  commit_trans();
80105de9:	e8 1e d5 ff ff       	call   8010330c <commit_trans>

  return 0;
80105dee:	b8 00 00 00 00       	mov    $0x0,%eax
80105df3:	eb 3c                	jmp    80105e31 <sys_link+0x17b>

bad:
  ilock(ip);
80105df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df8:	89 04 24             	mov    %eax,(%esp)
80105dfb:	e8 53 ba ff ff       	call   80101853 <ilock>
  ip->nlink--;
80105e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e03:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e07:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e14:	89 04 24             	mov    %eax,(%esp)
80105e17:	e8 7b b8 ff ff       	call   80101697 <iupdate>
  iunlockput(ip);
80105e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1f:	89 04 24             	mov    %eax,(%esp)
80105e22:	e8 b0 bc ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80105e27:	e8 e0 d4 ff ff       	call   8010330c <commit_trans>
  return -1;
80105e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e31:	c9                   	leave  
80105e32:	c3                   	ret    

80105e33 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105e33:	55                   	push   %ebp
80105e34:	89 e5                	mov    %esp,%ebp
80105e36:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e39:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105e40:	eb 4b                	jmp    80105e8d <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e45:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e4c:	00 
80105e4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e58:	8b 45 08             	mov    0x8(%ebp),%eax
80105e5b:	89 04 24             	mov    %eax,(%esp)
80105e5e:	e8 fd be ff ff       	call   80101d60 <readi>
80105e63:	83 f8 10             	cmp    $0x10,%eax
80105e66:	74 0c                	je     80105e74 <isdirempty+0x41>
      panic("isdirempty: readi");
80105e68:	c7 04 24 36 8e 10 80 	movl   $0x80108e36,(%esp)
80105e6f:	e8 c6 a6 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105e74:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e78:	66 85 c0             	test   %ax,%ax
80105e7b:	74 07                	je     80105e84 <isdirempty+0x51>
      return 0;
80105e7d:	b8 00 00 00 00       	mov    $0x0,%eax
80105e82:	eb 1b                	jmp    80105e9f <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e87:	83 c0 10             	add    $0x10,%eax
80105e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e90:	8b 45 08             	mov    0x8(%ebp),%eax
80105e93:	8b 40 18             	mov    0x18(%eax),%eax
80105e96:	39 c2                	cmp    %eax,%edx
80105e98:	72 a8                	jb     80105e42 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105e9a:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e9f:	c9                   	leave  
80105ea0:	c3                   	ret    

80105ea1 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ea1:	55                   	push   %ebp
80105ea2:	89 e5                	mov    %esp,%ebp
80105ea4:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ea7:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105eb5:	e8 76 fa ff ff       	call   80105930 <argstr>
80105eba:	85 c0                	test   %eax,%eax
80105ebc:	79 0a                	jns    80105ec8 <sys_unlink+0x27>
    return -1;
80105ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec3:	e9 aa 01 00 00       	jmp    80106072 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105ec8:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ecb:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ece:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ed2:	89 04 24             	mov    %eax,(%esp)
80105ed5:	e8 46 c5 ff ff       	call   80102420 <nameiparent>
80105eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee1:	75 0a                	jne    80105eed <sys_unlink+0x4c>
    return -1;
80105ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee8:	e9 85 01 00 00       	jmp    80106072 <sys_unlink+0x1d1>

  begin_trans();
80105eed:	e8 d1 d3 ff ff       	call   801032c3 <begin_trans>

  ilock(dp);
80105ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef5:	89 04 24             	mov    %eax,(%esp)
80105ef8:	e8 56 b9 ff ff       	call   80101853 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105efd:	c7 44 24 04 48 8e 10 	movl   $0x80108e48,0x4(%esp)
80105f04:	80 
80105f05:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f08:	89 04 24             	mov    %eax,(%esp)
80105f0b:	e8 43 c1 ff ff       	call   80102053 <namecmp>
80105f10:	85 c0                	test   %eax,%eax
80105f12:	0f 84 45 01 00 00    	je     8010605d <sys_unlink+0x1bc>
80105f18:	c7 44 24 04 4a 8e 10 	movl   $0x80108e4a,0x4(%esp)
80105f1f:	80 
80105f20:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f23:	89 04 24             	mov    %eax,(%esp)
80105f26:	e8 28 c1 ff ff       	call   80102053 <namecmp>
80105f2b:	85 c0                	test   %eax,%eax
80105f2d:	0f 84 2a 01 00 00    	je     8010605d <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f33:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105f36:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f3a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f44:	89 04 24             	mov    %eax,(%esp)
80105f47:	e8 29 c1 ff ff       	call   80102075 <dirlookup>
80105f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f53:	75 05                	jne    80105f5a <sys_unlink+0xb9>
    goto bad;
80105f55:	e9 03 01 00 00       	jmp    8010605d <sys_unlink+0x1bc>
  ilock(ip);
80105f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5d:	89 04 24             	mov    %eax,(%esp)
80105f60:	e8 ee b8 ff ff       	call   80101853 <ilock>

  if(ip->nlink < 1)
80105f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f68:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f6c:	66 85 c0             	test   %ax,%ax
80105f6f:	7f 0c                	jg     80105f7d <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80105f71:	c7 04 24 4d 8e 10 80 	movl   $0x80108e4d,(%esp)
80105f78:	e8 bd a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f80:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f84:	66 83 f8 01          	cmp    $0x1,%ax
80105f88:	75 1f                	jne    80105fa9 <sys_unlink+0x108>
80105f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8d:	89 04 24             	mov    %eax,(%esp)
80105f90:	e8 9e fe ff ff       	call   80105e33 <isdirempty>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	75 10                	jne    80105fa9 <sys_unlink+0x108>
    iunlockput(ip);
80105f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9c:	89 04 24             	mov    %eax,(%esp)
80105f9f:	e8 33 bb ff ff       	call   80101ad7 <iunlockput>
    goto bad;
80105fa4:	e9 b4 00 00 00       	jmp    8010605d <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105fa9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105fb0:	00 
80105fb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fb8:	00 
80105fb9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fbc:	89 04 24             	mov    %eax,(%esp)
80105fbf:	e8 9a f5 ff ff       	call   8010555e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fc4:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105fc7:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105fce:	00 
80105fcf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fd3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdd:	89 04 24             	mov    %eax,(%esp)
80105fe0:	e8 df be ff ff       	call   80101ec4 <writei>
80105fe5:	83 f8 10             	cmp    $0x10,%eax
80105fe8:	74 0c                	je     80105ff6 <sys_unlink+0x155>
    panic("unlink: writei");
80105fea:	c7 04 24 5f 8e 10 80 	movl   $0x80108e5f,(%esp)
80105ff1:	e8 44 a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ffd:	66 83 f8 01          	cmp    $0x1,%ax
80106001:	75 1c                	jne    8010601f <sys_unlink+0x17e>
    dp->nlink--;
80106003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106006:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010600a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010600d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106010:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106017:	89 04 24             	mov    %eax,(%esp)
8010601a:	e8 78 b6 ff ff       	call   80101697 <iupdate>
  }
  iunlockput(dp);
8010601f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106022:	89 04 24             	mov    %eax,(%esp)
80106025:	e8 ad ba ff ff       	call   80101ad7 <iunlockput>

  ip->nlink--;
8010602a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106031:	8d 50 ff             	lea    -0x1(%eax),%edx
80106034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106037:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	89 04 24             	mov    %eax,(%esp)
80106041:	e8 51 b6 ff ff       	call   80101697 <iupdate>
  iunlockput(ip);
80106046:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106049:	89 04 24             	mov    %eax,(%esp)
8010604c:	e8 86 ba ff ff       	call   80101ad7 <iunlockput>

  commit_trans();
80106051:	e8 b6 d2 ff ff       	call   8010330c <commit_trans>

  return 0;
80106056:	b8 00 00 00 00       	mov    $0x0,%eax
8010605b:	eb 15                	jmp    80106072 <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
8010605d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106060:	89 04 24             	mov    %eax,(%esp)
80106063:	e8 6f ba ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80106068:	e8 9f d2 ff ff       	call   8010330c <commit_trans>
  return -1;
8010606d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106072:	c9                   	leave  
80106073:	c3                   	ret    

80106074 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	83 ec 48             	sub    $0x48,%esp
8010607a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010607d:	8b 55 10             	mov    0x10(%ebp),%edx
80106080:	8b 45 14             	mov    0x14(%ebp),%eax
80106083:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106087:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010608b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010608f:	8d 45 de             	lea    -0x22(%ebp),%eax
80106092:	89 44 24 04          	mov    %eax,0x4(%esp)
80106096:	8b 45 08             	mov    0x8(%ebp),%eax
80106099:	89 04 24             	mov    %eax,(%esp)
8010609c:	e8 7f c3 ff ff       	call   80102420 <nameiparent>
801060a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a8:	75 0a                	jne    801060b4 <create+0x40>
    return 0;
801060aa:	b8 00 00 00 00       	mov    $0x0,%eax
801060af:	e9 7e 01 00 00       	jmp    80106232 <create+0x1be>
  ilock(dp);
801060b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b7:	89 04 24             	mov    %eax,(%esp)
801060ba:	e8 94 b7 ff ff       	call   80101853 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801060bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801060c6:	8d 45 de             	lea    -0x22(%ebp),%eax
801060c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801060cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d0:	89 04 24             	mov    %eax,(%esp)
801060d3:	e8 9d bf ff ff       	call   80102075 <dirlookup>
801060d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060df:	74 47                	je     80106128 <create+0xb4>
    iunlockput(dp);
801060e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e4:	89 04 24             	mov    %eax,(%esp)
801060e7:	e8 eb b9 ff ff       	call   80101ad7 <iunlockput>
    ilock(ip);
801060ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ef:	89 04 24             	mov    %eax,(%esp)
801060f2:	e8 5c b7 ff ff       	call   80101853 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060f7:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060fc:	75 15                	jne    80106113 <create+0x9f>
801060fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106101:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106105:	66 83 f8 02          	cmp    $0x2,%ax
80106109:	75 08                	jne    80106113 <create+0x9f>
      return ip;
8010610b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610e:	e9 1f 01 00 00       	jmp    80106232 <create+0x1be>
    iunlockput(ip);
80106113:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106116:	89 04 24             	mov    %eax,(%esp)
80106119:	e8 b9 b9 ff ff       	call   80101ad7 <iunlockput>
    return 0;
8010611e:	b8 00 00 00 00       	mov    $0x0,%eax
80106123:	e9 0a 01 00 00       	jmp    80106232 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106128:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010612c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612f:	8b 00                	mov    (%eax),%eax
80106131:	89 54 24 04          	mov    %edx,0x4(%esp)
80106135:	89 04 24             	mov    %eax,(%esp)
80106138:	e8 7b b4 ff ff       	call   801015b8 <ialloc>
8010613d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106144:	75 0c                	jne    80106152 <create+0xde>
    panic("create: ialloc");
80106146:	c7 04 24 6e 8e 10 80 	movl   $0x80108e6e,(%esp)
8010614d:	e8 e8 a3 ff ff       	call   8010053a <panic>

  ilock(ip);
80106152:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106155:	89 04 24             	mov    %eax,(%esp)
80106158:	e8 f6 b6 ff ff       	call   80101853 <ilock>
  ip->major = major;
8010615d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106160:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106164:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106168:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616b:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010616f:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106173:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106176:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010617c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617f:	89 04 24             	mov    %eax,(%esp)
80106182:	e8 10 b5 ff ff       	call   80101697 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106187:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010618c:	75 6a                	jne    801061f8 <create+0x184>
    dp->nlink++;  // for ".."
8010618e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106191:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106195:	8d 50 01             	lea    0x1(%eax),%edx
80106198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619b:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010619f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a2:	89 04 24             	mov    %eax,(%esp)
801061a5:	e8 ed b4 ff ff       	call   80101697 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801061aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ad:	8b 40 04             	mov    0x4(%eax),%eax
801061b0:	89 44 24 08          	mov    %eax,0x8(%esp)
801061b4:	c7 44 24 04 48 8e 10 	movl   $0x80108e48,0x4(%esp)
801061bb:	80 
801061bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061bf:	89 04 24             	mov    %eax,(%esp)
801061c2:	e8 77 bf ff ff       	call   8010213e <dirlink>
801061c7:	85 c0                	test   %eax,%eax
801061c9:	78 21                	js     801061ec <create+0x178>
801061cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ce:	8b 40 04             	mov    0x4(%eax),%eax
801061d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d5:	c7 44 24 04 4a 8e 10 	movl   $0x80108e4a,0x4(%esp)
801061dc:	80 
801061dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e0:	89 04 24             	mov    %eax,(%esp)
801061e3:	e8 56 bf ff ff       	call   8010213e <dirlink>
801061e8:	85 c0                	test   %eax,%eax
801061ea:	79 0c                	jns    801061f8 <create+0x184>
      panic("create dots");
801061ec:	c7 04 24 7d 8e 10 80 	movl   $0x80108e7d,(%esp)
801061f3:	e8 42 a3 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801061f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fb:	8b 40 04             	mov    0x4(%eax),%eax
801061fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80106202:	8d 45 de             	lea    -0x22(%ebp),%eax
80106205:	89 44 24 04          	mov    %eax,0x4(%esp)
80106209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620c:	89 04 24             	mov    %eax,(%esp)
8010620f:	e8 2a bf ff ff       	call   8010213e <dirlink>
80106214:	85 c0                	test   %eax,%eax
80106216:	79 0c                	jns    80106224 <create+0x1b0>
    panic("create: dirlink");
80106218:	c7 04 24 89 8e 10 80 	movl   $0x80108e89,(%esp)
8010621f:	e8 16 a3 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106227:	89 04 24             	mov    %eax,(%esp)
8010622a:	e8 a8 b8 ff ff       	call   80101ad7 <iunlockput>

  return ip;
8010622f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106232:	c9                   	leave  
80106233:	c3                   	ret    

80106234 <sys_open>:

int
sys_open(void)
{
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010623a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010623d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106248:	e8 e3 f6 ff ff       	call   80105930 <argstr>
8010624d:	85 c0                	test   %eax,%eax
8010624f:	78 17                	js     80106268 <sys_open+0x34>
80106251:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106254:	89 44 24 04          	mov    %eax,0x4(%esp)
80106258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010625f:	e8 3c f6 ff ff       	call   801058a0 <argint>
80106264:	85 c0                	test   %eax,%eax
80106266:	79 0a                	jns    80106272 <sys_open+0x3e>
    return -1;
80106268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626d:	e9 48 01 00 00       	jmp    801063ba <sys_open+0x186>
  if(omode & O_CREATE){
80106272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106275:	25 00 02 00 00       	and    $0x200,%eax
8010627a:	85 c0                	test   %eax,%eax
8010627c:	74 40                	je     801062be <sys_open+0x8a>
    begin_trans();
8010627e:	e8 40 d0 ff ff       	call   801032c3 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106283:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106286:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010628d:	00 
8010628e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106295:	00 
80106296:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010629d:	00 
8010629e:	89 04 24             	mov    %eax,(%esp)
801062a1:	e8 ce fd ff ff       	call   80106074 <create>
801062a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801062a9:	e8 5e d0 ff ff       	call   8010330c <commit_trans>
    if(ip == 0)
801062ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b2:	75 5c                	jne    80106310 <sys_open+0xdc>
      return -1;
801062b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b9:	e9 fc 00 00 00       	jmp    801063ba <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
801062be:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062c1:	89 04 24             	mov    %eax,(%esp)
801062c4:	e8 35 c1 ff ff       	call   801023fe <namei>
801062c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062d0:	75 0a                	jne    801062dc <sys_open+0xa8>
      return -1;
801062d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d7:	e9 de 00 00 00       	jmp    801063ba <sys_open+0x186>
    ilock(ip);
801062dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062df:	89 04 24             	mov    %eax,(%esp)
801062e2:	e8 6c b5 ff ff       	call   80101853 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801062e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062ee:	66 83 f8 01          	cmp    $0x1,%ax
801062f2:	75 1c                	jne    80106310 <sys_open+0xdc>
801062f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062f7:	85 c0                	test   %eax,%eax
801062f9:	74 15                	je     80106310 <sys_open+0xdc>
      iunlockput(ip);
801062fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062fe:	89 04 24             	mov    %eax,(%esp)
80106301:	e8 d1 b7 ff ff       	call   80101ad7 <iunlockput>
      return -1;
80106306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630b:	e9 aa 00 00 00       	jmp    801063ba <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106310:	e8 09 ac ff ff       	call   80100f1e <filealloc>
80106315:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010631c:	74 14                	je     80106332 <sys_open+0xfe>
8010631e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106321:	89 04 24             	mov    %eax,(%esp)
80106324:	e8 42 f7 ff ff       	call   80105a6b <fdalloc>
80106329:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010632c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106330:	79 23                	jns    80106355 <sys_open+0x121>
    if(f)
80106332:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106336:	74 0b                	je     80106343 <sys_open+0x10f>
      fileclose(f);
80106338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633b:	89 04 24             	mov    %eax,(%esp)
8010633e:	e8 83 ac ff ff       	call   80100fc6 <fileclose>
    iunlockput(ip);
80106343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106346:	89 04 24             	mov    %eax,(%esp)
80106349:	e8 89 b7 ff ff       	call   80101ad7 <iunlockput>
    return -1;
8010634e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106353:	eb 65                	jmp    801063ba <sys_open+0x186>
  }
  iunlock(ip);
80106355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106358:	89 04 24             	mov    %eax,(%esp)
8010635b:	e8 41 b6 ff ff       	call   801019a1 <iunlock>

  f->type = FD_INODE;
80106360:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106363:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010636f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106372:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106375:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010637c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010637f:	83 e0 01             	and    $0x1,%eax
80106382:	85 c0                	test   %eax,%eax
80106384:	0f 94 c0             	sete   %al
80106387:	89 c2                	mov    %eax,%edx
80106389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010638c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010638f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106392:	83 e0 01             	and    $0x1,%eax
80106395:	85 c0                	test   %eax,%eax
80106397:	75 0a                	jne    801063a3 <sys_open+0x16f>
80106399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010639c:	83 e0 02             	and    $0x2,%eax
8010639f:	85 c0                	test   %eax,%eax
801063a1:	74 07                	je     801063aa <sys_open+0x176>
801063a3:	b8 01 00 00 00       	mov    $0x1,%eax
801063a8:	eb 05                	jmp    801063af <sys_open+0x17b>
801063aa:	b8 00 00 00 00       	mov    $0x0,%eax
801063af:	89 c2                	mov    %eax,%edx
801063b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063ba:	c9                   	leave  
801063bb:	c3                   	ret    

801063bc <sys_mkdir>:

int
sys_mkdir(void)
{
801063bc:	55                   	push   %ebp
801063bd:	89 e5                	mov    %esp,%ebp
801063bf:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801063c2:	e8 fc ce ff ff       	call   801032c3 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063d5:	e8 56 f5 ff ff       	call   80105930 <argstr>
801063da:	85 c0                	test   %eax,%eax
801063dc:	78 2c                	js     8010640a <sys_mkdir+0x4e>
801063de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801063e8:	00 
801063e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801063f0:	00 
801063f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801063f8:	00 
801063f9:	89 04 24             	mov    %eax,(%esp)
801063fc:	e8 73 fc ff ff       	call   80106074 <create>
80106401:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106408:	75 0c                	jne    80106416 <sys_mkdir+0x5a>
    commit_trans();
8010640a:	e8 fd ce ff ff       	call   8010330c <commit_trans>
    return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106414:	eb 15                	jmp    8010642b <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106419:	89 04 24             	mov    %eax,(%esp)
8010641c:	e8 b6 b6 ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80106421:	e8 e6 ce ff ff       	call   8010330c <commit_trans>
  return 0;
80106426:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010642b:	c9                   	leave  
8010642c:	c3                   	ret    

8010642d <sys_mknod>:

int
sys_mknod(void)
{
8010642d:	55                   	push   %ebp
8010642e:	89 e5                	mov    %esp,%ebp
80106430:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106433:	e8 8b ce ff ff       	call   801032c3 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106438:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010643b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010643f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106446:	e8 e5 f4 ff ff       	call   80105930 <argstr>
8010644b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010644e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106452:	78 5e                	js     801064b2 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106454:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106457:	89 44 24 04          	mov    %eax,0x4(%esp)
8010645b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106462:	e8 39 f4 ff ff       	call   801058a0 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106467:	85 c0                	test   %eax,%eax
80106469:	78 47                	js     801064b2 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010646b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010646e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106472:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106479:	e8 22 f4 ff ff       	call   801058a0 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010647e:	85 c0                	test   %eax,%eax
80106480:	78 30                	js     801064b2 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106485:	0f bf c8             	movswl %ax,%ecx
80106488:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010648b:	0f bf d0             	movswl %ax,%edx
8010648e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106491:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106495:	89 54 24 08          	mov    %edx,0x8(%esp)
80106499:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801064a0:	00 
801064a1:	89 04 24             	mov    %eax,(%esp)
801064a4:	e8 cb fb ff ff       	call   80106074 <create>
801064a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064b0:	75 0c                	jne    801064be <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
801064b2:	e8 55 ce ff ff       	call   8010330c <commit_trans>
    return -1;
801064b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064bc:	eb 15                	jmp    801064d3 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801064be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c1:	89 04 24             	mov    %eax,(%esp)
801064c4:	e8 0e b6 ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
801064c9:	e8 3e ce ff ff       	call   8010330c <commit_trans>
  return 0;
801064ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064d3:	c9                   	leave  
801064d4:	c3                   	ret    

801064d5 <sys_chdir>:

int
sys_chdir(void)
{
801064d5:	55                   	push   %ebp
801064d6:	89 e5                	mov    %esp,%ebp
801064d8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801064db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064de:	89 44 24 04          	mov    %eax,0x4(%esp)
801064e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064e9:	e8 42 f4 ff ff       	call   80105930 <argstr>
801064ee:	85 c0                	test   %eax,%eax
801064f0:	78 14                	js     80106506 <sys_chdir+0x31>
801064f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f5:	89 04 24             	mov    %eax,(%esp)
801064f8:	e8 01 bf ff ff       	call   801023fe <namei>
801064fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106504:	75 07                	jne    8010650d <sys_chdir+0x38>
    return -1;
80106506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650b:	eb 57                	jmp    80106564 <sys_chdir+0x8f>
  ilock(ip);
8010650d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106510:	89 04 24             	mov    %eax,(%esp)
80106513:	e8 3b b3 ff ff       	call   80101853 <ilock>
  if(ip->type != T_DIR){
80106518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010651f:	66 83 f8 01          	cmp    $0x1,%ax
80106523:	74 12                	je     80106537 <sys_chdir+0x62>
    iunlockput(ip);
80106525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106528:	89 04 24             	mov    %eax,(%esp)
8010652b:	e8 a7 b5 ff ff       	call   80101ad7 <iunlockput>
    return -1;
80106530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106535:	eb 2d                	jmp    80106564 <sys_chdir+0x8f>
  }
  iunlock(ip);
80106537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653a:	89 04 24             	mov    %eax,(%esp)
8010653d:	e8 5f b4 ff ff       	call   801019a1 <iunlock>
  iput(proc->cwd);
80106542:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106548:	8b 40 68             	mov    0x68(%eax),%eax
8010654b:	89 04 24             	mov    %eax,(%esp)
8010654e:	e8 b3 b4 ff ff       	call   80101a06 <iput>
  proc->cwd = ip;
80106553:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010655c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010655f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106564:	c9                   	leave  
80106565:	c3                   	ret    

80106566 <sys_exec>:

int
sys_exec(void)
{
80106566:	55                   	push   %ebp
80106567:	89 e5                	mov    %esp,%ebp
80106569:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010656f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106572:	89 44 24 04          	mov    %eax,0x4(%esp)
80106576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010657d:	e8 ae f3 ff ff       	call   80105930 <argstr>
80106582:	85 c0                	test   %eax,%eax
80106584:	78 1a                	js     801065a0 <sys_exec+0x3a>
80106586:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010658c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106597:	e8 04 f3 ff ff       	call   801058a0 <argint>
8010659c:	85 c0                	test   %eax,%eax
8010659e:	79 0a                	jns    801065aa <sys_exec+0x44>
    return -1;
801065a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a5:	e9 c8 00 00 00       	jmp    80106672 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801065aa:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801065b1:	00 
801065b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065b9:	00 
801065ba:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065c0:	89 04 24             	mov    %eax,(%esp)
801065c3:	e8 96 ef ff ff       	call   8010555e <memset>
  for(i=0;; i++){
801065c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d2:	83 f8 1f             	cmp    $0x1f,%eax
801065d5:	76 0a                	jbe    801065e1 <sys_exec+0x7b>
      return -1;
801065d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065dc:	e9 91 00 00 00       	jmp    80106672 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801065e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e4:	c1 e0 02             	shl    $0x2,%eax
801065e7:	89 c2                	mov    %eax,%edx
801065e9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065ef:	01 c2                	add    %eax,%edx
801065f1:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801065fb:	89 14 24             	mov    %edx,(%esp)
801065fe:	e8 01 f2 ff ff       	call   80105804 <fetchint>
80106603:	85 c0                	test   %eax,%eax
80106605:	79 07                	jns    8010660e <sys_exec+0xa8>
      return -1;
80106607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660c:	eb 64                	jmp    80106672 <sys_exec+0x10c>
    if(uarg == 0){
8010660e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106614:	85 c0                	test   %eax,%eax
80106616:	75 26                	jne    8010663e <sys_exec+0xd8>
      argv[i] = 0;
80106618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106622:	00 00 00 00 
      break;
80106626:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106630:	89 54 24 04          	mov    %edx,0x4(%esp)
80106634:	89 04 24             	mov    %eax,(%esp)
80106637:	e8 b3 a4 ff ff       	call   80100aef <exec>
8010663c:	eb 34                	jmp    80106672 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010663e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106644:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106647:	c1 e2 02             	shl    $0x2,%edx
8010664a:	01 c2                	add    %eax,%edx
8010664c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106652:	89 54 24 04          	mov    %edx,0x4(%esp)
80106656:	89 04 24             	mov    %eax,(%esp)
80106659:	e8 e0 f1 ff ff       	call   8010583e <fetchstr>
8010665e:	85 c0                	test   %eax,%eax
80106660:	79 07                	jns    80106669 <sys_exec+0x103>
      return -1;
80106662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106667:	eb 09                	jmp    80106672 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106669:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010666d:	e9 5d ff ff ff       	jmp    801065cf <sys_exec+0x69>
  return exec(path, argv);
}
80106672:	c9                   	leave  
80106673:	c3                   	ret    

80106674 <sys_pipe>:

int
sys_pipe(void)
{
80106674:	55                   	push   %ebp
80106675:	89 e5                	mov    %esp,%ebp
80106677:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010667a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106681:	00 
80106682:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106685:	89 44 24 04          	mov    %eax,0x4(%esp)
80106689:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106690:	e8 39 f2 ff ff       	call   801058ce <argptr>
80106695:	85 c0                	test   %eax,%eax
80106697:	79 0a                	jns    801066a3 <sys_pipe+0x2f>
    return -1;
80106699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669e:	e9 9b 00 00 00       	jmp    8010673e <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801066a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801066aa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066ad:	89 04 24             	mov    %eax,(%esp)
801066b0:	e8 f8 d5 ff ff       	call   80103cad <pipealloc>
801066b5:	85 c0                	test   %eax,%eax
801066b7:	79 07                	jns    801066c0 <sys_pipe+0x4c>
    return -1;
801066b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066be:	eb 7e                	jmp    8010673e <sys_pipe+0xca>
  fd0 = -1;
801066c0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066ca:	89 04 24             	mov    %eax,(%esp)
801066cd:	e8 99 f3 ff ff       	call   80105a6b <fdalloc>
801066d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066d9:	78 14                	js     801066ef <sys_pipe+0x7b>
801066db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066de:	89 04 24             	mov    %eax,(%esp)
801066e1:	e8 85 f3 ff ff       	call   80105a6b <fdalloc>
801066e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066ed:	79 37                	jns    80106726 <sys_pipe+0xb2>
    if(fd0 >= 0)
801066ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066f3:	78 14                	js     80106709 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801066f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066fe:	83 c2 08             	add    $0x8,%edx
80106701:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106708:	00 
    fileclose(rf);
80106709:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010670c:	89 04 24             	mov    %eax,(%esp)
8010670f:	e8 b2 a8 ff ff       	call   80100fc6 <fileclose>
    fileclose(wf);
80106714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106717:	89 04 24             	mov    %eax,(%esp)
8010671a:	e8 a7 a8 ff ff       	call   80100fc6 <fileclose>
    return -1;
8010671f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106724:	eb 18                	jmp    8010673e <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106726:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106729:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010672c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010672e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106731:	8d 50 04             	lea    0x4(%eax),%edx
80106734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106737:	89 02                	mov    %eax,(%edx)
  return 0;
80106739:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010673e:	c9                   	leave  
8010673f:	c3                   	ret    

80106740 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106746:	e8 92 dc ff ff       	call   801043dd <fork>
}
8010674b:	c9                   	leave  
8010674c:	c3                   	ret    

8010674d <sys_clone>:

int
sys_clone(){
8010674d:	55                   	push   %ebp
8010674e:	89 e5                	mov    %esp,%ebp
80106750:	53                   	push   %ebx
80106751:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106754:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010675b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106762:	e8 39 f1 ff ff       	call   801058a0 <argint>
80106767:	85 c0                	test   %eax,%eax
80106769:	78 4c                	js     801067b7 <sys_clone+0x6a>
8010676b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676e:	85 c0                	test   %eax,%eax
80106770:	7e 45                	jle    801067b7 <sys_clone+0x6a>
80106772:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106775:	89 44 24 04          	mov    %eax,0x4(%esp)
80106779:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106780:	e8 1b f1 ff ff       	call   801058a0 <argint>
80106785:	85 c0                	test   %eax,%eax
80106787:	78 2e                	js     801067b7 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106789:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010678c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106790:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106797:	e8 04 f1 ff ff       	call   801058a0 <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
8010679c:	85 c0                	test   %eax,%eax
8010679e:	78 17                	js     801067b7 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
801067a0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801067a7:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
801067ae:	e8 ed f0 ff ff       	call   801058a0 <argint>
801067b3:	85 c0                	test   %eax,%eax
801067b5:	79 07                	jns    801067be <sys_clone+0x71>
        return -1;
801067b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067bc:	eb 20                	jmp    801067de <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
801067be:	8b 5d e8             	mov    -0x18(%ebp),%ebx
801067c1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801067c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801067c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801067ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801067d6:	89 04 24             	mov    %eax,(%esp)
801067d9:	e8 6f dd ff ff       	call   8010454d <clone>
}
801067de:	83 c4 24             	add    $0x24,%esp
801067e1:	5b                   	pop    %ebx
801067e2:	5d                   	pop    %ebp
801067e3:	c3                   	ret    

801067e4 <sys_exit>:

int
sys_exit(void)
{
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	83 ec 08             	sub    $0x8,%esp
  exit();
801067ea:	e8 81 df ff ff       	call   80104770 <exit>
  return 0;  // not reached
801067ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067f4:	c9                   	leave  
801067f5:	c3                   	ret    

801067f6 <sys_texit>:

int
sys_texit(void)
{
801067f6:	55                   	push   %ebp
801067f7:	89 e5                	mov    %esp,%ebp
801067f9:	83 ec 08             	sub    $0x8,%esp
    texit();
801067fc:	e8 8a e0 ff ff       	call   8010488b <texit>
    return 0;
80106801:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106806:	c9                   	leave  
80106807:	c3                   	ret    

80106808 <sys_wait>:

int
sys_wait(void)
{
80106808:	55                   	push   %ebp
80106809:	89 e5                	mov    %esp,%ebp
8010680b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010680e:	e8 46 e1 ff ff       	call   80104959 <wait>
}
80106813:	c9                   	leave  
80106814:	c3                   	ret    

80106815 <sys_kill>:

int
sys_kill(void)
{
80106815:	55                   	push   %ebp
80106816:	89 e5                	mov    %esp,%ebp
80106818:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010681b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010681e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106822:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106829:	e8 72 f0 ff ff       	call   801058a0 <argint>
8010682e:	85 c0                	test   %eax,%eax
80106830:	79 07                	jns    80106839 <sys_kill+0x24>
    return -1;
80106832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106837:	eb 0b                	jmp    80106844 <sys_kill+0x2f>
  return kill(pid);
80106839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010683c:	89 04 24             	mov    %eax,(%esp)
8010683f:	e8 78 e5 ff ff       	call   80104dbc <kill>
}
80106844:	c9                   	leave  
80106845:	c3                   	ret    

80106846 <sys_getpid>:

int
sys_getpid(void)
{
80106846:	55                   	push   %ebp
80106847:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106849:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010684f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106852:	5d                   	pop    %ebp
80106853:	c3                   	ret    

80106854 <sys_sbrk>:

int
sys_sbrk(void)
{
80106854:	55                   	push   %ebp
80106855:	89 e5                	mov    %esp,%ebp
80106857:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010685a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010685d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106868:	e8 33 f0 ff ff       	call   801058a0 <argint>
8010686d:	85 c0                	test   %eax,%eax
8010686f:	79 07                	jns    80106878 <sys_sbrk+0x24>
    return -1;
80106871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106876:	eb 24                	jmp    8010689c <sys_sbrk+0x48>
  addr = proc->sz;
80106878:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010687e:	8b 00                	mov    (%eax),%eax
80106880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106883:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106886:	89 04 24             	mov    %eax,(%esp)
80106889:	e8 aa da ff ff       	call   80104338 <growproc>
8010688e:	85 c0                	test   %eax,%eax
80106890:	79 07                	jns    80106899 <sys_sbrk+0x45>
    return -1;
80106892:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106897:	eb 03                	jmp    8010689c <sys_sbrk+0x48>
  return addr;
80106899:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010689c:	c9                   	leave  
8010689d:	c3                   	ret    

8010689e <sys_sleep>:

int
sys_sleep(void)
{
8010689e:	55                   	push   %ebp
8010689f:	89 e5                	mov    %esp,%ebp
801068a1:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801068a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068b2:	e8 e9 ef ff ff       	call   801058a0 <argint>
801068b7:	85 c0                	test   %eax,%eax
801068b9:	79 07                	jns    801068c2 <sys_sleep+0x24>
    return -1;
801068bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c0:	eb 6c                	jmp    8010692e <sys_sleep+0x90>
  acquire(&tickslock);
801068c2:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801068c9:	e8 3c ea ff ff       	call   8010530a <acquire>
  ticks0 = ticks;
801068ce:	a1 c0 38 11 80       	mov    0x801138c0,%eax
801068d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801068d6:	eb 34                	jmp    8010690c <sys_sleep+0x6e>
    if(proc->killed){
801068d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068de:	8b 40 24             	mov    0x24(%eax),%eax
801068e1:	85 c0                	test   %eax,%eax
801068e3:	74 13                	je     801068f8 <sys_sleep+0x5a>
      release(&tickslock);
801068e5:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801068ec:	e8 7b ea ff ff       	call   8010536c <release>
      return -1;
801068f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f6:	eb 36                	jmp    8010692e <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801068f8:	c7 44 24 04 80 30 11 	movl   $0x80113080,0x4(%esp)
801068ff:	80 
80106900:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80106907:	e8 41 e3 ff ff       	call   80104c4d <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010690c:	a1 c0 38 11 80       	mov    0x801138c0,%eax
80106911:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106914:	89 c2                	mov    %eax,%edx
80106916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106919:	39 c2                	cmp    %eax,%edx
8010691b:	72 bb                	jb     801068d8 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010691d:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80106924:	e8 43 ea ff ff       	call   8010536c <release>
  return 0;
80106929:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010692e:	c9                   	leave  
8010692f:	c3                   	ret    

80106930 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106936:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
8010693d:	e8 c8 e9 ff ff       	call   8010530a <acquire>
  xticks = ticks;
80106942:	a1 c0 38 11 80       	mov    0x801138c0,%eax
80106947:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010694a:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80106951:	e8 16 ea ff ff       	call   8010536c <release>
  return xticks;
80106956:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106959:	c9                   	leave  
8010695a:	c3                   	ret    

8010695b <sys_tsleep>:

int
sys_tsleep(void)
{
8010695b:	55                   	push   %ebp
8010695c:	89 e5                	mov    %esp,%ebp
8010695e:	83 ec 08             	sub    $0x8,%esp
    tsleep();
80106961:	e8 cb e5 ff ff       	call   80104f31 <tsleep>
    return 0;
80106966:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010696b:	c9                   	leave  
8010696c:	c3                   	ret    

8010696d <sys_twakeup>:

int 
sys_twakeup(void)
{
8010696d:	55                   	push   %ebp
8010696e:	89 e5                	mov    %esp,%ebp
80106970:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
80106973:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106976:	89 44 24 04          	mov    %eax,0x4(%esp)
8010697a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106981:	e8 1a ef ff ff       	call   801058a0 <argint>
80106986:	85 c0                	test   %eax,%eax
80106988:	79 07                	jns    80106991 <sys_twakeup+0x24>
        return -1;
8010698a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010698f:	eb 10                	jmp    801069a1 <sys_twakeup+0x34>
    }
        twakeup(tid);
80106991:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106994:	89 04 24             	mov    %eax,(%esp)
80106997:	e8 8d e3 ff ff       	call   80104d29 <twakeup>
        return 0;
8010699c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a1:	c9                   	leave  
801069a2:	c3                   	ret    

801069a3 <sys_thread_yield>:

/////////////////////////////////////////
int
sys_thread_yield(void)
{
801069a3:	55                   	push   %ebp
801069a4:	89 e5                	mov    %esp,%ebp
801069a6:	83 ec 08             	sub    $0x8,%esp
  //cprintf("Yielded_1\n");
  //yield();
  thread_yield();
801069a9:	e8 c7 e6 ff ff       	call   80105075 <thread_yield>
  //cprintf("Yielded_2\n");
  return 0;
801069ae:	b8 00 00 00 00       	mov    $0x0,%eax
801069b3:	c9                   	leave  
801069b4:	c3                   	ret    

801069b5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801069b5:	55                   	push   %ebp
801069b6:	89 e5                	mov    %esp,%ebp
801069b8:	83 ec 08             	sub    $0x8,%esp
801069bb:	8b 55 08             	mov    0x8(%ebp),%edx
801069be:	8b 45 0c             	mov    0xc(%ebp),%eax
801069c1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069c5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069c8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069cc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069d0:	ee                   	out    %al,(%dx)
}
801069d1:	c9                   	leave  
801069d2:	c3                   	ret    

801069d3 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801069d3:	55                   	push   %ebp
801069d4:	89 e5                	mov    %esp,%ebp
801069d6:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801069d9:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801069e0:	00 
801069e1:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801069e8:	e8 c8 ff ff ff       	call   801069b5 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801069ed:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801069f4:	00 
801069f5:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801069fc:	e8 b4 ff ff ff       	call   801069b5 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a01:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106a08:	00 
80106a09:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a10:	e8 a0 ff ff ff       	call   801069b5 <outb>
  picenable(IRQ_TIMER);
80106a15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a1c:	e8 1f d1 ff ff       	call   80103b40 <picenable>
}
80106a21:	c9                   	leave  
80106a22:	c3                   	ret    

80106a23 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a23:	1e                   	push   %ds
  pushl %es
80106a24:	06                   	push   %es
  pushl %fs
80106a25:	0f a0                	push   %fs
  pushl %gs
80106a27:	0f a8                	push   %gs
  pushal
80106a29:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a2a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a2e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a30:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a32:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106a36:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106a38:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a3a:	54                   	push   %esp
  call trap
80106a3b:	e8 d8 01 00 00       	call   80106c18 <trap>
  addl $4, %esp
80106a40:	83 c4 04             	add    $0x4,%esp

80106a43 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a43:	61                   	popa   
  popl %gs
80106a44:	0f a9                	pop    %gs
  popl %fs
80106a46:	0f a1                	pop    %fs
  popl %es
80106a48:	07                   	pop    %es
  popl %ds
80106a49:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a4a:	83 c4 08             	add    $0x8,%esp
  iret
80106a4d:	cf                   	iret   

80106a4e <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a4e:	55                   	push   %ebp
80106a4f:	89 e5                	mov    %esp,%ebp
80106a51:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106a54:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a57:	83 e8 01             	sub    $0x1,%eax
80106a5a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a61:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a65:	8b 45 08             	mov    0x8(%ebp),%eax
80106a68:	c1 e8 10             	shr    $0x10,%eax
80106a6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106a6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a72:	0f 01 18             	lidtl  (%eax)
}
80106a75:	c9                   	leave  
80106a76:	c3                   	ret    

80106a77 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106a77:	55                   	push   %ebp
80106a78:	89 e5                	mov    %esp,%ebp
80106a7a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a7d:	0f 20 d0             	mov    %cr2,%eax
80106a80:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a86:	c9                   	leave  
80106a87:	c3                   	ret    

80106a88 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a88:	55                   	push   %ebp
80106a89:	89 e5                	mov    %esp,%ebp
80106a8b:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a95:	e9 c3 00 00 00       	jmp    80106b5d <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a9d:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106aa4:	89 c2                	mov    %eax,%edx
80106aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa9:	66 89 14 c5 c0 30 11 	mov    %dx,-0x7feecf40(,%eax,8)
80106ab0:	80 
80106ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab4:	66 c7 04 c5 c2 30 11 	movw   $0x8,-0x7feecf3e(,%eax,8)
80106abb:	80 08 00 
80106abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ac1:	0f b6 14 c5 c4 30 11 	movzbl -0x7feecf3c(,%eax,8),%edx
80106ac8:	80 
80106ac9:	83 e2 e0             	and    $0xffffffe0,%edx
80106acc:	88 14 c5 c4 30 11 80 	mov    %dl,-0x7feecf3c(,%eax,8)
80106ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ad6:	0f b6 14 c5 c4 30 11 	movzbl -0x7feecf3c(,%eax,8),%edx
80106add:	80 
80106ade:	83 e2 1f             	and    $0x1f,%edx
80106ae1:	88 14 c5 c4 30 11 80 	mov    %dl,-0x7feecf3c(,%eax,8)
80106ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aeb:	0f b6 14 c5 c5 30 11 	movzbl -0x7feecf3b(,%eax,8),%edx
80106af2:	80 
80106af3:	83 e2 f0             	and    $0xfffffff0,%edx
80106af6:	83 ca 0e             	or     $0xe,%edx
80106af9:	88 14 c5 c5 30 11 80 	mov    %dl,-0x7feecf3b(,%eax,8)
80106b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b03:	0f b6 14 c5 c5 30 11 	movzbl -0x7feecf3b(,%eax,8),%edx
80106b0a:	80 
80106b0b:	83 e2 ef             	and    $0xffffffef,%edx
80106b0e:	88 14 c5 c5 30 11 80 	mov    %dl,-0x7feecf3b(,%eax,8)
80106b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b18:	0f b6 14 c5 c5 30 11 	movzbl -0x7feecf3b(,%eax,8),%edx
80106b1f:	80 
80106b20:	83 e2 9f             	and    $0xffffff9f,%edx
80106b23:	88 14 c5 c5 30 11 80 	mov    %dl,-0x7feecf3b(,%eax,8)
80106b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2d:	0f b6 14 c5 c5 30 11 	movzbl -0x7feecf3b(,%eax,8),%edx
80106b34:	80 
80106b35:	83 ca 80             	or     $0xffffff80,%edx
80106b38:	88 14 c5 c5 30 11 80 	mov    %dl,-0x7feecf3b(,%eax,8)
80106b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b42:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b49:	c1 e8 10             	shr    $0x10,%eax
80106b4c:	89 c2                	mov    %eax,%edx
80106b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b51:	66 89 14 c5 c6 30 11 	mov    %dx,-0x7feecf3a(,%eax,8)
80106b58:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106b59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b5d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106b64:	0f 8e 30 ff ff ff    	jle    80106a9a <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b6a:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106b6f:	66 a3 c0 32 11 80    	mov    %ax,0x801132c0
80106b75:	66 c7 05 c2 32 11 80 	movw   $0x8,0x801132c2
80106b7c:	08 00 
80106b7e:	0f b6 05 c4 32 11 80 	movzbl 0x801132c4,%eax
80106b85:	83 e0 e0             	and    $0xffffffe0,%eax
80106b88:	a2 c4 32 11 80       	mov    %al,0x801132c4
80106b8d:	0f b6 05 c4 32 11 80 	movzbl 0x801132c4,%eax
80106b94:	83 e0 1f             	and    $0x1f,%eax
80106b97:	a2 c4 32 11 80       	mov    %al,0x801132c4
80106b9c:	0f b6 05 c5 32 11 80 	movzbl 0x801132c5,%eax
80106ba3:	83 c8 0f             	or     $0xf,%eax
80106ba6:	a2 c5 32 11 80       	mov    %al,0x801132c5
80106bab:	0f b6 05 c5 32 11 80 	movzbl 0x801132c5,%eax
80106bb2:	83 e0 ef             	and    $0xffffffef,%eax
80106bb5:	a2 c5 32 11 80       	mov    %al,0x801132c5
80106bba:	0f b6 05 c5 32 11 80 	movzbl 0x801132c5,%eax
80106bc1:	83 c8 60             	or     $0x60,%eax
80106bc4:	a2 c5 32 11 80       	mov    %al,0x801132c5
80106bc9:	0f b6 05 c5 32 11 80 	movzbl 0x801132c5,%eax
80106bd0:	83 c8 80             	or     $0xffffff80,%eax
80106bd3:	a2 c5 32 11 80       	mov    %al,0x801132c5
80106bd8:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106bdd:	c1 e8 10             	shr    $0x10,%eax
80106be0:	66 a3 c6 32 11 80    	mov    %ax,0x801132c6
  
  initlock(&tickslock, "time");
80106be6:	c7 44 24 04 9c 8e 10 	movl   $0x80108e9c,0x4(%esp)
80106bed:	80 
80106bee:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80106bf5:	e8 ef e6 ff ff       	call   801052e9 <initlock>
}
80106bfa:	c9                   	leave  
80106bfb:	c3                   	ret    

80106bfc <idtinit>:

void
idtinit(void)
{
80106bfc:	55                   	push   %ebp
80106bfd:	89 e5                	mov    %esp,%ebp
80106bff:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106c02:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106c09:	00 
80106c0a:	c7 04 24 c0 30 11 80 	movl   $0x801130c0,(%esp)
80106c11:	e8 38 fe ff ff       	call   80106a4e <lidt>
}
80106c16:	c9                   	leave  
80106c17:	c3                   	ret    

80106c18 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c18:	55                   	push   %ebp
80106c19:	89 e5                	mov    %esp,%ebp
80106c1b:	57                   	push   %edi
80106c1c:	56                   	push   %esi
80106c1d:	53                   	push   %ebx
80106c1e:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106c21:	8b 45 08             	mov    0x8(%ebp),%eax
80106c24:	8b 40 30             	mov    0x30(%eax),%eax
80106c27:	83 f8 40             	cmp    $0x40,%eax
80106c2a:	75 3f                	jne    80106c6b <trap+0x53>
    if(proc->killed)
80106c2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c32:	8b 40 24             	mov    0x24(%eax),%eax
80106c35:	85 c0                	test   %eax,%eax
80106c37:	74 05                	je     80106c3e <trap+0x26>
      exit();
80106c39:	e8 32 db ff ff       	call   80104770 <exit>
    proc->tf = tf;
80106c3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c44:	8b 55 08             	mov    0x8(%ebp),%edx
80106c47:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c4a:	e8 18 ed ff ff       	call   80105967 <syscall>
    if(proc->killed)
80106c4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c55:	8b 40 24             	mov    0x24(%eax),%eax
80106c58:	85 c0                	test   %eax,%eax
80106c5a:	74 0a                	je     80106c66 <trap+0x4e>
      exit();
80106c5c:	e8 0f db ff ff       	call   80104770 <exit>
    return;
80106c61:	e9 2d 02 00 00       	jmp    80106e93 <trap+0x27b>
80106c66:	e9 28 02 00 00       	jmp    80106e93 <trap+0x27b>
  }

  switch(tf->trapno){
80106c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6e:	8b 40 30             	mov    0x30(%eax),%eax
80106c71:	83 e8 20             	sub    $0x20,%eax
80106c74:	83 f8 1f             	cmp    $0x1f,%eax
80106c77:	0f 87 bc 00 00 00    	ja     80106d39 <trap+0x121>
80106c7d:	8b 04 85 44 8f 10 80 	mov    -0x7fef70bc(,%eax,4),%eax
80106c84:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106c86:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c8c:	0f b6 00             	movzbl (%eax),%eax
80106c8f:	84 c0                	test   %al,%al
80106c91:	75 31                	jne    80106cc4 <trap+0xac>
      acquire(&tickslock);
80106c93:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80106c9a:	e8 6b e6 ff ff       	call   8010530a <acquire>
      ticks++;
80106c9f:	a1 c0 38 11 80       	mov    0x801138c0,%eax
80106ca4:	83 c0 01             	add    $0x1,%eax
80106ca7:	a3 c0 38 11 80       	mov    %eax,0x801138c0
      wakeup(&ticks);
80106cac:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80106cb3:	e8 d9 e0 ff ff       	call   80104d91 <wakeup>
      release(&tickslock);
80106cb8:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80106cbf:	e8 a8 e6 ff ff       	call   8010536c <release>
    }
    lapiceoi();
80106cc4:	e8 c8 c2 ff ff       	call   80102f91 <lapiceoi>
    break;
80106cc9:	e9 41 01 00 00       	jmp    80106e0f <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106cce:	e8 03 ba ff ff       	call   801026d6 <ideintr>
    lapiceoi();
80106cd3:	e8 b9 c2 ff ff       	call   80102f91 <lapiceoi>
    break;
80106cd8:	e9 32 01 00 00       	jmp    80106e0f <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106cdd:	e8 9b c0 ff ff       	call   80102d7d <kbdintr>
    lapiceoi();
80106ce2:	e8 aa c2 ff ff       	call   80102f91 <lapiceoi>
    break;
80106ce7:	e9 23 01 00 00       	jmp    80106e0f <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106cec:	e8 97 03 00 00       	call   80107088 <uartintr>
    lapiceoi();
80106cf1:	e8 9b c2 ff ff       	call   80102f91 <lapiceoi>
    break;
80106cf6:	e9 14 01 00 00       	jmp    80106e0f <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cfe:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d01:	8b 45 08             	mov    0x8(%ebp),%eax
80106d04:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d08:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d0b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d11:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d14:	0f b6 c0             	movzbl %al,%eax
80106d17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d23:	c7 04 24 a4 8e 10 80 	movl   $0x80108ea4,(%esp)
80106d2a:	e8 71 96 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d2f:	e8 5d c2 ff ff       	call   80102f91 <lapiceoi>
    break;
80106d34:	e9 d6 00 00 00       	jmp    80106e0f <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106d39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d3f:	85 c0                	test   %eax,%eax
80106d41:	74 11                	je     80106d54 <trap+0x13c>
80106d43:	8b 45 08             	mov    0x8(%ebp),%eax
80106d46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d4a:	0f b7 c0             	movzwl %ax,%eax
80106d4d:	83 e0 03             	and    $0x3,%eax
80106d50:	85 c0                	test   %eax,%eax
80106d52:	75 46                	jne    80106d9a <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d54:	e8 1e fd ff ff       	call   80106a77 <rcr2>
80106d59:	8b 55 08             	mov    0x8(%ebp),%edx
80106d5c:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106d5f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106d66:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d69:	0f b6 ca             	movzbl %dl,%ecx
80106d6c:	8b 55 08             	mov    0x8(%ebp),%edx
80106d6f:	8b 52 30             	mov    0x30(%edx),%edx
80106d72:	89 44 24 10          	mov    %eax,0x10(%esp)
80106d76:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106d7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106d7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d82:	c7 04 24 c8 8e 10 80 	movl   $0x80108ec8,(%esp)
80106d89:	e8 12 96 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106d8e:	c7 04 24 fa 8e 10 80 	movl   $0x80108efa,(%esp)
80106d95:	e8 a0 97 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d9a:	e8 d8 fc ff ff       	call   80106a77 <rcr2>
80106d9f:	89 c2                	mov    %eax,%edx
80106da1:	8b 45 08             	mov    0x8(%ebp),%eax
80106da4:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106da7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106dad:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106db0:	0f b6 f0             	movzbl %al,%esi
80106db3:	8b 45 08             	mov    0x8(%ebp),%eax
80106db6:	8b 58 34             	mov    0x34(%eax),%ebx
80106db9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbc:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc5:	83 c0 6c             	add    $0x6c,%eax
80106dc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106dd1:	8b 40 10             	mov    0x10(%eax),%eax
80106dd4:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106dd8:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106ddc:	89 74 24 14          	mov    %esi,0x14(%esp)
80106de0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106de4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106de8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106deb:	89 74 24 08          	mov    %esi,0x8(%esp)
80106def:	89 44 24 04          	mov    %eax,0x4(%esp)
80106df3:	c7 04 24 00 8f 10 80 	movl   $0x80108f00,(%esp)
80106dfa:	e8 a1 95 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106dff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e05:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106e0c:	eb 01                	jmp    80106e0f <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106e0e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106e0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e15:	85 c0                	test   %eax,%eax
80106e17:	74 24                	je     80106e3d <trap+0x225>
80106e19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e1f:	8b 40 24             	mov    0x24(%eax),%eax
80106e22:	85 c0                	test   %eax,%eax
80106e24:	74 17                	je     80106e3d <trap+0x225>
80106e26:	8b 45 08             	mov    0x8(%ebp),%eax
80106e29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e2d:	0f b7 c0             	movzwl %ax,%eax
80106e30:	83 e0 03             	and    $0x3,%eax
80106e33:	83 f8 03             	cmp    $0x3,%eax
80106e36:	75 05                	jne    80106e3d <trap+0x225>
    exit();
80106e38:	e8 33 d9 ff ff       	call   80104770 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106e3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e43:	85 c0                	test   %eax,%eax
80106e45:	74 1e                	je     80106e65 <trap+0x24d>
80106e47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e4d:	8b 40 0c             	mov    0xc(%eax),%eax
80106e50:	83 f8 04             	cmp    $0x4,%eax
80106e53:	75 10                	jne    80106e65 <trap+0x24d>
80106e55:	8b 45 08             	mov    0x8(%ebp),%eax
80106e58:	8b 40 30             	mov    0x30(%eax),%eax
80106e5b:	83 f8 20             	cmp    $0x20,%eax
80106e5e:	75 05                	jne    80106e65 <trap+0x24d>
    yield();
80106e60:	e8 8a dd ff ff       	call   80104bef <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e6b:	85 c0                	test   %eax,%eax
80106e6d:	74 24                	je     80106e93 <trap+0x27b>
80106e6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e75:	8b 40 24             	mov    0x24(%eax),%eax
80106e78:	85 c0                	test   %eax,%eax
80106e7a:	74 17                	je     80106e93 <trap+0x27b>
80106e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e83:	0f b7 c0             	movzwl %ax,%eax
80106e86:	83 e0 03             	and    $0x3,%eax
80106e89:	83 f8 03             	cmp    $0x3,%eax
80106e8c:	75 05                	jne    80106e93 <trap+0x27b>
    exit();
80106e8e:	e8 dd d8 ff ff       	call   80104770 <exit>
}
80106e93:	83 c4 3c             	add    $0x3c,%esp
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	5f                   	pop    %edi
80106e99:	5d                   	pop    %ebp
80106e9a:	c3                   	ret    

80106e9b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106e9b:	55                   	push   %ebp
80106e9c:	89 e5                	mov    %esp,%ebp
80106e9e:	83 ec 14             	sub    $0x14,%esp
80106ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ea8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106eac:	89 c2                	mov    %eax,%edx
80106eae:	ec                   	in     (%dx),%al
80106eaf:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106eb2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106eb6:	c9                   	leave  
80106eb7:	c3                   	ret    

80106eb8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106eb8:	55                   	push   %ebp
80106eb9:	89 e5                	mov    %esp,%ebp
80106ebb:	83 ec 08             	sub    $0x8,%esp
80106ebe:	8b 55 08             	mov    0x8(%ebp),%edx
80106ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ec4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ec8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ecb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ecf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ed3:	ee                   	out    %al,(%dx)
}
80106ed4:	c9                   	leave  
80106ed5:	c3                   	ret    

80106ed6 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ed6:	55                   	push   %ebp
80106ed7:	89 e5                	mov    %esp,%ebp
80106ed9:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106edc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ee3:	00 
80106ee4:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106eeb:	e8 c8 ff ff ff       	call   80106eb8 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106ef0:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106ef7:	00 
80106ef8:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106eff:	e8 b4 ff ff ff       	call   80106eb8 <outb>
  outb(COM1+0, 115200/9600);
80106f04:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106f0b:	00 
80106f0c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f13:	e8 a0 ff ff ff       	call   80106eb8 <outb>
  outb(COM1+1, 0);
80106f18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f1f:	00 
80106f20:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106f27:	e8 8c ff ff ff       	call   80106eb8 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106f2c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106f33:	00 
80106f34:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106f3b:	e8 78 ff ff ff       	call   80106eb8 <outb>
  outb(COM1+4, 0);
80106f40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f47:	00 
80106f48:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106f4f:	e8 64 ff ff ff       	call   80106eb8 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106f54:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106f5b:	00 
80106f5c:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106f63:	e8 50 ff ff ff       	call   80106eb8 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106f68:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106f6f:	e8 27 ff ff ff       	call   80106e9b <inb>
80106f74:	3c ff                	cmp    $0xff,%al
80106f76:	75 02                	jne    80106f7a <uartinit+0xa4>
    return;
80106f78:	eb 6a                	jmp    80106fe4 <uartinit+0x10e>
  uart = 1;
80106f7a:	c7 05 74 c6 10 80 01 	movl   $0x1,0x8010c674
80106f81:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106f84:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106f8b:	e8 0b ff ff ff       	call   80106e9b <inb>
  inb(COM1+0);
80106f90:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f97:	e8 ff fe ff ff       	call   80106e9b <inb>
  picenable(IRQ_COM1);
80106f9c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106fa3:	e8 98 cb ff ff       	call   80103b40 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106fa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106faf:	00 
80106fb0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106fb7:	e8 99 b9 ff ff       	call   80102955 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106fbc:	c7 45 f4 c4 8f 10 80 	movl   $0x80108fc4,-0xc(%ebp)
80106fc3:	eb 15                	jmp    80106fda <uartinit+0x104>
    uartputc(*p);
80106fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc8:	0f b6 00             	movzbl (%eax),%eax
80106fcb:	0f be c0             	movsbl %al,%eax
80106fce:	89 04 24             	mov    %eax,(%esp)
80106fd1:	e8 10 00 00 00       	call   80106fe6 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106fd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fdd:	0f b6 00             	movzbl (%eax),%eax
80106fe0:	84 c0                	test   %al,%al
80106fe2:	75 e1                	jne    80106fc5 <uartinit+0xef>
    uartputc(*p);
}
80106fe4:	c9                   	leave  
80106fe5:	c3                   	ret    

80106fe6 <uartputc>:

void
uartputc(int c)
{
80106fe6:	55                   	push   %ebp
80106fe7:	89 e5                	mov    %esp,%ebp
80106fe9:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106fec:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80106ff1:	85 c0                	test   %eax,%eax
80106ff3:	75 02                	jne    80106ff7 <uartputc+0x11>
    return;
80106ff5:	eb 4b                	jmp    80107042 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ff7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ffe:	eb 10                	jmp    80107010 <uartputc+0x2a>
    microdelay(10);
80107000:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107007:	e8 aa bf ff ff       	call   80102fb6 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010700c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107010:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107014:	7f 16                	jg     8010702c <uartputc+0x46>
80107016:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010701d:	e8 79 fe ff ff       	call   80106e9b <inb>
80107022:	0f b6 c0             	movzbl %al,%eax
80107025:	83 e0 20             	and    $0x20,%eax
80107028:	85 c0                	test   %eax,%eax
8010702a:	74 d4                	je     80107000 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010702c:	8b 45 08             	mov    0x8(%ebp),%eax
8010702f:	0f b6 c0             	movzbl %al,%eax
80107032:	89 44 24 04          	mov    %eax,0x4(%esp)
80107036:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010703d:	e8 76 fe ff ff       	call   80106eb8 <outb>
}
80107042:	c9                   	leave  
80107043:	c3                   	ret    

80107044 <uartgetc>:

static int
uartgetc(void)
{
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010704a:	a1 74 c6 10 80       	mov    0x8010c674,%eax
8010704f:	85 c0                	test   %eax,%eax
80107051:	75 07                	jne    8010705a <uartgetc+0x16>
    return -1;
80107053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107058:	eb 2c                	jmp    80107086 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010705a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107061:	e8 35 fe ff ff       	call   80106e9b <inb>
80107066:	0f b6 c0             	movzbl %al,%eax
80107069:	83 e0 01             	and    $0x1,%eax
8010706c:	85 c0                	test   %eax,%eax
8010706e:	75 07                	jne    80107077 <uartgetc+0x33>
    return -1;
80107070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107075:	eb 0f                	jmp    80107086 <uartgetc+0x42>
  return inb(COM1+0);
80107077:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010707e:	e8 18 fe ff ff       	call   80106e9b <inb>
80107083:	0f b6 c0             	movzbl %al,%eax
}
80107086:	c9                   	leave  
80107087:	c3                   	ret    

80107088 <uartintr>:

void
uartintr(void)
{
80107088:	55                   	push   %ebp
80107089:	89 e5                	mov    %esp,%ebp
8010708b:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010708e:	c7 04 24 44 70 10 80 	movl   $0x80107044,(%esp)
80107095:	e8 13 97 ff ff       	call   801007ad <consoleintr>
}
8010709a:	c9                   	leave  
8010709b:	c3                   	ret    

8010709c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $0
8010709e:	6a 00                	push   $0x0
  jmp alltraps
801070a0:	e9 7e f9 ff ff       	jmp    80106a23 <alltraps>

801070a5 <vector1>:
.globl vector1
vector1:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $1
801070a7:	6a 01                	push   $0x1
  jmp alltraps
801070a9:	e9 75 f9 ff ff       	jmp    80106a23 <alltraps>

801070ae <vector2>:
.globl vector2
vector2:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $2
801070b0:	6a 02                	push   $0x2
  jmp alltraps
801070b2:	e9 6c f9 ff ff       	jmp    80106a23 <alltraps>

801070b7 <vector3>:
.globl vector3
vector3:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $3
801070b9:	6a 03                	push   $0x3
  jmp alltraps
801070bb:	e9 63 f9 ff ff       	jmp    80106a23 <alltraps>

801070c0 <vector4>:
.globl vector4
vector4:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $4
801070c2:	6a 04                	push   $0x4
  jmp alltraps
801070c4:	e9 5a f9 ff ff       	jmp    80106a23 <alltraps>

801070c9 <vector5>:
.globl vector5
vector5:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $5
801070cb:	6a 05                	push   $0x5
  jmp alltraps
801070cd:	e9 51 f9 ff ff       	jmp    80106a23 <alltraps>

801070d2 <vector6>:
.globl vector6
vector6:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $6
801070d4:	6a 06                	push   $0x6
  jmp alltraps
801070d6:	e9 48 f9 ff ff       	jmp    80106a23 <alltraps>

801070db <vector7>:
.globl vector7
vector7:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $7
801070dd:	6a 07                	push   $0x7
  jmp alltraps
801070df:	e9 3f f9 ff ff       	jmp    80106a23 <alltraps>

801070e4 <vector8>:
.globl vector8
vector8:
  pushl $8
801070e4:	6a 08                	push   $0x8
  jmp alltraps
801070e6:	e9 38 f9 ff ff       	jmp    80106a23 <alltraps>

801070eb <vector9>:
.globl vector9
vector9:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $9
801070ed:	6a 09                	push   $0x9
  jmp alltraps
801070ef:	e9 2f f9 ff ff       	jmp    80106a23 <alltraps>

801070f4 <vector10>:
.globl vector10
vector10:
  pushl $10
801070f4:	6a 0a                	push   $0xa
  jmp alltraps
801070f6:	e9 28 f9 ff ff       	jmp    80106a23 <alltraps>

801070fb <vector11>:
.globl vector11
vector11:
  pushl $11
801070fb:	6a 0b                	push   $0xb
  jmp alltraps
801070fd:	e9 21 f9 ff ff       	jmp    80106a23 <alltraps>

80107102 <vector12>:
.globl vector12
vector12:
  pushl $12
80107102:	6a 0c                	push   $0xc
  jmp alltraps
80107104:	e9 1a f9 ff ff       	jmp    80106a23 <alltraps>

80107109 <vector13>:
.globl vector13
vector13:
  pushl $13
80107109:	6a 0d                	push   $0xd
  jmp alltraps
8010710b:	e9 13 f9 ff ff       	jmp    80106a23 <alltraps>

80107110 <vector14>:
.globl vector14
vector14:
  pushl $14
80107110:	6a 0e                	push   $0xe
  jmp alltraps
80107112:	e9 0c f9 ff ff       	jmp    80106a23 <alltraps>

80107117 <vector15>:
.globl vector15
vector15:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $15
80107119:	6a 0f                	push   $0xf
  jmp alltraps
8010711b:	e9 03 f9 ff ff       	jmp    80106a23 <alltraps>

80107120 <vector16>:
.globl vector16
vector16:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $16
80107122:	6a 10                	push   $0x10
  jmp alltraps
80107124:	e9 fa f8 ff ff       	jmp    80106a23 <alltraps>

80107129 <vector17>:
.globl vector17
vector17:
  pushl $17
80107129:	6a 11                	push   $0x11
  jmp alltraps
8010712b:	e9 f3 f8 ff ff       	jmp    80106a23 <alltraps>

80107130 <vector18>:
.globl vector18
vector18:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $18
80107132:	6a 12                	push   $0x12
  jmp alltraps
80107134:	e9 ea f8 ff ff       	jmp    80106a23 <alltraps>

80107139 <vector19>:
.globl vector19
vector19:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $19
8010713b:	6a 13                	push   $0x13
  jmp alltraps
8010713d:	e9 e1 f8 ff ff       	jmp    80106a23 <alltraps>

80107142 <vector20>:
.globl vector20
vector20:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $20
80107144:	6a 14                	push   $0x14
  jmp alltraps
80107146:	e9 d8 f8 ff ff       	jmp    80106a23 <alltraps>

8010714b <vector21>:
.globl vector21
vector21:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $21
8010714d:	6a 15                	push   $0x15
  jmp alltraps
8010714f:	e9 cf f8 ff ff       	jmp    80106a23 <alltraps>

80107154 <vector22>:
.globl vector22
vector22:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $22
80107156:	6a 16                	push   $0x16
  jmp alltraps
80107158:	e9 c6 f8 ff ff       	jmp    80106a23 <alltraps>

8010715d <vector23>:
.globl vector23
vector23:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $23
8010715f:	6a 17                	push   $0x17
  jmp alltraps
80107161:	e9 bd f8 ff ff       	jmp    80106a23 <alltraps>

80107166 <vector24>:
.globl vector24
vector24:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $24
80107168:	6a 18                	push   $0x18
  jmp alltraps
8010716a:	e9 b4 f8 ff ff       	jmp    80106a23 <alltraps>

8010716f <vector25>:
.globl vector25
vector25:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $25
80107171:	6a 19                	push   $0x19
  jmp alltraps
80107173:	e9 ab f8 ff ff       	jmp    80106a23 <alltraps>

80107178 <vector26>:
.globl vector26
vector26:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $26
8010717a:	6a 1a                	push   $0x1a
  jmp alltraps
8010717c:	e9 a2 f8 ff ff       	jmp    80106a23 <alltraps>

80107181 <vector27>:
.globl vector27
vector27:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $27
80107183:	6a 1b                	push   $0x1b
  jmp alltraps
80107185:	e9 99 f8 ff ff       	jmp    80106a23 <alltraps>

8010718a <vector28>:
.globl vector28
vector28:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $28
8010718c:	6a 1c                	push   $0x1c
  jmp alltraps
8010718e:	e9 90 f8 ff ff       	jmp    80106a23 <alltraps>

80107193 <vector29>:
.globl vector29
vector29:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $29
80107195:	6a 1d                	push   $0x1d
  jmp alltraps
80107197:	e9 87 f8 ff ff       	jmp    80106a23 <alltraps>

8010719c <vector30>:
.globl vector30
vector30:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $30
8010719e:	6a 1e                	push   $0x1e
  jmp alltraps
801071a0:	e9 7e f8 ff ff       	jmp    80106a23 <alltraps>

801071a5 <vector31>:
.globl vector31
vector31:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $31
801071a7:	6a 1f                	push   $0x1f
  jmp alltraps
801071a9:	e9 75 f8 ff ff       	jmp    80106a23 <alltraps>

801071ae <vector32>:
.globl vector32
vector32:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $32
801071b0:	6a 20                	push   $0x20
  jmp alltraps
801071b2:	e9 6c f8 ff ff       	jmp    80106a23 <alltraps>

801071b7 <vector33>:
.globl vector33
vector33:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $33
801071b9:	6a 21                	push   $0x21
  jmp alltraps
801071bb:	e9 63 f8 ff ff       	jmp    80106a23 <alltraps>

801071c0 <vector34>:
.globl vector34
vector34:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $34
801071c2:	6a 22                	push   $0x22
  jmp alltraps
801071c4:	e9 5a f8 ff ff       	jmp    80106a23 <alltraps>

801071c9 <vector35>:
.globl vector35
vector35:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $35
801071cb:	6a 23                	push   $0x23
  jmp alltraps
801071cd:	e9 51 f8 ff ff       	jmp    80106a23 <alltraps>

801071d2 <vector36>:
.globl vector36
vector36:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $36
801071d4:	6a 24                	push   $0x24
  jmp alltraps
801071d6:	e9 48 f8 ff ff       	jmp    80106a23 <alltraps>

801071db <vector37>:
.globl vector37
vector37:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $37
801071dd:	6a 25                	push   $0x25
  jmp alltraps
801071df:	e9 3f f8 ff ff       	jmp    80106a23 <alltraps>

801071e4 <vector38>:
.globl vector38
vector38:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $38
801071e6:	6a 26                	push   $0x26
  jmp alltraps
801071e8:	e9 36 f8 ff ff       	jmp    80106a23 <alltraps>

801071ed <vector39>:
.globl vector39
vector39:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $39
801071ef:	6a 27                	push   $0x27
  jmp alltraps
801071f1:	e9 2d f8 ff ff       	jmp    80106a23 <alltraps>

801071f6 <vector40>:
.globl vector40
vector40:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $40
801071f8:	6a 28                	push   $0x28
  jmp alltraps
801071fa:	e9 24 f8 ff ff       	jmp    80106a23 <alltraps>

801071ff <vector41>:
.globl vector41
vector41:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $41
80107201:	6a 29                	push   $0x29
  jmp alltraps
80107203:	e9 1b f8 ff ff       	jmp    80106a23 <alltraps>

80107208 <vector42>:
.globl vector42
vector42:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $42
8010720a:	6a 2a                	push   $0x2a
  jmp alltraps
8010720c:	e9 12 f8 ff ff       	jmp    80106a23 <alltraps>

80107211 <vector43>:
.globl vector43
vector43:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $43
80107213:	6a 2b                	push   $0x2b
  jmp alltraps
80107215:	e9 09 f8 ff ff       	jmp    80106a23 <alltraps>

8010721a <vector44>:
.globl vector44
vector44:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $44
8010721c:	6a 2c                	push   $0x2c
  jmp alltraps
8010721e:	e9 00 f8 ff ff       	jmp    80106a23 <alltraps>

80107223 <vector45>:
.globl vector45
vector45:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $45
80107225:	6a 2d                	push   $0x2d
  jmp alltraps
80107227:	e9 f7 f7 ff ff       	jmp    80106a23 <alltraps>

8010722c <vector46>:
.globl vector46
vector46:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $46
8010722e:	6a 2e                	push   $0x2e
  jmp alltraps
80107230:	e9 ee f7 ff ff       	jmp    80106a23 <alltraps>

80107235 <vector47>:
.globl vector47
vector47:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $47
80107237:	6a 2f                	push   $0x2f
  jmp alltraps
80107239:	e9 e5 f7 ff ff       	jmp    80106a23 <alltraps>

8010723e <vector48>:
.globl vector48
vector48:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $48
80107240:	6a 30                	push   $0x30
  jmp alltraps
80107242:	e9 dc f7 ff ff       	jmp    80106a23 <alltraps>

80107247 <vector49>:
.globl vector49
vector49:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $49
80107249:	6a 31                	push   $0x31
  jmp alltraps
8010724b:	e9 d3 f7 ff ff       	jmp    80106a23 <alltraps>

80107250 <vector50>:
.globl vector50
vector50:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $50
80107252:	6a 32                	push   $0x32
  jmp alltraps
80107254:	e9 ca f7 ff ff       	jmp    80106a23 <alltraps>

80107259 <vector51>:
.globl vector51
vector51:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $51
8010725b:	6a 33                	push   $0x33
  jmp alltraps
8010725d:	e9 c1 f7 ff ff       	jmp    80106a23 <alltraps>

80107262 <vector52>:
.globl vector52
vector52:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $52
80107264:	6a 34                	push   $0x34
  jmp alltraps
80107266:	e9 b8 f7 ff ff       	jmp    80106a23 <alltraps>

8010726b <vector53>:
.globl vector53
vector53:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $53
8010726d:	6a 35                	push   $0x35
  jmp alltraps
8010726f:	e9 af f7 ff ff       	jmp    80106a23 <alltraps>

80107274 <vector54>:
.globl vector54
vector54:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $54
80107276:	6a 36                	push   $0x36
  jmp alltraps
80107278:	e9 a6 f7 ff ff       	jmp    80106a23 <alltraps>

8010727d <vector55>:
.globl vector55
vector55:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $55
8010727f:	6a 37                	push   $0x37
  jmp alltraps
80107281:	e9 9d f7 ff ff       	jmp    80106a23 <alltraps>

80107286 <vector56>:
.globl vector56
vector56:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $56
80107288:	6a 38                	push   $0x38
  jmp alltraps
8010728a:	e9 94 f7 ff ff       	jmp    80106a23 <alltraps>

8010728f <vector57>:
.globl vector57
vector57:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $57
80107291:	6a 39                	push   $0x39
  jmp alltraps
80107293:	e9 8b f7 ff ff       	jmp    80106a23 <alltraps>

80107298 <vector58>:
.globl vector58
vector58:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $58
8010729a:	6a 3a                	push   $0x3a
  jmp alltraps
8010729c:	e9 82 f7 ff ff       	jmp    80106a23 <alltraps>

801072a1 <vector59>:
.globl vector59
vector59:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $59
801072a3:	6a 3b                	push   $0x3b
  jmp alltraps
801072a5:	e9 79 f7 ff ff       	jmp    80106a23 <alltraps>

801072aa <vector60>:
.globl vector60
vector60:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $60
801072ac:	6a 3c                	push   $0x3c
  jmp alltraps
801072ae:	e9 70 f7 ff ff       	jmp    80106a23 <alltraps>

801072b3 <vector61>:
.globl vector61
vector61:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $61
801072b5:	6a 3d                	push   $0x3d
  jmp alltraps
801072b7:	e9 67 f7 ff ff       	jmp    80106a23 <alltraps>

801072bc <vector62>:
.globl vector62
vector62:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $62
801072be:	6a 3e                	push   $0x3e
  jmp alltraps
801072c0:	e9 5e f7 ff ff       	jmp    80106a23 <alltraps>

801072c5 <vector63>:
.globl vector63
vector63:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $63
801072c7:	6a 3f                	push   $0x3f
  jmp alltraps
801072c9:	e9 55 f7 ff ff       	jmp    80106a23 <alltraps>

801072ce <vector64>:
.globl vector64
vector64:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $64
801072d0:	6a 40                	push   $0x40
  jmp alltraps
801072d2:	e9 4c f7 ff ff       	jmp    80106a23 <alltraps>

801072d7 <vector65>:
.globl vector65
vector65:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $65
801072d9:	6a 41                	push   $0x41
  jmp alltraps
801072db:	e9 43 f7 ff ff       	jmp    80106a23 <alltraps>

801072e0 <vector66>:
.globl vector66
vector66:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $66
801072e2:	6a 42                	push   $0x42
  jmp alltraps
801072e4:	e9 3a f7 ff ff       	jmp    80106a23 <alltraps>

801072e9 <vector67>:
.globl vector67
vector67:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $67
801072eb:	6a 43                	push   $0x43
  jmp alltraps
801072ed:	e9 31 f7 ff ff       	jmp    80106a23 <alltraps>

801072f2 <vector68>:
.globl vector68
vector68:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $68
801072f4:	6a 44                	push   $0x44
  jmp alltraps
801072f6:	e9 28 f7 ff ff       	jmp    80106a23 <alltraps>

801072fb <vector69>:
.globl vector69
vector69:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $69
801072fd:	6a 45                	push   $0x45
  jmp alltraps
801072ff:	e9 1f f7 ff ff       	jmp    80106a23 <alltraps>

80107304 <vector70>:
.globl vector70
vector70:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $70
80107306:	6a 46                	push   $0x46
  jmp alltraps
80107308:	e9 16 f7 ff ff       	jmp    80106a23 <alltraps>

8010730d <vector71>:
.globl vector71
vector71:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $71
8010730f:	6a 47                	push   $0x47
  jmp alltraps
80107311:	e9 0d f7 ff ff       	jmp    80106a23 <alltraps>

80107316 <vector72>:
.globl vector72
vector72:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $72
80107318:	6a 48                	push   $0x48
  jmp alltraps
8010731a:	e9 04 f7 ff ff       	jmp    80106a23 <alltraps>

8010731f <vector73>:
.globl vector73
vector73:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $73
80107321:	6a 49                	push   $0x49
  jmp alltraps
80107323:	e9 fb f6 ff ff       	jmp    80106a23 <alltraps>

80107328 <vector74>:
.globl vector74
vector74:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $74
8010732a:	6a 4a                	push   $0x4a
  jmp alltraps
8010732c:	e9 f2 f6 ff ff       	jmp    80106a23 <alltraps>

80107331 <vector75>:
.globl vector75
vector75:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $75
80107333:	6a 4b                	push   $0x4b
  jmp alltraps
80107335:	e9 e9 f6 ff ff       	jmp    80106a23 <alltraps>

8010733a <vector76>:
.globl vector76
vector76:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $76
8010733c:	6a 4c                	push   $0x4c
  jmp alltraps
8010733e:	e9 e0 f6 ff ff       	jmp    80106a23 <alltraps>

80107343 <vector77>:
.globl vector77
vector77:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $77
80107345:	6a 4d                	push   $0x4d
  jmp alltraps
80107347:	e9 d7 f6 ff ff       	jmp    80106a23 <alltraps>

8010734c <vector78>:
.globl vector78
vector78:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $78
8010734e:	6a 4e                	push   $0x4e
  jmp alltraps
80107350:	e9 ce f6 ff ff       	jmp    80106a23 <alltraps>

80107355 <vector79>:
.globl vector79
vector79:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $79
80107357:	6a 4f                	push   $0x4f
  jmp alltraps
80107359:	e9 c5 f6 ff ff       	jmp    80106a23 <alltraps>

8010735e <vector80>:
.globl vector80
vector80:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $80
80107360:	6a 50                	push   $0x50
  jmp alltraps
80107362:	e9 bc f6 ff ff       	jmp    80106a23 <alltraps>

80107367 <vector81>:
.globl vector81
vector81:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $81
80107369:	6a 51                	push   $0x51
  jmp alltraps
8010736b:	e9 b3 f6 ff ff       	jmp    80106a23 <alltraps>

80107370 <vector82>:
.globl vector82
vector82:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $82
80107372:	6a 52                	push   $0x52
  jmp alltraps
80107374:	e9 aa f6 ff ff       	jmp    80106a23 <alltraps>

80107379 <vector83>:
.globl vector83
vector83:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $83
8010737b:	6a 53                	push   $0x53
  jmp alltraps
8010737d:	e9 a1 f6 ff ff       	jmp    80106a23 <alltraps>

80107382 <vector84>:
.globl vector84
vector84:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $84
80107384:	6a 54                	push   $0x54
  jmp alltraps
80107386:	e9 98 f6 ff ff       	jmp    80106a23 <alltraps>

8010738b <vector85>:
.globl vector85
vector85:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $85
8010738d:	6a 55                	push   $0x55
  jmp alltraps
8010738f:	e9 8f f6 ff ff       	jmp    80106a23 <alltraps>

80107394 <vector86>:
.globl vector86
vector86:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $86
80107396:	6a 56                	push   $0x56
  jmp alltraps
80107398:	e9 86 f6 ff ff       	jmp    80106a23 <alltraps>

8010739d <vector87>:
.globl vector87
vector87:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $87
8010739f:	6a 57                	push   $0x57
  jmp alltraps
801073a1:	e9 7d f6 ff ff       	jmp    80106a23 <alltraps>

801073a6 <vector88>:
.globl vector88
vector88:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $88
801073a8:	6a 58                	push   $0x58
  jmp alltraps
801073aa:	e9 74 f6 ff ff       	jmp    80106a23 <alltraps>

801073af <vector89>:
.globl vector89
vector89:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $89
801073b1:	6a 59                	push   $0x59
  jmp alltraps
801073b3:	e9 6b f6 ff ff       	jmp    80106a23 <alltraps>

801073b8 <vector90>:
.globl vector90
vector90:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $90
801073ba:	6a 5a                	push   $0x5a
  jmp alltraps
801073bc:	e9 62 f6 ff ff       	jmp    80106a23 <alltraps>

801073c1 <vector91>:
.globl vector91
vector91:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $91
801073c3:	6a 5b                	push   $0x5b
  jmp alltraps
801073c5:	e9 59 f6 ff ff       	jmp    80106a23 <alltraps>

801073ca <vector92>:
.globl vector92
vector92:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $92
801073cc:	6a 5c                	push   $0x5c
  jmp alltraps
801073ce:	e9 50 f6 ff ff       	jmp    80106a23 <alltraps>

801073d3 <vector93>:
.globl vector93
vector93:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $93
801073d5:	6a 5d                	push   $0x5d
  jmp alltraps
801073d7:	e9 47 f6 ff ff       	jmp    80106a23 <alltraps>

801073dc <vector94>:
.globl vector94
vector94:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $94
801073de:	6a 5e                	push   $0x5e
  jmp alltraps
801073e0:	e9 3e f6 ff ff       	jmp    80106a23 <alltraps>

801073e5 <vector95>:
.globl vector95
vector95:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $95
801073e7:	6a 5f                	push   $0x5f
  jmp alltraps
801073e9:	e9 35 f6 ff ff       	jmp    80106a23 <alltraps>

801073ee <vector96>:
.globl vector96
vector96:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $96
801073f0:	6a 60                	push   $0x60
  jmp alltraps
801073f2:	e9 2c f6 ff ff       	jmp    80106a23 <alltraps>

801073f7 <vector97>:
.globl vector97
vector97:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $97
801073f9:	6a 61                	push   $0x61
  jmp alltraps
801073fb:	e9 23 f6 ff ff       	jmp    80106a23 <alltraps>

80107400 <vector98>:
.globl vector98
vector98:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $98
80107402:	6a 62                	push   $0x62
  jmp alltraps
80107404:	e9 1a f6 ff ff       	jmp    80106a23 <alltraps>

80107409 <vector99>:
.globl vector99
vector99:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $99
8010740b:	6a 63                	push   $0x63
  jmp alltraps
8010740d:	e9 11 f6 ff ff       	jmp    80106a23 <alltraps>

80107412 <vector100>:
.globl vector100
vector100:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $100
80107414:	6a 64                	push   $0x64
  jmp alltraps
80107416:	e9 08 f6 ff ff       	jmp    80106a23 <alltraps>

8010741b <vector101>:
.globl vector101
vector101:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $101
8010741d:	6a 65                	push   $0x65
  jmp alltraps
8010741f:	e9 ff f5 ff ff       	jmp    80106a23 <alltraps>

80107424 <vector102>:
.globl vector102
vector102:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $102
80107426:	6a 66                	push   $0x66
  jmp alltraps
80107428:	e9 f6 f5 ff ff       	jmp    80106a23 <alltraps>

8010742d <vector103>:
.globl vector103
vector103:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $103
8010742f:	6a 67                	push   $0x67
  jmp alltraps
80107431:	e9 ed f5 ff ff       	jmp    80106a23 <alltraps>

80107436 <vector104>:
.globl vector104
vector104:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $104
80107438:	6a 68                	push   $0x68
  jmp alltraps
8010743a:	e9 e4 f5 ff ff       	jmp    80106a23 <alltraps>

8010743f <vector105>:
.globl vector105
vector105:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $105
80107441:	6a 69                	push   $0x69
  jmp alltraps
80107443:	e9 db f5 ff ff       	jmp    80106a23 <alltraps>

80107448 <vector106>:
.globl vector106
vector106:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $106
8010744a:	6a 6a                	push   $0x6a
  jmp alltraps
8010744c:	e9 d2 f5 ff ff       	jmp    80106a23 <alltraps>

80107451 <vector107>:
.globl vector107
vector107:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $107
80107453:	6a 6b                	push   $0x6b
  jmp alltraps
80107455:	e9 c9 f5 ff ff       	jmp    80106a23 <alltraps>

8010745a <vector108>:
.globl vector108
vector108:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $108
8010745c:	6a 6c                	push   $0x6c
  jmp alltraps
8010745e:	e9 c0 f5 ff ff       	jmp    80106a23 <alltraps>

80107463 <vector109>:
.globl vector109
vector109:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $109
80107465:	6a 6d                	push   $0x6d
  jmp alltraps
80107467:	e9 b7 f5 ff ff       	jmp    80106a23 <alltraps>

8010746c <vector110>:
.globl vector110
vector110:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $110
8010746e:	6a 6e                	push   $0x6e
  jmp alltraps
80107470:	e9 ae f5 ff ff       	jmp    80106a23 <alltraps>

80107475 <vector111>:
.globl vector111
vector111:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $111
80107477:	6a 6f                	push   $0x6f
  jmp alltraps
80107479:	e9 a5 f5 ff ff       	jmp    80106a23 <alltraps>

8010747e <vector112>:
.globl vector112
vector112:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $112
80107480:	6a 70                	push   $0x70
  jmp alltraps
80107482:	e9 9c f5 ff ff       	jmp    80106a23 <alltraps>

80107487 <vector113>:
.globl vector113
vector113:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $113
80107489:	6a 71                	push   $0x71
  jmp alltraps
8010748b:	e9 93 f5 ff ff       	jmp    80106a23 <alltraps>

80107490 <vector114>:
.globl vector114
vector114:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $114
80107492:	6a 72                	push   $0x72
  jmp alltraps
80107494:	e9 8a f5 ff ff       	jmp    80106a23 <alltraps>

80107499 <vector115>:
.globl vector115
vector115:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $115
8010749b:	6a 73                	push   $0x73
  jmp alltraps
8010749d:	e9 81 f5 ff ff       	jmp    80106a23 <alltraps>

801074a2 <vector116>:
.globl vector116
vector116:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $116
801074a4:	6a 74                	push   $0x74
  jmp alltraps
801074a6:	e9 78 f5 ff ff       	jmp    80106a23 <alltraps>

801074ab <vector117>:
.globl vector117
vector117:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $117
801074ad:	6a 75                	push   $0x75
  jmp alltraps
801074af:	e9 6f f5 ff ff       	jmp    80106a23 <alltraps>

801074b4 <vector118>:
.globl vector118
vector118:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $118
801074b6:	6a 76                	push   $0x76
  jmp alltraps
801074b8:	e9 66 f5 ff ff       	jmp    80106a23 <alltraps>

801074bd <vector119>:
.globl vector119
vector119:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $119
801074bf:	6a 77                	push   $0x77
  jmp alltraps
801074c1:	e9 5d f5 ff ff       	jmp    80106a23 <alltraps>

801074c6 <vector120>:
.globl vector120
vector120:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $120
801074c8:	6a 78                	push   $0x78
  jmp alltraps
801074ca:	e9 54 f5 ff ff       	jmp    80106a23 <alltraps>

801074cf <vector121>:
.globl vector121
vector121:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $121
801074d1:	6a 79                	push   $0x79
  jmp alltraps
801074d3:	e9 4b f5 ff ff       	jmp    80106a23 <alltraps>

801074d8 <vector122>:
.globl vector122
vector122:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $122
801074da:	6a 7a                	push   $0x7a
  jmp alltraps
801074dc:	e9 42 f5 ff ff       	jmp    80106a23 <alltraps>

801074e1 <vector123>:
.globl vector123
vector123:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $123
801074e3:	6a 7b                	push   $0x7b
  jmp alltraps
801074e5:	e9 39 f5 ff ff       	jmp    80106a23 <alltraps>

801074ea <vector124>:
.globl vector124
vector124:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $124
801074ec:	6a 7c                	push   $0x7c
  jmp alltraps
801074ee:	e9 30 f5 ff ff       	jmp    80106a23 <alltraps>

801074f3 <vector125>:
.globl vector125
vector125:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $125
801074f5:	6a 7d                	push   $0x7d
  jmp alltraps
801074f7:	e9 27 f5 ff ff       	jmp    80106a23 <alltraps>

801074fc <vector126>:
.globl vector126
vector126:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $126
801074fe:	6a 7e                	push   $0x7e
  jmp alltraps
80107500:	e9 1e f5 ff ff       	jmp    80106a23 <alltraps>

80107505 <vector127>:
.globl vector127
vector127:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $127
80107507:	6a 7f                	push   $0x7f
  jmp alltraps
80107509:	e9 15 f5 ff ff       	jmp    80106a23 <alltraps>

8010750e <vector128>:
.globl vector128
vector128:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $128
80107510:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107515:	e9 09 f5 ff ff       	jmp    80106a23 <alltraps>

8010751a <vector129>:
.globl vector129
vector129:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $129
8010751c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107521:	e9 fd f4 ff ff       	jmp    80106a23 <alltraps>

80107526 <vector130>:
.globl vector130
vector130:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $130
80107528:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010752d:	e9 f1 f4 ff ff       	jmp    80106a23 <alltraps>

80107532 <vector131>:
.globl vector131
vector131:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $131
80107534:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107539:	e9 e5 f4 ff ff       	jmp    80106a23 <alltraps>

8010753e <vector132>:
.globl vector132
vector132:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $132
80107540:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107545:	e9 d9 f4 ff ff       	jmp    80106a23 <alltraps>

8010754a <vector133>:
.globl vector133
vector133:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $133
8010754c:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107551:	e9 cd f4 ff ff       	jmp    80106a23 <alltraps>

80107556 <vector134>:
.globl vector134
vector134:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $134
80107558:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010755d:	e9 c1 f4 ff ff       	jmp    80106a23 <alltraps>

80107562 <vector135>:
.globl vector135
vector135:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $135
80107564:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107569:	e9 b5 f4 ff ff       	jmp    80106a23 <alltraps>

8010756e <vector136>:
.globl vector136
vector136:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $136
80107570:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107575:	e9 a9 f4 ff ff       	jmp    80106a23 <alltraps>

8010757a <vector137>:
.globl vector137
vector137:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $137
8010757c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107581:	e9 9d f4 ff ff       	jmp    80106a23 <alltraps>

80107586 <vector138>:
.globl vector138
vector138:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $138
80107588:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010758d:	e9 91 f4 ff ff       	jmp    80106a23 <alltraps>

80107592 <vector139>:
.globl vector139
vector139:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $139
80107594:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107599:	e9 85 f4 ff ff       	jmp    80106a23 <alltraps>

8010759e <vector140>:
.globl vector140
vector140:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $140
801075a0:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801075a5:	e9 79 f4 ff ff       	jmp    80106a23 <alltraps>

801075aa <vector141>:
.globl vector141
vector141:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $141
801075ac:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801075b1:	e9 6d f4 ff ff       	jmp    80106a23 <alltraps>

801075b6 <vector142>:
.globl vector142
vector142:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $142
801075b8:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801075bd:	e9 61 f4 ff ff       	jmp    80106a23 <alltraps>

801075c2 <vector143>:
.globl vector143
vector143:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $143
801075c4:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801075c9:	e9 55 f4 ff ff       	jmp    80106a23 <alltraps>

801075ce <vector144>:
.globl vector144
vector144:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $144
801075d0:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801075d5:	e9 49 f4 ff ff       	jmp    80106a23 <alltraps>

801075da <vector145>:
.globl vector145
vector145:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $145
801075dc:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801075e1:	e9 3d f4 ff ff       	jmp    80106a23 <alltraps>

801075e6 <vector146>:
.globl vector146
vector146:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $146
801075e8:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801075ed:	e9 31 f4 ff ff       	jmp    80106a23 <alltraps>

801075f2 <vector147>:
.globl vector147
vector147:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $147
801075f4:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801075f9:	e9 25 f4 ff ff       	jmp    80106a23 <alltraps>

801075fe <vector148>:
.globl vector148
vector148:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $148
80107600:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107605:	e9 19 f4 ff ff       	jmp    80106a23 <alltraps>

8010760a <vector149>:
.globl vector149
vector149:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $149
8010760c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107611:	e9 0d f4 ff ff       	jmp    80106a23 <alltraps>

80107616 <vector150>:
.globl vector150
vector150:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $150
80107618:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010761d:	e9 01 f4 ff ff       	jmp    80106a23 <alltraps>

80107622 <vector151>:
.globl vector151
vector151:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $151
80107624:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107629:	e9 f5 f3 ff ff       	jmp    80106a23 <alltraps>

8010762e <vector152>:
.globl vector152
vector152:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $152
80107630:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107635:	e9 e9 f3 ff ff       	jmp    80106a23 <alltraps>

8010763a <vector153>:
.globl vector153
vector153:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $153
8010763c:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107641:	e9 dd f3 ff ff       	jmp    80106a23 <alltraps>

80107646 <vector154>:
.globl vector154
vector154:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $154
80107648:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010764d:	e9 d1 f3 ff ff       	jmp    80106a23 <alltraps>

80107652 <vector155>:
.globl vector155
vector155:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $155
80107654:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107659:	e9 c5 f3 ff ff       	jmp    80106a23 <alltraps>

8010765e <vector156>:
.globl vector156
vector156:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $156
80107660:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107665:	e9 b9 f3 ff ff       	jmp    80106a23 <alltraps>

8010766a <vector157>:
.globl vector157
vector157:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $157
8010766c:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107671:	e9 ad f3 ff ff       	jmp    80106a23 <alltraps>

80107676 <vector158>:
.globl vector158
vector158:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $158
80107678:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010767d:	e9 a1 f3 ff ff       	jmp    80106a23 <alltraps>

80107682 <vector159>:
.globl vector159
vector159:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $159
80107684:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107689:	e9 95 f3 ff ff       	jmp    80106a23 <alltraps>

8010768e <vector160>:
.globl vector160
vector160:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $160
80107690:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107695:	e9 89 f3 ff ff       	jmp    80106a23 <alltraps>

8010769a <vector161>:
.globl vector161
vector161:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $161
8010769c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801076a1:	e9 7d f3 ff ff       	jmp    80106a23 <alltraps>

801076a6 <vector162>:
.globl vector162
vector162:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $162
801076a8:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801076ad:	e9 71 f3 ff ff       	jmp    80106a23 <alltraps>

801076b2 <vector163>:
.globl vector163
vector163:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $163
801076b4:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801076b9:	e9 65 f3 ff ff       	jmp    80106a23 <alltraps>

801076be <vector164>:
.globl vector164
vector164:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $164
801076c0:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801076c5:	e9 59 f3 ff ff       	jmp    80106a23 <alltraps>

801076ca <vector165>:
.globl vector165
vector165:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $165
801076cc:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801076d1:	e9 4d f3 ff ff       	jmp    80106a23 <alltraps>

801076d6 <vector166>:
.globl vector166
vector166:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $166
801076d8:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801076dd:	e9 41 f3 ff ff       	jmp    80106a23 <alltraps>

801076e2 <vector167>:
.globl vector167
vector167:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $167
801076e4:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801076e9:	e9 35 f3 ff ff       	jmp    80106a23 <alltraps>

801076ee <vector168>:
.globl vector168
vector168:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $168
801076f0:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801076f5:	e9 29 f3 ff ff       	jmp    80106a23 <alltraps>

801076fa <vector169>:
.globl vector169
vector169:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $169
801076fc:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107701:	e9 1d f3 ff ff       	jmp    80106a23 <alltraps>

80107706 <vector170>:
.globl vector170
vector170:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $170
80107708:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010770d:	e9 11 f3 ff ff       	jmp    80106a23 <alltraps>

80107712 <vector171>:
.globl vector171
vector171:
  pushl $0
80107712:	6a 00                	push   $0x0
  pushl $171
80107714:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107719:	e9 05 f3 ff ff       	jmp    80106a23 <alltraps>

8010771e <vector172>:
.globl vector172
vector172:
  pushl $0
8010771e:	6a 00                	push   $0x0
  pushl $172
80107720:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107725:	e9 f9 f2 ff ff       	jmp    80106a23 <alltraps>

8010772a <vector173>:
.globl vector173
vector173:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $173
8010772c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107731:	e9 ed f2 ff ff       	jmp    80106a23 <alltraps>

80107736 <vector174>:
.globl vector174
vector174:
  pushl $0
80107736:	6a 00                	push   $0x0
  pushl $174
80107738:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010773d:	e9 e1 f2 ff ff       	jmp    80106a23 <alltraps>

80107742 <vector175>:
.globl vector175
vector175:
  pushl $0
80107742:	6a 00                	push   $0x0
  pushl $175
80107744:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107749:	e9 d5 f2 ff ff       	jmp    80106a23 <alltraps>

8010774e <vector176>:
.globl vector176
vector176:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $176
80107750:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107755:	e9 c9 f2 ff ff       	jmp    80106a23 <alltraps>

8010775a <vector177>:
.globl vector177
vector177:
  pushl $0
8010775a:	6a 00                	push   $0x0
  pushl $177
8010775c:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107761:	e9 bd f2 ff ff       	jmp    80106a23 <alltraps>

80107766 <vector178>:
.globl vector178
vector178:
  pushl $0
80107766:	6a 00                	push   $0x0
  pushl $178
80107768:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010776d:	e9 b1 f2 ff ff       	jmp    80106a23 <alltraps>

80107772 <vector179>:
.globl vector179
vector179:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $179
80107774:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107779:	e9 a5 f2 ff ff       	jmp    80106a23 <alltraps>

8010777e <vector180>:
.globl vector180
vector180:
  pushl $0
8010777e:	6a 00                	push   $0x0
  pushl $180
80107780:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107785:	e9 99 f2 ff ff       	jmp    80106a23 <alltraps>

8010778a <vector181>:
.globl vector181
vector181:
  pushl $0
8010778a:	6a 00                	push   $0x0
  pushl $181
8010778c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107791:	e9 8d f2 ff ff       	jmp    80106a23 <alltraps>

80107796 <vector182>:
.globl vector182
vector182:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $182
80107798:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010779d:	e9 81 f2 ff ff       	jmp    80106a23 <alltraps>

801077a2 <vector183>:
.globl vector183
vector183:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $183
801077a4:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801077a9:	e9 75 f2 ff ff       	jmp    80106a23 <alltraps>

801077ae <vector184>:
.globl vector184
vector184:
  pushl $0
801077ae:	6a 00                	push   $0x0
  pushl $184
801077b0:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801077b5:	e9 69 f2 ff ff       	jmp    80106a23 <alltraps>

801077ba <vector185>:
.globl vector185
vector185:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $185
801077bc:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801077c1:	e9 5d f2 ff ff       	jmp    80106a23 <alltraps>

801077c6 <vector186>:
.globl vector186
vector186:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $186
801077c8:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801077cd:	e9 51 f2 ff ff       	jmp    80106a23 <alltraps>

801077d2 <vector187>:
.globl vector187
vector187:
  pushl $0
801077d2:	6a 00                	push   $0x0
  pushl $187
801077d4:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801077d9:	e9 45 f2 ff ff       	jmp    80106a23 <alltraps>

801077de <vector188>:
.globl vector188
vector188:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $188
801077e0:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801077e5:	e9 39 f2 ff ff       	jmp    80106a23 <alltraps>

801077ea <vector189>:
.globl vector189
vector189:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $189
801077ec:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801077f1:	e9 2d f2 ff ff       	jmp    80106a23 <alltraps>

801077f6 <vector190>:
.globl vector190
vector190:
  pushl $0
801077f6:	6a 00                	push   $0x0
  pushl $190
801077f8:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801077fd:	e9 21 f2 ff ff       	jmp    80106a23 <alltraps>

80107802 <vector191>:
.globl vector191
vector191:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $191
80107804:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107809:	e9 15 f2 ff ff       	jmp    80106a23 <alltraps>

8010780e <vector192>:
.globl vector192
vector192:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $192
80107810:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107815:	e9 09 f2 ff ff       	jmp    80106a23 <alltraps>

8010781a <vector193>:
.globl vector193
vector193:
  pushl $0
8010781a:	6a 00                	push   $0x0
  pushl $193
8010781c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107821:	e9 fd f1 ff ff       	jmp    80106a23 <alltraps>

80107826 <vector194>:
.globl vector194
vector194:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $194
80107828:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010782d:	e9 f1 f1 ff ff       	jmp    80106a23 <alltraps>

80107832 <vector195>:
.globl vector195
vector195:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $195
80107834:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107839:	e9 e5 f1 ff ff       	jmp    80106a23 <alltraps>

8010783e <vector196>:
.globl vector196
vector196:
  pushl $0
8010783e:	6a 00                	push   $0x0
  pushl $196
80107840:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107845:	e9 d9 f1 ff ff       	jmp    80106a23 <alltraps>

8010784a <vector197>:
.globl vector197
vector197:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $197
8010784c:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107851:	e9 cd f1 ff ff       	jmp    80106a23 <alltraps>

80107856 <vector198>:
.globl vector198
vector198:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $198
80107858:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010785d:	e9 c1 f1 ff ff       	jmp    80106a23 <alltraps>

80107862 <vector199>:
.globl vector199
vector199:
  pushl $0
80107862:	6a 00                	push   $0x0
  pushl $199
80107864:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107869:	e9 b5 f1 ff ff       	jmp    80106a23 <alltraps>

8010786e <vector200>:
.globl vector200
vector200:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $200
80107870:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107875:	e9 a9 f1 ff ff       	jmp    80106a23 <alltraps>

8010787a <vector201>:
.globl vector201
vector201:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $201
8010787c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107881:	e9 9d f1 ff ff       	jmp    80106a23 <alltraps>

80107886 <vector202>:
.globl vector202
vector202:
  pushl $0
80107886:	6a 00                	push   $0x0
  pushl $202
80107888:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010788d:	e9 91 f1 ff ff       	jmp    80106a23 <alltraps>

80107892 <vector203>:
.globl vector203
vector203:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $203
80107894:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107899:	e9 85 f1 ff ff       	jmp    80106a23 <alltraps>

8010789e <vector204>:
.globl vector204
vector204:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $204
801078a0:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801078a5:	e9 79 f1 ff ff       	jmp    80106a23 <alltraps>

801078aa <vector205>:
.globl vector205
vector205:
  pushl $0
801078aa:	6a 00                	push   $0x0
  pushl $205
801078ac:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801078b1:	e9 6d f1 ff ff       	jmp    80106a23 <alltraps>

801078b6 <vector206>:
.globl vector206
vector206:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $206
801078b8:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801078bd:	e9 61 f1 ff ff       	jmp    80106a23 <alltraps>

801078c2 <vector207>:
.globl vector207
vector207:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $207
801078c4:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801078c9:	e9 55 f1 ff ff       	jmp    80106a23 <alltraps>

801078ce <vector208>:
.globl vector208
vector208:
  pushl $0
801078ce:	6a 00                	push   $0x0
  pushl $208
801078d0:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801078d5:	e9 49 f1 ff ff       	jmp    80106a23 <alltraps>

801078da <vector209>:
.globl vector209
vector209:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $209
801078dc:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801078e1:	e9 3d f1 ff ff       	jmp    80106a23 <alltraps>

801078e6 <vector210>:
.globl vector210
vector210:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $210
801078e8:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801078ed:	e9 31 f1 ff ff       	jmp    80106a23 <alltraps>

801078f2 <vector211>:
.globl vector211
vector211:
  pushl $0
801078f2:	6a 00                	push   $0x0
  pushl $211
801078f4:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801078f9:	e9 25 f1 ff ff       	jmp    80106a23 <alltraps>

801078fe <vector212>:
.globl vector212
vector212:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $212
80107900:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107905:	e9 19 f1 ff ff       	jmp    80106a23 <alltraps>

8010790a <vector213>:
.globl vector213
vector213:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $213
8010790c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107911:	e9 0d f1 ff ff       	jmp    80106a23 <alltraps>

80107916 <vector214>:
.globl vector214
vector214:
  pushl $0
80107916:	6a 00                	push   $0x0
  pushl $214
80107918:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010791d:	e9 01 f1 ff ff       	jmp    80106a23 <alltraps>

80107922 <vector215>:
.globl vector215
vector215:
  pushl $0
80107922:	6a 00                	push   $0x0
  pushl $215
80107924:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107929:	e9 f5 f0 ff ff       	jmp    80106a23 <alltraps>

8010792e <vector216>:
.globl vector216
vector216:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $216
80107930:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107935:	e9 e9 f0 ff ff       	jmp    80106a23 <alltraps>

8010793a <vector217>:
.globl vector217
vector217:
  pushl $0
8010793a:	6a 00                	push   $0x0
  pushl $217
8010793c:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107941:	e9 dd f0 ff ff       	jmp    80106a23 <alltraps>

80107946 <vector218>:
.globl vector218
vector218:
  pushl $0
80107946:	6a 00                	push   $0x0
  pushl $218
80107948:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010794d:	e9 d1 f0 ff ff       	jmp    80106a23 <alltraps>

80107952 <vector219>:
.globl vector219
vector219:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $219
80107954:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107959:	e9 c5 f0 ff ff       	jmp    80106a23 <alltraps>

8010795e <vector220>:
.globl vector220
vector220:
  pushl $0
8010795e:	6a 00                	push   $0x0
  pushl $220
80107960:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107965:	e9 b9 f0 ff ff       	jmp    80106a23 <alltraps>

8010796a <vector221>:
.globl vector221
vector221:
  pushl $0
8010796a:	6a 00                	push   $0x0
  pushl $221
8010796c:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107971:	e9 ad f0 ff ff       	jmp    80106a23 <alltraps>

80107976 <vector222>:
.globl vector222
vector222:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $222
80107978:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010797d:	e9 a1 f0 ff ff       	jmp    80106a23 <alltraps>

80107982 <vector223>:
.globl vector223
vector223:
  pushl $0
80107982:	6a 00                	push   $0x0
  pushl $223
80107984:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107989:	e9 95 f0 ff ff       	jmp    80106a23 <alltraps>

8010798e <vector224>:
.globl vector224
vector224:
  pushl $0
8010798e:	6a 00                	push   $0x0
  pushl $224
80107990:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107995:	e9 89 f0 ff ff       	jmp    80106a23 <alltraps>

8010799a <vector225>:
.globl vector225
vector225:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $225
8010799c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801079a1:	e9 7d f0 ff ff       	jmp    80106a23 <alltraps>

801079a6 <vector226>:
.globl vector226
vector226:
  pushl $0
801079a6:	6a 00                	push   $0x0
  pushl $226
801079a8:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801079ad:	e9 71 f0 ff ff       	jmp    80106a23 <alltraps>

801079b2 <vector227>:
.globl vector227
vector227:
  pushl $0
801079b2:	6a 00                	push   $0x0
  pushl $227
801079b4:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801079b9:	e9 65 f0 ff ff       	jmp    80106a23 <alltraps>

801079be <vector228>:
.globl vector228
vector228:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $228
801079c0:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801079c5:	e9 59 f0 ff ff       	jmp    80106a23 <alltraps>

801079ca <vector229>:
.globl vector229
vector229:
  pushl $0
801079ca:	6a 00                	push   $0x0
  pushl $229
801079cc:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801079d1:	e9 4d f0 ff ff       	jmp    80106a23 <alltraps>

801079d6 <vector230>:
.globl vector230
vector230:
  pushl $0
801079d6:	6a 00                	push   $0x0
  pushl $230
801079d8:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801079dd:	e9 41 f0 ff ff       	jmp    80106a23 <alltraps>

801079e2 <vector231>:
.globl vector231
vector231:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $231
801079e4:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801079e9:	e9 35 f0 ff ff       	jmp    80106a23 <alltraps>

801079ee <vector232>:
.globl vector232
vector232:
  pushl $0
801079ee:	6a 00                	push   $0x0
  pushl $232
801079f0:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801079f5:	e9 29 f0 ff ff       	jmp    80106a23 <alltraps>

801079fa <vector233>:
.globl vector233
vector233:
  pushl $0
801079fa:	6a 00                	push   $0x0
  pushl $233
801079fc:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a01:	e9 1d f0 ff ff       	jmp    80106a23 <alltraps>

80107a06 <vector234>:
.globl vector234
vector234:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $234
80107a08:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a0d:	e9 11 f0 ff ff       	jmp    80106a23 <alltraps>

80107a12 <vector235>:
.globl vector235
vector235:
  pushl $0
80107a12:	6a 00                	push   $0x0
  pushl $235
80107a14:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a19:	e9 05 f0 ff ff       	jmp    80106a23 <alltraps>

80107a1e <vector236>:
.globl vector236
vector236:
  pushl $0
80107a1e:	6a 00                	push   $0x0
  pushl $236
80107a20:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a25:	e9 f9 ef ff ff       	jmp    80106a23 <alltraps>

80107a2a <vector237>:
.globl vector237
vector237:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $237
80107a2c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107a31:	e9 ed ef ff ff       	jmp    80106a23 <alltraps>

80107a36 <vector238>:
.globl vector238
vector238:
  pushl $0
80107a36:	6a 00                	push   $0x0
  pushl $238
80107a38:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107a3d:	e9 e1 ef ff ff       	jmp    80106a23 <alltraps>

80107a42 <vector239>:
.globl vector239
vector239:
  pushl $0
80107a42:	6a 00                	push   $0x0
  pushl $239
80107a44:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a49:	e9 d5 ef ff ff       	jmp    80106a23 <alltraps>

80107a4e <vector240>:
.globl vector240
vector240:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $240
80107a50:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107a55:	e9 c9 ef ff ff       	jmp    80106a23 <alltraps>

80107a5a <vector241>:
.globl vector241
vector241:
  pushl $0
80107a5a:	6a 00                	push   $0x0
  pushl $241
80107a5c:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107a61:	e9 bd ef ff ff       	jmp    80106a23 <alltraps>

80107a66 <vector242>:
.globl vector242
vector242:
  pushl $0
80107a66:	6a 00                	push   $0x0
  pushl $242
80107a68:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107a6d:	e9 b1 ef ff ff       	jmp    80106a23 <alltraps>

80107a72 <vector243>:
.globl vector243
vector243:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $243
80107a74:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107a79:	e9 a5 ef ff ff       	jmp    80106a23 <alltraps>

80107a7e <vector244>:
.globl vector244
vector244:
  pushl $0
80107a7e:	6a 00                	push   $0x0
  pushl $244
80107a80:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107a85:	e9 99 ef ff ff       	jmp    80106a23 <alltraps>

80107a8a <vector245>:
.globl vector245
vector245:
  pushl $0
80107a8a:	6a 00                	push   $0x0
  pushl $245
80107a8c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107a91:	e9 8d ef ff ff       	jmp    80106a23 <alltraps>

80107a96 <vector246>:
.globl vector246
vector246:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $246
80107a98:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107a9d:	e9 81 ef ff ff       	jmp    80106a23 <alltraps>

80107aa2 <vector247>:
.globl vector247
vector247:
  pushl $0
80107aa2:	6a 00                	push   $0x0
  pushl $247
80107aa4:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107aa9:	e9 75 ef ff ff       	jmp    80106a23 <alltraps>

80107aae <vector248>:
.globl vector248
vector248:
  pushl $0
80107aae:	6a 00                	push   $0x0
  pushl $248
80107ab0:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107ab5:	e9 69 ef ff ff       	jmp    80106a23 <alltraps>

80107aba <vector249>:
.globl vector249
vector249:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $249
80107abc:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107ac1:	e9 5d ef ff ff       	jmp    80106a23 <alltraps>

80107ac6 <vector250>:
.globl vector250
vector250:
  pushl $0
80107ac6:	6a 00                	push   $0x0
  pushl $250
80107ac8:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107acd:	e9 51 ef ff ff       	jmp    80106a23 <alltraps>

80107ad2 <vector251>:
.globl vector251
vector251:
  pushl $0
80107ad2:	6a 00                	push   $0x0
  pushl $251
80107ad4:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107ad9:	e9 45 ef ff ff       	jmp    80106a23 <alltraps>

80107ade <vector252>:
.globl vector252
vector252:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $252
80107ae0:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107ae5:	e9 39 ef ff ff       	jmp    80106a23 <alltraps>

80107aea <vector253>:
.globl vector253
vector253:
  pushl $0
80107aea:	6a 00                	push   $0x0
  pushl $253
80107aec:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107af1:	e9 2d ef ff ff       	jmp    80106a23 <alltraps>

80107af6 <vector254>:
.globl vector254
vector254:
  pushl $0
80107af6:	6a 00                	push   $0x0
  pushl $254
80107af8:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107afd:	e9 21 ef ff ff       	jmp    80106a23 <alltraps>

80107b02 <vector255>:
.globl vector255
vector255:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $255
80107b04:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b09:	e9 15 ef ff ff       	jmp    80106a23 <alltraps>

80107b0e <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107b0e:	55                   	push   %ebp
80107b0f:	89 e5                	mov    %esp,%ebp
80107b11:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b14:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b17:	83 e8 01             	sub    $0x1,%eax
80107b1a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80107b21:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b25:	8b 45 08             	mov    0x8(%ebp),%eax
80107b28:	c1 e8 10             	shr    $0x10,%eax
80107b2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107b2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b32:	0f 01 10             	lgdtl  (%eax)
}
80107b35:	c9                   	leave  
80107b36:	c3                   	ret    

80107b37 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107b37:	55                   	push   %ebp
80107b38:	89 e5                	mov    %esp,%ebp
80107b3a:	83 ec 04             	sub    $0x4,%esp
80107b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b40:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107b44:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b48:	0f 00 d8             	ltr    %ax
}
80107b4b:	c9                   	leave  
80107b4c:	c3                   	ret    

80107b4d <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107b4d:	55                   	push   %ebp
80107b4e:	89 e5                	mov    %esp,%ebp
80107b50:	83 ec 04             	sub    $0x4,%esp
80107b53:	8b 45 08             	mov    0x8(%ebp),%eax
80107b56:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107b5a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b5e:	8e e8                	mov    %eax,%gs
}
80107b60:	c9                   	leave  
80107b61:	c3                   	ret    

80107b62 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107b62:	55                   	push   %ebp
80107b63:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b65:	8b 45 08             	mov    0x8(%ebp),%eax
80107b68:	0f 22 d8             	mov    %eax,%cr3
}
80107b6b:	5d                   	pop    %ebp
80107b6c:	c3                   	ret    

80107b6d <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107b6d:	55                   	push   %ebp
80107b6e:	89 e5                	mov    %esp,%ebp
80107b70:	8b 45 08             	mov    0x8(%ebp),%eax
80107b73:	05 00 00 00 80       	add    $0x80000000,%eax
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    

80107b7a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107b7a:	55                   	push   %ebp
80107b7b:	89 e5                	mov    %esp,%ebp
80107b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b80:	05 00 00 00 80       	add    $0x80000000,%eax
80107b85:	5d                   	pop    %ebp
80107b86:	c3                   	ret    

80107b87 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107b87:	55                   	push   %ebp
80107b88:	89 e5                	mov    %esp,%ebp
80107b8a:	53                   	push   %ebx
80107b8b:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107b8e:	e8 a6 b3 ff ff       	call   80102f39 <cpunum>
80107b93:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107b99:	05 40 09 11 80       	add    $0x80110940,%eax
80107b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107bc1:	83 e2 f0             	and    $0xfffffff0,%edx
80107bc4:	83 ca 0a             	or     $0xa,%edx
80107bc7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107bd1:	83 ca 10             	or     $0x10,%edx
80107bd4:	88 50 7d             	mov    %dl,0x7d(%eax)
80107bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bda:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107bde:	83 e2 9f             	and    $0xffffff9f,%edx
80107be1:	88 50 7d             	mov    %dl,0x7d(%eax)
80107be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107beb:	83 ca 80             	or     $0xffffff80,%edx
80107bee:	88 50 7d             	mov    %dl,0x7d(%eax)
80107bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107bf8:	83 ca 0f             	or     $0xf,%edx
80107bfb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c01:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c05:	83 e2 ef             	and    $0xffffffef,%edx
80107c08:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c12:	83 e2 df             	and    $0xffffffdf,%edx
80107c15:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c1f:	83 ca 40             	or     $0x40,%edx
80107c22:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c28:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c2c:	83 ca 80             	or     $0xffffff80,%edx
80107c2f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c35:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107c43:	ff ff 
80107c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c48:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107c4f:	00 00 
80107c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c54:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c65:	83 e2 f0             	and    $0xfffffff0,%edx
80107c68:	83 ca 02             	or     $0x2,%edx
80107c6b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c74:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c7b:	83 ca 10             	or     $0x10,%edx
80107c7e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c87:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c8e:	83 e2 9f             	and    $0xffffff9f,%edx
80107c91:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ca1:	83 ca 80             	or     $0xffffff80,%edx
80107ca4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cb4:	83 ca 0f             	or     $0xf,%edx
80107cb7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cc7:	83 e2 ef             	and    $0xffffffef,%edx
80107cca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cda:	83 e2 df             	and    $0xffffffdf,%edx
80107cdd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ced:	83 ca 40             	or     $0x40,%edx
80107cf0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d00:	83 ca 80             	or     $0xffffff80,%edx
80107d03:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d16:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d1d:	ff ff 
80107d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d22:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107d29:	00 00 
80107d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d38:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d3f:	83 e2 f0             	and    $0xfffffff0,%edx
80107d42:	83 ca 0a             	or     $0xa,%edx
80107d45:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d55:	83 ca 10             	or     $0x10,%edx
80107d58:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d61:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d68:	83 ca 60             	or     $0x60,%edx
80107d6b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d74:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d7b:	83 ca 80             	or     $0xffffff80,%edx
80107d7e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d87:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d8e:	83 ca 0f             	or     $0xf,%edx
80107d91:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107da1:	83 e2 ef             	and    $0xffffffef,%edx
80107da4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dad:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107db4:	83 e2 df             	and    $0xffffffdf,%edx
80107db7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dc7:	83 ca 40             	or     $0x40,%edx
80107dca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dda:	83 ca 80             	or     $0xffffff80,%edx
80107ddd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de6:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107df7:	ff ff 
80107df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfc:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107e03:	00 00 
80107e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e08:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e12:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e19:	83 e2 f0             	and    $0xfffffff0,%edx
80107e1c:	83 ca 02             	or     $0x2,%edx
80107e1f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e2f:	83 ca 10             	or     $0x10,%edx
80107e32:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e42:	83 ca 60             	or     $0x60,%edx
80107e45:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e55:	83 ca 80             	or     $0xffffff80,%edx
80107e58:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e61:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e68:	83 ca 0f             	or     $0xf,%edx
80107e6b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e74:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e7b:	83 e2 ef             	and    $0xffffffef,%edx
80107e7e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e87:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e8e:	83 e2 df             	and    $0xffffffdf,%edx
80107e91:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ea1:	83 ca 40             	or     $0x40,%edx
80107ea4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ead:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107eb4:	83 ca 80             	or     $0xffffff80,%edx
80107eb7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec0:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eca:	05 b4 00 00 00       	add    $0xb4,%eax
80107ecf:	89 c3                	mov    %eax,%ebx
80107ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed4:	05 b4 00 00 00       	add    $0xb4,%eax
80107ed9:	c1 e8 10             	shr    $0x10,%eax
80107edc:	89 c1                	mov    %eax,%ecx
80107ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee1:	05 b4 00 00 00       	add    $0xb4,%eax
80107ee6:	c1 e8 18             	shr    $0x18,%eax
80107ee9:	89 c2                	mov    %eax,%edx
80107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eee:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107ef5:	00 00 
80107ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efa:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f04:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f14:	83 e1 f0             	and    $0xfffffff0,%ecx
80107f17:	83 c9 02             	or     $0x2,%ecx
80107f1a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f23:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f2a:	83 c9 10             	or     $0x10,%ecx
80107f2d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f36:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f3d:	83 e1 9f             	and    $0xffffff9f,%ecx
80107f40:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f49:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f50:	83 c9 80             	or     $0xffffff80,%ecx
80107f53:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f63:	83 e1 f0             	and    $0xfffffff0,%ecx
80107f66:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f76:	83 e1 ef             	and    $0xffffffef,%ecx
80107f79:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f82:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f89:	83 e1 df             	and    $0xffffffdf,%ecx
80107f8c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f95:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107f9c:	83 c9 40             	or     $0x40,%ecx
80107f9f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa8:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107faf:	83 c9 80             	or     $0xffffff80,%ecx
80107fb2:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbb:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	83 c0 70             	add    $0x70,%eax
80107fc7:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107fce:	00 
80107fcf:	89 04 24             	mov    %eax,(%esp)
80107fd2:	e8 37 fb ff ff       	call   80107b0e <lgdt>
  loadgs(SEG_KCPU << 3);
80107fd7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107fde:	e8 6a fb ff ff       	call   80107b4d <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe6:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107fec:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107ff3:	00 00 00 00 
}
80107ff7:	83 c4 24             	add    $0x24,%esp
80107ffa:	5b                   	pop    %ebx
80107ffb:	5d                   	pop    %ebp
80107ffc:	c3                   	ret    

80107ffd <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ffd:	55                   	push   %ebp
80107ffe:	89 e5                	mov    %esp,%ebp
80108000:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108003:	8b 45 0c             	mov    0xc(%ebp),%eax
80108006:	c1 e8 16             	shr    $0x16,%eax
80108009:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108010:	8b 45 08             	mov    0x8(%ebp),%eax
80108013:	01 d0                	add    %edx,%eax
80108015:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010801b:	8b 00                	mov    (%eax),%eax
8010801d:	83 e0 01             	and    $0x1,%eax
80108020:	85 c0                	test   %eax,%eax
80108022:	74 17                	je     8010803b <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108024:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108027:	8b 00                	mov    (%eax),%eax
80108029:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010802e:	89 04 24             	mov    %eax,(%esp)
80108031:	e8 44 fb ff ff       	call   80107b7a <p2v>
80108036:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108039:	eb 4b                	jmp    80108086 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010803b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010803f:	74 0e                	je     8010804f <walkpgdir+0x52>
80108041:	e8 94 aa ff ff       	call   80102ada <kalloc>
80108046:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010804d:	75 07                	jne    80108056 <walkpgdir+0x59>
      return 0;
8010804f:	b8 00 00 00 00       	mov    $0x0,%eax
80108054:	eb 47                	jmp    8010809d <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108056:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010805d:	00 
8010805e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108065:	00 
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	89 04 24             	mov    %eax,(%esp)
8010806c:	e8 ed d4 ff ff       	call   8010555e <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108074:	89 04 24             	mov    %eax,(%esp)
80108077:	e8 f1 fa ff ff       	call   80107b6d <v2p>
8010807c:	83 c8 07             	or     $0x7,%eax
8010807f:	89 c2                	mov    %eax,%edx
80108081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108084:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108086:	8b 45 0c             	mov    0xc(%ebp),%eax
80108089:	c1 e8 0c             	shr    $0xc,%eax
8010808c:	25 ff 03 00 00       	and    $0x3ff,%eax
80108091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809b:	01 d0                	add    %edx,%eax
}
8010809d:	c9                   	leave  
8010809e:	c3                   	ret    

8010809f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010809f:	55                   	push   %ebp
801080a0:	89 e5                	mov    %esp,%ebp
801080a2:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801080a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801080b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801080b3:	8b 45 10             	mov    0x10(%ebp),%eax
801080b6:	01 d0                	add    %edx,%eax
801080b8:	83 e8 01             	sub    $0x1,%eax
801080bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801080c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801080ca:	00 
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801080d2:	8b 45 08             	mov    0x8(%ebp),%eax
801080d5:	89 04 24             	mov    %eax,(%esp)
801080d8:	e8 20 ff ff ff       	call   80107ffd <walkpgdir>
801080dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080e4:	75 07                	jne    801080ed <mappages+0x4e>
      return -1;
801080e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080eb:	eb 48                	jmp    80108135 <mappages+0x96>
    if(*pte & PTE_P)
801080ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f0:	8b 00                	mov    (%eax),%eax
801080f2:	83 e0 01             	and    $0x1,%eax
801080f5:	85 c0                	test   %eax,%eax
801080f7:	74 0c                	je     80108105 <mappages+0x66>
      panic("remap");
801080f9:	c7 04 24 cc 8f 10 80 	movl   $0x80108fcc,(%esp)
80108100:	e8 35 84 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80108105:	8b 45 18             	mov    0x18(%ebp),%eax
80108108:	0b 45 14             	or     0x14(%ebp),%eax
8010810b:	83 c8 01             	or     $0x1,%eax
8010810e:	89 c2                	mov    %eax,%edx
80108110:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108113:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010811b:	75 08                	jne    80108125 <mappages+0x86>
      break;
8010811d:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010811e:	b8 00 00 00 00       	mov    $0x0,%eax
80108123:	eb 10                	jmp    80108135 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108125:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010812c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108133:	eb 8e                	jmp    801080c3 <mappages+0x24>
  return 0;
}
80108135:	c9                   	leave  
80108136:	c3                   	ret    

80108137 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108137:	55                   	push   %ebp
80108138:	89 e5                	mov    %esp,%ebp
8010813a:	53                   	push   %ebx
8010813b:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010813e:	e8 97 a9 ff ff       	call   80102ada <kalloc>
80108143:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108146:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010814a:	75 0a                	jne    80108156 <setupkvm+0x1f>
    return 0;
8010814c:	b8 00 00 00 00       	mov    $0x0,%eax
80108151:	e9 98 00 00 00       	jmp    801081ee <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108156:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010815d:	00 
8010815e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108165:	00 
80108166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108169:	89 04 24             	mov    %eax,(%esp)
8010816c:	e8 ed d3 ff ff       	call   8010555e <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108171:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108178:	e8 fd f9 ff ff       	call   80107b7a <p2v>
8010817d:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108182:	76 0c                	jbe    80108190 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108184:	c7 04 24 d2 8f 10 80 	movl   $0x80108fd2,(%esp)
8010818b:	e8 aa 83 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108190:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108197:	eb 49                	jmp    801081e2 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819c:	8b 48 0c             	mov    0xc(%eax),%ecx
8010819f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a2:	8b 50 04             	mov    0x4(%eax),%edx
801081a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a8:	8b 58 08             	mov    0x8(%eax),%ebx
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	8b 40 04             	mov    0x4(%eax),%eax
801081b1:	29 c3                	sub    %eax,%ebx
801081b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b6:	8b 00                	mov    (%eax),%eax
801081b8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801081bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
801081c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801081c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801081c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cb:	89 04 24             	mov    %eax,(%esp)
801081ce:	e8 cc fe ff ff       	call   8010809f <mappages>
801081d3:	85 c0                	test   %eax,%eax
801081d5:	79 07                	jns    801081de <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801081d7:	b8 00 00 00 00       	mov    $0x0,%eax
801081dc:	eb 10                	jmp    801081ee <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081de:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801081e2:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801081e9:	72 ae                	jb     80108199 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801081eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801081ee:	83 c4 34             	add    $0x34,%esp
801081f1:	5b                   	pop    %ebx
801081f2:	5d                   	pop    %ebp
801081f3:	c3                   	ret    

801081f4 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801081f4:	55                   	push   %ebp
801081f5:	89 e5                	mov    %esp,%ebp
801081f7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801081fa:	e8 38 ff ff ff       	call   80108137 <setupkvm>
801081ff:	a3 18 39 11 80       	mov    %eax,0x80113918
  switchkvm();
80108204:	e8 02 00 00 00       	call   8010820b <switchkvm>
}
80108209:	c9                   	leave  
8010820a:	c3                   	ret    

8010820b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010820b:	55                   	push   %ebp
8010820c:	89 e5                	mov    %esp,%ebp
8010820e:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108211:	a1 18 39 11 80       	mov    0x80113918,%eax
80108216:	89 04 24             	mov    %eax,(%esp)
80108219:	e8 4f f9 ff ff       	call   80107b6d <v2p>
8010821e:	89 04 24             	mov    %eax,(%esp)
80108221:	e8 3c f9 ff ff       	call   80107b62 <lcr3>
}
80108226:	c9                   	leave  
80108227:	c3                   	ret    

80108228 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108228:	55                   	push   %ebp
80108229:	89 e5                	mov    %esp,%ebp
8010822b:	53                   	push   %ebx
8010822c:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010822f:	e8 2a d2 ff ff       	call   8010545e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108234:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010823a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108241:	83 c2 08             	add    $0x8,%edx
80108244:	89 d3                	mov    %edx,%ebx
80108246:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010824d:	83 c2 08             	add    $0x8,%edx
80108250:	c1 ea 10             	shr    $0x10,%edx
80108253:	89 d1                	mov    %edx,%ecx
80108255:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010825c:	83 c2 08             	add    $0x8,%edx
8010825f:	c1 ea 18             	shr    $0x18,%edx
80108262:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108269:	67 00 
8010826b:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108272:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108278:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010827f:	83 e1 f0             	and    $0xfffffff0,%ecx
80108282:	83 c9 09             	or     $0x9,%ecx
80108285:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010828b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108292:	83 c9 10             	or     $0x10,%ecx
80108295:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010829b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801082a2:	83 e1 9f             	and    $0xffffff9f,%ecx
801082a5:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801082ab:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801082b2:	83 c9 80             	or     $0xffffff80,%ecx
801082b5:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801082bb:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801082c2:	83 e1 f0             	and    $0xfffffff0,%ecx
801082c5:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801082cb:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801082d2:	83 e1 ef             	and    $0xffffffef,%ecx
801082d5:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801082db:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801082e2:	83 e1 df             	and    $0xffffffdf,%ecx
801082e5:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801082eb:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801082f2:	83 c9 40             	or     $0x40,%ecx
801082f5:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801082fb:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108302:	83 e1 7f             	and    $0x7f,%ecx
80108305:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010830b:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108311:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108317:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010831e:	83 e2 ef             	and    $0xffffffef,%edx
80108321:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108327:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010832d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108333:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108339:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108340:	8b 52 08             	mov    0x8(%edx),%edx
80108343:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108349:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010834c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108353:	e8 df f7 ff ff       	call   80107b37 <ltr>
  if(p->pgdir == 0)
80108358:	8b 45 08             	mov    0x8(%ebp),%eax
8010835b:	8b 40 04             	mov    0x4(%eax),%eax
8010835e:	85 c0                	test   %eax,%eax
80108360:	75 0c                	jne    8010836e <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80108362:	c7 04 24 e3 8f 10 80 	movl   $0x80108fe3,(%esp)
80108369:	e8 cc 81 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010836e:	8b 45 08             	mov    0x8(%ebp),%eax
80108371:	8b 40 04             	mov    0x4(%eax),%eax
80108374:	89 04 24             	mov    %eax,(%esp)
80108377:	e8 f1 f7 ff ff       	call   80107b6d <v2p>
8010837c:	89 04 24             	mov    %eax,(%esp)
8010837f:	e8 de f7 ff ff       	call   80107b62 <lcr3>
  popcli();
80108384:	e8 19 d1 ff ff       	call   801054a2 <popcli>
}
80108389:	83 c4 14             	add    $0x14,%esp
8010838c:	5b                   	pop    %ebx
8010838d:	5d                   	pop    %ebp
8010838e:	c3                   	ret    

8010838f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010838f:	55                   	push   %ebp
80108390:	89 e5                	mov    %esp,%ebp
80108392:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108395:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010839c:	76 0c                	jbe    801083aa <inituvm+0x1b>
    panic("inituvm: more than a page");
8010839e:	c7 04 24 f7 8f 10 80 	movl   $0x80108ff7,(%esp)
801083a5:	e8 90 81 ff ff       	call   8010053a <panic>
  mem = kalloc();
801083aa:	e8 2b a7 ff ff       	call   80102ada <kalloc>
801083af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801083b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083b9:	00 
801083ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083c1:	00 
801083c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c5:	89 04 24             	mov    %eax,(%esp)
801083c8:	e8 91 d1 ff ff       	call   8010555e <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801083cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d0:	89 04 24             	mov    %eax,(%esp)
801083d3:	e8 95 f7 ff ff       	call   80107b6d <v2p>
801083d8:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801083df:	00 
801083e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
801083e4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083eb:	00 
801083ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083f3:	00 
801083f4:	8b 45 08             	mov    0x8(%ebp),%eax
801083f7:	89 04 24             	mov    %eax,(%esp)
801083fa:	e8 a0 fc ff ff       	call   8010809f <mappages>
  memmove(mem, init, sz);
801083ff:	8b 45 10             	mov    0x10(%ebp),%eax
80108402:	89 44 24 08          	mov    %eax,0x8(%esp)
80108406:	8b 45 0c             	mov    0xc(%ebp),%eax
80108409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010840d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108410:	89 04 24             	mov    %eax,(%esp)
80108413:	e8 15 d2 ff ff       	call   8010562d <memmove>
}
80108418:	c9                   	leave  
80108419:	c3                   	ret    

8010841a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010841a:	55                   	push   %ebp
8010841b:	89 e5                	mov    %esp,%ebp
8010841d:	53                   	push   %ebx
8010841e:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108421:	8b 45 0c             	mov    0xc(%ebp),%eax
80108424:	25 ff 0f 00 00       	and    $0xfff,%eax
80108429:	85 c0                	test   %eax,%eax
8010842b:	74 0c                	je     80108439 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010842d:	c7 04 24 14 90 10 80 	movl   $0x80109014,(%esp)
80108434:	e8 01 81 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108440:	e9 a9 00 00 00       	jmp    801084ee <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010844b:	01 d0                	add    %edx,%eax
8010844d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108454:	00 
80108455:	89 44 24 04          	mov    %eax,0x4(%esp)
80108459:	8b 45 08             	mov    0x8(%ebp),%eax
8010845c:	89 04 24             	mov    %eax,(%esp)
8010845f:	e8 99 fb ff ff       	call   80107ffd <walkpgdir>
80108464:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010846b:	75 0c                	jne    80108479 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010846d:	c7 04 24 37 90 10 80 	movl   $0x80109037,(%esp)
80108474:	e8 c1 80 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108479:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847c:	8b 00                	mov    (%eax),%eax
8010847e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108483:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108489:	8b 55 18             	mov    0x18(%ebp),%edx
8010848c:	29 c2                	sub    %eax,%edx
8010848e:	89 d0                	mov    %edx,%eax
80108490:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108495:	77 0f                	ja     801084a6 <loaduvm+0x8c>
      n = sz - i;
80108497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010849a:	8b 55 18             	mov    0x18(%ebp),%edx
8010849d:	29 c2                	sub    %eax,%edx
8010849f:	89 d0                	mov    %edx,%eax
801084a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084a4:	eb 07                	jmp    801084ad <loaduvm+0x93>
    else
      n = PGSIZE;
801084a6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801084ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b0:	8b 55 14             	mov    0x14(%ebp),%edx
801084b3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801084b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084b9:	89 04 24             	mov    %eax,(%esp)
801084bc:	e8 b9 f6 ff ff       	call   80107b7a <p2v>
801084c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801084c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
801084c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801084cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801084d0:	8b 45 10             	mov    0x10(%ebp),%eax
801084d3:	89 04 24             	mov    %eax,(%esp)
801084d6:	e8 85 98 ff ff       	call   80101d60 <readi>
801084db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084de:	74 07                	je     801084e7 <loaduvm+0xcd>
      return -1;
801084e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084e5:	eb 18                	jmp    801084ff <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801084e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f1:	3b 45 18             	cmp    0x18(%ebp),%eax
801084f4:	0f 82 4b ff ff ff    	jb     80108445 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801084fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084ff:	83 c4 24             	add    $0x24,%esp
80108502:	5b                   	pop    %ebx
80108503:	5d                   	pop    %ebp
80108504:	c3                   	ret    

80108505 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108505:	55                   	push   %ebp
80108506:	89 e5                	mov    %esp,%ebp
80108508:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010850b:	8b 45 10             	mov    0x10(%ebp),%eax
8010850e:	85 c0                	test   %eax,%eax
80108510:	79 0a                	jns    8010851c <allocuvm+0x17>
    return 0;
80108512:	b8 00 00 00 00       	mov    $0x0,%eax
80108517:	e9 c1 00 00 00       	jmp    801085dd <allocuvm+0xd8>
  if(newsz < oldsz)
8010851c:	8b 45 10             	mov    0x10(%ebp),%eax
8010851f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108522:	73 08                	jae    8010852c <allocuvm+0x27>
    return oldsz;
80108524:	8b 45 0c             	mov    0xc(%ebp),%eax
80108527:	e9 b1 00 00 00       	jmp    801085dd <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010852c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010852f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108534:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010853c:	e9 8d 00 00 00       	jmp    801085ce <allocuvm+0xc9>
    mem = kalloc();
80108541:	e8 94 a5 ff ff       	call   80102ada <kalloc>
80108546:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010854d:	75 2c                	jne    8010857b <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
8010854f:	c7 04 24 55 90 10 80 	movl   $0x80109055,(%esp)
80108556:	e8 45 7e ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010855b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010855e:	89 44 24 08          	mov    %eax,0x8(%esp)
80108562:	8b 45 10             	mov    0x10(%ebp),%eax
80108565:	89 44 24 04          	mov    %eax,0x4(%esp)
80108569:	8b 45 08             	mov    0x8(%ebp),%eax
8010856c:	89 04 24             	mov    %eax,(%esp)
8010856f:	e8 6b 00 00 00       	call   801085df <deallocuvm>
      return 0;
80108574:	b8 00 00 00 00       	mov    $0x0,%eax
80108579:	eb 62                	jmp    801085dd <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
8010857b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108582:	00 
80108583:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010858a:	00 
8010858b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010858e:	89 04 24             	mov    %eax,(%esp)
80108591:	e8 c8 cf ff ff       	call   8010555e <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108596:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108599:	89 04 24             	mov    %eax,(%esp)
8010859c:	e8 cc f5 ff ff       	call   80107b6d <v2p>
801085a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085a4:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801085ab:	00 
801085ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
801085b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085b7:	00 
801085b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801085bc:	8b 45 08             	mov    0x8(%ebp),%eax
801085bf:	89 04 24             	mov    %eax,(%esp)
801085c2:	e8 d8 fa ff ff       	call   8010809f <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801085c7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d1:	3b 45 10             	cmp    0x10(%ebp),%eax
801085d4:	0f 82 67 ff ff ff    	jb     80108541 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801085da:	8b 45 10             	mov    0x10(%ebp),%eax
}
801085dd:	c9                   	leave  
801085de:	c3                   	ret    

801085df <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801085df:	55                   	push   %ebp
801085e0:	89 e5                	mov    %esp,%ebp
801085e2:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801085e5:	8b 45 10             	mov    0x10(%ebp),%eax
801085e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085eb:	72 08                	jb     801085f5 <deallocuvm+0x16>
    return oldsz;
801085ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801085f0:	e9 a4 00 00 00       	jmp    80108699 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801085f5:	8b 45 10             	mov    0x10(%ebp),%eax
801085f8:	05 ff 0f 00 00       	add    $0xfff,%eax
801085fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108605:	e9 80 00 00 00       	jmp    8010868a <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010860a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108614:	00 
80108615:	89 44 24 04          	mov    %eax,0x4(%esp)
80108619:	8b 45 08             	mov    0x8(%ebp),%eax
8010861c:	89 04 24             	mov    %eax,(%esp)
8010861f:	e8 d9 f9 ff ff       	call   80107ffd <walkpgdir>
80108624:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010862b:	75 09                	jne    80108636 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010862d:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108634:	eb 4d                	jmp    80108683 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108639:	8b 00                	mov    (%eax),%eax
8010863b:	83 e0 01             	and    $0x1,%eax
8010863e:	85 c0                	test   %eax,%eax
80108640:	74 41                	je     80108683 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108645:	8b 00                	mov    (%eax),%eax
80108647:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010864c:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010864f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108653:	75 0c                	jne    80108661 <deallocuvm+0x82>
        panic("kfree");
80108655:	c7 04 24 6d 90 10 80 	movl   $0x8010906d,(%esp)
8010865c:	e8 d9 7e ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108661:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108664:	89 04 24             	mov    %eax,(%esp)
80108667:	e8 0e f5 ff ff       	call   80107b7a <p2v>
8010866c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010866f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108672:	89 04 24             	mov    %eax,(%esp)
80108675:	e8 c7 a3 ff ff       	call   80102a41 <kfree>
      *pte = 0;
8010867a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010867d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108683:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010868a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108690:	0f 82 74 ff ff ff    	jb     8010860a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108696:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108699:	c9                   	leave  
8010869a:	c3                   	ret    

8010869b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010869b:	55                   	push   %ebp
8010869c:	89 e5                	mov    %esp,%ebp
8010869e:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801086a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801086a5:	75 0c                	jne    801086b3 <freevm+0x18>
    panic("freevm: no pgdir");
801086a7:	c7 04 24 73 90 10 80 	movl   $0x80109073,(%esp)
801086ae:	e8 87 7e ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801086b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801086ba:	00 
801086bb:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801086c2:	80 
801086c3:	8b 45 08             	mov    0x8(%ebp),%eax
801086c6:	89 04 24             	mov    %eax,(%esp)
801086c9:	e8 11 ff ff ff       	call   801085df <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801086ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086d5:	eb 48                	jmp    8010871f <freevm+0x84>
    if(pgdir[i] & PTE_P){
801086d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086e1:	8b 45 08             	mov    0x8(%ebp),%eax
801086e4:	01 d0                	add    %edx,%eax
801086e6:	8b 00                	mov    (%eax),%eax
801086e8:	83 e0 01             	and    $0x1,%eax
801086eb:	85 c0                	test   %eax,%eax
801086ed:	74 2c                	je     8010871b <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801086ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086f9:	8b 45 08             	mov    0x8(%ebp),%eax
801086fc:	01 d0                	add    %edx,%eax
801086fe:	8b 00                	mov    (%eax),%eax
80108700:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108705:	89 04 24             	mov    %eax,(%esp)
80108708:	e8 6d f4 ff ff       	call   80107b7a <p2v>
8010870d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108713:	89 04 24             	mov    %eax,(%esp)
80108716:	e8 26 a3 ff ff       	call   80102a41 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010871b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010871f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108726:	76 af                	jbe    801086d7 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108728:	8b 45 08             	mov    0x8(%ebp),%eax
8010872b:	89 04 24             	mov    %eax,(%esp)
8010872e:	e8 0e a3 ff ff       	call   80102a41 <kfree>
}
80108733:	c9                   	leave  
80108734:	c3                   	ret    

80108735 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108735:	55                   	push   %ebp
80108736:	89 e5                	mov    %esp,%ebp
80108738:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010873b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108742:	00 
80108743:	8b 45 0c             	mov    0xc(%ebp),%eax
80108746:	89 44 24 04          	mov    %eax,0x4(%esp)
8010874a:	8b 45 08             	mov    0x8(%ebp),%eax
8010874d:	89 04 24             	mov    %eax,(%esp)
80108750:	e8 a8 f8 ff ff       	call   80107ffd <walkpgdir>
80108755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010875c:	75 0c                	jne    8010876a <clearpteu+0x35>
    panic("clearpteu");
8010875e:	c7 04 24 84 90 10 80 	movl   $0x80109084,(%esp)
80108765:	e8 d0 7d ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
8010876a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876d:	8b 00                	mov    (%eax),%eax
8010876f:	83 e0 fb             	and    $0xfffffffb,%eax
80108772:	89 c2                	mov    %eax,%edx
80108774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108777:	89 10                	mov    %edx,(%eax)
}
80108779:	c9                   	leave  
8010877a:	c3                   	ret    

8010877b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010877b:	55                   	push   %ebp
8010877c:	89 e5                	mov    %esp,%ebp
8010877e:	53                   	push   %ebx
8010877f:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108782:	e8 b0 f9 ff ff       	call   80108137 <setupkvm>
80108787:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010878a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010878e:	75 0a                	jne    8010879a <copyuvm+0x1f>
    return 0;
80108790:	b8 00 00 00 00       	mov    $0x0,%eax
80108795:	e9 fd 00 00 00       	jmp    80108897 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
8010879a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087a1:	e9 d0 00 00 00       	jmp    80108876 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801087a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087b0:	00 
801087b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b5:	8b 45 08             	mov    0x8(%ebp),%eax
801087b8:	89 04 24             	mov    %eax,(%esp)
801087bb:	e8 3d f8 ff ff       	call   80107ffd <walkpgdir>
801087c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087c7:	75 0c                	jne    801087d5 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801087c9:	c7 04 24 8e 90 10 80 	movl   $0x8010908e,(%esp)
801087d0:	e8 65 7d ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801087d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087d8:	8b 00                	mov    (%eax),%eax
801087da:	83 e0 01             	and    $0x1,%eax
801087dd:	85 c0                	test   %eax,%eax
801087df:	75 0c                	jne    801087ed <copyuvm+0x72>
      panic("copyuvm: page not present");
801087e1:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
801087e8:	e8 4d 7d ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801087ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087f0:	8b 00                	mov    (%eax),%eax
801087f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801087fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087fd:	8b 00                	mov    (%eax),%eax
801087ff:	25 ff 0f 00 00       	and    $0xfff,%eax
80108804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108807:	e8 ce a2 ff ff       	call   80102ada <kalloc>
8010880c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010880f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108813:	75 02                	jne    80108817 <copyuvm+0x9c>
      goto bad;
80108815:	eb 70                	jmp    80108887 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108817:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010881a:	89 04 24             	mov    %eax,(%esp)
8010881d:	e8 58 f3 ff ff       	call   80107b7a <p2v>
80108822:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108829:	00 
8010882a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010882e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108831:	89 04 24             	mov    %eax,(%esp)
80108834:	e8 f4 cd ff ff       	call   8010562d <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108839:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010883c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010883f:	89 04 24             	mov    %eax,(%esp)
80108842:	e8 26 f3 ff ff       	call   80107b6d <v2p>
80108847:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010884a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010884e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108852:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108859:	00 
8010885a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010885e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108861:	89 04 24             	mov    %eax,(%esp)
80108864:	e8 36 f8 ff ff       	call   8010809f <mappages>
80108869:	85 c0                	test   %eax,%eax
8010886b:	79 02                	jns    8010886f <copyuvm+0xf4>
      goto bad;
8010886d:	eb 18                	jmp    80108887 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010886f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108879:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010887c:	0f 82 24 ff ff ff    	jb     801087a6 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108885:	eb 10                	jmp    80108897 <copyuvm+0x11c>

bad:
  freevm(d);
80108887:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010888a:	89 04 24             	mov    %eax,(%esp)
8010888d:	e8 09 fe ff ff       	call   8010869b <freevm>
  return 0;
80108892:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108897:	83 c4 44             	add    $0x44,%esp
8010889a:	5b                   	pop    %ebx
8010889b:	5d                   	pop    %ebp
8010889c:	c3                   	ret    

8010889d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010889d:	55                   	push   %ebp
8010889e:	89 e5                	mov    %esp,%ebp
801088a0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801088a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088aa:	00 
801088ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801088ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801088b2:	8b 45 08             	mov    0x8(%ebp),%eax
801088b5:	89 04 24             	mov    %eax,(%esp)
801088b8:	e8 40 f7 ff ff       	call   80107ffd <walkpgdir>
801088bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801088c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c3:	8b 00                	mov    (%eax),%eax
801088c5:	83 e0 01             	and    $0x1,%eax
801088c8:	85 c0                	test   %eax,%eax
801088ca:	75 07                	jne    801088d3 <uva2ka+0x36>
    return 0;
801088cc:	b8 00 00 00 00       	mov    $0x0,%eax
801088d1:	eb 25                	jmp    801088f8 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801088d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d6:	8b 00                	mov    (%eax),%eax
801088d8:	83 e0 04             	and    $0x4,%eax
801088db:	85 c0                	test   %eax,%eax
801088dd:	75 07                	jne    801088e6 <uva2ka+0x49>
    return 0;
801088df:	b8 00 00 00 00       	mov    $0x0,%eax
801088e4:	eb 12                	jmp    801088f8 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801088e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e9:	8b 00                	mov    (%eax),%eax
801088eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088f0:	89 04 24             	mov    %eax,(%esp)
801088f3:	e8 82 f2 ff ff       	call   80107b7a <p2v>
}
801088f8:	c9                   	leave  
801088f9:	c3                   	ret    

801088fa <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801088fa:	55                   	push   %ebp
801088fb:	89 e5                	mov    %esp,%ebp
801088fd:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108900:	8b 45 10             	mov    0x10(%ebp),%eax
80108903:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108906:	e9 87 00 00 00       	jmp    80108992 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010890b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010890e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108913:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108916:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108919:	89 44 24 04          	mov    %eax,0x4(%esp)
8010891d:	8b 45 08             	mov    0x8(%ebp),%eax
80108920:	89 04 24             	mov    %eax,(%esp)
80108923:	e8 75 ff ff ff       	call   8010889d <uva2ka>
80108928:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010892b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010892f:	75 07                	jne    80108938 <copyout+0x3e>
      return -1;
80108931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108936:	eb 69                	jmp    801089a1 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108938:	8b 45 0c             	mov    0xc(%ebp),%eax
8010893b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010893e:	29 c2                	sub    %eax,%edx
80108940:	89 d0                	mov    %edx,%eax
80108942:	05 00 10 00 00       	add    $0x1000,%eax
80108947:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010894a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010894d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108950:	76 06                	jbe    80108958 <copyout+0x5e>
      n = len;
80108952:	8b 45 14             	mov    0x14(%ebp),%eax
80108955:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108958:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010895b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010895e:	29 c2                	sub    %eax,%edx
80108960:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108963:	01 c2                	add    %eax,%edx
80108965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108968:	89 44 24 08          	mov    %eax,0x8(%esp)
8010896c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108973:	89 14 24             	mov    %edx,(%esp)
80108976:	e8 b2 cc ff ff       	call   8010562d <memmove>
    len -= n;
8010897b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010897e:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108984:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108987:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010898a:	05 00 10 00 00       	add    $0x1000,%eax
8010898f:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108992:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108996:	0f 85 6f ff ff ff    	jne    8010890b <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010899c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089a1:	c9                   	leave  
801089a2:	c3                   	ret    
